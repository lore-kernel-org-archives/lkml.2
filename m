Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab1BJHrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 02:47:18 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53323 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab1BJHrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 02:47:17 -0500
Message-ID: <4D5397F7.9030804@cn.fujitsu.com>
Date: Thu, 10 Feb 2011 15:47:03 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>
CC: Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        Chad Talbott <ctalbott@google.com>, Divyesh Shah <dpshah@google.com>
Subject: [PATCH 2/6 v4] cfq-iosched: Introduce cfq_entity for CFQ group
References: <4D51ED26.8050809@cn.fujitsu.com>
In-Reply-To: <4D51ED26.8050809@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-10 15:46:12,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-10 15:46:13,
	Serialize complete at 2011-02-10 15:46:13
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce cfq_entity for CFQ group

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/cfq-iosched.c |  111 +++++++++++++++++++++++++++++++--------------------
 1 files changed, 67 insertions(+), 44 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 939c6a6..f3a126e 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -73,7 +73,7 @@ static DEFINE_IDA(cic_index_ida);
 #define cfq_class_rt(cfqq)	((cfqq)->ioprio_class == IOPRIO_CLASS_RT)
 
 #define sample_valid(samples)	((samples) > 80)
-#define rb_entry_cfqg(node)	rb_entry((node), struct cfq_group, rb_node)
+#define rb_entry_entity(node)	rb_entry((node), struct cfq_entity, rb_node)
 
 /*
  * Most of our rbtree usage is for sorting with min extraction, so
@@ -101,6 +101,11 @@ struct cfq_entity {
 	struct rb_node rb_node;
 	/* service_tree key, represent the position on the tree */
 	unsigned long rb_key;
+
+	/* group service_tree key */
+	u64 vdisktime;
+	bool is_group_entity;
+	unsigned int weight;
 };
 
 /*
@@ -182,12 +187,8 @@ enum wl_type_t {
 
 /* This is per cgroup per device grouping structure */
 struct cfq_group {
-	/* group service_tree member */
-	struct rb_node rb_node;
-
-	/* group service_tree key */
-	u64 vdisktime;
-	unsigned int weight;
+	/* cfq group sched entity */
+	struct cfq_entity cfqe;
 
 	/* number of cfqq currently on this group */
 	int nr_cfqq;
@@ -314,12 +315,22 @@ struct cfq_data {
 static inline struct cfq_queue *
 cfqq_of_entity(struct cfq_entity *cfqe)
 {
-	if (cfqe)
+	if (cfqe && !cfqe->is_group_entity)
 		return container_of(cfqe, struct cfq_queue, cfqe);
 
 	return NULL;
 }
 
+static inline struct cfq_group *
+cfqg_of_entity(struct cfq_entity *cfqe)
+{
+	if (cfqe && cfqe->is_group_entity)
+		return container_of(cfqe, struct cfq_group, cfqe);
+
+	return NULL;
+}
+
+
 static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
 
 static struct cfq_rb_root *service_tree_for(struct cfq_group *cfqg,
@@ -547,12 +558,12 @@ cfq_prio_to_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	return cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio);
 }
 
-static inline u64 cfq_scale_slice(unsigned long delta, struct cfq_group *cfqg)
+static inline u64 cfq_scale_slice(unsigned long delta, struct cfq_entity *cfqe)
 {
 	u64 d = delta << CFQ_SERVICE_SHIFT;
 
 	d = d * BLKIO_WEIGHT_DEFAULT;
-	do_div(d, cfqg->weight);
+	do_div(d, cfqe->weight);
 	return d;
 }
 
@@ -577,11 +588,11 @@ static inline u64 min_vdisktime(u64 min_vdisktime, u64 vdisktime)
 static void update_min_vdisktime(struct cfq_rb_root *st)
 {
 	u64 vdisktime = st->min_vdisktime;
-	struct cfq_group *cfqg;
+	struct cfq_entity *cfqe;
 
 	if (st->left) {
-		cfqg = rb_entry_cfqg(st->left);
-		vdisktime = min_vdisktime(vdisktime, cfqg->vdisktime);
+		cfqe = rb_entry_entity(st->left);
+		vdisktime = min_vdisktime(vdisktime, cfqe->vdisktime);
 	}
 
 	st->min_vdisktime = max_vdisktime(st->min_vdisktime, vdisktime);
@@ -612,8 +623,9 @@ static inline unsigned
 cfq_group_slice(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
 	struct cfq_rb_root *st = &cfqd->grp_service_tree;
+	struct cfq_entity *cfqe = &cfqg->cfqe;
 
-	return cfq_target_latency * cfqg->weight / st->total_weight;
+	return cfq_target_latency * cfqe->weight / st->total_weight;
 }
 
 static inline void
@@ -776,13 +788,13 @@ static struct cfq_entity *cfq_rb_first(struct cfq_rb_root *root)
 	return NULL;
 }
 
-static struct cfq_group *cfq_rb_first_group(struct cfq_rb_root *root)
+static struct cfq_entity *cfq_rb_first_entity(struct cfq_rb_root *root)
 {
 	if (!root->left)
 		root->left = rb_first(&root->rb);
 
 	if (root->left)
-		return rb_entry_cfqg(root->left);
+		return rb_entry_entity(root->left);
 
 	return NULL;
 }
@@ -839,9 +851,9 @@ static unsigned long cfq_slice_offset(struct cfq_data *cfqd,
 }
 
 static inline s64
-cfqg_key(struct cfq_rb_root *st, struct cfq_group *cfqg)
+entity_key(struct cfq_rb_root *st, struct cfq_entity *entity)
 {
-	return cfqg->vdisktime - st->min_vdisktime;
+	return entity->vdisktime - st->min_vdisktime;
 }
 
 static void
@@ -849,15 +861,16 @@ __cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
 {
 	struct rb_node **node = &st->rb.rb_node;
 	struct rb_node *parent = NULL;
-	struct cfq_group *__cfqg;
-	s64 key = cfqg_key(st, cfqg);
+	struct cfq_entity *__cfqe;
+	struct cfq_entity *cfqe = &cfqg->cfqe;
+	s64 key = entity_key(st, cfqe);
 	int left = 1;
 
 	while (*node != NULL) {
 		parent = *node;
-		__cfqg = rb_entry_cfqg(parent);
+		__cfqe = rb_entry_entity(parent);
 
-		if (key < cfqg_key(st, __cfqg))
+		if (key < entity_key(st, __cfqe))
 			node = &parent->rb_left;
 		else {
 			node = &parent->rb_right;
@@ -866,21 +879,22 @@ __cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
 	}
 
 	if (left)
-		st->left = &cfqg->rb_node;
+		st->left = &cfqe->rb_node;
 
-	rb_link_node(&cfqg->rb_node, parent, node);
-	rb_insert_color(&cfqg->rb_node, &st->rb);
+	rb_link_node(&cfqe->rb_node, parent, node);
+	rb_insert_color(&cfqe->rb_node, &st->rb);
 }
 
 static void
 cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
 	struct cfq_rb_root *st = &cfqd->grp_service_tree;
-	struct cfq_group *__cfqg;
+	struct cfq_entity *cfqe = &cfqg->cfqe;
+	struct cfq_entity *__cfqe;
 	struct rb_node *n;
 
 	cfqg->nr_cfqq++;
-	if (!RB_EMPTY_NODE(&cfqg->rb_node))
+	if (!RB_EMPTY_NODE(&cfqe->rb_node))
 		return;
 
 	/*
@@ -890,19 +904,20 @@ cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	 */
 	n = rb_last(&st->rb);
 	if (n) {
-		__cfqg = rb_entry_cfqg(n);
-		cfqg->vdisktime = __cfqg->vdisktime + CFQ_IDLE_DELAY;
+		__cfqe = rb_entry_entity(n);
+		cfqe->vdisktime = __cfqe->vdisktime + CFQ_IDLE_DELAY;
 	} else
-		cfqg->vdisktime = st->min_vdisktime;
+		cfqe->vdisktime = st->min_vdisktime;
 
 	__cfq_group_service_tree_add(st, cfqg);
-	st->total_weight += cfqg->weight;
+	st->total_weight += cfqe->weight;
 }
 
 static void
 cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
 	struct cfq_rb_root *st = &cfqd->grp_service_tree;
+	struct cfq_entity *cfqe = &cfqg->cfqe;
 
 	BUG_ON(cfqg->nr_cfqq < 1);
 	cfqg->nr_cfqq--;
@@ -912,9 +927,9 @@ cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
 		return;
 
 	cfq_log_cfqg(cfqd, cfqg, "del_from_rr group");
-	st->total_weight -= cfqg->weight;
-	if (!RB_EMPTY_NODE(&cfqg->rb_node))
-		cfq_rb_erase(&cfqg->rb_node, st);
+	st->total_weight -= cfqe->weight;
+	if (!RB_EMPTY_NODE(&cfqe->rb_node))
+		cfq_rb_erase(&cfqe->rb_node, st);
 	cfqg->saved_workload_slice = 0;
 	cfq_blkiocg_update_dequeue_stats(&cfqg->blkg, 1);
 }
@@ -952,6 +967,7 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 	unsigned int used_sl, charge;
 	int nr_sync = cfqg->nr_cfqq - cfqg_busy_async_queues(cfqd, cfqg)
 			- cfqg->service_tree_idle.count;
+	struct cfq_entity *cfqe = &cfqg->cfqe;
 
 	BUG_ON(nr_sync < 0);
 	used_sl = charge = cfq_cfqq_slice_usage(cfqq);
@@ -962,8 +978,8 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 		charge = cfqq->allocated_slice;
 
 	/* Can't update vdisktime while group is on service tree */
-	cfq_rb_erase(&cfqg->rb_node, st);
-	cfqg->vdisktime += cfq_scale_slice(charge, cfqg);
+	cfq_rb_erase(&cfqe->rb_node, st);
+	cfqe->vdisktime += cfq_scale_slice(charge, cfqe);
 	__cfq_group_service_tree_add(st, cfqg);
 
 	/* This group is being expired. Save the context */
@@ -975,8 +991,8 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 	} else
 		cfqg->saved_workload_slice = 0;
 
-	cfq_log_cfqg(cfqd, cfqg, "served: vt=%llu min_vt=%llu", cfqg->vdisktime,
-					st->min_vdisktime);
+	cfq_log_cfqg(cfqd, cfqg, "served: vt=%llu min_vt=%llu",
+		     cfqe->vdisktime, st->min_vdisktime);
 	cfq_log_cfqq(cfqq->cfqd, cfqq, "sl_used=%u disp=%u charge=%u iops=%u"
 			" sect=%u", used_sl, cfqq->slice_dispatch, charge,
 			iops_mode(cfqd), cfqq->nr_sectors);
@@ -995,7 +1011,7 @@ static inline struct cfq_group *cfqg_of_blkg(struct blkio_group *blkg)
 void cfq_update_blkio_group_weight(void *key, struct blkio_group *blkg,
 					unsigned int weight)
 {
-	cfqg_of_blkg(blkg)->weight = weight;
+	cfqg_of_blkg(blkg)->cfqe.weight = weight;
 }
 
 static struct cfq_group *
@@ -1024,7 +1040,9 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 
 	for_each_cfqg_st(cfqg, i, j, st)
 		*st = CFQ_RB_ROOT;
-	RB_CLEAR_NODE(&cfqg->rb_node);
+	RB_CLEAR_NODE(&cfqg->cfqe.rb_node);
+
+	cfqg->cfqe.is_group_entity = true;
 
 	/*
 	 * Take the initial reference that will be released on destroy
@@ -1048,7 +1066,7 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 		cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
 					0);
 
-	cfqg->weight = blkcg_get_weight(blkcg, cfqg->blkg.dev);
+	cfqg->cfqe.weight = blkcg_get_weight(blkcg, cfqg->blkg.dev);
 
 	/* Add group on cfqd list */
 	hlist_add_head(&cfqg->cfqd_node, &cfqd->cfqg_list);
@@ -2209,10 +2227,13 @@ static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd)
 {
 	struct cfq_rb_root *st = &cfqd->grp_service_tree;
 	struct cfq_group *cfqg;
+	struct cfq_entity *cfqe;
 
 	if (RB_EMPTY_ROOT(&st->rb))
 		return NULL;
-	cfqg = cfq_rb_first_group(st);
+	cfqe = cfq_rb_first_entity(st);
+	cfqg = cfqg_of_entity(cfqe);
+	BUG_ON(!cfqg);
 	update_min_vdisktime(st);
 	return cfqg;
 }
@@ -2871,6 +2892,7 @@ static void cfq_init_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	RB_CLEAR_NODE(&cfqq->p_node);
 	INIT_LIST_HEAD(&cfqq->fifo);
 
+	cfqe->is_group_entity = false;
 	cfqq->ref = 0;
 	cfqq->cfqd = cfqd;
 
@@ -3907,10 +3929,11 @@ static void *cfq_init_queue(struct request_queue *q)
 	cfqg = &cfqd->root_group;
 	for_each_cfqg_st(cfqg, i, j, st)
 		*st = CFQ_RB_ROOT;
-	RB_CLEAR_NODE(&cfqg->rb_node);
+	RB_CLEAR_NODE(&cfqg->cfqe.rb_node);
 
 	/* Give preference to root group over other groups */
-	cfqg->weight = 2*BLKIO_WEIGHT_DEFAULT;
+	cfqg->cfqe.weight = 2*BLKIO_WEIGHT_DEFAULT;
+	cfqg->cfqe.is_group_entity = true;
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 	/*
-- 
1.7.1




