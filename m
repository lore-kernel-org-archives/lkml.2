Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607Ab1FUXkN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 19:40:13 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65291 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757580Ab1FUXkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 19:40:08 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linaro-dev@lists.linaro.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, Venkatraman S <svenkatr@ti.com>
Cc: Chris Ball <cjb@laptop.org>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v7 09/11] mmc: add a second mmc queue request member
Date: Wed, 22 Jun 2011 01:38:39 +0200
Message-Id: <1308699521-20556-10-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308699521-20556-1-git-send-email-per.forlin@linaro.org>
References: <1308699521-20556-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an additional mmc queue request instance to make way for
two active block requests. One request may be active while the
other request is being prepared.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 drivers/mmc/card/queue.c |   44 ++++++++++++++++++++++++++++++++++++++++++--
 drivers/mmc/card/queue.h |    3 ++-
 2 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 81d0eef..0757a39 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -130,6 +130,7 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 	u64 limit = BLK_BOUNCE_HIGH;
 	int ret;
 	struct mmc_queue_req *mqrq_cur = &mq->mqrq[0];
+	struct mmc_queue_req *mqrq_prev = &mq->mqrq[1];
 
 	if (mmc_dev(host)->dma_mask && *mmc_dev(host)->dma_mask)
 		limit = *mmc_dev(host)->dma_mask;
@@ -140,7 +141,9 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 		return -ENOMEM;
 
 	memset(&mq->mqrq_cur, 0, sizeof(mq->mqrq_cur));
+	memset(&mq->mqrq_prev, 0, sizeof(mq->mqrq_prev));
 	mq->mqrq_cur = mqrq_cur;
+	mq->mqrq_prev = mqrq_prev;
 	mq->queue->queuedata = mq;
 
 	blk_queue_prep_rq(mq->queue, mmc_prep_request);
@@ -181,9 +184,17 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
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
@@ -198,11 +209,19 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
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
@@ -213,6 +232,10 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 		if (ret)
 			goto cleanup_queue;
 
+
+		mqrq_prev->sg = mmc_alloc_sg(host->max_segs, &ret);
+		if (ret)
+			goto cleanup_queue;
 	}
 
 	sema_init(&mq->thread_sem, 1);
@@ -229,6 +252,8 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
  free_bounce_sg:
 	kfree(mqrq_cur->bounce_sg);
 	mqrq_cur->bounce_sg = NULL;
+	kfree(mqrq_prev->bounce_sg);
+	mqrq_prev->bounce_sg = NULL;
 
  cleanup_queue:
 	kfree(mqrq_cur->sg);
@@ -236,6 +261,11 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
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
@@ -245,6 +275,7 @@ void mmc_cleanup_queue(struct mmc_queue *mq)
 	struct request_queue *q = mq->queue;
 	unsigned long flags;
 	struct mmc_queue_req *mqrq_cur = mq->mqrq_cur;
+	struct mmc_queue_req *mqrq_prev = mq->mqrq_prev;
 
 	/* Make sure the queue isn't suspended, as that will deadlock */
 	mmc_queue_resume(mq);
@@ -267,6 +298,15 @@ void mmc_cleanup_queue(struct mmc_queue *mq)
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
index a1defed..c8fb2dc 100644
--- a/drivers/mmc/card/queue.h
+++ b/drivers/mmc/card/queue.h
@@ -29,8 +29,9 @@ struct mmc_queue {
 	int			(*issue_fn)(struct mmc_queue *, struct request *);
 	void			*data;
 	struct request_queue	*queue;
-	struct mmc_queue_req	mqrq[1];
+	struct mmc_queue_req	mqrq[2];
 	struct mmc_queue_req	*mqrq_cur;
+	struct mmc_queue_req	*mqrq_prev;
 };
 
 extern int mmc_init_queue(struct mmc_queue *, struct mmc_card *, spinlock_t *);
-- 
1.7.4.1

