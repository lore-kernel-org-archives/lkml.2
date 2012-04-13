Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075Ab2DMULr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 16:11:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37922 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756243Ab2DMULp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 16:11:45 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/11] blkcg: kill blkio_list and replace blkio_list_lock with a mutex
Date: Fri, 13 Apr 2012 13:11:26 -0700
Message-Id: <1334347895-6268-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1334347895-6268-1-git-send-email-tj@kernel.org>
References: <1334347895-6268-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With blkio_policy[], blkio_list is redundant and hinders with
per-queue policy activation.  Remove it.  Also, replace
blkio_list_lock with a mutex blkcg_pol_mutex and let it protect the
whole [un]registration.

This is to prepare for per-queue policy activation and doesn't cause
any functional difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c |   32 +++++++++++++++++---------------
 block/blk-cgroup.h |    1 -
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 9449c38..af665fe 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -24,9 +24,7 @@
 
 #define MAX_KEY_LEN 100
 
-static DEFINE_SPINLOCK(blkio_list_lock);
-static LIST_HEAD(blkio_list);
-
+static DEFINE_MUTEX(blkcg_pol_mutex);
 static DEFINE_MUTEX(all_q_mutex);
 static LIST_HEAD(all_q_list);
 
@@ -311,8 +309,9 @@ blkiocg_reset_stats(struct cgroup *cgroup, struct cftype *cftype, u64 val)
 	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
 	struct blkio_group *blkg;
 	struct hlist_node *n;
+	int i;
 
-	spin_lock(&blkio_list_lock);
+	mutex_lock(&blkcg_pol_mutex);
 	spin_lock_irq(&blkcg->lock);
 
 	/*
@@ -321,15 +320,16 @@ blkiocg_reset_stats(struct cgroup *cgroup, struct cftype *cftype, u64 val)
 	 * anyway.  If you get hit by a race, retry.
 	 */
 	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
-		struct blkio_policy_type *pol;
+		for (i = 0; i < BLKIO_NR_POLICIES; i++) {
+			struct blkio_policy_type *pol = blkio_policy[i];
 
-		list_for_each_entry(pol, &blkio_list, list)
-			if (pol->ops.blkio_reset_group_stats_fn)
+			if (pol && pol->ops.blkio_reset_group_stats_fn)
 				pol->ops.blkio_reset_group_stats_fn(blkg);
+		}
 	}
 
 	spin_unlock_irq(&blkcg->lock);
-	spin_unlock(&blkio_list_lock);
+	mutex_unlock(&blkcg_pol_mutex);
 	return 0;
 }
 
@@ -732,20 +732,21 @@ void blkio_policy_register(struct blkio_policy_type *blkiop)
 {
 	struct request_queue *q;
 
+	mutex_lock(&blkcg_pol_mutex);
+
 	blkcg_bypass_start();
-	spin_lock(&blkio_list_lock);
 
 	BUG_ON(blkio_policy[blkiop->plid]);
 	blkio_policy[blkiop->plid] = blkiop;
-	list_add_tail(&blkiop->list, &blkio_list);
-
-	spin_unlock(&blkio_list_lock);
 	list_for_each_entry(q, &all_q_list, all_q_node)
 		update_root_blkg_pd(q, blkiop->plid);
+
 	blkcg_bypass_end();
 
 	if (blkiop->cftypes)
 		WARN_ON(cgroup_add_cftypes(&blkio_subsys, blkiop->cftypes));
+
+	mutex_unlock(&blkcg_pol_mutex);
 }
 EXPORT_SYMBOL_GPL(blkio_policy_register);
 
@@ -753,19 +754,20 @@ void blkio_policy_unregister(struct blkio_policy_type *blkiop)
 {
 	struct request_queue *q;
 
+	mutex_lock(&blkcg_pol_mutex);
+
 	if (blkiop->cftypes)
 		cgroup_rm_cftypes(&blkio_subsys, blkiop->cftypes);
 
 	blkcg_bypass_start();
-	spin_lock(&blkio_list_lock);
 
 	BUG_ON(blkio_policy[blkiop->plid] != blkiop);
 	blkio_policy[blkiop->plid] = NULL;
-	list_del_init(&blkiop->list);
 
-	spin_unlock(&blkio_list_lock);
 	list_for_each_entry(q, &all_q_list, all_q_node)
 		update_root_blkg_pd(q, blkiop->plid);
 	blkcg_bypass_end();
+
+	mutex_unlock(&blkcg_pol_mutex);
 }
 EXPORT_SYMBOL_GPL(blkio_policy_unregister);
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 64392ac..c772581 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -102,7 +102,6 @@ struct blkio_policy_ops {
 };
 
 struct blkio_policy_type {
-	struct list_head list;
 	struct blkio_policy_ops ops;
 	enum blkio_policy_id plid;
 	size_t pdata_size;		/* policy specific private data size */
-- 
1.7.7.3

