Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab1F1IQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 04:16:03 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33139 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356Ab1F1INP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 04:13:15 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linaro-dev@lists.linaro.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org,
        Nickolay Nickolaev <nicknickolaev@gmail.com>,
        Venkatraman S <svenkatr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Chris Ball <cjb@laptop.org>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v8 07/12] mmc: block: add member in mmc queue struct to hold request data
Date: Tue, 28 Jun 2011 10:11:52 +0200
Message-Id: <1309248717-14606-8-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309248717-14606-1-git-send-email-per.forlin@linaro.org>
References: <1309248717-14606-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The way the request data is organized in the mmc queue struct
it only allows processing of one request at the time.
This patch adds a new struct to hold mmc queue request data such as
sg list, request, blk request and bounce buffers, and updates any functions
depending on the mmc queue struct. This lies the ground for
using multiple active request for one mmc queue.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 drivers/mmc/card/block.c |  109 ++++++++++++++++++---------------------
 drivers/mmc/card/queue.c |  129 ++++++++++++++++++++++++----------------------
 drivers/mmc/card/queue.h |   31 ++++++++---
 3 files changed, 141 insertions(+), 128 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index bee2106..88bcc4e 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -427,14 +427,6 @@ static const struct block_device_operations mmc_bdops = {
 #endif
 };
 
-struct mmc_blk_request {
-	struct mmc_request	mrq;
-	struct mmc_command	sbc;
-	struct mmc_command	cmd;
-	struct mmc_command	stop;
-	struct mmc_data		data;
-};
-
 static inline int mmc_blk_part_switch(struct mmc_card *card,
 				      struct mmc_blk_data *md)
 {
@@ -824,7 +816,7 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 {
 	struct mmc_blk_data *md = mq->data;
 	struct mmc_card *card = md->queue.card;
-	struct mmc_blk_request brq;
+	struct mmc_blk_request *brq = &mq->mqrq_cur->brq;
 	int ret = 1, disable_multi = 0, retry = 0;
 
 	/*
@@ -839,60 +831,60 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 	do {
 		u32 readcmd, writecmd;
 
-		memset(&brq, 0, sizeof(struct mmc_blk_request));
-		brq.mrq.cmd = &brq.cmd;
-		brq.mrq.data = &brq.data;
+		memset(brq, 0, sizeof(struct mmc_blk_request));
+		brq->mrq.cmd = &brq->cmd;
+		brq->mrq.data = &brq->data;
 
-		brq.cmd.arg = blk_rq_pos(req);
+		brq->cmd.arg = blk_rq_pos(req);
 		if (!mmc_card_blockaddr(card))
-			brq.cmd.arg <<= 9;
-		brq.cmd.flags = MMC_RSP_SPI_R1 | MMC_RSP_R1 | MMC_CMD_ADTC;
-		brq.data.blksz = 512;
-		brq.stop.opcode = MMC_STOP_TRANSMISSION;
-		brq.stop.arg = 0;
-		brq.stop.flags = MMC_RSP_SPI_R1B | MMC_RSP_R1B | MMC_CMD_AC;
-		brq.data.blocks = blk_rq_sectors(req);
+			brq->cmd.arg <<= 9;
+		brq->cmd.flags = MMC_RSP_SPI_R1 | MMC_RSP_R1 | MMC_CMD_ADTC;
+		brq->data.blksz = 512;
+		brq->stop.opcode = MMC_STOP_TRANSMISSION;
+		brq->stop.arg = 0;
+		brq->stop.flags = MMC_RSP_SPI_R1B | MMC_RSP_R1B | MMC_CMD_AC;
+		brq->data.blocks = blk_rq_sectors(req);
 
 		/*
 		 * The block layer doesn't support all sector count
 		 * restrictions, so we need to be prepared for too big
 		 * requests.
 		 */
-		if (brq.data.blocks > card->host->max_blk_count)
-			brq.data.blocks = card->host->max_blk_count;
+		if (brq->data.blocks > card->host->max_blk_count)
+			brq->data.blocks = card->host->max_blk_count;
 
 		/*
 		 * After a read error, we redo the request one sector at a time
 		 * in order to accurately determine which sectors can be read
 		 * successfully.
 		 */
-		if (disable_multi && brq.data.blocks > 1)
-			brq.data.blocks = 1;
+		if (disable_multi && brq->data.blocks > 1)
+			brq->data.blocks = 1;
 
-		if (brq.data.blocks > 1 || do_rel_wr) {
+		if (brq->data.blocks > 1 || do_rel_wr) {
 			/* SPI multiblock writes terminate using a special
 			 * token, not a STOP_TRANSMISSION request.
 			 */
 			if (!mmc_host_is_spi(card->host) ||
 			    rq_data_dir(req) == READ)
-				brq.mrq.stop = &brq.stop;
+				brq->mrq.stop = &brq->stop;
 			readcmd = MMC_READ_MULTIPLE_BLOCK;
 			writecmd = MMC_WRITE_MULTIPLE_BLOCK;
 		} else {
-			brq.mrq.stop = NULL;
+			brq->mrq.stop = NULL;
 			readcmd = MMC_READ_SINGLE_BLOCK;
 			writecmd = MMC_WRITE_BLOCK;
 		}
 		if (rq_data_dir(req) == READ) {
-			brq.cmd.opcode = readcmd;
-			brq.data.flags |= MMC_DATA_READ;
+			brq->cmd.opcode = readcmd;
+			brq->data.flags |= MMC_DATA_READ;
 		} else {
-			brq.cmd.opcode = writecmd;
-			brq.data.flags |= MMC_DATA_WRITE;
+			brq->cmd.opcode = writecmd;
+			brq->data.flags |= MMC_DATA_WRITE;
 		}
 
 		if (do_rel_wr)
-			mmc_apply_rel_rw(&brq, card, req);
+			mmc_apply_rel_rw(brq, card, req);
 
 		/*
 		 * Pre-defined multi-block transfers are preferable to
@@ -914,29 +906,29 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 		 */
 
 		if ((md->flags & MMC_BLK_CMD23) &&
-		    mmc_op_multi(brq.cmd.opcode) &&
+		    mmc_op_multi(brq->cmd.opcode) &&
 		    (do_rel_wr || !(card->quirks & MMC_QUIRK_BLK_NO_CMD23))) {
-			brq.sbc.opcode = MMC_SET_BLOCK_COUNT;
-			brq.sbc.arg = brq.data.blocks |
+			brq->sbc.opcode = MMC_SET_BLOCK_COUNT;
+			brq->sbc.arg = brq->data.blocks |
 				(do_rel_wr ? (1 << 31) : 0);
-			brq.sbc.flags = MMC_RSP_R1 | MMC_CMD_AC;
-			brq.mrq.sbc = &brq.sbc;
+			brq->sbc.flags = MMC_RSP_R1 | MMC_CMD_AC;
+			brq->mrq.sbc = &brq->sbc;
 		}
 
-		mmc_set_data_timeout(&brq.data, card);
+		mmc_set_data_timeout(&brq->data, card);
 
-		brq.data.sg = mq->sg;
-		brq.data.sg_len = mmc_queue_map_sg(mq);
+		brq->data.sg = mq->mqrq_cur->sg;
+		brq->data.sg_len = mmc_queue_map_sg(mq, mq->mqrq_cur);
 
 		/*
 		 * Adjust the sg list so it is the same size as the
 		 * request.
 		 */
-		if (brq.data.blocks != blk_rq_sectors(req)) {
-			int i, data_size = brq.data.blocks << 9;
+		if (brq->data.blocks != blk_rq_sectors(req)) {
+			int i, data_size = brq->data.blocks << 9;
 			struct scatterlist *sg;
 
-			for_each_sg(brq.data.sg, sg, brq.data.sg_len, i) {
+			for_each_sg(brq->data.sg, sg, brq->data.sg_len, i) {
 				data_size -= sg->length;
 				if (data_size <= 0) {
 					sg->length += data_size;
@@ -944,14 +936,14 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 					break;
 				}
 			}
-			brq.data.sg_len = i;
+			brq->data.sg_len = i;
 		}
 
-		mmc_queue_bounce_pre(mq);
+		mmc_queue_bounce_pre(mq->mqrq_cur);
 
-		mmc_wait_for_req(card->host, &brq.mrq);
+		mmc_wait_for_req(card->host, &brq->mrq);
 
-		mmc_queue_bounce_post(mq);
+		mmc_queue_bounce_post(mq->mqrq_cur);
 
 		/*
 		 * sbc.error indicates a problem with the set block count
@@ -963,8 +955,8 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 		 * stop.error indicates a problem with the stop command.  Data
 		 * may have been transferred, or may still be transferring.
 		 */
-		if (brq.sbc.error || brq.cmd.error || brq.stop.error) {
-			switch (mmc_blk_cmd_recovery(card, req, &brq)) {
+		if (brq->sbc.error || brq->cmd.error || brq->stop.error) {
+			switch (mmc_blk_cmd_recovery(card, req, brq)) {
 			case ERR_RETRY:
 				if (retry++ < 5)
 					continue;
@@ -980,9 +972,9 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 		 * initial command - such as address errors.  No data
 		 * has been transferred.
 		 */
-		if (brq.cmd.resp[0] & CMD_ERRORS) {
+		if (brq->cmd.resp[0] & CMD_ERRORS) {
 			pr_err("%s: r/w command failed, status = %#x\n",
-				req->rq_disk->disk_name, brq.cmd.resp[0]);
+				req->rq_disk->disk_name, brq->cmd.resp[0]);
 			goto cmd_abort;
 		}
 
@@ -1009,15 +1001,15 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 				 (R1_CURRENT_STATE(status) == R1_STATE_PRG));
 		}
 
-		if (brq.data.error) {
+		if (brq->data.error) {
 			pr_err("%s: error %d transferring data, sector %u, nr %u, cmd response %#x, card status %#x\n",
-				req->rq_disk->disk_name, brq.data.error,
+				req->rq_disk->disk_name, brq->data.error,
 				(unsigned)blk_rq_pos(req),
 				(unsigned)blk_rq_sectors(req),
-				brq.cmd.resp[0], brq.stop.resp[0]);
+				brq->cmd.resp[0], brq->stop.resp[0]);
 
 			if (rq_data_dir(req) == READ) {
-				if (brq.data.blocks > 1) {
+				if (brq->data.blocks > 1) {
 					/* Redo read one sector at a time */
 					pr_warning("%s: retrying using single block read\n",
 						req->rq_disk->disk_name);
@@ -1031,7 +1023,8 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 				 * read a single sector.
 				 */
 				spin_lock_irq(&md->lock);
-				ret = __blk_end_request(req, -EIO, brq.data.blksz);
+				ret = __blk_end_request(req, -EIO,
+							brq->data.blksz);
 				spin_unlock_irq(&md->lock);
 				continue;
 			} else {
@@ -1043,7 +1036,7 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 		 * A block was successfully transferred.
 		 */
 		spin_lock_irq(&md->lock);
-		ret = __blk_end_request(req, 0, brq.data.bytes_xfered);
+		ret = __blk_end_request(req, 0, brq->data.bytes_xfered);
 		spin_unlock_irq(&md->lock);
 	} while (ret);
 
@@ -1069,7 +1062,7 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 		}
 	} else {
 		spin_lock_irq(&md->lock);
-		ret = __blk_end_request(req, 0, brq.data.bytes_xfered);
+		ret = __blk_end_request(req, 0, brq->data.bytes_xfered);
 		spin_unlock_irq(&md->lock);
 	}
 
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 6413afa..4222e1a 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -56,7 +56,7 @@ static int mmc_queue_thread(void *d)
 		spin_lock_irq(q->queue_lock);
 		set_current_state(TASK_INTERRUPTIBLE);
 		req = blk_fetch_request(q);
-		mq->req = req;
+		mq->mqrq_cur->req = req;
 		spin_unlock_irq(q->queue_lock);
 
 		if (!req) {
@@ -97,10 +97,25 @@ static void mmc_request(struct request_queue *q)
 		return;
 	}
 
-	if (!mq->req)
+	if (!mq->mqrq_cur->req)
 		wake_up_process(mq->thread);
 }
 
+struct scatterlist *mmc_alloc_sg(int sg_len, int *err)
+{
+	struct scatterlist *sg;
+
+	sg = kmalloc(sizeof(struct scatterlist)*sg_len, GFP_KERNEL);
+	if (!sg)
+		*err = -ENOMEM;
+	else {
+		*err = 0;
+		sg_init_table(sg, sg_len);
+	}
+
+	return sg;
+}
+
 /**
  * mmc_init_queue - initialise a queue structure.
  * @mq: mmc queue
@@ -116,6 +131,7 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
 	struct mmc_host *host = card->host;
 	u64 limit = BLK_BOUNCE_HIGH;
 	int ret;
+	struct mmc_queue_req *mqrq_cur = &mq->mqrq[0];
 
 	if (mmc_dev(host)->dma_mask && *mmc_dev(host)->dma_mask)
 		limit = *mmc_dev(host)->dma_mask;
@@ -125,8 +141,9 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
 	if (!mq->queue)
 		return -ENOMEM;
 
+	memset(&mq->mqrq_cur, 0, sizeof(mq->mqrq_cur));
+	mq->mqrq_cur = mqrq_cur;
 	mq->queue->queuedata = mq;
-	mq->req = NULL;
 
 	blk_queue_prep_rq(mq->queue, mmc_prep_request);
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, mq->queue);
@@ -155,53 +172,44 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
 			bouncesz = host->max_blk_count * 512;
 
 		if (bouncesz > 512) {
-			mq->bounce_buf = kmalloc(bouncesz, GFP_KERNEL);
-			if (!mq->bounce_buf) {
+			mqrq_cur->bounce_buf = kmalloc(bouncesz, GFP_KERNEL);
+			if (!mqrq_cur->bounce_buf) {
 				printk(KERN_WARNING "%s: unable to "
-					"allocate bounce buffer\n",
+					"allocate bounce cur buffer\n",
 					mmc_card_name(card));
 			}
 		}
 
-		if (mq->bounce_buf) {
+		if (mqrq_cur->bounce_buf) {
 			blk_queue_bounce_limit(mq->queue, BLK_BOUNCE_ANY);
 			blk_queue_max_hw_sectors(mq->queue, bouncesz / 512);
 			blk_queue_max_segments(mq->queue, bouncesz / 512);
 			blk_queue_max_segment_size(mq->queue, bouncesz);
 
-			mq->sg = kmalloc(sizeof(struct scatterlist),
-				GFP_KERNEL);
-			if (!mq->sg) {
-				ret = -ENOMEM;
+			mqrq_cur->sg = mmc_alloc_sg(1, &ret);
+			if (ret)
 				goto cleanup_queue;
-			}
-			sg_init_table(mq->sg, 1);
 
-			mq->bounce_sg = kmalloc(sizeof(struct scatterlist) *
-				bouncesz / 512, GFP_KERNEL);
-			if (!mq->bounce_sg) {
-				ret = -ENOMEM;
+			mqrq_cur->bounce_sg =
+				mmc_alloc_sg(bouncesz / 512, &ret);
+			if (ret)
 				goto cleanup_queue;
-			}
-			sg_init_table(mq->bounce_sg, bouncesz / 512);
+
 		}
 	}
 #endif
 
-	if (!mq->bounce_buf) {
+	if (!mqrq_cur->bounce_buf) {
 		blk_queue_bounce_limit(mq->queue, limit);
 		blk_queue_max_hw_sectors(mq->queue,
 			min(host->max_blk_count, host->max_req_size / 512));
 		blk_queue_max_segments(mq->queue, host->max_segs);
 		blk_queue_max_segment_size(mq->queue, host->max_seg_size);
 
-		mq->sg = kmalloc(sizeof(struct scatterlist) *
-			host->max_segs, GFP_KERNEL);
-		if (!mq->sg) {
-			ret = -ENOMEM;
+		mqrq_cur->sg = mmc_alloc_sg(host->max_segs, &ret);
+		if (ret)
 			goto cleanup_queue;
-		}
-		sg_init_table(mq->sg, host->max_segs);
+
 	}
 
 	sema_init(&mq->thread_sem, 1);
@@ -216,16 +224,15 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
 
 	return 0;
  free_bounce_sg:
- 	if (mq->bounce_sg)
- 		kfree(mq->bounce_sg);
- 	mq->bounce_sg = NULL;
+	kfree(mqrq_cur->bounce_sg);
+	mqrq_cur->bounce_sg = NULL;
+
  cleanup_queue:
- 	if (mq->sg)
-		kfree(mq->sg);
-	mq->sg = NULL;
-	if (mq->bounce_buf)
-		kfree(mq->bounce_buf);
-	mq->bounce_buf = NULL;
+	kfree(mqrq_cur->sg);
+	mqrq_cur->sg = NULL;
+	kfree(mqrq_cur->bounce_buf);
+	mqrq_cur->bounce_buf = NULL;
+
 	blk_cleanup_queue(mq->queue);
 	return ret;
 }
@@ -234,6 +241,7 @@ void mmc_cleanup_queue(struct mmc_queue *mq)
 {
 	struct request_queue *q = mq->queue;
 	unsigned long flags;
+	struct mmc_queue_req *mqrq_cur = mq->mqrq_cur;
 
 	/* Make sure the queue isn't suspended, as that will deadlock */
 	mmc_queue_resume(mq);
@@ -247,16 +255,14 @@ void mmc_cleanup_queue(struct mmc_queue *mq)
 	blk_start_queue(q);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
- 	if (mq->bounce_sg)
- 		kfree(mq->bounce_sg);
- 	mq->bounce_sg = NULL;
+	kfree(mqrq_cur->bounce_sg);
+	mqrq_cur->bounce_sg = NULL;
 
-	kfree(mq->sg);
-	mq->sg = NULL;
+	kfree(mqrq_cur->sg);
+	mqrq_cur->sg = NULL;
 
-	if (mq->bounce_buf)
-		kfree(mq->bounce_buf);
-	mq->bounce_buf = NULL;
+	kfree(mqrq_cur->bounce_buf);
+	mqrq_cur->bounce_buf = NULL;
 
 	mq->card = NULL;
 }
@@ -309,27 +315,27 @@ void mmc_queue_resume(struct mmc_queue *mq)
 /*
  * Prepare the sg list(s) to be handed of to the host driver
  */
-unsigned int mmc_queue_map_sg(struct mmc_queue *mq)
+unsigned int mmc_queue_map_sg(struct mmc_queue *mq, struct mmc_queue_req *mqrq)
 {
 	unsigned int sg_len;
 	size_t buflen;
 	struct scatterlist *sg;
 	int i;
 
-	if (!mq->bounce_buf)
-		return blk_rq_map_sg(mq->queue, mq->req, mq->sg);
+	if (!mqrq->bounce_buf)
+		return blk_rq_map_sg(mq->queue, mqrq->req, mqrq->sg);
 
-	BUG_ON(!mq->bounce_sg);
+	BUG_ON(!mqrq->bounce_sg);
 
-	sg_len = blk_rq_map_sg(mq->queue, mq->req, mq->bounce_sg);
+	sg_len = blk_rq_map_sg(mq->queue, mqrq->req, mqrq->bounce_sg);
 
-	mq->bounce_sg_len = sg_len;
+	mqrq->bounce_sg_len = sg_len;
 
 	buflen = 0;
-	for_each_sg(mq->bounce_sg, sg, sg_len, i)
+	for_each_sg(mqrq->bounce_sg, sg, sg_len, i)
 		buflen += sg->length;
 
-	sg_init_one(mq->sg, mq->bounce_buf, buflen);
+	sg_init_one(mqrq->sg, mqrq->bounce_buf, buflen);
 
 	return 1;
 }
@@ -338,31 +344,30 @@ unsigned int mmc_queue_map_sg(struct mmc_queue *mq)
  * If writing, bounce the data to the buffer before the request
  * is sent to the host driver
  */
-void mmc_queue_bounce_pre(struct mmc_queue *mq)
+void mmc_queue_bounce_pre(struct mmc_queue_req *mqrq)
 {
-	if (!mq->bounce_buf)
+	if (!mqrq->bounce_buf)
 		return;
 
-	if (rq_data_dir(mq->req) != WRITE)
+	if (rq_data_dir(mqrq->req) != WRITE)
 		return;
 
-	sg_copy_to_buffer(mq->bounce_sg, mq->bounce_sg_len,
-		mq->bounce_buf, mq->sg[0].length);
+	sg_copy_to_buffer(mqrq->bounce_sg, mqrq->bounce_sg_len,
+		mqrq->bounce_buf, mqrq->sg[0].length);
 }
 
 /*
  * If reading, bounce the data from the buffer after the request
  * has been handled by the host driver
  */
-void mmc_queue_bounce_post(struct mmc_queue *mq)
+void mmc_queue_bounce_post(struct mmc_queue_req *mqrq)
 {
-	if (!mq->bounce_buf)
+	if (!mqrq->bounce_buf)
 		return;
 
-	if (rq_data_dir(mq->req) != READ)
+	if (rq_data_dir(mqrq->req) != READ)
 		return;
 
-	sg_copy_from_buffer(mq->bounce_sg, mq->bounce_sg_len,
-		mq->bounce_buf, mq->sg[0].length);
+	sg_copy_from_buffer(mqrq->bounce_sg, mqrq->bounce_sg_len,
+		mqrq->bounce_buf, mqrq->sg[0].length);
 }
-
diff --git a/drivers/mmc/card/queue.h b/drivers/mmc/card/queue.h
index 6223ef8..c1a69ac 100644
--- a/drivers/mmc/card/queue.h
+++ b/drivers/mmc/card/queue.h
@@ -4,19 +4,33 @@
 struct request;
 struct task_struct;
 
+struct mmc_blk_request {
+	struct mmc_request	mrq;
+	struct mmc_command	sbc;
+	struct mmc_command	cmd;
+	struct mmc_command	stop;
+	struct mmc_data		data;
+};
+
+struct mmc_queue_req {
+	struct request		*req;
+	struct mmc_blk_request	brq;
+	struct scatterlist	*sg;
+	char			*bounce_buf;
+	struct scatterlist	*bounce_sg;
+	unsigned int		bounce_sg_len;
+};
+
 struct mmc_queue {
 	struct mmc_card		*card;
 	struct task_struct	*thread;
 	struct semaphore	thread_sem;
 	unsigned int		flags;
-	struct request		*req;
 	int			(*issue_fn)(struct mmc_queue *, struct request *);
 	void			*data;
 	struct request_queue	*queue;
-	struct scatterlist	*sg;
-	char			*bounce_buf;
-	struct scatterlist	*bounce_sg;
-	unsigned int		bounce_sg_len;
+	struct mmc_queue_req	mqrq[1];
+	struct mmc_queue_req	*mqrq_cur;
 };
 
 extern int mmc_init_queue(struct mmc_queue *, struct mmc_card *, spinlock_t *,
@@ -25,8 +39,9 @@ extern void mmc_cleanup_queue(struct mmc_queue *);
 extern void mmc_queue_suspend(struct mmc_queue *);
 extern void mmc_queue_resume(struct mmc_queue *);
 
-extern unsigned int mmc_queue_map_sg(struct mmc_queue *);
-extern void mmc_queue_bounce_pre(struct mmc_queue *);
-extern void mmc_queue_bounce_post(struct mmc_queue *);
+extern unsigned int mmc_queue_map_sg(struct mmc_queue *,
+				     struct mmc_queue_req *);
+extern void mmc_queue_bounce_pre(struct mmc_queue_req *);
+extern void mmc_queue_bounce_post(struct mmc_queue_req *);
 
 #endif
-- 
1.7.4.1

