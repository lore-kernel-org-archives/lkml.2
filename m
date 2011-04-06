Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151Ab1DFTJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 15:09:28 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48270 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696Ab1DFTI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 15:08:26 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Cc: Chris Ball <cjb@laptop.org>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v2 08/12] mmc: add handling for two parallel block requests in issue_rw_rq
Date: Wed,  6 Apr 2011 21:07:09 +0200
Message-Id: <1302116833-24540-9-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302116833-24540-1-git-send-email-per.forlin@linaro.org>
References: <1302116833-24540-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change mmc_blk_issue_rw_rq() to become asynchronous.
The execution flow looks like this:
The mmc-queue calls issue_rw_rq(), which sends the request
to the host and returns back to the mmc-queue. The mmc-queue calls
isuue_rw_rq() again with a new request. This new request is prepared,
in isuue_rw_rq(), then it waits for the active request to complete before
pushing it to the host. When to mmc-queue is empty it will call
isuue_rw_rq() with req=NULL to finish off the active request
without starting a new request.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 drivers/mmc/card/block.c |  157 +++++++++++++++++++++++++++++++++++++++-------
 drivers/mmc/card/queue.c |    2 +-
 2 files changed, 134 insertions(+), 25 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index f5db000..4b530ae 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -516,24 +516,75 @@ static enum mmc_blk_status mmc_blk_get_status(struct mmc_blk_request *brq,
 
 }
 
-static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
+static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 {
 	struct mmc_blk_data *md = mq->data;
 	struct mmc_card *card = md->queue.card;
-	struct mmc_blk_request *brq = &mq->mqrq_cur->brq;
-	int ret = 1, disable_multi = 0;
+	struct mmc_blk_request *brqc = &mq->mqrq_cur->brq;
+	struct mmc_blk_request *brqp = &mq->mqrq_prev->brq;
+	struct mmc_queue_req  *mqrqp = mq->mqrq_prev;
+	struct request *rqp = mqrqp->req;
+	int ret = 0;
+	int disable_multi = 0;
 	enum mmc_blk_status status;
 
-	mmc_claim_host(card->host);
+	if (!rqc && !rqp)
+		return 0;
 
-	do {
-		mmc_blk_rw_rq_prep(mq->mqrq_cur, card, disable_multi, mq);
-		mmc_wait_for_req(card->host, &brq->mrq);
+	if (rqc) {
+		/* Claim host for the first request in a serie of requests */
+		if (!rqp)
+			mmc_claim_host(card->host);
 
-		mmc_queue_bounce_post(mq->mqrq_cur);
-		status = mmc_blk_get_status(brq, req, card, md);
+		/* Prepare a new request */
+		mmc_blk_rw_rq_prep(mq->mqrq_cur, card, 0, mq);
+		mmc_pre_req(card->host, &brqc->mrq, !rqp);
+	}
+	do {
+		/*
+		 * If there is an ongoing request, indicated by rqp, wait for
+		 * it to finish before starting a new one.
+		 */
+		if (rqp)
+			mmc_wait_for_req_done(&brqp->mrq);
+		else {
+			/* start a new asynchronous request */
+			mmc_start_req(card->host, &brqc->mrq);
+			goto out;
+		}
+		status = mmc_blk_get_status(brqp, rqp, card, md);
+		if (status != MMC_BLK_SUCCESS) {
+			mmc_post_req(card->host, &brqp->mrq, -EINVAL);
+			mmc_queue_bounce_post(mqrqp);
+			if (rqc)
+				mmc_post_req(card->host, &brqc->mrq, -EINVAL);
+		}
 
 		switch (status) {
+		case MMC_BLK_SUCCESS:
+			/*
+			 * A block was successfully transferred.
+			 */
+
+			/*
+			 * All data is transferred without errors.
+			 * Defer mmc post processing and _blk_end_request
+			 * until after the new request is started.
+			 */
+			if (blk_rq_bytes(rqp) == brqp->data.bytes_xfered)
+				break;
+
+			mmc_post_req(card->host, &brqp->mrq, 0);
+			mmc_queue_bounce_post(mqrqp);
+
+			spin_lock_irq(&md->lock);
+			ret = __blk_end_request(rqp, 0,
+						brqp->data.bytes_xfered);
+			spin_unlock_irq(&md->lock);
+
+			if (rqc)
+				mmc_post_req(card->host, &brqc->mrq, -EINVAL);
+			break;
 		case MMC_BLK_CMD_ERR:
 			goto cmd_err;
 			break;
@@ -548,27 +599,73 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 			 * read a single sector.
 			 */
 			spin_lock_irq(&md->lock);
-			ret = __blk_end_request(req, -EIO,
-						brq->data.blksz);
+			ret = __blk_end_request(rqp, -EIO, brqp->data.blksz);
 			spin_unlock_irq(&md->lock);
-
+			if (rqc && !ret)
+				mmc_pre_req(card->host, &brqc->mrq, false);
 			break;
-		case MMC_BLK_SUCCESS:
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
+			mmc_blk_rw_rq_prep(mqrqp, card, disable_multi, mq);
+			mmc_pre_req(card->host, &brqp->mrq, true);
+			mmc_start_req(card->host, &brqp->mrq);
+			if (rqc)
+				mmc_pre_req(card->host, &brqc->mrq, false);
 		}
 	} while (ret);
 
-	mmc_release_host(card->host);
+	/* Previous request is completed, start the new request if any */
+	if (rqc)
+		mmc_start_req(card->host, &brqc->mrq);
+
+	/*
+	 * Post process the previous request while the new request is active.
+	 * In case of error the reuqest is already ended.
+	 */
+	if (status == MMC_BLK_SUCCESS) {
+		mmc_post_req(card->host, &brqp->mrq, 0);
+		mmc_queue_bounce_post(mqrqp);
+
+		spin_lock_irq(&md->lock);
+		ret = __blk_end_request(rqp, 0, brqp->data.bytes_xfered);
+		spin_unlock_irq(&md->lock);
+
+		if (ret) {
+			/* If this happen it is a bug */
+			printk(KERN_ERR "[%s] BUG: rq_bytes %d xfered %d\n",
+			       __func__, blk_rq_bytes(rqp),
+			       brqp->data.bytes_xfered);
+			goto cmd_err;
+		}
+	}
+
+	/* 1 indicates one request has been completed */
+	ret = 1;
+ out:
+	/*
+	 * TODO: Find out if it is OK to only release host after the
+	 *       last request. For the last request the current request
+	 *        is NULL, which means no requests are pending.
+	 */
+	/* Release host for the last request in a serie of requests */
+	if (!rqc)
+		mmc_release_host(card->host);
 
-	return 1;
+	/* Current request becomes previous request and vice versa. */
+	mqrqp->brq.mrq.data = NULL;
+	mqrqp->req = NULL;
+	mq->mqrq_prev = mq->mqrq_cur;
+	mq->mqrq_cur = mqrqp;
+
+	return ret;
 
  cmd_err:
+
  	/*
  	 * If this is an SD card and we're writing, we can first
  	 * mark the known good sectors as ok.
@@ -583,12 +680,12 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 		blocks = mmc_sd_num_wr_blocks(card);
 		if (blocks != (u32)-1) {
 			spin_lock_irq(&md->lock);
-			ret = __blk_end_request(req, 0, blocks << 9);
+			ret = __blk_end_request(rqp, 0, blocks << 9);
 			spin_unlock_irq(&md->lock);
 		}
 	} else {
 		spin_lock_irq(&md->lock);
-		ret = __blk_end_request(req, 0, brq->data.bytes_xfered);
+		ret = __blk_end_request(rqp, 0, brqp->data.bytes_xfered);
 		spin_unlock_irq(&md->lock);
 	}
 
@@ -596,15 +693,27 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 
 	spin_lock_irq(&md->lock);
 	while (ret)
-		ret = __blk_end_request(req, -EIO, blk_rq_cur_bytes(req));
+		ret = __blk_end_request(rqp, -EIO, blk_rq_cur_bytes(rqp));
 	spin_unlock_irq(&md->lock);
 
+	if (rqc) {
+		mmc_claim_host(card->host);
+		mmc_pre_req(card->host, &brqc->mrq, false);
+		mmc_start_req(card->host, &brqc->mrq);
+	}
+
+	/* Current request becomes previous request and vice versa. */
+	mqrqp->brq.mrq.data = NULL;
+	mqrqp->req = NULL;
+	mq->mqrq_prev = mq->mqrq_cur;
+	mq->mqrq_cur = mqrqp;
+
 	return 0;
 }
 
 static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 {
-	if (req->cmd_flags & REQ_DISCARD) {
+	if (req && req->cmd_flags & REQ_DISCARD) {
 		if (req->cmd_flags & REQ_SECURE)
 			return mmc_blk_issue_secdiscard_rq(mq, req);
 		else
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index eef3510..2b14d1c 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -59,6 +59,7 @@ static int mmc_queue_thread(void *d)
 		mq->mqrq_cur->req = req;
 		spin_unlock_irq(q->queue_lock);
 
+		mq->issue_fn(mq, req);
 		if (!req) {
 			if (kthread_should_stop()) {
 				set_current_state(TASK_RUNNING);
@@ -71,7 +72,6 @@ static int mmc_queue_thread(void *d)
 		}
 		set_current_state(TASK_RUNNING);
 
-		mq->issue_fn(mq, req);
 	} while (1);
 	up(&mq->thread_sem);
 
-- 
1.7.4.1

