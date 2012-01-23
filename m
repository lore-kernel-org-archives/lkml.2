Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab2AWXK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:10:29 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38617 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab2AWXKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:10:23 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tejun@google.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/16] blkcg: use the usual get blkg path for root blkio_group
Date: Mon, 23 Jan 2012 15:09:49 -0800
Message-Id: <1327360193-24679-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1327360193-24679-1-git-send-email-tj@kernel.org>
References: <1327360193-24679-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tejun@google.com>

For root blkg, blk_throtl_init() was using throtl_alloc_tg()
explicitly and cfq_init_queue() was manually initializing embedded
cfqd->root_group, adding unnecessarily different code paths to blkg
handling.

Make both use the usual blkio_group get functions - throtl_get_tg()
and cfq_get_cfqg() - for the root blkio_group too.  Note that
blk_throtl_init() callsite is pushed downwards in
blk_alloc_queue_node() so that @q is sufficiently initialized for
throtl_get_tg().

This simplifies root blkg handling noticeably for cfq and will allow
further modularization of blkcg API.

-v2: Vivek pointed out that using cfq_get_cfqg() won't work if
     CONFIG_CFQ_GROUP_IOSCHED is disabled.  Fix it by factoring out
     initialization of base part of cfqg into cfq_init_cfqg_base() and
     alloc/init/free explicitly if !CONFIG_CFQ_GROUP_IOSCHED.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-core.c     |    6 +-
 block/blk-throttle.c |   18 ++++----
 block/cfq-iosched.c  |  105 +++++++++++++++++++++++++-------------------------
 3 files changed, 65 insertions(+), 64 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index c6c61c0..1b73d06 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -538,9 +538,6 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	if (err)
 		goto fail_id;
 
-	if (blk_throtl_init(q))
-		goto fail_id;
-
 	setup_timer(&q->backing_dev_info.laptop_mode_wb_timer,
 		    laptop_mode_timer_fn, (unsigned long) q);
 	setup_timer(&q->timeout, blk_rq_timed_out_timer, (unsigned long) q);
@@ -562,6 +559,9 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	 */
 	q->queue_lock = &q->__queue_lock;
 
+	if (blk_throtl_init(q))
+		goto fail_id;
+
 	return q;
 
 fail_id:
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 6613de7..aeeb798 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1252,7 +1252,6 @@ void blk_throtl_drain(struct request_queue *q)
 int blk_throtl_init(struct request_queue *q)
 {
 	struct throtl_data *td;
-	struct throtl_grp *tg;
 
 	td = kzalloc_node(sizeof(*td), GFP_KERNEL, q->node);
 	if (!td)
@@ -1265,19 +1264,20 @@ int blk_throtl_init(struct request_queue *q)
 
 	/* alloc and Init root group. */
 	td->queue = q;
-	tg = throtl_alloc_tg(td);
 
-	if (!tg) {
-		kfree(td);
-		return -ENOMEM;
-	}
+	rcu_read_lock();
+	spin_lock_irq(q->queue_lock);
 
-	td->root_tg = tg;
+	td->root_tg = throtl_get_tg(td, &blkio_root_cgroup);
 
-	rcu_read_lock();
-	throtl_init_add_tg_lists(td, tg, &blkio_root_cgroup);
+	spin_unlock_irq(q->queue_lock);
 	rcu_read_unlock();
 
+	if (!td->root_tg) {
+		kfree(td);
+		return -ENOMEM;
+	}
+
 	/* Attach throtl data to request queue */
 	q->td = td;
 	return 0;
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index f063557..4ad2531 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -229,7 +229,7 @@ struct cfq_data {
 	struct request_queue *queue;
 	/* Root service tree for cfq_groups */
 	struct cfq_rb_root grp_service_tree;
-	struct cfq_group root_group;
+	struct cfq_group *root_group;
 
 	/*
 	 * The priority currently being served
@@ -1012,6 +1012,25 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 	cfq_blkiocg_set_start_empty_time(&cfqg->blkg);
 }
 
+/**
+ * cfq_init_cfqg_base - initialize base part of a cfq_group
+ * @cfqg: cfq_group to initialize
+ *
+ * Initialize the base part which is used whether %CONFIG_CFQ_GROUP_IOSCHED
+ * is enabled or not.
+ */
+static void cfq_init_cfqg_base(struct cfq_group *cfqg)
+{
+	struct cfq_rb_root *st;
+	int i, j;
+
+	for_each_cfqg_st(cfqg, i, j, st)
+		*st = CFQ_RB_ROOT;
+	RB_CLEAR_NODE(&cfqg->rb_node);
+
+	cfqg->ttime.last_end_request = jiffies;
+}
+
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 static inline struct cfq_group *cfqg_of_blkg(struct blkio_group *blkg)
 {
@@ -1063,19 +1082,14 @@ static void cfq_init_add_cfqg_lists(struct cfq_data *cfqd,
  */
 static struct cfq_group * cfq_alloc_cfqg(struct cfq_data *cfqd)
 {
-	struct cfq_group *cfqg = NULL;
-	int i, j, ret;
-	struct cfq_rb_root *st;
+	struct cfq_group *cfqg;
+	int ret;
 
 	cfqg = kzalloc_node(sizeof(*cfqg), GFP_ATOMIC, cfqd->queue->node);
 	if (!cfqg)
 		return NULL;
 
-	for_each_cfqg_st(cfqg, i, j, st)
-		*st = CFQ_RB_ROOT;
-	RB_CLEAR_NODE(&cfqg->rb_node);
-
-	cfqg->ttime.last_end_request = jiffies;
+	cfq_init_cfqg_base(cfqg);
 
 	/*
 	 * Take the initial reference that will be released on destroy
@@ -1106,7 +1120,7 @@ cfq_find_cfqg(struct cfq_data *cfqd, struct blkio_cgroup *blkcg)
 	 * Avoid lookup in this case
 	 */
 	if (blkcg == &blkio_root_cgroup)
-		cfqg = &cfqd->root_group;
+		cfqg = cfqd->root_group;
 	else
 		cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, cfqd->queue,
 							 BLKIO_POLICY_PROP));
@@ -1166,7 +1180,7 @@ static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd,
 	}
 
 	if (!cfqg)
-		cfqg = &cfqd->root_group;
+		cfqg = cfqd->root_group;
 
 	cfq_init_add_cfqg_lists(cfqd, cfqg, blkcg);
 	return cfqg;
@@ -1182,7 +1196,7 @@ static void cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg)
 {
 	/* Currently, all async queues are mapped to root group */
 	if (!cfq_cfqq_sync(cfqq))
-		cfqg = &cfqq->cfqd->root_group;
+		cfqg = cfqq->cfqd->root_group;
 
 	cfqq->cfqg = cfqg;
 	/* cfqq reference on cfqg */
@@ -1284,7 +1298,7 @@ static bool cfq_clear_queue(struct request_queue *q)
 static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd,
 				      struct blkio_cgroup *blkcg)
 {
-	return &cfqd->root_group;
+	return cfqd->root_group;
 }
 
 static inline struct cfq_group *cfq_ref_get_cfqg(struct cfq_group *cfqg)
@@ -3678,9 +3692,8 @@ static void cfq_exit_queue(struct elevator_queue *e)
 	if (wait)
 		synchronize_rcu();
 
-#ifdef CONFIG_CFQ_GROUP_IOSCHED
-	/* Free up per cpu stats for root group */
-	free_percpu(cfqd->root_group.blkg.stats_cpu);
+#ifndef CONFIG_CFQ_GROUP_IOSCHED
+	kfree(cfqd->root_group);
 #endif
 	kfree(cfqd);
 }
@@ -3688,52 +3701,40 @@ static void cfq_exit_queue(struct elevator_queue *e)
 static int cfq_init_queue(struct request_queue *q)
 {
 	struct cfq_data *cfqd;
-	int i, j;
-	struct cfq_group *cfqg;
-	struct cfq_rb_root *st;
+	int i;
 
 	cfqd = kmalloc_node(sizeof(*cfqd), GFP_KERNEL | __GFP_ZERO, q->node);
 	if (!cfqd)
 		return -ENOMEM;
 
+	cfqd->queue = q;
+	q->elevator->elevator_data = cfqd;
+
 	/* Init root service tree */
 	cfqd->grp_service_tree = CFQ_RB_ROOT;
 
-	/* Init root group */
-	cfqg = &cfqd->root_group;
-	for_each_cfqg_st(cfqg, i, j, st)
-		*st = CFQ_RB_ROOT;
-	RB_CLEAR_NODE(&cfqg->rb_node);
-
-	/* Give preference to root group over other groups */
-	cfqg->weight = 2*BLKIO_WEIGHT_DEFAULT;
-
+	/* Init root group and prefer root group over other groups by default */
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
-	/*
-	 * Set root group reference to 2. One reference will be dropped when
-	 * all groups on cfqd->cfqg_list are being deleted during queue exit.
-	 * Other reference will remain there as we don't want to delete this
-	 * group as it is statically allocated and gets destroyed when
-	 * throtl_data goes away.
-	 */
-	cfqg->ref = 2;
+	rcu_read_lock();
+	spin_lock_irq(q->queue_lock);
 
-	if (blkio_alloc_blkg_stats(&cfqg->blkg)) {
-		kfree(cfqg);
+	cfqd->root_group = cfq_get_cfqg(cfqd, &blkio_root_cgroup);
+
+	spin_unlock_irq(q->queue_lock);
+	rcu_read_unlock();
+#else
+	cfqd->root_group = kzalloc_node(sizeof(*cfqd->root_group),
+					GFP_KERNEL, cfqd->queue->node);
+	if (cfqd->root_group)
+		cfq_init_cfqg_base(cfqd->root_group);
+#endif
+	if (!cfqd->root_group) {
 		kfree(cfqd);
 		return -ENOMEM;
 	}
 
-	rcu_read_lock();
+	cfqd->root_group->weight = 2*BLKIO_WEIGHT_DEFAULT;
 
-	cfq_blkiocg_add_blkio_group(&blkio_root_cgroup, &cfqg->blkg,
-				    cfqd->queue, 0);
-	rcu_read_unlock();
-	cfqd->nr_blkcg_linked_grps++;
-
-	/* Add group on cfqd->cfqg_list */
-	hlist_add_head(&cfqg->cfqd_node, &cfqd->cfqg_list);
-#endif
 	/*
 	 * Not strictly needed (since RB_ROOT just clears the node and we
 	 * zeroed cfqd on alloc), but better be safe in case someone decides
@@ -3745,14 +3746,14 @@ static int cfq_init_queue(struct request_queue *q)
 	/*
 	 * Our fallback cfqq if cfq_find_alloc_queue() runs into OOM issues.
 	 * Grab a permanent reference to it, so that the normal code flow
-	 * will not attempt to free it.
+	 * will not attempt to free it.  oom_cfqq is linked to root_group
+	 * but shouldn't hold a reference as it'll never be unlinked.  Lose
+	 * the reference from linking right away.
 	 */
 	cfq_init_cfqq(cfqd, &cfqd->oom_cfqq, 1, 0);
 	cfqd->oom_cfqq.ref++;
-	cfq_link_cfqq_cfqg(&cfqd->oom_cfqq, &cfqd->root_group);
-
-	cfqd->queue = q;
-	q->elevator->elevator_data = cfqd;
+	cfq_link_cfqq_cfqg(&cfqd->oom_cfqq, cfqd->root_group);
+	cfq_put_cfqg(cfqd->root_group);
 
 	init_timer(&cfqd->idle_slice_timer);
 	cfqd->idle_slice_timer.function = cfq_idle_slice_timer;
-- 
1.7.7.3

