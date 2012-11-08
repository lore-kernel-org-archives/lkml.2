Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab2KHTzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 14:55:15 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:39903 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772Ab2KHTzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 14:55:00 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben@decadent.org.uk>, Sean Young <sean@mess.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] staging/media: Use dev_ or pr_ printks in lirc/lirc_imon.c
Date: Fri,  9 Nov 2012 04:54:54 +0900
Message-Id: <1352404494-7735-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
- WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

and add pr_fmt.

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/media/lirc/lirc_imon.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_imon.c b/drivers/staging/media/lirc/lirc_imon.c
index 2944fde..343c622 100644
--- a/drivers/staging/media/lirc/lirc_imon.c
+++ b/drivers/staging/media/lirc/lirc_imon.c
@@ -20,6 +20,8 @@
  *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -205,12 +207,12 @@ static void deregister_from_lirc(struct imon_context *context)
 
 	retval = lirc_unregister_driver(minor);
 	if (retval)
-		printk(KERN_ERR KBUILD_MODNAME
-		       ": %s: unable to deregister from lirc(%d)",
-		       __func__, retval);
+		dev_err(&context->usbdev->dev,
+			": %s: unable to deregister from lirc(%d)",
+			__func__, retval);
 	else
-		printk(KERN_INFO MOD_NAME ": Deregistered iMON driver "
-		       "(minor:%d)\n", minor);
+		dev_info(&context->usbdev->dev,
+			 "Deregistered iMON driver (minor:%d)\n", minor);
 
 }
 
@@ -231,8 +233,7 @@ static int display_open(struct inode *inode, struct file *file)
 	subminor = iminor(inode);
 	interface = usb_find_interface(&imon_driver, subminor);
 	if (!interface) {
-		printk(KERN_ERR KBUILD_MODNAME
-		       ": %s: could not find interface for minor %d\n",
+		pr_err("%s: could not find interface for minor %d\n",
 		       __func__, subminor);
 		retval = -ENODEV;
 		goto exit;
@@ -282,8 +283,7 @@ static int display_close(struct inode *inode, struct file *file)
 	context = file->private_data;
 
 	if (!context) {
-		printk(KERN_ERR KBUILD_MODNAME
-		       "%s: no context for device\n", __func__);
+		pr_err("%s: no context for device\n", __func__);
 		return -ENODEV;
 	}
 
@@ -391,8 +391,7 @@ static ssize_t vfd_write(struct file *file, const char __user *buf,
 
 	context = file->private_data;
 	if (!context) {
-		printk(KERN_ERR KBUILD_MODNAME
-		       "%s: no context for device\n", __func__);
+		pr_err("%s: no context for device\n", __func__);
 		return -ENODEV;
 	}
 
@@ -521,8 +520,7 @@ static void ir_close(void *data)
 
 	context = (struct imon_context *)data;
 	if (!context) {
-		printk(KERN_ERR KBUILD_MODNAME
-		       "%s: no context for device\n", __func__);
+		pr_err("%s: no context for device\n", __func__);
 		return;
 	}
 
@@ -1009,8 +1007,8 @@ static void imon_disconnect(struct usb_interface *interface)
 
 	mutex_unlock(&driver_lock);
 
-	printk(KERN_INFO "%s: iMON device (intf%d) disconnected\n",
-	       __func__, ifnum);
+	dev_info(&interface->dev, "%s: iMON device (intf%d) disconnected\n",
+		 __func__, ifnum);
 }
 
 static int imon_suspend(struct usb_interface *intf, pm_message_t message)
-- 
1.7.9.5

