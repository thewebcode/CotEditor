/*
 
 CEConsolePanelController.m
 
 CotEditor
 http://coteditor.com
 
 Created by 1024jp on 2014-03-12.

 ------------------------------------------------------------------------------
 
 © 2014-2016 1024jp
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 
 */

#import "CEConsolePanelController.h"


const CGFloat kFontSize = 11;


@interface CEConsolePanelController ()

@property (nonatomic, nonnull, copy) NSParagraphStyle *messageParagraphStyle;
@property (nonatomic, nonnull) NSDateFormatter *dateFormatter;

@property (nonatomic, nullable, strong) IBOutlet NSTextView *textView;  // on 10.8 NSTextView cannot be weak
@property (nonatomic, nullable) IBOutlet NSTextFinder *textFinder;

@end




#pragma mark -

@implementation CEConsolePanelController

#pragma mark Superclass Mthods

// ------------------------------------------------------
/// initializer of panelController
- (nonnull instancetype)init
// ------------------------------------------------------
{
    self = [super init];
    if (self) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"YYYY-MM-DD HH:MM:SS"];
        
        // indent for message body
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [paragraphStyle setHeadIndent:kFontSize];
        [paragraphStyle setFirstLineHeadIndent:kFontSize];
        _messageParagraphStyle = [paragraphStyle copy];
    }
    return self;
}


// ------------------------------------------------------
/// nib name
- (nullable NSString *)windowNibName
// ------------------------------------------------------
{
    return @"ConsolePanel";
}


// ------------------------------------------------------
/// setup UI
- (void)windowDidLoad
// ------------------------------------------------------
{
    [super windowDidLoad];
    
    [[self textView] setFont:[NSFont messageFontOfSize:kFontSize]];
    [[self textView] setTextContainerInset:NSMakeSize(0.0, 4.0)];

}



#pragma mark Public Methods

// ------------------------------------------------------
/// append given message to the console
- (void)appendMessage:(nonnull NSString *)message title:(NSString *)title  // TODO: check nullability for `title`
// ------------------------------------------------------
{
    NSString *date = [[self dateFormatter] stringFromDate:[NSDate date]];
    NSString *string = [NSString stringWithFormat:@"[%@] %@\n%@\n", date, title, message];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    
    // bold title
    [attrString applyFontTraits:NSBoldFontMask range:NSMakeRange([date length] + 3, [title length])];
    
    // apply message paragraph style to body
    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:[self messageParagraphStyle]
                       range:NSMakeRange([attrString length] - [message length] - 1, [message length])];
    
    [[[self textView] textStorage] appendAttributedString:attrString];
}



#pragma mark Action Messages

// ------------------------------------------------------
/// flush console
- (IBAction)cleanConsole:(nullable id)sender
// ------------------------------------------------------
{
    [[self textView] setString:@""];
}

@end




/// Map find actions to NSTextFinder, since find action key bindings are configured for CETextFinder.
@implementation CEConsolePanelController (TextFinderSupport)

#pragma mark Action Messages

// ------------------------------------------------------
/// bridge find action to NSTextFinder
- (IBAction)showFindPanel:(nullable id)sender
// ------------------------------------------------------
{
    [[self textFinder] performAction:NSTextFinderActionShowFindInterface];
}


// ------------------------------------------------------
/// bridge find action to NSTextFinder
- (IBAction)findNext:(nullable id)sender
// ------------------------------------------------------
{
    [[self textFinder] performAction:NSTextFinderActionNextMatch];
}


// ------------------------------------------------------
/// bridge find action to NSTextFinder
- (IBAction)findPrevious:(nullable id)sender
// ------------------------------------------------------
{
    [[self textFinder] performAction:NSTextFinderActionPreviousMatch];
}


// ------------------------------------------------------
/// bridge find action to NSTextFinder
- (IBAction)useSelectionForFind:(nullable id)sender
// ------------------------------------------------------
{
    [[self textFinder] performAction:NSTextFinderActionSetSearchString];
}

@end
