Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab1CQPGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 11:06:22 -0400
Received: from smtp-out.google.com ([216.239.44.51]:14618 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab1CQPGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 11:06:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=oKzCMEko7HBH8ERn8Jd41rI4b4oYAr3pxvHd/he8xKaOo+7Yac4TUOyxDu2SMrseo
	iPGGdgfjOoBrZYayqVnag==
From: Justin TerAvest <teravest@google.com>
To: jaxboe@fusionio.com, vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, Justin TerAvest <teravest@google.com>
Subject: [PATCH v3] Don't update group weights when on service tree.
Date: Thu, 17 Mar 2011 08:05:57 -0700
Message-Id: <1300374357-30686-1-git-send-email-teravest@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Version 3 is updated to apply to for-2.6.39/core.

For version 2, I took Vivek's advice and made sure we update the group
weight from cfq_group_service_tree_add().

If a weight was updated while a group is on the service tree, the
calculation for the total weight of the service tree can be adjusted
improperly, which either leads to bad service tree weights, or
potentially crashes (if total_weight becomes 0).

This patch defers updates to the weight until a group is off the service
tree.

Signed-off-by: Justin TerAvest <teravest@google.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   53 +++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 41 insertions(+), 12 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 89e0d1c..12e380b 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -178,6 +178,8 @@ struct cfq_group {
 	/* group service_tree key */
 	u64 vdisktime;
 	unsigned int weight;
+	unsigned int new_weight;
+	bool needs_update;
 
 	/* number of cfqq currently on this group */
 	int nr_cfqq;
@@ -853,7 +855,27 @@ __cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
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
@@ -874,13 +896,19 @@ cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
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
 
@@ -892,9 +920,7 @@ cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
 		return;
 
 	cfq_log_cfqg(cfqd, cfqg, "del_from_rr group");
-	st->total_weight -= cfqg->weight;
-	if (!RB_EMPTY_NODE(&cfqg->rb_node))
-		cfq_rb_erase(&cfqg->rb_node, st);
+	cfq_group_service_tree_del(st, cfqg);
 	cfqg->saved_workload_slice = 0;
 	cfq_blkiocg_update_dequeue_stats(&cfqg->blkg, 1);
 }
@@ -948,9 +974,10 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
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
@@ -982,7 +1009,9 @@ static inline struct cfq_group *cfqg_of_blkg(struct blkio_group *blkg)
 void cfq_update_blkio_group_weight(void *key, struct blkio_group *blkg,
 					unsigned int weight)
 {
-	cfqg_of_blkg(blkg)->weight = weight;
+	struct cfq_group *cfqg = cfqg_of_blkg(blkg);
+	cfqg->new_weight = weight;
+	cfqg->needs_update = true;
 }
 
 static struct cfq_group *
@@ -1255,7 +1284,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	service_tree->count++;
 	if ((add_front || !new_cfqq) && !group_changed)
 		return;
-	cfq_group_service_tree_add(cfqd, cfqq->cfqg);
+	cfq_group_notify_queue_add(cfqd, cfqq->cfqg);
 }
 
 static struct cfq_queue *
@@ -1368,7 +1397,7 @@ static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 		cfqq->p_root = NULL;
 	}
 
-	cfq_group_service_tree_del(cfqd, cfqq->cfqg);
+	cfq_group_notify_queue_del(cfqd, cfqq->cfqg);
 	BUG_ON(!cfqd->busy_queues);
 	cfqd->busy_queues--;
 	if (cfq_cfqq_sync(cfqq))
-- 
1.7.3.1

