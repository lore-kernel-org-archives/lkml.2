Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab2BUOBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 09:01:05 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26951 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab2BUOBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 09:01:01 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6626"; a="164932911"
From: Yaniv Gardi <ygardi@codeaurora.org>
To: linux-mmc@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, axboe@kernel.dk, ygardi@codeaurora.org,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 1/2] block: IOCTL support for Sanitize in eMMC v4.5
Date: Tue, 21 Feb 2012 16:00:24 +0200
Message-Id: <1329832825-8844-2-git-send-email-ygardi@codeaurora.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1329832825-8844-1-git-send-email-ygardi@codeaurora.org>
References: <1329832825-8844-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 block/blk-core.c          |   15 ++++++++++++---
 block/blk-lib.c           |   44 ++++++++++++++++++++++++++++++++++++++++++++
 block/blk-merge.c         |    6 ++++++
 block/elevator.c          |    8 +++++++-
 block/ioctl.c             |    9 +++++++++
 include/linux/blk_types.h |    6 ++++--
 include/linux/blkdev.h    |    3 +++
 include/linux/fs.h        |    1 +
 kernel/trace/blktrace.c   |    2 ++
 9 files changed, 88 insertions(+), 6 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index e6c05a9..150ea4a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1544,7 +1544,7 @@ generic_make_request_checks(struct bio *bio)
 		goto end_io;
 	}
 
-	if (unlikely(!(bio->bi_rw & REQ_DISCARD) &&
+	if (unlikely(!(bio->bi_rw & (REQ_DISCARD | REQ_SANITIZE)) &&
 		     nr_sectors > queue_max_hw_sectors(q))) {
 		printk(KERN_ERR "bio too big device %s (%u > %u)\n",
 		       bdevname(bio->bi_bdev, b),
@@ -1592,6 +1592,14 @@ generic_make_request_checks(struct bio *bio)
 		goto end_io;
 	}
 
+	 if ((bio->bi_rw & REQ_SANITIZE) &&
+	     (!blk_queue_sanitize(q))) {
+		pr_err("%s - SANITIZE request but queue "
+		       "doesn't support sanitize", __func__);
+		err = -EOPNOTSUPP;
+		goto end_io;
+	 }
+
 	if (blk_throtl_bio(q, bio))
 		return false;	/* throttled, will be resubmitted later */
 
@@ -1697,7 +1705,8 @@ void submit_bio(int rw, struct bio *bio)
 	 * If it's a regular read/write or a barrier with data attached,
 	 * go through the normal accounting stuff before submission.
 	 */
-	if (bio_has_data(bio) && !(rw & REQ_DISCARD)) {
+	if (bio_has_data(bio) &&
+	    (!(rw & (REQ_DISCARD | REQ_SANITIZE)))) {
 		if (rw & WRITE) {
 			count_vm_events(PGPGOUT, count);
 		} else {
@@ -1743,7 +1752,7 @@ EXPORT_SYMBOL(submit_bio);
  */
 int blk_rq_check_limits(struct request_queue *q, struct request *rq)
 {
-	if (rq->cmd_flags & REQ_DISCARD)
+	if (rq->cmd_flags & (REQ_DISCARD | REQ_SANITIZE))
 		return 0;
 
 	if (blk_rq_sectors(rq) > queue_max_sectors(q) ||
diff --git a/block/blk-lib.c b/block/blk-lib.c
index 2b461b4..1aef2fb 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -114,6 +114,50 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 }
 EXPORT_SYMBOL(blkdev_issue_discard);
 
+int blkdev_issue_sanitize(struct block_device *bdev, gfp_t gfp_mask)
+{
+	DECLARE_COMPLETION_ONSTACK(wait);
+	struct request_queue *q = bdev_get_queue(bdev);
+	int type = REQ_WRITE | REQ_SANITIZE;
+
+	struct bio_batch bb;
+	struct bio *bio;
+	int ret = 0;
+
+	if (!q)
+		return -ENXIO;
+
+	if (!blk_queue_sanitize(q)) {
+		pr_err("%s - card doesn't support sanitize", __func__);
+		return -EOPNOTSUPP;
+	}
+
+	bio = bio_alloc(gfp_mask, 1);
+	if (!bio)
+		return -ENOMEM;
+
+	atomic_set(&bb.done, 1);
+	bb.flags = 1 << BIO_UPTODATE;
+	bb.wait = &wait;
+
+	bio->bi_end_io = bio_batch_end_io;
+	bio->bi_bdev = bdev;
+	bio->bi_private = &bb;
+
+	atomic_inc(&bb.done);
+	submit_bio(type, bio);
+
+	/* Wait for bios in-flight */
+	if (!atomic_dec_and_test(&bb.done))
+		wait_for_completion(&wait);
+
+	if (!test_bit(BIO_UPTODATE, &bb.flags))
+		ret = -EIO;
+
+	return ret;
+}
+EXPORT_SYMBOL(blkdev_issue_sanitize);
+
 /**
  * blkdev_issue_zeroout - generate number of zero filed write bios
  * @bdev:	blockdev to issue
diff --git a/block/blk-merge.c b/block/blk-merge.c
index cfcc37c..f3ed15b 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -383,6 +383,12 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 		return 0;
 
 	/*
+	 * Don't merge file system requests and sanitize requests
+	 */
+	if ((req->cmd_flags & REQ_SANITIZE) != (next->cmd_flags & REQ_SANITIZE))
+		return 0;
+
+	/*
 	 * not contiguous
 	 */
 	if (blk_rq_pos(req) + blk_rq_sectors(req) != blk_rq_pos(next))
diff --git a/block/elevator.c b/block/elevator.c
index 99838f4..4255dd9 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -88,6 +88,12 @@ int elv_rq_merge_ok(struct request *rq, struct bio *bio)
 		return 0;
 
 	/*
+	 * Don't merge sanitize requests
+	 */
+	if ((bio->bi_rw & REQ_SANITIZE) != (rq->bio->bi_rw & REQ_SANITIZE))
+		return 0;
+
+	/*
 	 * different data direction or already started, don't merge
 	 */
 	if (bio_data_dir(bio) != rq_data_dir(rq))
@@ -647,7 +653,7 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
 	if (rq->cmd_flags & REQ_SOFTBARRIER) {
 		/* barriers are scheduling boundary, update end_sector */
 		if (rq->cmd_type == REQ_TYPE_FS ||
-		    (rq->cmd_flags & REQ_DISCARD)) {
+		    (rq->cmd_flags & (REQ_DISCARD | REQ_SANITIZE))) {
 			q->end_sector = rq_end_sector(rq);
 			q->boundary_rq = rq;
 		}
diff --git a/block/ioctl.c b/block/ioctl.c
index ca939fc..eed6dbb 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -132,6 +132,11 @@ static int blk_ioctl_discard(struct block_device *bdev, uint64_t start,
 	return blkdev_issue_discard(bdev, start, len, GFP_KERNEL, flags);
 }
 
+static int blk_ioctl_sanitize(struct block_device *bdev)
+{
+	return blkdev_issue_sanitize(bdev, GFP_KERNEL);
+}
+
 static int put_ushort(unsigned long arg, unsigned short val)
 {
 	return put_user(val, (unsigned short __user *)arg);
@@ -216,6 +221,10 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 		set_device_ro(bdev, n);
 		return 0;
 
+	case BLKSANITIZE:
+		ret = blk_ioctl_sanitize(bdev);
+		break;
+
 	case BLKDISCARD:
 	case BLKSECDISCARD: {
 		uint64_t range[2];
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 4053cbd..bbe4976 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -150,6 +150,7 @@ enum rq_flag_bits {
 	__REQ_FLUSH_SEQ,	/* request for flush sequence */
 	__REQ_IO_STAT,		/* account I/O stat */
 	__REQ_MIXED_MERGE,	/* merge of different types, fail separately */
+	__REQ_SANITIZE,		/* sanitize */
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -161,13 +162,14 @@ enum rq_flag_bits {
 #define REQ_META		(1 << __REQ_META)
 #define REQ_PRIO		(1 << __REQ_PRIO)
 #define REQ_DISCARD		(1 << __REQ_DISCARD)
+#define REQ_SANITIZE		(1 << __REQ_SANITIZE)
 #define REQ_NOIDLE		(1 << __REQ_NOIDLE)
 
 #define REQ_FAILFAST_MASK \
 	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
 #define REQ_COMMON_MASK \
-	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_SYNC | REQ_META | REQ_PRIO | \
-	 REQ_DISCARD | REQ_NOIDLE | REQ_FLUSH | REQ_FUA | REQ_SECURE)
+	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_SYNC | REQ_META | REQ_DISCARD | \
+	 REQ_NOIDLE | REQ_FLUSH | REQ_FUA | REQ_SECURE | REQ_SANITIZE)
 #define REQ_CLONE_MASK		REQ_COMMON_MASK
 
 #define REQ_RAHEAD		(1 << __REQ_RAHEAD)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 7084318..1197c31 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -423,6 +423,7 @@ struct request_queue {
 #define QUEUE_FLAG_ADD_RANDOM  16	/* Contributes to random pool */
 #define QUEUE_FLAG_SECDISCARD  17	/* supports SECDISCARD */
 #define QUEUE_FLAG_SAME_FORCE  18	/* force complete on same CPU */
+#define QUEUE_FLAG_SANITIZE    19	/* supports SANITIZE */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
@@ -506,6 +507,7 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 #define blk_queue_stackable(q)	\
 	test_bit(QUEUE_FLAG_STACKABLE, &(q)->queue_flags)
 #define blk_queue_discard(q)	test_bit(QUEUE_FLAG_DISCARD, &(q)->queue_flags)
+#define blk_queue_sanitize(q)	test_bit(QUEUE_FLAG_SANITIZE, &(q)->queue_flags)
 #define blk_queue_secdiscard(q)	(blk_queue_discard(q) && \
 	test_bit(QUEUE_FLAG_SECDISCARD, &(q)->queue_flags))
 
@@ -955,6 +957,7 @@ static inline struct request *blk_map_queue_find_tag(struct blk_queue_tag *bqt,
 extern int blkdev_issue_flush(struct block_device *, gfp_t, sector_t *);
 extern int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, unsigned long flags);
+extern int blkdev_issue_sanitize(struct block_device *bdev, gfp_t gfp_mask);
 extern int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 			sector_t nr_sects, gfp_t gfp_mask);
 static inline int sb_issue_discard(struct super_block *sb, sector_t block,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 057434a..3680eef 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -319,6 +319,7 @@ struct inodes_stat_t {
 #define BLKPBSZGET _IO(0x12,123)
 #define BLKDISCARDZEROES _IO(0x12,124)
 #define BLKSECDISCARD _IO(0x12,125)
+#define BLKSANITIZE _IO(0x12, 126)
 
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 16fc34a..2c2efc6 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1802,6 +1802,8 @@ void blk_fill_rwbs(char *rwbs, u32 rw, int bytes)
 		rwbs[i++] = 'W';
 	else if (rw & REQ_DISCARD)
 		rwbs[i++] = 'D';
+	else if (rw & REQ_SANITIZE)
+		rwbs[i++] = 'Z';
 	else if (bytes)
 		rwbs[i++] = 'R';
 	else
-- 
1.7.6
-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum
