Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab0KOAwC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 19:52:02 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60812 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755027Ab0KOAwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 19:52:00 -0500
Message-ID: <4CE0842A.4040903@cn.fujitsu.com>
Date: Mon, 15 Nov 2010 08:51:54 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: [RFC] [PATCH 1/8] cfq-iosched: Introduce io_sched_entity for CFQ
 queue
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-15 08:52:24,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-15 08:52:24,
	Serialize complete at 2010-11-15 08:52:24
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

introduce io_sched_entity for CFQ queue.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/cfq-iosched.c |  125 +++++++++++++++++++++++++++++++++-----------------
 1 files changed, 82 insertions(+), 43 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 28a54b0..1f099a4 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -92,20 +92,31 @@ struct cfq_rb_root {
 #define CFQ_RB_ROOT	(struct cfq_rb_root) { .rb = RB_ROOT, .left = NULL, \
 			.count = 0, .min_vdisktime = 0, }
 
+
+/*
+ * This's the CFQ queue schedule entity which is scheduled on  service tree.
+ */
+struct io_sched_entity {
+	/* service tree */
+	struct cfq_rb_root *service_tree;
+	/* service_tree member */
+	struct rb_node rb_node;
+	/* service_tree key, represent the position on the tree */
+	unsigned long rb_key;
+};
+
 /*
  * Per process-grouping structure
  */
 struct cfq_queue {
+	/* The schedule entity */
+	struct io_sched_entity queue_entity;
 	/* reference count */
 	atomic_t ref;
 	/* various state flags, see below */
 	unsigned int flags;
 	/* parent cfq_data */
 	struct cfq_data *cfqd;
-	/* service_tree member */
-	struct rb_node rb_node;
-	/* service_tree key */
-	unsigned long rb_key;
 	/* prio tree member */
 	struct rb_node p_node;
 	/* prio tree root we belong to, if any */
@@ -144,7 +155,6 @@ struct cfq_queue {
 	u32 seek_history;
 	sector_t last_request_pos;
 
-	struct cfq_rb_root *service_tree;
 	struct cfq_queue *new_cfqq;
 	struct cfq_group *cfqg;
 	struct cfq_group *orig_cfqg;
@@ -294,6 +304,15 @@ struct cfq_data {
 	struct rcu_head rcu;
 };
 
+static inline struct cfq_queue *
+cfqq_of_entity(struct io_sched_entity *queue_entity)
+{
+	if (queue_entity)
+		return container_of(queue_entity, struct cfq_queue,
+				    queue_entity);
+	return NULL;
+}
+
 static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
 
 static struct cfq_rb_root *service_tree_for(struct cfq_group *cfqg,
@@ -740,7 +759,7 @@ cfq_choose_req(struct cfq_data *cfqd, struct request *rq1, struct request *rq2,
 /*
  * The below is leftmost cache rbtree addon
  */
-static struct cfq_queue *cfq_rb_first(struct cfq_rb_root *root)
+static struct io_sched_entity *cfq_rb_first(struct cfq_rb_root *root)
 {
 	/* Service tree is empty */
 	if (!root->count)
@@ -750,7 +769,7 @@ static struct cfq_queue *cfq_rb_first(struct cfq_rb_root *root)
 		root->left = rb_first(&root->rb);
 
 	if (root->left)
-		return rb_entry(root->left, struct cfq_queue, rb_node);
+		return rb_entry(root->left, struct io_sched_entity, rb_node);
 
 	return NULL;
 }
@@ -1172,21 +1191,24 @@ static inline void cfq_put_cfqg(struct cfq_group *cfqg) {}
 static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 				 bool add_front)
 {
+	struct io_sched_entity *queue_entity;
 	struct rb_node **p, *parent;
-	struct cfq_queue *__cfqq;
+	struct io_sched_entity *__queue_entity;
 	unsigned long rb_key;
 	struct cfq_rb_root *service_tree;
 	int left;
 	int new_cfqq = 1;
 	int group_changed = 0;
 
+	queue_entity = &cfqq->queue_entity;
+
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 	if (!cfqd->cfq_group_isolation
 	    && cfqq_type(cfqq) == SYNC_NOIDLE_WORKLOAD
 	    && cfqq->cfqg && cfqq->cfqg != &cfqd->root_group) {
 		/* Move this cfq to root group */
 		cfq_log_cfqq(cfqd, cfqq, "moving to root group");
-		if (!RB_EMPTY_NODE(&cfqq->rb_node))
+		if (!RB_EMPTY_NODE(&queue_entity->rb_node))
 			cfq_group_service_tree_del(cfqd, cfqq->cfqg);
 		cfqq->orig_cfqg = cfqq->cfqg;
 		cfqq->cfqg = &cfqd->root_group;
@@ -1196,7 +1218,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		   && cfqq_type(cfqq) == SYNC_WORKLOAD && cfqq->orig_cfqg) {
 		/* cfqq is sequential now needs to go to its original group */
 		BUG_ON(cfqq->cfqg != &cfqd->root_group);
-		if (!RB_EMPTY_NODE(&cfqq->rb_node))
+		if (!RB_EMPTY_NODE(&queue_entity->rb_node))
 			cfq_group_service_tree_del(cfqd, cfqq->cfqg);
 		cfq_put_cfqg(cfqq->cfqg);
 		cfqq->cfqg = cfqq->orig_cfqg;
@@ -1211,9 +1233,11 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	if (cfq_class_idle(cfqq)) {
 		rb_key = CFQ_IDLE_DELAY;
 		parent = rb_last(&service_tree->rb);
-		if (parent && parent != &cfqq->rb_node) {
-			__cfqq = rb_entry(parent, struct cfq_queue, rb_node);
-			rb_key += __cfqq->rb_key;
+		if (parent && parent != &queue_entity->rb_node) {
+			__queue_entity = rb_entry(parent,
+						  struct io_sched_entity,
+						  rb_node);
+			rb_key += __queue_entity->rb_key;
 		} else
 			rb_key += jiffies;
 	} else if (!add_front) {
@@ -1228,37 +1252,39 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		cfqq->slice_resid = 0;
 	} else {
 		rb_key = -HZ;
-		__cfqq = cfq_rb_first(service_tree);
-		rb_key += __cfqq ? __cfqq->rb_key : jiffies;
+		__queue_entity = cfq_rb_first(service_tree);
+		rb_key += __queue_entity ? __queue_entity->rb_key : jiffies;
 	}
 
-	if (!RB_EMPTY_NODE(&cfqq->rb_node)) {
+	if (!RB_EMPTY_NODE(&queue_entity->rb_node)) {
 		new_cfqq = 0;
 		/*
 		 * same position, nothing more to do
 		 */
-		if (rb_key == cfqq->rb_key &&
-		    cfqq->service_tree == service_tree)
+		if (rb_key == queue_entity->rb_key &&
+		    queue_entity->service_tree == service_tree)
 			return;
 
-		cfq_rb_erase(&cfqq->rb_node, cfqq->service_tree);
-		cfqq->service_tree = NULL;
+		cfq_rb_erase(&queue_entity->rb_node,
+			     queue_entity->service_tree);
+		queue_entity->service_tree = NULL;
 	}
 
 	left = 1;
 	parent = NULL;
-	cfqq->service_tree = service_tree;
+	queue_entity->service_tree = service_tree;
 	p = &service_tree->rb.rb_node;
 	while (*p) {
 		struct rb_node **n;
 
 		parent = *p;
-		__cfqq = rb_entry(parent, struct cfq_queue, rb_node);
+		__queue_entity = rb_entry(parent, struct io_sched_entity,
+					  rb_node);
 
 		/*
 		 * sort by key, that represents service time.
 		 */
-		if (time_before(rb_key, __cfqq->rb_key))
+		if (time_before(rb_key, __queue_entity->rb_key))
 			n = &(*p)->rb_left;
 		else {
 			n = &(*p)->rb_right;
@@ -1269,11 +1295,11 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	}
 
 	if (left)
-		service_tree->left = &cfqq->rb_node;
+		service_tree->left = &queue_entity->rb_node;
 
-	cfqq->rb_key = rb_key;
-	rb_link_node(&cfqq->rb_node, parent, p);
-	rb_insert_color(&cfqq->rb_node, &service_tree->rb);
+	queue_entity->rb_key = rb_key;
+	rb_link_node(&queue_entity->rb_node, parent, p);
+	rb_insert_color(&queue_entity->rb_node, &service_tree->rb);
 	service_tree->count++;
 	if ((add_front || !new_cfqq) && !group_changed)
 		return;
@@ -1375,13 +1401,17 @@ static void cfq_add_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
  */
 static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
+	struct io_sched_entity *queue_entity;
 	cfq_log_cfqq(cfqd, cfqq, "del_from_rr");
 	BUG_ON(!cfq_cfqq_on_rr(cfqq));
 	cfq_clear_cfqq_on_rr(cfqq);
 
-	if (!RB_EMPTY_NODE(&cfqq->rb_node)) {
-		cfq_rb_erase(&cfqq->rb_node, cfqq->service_tree);
-		cfqq->service_tree = NULL;
+	queue_entity = &cfqq->queue_entity;
+
+	if (!RB_EMPTY_NODE(&queue_entity->rb_node)) {
+		cfq_rb_erase(&queue_entity->rb_node,
+			     queue_entity->service_tree);
+		queue_entity->service_tree = NULL;
 	}
 	if (cfqq->p_root) {
 		rb_erase(&cfqq->p_node, cfqq->p_root);
@@ -1712,13 +1742,13 @@ static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 		return NULL;
 	if (RB_EMPTY_ROOT(&service_tree->rb))
 		return NULL;
-	return cfq_rb_first(service_tree);
+	return cfqq_of_entity(cfq_rb_first(service_tree));
 }
 
 static struct cfq_queue *cfq_get_next_queue_forced(struct cfq_data *cfqd)
 {
 	struct cfq_group *cfqg;
-	struct cfq_queue *cfqq;
+	struct io_sched_entity *queue_entity;
 	int i, j;
 	struct cfq_rb_root *st;
 
@@ -1729,9 +1759,11 @@ static struct cfq_queue *cfq_get_next_queue_forced(struct cfq_data *cfqd)
 	if (!cfqg)
 		return NULL;
 
-	for_each_cfqg_st(cfqg, i, j, st)
-		if ((cfqq = cfq_rb_first(st)) != NULL)
-			return cfqq;
+	for_each_cfqg_st(cfqg, i, j, st) {
+		queue_entity = cfq_rb_first(st);
+		if (queue_entity != NULL)
+			return cfqq_of_entity(queue_entity);
+	}
 	return NULL;
 }
 
@@ -1868,9 +1900,12 @@ static struct cfq_queue *cfq_close_cooperator(struct cfq_data *cfqd,
 
 static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
+	struct io_sched_entity *queue_entity;
 	enum wl_prio_t prio = cfqq_prio(cfqq);
-	struct cfq_rb_root *service_tree = cfqq->service_tree;
+	struct cfq_rb_root *service_tree;
 
+	queue_entity = &cfqq->queue_entity;
+	service_tree = queue_entity->service_tree;
 	BUG_ON(!service_tree);
 	BUG_ON(!service_tree->count);
 
@@ -2080,7 +2115,7 @@ static void cfq_setup_merge(struct cfq_queue *cfqq, struct cfq_queue *new_cfqq)
 static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
 				struct cfq_group *cfqg, enum wl_prio_t prio)
 {
-	struct cfq_queue *queue;
+	struct io_sched_entity *queue_entity;
 	int i;
 	bool key_valid = false;
 	unsigned long lowest_key = 0;
@@ -2088,10 +2123,11 @@ static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
 
 	for (i = 0; i <= SYNC_WORKLOAD; ++i) {
 		/* select the one with lowest rb_key */
-		queue = cfq_rb_first(service_tree_for(cfqg, prio, i));
-		if (queue &&
-		    (!key_valid || time_before(queue->rb_key, lowest_key))) {
-			lowest_key = queue->rb_key;
+		queue_entity = cfq_rb_first(service_tree_for(cfqg, prio, i));
+		if (queue_entity &&
+		    (!key_valid ||
+		     time_before(queue_entity->rb_key, lowest_key))) {
+			lowest_key = queue_entity->rb_key;
 			cur_best = i;
 			key_valid = true;
 		}
@@ -2829,7 +2865,10 @@ static void cfq_ioc_set_ioprio(struct io_context *ioc)
 static void cfq_init_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 			  pid_t pid, bool is_sync)
 {
-	RB_CLEAR_NODE(&cfqq->rb_node);
+	struct io_sched_entity *queue_entity;
+
+	queue_entity = &cfqq->queue_entity;
+	RB_CLEAR_NODE(&queue_entity->rb_node);
 	RB_CLEAR_NODE(&cfqq->p_node);
 	INIT_LIST_HEAD(&cfqq->fifo);
 
@@ -3238,7 +3277,7 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 	/* Allow preemption only if we are idling on sync-noidle tree */
 	if (cfqd->serving_type == SYNC_NOIDLE_WORKLOAD &&
 	    cfqq_type(new_cfqq) == SYNC_NOIDLE_WORKLOAD &&
-	    new_cfqq->service_tree->count == 2 &&
+	    new_cfqq->queue_entity.service_tree->count == 2 &&
 	    RB_EMPTY_ROOT(&cfqq->sort_list))
 		return true;
 
-- 
1.6.5.2





-- 
Regards
Gui Jianfeng
