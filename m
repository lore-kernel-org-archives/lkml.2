Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab1HWEsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 00:48:17 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:48244 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab1HWEsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 00:48:11 -0400
X-AuditID: cbfee61b-b7b7fae000005864-f8-4e5331088cb3
Date: Tue, 23 Aug 2011 13:48:24 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
Subject: [RFC PATCH resend] support ioctl for tunable user request
To: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Chris Ball <cjb@laptop.org>, Jens Axboe <jaxboe@fusionio.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Message-id: <4E533118.5010906@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.24 (X11/20100623)
X-OriginalArrivalTime: 23 Aug 2011 04:48:48.0640 (UTC)
 FILETIME=[F28AE000:01CC614F]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry Add to linux-kernel mailing and change Jens's e-mail.

This patch is added the ioctl for tunable user request.

First, We defined TUNE request (REQ_TUNE). TUNE request means tunable request.
(In this patch, TUNE request is background request for eMMC).

That request should be defined by device.
User has only to do TUNE-request trigger. Then device should be run its specific request.

In other words, user notify the request to device. then user's responsibility is done.
(i think quite similar to DISCARD request)

If you want to test this patch, you need to apply the some patches in mmc mailing.
([PATCH v4] mmc: support HPI send command, [RFC PATCH v2] mmc: support background operation)

Because this patch is based on background operation for eMMC.
(but, if use the ioctl part,then i think TUNE request is supported other devices)

This patch didn't separate the block layer and eMMC.(because just RFC patch)

Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 block/blk-core.c          |    2 +-
 block/blk-lib.c           |   47 +++++++++++++++++++++++++++++++++++++++++++++
 block/ioctl.c             |    3 ++
 drivers/mmc/card/block.c  |   17 ++++++++++++++++
 drivers/mmc/card/queue.c  |   10 +++++++++
 drivers/mmc/core/core.c   |    9 ++++++++
 include/linux/blk_types.h |    4 ++-
 include/linux/blkdev.h    |    3 ++
 include/linux/fs.h        |    1 +
 include/linux/mmc/core.h  |    1 +
 10 files changed, 95 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index b627558..0e94897 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1623,7 +1623,7 @@ void submit_bio(int rw, struct bio *bio)
 	 * If it's a regular read/write or a barrier with data attached,
 	 * go through the normal accounting stuff before submission.
 	 */
-	if (bio_has_data(bio) && !(rw & REQ_DISCARD)) {
+	if (bio_has_data(bio) && !((rw & REQ_DISCARD) || (rw & REQ_TUNE))) {
 		if (rw & WRITE) {
 			count_vm_events(PGPGOUT, count);
 		} else {
diff --git a/block/blk-lib.c b/block/blk-lib.c
index 2b461b4..58dcf5e 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -27,6 +27,53 @@ static void bio_batch_end_io(struct bio *bio, int err)
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
+	DECLARE_COMPLETION_ONSTACK(wait);
+	struct request_queue *q = bdev_get_queue(bdev);
+	struct bio_batch bb;
+	struct bio *bio;
+	int ret = 0;
+	int type = REQ_TUNE;
+
+	if (!blk_queue_tune(q))
+		return -ENXIO;
+
+	atomic_set(&bb.done, 1);
+	bb.flags = 1 << BIO_UPTODATE;
+	bb.wait = &wait;
+
+	bio = bio_alloc(gfp_mask, 1);
+	if (bio == NULL)
+		return 0;
+	bio->bi_end_io = bio_batch_end_io;
+	bio->bi_bdev = bdev;
+	bio->bi_private = &bb;
+
+	bio->bi_bdev = bdev;
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
+EXPORT_SYMBOL(blkdev_issue_tune);
+
+/**
  * blkdev_issue_discard - queue a discard
  * @bdev:	blockdev to issue discard for
  * @sector:	start sector
diff --git a/block/ioctl.c b/block/ioctl.c
index 1124cd2..5f26cff 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -112,6 +112,7 @@ static int blkdev_reread_part(struct block_device *bdev)
 	return res;
 }
 
+
 static int blk_ioctl_discard(struct block_device *bdev, uint64_t start,
 			     uint64_t len, int secure)
 {
@@ -214,6 +215,8 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 			return -EFAULT;
 		set_device_ro(bdev, n);
 		return 0;
+	case BLKTUNE:
+		return blkdev_issue_tune(bdev, GFP_KERNEL);
 
 	case BLKDISCARD:
 	case BLKSECDISCARD: {
diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 83379ff..2adb072 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -791,6 +791,18 @@ static int mmc_blk_issue_flush(struct mmc_queue *mq, struct request *req)
 	return 1;
 }
 
+static int mmc_blk_issue_bkops(struct mmc_queue *mq, struct request *req)
+{
+	struct mmc_blk_data *md = mq->data;
+
+	spin_lock_irq(&md->lock);
+	__blk_end_request_all(req, 0);
+	spin_unlock_irq(&md->lock);
+
+	return 1;
+}
+
+
 /*
  * Reformat current write as a reliable write, supporting
  * both legacy and the enhanced reliable write MMC cards.
@@ -1208,6 +1220,11 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 		if (card->host->areq)
 			mmc_blk_issue_rw_rq(mq, NULL);
 		ret = mmc_blk_issue_flush(mq, req);
+	} else if (req && req->cmd_flags & REQ_TUNE) {
+		if (card->host->areq)
+			mmc_blk_issue_rw_rq(mq, NULL);
+		ret = mmc_blk_issue_bkops(mq, req);
+		mmc_card_set_need_bkops(card);
 	} else {
 		ret = mmc_blk_issue_rw_rq(mq, req);
 	}
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 52b1293..6f1bbff 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -133,6 +133,12 @@ struct scatterlist *mmc_alloc_sg(int sg_len, int *err)
 	return sg;
 }
 
+static void mmc_queue_setup_bkops(struct request_queue *q,
+		struct mmc_card *card)
+{
+	queue_flag_set_unlocked(QUEUE_FLAG_TUNE, q);
+}
+
 static void mmc_queue_setup_discard(struct request_queue *q,
 				    struct mmc_card *card)
 {
@@ -191,6 +197,10 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
 	if (mmc_can_erase(card))
 		mmc_queue_setup_discard(mq->queue, card);
 
+	/* Set support bkops flag */
+	if (mmc_can_bkops(card))
+		mmc_queue_setup_bkops(mq->queue, card);
+
 #ifdef CONFIG_MMC_BLOCK_BOUNCE
 	if (host->max_segs == 1) {
 		unsigned int bouncesz;
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index b5a92af..19e7579 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1738,6 +1738,15 @@ int mmc_erase(struct mmc_card *card, unsigned int from, unsigned int nr,
 }
 EXPORT_SYMBOL(mmc_erase);
 
+int mmc_can_bkops(struct mmc_card *card)
+{
+	if (mmc_card_mmc(card) && card->ext_csd.bkops &&
+			card->ext_csd.hpi)
+		return 1;
+	return 0;
+}
+EXPORT_SYMBOL(mmc_can_bkops);
+
 int mmc_can_erase(struct mmc_card *card)
 {
 	if ((card->host->caps & MMC_CAP_ERASE) &&
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 6395692..75521e3 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -125,6 +125,7 @@ enum rq_flag_bits {
 	__REQ_SYNC,		/* request is sync (sync write or read) */
 	__REQ_META,		/* metadata io request */
 	__REQ_DISCARD,		/* request to discard sectors */
+	__REQ_TUNE,		/* tunable request */
 	__REQ_NOIDLE,		/* don't anticipate more IO after this one */
 
 	/* bio only flags */
@@ -161,13 +162,14 @@ enum rq_flag_bits {
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
index 0e67c45..f1f4532 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -403,6 +403,7 @@ struct request_queue {
 #define QUEUE_FLAG_ADD_RANDOM  16	/* Contributes to random pool */
 #define QUEUE_FLAG_SECDISCARD  17	/* supports SECDISCARD */
 #define QUEUE_FLAG_SAME_FORCE  18	/* force complete on same CPU */
+#define QUEUE_FLAG_TUNE        19	/* support tunable request */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
@@ -487,6 +488,7 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 #define blk_queue_discard(q)	test_bit(QUEUE_FLAG_DISCARD, &(q)->queue_flags)
 #define blk_queue_secdiscard(q)	(blk_queue_discard(q) && \
 	test_bit(QUEUE_FLAG_SECDISCARD, &(q)->queue_flags))
+#define blk_queue_tune(q)	test_bit(QUEUE_FLAG_TUNE, &(q)->queue_flags)
 
 #define blk_noretry_request(rq) \
 	((rq)->cmd_flags & (REQ_FAILFAST_DEV|REQ_FAILFAST_TRANSPORT| \
@@ -929,6 +931,7 @@ static inline struct request *blk_map_queue_find_tag(struct blk_queue_tag *bqt,
 #define BLKDEV_DISCARD_SECURE  0x01    /* secure discard */
 
 extern int blkdev_issue_flush(struct block_device *, gfp_t, sector_t *);
+extern int blkdev_issue_tune(struct block_device *bdev, gfp_t gfp_mask);
 extern int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, unsigned long flags);
 extern int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 178cdb4..8d8faa1 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -320,6 +320,7 @@ struct inodes_stat_t {
 #define BLKPBSZGET _IO(0x12,123)
 #define BLKDISCARDZEROES _IO(0x12,124)
 #define BLKSECDISCARD _IO(0x12,125)
+#define BLKTUNE _IO(0x12,126)
 
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */
diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
index 90f2e1c..6a4fa77 100644
--- a/include/linux/mmc/core.h
+++ b/include/linux/mmc/core.h
@@ -156,6 +156,7 @@ extern int mmc_switch(struct mmc_card *, u8, u8, u8, unsigned int);
 extern int mmc_erase(struct mmc_card *card, unsigned int from, unsigned int nr,
 		     unsigned int arg);
 extern int mmc_can_erase(struct mmc_card *card);
+extern int mmc_can_bkops(struct mmc_card *card);
 extern int mmc_can_trim(struct mmc_card *card);
 extern int mmc_can_secure_erase_trim(struct mmc_card *card);
 extern int mmc_erase_group_aligned(struct mmc_card *card, unsigned int from,
--
To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

