Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417Ab1ALSP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 13:15:28 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:44785 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932353Ab1ALSPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 13:15:25 -0500
From: Per Forlin <per.forlin@linaro.org>
To: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@lists.linaro.org
Cc: Chris Ball <cjb@laptop.org>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH 4/5] mmc: Store the mmc block request struct in mmc queue
Date: Wed, 12 Jan 2011 19:14:02 +0100
Message-Id: <1294856043-13447-5-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1294856043-13447-1-git-send-email-per.forlin@linaro.org>
References: <1294856043-13447-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the mmc block request to the mmc queue struct in
order to make way for processing two brqs simultanously.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 drivers/mmc/card/block.c |   68 +++++++++++++++++++++-------------------------
 drivers/mmc/card/queue.h |    9 +++++-
 2 files changed, 39 insertions(+), 38 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 3f98b15..028b2b8 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -165,13 +165,6 @@ static const struct block_device_operations mmc_bdops = {
 	.owner			= THIS_MODULE,
 };
 
-struct mmc_blk_request {
-	struct mmc_request	mrq;
-	struct mmc_command	cmd;
-	struct mmc_command	stop;
-	struct mmc_data		data;
-};
-
 static u32 mmc_sd_num_wr_blocks(struct mmc_card *card)
 {
 	int err;
@@ -422,11 +415,11 @@ static void mmc_blk_issue_rw_rq_prep(struct mmc_blk_request *brq,
 	mmc_queue_bounce_pre(mqrq);
 }
 
-static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
+static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 {
 	struct mmc_blk_data *md = mq->data;
 	struct mmc_card *card = md->queue.card;
-	struct mmc_blk_request brq;
+	struct mmc_blk_request *brqc = &mq->mqrq_cur->brq;
 	int ret = 1, disable_multi = 0;
 
 	mmc_claim_host(card->host);
@@ -435,9 +428,9 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 		struct mmc_command cmd;
 		u32 status = 0;
 
-		mmc_blk_issue_rw_rq_prep(&brq, mq->mqrq_cur, req, card,
+		mmc_blk_issue_rw_rq_prep(brqc, mq->mqrq_cur, rqc, card,
 					 disable_multi, mq);
-		mmc_wait_for_req(card->host, &brq.mrq);
+		mmc_wait_for_req(card->host, &brqc->mrq);
 
 		mmc_queue_bounce_post(mq->mqrq_cur);
 
@@ -446,43 +439,43 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 		 * until later as we need to wait for the card to leave
 		 * programming mode even when things go wrong.
 		 */
-		if (brq.cmd.error || brq.data.error || brq.stop.error) {
-			if (brq.data.blocks > 1 && rq_data_dir(req) == READ) {
+		if (brqc->cmd.error || brqc->data.error || brqc->stop.error) {
+			if (brqc->data.blocks > 1 && rq_data_dir(rqc) == READ) {
 				/* Redo read one sector at a time */
 				printk(KERN_WARNING "%s: retrying using single "
-				       "block read\n", req->rq_disk->disk_name);
+				       "block read\n", rqc->rq_disk->disk_name);
 				disable_multi = 1;
 				continue;
 			}
-			status = get_card_status(card, req);
+			status = get_card_status(card, rqc);
 		}
 
-		if (brq.cmd.error) {
+		if (brqc->cmd.error) {
 			printk(KERN_ERR "%s: error %d sending read/write "
 			       "command, response %#x, card status %#x\n",
-			       req->rq_disk->disk_name, brq.cmd.error,
-			       brq.cmd.resp[0], status);
+			       rqc->rq_disk->disk_name, brqc->cmd.error,
+			       brqc->cmd.resp[0], status);
 		}
 
-		if (brq.data.error) {
-			if (brq.data.error == -ETIMEDOUT && brq.mrq.stop)
+		if (brqc->data.error) {
+			if (brqc->data.error == -ETIMEDOUT && brqc->mrq.stop)
 				/* 'Stop' response contains card status */
-				status = brq.mrq.stop->resp[0];
+				status = brqc->mrq.stop->resp[0];
 			printk(KERN_ERR "%s: error %d transferring data,"
 			       " sector %u, nr %u, card status %#x\n",
-			       req->rq_disk->disk_name, brq.data.error,
-			       (unsigned)blk_rq_pos(req),
-			       (unsigned)blk_rq_sectors(req), status);
+			       rqc->rq_disk->disk_name, brqc->data.error,
+			       (unsigned)blk_rq_pos(rqc),
+			       (unsigned)blk_rq_sectors(rqc), status);
 		}
 
-		if (brq.stop.error) {
+		if (brqc->stop.error) {
 			printk(KERN_ERR "%s: error %d sending stop command, "
 			       "response %#x, card status %#x\n",
-			       req->rq_disk->disk_name, brq.stop.error,
-			       brq.stop.resp[0], status);
+			       rqc->rq_disk->disk_name, brqc->stop.error,
+			       brqc->stop.resp[0], status);
 		}
 
-		if (!mmc_host_is_spi(card->host) && rq_data_dir(req) != READ) {
+		if (!mmc_host_is_spi(card->host) && rq_data_dir(rqc) != READ) {
 			do {
 				int err;
 
@@ -492,7 +485,7 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 				err = mmc_wait_for_cmd(card->host, &cmd, 5);
 				if (err) {
 					printk(KERN_ERR "%s: error %d requesting status\n",
-					       req->rq_disk->disk_name, err);
+					       rqc->rq_disk->disk_name, err);
 					goto cmd_err;
 				}
 				/*
@@ -506,21 +499,22 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 #if 0
 			if (cmd.resp[0] & ~0x00000900)
 				printk(KERN_ERR "%s: status = %08x\n",
-				       req->rq_disk->disk_name, cmd.resp[0]);
+				       rqc->rq_disk->disk_name, cmd.resp[0]);
 			if (mmc_decode_status(cmd.resp))
 				goto cmd_err;
 #endif
 		}
 
-		if (brq.cmd.error || brq.stop.error || brq.data.error) {
-			if (rq_data_dir(req) == READ) {
+		if (brqc->cmd.error || brqc->stop.error || brqc->data.error) {
+			if (rq_data_dir(rqc) == READ) {
 				/*
 				 * After an error, we redo I/O one sector at a
 				 * time, so we only reach here after trying to
 				 * read a single sector.
 				 */
 				spin_lock_irq(&md->lock);
-				ret = __blk_end_request(req, -EIO, brq.data.blksz);
+				ret = __blk_end_request(rqc, -EIO,
+							brqc->data.blksz);
 				spin_unlock_irq(&md->lock);
 				continue;
 			}
@@ -531,7 +525,7 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 		 * A block was successfully transferred.
 		 */
 		spin_lock_irq(&md->lock);
-		ret = __blk_end_request(req, 0, brq.data.bytes_xfered);
+		ret = __blk_end_request(rqc, 0, brqc->data.bytes_xfered);
 		spin_unlock_irq(&md->lock);
 	} while (ret);
 
@@ -554,12 +548,12 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 		blocks = mmc_sd_num_wr_blocks(card);
 		if (blocks != (u32)-1) {
 			spin_lock_irq(&md->lock);
-			ret = __blk_end_request(req, 0, blocks << 9);
+			ret = __blk_end_request(rqc, 0, blocks << 9);
 			spin_unlock_irq(&md->lock);
 		}
 	} else {
 		spin_lock_irq(&md->lock);
-		ret = __blk_end_request(req, 0, brq.data.bytes_xfered);
+		ret = __blk_end_request(rqc, 0, brqc->data.bytes_xfered);
 		spin_unlock_irq(&md->lock);
 	}
 
@@ -567,7 +561,7 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 
 	spin_lock_irq(&md->lock);
 	while (ret)
-		ret = __blk_end_request(req, -EIO, blk_rq_cur_bytes(req));
+		ret = __blk_end_request(rqc, -EIO, blk_rq_cur_bytes(rqc));
 	spin_unlock_irq(&md->lock);
 
 	return 0;
diff --git a/drivers/mmc/card/queue.h b/drivers/mmc/card/queue.h
index f65eb88..bf3dee9 100644
--- a/drivers/mmc/card/queue.h
+++ b/drivers/mmc/card/queue.h
@@ -4,12 +4,20 @@
 struct request;
 struct task_struct;
 
+struct mmc_blk_request {
+	struct mmc_request	mrq;
+	struct mmc_command	cmd;
+	struct mmc_command	stop;
+	struct mmc_data		data;
+};
+
 struct mmc_queue_req {
 	struct request		*req;
 	struct scatterlist	*sg;
 	char			*bounce_buf;
 	struct scatterlist	*bounce_sg;
 	unsigned int		bounce_sg_len;
+	struct mmc_blk_request	brq;
 };
 
 struct mmc_queue {
@@ -20,7 +28,6 @@ struct mmc_queue {
 	int			(*issue_fn)(struct mmc_queue *, struct request *);
 	void			*data;
 	struct request_queue	*queue;
-
 	struct mmc_queue_req	mqrq[2];
 	struct mmc_queue_req	*mqrq_cur;
 	struct mmc_queue_req	*mqrq_prev;
-- 
1.7.1

