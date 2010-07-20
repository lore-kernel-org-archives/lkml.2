Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676Ab0GTUpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 16:45:24 -0400
Received: from claw.goop.org ([74.207.240.146]:50955 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761615Ab0GTUmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 16:42:50 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Xen-devel <xen-devel@lists.xensource.com>,
        Daniel Stodden <daniel.stodden@citrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 15/16] blkfront: Remove obsolete info->users
Date: Tue, 20 Jul 2010 13:42:23 -0700
Message-Id: <6172b98d328f8fff80091a234671ff3016228229.1279658433.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <cover.1279658231.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1279658231.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <355e718c3f164de385d165eb8a0594895f034ebd.1279658433.git.jeremy.fitzhardinge@citrix.com>
References: <355e718c3f164de385d165eb8a0594895f034ebd.1279658433.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Stodden <daniel.stodden@citrix.com>

This is just bd_openers, protected by the bd_mutex.

Signed-off-by: Daniel Stodden <daniel.stodden@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/block/xen-blkfront.c |   19 +++++--------------
 1 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 96ff225..2c8de1b 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -95,12 +95,6 @@ struct blkfront_info
 	unsigned long shadow_free;
 	int feature_barrier;
 	int is_ready;
-
-	/**
-	 * The number of people holding this device open.  We won't allow a
-	 * hot-unplug unless this is 0.
-	 */
-	int users;
 };
 
 static DEFINE_SPINLOCK(blkif_io_lock);
@@ -977,7 +971,7 @@ blkfront_closing(struct blkfront_info *info)
 
 	mutex_lock(&bdev->bd_mutex);
 
-	if (info->users) {
+	if (bdev->bd_openers) {
 		xenbus_dev_error(xbdev, -EBUSY,
 				 "Device in use; refusing to close");
 		xenbus_switch_state(xbdev, XenbusStateClosing);
@@ -1126,7 +1120,7 @@ static int blkfront_remove(struct xenbus_device *xbdev)
 	mutex_lock(&bdev->bd_mutex);
 	info = disk->private_data;
 
-	if (info && !info->users) {
+	if (info && !bdev->bd_openers) {
 		xlvbd_release_gendisk(info);
 		disk->private_data = NULL;
 		kfree(info);
@@ -1164,9 +1158,6 @@ static int blkif_open(struct block_device *bdev, fmode_t mode)
 
 	mutex_unlock(&info->mutex);
 
-	if (!err)
-		++info->users;
-
 	return err;
 }
 
@@ -1176,12 +1167,12 @@ static int blkif_release(struct gendisk *disk, fmode_t mode)
 	struct block_device *bdev;
 	struct xenbus_device *xbdev;
 
-	if (--info->users)
-		return 0;
-
 	bdev = bdget_disk(disk, 0);
 	bdput(bdev);
 
+	if (bdev->bd_openers)
+		return 0;
+
 	/*
 	 * Check if we have been instructed to close. We will have
 	 * deferred this request, because the bdev was still open.
-- 
1.7.1.1

