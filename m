Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212Ab2FGIZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 04:25:16 -0400
Received: from www84.your-server.de ([213.133.104.84]:39288 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757513Ab2FGIU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 04:20:27 -0400
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de
Cc: linux-usb@vger.kernel.org, Stefani Seibold <stefani@seibold.net>
Subject: [PATCH 02/13] code cleanup
Date: Thu,  7 Jun 2012 10:20:32 +0200
Message-Id: <1339057243-10029-3-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1339057243-10029-1-git-send-email-stefani@seibold.net>
References: <1339057243-10029-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

- consistent nameing
- more compact style
- remove unneeded code

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 drivers/usb/usb-skeleton.c |  119 +++++++++++++++++---------------------------
 1 files changed, 46 insertions(+), 73 deletions(-)

diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
index efda3a5..7385aa8 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -22,7 +22,6 @@
 #include <linux/usb.h>
 #include <linux/mutex.h>
 
-
 /* Define these values to match your devices */
 #define USB_SKEL_VENDOR_ID	0xfff0
 #define USB_SKEL_PRODUCT_ID	0xfff0
@@ -34,7 +33,6 @@ static const struct usb_device_id skel_table[] = {
 };
 MODULE_DEVICE_TABLE(usb, skel_table);
 
-
 /* Get a minor range for your devices from the usb maintainer */
 #define USB_SKEL_MINOR_BASE	192
 
@@ -95,15 +93,12 @@ static int skel_open(struct inode *inode, struct file *file)
 	if (!interface) {
 		pr_err("%s - error, can't find device for minor %d\n",
 			__func__, subminor);
-		retval = -ENODEV;
-		goto exit;
+		return -ENODEV;
 	}
 
 	dev = usb_get_intfdata(interface);
-	if (!dev) {
-		retval = -ENODEV;
-		goto exit;
-	}
+	if (!dev)
+		return -ENODEV;
 
 	/* increment our usage count for the device */
 	kref_get(&dev->kref);
@@ -111,27 +106,19 @@ static int skel_open(struct inode *inode, struct file *file)
 	/* lock the device to allow correctly handling errors
 	 * in resumption */
 	mutex_lock(&dev->io_mutex);
-
 	retval = usb_autopm_get_interface(interface);
-	if (retval)
-		goto exit2;
+	mutex_unlock(&dev->io_mutex);
 
 	/* save our object in the file's private structure */
-	file->private_data = dev;
-exit2:
-	mutex_unlock(&dev->io_mutex);
+	if (!retval)
+		file->private_data = dev;
 
-exit:
 	return retval;
 }
 
 static int skel_release(struct inode *inode, struct file *file)
 {
-	struct usb_skel *dev;
-
-	dev = file->private_data;
-	if (dev == NULL)
-		return -ENODEV;
+	struct usb_skel *dev = file->private_data;
 
 	/* allow the device to be autosuspended */
 	mutex_lock(&dev->io_mutex);
@@ -146,13 +133,9 @@ static int skel_release(struct inode *inode, struct file *file)
 
 static int skel_flush(struct file *file, fl_owner_t id)
 {
-	struct usb_skel *dev;
+	struct usb_skel *dev = file->private_data;
 	int res;
 
-	dev = file->private_data;
-	if (dev == NULL)
-		return -ENODEV;
-
 	/* wait for io to stop */
 	mutex_lock(&dev->io_mutex);
 	skel_draw_down(dev);
@@ -188,7 +171,7 @@ static void skel_read_bulk_callback(struct urb *urb)
 	} else {
 		dev->bulk_in_filled = urb->actual_length;
 	}
-	dev->ongoing_read = 0;
+	dev->ongoing_read = false;
 	spin_unlock(&dev->err_lock);
 
 	complete(&dev->bulk_in_completion);
@@ -196,7 +179,7 @@ static void skel_read_bulk_callback(struct urb *urb)
 
 static int skel_do_read_io(struct usb_skel *dev, size_t count)
 {
-	int rv;
+	int retval;
 
 	/* prepare a read */
 	usb_fill_bulk_urb(dev->bulk_in_urb,
@@ -209,45 +192,43 @@ static int skel_do_read_io(struct usb_skel *dev, size_t count)
 			dev);
 	/* tell everybody to leave the URB alone */
 	spin_lock_irq(&dev->err_lock);
-	dev->ongoing_read = 1;
+	dev->ongoing_read = true;
 	spin_unlock_irq(&dev->err_lock);
 
 	/* do it */
-	rv = usb_submit_urb(dev->bulk_in_urb, GFP_KERNEL);
-	if (rv < 0) {
+	retval = usb_submit_urb(dev->bulk_in_urb, GFP_KERNEL);
+	if (retval < 0) {
 		dev_err(&dev->interface->dev,
 			"%s - failed submitting read urb, error %d\n",
-			__func__, rv);
+			__func__, retval);
 		dev->bulk_in_filled = 0;
-		rv = (rv == -ENOMEM) ? rv : -EIO;
+		retval = (retval == -ENOMEM) ? retval : -EIO;
 		spin_lock_irq(&dev->err_lock);
-		dev->ongoing_read = 0;
+		dev->ongoing_read = false;
 		spin_unlock_irq(&dev->err_lock);
 	}
 
-	return rv;
+	return retval;
 }
 
 static ssize_t skel_read(struct file *file, char *buffer, size_t count,
 			 loff_t *ppos)
 {
-	struct usb_skel *dev;
-	int rv;
+	struct usb_skel *dev = file->private_data;
+	int retval;
 	bool ongoing_io;
 
-	dev = file->private_data;
-
 	/* if we cannot read at all, return EOF */
 	if (!dev->bulk_in_urb || !count)
 		return 0;
 
 	/* no concurrent readers */
-	rv = mutex_lock_interruptible(&dev->io_mutex);
-	if (rv < 0)
-		return rv;
+	retval = mutex_lock_interruptible(&dev->io_mutex);
+	if (retval < 0)
+		return retval;
 
 	if (!dev->interface) {		/* disconnect() was called */
-		rv = -ENODEV;
+		retval = -ENODEV;
 		goto exit;
 	}
 
@@ -260,22 +241,22 @@ retry:
 	if (ongoing_io) {
 		/* nonblocking IO shall not wait */
 		if (file->f_flags & O_NONBLOCK) {
-			rv = -EAGAIN;
+			retval = -EAGAIN;
 			goto exit;
 		}
 		/*
 		 * IO may take forever
 		 * hence wait in an interruptible state
 		 */
-		rv = wait_for_completion_interruptible(&dev->bulk_in_completion);
-		if (rv < 0)
+		retval = wait_for_completion_interruptible(&dev->bulk_in_completion);
+		if (retval < 0)
 			goto exit;
 		/*
 		 * by waiting we also semiprocessed the urb
 		 * we must finish now
 		 */
 		dev->bulk_in_copied = 0;
-		dev->processed_urb = 1;
+		dev->processed_urb = true;
 	}
 
 	if (!dev->processed_urb) {
@@ -285,16 +266,16 @@ retry:
 		 */
 		wait_for_completion(&dev->bulk_in_completion);
 		dev->bulk_in_copied = 0;
-		dev->processed_urb = 1;
+		dev->processed_urb = true;
 	}
 
 	/* errors must be reported */
-	rv = dev->errors;
-	if (rv < 0) {
+	retval = dev->errors;
+	if (retval < 0) {
 		/* any error is reported once */
 		dev->errors = 0;
 		/* to preserve notifications about reset */
-		rv = (rv == -EPIPE) ? rv : -EIO;
+		retval = (retval == -EPIPE) ? retval : -EIO;
 		/* no data to deliver */
 		dev->bulk_in_filled = 0;
 		/* report it */
@@ -316,8 +297,8 @@ retry:
 			 * all data has been used
 			 * actual IO needs to be done
 			 */
-			rv = skel_do_read_io(dev, count);
-			if (rv < 0)
+			retval = skel_do_read_io(dev, count);
+			if (retval < 0)
 				goto exit;
 			else
 				goto retry;
@@ -330,9 +311,9 @@ retry:
 		if (copy_to_user(buffer,
 				 dev->bulk_in_buffer + dev->bulk_in_copied,
 				 chunk))
-			rv = -EFAULT;
+			retval = -EFAULT;
 		else
-			rv = chunk;
+			retval = chunk;
 
 		dev->bulk_in_copied += chunk;
 
@@ -344,16 +325,16 @@ retry:
 			skel_do_read_io(dev, count - chunk);
 	} else {
 		/* no data in the buffer */
-		rv = skel_do_read_io(dev, count);
-		if (rv < 0)
+		retval = skel_do_read_io(dev, count);
+		if (retval < 0)
 			goto exit;
 		else if (!(file->f_flags & O_NONBLOCK))
 			goto retry;
-		rv = -EAGAIN;
+		retval = -EAGAIN;
 	}
 exit:
 	mutex_unlock(&dev->io_mutex);
-	return rv;
+	return retval;
 }
 
 static void skel_write_bulk_callback(struct urb *urb)
@@ -385,32 +366,26 @@ static void skel_write_bulk_callback(struct urb *urb)
 static ssize_t skel_write(struct file *file, const char *user_buffer,
 			  size_t count, loff_t *ppos)
 {
-	struct usb_skel *dev;
+	struct usb_skel *dev = file->private_data;
 	int retval = 0;
 	struct urb *urb = NULL;
 	char *buf = NULL;
 	size_t writesize = min(count, (size_t)MAX_TRANSFER);
 
-	dev = file->private_data;
-
 	/* verify that we actually have some data to write */
-	if (count == 0)
-		goto exit;
+	if (!count)
+		return 0;
 
 	/*
 	 * limit the number of URBs in flight to stop a user from using up all
 	 * RAM
 	 */
 	if (!(file->f_flags & O_NONBLOCK)) {
-		if (down_interruptible(&dev->limit_sem)) {
-			retval = -ERESTARTSYS;
-			goto exit;
-		}
+		if (down_interruptible(&dev->limit_sem))
+			return -ERESTARTSYS;
 	} else {
-		if (down_trylock(&dev->limit_sem)) {
-			retval = -EAGAIN;
-			goto exit;
-		}
+		if (down_trylock(&dev->limit_sem))
+			return -EAGAIN;
 	}
 
 	spin_lock_irq(&dev->err_lock);
@@ -475,7 +450,6 @@ static ssize_t skel_write(struct file *file, const char *user_buffer,
 	 */
 	usb_free_urb(urb);
 
-
 	return writesize;
 
 error_unanchor:
@@ -487,7 +461,6 @@ error:
 	}
 	up(&dev->limit_sem);
 
-exit:
 	return retval;
 }
 
-- 
1.7.8.6

