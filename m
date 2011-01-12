Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab1ALSPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 13:15:31 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34668 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932344Ab1ALSPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 13:15:24 -0500
From: Per Forlin <per.forlin@linaro.org>
To: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@lists.linaro.org
Cc: Chris Ball <cjb@laptop.org>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH 5/5] mmc: Add double buffering for mmc block requests
Date: Wed, 12 Jan 2011 19:14:03 +0100
Message-Id: <1294856043-13447-6-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1294856043-13447-1-git-send-email-per.forlin@linaro.org>
References: <1294856043-13447-1-git-send-email-per.forlin@linaro.org>
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
 drivers/mmc/card/block.c |  170 +++++++++++++++++++++++++++++++++++----------
 drivers/mmc/card/queue.c |    2 +-
 drivers/mmc/core/core.c  |   77 ++++++++++++++++++---
 include/linux/mmc/core.h |    7 ++-
 include/linux/mmc/host.h |    8 ++
 5 files changed, 214 insertions(+), 50 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 028b2b8..11e6e97 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -420,62 +420,98 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 	struct mmc_blk_data *md = mq->data;
 	struct mmc_card *card = md->queue.card;
 	struct mmc_blk_request *brqc = &mq->mqrq_cur->brq;
-	int ret = 1, disable_multi = 0;
+	struct mmc_blk_request *brqp = &mq->mqrq_prev->brq;
+	struct mmc_queue_req  *mqrqp = mq->mqrq_prev;
+	struct request *rqp = mqrqp->req;
+	int ret = 0;
+	int disable_multi = 0;
+	bool complete_transfer = true;
+
+	if (!rqc && !rqp) {
+		brqc->mrq.data = NULL;
+		brqp->mrq.data = NULL;
+		return 0;
+	}
 
-	mmc_claim_host(card->host);
+	/*
+	 * TODO: Find out if it is OK to only claim host for the first request.
+	 *       For the first request the previous request is NULL
+	 */
+	if (!rqp && rqc)
+		mmc_claim_host(card->host);
+
+	if (rqc) {
+		/* Prepare a new request */
+		mmc_blk_issue_rw_rq_prep(brqc, mq->mqrq_cur,
+					 rqc, card, 0, mq);
+		mmc_pre_req(card->host, &brqc->mrq, !rqp);
+	}
 
 	do {
 		struct mmc_command cmd;
 		u32 status = 0;
 
-		mmc_blk_issue_rw_rq_prep(brqc, mq->mqrq_cur, rqc, card,
-					 disable_multi, mq);
-		mmc_wait_for_req(card->host, &brqc->mrq);
-
-		mmc_queue_bounce_post(mq->mqrq_cur);
+		/* In case of error redo prepare and resend */
+		if (ret) {
+			mmc_blk_issue_rw_rq_prep(brqp, mqrqp, rqp, card,
+						 disable_multi, mq);
+			mmc_pre_req(card->host, &brqc->mrq, !rqp);
+			mmc_start_req(card->host, &brqp->mrq);
+		}
+		/*
+		 * If there is an ongoing request, indicated by rqp, wait for
+		 * it to finish before starting a new one.
+		 */
+		if (rqp) {
+			mmc_wait_for_req_done(&brqp->mrq);
+		} else {
+			/* start a new asynchronous request */
+			mmc_start_req(card->host, &brqc->mrq);
+			goto out;
+		}
 
 		/*
 		 * Check for errors here, but don't jump to cmd_err
 		 * until later as we need to wait for the card to leave
 		 * programming mode even when things go wrong.
 		 */
-		if (brqc->cmd.error || brqc->data.error || brqc->stop.error) {
-			if (brqc->data.blocks > 1 && rq_data_dir(rqc) == READ) {
+		if (brqp->cmd.error || brqp->data.error || brqp->stop.error) {
+			if (brqp->data.blocks > 1 && rq_data_dir(rqp) == READ) {
 				/* Redo read one sector at a time */
 				printk(KERN_WARNING "%s: retrying using single "
-				       "block read\n", rqc->rq_disk->disk_name);
+				       "block read\n", rqp->rq_disk->disk_name);
 				disable_multi = 1;
 				continue;
 			}
-			status = get_card_status(card, rqc);
+			status = get_card_status(card, rqp);
 		}
 
-		if (brqc->cmd.error) {
+		if (brqp->cmd.error) {
 			printk(KERN_ERR "%s: error %d sending read/write "
 			       "command, response %#x, card status %#x\n",
-			       rqc->rq_disk->disk_name, brqc->cmd.error,
-			       brqc->cmd.resp[0], status);
+			       rqp->rq_disk->disk_name, brqp->cmd.error,
+			       brqp->cmd.resp[0], status);
 		}
 
-		if (brqc->data.error) {
-			if (brqc->data.error == -ETIMEDOUT && brqc->mrq.stop)
+		if (brqp->data.error) {
+			if (brqp->data.error == -ETIMEDOUT && brqp->mrq.stop)
 				/* 'Stop' response contains card status */
-				status = brqc->mrq.stop->resp[0];
+				status = brqp->mrq.stop->resp[0];
 			printk(KERN_ERR "%s: error %d transferring data,"
 			       " sector %u, nr %u, card status %#x\n",
-			       rqc->rq_disk->disk_name, brqc->data.error,
-			       (unsigned)blk_rq_pos(rqc),
-			       (unsigned)blk_rq_sectors(rqc), status);
+			       rqp->rq_disk->disk_name, brqp->data.error,
+			       (unsigned)blk_rq_pos(rqp),
+			       (unsigned)blk_rq_sectors(rqp), status);
 		}
 
-		if (brqc->stop.error) {
+		if (brqp->stop.error) {
 			printk(KERN_ERR "%s: error %d sending stop command, "
 			       "response %#x, card status %#x\n",
-			       rqc->rq_disk->disk_name, brqc->stop.error,
-			       brqc->stop.resp[0], status);
+			       rqp->rq_disk->disk_name, brqp->stop.error,
+			       brqp->stop.resp[0], status);
 		}
 
-		if (!mmc_host_is_spi(card->host) && rq_data_dir(rqc) != READ) {
+		if (!mmc_host_is_spi(card->host) && rq_data_dir(rqp) != READ) {
 			do {
 				int err;
 
@@ -485,7 +521,7 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 				err = mmc_wait_for_cmd(card->host, &cmd, 5);
 				if (err) {
 					printk(KERN_ERR "%s: error %d requesting status\n",
-					       rqc->rq_disk->disk_name, err);
+					       rqp->rq_disk->disk_name, err);
 					goto cmd_err;
 				}
 				/*
@@ -499,22 +535,22 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 #if 0
 			if (cmd.resp[0] & ~0x00000900)
 				printk(KERN_ERR "%s: status = %08x\n",
-				       rqc->rq_disk->disk_name, cmd.resp[0]);
+				       rqp->rq_disk->disk_name, cmd.resp[0]);
 			if (mmc_decode_status(cmd.resp))
 				goto cmd_err;
 #endif
 		}
 
-		if (brqc->cmd.error || brqc->stop.error || brqc->data.error) {
-			if (rq_data_dir(rqc) == READ) {
+		if (brqp->cmd.error || brqp->stop.error || brqp->data.error) {
+			if (rq_data_dir(rqp) == READ) {
 				/*
 				 * After an error, we redo I/O one sector at a
 				 * time, so we only reach here after trying to
 				 * read a single sector.
 				 */
 				spin_lock_irq(&md->lock);
-				ret = __blk_end_request(rqc, -EIO,
-							brqc->data.blksz);
+				ret = __blk_end_request(rqp, -EIO,
+							brqp->data.blksz);
 				spin_unlock_irq(&md->lock);
 				continue;
 			}
@@ -524,14 +560,72 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 		/*
 		 * A block was successfully transferred.
 		 */
+		/*
+		 * TODO: Find out if it safe to only check if
+		 * blk_rq_bytes(req) == data.bytes_xfered to make sure
+		 * the entire request is completed. If equal, defer
+		 * __blk_end_request until after the new request is started.
+		 */
+		if (blk_rq_bytes(rqp) != brqp->data.bytes_xfered ||
+		    !complete_transfer) {
+			complete_transfer = false;
+			mmc_post_req(card->host, &brqp->mrq);
+			mmc_queue_bounce_post(mqrqp);
+
+			spin_lock_irq(&md->lock);
+			ret = __blk_end_request(rqp, 0,
+						brqp->data.bytes_xfered);
+			spin_unlock_irq(&md->lock);
+		}
+	} while (ret);
+
+	/* Previous request is completed, start the new request if any */
+	if (rqc)
+		mmc_start_req(card->host, &brqc->mrq);
+
+	/* Post process the previous request while the new request is active */
+	if (complete_transfer) {
+		mmc_post_req(card->host, &brqp->mrq);
+		mmc_queue_bounce_post(mqrqp);
+
 		spin_lock_irq(&md->lock);
-		ret = __blk_end_request(rqc, 0, brqc->data.bytes_xfered);
+		ret = __blk_end_request(rqp, 0, brqp->data.bytes_xfered);
 		spin_unlock_irq(&md->lock);
-	} while (ret);
 
-	mmc_release_host(card->host);
+		/*
+		 * TODO: Make sure "ret" can never be true and remove the
+		 * if-statement and the code inside it.
+		 */
+		if (ret) {
+			/* This should never happen */
+			printk(KERN_ERR "[%s] BUG: rq_bytes %d xfered %d\n",
+			       __func__, blk_rq_bytes(rqp),
+			       brqp->data.bytes_xfered);
+			BUG();
+		}
+	}
+	/* 1 indicates one request has been completed */
+	ret = 1;
+ out:
+	/*
+	 * TODO: Find out if it is OK to only release host after the
+	 *       last request. For the last request the current request
+	 *        is NULL, which means no requests are pending.
+	 */
+	if (!rqc)
+		mmc_release_host(card->host);
+
+	do {
+		/* Current request becomes previous request and vice versa. */
+		struct mmc_queue_req  *tmp;
+		mq->mqrq_prev->brq.mrq.data = NULL;
+		mq->mqrq_prev->req = NULL;
+		tmp = mq->mqrq_prev;
+		mq->mqrq_prev = mq->mqrq_cur;
+		mq->mqrq_cur = tmp;
+	} while (0);
 
-	return 1;
+	return ret;
 
  cmd_err:
  	/*
@@ -548,12 +642,12 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 		blocks = mmc_sd_num_wr_blocks(card);
 		if (blocks != (u32)-1) {
 			spin_lock_irq(&md->lock);
-			ret = __blk_end_request(rqc, 0, blocks << 9);
+			ret = __blk_end_request(rqp, 0, blocks << 9);
 			spin_unlock_irq(&md->lock);
 		}
 	} else {
 		spin_lock_irq(&md->lock);
-		ret = __blk_end_request(rqc, 0, brqc->data.bytes_xfered);
+		ret = __blk_end_request(rqp, 0, brqp->data.bytes_xfered);
 		spin_unlock_irq(&md->lock);
 	}
 
@@ -561,7 +655,7 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 
 	spin_lock_irq(&md->lock);
 	while (ret)
-		ret = __blk_end_request(rqc, -EIO, blk_rq_cur_bytes(rqc));
+		ret = __blk_end_request(rqp, -EIO, blk_rq_cur_bytes(rqp));
 	spin_unlock_irq(&md->lock);
 
 	return 0;
@@ -569,7 +663,7 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 
 static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 {
-	if (req->cmd_flags & REQ_DISCARD) {
+	if (req && req->cmd_flags & REQ_DISCARD) {
 		if (req->cmd_flags & REQ_SECURE)
 			return mmc_blk_issue_secdiscard_rq(mq, req);
 		else
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 30d4707..30f8ae9 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -60,6 +60,7 @@ static int mmc_queue_thread(void *d)
 		mq->mqrq_cur->req = req;
 		spin_unlock_irq(q->queue_lock);
 
+		mq->issue_fn(mq, req);
 		if (!req) {
 			if (kthread_should_stop()) {
 				set_current_state(TASK_RUNNING);
@@ -72,7 +73,6 @@ static int mmc_queue_thread(void *d)
 		}
 		set_current_state(TASK_RUNNING);
 
-		mq->issue_fn(mq, req);
 	} while (1);
 	up(&mq->thread_sem);
 
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index a3a780f..63b4684 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -195,30 +195,87 @@ mmc_start_request(struct mmc_host *host, struct mmc_request *mrq)
 
 static void mmc_wait_done(struct mmc_request *mrq)
 {
-	complete(mrq->done_data);
+	complete(&mrq->completion);
 }
 
 /**
- *	mmc_wait_for_req - start a request and wait for completion
+ *	mmc_pre_req - Prepare for a new request
+ *	@host: MMC host to prepare command
+ *	@mrq: MMC request to prepare for
+ *	@host_is_idle: true if the host it not processing a request,
+ *		       false if a request may be active on the host.
+ *
+ *	mmc_pre_req() is called in prior to mmc_start_req() to let
+ *	host prepare for the new request. Preparation of a request may be
+ *	performed while another request is running on the host.
+ */
+void mmc_pre_req(struct mmc_host *host, struct mmc_request *mrq,
+		 bool host_is_idle)
+{
+	if (host->ops->pre_req)
+		host->ops->pre_req(host, mrq, host_is_idle);
+}
+EXPORT_SYMBOL(mmc_pre_req);
+
+/**
+ *	mmc_post_req - Post process a completed request
+ *	@host: MMC host to post process command
+ *	@mrq: MMC request to post process for
+ *
+ *	Let the host post process a completed request. Post processing of
+ *	a request may be performed while another reuqest is running.
+ */
+void mmc_post_req(struct mmc_host *host, struct mmc_request *mrq)
+{
+	if (host->ops->post_req)
+		host->ops->post_req(host, mrq);
+}
+EXPORT_SYMBOL(mmc_post_req);
+
+/**
+ *	mmc_start_req - start a request
  *	@host: MMC host to start command
  *	@mrq: MMC request to start
  *
- *	Start a new MMC custom command request for a host, and wait
- *	for the command to complete. Does not attempt to parse the
- *	response.
+ *	Start a new MMC custom command request for a host.
+ *	Does not wait for the command to complete.
  */
-void mmc_wait_for_req(struct mmc_host *host, struct mmc_request *mrq)
+void mmc_start_req(struct mmc_host *host, struct mmc_request *mrq)
 {
-	DECLARE_COMPLETION_ONSTACK(complete);
-
-	mrq->done_data = &complete;
+	init_completion(&mrq->completion);
 	mrq->done = mmc_wait_done;
 
 	mmc_start_request(host, mrq);
+}
+EXPORT_SYMBOL(mmc_start_req);
 
-	wait_for_completion(&complete);
+/**
+ *	mmc_wait_for_req_done - wait for completion of request
+ *	@mrq: MMC request to wait for
+ *
+ *	Wait for the command to complete. Does not attempt to parse the
+ *	response.
+ */
+void mmc_wait_for_req_done(struct mmc_request *mrq)
+{
+	wait_for_completion(&mrq->completion);
 }
+EXPORT_SYMBOL(mmc_wait_for_req_done);
 
+/**
+ *	mmc_wait_for_req - start a request and wait for completion
+ *	@host: MMC host to start command
+ *	@mrq: MMC request to start
+ *
+ *	Start a new MMC custom command request for a host, and wait
+ *	for the command to complete. Does not attempt to parse the
+ *	response.
+ */
+void mmc_wait_for_req(struct mmc_host *host, struct mmc_request *mrq)
+{
+	mmc_start_req(host, mrq);
+	mmc_wait_for_req_done(mrq);
+}
 EXPORT_SYMBOL(mmc_wait_for_req);
 
 /**
diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
index 64e013f..da504f7 100644
--- a/include/linux/mmc/core.h
+++ b/include/linux/mmc/core.h
@@ -124,13 +124,18 @@ struct mmc_request {
 	struct mmc_data		*data;
 	struct mmc_command	*stop;
 
-	void			*done_data;	/* completion data */
+	struct completion	completion;
 	void			(*done)(struct mmc_request *);/* completion function */
 };
 
 struct mmc_host;
 struct mmc_card;
 
+extern void mmc_pre_req(struct mmc_host *host, struct mmc_request *mrq,
+			bool host_is_idle);
+extern void mmc_post_req(struct mmc_host *host, struct mmc_request *mrq);
+extern void mmc_start_req(struct mmc_host *host, struct mmc_request *mrq);
+extern void mmc_wait_for_req_done(struct mmc_request *mrq);
 extern void mmc_wait_for_req(struct mmc_host *, struct mmc_request *);
 extern int mmc_wait_for_cmd(struct mmc_host *, struct mmc_command *, int);
 extern int mmc_wait_for_app_cmd(struct mmc_host *, struct mmc_card *,
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 30f6fad..b85463b 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -88,6 +88,14 @@ struct mmc_host_ops {
 	 */
 	int (*enable)(struct mmc_host *host);
 	int (*disable)(struct mmc_host *host, int lazy);
+	/*
+	 * It is optional for the host to implement pre_req and post_req in
+	 * order to support double buffering of requests (prepare one
+	 * request while another request is active).
+	 */
+	void	(*post_req)(struct mmc_host *host, struct mmc_request *req);
+	void	(*pre_req)(struct mmc_host *host, struct mmc_request *req,
+			   bool host_is_idle);
 	void	(*request)(struct mmc_host *host, struct mmc_request *req);
 	/*
 	 * Avoid calling these three functions too often or in a "fast path",
-- 
1.7.1

