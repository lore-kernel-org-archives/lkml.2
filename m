Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab0KOA4s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 19:56:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52874 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751617Ab0KOA4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 19:56:47 -0500
Message-ID: <4CE08545.9010008@cn.fujitsu.com>
Date: Mon, 15 Nov 2010 08:56:37 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>
CC: Corrado Zoccolo <czoccolo@gmail.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: [RFC] [PATCH 5/8] cfq-iosched: Extract some common code of service
 tree handling for CFQ queue and CFQ group.
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-15 08:57:07,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-15 08:57:12,
	Serialize complete at 2010-11-15 08:57:12
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extract some common code of service tree handling for CFQ queue
and CFQ group. This helps when CFQ queue and CFQ group are scheduling
together.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/cfq-iosched.c |  114 ++++++++++++++++++++++----------------------------
 1 files changed, 50 insertions(+), 64 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index ad577b5..1b9b4b2 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -855,20 +855,20 @@ entity_key(struct cfq_rb_root *st, struct io_sched_entity *entity)
 }
 
 static void
-__cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
+__io_entity_service_tree_add(struct cfq_rb_root *st,
+			   struct io_sched_entity *io_entity)
 {
 	struct rb_node **node = &st->rb.rb_node;
 	struct rb_node *parent = NULL;
-	struct io_sched_entity *__group_entity;
-	struct io_sched_entity *group_entity = &cfqg->group_entity;
-	s64 key = entity_key(st, group_entity);
+	struct io_sched_entity *__io_entity;
+	s64 key = entity_key(st, io_entity);
 	int left = 1;
 
 	while (*node != NULL) {
 		parent = *node;
-		__group_entity = rb_entry_entity(parent);
+		__io_entity = rb_entry_entity(parent);
 
-		if (key < entity_key(st, __group_entity))
+		if (key < entity_key(st, __io_entity))
 			node = &parent->rb_left;
 		else {
 			node = &parent->rb_right;
@@ -877,10 +877,21 @@ __cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
 	}
 
 	if (left)
-		st->left = &group_entity->rb_node;
+		st->left = &io_entity->rb_node;
 
-	rb_link_node(&group_entity->rb_node, parent, node);
-	rb_insert_color(&group_entity->rb_node, &st->rb);
+	rb_link_node(&io_entity->rb_node, parent, node);
+	rb_insert_color(&io_entity->rb_node, &st->rb);
+}
+
+static void
+io_entity_service_tree_add(struct cfq_rb_root *st,
+			   struct io_sched_entity *io_entity)
+{
+	__io_entity_service_tree_add(st, io_entity);
+	st->count++;
+	st->total_weight += io_entity->weight;
+	if (io_entity->is_group_entity)
+		io_entity->on_st = true;
 }
 
 static void
@@ -908,9 +919,27 @@ cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	} else
 		group_entity->vdisktime = st->min_vdisktime;
 
-	__cfq_group_service_tree_add(st, cfqg);
-	group_entity->on_st = true;
-	st->total_weight += group_entity->weight;
+	io_entity_service_tree_add(st, group_entity);
+}
+
+static void
+__io_entity_service_tree_del(struct cfq_rb_root *st,
+			   struct io_sched_entity *io_entity)
+{
+	cfq_rb_erase(&io_entity->rb_node, st);
+}
+
+static void
+io_entity_service_tree_del(struct cfq_rb_root *st,
+			   struct io_sched_entity *io_entity)
+{
+	if (!RB_EMPTY_NODE(&io_entity->rb_node)) {
+		__io_entity_service_tree_del(st, io_entity);
+		st->total_weight -= io_entity->weight;
+		if (io_entity->is_group_entity)
+			io_entity->on_st = false;
+		io_entity->service_tree = NULL;
+	}
 }
 
 static void
@@ -927,10 +956,7 @@ cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
 		return;
 
 	cfq_log_cfqg(cfqd, cfqg, "del_from_rr group");
-	group_entity->on_st = false;
-	st->total_weight -= group_entity->weight;
-	if (!RB_EMPTY_NODE(&group_entity->rb_node))
-		cfq_rb_erase(&group_entity->rb_node, st);
+	io_entity_service_tree_del(st, group_entity);
 	cfqg->saved_workload_slice = 0;
 	cfq_blkiocg_update_dequeue_stats(&cfqg->blkg, 1);
 }
@@ -979,9 +1005,9 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 		charge = cfqq->allocated_slice;
 
 	/* Can't update vdisktime while group is on service tree */
-	cfq_rb_erase(&group_entity->rb_node, st);
+	__io_entity_service_tree_del(st, group_entity);
 	group_entity->vdisktime += cfq_scale_slice(charge, group_entity);
-	__cfq_group_service_tree_add(st, cfqg);
+	__io_entity_service_tree_add(st, group_entity);
 
 	/* This group is being expired. Save the context */
 	if (time_after(cfqd->workload_expires, jiffies)) {
@@ -1209,13 +1235,11 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 				 bool add_front)
 {
 	struct io_sched_entity *queue_entity;
-	struct rb_node **p, *parent;
+	struct rb_node *parent;
 	struct io_sched_entity *__queue_entity;
 	struct cfq_rb_root *service_tree, *orig_st;
-	int left;
 	int new_cfqq = 1;
 	int group_changed = 0;
-	s64 key;
 
 	queue_entity = &cfqq->queue_entity;
 	orig_st = queue_entity->service_tree;
@@ -1232,9 +1256,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 			 * Group changed, dequeue this CFQ queue from the
 			 * original service tree.
 			 */
-			cfq_rb_erase(&queue_entity->rb_node,
-				     queue_entity->service_tree);
-			orig_st->total_weight -= queue_entity->weight;
+			io_entity_service_tree_del(orig_st, queue_entity);
 		}
 		cfqq->orig_cfqg = cfqq->cfqg;
 		cfqq->cfqg = &cfqd->root_group;
@@ -1250,9 +1272,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 			 * Group changed, dequeue this CFQ queue from the
 			 * original service tree.
 			 */
-			cfq_rb_erase(&queue_entity->rb_node,
-				     queue_entity->service_tree);
-			orig_st->total_weight -= queue_entity->weight;
+			io_entity_service_tree_del(orig_st, queue_entity);
 		}
 		cfq_put_cfqg(cfqq->cfqg);
 		cfqq->cfqg = cfqq->orig_cfqg;
@@ -1290,9 +1310,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	 * Ok, we get here, this CFQ queue is on the service tree, dequeue it
 	 * firstly.
 	 */
-	cfq_rb_erase(&queue_entity->rb_node,
-		     queue_entity->service_tree);
-	orig_st->total_weight -= queue_entity->weight;
+	io_entity_service_tree_del(orig_st, queue_entity);
 
 	new_cfqq = 0;
 	if (cfq_class_idle(cfqq)) {
@@ -1320,39 +1338,10 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	}
 
 insert:
-	left = 1;
-	parent = NULL;
 	queue_entity->service_tree = service_tree;
-	p = &service_tree->rb.rb_node;
-	key = entity_key(service_tree, queue_entity);
-	while (*p) {
-		struct rb_node **n;
-
-		parent = *p;
-		__queue_entity = rb_entry(parent, struct io_sched_entity,
-					  rb_node);
-
-		/*
-		 * sort by key, that represents service time.
-		 */
-		if (key < entity_key(service_tree, __queue_entity))
-			n = &(*p)->rb_left;
-		else {
-			n = &(*p)->rb_right;
-			left = 0;
-		}
-
-		p = n;
-	}
-
-	if (left)
-		service_tree->left = &queue_entity->rb_node;
+	io_entity_service_tree_add(service_tree, queue_entity);
 
-	rb_link_node(&queue_entity->rb_node, parent, p);
-	rb_insert_color(&queue_entity->rb_node, &service_tree->rb);
 	update_min_vdisktime(service_tree);
-	service_tree->count++;
-	service_tree->total_weight += queue_entity->weight;
 	cfqq->reposition_time = jiffies;
 	if ((add_front || !new_cfqq) && !group_changed)
 		return;
@@ -1465,10 +1454,7 @@ static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	service_tree = queue_entity->service_tree;
 
 	if (!RB_EMPTY_NODE(&queue_entity->rb_node)) {
-		cfq_rb_erase(&queue_entity->rb_node,
-			     queue_entity->service_tree);
-		service_tree->total_weight -= queue_entity->weight;
-		queue_entity->service_tree = NULL;
+		io_entity_service_tree_del(service_tree, queue_entity);
 	}
 	if (cfqq->p_root) {
 		rb_erase(&cfqq->p_node, cfqq->p_root);
-- 
1.6.5.2

