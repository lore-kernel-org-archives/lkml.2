Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab1BWDKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 22:10:42 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51638 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753561Ab1BWDKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 22:10:41 -0500
Message-ID: <4D647A99.7080703@cn.fujitsu.com>
Date: Wed, 23 Feb 2011 11:10:17 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>
CC: Justin TerAvest <teravest@google.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        Chad Talbott <ctalbott@google.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/6 v5.1] cfq-iosched: CFQ group hierarchical scheduling and
 use_hierarchy interface.
References: <4D61FE91.60705@cn.fujitsu.com> <4D6201A3.70301@cn.fujitsu.com> <4D64788F.6040408@cn.fujitsu.com>
In-Reply-To: <4D64788F.6040408@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-23 11:09:31,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-23 11:09:34,
	Serialize complete at 2011-02-23 11:09:34
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CFQ group hierarchical scheduling and use_hierarchy interface.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/blk-cgroup.c  |   61 +++++-
 block/blk-cgroup.h  |    3 +
 block/cfq-iosched.c |  596 +++++++++++++++++++++++++++++++++++++--------------
 3 files changed, 496 insertions(+), 164 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 455768a..c55fecd 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -25,7 +25,10 @@
 static DEFINE_SPINLOCK(blkio_list_lock);
 static LIST_HEAD(blkio_list);
 
-struct blkio_cgroup blkio_root_cgroup = { .weight = 2*BLKIO_WEIGHT_DEFAULT };
+struct blkio_cgroup blkio_root_cgroup = {
+	.weight = 2*BLKIO_WEIGHT_DEFAULT,
+	.use_hierarchy = 0
+};
 EXPORT_SYMBOL_GPL(blkio_root_cgroup);
 
 static struct cgroup_subsys_state *blkiocg_create(struct cgroup_subsys *,
@@ -454,6 +457,7 @@ static void __blkiocg_del_blkio_group(struct blkio_group *blkg)
 	blkg->blkcg_id = 0;
 }
 
+
 /*
  * returns 0 if blkio_group was still on cgroup list. Otherwise returns 1
  * indicating that blk_group was unhashed by the time we got to it.
@@ -765,6 +769,12 @@ unsigned int blkcg_get_weight(struct blkio_cgroup *blkcg,
 }
 EXPORT_SYMBOL_GPL(blkcg_get_weight);
 
+unsigned int blkcg_get_use_hierarchy(struct blkio_cgroup *blkcg)
+{
+	return blkcg->use_hierarchy;
+}
+EXPORT_SYMBOL_GPL(blkcg_get_use_hierarchy);
+
 uint64_t blkcg_get_read_bps(struct blkio_cgroup *blkcg, dev_t dev)
 {
 	struct blkio_policy_node *pn;
@@ -1202,6 +1212,8 @@ static u64 blkiocg_file_read_u64 (struct cgroup *cgrp, struct cftype *cft) {
 		switch(name) {
 		case BLKIO_PROP_weight:
 			return (u64)blkcg->weight;
+		case BLKIO_PROP_use_hierarchy:
+			return (u64)blkcg->use_hierarchy;
 		}
 		break;
 	default:
@@ -1210,6 +1222,36 @@ static u64 blkiocg_file_read_u64 (struct cgroup *cgrp, struct cftype *cft) {
 	return 0;
 }
 
+static int blkio_use_hierarchy_write(struct cgroup *cgrp, u64 val)
+{
+	struct cgroup *parent = cgrp->parent;
+	struct blkio_cgroup *blkcg, *parent_blkcg = NULL;
+	int ret = 0;
+
+	if (val != 0 && val != 1)
+		return -EINVAL;
+
+	blkcg = cgroup_to_blkio_cgroup(cgrp);
+	if (parent)
+		parent_blkcg = cgroup_to_blkio_cgroup(parent);
+
+	cgroup_lock();
+	/*
+	 * If parent's use_hierarchy is set, we can't make any modifications
+	 * in the child subtrees. If it is unset, then the change can occur,
+	 * provided the current cgroup has no children.
+	 */
+	if (!parent_blkcg || !parent_blkcg->use_hierarchy) {
+		if (list_empty(&cgrp->children))
+			blkcg->use_hierarchy = val;
+		else
+			ret = -EBUSY;
+	} else
+		ret = -EINVAL;
+	cgroup_unlock();
+	return ret;
+}
+
 static int
 blkiocg_file_write_u64(struct cgroup *cgrp, struct cftype *cft, u64 val)
 {
@@ -1224,6 +1266,8 @@ blkiocg_file_write_u64(struct cgroup *cgrp, struct cftype *cft, u64 val)
 		switch(name) {
 		case BLKIO_PROP_weight:
 			return blkio_weight_write(blkcg, val);
+		case BLKIO_PROP_use_hierarchy:
+			return blkio_use_hierarchy_write(cgrp, val);
 		}
 		break;
 	default:
@@ -1301,6 +1345,13 @@ struct cftype blkio_files[] = {
 		.name = "reset_stats",
 		.write_u64 = blkiocg_reset_stats,
 	},
+	{
+		.name = "use_hierarchy",
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
+					     BLKIO_PROP_use_hierarchy),
+		.read_u64 = blkiocg_file_read_u64,
+		.write_u64 = blkiocg_file_write_u64,
+	},
 #ifdef CONFIG_BLK_DEV_THROTTLING
 	{
 		.name = "throttle.read_bps_device",
@@ -1444,7 +1495,7 @@ static void blkiocg_destroy(struct cgroup_subsys *subsys, struct cgroup *cgroup)
 static struct cgroup_subsys_state *
 blkiocg_create(struct cgroup_subsys *subsys, struct cgroup *cgroup)
 {
-	struct blkio_cgroup *blkcg;
+	struct blkio_cgroup *blkcg, *parent_blkcg = NULL;
 	struct cgroup *parent = cgroup->parent;
 
 	if (!parent) {
@@ -1452,6 +1503,7 @@ blkiocg_create(struct cgroup_subsys *subsys, struct cgroup *cgroup)
 		goto done;
 	}
 
+	parent_blkcg = cgroup_to_blkio_cgroup(parent);
 	blkcg = kzalloc(sizeof(*blkcg), GFP_KERNEL);
 	if (!blkcg)
 		return ERR_PTR(-ENOMEM);
@@ -1462,6 +1514,11 @@ done:
 	INIT_HLIST_HEAD(&blkcg->blkg_list);
 
 	INIT_LIST_HEAD(&blkcg->policy_list);
+	if (parent)
+		blkcg->use_hierarchy = parent_blkcg->use_hierarchy;
+	else
+		blkcg->use_hierarchy = 0;
+
 	return &blkcg->css;
 }
 
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index ea4861b..5b4b351 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -90,6 +90,7 @@ enum blkcg_file_name_prop {
 	BLKIO_PROP_idle_time,
 	BLKIO_PROP_empty_time,
 	BLKIO_PROP_dequeue,
+	BLKIO_PROP_use_hierarchy,
 };
 
 /* cgroup files owned by throttle policy */
@@ -105,6 +106,7 @@ enum blkcg_file_name_throtl {
 struct blkio_cgroup {
 	struct cgroup_subsys_state css;
 	unsigned int weight;
+	bool use_hierarchy;
 	spinlock_t lock;
 	struct hlist_head blkg_list;
 	struct list_head policy_list; /* list of blkio_policy_node */
@@ -179,6 +181,7 @@ struct blkio_policy_node {
 
 extern unsigned int blkcg_get_weight(struct blkio_cgroup *blkcg,
 				     dev_t dev);
+extern unsigned int blkcg_get_use_hierarchy(struct blkio_cgroup *blkcg);
 extern uint64_t blkcg_get_read_bps(struct blkio_cgroup *blkcg,
 				     dev_t dev);
 extern uint64_t blkcg_get_write_bps(struct blkio_cgroup *blkcg,
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index d10f776..380d667 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -110,6 +110,9 @@ struct cfq_entity {
 	u64 vdisktime;
 	bool is_group_entity;
 	unsigned int weight;
+	struct cfq_entity *parent;
+	/* Position time */
+	unsigned long position_time;
 };
 
 /*
@@ -118,8 +121,6 @@ struct cfq_entity {
 struct cfq_queue {
 	/* The schedule entity */
 	struct cfq_entity cfqe;
-	/* Position time */
-	unsigned long position_time;
 	/* reference count */
 	int ref;
 	/* various state flags, see below */
@@ -199,6 +200,9 @@ struct cfq_group {
 	/* number of cfqq currently on this group */
 	int nr_cfqq;
 
+	/* number of sub cfq groups */
+	int nr_subgp;
+
 	/*
 	 * Per group busy queus average. Useful for workload slice calc. We
 	 * create the array for each prio class but at run time it is used
@@ -234,8 +238,6 @@ struct cfq_group {
  */
 struct cfq_data {
 	struct request_queue *queue;
-	/* Root service tree for cfq_groups */
-	struct cfq_rb_root grp_service_tree;
 	struct cfq_group root_group;
 
 	/*
@@ -247,6 +249,12 @@ struct cfq_data {
 	struct cfq_group *serving_group;
 
 	/*
+	 * Both flat mode and hierarchical mode start from the service
+	 * tree here.
+	 */
+	struct cfq_rb_root grp_service_tree;
+
+	/*
 	 * Each priority tree is sorted by next_request position.  These
 	 * trees are used when determining if two or more queues are
 	 * interleaving requests (see cfq_close_cooperator).
@@ -355,8 +363,6 @@ cfqg_of_entity(struct cfq_entity *cfqe)
 }
 
 
-static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
-
 static struct cfq_rb_root *service_tree_for(struct cfq_group *cfqg,
 					    enum wl_prio_t prio,
 					    enum wl_type_t type)
@@ -643,13 +649,50 @@ static inline unsigned cfq_group_get_avg_queues(struct cfq_data *cfqd,
 	return cfqg->busy_queues_avg[rt];
 }
 
+static inline unsigned int
+cfq_group_get_total_weight(struct cfq_group *cfqg)
+{
+	int i, j;
+	struct cfq_rb_root *st;
+	unsigned int total_weight = 0;
+
+	for_each_cfqg_st(cfqg, i, j, st) {
+		total_weight += st->total_weight;
+	}
+
+	return total_weight;
+}
+
 static inline unsigned
 cfq_group_slice(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
-	struct cfq_rb_root *st = &cfqd->grp_service_tree;
 	struct cfq_entity *cfqe = &cfqg->cfqe;
+	struct cfq_rb_root *st;
+	int group_slice = cfq_target_latency;
+	unsigned int grp_total_weight;
+	struct cfq_group *p_cfqg;
+
+	/*
+	 * Calculate group slice in a hierarchical way.
+	 * Note, the calculation is cross all service trees under a group.
+	 */
+	do {
+		if (cfqe->parent) {
+			p_cfqg = cfqg_of_entity(cfqe->parent);
+			grp_total_weight = cfq_group_get_total_weight(p_cfqg);
+			group_slice = group_slice * cfqe->weight /
+					grp_total_weight;
+		} else {
+			/* For top level groups */
+			st = cfqe->service_tree;
+			group_slice = group_slice * cfqe->weight /
+					st->total_weight;
+		}
+
+		cfqe = cfqe->parent;
+	} while (cfqe);
 
-	return cfq_target_latency * cfqe->weight / st->total_weight;
+	return group_slice;
 }
 
 static inline unsigned
@@ -672,7 +715,8 @@ cfq_scaled_cfqq_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 			/* scale low_slice according to IO priority
 			 * and sync vs async */
 			unsigned low_slice =
-				min(slice, base_low_slice * slice / sync_slice);
+				min(slice, base_low_slice * slice /
+				    sync_slice);
 			/* the adapted slice value is scaled to fit all iqs
 			 * into the target latency */
 			slice = max(slice * group_slice / expect_latency,
@@ -820,17 +864,6 @@ static struct cfq_entity *cfq_rb_first(struct cfq_rb_root *root)
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
@@ -904,12 +937,15 @@ __cfq_entity_service_tree_add(struct cfq_rb_root *st, struct cfq_entity *cfqe)
 
 	rb_link_node(&cfqe->rb_node, parent, node);
 	rb_insert_color(&cfqe->rb_node, &st->rb);
+
+	update_min_vdisktime(st);
 }
 
 static void
 cfq_entity_service_tree_add(struct cfq_rb_root *st, struct cfq_entity *cfqe)
 {
 	__cfq_entity_service_tree_add(st, cfqe);
+	cfqe->position_time = jiffies;
 	st->count++;
 	st->total_weight += cfqe->weight;
 }
@@ -917,34 +953,52 @@ cfq_entity_service_tree_add(struct cfq_rb_root *st, struct cfq_entity *cfqe)
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
+	while (cfqe) {
+		if (!RB_EMPTY_NODE(&cfqe->rb_node))
+			return;
+
+		/*
+		 * Currently put the group at the end. Later implement
+		 * something so that groups get lesser vtime based on
+		 * their weights, so that if group does not loose all
+		 * if it was not continously backlogged.
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
+		if (__cfqg)
+			__cfqg->nr_subgp++;
+	}
 }
 
 static void
 __cfq_entity_service_tree_del(struct cfq_rb_root *st, struct cfq_entity *cfqe)
 {
 	cfq_rb_erase(&cfqe->rb_node, st);
+	update_min_vdisktime(st);
 }
 
 static void
@@ -953,27 +1007,43 @@ cfq_entity_service_tree_del(struct cfq_rb_root *st, struct cfq_entity *cfqe)
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
 
-	/* If there are other cfq queues under this group, don't delete it */
-	if (cfqg->nr_cfqq)
+	/*
+	 * If there are other cfq queues under this group, or there are other
+	 * cfq groups under this group, don't delete it.
+	 */
+	if (cfqg->nr_cfqq || cfqg->nr_subgp)
 		return;
 
-	cfq_log_cfqg(cfqd, cfqg, "del_from_rr group");
-	cfq_entity_service_tree_del(st, cfqe);
-	cfqg->saved_workload_slice = 0;
-	cfq_blkiocg_update_dequeue_stats(&cfqg->blkg, 1);
+	/*
+	 * Dequeue this group and its ancestors from their service
+	 * tree.
+	 */
+	while (cfqe) {
+		__cfqg = cfqg_of_entity(cfqe);
+		p_cfqg = cfqg_of_entity(cfqe->parent);
+		cfq_entity_service_tree_del(cfqe->service_tree, cfqe);
+		cfq_blkiocg_update_dequeue_stats(&__cfqg->blkg, 1);
+		cfq_log_cfqg(cfqd, __cfqg, "del_from_rr group");
+		__cfqg->saved_workload_slice = 0;
+		cfqe = cfqe->parent;
+		if (p_cfqg) {
+			p_cfqg->nr_subgp--;
+			if (p_cfqg->nr_cfqq || p_cfqg->nr_subgp)
+				return;
+		}
+	}
 }
 
 static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq)
@@ -1005,7 +1075,6 @@ static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq)
 static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 				struct cfq_queue *cfqq)
 {
-	struct cfq_rb_root *st = &cfqd->grp_service_tree;
 	unsigned int used_sl, charge;
 	int nr_sync = cfqg->nr_cfqq - cfqg_busy_async_queues(cfqd, cfqg)
 			- cfqg->service_tree_idle.count;
@@ -1019,10 +1088,23 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 	else if (!cfq_cfqq_sync(cfqq) && !nr_sync)
 		charge = cfqq->allocated_slice;
 
-	/* Can't update vdisktime while group is on service tree */
-	__cfq_entity_service_tree_del(st, cfqe);
-	cfqe->vdisktime += cfq_scale_slice(charge, cfqe);
-	__cfq_entity_service_tree_add(st, cfqe);
+	/*
+	 * Update the vdisktime on the whole chain.
+	 */
+	while (cfqe) {
+		struct cfq_rb_root *st = cfqe->service_tree;
+
+		/*
+		 * Can't update vdisktime while group is on service
+		 * tree.
+		 */
+		__cfq_entity_service_tree_del(st, cfqe);
+		cfqe->vdisktime += cfq_scale_slice(charge, cfqe);
+		__cfq_entity_service_tree_add(st, cfqe);
+		st->count++;
+		cfqe->position_time = jiffies;
+		cfqe = cfqe->parent;
+	}
 
 	/* This group is being expired. Save the context */
 	if (time_after(cfqd->workload_expires, jiffies)) {
@@ -1034,7 +1116,8 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 		cfqg->saved_workload_slice = 0;
 
 	cfq_log_cfqg(cfqd, cfqg, "served: vt=%llu min_vt=%llu",
-		     cfqe->vdisktime, st->min_vdisktime);
+		     cfqg->cfqe.vdisktime,
+		     cfqg->cfqe.service_tree->min_vdisktime);
 	cfq_log_cfqq(cfqq->cfqd, cfqq, "sl_used=%u disp=%u charge=%u iops=%u"
 			" sect=%u", used_sl, cfqq->slice_dispatch, charge,
 			iops_mode(cfqd), cfqq->nr_sectors);
@@ -1056,35 +1139,27 @@ void cfq_update_blkio_group_weight(void *key, struct blkio_group *blkg,
 	cfqg_of_blkg(blkg)->cfqe.weight = weight;
 }
 
-static struct cfq_group *
-cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
+static void init_group_cfqe(struct blkio_cgroup *blkcg,
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
@@ -1094,24 +1169,195 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 	 */
 	cfqg->ref = 1;
 
+	/* Add group onto cgroup list */
+	sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
+	cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
+				    MKDEV(major, minor));
+	/* Initiate group entity */
+	init_group_cfqe(blkcg, cfqg);
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
 	/*
-	 * Add group onto cgroup list. It might happen that bdi->dev is
-	 * not initialized yet. Initialize this new group without major
-	 * and minor info and this info will be filled in once a new thread
-	 * comes for IO. See code above.
+	 * 1. If use_hierarchy of the CGroup where cfqg's parent stays is not
+	 *    set, we put this cfqg onto global service tree.
+	 * 2. If cfqg is root cfqg, put it onto global service tree.
 	 */
-	if (bdi->dev) {
-		sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
-		cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
-					MKDEV(major, minor));
-	} else
-		cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
-					0);
+	if (!p_cfqg) {
+		cfqe->service_tree = &cfqd->grp_service_tree;
+		cfqe->parent = NULL;
+		return;
+	}
 
-	cfqg->cfqe.weight = blkcg_get_weight(blkcg, cfqg->blkg.dev);
+	p_cfqe = &p_cfqg->cfqe;
 
-	/* Add group on cfqd list */
-	hlist_add_head(&cfqg->cfqd_node, &cfqd->cfqg_list);
+	cfqe->parent = p_cfqe;
+
+	/*
+	 * Currently, just put cfq group entity on "BE:SYNC" workload
+	 * service tree.
+	 */
+	cfqe->service_tree = service_tree_for(p_cfqg, BE_WORKLOAD,
+					      SYNC_WORKLOAD);
+
+	/* child reference */
+	p_cfqg->ref++;
+}
+
+static struct cfq_group *cfqg_get_parent(struct cfq_group * cfqg)
+{
+	struct cfq_entity *cfqe, *p_cfqe;
+
+	if (!cfqg)
+		return NULL;
+
+	cfqe = &cfqg->cfqe;
+	p_cfqe = cfqe->parent;
+	if (!p_cfqe)
+		return NULL;
+
+	return cfqg_of_entity(p_cfqe);
+}
+
+static struct cfq_group *
+cfqg_chain_alloc(struct cfq_data *cfqd, struct cgroup *cgroup)
+{
+	struct blkio_cgroup *blkcg;
+	struct backing_dev_info *bdi = &cfqd->queue->backing_dev_info;
+	unsigned int major, minor;
+	struct cfq_group *cfqg, *leaf_cfqg, *child_cfqg, *tmp_cfqg;
+	void *key = cfqd;
+
+	/*
+	 * If CGroup's use_hierarchy is unset, we just need to allocate only
+	 * one CFQ group, and this group will put onto the "grp_service_tree".
+	 * We don't need to check whether the cfqg exists, the caller has
+	 * already checked it.
+	 */
+	blkcg = cgroup_to_blkio_cgroup(cgroup);
+	if (!blkcg_get_use_hierarchy(blkcg)) {
+		cfqg = kzalloc_node(sizeof(*cfqg), GFP_ATOMIC,
+				    cfqd->queue->node);
+		if (!cfqg)
+			return NULL;
+
+		init_cfqg(cfqd, blkcg, cfqg);
+		cfqg_set_parent(cfqd, cfqg, NULL);
+		return cfqg;
+	}
+
+	/*
+	 * Allocate the CFQ group chain until we meet the group we'v already
+	 * allocated before, or to the CGroup whose use_hierarchy is not set.
+	 */
+	leaf_cfqg = NULL;
+	child_cfqg = NULL;
+	for (; cgroup != NULL; cgroup = cgroup->parent) {
+		blkcg = cgroup_to_blkio_cgroup(cgroup);
+		cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, key));
+		if (cfqg) {
+			if (!cfqg->blkg.dev && bdi->dev &&
+			    dev_name(bdi->dev)) {
+				sscanf(dev_name(bdi->dev), "%u:%u",
+				       &major, &minor);
+				cfqg->blkg.dev = MKDEV(major, minor);
+			}
+			/*
+			 * Initialization of parent doesn't finish yet, get
+			 * it done.
+			 */
+			if (child_cfqg) {
+				if (blkcg_get_use_hierarchy(blkcg))
+					cfqg_set_parent(cfqd, child_cfqg,
+							cfqg);
+				else
+					cfqg_set_parent(cfqd, child_cfqg,
+							NULL);
+			}
+
+			/* chain has already been built */
+			break;
+		}
+		/*
+		 * We only allocate a cfqg that the corresponding cgroup's
+		 * use_hierarchy is set.
+		 */
+		if (blkcg_get_use_hierarchy(blkcg)) {
+			cfqg = kzalloc_node(sizeof(*cfqg), GFP_ATOMIC,
+					    cfqd->queue->node);
+			if (!cfqg)
+				goto clean_up;
+			if (!leaf_cfqg)
+				leaf_cfqg = cfqg;
+			init_cfqg(cfqd, blkcg, cfqg);
+		} else {
+			cfqg = NULL;
+		}
+
+		if (child_cfqg)
+			cfqg_set_parent(cfqd, child_cfqg, cfqg);
+
+		/*
+		 * This CGroup's use_hierarchy isn't set, this means the CFQ
+		 * group chain has been built.
+		 */
+		if (!blkcg_get_use_hierarchy(blkcg))
+			break;
+
+		child_cfqg = cfqg;
+	}
+
+	return leaf_cfqg;
+
+clean_up:
+	/* clean up the allocated cfq groups. */
+	while (leaf_cfqg) {
+		tmp_cfqg = leaf_cfqg;
+		leaf_cfqg = cfqg_get_parent(leaf_cfqg);
+		uninit_cfqg(cfqd, tmp_cfqg);
+	}
+	return NULL;
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
+	 * Allocate CFQ group chain to the root group or we meet the CGroup
+	 * with use_hierarchy disabled.
+	 */
+	cfqg = cfqg_chain_alloc(cfqd, cgroup);
 
 done:
 	return cfqg;
@@ -1156,6 +1402,7 @@ static void cfq_put_cfqg(struct cfq_group *cfqg)
 {
 	struct cfq_rb_root *st;
 	int i, j;
+	struct cfq_group *p_cfqg;
 
 	BUG_ON(cfqg->ref <= 0);
 	cfqg->ref--;
@@ -1163,6 +1410,22 @@ static void cfq_put_cfqg(struct cfq_group *cfqg)
 		return;
 	for_each_cfqg_st(cfqg, i, j, st)
 		BUG_ON(!RB_EMPTY_ROOT(&st->rb));
+
+	do {
+		p_cfqg = cfqg_get_parent(cfqg);
+		kfree(cfqg);
+		cfqg = NULL;
+		/*
+		 * Drop the reference taken by children, if nobody references
+		 * parent group, we need delete the parent also.
+		 */
+		if (p_cfqg) {
+			p_cfqg->ref--;
+			if (p_cfqg->ref == 0)
+				cfqg = p_cfqg;
+		}
+	} while (cfqg);
+
 	kfree(cfqg);
 }
 
@@ -1364,9 +1627,8 @@ insert:
 	cfqe->service_tree = service_tree;
 
 	/* Add cfqq onto service tree. */
+
 	cfq_entity_service_tree_add(service_tree, cfqe);
-	update_min_vdisktime(service_tree);
-	cfqq->position_time = jiffies;
 	if ((add_front || !new_cfqq) && !group_changed)
 		return;
 	cfq_group_service_tree_add(cfqd, cfqq->cfqg);
@@ -1812,28 +2074,43 @@ static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 	return cfqq_of_entity(cfq_rb_first(service_tree));
 }
 
-static struct cfq_queue *cfq_get_next_queue_forced(struct cfq_data *cfqd)
+struct cfq_rb_root *choose_service_tree_forced(struct cfq_group *cfqg)
 {
-	struct cfq_group *cfqg;
-	struct cfq_entity *cfqe;
 	int i, j;
 	struct cfq_rb_root *st;
 
-	if (!cfqd->rq_queued)
-		return NULL;
+	for_each_cfqg_st(cfqg, i, j, st) {
+		if (st->count != 0)
+			return st;
+	}
 
-	cfqg = cfq_get_next_cfqg(cfqd);
-	if (!cfqg)
+	return NULL;
+}
+
+static struct cfq_entity *
+cfq_get_next_entity_forced(struct cfq_data *cfqd)
+{
+	struct cfq_entity *cfqe;
+	struct cfq_rb_root *st = &cfqd->grp_service_tree;
+	struct cfq_group *cfqg;
+
+	if (!cfqd->rq_queued)
 		return NULL;
 
-	for_each_cfqg_st(cfqg, i, j, st) {
+	do {
 		cfqe = cfq_rb_first(st);
-		if (cfqe != NULL)
-			return cfqq_of_entity(cfqe);
-	}
+		if (cfqe && !cfqe->is_group_entity)
+			return cfqe;
+		else if (cfqe && cfqe->is_group_entity)
+			cfqg = cfqg_of_entity(cfqe);
+
+		st = choose_service_tree_forced(cfqg);
+	} while (st);
+
 	return NULL;
 }
 
+
 /*
  * Get and set a new active queue for service.
  */
@@ -2189,7 +2466,6 @@ static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
 				struct cfq_group *cfqg, enum wl_prio_t prio)
 {
 	struct cfq_entity *cfqe;
-	struct cfq_queue *cfqq;
 	unsigned long lowest_start_time;
 	int i;
 	bool time_valid = false;
@@ -2202,11 +2478,10 @@ static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
 	 */
 	for (i = 0; i <= SYNC_WORKLOAD; ++i) {
 		cfqe = cfq_rb_first(service_tree_for(cfqg, prio, i));
-		cfqq = cfqq_of_entity(cfqe);
 		if (cfqe && (!time_valid ||
-			     time_before(cfqq->position_time,
+			     time_before(cfqe->position_time,
 					 lowest_start_time))) {
-			lowest_start_time = cfqq->position_time;
+			lowest_start_time = cfqe->position_time;
 			cur_best = i;
 			time_valid = true;
 		}
@@ -2215,46 +2490,13 @@ static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
 	return cur_best;
 }
 
-static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
+static void set_workload_expire(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
 	unsigned slice;
 	unsigned count;
 	struct cfq_rb_root *st;
 	unsigned group_slice;
-	enum wl_prio_t original_prio = cfqd->serving_prio;
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
-	if (original_prio != cfqd->serving_prio)
-		goto new_workload;
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
 
-new_workload:
-	/* otherwise select new workload type */
-	cfqd->serving_type =
-		cfq_choose_wl(cfqd, cfqg, cfqd->serving_prio);
 	st = service_tree_for(cfqg, cfqd->serving_prio, cfqd->serving_type);
 	count = st->count;
 
@@ -2293,38 +2535,63 @@ new_workload:
 	slice = max_t(unsigned, slice, CFQ_MIN_TT);
 	cfq_log(cfqd, "workload slice:%d", slice);
 	cfqd->workload_expires = jiffies + slice;
+	/* Restore the previous saved slice. */
+	if (cfqg->saved_workload_slice)
+		cfqd->workload_expires = jiffies + cfqg->saved_workload_slice;
 }
 
-static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd)
+static struct cfq_rb_root *choose_service_tree(struct cfq_data *cfqd,
+					       struct cfq_group *cfqg)
 {
-	struct cfq_rb_root *st = &cfqd->grp_service_tree;
-	struct cfq_group *cfqg;
-	struct cfq_entity *cfqe;
-
-	if (RB_EMPTY_ROOT(&st->rb))
+	if (!cfqg) {
+		cfqd->serving_prio = IDLE_WORKLOAD;
+		cfqd->workload_expires = jiffies + 1;
 		return NULL;
-	cfqe = cfq_rb_first_entity(st);
-	cfqg = cfqg_of_entity(cfqe);
-	BUG_ON(!cfqg);
-	update_min_vdisktime(st);
-	return cfqg;
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
+		return service_tree_for(cfqg, cfqd->serving_prio,
+					cfqd->serving_type);
+	}
+
+	/* otherwise select new workload type */
+	cfqd->serving_type =
+		cfq_choose_wl(cfqd, cfqg, cfqd->serving_prio);
+
+	return service_tree_for(cfqg, cfqd->serving_prio, cfqd->serving_type);
 }
 
-static void cfq_choose_cfqg(struct cfq_data *cfqd)
+static struct cfq_entity *cfq_select_entity(struct cfq_data *cfqd)
 {
-	struct cfq_group *cfqg = cfq_get_next_cfqg(cfqd);
+	struct cfq_rb_root *st = &cfqd->grp_service_tree;
+	struct cfq_entity *cfqe;
+	struct cfq_group *cfqg = NULL;
 
-	cfqd->serving_group = cfqg;
+	if (!cfqd->rq_queued)
+		return NULL;
 
-	/* Restore the workload type data */
-	if (cfqg->saved_workload_slice) {
-		cfqd->workload_expires = jiffies + cfqg->saved_workload_slice;
-		cfqd->serving_type = cfqg->saved_workload;
-		cfqd->serving_prio = cfqg->saved_serving_prio;
-	} else
-		cfqd->workload_expires = jiffies - 1;
+	do {
+		cfqe = cfq_rb_first(st);
+		if (!cfqe->is_group_entity) {
+			set_workload_expire(cfqd, cfqg);
+			cfqd->serving_group = cfqg;
+			return cfqe;
+		} else {
+			cfqg = cfqg_of_entity(cfqe);
+			st = choose_service_tree(cfqd, cfqg);
+			if (!st || RB_EMPTY_ROOT(&st->rb))
+				return NULL;
+		}
+	} while (st);
 
-	choose_service_tree(cfqd, cfqg);
+	return NULL;
 }
 
 /*
@@ -2334,6 +2601,7 @@ static void cfq_choose_cfqg(struct cfq_data *cfqd)
 static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 {
 	struct cfq_queue *cfqq, *new_cfqq = NULL;
+	struct cfq_entity *entity;
 
 	cfqq = cfqd->active_queue;
 	if (!cfqq)
@@ -2433,9 +2701,9 @@ new_queue:
 	 * Current queue expired. Check if we have to switch to a new
 	 * service tree
 	 */
-	if (!new_cfqq)
-		cfq_choose_cfqg(cfqd);
-
+	entity = cfq_select_entity(cfqd);
+	BUG_ON(entity->is_group_entity);
+	new_cfqq = cfqq_of_entity(entity);
 	cfqq = cfq_set_active_queue(cfqd, new_cfqq);
 keep_queue:
 	return cfqq;
@@ -2465,10 +2733,14 @@ static int cfq_forced_dispatch(struct cfq_data *cfqd)
 {
 	struct cfq_queue *cfqq;
 	int dispatched = 0;
+	struct cfq_entity *cfqe;
 
 	/* Expire the timeslice of the current active queue first */
 	cfq_slice_expired(cfqd, 0);
-	while ((cfqq = cfq_get_next_queue_forced(cfqd)) != NULL) {
+
+	while ((cfqe = cfq_get_next_entity_forced(cfqd)) != NULL) {
+		BUG_ON(cfqe->is_group_entity);
+		cfqq = cfqq_of_entity(cfqe);
 		__cfq_set_active_queue(cfqd, cfqq);
 		dispatched += __cfq_forced_dispatch_cfqq(cfqq);
 	}
@@ -2476,6 +2748,7 @@ static int cfq_forced_dispatch(struct cfq_data *cfqd)
 	BUG_ON(cfqd->busy_queues);
 
 	cfq_log(cfqd, "forced_dispatch=%d", dispatched);
+
 	return dispatched;
 }
 
@@ -4038,9 +4311,6 @@ static void *cfq_init_queue(struct request_queue *q)
 	 */
 	cfqd->cic_index = i;
 
-	/* Init root service tree */
-	cfqd->grp_service_tree = CFQ_RB_ROOT;
-
 	/* Init root group */
 	cfqg = &cfqd->root_group;
 	for_each_cfqg_st(cfqg, i, j, st)
@@ -4050,6 +4320,7 @@ static void *cfq_init_queue(struct request_queue *q)
 	/* Give preference to root group over other groups */
 	cfqg->cfqe.weight = 2*BLKIO_WEIGHT_DEFAULT;
 	cfqg->cfqe.is_group_entity = true;
+	cfqg_set_parent(cfqd, cfqg, NULL);
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 	/*
@@ -4102,6 +4373,7 @@ static void *cfq_init_queue(struct request_queue *q)
 	cfqd->cfq_latency = 1;
 	cfqd->cfq_group_isolation = 0;
 	cfqd->hw_tag = -1;
+
 	/*
 	 * we optimistically start assuming sync ops weren't delayed in last
 	 * second, in order to have larger depth for async operations.
-- 
1.7.1

