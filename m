Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab0KOAyD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 19:54:03 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50009 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755188Ab0KOAyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 19:54:01 -0500
Message-ID: <4CE084A2.7010701@cn.fujitsu.com>
Date: Mon, 15 Nov 2010 08:53:54 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>
CC: Corrado Zoccolo <czoccolo@gmail.com>, Chad Talbott <ctalbott@google.com>,
        Nauman Rafique <nauman@google.com>, Divyesh Shah <dpshah@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: [RFC] [PATCH 3/8] cfq-iosched: Introduce vdisktime and io weight
 for CFQ queue
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-15 08:54:23,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-15 08:54:24,
	Serialize complete at 2010-11-15 08:54:24
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce vdisktime and io weight for CFQ queue scheduling. Currently, io priority
maps to a range [100,1000]. It also gets rid of cfq_slice_offset() logic and makes
use the same scheduling algorithm as CFQ group does. This helps for CFQ queue and
group scheduling on the same service tree.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/cfq-iosched.c |  194 ++++++++++++++++++++++++++++++++++----------------
 1 files changed, 132 insertions(+), 62 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 5cce1e8..ef88931 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -102,10 +102,7 @@ struct io_sched_entity {
 	struct cfq_rb_root *service_tree;
 	/* service_tree member */
 	struct rb_node rb_node;
-	/* service_tree key, represent the position on the tree */
-	unsigned long rb_key;
-
-	/* group service_tree key */
+	/* service_tree key */
 	u64 vdisktime;
 	bool on_st;
 	bool is_group_entity;
@@ -118,6 +115,8 @@ struct io_sched_entity {
 struct cfq_queue {
 	/* The schedule entity */
 	struct io_sched_entity queue_entity;
+	/* Reposition time */
+	unsigned long reposition_time;
 	/* reference count */
 	atomic_t ref;
 	/* various state flags, see below */
@@ -306,6 +305,22 @@ struct cfq_data {
 	struct rcu_head rcu;
 };
 
+/*
+ * Map io priority(7 ~ 0) to io weight(100 ~ 1000)
+ */
+static inline unsigned int cfq_prio_to_weight(unsigned short ioprio)
+{
+	unsigned int step;
+
+	BUG_ON(ioprio >= IOPRIO_BE_NR);
+
+	step = (BLKIO_WEIGHT_MAX - BLKIO_WEIGHT_MIN) / (IOPRIO_BE_NR - 1);
+	if (ioprio == 0)
+		return BLKIO_WEIGHT_MAX;
+
+	return BLKIO_WEIGHT_MIN + (IOPRIO_BE_NR - ioprio - 1) * step;
+}
+
 static inline struct cfq_queue *
 cfqq_of_entity(struct io_sched_entity *io_entity)
 {
@@ -551,12 +566,13 @@ cfq_prio_to_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	return cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio);
 }
 
-static inline u64 cfq_scale_slice(unsigned long delta, struct cfq_group *cfqg)
+static inline u64
+cfq_scale_slice(unsigned long delta, struct io_sched_entity *entity)
 {
 	u64 d = delta << CFQ_SERVICE_SHIFT;
 
 	d = d * BLKIO_WEIGHT_DEFAULT;
-	do_div(d, cfqg->group_entity.weight);
+	do_div(d, entity->weight);
 	return d;
 }
 
@@ -581,16 +597,16 @@ static inline u64 min_vdisktime(u64 min_vdisktime, u64 vdisktime)
 static void update_min_vdisktime(struct cfq_rb_root *st)
 {
 	u64 vdisktime = st->min_vdisktime;
-	struct io_sched_entity *group_entity;
+	struct io_sched_entity *entity;
 
 	if (st->active) {
-		group_entity = rb_entry_entity(st->active);
-		vdisktime = group_entity->vdisktime;
+		entity = rb_entry_entity(st->active);
+		vdisktime = entity->vdisktime;
 	}
 
 	if (st->left) {
-		group_entity = rb_entry_entity(st->left);
-		vdisktime = min_vdisktime(vdisktime, group_entity->vdisktime);
+		entity = rb_entry_entity(st->left);
+		vdisktime = min_vdisktime(vdisktime, entity->vdisktime);
 	}
 
 	st->min_vdisktime = max_vdisktime(st->min_vdisktime, vdisktime);
@@ -838,16 +854,6 @@ cfq_find_next_rq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	return cfq_choose_req(cfqd, next, prev, blk_rq_pos(last));
 }
 
-static unsigned long cfq_slice_offset(struct cfq_data *cfqd,
-				      struct cfq_queue *cfqq)
-{
-	/*
-	 * just an approximation, should be ok.
-	 */
-	return (cfqq->cfqg->nr_cfqq - 1) * (cfq_prio_slice(cfqd, 1, 0) -
-		       cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio));
-}
-
 static inline s64
 entity_key(struct cfq_rb_root *st, struct io_sched_entity *entity)
 {
@@ -983,7 +989,7 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 
 	/* Can't update vdisktime while group is on service tree */
 	cfq_rb_erase(&group_entity->rb_node, st);
-	group_entity->vdisktime += cfq_scale_slice(charge, cfqg);
+	group_entity->vdisktime += cfq_scale_slice(charge, group_entity);
 	__cfq_group_service_tree_add(st, cfqg);
 
 	/* This group is being expired. Save the context */
@@ -1214,13 +1220,14 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	struct io_sched_entity *queue_entity;
 	struct rb_node **p, *parent;
 	struct io_sched_entity *__queue_entity;
-	unsigned long rb_key;
-	struct cfq_rb_root *service_tree;
+	struct cfq_rb_root *service_tree, *orig_st;
 	int left;
 	int new_cfqq = 1;
 	int group_changed = 0;
+	s64 key;
 
 	queue_entity = &cfqq->queue_entity;
+	orig_st = queue_entity->service_tree;
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 	if (!cfqd->cfq_group_isolation
@@ -1228,8 +1235,16 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	    && cfqq->cfqg && cfqq->cfqg != &cfqd->root_group) {
 		/* Move this cfq to root group */
 		cfq_log_cfqq(cfqd, cfqq, "moving to root group");
-		if (!RB_EMPTY_NODE(&queue_entity->rb_node))
+		if (!RB_EMPTY_NODE(&queue_entity->rb_node)) {
 			cfq_group_service_tree_del(cfqd, cfqq->cfqg);
+			/*
+			 * Group changed, dequeue this CFQ queue from the
+			 * original service tree.
+			 */
+			cfq_rb_erase(&queue_entity->rb_node,
+				     queue_entity->service_tree);
+			orig_st->total_weight -= queue_entity->weight;
+		}
 		cfqq->orig_cfqg = cfqq->cfqg;
 		cfqq->cfqg = &cfqd->root_group;
 		atomic_inc(&cfqd->root_group.ref);
@@ -1238,8 +1253,16 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		   && cfqq_type(cfqq) == SYNC_WORKLOAD && cfqq->orig_cfqg) {
 		/* cfqq is sequential now needs to go to its original group */
 		BUG_ON(cfqq->cfqg != &cfqd->root_group);
-		if (!RB_EMPTY_NODE(&queue_entity->rb_node))
+		if (!RB_EMPTY_NODE(&queue_entity->rb_node)) {
 			cfq_group_service_tree_del(cfqd, cfqq->cfqg);
+			/*
+			 * Group changed, dequeue this CFQ queue from the
+			 * original service tree.
+			 */
+			cfq_rb_erase(&queue_entity->rb_node,
+				     queue_entity->service_tree);
+			orig_st->total_weight -= queue_entity->weight;
+		}
 		cfq_put_cfqg(cfqq->cfqg);
 		cfqq->cfqg = cfqq->orig_cfqg;
 		cfqq->orig_cfqg = NULL;
@@ -1250,50 +1273,67 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 
 	service_tree = service_tree_for(cfqq->cfqg, cfqq_prio(cfqq),
 						cfqq_type(cfqq));
+
+	/*
+	 * For the time being, put the newly added CFQ queue at the end of the
+	 * service tree.
+	 */
+	if (RB_EMPTY_NODE(&queue_entity->rb_node)) {
+		/*
+		 * If this CFQ queue moves to another group, the original
+		 * vdisktime makes no sense any more, reset the vdisktime
+		 * here.
+		 */
+		parent = rb_last(&service_tree->rb);
+		if (parent) {
+			__queue_entity = rb_entry_entity(parent);
+			queue_entity->vdisktime = __queue_entity->vdisktime +
+						  CFQ_IDLE_DELAY;
+		} else
+			queue_entity->vdisktime = service_tree->min_vdisktime;
+
+		goto insert;
+	}
+
+	/*
+	 * Ok, we get here, this CFQ queue is on the service tree, dequeue it
+	 * firstly.
+	 */
+	cfq_rb_erase(&queue_entity->rb_node,
+		     queue_entity->service_tree);
+	orig_st->total_weight -= queue_entity->weight;
+
+	new_cfqq = 0;
 	if (cfq_class_idle(cfqq)) {
-		rb_key = CFQ_IDLE_DELAY;
 		parent = rb_last(&service_tree->rb);
 		if (parent && parent != &queue_entity->rb_node) {
 			__queue_entity = rb_entry(parent,
 						  struct io_sched_entity,
 						  rb_node);
-			rb_key += __queue_entity->rb_key;
+			queue_entity->vdisktime = __queue_entity->vdisktime +
+						  CFQ_IDLE_DELAY;
 		} else
-			rb_key += jiffies;
+			queue_entity->vdisktime = service_tree->min_vdisktime;
 	} else if (!add_front) {
 		/*
-		 * Get our rb key offset. Subtract any residual slice
-		 * value carried from last service. A negative resid
-		 * count indicates slice overrun, and this should position
-		 * the next service time further away in the tree.
-		 */
-		rb_key = cfq_slice_offset(cfqd, cfqq) + jiffies;
-		rb_key -= cfqq->slice_resid;
-		cfqq->slice_resid = 0;
-	} else {
-		rb_key = -HZ;
-		__queue_entity = cfq_rb_first(service_tree);
-		rb_key += __queue_entity ? __queue_entity->rb_key : jiffies;
-	}
-
-	if (!RB_EMPTY_NODE(&queue_entity->rb_node)) {
-		new_cfqq = 0;
-		/*
-		 * same position, nothing more to do
+		 * We charge the CFQ queue by the time this queue runs, and
+		 * repsition it on the service tree.
 		 */
-		if (rb_key == queue_entity->rb_key &&
-		    queue_entity->service_tree == service_tree)
-			return;
+		unsigned int used_sl;
 
-		cfq_rb_erase(&queue_entity->rb_node,
-			     queue_entity->service_tree);
-		queue_entity->service_tree = NULL;
+		used_sl = cfq_cfqq_slice_usage(cfqq);
+		queue_entity->vdisktime += cfq_scale_slice(used_sl,
+							   queue_entity);
+	} else {
+		queue_entity->vdisktime = service_tree->min_vdisktime;
 	}
 
+insert:
 	left = 1;
 	parent = NULL;
 	queue_entity->service_tree = service_tree;
 	p = &service_tree->rb.rb_node;
+	key = entity_key(service_tree, queue_entity);
 	while (*p) {
 		struct rb_node **n;
 
@@ -1304,7 +1344,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		/*
 		 * sort by key, that represents service time.
 		 */
-		if (time_before(rb_key, __queue_entity->rb_key))
+		if (key < entity_key(service_tree, __queue_entity))
 			n = &(*p)->rb_left;
 		else {
 			n = &(*p)->rb_right;
@@ -1317,10 +1357,12 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	if (left)
 		service_tree->left = &queue_entity->rb_node;
 
-	queue_entity->rb_key = rb_key;
 	rb_link_node(&queue_entity->rb_node, parent, p);
 	rb_insert_color(&queue_entity->rb_node, &service_tree->rb);
+	update_min_vdisktime(service_tree);
 	service_tree->count++;
+	service_tree->total_weight += queue_entity->weight;
+	cfqq->reposition_time = jiffies;
 	if ((add_front || !new_cfqq) && !group_changed)
 		return;
 	cfq_group_service_tree_add(cfqd, cfqq->cfqg);
@@ -1422,15 +1464,19 @@ static void cfq_add_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
 	struct io_sched_entity *queue_entity;
+	struct cfq_rb_root *service_tree;
+
 	cfq_log_cfqq(cfqd, cfqq, "del_from_rr");
 	BUG_ON(!cfq_cfqq_on_rr(cfqq));
 	cfq_clear_cfqq_on_rr(cfqq);
 
 	queue_entity = &cfqq->queue_entity;
+	service_tree = queue_entity->service_tree;
 
 	if (!RB_EMPTY_NODE(&queue_entity->rb_node)) {
 		cfq_rb_erase(&queue_entity->rb_node,
 			     queue_entity->service_tree);
+		service_tree->total_weight -= queue_entity->weight;
 		queue_entity->service_tree = NULL;
 	}
 	if (cfqq->p_root) {
@@ -2132,24 +2178,35 @@ static void cfq_setup_merge(struct cfq_queue *cfqq, struct cfq_queue *new_cfqq)
 	}
 }
 
+/*
+ * The time when a CFQ queue is put onto a service tree is recoreded in
+ * cfqq->reposition_time. Currently, we check the first priority CFQ queues
+ * on each service tree, and select the workload type that contain the lowest
+ * reposition_time CFQ queue among them.
+ */
 static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
 				struct cfq_group *cfqg, enum wl_prio_t prio)
 {
 	struct io_sched_entity *queue_entity;
+	struct cfq_queue *cfqq;
+	unsigned long lowest_start_time;
 	int i;
-	bool key_valid = false;
-	unsigned long lowest_key = 0;
+	bool time_valid = false;
 	enum wl_type_t cur_best = SYNC_NOIDLE_WORKLOAD;
 
+	/*
+	 * TODO: We may take io priority into account when choosing a workload
+	 * type. But for the time being just make use of reposition_time only.
+	 */
 	for (i = 0; i <= SYNC_WORKLOAD; ++i) {
-		/* select the one with lowest rb_key */
 		queue_entity = cfq_rb_first(service_tree_for(cfqg, prio, i));
+		cfqq = cfqq_of_entity(queue_entity);
 		if (queue_entity &&
-		    (!key_valid ||
-		     time_before(queue_entity->rb_key, lowest_key))) {
-			lowest_key = queue_entity->rb_key;
+		    (!time_valid ||
+		     cfqq->reposition_time < lowest_start_time)) {
+			lowest_start_time = cfqq->reposition_time;
 			cur_best = i;
-			key_valid = true;
+			time_valid = true;
 		}
 	}
 
@@ -2811,10 +2868,13 @@ static void cfq_init_prio_data(struct cfq_queue *cfqq, struct io_context *ioc)
 {
 	struct task_struct *tsk = current;
 	int ioprio_class;
+	struct io_sched_entity *queue_entity;
 
 	if (!cfq_cfqq_prio_changed(cfqq))
 		return;
 
+	queue_entity = &cfqq->queue_entity;
+
 	ioprio_class = IOPRIO_PRIO_CLASS(ioc->ioprio);
 	switch (ioprio_class) {
 	default:
@@ -2841,6 +2901,8 @@ static void cfq_init_prio_data(struct cfq_queue *cfqq, struct io_context *ioc)
 		break;
 	}
 
+	queue_entity->weight = cfq_prio_to_weight(cfqq->ioprio);
+
 	/*
 	 * keep track of original prio settings in case we have to temporarily
 	 * elevate the priority of this queue
@@ -3571,6 +3633,9 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
  */
 static void cfq_prio_boost(struct cfq_queue *cfqq)
 {
+	struct io_sched_entity *queue_entity;
+
+	queue_entity = &cfqq->queue_entity;
 	if (has_fs_excl()) {
 		/*
 		 * boost idle prio on transactions that would lock out other
@@ -3587,6 +3652,11 @@ static void cfq_prio_boost(struct cfq_queue *cfqq)
 		cfqq->ioprio_class = cfqq->org_ioprio_class;
 		cfqq->ioprio = cfqq->org_ioprio;
 	}
+
+	/*
+	 * update the io weight if io priority gets changed.
+	 */
+	queue_entity->weight = cfq_prio_to_weight(cfqq->ioprio);
 }
 
 static inline int __cfq_may_queue(struct cfq_queue *cfqq)
-- 
1.6.5.2






-- 
Regards
Gui Jianfeng
