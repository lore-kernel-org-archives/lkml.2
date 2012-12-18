Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab2LRBNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 20:13:16 -0500
Received: from order.stressinduktion.org ([87.106.68.36]:36695 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab2LRBNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 20:13:11 -0500
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: linux-kernel@vger.kernel.org
Cc: npiggin@kernel.dk, Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: [PATCH v2 2/4] brd: check for open partitions when BLKFLSBUFing a ram disk
Date: Tue, 18 Dec 2012 02:13:05 +0100
Message-Id: <1355793187-2638-3-git-send-email-hannes@stressinduktion.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1355793187-2638-1-git-send-email-hannes@stressinduktion.org>
References: <1355793187-2638-1-git-send-email-hannes@stressinduktion.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Users of partitions on ram disks could accidentally flush the block
device with ioctl(BLKFLSBUF) while it is in use. This patch prevents
this from happening.

This patch also adds a call to rescan_partitions after BLKFLSBUFing,
for which a EXPORT_SYMBOL_GPL statement was needed. Otherwise some kind
of use-after-free could happen.

After this change BLKFLSBUFing on partitions of a ram disk is never
possible.

Cc: Nick Piggin <npiggin@kernel.dk>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
---
 block/partition-generic.c |  1 +
 drivers/block/brd.c       | 20 +++++++++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/block/partition-generic.c b/block/partition-generic.c
index f1d1451..cd7bc10 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -528,6 +528,7 @@ rescan:
 	kfree(state);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(rescan_partitions);
 
 int invalidate_partitions(struct gendisk *disk, struct block_device *bdev)
 {
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 70ad8dc..80dd094 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -385,6 +385,13 @@ static int brd_direct_access(struct block_device *bdev, sector_t sector,
 }
 #endif
 
+static int brd_blkdev_in_use(struct block_device *bdev)
+{
+	lockdep_assert_held(&bdev->bd_mutex);
+	return bdev->bd_part_count > 0
+		|| bdev->bd_openers > 1;
+}
+
 static int brd_ioctl(struct block_device *bdev, fmode_t mode,
 			unsigned int cmd, unsigned long arg)
 {
@@ -399,9 +406,15 @@ static int brd_ioctl(struct block_device *bdev, fmode_t mode,
 	 * release and destroy the ramdisk data.
 	 */
 	mutex_lock(&brd_mutex);
+	if (bdget_disk(brd->brd_disk, 0) != bdev) {
+		error = -EBUSY;
+		goto out;
+	}
 	mutex_lock(&bdev->bd_mutex);
-	error = -EBUSY;
-	if (bdev->bd_openers <= 1) {
+	error = brd_blkdev_in_use(bdev);
+	if (error) {
+		error = -EBUSY;
+	} else {
 		/*
 		 * Kill the cache first, so it isn't written back to the
 		 * device.
@@ -411,9 +424,10 @@ static int brd_ioctl(struct block_device *bdev, fmode_t mode,
 		 */
 		kill_bdev(bdev);
 		brd_free_pages(brd);
-		error = 0;
+		error = rescan_partitions(brd->brd_disk, bdev);
 	}
 	mutex_unlock(&bdev->bd_mutex);
+out:
 	mutex_unlock(&brd_mutex);
 
 	return error;
-- 
1.8.0.2

