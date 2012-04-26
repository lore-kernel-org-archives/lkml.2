Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481Ab2DZWAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 18:00:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53858 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759458Ab2DZV7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 17:59:54 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, fengguang.wu@intel.com,
        hughd@google.com, akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/11] blkcg: inline bio_blkcg() and friends
Date: Thu, 26 Apr 2012 14:59:18 -0700
Message-Id: <1335477561-11131-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1335477561-11131-1-git-send-email-tj@kernel.org>
References: <1335477561-11131-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make bio_blkcg() and friends inline.  They all are very simple and
used only in few places.

This patch is to prepare for further updates to request allocation
path.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c |   21 ---------------------
 block/blk-cgroup.h |   26 ++++++++++++++++++++++----
 2 files changed, 22 insertions(+), 25 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index a8f2f03..b5c155d 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -31,27 +31,6 @@ EXPORT_SYMBOL_GPL(blkcg_root);
 
 static struct blkcg_policy *blkcg_policy[BLKCG_MAX_POLS];
 
-struct blkcg *cgroup_to_blkcg(struct cgroup *cgroup)
-{
-	return container_of(cgroup_subsys_state(cgroup, blkio_subsys_id),
-			    struct blkcg, css);
-}
-EXPORT_SYMBOL_GPL(cgroup_to_blkcg);
-
-static struct blkcg *task_blkcg(struct task_struct *tsk)
-{
-	return container_of(task_subsys_state(tsk, blkio_subsys_id),
-			    struct blkcg, css);
-}
-
-struct blkcg *bio_blkcg(struct bio *bio)
-{
-	if (bio && bio->bi_css)
-		return container_of(bio->bi_css, struct blkcg, css);
-	return task_blkcg(current);
-}
-EXPORT_SYMBOL_GPL(bio_blkcg);
-
 static bool blkcg_policy_enabled(struct request_queue *q,
 				 const struct blkcg_policy *pol)
 {
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 8ac457c..e74cce1 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -120,8 +120,6 @@ struct blkcg_policy {
 
 extern struct blkcg blkcg_root;
 
-struct blkcg *cgroup_to_blkcg(struct cgroup *cgroup);
-struct blkcg *bio_blkcg(struct bio *bio);
 struct blkcg_gq *blkg_lookup(struct blkcg *blkcg, struct request_queue *q);
 struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
 				    struct request_queue *q);
@@ -160,6 +158,25 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 void blkg_conf_finish(struct blkg_conf_ctx *ctx);
 
 
+static inline struct blkcg *cgroup_to_blkcg(struct cgroup *cgroup)
+{
+	return container_of(cgroup_subsys_state(cgroup, blkio_subsys_id),
+			    struct blkcg, css);
+}
+
+static inline struct blkcg *task_blkcg(struct task_struct *tsk)
+{
+	return container_of(task_subsys_state(tsk, blkio_subsys_id),
+			    struct blkcg, css);
+}
+
+static inline struct blkcg *bio_blkcg(struct bio *bio)
+{
+	if (bio && bio->bi_css)
+		return container_of(bio->bi_css, struct blkcg, css);
+	return task_blkcg(current);
+}
+
 /**
  * blkg_to_pdata - get policy private data
  * @blkg: blkg of interest
@@ -351,6 +368,7 @@ static inline void blkg_rwstat_reset(struct blkg_rwstat *rwstat)
 #else	/* CONFIG_BLK_CGROUP */
 
 struct cgroup;
+struct blkcg;
 
 struct blkg_policy_data {
 };
@@ -361,8 +379,6 @@ struct blkcg_gq {
 struct blkcg_policy {
 };
 
-static inline struct blkcg *cgroup_to_blkcg(struct cgroup *cgroup) { return NULL; }
-static inline struct blkcg *bio_blkcg(struct bio *bio) { return NULL; }
 static inline struct blkcg_gq *blkg_lookup(struct blkcg *blkcg, void *key) { return NULL; }
 static inline int blkcg_init_queue(struct request_queue *q) { return 0; }
 static inline void blkcg_drain_queue(struct request_queue *q) { }
@@ -374,6 +390,8 @@ static inline int blkcg_activate_policy(struct request_queue *q,
 static inline void blkcg_deactivate_policy(struct request_queue *q,
 					   const struct blkcg_policy *pol) { }
 
+static inline struct blkcg *cgroup_to_blkcg(struct cgroup *cgroup) { return NULL; }
+static inline struct blkcg *bio_blkcg(struct bio *bio) { return NULL; }
 static inline struct blkg_policy_data *blkg_to_pd(struct blkcg_gq *blkg,
 						  struct blkcg_policy *pol) { return NULL; }
 static inline struct blkcg_gq *pd_to_blkg(struct blkg_policy_data *pd) { return NULL; }
-- 
1.7.7.3

