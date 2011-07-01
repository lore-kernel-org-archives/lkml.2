Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab1GAKIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 06:08:53 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60730 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568Ab1GAKIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 06:08:51 -0400
From: Chris Forbes <chrisf@ijw.co.nz>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Chris Forbes <chrisf@ijw.co.nz>
Subject: [PATCH v3] block: ioctl: Fixed coding style issues.
Date: Fri,  1 Jul 2011 22:08:39 +1200
Message-Id: <1309514919-31528-1-git-send-email-chrisf@ijw.co.nz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309514299.7277.30.camel@Joe-Laptop>
References: <1309514299.7277.30.camel@Joe-Laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issues as flagged by checkpatch.pl
Corrected error in previous version of patch.

Signed-off-by: Chris Forbes <chrisf@ijw.co.nz>
---
 block/ioctl.c |  122 +++++++++++++++++++++++++++++----------------------------
 1 files changed, 62 insertions(+), 60 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index 1124cd2..729bfac 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -6,9 +6,10 @@
 #include <linux/backing-dev.h>
 #include <linux/buffer_head.h>
 #include <linux/blktrace_api.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
-static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user *arg)
+static int blkpg_ioctl(struct block_device *bdev,
+			struct blkpg_ioctl_arg __user *arg)
 {
 	struct block_device *bdevp;
 	struct gendisk *disk;
@@ -31,68 +32,69 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 	partno = p.pno;
 	if (partno <= 0)
 		return -EINVAL;
+
 	switch (a.op) {
-		case BLKPG_ADD_PARTITION:
-			start = p.start >> 9;
-			length = p.length >> 9;
-			/* check for fit in a hd_struct */ 
-			if (sizeof(sector_t) == sizeof(long) && 
-			    sizeof(long long) > sizeof(long)) {
-				long pstart = start, plength = length;
-				if (pstart != start || plength != length
-				    || pstart < 0 || plength < 0)
-					return -EINVAL;
-			}
+	case BLKPG_ADD_PARTITION:
+		start = p.start >> 9;
+		length = p.length >> 9;
+		/* check for fit in a hd_struct */
+		if (sizeof(sector_t) == sizeof(long) &&
+		    sizeof(long long) > sizeof(long)) {
+			long pstart = start, plength = length;
+			if (pstart != start || plength != length
+			    || pstart < 0 || plength < 0)
+				return -EINVAL;
+		}
 
-			mutex_lock(&bdev->bd_mutex);
-
-			/* overlap? */
-			disk_part_iter_init(&piter, disk,
-					    DISK_PITER_INCL_EMPTY);
-			while ((part = disk_part_iter_next(&piter))) {
-				if (!(start + length <= part->start_sect ||
-				      start >= part->start_sect + part->nr_sects)) {
-					disk_part_iter_exit(&piter);
-					mutex_unlock(&bdev->bd_mutex);
-					return -EBUSY;
-				}
-			}
-			disk_part_iter_exit(&piter);
-
-			/* all seems OK */
-			part = add_partition(disk, partno, start, length,
-					     ADDPART_FLAG_NONE, NULL);
-			mutex_unlock(&bdev->bd_mutex);
-			return IS_ERR(part) ? PTR_ERR(part) : 0;
-		case BLKPG_DEL_PARTITION:
-			part = disk_get_part(disk, partno);
-			if (!part)
-				return -ENXIO;
-
-			bdevp = bdget(part_devt(part));
-			disk_put_part(part);
-			if (!bdevp)
-				return -ENOMEM;
-
-			mutex_lock(&bdevp->bd_mutex);
-			if (bdevp->bd_openers) {
-				mutex_unlock(&bdevp->bd_mutex);
-				bdput(bdevp);
+		mutex_lock(&bdev->bd_mutex);
+
+		/* overlap? */
+		disk_part_iter_init(&piter, disk,
+				    DISK_PITER_INCL_EMPTY);
+		while ((part = disk_part_iter_next(&piter))) {
+			if (!(start + length <= part->start_sect ||
+			      start >= part->start_sect + part->nr_sects)) {
+				disk_part_iter_exit(&piter);
+				mutex_unlock(&bdev->bd_mutex);
 				return -EBUSY;
 			}
-			/* all seems OK */
-			fsync_bdev(bdevp);
-			invalidate_bdev(bdevp);
-
-			mutex_lock_nested(&bdev->bd_mutex, 1);
-			delete_partition(disk, partno);
-			mutex_unlock(&bdev->bd_mutex);
+		}
+		disk_part_iter_exit(&piter);
+
+		/* all seems OK */
+		part = add_partition(disk, partno, start, length,
+				     ADDPART_FLAG_NONE, NULL);
+		mutex_unlock(&bdev->bd_mutex);
+		return IS_ERR(part) ? PTR_ERR(part) : 0;
+	case BLKPG_DEL_PARTITION:
+		part = disk_get_part(disk, partno);
+		if (!part)
+			return -ENXIO;
+
+		bdevp = bdget(part_devt(part));
+		disk_put_part(part);
+		if (!bdevp)
+			return -ENOMEM;
+
+		mutex_lock(&bdevp->bd_mutex);
+		if (bdevp->bd_openers) {
 			mutex_unlock(&bdevp->bd_mutex);
 			bdput(bdevp);
+			return -EBUSY;
+		}
+		/* all seems OK */
+		fsync_bdev(bdevp);
+		invalidate_bdev(bdevp);
 
-			return 0;
-		default:
-			return -EINVAL;
+		mutex_lock_nested(&bdev->bd_mutex, 1);
+		delete_partition(disk, partno);
+		mutex_unlock(&bdev->bd_mutex);
+		mutex_unlock(&bdevp->bd_mutex);
+		bdput(bdevp);
+
+		return 0;
+	default:
+		return -EINVAL;
 	}
 }
 
@@ -189,7 +191,7 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	loff_t size;
 	int ret, n;
 
-	switch(cmd) {
+	switch (cmd) {
 	case BLKFLSBUF:
 		if (!capable(CAP_SYS_ADMIN))
 			return -EACCES;
@@ -279,7 +281,7 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 		return put_ushort(arg, queue_max_sectors(bdev_get_queue(bdev)));
 	case BLKRASET:
 	case BLKFRASET:
-		if(!capable(CAP_SYS_ADMIN))
+		if (!capable(CAP_SYS_ADMIN))
 			return -EACCES;
 		bdi = blk_get_backing_dev_info(bdev);
 		if (bdi == NULL)
-- 
1.7.4.1

