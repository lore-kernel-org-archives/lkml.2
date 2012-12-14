Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945893Ab2LNWnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:43:49 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:47332 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756226Ab2LNWlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:41:55 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, axboe@kernel.dk, vgoyal@redhat.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/12] cfq-iosched: convert cfq_group_slice() to use cfqg->vfraction
Date: Fri, 14 Dec 2012 14:41:21 -0800
Message-Id: <1355524885-22719-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1355524885-22719-1-git-send-email-tj@kernel.org>
References: <1355524885-22719-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cfq_group_slice() calculates slice by taking a fraction of
cfq_target_latency according to the ratio of cfqg->weight against
service_tree->total_weight.  This currently works only because all
cfqgs are treated to be at the same level.

To prepare for proper hierarchy support, convert cfq_group_slice() to
base the calculation on cfqg->vfraction.  As cfqg->vfraction is always
a fraction of 1 and represents the fraction allocated to the cfqg with
hierarchy considered, the slice can be simply calculated by
multiplying cfqg->vfraction to cfq_target_latency (with fixed point
shift factored in).

As vfraction calculation currently treats all non-root cfqgs as
children of the root cfqg, this patch doesn't introduce noticeable
behavior difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/cfq-iosched.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 663a0f0..fd2f4b4 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -85,7 +85,6 @@ struct cfq_rb_root {
 	struct rb_root rb;
 	struct rb_node *left;
 	unsigned count;
-	unsigned total_weight;
 	u64 min_vdisktime;
 	struct cfq_ttime ttime;
 };
@@ -976,9 +975,7 @@ static inline unsigned cfq_group_get_avg_queues(struct cfq_data *cfqd,
 static inline unsigned
 cfq_group_slice(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
-	struct cfq_rb_root *st = &cfqd->grp_service_tree;
-
-	return cfqd->cfq_target_latency * cfqg->weight / st->total_weight;
+	return cfqd->cfq_target_latency * cfqg->vfraction >> CFQ_SERVICE_SHIFT;
 }
 
 static inline unsigned
@@ -1270,7 +1267,6 @@ cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
 
 	cfq_update_group_weight(cfqg);
 	__cfq_group_service_tree_add(st, cfqg);
-	st->total_weight += cfqg->weight;
 
 	/*
 	 * Activate @cfqg and calculate the portion of vfraction @cfqg is
@@ -1356,7 +1352,6 @@ cfq_group_service_tree_del(struct cfq_rb_root *st, struct cfq_group *cfqg)
 	}
 
 	/* remove from the service tree */
-	st->total_weight -= cfqg->weight;
 	if (!RB_EMPTY_NODE(&cfqg->rb_node))
 		cfq_rb_erase(&cfqg->rb_node, st);
 }
-- 
1.7.11.7

