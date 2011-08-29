Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab1H2IPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 04:15:17 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:59921 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab1H2IPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 04:15:13 -0400
X-AuditID: cbfee61b-b7b7fae000005864-8d-4e5b4a90a246
Date: Mon, 29 Aug 2011 17:15:43 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
Subject: [RFC PATCH v2] support ioctl for tunable user request
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, Arnd Bergmann <arnd.bergmann@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4E5B4AAF.2040101@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.24 (X11/20100623)
X-OriginalArrivalTime: 29 Aug 2011 08:15:49.0627 (UTC)
 FILETIME=[DC8194B0:01CC6623]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is added the ioctl for tunable user request.

First, We defined TUNE request (REQ_TUNE). TUNE request means tunable request.
(For example, TUNE request is background request.)

That request should be defined by device.
User has only to do TUNE-request trigger. Then device should be run its specific request.

In other words, user notify the request to device. then user's responsibility is done.
(i think quite similar to DISCARD request)

I want to get mailing's review.

Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Change-log v2:
- removed wait completion code.(This request has only to do trigger interrupt)
- based-on for-next tree in linux-block git repository
---
 block/blk-core.c          |    2 +-
 block/blk-lib.c           |   38 ++++++++++++++++++++++++++++++++++++++
 block/ioctl.c             |    3 +++
 include/linux/blk_types.h |    4 +++-
 include/linux/blkdev.h    |    3 +++
 include/linux/fs.h        |    1 +
 6 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 7c59b0f..6d54ca0 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1621,7 +1621,7 @@ void submit_bio(int rw, struct bio *bio)
 	 * If it's a regular read/write or a barrier with data attached,
 	 * go through the normal accounting stuff before submission.
 	 */
-	if (bio_has_data(bio) && !(rw & REQ_DISCARD)) {
+	if (bio_has_data(bio) && !((rw & REQ_DISCARD) || (rw & REQ_TUNE))) {
 		if (rw & WRITE) {
 			count_vm_events(PGPGOUT, count);
 		} else {
diff --git a/block/blk-lib.c b/block/blk-lib.c
index 2b461b4..c9824b6 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -27,6 +27,44 @@ static void bio_batch_end_io(struct bio *bio, int err)
 }
 
 /**
+ * blkdev_issue_tune - queue a tune request
+ * @bdev:	blockdev to issue discard for
+ * @gfp_mask:	memory allocation flags (for bio_alloc)
+ *
+ * Description:
+ *    Issue a tunable request from user.
+ */
+int blkdev_issue_tune(struct block_device *bdev, gfp_t gfp_mask)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+	struct bio *bio;
+	struct bio_batch bb;
+	int type = REQ_TUNE;
+
+	if (!blk_queue_tune(q))
+		return -ENXIO;
+
+	bio = bio_alloc(gfp_mask, 1);
+	if (bio == NULL)
+		return -ENOMEM;
+
+	/*
+	 * TUNE request didn't wait for completion.
+	 * Because this request didn't include any data
+	 * (Just triger request.)
+	 */
+	atomic_set(&bb.done, 0);
+	bio->bi_end_io = bio_batch_end_io;
+	bio->bi_bdev = bdev;
+	bio->bi_private = &bb;
+
+	submit_bio(type, bio);
+
+	return 0;
+}
+EXPORT_SYMBOL(blkdev_issue_tune);
+
+/**
  * blkdev_issue_discard - queue a discard
  * @bdev:	blockdev to issue discard for
  * @sector:	start sector
diff --git a/block/ioctl.c b/block/ioctl.c
index 1124cd2..ca580c4 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -215,6 +215,9 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 		set_device_ro(bdev, n);
 		return 0;
 
+	case BLKTUNE:
+		return blkdev_issue_tune(bdev, GFP_KERNEL);
+
 	case BLKDISCARD:
 	case BLKSECDISCARD: {
 		uint64_t range[2];
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 32f0076..7a1ada2 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -126,6 +126,7 @@ enum rq_flag_bits {
 	__REQ_META,		/* metadata io request */
 	__REQ_DISCARD,		/* request to discard sectors */
 	__REQ_SECURE,		/* secure discard (used with __REQ_DISCARD) */
+	__REQ_TUNE,		/* tunable request */
 
 	__REQ_NOIDLE,		/* don't anticipate more IO after this one */
 	__REQ_FUA,		/* forced unit access */
@@ -162,13 +163,14 @@ enum rq_flag_bits {
 #define REQ_SYNC		(1 << __REQ_SYNC)
 #define REQ_META		(1 << __REQ_META)
 #define REQ_DISCARD		(1 << __REQ_DISCARD)
+#define REQ_TUNE		(1 << __REQ_TUNE)
 #define REQ_NOIDLE		(1 << __REQ_NOIDLE)
 
 #define REQ_FAILFAST_MASK \
 	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
 #define REQ_COMMON_MASK \
 	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_SYNC | REQ_META | REQ_DISCARD | \
-	 REQ_NOIDLE | REQ_FLUSH | REQ_FUA | REQ_SECURE)
+	 REQ_NOIDLE | REQ_FLUSH | REQ_FUA | REQ_SECURE | REQ_TUNE)
 #define REQ_CLONE_MASK		REQ_COMMON_MASK
 
 #define REQ_RAHEAD		(1 << __REQ_RAHEAD)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 84b15d5..dd43aa2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -408,6 +408,7 @@ struct request_queue {
 #define QUEUE_FLAG_ADD_RANDOM  16	/* Contributes to random pool */
 #define QUEUE_FLAG_SECDISCARD  17	/* supports SECDISCARD */
 #define QUEUE_FLAG_SAME_FORCE  18	/* force complete on same CPU */
+#define QUEUE_FLAG_TUNE        19	/* support tunable request */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
@@ -492,6 +493,7 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 #define blk_queue_discard(q)	test_bit(QUEUE_FLAG_DISCARD, &(q)->queue_flags)
 #define blk_queue_secdiscard(q)	(blk_queue_discard(q) && \
 	test_bit(QUEUE_FLAG_SECDISCARD, &(q)->queue_flags))
+#define blk_queue_tune(q)	test_bit(QUEUE_FLAG_TUNE, &(q)->queue_flags)
 
 #define blk_noretry_request(rq) \
 	((rq)->cmd_flags & (REQ_FAILFAST_DEV|REQ_FAILFAST_TRANSPORT| \
@@ -934,6 +936,7 @@ static inline struct request *blk_map_queue_find_tag(struct blk_queue_tag *bqt,
 #define BLKDEV_DISCARD_SECURE  0x01    /* secure discard */
 
 extern int blkdev_issue_flush(struct block_device *, gfp_t, sector_t *);
+extern int blkdev_issue_tune(struct block_device *bdev, gfp_t gfp_mask);
 extern int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, unsigned long flags);
 extern int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f23bcb7..b27ea55 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -320,6 +320,7 @@ struct inodes_stat_t {
 #define BLKPBSZGET _IO(0x12,123)
 #define BLKDISCARDZEROES _IO(0x12,124)
 #define BLKSECDISCARD _IO(0x12,125)
+#define BLKTUNE _IO(0x12,126)
 
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */
