Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829Ab2AQAOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 19:14:12 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44966 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab2AQAOK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 19:14:10 -0500
MIME-Version: 1.0
Date: Mon, 16 Jan 2012 18:14:09 -0600
Message-ID: <CAJbtUMGDUixS1h7Ct+TmkK+-9r3TPZaa54QkRvh8fNpm5CwjTA@mail.gmail.com>
Subject: Re: [PATCH 3.2.0] cp210x: Bug fix for CP2104 baudrate usage, Bugzilla #42586
From: Preston Fick <pffick@gmail.com>
To: greg@kroah.com, preston.fick@silabs.com
Cc: linux-usb-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Preston Fick <preston.fick@silabs.com>

This is an updated patch for the cp210x.ko driver with regards to the
following bug report:
CP2104 Device doesn't respond to baudrate change request Bug Report:
#42586 in bugzilla.kernel.org:
https://bugzilla.kernel.org/show_bug.cgi?id=42586

OS/Kernel version: GNU/Linux 3.2.0 (Mainline)

Description:
This fix changes the way baudrates are set on the CP210x devices from
Silicon Labs. The CP2101/2/3 will respond to both a GET/SET_BAUDDIV
command, and GET/SET_BAUDRATE command, while CP2104 and higher devices
only respond to GET/SET_BAUDRATE. The current cp210x.ko driver in
kernel version 3.2.0 only implements the GET/SET_BAUDDIV command.

This patch implements the two new codes for the GET/SET_BAUDRATE
commands. Then there is a change in the way that the baudrate is
assigned or retrieved. This is done according to the CP210x USB
specification in AN571. This document can be found here:
http://www.silabs.com/pages/DownloadDoc.aspx?FILEURL=Support%20Documents/TechnicalDocs/AN571.pdf&src=DocumentationWebPart

Sections 5.3/5.4 describe the USB packets for the old baudrate method.
Sections 5.5/5.6 describe the USB packets for the new method. This
patch also implements the new request scheme, and eliminates the
unnecessary baudrate calculations since it uses the "actual baudrate"
method.

This patch solves the problem reported for the CP2104 in bug 42586,
and also keeps support for all other devices (CP2101/2/3).

This patchfile is also attached to the bug report on
bugzilla.kernel.org. This patch has been developed and test on the
3.2.0 mainline kernel version under Ubuntu 10.11.

Signed-off-by: Preston Fick <preston.fick@silabs.com>

---

Hi Greg -

Here is the updated patchfile, and I have put in comments on your
questions inline. I'm obviously new to this, but hope to learn the
process to be able to help with the maintenance of this driver.

Begin corrected patchfile text:

diff -uNr linux.vanilla/linux-3.2/drivers/usb/serial/cp210x.c
linux.new/linux-3.2/drivers/usb/serial/cp210x.c
--- linux.vanilla/linux-3.2/drivers/usb/serial/cp210x.c	2012-01-04
17:55:44.000000000 -0600
+++ linux.new/linux-3.2/drivers/usb/serial/cp210x.c	2012-01-16
17:01:31.586410065 -0600
@@ -200,6 +200,8 @@
 #define CP210X_EMBED_EVENTS	0x15
 #define CP210X_GET_EVENTSTATE	0x16
 #define CP210X_SET_CHARS	0x19
+#define CP210X_GET_BAUDRATE	0x1D
+#define CP210X_SET_BAUDRATE	0x1E

 /* CP210X_IFC_ENABLE */
 #define UART_ENABLE		0x0001
@@ -459,10 +461,7 @@

 	dbg("%s - port %d", __func__, port->number);

-	cp210x_get_config(port, CP210X_GET_BAUDDIV, &baud, 2);
-	/* Convert to baudrate */
-	if (baud)
-		baud = cp210x_quantise_baudrate((BAUD_RATE_GEN_FREQ + baud/2)/ baud);
+	cp210x_get_config(port, CP210X_GET_BAUDRATE, &baud, 4);

 	dbg("%s - baud rate = %d", __func__, baud);
 	*baudp = baud;
@@ -597,8 +596,7 @@
 	if (baud != tty_termios_baud_rate(old_termios) && baud != 0) {
 		dbg("%s - Setting baud rate to %d baud", __func__,
 				baud);
-		if (cp210x_set_config_single(port, CP210X_SET_BAUDDIV,
-					((BAUD_RATE_GEN_FREQ + baud/2) / baud))) {
+		if (cp210x_set_config(port, CP210X_SET_BAUDRATE, &baud, 4)) {
 			dbg("Baud rate requested not supported by device");
 			baud = tty_termios_baud_rate(old_termios);
 		}

On Mon, Jan 16, 2012 at 5:21 PM, Preston Fick <Preston.Fick@silabs.com> wrote:
>
>
> -----Original Message-----
> From: greg@kroah.com [mailto:greg@kroah.com]
> Sent: Monday, January 16, 2012 11:42 AM
> To: Preston Fick
> Cc: linux-usb-devel@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 3.2.0] cp210x: Bug fix for CP2104 baudrate usage, Bugzilla #42586
>
> On Sun, Jan 15, 2012 at 09:51:56PM -0600, Preston Fick wrote:
>> From: Preston Fick <preston.fick@silabs.com>
>>
>> This is a patch for the cp210x.ko driver with regards to the following bug report:
>> CP2104 Device doesn't respond to baudrate change request
>> Bug Report: #42586 in bugzilla.kernel.org: https://bugzilla.kernel.org/show_bug.cgi?id=42586
>>
>> OS/Kernel version: GNU/Linux 3.2.0 (Mainline)
>>
>> Description:
>> This fix changes the way baudrates are set on the CP210x devices from Silicon Labs. The CP2101/2/3 will respond to both a GET/SET_BAUDDIV command, and GET/SET_BAUDRATE command, while CP2104 and higher devices only respond to GET/SET_BAUDRATE. The current cp210x.ko driver in kernel version 3.2.0 only implements the GET/SET_BAUDDIV command.
>>
>> This patch implements the two new codes for the GET/SET_BAUDRATE commands. Then there is a change in the way that the baudrate is assigned or retrieved. This is done according to the CP210x USB specification in AN571. This document can be found here: http://www.silabs.com/pages/DownloadDoc.aspx?FILEURL=Support%20Documents/TechnicalDocs/AN571.pdf&src=DocumentationWebPart
>>
>> Sections 5.3/5.4 describe the USB packets for the old baudrate method. Sections 5.5/5.6 describe the USB packets for the new method. This patch also implements the new request scheme, and eliminates the unnecessary baudrate calculations since it uses the "actual baudrate" method.
>>
>> This patch solves the problem reported for the CP2104 in bug 42586, and also keeps support for all other devices (CP2101/2/3).
>>
>> This patchfile is also attached to the bug report on bugzilla.kernel.org. This patch has been developed and test on the 3.2.0 mainline kernel version under Ubuntu 10.11.
>>
>> Signed-off-by: Preston Fick <preston.fick@silabs.com>
>>
>> ---
>>
>> Thank you for the consideration of this patch.
>>
>> Kind Regards -
>> Preston Fick
>>
>> Begin patchfile text:
>>
>> diff -uNr linux.vanilla/linux-3.2/drivers/usb/serial/cp210x.c linux.new/linux-3.2/drivers/usb/serial/cp210x.c
>> --- linux.vanilla/linux-3.2/drivers/usb/serial/cp210x.c       2012-01-04 17:55:44.000000000 -0600
>> +++ linux.new/linux-3.2/drivers/usb/serial/cp210x.c   2012-01-13 11:35:44.031334039 -0600
>> @@ -200,6 +200,8 @@
>>  #define CP210X_EMBED_EVENTS  0x15
>>  #define CP210X_GET_EVENTSTATE        0x16
>>  #define CP210X_SET_CHARS     0x19
>> +#define CP210X_GET_BAUDRATE  0x1D
>> +#define CP210X_SET_BAUDRATE  0x1E
>>
>>  /* CP210X_IFC_ENABLE */
>>  #define UART_ENABLE          0x0001
>> @@ -459,10 +461,7 @@
>>
>>       dbg("%s - port %d", __func__, port->number);
>>
>> -     cp210x_get_config(port, CP210X_GET_BAUDDIV, &baud, 2);
>> -     /* Convert to baudrate */
>> -     if (baud)
>> -             baud = cp210x_quantise_baudrate((BAUD_RATE_GEN_FREQ + baud/2)/ baud);
>> +     cp210x_get_config(port, CP210X_GET_BAUDDIV, &baud, 4);
>
> Shouldn't this be CP210X_GET_BAUDRATE ?

Yes - you are correct. I think I spent so much time trying to get bug
report and patch submitted properly I missed this when I diff'd my two
kernels. The corrected patch has been resubmitted at the top of this
email.

>
>>
>>       dbg("%s - baud rate = %d", __func__, baud);
>>       *baudp = baud;
>> @@ -597,8 +596,7 @@
>>       if (baud != tty_termios_baud_rate(old_termios) && baud != 0) {
>>               dbg("%s - Setting baud rate to %d baud", __func__,
>>                               baud);
>> -             if (cp210x_set_config_single(port, CP210X_SET_BAUDDIV,
>> -                                     ((BAUD_RATE_GEN_FREQ + baud/2) / baud))) {
>> +             if (cp210x_set_config(port, CP210X_SET_BAUDRATE, &baud, 4)) {
>>                       dbg("Baud rate requested not supported by device");
>>                       baud = tty_termios_baud_rate(old_termios);
>>               }
>
> With a footer like this, that directly contridicts the Signed-off-by:
> line, which do I believe?  As such, I can't accept patches with this
> type of footer, please fix your email client and try again.

Unfortunately the Silabs email is always tagged with this by the
server. I am changing over to another address which that doesn't
include this verbage. I've removed the verbage from this email to
prevent any issues.

>
> Also, how do the other patches sent to this list to solve the problem of
> this device look to you?  Do you think yours should be applied instead
> of them?

Here are two that were posted recently, I didn't find any matches at
the time of development - I've included comments on the latest two:

Andreas <andreas@...> (2012-01-13 09:20:52 GMT)
Re: Kernel patch for driver/usb/serial/cp210x.c
- This patch only implements the SET_BAUDRATE, and is missing the
GET_BAUDRATE functionality
- This patch relies on the device string to be "CP2104 USB to UART
Bridge Controller", which could change on customized devices so it
will not work in all cases
*Conclusion: My patch is better than this one, but I only know this
because I've worked on the Windows and Mac drivers as well and
understand that all devices support the SET/GET_BAUDRATE commands
making it cleaner and simpler, and works in all cases for all devices

Johan Hovold <jhovold@...> (2012-01-15 23:36:49 GMT)
[PATCH 3/7] USB: cp210x: use direct baud-rate commands
- This patch is almost line for line what I have re-submitted above
*Conclusion: Since this is the same as mine either could be used

The main reason I'd like my patch applied is to get involved in the
process of helping to maintain this driver. I'm trying to adhere
closely to the patch and reporting standards with an easy fix like
this so I can understand the process and add more fixes and features
in the future.

>
> thanks,
>
> greg k-h

Kind Regards -
Preston
