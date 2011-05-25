Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814Ab1EYV6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 17:58:40 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55562 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932747Ab1EYV6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 17:58:37 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        David Vrabel <david.vrabel@csr.com>
Cc: Chris Ball <cjb@laptop.org>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v4 09/12] mmc: move error code in mmc_block_issue_rw_rq to a separate function.
Date: Wed, 25 May 2011 23:57:30 +0200
Message-Id: <1306360653-6196-10-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1306360653-6196-1-git-send-email-per.forlin@linaro.org>
References: <1306360653-6196-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Break out code without functional changes. This simplifies the code and
makes way for handle two parallel request.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 drivers/mmc/card/block.c |  226 +++++++++++++++++++++++++++-------------------
 1 files changed, 132 insertions(+), 94 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index aead2d1..1c0b077 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -79,6 +79,13 @@ struct mmc_blk_data {
 
 static DEFINE_MUTEX(open_lock);
 
+enum mmc_blk_status {
+	MMC_BLK_SUCCESS = 0,
+	MMC_BLK_RETRY,
+	MMC_BLK_DATA_ERR,
+	MMC_BLK_CMD_ERR,
+};
+
 module_param(perdev_minors, int, 0444);
 MODULE_PARM_DESC(perdev_minors, "Minors numbers to allocate per device");
 
@@ -324,6 +331,102 @@ out:
 	return err ? 0 : 1;
 }
 
+static enum mmc_blk_status mmc_blk_err_check(struct mmc_blk_request *brq,
+					     struct request *req,
+					     struct mmc_card *card,
+					     struct mmc_blk_data *md)
+{
+	struct mmc_command cmd;
+	u32 status = 0;
+	enum mmc_blk_status ret = MMC_BLK_SUCCESS;
+
+	/*
+	 * Check for errors here, but don't jump to cmd_err
+	 * until later as we need to wait for the card to leave
+	 * programming mode even when things go wrong.
+	 */
+	if (brq->cmd.error || brq->data.error || brq->stop.error) {
+		if (brq->data.blocks > 1 && rq_data_dir(req) == READ) {
+			/* Redo read one sector at a time */
+			printk(KERN_WARNING "%s: retrying using single "
+			       "block read, brq %p\n",
+			       req->rq_disk->disk_name, brq);
+			ret = MMC_BLK_RETRY;
+			goto out;
+		}
+		status = get_card_status(card, req);
+	}
+
+	if (brq->cmd.error) {
+		printk(KERN_ERR "%s: error %d sending read/write "
+		       "command, response %#x, card status %#x\n",
+		       req->rq_disk->disk_name, brq->cmd.error,
+		       brq->cmd.resp[0], status);
+	}
+
+	if (brq->data.error) {
+		if (brq->data.error == -ETIMEDOUT && brq->mrq.stop)
+			/* 'Stop' response contains card status */
+			status = brq->mrq.stop->resp[0];
+		printk(KERN_ERR "%s: error %d transferring data,"
+		       " sector %u, nr %u, card status %#x\n",
+		       req->rq_disk->disk_name, brq->data.error,
+		       (unsigned)blk_rq_pos(req),
+		       (unsigned)blk_rq_sectors(req), status);
+	}
+
+	if (brq->stop.error) {
+		printk(KERN_ERR "%s: error %d sending stop command, "
+		       "response %#x, card status %#x\n",
+		       req->rq_disk->disk_name, brq->stop.error,
+		       brq->stop.resp[0], status);
+	}
+
+	if (!mmc_host_is_spi(card->host) && rq_data_dir(req) != READ) {
+		do {
+			int err;
+
+			cmd.opcode = MMC_SEND_STATUS;
+			cmd.arg = card->rca << 16;
+			cmd.flags = MMC_RSP_R1 | MMC_CMD_AC;
+			err = mmc_wait_for_cmd(card->host, &cmd, 5);
+			if (err) {
+				printk(KERN_ERR "%s: error %d requesting status\n",
+				       req->rq_disk->disk_name, err);
+				ret = MMC_BLK_CMD_ERR;
+				goto out;
+			}
+			/*
+			 * Some cards mishandle the status bits,
+			 * so make sure to check both the busy
+			 * indication and the card state.
+			 */
+		} while (!(cmd.resp[0] & R1_READY_FOR_DATA) ||
+			 (R1_CURRENT_STATE(cmd.resp[0]) == 7));
+
+#if 0
+		if (cmd.resp[0] & ~0x00000900)
+			printk(KERN_ERR "%s: status = %08x\n",
+			       req->rq_disk->disk_name, cmd.resp[0]);
+		if (mmc_decode_status(cmd.resp)) {
+			ret = MMC_BLK_CMD_ERR;
+			goto out;
+		}
+
+#endif
+	}
+
+	if (brq->cmd.error || brq->stop.error || brq->data.error) {
+		if (rq_data_dir(req) == READ)
+			ret = MMC_BLK_DATA_ERR;
+		else
+			ret = MMC_BLK_CMD_ERR;
+	}
+ out:
+	return ret;
+
+}
+
 static void mmc_blk_rw_rq_prep(struct mmc_queue_req *mqrq,
 			       struct mmc_card *card,
 			       int disable_multi,
@@ -419,111 +522,46 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 	struct mmc_card *card = md->queue.card;
 	struct mmc_blk_request *brq = &mq->mqrq_cur->brq;
 	int ret = 1, disable_multi = 0;
+	enum mmc_blk_status status;
 
 	mmc_claim_host(card->host);
 
 	do {
-		struct mmc_command cmd;
-		u32 status = 0;
-
 		mmc_blk_rw_rq_prep(mq->mqrq_cur, card, disable_multi, mq);
 		mmc_wait_for_req(card->host, &brq->mrq);
 
 		mmc_queue_bounce_post(mq->mqrq_cur);
+		status = mmc_blk_err_check(brq, req, card, md);
 
-		/*
-		 * Check for errors here, but don't jump to cmd_err
-		 * until later as we need to wait for the card to leave
-		 * programming mode even when things go wrong.
-		 */
-		if (brq->cmd.error || brq->data.error || brq->stop.error) {
-			if (brq->data.blocks > 1 && rq_data_dir(req) == READ) {
-				/* Redo read one sector at a time */
-				printk(KERN_WARNING "%s: retrying using single "
-				       "block read\n", req->rq_disk->disk_name);
-				disable_multi = 1;
-				continue;
-			}
-			status = get_card_status(card, req);
-		}
-
-		if (brq->cmd.error) {
-			printk(KERN_ERR "%s: error %d sending read/write "
-			       "command, response %#x, card status %#x\n",
-			       req->rq_disk->disk_name, brq->cmd.error,
-			       brq->cmd.resp[0], status);
-		}
-
-		if (brq->data.error) {
-			if (brq->data.error == -ETIMEDOUT && brq->mrq.stop)
-				/* 'Stop' response contains card status */
-				status = brq->mrq.stop->resp[0];
-			printk(KERN_ERR "%s: error %d transferring data,"
-			       " sector %u, nr %u, card status %#x\n",
-			       req->rq_disk->disk_name, brq->data.error,
-			       (unsigned)blk_rq_pos(req),
-			       (unsigned)blk_rq_sectors(req), status);
-		}
-
-		if (brq->stop.error) {
-			printk(KERN_ERR "%s: error %d sending stop command, "
-			       "response %#x, card status %#x\n",
-			       req->rq_disk->disk_name, brq->stop.error,
-			       brq->stop.resp[0], status);
-		}
-
-		if (!mmc_host_is_spi(card->host) && rq_data_dir(req) != READ) {
-			do {
-				int err;
-
-				cmd.opcode = MMC_SEND_STATUS;
-				cmd.arg = card->rca << 16;
-				cmd.flags = MMC_RSP_R1 | MMC_CMD_AC;
-				err = mmc_wait_for_cmd(card->host, &cmd, 5);
-				if (err) {
-					printk(KERN_ERR "%s: error %d requesting status\n",
-					       req->rq_disk->disk_name, err);
-					goto cmd_err;
-				}
-				/*
-				 * Some cards mishandle the status bits,
-				 * so make sure to check both the busy
-				 * indication and the card state.
-				 */
-			} while (!(cmd.resp[0] & R1_READY_FOR_DATA) ||
-				(R1_CURRENT_STATE(cmd.resp[0]) == 7));
-
-#if 0
-			if (cmd.resp[0] & ~0x00000900)
-				printk(KERN_ERR "%s: status = %08x\n",
-				       req->rq_disk->disk_name, cmd.resp[0]);
-			if (mmc_decode_status(cmd.resp))
-				goto cmd_err;
-#endif
-		}
-
-		if (brq->cmd.error || brq->stop.error || brq->data.error) {
-			if (rq_data_dir(req) == READ) {
-				/*
-				 * After an error, we redo I/O one sector at a
-				 * time, so we only reach here after trying to
-				 * read a single sector.
-				 */
-				spin_lock_irq(&md->lock);
-				ret = __blk_end_request(req, -EIO,
-							brq->data.blksz);
-				spin_unlock_irq(&md->lock);
-				continue;
-			}
+		switch (status) {
+		case MMC_BLK_CMD_ERR:
 			goto cmd_err;
-		}
+			break;
+		case MMC_BLK_RETRY:
+			disable_multi = 1;
+			ret = 1;
+			break;
+		case MMC_BLK_DATA_ERR:
+			/*
+			 * After an error, we redo I/O one sector at a
+			 * time, so we only reach here after trying to
+			 * read a single sector.
+			 */
+			spin_lock_irq(&md->lock);
+			ret = __blk_end_request(req, -EIO,
+						brq->data.blksz);
+			spin_unlock_irq(&md->lock);
 
-		/*
-		 * A block was successfully transferred.
-		 */
-		spin_lock_irq(&md->lock);
-		ret = __blk_end_request(req, 0, brq->data.bytes_xfered);
-		spin_unlock_irq(&md->lock);
+			break;
+		case MMC_BLK_SUCCESS:
+			/*
+			 * A block was successfully transferred.
+			 */
+			spin_lock_irq(&md->lock);
+			ret = __blk_end_request(req, 0, brq->data.bytes_xfered);
+			spin_unlock_irq(&md->lock);
+			break;
+		}
 	} while (ret);
 
 	mmc_release_host(card->host);
-- 
1.7.4.1

