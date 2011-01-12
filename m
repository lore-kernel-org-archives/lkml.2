Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab1ALSPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 13:15:19 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57333 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537Ab1ALSPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 13:15:15 -0500
From: Per Forlin <per.forlin@linaro.org>
To: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@lists.linaro.org
Cc: Chris Ball <cjb@laptop.org>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH 3/5] mmc: Add a second mmc queue request member
Date: Wed, 12 Jan 2011 19:14:01 +0100
Message-Id: <1294856043-13447-4-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1294856043-13447-1-git-send-email-per.forlin@linaro.org>
References: <1294856043-13447-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an additional mmc queue request instance to make way for
double buffering. One request may be active while the
other request is being prepared.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 drivers/mmc/card/queue.c |   44 ++++++++++++++++++++++++++++++++++++++++++--
 drivers/mmc/card/queue.h |    4 +++-
 2 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 8a8d88b..30d4707 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -131,6 +131,7 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 	u64 limit = BLK_BOUNCE_HIGH;
 	int ret;
 	struct mmc_queue_req *mqrq_cur = &mq->mqrq[0];
+	struct mmc_queue_req *mqrq_prev = &mq->mqrq[1];
 
 	if (mmc_dev(host)->dma_mask && *mmc_dev(host)->dma_mask)
 		limit = *mmc_dev(host)->dma_mask;
@@ -141,7 +142,9 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 		return -ENOMEM;
 
 	memset(&mq->mqrq_cur, 0, sizeof(mq->mqrq_cur));
+	memset(&mq->mqrq_prev, 0, sizeof(mq->mqrq_prev));
 	mq->mqrq_cur = mqrq_cur;
+	mq->mqrq_prev = mqrq_prev;
 	mq->queue->queuedata = mq;
 
 	blk_queue_prep_rq(mq->queue, mmc_prep_request);
@@ -182,9 +185,17 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 					"allocate bounce cur buffer\n",
 					mmc_card_name(card));
 			}
+			mqrq_prev->bounce_buf = kmalloc(bouncesz, GFP_KERNEL);
+			if (!mqrq_prev->bounce_buf) {
+				printk(KERN_WARNING "%s: unable to "
+					"allocate bounce prev buffer\n",
+					mmc_card_name(card));
+				kfree(mqrq_cur->bounce_buf);
+				mqrq_cur->bounce_buf = NULL;
+			}
 		}
 
-		if (mqrq_cur->bounce_buf) {
+		if (mqrq_cur->bounce_buf && mqrq_prev->bounce_buf) {
 			blk_queue_bounce_limit(mq->queue, BLK_BOUNCE_ANY);
 			blk_queue_max_hw_sectors(mq->queue, bouncesz / 512);
 			blk_queue_max_segments(mq->queue, bouncesz / 512);
@@ -199,11 +210,19 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 			if (ret)
 				goto cleanup_queue;
 
+			mqrq_prev->sg = mmc_alloc_sg(1, &ret);
+			if (ret)
+				goto cleanup_queue;
+
+			mqrq_prev->bounce_sg =
+				mmc_alloc_sg(bouncesz / 512, &ret);
+			if (ret)
+				goto cleanup_queue;
 		}
 	}
 #endif
 
-	if (!mqrq_cur->bounce_buf) {
+	if (!mqrq_cur->bounce_buf && !mqrq_prev->bounce_buf) {
 		blk_queue_bounce_limit(mq->queue, limit);
 		blk_queue_max_hw_sectors(mq->queue,
 			min(host->max_blk_count, host->max_req_size / 512));
@@ -214,6 +233,10 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 		if (ret)
 			goto cleanup_queue;
 
+
+		mqrq_prev->sg = mmc_alloc_sg(host->max_segs, &ret);
+		if (ret)
+			goto cleanup_queue;
 	}
 
 	sema_init(&mq->thread_sem, 1);
@@ -230,6 +253,8 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
  free_bounce_sg:
 	kfree(mqrq_cur->bounce_sg);
 	mqrq_cur->bounce_sg = NULL;
+	kfree(mqrq_prev->bounce_sg);
+	mqrq_prev->bounce_sg = NULL;
 
  cleanup_queue:
 	kfree(mqrq_cur->sg);
@@ -237,6 +262,11 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 	kfree(mqrq_cur->bounce_buf);
 	mqrq_cur->bounce_buf = NULL;
 
+	kfree(mqrq_prev->sg);
+	mqrq_prev->sg = NULL;
+	kfree(mqrq_prev->bounce_buf);
+	mqrq_prev->bounce_buf = NULL;
+
 	blk_cleanup_queue(mq->queue);
 	return ret;
 }
@@ -246,6 +276,7 @@ void mmc_cleanup_queue(struct mmc_queue *mq)
 	struct request_queue *q = mq->queue;
 	unsigned long flags;
 	struct mmc_queue_req *mqrq_cur = mq->mqrq_cur;
+	struct mmc_queue_req *mqrq_prev = mq->mqrq_prev;
 
 	/* Make sure the queue isn't suspended, as that will deadlock */
 	mmc_queue_resume(mq);
@@ -268,6 +299,15 @@ void mmc_cleanup_queue(struct mmc_queue *mq)
 	kfree(mqrq_cur->bounce_buf);
 	mqrq_cur->bounce_buf = NULL;
 
+	kfree(mqrq_prev->bounce_sg);
+	mqrq_prev->bounce_sg = NULL;
+
+	kfree(mqrq_prev->sg);
+	mqrq_prev->sg = NULL;
+
+	kfree(mqrq_prev->bounce_buf);
+	mqrq_prev->bounce_buf = NULL;
+
 	mq->card = NULL;
 }
 EXPORT_SYMBOL(mmc_cleanup_queue);
diff --git a/drivers/mmc/card/queue.h b/drivers/mmc/card/queue.h
index 96c440d..f65eb88 100644
--- a/drivers/mmc/card/queue.h
+++ b/drivers/mmc/card/queue.h
@@ -20,8 +20,10 @@ struct mmc_queue {
 	int			(*issue_fn)(struct mmc_queue *, struct request *);
 	void			*data;
 	struct request_queue	*queue;
-	struct mmc_queue_req	mqrq[1];
+
+	struct mmc_queue_req	mqrq[2];
 	struct mmc_queue_req	*mqrq_cur;
+	struct mmc_queue_req	*mqrq_prev;
 };
 
 extern int mmc_init_queue(struct mmc_queue *, struct mmc_card *, spinlock_t *);
-- 
1.7.1

