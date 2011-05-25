Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932871Ab1EYV6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 17:58:50 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38928 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932847Ab1EYV6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 17:58:46 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        David Vrabel <david.vrabel@csr.com>
Cc: Chris Ball <cjb@laptop.org>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v4 12/12] mmc: add handling for two parallel block requests in issue_rw_rq
Date: Wed, 25 May 2011 23:57:33 +0200
Message-Id: <1306360653-6196-13-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1306360653-6196-1-git-send-email-per.forlin@linaro.org>
References: <1306360653-6196-1-git-send-email-per.forlin@linaro.org>
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
 drivers/mmc/card/block.c |  118 ++++++++++++++++++++++++++++++++-------------
 drivers/mmc/card/queue.c |   17 +++++--
 drivers/mmc/card/queue.h |    1 +
 3 files changed, 97 insertions(+), 39 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 1c0b077..72f2362 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -81,6 +81,7 @@ static DEFINE_MUTEX(open_lock);
 
 enum mmc_blk_status {
 	MMC_BLK_SUCCESS = 0,
+	MMC_BLK_PARTIAL,
 	MMC_BLK_RETRY,
 	MMC_BLK_DATA_ERR,
 	MMC_BLK_CMD_ERR,
@@ -331,14 +332,16 @@ out:
 	return err ? 0 : 1;
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
@@ -422,9 +425,12 @@ static enum mmc_blk_status mmc_blk_err_check(struct mmc_blk_request *brq,
 		else
 			ret = MMC_BLK_CMD_ERR;
 	}
+
+	if (ret == MMC_BLK_SUCCESS &&
+	    blk_rq_bytes(req) != brq->data.bytes_xfered)
+		ret = MMC_BLK_PARTIAL;
  out:
 	return ret;
-
 }
 
 static void mmc_blk_rw_rq_prep(struct mmc_queue_req *mqrq,
@@ -513,29 +519,62 @@ static void mmc_blk_rw_rq_prep(struct mmc_queue_req *mqrq,
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
 
-	mmc_claim_host(card->host);
+	if (!rqc && !mq->mqrq_prev->req)
+		goto out;
+
+	if (rqc && !mq->mqrq_prev->req)
+		mmc_claim_host(card->host);
 
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
@@ -548,38 +587,44 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
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
 
-	mmc_release_host(card->host);
+	if (!rqc)
+		mmc_release_host(card->host);
 
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
@@ -592,19 +637,24 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 		spin_unlock_irq(&md->lock);
 	}
 
-	mmc_release_host(card->host);
-
 	spin_lock_irq(&md->lock);
 	while (ret)
 		ret = __blk_end_request(req, -EIO, blk_rq_cur_bytes(req));
 	spin_unlock_irq(&md->lock);
 
+ start_new_req:
+	if (rqc) {
+		mmc_blk_rw_rq_prep(mq->mqrq_cur, card, 0, mq);
+		mmc_start_req(card->host, &mq->mqrq_cur->mmc_active, NULL);
+	} else
+		mmc_release_host(card->host);
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
index eef3510..d4fffb7 100644
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
index 0e65807..62c27f8 100644
--- a/drivers/mmc/card/queue.h
+++ b/drivers/mmc/card/queue.h
@@ -18,6 +18,7 @@ struct mmc_queue_req {
 	char			*bounce_buf;
 	struct scatterlist	*bounce_sg;
 	unsigned int		bounce_sg_len;
+	struct mmc_async_req	mmc_active;
 };
 
 struct mmc_queue {
-- 
1.7.4.1

