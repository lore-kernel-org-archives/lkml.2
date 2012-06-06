Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419Ab2FFQ3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:29:41 -0400
Received: from www84.your-server.de ([213.133.104.84]:36687 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757176Ab2FFQ1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:27:21 -0400
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de
Cc: alan@lxorguk.ukuu.org.uk, linux-usb@vger.kernel.org,
        Stefani Seibold <stefani@seibold.net>
Subject: [PATCH 02/11] code cleanup
Date: Wed,  6 Jun 2012 18:27:03 +0200
Message-Id: <1339000032-10313-3-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1339000032-10313-1-git-send-email-stefani@seibold.net>
References: <1339000032-10313-1-git-send-email-stefani@seibold.net>
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
 drivers/usb/usb-skeleton.c |   80 ++++++++++++++++++-------------------------
 1 files changed, 34 insertions(+), 46 deletions(-)

diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
index a57f1d2..2298ef0 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -126,11 +126,7 @@ exit:
 
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
@@ -145,13 +141,9 @@ static int skel_release(struct inode *inode, struct file *file)
 
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
@@ -187,7 +179,7 @@ static void skel_read_bulk_callback(struct urb *urb)
 	} else {
 		dev->bulk_in_filled = urb->actual_length;
 	}
-	dev->ongoing_read = 0;
+	dev->ongoing_read = false;
 	spin_unlock(&dev->err_lock);
 
 	complete(&dev->bulk_in_completion);
@@ -195,7 +187,7 @@ static void skel_read_bulk_callback(struct urb *urb)
 
 static int skel_do_read_io(struct usb_skel *dev, size_t count)
 {
-	int rv;
+	int retval;
 
 	/* prepare a read */
 	usb_fill_bulk_urb(dev->bulk_in_urb,
@@ -208,45 +200,43 @@ static int skel_do_read_io(struct usb_skel *dev, size_t count)
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
 
@@ -259,22 +249,22 @@ retry:
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
@@ -284,16 +274,16 @@ retry:
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
@@ -315,8 +305,8 @@ retry:
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
@@ -329,9 +319,9 @@ retry:
 		if (copy_to_user(buffer,
 				 dev->bulk_in_buffer + dev->bulk_in_copied,
 				 chunk))
-			rv = -EFAULT;
+			retval = -EFAULT;
 		else
-			rv = chunk;
+			retval = chunk;
 
 		dev->bulk_in_copied += chunk;
 
@@ -343,16 +333,16 @@ retry:
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
@@ -384,14 +374,12 @@ static void skel_write_bulk_callback(struct urb *urb)
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
 	if (count == 0)
 		goto exit;
-- 
1.7.8.6

