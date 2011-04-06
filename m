Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab1DFTIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 15:08:16 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48270 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756566Ab1DFTIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 15:08:12 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Cc: Chris Ball <cjb@laptop.org>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v2 04/12] mmc: add member in mmc queue struct to hold request data
Date: Wed,  6 Apr 2011 21:07:05 +0200
Message-Id: <1302116833-24540-5-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302116833-24540-1-git-send-email-per.forlin@linaro.org>
References: <1302116833-24540-1-git-send-email-per.forlin@linaro.org>
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
 drivers/mmc/card/block.c |  105 +++++++++++++++++--------------------
 drivers/mmc/card/queue.c |  129 ++++++++++++++++++++++++----------------------
 drivers/mmc/card/queue.h |   30 ++++++++---
 3 files changed, 138 insertions(+), 126 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 61d233a..ec4e432 100644
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
@@ -335,7 +328,7 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 {
 	struct mmc_blk_data *md = mq->data;
 	struct mmc_card *card = md->queue.card;
-	struct mmc_blk_request brq;
+	struct mmc_blk_request *brq = &mq->mqrq_cur->brq;
 	int ret = 1, disable_multi = 0;
 
 	mmc_claim_host(card->host);
@@ -344,72 +337,72 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 		struct mmc_command cmd;
 		u32 readcmd, writecmd, status = 0;
 
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
 
-		if (brq.data.blocks > 1) {
+		if (brq->data.blocks > 1) {
 			/* SPI multiblock writes terminate using a special
 			 * token, not a STOP_TRANSMISSION request.
 			 */
 			if (!mmc_host_is_spi(card->host)
 					|| rq_data_dir(req) == READ)
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
@@ -417,22 +410,22 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
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
 		 * Check for errors here, but don't jump to cmd_err
 		 * until later as we need to wait for the card to leave
 		 * programming mode even when things go wrong.
 		 */
-		if (brq.cmd.error || brq.data.error || brq.stop.error) {
-			if (brq.data.blocks > 1 && rq_data_dir(req) == READ) {
+		if (brq->cmd.error || brq->data.error || brq->stop.error) {
+			if (brq->data.blocks > 1 && rq_data_dir(req) == READ) {
 				/* Redo read one sector at a time */
 				printk(KERN_WARNING "%s: retrying using single "
 				       "block read\n", req->rq_disk->disk_name);
@@ -442,29 +435,29 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 			status = get_card_status(card, req);
 		}
 
-		if (brq.cmd.error) {
+		if (brq->cmd.error) {
 			printk(KERN_ERR "%s: error %d sending read/write "
 			       "command, response %#x, card status %#x\n",
-			       req->rq_disk->disk_name, brq.cmd.error,
-			       brq.cmd.resp[0], status);
+			       req->rq_disk->disk_name, brq->cmd.error,
+			       brq->cmd.resp[0], status);
 		}
 
-		if (brq.data.error) {
-			if (brq.data.error == -ETIMEDOUT && brq.mrq.stop)
+		if (brq->data.error) {
+			if (brq->data.error == -ETIMEDOUT && brq->mrq.stop)
 				/* 'Stop' response contains card status */
-				status = brq.mrq.stop->resp[0];
+				status = brq->mrq.stop->resp[0];
 			printk(KERN_ERR "%s: error %d transferring data,"
 			       " sector %u, nr %u, card status %#x\n",
-			       req->rq_disk->disk_name, brq.data.error,
+			       req->rq_disk->disk_name, brq->data.error,
 			       (unsigned)blk_rq_pos(req),
 			       (unsigned)blk_rq_sectors(req), status);
 		}
 
-		if (brq.stop.error) {
+		if (brq->stop.error) {
 			printk(KERN_ERR "%s: error %d sending stop command, "
 			       "response %#x, card status %#x\n",
-			       req->rq_disk->disk_name, brq.stop.error,
-			       brq.stop.resp[0], status);
+			       req->rq_disk->disk_name, brq->stop.error,
+			       brq->stop.resp[0], status);
 		}
 
 		if (!mmc_host_is_spi(card->host) && rq_data_dir(req) != READ) {
@@ -497,7 +490,7 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 #endif
 		}
 
-		if (brq.cmd.error || brq.stop.error || brq.data.error) {
+		if (brq->cmd.error || brq->stop.error || brq->data.error) {
 			if (rq_data_dir(req) == READ) {
 				/*
 				 * After an error, we redo I/O one sector at a
@@ -505,7 +498,7 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 				 * read a single sector.
 				 */
 				spin_lock_irq(&md->lock);
-				ret = __blk_end_request(req, -EIO, brq.data.blksz);
+				ret = __blk_end_request(req, -EIO, brq->data.blksz);
 				spin_unlock_irq(&md->lock);
 				continue;
 			}
@@ -516,7 +509,7 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 		 * A block was successfully transferred.
 		 */
 		spin_lock_irq(&md->lock);
-		ret = __blk_end_request(req, 0, brq.data.bytes_xfered);
+		ret = __blk_end_request(req, 0, brq->data.bytes_xfered);
 		spin_unlock_irq(&md->lock);
 	} while (ret);
 
@@ -544,7 +537,7 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 		}
 	} else {
 		spin_lock_irq(&md->lock);
-		ret = __blk_end_request(req, 0, brq.data.bytes_xfered);
+		ret = __blk_end_request(req, 0, brq->data.bytes_xfered);
 		spin_unlock_irq(&md->lock);
 	}
 
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 2ae7275..40e18b5 100644
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
@@ -114,6 +129,7 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 	struct mmc_host *host = card->host;
 	u64 limit = BLK_BOUNCE_HIGH;
 	int ret;
+	struct mmc_queue_req *mqrq_cur = &mq->mqrq[0];
 
 	if (mmc_dev(host)->dma_mask && *mmc_dev(host)->dma_mask)
 		limit = *mmc_dev(host)->dma_mask;
@@ -123,8 +139,9 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 	if (!mq->queue)
 		return -ENOMEM;
 
+	memset(&mq->mqrq_cur, 0, sizeof(mq->mqrq_cur));
+	mq->mqrq_cur = mqrq_cur;
 	mq->queue->queuedata = mq;
-	mq->req = NULL;
 
 	blk_queue_prep_rq(mq->queue, mmc_prep_request);
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, mq->queue);
@@ -158,53 +175,44 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
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
@@ -219,16 +227,15 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 
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
@@ -237,6 +244,7 @@ void mmc_cleanup_queue(struct mmc_queue *mq)
 {
 	struct request_queue *q = mq->queue;
 	unsigned long flags;
+	struct mmc_queue_req *mqrq_cur = mq->mqrq_cur;
 
 	/* Make sure the queue isn't suspended, as that will deadlock */
 	mmc_queue_resume(mq);
@@ -250,16 +258,14 @@ void mmc_cleanup_queue(struct mmc_queue *mq)
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
@@ -312,27 +318,27 @@ void mmc_queue_resume(struct mmc_queue *mq)
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
@@ -341,19 +347,19 @@ unsigned int mmc_queue_map_sg(struct mmc_queue *mq)
  * If writing, bounce the data to the buffer before the request
  * is sent to the host driver
  */
-void mmc_queue_bounce_pre(struct mmc_queue *mq)
+void mmc_queue_bounce_pre(struct mmc_queue_req *mqrq)
 {
 	unsigned long flags;
 
-	if (!mq->bounce_buf)
+	if (!mqrq->bounce_buf)
 		return;
 
-	if (rq_data_dir(mq->req) != WRITE)
+	if (rq_data_dir(mqrq->req) != WRITE)
 		return;
 
 	local_irq_save(flags);
-	sg_copy_to_buffer(mq->bounce_sg, mq->bounce_sg_len,
-		mq->bounce_buf, mq->sg[0].length);
+	sg_copy_to_buffer(mqrq->bounce_sg, mqrq->bounce_sg_len,
+		mqrq->bounce_buf, mqrq->sg[0].length);
 	local_irq_restore(flags);
 }
 
@@ -361,19 +367,18 @@ void mmc_queue_bounce_pre(struct mmc_queue *mq)
  * If reading, bounce the data from the buffer after the request
  * has been handled by the host driver
  */
-void mmc_queue_bounce_post(struct mmc_queue *mq)
+void mmc_queue_bounce_post(struct mmc_queue_req *mqrq)
 {
 	unsigned long flags;
 
-	if (!mq->bounce_buf)
+	if (!mqrq->bounce_buf)
 		return;
 
-	if (rq_data_dir(mq->req) != READ)
+	if (rq_data_dir(mqrq->req) != READ)
 		return;
 
 	local_irq_save(flags);
-	sg_copy_from_buffer(mq->bounce_sg, mq->bounce_sg_len,
-		mq->bounce_buf, mq->sg[0].length);
+	sg_copy_from_buffer(mqrq->bounce_sg, mqrq->bounce_sg_len,
+		mqrq->bounce_buf, mqrq->sg[0].length);
 	local_irq_restore(flags);
 }
-
diff --git a/drivers/mmc/card/queue.h b/drivers/mmc/card/queue.h
index 64e66e0..468044f 100644
--- a/drivers/mmc/card/queue.h
+++ b/drivers/mmc/card/queue.h
@@ -4,19 +4,32 @@
 struct request;
 struct task_struct;
 
+struct mmc_blk_request {
+	struct mmc_request	mrq;
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
 
 extern int mmc_init_queue(struct mmc_queue *, struct mmc_card *, spinlock_t *);
@@ -24,8 +37,9 @@ extern void mmc_cleanup_queue(struct mmc_queue *);
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

