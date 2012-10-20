Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab2JTScw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 14:32:52 -0400
Received: from order.stressinduktion.org ([87.106.68.36]:60880 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490Ab2JTSc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 14:32:27 -0400
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: linux-kernel@vger.kernel.org
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Nick Piggin <npiggin@kernel.dk>
Subject: [PATCH 2/4] brd: check for open partitions when BLKFLSBUFing a ram disk
Date: Sat, 20 Oct 2012 20:32:21 +0200
Message-Id: <1350757943-24981-3-git-send-email-hannes@stressinduktion.org>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1350757943-24981-1-git-send-email-hannes@stressinduktion.org>
References: <1350757943-24981-1-git-send-email-hannes@stressinduktion.org>
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
index c4965f5..ce1255c 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -385,6 +385,13 @@ static int brd_direct_access(struct block_device *bdev, sector_t sector,
 }
 #endif
 
+static int brd_blkdev_in_use(struct block_device *bdev)
+{
+        lockdep_assert_held(&bdev->bd_mutex);
+        return bdev->bd_part_count > 0
+                || bdev->bd_openers > 1;
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
1.7.12.4

