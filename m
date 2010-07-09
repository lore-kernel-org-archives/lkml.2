Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab0GIDY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 23:24:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308Ab0GIDY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 23:24:27 -0400
Message-ID: <4C3695D9.1060203@ds.jp.nec.com>
Date: Thu, 08 Jul 2010 23:22:01 -0400
From: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       Vivek Goyal <vgoyal@redhat.com>
CC: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>, Ryo Tsuruta <ryov@valinux.co.jp>,
       taka@valinux.co.jp, kamezawa.hiroyu@jp.fujitsu.com,
       Andrea Righi <righi.andrea@gmail.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
       balbir@linux.vnet.ibm.com
Subject: [RFC][PATCH 10/11] blkiocg async: Async queue per cfq_group
References: <4C369009.80503@ds.jp.nec.com>
In-Reply-To: <4C369009.80503@ds.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the main body for async capability of blkio controller.
The basic ideas are
  - To move async queues from cfq_data to cfq_group, and
  - To associate cfq_io_context with cfq_group

Each cfq_io_context, which was created per an io_context
per a device, is now created per an io_context per a cfq_group.
Each cfq_group is created per a cgroup per a device, so
cfq_io_context is now resulted in to be created per
an io_context per a cgroup per a device.

To protect link between cfq_io_context and cfq_group,
locking code is modified in several parts.

ToDo:
- Lock protection still might be imperfect and more investigation
  is needed.

- cic_index of root cfq_group (cfqd->root_group.cic_index) is not
  removed and lasts beyond elevator switching.
  This issues should be solved.

Signed-off-by: Munehiro "Muuhh" Ikeda <m-ikeda@ds.jp.nec.com>
---
 block/cfq-iosched.c       |  277 ++++++++++++++++++++++++++++-----------------
 include/linux/iocontext.h |    2 +-
 2 files changed, 175 insertions(+), 104 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 68f76e9..4186c30 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -191,10 +191,23 @@ struct cfq_group {
 	struct cfq_rb_root service_trees[2][3];
 	struct cfq_rb_root service_tree_idle;
 
+	/*
+	 * async queue for each priority case
+	 */
+	struct cfq_queue *async_cfqq[2][IOPRIO_BE_NR];
+	struct cfq_queue *async_idle_cfqq;
+
 	unsigned long saved_workload_slice;
 	enum wl_type_t saved_workload;
 	enum wl_prio_t saved_serving_prio;
 	struct blkio_group blkg;
+	struct cfq_data *cfqd;
+
+	/* lock for cic_list */
+	spinlock_t lock;
+	unsigned int cic_index;
+	struct list_head cic_list;
+
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 	struct hlist_node cfqd_node;
 	atomic_t ref;
@@ -254,12 +267,6 @@ struct cfq_data {
 	struct cfq_queue *active_queue;
 	struct cfq_io_context *active_cic;
 
-	/*
-	 * async queue for each priority case
-	 */
-	struct cfq_queue *async_cfqq[2][IOPRIO_BE_NR];
-	struct cfq_queue *async_idle_cfqq;
-
 	sector_t last_position;
 
 	/*
@@ -275,8 +282,6 @@ struct cfq_data {
 	unsigned int cfq_latency;
 	unsigned int cfq_group_isolation;
 
-	unsigned int cic_index;
-	struct list_head cic_list;
 
 	/*
 	 * Fallback dummy cfqq for extreme OOM conditions
@@ -418,10 +423,16 @@ static inline int cfqg_busy_async_queues(struct cfq_data *cfqd,
 }
 
 static void cfq_dispatch_insert(struct request_queue *, struct request *);
+static void __cfq_exit_single_io_context(struct cfq_data *,
+					 struct cfq_group *,
+					 struct cfq_io_context *);
 static struct cfq_queue *cfq_get_queue(struct cfq_data *, bool,
-				       struct io_context *, gfp_t);
+				       struct cfq_io_context *, gfp_t);
 static struct cfq_io_context *cfq_cic_lookup(struct cfq_data *,
-						struct io_context *);
+					     struct cfq_group *,
+					     struct io_context *);
+static void cfq_put_async_queues(struct cfq_group *);
+static int cfq_alloc_cic_index(void);
 
 static inline struct cfq_queue *cic_to_cfqq(struct cfq_io_context *cic,
 					    bool is_sync)
@@ -438,17 +449,28 @@ static inline void cic_set_cfqq(struct cfq_io_context *cic,
 #define CIC_DEAD_KEY	1ul
 #define CIC_DEAD_INDEX_SHIFT	1
 
-static inline void *cfqd_dead_key(struct cfq_data *cfqd)
+static inline void *cfqg_dead_key(struct cfq_group *cfqg)
 {
-	return (void *)(cfqd->cic_index << CIC_DEAD_INDEX_SHIFT | CIC_DEAD_KEY);
+	return (void *)(cfqg->cic_index << CIC_DEAD_INDEX_SHIFT | CIC_DEAD_KEY);
+}
+
+static inline struct cfq_group *cic_to_cfqg(struct cfq_io_context *cic)
+{
+	struct cfq_group *cfqg = cic->key;
+
+	if (unlikely((unsigned long) cfqg & CIC_DEAD_KEY))
+		cfqg = NULL;
+
+	return cfqg;
 }
 
 static inline struct cfq_data *cic_to_cfqd(struct cfq_io_context *cic)
 {
-	struct cfq_data *cfqd = cic->key;
+	struct cfq_data *cfqd = NULL;
+	struct cfq_group *cfqg = cic_to_cfqg(cic);
 
-	if (unlikely((unsigned long) cfqd & CIC_DEAD_KEY))
-		return NULL;
+	if (likely(cfqg))
+		cfqd =  cfqg->cfqd;
 
 	return cfqd;
 }
@@ -959,12 +981,12 @@ cfq_update_blkio_group_weight(struct blkio_group *blkg, unsigned int weight)
 }
 
 static struct cfq_group *
-cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
+cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct blkio_cgroup *blkcg,
+		    int create)
 {
-	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
 	struct cfq_group *cfqg = NULL;
 	void *key = cfqd;
-	int i, j;
+	int i, j, idx;
 	struct cfq_rb_root *st;
 	struct backing_dev_info *bdi = &cfqd->queue->backing_dev_info;
 	unsigned int major, minor;
@@ -978,14 +1000,21 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 	if (cfqg || !create)
 		goto done;
 
+	idx = cfq_alloc_cic_index();
+	if (idx < 0)
+		goto done;
+
 	cfqg = kzalloc_node(sizeof(*cfqg), GFP_ATOMIC, cfqd->queue->node);
 	if (!cfqg)
-		goto done;
+		goto err;
 
 	for_each_cfqg_st(cfqg, i, j, st)
 		*st = CFQ_RB_ROOT;
 	RB_CLEAR_NODE(&cfqg->rb_node);
 
+	spin_lock_init(&cfqg->lock);
+	INIT_LIST_HEAD(&cfqg->cic_list);
+
 	/*
 	 * Take the initial reference that will be released on destroy
 	 * This can be thought of a joint reference by cgroup and
@@ -1002,7 +1031,14 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 
 	/* Add group on cfqd list */
 	hlist_add_head(&cfqg->cfqd_node, &cfqd->cfqg_list);
+	cfqg->cfqd = cfqd;
+	cfqg->cic_index = idx;
+	goto done;
 
+err:
+	spin_lock(&cic_index_lock);
+	ida_remove(&cic_index_ida, idx);
+	spin_unlock(&cic_index_lock);
 done:
 	return cfqg;
 }
@@ -1095,10 +1131,6 @@ static inline struct cfq_group *cfq_ref_get_cfqg(struct cfq_group *cfqg)
 
 static void cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg)
 {
-	/* Currently, all async queues are mapped to root group */
-	if (!cfq_cfqq_sync(cfqq))
-		cfqg = &cfqq->cfqd->root_group;
-
 	cfqq->cfqg = cfqg;
 	/* cfqq reference on cfqg */
 	atomic_inc(&cfqq->cfqg->ref);
@@ -1114,6 +1146,16 @@ static void cfq_put_cfqg(struct cfq_group *cfqg)
 		return;
 	for_each_cfqg_st(cfqg, i, j, st)
 		BUG_ON(!RB_EMPTY_ROOT(&st->rb) || st->active != NULL);
+
+	/**
+	 * ToDo:
+	 * root_group never reaches here and cic_index is never
+	 * removed.  Unused cic_index lasts by elevator switching.
+	 */
+	spin_lock(&cic_index_lock);
+	ida_remove(&cic_index_ida, cfqg->cic_index);
+	spin_unlock(&cic_index_lock);
+
 	kfree(cfqg);
 }
 
@@ -1122,6 +1164,15 @@ static void cfq_destroy_cfqg(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	/* Something wrong if we are trying to remove same group twice */
 	BUG_ON(hlist_unhashed(&cfqg->cfqd_node));
 
+	while (!list_empty(&cfqg->cic_list)) {
+		struct cfq_io_context *cic = list_entry(cfqg->cic_list.next,
+							struct cfq_io_context,
+							group_list);
+
+		__cfq_exit_single_io_context(cfqd, cfqg, cic);
+	}
+
+	cfq_put_async_queues(cfqg);
 	hlist_del_init(&cfqg->cfqd_node);
 
 	/*
@@ -1497,10 +1548,12 @@ static struct request *
 cfq_find_rq_fmerge(struct cfq_data *cfqd, struct bio *bio)
 {
 	struct task_struct *tsk = current;
+	struct cfq_group *cfqg;
 	struct cfq_io_context *cic;
 	struct cfq_queue *cfqq;
 
-	cic = cfq_cic_lookup(cfqd, tsk->io_context);
+	cfqg = cfq_get_cfqg(cfqd, bio, 0);
+	cic = cfq_cic_lookup(cfqd, cfqg, tsk->io_context);
 	if (!cic)
 		return NULL;
 
@@ -1611,6 +1664,7 @@ static int cfq_allow_merge(struct request_queue *q, struct request *rq,
 			   struct bio *bio)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
+	struct cfq_group *cfqg;
 	struct cfq_io_context *cic;
 	struct cfq_queue *cfqq;
 
@@ -1624,7 +1678,8 @@ static int cfq_allow_merge(struct request_queue *q, struct request *rq,
 	 * Lookup the cfqq that this bio will be queued with. Allow
 	 * merge only if rq is queued there.
 	 */
-	cic = cfq_cic_lookup(cfqd, current->io_context);
+	cfqg = cfq_get_cfqg(cfqd, bio, 0);
+	cic = cfq_cic_lookup(cfqd, cfqg, current->io_context);
 	if (!cic)
 		return false;
 
@@ -2667,17 +2722,18 @@ static void cfq_exit_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 }
 
 static void __cfq_exit_single_io_context(struct cfq_data *cfqd,
+					 struct cfq_group *cfqg,
 					 struct cfq_io_context *cic)
 {
 	struct io_context *ioc = cic->ioc;
 
-	list_del_init(&cic->queue_list);
+	list_del_init(&cic->group_list);
 
 	/*
 	 * Make sure dead mark is seen for dead queues
 	 */
 	smp_wmb();
-	cic->key = cfqd_dead_key(cfqd);
+	cic->key = cfqg_dead_key(cfqg);
 
 	if (ioc->ioc_data == cic)
 		rcu_assign_pointer(ioc->ioc_data, NULL);
@@ -2696,23 +2752,23 @@ static void __cfq_exit_single_io_context(struct cfq_data *cfqd,
 static void cfq_exit_single_io_context(struct io_context *ioc,
 				       struct cfq_io_context *cic)
 {
-	struct cfq_data *cfqd = cic_to_cfqd(cic);
+	struct cfq_group *cfqg = cic_to_cfqg(cic);
 
-	if (cfqd) {
-		struct request_queue *q = cfqd->queue;
+	if (cfqg) {
+		struct cfq_data *cfqd = cfqg->cfqd;
 		unsigned long flags;
 
-		spin_lock_irqsave(q->queue_lock, flags);
+		spin_lock_irqsave(&cfqg->lock, flags);
 
 		/*
 		 * Ensure we get a fresh copy of the ->key to prevent
 		 * race between exiting task and queue
 		 */
 		smp_read_barrier_depends();
-		if (cic->key == cfqd)
-			__cfq_exit_single_io_context(cfqd, cic);
+		if (cic->key == cfqg)
+			__cfq_exit_single_io_context(cfqd, cfqg, cic);
 
-		spin_unlock_irqrestore(q->queue_lock, flags);
+		spin_unlock_irqrestore(&cfqg->lock, flags);
 	}
 }
 
@@ -2734,7 +2790,7 @@ cfq_alloc_io_context(struct cfq_data *cfqd, gfp_t gfp_mask)
 							cfqd->queue->node);
 	if (cic) {
 		cic->last_end_request = jiffies;
-		INIT_LIST_HEAD(&cic->queue_list);
+		INIT_LIST_HEAD(&cic->group_list);
 		INIT_HLIST_NODE(&cic->cic_list);
 		cic->dtor = cfq_free_io_context;
 		cic->exit = cfq_exit_io_context;
@@ -2801,8 +2857,7 @@ static void changed_ioprio(struct io_context *ioc, struct cfq_io_context *cic)
 	cfqq = cic->cfqq[BLK_RW_ASYNC];
 	if (cfqq) {
 		struct cfq_queue *new_cfqq;
-		new_cfqq = cfq_get_queue(cfqd, BLK_RW_ASYNC, cic->ioc,
-						GFP_ATOMIC);
+		new_cfqq = cfq_get_queue(cfqd, BLK_RW_ASYNC, cic, GFP_ATOMIC);
 		if (new_cfqq) {
 			cic->cfqq[BLK_RW_ASYNC] = new_cfqq;
 			cfq_put_queue(cfqq);
@@ -2879,16 +2934,14 @@ static void cfq_ioc_set_cgroup(struct io_context *ioc)
 
 static struct cfq_queue *
 cfq_find_alloc_queue(struct cfq_data *cfqd, bool is_sync,
-		     struct io_context *ioc, gfp_t gfp_mask)
+		     struct cfq_io_context *cic, gfp_t gfp_mask)
 {
 	struct cfq_queue *cfqq, *new_cfqq = NULL;
-	struct cfq_io_context *cic;
+	struct io_context *ioc = cic->ioc;
 	struct cfq_group *cfqg;
 
 retry:
-	cfqg = cfq_get_cfqg(cfqd, NULL, 1);
-	cic = cfq_cic_lookup(cfqd, ioc);
-	/* cic always exists here */
+	cfqg = cic_to_cfqg(cic);
 	cfqq = cic_to_cfqq(cic, is_sync);
 
 	/*
@@ -2930,36 +2983,38 @@ retry:
 }
 
 static struct cfq_queue **
-cfq_async_queue_prio(struct cfq_data *cfqd, int ioprio_class, int ioprio)
+cfq_async_queue_prio(struct cfq_group *cfqg, int ioprio_class, int ioprio)
 {
 	switch (ioprio_class) {
 	case IOPRIO_CLASS_RT:
-		return &cfqd->async_cfqq[0][ioprio];
+		return &cfqg->async_cfqq[0][ioprio];
 	case IOPRIO_CLASS_BE:
-		return &cfqd->async_cfqq[1][ioprio];
+		return &cfqg->async_cfqq[1][ioprio];
 	case IOPRIO_CLASS_IDLE:
-		return &cfqd->async_idle_cfqq;
+		return &cfqg->async_idle_cfqq;
 	default:
 		BUG();
 	}
 }
 
 static struct cfq_queue *
-cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct io_context *ioc,
+cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_context *cic,
 	      gfp_t gfp_mask)
 {
+	struct io_context *ioc = cic->ioc;
 	const int ioprio = task_ioprio(ioc);
 	const int ioprio_class = task_ioprio_class(ioc);
+	struct cfq_group *cfqg = cic_to_cfqg(cic);
 	struct cfq_queue **async_cfqq = NULL;
 	struct cfq_queue *cfqq = NULL;
 
 	if (!is_sync) {
-		async_cfqq = cfq_async_queue_prio(cfqd, ioprio_class, ioprio);
+		async_cfqq = cfq_async_queue_prio(cfqg, ioprio_class, ioprio);
 		cfqq = *async_cfqq;
 	}
 
 	if (!cfqq)
-		cfqq = cfq_find_alloc_queue(cfqd, is_sync, ioc, gfp_mask);
+		cfqq = cfq_find_alloc_queue(cfqd, is_sync, cic, gfp_mask);
 
 	/*
 	 * pin the queue now that it's allocated, scheduler exit will prune it
@@ -2977,19 +3032,19 @@ cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct io_context *ioc,
  * We drop cfq io contexts lazily, so we may find a dead one.
  */
 static void
-cfq_drop_dead_cic(struct cfq_data *cfqd, struct io_context *ioc,
-		  struct cfq_io_context *cic)
+cfq_drop_dead_cic(struct cfq_data *cfqd, struct cfq_group *cfqg,
+		  struct io_context *ioc, struct cfq_io_context *cic)
 {
 	unsigned long flags;
 
-	WARN_ON(!list_empty(&cic->queue_list));
-	BUG_ON(cic->key != cfqd_dead_key(cfqd));
+	WARN_ON(!list_empty(&cic->group_list));
+	BUG_ON(cic->key != cfqg_dead_key(cfqg));
 
 	spin_lock_irqsave(&ioc->lock, flags);
 
 	BUG_ON(ioc->ioc_data == cic);
 
-	radix_tree_delete(&ioc->radix_root, cfqd->cic_index);
+	radix_tree_delete(&ioc->radix_root, cfqg->cic_index);
 	hlist_del_rcu(&cic->cic_list);
 	spin_unlock_irqrestore(&ioc->lock, flags);
 
@@ -2997,11 +3052,14 @@ cfq_drop_dead_cic(struct cfq_data *cfqd, struct io_context *ioc,
 }
 
 static struct cfq_io_context *
-cfq_cic_lookup(struct cfq_data *cfqd, struct io_context *ioc)
+cfq_cic_lookup(struct cfq_data *cfqd, struct cfq_group *cfqg,
+	       struct io_context *ioc)
 {
 	struct cfq_io_context *cic;
 	unsigned long flags;
 
+	if (!cfqg)
+		return NULL;
 	if (unlikely(!ioc))
 		return NULL;
 
@@ -3011,18 +3069,18 @@ cfq_cic_lookup(struct cfq_data *cfqd, struct io_context *ioc)
 	 * we maintain a last-hit cache, to avoid browsing over the tree
 	 */
 	cic = rcu_dereference(ioc->ioc_data);
-	if (cic && cic->key == cfqd) {
+	if (cic && cic->key == cfqg) {
 		rcu_read_unlock();
 		return cic;
 	}
 
 	do {
-		cic = radix_tree_lookup(&ioc->radix_root, cfqd->cic_index);
+		cic = radix_tree_lookup(&ioc->radix_root, cfqg->cic_index);
 		rcu_read_unlock();
 		if (!cic)
 			break;
-		if (unlikely(cic->key != cfqd)) {
-			cfq_drop_dead_cic(cfqd, ioc, cic);
+		if (unlikely(cic->key != cfqg)) {
+			cfq_drop_dead_cic(cfqd, cfqg, ioc, cic);
 			rcu_read_lock();
 			continue;
 		}
@@ -3037,24 +3095,25 @@ cfq_cic_lookup(struct cfq_data *cfqd, struct io_context *ioc)
 }
 
 /*
- * Add cic into ioc, using cfqd as the search key. This enables us to lookup
+ * Add cic into ioc, using cfqg as the search key. This enables us to lookup
  * the process specific cfq io context when entered from the block layer.
- * Also adds the cic to a per-cfqd list, used when this queue is removed.
+ * Also adds the cic to a per-cfqg list, used when the group is removed.
+ * request_queue lock must be held.
  */
-static int cfq_cic_link(struct cfq_data *cfqd, struct io_context *ioc,
-			struct cfq_io_context *cic, gfp_t gfp_mask)
+static int cfq_cic_link(struct cfq_data *cfqd, struct cfq_group *cfqg,
+			struct io_context *ioc, struct cfq_io_context *cic)
 {
 	unsigned long flags;
 	int ret;
 
-	ret = radix_tree_preload(gfp_mask);
+	ret = radix_tree_preload(GFP_ATOMIC);
 	if (!ret) {
 		cic->ioc = ioc;
-		cic->key = cfqd;
+		cic->key = cfqg;
 
 		spin_lock_irqsave(&ioc->lock, flags);
 		ret = radix_tree_insert(&ioc->radix_root,
-						cfqd->cic_index, cic);
+						cfqg->cic_index, cic);
 		if (!ret)
 			hlist_add_head_rcu(&cic->cic_list, &ioc->cic_list);
 		spin_unlock_irqrestore(&ioc->lock, flags);
@@ -3062,9 +3121,9 @@ static int cfq_cic_link(struct cfq_data *cfqd, struct io_context *ioc,
 		radix_tree_preload_end();
 
 		if (!ret) {
-			spin_lock_irqsave(cfqd->queue->queue_lock, flags);
-			list_add(&cic->queue_list, &cfqd->cic_list);
-			spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
+			spin_lock_irqsave(&cfqg->lock, flags);
+			list_add(&cic->group_list, &cfqg->cic_list);
+			spin_unlock_irqrestore(&cfqg->lock, flags);
 		}
 	}
 
@@ -3080,10 +3139,12 @@ static int cfq_cic_link(struct cfq_data *cfqd, struct io_context *ioc,
  * than one device managed by cfq.
  */
 static struct cfq_io_context *
-cfq_get_io_context(struct cfq_data *cfqd, gfp_t gfp_mask)
+cfq_get_io_context(struct cfq_data *cfqd, struct bio *bio, gfp_t gfp_mask)
 {
 	struct io_context *ioc = NULL;
 	struct cfq_io_context *cic;
+	struct cfq_group *cfqg, *cfqg2;
+	unsigned long flags;
 
 	might_sleep_if(gfp_mask & __GFP_WAIT);
 
@@ -3091,18 +3152,38 @@ cfq_get_io_context(struct cfq_data *cfqd, gfp_t gfp_mask)
 	if (!ioc)
 		return NULL;
 
-	cic = cfq_cic_lookup(cfqd, ioc);
+	spin_lock_irqsave(cfqd->queue->queue_lock, flags);
+retry_cfqg:
+	cfqg = cfq_get_cfqg(cfqd, bio, 1);
+retry_cic:
+	cic = cfq_cic_lookup(cfqd, cfqg, ioc);
 	if (cic)
 		goto out;
+	spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
 
 	cic = cfq_alloc_io_context(cfqd, gfp_mask);
 	if (cic == NULL)
 		goto err;
 
-	if (cfq_cic_link(cfqd, ioc, cic, gfp_mask))
+	spin_lock_irqsave(cfqd->queue->queue_lock, flags);
+
+	/* check the consistency breakage during unlock period */
+	cfqg2 = cfq_get_cfqg(cfqd, bio, 0);
+	if (cfqg != cfqg2) {
+		cfq_cic_free(cic);
+		if (!cfqg2)
+			goto retry_cfqg;
+		else {
+			cfqg = cfqg2;
+			goto retry_cic;
+		}
+	}
+
+	if (cfq_cic_link(cfqd, cfqg, ioc, cic))
 		goto err_free;
 
 out:
+	spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
 	smp_read_barrier_depends();
 	if (unlikely(ioc->ioprio_changed))
 		cfq_ioc_set_ioprio(ioc);
@@ -3113,6 +3194,7 @@ out:
 #endif
 	return cic;
 err_free:
+	spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
 	cfq_cic_free(cic);
 err:
 	put_io_context(ioc);
@@ -3537,6 +3619,7 @@ static inline int __cfq_may_queue(struct cfq_queue *cfqq)
 static int cfq_may_queue(struct request_queue *q, struct bio *bio, int rw)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
+	struct cfq_group *cfqg;
 	struct task_struct *tsk = current;
 	struct cfq_io_context *cic;
 	struct cfq_queue *cfqq;
@@ -3547,7 +3630,8 @@ static int cfq_may_queue(struct request_queue *q, struct bio *bio, int rw)
 	 * so just lookup a possibly existing queue, or return 'may queue'
 	 * if that fails
 	 */
-	cic = cfq_cic_lookup(cfqd, tsk->io_context);
+	cfqg = cfq_get_cfqg(cfqd, bio, 0);
+	cic = cfq_cic_lookup(cfqd, cfqg, tsk->io_context);
 	if (!cic)
 		return ELV_MQUEUE_MAY;
 
@@ -3636,7 +3720,7 @@ cfq_set_request(struct request_queue *q, struct request *rq, struct bio *bio,
 
 	might_sleep_if(gfp_mask & __GFP_WAIT);
 
-	cic = cfq_get_io_context(cfqd, gfp_mask);
+	cic = cfq_get_io_context(cfqd, bio, gfp_mask);
 
 	spin_lock_irqsave(q->queue_lock, flags);
 
@@ -3646,7 +3730,7 @@ cfq_set_request(struct request_queue *q, struct request *rq, struct bio *bio,
 new_queue:
 	cfqq = cic_to_cfqq(cic, is_sync);
 	if (!cfqq || cfqq == &cfqd->oom_cfqq) {
-		cfqq = cfq_get_queue(cfqd, is_sync, cic->ioc, gfp_mask);
+		cfqq = cfq_get_queue(cfqd, is_sync, cic, gfp_mask);
 		cic_set_cfqq(cic, cfqq, is_sync);
 	} else {
 		/*
@@ -3762,19 +3846,19 @@ static void cfq_shutdown_timer_wq(struct cfq_data *cfqd)
 	cancel_work_sync(&cfqd->unplug_work);
 }
 
-static void cfq_put_async_queues(struct cfq_data *cfqd)
+static void cfq_put_async_queues(struct cfq_group *cfqg)
 {
 	int i;
 
 	for (i = 0; i < IOPRIO_BE_NR; i++) {
-		if (cfqd->async_cfqq[0][i])
-			cfq_put_queue(cfqd->async_cfqq[0][i]);
-		if (cfqd->async_cfqq[1][i])
-			cfq_put_queue(cfqd->async_cfqq[1][i]);
+		if (cfqg->async_cfqq[0][i])
+			cfq_put_queue(cfqg->async_cfqq[0][i]);
+		if (cfqg->async_cfqq[1][i])
+			cfq_put_queue(cfqg->async_cfqq[1][i]);
 	}
 
-	if (cfqd->async_idle_cfqq)
-		cfq_put_queue(cfqd->async_idle_cfqq);
+	if (cfqg->async_idle_cfqq)
+		cfq_put_queue(cfqg->async_idle_cfqq);
 }
 
 static void cfq_cfqd_free(struct rcu_head *head)
@@ -3794,15 +3878,6 @@ static void cfq_exit_queue(struct elevator_queue *e)
 	if (cfqd->active_queue)
 		__cfq_slice_expired(cfqd, cfqd->active_queue, 0);
 
-	while (!list_empty(&cfqd->cic_list)) {
-		struct cfq_io_context *cic = list_entry(cfqd->cic_list.next,
-							struct cfq_io_context,
-							queue_list);
-
-		__cfq_exit_single_io_context(cfqd, cic);
-	}
-
-	cfq_put_async_queues(cfqd);
 	cfq_release_cfq_groups(cfqd);
 	cfq_blkiocg_del_blkio_group(&cfqd->root_group.blkg);
 
@@ -3810,10 +3885,6 @@ static void cfq_exit_queue(struct elevator_queue *e)
 
 	cfq_shutdown_timer_wq(cfqd);
 
-	spin_lock(&cic_index_lock);
-	ida_remove(&cic_index_ida, cfqd->cic_index);
-	spin_unlock(&cic_index_lock);
-
 	/* Wait for cfqg->blkg->key accessors to exit their grace periods. */
 	call_rcu(&cfqd->rcu, cfq_cfqd_free);
 }
@@ -3823,7 +3894,7 @@ static int cfq_alloc_cic_index(void)
 	int index, error;
 
 	do {
-		if (!ida_pre_get(&cic_index_ida, GFP_KERNEL))
+		if (!ida_pre_get(&cic_index_ida, GFP_ATOMIC))
 			return -ENOMEM;
 
 		spin_lock(&cic_index_lock);
@@ -3839,20 +3910,18 @@ static int cfq_alloc_cic_index(void)
 static void *cfq_init_queue(struct request_queue *q)
 {
 	struct cfq_data *cfqd;
-	int i, j;
+	int i, j, idx;
 	struct cfq_group *cfqg;
 	struct cfq_rb_root *st;
 
-	i = cfq_alloc_cic_index();
-	if (i < 0)
+	idx = cfq_alloc_cic_index();
+	if (idx < 0)
 		return NULL;
 
 	cfqd = kmalloc_node(sizeof(*cfqd), GFP_KERNEL | __GFP_ZERO, q->node);
 	if (!cfqd)
 		return NULL;
 
-	cfqd->cic_index = i;
-
 	/* Init root service tree */
 	cfqd->grp_service_tree = CFQ_RB_ROOT;
 
@@ -3861,6 +3930,9 @@ static void *cfq_init_queue(struct request_queue *q)
 	for_each_cfqg_st(cfqg, i, j, st)
 		*st = CFQ_RB_ROOT;
 	RB_CLEAR_NODE(&cfqg->rb_node);
+	cfqg->cfqd = cfqd;
+	cfqg->cic_index = idx;
+	INIT_LIST_HEAD(&cfqg->cic_list);
 
 	/* Give preference to root group over other groups */
 	cfqg->weight = 2*BLKIO_WEIGHT_DEFAULT;
@@ -3874,6 +3946,7 @@ static void *cfq_init_queue(struct request_queue *q)
 	rcu_read_lock();
 	cfq_blkiocg_add_blkio_group(&blkio_root_cgroup, &cfqg->blkg,
 					(void *)cfqd, 0);
+	hlist_add_head(&cfqg->cfqd_node, &cfqd->cfqg_list);
 	rcu_read_unlock();
 #endif
 	/*
@@ -3893,8 +3966,6 @@ static void *cfq_init_queue(struct request_queue *q)
 	atomic_inc(&cfqd->oom_cfqq.ref);
 	cfq_link_cfqq_cfqg(&cfqd->oom_cfqq, &cfqd->root_group);
 
-	INIT_LIST_HEAD(&cfqd->cic_list);
-
 	cfqd->queue = q;
 
 	init_timer(&cfqd->idle_slice_timer);
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index 64d5291..6c05b54 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -18,7 +18,7 @@ struct cfq_io_context {
 	unsigned long ttime_samples;
 	unsigned long ttime_mean;
 
-	struct list_head queue_list;
+	struct list_head group_list;
 	struct hlist_node cic_list;
 
 	void (*dtor)(struct io_context *); /* destructor */
-- 
1.6.2.5
