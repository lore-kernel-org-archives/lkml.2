Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590Ab2ITGDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 02:03:15 -0400
Received: from 212.199.104.198.static.012.net.il ([212.199.104.198]:32966 "EHLO
	lx-merez.qi.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751116Ab2ITGDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 02:03:12 -0400
From: Maya Erez <merez@codeaurora.org>
To: linux-mmc@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org,
        Konstantin Dorfman <kdorfman@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC/PATCH 1/2] mmc: Urgent data request flow
Date: Thu, 20 Sep 2012 09:02:31 +0300
Message-Id: <1348120954-6937-2-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konstantin Dorfman <kdorfman@codeaurora.org>

Urgent request notification stops currently running packed
transaction on bus. Finished part of the request will be
acknowledged to the block layer, remainder will be re-inserted
back to be fetched later, this will minimize urgent request latency.

Signed-off-by: Konstantin Dorfman <kdorfman@codeaurora.org>
---
 drivers/mmc/card/block.c |  171 +++++++++++++++++++++++---
 drivers/mmc/card/queue.c |   40 ++++++
 drivers/mmc/card/queue.h |    1 +
 drivers/mmc/core/core.c  |  306 ++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/mmc/card.h |   14 ++
 include/linux/mmc/core.h |   21 +++
 include/linux/mmc/host.h |    4 +
 include/linux/mmc/mmc.h  |    1 +
 8 files changed, 534 insertions(+), 24 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index ea52ac2..e739c2f 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -119,17 +119,6 @@ struct mmc_blk_data {
 
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
 enum {
 	MMC_PACKED_N_IDX = -1,
 	MMC_PACKED_N_ZERO,
@@ -1133,6 +1122,113 @@ static int mmc_blk_err_check(struct mmc_card *card,
 	return MMC_BLK_SUCCESS;
 }
 
+/*
+ * mmc_blk_reinsert_request() - re-insert request back into block layer
+ * @areq:	request to re-insert.
+ *
+ * Request may be packed or single. When fails to reinsert request, -EIO will be
+ * reported for this request and rest of packed_list
+ */
+static void mmc_blk_reinsert_request(struct mmc_async_req *areq)
+{
+	struct request *prq;
+	int ret = 0;
+	struct mmc_queue_req *mq_rq;
+	struct request_queue *q;
+
+	mq_rq = container_of(areq, struct mmc_queue_req, mmc_active);
+	q = mq_rq->req->q;
+	if (mq_rq->packed_cmd != MMC_PACKED_NONE) {
+		while (!list_empty(&mq_rq->packed_list)) {
+			/* return requests in reverse order */
+			prq = list_entry_rq(mq_rq->packed_list.prev);
+			list_del_init(&prq->queuelist);
+			ret = blk_reinsert_request(q, prq);
+			if (ret)
+				goto reinsert_error;
+		}
+	} else {
+		ret = blk_reinsert_request(q, mq_rq->req);
+		if (ret) {
+			pr_err("%s: blk_reinsert_request() fails (%d)",
+					__func__, ret);
+			blk_end_request(mq_rq->req, -EIO,
+					blk_rq_cur_bytes(mq_rq->req));
+		}
+	}
+	return;
+
+reinsert_error:
+	pr_err("%s: blk_reinsert_request() fails (%d)", __func__, ret);
+	while (!list_empty(&mq_rq->packed_list)) {
+		prq = list_entry_rq(mq_rq->packed_list.next);
+		list_del_init(&prq->queuelist);
+		blk_end_request(prq, -EIO, blk_rq_cur_bytes(prq));
+	}
+}
+
+/*
+ * mmc_update_interrupted_request() - update details of the interrupted request
+ * @card:	the MMC card associated with the request.
+ * @areq:	interrupted async request.
+ *
+ * Get stopped request state from card and updates successfully done part
+ * of the request by setting packed_fail_idx. For not packed request
+ * packed_fail_idx unchanged (-1).
+ *
+ * Returns: 0 for success, MMC_BLK_ABORT otherwise
+ */
+static int mmc_update_interrupted_request(struct mmc_card *card,
+					struct mmc_async_req *areq)
+{
+	int ret = MMC_BLK_SUCCESS;
+	u8 *ext_csd;
+	int correctly_done;
+	struct mmc_queue_req *mq_rq = container_of(areq, struct mmc_queue_req,
+			mmc_active);
+	struct request *prq;
+	u8 req_index = 0;
+
+	ext_csd = kmalloc(512, GFP_KERNEL);
+	if (!ext_csd) {
+		ret = MMC_BLK_ABORT;
+		goto exit;
+	}
+
+	mq_rq->packed_fail_idx = 0;
+
+	if (mq_rq->packed_cmd != MMC_PACKED_NONE) {
+		/* get correctly programmed sectors number from card */
+		ret = mmc_send_ext_csd(card, ext_csd);
+		if (ret) {
+			pr_err("%s: error %d sending ext_csd\n",
+					mq_rq->req->rq_disk->disk_name, ret);
+			ret = MMC_BLK_ABORT;
+			goto exit;
+		}
+		correctly_done = card->ext_csd.data_sector_size *
+			(ext_csd[EXT_CSD_CORRECTLY_PRG_SECTORS_NUM + 0] << 0 |
+			 ext_csd[EXT_CSD_CORRECTLY_PRG_SECTORS_NUM + 1] << 8 |
+			 ext_csd[EXT_CSD_CORRECTLY_PRG_SECTORS_NUM + 2] << 16 |
+			 ext_csd[EXT_CSD_CORRECTLY_PRG_SECTORS_NUM + 3] << 24);
+
+		list_for_each_entry(prq, &mq_rq->packed_list, queuelist) {
+			if (correctly_done < 0)
+				break;
+			if (correctly_done -  (int)blk_rq_bytes(prq) < 0) {
+				/* prq is not successfull */
+				mq_rq->packed_fail_idx = req_index;
+				break;
+			}
+			correctly_done -= blk_rq_bytes(prq);
+			req_index++;
+		}
+	}
+exit:
+	kfree(ext_csd);
+	return ret;
+}
+
 static int mmc_blk_packed_err_check(struct mmc_card *card,
 				    struct mmc_async_req *areq)
 {
@@ -1324,7 +1420,10 @@ static void mmc_blk_rw_rq_prep(struct mmc_queue_req *mqrq,
 	}
 
 	mqrq->mmc_active.mrq = &brq->mrq;
+	mqrq->mmc_active.mrq->sync_data = &mq->sync_data;
 	mqrq->mmc_active.err_check = mmc_blk_err_check;
+	mqrq->mmc_active.reinsert_request = mmc_blk_reinsert_request;
+	mqrq->mmc_active.update_interrupted = mmc_update_interrupted_request;
 
 	mmc_queue_bounce_pre(mqrq);
 }
@@ -1372,6 +1471,21 @@ static void mmc_blk_write_packing_control(struct mmc_queue *mq,
 
 }
 
+/**
+ * mmc_blk_disable_wr_packing() - disables packing mode
+ * @mq:	MMC queue.
+ *
+ * Note: this function may be called from 2 threads (mmc_queue_thread() and
+ * block layer context), in this case the code should be under lock to
+ * resolve race.
+ */
+void mmc_blk_disable_wr_packing(struct mmc_queue *mq)
+{
+	mq->wr_packing_enabled = false;
+	mq->num_of_potential_packed_wr_reqs = 0;
+}
+EXPORT_SYMBOL(mmc_blk_disable_wr_packing);
+
 static u8 mmc_blk_prep_packed_list(struct mmc_queue *mq, struct request *req)
 {
 	struct request_queue *q = mq->queue;
@@ -1566,6 +1680,9 @@ static void mmc_blk_packed_hdr_wrq_prep(struct mmc_queue_req *mqrq,
 
 	mqrq->mmc_active.mrq = &brq->mrq;
 	mqrq->mmc_active.err_check = mmc_blk_packed_err_check;
+	mqrq->mmc_active.mrq->sync_data = &mq->sync_data;
+	mqrq->mmc_active.reinsert_request = mmc_blk_reinsert_request;
+	mqrq->mmc_active.update_interrupted = mmc_update_interrupted_request;
 
 	mmc_queue_bounce_pre(mqrq);
 }
@@ -1702,7 +1819,7 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 			areq = &mq->mqrq_cur->mmc_active;
 		} else
 			areq = NULL;
-		areq = mmc_start_req(card->host, areq, (int *) &status);
+		areq = mmc_start_data_req(card->host, areq, (int *) &status);
 		if (!areq)
 			return 0;
 
@@ -1713,6 +1830,26 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 		mmc_queue_bounce_post(mq_rq);
 
 		switch (status) {
+		case MMC_BLK_URGENT:
+			if (mq_rq->packed_cmd != MMC_PACKED_NONE) {
+				/* complete successfully transmitted part */
+				ret = mmc_blk_end_packed_req(mq_rq);
+				if (ret)
+					/* process for not transmitted part */
+					mmc_blk_reinsert_request(areq);
+			} else { /* non packed request */
+				ret = blk_reinsert_request(mq->queue,
+						mq_rq->req);
+				if (ret)
+					blk_end_request(mq_rq->req, -EIO,
+						blk_rq_cur_bytes(mq_rq->req));
+			}
+			mq->mqrq_prev->brq.mrq.data = NULL;
+			mq->mqrq_prev->req = NULL;
+			mq->mqrq_cur->brq.mrq.data = NULL;
+			mq->mqrq_cur->req = NULL;
+			ret = 0;
+			break;
 		case MMC_BLK_SUCCESS:
 		case MMC_BLK_PARTIAL:
 			/*
@@ -1795,14 +1932,14 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 				 */
 				mmc_blk_rw_rq_prep(mq_rq, card,
 						disable_multi, mq);
-				mmc_start_req(card->host,
-						&mq_rq->mmc_active, NULL);
+				mmc_start_data_req(card->host,
+					&mq_rq->mmc_active, (int *) &status);
 			} else {
 				if (!mq_rq->packed_retries)
 					goto cmd_abort;
 				mmc_blk_packed_hdr_wrq_prep(mq_rq, card, mq);
-				mmc_start_req(card->host,
-						&mq_rq->mmc_active, NULL);
+				mmc_start_data_req(card->host,
+					&mq_rq->mmc_active, (int *) &status);
 			}
 		}
 	} while (ret);
@@ -1829,7 +1966,7 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 			mmc_blk_revert_packed_req(mq, mq->mqrq_cur);
 
 		mmc_blk_rw_rq_prep(mq->mqrq_cur, card, 0, mq);
-		mmc_start_req(card->host, &mq->mqrq_cur->mmc_active, NULL);
+		mmc_start_data_req(card->host, &mq->mqrq_cur->mmc_active, NULL);
 	}
 
 	return 0;
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 79ef91b..b56ff33 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -120,6 +120,38 @@ static void mmc_request_fn(struct request_queue *q)
 		wake_up_process(mq->thread);
 }
 
+/*
+ * mmc_urgent_request() - Urgent MMC request handler.
+ * @q: request queue.
+ *
+ * This is called when block layer has urgent request for delivery.
+ * When mmc context is waiting for current request, it will be awaken,
+ * current request interrupted and re-inserted back into block layer.
+ * The next fetched request should be urgent request.
+ */
+static void mmc_urgent_request(struct request_queue *q)
+{
+	unsigned long flags;
+	struct mmc_queue *mq = q->queuedata;
+
+	mq->sync_data.skip_urgent_flag = false;
+	/* critical section with mmc_wait_data_done() */
+	spin_lock_irqsave(&mq->sync_data.lock, flags);
+
+	/* do stop flow only when mmc thread is waiting for done */
+	if (mq->sync_data.waiting_flag &&
+		!mq->sync_data.skip_urgent_flag) {
+
+		mmc_blk_disable_wr_packing(mq);
+		mq->sync_data.urgent_flag = true;
+		wake_up_interruptible(&mq->sync_data.wait);
+		spin_unlock_irqrestore(&mq->sync_data.lock, flags);
+	} else {
+		spin_unlock_irqrestore(&mq->sync_data.lock, flags);
+		mmc_request_fn(q);
+	}
+}
+
 static struct scatterlist *mmc_alloc_sg(int sg_len, int *err)
 {
 	struct scatterlist *sg;
@@ -182,6 +214,8 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
 	if (!mq->queue)
 		return -ENOMEM;
 
+	blk_urgent_request(mq->queue, mmc_urgent_request);
+
 	INIT_LIST_HEAD(&mqrq_cur->packed_list);
 	INIT_LIST_HEAD(&mqrq_prev->packed_list);
 
@@ -270,6 +304,12 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
 	}
 
 	sema_init(&mq->thread_sem, 1);
+	spin_lock_init(&mq->sync_data.lock);
+	mq->sync_data.skip_urgent_flag = false;
+	mq->sync_data.urgent_flag = false;
+	mq->sync_data.done_flag = false;
+	mq->sync_data.waiting_flag = false;
+	init_waitqueue_head(&mq->sync_data.wait);
 
 	mq->thread = kthread_run(mmc_queue_thread, mq, "mmcqd/%d%s",
 		host->index, subname ? subname : "");
diff --git a/drivers/mmc/card/queue.h b/drivers/mmc/card/queue.h
index 93e4b59..73a8ee2 100644
--- a/drivers/mmc/card/queue.h
+++ b/drivers/mmc/card/queue.h
@@ -48,6 +48,7 @@ struct mmc_queue {
 	bool			wr_packing_enabled;
 	int			num_of_potential_packed_wr_reqs;
 	int			num_wr_reqs_to_start_packing;
+	struct mmc_sync_data	sync_data;
 };
 
 extern int mmc_init_queue(struct mmc_queue *, struct mmc_card *, spinlock_t *,
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index af2c4d2..623f60b 100644
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
+	/* critical section with mmc_urgent_request() */
+	spin_lock_irqsave(&mrq->sync_data->lock, flags);
+	mrq->sync_data->skip_urgent_flag = true;
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
@@ -263,6 +304,201 @@ static int __mmc_start_req(struct mmc_host *host, struct mmc_request *mrq)
 	return 0;
 }
 
+/*
+ * mmc_need_to_stop() - check for stop flow rationality
+ * @host->areq - current running request.
+ *
+ * Check possibility to interrupt current running request
+ * Returns  true when not all request trasferred to the card
+ *          false otherwise
+ */
+static bool mmc_need_to_stop(struct mmc_host *host)
+{
+	int remainder;
+
+	remainder = host->ops->get_xfer_remain(host);
+	return (remainder > 0);
+}
+
+/*
+ * mmc_stop_request() - Stops current running request
+ * @host: MMC host to prepare the command.
+ *
+ * Triggers stop flow in the host driver and sends CMD12 (stop command) to the
+ * card.
+ *
+ * Returns any error that occurred while stop command was executing,
+ * 0 otherwise.
+ */
+static int mmc_stop_request(struct mmc_host *host)
+{
+	struct mmc_command cmd = {0};
+	struct mmc_card *card = host->card;
+	int err = 0;
+	u32 status;
+
+	if (host->ops->stop_request) {
+		err = host->ops->stop_request(host);
+		if (err) {
+			pr_err("%s: Got error %d from host->ops->stop_request(host)\n",
+					__func__, err);
+			goto out;
+		}
+		err = mmc_send_status(card, &status);
+		if (err) {
+			pr_err("%s: Get card status fail\n", __func__);
+			goto out;
+		}
+		if (R1_CURRENT_STATE(status) == R1_STATE_RCV) {
+			cmd.opcode = MMC_STOP_TRANSMISSION;
+			cmd.flags = MMC_RSP_SPI_R1 | MMC_RSP_R1 | MMC_CMD_AC;
+			err = mmc_wait_for_cmd(host, &cmd, 0);
+			if (err)
+				pr_err("%s: cmd12 cmd fails (%d)\n",
+						__func__, err);
+		}
+		if (card->ext_csd.hpi) { /* hpi supported */
+			cmd.flags = MMC_RSP_R1 | MMC_CMD_AC;
+			cmd.arg = card->rca << 16 | 1;
+			cmd.cmd_timeout_ms = card->ext_csd.out_of_int_time;
+			if (card->ext_csd.hpi_cmd == MMC_SEND_STATUS) {
+				cmd.opcode = MMC_SEND_STATUS;
+				err = mmc_wait_for_cmd(card->host, &cmd, 0);
+				if (err)
+					pr_warn("%s:HPI cmd (cmd13) fails (%d)",
+						__func__, err);
+			} else { /* HPI supported via MMC_STOP_TRANSMISSION */
+				err = mmc_send_status(card, &status);
+				if (err) {
+					pr_err("%s: Get card status fail\n",
+							__func__);
+					goto out;
+				}
+				if (R1_CURRENT_STATE(status) == R1_STATE_PRG) {
+					cmd.opcode = MMC_STOP_TRANSMISSION;
+					err = mmc_wait_for_cmd(card->host,
+							&cmd, 0);
+					if (err)
+						pr_warn("%s:HPI cmd (cmd12) fails (%d)",
+							__func__, err);
+				}
+			}
+		} else {
+			pr_warn("%s: HPI does not supported", __func__);
+		}
+	} else {
+		pr_warn("%s: host ops stop_request() not supported", __func__);
+	}
+out:
+	return 0;
+}
+
+/*
+ * mmc_wait_for_data_req_done() - wait for request completed or urgent
+ *				  request notification arrives
+ * @host: MMC host to prepare the command.
+ * @mrq: MMC request to wait for
+ *
+ * Blocks MMC context till host controller will ack end of data request
+ * execution or urgent request arrives from block layer. Handles
+ * command retries.
+ *
+ * Returns enum mmc_blk_status after checking errors.
+ */
+static int mmc_wait_for_data_req_done(struct mmc_host *host,
+				      struct mmc_request *mrq)
+{
+	struct mmc_command *cmd;
+	struct mmc_sync_data *sync_data = mrq->sync_data;
+	bool pending_urgent_flag = false;
+	int ret = 0;
+	bool done_flag = false;
+	bool urgent_flag = false;
+	int err;
+
+	while (1) {
+		sync_data->waiting_flag = true;
+		wait_event_interruptible(sync_data->wait,
+				(sync_data->done_flag ||
+				 sync_data->urgent_flag));
+		sync_data->waiting_flag = false;
+		done_flag = sync_data->done_flag;
+		urgent_flag = sync_data->urgent_flag;
+		if (done_flag) {
+			sync_data->done_flag = false;
+			cmd = mrq->cmd;
+			if (!cmd->error || !cmd->retries ||
+					mmc_card_removed(host->card)) {
+				err = host->areq->err_check(host->card,
+						host->areq);
+				if (pending_urgent_flag || urgent_flag) {
+					/*
+					 * all the success/partial operations
+					 * are done in an addition to handling
+					 * the urgent request
+					 */
+					if ((err == MMC_BLK_PARTIAL) ||
+						(err == MMC_BLK_SUCCESS))
+						err = MMC_BLK_URGENT;
+
+					if (urgent_flag)
+						sync_data->urgent_flag = false;
+				}
+				break; /* return err */
+			} else {
+				pr_info("%s: req failed (CMD%u): %d, retrying...\n",
+						mmc_hostname(host),
+						cmd->opcode, cmd->error);
+				cmd->retries--;
+				cmd->error = 0;
+				host->ops->request(host, mrq);
+				/*
+				 * ignore urgent flow, request retry has greater
+				 * priority than urgent flow
+				 */
+				sync_data->urgent_flag = false;
+				sync_data->done_flag = false;
+				continue; /* wait for done/urgent event again */
+			}
+		}
+		if (urgent_flag) {
+			/*
+			 * The case when block layer sent next urgent
+			 * notification before it receives end_io on
+			 * the current
+			 */
+			BUG_ON(pending_urgent_flag == true);
+
+			if (mmc_need_to_stop(host)) {
+				sync_data->urgent_flag = false;
+				ret = mmc_stop_request(host);
+				if (ret) {
+					err = MMC_BLK_ABORT;
+					break;
+				}
+				/* running request has finished at this point */
+				if (sync_data->done_flag) {
+					err = host->areq->err_check(host->card,
+							host->areq);
+					sync_data->done_flag = false;
+					sync_data->urgent_flag = false;
+					break; /* return err */
+				}
+				err = host->areq->update_interrupted(
+						host->card, host->areq);
+				if (!err)
+					err = MMC_BLK_URGENT;
+				break; /* return err */
+			} else {
+				sync_data->urgent_flag = false;
+				pending_urgent_flag = true;
+				continue; /* wait for done event */
+			}
+		}
+	} /* while */
+	return err;
+}
+
 static void mmc_wait_for_req_done(struct mmc_host *host,
 				  struct mmc_request *mrq)
 {
@@ -285,15 +521,15 @@ static void mmc_wait_for_req_done(struct mmc_host *host,
 }
 
 /**
- *	mmc_pre_req - Prepare for a new request
- *	@host: MMC host to prepare command
- *	@mrq: MMC request to prepare for
- *	@is_first_req: true if there is no previous started request
+ * mmc_pre_req - Prepare for a new request
+ * @host: MMC host to prepare command
+ * @mrq: MMC request to prepare for
+ * @is_first_req: true if there is no previous started request
  *                     that may run in parellel to this call, otherwise false
  *
- *	mmc_pre_req() is called in prior to mmc_start_req() to let
- *	host prepare for the new request. Preparation of a request may be
- *	performed while another request is running on the host.
+ * mmc_pre_req() is called in prior to mmc_start_req() to let
+ * host prepare for the new request. Preparation of a request may be
+ * performed while another request is running on the host.
  */
 static void mmc_pre_req(struct mmc_host *host, struct mmc_request *mrq,
 		 bool is_first_req)
@@ -325,6 +561,62 @@ static void mmc_post_req(struct mmc_host *host, struct mmc_request *mrq,
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
+		areq->mrq->sync_data->waiting_flag = true;
+		mmc_pre_req(host, areq->mrq, !host->areq);
+	}
+
+	if (host->areq) {
+		err = mmc_wait_for_data_req_done(host, host->areq->mrq);
+		if (err == MMC_BLK_URGENT) {
+			if (areq) /* reinsert ready request */
+				host->areq->reinsert_request(areq);
+			host->areq = NULL;
+			goto exit;
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
+exit:
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
index a585f63..50eb211 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -181,6 +181,7 @@ struct sdio_cis {
 struct mmc_host;
 struct sdio_func;
 struct sdio_func_tuple;
+struct mmc_queue;
 
 #define SDIO_MAX_FUNCS		7
 
@@ -206,6 +207,18 @@ struct mmc_part {
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
+	MMC_BLK_URGENT,
+};
+
 /*
  * MMC device
  */
@@ -505,4 +518,5 @@ extern void mmc_unregister_driver(struct mmc_driver *);
 extern void mmc_fixup_device(struct mmc_card *card,
 			     const struct mmc_fixup *table);
 
+extern void mmc_blk_disable_wr_packing(struct mmc_queue *mq);
 #endif /* LINUX_MMC_CARD_H */
diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
index d787037..c02d753 100644
--- a/include/linux/mmc/core.h
+++ b/include/linux/mmc/core.h
@@ -10,6 +10,7 @@
 
 #include <linux/interrupt.h>
 #include <linux/completion.h>
+#include <linux/semaphore.h>
 
 struct request;
 struct mmc_data;
@@ -123,6 +124,23 @@ struct mmc_data {
 	s32			host_cookie;	/* host private data */
 };
 
+/**
+ * mmc_sync_data - synchronization details for mmc context
+ * @done_flag		wake up reason was done request
+ * @urgent_flag		wake up reason was urgent block request
+ * @skip_urgent_flag	done arrived before urgent
+ * @wait		wait queue
+ * @mmc_sem		semaphore to serialize wake up code
+ */
+struct mmc_sync_data {
+	bool			done_flag;
+	bool			urgent_flag;
+	bool			skip_urgent_flag;
+	bool			waiting_flag;
+	wait_queue_head_t	wait;
+	spinlock_t		lock;
+};
+
 struct mmc_request {
 	struct mmc_command	*sbc;		/* SET_BLOCK_COUNT for multiblock */
 	struct mmc_command	*cmd;
@@ -131,6 +149,7 @@ struct mmc_request {
 
 	struct completion	completion;
 	void			(*done)(struct mmc_request *);/* completion function */
+	struct mmc_sync_data    *sync_data;
 };
 
 struct mmc_host;
@@ -139,6 +158,8 @@ struct mmc_async_req;
 
 extern struct mmc_async_req *mmc_start_req(struct mmc_host *,
 					   struct mmc_async_req *, int *);
+extern struct mmc_async_req *mmc_start_data_req(struct mmc_host *,
+					   struct mmc_async_req *, int *);
 extern int mmc_interrupt_hpi(struct mmc_card *);
 extern void mmc_wait_for_req(struct mmc_host *, struct mmc_request *);
 extern int mmc_wait_for_cmd(struct mmc_host *, struct mmc_command *, int);
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 263452f..4dcdc29 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -151,6 +151,10 @@ struct mmc_async_req {
 	 * Returns 0 if success otherwise non zero.
 	 */
 	int (*err_check) (struct mmc_card *, struct mmc_async_req *);
+	/* Reinserts request back to the block layer */
+	void (*reinsert_request) (struct mmc_async_req *);
+	/* update what part of request is not done (packed_fail_idx) */
+	int (*update_interrupted) (struct mmc_card *, struct mmc_async_req *);
 };
 
 /**
diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
index 254901a..20f67be 100644
--- a/include/linux/mmc/mmc.h
+++ b/include/linux/mmc/mmc.h
@@ -318,6 +318,7 @@ struct _mmc_csd {
 #define EXT_CSD_PWR_CL_200_360		237	/* RO */
 #define EXT_CSD_PWR_CL_DDR_52_195	238	/* RO */
 #define EXT_CSD_PWR_CL_DDR_52_360	239	/* RO */
+#define EXT_CSD_CORRECTLY_PRG_SECTORS_NUM 242	/* RO, 4 bytes */
 #define EXT_CSD_POWER_OFF_LONG_TIME	247	/* RO */
 #define EXT_CSD_GENERIC_CMD6_TIME	248	/* RO */
 #define EXT_CSD_CACHE_SIZE		249	/* RO, 4 bytes */
-- 
1.7.6
-- 
QUALCOMM ISRAEL,
on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
