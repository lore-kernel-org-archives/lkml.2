Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab2FFQa4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:30:56 -0400
Received: from www84.your-server.de ([213.133.104.84]:36968 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175Ab2FFQaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:30:55 -0400
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de
Cc: alan@lxorguk.ukuu.org.uk, linux-usb@vger.kernel.org,
        Stefani Seibold <stefani@seibold.net>
Subject: [PATCH 10/11] Introduce single user mode
Date: Wed,  6 Jun 2012 18:27:11 +0200
Message-Id: <1339000032-10313-11-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1339000032-10313-1-git-send-email-stefani@seibold.net>
References: <1339000032-10313-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

Most USB devices can only used in a single usage mode. This patch
prevents a reopening on an already opened device.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 drivers/usb/usb-skeleton.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
index 11cc97b..81d256f 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -61,6 +61,7 @@ struct usb_skel {
 	int			errors;			/* the last request tanked */
 	bool			ongoing_read;		/* a read is going on */
 	bool			connected;		/* connected flag */
+	bool			in_use;			/* in use flag */
 	spinlock_t		err_lock;		/* lock for errors */
 	struct kref		kref;
 	struct mutex		io_mutex;		/* synchronize with disconnect */
@@ -104,6 +105,11 @@ static int skel_open(struct inode *inode, struct file *file)
 		goto exit;
 	}
 
+	if (dev->in_use) {
+		retval = -EBUSY;
+		goto exit;
+	}
+
 	retval = usb_autopm_get_interface(interface);
 	if (retval)
 		goto exit;
@@ -111,6 +117,7 @@ static int skel_open(struct inode *inode, struct file *file)
 	/* increment our usage count for the device */
 	kref_get(&dev->kref);
 
+	dev->in_use = true;
 	mutex_unlock(&sync_mutex);
 
 	/* save our object in the file's private structure */
@@ -131,6 +138,7 @@ static int skel_release(struct inode *inode, struct file *file)
 	if (dev->connected)
 		usb_autopm_put_interface(
 			usb_find_interface(&skel_driver, iminor(inode)));
+	dev->in_use = false;
 
 	/* decrement the count on our device */
 	kref_put(&dev->kref, skel_delete);
@@ -529,6 +537,7 @@ static int skel_probe(struct usb_interface *interface,
 
 	dev->udev = usb_get_dev(interface_to_usbdev(interface));
 	dev->connected = true;
+	dev->in_use = false;
 
 	/* set up the endpoint information */
 	/* use only the first bulk-in and bulk-out endpoints */
-- 
1.7.8.6

