Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176Ab1BKVKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 16:10:04 -0500
Received: from smtp-out.google.com ([74.125.121.67]:25264 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758133Ab1BKVKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 16:10:03 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=brclRJRPFmYX17LWKwUwsjLjk5v6v9W8Wg4odB16a9liH6RtYcLSCf244qIWP1Emr
	Jmdi7KsOkL8OvDAxOxIqA==
From: Justin TerAvest <teravest@google.com>
To: jaxboe@fusionio.com, vgoyal@redhat.com
Cc: ctalbott@google.com, mrubin@google.com, jmoyer@redhat.com,
        guijianfeng@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        Justin TerAvest <teravest@google.com>
Subject: [PATCH v2 1/1] Don't update group weights when on service tree.
Date: Fri, 11 Feb 2011 13:09:03 -0800
Message-Id: <1297458543-14779-1-git-send-email-teravest@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For version 2, I took Vivek's advice and made sure we update the group
weight from cfq_group_service_tree_add().

If a weight was updated while a group is on the service tree, the
calculation for the total weight of the service tree can be adjusted
improperly, which either leads to bad service tree weights, or
potentially crashes (if total_weight becomes 0).

This patch defers updates to the weight until a group is off the service
tree.

Signed-off-by: Justin TerAvest <teravest@google.com>
---
 block/cfq-iosched.c |   57 ++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 43 insertions(+), 14 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 501ffdf..868f9cf 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -179,6 +179,8 @@ struct cfq_group {
 	/* group service_tree key */
 	u64 vdisktime;
 	unsigned int weight;
+	unsigned int new_weight;
+	bool needs_update;
 
 	/* number of cfqq currently on this group */
 	int nr_cfqq;
@@ -863,7 +865,27 @@ __cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
 }
 
 static void
-cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
+cfq_update_group_weight(struct cfq_group *cfqg)
+{
+	BUG_ON(!RB_EMPTY_NODE(&cfqg->rb_node));
+	if (cfqg->needs_update) {
+		cfqg->weight = cfqg->new_weight;
+		cfqg->needs_update = false;
+	}
+}
+
+static void
+cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
+{
+	BUG_ON(!RB_EMPTY_NODE(&cfqg->rb_node));
+
+	cfq_update_group_weight(cfqg);
+	__cfq_group_service_tree_add(st, cfqg);
+	st->total_weight += cfqg->weight;
+}
+
+static void
+cfq_group_notify_queue_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
 	struct cfq_rb_root *st = &cfqd->grp_service_tree;
 	struct cfq_group *__cfqg;
@@ -884,13 +906,19 @@ cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
 		cfqg->vdisktime = __cfqg->vdisktime + CFQ_IDLE_DELAY;
 	} else
 		cfqg->vdisktime = st->min_vdisktime;
+	cfq_group_service_tree_add(st, cfqg);
+}
 
-	__cfq_group_service_tree_add(st, cfqg);
-	st->total_weight += cfqg->weight;
+static void
+cfq_group_service_tree_del(struct cfq_rb_root *st, struct cfq_group *cfqg)
+{
+	st->total_weight -= cfqg->weight;
+	if (!RB_EMPTY_NODE(&cfqg->rb_node))
+		cfq_rb_erase(&cfqg->rb_node, st);
 }
 
 static void
-cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
+cfq_group_notify_queue_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
 	struct cfq_rb_root *st = &cfqd->grp_service_tree;
 
@@ -902,9 +930,7 @@ cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
 		return;
 
 	cfq_log_cfqg(cfqd, cfqg, "del_from_rr group");
-	st->total_weight -= cfqg->weight;
-	if (!RB_EMPTY_NODE(&cfqg->rb_node))
-		cfq_rb_erase(&cfqg->rb_node, st);
+	cfq_group_service_tree_del(st, cfqg);
 	cfqg->saved_workload_slice = 0;
 	cfq_blkiocg_update_dequeue_stats(&cfqg->blkg, 1);
 }
@@ -952,9 +978,10 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 		charge = cfqq->allocated_slice;
 
 	/* Can't update vdisktime while group is on service tree */
-	cfq_rb_erase(&cfqg->rb_node, st);
+	cfq_group_service_tree_del(st, cfqg);
 	cfqg->vdisktime += cfq_scale_slice(charge, cfqg);
-	__cfq_group_service_tree_add(st, cfqg);
+	/* If a new weight was requested, update now, off tree */
+	cfq_group_service_tree_add(st, cfqg);
 
 	/* This group is being expired. Save the context */
 	if (time_after(cfqd->workload_expires, jiffies)) {
@@ -985,7 +1012,9 @@ static inline struct cfq_group *cfqg_of_blkg(struct blkio_group *blkg)
 void cfq_update_blkio_group_weight(void *key, struct blkio_group *blkg,
 					unsigned int weight)
 {
-	cfqg_of_blkg(blkg)->weight = weight;
+	struct cfq_group *cfqg = cfqg_of_blkg(blkg);
+	cfqg->new_weight = weight;
+	cfqg->needs_update = true;
 }
 
 static struct cfq_group *
@@ -1194,7 +1223,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		/* Move this cfq to root group */
 		cfq_log_cfqq(cfqd, cfqq, "moving to root group");
 		if (!RB_EMPTY_NODE(&cfqq->rb_node))
-			cfq_group_service_tree_del(cfqd, cfqq->cfqg);
+			cfq_group_notify_queue_del(cfqd, cfqq->cfqg);
 		cfqq->orig_cfqg = cfqq->cfqg;
 		cfqq->cfqg = &cfqd->root_group;
 		cfqd->root_group.ref++;
@@ -1204,7 +1233,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		/* cfqq is sequential now needs to go to its original group */
 		BUG_ON(cfqq->cfqg != &cfqd->root_group);
 		if (!RB_EMPTY_NODE(&cfqq->rb_node))
-			cfq_group_service_tree_del(cfqd, cfqq->cfqg);
+			cfq_group_notify_queue_del(cfqd, cfqq->cfqg);
 		cfq_put_cfqg(cfqq->cfqg);
 		cfqq->cfqg = cfqq->orig_cfqg;
 		cfqq->orig_cfqg = NULL;
@@ -1284,7 +1313,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	service_tree->count++;
 	if ((add_front || !new_cfqq) && !group_changed)
 		return;
-	cfq_group_service_tree_add(cfqd, cfqq->cfqg);
+	cfq_group_notify_queue_add(cfqd, cfqq->cfqg);
 }
 
 static struct cfq_queue *
@@ -1395,7 +1424,7 @@ static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 		cfqq->p_root = NULL;
 	}
 
-	cfq_group_service_tree_del(cfqd, cfqq->cfqg);
+	cfq_group_notify_queue_del(cfqd, cfqq->cfqg);
 	BUG_ON(!cfqd->busy_queues);
 	cfqd->busy_queues--;
 }
-- 
1.7.3.1

