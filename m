Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761725Ab0GTUnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 16:43:18 -0400
Received: from claw.goop.org ([74.207.240.146]:50927 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761591Ab0GTUmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 16:42:50 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Xen-devel <xen-devel@lists.xensource.com>,
        Daniel Stodden <daniel.stodden@citrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 11/16] blkfront: Lock blkfront_info when closing
Date: Tue, 20 Jul 2010 13:42:19 -0700
Message-Id: <6c66a11e91acae95cda631fd406304cb56b1c710.1279658433.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <cover.1279658231.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1279658231.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <355e718c3f164de385d165eb8a0594895f034ebd.1279658433.git.jeremy.fitzhardinge@citrix.com>
References: <355e718c3f164de385d165eb8a0594895f034ebd.1279658433.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Stodden <daniel.stodden@citrix.com>

The bdev .open/.release fops race against backend switches to Closing,
handled by the XenBus thread.

The original code attempted to serialize block device holders and
xenbus only via bd_mutex. This is insufficient, the info->bd pointer
may already be stale (or null) while xenbus tries to bump up the
refcount.

Protect blkfront_info with a dedicated mutex.

Signed-off-by: Daniel Stodden <daniel.stodden@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/block/xen-blkfront.c |   61 +++++++++++++++++++++++++++--------------
 1 files changed, 40 insertions(+), 21 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 7b03b48..1046a58 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -78,6 +78,7 @@ static const struct block_device_operations xlvbd_block_fops;
  */
 struct blkfront_info
 {
+	struct mutex mutex;
 	struct xenbus_device *xbdev;
 	struct gendisk *gd;
 	int vdevice;
@@ -804,7 +805,6 @@ again:
 	return err;
 }
 
-
 /**
  * Entry point to this code when a new device is created.  Allocate the basic
  * structures and the ring buffer for communication with the backend, and
@@ -836,6 +836,7 @@ static int blkfront_probe(struct xenbus_device *dev,
 		return -ENOMEM;
 	}
 
+	mutex_init(&info->mutex);
 	info->xbdev = dev;
 	info->vdevice = vdevice;
 	info->connected = BLKIF_STATE_DISCONNECTED;
@@ -951,6 +952,43 @@ static int blkfront_resume(struct xenbus_device *dev)
 	return err;
 }
 
+static void
+blkfront_closing(struct blkfront_info *info)
+{
+	struct xenbus_device *xbdev = info->xbdev;
+	struct block_device *bdev = NULL;
+
+	mutex_lock(&info->mutex);
+
+	if (xbdev->state == XenbusStateClosing) {
+		mutex_unlock(&info->mutex);
+		return;
+	}
+
+	if (info->gd)
+		bdev = bdget_disk(info->gd, 0);
+
+	mutex_unlock(&info->mutex);
+
+	if (!bdev) {
+		xenbus_frontend_closed(xbdev);
+		return;
+	}
+
+	mutex_lock(&bdev->bd_mutex);
+
+	if (info->users) {
+		xenbus_dev_error(xbdev, -EBUSY,
+				 "Device in use; refusing to close");
+		xenbus_switch_state(xbdev, XenbusStateClosing);
+	} else {
+		xlvbd_release_gendisk(info);
+		xenbus_frontend_closed(xbdev);
+	}
+
+	mutex_unlock(&bdev->bd_mutex);
+	bdput(bdev);
+}
 
 /*
  * Invoked when the backend is finally 'ready' (and has told produced
@@ -1034,7 +1072,6 @@ static void blkback_changed(struct xenbus_device *dev,
 			    enum xenbus_state backend_state)
 {
 	struct blkfront_info *info = dev_get_drvdata(&dev->dev);
-	struct block_device *bd;
 
 	dev_dbg(&dev->dev, "blkfront:blkback_changed to state %d.\n", backend_state);
 
@@ -1051,25 +1088,7 @@ static void blkback_changed(struct xenbus_device *dev,
 		break;
 
 	case XenbusStateClosing:
-		if (info->gd == NULL) {
-			xenbus_frontend_closed(dev);
-			break;
-		}
-		bd = bdget_disk(info->gd, 0);
-		if (bd == NULL)
-			xenbus_dev_fatal(dev, -ENODEV, "bdget failed");
-
-		mutex_lock(&bd->bd_mutex);
-		if (info->users > 0)
-			xenbus_dev_error(dev, -EBUSY,
-					 "Device in use; refusing to close");
-		else {
-			xlvbd_release_gendisk(info);
-			xenbus_frontend_closed(info->xbdev);
-		}
-
-		mutex_unlock(&bd->bd_mutex);
-		bdput(bd);
+		blkfront_closing(info);
 		break;
 	}
 }
-- 
1.7.1.1

