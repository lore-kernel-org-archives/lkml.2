Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126Ab0JUCef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 22:34:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63224 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757077Ab0JUCee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 22:34:34 -0400
Message-ID: <4CBFA6C9.3040604@cn.fujitsu.com>
Date: Thu, 21 Oct 2010 10:34:49 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>
CC: Nauman Rafique <nauman@google.com>, Chad Talbott <ctalbott@google.com>,
        Divyesh Shah <dpshah@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: [PATCH 1/4 v2] cfq-iosched: add cfq group hierarchical scheduling
 support
References: <4CBFA64D.6050800@cn.fujitsu.com>
In-Reply-To: <4CBFA64D.6050800@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables cfq group hierarchical scheduling.

With this patch, you can create a cgroup directory deeper than level 1.
Now, I/O Bandwidth is distributed in a hierarchy way. For example:
We create cgroup directories as following(the number represents weight):

            Root grp
           /       \
       grp_1(100) grp_2(400)
       /    \ 
  grp_3(200) grp_4(300)

If grp_2 grp_3 and grp_4 are contending for I/O Bandwidth,
grp_2 will share 80% of total bandwidth.
For sub_groups, grp_3 shares 8%(20% * 40%), grp_4 shares 12%(20% * 60%)

Design:
  o Each cfq group has its own group service tree. 
  o Each cfq group contains a "group schedule entity" (gse) that 
    schedules on parent cfq group's service tree.
  o Each cfq group contains a "queue schedule entity"(qse), it
    represents all cfqqs located on this cfq group. It schedules
    on this group's service tree. For the time being, root group
    qse's weight is 1000, and subgroup qse's weight is 500.
  o All gses and qse which belones to a same cfq group schedules
    on the same group service tree.
  o cfq group allocates in a recursive manner, that means when a cfq 
    group needs to be allocated, the upper level cfq groups are also
    allocated.
  o When a cfq group served, not only charge this cfq group but also
    charge its ancestors.

Change v1->v2
o Rename some struct and variable according to Chad's comment.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/blk-cgroup.c  |    4 -
 block/cfq-iosched.c |  483 ++++++++++++++++++++++++++++++++++++++-------------
 2 files changed, 359 insertions(+), 128 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index b1febd0..455768a 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1452,10 +1452,6 @@ blkiocg_create(struct cgroup_subsys *subsys, struct cgroup *cgroup)
 		goto done;
 	}
 
-	/* Currently we do not support hierarchy deeper than two level (0,1) */
-	if (parent != cgroup->top_cgroup)
-		return ERR_PTR(-EPERM);
-
 	blkcg = kzalloc(sizeof(*blkcg), GFP_KERNEL);
 	if (!blkcg)
 		return ERR_PTR(-ENOMEM);
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index ee9cd3a..5c3953d 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -73,7 +73,8 @@ static DEFINE_IDA(cic_index_ida);
 #define cfq_class_rt(cfqq)	((cfqq)->ioprio_class == IOPRIO_CLASS_RT)
 
 #define sample_valid(samples)	((samples) > 80)
-#define rb_entry_cfqg(node)	rb_entry((node), struct cfq_group, rb_node)
+#define rb_entry_se(node)	\
+	rb_entry((node), struct io_sched_entity, rb_node)
 
 /*
  * Most of our rbtree usage is for sorting with min extraction, so
@@ -171,19 +172,40 @@ enum wl_type_t {
 	SYNC_WORKLOAD = 2
 };
 
-/* This is per cgroup per device grouping structure */
-struct cfq_group {
+/*
+ * This's the schedule entity which is scheduled on group service tree.
+ * It represents shedule structure of a cfq group, or a bundle of cfq
+ * queues that locate in a cfq group.
+ */
+struct io_sched_entity {
+	struct cfq_rb_root *st;
+
 	/* group service_tree member */
 	struct rb_node rb_node;
-
-	/* group service_tree key */
 	u64 vdisktime;
 	unsigned int weight;
 	bool on_st;
+	bool is_group_se;
+	struct io_sched_entity *parent;
+};
+
+/* This is per cgroup per device grouping structure */
+struct cfq_group {
+	/* cfq group sched entity */
+	struct io_sched_entity group_se;
+
+	/* cfq queue sched entity */
+	struct io_sched_entity queue_se;
+
+	/* Service tree for cfq_groups and cfqqs set*/
+	struct cfq_rb_root grp_service_tree;
 
 	/* number of cfqq currently on this group */
 	int nr_cfqq;
 
+	/* number of sub cfq groups */
+	int nr_subgp;
+
 	/* Per group busy queus average. Useful for workload slice calc. */
 	unsigned int busy_queues_avg[2];
 	/*
@@ -210,8 +232,6 @@ struct cfq_group {
  */
 struct cfq_data {
 	struct request_queue *queue;
-	/* Root service tree for cfq_groups */
-	struct cfq_rb_root grp_service_tree;
 	struct cfq_group root_group;
 
 	/*
@@ -398,6 +418,24 @@ static inline bool iops_mode(struct cfq_data *cfqd)
 		return false;
 }
 
+static inline struct cfq_group *
+cfqg_of_group_entity(struct io_sched_entity *se)
+{
+	if (se->is_group_se)
+		return container_of(se, struct cfq_group, group_se);
+	else
+		return NULL;
+}
+
+static inline struct cfq_group *
+cfqg_of_queue_entity(struct io_sched_entity *se)
+{
+	if (!se->is_group_se)
+		return container_of(se, struct cfq_group, queue_se);
+	else
+		return NULL;
+}
+
 static inline enum wl_prio_t cfqq_prio(struct cfq_queue *cfqq)
 {
 	if (cfq_class_idle(cfqq))
@@ -521,12 +559,13 @@ cfq_prio_to_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	return cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio);
 }
 
-static inline u64 cfq_scale_slice(unsigned long delta, struct cfq_group *cfqg)
+static inline u64 cfq_scale_slice(unsigned long delta,
+				  struct io_sched_entity *se)
 {
 	u64 d = delta << CFQ_SERVICE_SHIFT;
 
 	d = d * BLKIO_WEIGHT_DEFAULT;
-	do_div(d, cfqg->weight);
+	do_div(d, se->weight);
 	return d;
 }
 
@@ -551,16 +590,16 @@ static inline u64 min_vdisktime(u64 min_vdisktime, u64 vdisktime)
 static void update_min_vdisktime(struct cfq_rb_root *st)
 {
 	u64 vdisktime = st->min_vdisktime;
-	struct cfq_group *cfqg;
+	struct io_sched_entity *se;
 
 	if (st->active) {
-		cfqg = rb_entry_cfqg(st->active);
-		vdisktime = cfqg->vdisktime;
+		se = rb_entry_se(st->active);
+		vdisktime = se->vdisktime;
 	}
 
 	if (st->left) {
-		cfqg = rb_entry_cfqg(st->left);
-		vdisktime = min_vdisktime(vdisktime, cfqg->vdisktime);
+		se = rb_entry_se(st->left);
+		vdisktime = min_vdisktime(vdisktime, se->vdisktime);
 	}
 
 	st->min_vdisktime = max_vdisktime(st->min_vdisktime, vdisktime);
@@ -590,9 +629,10 @@ static inline unsigned cfq_group_get_avg_queues(struct cfq_data *cfqd,
 static inline unsigned
 cfq_group_slice(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
-	struct cfq_rb_root *st = &cfqd->grp_service_tree;
+	struct io_sched_entity *queue_entity = &cfqg->queue_se;
+	struct cfq_rb_root *st = queue_entity->st;
 
-	return cfq_target_latency * cfqg->weight / st->total_weight;
+	return cfq_target_latency * queue_entity->weight / st->total_weight;
 }
 
 static inline void
@@ -755,13 +795,13 @@ static struct cfq_queue *cfq_rb_first(struct cfq_rb_root *root)
 	return NULL;
 }
 
-static struct cfq_group *cfq_rb_first_group(struct cfq_rb_root *root)
+static struct io_sched_entity *cfq_rb_first_se(struct cfq_rb_root *root)
 {
 	if (!root->left)
 		root->left = rb_first(&root->rb);
 
 	if (root->left)
-		return rb_entry_cfqg(root->left);
+		return rb_entry_se(root->left);
 
 	return NULL;
 }
@@ -818,25 +858,25 @@ static unsigned long cfq_slice_offset(struct cfq_data *cfqd,
 }
 
 static inline s64
-cfqg_key(struct cfq_rb_root *st, struct cfq_group *cfqg)
+se_key(struct cfq_rb_root *st, struct io_sched_entity *se)
 {
-	return cfqg->vdisktime - st->min_vdisktime;
+	return se->vdisktime - st->min_vdisktime;
 }
 
 static void
-__cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
+__io_sched_entity_add(struct cfq_rb_root *st, struct io_sched_entity *se)
 {
 	struct rb_node **node = &st->rb.rb_node;
 	struct rb_node *parent = NULL;
-	struct cfq_group *__cfqg;
-	s64 key = cfqg_key(st, cfqg);
+	struct io_sched_entity *__se;
+	s64 key = se_key(st, se);
 	int left = 1;
 
 	while (*node != NULL) {
 		parent = *node;
-		__cfqg = rb_entry_cfqg(parent);
+		__se = rb_entry_se(parent);
 
-		if (key < cfqg_key(st, __cfqg))
+		if (key < se_key(st, __se))
 			node = &parent->rb_left;
 		else {
 			node = &parent->rb_right;
@@ -845,47 +885,82 @@ __cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
 	}
 
 	if (left)
-		st->left = &cfqg->rb_node;
+		st->left = &se->rb_node;
 
-	rb_link_node(&cfqg->rb_node, parent, node);
-	rb_insert_color(&cfqg->rb_node, &st->rb);
+	rb_link_node(&se->rb_node, parent, node);
+	rb_insert_color(&se->rb_node, &st->rb);
 }
 
-static void
-cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
+static void io_sched_entity_add(struct cfq_rb_root *st,
+				struct io_sched_entity *se)
 {
-	struct cfq_rb_root *st = &cfqd->grp_service_tree;
-	struct cfq_group *__cfqg;
 	struct rb_node *n;
+	struct io_sched_entity *__se;
 
-	cfqg->nr_cfqq++;
-	if (cfqg->on_st)
-		return;
 
+	if (se->on_st)
+		return;
 	/*
 	 * Currently put the group at the end. Later implement something
 	 * so that groups get lesser vtime based on their weights, so that
 	 * if group does not loose all if it was not continously backlogged.
 	 */
-	n = rb_last(&st->rb);
+	n = rb_last(&se->st->rb);
 	if (n) {
-		__cfqg = rb_entry_cfqg(n);
-		cfqg->vdisktime = __cfqg->vdisktime + CFQ_IDLE_DELAY;
+		__se = rb_entry_se(n);
+		se->vdisktime = __se->vdisktime + CFQ_IDLE_DELAY;
 	} else
-		cfqg->vdisktime = st->min_vdisktime;
+		se->vdisktime = st->min_vdisktime;
 
-	__cfq_group_service_tree_add(st, cfqg);
-	cfqg->on_st = true;
-	st->total_weight += cfqg->weight;
+	__io_sched_entity_add(se->st, se);
+	se->on_st = true;
+	st->total_weight += se->weight;
+}
+
+static void
+cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
+{
+	struct io_sched_entity *group_entity = &cfqg->group_se;
+	struct io_sched_entity *queue_entity = &cfqg->queue_se;
+	struct cfq_group *__cfqg;
+
+	cfqg->nr_cfqq++;
+
+	io_sched_entity_add(queue_entity->st, queue_entity);
+
+	while (group_entity && group_entity->parent) {
+		if (group_entity->on_st)
+			return;
+		io_sched_entity_add(group_entity->st, group_entity);
+		group_entity = group_entity->parent;
+		__cfqg = cfqg_of_group_entity(group_entity);
+		__cfqg->nr_subgp++;
+	}
+}
+
+static void io_sched_entity_del(struct io_sched_entity *se)
+{
+	if (!RB_EMPTY_NODE(&se->rb_node))
+		cfq_rb_erase(&se->rb_node, se->st);
+
+	se->on_st = false;
+	se->st->total_weight -= se->weight;
 }
 
 static void
 cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
-	struct cfq_rb_root *st = &cfqd->grp_service_tree;
+	struct io_sched_entity *group_entity = &cfqg->group_se;
+	struct io_sched_entity *queue_entity = &cfqg->queue_se;
+	struct cfq_group *__cfqg, *p_cfqg;
+
+	if (group_entity->st &&
+	    group_entity->st->active == &group_entity->rb_node)
+		group_entity->st->active = NULL;
 
-	if (st->active == &cfqg->rb_node)
-		st->active = NULL;
+	if (queue_entity->st &&
+	    queue_entity->st->active == &queue_entity->rb_node)
+		queue_entity->st->active = NULL;
 
 	BUG_ON(cfqg->nr_cfqq < 1);
 	cfqg->nr_cfqq--;
@@ -894,13 +969,25 @@ cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	if (cfqg->nr_cfqq)
 		return;
 
-	cfq_log_cfqg(cfqd, cfqg, "del_from_rr group");
-	cfqg->on_st = false;
-	st->total_weight -= cfqg->weight;
-	if (!RB_EMPTY_NODE(&cfqg->rb_node))
-		cfq_rb_erase(&cfqg->rb_node, st);
-	cfqg->saved_workload_slice = 0;
-	cfq_blkiocg_update_dequeue_stats(&cfqg->blkg, 1);
+	/* dequeue queue se from group */
+	io_sched_entity_del(queue_entity);
+
+	if (cfqg->nr_subgp)
+		return;
+
+	/* prevent from dequeuing root group */
+	while (group_entity && group_entity->parent) {
+		__cfqg = cfqg_of_group_entity(group_entity);
+		p_cfqg = cfqg_of_group_entity(group_entity->parent);
+		io_sched_entity_del(group_entity);
+		cfq_blkiocg_update_dequeue_stats(&__cfqg->blkg, 1);
+		cfq_log_cfqg(cfqd, __cfqg, "del_from_rr group");
+		__cfqg->saved_workload_slice = 0;
+		group_entity = group_entity->parent;
+		p_cfqg->nr_subgp--;
+		if (p_cfqg->nr_cfqq || p_cfqg->nr_subgp)
+			return;
+	}
 }
 
 static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq)
@@ -932,7 +1019,8 @@ static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq)
 static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 				struct cfq_queue *cfqq)
 {
-	struct cfq_rb_root *st = &cfqd->grp_service_tree;
+	struct io_sched_entity *group_entity = &cfqg->group_se;
+	struct io_sched_entity *queue_entity = &cfqg->queue_se;
 	unsigned int used_sl, charge;
 	int nr_sync = cfqg->nr_cfqq - cfqg_busy_async_queues(cfqd, cfqg)
 			- cfqg->service_tree_idle.count;
@@ -945,10 +1033,26 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 	else if (!cfq_cfqq_sync(cfqq) && !nr_sync)
 		charge = cfqq->allocated_slice;
 
-	/* Can't update vdisktime while group is on service tree */
-	cfq_rb_erase(&cfqg->rb_node, st);
-	cfqg->vdisktime += cfq_scale_slice(charge, cfqg);
-	__cfq_group_service_tree_add(st, cfqg);
+	/*
+	 *  update queue se's vdisktime.
+	 *  Can't update vdisktime while group is on service tree.
+	 */
+
+	cfq_rb_erase(&queue_entity->rb_node, queue_entity->st);
+	queue_entity->vdisktime += cfq_scale_slice(charge, queue_entity);
+	__io_sched_entity_add(queue_entity->st, queue_entity);
+	if (&queue_entity->rb_node == queue_entity->st->active)
+		queue_entity->st->active = NULL;
+
+	while (group_entity && group_entity->parent) {
+		cfq_rb_erase(&group_entity->rb_node, group_entity->st);
+		group_entity->vdisktime += cfq_scale_slice(charge,
+							   group_entity);
+		__io_sched_entity_add(group_entity->st, group_entity);
+		if (&group_entity->rb_node == group_entity->st->active)
+			group_entity->st->active = NULL;
+		group_entity = group_entity->parent;
+	}
 
 	/* This group is being expired. Save the context */
 	if (time_after(cfqd->workload_expires, jiffies)) {
@@ -959,8 +1063,10 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 	} else
 		cfqg->saved_workload_slice = 0;
 
-	cfq_log_cfqg(cfqd, cfqg, "served: vt=%llu min_vt=%llu", cfqg->vdisktime,
-					st->min_vdisktime);
+	cfq_log_cfqg(cfqd, cfqg, "served: vt=%llu min_vt=%llu",
+		     group_entity->vdisktime,
+		     group_entity->st->min_vdisktime);
+
 	cfq_log_cfqq(cfqq->cfqd, cfqq, "sl_used=%u disp=%u charge=%u iops=%u"
 			" sect=%u", used_sl, cfqq->slice_dispatch, charge,
 			iops_mode(cfqd), cfqq->nr_sectors);
@@ -976,39 +1082,84 @@ static inline struct cfq_group *cfqg_of_blkg(struct blkio_group *blkg)
 	return NULL;
 }
 
+static void cfq_put_cfqg(struct cfq_group *cfqg)
+{
+	struct cfq_rb_root *st;
+	int i, j;
+	struct io_sched_entity *group_entity;
+	struct cfq_group *p_cfqg;
+
+	BUG_ON(atomic_read(&cfqg->ref) <= 0);
+	if (!atomic_dec_and_test(&cfqg->ref))
+		return;
+	for_each_cfqg_st(cfqg, i, j, st)
+		BUG_ON(!RB_EMPTY_ROOT(&st->rb) || st->active != NULL);
+
+	group_entity = &cfqg->group_se;
+	if (group_entity->parent) {
+		p_cfqg = cfqg_of_group_entity(group_entity->parent);
+		/* Drop the reference taken by children */
+		atomic_dec(&p_cfqg->ref);
+	}
+
+	kfree(cfqg);
+}
+
+static void cfq_destroy_cfqg(struct cfq_data *cfqd, struct cfq_group *cfqg)
+{
+	/* Something wrong if we are trying to remove same group twice */
+	BUG_ON(hlist_unhashed(&cfqg->cfqd_node));
+
+	hlist_del_init(&cfqg->cfqd_node);
+
+	/*
+	 * Put the reference taken at the time of creation so that when all
+	 * queues are gone, group can be destroyed.
+	 */
+	cfq_put_cfqg(cfqg);
+}
+
+static void init_group_queue_entity(struct blkio_cgroup *blkcg,
+				    struct cfq_group *cfqg)
+{
+	struct io_sched_entity *group_entity = &cfqg->group_se;
+	struct io_sched_entity *queue_entity = &cfqg->queue_se;
+
+	group_entity->weight = blkcg_get_weight(blkcg, cfqg->blkg.dev);
+	RB_CLEAR_NODE(&group_entity->rb_node);
+	group_entity->is_group_se = true;
+	group_entity->on_st = false;
+
+	/* Set to 500 for the time being */
+	queue_entity->weight = 500;
+	RB_CLEAR_NODE(&queue_entity->rb_node);
+	queue_entity->is_group_se = false;
+	queue_entity->on_st = false;
+}
+
 void cfq_update_blkio_group_weight(void *key, struct blkio_group *blkg,
 					unsigned int weight)
 {
-	cfqg_of_blkg(blkg)->weight = weight;
+	struct cfq_group *cfqg;
+	struct io_sched_entity *group_entity;
+
+	cfqg = cfqg_of_blkg(blkg);
+	group_entity = &cfqg->group_se;
+	group_entity->weight = weight;
 }
 
-static struct cfq_group *
-cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
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
+	struct backing_dev_info *bdi = &cfqd->queue->backing_dev_info;
 
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
+	cfqg->grp_service_tree = CFQ_RB_ROOT;
 
 	for_each_cfqg_st(cfqg, i, j, st)
 		*st = CFQ_RB_ROOT;
-	RB_CLEAR_NODE(&cfqg->rb_node);
 
 	/*
 	 * Take the initial reference that will be released on destroy
@@ -1022,11 +1173,102 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 	sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
 	cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
 					MKDEV(major, minor));
-	cfqg->weight = blkcg_get_weight(blkcg, cfqg->blkg.dev);
-
+	init_group_queue_entity(blkcg, cfqg);
 	/* Add group on cfqd list */
 	hlist_add_head(&cfqg->cfqd_node, &cfqd->cfqg_list);
+}
+
+static void uninit_cfqg(struct cfq_data *cfqd, struct cfq_group *cfqg)
+{
+	if (!cfq_blkiocg_del_blkio_group(&cfqg->blkg))
+		cfq_destroy_cfqg(cfqd, cfqg);
+}
+
+static void cfqg_set_parent(struct cfq_group *cfqg, struct cfq_group *p_cfqg)
+{
+	struct io_sched_entity *group_entity = &cfqg->group_se;
+	struct io_sched_entity *queue_entity = &cfqg->queue_se;
+	struct io_sched_entity *p_group_entity = &p_cfqg->group_se;
+
+	group_entity->parent = p_group_entity;
+	group_entity->st = &p_cfqg->grp_service_tree;
+
+	queue_entity->parent = group_entity;
+	queue_entity->st = &cfqg->grp_service_tree;
+
+	/* child reference */
+	atomic_inc(&p_cfqg->ref);
+}
+
+int cfqg_chain_alloc(struct cfq_data *cfqd, struct cgroup *cgroup)
+{
+	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
+	struct blkio_cgroup *p_blkcg;
+	struct backing_dev_info *bdi = &cfqd->queue->backing_dev_info;
+	unsigned int major, minor;
+	struct cfq_group *cfqg, *p_cfqg;
+	void *key = cfqd;
+	int ret;
+
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
+	cfqg_set_parent(cfqg, p_cfqg);
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
 
+	cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, key));
+	if (cfqg && !cfqg->blkg.dev && bdi->dev && dev_name(bdi->dev)) {
+		sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
+		cfqg->blkg.dev = MKDEV(major, minor);
+		goto done;
+	}
+	if (cfqg || !create)
+		goto done;
+
+	ret = cfqg_chain_alloc(cfqd, cgroup);
+	if (!ret) {
+		cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, key));
+		BUG_ON(cfqg == NULL);
+		goto done;
+	}
 done:
 	return cfqg;
 }
@@ -1066,33 +1308,6 @@ static void cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg)
 	atomic_inc(&cfqq->cfqg->ref);
 }
 
-static void cfq_put_cfqg(struct cfq_group *cfqg)
-{
-	struct cfq_rb_root *st;
-	int i, j;
-
-	BUG_ON(atomic_read(&cfqg->ref) <= 0);
-	if (!atomic_dec_and_test(&cfqg->ref))
-		return;
-	for_each_cfqg_st(cfqg, i, j, st)
-		BUG_ON(!RB_EMPTY_ROOT(&st->rb) || st->active != NULL);
-	kfree(cfqg);
-}
-
-static void cfq_destroy_cfqg(struct cfq_data *cfqd, struct cfq_group *cfqg)
-{
-	/* Something wrong if we are trying to remove same group twice */
-	BUG_ON(hlist_unhashed(&cfqg->cfqd_node));
-
-	hlist_del_init(&cfqg->cfqd_node);
-
-	/*
-	 * Put the reference taken at the time of creation so that when all
-	 * queues are gone, group can be destroyed.
-	 */
-	cfq_put_cfqg(cfqg);
-}
-
 static void cfq_release_cfq_groups(struct cfq_data *cfqd)
 {
 	struct hlist_node *pos, *n;
@@ -1667,9 +1882,6 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	if (cfqq == cfqd->active_queue)
 		cfqd->active_queue = NULL;
 
-	if (&cfqq->cfqg->rb_node == cfqd->grp_service_tree.active)
-		cfqd->grp_service_tree.active = NULL;
-
 	if (cfqd->active_cic) {
 		put_io_context(cfqd->active_cic->ioc);
 		cfqd->active_cic = NULL;
@@ -2171,17 +2383,26 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	cfqd->workload_expires = jiffies + slice;
 }
 
+
 static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd)
 {
-	struct cfq_rb_root *st = &cfqd->grp_service_tree;
+	struct cfq_group *root_group = &cfqd->root_group;
+	struct cfq_rb_root *st = &root_group->grp_service_tree;
 	struct cfq_group *cfqg;
+	struct io_sched_entity *se;
 
-	if (RB_EMPTY_ROOT(&st->rb))
-		return NULL;
-	cfqg = cfq_rb_first_group(st);
-	st->active = &cfqg->rb_node;
-	update_min_vdisktime(st);
-	return cfqg;
+	do {
+		se = cfq_rb_first_se(st);
+		if (!se)
+			return NULL;
+		st->active = &se->rb_node;
+		update_min_vdisktime(st);
+		cfqg = cfqg_of_queue_entity(se);
+		if (cfqg)
+			return cfqg;
+		cfqg = cfqg_of_group_entity(se);
+		st = &cfqg->grp_service_tree;
+	} while (1);
 }
 
 static void cfq_choose_cfqg(struct cfq_data *cfqd)
@@ -2213,15 +2434,18 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 	if (!cfqq)
 		goto new_queue;
 
+
 	if (!cfqd->rq_queued)
 		return NULL;
 
+
 	/*
 	 * We were waiting for group to get backlogged. Expire the queue
 	 */
 	if (cfq_cfqq_wait_busy(cfqq) && !RB_EMPTY_ROOT(&cfqq->sort_list))
 		goto expire;
 
+
 	/*
 	 * The active queue has run out of time, expire it and select new.
 	 */
@@ -2243,6 +2467,7 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 			goto check_group_idle;
 	}
 
+
 	/*
 	 * The active queue has requests and isn't expired, allow it to
 	 * dispatch.
@@ -2250,6 +2475,7 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 	if (!RB_EMPTY_ROOT(&cfqq->sort_list))
 		goto keep_queue;
 
+
 	/*
 	 * If another queue has a request waiting within our mean seek
 	 * distance, let it run.  The expire code will check for close
@@ -2503,6 +2729,7 @@ static int cfq_dispatch_requests(struct request_queue *q, int force)
 	}
 
 	cfq_log_cfqq(cfqd, cfqq, "dispatched a request");
+
 	return 1;
 }
 
@@ -3844,17 +4071,25 @@ static void *cfq_init_queue(struct request_queue *q)
 
 	cfqd->cic_index = i;
 
-	/* Init root service tree */
-	cfqd->grp_service_tree = CFQ_RB_ROOT;
-
 	/* Init root group */
 	cfqg = &cfqd->root_group;
+	cfqg->grp_service_tree = CFQ_RB_ROOT;
 	for_each_cfqg_st(cfqg, i, j, st)
 		*st = CFQ_RB_ROOT;
-	RB_CLEAR_NODE(&cfqg->rb_node);
-
+	cfqg->group_se.is_group_se = true;
+	RB_CLEAR_NODE(&cfqg->group_se.rb_node);
+	cfqg->group_se.on_st = false;
 	/* Give preference to root group over other groups */
-	cfqg->weight = 2*BLKIO_WEIGHT_DEFAULT;
+	cfqg->group_se.weight = 2*BLKIO_WEIGHT_DEFAULT;
+	cfqg->group_se.parent = NULL;
+	cfqg->group_se.st = NULL;
+
+	cfqg->queue_se.is_group_se = false;
+	RB_CLEAR_NODE(&cfqg->queue_se.rb_node);
+	cfqg->queue_se.on_st = false;
+	cfqg->queue_se.weight = 2*BLKIO_WEIGHT_DEFAULT;
+	cfqg->queue_se.parent = &cfqg->group_se;
+	cfqg->queue_se.st = &cfqg->grp_service_tree;
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 	/*
-- 1.6.5.2 
