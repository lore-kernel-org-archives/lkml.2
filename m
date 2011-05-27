Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740Ab1E0CnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 22:43:25 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41729 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758689Ab1E0CnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 22:43:22 -0400
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: jaxboe@fusionio.com
Cc: snitzer@redhat.com, msb@chromium.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/3] block: Introduce blk_set_stacking_limits function
Date: Thu, 26 May 2011 22:42:47 -0400
Message-Id: <1306464169-4291-2-git-send-email-martin.petersen@oracle.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1306464169-4291-1-git-send-email-martin.petersen@oracle.com>
References: <4DDEA689.2090004@fusionio.com>
 <1306464169-4291-1-git-send-email-martin.petersen@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4DDF0FC0.0112:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stacking driver queue limits are typically bounded exclusively by the
capabilities of the low level devices, not by the stacking driver
itself.

Stacking drivers are typically permissive. A feature is supported unless
an incompatible bottom device causes it to be disabled. Low-level
drivers on the other hand are restrictive and want features disabled by
default. Low-level drivers explicitly enable features as part of their
device discovery process.

This patch introduces blk_set_stacking_limits() which has more liberal
metrics than the default queue limits function. This allows us to
inherit topology parameters from bottom devices without manually
tweaking the default limits in each driver prior to calling the stacking
function.

Since there is now a clear distinction between stacking and low-level
devices, blk_set_default_limits() has been modified to carry the more
conservative values that we used to manually set in
blk_queue_make_request().

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/blk-settings.c   |   30 ++++++++++++++++++++++--------
 drivers/md/dm-table.c  |    6 +++---
 drivers/md/md.c        |    1 +
 include/linux/blkdev.h |    1 +
 4 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index fa1eb04..b373721 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -104,9 +104,7 @@ EXPORT_SYMBOL_GPL(blk_queue_lld_busy);
  * @lim:  the queue_limits structure to reset
  *
  * Description:
- *   Returns a queue_limit struct to its default state.  Can be used by
- *   stacking drivers like DM that stage table swaps and reuse an
- *   existing device queue.
+ *   Returns a queue_limit struct to its default state.
  */
 void blk_set_default_limits(struct queue_limits *lim)
 {
@@ -114,13 +112,12 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->max_integrity_segments = 0;
 	lim->seg_boundary_mask = BLK_SEG_BOUNDARY_MASK;
 	lim->max_segment_size = BLK_MAX_SEGMENT_SIZE;
-	lim->max_sectors = BLK_DEF_MAX_SECTORS;
-	lim->max_hw_sectors = INT_MAX;
+	lim->max_sectors = lim->max_hw_sectors = BLK_SAFE_MAX_SECTORS;
 	lim->max_discard_sectors = 0;
 	lim->discard_granularity = 0;
 	lim->discard_alignment = 0;
 	lim->discard_misaligned = 0;
-	lim->discard_zeroes_data = 1;
+	lim->discard_zeroes_data = 0;
 	lim->logical_block_size = lim->physical_block_size = lim->io_min = 512;
 	lim->bounce_pfn = (unsigned long)(BLK_BOUNCE_ANY >> PAGE_SHIFT);
 	lim->alignment_offset = 0;
@@ -131,6 +128,25 @@ void blk_set_default_limits(struct queue_limits *lim)
 EXPORT_SYMBOL(blk_set_default_limits);
 
 /**
+ * blk_set_stacking_limits - set default limits for stacking devices
+ * @lim:  the queue_limits structure to reset
+ *
+ * Description:
+ *   Returns a queue_limit struct to its default state. Should be used
+ *   by stacking drivers like DM that stage table swaps and reuse an
+ *   existing device queue.
+ */
+void blk_set_stacking_limits(struct queue_limits *lim)
+{
+	blk_set_default_limits(lim);
+
+	lim->max_hw_sectors = INT_MAX;
+	lim->max_sectors = BLK_DEF_MAX_SECTORS;
+	lim->discard_zeroes_data = 1;
+}
+EXPORT_SYMBOL(blk_set_stacking_limits);
+
+/**
  * blk_queue_make_request - define an alternate make_request function for a device
  * @q:  the request queue for the device to be affected
  * @mfn: the alternate make_request function
@@ -165,8 +181,6 @@ void blk_queue_make_request(struct request_queue *q, make_request_fn *mfn)
 	q->nr_batching = BLK_BATCH_REQ;
 
 	blk_set_default_limits(&q->limits);
-	blk_queue_max_hw_sectors(q, BLK_SAFE_MAX_SECTORS);
-	q->limits.discard_zeroes_data = 0;
 
 	/*
 	 * by default assume old behaviour and bounce for any highmem page
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index cb8380c..35792bf 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -686,7 +686,7 @@ static int validate_hardware_logical_block_alignment(struct dm_table *table,
 	while (i < dm_table_get_num_targets(table)) {
 		ti = dm_table_get_target(table, i++);
 
-		blk_set_default_limits(&ti_limits);
+		blk_set_stacking_limits(&ti_limits);
 
 		/* combine all target devices' limits */
 		if (ti->type->iterate_devices)
@@ -1107,10 +1107,10 @@ int dm_calculate_queue_limits(struct dm_table *table,
 	struct queue_limits ti_limits;
 	unsigned i = 0;
 
-	blk_set_default_limits(limits);
+	blk_set_stacking_limits(limits);
 
 	while (i < dm_table_get_num_targets(table)) {
-		blk_set_default_limits(&ti_limits);
+		blk_set_stacking_limits(&ti_limits);
 
 		ti = dm_table_get_target(table, i++);
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index aa640a8..1bd4c21 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4329,6 +4329,7 @@ static int md_alloc(dev_t dev, char *name)
 	mddev->queue->queuedata = mddev;
 
 	blk_queue_make_request(mddev->queue, md_make_request);
+	blk_set_stacking_limits(&mddev->queue->limits);
 
 	disk = alloc_disk(1 << shift);
 	if (!disk) {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ae9091a..517247d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -822,6 +822,7 @@ extern void blk_queue_io_min(struct request_queue *q, unsigned int min);
 extern void blk_limits_io_opt(struct queue_limits *limits, unsigned int opt);
 extern void blk_queue_io_opt(struct request_queue *q, unsigned int opt);
 extern void blk_set_default_limits(struct queue_limits *lim);
+extern void blk_set_stacking_limits(struct queue_limits *lim);
 extern int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 			    sector_t offset);
 extern int bdev_stack_limits(struct queue_limits *t, struct block_device *bdev,
-- 
1.7.4.4

