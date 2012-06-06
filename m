Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab2FFHA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 03:00:28 -0400
Received: from www84.your-server.de ([213.133.104.84]:42057 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab2FFHAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 03:00:25 -0400
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de,
        alan@lxorguk.ukuu.org.uk
Cc: Stefani Seibold <stefani@seibold.net>
Subject: [PATCH] fix usb skeleton driver
Date: Wed,  6 Jun 2012 09:00:36 +0200
Message-Id: <1338966036-30443-1-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.7.8.6
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

This is a fix for the USB skeleton driver to bring it in shape.

- The usb_device structure pointer will no longer stored 
- Every access to the USB will be handled trought the usb_interface pointer
- No longer assign a NULL to usb_interface pointer in the disconnect() handler
- Add a new bool 'connected' for signaling a disconnect (== false)
- Handle a non blocking read without blocking
- Code clean up

The patch is against linux 3.5.0 commit eea5b5510fc5545d15b69da8e485a7424ae388cf

Hope this helps

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 drivers/usb/usb-skeleton.c |  107 ++++++++++++++++++--------------------------
 1 files changed, 44 insertions(+), 63 deletions(-)

diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
index 0616f23..01f7ca5 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -1,7 +1,8 @@
 /*
- * USB Skeleton driver - 2.2
+ * USB Skeleton driver - 2.3
  *
  * Copyright (C) 2001-2004 Greg Kroah-Hartman (greg@kroah.com)
+ * fixes by Stefan Seibold <stefani@seibold.net>
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License as
@@ -48,7 +49,6 @@ MODULE_DEVICE_TABLE(usb, skel_table);
 
 /* Structure to hold all of our device specific stuff */
 struct usb_skel {
-	struct usb_device	*udev;			/* the usb device for this device */
 	struct usb_interface	*interface;		/* the interface for this device */
 	struct semaphore	limit_sem;		/* limiting the number of writes in progress */
 	struct usb_anchor	submitted;		/* in case we need to retract our submissions */
@@ -62,9 +62,10 @@ struct usb_skel {
 	int			errors;			/* the last request tanked */
 	bool			ongoing_read;		/* a read is going on */
 	bool			processed_urb;		/* indicates we haven't processed the urb */
+	bool			connected;		/* connected flag */
 	spinlock_t		err_lock;		/* lock for errors */
 	struct kref		kref;
-	struct mutex		io_mutex;		/* synchronize I/O with disconnect */
+	struct mutex		io_mutex;		/* synchronize I/O */
 	struct completion	bulk_in_completion;	/* to wait for an ongoing read */
 };
 #define to_skel_dev(d) container_of(d, struct usb_skel, kref)
@@ -77,7 +78,7 @@ static void skel_delete(struct kref *kref)
 	struct usb_skel *dev = to_skel_dev(kref);
 
 	usb_free_urb(dev->bulk_in_urb);
-	usb_put_dev(dev->udev);
+	usb_put_dev(interface_to_usbdev(dev->interface));
 	kfree(dev->bulk_in_buffer);
 	kfree(dev);
 }
@@ -100,7 +101,7 @@ static int skel_open(struct inode *inode, struct file *file)
 	}
 
 	dev = usb_get_intfdata(interface);
-	if (!dev) {
+	if (!dev || !dev->connected) {
 		retval = -ENODEV;
 		goto exit;
 	}
@@ -108,17 +109,12 @@ static int skel_open(struct inode *inode, struct file *file)
 	/* increment our usage count for the device */
 	kref_get(&dev->kref);
 
-	/* lock the device to allow correctly handling errors
-	 * in resumption */
-	mutex_lock(&dev->io_mutex);
-
 	retval = usb_autopm_get_interface(interface);
 	if (retval)
-		goto out_err;
+		goto exit;
 
 	/* save our object in the file's private structure */
 	file->private_data = dev;
-	mutex_unlock(&dev->io_mutex);
 
 exit:
 	return retval;
@@ -126,32 +122,21 @@ exit:
 
 static int skel_release(struct inode *inode, struct file *file)
 {
-	struct usb_skel *dev;
-
-	dev = file->private_data;
-	if (dev == NULL)
-		return -ENODEV;
+	struct usb_skel *dev = file->private_data;
 
 	/* allow the device to be autosuspended */
-	mutex_lock(&dev->io_mutex);
-	if (dev->interface)
-		usb_autopm_put_interface(dev->interface);
-	mutex_unlock(&dev->io_mutex);
+	usb_autopm_put_interface(dev->interface);
 
 	/* decrement the count on our device */
 	kref_put(&dev->kref, skel_delete);
 	return 0;
 }
 
-static int skel_flush(struct file *file, fl_owner_t id)
+static int skel_fsync(struct file *file, loff_t start, loff_t end, int datasync)
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
@@ -167,6 +152,11 @@ static int skel_flush(struct file *file, fl_owner_t id)
 	return res;
 }
 
+static int skel_flush(struct file *file, fl_owner_t id)
+{
+	return skel_fsync(file, 0, LLONG_MAX, 0);
+}
+
 static void skel_read_bulk_callback(struct urb *urb)
 {
 	struct usb_skel *dev;
@@ -187,7 +177,7 @@ static void skel_read_bulk_callback(struct urb *urb)
 	} else {
 		dev->bulk_in_filled = urb->actual_length;
 	}
-	dev->ongoing_read = 0;
+	dev->ongoing_read = false;
 	spin_unlock(&dev->err_lock);
 
 	complete(&dev->bulk_in_completion);
@@ -196,20 +186,19 @@ static void skel_read_bulk_callback(struct urb *urb)
 static int skel_do_read_io(struct usb_skel *dev, size_t count)
 {
 	int rv;
+	struct usb_device *udev = interface_to_usbdev(dev->interface);
 
 	/* prepare a read */
 	usb_fill_bulk_urb(dev->bulk_in_urb,
-			dev->udev,
-			usb_rcvbulkpipe(dev->udev,
+			udev,
+			usb_rcvbulkpipe(udev,
 				dev->bulk_in_endpointAddr),
 			dev->bulk_in_buffer,
 			min(dev->bulk_in_size, count),
 			skel_read_bulk_callback,
 			dev);
 	/* tell everybody to leave the URB alone */
-	spin_lock_irq(&dev->err_lock);
-	dev->ongoing_read = 1;
-	spin_unlock_irq(&dev->err_lock);
+	dev->ongoing_read = true;
 
 	/* do it */
 	rv = usb_submit_urb(dev->bulk_in_urb, GFP_KERNEL);
@@ -219,9 +208,7 @@ static int skel_do_read_io(struct usb_skel *dev, size_t count)
 			__func__, rv);
 		dev->bulk_in_filled = 0;
 		rv = (rv == -ENOMEM) ? rv : -EIO;
-		spin_lock_irq(&dev->err_lock);
-		dev->ongoing_read = 0;
-		spin_unlock_irq(&dev->err_lock);
+		dev->ongoing_read = false;
 	}
 
 	return rv;
@@ -230,33 +217,31 @@ static int skel_do_read_io(struct usb_skel *dev, size_t count)
 static ssize_t skel_read(struct file *file, char *buffer, size_t count,
 			 loff_t *ppos)
 {
-	struct usb_skel *dev;
+	struct usb_skel *dev = file->private_data;
 	int rv;
-	bool ongoing_io;
-
-	dev = file->private_data;
 
 	/* if we cannot read at all, return EOF */
 	if (!dev->bulk_in_urb || !count)
 		return 0;
 
 	/* no concurrent readers */
-	rv = mutex_lock_interruptible(&dev->io_mutex);
-	if (rv < 0)
-		return rv;
+	if (file->f_flags & O_NONBLOCK) {
+		if (!mutex_trylock(&dev->io_mutex))
+			return -EAGAIN;
+	} else {
+		rv = mutex_lock_interruptible(&dev->io_mutex);
+		if (rv < 0)
+			return rv;
+	}
 
-	if (!dev->interface) {		/* disconnect() was called */
+	if (!dev->connected) {		/* disconnect() was called */
 		rv = -ENODEV;
 		goto exit;
 	}
 
 	/* if IO is under way, we must not touch things */
 retry:
-	spin_lock_irq(&dev->err_lock);
-	ongoing_io = dev->ongoing_read;
-	spin_unlock_irq(&dev->err_lock);
-
-	if (ongoing_io) {
+	if (dev->ongoing_read) {
 		/* nonblocking IO shall not wait */
 		if (file->f_flags & O_NONBLOCK) {
 			rv = -EAGAIN;
@@ -384,13 +369,12 @@ static void skel_write_bulk_callback(struct urb *urb)
 static ssize_t skel_write(struct file *file, const char *user_buffer,
 			  size_t count, loff_t *ppos)
 {
-	struct usb_skel *dev;
+	struct usb_skel *dev = file->private_data;
 	int retval = 0;
 	struct urb *urb = NULL;
 	char *buf = NULL;
 	size_t writesize = min(count, (size_t)MAX_TRANSFER);
-
-	dev = file->private_data;
+	struct usb_device *udev = interface_to_usbdev(dev->interface);
 
 	/* verify that we actually have some data to write */
 	if (count == 0)
@@ -431,7 +415,7 @@ static ssize_t skel_write(struct file *file, const char *user_buffer,
 		goto error;
 	}
 
-	buf = usb_alloc_coherent(dev->udev, writesize, GFP_KERNEL,
+	buf = usb_alloc_coherent(udev, writesize, GFP_KERNEL,
 				 &urb->transfer_dma);
 	if (!buf) {
 		retval = -ENOMEM;
@@ -444,23 +428,20 @@ static ssize_t skel_write(struct file *file, const char *user_buffer,
 	}
 
 	/* this lock makes sure we don't submit URBs to gone devices */
-	mutex_lock(&dev->io_mutex);
-	if (!dev->interface) {		/* disconnect() was called */
-		mutex_unlock(&dev->io_mutex);
+	if (!dev->connected) {		/* disconnect() was called */
 		retval = -ENODEV;
 		goto error;
 	}
 
 	/* initialize the urb properly */
-	usb_fill_bulk_urb(urb, dev->udev,
-			  usb_sndbulkpipe(dev->udev, dev->bulk_out_endpointAddr),
+	usb_fill_bulk_urb(urb, udev,
+			  usb_sndbulkpipe(udev, dev->bulk_out_endpointAddr),
 			  buf, writesize, skel_write_bulk_callback, dev);
 	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 	usb_anchor_urb(urb, &dev->submitted);
 
 	/* send the data out the bulk port */
 	retval = usb_submit_urb(urb, GFP_KERNEL);
-	mutex_unlock(&dev->io_mutex);
 	if (retval) {
 		dev_err(&dev->interface->dev,
 			"%s - failed submitting write urb, error %d\n",
@@ -481,7 +462,7 @@ error_unanchor:
 	usb_unanchor_urb(urb);
 error:
 	if (urb) {
-		usb_free_coherent(dev->udev, writesize, buf, urb->transfer_dma);
+		usb_free_coherent(udev, writesize, buf, urb->transfer_dma);
 		usb_free_urb(urb);
 	}
 	up(&dev->limit_sem);
@@ -496,6 +477,7 @@ static const struct file_operations skel_fops = {
 	.write =	skel_write,
 	.open =		skel_open,
 	.release =	skel_release,
+	.fsync =	skel_fsync,
 	.flush =	skel_flush,
 	.llseek =	noop_llseek,
 };
@@ -533,8 +515,9 @@ static int skel_probe(struct usb_interface *interface,
 	init_usb_anchor(&dev->submitted);
 	init_completion(&dev->bulk_in_completion);
 
-	dev->udev = usb_get_dev(interface_to_usbdev(interface));
+	usb_get_dev(interface_to_usbdev(interface));
 	dev->interface = interface;
+	dev->connected = true;
 
 	/* set up the endpoint information */
 	/* use only the first bulk-in and bulk-out endpoints */
@@ -612,9 +595,7 @@ static void skel_disconnect(struct usb_interface *interface)
 	usb_deregister_dev(interface, &skel_class);
 
 	/* prevent more I/O from starting */
-	mutex_lock(&dev->io_mutex);
-	dev->interface = NULL;
-	mutex_unlock(&dev->io_mutex);
+	dev->connected = false;
 
 	usb_kill_anchored_urbs(&dev->submitted);
 
-- 
1.7.8.6

