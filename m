Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab1BJHqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 02:46:44 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61698 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750738Ab1BJHqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 02:46:43 -0500
Message-ID: <4D5397E0.9000704@cn.fujitsu.com>
Date: Thu, 10 Feb 2011 15:46:40 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>
CC: Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        Chad Talbott <ctalbott@google.com>, Divyesh Shah <dpshah@google.com>
Subject: [PATCH 1/6 v4] cfq-iosched: Introduce cfq_entity for CFQ queue
References: <4D51ED26.8050809@cn.fujitsu.com>
In-Reply-To: <4D51ED26.8050809@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-10 15:45:49,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-10 15:45:51,
	Serialize complete at 2011-02-10 15:45:51
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce cfq_entity for CFQ queue

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/cfq-iosched.c |  118 ++++++++++++++++++++++++++++++++------------------
 1 files changed, 75 insertions(+), 43 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index f083bda..939c6a6 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -92,19 +92,29 @@ struct cfq_rb_root {
 			.count = 0, .min_vdisktime = 0, }
 
 /*
+ * This's the CFQ queue schedule entity which is scheduled on  service tree.
+ */
+struct cfq_entity {
+	/* service tree */
+	struct cfq_rb_root *service_tree;
+	/* service_tree member */
+	struct rb_node rb_node;
+	/* service_tree key, represent the position on the tree */
+	unsigned long rb_key;
+};
+
+/*
  * Per process-grouping structure
  */
 struct cfq_queue {
+	/* The schedule entity */
+	struct cfq_entity cfqe;
 	/* reference count */
 	int ref;
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
@@ -143,7 +153,6 @@ struct cfq_queue {
 	u32 seek_history;
 	sector_t last_request_pos;
 
-	struct cfq_rb_root *service_tree;
 	struct cfq_queue *new_cfqq;
 	struct cfq_group *cfqg;
 	struct cfq_group *orig_cfqg;
@@ -302,6 +311,15 @@ struct cfq_data {
 	struct rcu_head rcu;
 };
 
+static inline struct cfq_queue *
+cfqq_of_entity(struct cfq_entity *cfqe)
+{
+	if (cfqe)
+		return container_of(cfqe, struct cfq_queue, cfqe);
+
+	return NULL;
+}
+
 static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
 
 static struct cfq_rb_root *service_tree_for(struct cfq_group *cfqg,
@@ -743,7 +761,7 @@ cfq_choose_req(struct cfq_data *cfqd, struct request *rq1, struct request *rq2,
 /*
  * The below is leftmost cache rbtree addon
  */
-static struct cfq_queue *cfq_rb_first(struct cfq_rb_root *root)
+static struct cfq_entity *cfq_rb_first(struct cfq_rb_root *root)
 {
 	/* Service tree is empty */
 	if (!root->count)
@@ -753,7 +771,7 @@ static struct cfq_queue *cfq_rb_first(struct cfq_rb_root *root)
 		root->left = rb_first(&root->rb);
 
 	if (root->left)
-		return rb_entry(root->left, struct cfq_queue, rb_node);
+		return rb_entry(root->left, struct cfq_entity, rb_node);
 
 	return NULL;
 }
@@ -1171,21 +1189,24 @@ static inline void cfq_put_cfqg(struct cfq_group *cfqg) {}
 static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 				 bool add_front)
 {
+	struct cfq_entity *cfqe;
 	struct rb_node **p, *parent;
-	struct cfq_queue *__cfqq;
+	struct cfq_entity *__cfqe;
 	unsigned long rb_key;
 	struct cfq_rb_root *service_tree;
 	int left;
 	int new_cfqq = 1;
 	int group_changed = 0;
 
+	cfqe = &cfqq->cfqe;
+
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 	if (!cfqd->cfq_group_isolation
 	    && cfqq_type(cfqq) == SYNC_NOIDLE_WORKLOAD
 	    && cfqq->cfqg && cfqq->cfqg != &cfqd->root_group) {
 		/* Move this cfq to root group */
 		cfq_log_cfqq(cfqd, cfqq, "moving to root group");
-		if (!RB_EMPTY_NODE(&cfqq->rb_node))
+		if (!RB_EMPTY_NODE(&cfqe->rb_node))
 			cfq_group_service_tree_del(cfqd, cfqq->cfqg);
 		cfqq->orig_cfqg = cfqq->cfqg;
 		cfqq->cfqg = &cfqd->root_group;
@@ -1195,7 +1216,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		   && cfqq_type(cfqq) == SYNC_WORKLOAD && cfqq->orig_cfqg) {
 		/* cfqq is sequential now needs to go to its original group */
 		BUG_ON(cfqq->cfqg != &cfqd->root_group);
-		if (!RB_EMPTY_NODE(&cfqq->rb_node))
+		if (!RB_EMPTY_NODE(&cfqe->rb_node))
 			cfq_group_service_tree_del(cfqd, cfqq->cfqg);
 		cfq_put_cfqg(cfqq->cfqg);
 		cfqq->cfqg = cfqq->orig_cfqg;
@@ -1210,9 +1231,9 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	if (cfq_class_idle(cfqq)) {
 		rb_key = CFQ_IDLE_DELAY;
 		parent = rb_last(&service_tree->rb);
-		if (parent && parent != &cfqq->rb_node) {
-			__cfqq = rb_entry(parent, struct cfq_queue, rb_node);
-			rb_key += __cfqq->rb_key;
+		if (parent && parent != &cfqe->rb_node) {
+			__cfqe = rb_entry(parent, struct cfq_entity, rb_node);
+			rb_key += __cfqe->rb_key;
 		} else
 			rb_key += jiffies;
 	} else if (!add_front) {
@@ -1227,37 +1248,37 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		cfqq->slice_resid = 0;
 	} else {
 		rb_key = -HZ;
-		__cfqq = cfq_rb_first(service_tree);
-		rb_key += __cfqq ? __cfqq->rb_key : jiffies;
+		__cfqe = cfq_rb_first(service_tree);
+		rb_key += __cfqe ? __cfqe->rb_key : jiffies;
 	}
 
-	if (!RB_EMPTY_NODE(&cfqq->rb_node)) {
+	if (!RB_EMPTY_NODE(&cfqe->rb_node)) {
 		new_cfqq = 0;
 		/*
 		 * same position, nothing more to do
 		 */
-		if (rb_key == cfqq->rb_key &&
-		    cfqq->service_tree == service_tree)
+		if (rb_key == cfqe->rb_key &&
+		    cfqe->service_tree == service_tree)
 			return;
 
-		cfq_rb_erase(&cfqq->rb_node, cfqq->service_tree);
-		cfqq->service_tree = NULL;
+		cfq_rb_erase(&cfqe->rb_node, cfqe->service_tree);
+		cfqe->service_tree = NULL;
 	}
 
 	left = 1;
 	parent = NULL;
-	cfqq->service_tree = service_tree;
+	cfqe->service_tree = service_tree;
 	p = &service_tree->rb.rb_node;
 	while (*p) {
 		struct rb_node **n;
 
 		parent = *p;
-		__cfqq = rb_entry(parent, struct cfq_queue, rb_node);
+		__cfqe = rb_entry(parent, struct cfq_entity, rb_node);
 
 		/*
 		 * sort by key, that represents service time.
 		 */
-		if (time_before(rb_key, __cfqq->rb_key))
+		if (time_before(rb_key, __cfqe->rb_key))
 			n = &(*p)->rb_left;
 		else {
 			n = &(*p)->rb_right;
@@ -1268,11 +1289,11 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	}
 
 	if (left)
-		service_tree->left = &cfqq->rb_node;
+		service_tree->left = &cfqe->rb_node;
 
-	cfqq->rb_key = rb_key;
-	rb_link_node(&cfqq->rb_node, parent, p);
-	rb_insert_color(&cfqq->rb_node, &service_tree->rb);
+	cfqe->rb_key = rb_key;
+	rb_link_node(&cfqe->rb_node, parent, p);
+	rb_insert_color(&cfqe->rb_node, &service_tree->rb);
 	service_tree->count++;
 	if ((add_front || !new_cfqq) && !group_changed)
 		return;
@@ -1374,13 +1395,16 @@ static void cfq_add_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
  */
 static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
+	struct cfq_entity *cfqe;
 	cfq_log_cfqq(cfqd, cfqq, "del_from_rr");
 	BUG_ON(!cfq_cfqq_on_rr(cfqq));
 	cfq_clear_cfqq_on_rr(cfqq);
 
-	if (!RB_EMPTY_NODE(&cfqq->rb_node)) {
-		cfq_rb_erase(&cfqq->rb_node, cfqq->service_tree);
-		cfqq->service_tree = NULL;
+	cfqe = &cfqq->cfqe;
+
+	if (!RB_EMPTY_NODE(&cfqe->rb_node)) {
+		cfq_rb_erase(&cfqe->rb_node, cfqe->service_tree);
+		cfqe->service_tree = NULL;
 	}
 	if (cfqq->p_root) {
 		rb_erase(&cfqq->p_node, cfqq->p_root);
@@ -1708,13 +1732,13 @@ static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
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
+	struct cfq_entity *cfqe;
 	int i, j;
 	struct cfq_rb_root *st;
 
@@ -1725,9 +1749,11 @@ static struct cfq_queue *cfq_get_next_queue_forced(struct cfq_data *cfqd)
 	if (!cfqg)
 		return NULL;
 
-	for_each_cfqg_st(cfqg, i, j, st)
-		if ((cfqq = cfq_rb_first(st)) != NULL)
-			return cfqq;
+	for_each_cfqg_st(cfqg, i, j, st) {
+		cfqe = cfq_rb_first(st);
+		if (cfqe != NULL)
+			return cfqq_of_entity(cfqe);
+	}
 	return NULL;
 }
 
@@ -1864,9 +1890,12 @@ static struct cfq_queue *cfq_close_cooperator(struct cfq_data *cfqd,
 
 static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
+	struct cfq_entity *cfqe;
 	enum wl_prio_t prio = cfqq_prio(cfqq);
-	struct cfq_rb_root *service_tree = cfqq->service_tree;
+	struct cfq_rb_root *service_tree;
 
+	cfqe = &cfqq->cfqe;
+	service_tree = cfqe->service_tree;
 	BUG_ON(!service_tree);
 	BUG_ON(!service_tree->count);
 
@@ -2076,7 +2105,7 @@ static void cfq_setup_merge(struct cfq_queue *cfqq, struct cfq_queue *new_cfqq)
 static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
 				struct cfq_group *cfqg, enum wl_prio_t prio)
 {
-	struct cfq_queue *queue;
+	struct cfq_entity *cfqe;
 	int i;
 	bool key_valid = false;
 	unsigned long lowest_key = 0;
@@ -2084,10 +2113,10 @@ static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
 
 	for (i = 0; i <= SYNC_WORKLOAD; ++i) {
 		/* select the one with lowest rb_key */
-		queue = cfq_rb_first(service_tree_for(cfqg, prio, i));
-		if (queue &&
-		    (!key_valid || time_before(queue->rb_key, lowest_key))) {
-			lowest_key = queue->rb_key;
+		cfqe = cfq_rb_first(service_tree_for(cfqg, prio, i));
+		if (cfqe &&
+		    (!key_valid || time_before(cfqe->rb_key, lowest_key))) {
+			lowest_key = cfqe->rb_key;
 			cur_best = i;
 			key_valid = true;
 		}
@@ -2835,7 +2864,10 @@ static void cfq_ioc_set_ioprio(struct io_context *ioc)
 static void cfq_init_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 			  pid_t pid, bool is_sync)
 {
-	RB_CLEAR_NODE(&cfqq->rb_node);
+	struct cfq_entity *cfqe;
+
+	cfqe = &cfqq->cfqe;
+	RB_CLEAR_NODE(&cfqe->rb_node);
 	RB_CLEAR_NODE(&cfqq->p_node);
 	INIT_LIST_HEAD(&cfqq->fifo);
 
@@ -3244,7 +3276,7 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 	/* Allow preemption only if we are idling on sync-noidle tree */
 	if (cfqd->serving_type == SYNC_NOIDLE_WORKLOAD &&
 	    cfqq_type(new_cfqq) == SYNC_NOIDLE_WORKLOAD &&
-	    new_cfqq->service_tree->count == 2 &&
+	    new_cfqq->cfqe.service_tree->count == 2 &&
 	    RB_EMPTY_ROOT(&cfqq->sort_list))
 		return true;
 
-- 
1.7.1


