Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725Ab1E0CnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 22:43:18 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41662 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758689Ab1E0CnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 22:43:16 -0400
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: jaxboe@fusionio.com
Cc: snitzer@redhat.com, msb@chromium.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2/3] block: Move non-rotational flag to queue limits
Date: Thu, 26 May 2011 22:42:48 -0400
Message-Id: <1306464169-4291-3-git-send-email-martin.petersen@oracle.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1306464169-4291-1-git-send-email-martin.petersen@oracle.com>
References: <4DDEA689.2090004@fusionio.com>
 <1306464169-4291-1-git-send-email-martin.petersen@oracle.com>
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090202.4DDF0FC2.0070:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid special-casing the non-rotational flag when stacking it is
moved from the queue flags to be part of the queue limits. This allows
us to handle it like the remaining I/O topology information.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/blk-settings.c            |   19 +++++++++++++++++++
 block/blk-sysfs.c               |   21 ++++++++++++++++++---
 drivers/block/nbd.c             |    2 +-
 drivers/ide/ide-disk.c          |    2 +-
 drivers/mmc/card/queue.c        |    2 +-
 drivers/scsi/sd.c               |    2 +-
 drivers/staging/zram/zram_drv.c |    2 +-
 include/linux/blkdev.h          |   21 +++++++++++++--------
 8 files changed, 55 insertions(+), 16 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index b373721..f95760d 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -124,6 +124,7 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->io_opt = 0;
 	lim->misaligned = 0;
 	lim->cluster = 1;
+	lim->non_rotational = 0;
 }
 EXPORT_SYMBOL(blk_set_default_limits);
 
@@ -143,6 +144,7 @@ void blk_set_stacking_limits(struct queue_limits *lim)
 	lim->max_hw_sectors = INT_MAX;
 	lim->max_sectors = BLK_DEF_MAX_SECTORS;
 	lim->discard_zeroes_data = 1;
+	lim->non_rotational = 1;
 }
 EXPORT_SYMBOL(blk_set_stacking_limits);
 
@@ -471,6 +473,22 @@ void blk_queue_io_opt(struct request_queue *q, unsigned int opt)
 EXPORT_SYMBOL(blk_queue_io_opt);
 
 /**
+ * blk_queue_non_rotational - set this queue as non-rotational
+ * @q:	the request queue for the device
+ *
+ * Description:
+ *   This setting may be used by drivers to indicate that the physical
+ *   device is non-rotational (solid state device, array with
+ *   non-volatile cache). Setting this may affect I/O scheduler
+ *   decisions and readahead behavior.
+ */
+void blk_queue_non_rotational(struct request_queue *q)
+{
+	q->limits.non_rotational = 1;
+}
+EXPORT_SYMBOL(blk_queue_non_rotational);
+
+/**
  * blk_queue_stack_limits - inherit underlying queue limits for stacked drivers
  * @t:	the stacking driver (top)
  * @b:  the underlying device (bottom)
@@ -552,6 +570,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 
 	t->cluster &= b->cluster;
 	t->discard_zeroes_data &= b->discard_zeroes_data;
+	t->non_rotational &= b->non_rotational;
 
 	/* Physical block size a multiple of the logical block size? */
 	if (t->physical_block_size & (t->logical_block_size - 1)) {
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index d935bd8..598d00a 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -186,6 +186,22 @@ static ssize_t queue_max_hw_sectors_show(struct request_queue *q, char *page)
 	return queue_var_show(max_hw_sectors_kb, (page));
 }
 
+static ssize_t queue_rotational_show(struct request_queue *q, char *page)
+{
+	return queue_var_show(!q->limits.non_rotational, page);
+}
+
+static ssize_t queue_rotational_store(struct request_queue *q,
+				      const char *page, size_t count)
+{
+	unsigned long rotational;
+	ssize_t ret = queue_var_store(&rotational, page, count);
+
+	q->limits.non_rotational = !rotational;
+
+	return ret;
+}
+
 #define QUEUE_SYSFS_BIT_FNS(name, flag, neg)				\
 static ssize_t								\
 queue_show_##name(struct request_queue *q, char *page)			\
@@ -212,7 +228,6 @@ queue_store_##name(struct request_queue *q, const char *page, size_t count) \
 	return ret;							\
 }
 
-QUEUE_SYSFS_BIT_FNS(nonrot, NONROT, 1);
 QUEUE_SYSFS_BIT_FNS(random, ADD_RANDOM, 0);
 QUEUE_SYSFS_BIT_FNS(iostats, IO_STAT, 0);
 #undef QUEUE_SYSFS_BIT_FNS
@@ -352,8 +367,8 @@ static struct queue_sysfs_entry queue_discard_zeroes_data_entry = {
 
 static struct queue_sysfs_entry queue_nonrot_entry = {
 	.attr = {.name = "rotational", .mode = S_IRUGO | S_IWUSR },
-	.show = queue_show_nonrot,
-	.store = queue_store_nonrot,
+	.show = queue_rotational_show,
+	.store = queue_rotational_store,
 };
 
 static struct queue_sysfs_entry queue_nomerges_entry = {
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index e6fc716..fd96b44 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -774,7 +774,7 @@ static int __init nbd_init(void)
 		/*
 		 * Tell the block layer that we are not a rotational device
 		 */
-		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, disk->queue);
+		blk_queue_non_rotational(queue);
 	}
 
 	if (register_blkdev(NBD_MAJOR, "nbd")) {
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 2747980..422c558 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -682,7 +682,7 @@ static void ide_disk_setup(ide_drive_t *drive)
 	       queue_max_sectors(q) / 2);
 
 	if (ata_id_is_ssd(id))
-		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
+		blk_queue_non_rotational(q);
 
 	/* calculate drive capacity, and select LBA if possible */
 	ide_disk_get_capacity(drive);
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index c07322c..9adce86 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -127,7 +127,7 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 	mq->req = NULL;
 
 	blk_queue_prep_rq(mq->queue, mmc_prep_request);
-	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, mq->queue);
+	blk_queue_non_rotational(mq->queue);
 	if (mmc_can_erase(card)) {
 		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mq->queue);
 		mq->queue->limits.max_discard_sectors = UINT_MAX;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index bd0806e..7a5cf28 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2257,7 +2257,7 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 	rot = get_unaligned_be16(&buffer[4]);
 
 	if (rot == 1)
-		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, sdkp->disk->queue);
+		blk_queue_non_rotational(sdkp->disk->queue);
 
  out:
 	kfree(buffer);
diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index aab4ec4..9bd0874 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -538,7 +538,7 @@ int zram_init_device(struct zram *zram)
 	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
 
 	/* zram devices sort of resembles non-rotational disks */
-	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, zram->disk->queue);
+	blk_queue_non_rotational(zram->disk->queue);
 
 	zram->mem_pool = xv_create_pool();
 	if (!zram->mem_pool) {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 517247d..52a3f4c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -258,6 +258,8 @@ struct queue_limits {
 	unsigned char		discard_misaligned;
 	unsigned char		cluster;
 	unsigned char		discard_zeroes_data;
+
+	unsigned char		non_rotational;
 };
 
 struct request_queue
@@ -396,13 +398,11 @@ struct request_queue
 #define QUEUE_FLAG_SAME_COMP	9	/* force complete on same CPU */
 #define QUEUE_FLAG_FAIL_IO     10	/* fake timeout */
 #define QUEUE_FLAG_STACKABLE   11	/* supports request stacking */
-#define QUEUE_FLAG_NONROT      12	/* non-rotational device (SSD) */
-#define QUEUE_FLAG_VIRT        QUEUE_FLAG_NONROT /* paravirt device */
-#define QUEUE_FLAG_IO_STAT     13	/* do IO stats */
-#define QUEUE_FLAG_DISCARD     14	/* supports DISCARD */
-#define QUEUE_FLAG_NOXMERGES   15	/* No extended merges */
-#define QUEUE_FLAG_ADD_RANDOM  16	/* Contributes to random pool */
-#define QUEUE_FLAG_SECDISCARD  17	/* supports SECDISCARD */
+#define QUEUE_FLAG_IO_STAT     12	/* do IO stats */
+#define QUEUE_FLAG_DISCARD     13	/* supports DISCARD */
+#define QUEUE_FLAG_NOXMERGES   14	/* No extended merges */
+#define QUEUE_FLAG_ADD_RANDOM  15	/* Contributes to random pool */
+#define QUEUE_FLAG_SECDISCARD  16	/* supports SECDISCARD */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
@@ -479,7 +479,6 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 #define blk_queue_nomerges(q)	test_bit(QUEUE_FLAG_NOMERGES, &(q)->queue_flags)
 #define blk_queue_noxmerges(q)	\
 	test_bit(QUEUE_FLAG_NOXMERGES, &(q)->queue_flags)
-#define blk_queue_nonrot(q)	test_bit(QUEUE_FLAG_NONROT, &(q)->queue_flags)
 #define blk_queue_io_stat(q)	test_bit(QUEUE_FLAG_IO_STAT, &(q)->queue_flags)
 #define blk_queue_add_random(q)	test_bit(QUEUE_FLAG_ADD_RANDOM, &(q)->queue_flags)
 #define blk_queue_stackable(q)	\
@@ -821,6 +820,7 @@ extern void blk_limits_io_min(struct queue_limits *limits, unsigned int min);
 extern void blk_queue_io_min(struct request_queue *q, unsigned int min);
 extern void blk_limits_io_opt(struct queue_limits *limits, unsigned int opt);
 extern void blk_queue_io_opt(struct request_queue *q, unsigned int opt);
+extern void blk_queue_non_rotational(struct request_queue *q);
 extern void blk_set_default_limits(struct queue_limits *lim);
 extern void blk_set_stacking_limits(struct queue_limits *lim);
 extern int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
@@ -1028,6 +1028,11 @@ static inline int bdev_io_opt(struct block_device *bdev)
 	return queue_io_opt(bdev_get_queue(bdev));
 }
 
+static inline unsigned int blk_queue_nonrot(struct request_queue *q)
+{
+	return q->limits.non_rotational;
+}
+
 static inline int queue_alignment_offset(struct request_queue *q)
 {
 	if (q->limits.misaligned)
-- 
1.7.4.4

