Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832Ab1EFAxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:53:13 -0400
Received: from kroah.org ([198.145.64.141]:36819 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932251Ab1EFAZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:00 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:11 2011
Message-Id: <20110506002211.306182566@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Streetman <ddstreet@ieee.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [062/143] USB: retain USB device power/wakeup setting across reconfiguration
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Streetman <ddstreet@ieee.org>

commit 16985408b5c48585762ec3b9b7bae1dec4ad7437 upstream.

Currently a non-root-hub USB device's wakeup settings are initialized when the
device is set to a configured state using device_init_wakeup(), but this is not
correct as wakeup is split into "capable" (can_wakeup) and "enabled"
(should_wakeup).  The settings should be initialized instead in the device
initialization (usb_new_device) with the "capable" setting disabled and the
"enabled" setting enabled.  The "capable" setting should be set based on the
device being configured or unconfigured, and "enabled" setting set based on
the sysfs power/wakeup control.

This patch retains the sysfs power/wakeup setting of a non-root-hub USB device
over a USB device re-configuration, which can happen (for example) after a
suspend/resume cycle.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
[bwh: Adjust context for 2.6.32]
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/core/hub.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1424,11 +1424,11 @@ void usb_set_device_state(struct usb_dev
 					|| new_state == USB_STATE_SUSPENDED)
 				;	/* No change to wakeup settings */
 			else if (new_state == USB_STATE_CONFIGURED)
-				device_init_wakeup(&udev->dev,
+				device_set_wakeup_capable(&udev->dev,
 					(udev->actconfig->desc.bmAttributes
 					 & USB_CONFIG_ATT_WAKEUP));
 			else
-				device_init_wakeup(&udev->dev, 0);
+				device_set_wakeup_capable(&udev->dev, 0);
 		}
 		if (udev->state == USB_STATE_SUSPENDED &&
 			new_state != USB_STATE_SUSPENDED)
@@ -1786,10 +1786,18 @@ int usb_new_device(struct usb_device *ud
 {
 	int err;
 
-	/* Increment the parent's count of unsuspended children */
-	if (udev->parent)
+	if (udev->parent) {
+		/* Increment the parent's count of unsuspended children */
 		usb_autoresume_device(udev->parent);
 
+		/* Initialize non-root-hub device wakeup to disabled;
+		 * device (un)configuration controls wakeup capable
+		 * sysfs power/wakeup controls wakeup enabled/disabled
+		 */
+		device_init_wakeup(&udev->dev, 0);
+		device_set_wakeup_enable(&udev->dev, 1);
+	}
+
 	err = usb_enumerate_device(udev);	/* Read descriptors */
 	if (err < 0)
 		goto fail;


