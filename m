Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab0IOVbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 17:31:06 -0400
Received: from core.signal11.us ([64.251.29.136]:36932 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409Ab0IOVbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 17:31:04 -0400
Message-ID: <4C913B1B.4070702@signal11.us>
Date: Wed, 15 Sep 2010 17:31:07 -0400
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100528 Thunderbird/3.0.5
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jiri Kosina <jkosina@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        Marcel Holtmann <marcel@holtmann.org>, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        simon@mungewell.org, Antonio Ospite <ospite@studenti.unina.it>
Subject: Re: [PATCH 1/1] Don't Send Feature Reports on Interrupt Endpoint
References: <Pine.LNX.4.44L0.1009151203030.1796-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1009151203030.1796-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Sep 15 17:31:03 2010
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4c913b1715281079919573
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2010 12:10 PM, Alan Stern wrote:
> On Wed, 15 Sep 2010, Alan Ott wrote:
>
>    
>> Feature reports should only be sent on the control endpoint.
>>      
> Where is this requirement?  Section 5.6 of the HID spec says:
>
> 	Note  Only Input reports are sent via the Interrupt In pipe.
> 	Feature and Output reports must be initiated by the host via
> 	the Control pipe or an optional Interrupt Out pipe.
>
> So if there is an Interrupt-OUT endpoint, it should be valid to use it
> for a Feature report.
>
> Alan Stern
>    

That is true, the standard does say that. Thanks for checking my work.

I expected to go into the HID standard and find something that would 
back me up. All I ended up finding was contradictions. I know I had seen 
it somewhere (that Feature reports must use the Control endpoint), and 
eventually I remembered that I had read it in Jan Axelson's USB 
Complete, 3rd Edition[1]. I sent her an email asking what she based it 
on, and I cited parts of the HID standard which I thought to be either 
unspecific, or even seemed to indicate the opposite of what she asserts 
in her book (one good example of which is the one you cited). I have not 
heard back from her yet (but she does indeed answer her email, so I 
expect something in a day or two).

In addition to the section you cited, there's also section 6.2.2.5 which 
says, at the very end of the section, on page 32:

    Output type reports can optionally be sent via an Interrupt Out pipe.
    While similar in function, Output and Feature items differ in the
    following
    ways:
         [snip]
       Like Output items, Feature items make up Feature Reports
    accessible via the Control
       pipe with the Get_Report (Feature) and Set_Report (Feature) requests.

That section seems to say both ways, depending on how you read "Output 
type" (ie: does it mean OUTPUT reports or does it mean "reports which go 
out from the host"). Note that particular section is the only place 
where the wording "input type" or "output type" is used, indicating it 
may mean "reports which go out from the host."

The second part of that quote says feature reports are accessible 
through the control pipe. (It doesn't say that they _aren't_ accessible 
any other way). It's curious to me why it would say it in that way, 
without saying "only accessible" or "also accessible."

In all, although somewhat unclear, the HID document does seem to suggest 
that the Interrupt OUT pipe can handle Feature Reports. However, there 
are several things which make me think otherwise.

1. The Windows implementation will refuse to send feature reports 
through WriteFile() (which is the function used to send reports out the 
interrupt OUT pipe if it exists). The HidD_SetFeature() function will 
ONLY send feature reports out the Control pipe, regardless of the 
presence of an Interrupt OUT endpoint.

2. The Macintosh HID implementation does the same thing as the Windows 
version. On the Mac, there's IOHIDDeviceSetReport() which allows you to 
specify a report type of Feature or Output. Output reports go to the 
Interrupt OUT pipe if it exists; feature reports do not. Feature reports 
only go out the Control endpoint.

3. Jan Axelson's book. While it's not an official standard, it's widely 
accepted as a good general reference on USB. Like I said, I have an 
email in to the author asking her to cite her source on Feature Reports. 
That said, the book is very Windows-centric on the host side, and she 
may be basing her assertion on #1 above.

4. Simon (Mungewell)'s email which started this whole thing. First, he 
indicates that his device doesn't handle Feature reports in the 
Interrupt OUT pipe. Second, he asserts that libhid works the same way 
Windows and Mac do, sending Feature reports out the Control pipe[2]. I 
have a PS3 controller that I borrowed which also seems to work the same 
way (ie: Feature reports don't work if they go out the Interrupt OUT 
endpoint).

5. The Bluetooth HID specification says in multiple places that "Feature 
Reports must be carried on the Control channel." Yes yes, you don't have 
to say it. Bluetooth is not USB, so the bluetooth standard shouldn't 
apply. Maybe true.

So there it is. That's everything I know about this particular problem. 
The standard to me is unclear at best; Every single other 
implementation[3] (Windows, Mac, libhid) uses the control endpoint only; 
Jan's book says that only the control endpoint can be used; Simon's 
hardware only works using the control endpoint for feature reports; my 
hardware only works using the control endpoint for Feature reports; the 
Bluetooth spec says Feature reports must use the control endpoint.

PS: I'll throw out one more thing. HID transfers which use the control 
endpoint have their report type identified in the wValue field of their 
header. Transfers which use the Interrupt OUT endpoint do not have their 
type identified in any way. (they only have the report ID, and even 
then, only when numbered reports are used). If a device which did not 
use report IDs had both a single OUTPUT and a single FEATURE report, how 
could the reports be differentiated by the device if it were possible 
for the FEATURE report to go out on the OUT endpoint? I think that 
actually closes the argument in my mind.

I'd be happy to hear alternate theories.

Alan.


[1] Fourth edition is out. I don't have it. Can anyone here confirm or 
deny that the 4th edition has similar language?
[2] I've confirmed this at:
      
http://libhid.alioth.debian.org/doc/hid__exchange_8c-source.html#l00191
[3] I'm not counting my own hidapi library 
(http://www.signal11.us/oss/hidapi), since it was written by me and is 
of course implemented the way I'm arguing for.


