Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298Ab1JZBvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 21:51:38 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:55101 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363Ab1JZBsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 21:48:51 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/13] block, cfq: move cfqd->cic_index to q->id
Date: Tue, 25 Oct 2011 18:48:28 -0700
Message-Id: <1319593719-19132-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1319593719-19132-1-git-send-email-tj@kernel.org>
References: <1319593719-19132-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cfq allocates per-queue id using ida and uses it to index cic radix
tree from io_context.  Move it to q->id and allocate on queue init and
free on queue release.  This simplifies cfq a bit and will allow for
further improvements of io context life-cycle management.

This patch doesn't introduce any functional difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-core.c       |   24 ++++++++++++++-------
 block/blk-sysfs.c      |    2 +
 block/blk.h            |    3 ++
 block/cfq-iosched.c    |   52 ++++-------------------------------------------
 include/linux/blkdev.h |    6 +++++
 5 files changed, 32 insertions(+), 55 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 8267409..d7304d8 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -39,6 +39,8 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_remap);
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_rq_remap);
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_complete);
 
+DEFINE_IDA(blk_queue_ida);
+
 /*
  * For the allocated request tables
  */
@@ -469,6 +471,10 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	if (!q)
 		return NULL;
 
+	q->id = ida_simple_get(&blk_queue_ida, 0, 0, GFP_KERNEL);
+	if (q->id < 0)
+		goto fail_q;
+
 	q->backing_dev_info.ra_pages =
 			(VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
 	q->backing_dev_info.state = 0;
@@ -476,15 +482,11 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	q->backing_dev_info.name = "block";
 
 	err = bdi_init(&q->backing_dev_info);
-	if (err) {
-		kmem_cache_free(blk_requestq_cachep, q);
-		return NULL;
-	}
+	if (err)
+		goto fail_id;
 
-	if (blk_throtl_init(q)) {
-		kmem_cache_free(blk_requestq_cachep, q);
-		return NULL;
-	}
+	if (blk_throtl_init(q))
+		goto fail_id;
 
 	setup_timer(&q->backing_dev_info.laptop_mode_wb_timer,
 		    laptop_mode_timer_fn, (unsigned long) q);
@@ -507,6 +509,12 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	q->queue_lock = &q->__queue_lock;
 
 	return q;
+
+fail_id:
+	ida_simple_remove(&blk_queue_ida, q->id);
+fail_q:
+	kmem_cache_free(blk_requestq_cachep, q);
+	return NULL;
 }
 EXPORT_SYMBOL(blk_alloc_queue_node);
 
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index f0b2ca8..5b4b4ab 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -494,6 +494,8 @@ static void blk_release_queue(struct kobject *kobj)
 	blk_trace_shutdown(q);
 
 	bdi_destroy(&q->backing_dev_info);
+
+	ida_simple_remove(&blk_queue_ida, q->id);
 	kmem_cache_free(blk_requestq_cachep, q);
 }
 
diff --git a/block/blk.h b/block/blk.h
index f8c797c..1a97609 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -1,6 +1,8 @@
 #ifndef BLK_INTERNAL_H
 #define BLK_INTERNAL_H
 
+#include <linux/idr.h>
+
 /* Amount of time in which a process may batch requests */
 #define BLK_BATCH_TIME	(HZ/50UL)
 
@@ -9,6 +11,7 @@
 
 extern struct kmem_cache *blk_requestq_cachep;
 extern struct kobj_type blk_queue_ktype;
+extern struct ida blk_queue_ida;
 
 void init_request_from_bio(struct request *req, struct bio *bio);
 void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 16ace89..ec3f5e8b 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -65,9 +65,6 @@ static DEFINE_PER_CPU(unsigned long, cfq_ioc_count);
 static struct completion *ioc_gone;
 static DEFINE_SPINLOCK(ioc_gone_lock);
 
-static DEFINE_SPINLOCK(cic_index_lock);
-static DEFINE_IDA(cic_index_ida);
-
 #define CFQ_PRIO_LISTS		IOPRIO_BE_NR
 #define cfq_class_idle(cfqq)	((cfqq)->ioprio_class == IOPRIO_CLASS_IDLE)
 #define cfq_class_rt(cfqq)	((cfqq)->ioprio_class == IOPRIO_CLASS_RT)
@@ -290,7 +287,6 @@ struct cfq_data {
 	unsigned int cfq_group_idle;
 	unsigned int cfq_latency;
 
-	unsigned int cic_index;
 	struct list_head cic_list;
 
 	/*
@@ -484,7 +480,7 @@ static inline void cic_set_cfqq(struct cfq_io_context *cic,
 
 static inline void *cfqd_dead_key(struct cfq_data *cfqd)
 {
-	return (void *)(cfqd->cic_index << CIC_DEAD_INDEX_SHIFT | CIC_DEAD_KEY);
+	return (void *)(cfqd->queue->id << CIC_DEAD_INDEX_SHIFT | CIC_DEAD_KEY);
 }
 
 static inline struct cfq_data *cic_to_cfqd(struct cfq_io_context *cic)
@@ -3105,7 +3101,7 @@ cfq_drop_dead_cic(struct cfq_data *cfqd, struct io_context *ioc,
 	BUG_ON(rcu_dereference_check(ioc->ioc_data,
 		lockdep_is_held(&ioc->lock)) == cic);
 
-	radix_tree_delete(&ioc->radix_root, cfqd->cic_index);
+	radix_tree_delete(&ioc->radix_root, cfqd->queue->id);
 	hlist_del_rcu(&cic->cic_list);
 	spin_unlock_irqrestore(&ioc->lock, flags);
 
@@ -3133,7 +3129,7 @@ cfq_cic_lookup(struct cfq_data *cfqd, struct io_context *ioc)
 	}
 
 	do {
-		cic = radix_tree_lookup(&ioc->radix_root, cfqd->cic_index);
+		cic = radix_tree_lookup(&ioc->radix_root, cfqd->queue->id);
 		rcu_read_unlock();
 		if (!cic)
 			break;
@@ -3169,8 +3165,7 @@ static int cfq_cic_link(struct cfq_data *cfqd, struct io_context *ioc,
 		cic->key = cfqd;
 
 		spin_lock_irqsave(&ioc->lock, flags);
-		ret = radix_tree_insert(&ioc->radix_root,
-						cfqd->cic_index, cic);
+		ret = radix_tree_insert(&ioc->radix_root, cfqd->queue->id, cic);
 		if (!ret)
 			hlist_add_head_rcu(&cic->cic_list, &ioc->cic_list);
 		spin_unlock_irqrestore(&ioc->lock, flags);
@@ -3944,10 +3939,6 @@ static void cfq_exit_queue(struct elevator_queue *e)
 
 	cfq_shutdown_timer_wq(cfqd);
 
-	spin_lock(&cic_index_lock);
-	ida_remove(&cic_index_ida, cfqd->cic_index);
-	spin_unlock(&cic_index_lock);
-
 	/*
 	 * Wait for cfqg->blkg->key accessors to exit their grace periods.
 	 * Do this wait only if there are other unlinked groups out
@@ -3969,24 +3960,6 @@ static void cfq_exit_queue(struct elevator_queue *e)
 	kfree(cfqd);
 }
 
-static int cfq_alloc_cic_index(void)
-{
-	int index, error;
-
-	do {
-		if (!ida_pre_get(&cic_index_ida, GFP_KERNEL))
-			return -ENOMEM;
-
-		spin_lock(&cic_index_lock);
-		error = ida_get_new(&cic_index_ida, &index);
-		spin_unlock(&cic_index_lock);
-		if (error && error != -EAGAIN)
-			return error;
-	} while (error);
-
-	return index;
-}
-
 static void *cfq_init_queue(struct request_queue *q)
 {
 	struct cfq_data *cfqd;
@@ -3994,23 +3967,9 @@ static void *cfq_init_queue(struct request_queue *q)
 	struct cfq_group *cfqg;
 	struct cfq_rb_root *st;
 
-	i = cfq_alloc_cic_index();
-	if (i < 0)
-		return NULL;
-
 	cfqd = kmalloc_node(sizeof(*cfqd), GFP_KERNEL | __GFP_ZERO, q->node);
-	if (!cfqd) {
-		spin_lock(&cic_index_lock);
-		ida_remove(&cic_index_ida, i);
-		spin_unlock(&cic_index_lock);
+	if (!cfqd)
 		return NULL;
-	}
-
-	/*
-	 * Don't need take queue_lock in the routine, since we are
-	 * initializing the ioscheduler, and nobody is using cfqd
-	 */
-	cfqd->cic_index = i;
 
 	/* Init root service tree */
 	cfqd->grp_service_tree = CFQ_RB_ROOT;
@@ -4294,7 +4253,6 @@ static void __exit cfq_exit(void)
 	 */
 	if (elv_ioc_count_read(cfq_ioc_count))
 		wait_for_completion(&all_gone);
-	ida_destroy(&cic_index_ida);
 	cfq_slab_kill();
 }
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6a4ab84..565a4ed 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -311,6 +311,12 @@ struct request_queue {
 	unsigned long		queue_flags;
 
 	/*
+	 * ida allocated id for this queue.  Used to index queues from
+	 * ioctx.
+	 */
+	int			id;
+
+	/*
 	 * queue needs bounce pages for pages above this limit
 	 */
 	gfp_t			bounce_gfp;
-- 
1.7.3.1

