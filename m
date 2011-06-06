Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab1FFX0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 19:26:22 -0400
Received: from mail001.aei.ca ([206.123.6.130]:49539 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968Ab1FFX0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 19:26:20 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Chase Douglas <chase.douglas@canonical.com>
Subject: Re: Linux 2.6.39.1
Date: Mon, 6 Jun 2011 19:26:13 -0400
User-Agent: KMail/1.13.7 (Linux/2.6.39.1-crc+; KDE/4.6.3; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20110603003835.GA20381@kroah.com> <201106032236.41294.edt@aei.ca> <4DED20C6.1020701@canonical.com>
In-Reply-To: <4DED20C6.1020701@canonical.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106061926.14661.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 June 2011 14:47:34 Chase Douglas wrote:
> On 06/03/2011 07:36 PM, Ed Tomlinson wrote:
> > On Thursday 02 June 2011 20:38:35 you wrote:
> >> I'm announcing the release of the 2.6.39.1 kernel.
> >>
> >> All users of the 2.6.39 kernel series must upgrade.
> >>
> >> The updated 2.6.39.y git tree can be found at:
> >>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.39.y.git
> >> and can be browsed at the normal kernel.org git web browser:
> >>         http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.39.y.git;a=summary
> >>
> > 
> > Greg,
> > 
> > Just updated to 39.1 and it breaks my magicmouse
> > 
> > [  107.360715] input: Apple Wireless Mouse as /devices/pci0000:00/0000:00:13.2/usb2/2-4/2-4.4/2-4.4:1.0/bluetooth/hci0/hci0:21/input8
> > [  107.376797] magicmouse 0005:05AC:030D.0005: input,hidraw3: BLUETOOTH HID v0.84 Mouse [Apple Wireless Mouse] on 00:02:72:20:20:1D
> > [  107.423387] magicmouse 0005:05AC:030D.0005: unable to request touch data (2)
> > [  107.451216] magicmouse: probe of 0005:05AC:030D.0005 failed with error 2
> > 
> > and the magicmouse is dead.
> > 
> > reverting 23746a66d7d9e73402c68ef00d708796b97ebd72
> > 
> > makes it work as before.
> 
> Hi Ed,
> > 
> Thanks!
> 
> -- Chase
> 
> 
> We pushed this commit to fix the regression you reported where the mouse
> failed to work in 2.6.39. With the commit, the mouse should be working
> properly.

Chase,

The patch that fixed .39 here was

(From: Ville Tervo <ville.tervo@nokia.com>)

I also played a bit with 1.1 CSR dongle and couldn't find any mask that would
be accepted. I think this command can be left out for older than 1.2 devices.

Following patch should do it. Could you verify it. I don't have access to old
hw ATM.

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 19cd4af..86d1e26 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -477,14 +477,16 @@ static void hci_setup_event_mask(struct hci_dev *hdev)
         * command otherwise */
        u8 events[8] = { 0xff, 0xff, 0xfb, 0xff, 0x00, 0x00, 0x00, 0x00 };
 
-       /* Events for 1.2 and newer controllers */
-       if (hdev->lmp_ver > 1) {
-               events[4] |= 0x01; /* Flow Specification Complete */
-               events[4] |= 0x02; /* Inquiry Result with RSSI */
-               events[4] |= 0x04; /* Read Remote Extended Features Complete */
-               events[5] |= 0x08; /* Synchronous Connection Complete */
-               events[5] |= 0x10; /* Synchronous Connection Changed */
-       }
+       /* CSR 1.1 dongles does not accept any bitfield so don't try to set
+        * any event mask for pre 1.2 devices */
+       if (hdev->lmp_ver <= 1)
+               return;
+
+       events[4] |= 0x01; /* Flow Specification Complete */
+       events[4] |= 0x02; /* Inquiry Result with RSSI */
+       events[4] |= 0x04; /* Read Remote Extended Features Complete */
+       events[5] |= 0x08; /* Synchronous Connection Complete */
+       events[5] |= 0x10; /* Synchronous Connection Changed */
 
        if (hdev->features[3] & LMP_RSSI_INQ)
                events[4] |= 0x04; /* Inquiry Result with RSSI */
-- 

> Now you are reporting that the mouse fails to work with the commit, but
> does work without the commit. This is perplexing :). I'm also not sure
> what you mean by:

The bug referenced in the commit below is: https://bugzilla.kernel.org/show_bug.cgi?id=35022
which was not mine and does show up with the id below in my 39.1 tree...

> "reverting 23746a66d7d9e73402c68ef00d708796b97ebd72 makes it work as before"

Bottom line.  I tested the correct kernels and the fix for 35022 breaks things here.

Thanks,
Ed


