Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab1GIGBO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 02:01:14 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:45687 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753868Ab1GIGBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 02:01:07 -0400
X-Sasl-enc: 54KnpTpaagZWQeut0I/x8CJnU3Jc5GDAprMTukKwwrDv 1310191266
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Jul  8 16:01:11 2011
Message-Id: <20110708230111.616399245@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 08 Jul 2011 16:00:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [21/35] USB: dont let errors prevent system sleep
In-Reply-To: <20110708230122.GA18807@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 0af212ba8f123c2eba151af7726c34a50b127962 upstream.

This patch (as1464) implements the recommended policy that most errors
during suspend or hibernation should not prevent the system from going
to sleep.  In particular, failure to suspend a USB driver or a USB
device should not prevent the sleep from succeeding:

Failure to suspend a device won't matter, because the device will
automatically go into suspend mode when the USB bus stops carrying
packets.  (This might be less true for USB-3.0 devices, but let's not
worry about them now.)

Failure of a driver to suspend might lead to trouble later on when the
system wakes up, but it isn't sufficient reason to prevent the system
from going to sleep.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/driver.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -1267,13 +1267,22 @@ static int usb_suspend_both(struct usb_d
 		for (; i < udev->actconfig->desc.bNumInterfaces; i++) {
 			intf = udev->actconfig->interface[i];
 			status = usb_suspend_interface(udev, intf, msg);
+
+			/* Ignore errors during system sleep transitions */
+			if (!(msg.event & PM_EVENT_AUTO))
+				status = 0;
 			if (status != 0)
 				break;
 		}
 	}
-	if (status == 0)
+	if (status == 0) {
 		status = usb_suspend_device(udev, msg);
 
+		/* Again, ignore errors during system sleep transitions */
+		if (!(msg.event & PM_EVENT_AUTO))
+			status = 0;
+	}
+
 	/* If the suspend failed, resume interfaces that did get suspended */
 	if (status != 0) {
 		pm_message_t msg2;


