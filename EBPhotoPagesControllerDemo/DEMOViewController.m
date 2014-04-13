//
//  EBViewController.m
//  EBPhotoPageViewControllerDemo
//
//  Created by Eddy Borja.
//  Copyright (c) 2014 Eddy Borja. All rights reserved.
//
/*
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "DEMOViewController.h"
#import "DEMOComment.h"
#import "DEMOPhoto.h"
#import "DEMOTag.h"
#import <QuartzCore/QuartzCore.h>
#import "EBPhotoPagesController.h"
#import "EBPhotoPagesFactory.h"
#import "EBTagPopover.h"


@interface DEMOViewController ()

@end

@implementation DEMOViewController

- (void)downloadPhoto{
    
    NSURL *url = [NSURL URLWithString:@"https://pbs.twimg.com/profile_images/454688604304846848/-FR4Xh2Z.jpeg"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    
    [data writeToFile:[@"~/Documents/sample.jpeg" stringByExpandingTildeInPath] atomically:YES];
    
    [self performSelectorOnMainThread:@selector(photoDownloaded) withObject:nil waitUntilDone:NO];
}

- (void)photoDownloaded{
    [self setPhotos:@[
                      [DEMOPhoto photoWithProperties:
                       @{@"imageName": @"sample.jpeg",
                         @"caption": @"A Dungeon crawler!",
                         
                         }],
                      ]];

}
- (void)loadView
{
    [super loadView];
    
    [self setSimulateLatency:NO];
    
    [self performSelectorInBackground:@selector(downloadPhoto) withObject:nil];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didSelectViewPhotos:(id)sender
{    
    EBPhotoPagesController *photoPagesController = [[EBPhotoPagesController alloc] initWithDataSource:self delegate:self];
    [self presentViewController:photoPagesController animated:YES completion:nil];
}


- (IBAction)didToggleLatency:(id)sender
{
    UISwitch *toggle = sender;
    
    [self setSimulateLatency:toggle.on];
}


#pragma mark - EBPhotoPagesDataSource

- (BOOL)photoPagesController:(EBPhotoPagesController *)photoPagesController
    shouldExpectPhotoAtIndex:(NSInteger)index
{
    if(index < self.photos.count){
        return YES;
    }
    
    return NO;
}

- (void)photoPagesController:(EBPhotoPagesController *)controller
                imageAtIndex:(NSInteger)index
           completionHandler:(void (^)(UIImage *))handler
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        DEMOPhoto *photo = self.photos[index];
        if(self.simulateLatency){
            sleep(arc4random_uniform(2)+arc4random_uniform(2));
        }
        
        handler(photo.image);
    });
}


- (void)photoPagesController:(EBPhotoPagesController *)controller
            attributedCaptionForPhotoAtIndex:(NSInteger)index
                           completionHandler:(void (^)(NSAttributedString *))handler
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        DEMOPhoto *photo = self.photos[index];
        if(self.simulateLatency){
            sleep(arc4random_uniform(2)+arc4random_uniform(2));
        }
        
        handler(photo.attributedCaption);
    });
}

- (void)photoPagesController:(EBPhotoPagesController *)controller
            captionForPhotoAtIndex:(NSInteger)index
                 completionHandler:(void (^)(NSString *))handler
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        DEMOPhoto *photo = self.photos[index];
        if(self.simulateLatency){
            sleep(arc4random_uniform(2)+arc4random_uniform(2));
        }
        
        handler(photo.caption);
    });
}


- (void)photoPagesController:(EBPhotoPagesController *)controller
     metaDataForPhotoAtIndex:(NSInteger)index
           completionHandler:(void (^)(NSDictionary *))handler
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        DEMOPhoto *photo = self.photos[index];
        if(self.simulateLatency){
            sleep(arc4random_uniform(2)+arc4random_uniform(2));
        }
        
        handler(photo.metaData);
    });
}

- (void)photoPagesController:(EBPhotoPagesController *)controller
         tagsForPhotoAtIndex:(NSInteger)index
           completionHandler:(void (^)(NSArray *))handler
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        DEMOPhoto *photo = self.photos[index];
        if(self.simulateLatency){
            sleep(arc4random_uniform(2)+arc4random_uniform(2));
        }
        
        handler(photo.tags);
    });
}


- (void)photoPagesController:(EBPhotoPagesController *)controller
     commentsForPhotoAtIndex:(NSInteger)index
           completionHandler:(void (^)(NSArray *))handler
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        DEMOPhoto *photo = self.photos[index];
        if(self.simulateLatency){
            sleep(arc4random_uniform(2)+arc4random_uniform(2));
        }
        
        handler(photo.comments);
    });
}


- (void)photoPagesController:(EBPhotoPagesController *)controller
  numberOfcommentsForPhotoAtIndex:(NSInteger)index
                completionHandler:(void (^)(NSInteger))handler
{
    DEMOPhoto *photo = self.photos[index];
    if(self.simulateLatency){
        sleep(arc4random_uniform(2)+arc4random_uniform(2));
    }
    
    handler(photo.comments.count);
}


- (void)photoPagesController:(EBPhotoPagesController *)photoPagesController
       didReportPhotoAtIndex:(NSInteger)index
{
    NSLog(@"Reported photo at index %li", (long)index);
    //Do something about this image someone reported.
}



- (void)photoPagesController:(EBPhotoPagesController *)controller
            didDeleteComment:(id<EBPhotoCommentProtocol>)deletedComment
             forPhotoAtIndex:(NSInteger)index
{
    DEMOPhoto *photo = self.photos[index];
    NSMutableArray *remainingComments = [NSMutableArray arrayWithArray:photo.comments];
    [remainingComments removeObject:deletedComment];
    [photo setComments:[NSArray arrayWithArray:remainingComments]];
}


- (void)photoPagesController:(EBPhotoPagesController *)controller
         didDeleteTagPopover:(EBTagPopover *)tagPopover
              inPhotoAtIndex:(NSInteger)index
{
    DEMOPhoto *photo = self.photos[index];
    NSMutableArray *remainingTags = [NSMutableArray arrayWithArray:photo.tags];
    id<EBPhotoTagProtocol> tagData = [tagPopover dataSource];
    [remainingTags removeObject:tagData];
    [photo setTags:[NSArray arrayWithArray:remainingTags]];
}

- (void)photoPagesController:(EBPhotoPagesController *)photoPagesController
       didDeletePhotoAtIndex:(NSInteger)index
{
    NSLog(@"Delete photo at index %li", (long)index);
    DEMOPhoto *deletedPhoto = self.photos[index];
    NSMutableArray *remainingPhotos = [NSMutableArray arrayWithArray:self.photos];
    [remainingPhotos removeObject:deletedPhoto];
    [self setPhotos:remainingPhotos];
}

- (void)photoPagesController:(EBPhotoPagesController *)photoPagesController
         didAddNewTagAtPoint:(CGPoint)tagLocation
                    withText:(NSString *)tagText
             forPhotoAtIndex:(NSInteger)index
                     tagInfo:(NSDictionary *)tagInfo
{
    NSLog(@"add new tag %@", tagText);
    
    DEMOPhoto *photo = self.photos[index];
    
    DEMOTag *newTag = [DEMOTag tagWithProperties:@{
                                                   @"tagPosition" : [NSValue valueWithCGPoint:tagLocation],
                                                   @"tagText" : tagText}];
    
    NSMutableArray *mutableTags = [NSMutableArray arrayWithArray:photo.tags];
    [mutableTags addObject:newTag];
    
    [photo setTags:[NSArray arrayWithArray:mutableTags]];
    
}


- (void)photoPagesController:(EBPhotoPagesController *)controller
              didPostComment:(NSString *)comment
             forPhotoAtIndex:(NSInteger)index
{
    DEMOComment *newComment = [DEMOComment
                               commentWithProperties:@{@"commentText": comment,
                                                       @"commentDate": [NSDate date],
                                                       @"authorImage": [UIImage imageNamed:@"guestAv.png"],
                                                       @"authorName" : @"Guest User"}];
    [newComment setUserCreated:YES];
    
    DEMOPhoto *photo = self.photos[index];
    [photo addComment:newComment];
    
    [controller setComments:photo.comments forPhotoAtIndex:index];
}



#pragma mark - User Permissions

- (BOOL)photoPagesController:(EBPhotoPagesController *)photoPagesController shouldAllowTaggingForPhotoAtIndex:(NSInteger)index
{
    if(!self.photos.count){
        return NO;
    }
    
    DEMOPhoto *photo = (DEMOPhoto *)self.photos[index];
    if(photo.disabledTagging){
        return NO;
    }
    
    return YES;
}

- (BOOL)photoPagesController:(EBPhotoPagesController *)controller
            shouldAllowDeleteForComment:(id<EBPhotoCommentProtocol>)comment
             forPhotoAtIndex:(NSInteger)index
{
    //We assume all comment objects used in the demo are of type DEMOComment
    DEMOComment *demoComment = (DEMOComment *)comment;
    
    if(demoComment.isUserCreated){
        //Demo user can only delete his or her own comments.
        return YES;
    }
    
    return NO;
}


- (BOOL)photoPagesController:(EBPhotoPagesController *)photoPagesController shouldAllowCommentingForPhotoAtIndex:(NSInteger)index
{
    if(!self.photos.count){
        return NO;
    }
    
    DEMOPhoto *photo = (DEMOPhoto *)self.photos[index];
    if(photo.disabledCommenting){
        return NO;
    } else {
        return YES;
    }
}


- (BOOL)photoPagesController:(EBPhotoPagesController *)photoPagesController shouldAllowActivitiesForPhotoAtIndex:(NSInteger)index
{
    if(!self.photos.count){
        return NO;
    }
    
    DEMOPhoto *photo = (DEMOPhoto *)self.photos[index];
    if(photo.disabledActivities){
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)photoPagesController:(EBPhotoPagesController *)photoPagesController shouldAllowDeleteForPhotoAtIndex:(NSInteger)index
{
    if(!self.photos.count){
        return NO;
    }
    
    DEMOPhoto *photo = (DEMOPhoto *)self.photos[index];
    if(photo.disabledDelete){
        return NO;
    } else {
        return YES;
    }
}





- (BOOL)photoPagesController:(EBPhotoPagesController *)photoPagesController
     shouldAllowDeleteForTag:(EBTagPopover *)tagPopover
              inPhotoAtIndex:(NSInteger)index
{
    if(!self.photos.count){
        return NO;
    }
    
    DEMOPhoto *photo = (DEMOPhoto *)self.photos[index];
    if(photo.disabledDeleteForTags){
        return NO;
    }
    
    return YES;
}




- (BOOL)photoPagesController:(EBPhotoPagesController *)photoPagesController
    shouldAllowEditingForTag:(EBTagPopover *)tagPopover
              inPhotoAtIndex:(NSInteger)index
{
    if(!self.photos.count){
        return NO;
    }
    
    if(index > 0){
        return YES;
    }
    
    return NO;
}


- (BOOL)photoPagesController:(EBPhotoPagesController *)photoPagesController shouldAllowReportForPhotoAtIndex:(NSInteger)index
{
    return YES;
}


#pragma mark - EBPPhotoPagesDelegate


- (void)photoPagesControllerDidDismiss:(EBPhotoPagesController *)photoPagesController
{
    NSLog(@"Finished using %@", photoPagesController);
}



@end
