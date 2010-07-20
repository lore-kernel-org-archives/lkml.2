Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761649Ab0GTUm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 16:42:56 -0400
Received: from claw.goop.org ([74.207.240.146]:50917 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761581Ab0GTUms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 16:42:48 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Xen-devel <xen-devel@lists.xensource.com>,
        Jan Beulich <jbeulich@novell.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 03/16] blkfront: don't access freed struct xenbus_device
Date: Tue, 20 Jul 2010 13:42:11 -0700
Message-Id: <e3e5dfefff0750e01788c79dda440f8b69bcb1e7.1279658433.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <cover.1279658231.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1279658231.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <355e718c3f164de385d165eb8a0594895f034ebd.1279658433.git.jeremy.fitzhardinge@citrix.com>
References: <355e718c3f164de385d165eb8a0594895f034ebd.1279658433.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Beulich <jbeulich@novell.com>

Unfortunately commit "blkfront: fixes for 'xm block-detach ... --force'"
still wasn't quite right - there was a reference to freed memory left
from blkfront_closing().

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/block/xen-blkfront.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index b1b16e5..df2bae5 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -981,13 +981,11 @@ static void blkfront_connect(struct blkfront_info *info)
  * the backend.  Once is this done, we can switch to Closed in
  * acknowledgement.
  */
-static void blkfront_closing(struct xenbus_device *dev)
+static void blkfront_closing(struct blkfront_info *info)
 {
-	struct blkfront_info *info = dev_get_drvdata(&dev->dev);
 	unsigned int minor, nr_minors;
 	unsigned long flags;
 
-	dev_dbg(&dev->dev, "blkfront_closing: %s removed\n", dev->nodename);
 
 	if (info->rq == NULL)
 		goto out;
@@ -1013,7 +1011,8 @@ static void blkfront_closing(struct xenbus_device *dev)
 	xlbd_release_minors(minor, nr_minors);
 
  out:
-	xenbus_frontend_closed(dev);
+	if (info->xbdev)
+		xenbus_frontend_closed(info->xbdev);
 }
 
 /**
@@ -1053,7 +1052,7 @@ static void blkback_changed(struct xenbus_device *dev,
 			xenbus_dev_error(dev, -EBUSY,
 					 "Device in use; refusing to close");
 		else
-			blkfront_closing(dev);
+			blkfront_closing(info);
 		mutex_unlock(&bd->bd_mutex);
 		bdput(bd);
 		break;
@@ -1071,7 +1070,7 @@ static int blkfront_remove(struct xenbus_device *dev)
 	if(info->users == 0)
 		kfree(info);
 	else
-		info->is_ready = -1;
+		info->xbdev = NULL;
 
 	return 0;
 }
@@ -1080,14 +1079,14 @@ static int blkfront_is_ready(struct xenbus_device *dev)
 {
 	struct blkfront_info *info = dev_get_drvdata(&dev->dev);
 
-	return info->is_ready > 0;
+	return info->is_ready && info->xbdev;
 }
 
 static int blkif_open(struct block_device *bdev, fmode_t mode)
 {
 	struct blkfront_info *info = bdev->bd_disk->private_data;
 
-	if(info->is_ready < 0)
+	if (!info->xbdev)
 		return -ENODEV;
 	info->users++;
 	return 0;
@@ -1102,13 +1101,13 @@ static int blkif_release(struct gendisk *disk, fmode_t mode)
 		   have ignored this request initially, as the device was
 		   still mounted. */
 		struct xenbus_device *dev = info->xbdev;
-		enum xenbus_state state = xenbus_read_driver_state(dev->otherend);
 
-		if(info->is_ready < 0) {
-			blkfront_closing(dev);
+		if (!dev) {
+			blkfront_closing(info);
 			kfree(info);
-		} else if (state == XenbusStateClosing && info->is_ready)
-			blkfront_closing(dev);
+		} else if (xenbus_read_driver_state(dev->otherend)
+			   == XenbusStateClosing && info->is_ready)
+			blkfront_closing(info);
 	}
 	return 0;
 }
-- 
1.7.1.1

