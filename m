Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab2AVD03 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 22:26:29 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34431 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab2AVDZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 22:25:55 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/17] blkcg: update blkg get functions take blkio_cgroup as parameter
Date: Sat, 21 Jan 2012 19:25:18 -0800
Message-Id: <1327202725-3383-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1327202725-3383-1-git-send-email-tj@kernel.org>
References: <1327202725-3383-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In both blkg get functions - throtl_get_tg() and cfq_get_cfqg(),
instead of obtaining blkcg of %current explicitly, let the caller
specify the blkcg to use as parameter and make both functions hold on
to the blkcg.

This is part of block cgroup interface cleanup and will help making
blkcg API more modular.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-throttle.c |   16 +++++++---------
 block/cfq-iosched.c  |   20 ++++++++++++--------
 2 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 16fb95b..254c8cb 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -303,21 +303,23 @@ throtl_grp *throtl_find_tg(struct throtl_data *td, struct blkio_cgroup *blkcg)
 	return tg;
 }
 
-static struct throtl_grp * throtl_get_tg(struct throtl_data *td)
+static struct throtl_grp *throtl_get_tg(struct throtl_data *td,
+					struct blkio_cgroup *blkcg)
 {
 	struct throtl_grp *tg = NULL, *__tg = NULL;
-	struct blkio_cgroup *blkcg;
 	struct request_queue *q = td->queue;
 
 	/* no throttling for dead queue */
 	if (unlikely(blk_queue_bypass(q)))
 		return NULL;
 
-	blkcg = task_blkio_cgroup(current);
 	tg = throtl_find_tg(td, blkcg);
 	if (tg)
 		return tg;
 
+	if (!css_tryget(&blkcg->css))
+		return NULL;
+
 	/*
 	 * Need to allocate a group. Allocation of group also needs allocation
 	 * of per cpu stats which in-turn takes a mutex() and can block. Hence
@@ -331,6 +333,7 @@ static struct throtl_grp * throtl_get_tg(struct throtl_data *td)
 	/* Group allocated and queue is still alive. take the lock */
 	rcu_read_lock();
 	spin_lock_irq(q->queue_lock);
+	css_put(&blkcg->css);
 
 	/* Make sure @q is still alive */
 	if (unlikely(blk_queue_bypass(q))) {
@@ -339,11 +342,6 @@ static struct throtl_grp * throtl_get_tg(struct throtl_data *td)
 	}
 
 	/*
-	 * Initialize the new group. After sleeping, read the blkcg again.
-	 */
-	blkcg = task_blkio_cgroup(current);
-
-	/*
 	 * If some other thread already allocated the group while we were
 	 * not holding queue lock, free up the group
 	 */
@@ -1147,7 +1145,7 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
 	 * IO group
 	 */
 	spin_lock_irq(q->queue_lock);
-	tg = throtl_get_tg(td);
+	tg = throtl_get_tg(td, blkcg);
 	if (unlikely(!tg))
 		goto out_unlock;
 
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 1cc3392..d89d582 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1122,17 +1122,19 @@ cfq_find_cfqg(struct cfq_data *cfqd, struct blkio_cgroup *blkcg)
  * Search for the cfq group current task belongs to. request_queue lock must
  * be held.
  */
-static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd)
+static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd,
+				      struct blkio_cgroup *blkcg)
 {
-	struct blkio_cgroup *blkcg;
 	struct cfq_group *cfqg = NULL, *__cfqg = NULL;
 	struct request_queue *q = cfqd->queue;
 
-	blkcg = task_blkio_cgroup(current);
 	cfqg = cfq_find_cfqg(cfqd, blkcg);
 	if (cfqg)
 		return cfqg;
 
+	if (!css_tryget(&blkcg->css))
+		return NULL;
+
 	/*
 	 * Need to allocate a group. Allocation of group also needs allocation
 	 * of per cpu stats which in-turn takes a mutex() and can block. Hence
@@ -1142,16 +1144,14 @@ static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd)
 	 * around by the time we return. CFQ queue allocation code does
 	 * the same. It might be racy though.
 	 */
-
 	rcu_read_unlock();
 	spin_unlock_irq(q->queue_lock);
 
 	cfqg = cfq_alloc_cfqg(cfqd);
 
 	spin_lock_irq(q->queue_lock);
-
 	rcu_read_lock();
-	blkcg = task_blkio_cgroup(current);
+	css_put(&blkcg->css);
 
 	/*
 	 * If some other thread already allocated the group while we were
@@ -1271,7 +1271,8 @@ static void cfq_clear_queue(struct request_queue *q)
 }
 
 #else /* GROUP_IOSCHED */
-static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd)
+static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd,
+				      struct blkio_cgroup *blkcg)
 {
 	return &cfqd->root_group;
 }
@@ -2860,6 +2861,7 @@ static struct cfq_queue *
 cfq_find_alloc_queue(struct cfq_data *cfqd, bool is_sync,
 		     struct io_context *ioc, gfp_t gfp_mask)
 {
+	struct blkio_cgroup *blkcg;
 	struct cfq_queue *cfqq, *new_cfqq = NULL;
 	struct cfq_io_cq *cic;
 	struct cfq_group *cfqg;
@@ -2867,7 +2869,9 @@ cfq_find_alloc_queue(struct cfq_data *cfqd, bool is_sync,
 retry:
 	rcu_read_lock();
 
-	cfqg = cfq_get_cfqg(cfqd);
+	blkcg = task_blkio_cgroup(current);
+
+	cfqg = cfq_get_cfqg(cfqd, blkcg);
 	cic = cfq_cic_lookup(cfqd, ioc);
 	/* cic always exists here */
 	cfqq = cic_to_cfqq(cic, is_sync);
-- 
1.7.7.3

