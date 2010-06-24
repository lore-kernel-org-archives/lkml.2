Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab0FXIpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 04:45:31 -0400
Received: from smtp.nokia.com ([192.100.122.233]:43358 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab0FXIpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 04:45:12 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Hunter <adrian.hunter@nokia.com>, Jens Axboe <axboe@kernel.dk>,
       Kyungmin Park <kmpark@infradead.org>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       linux-mmc Mailing List <linux-mmc@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 24 Jun 2010 11:44:09 +0300
Message-Id: <20100624084409.25444.42028.sendpatchset@ahunter-work.research.nokia.com>
In-Reply-To: <20100624084351.25444.30143.sendpatchset@ahunter-work.research.nokia.com>
References: <20100624084351.25444.30143.sendpatchset@ahunter-work.research.nokia.com>
Subject: [PATCH V3 2/5] mmc_block: Add discard support
X-OriginalArrivalTime: 24 Jun 2010 08:44:09.0993 (UTC) FILETIME=[69F69790:01CB1379]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1c859151d2d8c76e503a24c6d3d472cc01a68b3a Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@nokia.com>
Date: Thu, 3 Jun 2010 10:47:12 +0300
Subject: [PATCH 2/5] mmc_block: Add discard support

Enable MMC to service discard requests.  In the case of SD
and MMC cards that do not support trim, discards become
erases.  In the case of cards (MMC) that only allow erases
in multiples of erase group size, round to the nearest
completely discarded erase group.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 drivers/mmc/card/block.c |   42 +++++++++++++++++++++++++++++++++++++++++-
 drivers/mmc/card/queue.c |   16 ++++++++++++++--
 2 files changed, 55 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index cb9fbc8..af14ae1 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -242,7 +242,40 @@ static u32 get_card_status(struct mmc_card *card, struct request *req)
 	return cmd.resp[0];
 }
 
-static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
+static int mmc_blk_issue_discard_rq(struct mmc_queue *mq, struct request *req)
+{
+	struct mmc_blk_data *md = mq->data;
+	struct mmc_card *card = md->queue.card;
+	unsigned int from, nr, arg;
+	int err = 0;
+
+	mmc_claim_host(card->host);
+
+	if (!mmc_can_erase(card)) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	from = blk_rq_pos(req);
+	nr = blk_rq_sectors(req);
+
+	if (mmc_can_trim(card))
+		arg = MMC_TRIM_ARG;
+	else
+		arg = MMC_ERASE_ARG;
+
+	err = mmc_erase(card, from, nr, arg);
+out:
+	spin_lock_irq(&md->lock);
+	__blk_end_request(req, err, blk_rq_bytes(req));
+	spin_unlock_irq(&md->lock);
+
+	mmc_release_host(card->host);
+
+	return err ? 0 : 1;
+}
+
+static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 {
 	struct mmc_blk_data *md = mq->data;
 	struct mmc_card *card = md->queue.card;
@@ -470,6 +503,13 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 	return 0;
 }
 
+static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
+{
+	if (blk_discard_rq(req))
+		return mmc_blk_issue_discard_rq(mq, req);
+	else
+		return mmc_blk_issue_rw_rq(mq, req);
+}
 
 static inline int mmc_blk_readonly(struct mmc_card *card)
 {
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index d6ded24..37f648f 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -30,9 +30,9 @@
 static int mmc_prep_request(struct request_queue *q, struct request *req)
 {
 	/*
-	 * We only like normal block requests.
+	 * We only like normal block requests and discards.
 	 */
-	if (!blk_fs_request(req)) {
+	if (!blk_fs_request(req) && !blk_discard_rq(req)) {
 		blk_dump_rq_flags(req, "MMC bad request");
 		return BLKPREP_KILL;
 	}
@@ -130,6 +130,18 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 	blk_queue_prep_rq(mq->queue, mmc_prep_request);
 	blk_queue_ordered(mq->queue, QUEUE_ORDERED_DRAIN, NULL);
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, mq->queue);
+	if (mmc_can_erase(card)) {
+		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mq->queue);
+		mq->queue->limits.max_discard_sectors = UINT_MAX;
+		if (card->erased_byte == 0)
+			mq->queue->limits.discard_zeroes_data = 1;
+		if (!mmc_can_trim(card) && is_power_of_2(card->erase_size)) {
+			mq->queue->limits.discard_granularity =
+							card->erase_size << 9;
+			mq->queue->limits.discard_alignment =
+							card->erase_size << 9;
+		}
+	}
 
 #ifdef CONFIG_MMC_BLOCK_BOUNCE
 	if (host->max_hw_segs == 1) {
-- 
1.6.3.3

