Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab2L1UnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 15:43:16 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:54721 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab2L1UnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 15:43:13 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, axboe@kernel.dk, vgoyal@redhat.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 17/24] blkcg: implement blkcg_policy->on/offline_pd_fn() and blkcg_gq->online
Date: Fri, 28 Dec 2012 12:35:39 -0800
Message-Id: <1356726946-26037-18-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356726946-26037-1-git-send-email-tj@kernel.org>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add two blkcg_policy methods, ->online_pd_fn() and ->offline_pd_fn(),
which are invoked as the policy_data gets activated and deactivated
while holding both blkcg and q locks.

Also, add blkcg_gq->online bool, which is set and cleared as the
blkcg_gq gets activated and deactivated.  This flag also is toggled
while holding both blkcg and q locks.

These will be used to implement hierarchical stats.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-cgroup.c | 21 ++++++++++++++++++++-
 block/blk-cgroup.h |  7 +++++++
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 3a8de32..4d625d2 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -182,7 +182,7 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 				    struct blkcg_gq *new_blkg)
 {
 	struct blkcg_gq *blkg;
-	int ret;
+	int i, ret;
 
 	WARN_ON_ONCE(!rcu_read_lock_held());
 	lockdep_assert_held(q->queue_lock);
@@ -218,7 +218,15 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 	if (likely(!ret)) {
 		hlist_add_head_rcu(&blkg->blkcg_node, &blkcg->blkg_list);
 		list_add(&blkg->q_node, &q->blkg_list);
+
+		for (i = 0; i < BLKCG_MAX_POLS; i++) {
+			struct blkcg_policy *pol = blkcg_policy[i];
+
+			if (blkg->pd[i] && pol->pd_online_fn)
+				pol->pd_online_fn(blkg);
+		}
 	}
+	blkg->online = true;
 	spin_unlock(&blkcg->lock);
 
 	if (!ret)
@@ -291,6 +299,7 @@ EXPORT_SYMBOL_GPL(blkg_lookup_create);
 static void blkg_destroy(struct blkcg_gq *blkg)
 {
 	struct blkcg *blkcg = blkg->blkcg;
+	int i;
 
 	lockdep_assert_held(blkg->q->queue_lock);
 	lockdep_assert_held(&blkcg->lock);
@@ -299,6 +308,14 @@ static void blkg_destroy(struct blkcg_gq *blkg)
 	WARN_ON_ONCE(list_empty(&blkg->q_node));
 	WARN_ON_ONCE(hlist_unhashed(&blkg->blkcg_node));
 
+	for (i = 0; i < BLKCG_MAX_POLS; i++) {
+		struct blkcg_policy *pol = blkcg_policy[i];
+
+		if (blkg->pd[i] && pol->pd_offline_fn)
+			pol->pd_offline_fn(blkg);
+	}
+	blkg->online = false;
+
 	radix_tree_delete(&blkcg->blkg_tree, blkg->q->id);
 	list_del_init(&blkg->q_node);
 	hlist_del_init_rcu(&blkg->blkcg_node);
@@ -956,6 +973,8 @@ void blkcg_deactivate_policy(struct request_queue *q,
 		/* grab blkcg lock too while removing @pd from @blkg */
 		spin_lock(&blkg->blkcg->lock);
 
+		if (pol->pd_offline_fn)
+			pol->pd_offline_fn(blkg);
 		if (pol->pd_exit_fn)
 			pol->pd_exit_fn(blkg);
 
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 40f5b97..678e89e 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -106,12 +106,17 @@ struct blkcg_gq {
 	/* reference count */
 	int				refcnt;
 
+	/* is this blkg online? protected by both blkcg and q locks */
+	bool				online;
+
 	struct blkg_policy_data		*pd[BLKCG_MAX_POLS];
 
 	struct rcu_head			rcu_head;
 };
 
 typedef void (blkcg_pol_init_pd_fn)(struct blkcg_gq *blkg);
+typedef void (blkcg_pol_online_pd_fn)(struct blkcg_gq *blkg);
+typedef void (blkcg_pol_offline_pd_fn)(struct blkcg_gq *blkg);
 typedef void (blkcg_pol_exit_pd_fn)(struct blkcg_gq *blkg);
 typedef void (blkcg_pol_reset_pd_stats_fn)(struct blkcg_gq *blkg);
 
@@ -124,6 +129,8 @@ struct blkcg_policy {
 
 	/* operations */
 	blkcg_pol_init_pd_fn		*pd_init_fn;
+	blkcg_pol_online_pd_fn		*pd_online_fn;
+	blkcg_pol_offline_pd_fn		*pd_offline_fn;
 	blkcg_pol_exit_pd_fn		*pd_exit_fn;
 	blkcg_pol_reset_pd_stats_fn	*pd_reset_stats_fn;
 };
-- 
1.8.0.2

