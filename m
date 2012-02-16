Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab2BPWil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 17:38:41 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57140 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873Ab2BPWiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 17:38:19 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 8/9] block: make block cgroup policies follow bio task association
Date: Thu, 16 Feb 2012 14:37:57 -0800
Message-Id: <1329431878-28300-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1329431878-28300-1-git-send-email-tj@kernel.org>
References: <1329431878-28300-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement bio_blkio_cgroup() which returns the blkcg associated with
the bio if exists or %current's blkcg, and use it in blk-throttle and
cfq-iosched propio.  This makes both cgroup policies honor task
association for the bio instead of always assuming %current.

As nobody is using bio_set_task() yet, this doesn't introduce any
behavior change.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c   |   11 +++++++++--
 block/blk-cgroup.h   |    4 ++--
 block/blk-throttle.c |    2 +-
 block/cfq-iosched.c  |   21 +++++++++++----------
 4 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index fb5f21b..9bb203b 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -71,12 +71,19 @@ struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup)
 }
 EXPORT_SYMBOL_GPL(cgroup_to_blkio_cgroup);
 
-struct blkio_cgroup *task_blkio_cgroup(struct task_struct *tsk)
+static struct blkio_cgroup *task_blkio_cgroup(struct task_struct *tsk)
 {
 	return container_of(task_subsys_state(tsk, blkio_subsys_id),
 			    struct blkio_cgroup, css);
 }
-EXPORT_SYMBOL_GPL(task_blkio_cgroup);
+
+struct blkio_cgroup *bio_blkio_cgroup(struct bio *bio)
+{
+	if (bio && bio->bi_css)
+		return container_of(bio->bi_css, struct blkio_cgroup, css);
+	return task_blkio_cgroup(current);
+}
+EXPORT_SYMBOL_GPL(bio_blkio_cgroup);
 
 static inline void blkio_update_group_weight(struct blkio_group *blkg,
 					     int plid, unsigned int weight)
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 1a80619..4bf4c7b 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -375,7 +375,7 @@ static inline void blkiocg_set_start_empty_time(struct blkio_group *blkg,
 #ifdef CONFIG_BLK_CGROUP
 extern struct blkio_cgroup blkio_root_cgroup;
 extern struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup);
-extern struct blkio_cgroup *task_blkio_cgroup(struct task_struct *tsk);
+extern struct blkio_cgroup *bio_blkio_cgroup(struct bio *bio);
 extern struct blkio_group *blkg_lookup(struct blkio_cgroup *blkcg,
 				       struct request_queue *q);
 struct blkio_group *blkg_lookup_create(struct blkio_cgroup *blkcg,
@@ -409,7 +409,7 @@ struct cgroup;
 static inline struct blkio_cgroup *
 cgroup_to_blkio_cgroup(struct cgroup *cgroup) { return NULL; }
 static inline struct blkio_cgroup *
-task_blkio_cgroup(struct task_struct *tsk) { return NULL; }
+bio_blkio_cgroup(struct bio *bio) { return NULL; }
 
 static inline struct blkio_group *blkg_lookup(struct blkio_cgroup *blkcg,
 					      void *key) { return NULL; }
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 8cd13ec..a7c8e0b 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -900,7 +900,7 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
 	 * just update the dispatch stats in lockless manner and return.
 	 */
 	rcu_read_lock();
-	blkcg = task_blkio_cgroup(current);
+	blkcg = bio_blkio_cgroup(bio);
 	tg = throtl_lookup_tg(td, blkcg);
 	if (tg) {
 		if (tg_no_rule_group(tg, rw)) {
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index b2aabe8..d84879a 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -467,8 +467,9 @@ static inline int cfqg_busy_async_queues(struct cfq_data *cfqd,
 }
 
 static void cfq_dispatch_insert(struct request_queue *, struct request *);
-static struct cfq_queue *cfq_get_queue(struct cfq_data *, bool,
-				       struct io_context *, gfp_t);
+static struct cfq_queue *cfq_get_queue(struct cfq_data *cfqd, bool is_sync,
+				       struct io_context *ioc, struct bio *bio,
+				       gfp_t gfp_mask);
 
 static inline struct cfq_io_cq *icq_to_cic(struct io_cq *icq)
 {
@@ -2601,7 +2602,7 @@ static void cfq_init_prio_data(struct cfq_queue *cfqq, struct io_context *ioc)
 	cfq_clear_cfqq_prio_changed(cfqq);
 }
 
-static void changed_ioprio(struct cfq_io_cq *cic)
+static void changed_ioprio(struct cfq_io_cq *cic, struct bio *bio)
 {
 	struct cfq_data *cfqd = cic_to_cfqd(cic);
 	struct cfq_queue *cfqq;
@@ -2613,7 +2614,7 @@ static void changed_ioprio(struct cfq_io_cq *cic)
 	if (cfqq) {
 		struct cfq_queue *new_cfqq;
 		new_cfqq = cfq_get_queue(cfqd, BLK_RW_ASYNC, cic->icq.ioc,
-						GFP_ATOMIC);
+					 bio, GFP_ATOMIC);
 		if (new_cfqq) {
 			cic->cfqq[BLK_RW_ASYNC] = new_cfqq;
 			cfq_put_queue(cfqq);
@@ -2671,7 +2672,7 @@ static void changed_cgroup(struct cfq_io_cq *cic)
 
 static struct cfq_queue *
 cfq_find_alloc_queue(struct cfq_data *cfqd, bool is_sync,
-		     struct io_context *ioc, gfp_t gfp_mask)
+		     struct io_context *ioc, struct bio *bio, gfp_t gfp_mask)
 {
 	struct blkio_cgroup *blkcg;
 	struct cfq_queue *cfqq, *new_cfqq = NULL;
@@ -2681,7 +2682,7 @@ cfq_find_alloc_queue(struct cfq_data *cfqd, bool is_sync,
 retry:
 	rcu_read_lock();
 
-	blkcg = task_blkio_cgroup(current);
+	blkcg = bio_blkio_cgroup(bio);
 
 	cfqg = cfq_lookup_create_cfqg(cfqd, blkcg);
 
@@ -2746,7 +2747,7 @@ cfq_async_queue_prio(struct cfq_data *cfqd, int ioprio_class, int ioprio)
 
 static struct cfq_queue *
 cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct io_context *ioc,
-	      gfp_t gfp_mask)
+	      struct bio *bio, gfp_t gfp_mask)
 {
 	const int ioprio = task_ioprio(ioc);
 	const int ioprio_class = task_ioprio_class(ioc);
@@ -2759,7 +2760,7 @@ cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct io_context *ioc,
 	}
 
 	if (!cfqq)
-		cfqq = cfq_find_alloc_queue(cfqd, is_sync, ioc, gfp_mask);
+		cfqq = cfq_find_alloc_queue(cfqd, is_sync, ioc, bio, gfp_mask);
 
 	/*
 	 * pin the queue now that it's allocated, scheduler exit will prune it
@@ -3316,7 +3317,7 @@ cfq_set_request(struct request_queue *q, struct request *rq, struct bio *bio,
 	/* handle changed notifications */
 	changed = icq_get_changed(&cic->icq);
 	if (unlikely(changed & ICQ_IOPRIO_CHANGED))
-		changed_ioprio(cic);
+		changed_ioprio(cic, bio);
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 	if (unlikely(changed & ICQ_CGROUP_CHANGED))
 		changed_cgroup(cic);
@@ -3325,7 +3326,7 @@ cfq_set_request(struct request_queue *q, struct request *rq, struct bio *bio,
 new_queue:
 	cfqq = cic_to_cfqq(cic, is_sync);
 	if (!cfqq || cfqq == &cfqd->oom_cfqq) {
-		cfqq = cfq_get_queue(cfqd, is_sync, cic->icq.ioc, gfp_mask);
+		cfqq = cfq_get_queue(cfqd, is_sync, cic->icq.ioc, bio, gfp_mask);
 		cic_set_cfqq(cic, cfqq, is_sync);
 	} else {
 		/*
-- 
1.7.7.3

