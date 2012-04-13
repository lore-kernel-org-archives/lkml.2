Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab2DMUO0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 16:14:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37922 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690Ab2DMULq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 16:11:46 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/11] blkcg: use @pol instead of @plid in update_root_blkg_pd() and blkcg_print_blkgs()
Date: Fri, 13 Apr 2012 13:11:27 -0700
Message-Id: <1334347895-6268-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1334347895-6268-1-git-send-email-tj@kernel.org>
References: <1334347895-6268-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The two functions were taking "enum blkio_policy_id plid".  Make them
take "const struct blkio_policy_type *pol" instead.

This is to prepare for per-queue policy activation and doesn't cause
any functional difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c   |   21 +++++++++++----------
 block/blk-cgroup.h   |    7 ++++---
 block/blk-throttle.c |    6 +++---
 block/cfq-iosched.c  |   10 +++++-----
 4 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index af665fe..b123152 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -226,17 +226,17 @@ static void blkg_destroy(struct blkio_group *blkg)
  * aren't shot down.  This broken and racy implementation is temporary.
  * Eventually, blkg shoot down will be replaced by proper in-place update.
  */
-void update_root_blkg_pd(struct request_queue *q, enum blkio_policy_id plid)
+void update_root_blkg_pd(struct request_queue *q,
+			 const struct blkio_policy_type *pol)
 {
-	struct blkio_policy_type *pol = blkio_policy[plid];
 	struct blkio_group *blkg = blkg_lookup(&blkio_root_cgroup, q);
 	struct blkg_policy_data *pd;
 
 	if (!blkg)
 		return;
 
-	kfree(blkg->pd[plid]);
-	blkg->pd[plid] = NULL;
+	kfree(blkg->pd[pol->plid]);
+	blkg->pd[pol->plid] = NULL;
 
 	if (!pol)
 		return;
@@ -244,7 +244,7 @@ void update_root_blkg_pd(struct request_queue *q, enum blkio_policy_id plid)
 	pd = kzalloc(sizeof(*pd) + pol->pdata_size, GFP_KERNEL);
 	WARN_ON_ONCE(!pd);
 
-	blkg->pd[plid] = pd;
+	blkg->pd[pol->plid] = pd;
 	pd->blkg = blkg;
 	pol->ops.blkio_init_group_fn(blkg);
 }
@@ -360,7 +360,8 @@ static const char *blkg_dev_name(struct blkio_group *blkg)
  */
 void blkcg_print_blkgs(struct seq_file *sf, struct blkio_cgroup *blkcg,
 		       u64 (*prfill)(struct seq_file *, void *, int),
-		       int pol, int data, bool show_total)
+		       const struct blkio_policy_type *pol, int data,
+		       bool show_total)
 {
 	struct blkio_group *blkg;
 	struct hlist_node *n;
@@ -368,8 +369,8 @@ void blkcg_print_blkgs(struct seq_file *sf, struct blkio_cgroup *blkcg,
 
 	spin_lock_irq(&blkcg->lock);
 	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node)
-		if (blkg->pd[pol])
-			total += prfill(sf, blkg->pd[pol]->pdata, data);
+		if (blkg->pd[pol->plid])
+			total += prfill(sf, blkg->pd[pol->plid]->pdata, data);
 	spin_unlock_irq(&blkcg->lock);
 
 	if (show_total)
@@ -739,7 +740,7 @@ void blkio_policy_register(struct blkio_policy_type *blkiop)
 	BUG_ON(blkio_policy[blkiop->plid]);
 	blkio_policy[blkiop->plid] = blkiop;
 	list_for_each_entry(q, &all_q_list, all_q_node)
-		update_root_blkg_pd(q, blkiop->plid);
+		update_root_blkg_pd(q, blkiop);
 
 	blkcg_bypass_end();
 
@@ -765,7 +766,7 @@ void blkio_policy_unregister(struct blkio_policy_type *blkiop)
 	blkio_policy[blkiop->plid] = NULL;
 
 	list_for_each_entry(q, &all_q_list, all_q_node)
-		update_root_blkg_pd(q, blkiop->plid);
+		update_root_blkg_pd(q, blkiop);
 	blkcg_bypass_end();
 
 	mutex_unlock(&blkcg_pol_mutex);
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index c772581..2694973 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -117,11 +117,12 @@ extern void blkio_policy_register(struct blkio_policy_type *);
 extern void blkio_policy_unregister(struct blkio_policy_type *);
 extern void blkg_destroy_all(struct request_queue *q, bool destroy_root);
 extern void update_root_blkg_pd(struct request_queue *q,
-				enum blkio_policy_id plid);
+				const struct blkio_policy_type *pol);
 
 void blkcg_print_blkgs(struct seq_file *sf, struct blkio_cgroup *blkcg,
 		       u64 (*prfill)(struct seq_file *, void *, int),
-		       int pol, int data, bool show_total);
+		       const struct blkio_policy_type *pol, int data,
+		       bool show_total);
 u64 __blkg_prfill_u64(struct seq_file *sf, void *pdata, u64 v);
 u64 __blkg_prfill_rwstat(struct seq_file *sf, void *pdata,
 			 const struct blkg_rwstat *rwstat);
@@ -333,7 +334,7 @@ static inline void blkio_policy_unregister(struct blkio_policy_type *blkiop) { }
 static inline void blkg_destroy_all(struct request_queue *q,
 				    bool destory_root) { }
 static inline void update_root_blkg_pd(struct request_queue *q,
-				       enum blkio_policy_id plid) { }
+				       const struct blkio_policy_type *pol) { }
 
 static inline void *blkg_to_pdata(struct blkio_group *blkg,
 				struct blkio_policy_type *pol) { return NULL; }
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 6024014..07c17c2 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -946,7 +946,7 @@ static int tg_print_cpu_rwstat(struct cgroup *cgrp, struct cftype *cft,
 {
 	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgrp);
 
-	blkcg_print_blkgs(sf, blkcg, tg_prfill_cpu_rwstat, BLKIO_POLICY_THROTL,
+	blkcg_print_blkgs(sf, blkcg, tg_prfill_cpu_rwstat, &blkio_policy_throtl,
 			  cft->private, true);
 	return 0;
 }
@@ -973,7 +973,7 @@ static int tg_print_conf_u64(struct cgroup *cgrp, struct cftype *cft,
 			     struct seq_file *sf)
 {
 	blkcg_print_blkgs(sf, cgroup_to_blkio_cgroup(cgrp), tg_prfill_conf_u64,
-			  BLKIO_POLICY_THROTL, cft->private, false);
+			  &blkio_policy_throtl, cft->private, false);
 	return 0;
 }
 
@@ -981,7 +981,7 @@ static int tg_print_conf_uint(struct cgroup *cgrp, struct cftype *cft,
 			      struct seq_file *sf)
 {
 	blkcg_print_blkgs(sf, cgroup_to_blkio_cgroup(cgrp), tg_prfill_conf_uint,
-			  BLKIO_POLICY_THROTL, cft->private, false);
+			  &blkio_policy_throtl, cft->private, false);
 	return 0;
 }
 
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 7a8c3e0..d02f0ae 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1380,7 +1380,7 @@ static int cfqg_print_weight_device(struct cgroup *cgrp, struct cftype *cft,
 				    struct seq_file *sf)
 {
 	blkcg_print_blkgs(sf, cgroup_to_blkio_cgroup(cgrp),
-			  cfqg_prfill_weight_device, BLKIO_POLICY_PROP, 0,
+			  cfqg_prfill_weight_device, &blkio_policy_cfq, 0,
 			  false);
 	return 0;
 }
@@ -1445,7 +1445,7 @@ static int cfqg_print_stat(struct cgroup *cgrp, struct cftype *cft,
 {
 	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgrp);
 
-	blkcg_print_blkgs(sf, blkcg, blkg_prfill_stat, BLKIO_POLICY_PROP,
+	blkcg_print_blkgs(sf, blkcg, blkg_prfill_stat, &blkio_policy_cfq,
 			  cft->private, false);
 	return 0;
 }
@@ -1455,7 +1455,7 @@ static int cfqg_print_rwstat(struct cgroup *cgrp, struct cftype *cft,
 {
 	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgrp);
 
-	blkcg_print_blkgs(sf, blkcg, blkg_prfill_rwstat, BLKIO_POLICY_PROP,
+	blkcg_print_blkgs(sf, blkcg, blkg_prfill_rwstat, &blkio_policy_cfq,
 			  cft->private, true);
 	return 0;
 }
@@ -1482,7 +1482,7 @@ static int cfqg_print_avg_queue_size(struct cgroup *cgrp, struct cftype *cft,
 	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgrp);
 
 	blkcg_print_blkgs(sf, blkcg, cfqg_prfill_avg_queue_size,
-			  BLKIO_POLICY_PROP, 0, false);
+			  &blkio_policy_cfq, 0, false);
 	return 0;
 }
 #endif	/* CONFIG_DEBUG_BLK_CGROUP */
@@ -3938,7 +3938,7 @@ static void cfq_exit_queue(struct elevator_queue *e)
 #ifndef CONFIG_CFQ_GROUP_IOSCHED
 	kfree(cfqd->root_group);
 #endif
-	update_root_blkg_pd(q, BLKIO_POLICY_PROP);
+	update_root_blkg_pd(q, &blkio_policy_cfq);
 	kfree(cfqd);
 }
 
-- 
1.7.7.3

