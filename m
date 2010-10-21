Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab0JUAu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 20:50:27 -0400
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:41137 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752039Ab0JUAu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 20:50:26 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/21] fs: switch bdev inode bdi's correctly
Date: Thu, 21 Oct 2010 11:49:26 +1100
Message-Id: <1287622186-1935-2-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287622186-1935-1-git-send-email-david@fromorbit.com>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

bdev inodes can remain dirty even after their last close. Hence the
BDI associated with the bdev->inode gets modified duringthe last
close to point to the default BDI. However, the bdev inode still
needs to be moved to the dirty lists of the new BDI, otherwise it
will corrupt the writeback list is was left on.

Add a new function bdev_inode_switch_bdi() to move all the bdi state
from the old bdi to the new one safely. This is only a temporary
measure until the bdev inode<->bdi lifecycle problems are sorted
out.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/block_dev.c |   26 +++++++++++++++++++++-----
 1 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 50e8c85..501eab5 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -48,6 +48,21 @@ inline struct block_device *I_BDEV(struct inode *inode)
 
 EXPORT_SYMBOL(I_BDEV);
 
+/*
+ * move the inode from it's current bdi to the a new bdi. if the inode is dirty
+ * we need to move it onto the dirty list of @dst so that the inode is always
+ * on the right list.
+ */
+static void bdev_inode_switch_bdi(struct inode *inode,
+			struct backing_dev_info *dst)
+{
+	spin_lock(&inode_lock);
+	inode->i_data.backing_dev_info = dst;
+	if (inode->i_state & I_DIRTY)
+		list_move(&inode->i_list, &dst->wb.b_dirty);
+	spin_unlock(&inode_lock);
+}
+
 static sector_t max_block(struct block_device *bdev)
 {
 	sector_t retval = ~((sector_t)0);
@@ -1390,7 +1405,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 				bdi = blk_get_backing_dev_info(bdev);
 				if (bdi == NULL)
 					bdi = &default_backing_dev_info;
-				bdev->bd_inode->i_data.backing_dev_info = bdi;
+				bdev_inode_switch_bdi(bdev->bd_inode, bdi);
 			}
 			if (bdev->bd_invalidated)
 				rescan_partitions(disk, bdev);
@@ -1405,8 +1420,8 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 			if (ret)
 				goto out_clear;
 			bdev->bd_contains = whole;
-			bdev->bd_inode->i_data.backing_dev_info =
-			   whole->bd_inode->i_data.backing_dev_info;
+			bdev_inode_switch_bdi(bdev->bd_inode,
+				whole->bd_inode->i_data.backing_dev_info);
 			bdev->bd_part = disk_get_part(disk, partno);
 			if (!(disk->flags & GENHD_FL_UP) ||
 			    !bdev->bd_part || !bdev->bd_part->nr_sects) {
@@ -1439,7 +1454,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 	disk_put_part(bdev->bd_part);
 	bdev->bd_disk = NULL;
 	bdev->bd_part = NULL;
-	bdev->bd_inode->i_data.backing_dev_info = &default_backing_dev_info;
+	bdev_inode_switch_bdi(bdev->bd_inode, &default_backing_dev_info);
 	if (bdev != bdev->bd_contains)
 		__blkdev_put(bdev->bd_contains, mode, 1);
 	bdev->bd_contains = NULL;
@@ -1533,7 +1548,8 @@ static int __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
 		disk_put_part(bdev->bd_part);
 		bdev->bd_part = NULL;
 		bdev->bd_disk = NULL;
-		bdev->bd_inode->i_data.backing_dev_info = &default_backing_dev_info;
+		bdev_inode_switch_bdi(bdev->bd_inode,
+					&default_backing_dev_info);
 		if (bdev != bdev->bd_contains)
 			victim = bdev->bd_contains;
 		bdev->bd_contains = NULL;
-- 
1.7.1

