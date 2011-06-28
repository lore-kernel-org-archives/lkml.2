Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006Ab1F1IQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 04:16:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45016 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756766Ab1F1INT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 04:13:19 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linaro-dev@lists.linaro.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org,
        Nickolay Nickolaev <nicknickolaev@gmail.com>,
        Venkatraman S <svenkatr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Chris Ball <cjb@laptop.org>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v8 08/12] mmc: block: add a block request prepare function
Date: Tue, 28 Jun 2011 10:11:53 +0200
Message-Id: <1309248717-14606-9-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309248717-14606-1-git-send-email-per.forlin@linaro.org>
References: <1309248717-14606-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Break out code from mmc_blk_issue_rw_rq to create a
block request prepare function. This doesn't change
any functionallity. This helps when handling more
than one active block request.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 drivers/mmc/card/block.c |  218 ++++++++++++++++++++++++----------------------
 1 files changed, 114 insertions(+), 104 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 88bcc4e..a0a76f4 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -812,12 +812,15 @@ static inline void mmc_apply_rel_rw(struct mmc_blk_request *brq,
 	 R1_CC_ERROR |		/* Card controller error */		\
 	 R1_ERROR)		/* General/unknown error */
 
-static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
+static void mmc_blk_rw_rq_prep(struct mmc_queue_req *mqrq,
+			       struct mmc_card *card,
+			       int disable_multi,
+			       struct mmc_queue *mq)
 {
+	u32 readcmd, writecmd;
+	struct mmc_blk_request *brq = &mqrq->brq;
+	struct request *req = mqrq->req;
 	struct mmc_blk_data *md = mq->data;
-	struct mmc_card *card = md->queue.card;
-	struct mmc_blk_request *brq = &mq->mqrq_cur->brq;
-	int ret = 1, disable_multi = 0, retry = 0;
 
 	/*
 	 * Reliable writes are used to implement Forced Unit Access and
@@ -828,119 +831,126 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 		(rq_data_dir(req) == WRITE) &&
 		(md->flags & MMC_BLK_REL_WR);
 
-	do {
-		u32 readcmd, writecmd;
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
-
-		/*
-		 * The block layer doesn't support all sector count
-		 * restrictions, so we need to be prepared for too big
-		 * requests.
-		 */
-		if (brq->data.blocks > card->host->max_blk_count)
-			brq->data.blocks = card->host->max_blk_count;
+	memset(brq, 0, sizeof(struct mmc_blk_request));
+	brq->mrq.cmd = &brq->cmd;
+	brq->mrq.data = &brq->data;
 
-		/*
-		 * After a read error, we redo the request one sector at a time
-		 * in order to accurately determine which sectors can be read
-		 * successfully.
-		 */
-		if (disable_multi && brq->data.blocks > 1)
-			brq->data.blocks = 1;
+	brq->cmd.arg = blk_rq_pos(req);
+	if (!mmc_card_blockaddr(card))
+		brq->cmd.arg <<= 9;
+	brq->cmd.flags = MMC_RSP_SPI_R1 | MMC_RSP_R1 | MMC_CMD_ADTC;
+	brq->data.blksz = 512;
+	brq->stop.opcode = MMC_STOP_TRANSMISSION;
+	brq->stop.arg = 0;
+	brq->stop.flags = MMC_RSP_SPI_R1B | MMC_RSP_R1B | MMC_CMD_AC;
+	brq->data.blocks = blk_rq_sectors(req);
 
-		if (brq->data.blocks > 1 || do_rel_wr) {
-			/* SPI multiblock writes terminate using a special
-			 * token, not a STOP_TRANSMISSION request.
-			 */
-			if (!mmc_host_is_spi(card->host) ||
-			    rq_data_dir(req) == READ)
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
+	/*
+	 * The block layer doesn't support all sector count
+	 * restrictions, so we need to be prepared for too big
+	 * requests.
+	 */
+	if (brq->data.blocks > card->host->max_blk_count)
+		brq->data.blocks = card->host->max_blk_count;
 
-		if (do_rel_wr)
-			mmc_apply_rel_rw(brq, card, req);
+	/*
+	 * After a read error, we redo the request one sector at a time
+	 * in order to accurately determine which sectors can be read
+	 * successfully.
+	 */
+	if (disable_multi && brq->data.blocks > 1)
+		brq->data.blocks = 1;
 
-		/*
-		 * Pre-defined multi-block transfers are preferable to
-		 * open ended-ones (and necessary for reliable writes).
-		 * However, it is not sufficient to just send CMD23,
-		 * and avoid the final CMD12, as on an error condition
-		 * CMD12 (stop) needs to be sent anyway. This, coupled
-		 * with Auto-CMD23 enhancements provided by some
-		 * hosts, means that the complexity of dealing
-		 * with this is best left to the host. If CMD23 is
-		 * supported by card and host, we'll fill sbc in and let
-		 * the host deal with handling it correctly. This means
-		 * that for hosts that don't expose MMC_CAP_CMD23, no
-		 * change of behavior will be observed.
-		 *
-		 * N.B: Some MMC cards experience perf degradation.
-		 * We'll avoid using CMD23-bounded multiblock writes for
-		 * these, while retaining features like reliable writes.
+	if (brq->data.blocks > 1 || do_rel_wr) {
+		/* SPI multiblock writes terminate using a special
+		 * token, not a STOP_TRANSMISSION request.
 		 */
+		if (!mmc_host_is_spi(card->host) ||
+		    rq_data_dir(req) == READ)
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
 
-		if ((md->flags & MMC_BLK_CMD23) &&
-		    mmc_op_multi(brq->cmd.opcode) &&
-		    (do_rel_wr || !(card->quirks & MMC_QUIRK_BLK_NO_CMD23))) {
-			brq->sbc.opcode = MMC_SET_BLOCK_COUNT;
-			brq->sbc.arg = brq->data.blocks |
-				(do_rel_wr ? (1 << 31) : 0);
-			brq->sbc.flags = MMC_RSP_R1 | MMC_CMD_AC;
-			brq->mrq.sbc = &brq->sbc;
-		}
+	if (do_rel_wr)
+		mmc_apply_rel_rw(brq, card, req);
 
-		mmc_set_data_timeout(&brq->data, card);
+	/*
+	 * Pre-defined multi-block transfers are preferable to
+	 * open ended-ones (and necessary for reliable writes).
+	 * However, it is not sufficient to just send CMD23,
+	 * and avoid the final CMD12, as on an error condition
+	 * CMD12 (stop) needs to be sent anyway. This, coupled
+	 * with Auto-CMD23 enhancements provided by some
+	 * hosts, means that the complexity of dealing
+	 * with this is best left to the host. If CMD23 is
+	 * supported by card and host, we'll fill sbc in and let
+	 * the host deal with handling it correctly. This means
+	 * that for hosts that don't expose MMC_CAP_CMD23, no
+	 * change of behavior will be observed.
+	 *
+	 * N.B: Some MMC cards experience perf degradation.
+	 * We'll avoid using CMD23-bounded multiblock writes for
+	 * these, while retaining features like reliable writes.
+	 */
 
-		brq->data.sg = mq->mqrq_cur->sg;
-		brq->data.sg_len = mmc_queue_map_sg(mq, mq->mqrq_cur);
+	if ((md->flags & MMC_BLK_CMD23) &&
+	    mmc_op_multi(brq->cmd.opcode) &&
+	    (do_rel_wr || !(card->quirks & MMC_QUIRK_BLK_NO_CMD23))) {
+		brq->sbc.opcode = MMC_SET_BLOCK_COUNT;
+		brq->sbc.arg = brq->data.blocks |
+			(do_rel_wr ? (1 << 31) : 0);
+		brq->sbc.flags = MMC_RSP_R1 | MMC_CMD_AC;
+		brq->mrq.sbc = &brq->sbc;
+	}
 
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
+	mmc_set_data_timeout(&brq->data, card);
+
+	brq->data.sg = mqrq->sg;
+	brq->data.sg_len = mmc_queue_map_sg(mq, mqrq);
+
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
 
+static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
+{
+	struct mmc_blk_data *md = mq->data;
+	struct mmc_card *card = md->queue.card;
+	struct mmc_blk_request *brq = &mq->mqrq_cur->brq;
+	int ret = 1, disable_multi = 0, retry = 0;
+
+	do {
+		mmc_blk_rw_rq_prep(mq->mqrq_cur, card, disable_multi, mq);
 		mmc_wait_for_req(card->host, &brq->mrq);
 
 		mmc_queue_bounce_post(mq->mqrq_cur);
-- 
1.7.4.1

