Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab2DMULx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 16:11:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37922 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083Ab2DMULv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 16:11:51 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/11] blkcg: make blkg_conf_prep() take @pol and return with queue lock held
Date: Fri, 13 Apr 2012 13:11:29 -0700
Message-Id: <1334347895-6268-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1334347895-6268-1-git-send-email-tj@kernel.org>
References: <1334347895-6268-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add @pol to blkg_conf_prep() and let it return with queue lock held
(to be released by blkg_conf_finish()).  Note that @pol isn't used
yet.

This is to prepare for per-queue policy activation and doesn't cause
any visible difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c   |   17 ++++++++++-------
 block/blk-cgroup.h   |    3 ++-
 block/blk-throttle.c |    2 +-
 block/cfq-iosched.c  |    2 +-
 4 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 2d4d7d6..f6581a0 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -464,17 +464,19 @@ EXPORT_SYMBOL_GPL(blkg_prfill_rwstat);
 /**
  * blkg_conf_prep - parse and prepare for per-blkg config update
  * @blkcg: target block cgroup
+ * @pol: target policy
  * @input: input string
  * @ctx: blkg_conf_ctx to be filled
  *
  * Parse per-blkg config update from @input and initialize @ctx with the
  * result.  @ctx->blkg points to the blkg to be updated and @ctx->v the new
- * value.  This function returns with RCU read locked and must be paired
- * with blkg_conf_finish().
+ * value.  This function returns with RCU read lock and queue lock held and
+ * must be paired with blkg_conf_finish().
  */
-int blkg_conf_prep(struct blkio_cgroup *blkcg, const char *input,
+int blkg_conf_prep(struct blkio_cgroup *blkcg,
+		   const struct blkio_policy_type *pol, const char *input,
 		   struct blkg_conf_ctx *ctx)
-	__acquires(rcu)
+	__acquires(rcu) __acquires(disk->queue->queue_lock)
 {
 	struct gendisk *disk;
 	struct blkio_group *blkg;
@@ -490,14 +492,14 @@ int blkg_conf_prep(struct blkio_cgroup *blkcg, const char *input,
 		return -EINVAL;
 
 	rcu_read_lock();
-
 	spin_lock_irq(disk->queue->queue_lock);
+
 	blkg = blkg_lookup_create(blkcg, disk->queue, false);
-	spin_unlock_irq(disk->queue->queue_lock);
 
 	if (IS_ERR(blkg)) {
 		ret = PTR_ERR(blkg);
 		rcu_read_unlock();
+		spin_unlock_irq(disk->queue->queue_lock);
 		put_disk(disk);
 		/*
 		 * If queue was bypassing, we should retry.  Do so after a
@@ -527,8 +529,9 @@ EXPORT_SYMBOL_GPL(blkg_conf_prep);
  * with blkg_conf_prep().
  */
 void blkg_conf_finish(struct blkg_conf_ctx *ctx)
-	__releases(rcu)
+	__releases(ctx->disk->queue->queue_lock) __releases(rcu)
 {
+	spin_unlock_irq(ctx->disk->queue->queue_lock);
 	rcu_read_unlock();
 	put_disk(ctx->disk);
 }
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index be80d6e..df1c7b2 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -128,7 +128,8 @@ struct blkg_conf_ctx {
 	u64			v;
 };
 
-int blkg_conf_prep(struct blkio_cgroup *blkcg, const char *input,
+int blkg_conf_prep(struct blkio_cgroup *blkcg,
+		   const struct blkio_policy_type *pol, const char *input,
 		   struct blkg_conf_ctx *ctx);
 void blkg_conf_finish(struct blkg_conf_ctx *ctx);
 
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 0dc4645..6f1bfdf 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -993,7 +993,7 @@ static int tg_set_conf(struct cgroup *cgrp, struct cftype *cft, const char *buf,
 	struct throtl_grp *tg;
 	int ret;
 
-	ret = blkg_conf_prep(blkcg, buf, &ctx);
+	ret = blkg_conf_prep(blkcg, &blkio_policy_throtl, buf, &ctx);
 	if (ret)
 		return ret;
 
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 08db2fc..de95f9a 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1400,7 +1400,7 @@ static int cfqg_set_weight_device(struct cgroup *cgrp, struct cftype *cft,
 	struct cfq_group *cfqg;
 	int ret;
 
-	ret = blkg_conf_prep(blkcg, buf, &ctx);
+	ret = blkg_conf_prep(blkcg, &blkio_policy_cfq, buf, &ctx);
 	if (ret)
 		return ret;
 
-- 
1.7.7.3

