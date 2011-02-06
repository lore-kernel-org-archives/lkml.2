Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab1BFUJr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 15:09:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48388 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775Ab1BFUJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 15:09:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 1/2] USB / Hub: Do not call device_set_wakeup_capable() under spinlock
Date: Sun, 6 Feb 2011 21:07:49 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc3+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>, Greg KH <greg@kroah.com>
References: <201102061519.11360.rjw@sisk.pl> <201102062106.29712.rjw@sisk.pl>
In-Reply-To: <201102062106.29712.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102062107.49909.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

A subsequent patch will modify device_set_wakeup_capable() in such
a way that it will call functions which may sleep and therefore it
shouldn't be called under spinlocks.  In preparation for that, modify
usb_set_device_state() to avoid calling device_set_wakeup_capable()
under device_state_lock.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/core/hub.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/usb/core/hub.c
===================================================================
--- linux-2.6.orig/drivers/usb/core/hub.c
+++ linux-2.6/drivers/usb/core/hub.c
@@ -1465,6 +1465,7 @@ void usb_set_device_state(struct usb_dev
 		enum usb_device_state new_state)
 {
 	unsigned long flags;
+	int wakeup = -1;
 
 	spin_lock_irqsave(&device_state_lock, flags);
 	if (udev->state == USB_STATE_NOTATTACHED)
@@ -1479,11 +1480,10 @@ void usb_set_device_state(struct usb_dev
 					|| new_state == USB_STATE_SUSPENDED)
 				;	/* No change to wakeup settings */
 			else if (new_state == USB_STATE_CONFIGURED)
-				device_set_wakeup_capable(&udev->dev,
-					(udev->actconfig->desc.bmAttributes
-					 & USB_CONFIG_ATT_WAKEUP));
+				wakeup = udev->actconfig->desc.bmAttributes
+					 & USB_CONFIG_ATT_WAKEUP;
 			else
-				device_set_wakeup_capable(&udev->dev, 0);
+				wakeup = 0;
 		}
 		if (udev->state == USB_STATE_SUSPENDED &&
 			new_state != USB_STATE_SUSPENDED)
@@ -1495,6 +1495,8 @@ void usb_set_device_state(struct usb_dev
 	} else
 		recursively_mark_NOTATTACHED(udev);
 	spin_unlock_irqrestore(&device_state_lock, flags);
+	if (wakeup >= 0)
+		device_set_wakeup_capable(&udev->dev, wakeup);
 }
 EXPORT_SYMBOL_GPL(usb_set_device_state);
 

