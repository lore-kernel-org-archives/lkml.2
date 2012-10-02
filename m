Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab2JBPkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:40:23 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33317 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab2JBPkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:40:21 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6852"; a="242373928"
From: Konstantin Dorfman <kdorfman@codeaurora.org>
To: linux-mmc@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org,
        Konstantin Dorfman <kdorfman@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] mmc: fix async request mechanism for sequential read scenarios
Date: Tue,  2 Oct 2012 17:39:38 +0200
Message-Id: <1349192378-1676-2-git-send-email-kdorfman@codeaurora.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1349192378-1676-1-git-send-email-kdorfman@codeaurora.org>
References: <n>
 <1349192378-1676-1-git-send-email-kdorfman@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main assumption of the async request design is that the file
system adds block requests to the block device queue asynchronously
without waiting for completion (see the Rationale section of
https://wiki.linaro.org/WorkingGroups/Kernel/Specs
/StoragePerfMMC-async-req).

We found out that in case of sequential read operations this is not
the case, due to the read ahead mechanism.
When mmcqt reports on completion of a request there should be
a context switch to allow the insertion of the next read ahead BIOs
to the block layer. Since the mmcqd tries to fetch another request
immediately after the completion of the previous request it gets NULL
and starts waiting for the completion of the previous request.
This wait on completion gives the FS the opportunity to insert the next
request but the MMC layer is already blocked on the previous request
completion and is not aware of the new request waiting to be fetched.

This patch fixes the above behavior and allows the async request mechanism
to work in case of sequential read scenarios.
The main idea is to replace the blocking wait for a completion with an
event driven mechanism and add a new event of new_request.
When the block layer notifies the MMC layer on a new request, we check
for the above case where MMC layer is waiting on a previous request
completion and the current request is NULL.
In such a case the new_request event will be triggered to wakeup
the waiting thread. MMC layer will then fetch the new request
and after its preparation will go back to waiting on the completion.

Our tests showed that this fix improves the read sequential throughput
by 16%.

Signed-off-by: Konstantin Dorfman <kdorfman@codeaurora.org>

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 172a768..cb32d4c 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -112,17 +112,6 @@ struct mmc_blk_data {
 
 static DEFINE_MUTEX(open_lock);
 
-enum mmc_blk_status {
-	MMC_BLK_SUCCESS = 0,
-	MMC_BLK_PARTIAL,
-	MMC_BLK_CMD_ERR,
-	MMC_BLK_RETRY,
-	MMC_BLK_ABORT,
-	MMC_BLK_DATA_ERR,
-	MMC_BLK_ECC_ERR,
-	MMC_BLK_NOMEDIUM,
-};
-
 module_param(perdev_minors, int, 0444);
 MODULE_PARM_DESC(perdev_minors, "Minors numbers to allocate per device");
 
@@ -1224,6 +1213,7 @@ static void mmc_blk_rw_rq_prep(struct mmc_queue_req *mqrq,
 	}
 
 	mqrq->mmc_active.mrq = &brq->mrq;
+	mqrq->mmc_active.mrq->sync_data = &mq->sync_data;
 	mqrq->mmc_active.err_check = mmc_blk_err_check;
 
 	mmc_queue_bounce_pre(mqrq);
@@ -1284,9 +1274,12 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 			areq = &mq->mqrq_cur->mmc_active;
 		} else
 			areq = NULL;
-		areq = mmc_start_req(card->host, areq, (int *) &status);
-		if (!areq)
+		areq = mmc_start_data_req(card->host, areq, (int *) &status);
+		if (!areq) {
+			if (status == MMC_BLK_NEW_PACKET)
+				return status;
 			return 0;
+		}
 
 		mq_rq = container_of(areq, struct mmc_queue_req, mmc_active);
 		brq = &mq_rq->brq;
@@ -1295,6 +1288,9 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 		mmc_queue_bounce_post(mq_rq);
 
 		switch (status) {
+		case MMC_BLK_NEW_PACKET:
+			BUG_ON(1); /* should never get here */
+			return MMC_BLK_NEW_PACKET;
 		case MMC_BLK_SUCCESS:
 		case MMC_BLK_PARTIAL:
 			/*
@@ -1367,7 +1363,8 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 			 * prepare it again and resend.
 			 */
 			mmc_blk_rw_rq_prep(mq_rq, card, disable_multi, mq);
-			mmc_start_req(card->host, &mq_rq->mmc_active, NULL);
+			mmc_start_req(card->host, &mq_rq->mmc_active,
+					(int *) &status);
 		}
 	} while (ret);
 
@@ -1382,7 +1379,7 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
  start_new_req:
 	if (rqc) {
 		mmc_blk_rw_rq_prep(mq->mqrq_cur, card, 0, mq);
-		mmc_start_req(card->host, &mq->mqrq_cur->mmc_active, NULL);
+		mmc_start_data_req(card->host, &mq->mqrq_cur->mmc_active, NULL);
 	}
 
 	return 0;
@@ -1426,9 +1423,10 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 	}
 
 out:
-	if (!req)
+	if (!req && (ret != MMC_BLK_NEW_PACKET))
 		/* release host only when there are no more requests */
 		mmc_release_host(card->host);
+
 	return ret;
 }
 
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index e360a97..71e2610 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -67,7 +67,9 @@ static int mmc_queue_thread(void *d)
 
 		if (req || mq->mqrq_prev->req) {
 			set_current_state(TASK_RUNNING);
-			mq->issue_fn(mq, req);
+			if (mq->issue_fn(mq, req) == MMC_BLK_NEW_PACKET) {
+				continue; /* fetch again */
+			}
 		} else {
 			if (kthread_should_stop()) {
 				set_current_state(TASK_RUNNING);
@@ -98,6 +100,7 @@ static int mmc_queue_thread(void *d)
  */
 static void mmc_request_fn(struct request_queue *q)
 {
+	unsigned long flags;
 	struct mmc_queue *mq = q->queuedata;
 	struct request *req;
 
@@ -108,9 +111,26 @@ static void mmc_request_fn(struct request_queue *q)
 		}
 		return;
 	}
-
-	if (!mq->mqrq_cur->req && !mq->mqrq_prev->req)
-		wake_up_process(mq->thread);
+	if (!mq->mqrq_cur->req && mq->mqrq_prev->req) {
+		/* new packet arrived, while mmc context waiting with no
+		 * async packet
+		 */
+		mq->sync_data.skip_awake_flag = false;
+		/* critical section with mmc_wait_data_req_done() */
+		spin_lock_irqsave(&mq->sync_data.lock, flags);
+		/* do stop flow only when mmc thread is waiting for done */
+		if (mq->sync_data.waiting_flag &&
+				!mq->sync_data.new_packet_flag &&
+				!mq->sync_data.skip_awake_flag) {
+
+			mq->sync_data.new_packet_flag = true;
+			wake_up_interruptible(&mq->sync_data.wait);
+		}
+		spin_unlock_irqrestore(&mq->sync_data.lock, flags);
+	} else {
+		if (!mq->mqrq_cur->req && !mq->mqrq_prev->req)
+			wake_up_process(mq->thread);
+	}
 }
 
 static struct scatterlist *mmc_alloc_sg(int sg_len, int *err)
@@ -259,6 +279,12 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
 	}
 
 	sema_init(&mq->thread_sem, 1);
+	spin_lock_init(&mq->sync_data.lock);
+	mq->sync_data.skip_awake_flag = false;
+	mq->sync_data.new_packet_flag = false;
+	mq->sync_data.done_flag = false;
+	mq->sync_data.waiting_flag = false;
+	init_waitqueue_head(&mq->sync_data.wait);
 
 	mq->thread = kthread_run(mmc_queue_thread, mq, "mmcqd/%d%s",
 		host->index, subname ? subname : "");
diff --git a/drivers/mmc/card/queue.h b/drivers/mmc/card/queue.h
index d2a1eb4..bcccfd6 100644
--- a/drivers/mmc/card/queue.h
+++ b/drivers/mmc/card/queue.h
@@ -33,6 +33,7 @@ struct mmc_queue {
 	struct mmc_queue_req	mqrq[2];
 	struct mmc_queue_req	*mqrq_cur;
 	struct mmc_queue_req	*mqrq_prev;
+	struct mmc_sync_data	sync_data;
 };
 
 extern int mmc_init_queue(struct mmc_queue *, struct mmc_card *, spinlock_t *,
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index af2c4d2..7cda08b 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -245,11 +245,52 @@ mmc_start_request(struct mmc_host *host, struct mmc_request *mrq)
 	host->ops->request(host, mrq);
 }
 
+/*
+ * mmc_wait_data_done() - done callback for data request
+ * @mrq: done data request
+ *
+ * Wakes up mmc context, passed as callback to host controller driver
+ */
+static void mmc_wait_data_done(struct mmc_request *mrq)
+{
+	unsigned long flags;
+
+	/* critical section with  blk layer notifications */
+	spin_lock_irqsave(&mrq->sync_data->lock, flags);
+	mrq->sync_data->skip_awake_flag = true;
+	mrq->sync_data->done_flag = true;
+	wake_up_interruptible(&mrq->sync_data->wait);
+	spin_unlock_irqrestore(&mrq->sync_data->lock, flags);
+}
+
 static void mmc_wait_done(struct mmc_request *mrq)
 {
 	complete(&mrq->completion);
 }
 
+/*
+ *__mmc_start_data_req() - starts data request
+ * @host: MMC host to start the request
+ * @mrq: data request to start
+ *
+ * Fills done callback that will be used when request are done by card.
+ * Starts data mmc request execution
+ */
+static int __mmc_start_data_req(struct mmc_host *host, struct mmc_request *mrq)
+{
+	mrq->done = mmc_wait_data_done;
+	if (mmc_card_removed(host->card)) {
+		mrq->cmd->error = -ENOMEDIUM;
+		/*
+		 * TODO: do we need to wake_up_interruptible(&mrq->mq->wait)
+		 *       same way it's done in __mmc_start_req?
+		 */
+		return -ENOMEDIUM;
+	}
+	mmc_start_request(host, mrq);
+	return 0;
+}
+
 static int __mmc_start_req(struct mmc_host *host, struct mmc_request *mrq)
 {
 	init_completion(&mrq->completion);
@@ -263,6 +304,64 @@ static int __mmc_start_req(struct mmc_host *host, struct mmc_request *mrq)
 	return 0;
 }
 
+/*
+ * mmc_wait_for_data_req_done() - wait for request completed or new
+ *				  request notification arrives
+ * @host: MMC host to prepare the command.
+ * @mrq: MMC request to wait for
+ *
+ * Blocks MMC context till host controller will ack end of data request
+ * execution or new request arrives from block layer. Handles
+ * command retries.
+ *
+ * Returns enum mmc_blk_status after checking errors.
+ */
+static int mmc_wait_for_data_req_done(struct mmc_host *host,
+				      struct mmc_request *mrq)
+{
+	struct mmc_command *cmd;
+	struct mmc_sync_data *sync_data = mrq->sync_data;
+	bool done_flag = false;
+	bool new_packet_flag = false;
+	int err;
+
+	while (1) {
+		sync_data->waiting_flag = true;
+		sync_data->new_packet_flag = false;
+		wait_event_interruptible(sync_data->wait,
+				(sync_data->done_flag ||
+				 sync_data->new_packet_flag));
+		sync_data->waiting_flag = false;
+		done_flag = sync_data->done_flag;
+		new_packet_flag = sync_data->new_packet_flag;
+		if (done_flag) {
+			sync_data->done_flag = false;
+			sync_data->new_packet_flag = false;
+			cmd = mrq->cmd;
+			if (!cmd->error || !cmd->retries ||
+					mmc_card_removed(host->card)) {
+				err = host->areq->err_check(host->card,
+						host->areq);
+				break; /* return err */
+			} else {
+				pr_info("%s: req failed (CMD%u): %d, retrying...\n",
+						mmc_hostname(host),
+						cmd->opcode, cmd->error);
+				cmd->retries--;
+				cmd->error = 0;
+				host->ops->request(host, mrq);
+				sync_data->done_flag = false;
+				continue; /* wait for done/new event again */
+			}
+		} else if (new_packet_flag) {
+			sync_data->new_packet_flag = false;
+			err = MMC_BLK_NEW_PACKET;
+			break; /* return err */
+		}
+	} /* while */
+	return err;
+}
+
 static void mmc_wait_for_req_done(struct mmc_host *host,
 				  struct mmc_request *mrq)
 {
@@ -325,6 +424,72 @@ static void mmc_post_req(struct mmc_host *host, struct mmc_request *mrq,
 }
 
 /**
+ * mmc_start_data_req - start a non-blocking data request
+ * @host: MMC host to start the command
+ * @areq: async request to start
+ * @error: out parameter; returns 0 for success, otherwise non zero
+ *
+ * Wait for the ongoing request (previoulsy started) to complete and
+ * return the completed request. If there is no ongoing request, NULL
+ * is returned without waiting. NULL is not an error condition.
+ */
+struct mmc_async_req *mmc_start_data_req(struct mmc_host *host,
+					 struct mmc_async_req *areq, int *error)
+{
+	int err = 0;
+	int start_err = 0;
+	struct mmc_async_req *data = host->areq;
+
+	/* Prepare a new request */
+	if (areq) {
+		/*
+		 * start waiting here for possible interrupt
+		 * because mmc_pre_req() taking long time
+		 */
+		areq->mrq->sync_data->waiting_flag = true;
+		mmc_pre_req(host, areq->mrq, !host->areq);
+	}
+
+	if (host->areq) {
+		err = mmc_wait_for_data_req_done(host, host->areq->mrq);
+		if (err == MMC_BLK_NEW_PACKET) {
+			if (areq) {
+				pr_err("%s: new packet while areq = %p",
+						__func__, areq);
+				BUG_ON(1);
+			}
+			*error = err;
+			/*
+			 * The previous request was not completed,
+			 * nothing to return
+			 */
+			return NULL;
+		}
+	}
+
+	if (!err && areq)
+		start_err = __mmc_start_data_req(host, areq->mrq);
+
+	if (host->areq)
+		mmc_post_req(host, host->areq->mrq, 0);
+
+	/* Cancel a prepared request if it was not started. */
+	if ((err || start_err) && areq)
+			mmc_post_req(host, areq->mrq, -EINVAL);
+
+	if (err)
+		host->areq = NULL;
+	else
+		host->areq = areq;
+
+	if (error)
+		*error = err;
+
+	return data;
+}
+EXPORT_SYMBOL(mmc_start_data_req);
+
+/**
  *	mmc_start_req - start a non-blocking request
  *	@host: MMC host to start command
  *	@areq: async request to start
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 4b27f9f..06bff68 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -203,6 +203,18 @@ struct mmc_part {
 #define MMC_BLK_DATA_AREA_GP	(1<<2)
 };
 
+enum mmc_blk_status {
+	MMC_BLK_SUCCESS = 0,
+	MMC_BLK_PARTIAL,
+	MMC_BLK_CMD_ERR,
+	MMC_BLK_RETRY,
+	MMC_BLK_ABORT,
+	MMC_BLK_DATA_ERR,
+	MMC_BLK_ECC_ERR,
+	MMC_BLK_NOMEDIUM,
+	MMC_BLK_NEW_PACKET,
+};
+
 /*
  * MMC device
  */
diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
index 1b431c7..dc59226 100644
--- a/include/linux/mmc/core.h
+++ b/include/linux/mmc/core.h
@@ -120,6 +120,24 @@ struct mmc_data {
 	s32			host_cookie;	/* host private data */
 };
 
+/**
+ * mmc_sync_data - synchronization details for mmc context
+ * @done_flag		wake up reason was done request
+ * @new_packet_flag	wake up reason was new packet
+ * @skip_awake_flag	done arrived, no need in wake up flag
+ * @waiting_flag	mmc context in waiting state flag
+ * @wait		wait queue
+ * @lock		spinlock to protect this struct
+ */
+struct mmc_sync_data {
+	bool			done_flag;
+	bool			new_packet_flag;
+	bool			skip_awake_flag;
+	bool			waiting_flag;
+	wait_queue_head_t	wait;
+	spinlock_t		lock;
+};
+
 struct mmc_request {
 	struct mmc_command	*sbc;		/* SET_BLOCK_COUNT for multiblock */
 	struct mmc_command	*cmd;
@@ -128,6 +146,7 @@ struct mmc_request {
 
 	struct completion	completion;
 	void			(*done)(struct mmc_request *);/* completion function */
+	struct mmc_sync_data    *sync_data;
 };
 
 struct mmc_host;
@@ -136,6 +155,8 @@ struct mmc_async_req;
 
 extern struct mmc_async_req *mmc_start_req(struct mmc_host *,
 					   struct mmc_async_req *, int *);
+extern struct mmc_async_req *mmc_start_data_req(struct mmc_host *,
+					   struct mmc_async_req *, int *);
 extern int mmc_interrupt_hpi(struct mmc_card *);
 extern void mmc_wait_for_req(struct mmc_host *, struct mmc_request *);
 extern int mmc_wait_for_cmd(struct mmc_host *, struct mmc_command *, int);
-- 
1.7.6

--
Konstantin Dorfman,
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of
Code Aurora Forum, hosted by The Linux Foundation
