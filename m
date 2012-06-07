Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000Ab2FGIbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 04:31:47 -0400
Received: from www84.your-server.de ([213.133.104.84]:40734 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760016Ab2FGIbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 04:31:45 -0400
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de
Cc: linux-usb@vger.kernel.org, Stefani Seibold <stefani@seibold.net>
Subject: [PATCH 12/13] Introduce single user mode
Date: Thu,  7 Jun 2012 10:20:42 +0200
Message-Id: <1339057243-10029-13-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1339057243-10029-1-git-send-email-stefani@seibold.net>
References: <1339057243-10029-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

Most USB devices can only used in a single usage mode. This patch prevents a
reopening on an already opened device.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 drivers/usb/usb-skeleton.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
index 551fb51..456c9a8 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -59,6 +59,7 @@ struct usb_skel {
 	__u8			bulk_out_endpointAddr;	/* the address of the bulk out endpoint */
 	int			errors;			/* the last request tanked */
 	bool			ongoing_read;		/* a read is going on */
+	bool			in_use;			/* in use flag */
 	spinlock_t		err_lock;		/* lock for errors */
 	struct kref		kref;
 	struct mutex		io_mutex;		/* synchronize I/O with disconnect */
@@ -92,17 +93,28 @@ static int skel_open(struct inode *inode, struct file *file)
 	if (!dev)
 		return -ENODEV;
 
+	mutex_lock(&dev->io_mutex);
+	if (dev->in_use) {
+		mutex_unlock(&dev->io_mutex);
+		return -EBUSY;
+	}
+
 	/*
 	 * must be not locked since a disconnect waits in usb_deregister_dev()
 	 * due the already locked minor_rwsem in the usb_open() function
 	 */
 	retval = usb_autopm_get_interface(interface);
-	if (!retval)
+	if (!retval) {
+		mutex_unlock(&dev->io_mutex);
 		return retval;
+	}
 
 	/* increment our usage count for the device */
 	kref_get(&dev->kref);
 
+	dev->in_use = true;
+	mutex_unlock(&dev->io_mutex);
+
 	/* save our object in the file's private structure */
 	file->private_data = dev;
 
@@ -117,6 +129,7 @@ static int skel_release(struct inode *inode, struct file *file)
 	mutex_lock(&dev->io_mutex);
 	if (dev->interface)
 		usb_autopm_put_interface(dev->interface);
+	dev->in_use = false;
 	mutex_unlock(&dev->io_mutex);
 
 	/* decrement the count on our device */
@@ -517,6 +530,7 @@ static int skel_probe(struct usb_interface *interface,
 
 	dev->udev = usb_get_dev(interface_to_usbdev(interface));
 	dev->interface = interface;
+	dev->in_use = false;
 
 	/* set up the endpoint information */
 	/* use only the first bulk-in and bulk-out endpoints */
-- 
1.7.8.6

