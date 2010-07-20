Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619Ab0GTUnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 16:43:33 -0400
Received: from claw.goop.org ([74.207.240.146]:50938 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761618Ab0GTUmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 16:42:50 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Xen-devel <xen-devel@lists.xensource.com>,
        Daniel Stodden <daniel.stodden@citrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 14/16] blkfront: Lock blockfront_info during xbdev removal
Date: Tue, 20 Jul 2010 13:42:22 -0700
Message-Id: <95e2d7dba563709962f8ba02b707208dc875f2ed.1279658433.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <cover.1279658231.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1279658231.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <355e718c3f164de385d165eb8a0594895f034ebd.1279658433.git.jeremy.fitzhardinge@citrix.com>
References: <355e718c3f164de385d165eb8a0594895f034ebd.1279658433.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Stodden <daniel.stodden@citrix.com>

Same approach as blkfront_closing:
 * Grab the bdev safely, holding the info mutex.
 * Zap xbdev safely, holding the info mutex.
 * Try bdev removal safely, holding bd_mutex.

Signed-off-by: Daniel Stodden <daniel.stodden@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/block/xen-blkfront.c |   41 +++++++++++++++++++++++++++++++++++------
 1 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 214c92e..96ff225 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1093,18 +1093,47 @@ static void blkback_changed(struct xenbus_device *dev,
 	}
 }
 
-static int blkfront_remove(struct xenbus_device *dev)
+static int blkfront_remove(struct xenbus_device *xbdev)
 {
-	struct blkfront_info *info = dev_get_drvdata(&dev->dev);
+	struct blkfront_info *info = dev_get_drvdata(&xbdev->dev);
+	struct block_device *bdev = NULL;
+	struct gendisk *disk;
 
-	dev_dbg(&dev->dev, "blkfront_remove: %s removed\n", dev->nodename);
+	dev_dbg(&xbdev->dev, "%s removed", xbdev->nodename);
 
 	blkif_free(info, 0);
 
-	if(info->users == 0)
+	mutex_lock(&info->mutex);
+
+	disk = info->gd;
+	if (disk)
+		bdev = bdget_disk(disk, 0);
+
+	info->xbdev = NULL;
+	mutex_unlock(&info->mutex);
+
+	if (!bdev) {
+		kfree(info);
+		return 0;
+	}
+
+	/*
+	 * The xbdev was removed before we reached the Closed
+	 * state. See if it's safe to remove the disk. If the bdev
+	 * isn't closed yet, we let release take care of it.
+	 */
+
+	mutex_lock(&bdev->bd_mutex);
+	info = disk->private_data;
+
+	if (info && !info->users) {
+		xlvbd_release_gendisk(info);
+		disk->private_data = NULL;
 		kfree(info);
-	else
-		info->xbdev = NULL;
+	}
+
+	mutex_unlock(&bdev->bd_mutex);
+	bdput(bdev);
 
 	return 0;
 }
-- 
1.7.1.1

