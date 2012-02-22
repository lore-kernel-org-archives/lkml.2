Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab2BVBwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 20:52:38 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45648 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab2BVBrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 20:47:46 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.211.131 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 18/36] blkcg: let blkio_group point to blkio_cgroup directly
Date: Tue, 21 Feb 2012 17:46:45 -0800
Message-Id: <1329875223-5102-19-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1329875223-5102-1-git-send-email-tj@kernel.org>
References: <1329875223-5102-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, blkg points to the associated blkcg via its css_id.  This
unnecessarily complicates dereferencing blkcg.  Let blkg hold a
reference to the associated blkcg and point directly to it and disable
css_id on blkio_subsys.

This change requires splitting blkiocg_destroy() into
blkiocg_pre_destroy() and blkiocg_destroy() so that all blkg's can be
destroyed and all the blkcg references held by them dropped during
cgroup removal.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c   |   43 ++++++++++++++++++++++++-------------------
 block/blk-cgroup.h   |    2 +-
 block/blk-throttle.c |    3 +++
 block/cfq-iosched.c  |    4 ++++
 4 files changed, 32 insertions(+), 20 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 8742af3..803c3b1 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -37,6 +37,7 @@ static int blkiocg_can_attach(struct cgroup_subsys *, struct cgroup *,
 			      struct cgroup_taskset *);
 static void blkiocg_attach(struct cgroup_subsys *, struct cgroup *,
 			   struct cgroup_taskset *);
+static int blkiocg_pre_destroy(struct cgroup_subsys *, struct cgroup *);
 static void blkiocg_destroy(struct cgroup_subsys *, struct cgroup *);
 static int blkiocg_populate(struct cgroup_subsys *, struct cgroup *);
 
@@ -51,10 +52,10 @@ struct cgroup_subsys blkio_subsys = {
 	.create = blkiocg_create,
 	.can_attach = blkiocg_can_attach,
 	.attach = blkiocg_attach,
+	.pre_destroy = blkiocg_pre_destroy,
 	.destroy = blkiocg_destroy,
 	.populate = blkiocg_populate,
 	.subsys_id = blkio_subsys_id,
-	.use_id = 1,
 	.module = THIS_MODULE,
 };
 EXPORT_SYMBOL_GPL(blkio_subsys);
@@ -442,6 +443,7 @@ struct blkio_group *blkg_lookup_create(struct blkio_cgroup *blkcg,
 	if (blkg)
 		return blkg;
 
+	/* blkg holds a reference to blkcg */
 	if (!css_tryget(&blkcg->css))
 		return ERR_PTR(-EINVAL);
 
@@ -463,15 +465,16 @@ struct blkio_group *blkg_lookup_create(struct blkio_cgroup *blkcg,
 
 		spin_lock_init(&new_blkg->stats_lock);
 		rcu_assign_pointer(new_blkg->q, q);
-		new_blkg->blkcg_id = css_id(&blkcg->css);
+		new_blkg->blkcg = blkcg;
 		new_blkg->plid = plid;
 		cgroup_path(blkcg->css.cgroup, new_blkg->path,
 			    sizeof(new_blkg->path));
+	} else {
+		css_put(&blkcg->css);
 	}
 
 	rcu_read_lock();
 	spin_lock_irq(q->queue_lock);
-	css_put(&blkcg->css);
 
 	/* did bypass get turned on inbetween? */
 	if (unlikely(blk_queue_bypass(q)) && !for_root) {
@@ -500,6 +503,7 @@ out:
 	if (new_blkg) {
 		free_percpu(new_blkg->stats_cpu);
 		kfree(new_blkg);
+		css_put(&blkcg->css);
 	}
 	return blkg;
 }
@@ -508,7 +512,6 @@ EXPORT_SYMBOL_GPL(blkg_lookup_create);
 static void __blkiocg_del_blkio_group(struct blkio_group *blkg)
 {
 	hlist_del_init_rcu(&blkg->blkcg_node);
-	blkg->blkcg_id = 0;
 }
 
 /*
@@ -517,24 +520,17 @@ static void __blkiocg_del_blkio_group(struct blkio_group *blkg)
  */
 int blkiocg_del_blkio_group(struct blkio_group *blkg)
 {
-	struct blkio_cgroup *blkcg;
+	struct blkio_cgroup *blkcg = blkg->blkcg;
 	unsigned long flags;
-	struct cgroup_subsys_state *css;
 	int ret = 1;
 
-	rcu_read_lock();
-	css = css_lookup(&blkio_subsys, blkg->blkcg_id);
-	if (css) {
-		blkcg = container_of(css, struct blkio_cgroup, css);
-		spin_lock_irqsave(&blkcg->lock, flags);
-		if (!hlist_unhashed(&blkg->blkcg_node)) {
-			__blkiocg_del_blkio_group(blkg);
-			ret = 0;
-		}
-		spin_unlock_irqrestore(&blkcg->lock, flags);
+	spin_lock_irqsave(&blkcg->lock, flags);
+	if (!hlist_unhashed(&blkg->blkcg_node)) {
+		__blkiocg_del_blkio_group(blkg);
+		ret = 0;
 	}
+	spin_unlock_irqrestore(&blkcg->lock, flags);
 
-	rcu_read_unlock();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(blkiocg_del_blkio_group);
@@ -1376,7 +1372,8 @@ static int blkiocg_populate(struct cgroup_subsys *subsys, struct cgroup *cgroup)
 				ARRAY_SIZE(blkio_files));
 }
 
-static void blkiocg_destroy(struct cgroup_subsys *subsys, struct cgroup *cgroup)
+static int blkiocg_pre_destroy(struct cgroup_subsys *subsys,
+			       struct cgroup *cgroup)
 {
 	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
 	unsigned long flags;
@@ -1385,6 +1382,7 @@ static void blkiocg_destroy(struct cgroup_subsys *subsys, struct cgroup *cgroup)
 	struct blkio_policy_type *blkiop;
 
 	rcu_read_lock();
+
 	do {
 		spin_lock_irqsave(&blkcg->lock, flags);
 
@@ -1414,8 +1412,15 @@ static void blkiocg_destroy(struct cgroup_subsys *subsys, struct cgroup *cgroup)
 		spin_unlock(&blkio_list_lock);
 	} while (1);
 
-	free_css_id(&blkio_subsys, &blkcg->css);
 	rcu_read_unlock();
+
+	return 0;
+}
+
+static void blkiocg_destroy(struct cgroup_subsys *subsys, struct cgroup *cgroup)
+{
+	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
+
 	if (blkcg != &blkio_root_cgroup)
 		kfree(blkcg);
 }
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 7ebecf6..ca1fc63 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -163,7 +163,7 @@ struct blkio_group {
 	/* Pointer to the associated request_queue, RCU protected */
 	struct request_queue __rcu *q;
 	struct hlist_node blkcg_node;
-	unsigned short blkcg_id;
+	struct blkio_cgroup *blkcg;
 	/* Store cgroup path */
 	char path[128];
 	/* policy which owns this blk group */
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 52a4293..fe6a442 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -169,6 +169,9 @@ static void throtl_put_tg(struct throtl_grp *tg)
 	if (!atomic_dec_and_test(&tg->ref))
 		return;
 
+	/* release the extra blkcg reference this blkg has been holding */
+	css_put(&tg->blkg.blkcg->css);
+
 	/*
 	 * A group is freed in rcu manner. But having an rcu lock does not
 	 * mean that one can access all the fields of blkg and assume these
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index f67d109..9ef86fb 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1133,6 +1133,10 @@ static void cfq_put_cfqg(struct cfq_group *cfqg)
 	cfqg->ref--;
 	if (cfqg->ref)
 		return;
+
+	/* release the extra blkcg reference this blkg has been holding */
+	css_put(&cfqg->blkg.blkcg->css);
+
 	for_each_cfqg_st(cfqg, i, j, st)
 		BUG_ON(!RB_EMPTY_ROOT(&st->rb));
 	free_percpu(cfqg->blkg.stats_cpu);
-- 
1.7.7.3

