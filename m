Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678Ab2LNWmD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:42:03 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:61737 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756880Ab2LNWl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:41:57 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, axboe@kernel.dk, vgoyal@redhat.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/12] cfq-iosched: enable full blkcg hierarchy support
Date: Fri, 14 Dec 2012 14:41:22 -0800
Message-Id: <1355524885-22719-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1355524885-22719-1-git-send-email-tj@kernel.org>
References: <1355524885-22719-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the previous two patches, all cfqg scheduling decisions are based
on vfraction and ready for hierarchy support.  The only thing which
keeps the behavior flat is cfqg_flat_parent() which makes vfraction
calculation consider all non-root cfqgs children of the root cfqg.

Replace it with cfqg_parent() which returns the real parent.  This
enables full blkcg hierarchy support for cfq-iosched.  For example,
consider the following hierarchy.

        root
      /      \
   A:500      B:250
  /     \
 AA:500  AB:1000

For simplicity, let's say all the leaf nodes have active tasks and are
on service tree.  For each leaf node, vfraction would be

 AA: (500  / 1500) * (500 / 750) =~ 0.2222
 AB: (1000 / 1500) * (500 / 750) =~ 0.4444
  B:                 (250 / 750) =~ 0.3333

and vdisktime will be distributed accordingly.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/cfq-iosched.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index fd2f4b4..ceade6e 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -603,20 +603,11 @@ static inline struct cfq_group *blkg_to_cfqg(struct blkcg_gq *blkg)
 	return pd_to_cfqg(blkg_to_pd(blkg, &blkcg_policy_cfq));
 }
 
-/*
- * Determine the parent cfqg for weight calculation.  Currently, cfqg
- * scheduling is flat and the root is the parent of everyone else.
- */
-static inline struct cfq_group *cfqg_flat_parent(struct cfq_group *cfqg)
+static inline struct cfq_group *cfqg_parent(struct cfq_group *cfqg)
 {
-	struct blkcg_gq *blkg = cfqg_to_blkg(cfqg);
-	struct cfq_group *root;
-
-	while (blkg->parent)
-		blkg = blkg->parent;
-	root = blkg_to_cfqg(blkg);
+	struct blkcg_gq *pblkg = cfqg_to_blkg(cfqg)->parent;
 
-	return root != cfqg ? root : NULL;
+	return pblkg ? blkg_to_cfqg(pblkg) : NULL;
 }
 
 static inline void cfqg_get(struct cfq_group *cfqg)
@@ -719,7 +710,7 @@ static void cfq_pd_reset_stats(struct blkcg_gq *blkg)
 
 #else	/* CONFIG_CFQ_GROUP_IOSCHED */
 
-static inline struct cfq_group *cfqg_flat_parent(struct cfq_group *cfqg) { return NULL; }
+static inline struct cfq_group *cfqg_parent(struct cfq_group *cfqg) { return NULL; }
 static inline void cfqg_get(struct cfq_group *cfqg) { }
 static inline void cfqg_put(struct cfq_group *cfqg) { }
 
@@ -1286,7 +1277,7 @@ cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
 	 * activated node is met.  vfraction calculation should always
 	 * continue to the root.
 	 */
-	while ((parent = cfqg_flat_parent(pos))) {
+	while ((parent = cfqg_parent(pos))) {
 		if (propagate) {
 			propagate = !parent->nr_active++;
 			parent->level_weight += pos->weight;
@@ -1337,7 +1328,7 @@ cfq_group_service_tree_del(struct cfq_rb_root *st, struct cfq_group *cfqg)
 	pos->level_weight -= pos->leaf_weight;
 
 	while (propagate) {
-		struct cfq_group *parent = cfqg_flat_parent(pos);
+		struct cfq_group *parent = cfqg_parent(pos);
 
 		/* @pos has 0 nr_active at this point */
 		WARN_ON_ONCE(pos->level_weight);
-- 
1.7.11.7

