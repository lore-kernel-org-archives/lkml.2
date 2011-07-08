Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab1GHFH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:07:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42584 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755385Ab1GHFFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:05:52 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:17:02 2011
Message-Id: <20110708001702.242890321@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:17:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [098/107] USB: dont let errors prevent system sleep
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

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
@@ -1187,13 +1187,22 @@ static int usb_suspend_both(struct usb_d
 		for (i = n - 1; i >= 0; --i) {
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
 		msg.event ^= (PM_EVENT_SUSPEND | PM_EVENT_RESUME);


