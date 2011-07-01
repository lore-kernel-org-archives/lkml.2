Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464Ab1GAQ4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 12:56:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62813 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757391Ab1GAQ4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 12:56:50 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linaro-dev@lists.linaro.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, Venkatraman S <svenkatr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Sourav Poddar <sourav.poddar@ti.com>,
        Chris Ball <cjb@laptop.org>
Cc: Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v9 10/12] mmc: queue: add a second mmc queue request member
Date: Fri,  1 Jul 2011 18:55:31 +0200
Message-Id: <1309539333-2606-11-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309539333-2606-1-git-send-email-per.forlin@linaro.org>
References: <1309539333-2606-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an additional mmc queue request instance to make way for
two active block requests. One request may be active while the
other request is being prepared.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Venkatraman S <svenkatr@ti.com>
Tested-by: Sourav Poddar<sourav.poddar@ti.com>
Tested-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mmc/card/queue.c |   44 ++++++++++++++++++++++++++++++++++++++++++--
 drivers/mmc/card/queue.h |    3 ++-
 2 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 4222e1a..d69d954 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -132,6 +132,7 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
 	u64 limit = BLK_BOUNCE_HIGH;
 	int ret;
 	struct mmc_queue_req *mqrq_cur = &mq->mqrq[0];
+	struct mmc_queue_req *mqrq_prev = &mq->mqrq[1];
 
 	if (mmc_dev(host)->dma_mask && *mmc_dev(host)->dma_mask)
 		limit = *mmc_dev(host)->dma_mask;
@@ -142,7 +143,9 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
 		return -ENOMEM;
 
 	memset(&mq->mqrq_cur, 0, sizeof(mq->mqrq_cur));
+	memset(&mq->mqrq_prev, 0, sizeof(mq->mqrq_prev));
 	mq->mqrq_cur = mqrq_cur;
+	mq->mqrq_prev = mqrq_prev;
 	mq->queue->queuedata = mq;
 
 	blk_queue_prep_rq(mq->queue, mmc_prep_request);
@@ -178,9 +181,17 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
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
@@ -195,11 +206,19 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
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
@@ -210,6 +229,10 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
 		if (ret)
 			goto cleanup_queue;
 
+
+		mqrq_prev->sg = mmc_alloc_sg(host->max_segs, &ret);
+		if (ret)
+			goto cleanup_queue;
 	}
 
 	sema_init(&mq->thread_sem, 1);
@@ -226,6 +249,8 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
  free_bounce_sg:
 	kfree(mqrq_cur->bounce_sg);
 	mqrq_cur->bounce_sg = NULL;
+	kfree(mqrq_prev->bounce_sg);
+	mqrq_prev->bounce_sg = NULL;
 
  cleanup_queue:
 	kfree(mqrq_cur->sg);
@@ -233,6 +258,11 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
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
@@ -242,6 +272,7 @@ void mmc_cleanup_queue(struct mmc_queue *mq)
 	struct request_queue *q = mq->queue;
 	unsigned long flags;
 	struct mmc_queue_req *mqrq_cur = mq->mqrq_cur;
+	struct mmc_queue_req *mqrq_prev = mq->mqrq_prev;
 
 	/* Make sure the queue isn't suspended, as that will deadlock */
 	mmc_queue_resume(mq);
@@ -264,6 +295,15 @@ void mmc_cleanup_queue(struct mmc_queue *mq)
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
index c1a69ac..1a637d2 100644
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
 
 extern int mmc_init_queue(struct mmc_queue *, struct mmc_card *, spinlock_t *,
-- 
1.7.4.1

