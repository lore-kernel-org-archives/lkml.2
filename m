Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab0GGLSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 07:18:48 -0400
Received: from smtp.nokia.com ([192.100.105.134]:40687 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720Ab0GGLSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 07:18:36 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Hunter <adrian.hunter@nokia.com>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kyungmin Park <kmpark@infradead.org>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       linux-mmc Mailing List <linux-mmc@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Date: Wed, 07 Jul 2010 14:17:54 +0300
Message-Id: <20100707111754.24979.43278.sendpatchset@ahunter-work.research.nokia.com>
In-Reply-To: <20100707111716.24979.68940.sendpatchset@ahunter-work.research.nokia.com>
References: <20100707111716.24979.68940.sendpatchset@ahunter-work.research.nokia.com>
Subject: [PATCH V4 5/5] mmc_block: Add support for secure discard
X-OriginalArrivalTime: 07 Jul 2010 11:17:54.0830 (UTC) FILETIME=[0BC3C2E0:01CB1DC6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 548ec42c86a88092b92597ff2774691e5498974f Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@nokia.com>
Date: Wed, 23 Jun 2010 15:55:50 +0300
Subject: [PATCH 5/5] mmc_block: Add support for secure discard

Secure discard is implemented by Secure Trim if the discard
is unaligned or Secure Erase otherwise.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 drivers/mmc/card/block.c |   46 +++++++++++++++++++++++++++++++++++++++++++---
 drivers/mmc/card/queue.c |    3 +++
 2 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index adb8314..0265712 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -275,6 +275,42 @@ out:
 	return err ? 0 : 1;
 }
 
+static int mmc_blk_issue_secdiscard_rq(struct mmc_queue *mq,
+				       struct request *req)
+{
+	struct mmc_blk_data *md = mq->data;
+	struct mmc_card *card = md->queue.card;
+	unsigned int from, nr, arg;
+	int err = 0;
+
+	mmc_claim_host(card->host);
+
+	if (!mmc_can_secure_erase_trim(card)) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	from = blk_rq_pos(req);
+	nr = blk_rq_sectors(req);
+
+	if (mmc_can_trim(card) && !mmc_erase_group_aligned(card, from, nr))
+		arg = MMC_SECURE_TRIM1_ARG;
+	else
+		arg = MMC_SECURE_ERASE_ARG;
+
+	err = mmc_erase(card, from, nr, arg);
+	if (!err && arg == MMC_SECURE_TRIM1_ARG)
+		err = mmc_erase(card, from, nr, MMC_SECURE_TRIM2_ARG);
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
 static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 {
 	struct mmc_blk_data *md = mq->data;
@@ -505,10 +541,14 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 
 static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 {
-	if (req->cmd_flags & REQ_DISCARD)
-		return mmc_blk_issue_discard_rq(mq, req);
-	else
+	if (req->cmd_flags & REQ_DISCARD) {
+		if (req->cmd_flags & REQ_SECURE)
+			return mmc_blk_issue_secdiscard_rq(mq, req);
+		else
+			return mmc_blk_issue_discard_rq(mq, req);
+	} else {
 		return mmc_blk_issue_rw_rq(mq, req);
+	}
 }
 
 static inline int mmc_blk_readonly(struct mmc_card *card)
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 0add067..a7876d5 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -141,6 +141,9 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 			mq->queue->limits.discard_alignment =
 							card->erase_size << 9;
 		}
+		if (mmc_can_secure_erase_trim(card))
+			queue_flag_set_unlocked(QUEUE_FLAG_SECDISCARD,
+						mq->queue);
 	}
 
 #ifdef CONFIG_MMC_BLOCK_BOUNCE
-- 
1.6.3.3

