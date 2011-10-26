Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348Ab1JZBu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 21:50:27 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:55101 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191Ab1JZBtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 21:49:04 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/13] block, cfq: fix race condition in cic creation path and tighten locking
Date: Tue, 25 Oct 2011 18:48:34 -0700
Message-Id: <1319593719-19132-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1319593719-19132-1-git-send-email-tj@kernel.org>
References: <1319593719-19132-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cfq_get_io_context() would fail if multiple tasks race to insert cic's
for the same association.  This patch restructures
cfq_get_io_context() such that slow path insertion race is handled
properly.

Note that the restructuring also makes cfq_get_io_context() called
under queue_lock and performs both ioc and cfqd insertions while
holding both ioc and queue locks.  This is part of on-going locking
tightening and will be used to simplify synchronization rules.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/cfq-iosched.c |  135 ++++++++++++++++++++++++++++----------------------
 1 files changed, 76 insertions(+), 59 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 51aece2..181a63d 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2908,13 +2908,10 @@ static void changed_ioprio(struct cfq_io_context *cic)
 {
 	struct cfq_data *cfqd = cic_to_cfqd(cic);
 	struct cfq_queue *cfqq;
-	unsigned long flags;
 
 	if (unlikely(!cfqd))
 		return;
 
-	spin_lock_irqsave(cfqd->queue->queue_lock, flags);
-
 	cfqq = cic->cfqq[BLK_RW_ASYNC];
 	if (cfqq) {
 		struct cfq_queue *new_cfqq;
@@ -2929,8 +2926,6 @@ static void changed_ioprio(struct cfq_io_context *cic)
 	cfqq = cic->cfqq[BLK_RW_SYNC];
 	if (cfqq)
 		cfq_mark_cfqq_prio_changed(cfqq);
-
-	spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
 }
 
 static void cfq_init_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
@@ -2958,7 +2953,6 @@ static void changed_cgroup(struct cfq_io_context *cic)
 {
 	struct cfq_queue *sync_cfqq = cic_to_cfqq(cic, 1);
 	struct cfq_data *cfqd = cic_to_cfqd(cic);
-	unsigned long flags;
 	struct request_queue *q;
 
 	if (unlikely(!cfqd))
@@ -2966,8 +2960,6 @@ static void changed_cgroup(struct cfq_io_context *cic)
 
 	q = cfqd->queue;
 
-	spin_lock_irqsave(q->queue_lock, flags);
-
 	if (sync_cfqq) {
 		/*
 		 * Drop reference to sync queue. A new sync queue will be
@@ -2977,8 +2969,6 @@ static void changed_cgroup(struct cfq_io_context *cic)
 		cic_set_cfqq(cic, NULL, 1);
 		cfq_put_queue(sync_cfqq);
 	}
-
-	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 #endif  /* CONFIG_CFQ_GROUP_IOSCHED */
 
@@ -3142,16 +3132,31 @@ cfq_cic_lookup(struct cfq_data *cfqd, struct io_context *ioc)
 	return cic;
 }
 
-/*
- * Add cic into ioc, using cfqd as the search key. This enables us to lookup
- * the process specific cfq io context when entered from the block layer.
- * Also adds the cic to a per-cfqd list, used when this queue is removed.
+/**
+ * cfq_create_cic - create and link a cfq_io_context
+ * @cfqd: cfqd of interest
+ * @gfp_mask: allocation mask
+ *
+ * Make sure cfq_io_context linking %current->io_context and @cfqd exists.
+ * If ioc and/or cic doesn't exist, they will be created using @gfp_mask.
  */
-static int cfq_cic_link(struct cfq_data *cfqd, struct io_context *ioc,
-			struct cfq_io_context *cic, gfp_t gfp_mask)
+static int cfq_create_cic(struct cfq_data *cfqd, gfp_t gfp_mask)
 {
-	unsigned long flags;
-	int ret;
+	struct request_queue *q = cfqd->queue;
+	struct cfq_io_context *cic = NULL;
+	struct io_context *ioc;
+	int ret = -ENOMEM;
+
+	might_sleep_if(gfp_mask & __GFP_WAIT);
+
+	/* allocate stuff */
+	ioc = current_io_context(gfp_mask, q->node);
+	if (!ioc)
+		goto out;
+
+	cic = cfq_alloc_io_context(cfqd, gfp_mask);
+	if (!cic)
+		goto out;
 
 	ret = radix_tree_preload(gfp_mask);
 	if (ret)
@@ -3161,53 +3166,72 @@ static int cfq_cic_link(struct cfq_data *cfqd, struct io_context *ioc,
 	cic->key = cfqd;
 	cic->q = cfqd->queue;
 
-	spin_lock_irqsave(&ioc->lock, flags);
-	ret = radix_tree_insert(&ioc->radix_root, cfqd->queue->id, cic);
-	if (!ret)
-		hlist_add_head_rcu(&cic->cic_list, &ioc->cic_list);
-	spin_unlock_irqrestore(&ioc->lock, flags);
-
-	radix_tree_preload_end();
+	/* lock both q and ioc and try to link @cic */
+	spin_lock_irq(q->queue_lock);
+	spin_lock(&ioc->lock);
 
-	if (!ret) {
-		spin_lock_irqsave(cfqd->queue->queue_lock, flags);
+	ret = radix_tree_insert(&ioc->radix_root, q->id, cic);
+	if (likely(!ret)) {
+		hlist_add_head_rcu(&cic->cic_list, &ioc->cic_list);
 		list_add(&cic->queue_list, &cfqd->cic_list);
-		spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
+		cic = NULL;
+	} else if (ret == -EEXIST) {
+		/* someone else already did it */
+		ret = 0;
 	}
+
+	spin_unlock(&ioc->lock);
+	spin_unlock_irq(q->queue_lock);
+
+	radix_tree_preload_end();
 out:
 	if (ret)
 		printk(KERN_ERR "cfq: cic link failed!\n");
+	if (cic)
+		cfq_cic_free(cic);
 	return ret;
 }
 
-/*
- * Setup general io context and cfq io context. There can be several cfq
- * io contexts per general io context, if this process is doing io to more
- * than one device managed by cfq.
+/**
+ * cfq_get_io_context - acquire cfq_io_context and bump refcnt on io_context
+ * @cfqd: cfqd to setup cic for
+ * @gfp_mask: allocation mask
+ *
+ * Return cfq_io_context associating @cfqd and %current->io_context and
+ * bump refcnt on io_context.  If ioc or cic doesn't exist, they're created
+ * using @gfp_mask.
+ *
+ * Must be called under queue_lock which may be released and re-acquired.
+ * This function also may sleep depending on @gfp_mask.
  */
 static struct cfq_io_context *
 cfq_get_io_context(struct cfq_data *cfqd, gfp_t gfp_mask)
 {
-	struct io_context *ioc = NULL;
+	struct request_queue *q = cfqd->queue;
 	struct cfq_io_context *cic = NULL;
+	struct io_context *ioc;
+	int err;
+
+	lockdep_assert_held(q->queue_lock);
+
+	while (true) {
+		/* fast path */
+		ioc = current->io_context;
+		if (likely(ioc)) {
+			cic = cfq_cic_lookup(cfqd, ioc);
+			if (likely(cic))
+				break;
+		}
 
-	might_sleep_if(gfp_mask & __GFP_WAIT);
-
-	ioc = current_io_context(gfp_mask, cfqd->queue->node);
-	if (!ioc)
-		goto err;
-
-	cic = cfq_cic_lookup(cfqd, ioc);
-	if (cic)
-		goto out;
-
-	cic = cfq_alloc_io_context(cfqd, gfp_mask);
-	if (cic == NULL)
-		goto err;
+		/* slow path - unlock, create missing ones and retry */
+		spin_unlock_irq(q->queue_lock);
+		err = cfq_create_cic(cfqd, gfp_mask);
+		spin_lock_irq(q->queue_lock);
+		if (err)
+			return NULL;
+	}
 
-	if (cfq_cic_link(cfqd, ioc, cic, gfp_mask))
-		goto err;
-out:
+	/* bump @ioc's refcnt and handle changed notifications */
 	get_io_context(ioc);
 
 	if (unlikely(cic->changed)) {
@@ -3220,10 +3244,6 @@ out:
 	}
 
 	return cic;
-err:
-	if (cic)
-		cfq_cic_free(cic);
-	return NULL;
 }
 
 static void
@@ -3759,14 +3779,11 @@ cfq_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
 	const int rw = rq_data_dir(rq);
 	const bool is_sync = rq_is_sync(rq);
 	struct cfq_queue *cfqq;
-	unsigned long flags;
 
 	might_sleep_if(gfp_mask & __GFP_WAIT);
 
+	spin_lock_irq(q->queue_lock);
 	cic = cfq_get_io_context(cfqd, gfp_mask);
-
-	spin_lock_irqsave(q->queue_lock, flags);
-
 	if (!cic)
 		goto queue_fail;
 
@@ -3802,12 +3819,12 @@ new_queue:
 	rq->elevator_private[0] = cic;
 	rq->elevator_private[1] = cfqq;
 	rq->elevator_private[2] = cfq_ref_get_cfqg(cfqq->cfqg);
-	spin_unlock_irqrestore(q->queue_lock, flags);
+	spin_unlock_irq(q->queue_lock);
 	return 0;
 
 queue_fail:
 	cfq_schedule_dispatch(cfqd);
-	spin_unlock_irqrestore(q->queue_lock, flags);
+	spin_unlock_irq(q->queue_lock);
 	cfq_log(cfqd, "set_request fail");
 	return 1;
 }
-- 
1.7.3.1

