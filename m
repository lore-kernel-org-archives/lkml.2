Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965828Ab2EOCwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:52:41 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53376 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965091Ab2EOCRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:16 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 094/179] USB: don't let errors prevent system sleep
Date: Mon, 14 May 2012 22:13:10 -0400
Message-ID: <1337048075-6132-95-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/core/driver.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index 212b5e82..f045f19 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -1183,13 +1183,22 @@ static int usb_suspend_both(struct usb_device *udev, pm_message_t msg)
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
-- 
1.7.9.6

