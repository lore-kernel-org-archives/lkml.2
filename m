Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab1HOMMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 08:12:48 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63205 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab1HOMMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 08:12:47 -0400
Date: Mon, 15 Aug 2011 14:12:42 +0200
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Kay Sievers <kay.sievers@vrfy.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH UPDATED] block: add GENHD_FL_NO_PART_SCAN
Message-ID: <20110815121242.GF4254@htj.dyndns.org>
References: <20110813153237.GD4254@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110813153237.GD4254@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are cases where suppressing partition scan is useful - e.g. for
lo devices and pseudo SATA devices which advertise to be a disk but
get upset on partition scan (some port multiplier control devices show
such behavior).

This patch adds GENHD_FL_NO_PART_SCAN which suppresses partition scan
regardless of the number of possible partitions.  disk_partitionable()
is renamed to disk_part_scan_enabled() as suppressing partition scan
doesn't imply the device can't be partitioned using
BLKPG_ADD/DEL_PARTITION calls from userland.  show_partition() now
directly tests disk_max_parts() to maintain backward-compatibility.

-v2: Updated to make it clear that only partition scan is suppressed
     not partitioning itself as suggested by Kay Sievers.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
---
 block/genhd.c         |    4 ++--
 block/ioctl.c         |    2 +-
 fs/block_dev.c        |    2 +-
 include/linux/genhd.h |    6 ++++--
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 5cb51c5..2429ecb 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -536,7 +536,7 @@ void register_disk(struct gendisk *disk)
 	disk->slave_dir = kobject_create_and_add("slaves", &ddev->kobj);
 
 	/* No minors to use for partitions */
-	if (!disk_partitionable(disk))
+	if (!disk_part_scan_enabled(disk))
 		goto exit;
 
 	/* No such device (e.g., media were just removed) */
@@ -841,7 +841,7 @@ static int show_partition(struct seq_file *seqf, void *v)
 	char buf[BDEVNAME_SIZE];
 
 	/* Don't show non-partitionable removeable devices or empty devices */
-	if (!get_capacity(sgp) || (!disk_partitionable(sgp) &&
+	if (!get_capacity(sgp) || (!disk_max_parts(sgp) &&
 				   (sgp->flags & GENHD_FL_REMOVABLE)))
 		return 0;
 	if (sgp->flags & GENHD_FL_SUPPRESS_PARTITION_INFO)
diff --git a/block/ioctl.c b/block/ioctl.c
index 1124cd2..5c74efc 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -101,7 +101,7 @@ static int blkdev_reread_part(struct block_device *bdev)
 	struct gendisk *disk = bdev->bd_disk;
 	int res;
 
-	if (!disk_partitionable(disk) || bdev != bdev->bd_contains)
+	if (!disk_part_scan_enabled(disk) || bdev != bdev->bd_contains)
 		return -EINVAL;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
diff --git a/fs/block_dev.c b/fs/block_dev.c
index ff77262..0bed0d4 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -971,7 +971,7 @@ static void flush_disk(struct block_device *bdev, bool kill_dirty)
 
 	if (!bdev->bd_disk)
 		return;
-	if (disk_partitionable(bdev->bd_disk))
+	if (disk_part_scan_enabled(bdev->bd_disk))
 		bdev->bd_invalidated = 1;
 }
 
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 02fa469..6d18f35 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -128,6 +128,7 @@ struct hd_struct {
 #define GENHD_FL_EXT_DEVT			64 /* allow extended devt */
 #define GENHD_FL_NATIVE_CAPACITY		128
 #define GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE	256
+#define GENHD_FL_NO_PART_SCAN			512
 
 enum {
 	DISK_EVENT_MEDIA_CHANGE			= 1 << 0, /* media changed */
@@ -234,9 +235,10 @@ static inline int disk_max_parts(struct gendisk *disk)
 	return disk->minors;
 }
 
-static inline bool disk_partitionable(struct gendisk *disk)
+static inline bool disk_part_scan_enabled(struct gendisk *disk)
 {
-	return disk_max_parts(disk) > 1;
+	return disk_max_parts(disk) > 1 &&
+		!(disk->flags & GENHD_FL_NO_PART_SCAN);
 }
 
 static inline dev_t disk_devt(struct gendisk *disk)
