Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965833Ab2EOCwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:52:25 -0400
Received: from mail.windriver.com ([147.11.1.11]:49637 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964871Ab2EOCRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:17 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 095/179] USB: don't let the hub driver prevent system sleep
Date: Mon, 14 May 2012 22:13:11 -0400
Message-ID: <1337048075-6132-96-git-send-email-paul.gortmaker@windriver.com>
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

commit cbb330045e5df8f665ac60227ff898421fc8fb92 upstream.

This patch (as1465) continues implementation of the policy that errors
during suspend or hibernation should not prevent the system from going
to sleep.

In this case, failure to turn on the Suspend feature for a hub port
shouldn't be reported as an error.  There are situations where this
does actually occur (such as when the device plugged into that port
was disconnected in the recent past), and it turns out to be harmless.
There's no reason for it to prevent a system sleep.

Also, don't allow the hub driver to fail a system suspend if the
downstream ports aren't all suspended.  This is also harmless (and
should never happen, given the change mentioned above); printing a
warning message in the kernel log is all we really need to do.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/core/hub.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 642fc7e..40815d0 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2222,6 +2222,10 @@ int usb_port_suspend(struct usb_device *udev, pm_message_t msg)
 				USB_DEVICE_REMOTE_WAKEUP, 0,
 				NULL, 0,
 				USB_CTRL_SET_TIMEOUT);
+
+		/* System sleep transitions should never fail */
+		if (!(msg.event & PM_EVENT_AUTO))
+			status = 0;
 	} else {
 		/* device has up to 10 msec to fully suspend */
 		dev_dbg(&udev->dev, "usb %ssuspend\n",
@@ -2459,16 +2463,15 @@ static int hub_suspend(struct usb_interface *intf, pm_message_t msg)
 	struct usb_device	*hdev = hub->hdev;
 	unsigned		port1;
 
-	/* fail if children aren't already suspended */
+	/* Warn if children aren't already suspended */
 	for (port1 = 1; port1 <= hdev->maxchild; port1++) {
 		struct usb_device	*udev;
 
 		udev = hdev->children [port1-1];
 		if (udev && udev->can_submit) {
-			if (!(msg.event & PM_EVENT_AUTO))
-				dev_dbg(&intf->dev, "port %d nyet suspended\n",
-						port1);
-			return -EBUSY;
+			dev_warn(&intf->dev, "port %d nyet suspended\n", port1);
+			if (msg.event & PM_EVENT_AUTO)
+				return -EBUSY;
 		}
 	}
 
-- 
1.7.9.6

