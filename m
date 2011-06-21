Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640Ab1FUXkT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 19:40:19 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65291 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757606Ab1FUXkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 19:40:14 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linaro-dev@lists.linaro.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, Venkatraman S <svenkatr@ti.com>
Cc: Chris Ball <cjb@laptop.org>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v7 11/11] mmc: add handling for two parallel block requests in issue_rw_rq
Date: Wed, 22 Jun 2011 01:38:41 +0200
Message-Id: <1308699521-20556-12-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308699521-20556-1-git-send-email-per.forlin@linaro.org>
References: <1308699521-20556-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change mmc_blk_issue_rw_rq() to become asynchronous.
The execution flow looks like this:
The mmc-queue calls issue_rw_rq(), which sends the request
to the host and returns back to the mmc-queue. The mmc-queue calls
issue_rw_rq() again with a new request. This new request is prepared,
in isuue_rw_rq(), then it waits for the active request to complete before
pushing it to the host. When to mmc-queue is empty it will call
isuue_rw_rq() with req=NULL to finish off the active request
without starting a new request.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 drivers/mmc/card/block.c |  124 +++++++++++++++++++++++++++++++++------------
 drivers/mmc/card/queue.c |   17 +++++--
 drivers/mmc/card/queue.h |    1 +
 3 files changed, 104 insertions(+), 38 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 6a84a75..22acdd7 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -108,6 +108,7 @@ static DEFINE_MUTEX(open_lock);
 
 enum mmc_blk_status {
 	MMC_BLK_SUCCESS = 0,
+	MMC_BLK_PARTIAL,
 	MMC_BLK_RETRY,
 	MMC_BLK_DATA_ERR,
 	MMC_BLK_CMD_ERR,
@@ -668,14 +669,16 @@ static inline void mmc_apply_rel_rw(struct mmc_blk_request *brq,
 	}
 }
 
-static enum mmc_blk_status mmc_blk_err_check(struct mmc_blk_request *brq,
-					     struct request *req,
-					     struct mmc_card *card,
-					     struct mmc_blk_data *md)
+static int mmc_blk_err_check(struct mmc_card *card,
+			     struct mmc_async_req *areq)
 {
 	struct mmc_command cmd;
 	u32 status = 0;
 	enum mmc_blk_status ret = MMC_BLK_SUCCESS;
+	struct mmc_queue_req *mq_mrq = container_of(areq, struct mmc_queue_req,
+						    mmc_active);
+	struct mmc_blk_request *brq = &mq_mrq->brq;
+	struct request *req = mq_mrq->req;
 
 	/*
 	 * Check for errors here, but don't jump to cmd_err
@@ -770,7 +773,11 @@ static enum mmc_blk_status mmc_blk_err_check(struct mmc_blk_request *brq,
 		else
 			ret = MMC_BLK_DATA_ERR;
 	}
-out:
+
+	if (ret == MMC_BLK_SUCCESS &&
+	    blk_rq_bytes(req) != brq->data.bytes_xfered)
+		ret = MMC_BLK_PARTIAL;
+ out:
 	return ret;
 }
 
@@ -901,27 +908,59 @@ static void mmc_blk_rw_rq_prep(struct mmc_queue_req *mqrq,
 		brq->data.sg_len = i;
 	}
 
+	mqrq->mmc_active.mrq = &brq->mrq;
+	mqrq->mmc_active.err_check = mmc_blk_err_check;
+
 	mmc_queue_bounce_pre(mqrq);
 }
 
-static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
+static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 {
 	struct mmc_blk_data *md = mq->data;
 	struct mmc_card *card = md->queue.card;
-	struct mmc_blk_request *brq = &mq->mqrq_cur->brq;
-	int ret = 1, disable_multi = 0;
+	struct mmc_blk_request *brq;
+	int ret = 1;
+	int disable_multi = 0;
 	enum mmc_blk_status status;
+	struct mmc_queue_req *mq_rq;
+	struct request *req;
+	struct mmc_async_req *areq;
+
+	if (!rqc && !mq->mqrq_prev->req)
+		goto out;
 
 	do {
-		mmc_blk_rw_rq_prep(mq->mqrq_cur, card, disable_multi, mq);
-		mmc_wait_for_req(card->host, &brq->mrq);
+		if (rqc) {
+			mmc_blk_rw_rq_prep(mq->mqrq_cur, card, 0, mq);
+			areq = &mq->mqrq_cur->mmc_active;
+		} else
+			areq = NULL;
+		areq = mmc_start_req(card->host, areq, (int *) &status);
+		if (!areq)
+			goto out;
 
-		mmc_queue_bounce_post(mq->mqrq_cur);
-		status = mmc_blk_err_check(brq, req, card, md);
+		mq_rq = container_of(areq, struct mmc_queue_req, mmc_active);
+		brq = &mq_rq->brq;
+		req = mq_rq->req;
+		mmc_queue_bounce_post(mq_rq);
 
 		switch (status) {
-		case MMC_BLK_CMD_ERR:
-			goto cmd_err;
+		case MMC_BLK_SUCCESS:
+		case MMC_BLK_PARTIAL:
+			/*
+			 * A block was successfully transferred.
+			 */
+			spin_lock_irq(&md->lock);
+			ret = __blk_end_request(req, 0,
+						brq->data.bytes_xfered);
+			spin_unlock_irq(&md->lock);
+			if (status == MMC_BLK_SUCCESS && ret) {
+				/* If this happen it is a bug */
+				printk(KERN_ERR "%s BUG rq_tot %d d_xfer %d\n",
+				       __func__, blk_rq_bytes(req),
+				       brq->data.bytes_xfered);
+				goto cmd_err;
+			}
 			break;
 		case MMC_BLK_RETRY:
 			disable_multi = 1;
@@ -934,36 +973,41 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 			 * read a single sector.
 			 */
 			spin_lock_irq(&md->lock);
-			ret = __blk_end_request(req, -EIO,
-						brq->data.blksz);
+			ret = __blk_end_request(req, -EIO, brq->data.blksz);
 			spin_unlock_irq(&md->lock);
-
+			if (!ret)
+				goto start_new_req;
 			break;
-		case MMC_BLK_SUCCESS:
+		case MMC_BLK_CMD_ERR:
+			ret = 1;
+			goto cmd_err;
+			break;
+		}
+
+		if (ret) {
 			/*
-			 * A block was successfully transferred.
+			 * In case of a none complete request
+			 * prepare it again and resend.
 			 */
-			spin_lock_irq(&md->lock);
-			ret = __blk_end_request(req, 0, brq->data.bytes_xfered);
-			spin_unlock_irq(&md->lock);
-			break;
+			mmc_blk_rw_rq_prep(mq_rq, card, disable_multi, mq);
+			mmc_start_req(card->host, &mq_rq->mmc_active, NULL);
 		}
 	} while (ret);
 
 	return 1;
-
+ out:
+	return 0;
  cmd_err:
- 	/*
- 	 * If this is an SD card and we're writing, we can first
- 	 * mark the known good sectors as ok.
- 	 *
+	/*
+	 * If this is an SD card and we're writing, we can first
+	 * mark the known good sectors as ok.
+	 *
 	 * If the card is not SD, we can still ok written sectors
 	 * as reported by the controller (which might be less than
 	 * the real number of written sectors, but never more).
 	 */
 	if (mmc_card_sd(card)) {
 		u32 blocks;
-
 		blocks = mmc_sd_num_wr_blocks(card);
 		if (blocks != (u32)-1) {
 			spin_lock_irq(&md->lock);
@@ -981,6 +1025,12 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 		ret = __blk_end_request(req, -EIO, blk_rq_cur_bytes(req));
 	spin_unlock_irq(&md->lock);
 
+ start_new_req:
+	if (rqc) {
+		mmc_blk_rw_rq_prep(mq->mqrq_cur, card, 0, mq);
+		mmc_start_req(card->host, &mq->mqrq_cur->mmc_active, NULL);
+	}
+
 	return 0;
 }
 
@@ -990,26 +1040,34 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 	struct mmc_blk_data *md = mq->data;
 	struct mmc_card *card = md->queue.card;
 
-	mmc_claim_host(card->host);
+	if (req && !mq->mqrq_prev->req)
+		/* claim host only for the first request */
+		mmc_claim_host(card->host);
+
 	ret = mmc_blk_part_switch(card, md);
 	if (ret) {
 		ret = 0;
 		goto out;
 	}
 
-	if (req->cmd_flags & REQ_DISCARD) {
+	if (req && req->cmd_flags & REQ_DISCARD) {
+		/* complete ongoing async transfer before issuing discard */
+		if (card->host->areq)
+			mmc_blk_issue_rw_rq(mq, NULL);
 		if (req->cmd_flags & REQ_SECURE)
 			ret = mmc_blk_issue_secdiscard_rq(mq, req);
 		else
 			ret = mmc_blk_issue_discard_rq(mq, req);
-	} else if (req->cmd_flags & REQ_FLUSH) {
+	} else if (req && req->cmd_flags & REQ_FLUSH) {
 		ret = mmc_blk_issue_flush(mq, req);
 	} else {
 		ret = mmc_blk_issue_rw_rq(mq, req);
 	}
 
 out:
-	mmc_release_host(card->host);
+	if (!req)
+		/* release host only when there are no more requests */
+		mmc_release_host(card->host);
 	return ret;
 }
 
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 0757a39..2d6696a 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -52,6 +52,7 @@ static int mmc_queue_thread(void *d)
 	down(&mq->thread_sem);
 	do {
 		struct request *req = NULL;
+		struct mmc_queue_req *tmp;
 
 		spin_lock_irq(q->queue_lock);
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -59,7 +60,10 @@ static int mmc_queue_thread(void *d)
 		mq->mqrq_cur->req = req;
 		spin_unlock_irq(q->queue_lock);
 
-		if (!req) {
+		if (req || mq->mqrq_prev->req) {
+			set_current_state(TASK_RUNNING);
+			mq->issue_fn(mq, req);
+		} else {
 			if (kthread_should_stop()) {
 				set_current_state(TASK_RUNNING);
 				break;
@@ -67,11 +71,14 @@ static int mmc_queue_thread(void *d)
 			up(&mq->thread_sem);
 			schedule();
 			down(&mq->thread_sem);
-			continue;
 		}
-		set_current_state(TASK_RUNNING);
 
-		mq->issue_fn(mq, req);
+		/* Current request becomes previous request and vice versa. */
+		mq->mqrq_prev->brq.mrq.data = NULL;
+		mq->mqrq_prev->req = NULL;
+		tmp = mq->mqrq_prev;
+		mq->mqrq_prev = mq->mqrq_cur;
+		mq->mqrq_cur = tmp;
 	} while (1);
 	up(&mq->thread_sem);
 
@@ -97,7 +104,7 @@ static void mmc_request(struct request_queue *q)
 		return;
 	}
 
-	if (!mq->mqrq_cur->req)
+	if (!mq->mqrq_cur->req && !mq->mqrq_prev->req)
 		wake_up_process(mq->thread);
 }
 
diff --git a/drivers/mmc/card/queue.h b/drivers/mmc/card/queue.h
index c8fb2dc..f937538 100644
--- a/drivers/mmc/card/queue.h
+++ b/drivers/mmc/card/queue.h
@@ -19,6 +19,7 @@ struct mmc_queue_req {
 	char			*bounce_buf;
 	struct scatterlist	*bounce_sg;
 	unsigned int		bounce_sg_len;
+	struct mmc_async_req	mmc_active;
 };
 
 struct mmc_queue {
-- 
1.7.4.1

