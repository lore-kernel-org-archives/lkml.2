Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226Ab0KOAw7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 19:52:59 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50643 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755188Ab0KOAw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 19:52:58 -0500
Message-ID: <4CE08463.7080704@cn.fujitsu.com>
Date: Mon, 15 Nov 2010 08:52:51 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>
CC: Corrado Zoccolo <czoccolo@gmail.com>, Chad Talbott <ctalbott@google.com>,
        Nauman Rafique <nauman@google.com>, Divyesh Shah <dpshah@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: [RFC] [PATCH 2/8] cfq-iosched: Introduce io_sched_entity for CFQ
 group.
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-15 08:53:21,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-15 08:53:22,
	Serialize complete at 2010-11-15 08:53:22
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce io_sched_entity for CFQ group.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/cfq-iosched.c |  132 ++++++++++++++++++++++++++++++--------------------
 1 files changed, 79 insertions(+), 53 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 1f099a4..5cce1e8 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -73,7 +73,8 @@ static DEFINE_IDA(cic_index_ida);
 #define cfq_class_rt(cfqq)	((cfqq)->ioprio_class == IOPRIO_CLASS_RT)
 
 #define sample_valid(samples)	((samples) > 80)
-#define rb_entry_cfqg(node)	rb_entry((node), struct cfq_group, rb_node)
+#define rb_entry_entity(node)	rb_entry((node), struct io_sched_entity,\
+					 rb_node)
 
 /*
  * Most of our rbtree usage is for sorting with min extraction, so
@@ -103,6 +104,12 @@ struct io_sched_entity {
 	struct rb_node rb_node;
 	/* service_tree key, represent the position on the tree */
 	unsigned long rb_key;
+
+	/* group service_tree key */
+	u64 vdisktime;
+	bool on_st;
+	bool is_group_entity;
+	unsigned int weight;
 };
 
 /*
@@ -183,13 +190,8 @@ enum wl_type_t {
 
 /* This is per cgroup per device grouping structure */
 struct cfq_group {
-	/* group service_tree member */
-	struct rb_node rb_node;
-
-	/* group service_tree key */
-	u64 vdisktime;
-	unsigned int weight;
-	bool on_st;
+	/* cfq group sched entity */
+	struct io_sched_entity group_entity;
 
 	/* number of cfqq currently on this group */
 	int nr_cfqq;
@@ -305,14 +307,23 @@ struct cfq_data {
 };
 
 static inline struct cfq_queue *
-cfqq_of_entity(struct io_sched_entity *queue_entity)
+cfqq_of_entity(struct io_sched_entity *io_entity)
 {
-	if (queue_entity)
-		return container_of(queue_entity, struct cfq_queue,
+	if (io_entity && !io_entity->is_group_entity)
+		return container_of(io_entity, struct cfq_queue,
 				    queue_entity);
 	return NULL;
 }
 
+static inline struct cfq_group *
+cfqg_of_entity(struct io_sched_entity *io_entity)
+{
+	if (io_entity && io_entity->is_group_entity)
+		return container_of(io_entity, struct cfq_group,
+				    group_entity);
+	return NULL;
+}
+
 static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
 
 static struct cfq_rb_root *service_tree_for(struct cfq_group *cfqg,
@@ -545,7 +556,7 @@ static inline u64 cfq_scale_slice(unsigned long delta, struct cfq_group *cfqg)
 	u64 d = delta << CFQ_SERVICE_SHIFT;
 
 	d = d * BLKIO_WEIGHT_DEFAULT;
-	do_div(d, cfqg->weight);
+	do_div(d, cfqg->group_entity.weight);
 	return d;
 }
 
@@ -570,16 +581,16 @@ static inline u64 min_vdisktime(u64 min_vdisktime, u64 vdisktime)
 static void update_min_vdisktime(struct cfq_rb_root *st)
 {
 	u64 vdisktime = st->min_vdisktime;
-	struct cfq_group *cfqg;
+	struct io_sched_entity *group_entity;
 
 	if (st->active) {
-		cfqg = rb_entry_cfqg(st->active);
-		vdisktime = cfqg->vdisktime;
+		group_entity = rb_entry_entity(st->active);
+		vdisktime = group_entity->vdisktime;
 	}
 
 	if (st->left) {
-		cfqg = rb_entry_cfqg(st->left);
-		vdisktime = min_vdisktime(vdisktime, cfqg->vdisktime);
+		group_entity = rb_entry_entity(st->left);
+		vdisktime = min_vdisktime(vdisktime, group_entity->vdisktime);
 	}
 
 	st->min_vdisktime = max_vdisktime(st->min_vdisktime, vdisktime);
@@ -610,8 +621,9 @@ static inline unsigned
 cfq_group_slice(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
 	struct cfq_rb_root *st = &cfqd->grp_service_tree;
+	struct io_sched_entity *group_entity = &cfqg->group_entity;
 
-	return cfq_target_latency * cfqg->weight / st->total_weight;
+	return cfq_target_latency * group_entity->weight / st->total_weight;
 }
 
 static inline void
@@ -774,13 +786,13 @@ static struct io_sched_entity *cfq_rb_first(struct cfq_rb_root *root)
 	return NULL;
 }
 
-static struct cfq_group *cfq_rb_first_group(struct cfq_rb_root *root)
+static struct io_sched_entity *cfq_rb_first_entity(struct cfq_rb_root *root)
 {
 	if (!root->left)
 		root->left = rb_first(&root->rb);
 
 	if (root->left)
-		return rb_entry_cfqg(root->left);
+		return rb_entry_entity(root->left);
 
 	return NULL;
 }
@@ -837,9 +849,9 @@ static unsigned long cfq_slice_offset(struct cfq_data *cfqd,
 }
 
 static inline s64
-cfqg_key(struct cfq_rb_root *st, struct cfq_group *cfqg)
+entity_key(struct cfq_rb_root *st, struct io_sched_entity *entity)
 {
-	return cfqg->vdisktime - st->min_vdisktime;
+	return entity->vdisktime - st->min_vdisktime;
 }
 
 static void
@@ -847,15 +859,16 @@ __cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
 {
 	struct rb_node **node = &st->rb.rb_node;
 	struct rb_node *parent = NULL;
-	struct cfq_group *__cfqg;
-	s64 key = cfqg_key(st, cfqg);
+	struct io_sched_entity *__group_entity;
+	struct io_sched_entity *group_entity = &cfqg->group_entity;
+	s64 key = entity_key(st, group_entity);
 	int left = 1;
 
 	while (*node != NULL) {
 		parent = *node;
-		__cfqg = rb_entry_cfqg(parent);
+		__group_entity = rb_entry_entity(parent);
 
-		if (key < cfqg_key(st, __cfqg))
+		if (key < entity_key(st, __group_entity))
 			node = &parent->rb_left;
 		else {
 			node = &parent->rb_right;
@@ -864,21 +877,22 @@ __cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
 	}
 
 	if (left)
-		st->left = &cfqg->rb_node;
+		st->left = &group_entity->rb_node;
 
-	rb_link_node(&cfqg->rb_node, parent, node);
-	rb_insert_color(&cfqg->rb_node, &st->rb);
+	rb_link_node(&group_entity->rb_node, parent, node);
+	rb_insert_color(&group_entity->rb_node, &st->rb);
 }
 
 static void
 cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
 	struct cfq_rb_root *st = &cfqd->grp_service_tree;
-	struct cfq_group *__cfqg;
 	struct rb_node *n;
+	struct io_sched_entity *group_entity = &cfqg->group_entity;
+	struct io_sched_entity *__group_entity;
 
 	cfqg->nr_cfqq++;
-	if (cfqg->on_st)
+	if (group_entity->on_st)
 		return;
 
 	/*
@@ -888,22 +902,24 @@ cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	 */
 	n = rb_last(&st->rb);
 	if (n) {
-		__cfqg = rb_entry_cfqg(n);
-		cfqg->vdisktime = __cfqg->vdisktime + CFQ_IDLE_DELAY;
+		__group_entity = rb_entry_entity(n);
+		group_entity->vdisktime = __group_entity->vdisktime +
+					  CFQ_IDLE_DELAY;
 	} else
-		cfqg->vdisktime = st->min_vdisktime;
+		group_entity->vdisktime = st->min_vdisktime;
 
 	__cfq_group_service_tree_add(st, cfqg);
-	cfqg->on_st = true;
-	st->total_weight += cfqg->weight;
+	group_entity->on_st = true;
+	st->total_weight += group_entity->weight;
 }
 
 static void
 cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
 	struct cfq_rb_root *st = &cfqd->grp_service_tree;
+	struct io_sched_entity *group_entity = &cfqg->group_entity;
 
-	if (st->active == &cfqg->rb_node)
+	if (st->active == &group_entity->rb_node)
 		st->active = NULL;
 
 	BUG_ON(cfqg->nr_cfqq < 1);
@@ -914,10 +930,10 @@ cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
 		return;
 
 	cfq_log_cfqg(cfqd, cfqg, "del_from_rr group");
-	cfqg->on_st = false;
-	st->total_weight -= cfqg->weight;
-	if (!RB_EMPTY_NODE(&cfqg->rb_node))
-		cfq_rb_erase(&cfqg->rb_node, st);
+	group_entity->on_st = false;
+	st->total_weight -= group_entity->weight;
+	if (!RB_EMPTY_NODE(&group_entity->rb_node))
+		cfq_rb_erase(&group_entity->rb_node, st);
 	cfqg->saved_workload_slice = 0;
 	cfq_blkiocg_update_dequeue_stats(&cfqg->blkg, 1);
 }
@@ -955,6 +971,7 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 	unsigned int used_sl, charge;
 	int nr_sync = cfqg->nr_cfqq - cfqg_busy_async_queues(cfqd, cfqg)
 			- cfqg->service_tree_idle.count;
+	struct io_sched_entity *group_entity = &cfqg->group_entity;
 
 	BUG_ON(nr_sync < 0);
 	used_sl = charge = cfq_cfqq_slice_usage(cfqq);
@@ -965,8 +982,8 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 		charge = cfqq->allocated_slice;
 
 	/* Can't update vdisktime while group is on service tree */
-	cfq_rb_erase(&cfqg->rb_node, st);
-	cfqg->vdisktime += cfq_scale_slice(charge, cfqg);
+	cfq_rb_erase(&group_entity->rb_node, st);
+	group_entity->vdisktime += cfq_scale_slice(charge, cfqg);
 	__cfq_group_service_tree_add(st, cfqg);
 
 	/* This group is being expired. Save the context */
@@ -978,8 +995,8 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 	} else
 		cfqg->saved_workload_slice = 0;
 
-	cfq_log_cfqg(cfqd, cfqg, "served: vt=%llu min_vt=%llu", cfqg->vdisktime,
-					st->min_vdisktime);
+	cfq_log_cfqg(cfqd, cfqg, "served: vt=%llu min_vt=%llu",
+		     group_entity->vdisktime, st->min_vdisktime);
 	cfq_log_cfqq(cfqq->cfqd, cfqq, "sl_used=%u disp=%u charge=%u iops=%u"
 			" sect=%u", used_sl, cfqq->slice_dispatch, charge,
 			iops_mode(cfqd), cfqq->nr_sectors);
@@ -998,7 +1015,7 @@ static inline struct cfq_group *cfqg_of_blkg(struct blkio_group *blkg)
 void cfq_update_blkio_group_weight(void *key, struct blkio_group *blkg,
 					unsigned int weight)
 {
-	cfqg_of_blkg(blkg)->weight = weight;
+	cfqg_of_blkg(blkg)->group_entity.weight = weight;
 }
 
 static struct cfq_group *
@@ -1027,7 +1044,10 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 
 	for_each_cfqg_st(cfqg, i, j, st)
 		*st = CFQ_RB_ROOT;
-	RB_CLEAR_NODE(&cfqg->rb_node);
+	RB_CLEAR_NODE(&cfqg->group_entity.rb_node);
+
+	cfqg->group_entity.is_group_entity = true;
+	cfqg->group_entity.on_st = false;
 
 	/*
 	 * Take the initial reference that will be released on destroy
@@ -1051,7 +1071,7 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 		cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
 					0);
 
-	cfqg->weight = blkcg_get_weight(blkcg, cfqg->blkg.dev);
+	cfqg->group_entity.weight = blkcg_get_weight(blkcg, cfqg->blkg.dev);
 
 	/* Add group on cfqd list */
 	hlist_add_head(&cfqg->cfqd_node, &cfqd->cfqg_list);
@@ -1707,7 +1727,7 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	if (cfqq == cfqd->active_queue)
 		cfqd->active_queue = NULL;
 
-	if (&cfqq->cfqg->rb_node == cfqd->grp_service_tree.active)
+	if (&cfqq->cfqg->group_entity.rb_node == cfqd->grp_service_tree.active)
 		cfqd->grp_service_tree.active = NULL;
 
 	if (cfqd->active_cic) {
@@ -2221,11 +2241,14 @@ static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd)
 {
 	struct cfq_rb_root *st = &cfqd->grp_service_tree;
 	struct cfq_group *cfqg;
+	struct io_sched_entity *group_entity;
 
 	if (RB_EMPTY_ROOT(&st->rb))
 		return NULL;
-	cfqg = cfq_rb_first_group(st);
-	st->active = &cfqg->rb_node;
+	group_entity = cfq_rb_first_entity(st);
+	cfqg = cfqg_of_entity(group_entity);
+	BUG_ON(!cfqg);
+	st->active = &group_entity->rb_node;
 	update_min_vdisktime(st);
 	return cfqg;
 }
@@ -2872,6 +2895,7 @@ static void cfq_init_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	RB_CLEAR_NODE(&cfqq->p_node);
 	INIT_LIST_HEAD(&cfqq->fifo);
 
+	queue_entity->is_group_entity = false;
 	atomic_set(&cfqq->ref, 0);
 	cfqq->cfqd = cfqd;
 
@@ -3900,10 +3924,12 @@ static void *cfq_init_queue(struct request_queue *q)
 	cfqg = &cfqd->root_group;
 	for_each_cfqg_st(cfqg, i, j, st)
 		*st = CFQ_RB_ROOT;
-	RB_CLEAR_NODE(&cfqg->rb_node);
+	RB_CLEAR_NODE(&cfqg->group_entity.rb_node);
 
 	/* Give preference to root group over other groups */
-	cfqg->weight = 2*BLKIO_WEIGHT_DEFAULT;
+	cfqg->group_entity.weight = 2*BLKIO_WEIGHT_DEFAULT;
+	cfqg->group_entity.is_group_entity = true;
+	cfqg->group_entity.on_st = false;
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 	/*
-- 
1.6.5.2





-- 
Regards
Gui Jianfeng
