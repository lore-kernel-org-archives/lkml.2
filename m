Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087Ab2ITGDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 02:03:21 -0400
Received: from 212.199.104.198.static.012.net.il ([212.199.104.198]:33049 "EHLO
	lx-merez.qi.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751651Ab2ITGDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 02:03:19 -0400
From: Maya Erez <merez@codeaurora.org>
To: linux-mmc@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org,
        Konstantin Dorfman <kdorfman@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC/PATCH 2/2] mmc: new packet notification
Date: Thu, 20 Sep 2012 09:02:32 +0300
Message-Id: <1348120954-6937-3-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konstantin Dorfman <kdorfman@codeaurora.org>

Unblock waiting for current request running on the bus,
when new packet supplied by block layer. This improves async request
mechanism.
In most cases new request is inserted after mmc layer fetched NULL
and was blocked on waiting for the previous request completion.
The new event new_packet_flag wakes mmc layer and allow it to
immediately fetch the new inserted request.

Signed-off-by: Konstantin Dorfman <kdorfman@codeaurora.org>
---
 drivers/mmc/card/block.c |   11 +++++++++--
 drivers/mmc/card/queue.c |   29 +++++++++++++++++++++++++----
 drivers/mmc/core/core.c  |   21 +++++++++++++++++++++
 include/linux/mmc/card.h |    1 +
 include/linux/mmc/core.h |    1 +
 5 files changed, 57 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index e739c2f..8b996c3 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -1820,8 +1820,11 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 		} else
 			areq = NULL;
 		areq = mmc_start_data_req(card->host, areq, (int *) &status);
-		if (!areq)
+		if (!areq) {
+			if (status == MMC_BLK_NEW_PACKET)
+				return status;
 			return 0;
+		}
 
 		mq_rq = container_of(areq, struct mmc_queue_req, mmc_active);
 		brq = &mq_rq->brq;
@@ -1830,6 +1833,9 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 		mmc_queue_bounce_post(mq_rq);
 
 		switch (status) {
+		case MMC_BLK_NEW_PACKET:
+			BUG_ON(1); /* should never get here */
+			return MMC_BLK_NEW_PACKET;
 		case MMC_BLK_URGENT:
 			if (mq_rq->packed_cmd != MMC_PACKED_NONE) {
 				/* complete successfully transmitted part */
@@ -2012,9 +2018,10 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
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
index b56ff33..0b9bac3 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -74,7 +74,9 @@ static int mmc_queue_thread(void *d)
 
 		if (req || mq->mqrq_prev->req) {
 			set_current_state(TASK_RUNNING);
-			mq->issue_fn(mq, req);
+			if (mq->issue_fn(mq, req) == MMC_BLK_NEW_PACKET) {
+				continue; /* fetch again */
+			}
 		} else {
 			if (kthread_should_stop()) {
 				set_current_state(TASK_RUNNING);
@@ -105,6 +107,7 @@ static int mmc_queue_thread(void *d)
  */
 static void mmc_request_fn(struct request_queue *q)
 {
+	unsigned long flags;
 	struct mmc_queue *mq = q->queuedata;
 	struct request *req;
 
@@ -115,9 +118,26 @@ static void mmc_request_fn(struct request_queue *q)
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
+		mq->sync_data.skip_urgent_flag = false;
+		/* critical section with mmc_wait_data_req_done() */
+		spin_lock_irqsave(&mq->sync_data.lock, flags);
+		/* do stop flow only when mmc thread is waiting for done */
+		if (mq->sync_data.waiting_flag &&
+				!mq->sync_data.new_packet_flag &&
+				!mq->sync_data.skip_urgent_flag) {
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
 
 /*
@@ -307,6 +327,7 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
 	spin_lock_init(&mq->sync_data.lock);
 	mq->sync_data.skip_urgent_flag = false;
 	mq->sync_data.urgent_flag = false;
+	mq->sync_data.new_packet_flag = false;
 	mq->sync_data.done_flag = false;
 	mq->sync_data.waiting_flag = false;
 	init_waitqueue_head(&mq->sync_data.wait);
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 623f60b..5309990 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -414,18 +414,23 @@ static int mmc_wait_for_data_req_done(struct mmc_host *host,
 	int ret = 0;
 	bool done_flag = false;
 	bool urgent_flag = false;
+	bool new_packet_flag = false;
 	int err;
 
 	while (1) {
 		sync_data->waiting_flag = true;
+		sync_data->new_packet_flag = false;
 		wait_event_interruptible(sync_data->wait,
 				(sync_data->done_flag ||
+				 sync_data->new_packet_flag ||
 				 sync_data->urgent_flag));
 		sync_data->waiting_flag = false;
 		done_flag = sync_data->done_flag;
 		urgent_flag = sync_data->urgent_flag;
+		new_packet_flag = sync_data->new_packet_flag;
 		if (done_flag) {
 			sync_data->done_flag = false;
+			sync_data->new_packet_flag = false;
 			cmd = mrq->cmd;
 			if (!cmd->error || !cmd->retries ||
 					mmc_card_removed(host->card)) {
@@ -460,6 +465,10 @@ static int mmc_wait_for_data_req_done(struct mmc_host *host,
 				sync_data->done_flag = false;
 				continue; /* wait for done/urgent event again */
 			}
+		} else if (new_packet_flag) {
+			sync_data->new_packet_flag = false;
+			err = MMC_BLK_NEW_PACKET;
+			break; /* return err */
 		}
 		if (urgent_flag) {
 			/*
@@ -590,6 +599,18 @@ struct mmc_async_req *mmc_start_data_req(struct mmc_host *host,
 				host->areq->reinsert_request(areq);
 			host->areq = NULL;
 			goto exit;
+		} else if (err == MMC_BLK_NEW_PACKET) {
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
 		}
 	}
 
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 50eb211..a39c3ac 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -217,6 +217,7 @@ enum mmc_blk_status {
 	MMC_BLK_ECC_ERR,
 	MMC_BLK_NOMEDIUM,
 	MMC_BLK_URGENT,
+	MMC_BLK_NEW_PACKET,
 };
 
 /*
diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
index c02d753..fb6bcfd 100644
--- a/include/linux/mmc/core.h
+++ b/include/linux/mmc/core.h
@@ -135,6 +135,7 @@ struct mmc_data {
 struct mmc_sync_data {
 	bool			done_flag;
 	bool			urgent_flag;
+	bool			new_packet_flag;
 	bool			skip_urgent_flag;
 	bool			waiting_flag;
 	wait_queue_head_t	wait;
-- 
1.7.6
-- 
QUALCOMM ISRAEL,
on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
