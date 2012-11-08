Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab2KHTxA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 14:53:00 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60756 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500Ab2KHTw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 14:52:58 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben@decadent.org.uk>, Sean Young <sean@mess.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] staging/media: Use dev_ or pr_ printks in lirc/lirc_sasem.c
Date: Fri,  9 Nov 2012 04:52:49 +0900
Message-Id: <1352404370-7564-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
- WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
- WARNING: Prefer netdev_warn(netdev, ... then dev_warn(dev, ... then pr_warn(...  to printk(KERN_WARNING ...
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

and add pr_fmt.

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/media/lirc/lirc_sasem.c |   65 ++++++++++++++++---------------
 1 file changed, 33 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_sasem.c b/drivers/staging/media/lirc/lirc_sasem.c
index f4e4d90..9be4d3f 100644
--- a/drivers/staging/media/lirc/lirc_sasem.c
+++ b/drivers/staging/media/lirc/lirc_sasem.c
@@ -34,6 +34,8 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -171,7 +173,7 @@ static void delete_context(struct sasem_context *context)
 	kfree(context);
 
 	if (debug)
-		printk(KERN_INFO "%s: context deleted\n", __func__);
+		pr_info("%s: context deleted\n", __func__);
 }
 
 static void deregister_from_lirc(struct sasem_context *context)
@@ -181,11 +183,10 @@ static void deregister_from_lirc(struct sasem_context *context)
 
 	retval = lirc_unregister_driver(minor);
 	if (retval)
-		printk(KERN_ERR "%s: unable to deregister from lirc (%d)\n",
-			__func__, retval);
+		pr_err("%s: unable to deregister from lirc (%d)\n",
+		       __func__, retval);
 	else
-		printk(KERN_INFO "Deregistered Sasem driver (minor:%d)\n",
-		       minor);
+		pr_info("Deregistered Sasem driver (minor:%d)\n", minor);
 
 }
 
@@ -206,8 +207,7 @@ static int vfd_open(struct inode *inode, struct file *file)
 	subminor = iminor(inode);
 	interface = usb_find_interface(&sasem_driver, subminor);
 	if (!interface) {
-		printk(KERN_ERR KBUILD_MODNAME
-		       ": %s: could not find interface for minor %d\n",
+		pr_err("%s: could not find interface for minor %d\n",
 		       __func__, subminor);
 		retval = -ENODEV;
 		goto exit;
@@ -252,8 +252,7 @@ static long vfd_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	context = (struct sasem_context *) file->private_data;
 
 	if (!context) {
-		printk(KERN_ERR KBUILD_MODNAME
-		       ": %s: no context for device\n", __func__);
+		pr_err("%s: no context for device\n", __func__);
 		return -ENODEV;
 	}
 
@@ -266,7 +265,7 @@ static long vfd_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 		context->vfd_contrast = (unsigned int)arg;
 		break;
 	default:
-		printk(KERN_INFO "Unknown IOCTL command\n");
+		pr_info("Unknown IOCTL command\n");
 		mutex_unlock(&context->ctx_lock);
 		return -ENOIOCTLCMD;  /* not supported */
 	}
@@ -287,8 +286,7 @@ static int vfd_close(struct inode *inode, struct file *file)
 	context = (struct sasem_context *) file->private_data;
 
 	if (!context) {
-		printk(KERN_ERR KBUILD_MODNAME
-		       ": %s: no context for device\n", __func__);
+		pr_err("%s: no context for device\n", __func__);
 		return -ENODEV;
 	}
 
@@ -299,7 +297,7 @@ static int vfd_close(struct inode *inode, struct file *file)
 		retval = -EIO;
 	} else {
 		context->vfd_isopen = 0;
-		printk(KERN_INFO "VFD port closed\n");
+		dev_info(&context->dev->dev, "VFD port closed\n");
 		if (!context->dev_present && !context->ir_isopen) {
 
 			/* Device disconnected before close and IR port is
@@ -373,16 +371,14 @@ static ssize_t vfd_write(struct file *file, const char *buf,
 
 	context = (struct sasem_context *) file->private_data;
 	if (!context) {
-		printk(KERN_ERR KBUILD_MODNAME
-		       ": %s: no context for device\n", __func__);
+		pr_err("%s: no context for device\n", __func__);
 		return -ENODEV;
 	}
 
 	mutex_lock(&context->ctx_lock);
 
 	if (!context->dev_present) {
-		printk(KERN_ERR KBUILD_MODNAME
-		       ": %s: no Sasem device present\n", __func__);
+		pr_err("%s: no Sasem device present\n", __func__);
 		retval = -ENODEV;
 		goto exit;
 	}
@@ -519,7 +515,7 @@ static int ir_open(void *data)
 			__func__, retval);
 	else {
 		context->ir_isopen = 1;
-		printk(KERN_INFO "IR port opened\n");
+		dev_info(&context->dev->dev, "IR port opened\n");
 	}
 
 exit:
@@ -538,8 +534,7 @@ static void ir_close(void *data)
 
 	context = (struct sasem_context *)data;
 	if (!context) {
-		printk(KERN_ERR KBUILD_MODNAME
-		       ": %s: no context for device\n", __func__);
+		pr_err("%s: no context for device\n", __func__);
 		return;
 	}
 
@@ -547,7 +542,7 @@ static void ir_close(void *data)
 
 	usb_kill_urb(context->rx_urb);
 	context->ir_isopen = 0;
-	printk(KERN_INFO "IR port closed\n");
+	pr_info("IR port closed\n");
 
 	if (!context->dev_present) {
 
@@ -584,8 +579,9 @@ static void incoming_packet(struct sasem_context *context,
 	int i;
 
 	if (len != 8) {
-		printk(KERN_WARNING "%s: invalid incoming packet size (%d)\n",
-		     __func__, len);
+		dev_warn(&context->dev->dev,
+			 "%s: invalid incoming packet size (%d)\n",
+			 __func__, len);
 		return;
 	}
 
@@ -663,7 +659,7 @@ static void usb_rx_callback(struct urb *urb)
 		break;
 
 	default:
-		printk(KERN_WARNING "%s: status (%d): ignored",
+		dev_warn(&urb->dev->dev, "%s: status (%d): ignored",
 			 __func__, urb->status);
 		break;
 	}
@@ -830,8 +826,9 @@ static int sasem_probe(struct usb_interface *interface,
 		retval = lirc_minor;
 		goto unlock;
 	} else
-		printk(KERN_INFO "%s: Registered Sasem driver (minor:%d)\n",
-			__func__, lirc_minor);
+		dev_info(&interface->dev,
+			 "%s: Registered Sasem driver (minor:%d)\n",
+			 __func__, lirc_minor);
 
 	/* Needed while unregistering! */
 	driver->minor = lirc_minor;
@@ -852,15 +849,18 @@ static int sasem_probe(struct usb_interface *interface,
 	if (vfd_ep_found) {
 
 		if (debug)
-			printk(KERN_INFO "Registering VFD with sysfs\n");
+			dev_info(&interface->dev,
+				 "Registering VFD with sysfs\n");
 		if (usb_register_dev(interface, &sasem_class))
 			/* Not a fatal error, so ignore */
-			printk(KERN_INFO "%s: could not get a minor number "
-			       "for VFD\n", __func__);
+			dev_info(&interface->dev,
+				 "%s: could not get a minor number for VFD\n",
+				 __func__);
 	}
 
-	printk(KERN_INFO "%s: Sasem device on usb<%d:%d> initialized\n",
-			__func__, dev->bus->busnum, dev->devnum);
+	dev_info(&interface->dev,
+		 "%s: Sasem device on usb<%d:%d> initialized\n",
+		 __func__, dev->bus->busnum, dev->devnum);
 unlock:
 	mutex_unlock(&context->ctx_lock);
 
@@ -903,7 +903,8 @@ static void sasem_disconnect(struct usb_interface *interface)
 	context = usb_get_intfdata(interface);
 	mutex_lock(&context->ctx_lock);
 
-	printk(KERN_INFO "%s: Sasem device disconnected\n", __func__);
+	dev_info(&interface->dev, "%s: Sasem device disconnected\n",
+		 __func__);
 
 	usb_set_intfdata(interface, NULL);
 	context->dev_present = 0;
-- 
1.7.9.5

