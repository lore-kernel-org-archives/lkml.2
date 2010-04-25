Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab0DYKhZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 06:37:25 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:47691 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab0DYKhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 06:37:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=AZiT7TOpQCRPNzFFcYjtQ32OthibaREoqR578uS6wMPWXNFfqISGR73/EvbzHqvNW6
         JWvVhuf8gXjl3nyY4Zaxyrqcq33JAPAg7FRT3Vl4T/uHxRQlaKEV4NkR4MaqE0L5cRcM
         DoPO8Tlieoqae6Nvy/l2xBfV8CRXILtBviKII=
From: Alessio Igor Bogani <abogani@texware.it>
To: Greg Kroah-Hartman <gregkh@suse.de>,
       Thomas Winischhofer <thomas@winischhofer.net>,
       Oliver Neukum <neukum@b1-systems.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Pete Zaitcev <zaitcev@redhat.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH] USB: sisusbvga: Remove the BKL from open
Date: Sun, 25 Apr 2010 12:37:10 +0200
Message-Id: <1272191830-23675-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BKL is not needed here because necessary locking is already provided
by mutex sisusb->lock.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 drivers/usb/misc/sisusbvga/sisusb.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/misc/sisusbvga/sisusb.c b/drivers/usb/misc/sisusbvga/sisusb.c
index 63a6070..30d9303 100644
--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -47,7 +47,6 @@
 #include <linux/spinlock.h>
 #include <linux/kref.h>
 #include <linux/usb.h>
-#include <linux/smp_lock.h>
 #include <linux/vmalloc.h>
 
 #include "sisusb.h"
@@ -2416,14 +2415,11 @@ sisusb_open(struct inode *inode, struct file *file)
 	struct usb_interface *interface;
 	int subminor = iminor(inode);
 
-	lock_kernel();
 	if (!(interface = usb_find_interface(&sisusb_driver, subminor))) {
-		unlock_kernel();
 		return -ENODEV;
 	}
 
 	if (!(sisusb = usb_get_intfdata(interface))) {
-		unlock_kernel();
 		return -ENODEV;
 	}
 
@@ -2431,13 +2427,11 @@ sisusb_open(struct inode *inode, struct file *file)
 
 	if (!sisusb->present || !sisusb->ready) {
 		mutex_unlock(&sisusb->lock);
-		unlock_kernel();
 		return -ENODEV;
 	}
 
 	if (sisusb->isopen) {
 		mutex_unlock(&sisusb->lock);
-		unlock_kernel();
 		return -EBUSY;
 	}
 
@@ -2446,13 +2440,11 @@ sisusb_open(struct inode *inode, struct file *file)
 			if (sisusb_init_gfxdevice(sisusb, 0)) {
 				mutex_unlock(&sisusb->lock);
 				dev_err(&sisusb->sisusb_dev->dev, "Failed to initialize device\n");
-				unlock_kernel();
 				return -EIO;
 			}
 		} else {
 			mutex_unlock(&sisusb->lock);
 			dev_err(&sisusb->sisusb_dev->dev, "Device not attached to USB 2.0 hub\n");
-			unlock_kernel();
 			return -EIO;
 		}
 	}
@@ -2465,7 +2457,6 @@ sisusb_open(struct inode *inode, struct file *file)
 	file->private_data = sisusb;
 
 	mutex_unlock(&sisusb->lock);
-	unlock_kernel();
 
 	return 0;
 }
-- 
1.6.3.3

