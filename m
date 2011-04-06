Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab1DFTIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 15:08:22 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48270 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756566Ab1DFTIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 15:08:18 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Cc: Chris Ball <cjb@laptop.org>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v2 05/12] mmc: add a block request prepare function
Date: Wed,  6 Apr 2011 21:07:06 +0200
Message-Id: <1302116833-24540-6-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302116833-24540-1-git-send-email-per.forlin@linaro.org>
References: <1302116833-24540-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Break out code from mmc_blk_issue_rw_rq to create a
block request prepare function. This doesn't change
any functionallity. This helps when handling more
than one active block request.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 drivers/mmc/card/block.c |  170 ++++++++++++++++++++++++---------------------
 1 files changed, 91 insertions(+), 79 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index ec4e432..e606dec 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -324,97 +324,109 @@ out:
 	return err ? 0 : 1;
 }
 
-static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
+static void mmc_blk_rw_rq_prep(struct mmc_queue_req *mqrq,
+			       struct mmc_card *card,
+			       int disable_multi,
+			       struct mmc_queue *mq)
 {
-	struct mmc_blk_data *md = mq->data;
-	struct mmc_card *card = md->queue.card;
-	struct mmc_blk_request *brq = &mq->mqrq_cur->brq;
-	int ret = 1, disable_multi = 0;
+	u32 readcmd, writecmd;
+	struct mmc_blk_request *brq = &mqrq->brq;
+	struct request *req = mqrq->req;
 
-	mmc_claim_host(card->host);
+	memset(brq, 0, sizeof(struct mmc_blk_request));
 
-	do {
-		struct mmc_command cmd;
-		u32 readcmd, writecmd, status = 0;
-
-		memset(brq, 0, sizeof(struct mmc_blk_request));
-		brq->mrq.cmd = &brq->cmd;
-		brq->mrq.data = &brq->data;
-
-		brq->cmd.arg = blk_rq_pos(req);
-		if (!mmc_card_blockaddr(card))
-			brq->cmd.arg <<= 9;
-		brq->cmd.flags = MMC_RSP_SPI_R1 | MMC_RSP_R1 | MMC_CMD_ADTC;
-		brq->data.blksz = 512;
-		brq->stop.opcode = MMC_STOP_TRANSMISSION;
-		brq->stop.arg = 0;
-		brq->stop.flags = MMC_RSP_SPI_R1B | MMC_RSP_R1B | MMC_CMD_AC;
-		brq->data.blocks = blk_rq_sectors(req);
+	brq->mrq.cmd = &brq->cmd;
+	brq->mrq.data = &brq->data;
 
-		/*
-		 * The block layer doesn't support all sector count
-		 * restrictions, so we need to be prepared for too big
-		 * requests.
-		 */
-		if (brq->data.blocks > card->host->max_blk_count)
-			brq->data.blocks = card->host->max_blk_count;
+	brq->cmd.arg = blk_rq_pos(req);
+	if (!mmc_card_blockaddr(card))
+		brq->cmd.arg <<= 9;
+	brq->cmd.flags = MMC_RSP_SPI_R1 | MMC_RSP_R1 | MMC_CMD_ADTC;
+	brq->data.blksz = 512;
+	brq->stop.opcode = MMC_STOP_TRANSMISSION;
+	brq->stop.arg = 0;
+	brq->stop.flags = MMC_RSP_SPI_R1B | MMC_RSP_R1B | MMC_CMD_AC;
+	brq->data.blocks = blk_rq_sectors(req);
 
-		/*
-		 * After a read error, we redo the request one sector at a time
-		 * in order to accurately determine which sectors can be read
-		 * successfully.
+	/*
+	 * The block layer doesn't support all sector count
+	 * restrictions, so we need to be prepared for too big
+	 * requests.
+	 */
+	if (brq->data.blocks > card->host->max_blk_count)
+		brq->data.blocks = card->host->max_blk_count;
+
+	/*
+	 * After a read error, we redo the request one sector at a time
+	 * in order to accurately determine which sectors can be read
+	 * successfully.
+	 */
+	if (disable_multi && brq->data.blocks > 1)
+		brq->data.blocks = 1;
+
+	if (brq->data.blocks > 1) {
+		/* SPI multiblock writes terminate using a special
+		 * token, not a STOP_TRANSMISSION request.
 		 */
-		if (disable_multi && brq->data.blocks > 1)
-			brq->data.blocks = 1;
-
-		if (brq->data.blocks > 1) {
-			/* SPI multiblock writes terminate using a special
-			 * token, not a STOP_TRANSMISSION request.
-			 */
-			if (!mmc_host_is_spi(card->host)
-					|| rq_data_dir(req) == READ)
-				brq->mrq.stop = &brq->stop;
-			readcmd = MMC_READ_MULTIPLE_BLOCK;
-			writecmd = MMC_WRITE_MULTIPLE_BLOCK;
-		} else {
-			brq->mrq.stop = NULL;
-			readcmd = MMC_READ_SINGLE_BLOCK;
-			writecmd = MMC_WRITE_BLOCK;
-		}
-		if (rq_data_dir(req) == READ) {
-			brq->cmd.opcode = readcmd;
-			brq->data.flags |= MMC_DATA_READ;
-		} else {
-			brq->cmd.opcode = writecmd;
-			brq->data.flags |= MMC_DATA_WRITE;
-		}
+		if (!mmc_host_is_spi(card->host)
+		    || rq_data_dir(req) == READ)
+			brq->mrq.stop = &brq->stop;
+		readcmd = MMC_READ_MULTIPLE_BLOCK;
+		writecmd = MMC_WRITE_MULTIPLE_BLOCK;
+	} else {
+		brq->mrq.stop = NULL;
+		readcmd = MMC_READ_SINGLE_BLOCK;
+		writecmd = MMC_WRITE_BLOCK;
+	}
+	if (rq_data_dir(req) == READ) {
+		brq->cmd.opcode = readcmd;
+		brq->data.flags |= MMC_DATA_READ;
+	} else {
+		brq->cmd.opcode = writecmd;
+		brq->data.flags |= MMC_DATA_WRITE;
+	}
 
-		mmc_set_data_timeout(&brq->data, card);
+	mmc_set_data_timeout(&brq->data, card);
 
-		brq->data.sg = mq->mqrq_cur->sg;
-		brq->data.sg_len = mmc_queue_map_sg(mq, mq->mqrq_cur);
+	brq->data.sg = mqrq->sg;
+	brq->data.sg_len = mmc_queue_map_sg(mq, mqrq);
 
-		/*
-		 * Adjust the sg list so it is the same size as the
-		 * request.
-		 */
-		if (brq->data.blocks != blk_rq_sectors(req)) {
-			int i, data_size = brq->data.blocks << 9;
-			struct scatterlist *sg;
-
-			for_each_sg(brq->data.sg, sg, brq->data.sg_len, i) {
-				data_size -= sg->length;
-				if (data_size <= 0) {
-					sg->length += data_size;
-					i++;
-					break;
-				}
+	/*
+	 * Adjust the sg list so it is the same size as the
+	 * request.
+	 */
+	if (brq->data.blocks != blk_rq_sectors(req)) {
+		int i, data_size = brq->data.blocks << 9;
+		struct scatterlist *sg;
+
+		for_each_sg(brq->data.sg, sg, brq->data.sg_len, i) {
+			data_size -= sg->length;
+			if (data_size <= 0) {
+				sg->length += data_size;
+				i++;
+				break;
 			}
-			brq->data.sg_len = i;
 		}
+		brq->data.sg_len = i;
+	}
 
-		mmc_queue_bounce_pre(mq->mqrq_cur);
+	mmc_queue_bounce_pre(mqrq);
+}
+
+static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
+{
+	struct mmc_blk_data *md = mq->data;
+	struct mmc_card *card = md->queue.card;
+	struct mmc_blk_request *brq = &mq->mqrq_cur->brq;
+	int ret = 1, disable_multi = 0;
+
+	mmc_claim_host(card->host);
+
+	do {
+		struct mmc_command cmd;
+		u32 status = 0;
 
+		mmc_blk_rw_rq_prep(mq->mqrq_cur, card, disable_multi, mq);
 		mmc_wait_for_req(card->host, &brq->mrq);
 
 		mmc_queue_bounce_post(mq->mqrq_cur);
-- 
1.7.4.1

