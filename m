Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab1ALSPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 13:15:13 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57333 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417Ab1ALSPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 13:15:08 -0500
From: Per Forlin <per.forlin@linaro.org>
To: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@lists.linaro.org
Cc: Chris Ball <cjb@laptop.org>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH 1/5] mmc: add member in mmc queue struct to hold request data
Date: Wed, 12 Jan 2011 19:13:59 +0100
Message-Id: <1294856043-13447-2-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1294856043-13447-1-git-send-email-per.forlin@linaro.org>
References: <1294856043-13447-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The way the request data is organized in the mmc queue struct
it only allows processing of one request at the time.
This patch adds a new struct to hold mmc queue request data such as
sg list, request and bounce buffers, and update functions depending on
the mmc queue struct. This lies the ground for
using multiple active request for one mmc queue.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 drivers/mmc/card/block.c |    8 ++--
 drivers/mmc/card/queue.c |  129 ++++++++++++++++++++++++----------------------
 drivers/mmc/card/queue.h |   22 +++++---
 3 files changed, 85 insertions(+), 74 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 217f820..be51bde 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -398,8 +398,8 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 
 		mmc_set_data_timeout(&brq.data, card);
 
-		brq.data.sg = mq->sg;
-		brq.data.sg_len = mmc_queue_map_sg(mq);
+		brq.data.sg = mq->mqrq_cur->sg;
+		brq.data.sg_len = mmc_queue_map_sg(mq, mq->mqrq_cur);
 
 		/*
 		 * Adjust the sg list so it is the same size as the
@@ -420,11 +420,11 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 			brq.data.sg_len = i;
 		}
 
-		mmc_queue_bounce_pre(mq);
+		mmc_queue_bounce_pre(mq->mqrq_cur);
 
 		mmc_wait_for_req(card->host, &brq.mrq);
 
-		mmc_queue_bounce_post(mq);
+		mmc_queue_bounce_post(mq->mqrq_cur);
 
 		/*
 		 * Check for errors here, but don't jump to cmd_err
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 4e42d03..8a8d88b 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -57,7 +57,7 @@ static int mmc_queue_thread(void *d)
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (!blk_queue_plugged(q))
 			req = blk_fetch_request(q);
-		mq->req = req;
+		mq->mqrq_cur->req = req;
 		spin_unlock_irq(q->queue_lock);
 
 		if (!req) {
@@ -98,10 +98,25 @@ static void mmc_request(struct request_queue *q)
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
@@ -115,6 +130,7 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 	struct mmc_host *host = card->host;
 	u64 limit = BLK_BOUNCE_HIGH;
 	int ret;
+	struct mmc_queue_req *mqrq_cur = &mq->mqrq[0];
 
 	if (mmc_dev(host)->dma_mask && *mmc_dev(host)->dma_mask)
 		limit = *mmc_dev(host)->dma_mask;
@@ -124,8 +140,9 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 	if (!mq->queue)
 		return -ENOMEM;
 
+	memset(&mq->mqrq_cur, 0, sizeof(mq->mqrq_cur));
+	mq->mqrq_cur = mqrq_cur;
 	mq->queue->queuedata = mq;
-	mq->req = NULL;
 
 	blk_queue_prep_rq(mq->queue, mmc_prep_request);
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, mq->queue);
@@ -159,53 +176,44 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
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
@@ -220,16 +228,15 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 
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
@@ -238,6 +245,7 @@ void mmc_cleanup_queue(struct mmc_queue *mq)
 {
 	struct request_queue *q = mq->queue;
 	unsigned long flags;
+	struct mmc_queue_req *mqrq_cur = mq->mqrq_cur;
 
 	/* Make sure the queue isn't suspended, as that will deadlock */
 	mmc_queue_resume(mq);
@@ -251,16 +259,14 @@ void mmc_cleanup_queue(struct mmc_queue *mq)
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
@@ -313,27 +319,27 @@ void mmc_queue_resume(struct mmc_queue *mq)
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
@@ -342,19 +348,19 @@ unsigned int mmc_queue_map_sg(struct mmc_queue *mq)
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
 
@@ -362,19 +368,18 @@ void mmc_queue_bounce_pre(struct mmc_queue *mq)
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
index 64e66e0..96c440d 100644
--- a/drivers/mmc/card/queue.h
+++ b/drivers/mmc/card/queue.h
@@ -4,19 +4,24 @@
 struct request;
 struct task_struct;
 
+struct mmc_queue_req {
+	struct request		*req;
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
@@ -24,8 +29,9 @@ extern void mmc_cleanup_queue(struct mmc_queue *);
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
1.7.1

