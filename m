Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729Ab2ADGkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 01:40:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:44339 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab2ADGkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 01:40:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="92739638"
Message-Id: <20120104065454.001785808@sli10-conroe.sh.intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 04 Jan 2012 14:53:38 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, vgoyal@redhat.com, jmoyer@redhat.com,
        Shaohua Li <shaohua.li@intel.com>
Subject: [RFC 1/3]block: seperate CFQ io context management code
References: <20120104065337.230911609@sli10-conroe.sh.intel.com>
Content-Disposition: inline; filename=separate-cfq-ioc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CFQ's io context management creates a per-device io context for each task.
It's quite generic. Separate it from CFQ, and use it for fiops I/O scheduler.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 block/blk-ioc.c           |  474 ++++++++++++++++++++++++++++++++++-
 block/blk.h               |   55 ++++
 block/cfq-iosched.c       |  614 ++++++++++------------------------------------
 include/linux/iocontext.h |   30 +-
 4 files changed, 683 insertions(+), 490 deletions(-)

Index: linux/block/blk-ioc.c
===================================================================
--- linux.orig/block/blk-ioc.c	2011-12-27 16:13:02.000000000 +0800
+++ linux/block/blk-ioc.c	2011-12-28 09:42:18.000000000 +0800
@@ -8,6 +8,7 @@
 #include <linux/blkdev.h>
 #include <linux/bootmem.h>	/* for max_pfn/max_low_pfn */
 #include <linux/slab.h>
+#include <linux/idr.h>
 
 #include "blk.h"
 
@@ -16,12 +17,12 @@
  */
 static struct kmem_cache *iocontext_cachep;
 
-static void cfq_dtor(struct io_context *ioc)
+static void queue_data_dtor(struct io_context *ioc)
 {
 	if (!hlist_empty(&ioc->cic_list)) {
-		struct cfq_io_context *cic;
+		struct dev_io_context *cic;
 
-		cic = hlist_entry(ioc->cic_list.first, struct cfq_io_context,
+		cic = hlist_entry(ioc->cic_list.first, struct dev_io_context,
 								cic_list);
 		cic->dtor(ioc);
 	}
@@ -40,7 +41,7 @@ int put_io_context(struct io_context *io
 
 	if (atomic_long_dec_and_test(&ioc->refcount)) {
 		rcu_read_lock();
-		cfq_dtor(ioc);
+		queue_data_dtor(ioc);
 		rcu_read_unlock();
 
 		kmem_cache_free(iocontext_cachep, ioc);
@@ -50,14 +51,14 @@ int put_io_context(struct io_context *io
 }
 EXPORT_SYMBOL(put_io_context);
 
-static void cfq_exit(struct io_context *ioc)
+static void queue_data_exit(struct io_context *ioc)
 {
 	rcu_read_lock();
 
 	if (!hlist_empty(&ioc->cic_list)) {
-		struct cfq_io_context *cic;
+		struct dev_io_context *cic;
 
-		cic = hlist_entry(ioc->cic_list.first, struct cfq_io_context,
+		cic = hlist_entry(ioc->cic_list.first, struct dev_io_context,
 								cic_list);
 		cic->exit(ioc);
 	}
@@ -75,7 +76,7 @@ void exit_io_context(struct task_struct
 	task_unlock(task);
 
 	if (atomic_dec_and_test(&ioc->nr_tasks))
-		cfq_exit(ioc);
+		queue_data_exit(ioc);
 
 	put_io_context(ioc);
 }
@@ -162,3 +163,460 @@ static int __init blk_ioc_init(void)
 	return 0;
 }
 subsys_initcall(blk_ioc_init);
+
+#if IS_ENABLED(CONFIG_IOSCHED_CFQ)
+#define CIC_DEAD_INDEX_SHIFT	1
+
+static inline void *queue_data_dead_key(struct queue_data *qdata)
+{
+	return (void *)(qdata->cic_index << CIC_DEAD_INDEX_SHIFT | CIC_DEAD_KEY);
+}
+
+int ioc_builder_init(struct ioc_builder *builder)
+{
+	if (!builder->alloc_ioc || !builder->free_ioc)
+		return -ENOMEM;
+
+	builder->ioc_count = alloc_percpu(unsigned long);
+	if (!builder->ioc_count)
+		return -ENOMEM;
+
+	builder->ioc_gone = NULL;
+	spin_lock_init(&builder->ioc_gone_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(ioc_builder_init);
+
+void io_context_builder_exit(struct ioc_builder *builder)
+{
+	DECLARE_COMPLETION_ONSTACK(all_gone);
+
+	builder->ioc_gone = &all_gone;
+	/* ioc_gone's update must be visible before reading ioc_count */
+	smp_wmb();
+
+	/*
+	 * this also protects us from entering cfq_slab_kill() with
+	 * pending RCU callbacks
+	 */
+	if (elv_ioc_count_read(*builder->ioc_count))
+		wait_for_completion(&all_gone);
+
+	free_percpu(builder->ioc_count);
+}
+EXPORT_SYMBOL(io_context_builder_exit);
+
+static DEFINE_SPINLOCK(cic_index_lock);
+static DEFINE_IDA(cic_index_ida);
+static int builder_alloc_cic_index(struct ioc_builder *builder)
+{
+	int index, error;
+	unsigned long flags;
+
+	do {
+		if (!ida_pre_get(&cic_index_ida, GFP_KERNEL))
+			return -ENOMEM;
+
+		spin_lock_irqsave(&cic_index_lock, flags);
+		error = ida_get_new(&cic_index_ida, &index);
+		spin_unlock_irqrestore(&cic_index_lock, flags);
+		if (error && error != -EAGAIN)
+			return error;
+	} while (error);
+
+	return index;
+}
+
+static void builder_free_cic_index(struct ioc_builder *builder, int index)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cic_index_lock, flags);
+	ida_remove(&cic_index_ida, index);
+	spin_unlock_irqrestore(&cic_index_lock, flags);
+}
+
+int ioc_builder_init_queue(struct ioc_builder *builder,
+	struct queue_data *qdata, struct request_queue *q)
+{
+	/*
+	 * Don't need take queue_lock in the routine, since we are
+	 * initializing the ioscheduler, and nobody is using qdata
+	 */
+	qdata->cic_index = builder_alloc_cic_index(builder);
+	if (qdata->cic_index < 0)
+		return -ENOMEM;
+
+	qdata->queue = q;
+	INIT_LIST_HEAD(&qdata->cic_list);
+
+	return 0;
+}
+EXPORT_SYMBOL(ioc_builder_init_queue);
+
+/*
+ * Call func for each cic attached to this ioc.
+ */
+static void
+call_for_each_cic(struct io_context *ioc,
+		  void (*func)(struct io_context *, struct dev_io_context *))
+{
+	struct dev_io_context *cic;
+	struct hlist_node *n;
+
+	rcu_read_lock();
+
+	hlist_for_each_entry_rcu(cic, n, &ioc->cic_list, cic_list)
+		func(ioc, cic);
+
+	rcu_read_unlock();
+}
+
+static void queue_data_cic_free_rcu(struct rcu_head *head)
+{
+	struct dev_io_context *cic;
+	struct ioc_builder *builder;
+
+	cic = container_of(head, struct dev_io_context, rcu_head);
+	builder = cic->builder;
+
+	builder->free_ioc(builder, cic);
+	elv_ioc_count_dec(*builder->ioc_count);
+
+	if (builder->ioc_gone) {
+		/*
+		 * CFQ scheduler is exiting, grab exit lock and check
+		 * the pending io context count. If it hits zero,
+		 * complete ioc_gone and set it back to NULL
+		 */
+		spin_lock(&builder->ioc_gone_lock);
+		if (builder->ioc_gone &&
+		    !elv_ioc_count_read(*builder->ioc_count)) {
+			complete(builder->ioc_gone);
+			builder->ioc_gone = NULL;
+		}
+		spin_unlock(&builder->ioc_gone_lock);
+	}
+}
+
+static void queue_data_cic_free(struct dev_io_context *cic)
+{
+	call_rcu(&cic->rcu_head, queue_data_cic_free_rcu);
+}
+
+static void cic_free_func(struct io_context *ioc, struct dev_io_context *cic)
+{
+	unsigned long flags;
+	unsigned long dead_key = (unsigned long) cic->key;
+
+	BUG_ON(!(dead_key & CIC_DEAD_KEY));
+
+	spin_lock_irqsave(&ioc->lock, flags);
+	radix_tree_delete(&ioc->radix_root, dead_key >> CIC_DEAD_INDEX_SHIFT);
+	hlist_del_rcu(&cic->cic_list);
+	spin_unlock_irqrestore(&ioc->lock, flags);
+
+	queue_data_cic_free(cic);
+}
+
+/*
+ * Must be called with rcu_read_lock() held or preemption otherwise disabled.
+ * Only two callers of this - ->dtor() which is called with the rcu_read_lock(),
+ * and ->trim() which is called with the task lock held
+ */
+void queue_data_free_io_context(struct io_context *ioc)
+{
+	/*
+	 * ioc->refcount is zero here, or we are called from elv_unregister(),
+	 * so no more cic's are allowed to be linked into this ioc.  So it
+	 * should be ok to iterate over the known list, we will see all cic's
+	 * since no new ones are added.
+	 */
+	call_for_each_cic(ioc, cic_free_func);
+}
+EXPORT_SYMBOL(queue_data_free_io_context);
+
+static void __queue_data_exit_single_io_context(struct queue_data *qdata,
+					 struct dev_io_context *cic)
+{
+	struct io_context *ioc = cic->ioc;
+	struct ioc_builder *builder = cic->builder;
+
+	list_del_init(&cic->queue_list);
+
+	/*
+	 * Make sure dead mark is seen for dead queues
+	 */
+	smp_wmb();
+	cic->key = queue_data_dead_key(qdata);
+
+	rcu_read_lock();
+	if (rcu_dereference(ioc->ioc_data) == cic) {
+		rcu_read_unlock();
+		spin_lock(&ioc->lock);
+		rcu_assign_pointer(ioc->ioc_data, NULL);
+		spin_unlock(&ioc->lock);
+	} else
+		rcu_read_unlock();
+
+	if (builder->cic_exit)
+		builder->cic_exit(qdata, cic);
+}
+
+/* with request_queue lock hold */
+void ioc_builder_exit_queue(struct ioc_builder *builder,
+	struct queue_data *qdata)
+{
+	while (!list_empty(&qdata->cic_list)) {
+		struct dev_io_context *cic = list_entry(qdata->cic_list.next,
+							struct dev_io_context,
+							queue_list);
+
+		__queue_data_exit_single_io_context(qdata, cic);
+	}
+
+	builder_free_cic_index(builder, qdata->cic_index);
+}
+EXPORT_SYMBOL(ioc_builder_exit_queue);
+
+static void queue_data_exit_single_io_context(struct io_context *ioc,
+				       struct dev_io_context *cic)
+{
+	struct queue_data *qdata = cic_to_queue_data(cic);
+
+	if (qdata) {
+		struct request_queue *q = qdata->queue;
+		unsigned long flags;
+
+		spin_lock_irqsave(q->queue_lock, flags);
+
+		/*
+		 * Ensure we get a fresh copy of the ->key to prevent
+		 * race between exiting task and queue
+		 */
+		smp_read_barrier_depends();
+		if (cic->key == qdata)
+			__queue_data_exit_single_io_context(qdata, cic);
+
+		spin_unlock_irqrestore(q->queue_lock, flags);
+	}
+}
+
+/*
+ * The process that ioc belongs to has exited, we need to clean up
+ * and put the internal structures we have that belongs to that process.
+ */
+static void queue_data_exit_io_context(struct io_context *ioc)
+{
+	call_for_each_cic(ioc, queue_data_exit_single_io_context);
+}
+
+static struct dev_io_context *
+queue_data_alloc_io_context(struct ioc_builder *builder,
+	struct queue_data *qdata, gfp_t gfp_mask)
+{
+	struct dev_io_context *cic;
+
+	cic = builder->alloc_ioc(builder, qdata, gfp_mask | __GFP_ZERO);
+
+	if (cic) {
+		cic->builder = builder;
+		if (builder->cic_init)
+			builder->cic_init(qdata, cic);
+		INIT_LIST_HEAD(&cic->queue_list);
+		INIT_HLIST_NODE(&cic->cic_list);
+		cic->dtor = queue_data_free_io_context;
+		cic->exit = queue_data_exit_io_context;
+		elv_ioc_count_inc(*builder->ioc_count);
+	}
+
+	return cic;
+}
+
+/*
+ * We drop dev io contexts lazily, so we may find a dead one.
+ */
+static void
+queue_data_drop_dead_cic(struct queue_data *queue_data, struct io_context *ioc,
+		  struct dev_io_context *cic)
+{
+	unsigned long flags;
+
+	WARN_ON(!list_empty(&cic->queue_list));
+	BUG_ON(cic->key != queue_data_dead_key(queue_data));
+
+	spin_lock_irqsave(&ioc->lock, flags);
+
+	BUG_ON(rcu_dereference_check(ioc->ioc_data,
+		lockdep_is_held(&ioc->lock)) == cic);
+
+	radix_tree_delete(&ioc->radix_root, queue_data->cic_index);
+	hlist_del_rcu(&cic->cic_list);
+	spin_unlock_irqrestore(&ioc->lock, flags);
+
+	queue_data_cic_free(cic);
+}
+
+struct dev_io_context *
+queue_data_cic_lookup(struct queue_data *qdata, struct io_context *ioc)
+{
+	struct dev_io_context *cic;
+	unsigned long flags;
+
+	if (unlikely(!ioc))
+		return NULL;
+
+	rcu_read_lock();
+
+	/*
+	 * we maintain a last-hit cache, to avoid browsing over the tree
+	 */
+	cic = rcu_dereference(ioc->ioc_data);
+	if (cic && cic->key == qdata) {
+		rcu_read_unlock();
+		return cic;
+	}
+
+	do {
+		cic = radix_tree_lookup(&ioc->radix_root, qdata->cic_index);
+		rcu_read_unlock();
+		if (!cic)
+			break;
+		if (unlikely(cic->key != qdata)) {
+			queue_data_drop_dead_cic(qdata, ioc, cic);
+			rcu_read_lock();
+			continue;
+		}
+
+		spin_lock_irqsave(&ioc->lock, flags);
+		rcu_assign_pointer(ioc->ioc_data, cic);
+		spin_unlock_irqrestore(&ioc->lock, flags);
+		break;
+	} while (1);
+
+	return cic;
+}
+EXPORT_SYMBOL(queue_data_cic_lookup);
+
+/*
+ * Add cic into ioc, using qdata as the search key. This enables us to lookup
+ * the process specific dev io context when entered from the block layer.
+ * Also adds the cic to a per-qdata list, used when this queue is removed.
+ */
+static int queue_data_cic_link(struct queue_data *qdata,
+	struct io_context *ioc, struct dev_io_context *cic, gfp_t gfp_mask)
+{
+	unsigned long flags;
+	int ret;
+
+	ret = radix_tree_preload(gfp_mask);
+	if (!ret) {
+		cic->ioc = ioc;
+		cic->key = qdata;
+
+		spin_lock_irqsave(&ioc->lock, flags);
+		ret = radix_tree_insert(&ioc->radix_root,
+					qdata->cic_index, cic);
+		if (!ret)
+			hlist_add_head_rcu(&cic->cic_list, &ioc->cic_list);
+		spin_unlock_irqrestore(&ioc->lock, flags);
+
+		radix_tree_preload_end();
+
+		if (!ret) {
+			spin_lock_irqsave(qdata->queue->queue_lock, flags);
+			list_add(&cic->queue_list, &qdata->cic_list);
+			spin_unlock_irqrestore(qdata->queue->queue_lock, flags);
+		}
+	}
+
+	if (ret && ret != -EEXIST)
+		printk(KERN_ERR "block: cic link failed!\n");
+
+	return ret;
+}
+
+static void changed_ioprio(struct io_context *ioc,
+	struct dev_io_context *gen_cic)
+{
+	struct ioc_builder *builder = gen_cic->builder;
+	if (builder->changed_ioprio)
+		builder->changed_ioprio(ioc, gen_cic);
+}
+
+static void queue_data_ioc_set_ioprio(struct io_context *ioc)
+{
+	call_for_each_cic(ioc, changed_ioprio);
+	ioc->ioprio_changed = 0;
+}
+
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
+static void changed_cgroup(struct io_context *ioc,
+	struct dev_io_context *gen_cic)
+{
+	struct ioc_builder *builder = gen_cic->builder;
+	if (builder->changed_cgroup)
+		builder->changed_cgroup(ioc, gen_cic);
+}
+
+static void queue_data_ioc_set_cgroup(struct io_context *ioc)
+{
+	call_for_each_cic(ioc, changed_cgroup);
+	ioc->cgroup_changed = 0;
+}
+#endif  /* CONFIG_CFQ_GROUP_IOSCHED */
+
+/*
+ * Setup general io context and dev io context. There can be several
+ * dev io contexts per general io context, if this process is doing io to more
+ * than one device managed by elevator.
+ */
+struct dev_io_context *queue_data_get_io_context(struct ioc_builder *builder,
+	struct queue_data *qdata, gfp_t gfp_mask)
+{
+	struct io_context *ioc = NULL;
+	struct dev_io_context *cic;
+	int ret;
+
+	might_sleep_if(gfp_mask & __GFP_WAIT);
+
+	ioc = get_io_context(gfp_mask, qdata->queue->node);
+	if (!ioc)
+		return NULL;
+
+retry:
+	cic = queue_data_cic_lookup(qdata, ioc);
+	if (cic)
+		goto out;
+
+	cic = queue_data_alloc_io_context(builder, qdata, gfp_mask);
+	if (cic == NULL)
+		goto err;
+
+	ret = queue_data_cic_link(qdata, ioc, cic, gfp_mask);
+	if (ret == -EEXIST) {
+		/* someone has linked cic to ioc already */
+		queue_data_cic_free(cic);
+		goto retry;
+	} else if (ret)
+		goto err_free;
+
+out:
+	smp_read_barrier_depends();
+	if (unlikely(ioc->ioprio_changed))
+		queue_data_ioc_set_ioprio(ioc);
+
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
+	if (unlikely(ioc->cgroup_changed))
+		queue_data_ioc_set_cgroup(ioc);
+#endif
+	return cic;
+err_free:
+	queue_data_cic_free(cic);
+err:
+	put_io_context(ioc);
+	return NULL;
+}
+EXPORT_SYMBOL(queue_data_get_io_context);
+#endif
Index: linux/block/blk.h
===================================================================
--- linux.orig/block/blk.h	2011-12-27 16:13:02.000000000 +0800
+++ linux/block/blk.h	2011-12-28 09:42:18.000000000 +0800
@@ -206,4 +206,59 @@ static inline void blk_throtl_exit(struc
 static inline void blk_throtl_release(struct request_queue *q) { }
 #endif /* CONFIG_BLK_DEV_THROTTLING */
 
+#if IS_ENABLED(CONFIG_IOSCHED_CFQ)
+struct queue_data;
+struct ioc_builder {
+	struct dev_io_context *(*alloc_ioc)(struct ioc_builder *builder,
+		struct queue_data *qdata, gfp_t gfp_mask);
+	void (*free_ioc)(struct ioc_builder *builder,
+		struct dev_io_context *dev_ioc);
+
+	void (*changed_ioprio)(struct io_context *ioc,
+		struct dev_io_context *cic);
+	void (*changed_cgroup)(struct io_context *ioc,
+		struct dev_io_context *cic);
+	void (*cic_exit)(struct queue_data *qdata,
+		struct dev_io_context *gen_cic);
+	void (*cic_init)(struct queue_data *qdata,
+		struct dev_io_context *gen_cic);
+
+	unsigned long __percpu *ioc_count;
+	struct completion *ioc_gone;
+	spinlock_t ioc_gone_lock;
+};
+
+struct queue_data {
+	struct request_queue *queue;
+
+	unsigned int cic_index;
+	struct list_head cic_list;
+};
+
+#define CIC_DEAD_KEY	1ul
+static inline struct queue_data *cic_to_queue_data(struct dev_io_context *cic)
+{
+	struct queue_data *qdata = cic->key;
+
+	if (unlikely((unsigned long) qdata & CIC_DEAD_KEY))
+		return NULL;
+
+	return qdata;
+}
+
+int ioc_builder_init(struct ioc_builder *builder);
+void io_context_builder_exit(struct ioc_builder *builder);
+
+int ioc_builder_init_queue(struct ioc_builder *builder,
+	struct queue_data *qdata, struct request_queue *q);
+void ioc_builder_exit_queue(struct ioc_builder *builder,
+	struct queue_data *qdata);
+
+struct dev_io_context *queue_data_get_io_context(struct ioc_builder *builder,
+	struct queue_data *qdata, gfp_t gfp_mask);
+struct dev_io_context *queue_data_cic_lookup(struct queue_data *qdata,
+	struct io_context *ioc);
+void queue_data_free_io_context(struct io_context *ioc);
+#endif
+
 #endif /* BLK_INTERNAL_H */
Index: linux/block/cfq-iosched.c
===================================================================
--- linux.orig/block/cfq-iosched.c	2011-12-27 16:13:02.000000000 +0800
+++ linux/block/cfq-iosched.c	2011-12-28 09:12:06.000000000 +0800
@@ -14,6 +14,7 @@
 #include <linux/rbtree.h>
 #include <linux/ioprio.h>
 #include <linux/blktrace_api.h>
+#include "blk.h"
 #include "cfq.h"
 
 /*
@@ -60,13 +61,7 @@ static const int cfq_hist_divisor = 4;
 
 static struct kmem_cache *cfq_pool;
 static struct kmem_cache *cfq_ioc_pool;
-
-static DEFINE_PER_CPU(unsigned long, cfq_ioc_count);
-static struct completion *ioc_gone;
-static DEFINE_SPINLOCK(ioc_gone_lock);
-
-static DEFINE_SPINLOCK(cic_index_lock);
-static DEFINE_IDA(cic_index_ida);
+static struct ioc_builder ioc_builder;
 
 #define CFQ_PRIO_LISTS		IOPRIO_BE_NR
 #define cfq_class_idle(cfqq)	((cfqq)->ioprio_class == IOPRIO_CLASS_IDLE)
@@ -220,7 +215,8 @@ struct cfq_group {
  * Per block device queue structure
  */
 struct cfq_data {
-	struct request_queue *queue;
+	struct queue_data qdata;
+
 	/* Root service tree for cfq_groups */
 	struct cfq_rb_root grp_service_tree;
 	struct cfq_group root_group;
@@ -290,9 +286,6 @@ struct cfq_data {
 	unsigned int cfq_group_idle;
 	unsigned int cfq_latency;
 
-	unsigned int cic_index;
-	struct list_head cic_list;
-
 	/*
 	 * Fallback dummy cfqq for extreme OOM conditions
 	 */
@@ -306,6 +299,10 @@ struct cfq_data {
 	/* Number of groups which are on blkcg->blkg_list */
 	unsigned int nr_blkcg_linked_grps;
 };
+#define queue_data_to_cfqd(ptr) \
+	container_of(ptr, struct cfq_data, qdata)
+#define dev_ioc_to_cfq_ioc(ptr) \
+	container_of(ptr, struct cfq_io_context, dev_ioc)
 
 static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
 
@@ -369,21 +366,21 @@ CFQ_CFQQ_FNS(wait_busy);
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 #define cfq_log_cfqq(cfqd, cfqq, fmt, args...)	\
-	blk_add_trace_msg((cfqd)->queue, "cfq%d%c %s " fmt, (cfqq)->pid, \
+	blk_add_trace_msg((cfqd)->qdata.queue, "cfq%d%c %s " fmt, (cfqq)->pid, \
 			cfq_cfqq_sync((cfqq)) ? 'S' : 'A', \
 			blkg_path(&(cfqq)->cfqg->blkg), ##args)
 
 #define cfq_log_cfqg(cfqd, cfqg, fmt, args...)				\
-	blk_add_trace_msg((cfqd)->queue, "%s " fmt,			\
+	blk_add_trace_msg((cfqd)->qdata.queue, "%s " fmt,		\
 				blkg_path(&(cfqg)->blkg), ##args)       \
 
 #else
 #define cfq_log_cfqq(cfqd, cfqq, fmt, args...)	\
-	blk_add_trace_msg((cfqd)->queue, "cfq%d " fmt, (cfqq)->pid, ##args)
+	blk_add_trace_msg((cfqd)->qdata.queue, "cfq%d " fmt, (cfqq)->pid, ##args)
 #define cfq_log_cfqg(cfqd, cfqg, fmt, args...)		do {} while (0)
 #endif
 #define cfq_log(cfqd, fmt, args...)	\
-	blk_add_trace_msg((cfqd)->queue, "cfq " fmt, ##args)
+	blk_add_trace_msg((cfqd)->qdata.queue, "cfq " fmt, ##args)
 
 /* Traverses through cfq group service trees */
 #define for_each_cfqg_st(cfqg, i, j, st) \
@@ -464,8 +461,6 @@ static inline int cfqg_busy_async_queues
 static void cfq_dispatch_insert(struct request_queue *, struct request *);
 static struct cfq_queue *cfq_get_queue(struct cfq_data *, bool,
 				       struct io_context *, gfp_t);
-static struct cfq_io_context *cfq_cic_lookup(struct cfq_data *,
-						struct io_context *);
 
 static inline struct cfq_queue *cic_to_cfqq(struct cfq_io_context *cic,
 					    bool is_sync)
@@ -479,23 +474,6 @@ static inline void cic_set_cfqq(struct c
 	cic->cfqq[is_sync] = cfqq;
 }
 
-#define CIC_DEAD_KEY	1ul
-#define CIC_DEAD_INDEX_SHIFT	1
-
-static inline void *cfqd_dead_key(struct cfq_data *cfqd)
-{
-	return (void *)(cfqd->cic_index << CIC_DEAD_INDEX_SHIFT | CIC_DEAD_KEY);
-}
-
-static inline struct cfq_data *cic_to_cfqd(struct cfq_io_context *cic)
-{
-	struct cfq_data *cfqd = cic->key;
-
-	if (unlikely((unsigned long) cfqd & CIC_DEAD_KEY))
-		return NULL;
-
-	return cfqd;
-}
 
 /*
  * We regard a request as SYNC, if it's either a read or has the SYNC bit
@@ -514,7 +492,7 @@ static inline void cfq_schedule_dispatch
 {
 	if (cfqd->busy_queues) {
 		cfq_log(cfqd, "schedule dispatch");
-		kblockd_schedule_work(cfqd->queue, &cfqd->unplug_work);
+		kblockd_schedule_work(cfqd->qdata.queue, &cfqd->unplug_work);
 	}
 }
 
@@ -1030,7 +1008,7 @@ static void cfq_update_blkio_group_weigh
 static void cfq_init_add_cfqg_lists(struct cfq_data *cfqd,
 			struct cfq_group *cfqg, struct blkio_cgroup *blkcg)
 {
-	struct backing_dev_info *bdi = &cfqd->queue->backing_dev_info;
+	struct backing_dev_info *bdi = &cfqd->qdata.queue->backing_dev_info;
 	unsigned int major, minor;
 
 	/*
@@ -1065,7 +1043,7 @@ static struct cfq_group * cfq_alloc_cfqg
 	int i, j, ret;
 	struct cfq_rb_root *st;
 
-	cfqg = kzalloc_node(sizeof(*cfqg), GFP_ATOMIC, cfqd->queue->node);
+	cfqg = kzalloc_node(sizeof(*cfqg), GFP_ATOMIC, cfqd->qdata.queue->node);
 	if (!cfqg)
 		return NULL;
 
@@ -1097,7 +1075,7 @@ cfq_find_cfqg(struct cfq_data *cfqd, str
 {
 	struct cfq_group *cfqg = NULL;
 	void *key = cfqd;
-	struct backing_dev_info *bdi = &cfqd->queue->backing_dev_info;
+	struct backing_dev_info *bdi = &cfqd->qdata.queue->backing_dev_info;
 	unsigned int major, minor;
 
 	/*
@@ -1125,7 +1103,7 @@ static struct cfq_group *cfq_get_cfqg(st
 {
 	struct blkio_cgroup *blkcg;
 	struct cfq_group *cfqg = NULL, *__cfqg = NULL;
-	struct request_queue *q = cfqd->queue;
+	struct request_queue *q = cfqd->qdata.queue;
 
 	rcu_read_lock();
 	blkcg = task_blkio_cgroup(current);
@@ -1259,9 +1237,9 @@ static void cfq_unlink_blkio_group(void
 	unsigned long  flags;
 	struct cfq_data *cfqd = key;
 
-	spin_lock_irqsave(cfqd->queue->queue_lock, flags);
+	spin_lock_irqsave(cfqd->qdata.queue->queue_lock, flags);
 	cfq_destroy_cfqg(cfqd, cfqg_of_blkg(blkg));
-	spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
+	spin_unlock_irqrestore(cfqd->qdata.queue->queue_lock, flags);
 }
 
 #else /* GROUP_IOSCHED */
@@ -1561,12 +1539,14 @@ static struct request *
 cfq_find_rq_fmerge(struct cfq_data *cfqd, struct bio *bio)
 {
 	struct task_struct *tsk = current;
+	struct dev_io_context *gen_cic;
 	struct cfq_io_context *cic;
 	struct cfq_queue *cfqq;
 
-	cic = cfq_cic_lookup(cfqd, tsk->io_context);
-	if (!cic)
+	gen_cic = queue_data_cic_lookup(&cfqd->qdata, tsk->io_context);
+	if (!gen_cic)
 		return NULL;
+	cic = dev_ioc_to_cfq_ioc(gen_cic);
 
 	cfqq = cic_to_cfqq(cic, cfq_bio_sync(bio));
 	if (cfqq) {
@@ -1675,6 +1655,7 @@ static int cfq_allow_merge(struct reques
 			   struct bio *bio)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
+	struct dev_io_context *gen_cic;
 	struct cfq_io_context *cic;
 	struct cfq_queue *cfqq;
 
@@ -1688,9 +1669,10 @@ static int cfq_allow_merge(struct reques
 	 * Lookup the cfqq that this bio will be queued with. Allow
 	 * merge only if rq is queued there.
 	 */
-	cic = cfq_cic_lookup(cfqd, current->io_context);
-	if (!cic)
+	gen_cic = queue_data_cic_lookup(&cfqd->qdata, current->io_context);
+	if (!gen_cic)
 		return false;
+	cic = dev_ioc_to_cfq_ioc(gen_cic);
 
 	cfqq = cic_to_cfqq(cic, cfq_bio_sync(bio));
 	return cfqq == RQ_CFQQ(rq);
@@ -1774,7 +1756,7 @@ __cfq_slice_expired(struct cfq_data *cfq
 		cfqd->active_queue = NULL;
 
 	if (cfqd->active_cic) {
-		put_io_context(cfqd->active_cic->ioc);
+		put_io_context(cfqd->active_cic->dev_ioc.ioc);
 		cfqd->active_cic = NULL;
 	}
 }
@@ -1976,7 +1958,7 @@ static bool cfq_should_idle(struct cfq_d
 
 	/* We do for queues that were marked with idle window flag. */
 	if (cfq_cfqq_idle_window(cfqq) &&
-	   !(blk_queue_nonrot(cfqd->queue) && cfqd->hw_tag))
+	   !(blk_queue_nonrot(cfqd->qdata.queue) && cfqd->hw_tag))
 		return true;
 
 	/*
@@ -2002,7 +1984,7 @@ static void cfq_arm_slice_timer(struct c
 	 * for devices that support queuing, otherwise we still have a problem
 	 * with sync vs async workloads.
 	 */
-	if (blk_queue_nonrot(cfqd->queue) && cfqd->hw_tag)
+	if (blk_queue_nonrot(cfqd->qdata.queue) && cfqd->hw_tag)
 		return;
 
 	WARN_ON(!RB_EMPTY_ROOT(&cfqq->sort_list));
@@ -2029,7 +2011,7 @@ static void cfq_arm_slice_timer(struct c
 	 * task has exited, don't wait
 	 */
 	cic = cfqd->active_cic;
-	if (!cic || !atomic_read(&cic->ioc->nr_tasks))
+	if (!cic || !atomic_read(&cic->dev_ioc.ioc->nr_tasks))
 		return;
 
 	/*
@@ -2423,7 +2405,7 @@ static int __cfq_forced_dispatch_cfqq(st
 	int dispatched = 0;
 
 	while (cfqq->next_rq) {
-		cfq_dispatch_insert(cfqq->cfqd->queue, cfqq->next_rq);
+		cfq_dispatch_insert(cfqq->cfqd->qdata.queue, cfqq->next_rq);
 		dispatched++;
 	}
 
@@ -2577,12 +2559,12 @@ static bool cfq_dispatch_request(struct
 	/*
 	 * insert request into driver dispatch list
 	 */
-	cfq_dispatch_insert(cfqd->queue, rq);
+	cfq_dispatch_insert(cfqd->qdata.queue, rq);
 
 	if (!cfqd->active_cic) {
 		struct cfq_io_context *cic = RQ_CIC(rq);
 
-		atomic_long_inc(&cic->ioc->refcount);
+		atomic_long_inc(&cic->dev_ioc.ioc->refcount);
 		cfqd->active_cic = cic;
 	}
 
@@ -2665,84 +2647,6 @@ static void cfq_put_queue(struct cfq_que
 	cfq_put_cfqg(cfqg);
 }
 
-/*
- * Call func for each cic attached to this ioc.
- */
-static void
-call_for_each_cic(struct io_context *ioc,
-		  void (*func)(struct io_context *, struct cfq_io_context *))
-{
-	struct cfq_io_context *cic;
-	struct hlist_node *n;
-
-	rcu_read_lock();
-
-	hlist_for_each_entry_rcu(cic, n, &ioc->cic_list, cic_list)
-		func(ioc, cic);
-
-	rcu_read_unlock();
-}
-
-static void cfq_cic_free_rcu(struct rcu_head *head)
-{
-	struct cfq_io_context *cic;
-
-	cic = container_of(head, struct cfq_io_context, rcu_head);
-
-	kmem_cache_free(cfq_ioc_pool, cic);
-	elv_ioc_count_dec(cfq_ioc_count);
-
-	if (ioc_gone) {
-		/*
-		 * CFQ scheduler is exiting, grab exit lock and check
-		 * the pending io context count. If it hits zero,
-		 * complete ioc_gone and set it back to NULL
-		 */
-		spin_lock(&ioc_gone_lock);
-		if (ioc_gone && !elv_ioc_count_read(cfq_ioc_count)) {
-			complete(ioc_gone);
-			ioc_gone = NULL;
-		}
-		spin_unlock(&ioc_gone_lock);
-	}
-}
-
-static void cfq_cic_free(struct cfq_io_context *cic)
-{
-	call_rcu(&cic->rcu_head, cfq_cic_free_rcu);
-}
-
-static void cic_free_func(struct io_context *ioc, struct cfq_io_context *cic)
-{
-	unsigned long flags;
-	unsigned long dead_key = (unsigned long) cic->key;
-
-	BUG_ON(!(dead_key & CIC_DEAD_KEY));
-
-	spin_lock_irqsave(&ioc->lock, flags);
-	radix_tree_delete(&ioc->radix_root, dead_key >> CIC_DEAD_INDEX_SHIFT);
-	hlist_del_rcu(&cic->cic_list);
-	spin_unlock_irqrestore(&ioc->lock, flags);
-
-	cfq_cic_free(cic);
-}
-
-/*
- * Must be called with rcu_read_lock() held or preemption otherwise disabled.
- * Only two callers of this - ->dtor() which is called with the rcu_read_lock(),
- * and ->trim() which is called with the task lock held
- */
-static void cfq_free_io_context(struct io_context *ioc)
-{
-	/*
-	 * ioc->refcount is zero here, or we are called from elv_unregister(),
-	 * so no more cic's are allowed to be linked into this ioc.  So it
-	 * should be ok to iterate over the known list, we will see all cic's
-	 * since no new ones are added.
-	 */
-	call_for_each_cic(ioc, cic_free_func);
-}
-
 static void cfq_put_cooperator(struct cfq_queue *cfqq)
 {
 	struct cfq_queue *__cfqq, *next;
@@ -2776,90 +2680,6 @@ static void cfq_exit_cfqq(struct cfq_dat
 	cfq_put_queue(cfqq);
 }
 
-static void __cfq_exit_single_io_context(struct cfq_data *cfqd,
-					 struct cfq_io_context *cic)
-{
-	struct io_context *ioc = cic->ioc;
-
-	list_del_init(&cic->queue_list);
-
-	/*
-	 * Make sure dead mark is seen for dead queues
-	 */
-	smp_wmb();
-	cic->key = cfqd_dead_key(cfqd);
-
-	rcu_read_lock();
-	if (rcu_dereference(ioc->ioc_data) == cic) {
-		rcu_read_unlock();
-		spin_lock(&ioc->lock);
-		rcu_assign_pointer(ioc->ioc_data, NULL);
-		spin_unlock(&ioc->lock);
-	} else
-		rcu_read_unlock();
-
-	if (cic->cfqq[BLK_RW_ASYNC]) {
-		cfq_exit_cfqq(cfqd, cic->cfqq[BLK_RW_ASYNC]);
-		cic->cfqq[BLK_RW_ASYNC] = NULL;
-	}
-
-	if (cic->cfqq[BLK_RW_SYNC]) {
-		cfq_exit_cfqq(cfqd, cic->cfqq[BLK_RW_SYNC]);
-		cic->cfqq[BLK_RW_SYNC] = NULL;
-	}
-}
-
-static void cfq_exit_single_io_context(struct io_context *ioc,
-				       struct cfq_io_context *cic)
-{
-	struct cfq_data *cfqd = cic_to_cfqd(cic);
-
-	if (cfqd) {
-		struct request_queue *q = cfqd->queue;
-		unsigned long flags;
-
-		spin_lock_irqsave(q->queue_lock, flags);
-
-		/*
-		 * Ensure we get a fresh copy of the ->key to prevent
-		 * race between exiting task and queue
-		 */
-		smp_read_barrier_depends();
-		if (cic->key == cfqd)
-			__cfq_exit_single_io_context(cfqd, cic);
-
-		spin_unlock_irqrestore(q->queue_lock, flags);
-	}
-}
-
-/*
- * The process that ioc belongs to has exited, we need to clean up
- * and put the internal structures we have that belongs to that process.
- */
-static void cfq_exit_io_context(struct io_context *ioc)
-{
-	call_for_each_cic(ioc, cfq_exit_single_io_context);
-}
-
-static struct cfq_io_context *
-cfq_alloc_io_context(struct cfq_data *cfqd, gfp_t gfp_mask)
-{
-	struct cfq_io_context *cic;
-
-	cic = kmem_cache_alloc_node(cfq_ioc_pool, gfp_mask | __GFP_ZERO,
-							cfqd->queue->node);
-	if (cic) {
-		cic->ttime.last_end_request = jiffies;
-		INIT_LIST_HEAD(&cic->queue_list);
-		INIT_HLIST_NODE(&cic->cic_list);
-		cic->dtor = cfq_free_io_context;
-		cic->exit = cfq_exit_io_context;
-		elv_ioc_count_inc(cfq_ioc_count);
-	}
-
-	return cic;
-}
-
 static void cfq_init_prio_data(struct cfq_queue *cfqq, struct io_context *ioc)
 {
 	struct task_struct *tsk = current;
@@ -2902,21 +2722,24 @@ static void cfq_init_prio_data(struct cf
 	cfq_clear_cfqq_prio_changed(cfqq);
 }
 
-static void changed_ioprio(struct io_context *ioc, struct cfq_io_context *cic)
+static void changed_ioprio(struct io_context *ioc,
+	struct dev_io_context *gen_cic)
 {
-	struct cfq_data *cfqd = cic_to_cfqd(cic);
+	struct queue_data *qdata = cic_to_queue_data(gen_cic);
+	struct cfq_io_context *cic = dev_ioc_to_cfq_ioc(gen_cic);
+	struct cfq_data *cfqd = queue_data_to_cfqd(qdata);
 	struct cfq_queue *cfqq;
 	unsigned long flags;
 
 	if (unlikely(!cfqd))
 		return;
 
-	spin_lock_irqsave(cfqd->queue->queue_lock, flags);
+	spin_lock_irqsave(cfqd->qdata.queue->queue_lock, flags);
 
 	cfqq = cic->cfqq[BLK_RW_ASYNC];
 	if (cfqq) {
 		struct cfq_queue *new_cfqq;
-		new_cfqq = cfq_get_queue(cfqd, BLK_RW_ASYNC, cic->ioc,
+		new_cfqq = cfq_get_queue(cfqd, BLK_RW_ASYNC, cic->dev_ioc.ioc,
 						GFP_ATOMIC);
 		if (new_cfqq) {
 			cic->cfqq[BLK_RW_ASYNC] = new_cfqq;
@@ -2928,13 +2751,7 @@ static void changed_ioprio(struct io_con
 	if (cfqq)
 		cfq_mark_cfqq_prio_changed(cfqq);
 
-	spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
-}
-
-static void cfq_ioc_set_ioprio(struct io_context *ioc)
-{
-	call_for_each_cic(ioc, changed_ioprio);
-	ioc->ioprio_changed = 0;
+	spin_unlock_irqrestore(cfqd->qdata.queue->queue_lock, flags);
 }
 
 static void cfq_init_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
@@ -2958,17 +2775,20 @@ static void cfq_init_cfqq(struct cfq_dat
 }
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
-static void changed_cgroup(struct io_context *ioc, struct cfq_io_context *cic)
+static void changed_cgroup(struct io_context *ioc,
+	struct dev_io_context *gen_cic)
 {
+	struct cfq_io_context *cic = dev_ioc_to_cfq_ioc(gen_cic);
 	struct cfq_queue *sync_cfqq = cic_to_cfqq(cic, 1);
-	struct cfq_data *cfqd = cic_to_cfqd(cic);
+	struct queue_data *qdata = cic_to_queue_data(gen_cic);
+	struct cfq_data *cfqd = queue_data_to_cfqd(qdata);
 	unsigned long flags;
 	struct request_queue *q;
 
 	if (unlikely(!cfqd))
 		return;
 
-	q = cfqd->queue;
+	q = cfqd->qdata.queue;
 
 	spin_lock_irqsave(q->queue_lock, flags);
 
@@ -2984,12 +2804,6 @@ static void changed_cgroup(struct io_con
 
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
-
-static void cfq_ioc_set_cgroup(struct io_context *ioc)
-{
-	call_for_each_cic(ioc, changed_cgroup);
-	ioc->cgroup_changed = 0;
-}
 #endif  /* CONFIG_CFQ_GROUP_IOSCHED */
 
 static struct cfq_queue *
@@ -2997,12 +2811,14 @@ cfq_find_alloc_queue(struct cfq_data *cf
 		     struct io_context *ioc, gfp_t gfp_mask)
 {
 	struct cfq_queue *cfqq, *new_cfqq = NULL;
+	struct dev_io_context *gen_cic;
 	struct cfq_io_context *cic;
 	struct cfq_group *cfqg;
 
 retry:
 	cfqg = cfq_get_cfqg(cfqd);
-	cic = cfq_cic_lookup(cfqd, ioc);
+	gen_cic = queue_data_cic_lookup(&cfqd->qdata, ioc);
+	cic = dev_ioc_to_cfq_ioc(gen_cic);
 	/* cic always exists here */
 	cfqq = cic_to_cfqq(cic, is_sync);
 
@@ -3016,17 +2832,17 @@ retry:
 			cfqq = new_cfqq;
 			new_cfqq = NULL;
 		} else if (gfp_mask & __GFP_WAIT) {
-			spin_unlock_irq(cfqd->queue->queue_lock);
+			spin_unlock_irq(cfqd->qdata.queue->queue_lock);
 			new_cfqq = kmem_cache_alloc_node(cfq_pool,
 					gfp_mask | __GFP_ZERO,
-					cfqd->queue->node);
-			spin_lock_irq(cfqd->queue->queue_lock);
+					cfqd->qdata.queue->node);
+			spin_lock_irq(cfqd->qdata.queue->queue_lock);
 			if (new_cfqq)
 				goto retry;
 		} else {
 			cfqq = kmem_cache_alloc_node(cfq_pool,
 					gfp_mask | __GFP_ZERO,
-					cfqd->queue->node);
+					cfqd->qdata.queue->node);
 		}
 
 		if (cfqq) {
@@ -3088,159 +2904,6 @@ cfq_get_queue(struct cfq_data *cfqd, boo
 	return cfqq;
 }
 
-/*
- * We drop cfq io contexts lazily, so we may find a dead one.
- */
-static void
-cfq_drop_dead_cic(struct cfq_data *cfqd, struct io_context *ioc,
-		  struct cfq_io_context *cic)
-{
-	unsigned long flags;
-
-	WARN_ON(!list_empty(&cic->queue_list));
-	BUG_ON(cic->key != cfqd_dead_key(cfqd));
-
-	spin_lock_irqsave(&ioc->lock, flags);
-
-	BUG_ON(rcu_dereference_check(ioc->ioc_data,
-		lockdep_is_held(&ioc->lock)) == cic);
-
-	radix_tree_delete(&ioc->radix_root, cfqd->cic_index);
-	hlist_del_rcu(&cic->cic_list);
-	spin_unlock_irqrestore(&ioc->lock, flags);
-
-	cfq_cic_free(cic);
-}
-
-static struct cfq_io_context *
-cfq_cic_lookup(struct cfq_data *cfqd, struct io_context *ioc)
-{
-	struct cfq_io_context *cic;
-	unsigned long flags;
-
-	if (unlikely(!ioc))
-		return NULL;
-
-	rcu_read_lock();
-
-	/*
-	 * we maintain a last-hit cache, to avoid browsing over the tree
-	 */
-	cic = rcu_dereference(ioc->ioc_data);
-	if (cic && cic->key == cfqd) {
-		rcu_read_unlock();
-		return cic;
-	}
-
-	do {
-		cic = radix_tree_lookup(&ioc->radix_root, cfqd->cic_index);
-		rcu_read_unlock();
-		if (!cic)
-			break;
-		if (unlikely(cic->key != cfqd)) {
-			cfq_drop_dead_cic(cfqd, ioc, cic);
-			rcu_read_lock();
-			continue;
-		}
-
-		spin_lock_irqsave(&ioc->lock, flags);
-		rcu_assign_pointer(ioc->ioc_data, cic);
-		spin_unlock_irqrestore(&ioc->lock, flags);
-		break;
-	} while (1);
-
-	return cic;
-}
-
-/*
- * Add cic into ioc, using cfqd as the search key. This enables us to lookup
- * the process specific cfq io context when entered from the block layer.
- * Also adds the cic to a per-cfqd list, used when this queue is removed.
- */
-static int cfq_cic_link(struct cfq_data *cfqd, struct io_context *ioc,
-			struct cfq_io_context *cic, gfp_t gfp_mask)
-{
-	unsigned long flags;
-	int ret;
-
-	ret = radix_tree_preload(gfp_mask);
-	if (!ret) {
-		cic->ioc = ioc;
-		cic->key = cfqd;
-
-		spin_lock_irqsave(&ioc->lock, flags);
-		ret = radix_tree_insert(&ioc->radix_root,
-						cfqd->cic_index, cic);
-		if (!ret)
-			hlist_add_head_rcu(&cic->cic_list, &ioc->cic_list);
-		spin_unlock_irqrestore(&ioc->lock, flags);
-
-		radix_tree_preload_end();
-
-		if (!ret) {
-			spin_lock_irqsave(cfqd->queue->queue_lock, flags);
-			list_add(&cic->queue_list, &cfqd->cic_list);
-			spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
-		}
-	}
-
-	if (ret && ret != -EEXIST)
-		printk(KERN_ERR "cfq: cic link failed!\n");
-
-	return ret;
-}
-
-/*
- * Setup general io context and cfq io context. There can be several cfq
- * io contexts per general io context, if this process is doing io to more
- * than one device managed by cfq.
- */
-static struct cfq_io_context *
-cfq_get_io_context(struct cfq_data *cfqd, gfp_t gfp_mask)
-{
-	struct io_context *ioc = NULL;
-	struct cfq_io_context *cic;
-	int ret;
-
-	might_sleep_if(gfp_mask & __GFP_WAIT);
-
-	ioc = get_io_context(gfp_mask, cfqd->queue->node);
-	if (!ioc)
-		return NULL;
-
-retry:
-	cic = cfq_cic_lookup(cfqd, ioc);
-	if (cic)
-		goto out;
-
-	cic = cfq_alloc_io_context(cfqd, gfp_mask);
-	if (cic == NULL)
-		goto err;
-
-	ret = cfq_cic_link(cfqd, ioc, cic, gfp_mask);
-	if (ret == -EEXIST) {
-		/* someone has linked cic to ioc already */
-		cfq_cic_free(cic);
-		goto retry;
-	} else if (ret)
-		goto err_free;
-
-out:
-	smp_read_barrier_depends();
-	if (unlikely(ioc->ioprio_changed))
-		cfq_ioc_set_ioprio(ioc);
-
-#ifdef CONFIG_CFQ_GROUP_IOSCHED
-	if (unlikely(ioc->cgroup_changed))
-		cfq_ioc_set_cgroup(ioc);
-#endif
-	return cic;
-err_free:
-	cfq_cic_free(cic);
-err:
-	put_io_context(ioc);
-	return NULL;
-}
 
 static void
 __cfq_update_io_thinktime(struct cfq_ttime *ttime, unsigned long slice_idle)
@@ -3281,7 +2944,7 @@ cfq_update_io_seektime(struct cfq_data *
 	}
 
 	cfqq->seek_history <<= 1;
-	if (blk_queue_nonrot(cfqd->queue))
+	if (blk_queue_nonrot(cfqd->qdata.queue))
 		cfqq->seek_history |= (n_sec < CFQQ_SECT_THR_NONROT);
 	else
 		cfqq->seek_history |= (sdist > CFQQ_SEEK_THR);
@@ -3310,7 +2973,8 @@ cfq_update_idle_window(struct cfq_data *
 
 	if (cfqq->next_rq && (cfqq->next_rq->cmd_flags & REQ_NOIDLE))
 		enable_idle = 0;
-	else if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
+	else if (!atomic_read(&cic->dev_ioc.ioc->nr_tasks) ||
+	    !cfqd->cfq_slice_idle ||
 	    (!cfq_cfqq_deep(cfqq) && CFQQ_SEEKY(cfqq)))
 		enable_idle = 0;
 	else if (sample_valid(cic->ttime.ttime_samples)) {
@@ -3471,7 +3135,7 @@ cfq_rq_enqueued(struct cfq_data *cfqd, s
 			    cfqd->busy_queues > 1) {
 				cfq_del_timer(cfqd, cfqq);
 				cfq_clear_cfqq_wait_request(cfqq);
-				__blk_run_queue(cfqd->queue);
+				__blk_run_queue(cfqd->qdata.queue);
 			} else {
 				cfq_blkiocg_update_idle_time_stats(
 						&cfqq->cfqg->blkg);
@@ -3486,7 +3150,7 @@ cfq_rq_enqueued(struct cfq_data *cfqd, s
 		 * this new queue is RT and the current one is BE
 		 */
 		cfq_preempt_queue(cfqd, cfqq);
-		__blk_run_queue(cfqd->queue);
+		__blk_run_queue(cfqd->qdata.queue);
 	}
 }
 
@@ -3496,7 +3160,7 @@ static void cfq_insert_request(struct re
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
 
 	cfq_log_cfqq(cfqd, cfqq, "insert_request");
-	cfq_init_prio_data(cfqq, RQ_CIC(rq)->ioc);
+	cfq_init_prio_data(cfqq, RQ_CIC(rq)->dev_ioc.ioc);
 
 	rq_set_fifo_time(rq, jiffies + cfqd->cfq_fifo_expire[rq_is_sync(rq)]);
 	list_add_tail(&rq->queuelist, &cfqq->fifo);
@@ -3683,6 +3347,7 @@ static int cfq_may_queue(struct request_
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct task_struct *tsk = current;
+	struct dev_io_context *gen_cic;
 	struct cfq_io_context *cic;
 	struct cfq_queue *cfqq;
 
@@ -3692,13 +3357,14 @@ static int cfq_may_queue(struct request_
 	 * so just lookup a possibly existing queue, or return 'may queue'
 	 * if that fails
 	 */
-	cic = cfq_cic_lookup(cfqd, tsk->io_context);
-	if (!cic)
+	gen_cic = queue_data_cic_lookup(&cfqd->qdata, tsk->io_context);
+	if (!gen_cic)
 		return ELV_MQUEUE_MAY;
+	cic = dev_ioc_to_cfq_ioc(gen_cic);
 
 	cfqq = cic_to_cfqq(cic, rw_is_sync(rw));
 	if (cfqq) {
-		cfq_init_prio_data(cfqq, cic->ioc);
+		cfq_init_prio_data(cfqq, cic->dev_ioc.ioc);
 
 		return __cfq_may_queue(cfqq);
 	}
@@ -3719,7 +3385,7 @@ static void cfq_put_request(struct reque
 		BUG_ON(!cfqq->allocated[rw]);
 		cfqq->allocated[rw]--;
 
-		put_io_context(RQ_CIC(rq)->ioc);
+		put_io_context(RQ_CIC(rq)->dev_ioc.ioc);
 
 		rq->elevator_private[0] = NULL;
 		rq->elevator_private[1] = NULL;
@@ -3772,6 +3438,7 @@ cfq_set_request(struct request_queue *q,
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct cfq_io_context *cic;
+	struct dev_io_context *dev_ioc;
 	const int rw = rq_data_dir(rq);
 	const bool is_sync = rq_is_sync(rq);
 	struct cfq_queue *cfqq;
@@ -3779,7 +3446,12 @@ cfq_set_request(struct request_queue *q,
 
 	might_sleep_if(gfp_mask & __GFP_WAIT);
 
-	cic = cfq_get_io_context(cfqd, gfp_mask);
+	dev_ioc = queue_data_get_io_context(&ioc_builder, &cfqd->qdata,
+						gfp_mask);
+	if (dev_ioc)
+		cic = dev_ioc_to_cfq_ioc(dev_ioc);
+	else
+		cic = NULL;
 
 	spin_lock_irqsave(q->queue_lock, flags);
 
@@ -3789,7 +3461,7 @@ cfq_set_request(struct request_queue *q,
 new_queue:
 	cfqq = cic_to_cfqq(cic, is_sync);
 	if (!cfqq || cfqq == &cfqd->oom_cfqq) {
-		cfqq = cfq_get_queue(cfqd, is_sync, cic->ioc, gfp_mask);
+		cfqq = cfq_get_queue(cfqd, is_sync, cic->dev_ioc.ioc, gfp_mask);
 		cic_set_cfqq(cic, cfqq, is_sync);
 	} else {
 		/*
@@ -3832,10 +3504,10 @@ static void cfq_kick_queue(struct work_s
 {
 	struct cfq_data *cfqd =
 		container_of(work, struct cfq_data, unplug_work);
-	struct request_queue *q = cfqd->queue;
+	struct request_queue *q = cfqd->qdata.queue;
 
 	spin_lock_irq(q->queue_lock);
-	__blk_run_queue(cfqd->queue);
+	__blk_run_queue(q);
 	spin_unlock_irq(q->queue_lock);
 }
 
@@ -3851,7 +3523,7 @@ static void cfq_idle_slice_timer(unsigne
 
 	cfq_log(cfqd, "idle timer fired");
 
-	spin_lock_irqsave(cfqd->queue->queue_lock, flags);
+	spin_lock_irqsave(cfqd->qdata.queue->queue_lock, flags);
 
 	cfqq = cfqd->active_queue;
 	if (cfqq) {
@@ -3892,7 +3564,7 @@ expire:
 out_kick:
 	cfq_schedule_dispatch(cfqd);
 out_cont:
-	spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
+	spin_unlock_irqrestore(cfqd->qdata.queue->queue_lock, flags);
 }
 
 static void cfq_shutdown_timer_wq(struct cfq_data *cfqd)
@@ -3916,10 +3588,35 @@ static void cfq_put_async_queues(struct
 		cfq_put_queue(cfqd->async_idle_cfqq);
 }
 
+static void cfq_init_cic(struct queue_data *qdata,
+	struct dev_io_context *gen_cic)
+{
+	struct cfq_io_context *cic = dev_ioc_to_cfq_ioc(gen_cic);
+
+	cic->ttime.last_end_request = jiffies;
+}
+
+static void cfq_exit_cic(struct queue_data *qdata,
+	struct dev_io_context *gen_cic)
+{
+	struct cfq_io_context *cic = dev_ioc_to_cfq_ioc(gen_cic);
+	struct cfq_data *cfqd = queue_data_to_cfqd(qdata);
+
+	if (cic->cfqq[BLK_RW_ASYNC]) {
+		cfq_exit_cfqq(cfqd, cic->cfqq[BLK_RW_ASYNC]);
+		cic->cfqq[BLK_RW_ASYNC] = NULL;
+	}
+
+	if (cic->cfqq[BLK_RW_SYNC]) {
+		cfq_exit_cfqq(cfqd, cic->cfqq[BLK_RW_SYNC]);
+		cic->cfqq[BLK_RW_SYNC] = NULL;
+	}
+}
+
 static void cfq_exit_queue(struct elevator_queue *e)
 {
 	struct cfq_data *cfqd = e->elevator_data;
-	struct request_queue *q = cfqd->queue;
+	struct request_queue *q = cfqd->qdata.queue;
 	bool wait = false;
 
 	cfq_shutdown_timer_wq(cfqd);
@@ -3929,13 +3626,7 @@ static void cfq_exit_queue(struct elevat
 	if (cfqd->active_queue)
 		__cfq_slice_expired(cfqd, cfqd->active_queue, 0);
 
-	while (!list_empty(&cfqd->cic_list)) {
-		struct cfq_io_context *cic = list_entry(cfqd->cic_list.next,
-							struct cfq_io_context,
-							queue_list);
-
-		__cfq_exit_single_io_context(cfqd, cic);
-	}
+	ioc_builder_exit_queue(&ioc_builder, &cfqd->qdata);
 
 	cfq_put_async_queues(cfqd);
 	cfq_release_cfq_groups(cfqd);
@@ -3951,10 +3642,6 @@ static void cfq_exit_queue(struct elevat
 
 	cfq_shutdown_timer_wq(cfqd);
 
-	spin_lock(&cic_index_lock);
-	ida_remove(&cic_index_ida, cfqd->cic_index);
-	spin_unlock(&cic_index_lock);
-
 	/*
 	 * Wait for cfqg->blkg->key accessors to exit their grace periods.
 	 * Do this wait only if there are other unlinked groups out
@@ -3976,24 +3663,6 @@ static void cfq_exit_queue(struct elevat
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
@@ -4001,24 +3670,15 @@ static void *cfq_init_queue(struct reque
 	struct cfq_group *cfqg;
 	struct cfq_rb_root *st;
 
-	i = cfq_alloc_cic_index();
-	if (i < 0)
+	cfqd = kmalloc_node(sizeof(*cfqd), GFP_KERNEL | __GFP_ZERO, q->node);
+	if (!cfqd)
 		return NULL;
 
-	cfqd = kmalloc_node(sizeof(*cfqd), GFP_KERNEL | __GFP_ZERO, q->node);
-	if (!cfqd) {
-		spin_lock(&cic_index_lock);
-		ida_remove(&cic_index_ida, i);
-		spin_unlock(&cic_index_lock);
+	if (ioc_builder_init_queue(&ioc_builder, &cfqd->qdata, q)) {
+		kfree(cfqd);
 		return NULL;
 	}
 
-	/*
-	 * Don't need take queue_lock in the routine, since we are
-	 * initializing the ioscheduler, and nobody is using cfqd
-	 */
-	cfqd->cic_index = i;
-
 	/* Init root service tree */
 	cfqd->grp_service_tree = CFQ_RB_ROOT;
 
@@ -4044,9 +3704,7 @@ static void *cfq_init_queue(struct reque
 	if (blkio_alloc_blkg_stats(&cfqg->blkg)) {
 		kfree(cfqg);
 
-		spin_lock(&cic_index_lock);
-		ida_remove(&cic_index_ida, cfqd->cic_index);
-		spin_unlock(&cic_index_lock);
+		ioc_builder_exit_queue(&ioc_builder, &cfqd->qdata);
 
 		kfree(cfqd);
 		return NULL;
@@ -4079,9 +3737,6 @@ static void *cfq_init_queue(struct reque
 	cfqd->oom_cfqq.ref++;
 	cfq_link_cfqq_cfqg(&cfqd->oom_cfqq, &cfqd->root_group);
 
-	INIT_LIST_HEAD(&cfqd->cic_list);
-
-	cfqd->queue = q;
 
 	init_timer(&cfqd->idle_slice_timer);
 	cfqd->idle_slice_timer.function = cfq_idle_slice_timer;
@@ -4137,6 +3792,34 @@ fail:
 	return -ENOMEM;
 }
 
+static struct dev_io_context *cfq_alloc_ioc(struct ioc_builder *builder,
+	struct queue_data *qdata, gfp_t gfp_mask)
+{
+	struct cfq_io_context *ioc = kmem_cache_alloc_node(cfq_ioc_pool,
+					gfp_mask, qdata->queue->node);
+	if (ioc)
+		return &ioc->dev_ioc;
+	return NULL;
+}
+
+static void cfq_free_ioc(struct ioc_builder *builder,
+	struct dev_io_context *dev_ioc)
+{
+	struct cfq_io_context *ioc = dev_ioc_to_cfq_ioc(dev_ioc);
+	kmem_cache_free(cfq_ioc_pool, ioc);
+}
+
+static struct ioc_builder ioc_builder = {
+	.alloc_ioc = cfq_alloc_ioc,
+	.free_ioc = cfq_free_ioc,
+	.changed_ioprio = changed_ioprio,
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
+	.changed_cgroup = changed_cgroup,
+#endif
+	.cic_init = cfq_init_cic,
+	.cic_exit = cfq_exit_cic,
+};
+
 /*
  * sysfs parts below -->
  */
@@ -4247,7 +3930,7 @@ static struct elevator_type iosched_cfq
 		.elevator_may_queue_fn =	cfq_may_queue,
 		.elevator_init_fn =		cfq_init_queue,
 		.elevator_exit_fn =		cfq_exit_queue,
-		.trim =				cfq_free_io_context,
+		.trim =				queue_data_free_io_context,
 	},
 	.elevator_attrs =	cfq_attrs,
 	.elevator_name =	"cfq",
@@ -4284,6 +3967,10 @@ static int __init cfq_init(void)
 #endif
 	if (cfq_slab_setup())
 		return -ENOMEM;
+	if (ioc_builder_init(&ioc_builder)) {
+		cfq_slab_kill();
+		return -ENOMEM;
+	}
 
 	elv_register(&iosched_cfq);
 	blkio_policy_register(&blkio_policy_cfq);
@@ -4293,20 +3980,9 @@ static int __init cfq_init(void)
 
 static void __exit cfq_exit(void)
 {
-	DECLARE_COMPLETION_ONSTACK(all_gone);
 	blkio_policy_unregister(&blkio_policy_cfq);
 	elv_unregister(&iosched_cfq);
-	ioc_gone = &all_gone;
-	/* ioc_gone's update must be visible before reading ioc_count */
-	smp_wmb();
-
-	/*
-	 * this also protects us from entering cfq_slab_kill() with
-	 * pending RCU callbacks
-	 */
-	if (elv_ioc_count_read(cfq_ioc_count))
-		wait_for_completion(&all_gone);
-	ida_destroy(&cic_index_ida);
+	io_context_builder_exit(&ioc_builder);
 	cfq_slab_kill();
 }
 
Index: linux/include/linux/iocontext.h
===================================================================
--- linux.orig/include/linux/iocontext.h	2011-12-27 16:13:02.000000000 +0800
+++ linux/include/linux/iocontext.h	2011-12-27 16:16:38.000000000 +0800
@@ -4,6 +4,22 @@
 #include <linux/radix-tree.h>
 #include <linux/rcupdate.h>
 
+struct ioc_builder;
+struct dev_io_context {
+	void *key;
+	struct io_context *ioc;
+
+	struct list_head queue_list;
+	struct hlist_node cic_list;
+
+	void (*dtor)(struct io_context *); /* destructor */
+	void (*exit)(struct io_context *); /* called on task exit */
+
+	struct rcu_head rcu_head;
+
+	struct ioc_builder *builder;
+};
+
 struct cfq_queue;
 struct cfq_ttime {
 	unsigned long last_end_request;
@@ -14,21 +30,9 @@ struct cfq_ttime {
 };
 
 struct cfq_io_context {
-	void *key;
-
+	struct dev_io_context dev_ioc;
 	struct cfq_queue *cfqq[2];
-
-	struct io_context *ioc;
-
 	struct cfq_ttime ttime;
-
-	struct list_head queue_list;
-	struct hlist_node cic_list;
-
-	void (*dtor)(struct io_context *); /* destructor */
-	void (*exit)(struct io_context *); /* called on task exit */
-
-	struct rcu_head rcu_head;
 };
 
 /*

