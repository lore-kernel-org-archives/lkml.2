Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab2FHHSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 03:18:37 -0400
Received: from www84.your-server.de ([213.133.104.84]:59562 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726Ab2FHHSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 03:18:35 -0400
Message-ID: <1339139935.16819.5.camel@wall-e>
Subject: RFC: remove usb_device pointer from usb_skeleton.c
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, oneukum@suse.de,
        alan@lxorguk.ukuu.org.uk, linux-usb@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>
Date: Fri, 08 Jun 2012 09:18:55 +0200
In-Reply-To: <1339098621.13885.13.camel@wall-e>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

what do you think about this solution for removing the usb_device
pointer from the struct usb_skel in the usb_skeleton driver?

diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
index 1e36782..af698b3 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -47,7 +47,6 @@ MODULE_DEVICE_TABLE(usb, skel_table);
 
 /* Structure to hold all of our device specific stuff */
 struct usb_skel {
-	struct usb_device	*udev;			/* the usb device for this device */
 	struct usb_interface	*interface;		/* the interface for this device */
 	struct semaphore	limit_sem;		/* limiting the number of writes in progress */
 	struct usb_anchor	submitted;		/* in case we need to retract our submissions */
@@ -61,6 +60,7 @@ struct usb_skel {
 	int			errors;			/* the last request tanked */
 	bool			ongoing_read;		/* a read is going on */
 	bool			in_use;			/* in use flag */
+	bool			connected;		/* connected flag */
 	spinlock_t		err_lock;		/* lock for errors */
 	struct kref		kref;
 	struct mutex		io_mutex;		/* synchronize I/O with disconnect */
@@ -73,9 +73,12 @@ static struct usb_driver skel_driver;
 static void skel_delete(struct kref *kref)
 {
 	struct usb_skel *dev = to_skel_dev(kref);
+	struct usb_interface *interface = dev->interface;
+	struct usb_device *udev = usb_get_dev(interface_to_usbdev(interface));
 
 	usb_free_urb(dev->bulk_in_urb);
-	usb_put_dev(dev->udev);
+	usb_put_dev(udev);
+	usb_put_intf(interface);
 	kfree(dev->bulk_in_buffer);
 	kfree(dev);
 }
@@ -128,7 +131,7 @@ static int skel_release(struct inode *inode, struct file *file)
 
 	/* allow the device to be autosuspended */
 	mutex_lock(&dev->io_mutex);
-	if (dev->interface)
+	if (dev->connected)
 		usb_autopm_put_interface(dev->interface);
 	dev->in_use = false;
 	mutex_unlock(&dev->io_mutex);
@@ -155,7 +158,7 @@ static int skel_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 
 	/* wait for io to stop */
 	mutex_lock(&dev->io_mutex);
-	if (!dev->interface) {		/* disconnect() was called */
+	if (!dev->connected) {		/* disconnect() was called */
 		retval = -ENODEV;
 		goto exit;
 	}
@@ -206,11 +209,12 @@ static void skel_read_bulk_callback(struct urb *urb)
 static int skel_do_read_io(struct usb_skel *dev, size_t count)
 {
 	int retval;
+	struct usb_device *udev = usb_get_dev(interface_to_usbdev(dev->interface));
 
 	/* prepare a read */
 	usb_fill_bulk_urb(dev->bulk_in_urb,
-			dev->udev,
-			usb_rcvbulkpipe(dev->udev,
+			udev,
+			usb_rcvbulkpipe(udev,
 				dev->bulk_in_endpointAddr),
 			dev->bulk_in_buffer,
 			min(dev->bulk_in_size, count),
@@ -258,7 +262,7 @@ static ssize_t skel_read(struct file *file, char *buffer, size_t count,
 			return retval;
 	}
 
-	if (!dev->interface) {		/* disconnect() was called */
+	if (!dev->connected) {		/* disconnect() was called */
 		retval = -ENODEV;
 		goto exit;
 	}
@@ -391,6 +395,7 @@ static ssize_t skel_write(struct file *file, const char *user_buffer,
 	struct urb *urb = NULL;
 	char *buf = NULL;
 	size_t writesize = min(count, (size_t)MAX_TRANSFER);
+	struct usb_device *udev = usb_get_dev(interface_to_usbdev(dev->interface));
 
 	/* verify that we actually have some data to write */
 	if (!count)
@@ -427,7 +432,7 @@ static ssize_t skel_write(struct file *file, const char *user_buffer,
 		goto error;
 	}
 
-	buf = usb_alloc_coherent(dev->udev, writesize, GFP_KERNEL,
+	buf = usb_alloc_coherent(udev, writesize, GFP_KERNEL,
 				 &urb->transfer_dma);
 	if (!buf) {
 		retval = -ENOMEM;
@@ -441,15 +446,15 @@ static ssize_t skel_write(struct file *file, const char *user_buffer,
 
 	/* this lock makes sure we don't submit URBs to gone devices */
 	mutex_lock(&dev->io_mutex);
-	if (!dev->interface) {		/* disconnect() was called */
+	if (!dev->connected) {		/* disconnect() was called */
 		mutex_unlock(&dev->io_mutex);
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
@@ -477,7 +482,7 @@ error_unanchor:
 	usb_unanchor_urb(urb);
 error:
 	if (urb) {
-		usb_free_coherent(dev->udev, writesize, buf, urb->transfer_dma);
+		usb_free_coherent(udev, writesize, buf, urb->transfer_dma);
 		usb_free_urb(urb);
 	}
 	up(&dev->limit_sem);
@@ -529,9 +534,10 @@ static int skel_probe(struct usb_interface *interface,
 	init_usb_anchor(&dev->submitted);
 	init_completion(&dev->bulk_in_completion);
 
-	dev->udev = usb_get_dev(interface_to_usbdev(interface));
-	dev->interface = interface;
+	usb_get_dev(interface_to_usbdev(interface));
+	dev->interface = usb_get_intf(interface);
 	dev->in_use = false;
+	dev->connected = true;
 
 	/* set up the endpoint information */
 	/* use only the first bulk-in and bulk-out endpoints */
@@ -610,7 +616,7 @@ static void skel_disconnect(struct usb_interface *interface)
 
 	/* prevent more I/O from starting */
 	mutex_lock(&dev->io_mutex);
-	dev->interface = NULL;
+	dev->connected = false;
 	mutex_unlock(&dev->io_mutex);
 
 	usb_kill_anchored_urbs(&dev->submitted);


The connected flag could be also replaced by a "intf->condition ==
USB_INTERFACE_BOUND", which can be hided by a macro.

Regards,
Stefani


