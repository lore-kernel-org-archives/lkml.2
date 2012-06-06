Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab2FFQ12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:27:28 -0400
Received: from www84.your-server.de ([213.133.104.84]:36722 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757404Ab2FFQ10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:27:26 -0400
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de
Cc: alan@lxorguk.ukuu.org.uk, linux-usb@vger.kernel.org,
        Stefani Seibold <stefani@seibold.net>
Subject: [PATCH 09/11] Synchronize disconnect() handler with open() and release(), to fix races
Date: Wed,  6 Jun 2012 18:27:10 +0200
Message-Id: <1339000032-10313-10-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1339000032-10313-1-git-send-email-stefani@seibold.net>
References: <1339000032-10313-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

open()/release() races with disconnect() of an USB device

- The return interface pointer from usb_find_interface() could be
  already owned by an other driver and no more longer handle by the
  skeleton driver.
- The dev pointer return by usb_get_intfdata() could point to an
  already release memory.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 drivers/usb/usb-skeleton.c |   50 ++++++++++++++++++++++---------------------
 1 files changed, 26 insertions(+), 24 deletions(-)

diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
index 46c1bbb..11cc97b 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -63,13 +63,16 @@ struct usb_skel {
 	bool			connected;		/* connected flag */
 	spinlock_t		err_lock;		/* lock for errors */
 	struct kref		kref;
-	struct mutex		io_mutex;		/* synchronize I/O with disconnect */
+	struct mutex		io_mutex;		/* synchronize with disconnect */
 	struct completion	bulk_in_completion;	/* to wait for an ongoing read */
 };
 #define to_skel_dev(d) container_of(d, struct usb_skel, kref)
 
 static struct usb_driver skel_driver;
 
+/* synchronize open/release with disconnect */
+static DEFINE_MUTEX(sync_mutex);
+
 static void skel_delete(struct kref *kref)
 {
 	struct usb_skel *dev = to_skel_dev(kref);
@@ -86,6 +89,8 @@ static int skel_open(struct inode *inode, struct file *file)
 	struct usb_interface *interface;
 	int retval;
 
+	/* lock against skel_disconnect() */
+	mutex_lock(&sync_mutex);
 
 	interface = usb_find_interface(&skel_driver, iminor(inode));
 	if (!interface) {
@@ -99,22 +104,20 @@ static int skel_open(struct inode *inode, struct file *file)
 		goto exit;
 	}
 
-	/* increment our usage count for the device */
-	kref_get(&dev->kref);
-
-	/* lock the device to allow correctly handling errors
-	 * in resumption */
-	mutex_lock(&dev->io_mutex);
-
 	retval = usb_autopm_get_interface(interface);
 	if (retval)
 		goto exit;
 
+	/* increment our usage count for the device */
+	kref_get(&dev->kref);
+
+	mutex_unlock(&sync_mutex);
+
 	/* save our object in the file's private structure */
 	file->private_data = dev;
-	mutex_unlock(&dev->io_mutex);
-
+	return 0;
 exit:
+	mutex_unlock(&sync_mutex);
 	return retval;
 }
 
@@ -122,15 +125,16 @@ static int skel_release(struct inode *inode, struct file *file)
 {
 	struct usb_skel *dev = file->private_data;
 
+	/* lock against skel_disconnect() */
+	mutex_lock(&sync_mutex);
 	/* allow the device to be autosuspended */
-	mutex_lock(&dev->io_mutex);
 	if (dev->connected)
 		usb_autopm_put_interface(
 			usb_find_interface(&skel_driver, iminor(inode)));
-	mutex_unlock(&dev->io_mutex);
 
 	/* decrement the count on our device */
 	kref_put(&dev->kref, skel_delete);
+	mutex_unlock(&sync_mutex);
 	return 0;
 }
 
@@ -436,9 +440,7 @@ static ssize_t skel_write(struct file *file, const char *user_buffer,
 	}
 
 	/* this lock makes sure we don't submit URBs to gone devices */
-	mutex_lock(&dev->io_mutex);
 	if (!dev->connected) {		/* disconnect() was called */
-		mutex_unlock(&dev->io_mutex);
 		retval = -ENODEV;
 		goto error;
 	}
@@ -452,7 +454,6 @@ static ssize_t skel_write(struct file *file, const char *user_buffer,
 
 	/* send the data out the bulk port */
 	retval = usb_submit_urb(urb, GFP_KERNEL);
-	mutex_unlock(&dev->io_mutex);
 	if (retval) {
 		dev_err(&dev->udev->dev,
 			"%s - failed submitting write urb, error %d\n",
@@ -596,25 +597,26 @@ error:
 static void skel_disconnect(struct usb_interface *interface)
 {
 	struct usb_skel *dev;
-	int minor = interface->minor;
 
-	dev = usb_get_intfdata(interface);
-	usb_set_intfdata(interface, NULL);
+	dev_info(&interface->dev, "USB Skeleton disconnect #%d",
+			interface->minor);
 
 	/* give back our minor */
 	usb_deregister_dev(interface, &skel_class);
 
+	dev = usb_get_intfdata(interface);
+	usb_kill_anchored_urbs(&dev->submitted);
+
+	/* lock against skel_open() and skel_release() */
+	mutex_lock(&sync_mutex);
+	usb_set_intfdata(interface, NULL);
+
 	/* prevent more I/O from starting */
-	mutex_lock(&dev->io_mutex);
 	dev->connected = false;
-	mutex_unlock(&dev->io_mutex);
-
-	usb_kill_anchored_urbs(&dev->submitted);
 
 	/* decrement our usage count */
 	kref_put(&dev->kref, skel_delete);
-
-	dev_info(&interface->dev, "USB Skeleton #%d now disconnected", minor);
+	mutex_unlock(&sync_mutex);
 }
 
 static int skel_suspend(struct usb_interface *intf, pm_message_t message)
-- 
1.7.8.6

