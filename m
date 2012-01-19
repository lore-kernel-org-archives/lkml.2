Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab2ASBNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 20:13:47 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:34441 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754865Ab2ASBLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 20:11:45 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/12] blkcg: update blkg get functions take blkio_cgroup as parameter
Date: Wed, 18 Jan 2012 17:11:23 -0800
Message-Id: <1326935490-11827-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1326935490-11827-1-git-send-email-tj@kernel.org>
References: <1326935490-11827-1-git-send-email-tj@kernel.org>
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
index ae53056..dfd950c 100644
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
 	if (unlikely(blk_queue_dead(q)))
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
 	if (unlikely(blk_queue_dead(q))) {
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
@@ -1140,7 +1138,7 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
 	 * IO group
 	 */
 	spin_lock_irq(q->queue_lock);
-	tg = throtl_get_tg(td);
+	tg = throtl_get_tg(td, blkcg);
 	if (unlikely(!tg))
 		goto out_unlock;
 
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index fd39a44..a4c1154 100644
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
@@ -1261,7 +1261,8 @@ static void cfq_unlink_blkio_group(void *key, struct blkio_group *blkg)
 }
 
 #else /* GROUP_IOSCHED */
-static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd)
+static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd,
+				      struct blkio_cgroup *blkcg)
 {
 	return &cfqd->root_group;
 }
@@ -2850,6 +2851,7 @@ static struct cfq_queue *
 cfq_find_alloc_queue(struct cfq_data *cfqd, bool is_sync,
 		     struct io_context *ioc, gfp_t gfp_mask)
 {
+	struct blkio_cgroup *blkcg;
 	struct cfq_queue *cfqq, *new_cfqq = NULL;
 	struct cfq_io_cq *cic;
 	struct cfq_group *cfqg;
@@ -2857,7 +2859,9 @@ cfq_find_alloc_queue(struct cfq_data *cfqd, bool is_sync,
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

