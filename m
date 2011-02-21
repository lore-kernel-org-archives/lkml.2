Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab1BUGQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 01:16:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56915 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753339Ab1BUGQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 01:16:07 -0500
Message-ID: <4D620315.4080409@cn.fujitsu.com>
Date: Mon, 21 Feb 2011 14:15:49 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>
CC: Justin TerAvest <teravest@google.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        Chad Talbott <ctalbott@google.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/6 v5] cfq-iosched: Extract some common code of service tree
 handling for CFQ queue and CFQ group.
References: <4D61FE91.60705@cn.fujitsu.com>
In-Reply-To: <4D61FE91.60705@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-21 14:15:01,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-21 14:15:05,
	Serialize complete at 2011-02-21 14:15:05
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
 block/cfq-iosched.c |   86 +++++++++++++++++++++-----------------------------
 1 files changed, 36 insertions(+), 50 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 81f8eb9..23aa8c5 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -871,12 +871,11 @@ entity_key(struct cfq_rb_root *st, struct cfq_entity *entity)
 }
 
 static void
-__cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
+__cfq_entity_service_tree_add(struct cfq_rb_root *st, struct cfq_entity *cfqe)
 {
 	struct rb_node **node = &st->rb.rb_node;
 	struct rb_node *parent = NULL;
 	struct cfq_entity *__cfqe;
-	struct cfq_entity *cfqe = &cfqg->cfqe;
 	s64 key = entity_key(st, cfqe);
 	int left = 1;
 
@@ -900,6 +899,14 @@ __cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
 }
 
 static void
+cfq_entity_service_tree_add(struct cfq_rb_root *st, struct cfq_entity *cfqe)
+{
+	__cfq_entity_service_tree_add(st, cfqe);
+	st->count++;
+	st->total_weight += cfqe->weight;
+}
+
+static void
 cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
 	struct cfq_rb_root *st = &cfqd->grp_service_tree;
@@ -923,8 +930,23 @@ cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	} else
 		cfqe->vdisktime = st->min_vdisktime;
 
-	__cfq_group_service_tree_add(st, cfqg);
-	st->total_weight += cfqe->weight;
+	cfq_entity_service_tree_add(st, cfqe);
+}
+
+static void
+__cfq_entity_service_tree_del(struct cfq_rb_root *st, struct cfq_entity *cfqe)
+{
+	cfq_rb_erase(&cfqe->rb_node, st);
+}
+
+static void
+cfq_entity_service_tree_del(struct cfq_rb_root *st, struct cfq_entity *cfqe)
+{
+	if (!RB_EMPTY_NODE(&cfqe->rb_node)) {
+		__cfq_entity_service_tree_del(st, cfqe);
+		st->total_weight -= cfqe->weight;
+		cfqe->service_tree = NULL;
+	}
 }
 
 static void
@@ -941,9 +963,7 @@ cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
 		return;
 
 	cfq_log_cfqg(cfqd, cfqg, "del_from_rr group");
-	st->total_weight -= cfqe->weight;
-	if (!RB_EMPTY_NODE(&cfqe->rb_node))
-		cfq_rb_erase(&cfqe->rb_node, st);
+	cfq_entity_service_tree_del(st, cfqe);
 	cfqg->saved_workload_slice = 0;
 	cfq_blkiocg_update_dequeue_stats(&cfqg->blkg, 1);
 }
@@ -992,9 +1012,9 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 		charge = cfqq->allocated_slice;
 
 	/* Can't update vdisktime while group is on service tree */
-	cfq_rb_erase(&cfqe->rb_node, st);
+	__cfq_entity_service_tree_del(st, cfqe);
 	cfqe->vdisktime += cfq_scale_slice(charge, cfqe);
-	__cfq_group_service_tree_add(st, cfqg);
+	__cfq_entity_service_tree_add(st, cfqe);
 
 	/* This group is being expired. Save the context */
 	if (time_after(cfqd->workload_expires, jiffies)) {
@@ -1231,13 +1251,11 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 				 bool add_front)
 {
 	struct cfq_entity *cfqe;
-	struct rb_node **p, *parent;
+	struct rb_node *parent;
 	struct cfq_entity *__cfqe;
 	struct cfq_rb_root *service_tree, *orig_st;
-	int left;
 	int new_cfqq = 1;
 	int group_changed = 0;
-	s64 key;
 
 	cfqe = &cfqq->cfqe;
 	orig_st = cfqe->service_tree;
@@ -1254,8 +1272,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 			 * Group changed, dequeue this CFQ queue from the
 			 * original service tree.
 			 */
-			cfq_rb_erase(&cfqe->rb_node, cfqe->service_tree);
-			orig_st->total_weight -= cfqe->weight;
+			cfq_entity_service_tree_del(orig_st, cfqe);
 		}
 		cfqq->orig_cfqg = cfqq->cfqg;
 		cfqq->cfqg = &cfqd->root_group;
@@ -1271,8 +1288,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 			 * Group changed, dequeue this CFQ queue from the
 			 * original service tree.
 			 */
-			cfq_rb_erase(&cfqe->rb_node, cfqe->service_tree);
-			orig_st->total_weight -= cfqe->weight;
+			cfq_entity_service_tree_del(orig_st, cfqe);
 		}
 		cfq_put_cfqg(cfqq->cfqg);
 		cfqq->cfqg = cfqq->orig_cfqg;
@@ -1311,8 +1327,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	 * Ok, we get here, this CFQ queue is on the service tree, dequeue it
 	 * firstly.
 	 */
-	cfq_rb_erase(&cfqe->rb_node, cfqe->service_tree);
-	orig_st->total_weight -= cfqe->weight;
+	cfq_entity_service_tree_del(orig_st, cfqe);
 
 	new_cfqq = 0;
 
@@ -1338,38 +1353,11 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	}
 
 insert:
-	left = 1;
-	parent = NULL;
 	cfqe->service_tree = service_tree;
-	p = &service_tree->rb.rb_node;
-	key = entity_key(service_tree, cfqe);
-	while (*p) {
-		struct rb_node **n;
-
-		parent = *p;
-		__cfqe = rb_entry(parent, struct cfq_entity, rb_node);
-
-		/*
-		 * sort by key, that represents service time.
-		 */
-		if (key < entity_key(service_tree, __cfqe))
-			n = &(*p)->rb_left;
-		else {
-			n = &(*p)->rb_right;
-			left = 0;
-		}
-
-		p = n;
-	}
 
-	if (left)
-		service_tree->left = &cfqe->rb_node;
-
-	rb_link_node(&cfqe->rb_node, parent, p);
-	rb_insert_color(&cfqe->rb_node, &service_tree->rb);
+	/* Add cfqq onto service tree. */
+	cfq_entity_service_tree_add(service_tree, cfqe);
 	update_min_vdisktime(service_tree);
-	service_tree->count++;
-	service_tree->total_weight += cfqe->weight;
 	cfqq->position_time = jiffies;
 	if ((add_front || !new_cfqq) && !group_changed)
 		return;
@@ -1482,9 +1470,7 @@ static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	service_tree = cfqe->service_tree;
 
 	if (!RB_EMPTY_NODE(&cfqe->rb_node)) {
-		cfq_rb_erase(&cfqe->rb_node, cfqe->service_tree);
-		service_tree->total_weight -= cfqe->weight;
-		cfqe->service_tree = NULL;
+		cfq_entity_service_tree_del(service_tree, cfqe);
 	}
 	if (cfqq->p_root) {
 		rb_erase(&cfqq->p_node, cfqq->p_root);
-- 1.7.1 
