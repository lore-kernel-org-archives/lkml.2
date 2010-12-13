Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab0LMBop (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 20:44:45 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64695 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756553Ab0LMBom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 20:44:42 -0500
Message-ID: <4D057A9D.1090809@cn.fujitsu.com>
Date: Mon, 13 Dec 2010 09:45:01 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>
CC: Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/8 v2] cfq-iosched: Introduce hierarchical scheduling with
 CFQ queue and group at the same level
References: <4CDF7BC5.9080803@cn.fujitsu.com> <4CDF9CC6.2040106@cn.fujitsu.com> <20101115165319.GI30792@redhat.com> <4CE2718C.6010406@kernel.dk> <4D01C6AB.9040807@cn.fujitsu.com>
In-Reply-To: <4D01C6AB.9040807@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-13 09:44:37,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-13 09:44:41,
	Serialize complete at 2010-12-13 09:44:41
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes CFQ queue and CFQ group schedules at the same level.
Consider the following hierarchy:

                    Root
                   / | \
                 q1 q2 G1
                      / \
                    q3  G2

q1 q2 and q3 are CFQ queues G1 and G2 are CFQ groups. With this patch, q1,
q2 and G1 are scheduling on a same service tree in Root CFQ group. q3 and G2
are schedluing under G1. Note, for the time being, CFQ group is treated
as "BE and SYNC" workload, and is put on "BE and SYNC" service tree. That
means service differentiate only happens in "BE and SYNC" service tree.
Later, we may introduce "IO Class" for CFQ group.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/cfq-iosched.c |  473 ++++++++++++++++++++++++++++++++++----------------
 1 files changed, 321 insertions(+), 152 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 6486956..d90627e 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -105,6 +105,9 @@ struct cfq_entity {
 	u64 vdisktime;
 	bool is_group_entity;
 	unsigned int weight;
+	struct cfq_entity *parent;
+	/* Reposition time */
+	unsigned long reposition_time;
 };
 
 /*
@@ -113,8 +116,6 @@ struct cfq_entity {
 struct cfq_queue {
 	/* The schedule entity */
 	struct cfq_entity cfqe;
-	/* Reposition time */
-	unsigned long reposition_time;
 	/* reference count */
 	atomic_t ref;
 	/* various state flags, see below */
@@ -194,6 +195,9 @@ struct cfq_group {
 	/* number of cfqq currently on this group */
 	int nr_cfqq;
 
+	/* number of sub cfq groups */
+	int nr_subgp;
+
 	/*
 	 * Per group busy queus average. Useful for workload slice calc. We
 	 * create the array for each prio class but at run time it is used
@@ -229,8 +233,6 @@ struct cfq_group {
  */
 struct cfq_data {
 	struct request_queue *queue;
-	/* Root service tree for cfq_groups */
-	struct cfq_rb_root grp_service_tree;
 	struct cfq_group root_group;
 
 	/*
@@ -347,8 +349,6 @@ cfqg_of_entity(struct cfq_entity *cfqe)
 	return NULL;
 }
 
-static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
-
 static struct cfq_rb_root *service_tree_for(struct cfq_group *cfqg,
 					    enum wl_prio_t prio,
 					    enum wl_type_t type)
@@ -638,10 +638,15 @@ static inline unsigned cfq_group_get_avg_queues(struct cfq_data *cfqd,
 static inline unsigned
 cfq_group_slice(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
-	struct cfq_rb_root *st = &cfqd->grp_service_tree;
 	struct cfq_entity *cfqe = &cfqg->cfqe;
+	struct cfq_rb_root *st = cfqe->service_tree;
 
-	return cfq_target_latency * cfqe->weight / st->total_weight;
+	if (st)
+		return cfq_target_latency * cfqe->weight
+			/ st->total_weight;
+	else
+		/* If this is the root group, give it a full slice. */
+		return cfq_target_latency;
 }
 
 static inline void
@@ -804,17 +809,6 @@ static struct cfq_entity *cfq_rb_first(struct cfq_rb_root *root)
 	return NULL;
 }
 
-static struct cfq_entity *cfq_rb_first_entity(struct cfq_rb_root *root)
-{
-	if (!root->left)
-		root->left = rb_first(&root->rb);
-
-	if (root->left)
-		return rb_entry_entity(root->left);
-
-	return NULL;
-}
-
 static void rb_erase_init(struct rb_node *n, struct rb_root *root)
 {
 	rb_erase(n, root);
@@ -888,12 +882,15 @@ __cfq_entity_service_tree_add(struct cfq_rb_root *st, struct cfq_entity *cfqe)
 
 	rb_link_node(&cfqe->rb_node, parent, node);
 	rb_insert_color(&cfqe->rb_node, &st->rb);
+
+	update_min_vdisktime(st);
 }
 
 static void
 cfq_entity_service_tree_add(struct cfq_rb_root *st, struct cfq_entity *cfqe)
 {
 	__cfq_entity_service_tree_add(st, cfqe);
+	cfqe->reposition_time = jiffies;
 	st->count++;
 	st->total_weight += cfqe->weight;
 }
@@ -901,34 +898,57 @@ cfq_entity_service_tree_add(struct cfq_rb_root *st, struct cfq_entity *cfqe)
 static void
 cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
-	struct cfq_rb_root *st = &cfqd->grp_service_tree;
 	struct cfq_entity *cfqe = &cfqg->cfqe;
-	struct cfq_entity *__cfqe;
 	struct rb_node *n;
+	struct cfq_entity *entity;
+	struct cfq_rb_root *st;
+	struct cfq_group *__cfqg;
 
 	cfqg->nr_cfqq++;
+
+	/*
+	 * Root group doesn't belongs to any service
+	 */
+	if (cfqg == &cfqd->root_group)
+		return;
+
 	if (!RB_EMPTY_NODE(&cfqe->rb_node))
 		return;
 
 	/*
-	 * Currently put the group at the end. Later implement something
-	 * so that groups get lesser vtime based on their weights, so that
-	 * if group does not loose all if it was not continously backlogged.
+	 * Enqueue this group and its ancestors onto their service tree.
 	 */
-	n = rb_last(&st->rb);
-	if (n) {
-		__cfqe = rb_entry_entity(n);
-		cfqe->vdisktime = __cfqe->vdisktime + CFQ_IDLE_DELAY;
-	} else
-		cfqe->vdisktime = st->min_vdisktime;
+	while (cfqe && cfqe->parent) {
+		if (!RB_EMPTY_NODE(&cfqe->rb_node))
+			return;
+
+		/*
+		 * Currently put the group at the end. Later implement
+		 * something so that groups get lesser vtime based on their
+		 * weights, so that if group does not loose all if it was not
+		 * continously backlogged.
+		 */
+		st = cfqe->service_tree;
+		n = rb_last(&st->rb);
+		if (n) {
+			entity = rb_entry_entity(n);
+			cfqe->vdisktime = entity->vdisktime +
+				CFQ_IDLE_DELAY;
+		} else
+			cfqe->vdisktime = st->min_vdisktime;
 
-	cfq_entity_service_tree_add(st, cfqe);
+		cfq_entity_service_tree_add(st, cfqe);
+		cfqe = cfqe->parent;
+		__cfqg = cfqg_of_entity(cfqe);
+		__cfqg->nr_subgp++;
+	}
 }
 
 static void
 __cfq_entity_service_tree_del(struct cfq_rb_root *st, struct cfq_entity *cfqe)
 {
 	cfq_rb_erase(&cfqe->rb_node, st);
+	update_min_vdisktime(st);
 }
 
 static void
@@ -937,27 +957,47 @@ cfq_entity_service_tree_del(struct cfq_rb_root *st, struct cfq_entity *cfqe)
 	if (!RB_EMPTY_NODE(&cfqe->rb_node)) {
 		__cfq_entity_service_tree_del(st, cfqe);
 		st->total_weight -= cfqe->weight;
-		cfqe->service_tree = NULL;
 	}
 }
 
 static void
 cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
-	struct cfq_rb_root *st = &cfqd->grp_service_tree;
 	struct cfq_entity *cfqe = &cfqg->cfqe;
+	struct cfq_group *__cfqg, *p_cfqg;
 
 	BUG_ON(cfqg->nr_cfqq < 1);
 	cfqg->nr_cfqq--;
 
+	/*
+	 * Root group doesn't belongs to any service
+	 */
+	if (cfqg == &cfqd->root_group)
+		return;
+
 	/* If there are other cfq queues under this group, don't delete it */
 	if (cfqg->nr_cfqq)
 		return;
 
-	cfq_log_cfqg(cfqd, cfqg, "del_from_rr group");
-	cfq_entity_service_tree_del(st, cfqe);
-	cfqg->saved_workload_slice = 0;
-	cfq_blkiocg_update_dequeue_stats(&cfqg->blkg, 1);
+	/* If child group exists, don't dequeue it */
+	if (cfqg->nr_subgp)
+		return;
+
+	/*
+	 * Dequeue this group and its ancestors from their service tree.
+	 */
+	while (cfqe && cfqe->parent) {
+		__cfqg = cfqg_of_entity(cfqe);
+		p_cfqg = cfqg_of_entity(cfqe->parent);
+		cfq_entity_service_tree_del(cfqe->service_tree, cfqe);
+		cfq_blkiocg_update_dequeue_stats(&__cfqg->blkg, 1);
+		cfq_log_cfqg(cfqd, __cfqg, "del_from_rr group");
+		__cfqg->saved_workload_slice = 0;
+		cfqe = cfqe->parent;
+		p_cfqg->nr_subgp--;
+		if (p_cfqg->nr_cfqq || p_cfqg->nr_subgp)
+			return;
+	}
 }
 
 static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq)
@@ -989,7 +1029,6 @@ static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq)
 static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 				struct cfq_queue *cfqq)
 {
-	struct cfq_rb_root *st = &cfqd->grp_service_tree;
 	unsigned int used_sl, charge;
 	int nr_sync = cfqg->nr_cfqq - cfqg_busy_async_queues(cfqd, cfqg)
 			- cfqg->service_tree_idle.count;
@@ -1003,10 +1042,21 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 	else if (!cfq_cfqq_sync(cfqq) && !nr_sync)
 		charge = cfqq->allocated_slice;
 
-	/* Can't update vdisktime while group is on service tree */
-	__cfq_entity_service_tree_del(st, cfqe);
-	cfqe->vdisktime += cfq_scale_slice(charge, cfqe);
-	__cfq_entity_service_tree_add(st, cfqe);
+	/*
+	 * Update the vdisktime on the whole chain.
+	 */
+	while (cfqe && cfqe->parent) {
+		struct cfq_rb_root *st = cfqe->service_tree;
+
+		/* Can't update vdisktime while group is on service tree */
+		__cfq_entity_service_tree_del(st, cfqe);
+		cfqe->vdisktime += cfq_scale_slice(charge, cfqe);
+		__cfq_entity_service_tree_add(st, cfqe);
+		st->count++;
+		cfqe->reposition_time = jiffies;
+		cfqe = cfqe->parent;
+	}
+
 
 	/* This group is being expired. Save the context */
 	if (time_after(cfqd->workload_expires, jiffies)) {
@@ -1018,7 +1068,8 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 		cfqg->saved_workload_slice = 0;
 
 	cfq_log_cfqg(cfqd, cfqg, "served: vt=%llu min_vt=%llu",
-		     cfqe->vdisktime, st->min_vdisktime);
+		     cfqg->cfqe.vdisktime,
+		     cfqg->cfqe.service_tree->min_vdisktime);
 	cfq_log_cfqq(cfqq->cfqd, cfqq, "sl_used=%u disp=%u charge=%u iops=%u"
 			" sect=%u", used_sl, cfqq->slice_dispatch, charge,
 			iops_mode(cfqd), cfqq->nr_sectors);
@@ -1040,35 +1091,27 @@ void cfq_update_blkio_group_weight(void *key, struct blkio_group *blkg,
 	cfqg_of_blkg(blkg)->cfqe.weight = weight;
 }
 
-static struct cfq_group *
-cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
+static void init_cfqe(struct blkio_cgroup *blkcg,
+				    struct cfq_group *cfqg)
+{
+	struct cfq_entity *cfqe = &cfqg->cfqe;
+
+	cfqe->weight = blkcg_get_weight(blkcg, cfqg->blkg.dev);
+	RB_CLEAR_NODE(&cfqe->rb_node);
+	cfqe->is_group_entity = true;
+	cfqe->parent = NULL;
+}
+
+static void init_cfqg(struct cfq_data *cfqd, struct blkio_cgroup *blkcg,
+		      struct cfq_group *cfqg)
 {
-	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
-	struct cfq_group *cfqg = NULL;
-	void *key = cfqd;
 	int i, j;
 	struct cfq_rb_root *st;
-	struct backing_dev_info *bdi = &cfqd->queue->backing_dev_info;
 	unsigned int major, minor;
-
-	cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, key));
-	if (cfqg && !cfqg->blkg.dev && bdi->dev && dev_name(bdi->dev)) {
-		sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
-		cfqg->blkg.dev = MKDEV(major, minor);
-		goto done;
-	}
-	if (cfqg || !create)
-		goto done;
-
-	cfqg = kzalloc_node(sizeof(*cfqg), GFP_ATOMIC, cfqd->queue->node);
-	if (!cfqg)
-		goto done;
+	struct backing_dev_info *bdi = &cfqd->queue->backing_dev_info;
 
 	for_each_cfqg_st(cfqg, i, j, st)
 		*st = CFQ_RB_ROOT;
-	RB_CLEAR_NODE(&cfqg->cfqe.rb_node);
-
-	cfqg->cfqe.is_group_entity = true;
 
 	/*
 	 * Take the initial reference that will be released on destroy
@@ -1078,24 +1121,119 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 	 */
 	atomic_set(&cfqg->ref, 1);
 
+	/* Add group onto cgroup list */
+	sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
+	cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
+				    MKDEV(major, minor));
+	/* Initiate group entity */
+	init_cfqe(blkcg, cfqg);
+	/* Add group on cfqd list */
+	hlist_add_head(&cfqg->cfqd_node, &cfqd->cfqg_list);
+}
+
+static void cfq_destroy_cfqg(struct cfq_data *cfqd, struct cfq_group *cfqg);
+
+static void uninit_cfqg(struct cfq_data *cfqd, struct cfq_group *cfqg)
+{
+	if (!cfq_blkiocg_del_blkio_group(&cfqg->blkg))
+		cfq_destroy_cfqg(cfqd, cfqg);
+}
+
+static void cfqg_set_parent(struct cfq_data *cfqd, struct cfq_group *cfqg,
+			    struct cfq_group *p_cfqg)
+{
+	struct cfq_entity *cfqe, *p_cfqe;
+
+	cfqe = &cfqg->cfqe;
+
+	p_cfqe = &p_cfqg->cfqe;
+
+	cfqe->parent = p_cfqe;
+
 	/*
-	 * Add group onto cgroup list. It might happen that bdi->dev is
-	 * not initiliazed yet. Initialize this new group without major
-	 * and minor info and this info will be filled in once a new thread
-	 * comes for IO. See code above.
+	 * Currently, just put cfq group entity on "BE:SYNC" workload
+	 * service tree.
 	 */
-	if (bdi->dev) {
-		sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
-		cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
-					MKDEV(major, minor));
-	} else
-		cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
-					0);
+	cfqe->service_tree = service_tree_for(p_cfqg, BE_WORKLOAD,
+						      SYNC_WORKLOAD);
+	/* child reference */
+	atomic_inc(&p_cfqg->ref);
+}
 
-	cfqg->cfqe.weight = blkcg_get_weight(blkcg, cfqg->blkg.dev);
+int cfqg_chain_alloc(struct cfq_data *cfqd, struct cgroup *cgroup)
+{
+	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
+	struct blkio_cgroup *p_blkcg;
+	struct backing_dev_info *bdi = &cfqd->queue->backing_dev_info;
+	unsigned int major, minor;
+	struct cfq_group *cfqg, *p_cfqg;
+	void *key = cfqd;
+	int ret;
 
-	/* Add group on cfqd list */
-	hlist_add_head(&cfqg->cfqd_node, &cfqd->cfqg_list);
+	cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, key));
+	if (cfqg) {
+		if (!cfqg->blkg.dev && bdi->dev && dev_name(bdi->dev)) {
+			sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
+			cfqg->blkg.dev = MKDEV(major, minor);
+		}
+		/* chain has already been built */
+		return 0;
+	}
+
+	cfqg = kzalloc_node(sizeof(*cfqg), GFP_ATOMIC, cfqd->queue->node);
+	if (!cfqg)
+		return -1;
+
+	init_cfqg(cfqd, blkcg, cfqg);
+
+	/* Already to the top group */
+	if (!cgroup->parent)
+		return 0;
+
+	/* Allocate CFQ groups on the chain */
+	ret = cfqg_chain_alloc(cfqd, cgroup->parent);
+	if (ret == -1) {
+		uninit_cfqg(cfqd, cfqg);
+		return -1;
+	}
+
+	p_blkcg = cgroup_to_blkio_cgroup(cgroup->parent);
+	p_cfqg = cfqg_of_blkg(blkiocg_lookup_group(p_blkcg, key));
+	BUG_ON(p_cfqg == NULL);
+
+	cfqg_set_parent(cfqd, cfqg, p_cfqg);
+	return 0;
+}
+
+static struct cfq_group *
+cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
+{
+	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
+	struct cfq_group *cfqg = NULL;
+	void *key = cfqd;
+	struct backing_dev_info *bdi = &cfqd->queue->backing_dev_info;
+	unsigned int major, minor;
+	int ret;
+
+	cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, key));
+	if (cfqg && !cfqg->blkg.dev && bdi->dev && dev_name(bdi->dev)) {
+		sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
+		cfqg->blkg.dev = MKDEV(major, minor);
+		goto done;
+	}
+	if (cfqg || !create)
+		goto done;
+
+	/*
+	 * For hierarchical cfq group scheduling, we need to allocate
+	 * the whole cfq group chain.
+	 */
+	ret = cfqg_chain_alloc(cfqd, cgroup);
+	if (!ret) {
+		cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, key));
+		BUG_ON(cfqg == NULL);
+		goto done;
+	}
 
 done:
 	return cfqg;
@@ -1140,12 +1278,22 @@ static void cfq_put_cfqg(struct cfq_group *cfqg)
 {
 	struct cfq_rb_root *st;
 	int i, j;
+	struct cfq_entity *cfqe;
+	struct cfq_group *p_cfqg;
 
 	BUG_ON(atomic_read(&cfqg->ref) <= 0);
 	if (!atomic_dec_and_test(&cfqg->ref))
 		return;
 	for_each_cfqg_st(cfqg, i, j, st)
 		BUG_ON(!RB_EMPTY_ROOT(&st->rb));
+
+	cfqe = &cfqg->cfqe;
+	if (cfqe->parent) {
+		p_cfqg = cfqg_of_entity(cfqe->parent);
+		/* Drop the reference taken by children */
+		atomic_dec(&p_cfqg->ref);
+	}
+
 	kfree(cfqg);
 }
 
@@ -1358,8 +1506,6 @@ insert:
 	/* Add cfqq onto service tree. */
 	cfq_entity_service_tree_add(service_tree, cfqe);
 
-	update_min_vdisktime(service_tree);
-	cfqq->reposition_time = jiffies;
 	if ((add_front || !new_cfqq) && !group_changed)
 		return;
 	cfq_group_service_tree_add(cfqd, cfqq->cfqg);
@@ -1802,28 +1948,30 @@ static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 	return cfqq_of_entity(cfq_rb_first(service_tree));
 }
 
-static struct cfq_queue *cfq_get_next_queue_forced(struct cfq_data *cfqd)
+static struct cfq_entity *
+cfq_get_next_entity_forced(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
-	struct cfq_group *cfqg;
-	struct cfq_entity *cfqe;
+	struct cfq_entity *entity;
 	int i, j;
 	struct cfq_rb_root *st;
 
 	if (!cfqd->rq_queued)
 		return NULL;
 
-	cfqg = cfq_get_next_cfqg(cfqd);
-	if (!cfqg)
-		return NULL;
-
 	for_each_cfqg_st(cfqg, i, j, st) {
-		cfqe = cfq_rb_first(st);
-		if (cfqe != NULL)
-			return cfqq_of_entity(cfqe);
+		entity = cfq_rb_first(st);
+
+		if (entity && !entity->is_group_entity)
+			return entity;
+		else if (entity && entity->is_group_entity) {
+			cfqg = cfqg_of_entity(entity);
+			return cfq_get_next_entity_forced(cfqd, cfqg);
+		}
 	}
 	return NULL;
 }
 
+
 /*
  * Get and set a new active queue for service.
  */
@@ -2179,7 +2327,6 @@ static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
 				struct cfq_group *cfqg, enum wl_prio_t prio)
 {
 	struct cfq_entity *cfqe;
-	struct cfq_queue *cfqq;
 	unsigned long lowest_start_time;
 	int i;
 	bool time_valid = false;
@@ -2191,10 +2338,9 @@ static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
 	 */
 	for (i = 0; i <= SYNC_WORKLOAD; ++i) {
 		cfqe = cfq_rb_first(service_tree_for(cfqg, prio, i));
-		cfqq = cfqq_of_entity(cfqe);
 		if (cfqe && (!time_valid ||
-			     cfqq->reposition_time < lowest_start_time)) {
-			lowest_start_time = cfqq->reposition_time;
+			     cfqe->reposition_time < lowest_start_time)) {
+			lowest_start_time = cfqe->reposition_time;
 			cur_best = i;
 			time_valid = true;
 		}
@@ -2203,47 +2349,13 @@ static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
 	return cur_best;
 }
 
-static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
+static void set_workload_expire(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
 	unsigned slice;
 	unsigned count;
 	struct cfq_rb_root *st;
 	unsigned group_slice;
 
-	if (!cfqg) {
-		cfqd->serving_prio = IDLE_WORKLOAD;
-		cfqd->workload_expires = jiffies + 1;
-		return;
-	}
-
-	/* Choose next priority. RT > BE > IDLE */
-	if (cfq_group_busy_queues_wl(RT_WORKLOAD, cfqd, cfqg))
-		cfqd->serving_prio = RT_WORKLOAD;
-	else if (cfq_group_busy_queues_wl(BE_WORKLOAD, cfqd, cfqg))
-		cfqd->serving_prio = BE_WORKLOAD;
-	else {
-		cfqd->serving_prio = IDLE_WORKLOAD;
-		cfqd->workload_expires = jiffies + 1;
-		return;
-	}
-
-	/*
-	 * For RT and BE, we have to choose also the type
-	 * (SYNC, SYNC_NOIDLE, ASYNC), and to compute a workload
-	 * expiration time
-	 */
-	st = service_tree_for(cfqg, cfqd->serving_prio, cfqd->serving_type);
-	count = st->count;
-
-	/*
-	 * check workload expiration, and that we still have other queues ready
-	 */
-	if (count && !time_after(jiffies, cfqd->workload_expires))
-		return;
-
-	/* otherwise select new workload type */
-	cfqd->serving_type =
-		cfq_choose_wl(cfqd, cfqg, cfqd->serving_prio);
 	st = service_tree_for(cfqg, cfqd->serving_prio, cfqd->serving_type);
 	count = st->count;
 
@@ -2284,26 +2396,51 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	cfqd->workload_expires = jiffies + slice;
 }
 
-static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd)
+static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
-	struct cfq_rb_root *st = &cfqd->grp_service_tree;
-	struct cfq_group *cfqg;
-	struct cfq_entity *cfqe;
+	struct cfq_rb_root *st;
+	unsigned count;
 
-	if (RB_EMPTY_ROOT(&st->rb))
-		return NULL;
-	cfqe = cfq_rb_first_entity(st);
-	cfqg = cfqg_of_entity(cfqe);
-	BUG_ON(!cfqg);
-	update_min_vdisktime(st);
-	return cfqg;
+	if (!cfqg) {
+		cfqd->serving_prio = IDLE_WORKLOAD;
+		cfqd->workload_expires = jiffies + 1;
+		return;
+	}
+
+	/* Choose next priority. RT > BE > IDLE */
+	if (cfq_group_busy_queues_wl(RT_WORKLOAD, cfqd, cfqg))
+		cfqd->serving_prio = RT_WORKLOAD;
+	else if (cfq_group_busy_queues_wl(BE_WORKLOAD, cfqd, cfqg))
+		cfqd->serving_prio = BE_WORKLOAD;
+	else {
+		cfqd->serving_prio = IDLE_WORKLOAD;
+		cfqd->workload_expires = jiffies + 1;
+		return;
+	}
+
+	/*
+	 * For RT and BE, we have to choose also the type
+	 * (SYNC, SYNC_NOIDLE, ASYNC), and to compute a workload
+	 * expiration time
+	 */
+	st = service_tree_for(cfqg, cfqd->serving_prio, cfqd->serving_type);
+	count = st->count;
+
+	/*
+	 * check workload expiration, and that we still have other queues ready
+	 */
+	if (count && !time_after(jiffies, cfqd->workload_expires))
+		return;
+
+	/* otherwise select new workload type */
+	cfqd->serving_type =
+		cfq_choose_wl(cfqd, cfqg, cfqd->serving_prio);
 }
 
-static void cfq_choose_cfqg(struct cfq_data *cfqd)
+struct cfq_entity *choose_serving_entity(struct cfq_data *cfqd,
+					      struct cfq_group *cfqg)
 {
-	struct cfq_group *cfqg = cfq_get_next_cfqg(cfqd);
-
-	cfqd->serving_group = cfqg;
+	struct cfq_rb_root *service_tree;
 
 	/* Restore the workload type data */
 	if (cfqg->saved_workload_slice) {
@@ -2314,8 +2451,21 @@ static void cfq_choose_cfqg(struct cfq_data *cfqd)
 		cfqd->workload_expires = jiffies - 1;
 
 	choose_service_tree(cfqd, cfqg);
-}
 
+	service_tree = service_tree_for(cfqg, cfqd->serving_prio,
+					cfqd->serving_type);
+
+	if (!cfqd->rq_queued)
+		return NULL;
+
+	/* There is nothing to dispatch */
+	if (!service_tree)
+		return NULL;
+	if (RB_EMPTY_ROOT(&service_tree->rb))
+		return NULL;
+
+	return cfq_rb_first(service_tree);
+}
 /*
  * Select a queue for service. If we have a current active queue,
  * check whether to continue servicing it, or retrieve and set a new one.
@@ -2323,6 +2473,8 @@ static void cfq_choose_cfqg(struct cfq_data *cfqd)
 static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 {
 	struct cfq_queue *cfqq, *new_cfqq = NULL;
+	struct cfq_group *cfqg;
+	struct cfq_entity *entity;
 
 	cfqq = cfqd->active_queue;
 	if (!cfqq)
@@ -2422,8 +2574,23 @@ new_queue:
 	 * Current queue expired. Check if we have to switch to a new
 	 * service tree
 	 */
-	if (!new_cfqq)
-		cfq_choose_cfqg(cfqd);
+	cfqg = &cfqd->root_group;
+
+	if (!new_cfqq) {
+		do {
+			entity = choose_serving_entity(cfqd, cfqg);
+			if (entity && !entity->is_group_entity) {
+				/* This is the CFQ queue that should run */
+				new_cfqq = cfqq_of_entity(entity);
+				cfqd->serving_group = cfqg;
+				set_workload_expire(cfqd, cfqg);
+				break;
+			} else if (entity && entity->is_group_entity) {
+				/* Continue to lookup in this CFQ group */
+				cfqg = cfqg_of_entity(entity);
+			}
+		} while (entity && entity->is_group_entity);
+	}
 
 	cfqq = cfq_set_active_queue(cfqd, new_cfqq);
 keep_queue:
@@ -2454,10 +2621,14 @@ static int cfq_forced_dispatch(struct cfq_data *cfqd)
 {
 	struct cfq_queue *cfqq;
 	int dispatched = 0;
+	struct cfq_entity *entity;
+	struct cfq_group *root = &cfqd->root_group;
 
 	/* Expire the timeslice of the current active queue first */
 	cfq_slice_expired(cfqd, 0);
-	while ((cfqq = cfq_get_next_queue_forced(cfqd)) != NULL) {
+	while ((entity = cfq_get_next_entity_forced(cfqd, root)) != NULL) {
+		BUG_ON(entity->is_group_entity);
+		cfqq = cfqq_of_entity(entity);
 		__cfq_set_active_queue(cfqd, cfqq);
 		dispatched += __cfq_forced_dispatch_cfqq(cfqq);
 	}
@@ -3991,9 +4162,6 @@ static void *cfq_init_queue(struct request_queue *q)
 
 	cfqd->cic_index = i;
 
-	/* Init root service tree */
-	cfqd->grp_service_tree = CFQ_RB_ROOT;
-
 	/* Init root group */
 	cfqg = &cfqd->root_group;
 	for_each_cfqg_st(cfqg, i, j, st)
@@ -4003,6 +4171,7 @@ static void *cfq_init_queue(struct request_queue *q)
 	/* Give preference to root group over other groups */
 	cfqg->cfqe.weight = 2*BLKIO_WEIGHT_DEFAULT;
 	cfqg->cfqe.is_group_entity = true;
+	cfqg->cfqe.parent = NULL;
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 	/*
-- 
1.6.5.2



