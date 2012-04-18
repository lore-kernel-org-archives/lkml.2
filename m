Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab2DRG06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 02:26:58 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56887 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483Ab2DRG03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 02:26:29 -0400
From: Venkatraman S <svenkatr@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>
CC: <arnd.bergmann@linaro.org>, <cjb@laptop.org>, <alex.limberg@sandisk.com>,
        <ilan.smith@sandisk.com>, <lporzio@micron.com>,
        Venkatraman S <svenkatr@ti.com>
Subject: [RFC PATCH 11/11] mmc: block: Implement HPI invocation and handling for foreground requests
Date: Wed, 18 Apr 2012 11:55:32 +0530
Message-ID: <1334730332-22244-12-git-send-email-svenkatr@ti.com>
X-Mailer: git-send-email 1.7.10.rc2
In-Reply-To: <1334730332-22244-1-git-send-email-svenkatr@ti.com>
References: <1334730332-22244-1-git-send-email-svenkatr@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intercept requests which require high priority treatment.
An ongoing command can be preempted if
a) it is one of CMD 24, 25, 38 or CMD6(with BKOPS START)
b) a significant amount of time isn't elapsed since the
   start of the command that it is worthwhile to abort it
c) the next request is a DMPG or SWAPIN request

For practical reasons, HPI would be invoked for host controllers
 which support the abort_req interface. Technically, the
host controller driver can implement it as a no op. But the
abort would usually be required to clean up the context
variables and bypass the statemachine which requires it to
wait till the card is back to transfer state after completing
the write.

Signed-off-by: Venkatraman S <svenkatr@ti.com>
---
 drivers/mmc/card/block.c |  126 ++++++++++++++++++++++++++++++++++++++++++----
 drivers/mmc/card/queue.h |    1 +
 2 files changed, 117 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 11833e4..de0634f 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -57,6 +57,9 @@ MODULE_ALIAS("mmc:block");
 #define INAND_CMD38_ARG_SECERASE 0x80
 #define INAND_CMD38_ARG_SECTRIM1 0x81
 #define INAND_CMD38_ARG_SECTRIM2 0x88
+/* TODO: Convert the below macro to sysfs to tune this dynamically */
+#define MMC_HPI_PREEMPT_TIME_THRESHOLD 10 /* in msec */
+
 
 static DEFINE_MUTEX(block_mutex);
 
@@ -1276,7 +1279,7 @@ static int mmc_blk_cmd_err(struct mmc_blk_data *md, struct mmc_card *card,
 	return ret;
 }
 
-static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
+static int mmc_blk_execute_rw_rq(struct mmc_queue *mq, struct request *rqc)
 {
 	struct mmc_blk_data *md = mq->data;
 	struct mmc_card *card = md->queue.card;
@@ -1285,22 +1288,31 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 	enum mmc_blk_status status;
 	struct mmc_queue_req *mq_rq;
 	struct request *req;
-	struct mmc_async_req *areq;
+	struct mmc_async_req *prev_req, *cur_req;
 
 	if (!rqc && !mq->mqrq_prev->req)
 		return 0;
 
+	mq->mqrq_interrupted = NULL;
 	do {
 		if (rqc) {
 			mmc_blk_rw_rq_prep(mq->mqrq_cur, card, 0, mq);
-			areq = &mq->mqrq_cur->mmc_active;
-		} else
-			areq = NULL;
-		areq = mmc_start_req(card->host, areq, (int *) &status);
-		if (!areq)
+			cur_req = &mq->mqrq_cur->mmc_active;
+		} else {
+			cur_req = NULL;
+		}
+		prev_req = mmc_start_req(card->host, cur_req, (int *) &status);
+		if (!prev_req)
 			return 0;
 
-		mq_rq = container_of(areq, struct mmc_queue_req, mmc_active);
+		if (cur_req &&
+			cur_req->mrq->cmd->cmd_attr & MMC_CMD_PREEMPTIBLE) {
+			mq->mqrq_interrupted = mq->mqrq_cur;
+			pr_info("%x can be preempted\n", mq->mqrq_interrupted);
+		}
+
+		mq_rq = container_of(prev_req,
+			struct mmc_queue_req, mmc_active);
 		brq = &mq_rq->brq;
 		req = mq_rq->req;
 		type = rq_data_dir(req) == READ ? MMC_BLK_READ : MMC_BLK_WRITE;
@@ -1406,6 +1418,100 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 	return 0;
 }
 
+#define HPI_CHECK  (REQ_RW_SWAPIN | REQ_RW_DMPG)
+
+static bool mmc_can_do_foreground_hpi(struct mmc_queue *mq,
+					struct request *req)
+{
+
+	/* If some time has elapsed since the issuing of previous write
+	command, or if the size of the request was too small, there's
+	no point in preempting it. Check if it's worthwhile to preempt */
+	int time_elapsed = jiffies_to_msecs(jiffies -
+			mq->mqrq_cur->mmc_active.mrq->cmd->started_time);
+
+	if ((time_elapsed < MMC_HPI_PREEMPT_TIME_THRESHOLD))
+			return true;
+
+	return false;
+}
+
+/*  When a HPI command had been given for a foreground
+ *  request, the host controller will finish the request,
+ *  the completion request has to be handled differently
+ */
+
+static struct mmc_async_req *mmc_handle_aborted_request(struct mmc_queue *mq,
+	int hpi_err)
+{
+	struct mmc_async_req *areq;
+	struct mmc_request *mrq;
+	struct mmc_queue_req *mq_rq;
+	struct mmc_blk_data *md = mq->data;
+	struct request *req;
+
+	BUG_ON(!mq->mqrq_interrupted);
+
+	areq = &mq->mqrq_interrupted->mmc_active;
+	mrq = areq->mrq;
+	wait_for_completion(&mrq->completion);
+	/* Error checking is TBD
+	err = areq->err_check(card, areq);  */
+	mq_rq = container_of(areq, struct mmc_queue_req, mmc_active);
+	req = mq_rq->req;
+	mmc_queue_bounce_post(mq_rq);
+
+	spin_lock_irq(&md->lock);
+	/* TODO. Collect the correctly_programmed_sectors_num from card
+	and then pass it as parameter for __blk_end_request */
+	__blk_end_request(req, -EIO, 0);
+	spin_unlock_irq(&md->lock);
+	return areq;
+}
+
+static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
+{
+	int ret;
+	struct mmc_blk_data *md = mq->data;
+	struct mmc_card *card = md->queue.card;
+	struct mmc_async_req *areq;
+
+	if (req && md->flags & MMC_HPI_SUPPORT) {
+		if (!((req->cmd_flags & HPI_CHECK) && mq->mqrq_interrupted))
+			goto no_preempt;
+		if (!mmc_can_do_foreground_hpi(mq, req))
+			goto no_preempt;
+
+		ret = mmc_preempt_foreground_request(card,
+			 mq->mqrq_interrupted->mmc_active.mrq);
+		if (ret)
+			/* Couldn't execute HPI, or the request could
+			 * have been completed already. Go through
+			 * the normal route */
+			goto no_preempt;
+
+		areq = mmc_handle_aborted_request(mq, ret);
+		/* Remove the request from the host controller's
+		 * request queue. This prevents normal error handling
+		 * and retry procedures from executing (we know the
+		 * request has been aborted anyway). This also helps to start
+		 * the urgent requests without doing the post processing
+		 * of the aborted request
+		 */
+		 card->host->areq = NULL;
+
+		/* Now the decks are clear to send the most urgent command.
+		As we've preempted the ongoing one already, the urgent
+		one can go through the normal queue and it won't face much
+		resistance - hence the intentional fall through */
+		BUG_ON(areq != &mq->mqrq_interrupted->mmc_active);
+	}
+
+no_preempt:
+	ret = mmc_blk_execute_rw_rq(mq, req);
+	return ret;
+}
+
 static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 {
 	int ret;
@@ -1430,7 +1536,7 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 	if (req && req->cmd_flags & REQ_DISCARD) {
 		/* complete ongoing async transfer before issuing discard */
 		if (card->host->areq)
-			mmc_blk_issue_rw_rq(mq, NULL);
+			mmc_blk_execute_rw_rq(mq, NULL);
 		if (req->cmd_flags & REQ_SECURE)
 			ret = mmc_blk_issue_secdiscard_rq(mq, req);
 		else
@@ -1438,7 +1544,7 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 	} else if (req && req->cmd_flags & REQ_FLUSH) {
 		/* complete ongoing async transfer before issuing flush */
 		if (card->host->areq)
-			mmc_blk_issue_rw_rq(mq, NULL);
+			mmc_blk_execute_rw_rq(mq, NULL);
 		ret = mmc_blk_issue_flush(mq, req);
 	} else {
 		ret = mmc_blk_issue_rw_rq(mq, req);
diff --git a/drivers/mmc/card/queue.h b/drivers/mmc/card/queue.h
index d2a1eb4..7bd599e 100644
--- a/drivers/mmc/card/queue.h
+++ b/drivers/mmc/card/queue.h
@@ -33,6 +33,7 @@ struct mmc_queue {
 	struct mmc_queue_req	mqrq[2];
 	struct mmc_queue_req	*mqrq_cur;
 	struct mmc_queue_req	*mqrq_prev;
+	struct mmc_queue_req	*mqrq_interrupted;
 };
 
 extern int mmc_init_queue(struct mmc_queue *, struct mmc_card *, spinlock_t *,
-- 
1.7.10.rc2

