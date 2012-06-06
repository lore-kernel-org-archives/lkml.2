Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432Ab2FFQ2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:28:53 -0400
Received: from www84.your-server.de ([213.133.104.84]:36693 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757272Ab2FFQ1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:27:22 -0400
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de
Cc: alan@lxorguk.ukuu.org.uk, linux-usb@vger.kernel.org,
        Stefani Seibold <stefani@seibold.net>
Subject: [PATCH 04/11] remove usb_interface pointer
Date: Wed,  6 Jun 2012 18:27:05 +0200
Message-Id: <1339000032-10313-5-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1339000032-10313-1-git-send-email-stefani@seibold.net>
References: <1339000032-10313-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

this saves a litte bit of memory space in the driver devices structure

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 drivers/usb/usb-skeleton.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
index 2f17991..f7fe32f 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -49,7 +49,6 @@ MODULE_DEVICE_TABLE(usb, skel_table);
 /* Structure to hold all of our device specific stuff */
 struct usb_skel {
 	struct usb_device	*udev;			/* the usb device for this device */
-	struct usb_interface	*interface;		/* the interface for this device */
 	struct semaphore	limit_sem;		/* limiting the number of writes in progress */
 	struct usb_anchor	submitted;		/* in case we need to retract our submissions */
 	struct urb		*bulk_in_urb;		/* the urb to read data with */
@@ -61,6 +60,7 @@ struct usb_skel {
 	__u8			bulk_out_endpointAddr;	/* the address of the bulk out endpoint */
 	int			errors;			/* the last request tanked */
 	bool			ongoing_read;		/* a read is going on */
+	bool			connected;		/* connected flag */
 	spinlock_t		err_lock;		/* lock for errors */
 	struct kref		kref;
 	struct mutex		io_mutex;		/* synchronize I/O with disconnect */
@@ -129,8 +129,9 @@ static int skel_release(struct inode *inode, struct file *file)
 
 	/* allow the device to be autosuspended */
 	mutex_lock(&dev->io_mutex);
-	if (dev->interface)
-		usb_autopm_put_interface(dev->interface);
+	if (dev->connected)
+		usb_autopm_put_interface(
+			usb_find_interface(&skel_driver, iminor(inode)));
 	mutex_unlock(&dev->io_mutex);
 
 	/* decrement the count on our device */
@@ -170,7 +171,7 @@ static void skel_read_bulk_callback(struct urb *urb)
 		if (!(urb->status == -ENOENT ||
 		    urb->status == -ECONNRESET ||
 		    urb->status == -ESHUTDOWN))
-			dev_err(&dev->interface->dev,
+			dev_err(&urb->dev->dev,
 				"%s - nonzero write bulk status received: %d\n",
 				__func__, urb->status);
 
@@ -205,7 +206,7 @@ static int skel_do_read_io(struct usb_skel *dev, size_t count)
 	/* do it */
 	retval = usb_submit_urb(dev->bulk_in_urb, GFP_KERNEL);
 	if (retval < 0) {
-		dev_err(&dev->interface->dev,
+		dev_err(&dev->udev->dev,
 			"%s - failed submitting read urb, error %d\n",
 			__func__, retval);
 		dev->bulk_in_filled = 0;
@@ -234,7 +235,7 @@ static ssize_t skel_read(struct file *file, char *buffer, size_t count,
 	if (retval < 0)
 		return retval;
 
-	if (!dev->interface) {		/* disconnect() was called */
+	if (!dev->connected) {		/* disconnect() was called */
 		retval = -ENODEV;
 		goto exit;
 	}
@@ -344,7 +345,7 @@ static void skel_write_bulk_callback(struct urb *urb)
 		if (!(urb->status == -ENOENT ||
 		    urb->status == -ECONNRESET ||
 		    urb->status == -ESHUTDOWN))
-			dev_err(&dev->interface->dev,
+			dev_err(&urb->dev->dev,
 				"%s - nonzero write bulk status received: %d\n",
 				__func__, urb->status);
 
@@ -421,7 +422,7 @@ static ssize_t skel_write(struct file *file, const char *user_buffer,
 
 	/* this lock makes sure we don't submit URBs to gone devices */
 	mutex_lock(&dev->io_mutex);
-	if (!dev->interface) {		/* disconnect() was called */
+	if (!dev->connected) {		/* disconnect() was called */
 		mutex_unlock(&dev->io_mutex);
 		retval = -ENODEV;
 		goto error;
@@ -438,7 +439,7 @@ static ssize_t skel_write(struct file *file, const char *user_buffer,
 	retval = usb_submit_urb(urb, GFP_KERNEL);
 	mutex_unlock(&dev->io_mutex);
 	if (retval) {
-		dev_err(&dev->interface->dev,
+		dev_err(&dev->udev->dev,
 			"%s - failed submitting write urb, error %d\n",
 			__func__, retval);
 		goto error_unanchor;
@@ -510,7 +511,7 @@ static int skel_probe(struct usb_interface *interface,
 	init_completion(&dev->bulk_in_completion);
 
 	dev->udev = usb_get_dev(interface_to_usbdev(interface));
-	dev->interface = interface;
+	dev->connected = true;
 
 	/* set up the endpoint information */
 	/* use only the first bulk-in and bulk-out endpoints */
@@ -589,7 +590,7 @@ static void skel_disconnect(struct usb_interface *interface)
 
 	/* prevent more I/O from starting */
 	mutex_lock(&dev->io_mutex);
-	dev->interface = NULL;
+	dev->connected = false;
 	mutex_unlock(&dev->io_mutex);
 
 	usb_kill_anchored_urbs(&dev->submitted);
-- 
1.7.8.6

