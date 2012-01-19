Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab2ASBLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 20:11:39 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52870 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab2ASBLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 20:11:37 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/12] blkcg: obtaining blkg should be enclosed inside rcu_read_lock()
Date: Wed, 18 Jan 2012 17:11:19 -0800
Message-Id: <1326935490-11827-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1326935490-11827-1-git-send-email-tj@kernel.org>
References: <1326935490-11827-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When looking up or creating blkg's, both blk-throttle and cfq-iosched
drops rcu_read_lock() right after lookup is complete.  This isn't
safe.  Refcnt isn't incremented at that point and rcu lock is the only
thing holding the blkg.  It shouldn't be dropped until after refcnt is
incremented by the caller.

Update throtl_get_tg() and cfq_get_cfqg() such that they are called
and return under rcu_read_lock() and let their callers manage rcu
locking appropriately.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-throttle.c |   18 ++++++------------
 block/cfq-iosched.c  |   11 +++++------
 2 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 5eed6a7..ae53056 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -313,25 +313,23 @@ static struct throtl_grp * throtl_get_tg(struct throtl_data *td)
 	if (unlikely(blk_queue_dead(q)))
 		return NULL;
 
-	rcu_read_lock();
 	blkcg = task_blkio_cgroup(current);
 	tg = throtl_find_tg(td, blkcg);
-	if (tg) {
-		rcu_read_unlock();
+	if (tg)
 		return tg;
-	}
 
 	/*
 	 * Need to allocate a group. Allocation of group also needs allocation
 	 * of per cpu stats which in-turn takes a mutex() and can block. Hence
 	 * we need to drop rcu lock and queue_lock before we call alloc.
 	 */
-	rcu_read_unlock();
 	spin_unlock_irq(q->queue_lock);
+	rcu_read_unlock();
 
 	tg = throtl_alloc_tg(td);
 
 	/* Group allocated and queue is still alive. take the lock */
+	rcu_read_lock();
 	spin_lock_irq(q->queue_lock);
 
 	/* Make sure @q is still alive */
@@ -343,7 +341,6 @@ static struct throtl_grp * throtl_get_tg(struct throtl_data *td)
 	/*
 	 * Initialize the new group. After sleeping, read the blkcg again.
 	 */
-	rcu_read_lock();
 	blkcg = task_blkio_cgroup(current);
 
 	/*
@@ -354,7 +351,6 @@ static struct throtl_grp * throtl_get_tg(struct throtl_data *td)
 
 	if (__tg) {
 		kfree(tg);
-		rcu_read_unlock();
 		return __tg;
 	}
 
@@ -365,7 +361,6 @@ static struct throtl_grp * throtl_get_tg(struct throtl_data *td)
 	}
 
 	throtl_init_add_tg_lists(td, tg, blkcg);
-	rcu_read_unlock();
 	return tg;
 }
 
@@ -1127,7 +1122,6 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
 	 * basic fields like stats and io rates. If a group has no rules,
 	 * just update the dispatch stats in lockless manner and return.
 	 */
-
 	rcu_read_lock();
 	blkcg = task_blkio_cgroup(current);
 	tg = throtl_find_tg(td, blkcg);
@@ -1137,11 +1131,9 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
 		if (tg_no_rule_group(tg, rw)) {
 			blkiocg_update_dispatch_stats(&tg->blkg, bio->bi_size,
 					rw, rw_is_sync(bio->bi_rw));
-			rcu_read_unlock();
-			goto out;
+			goto out_unlock_rcu;
 		}
 	}
-	rcu_read_unlock();
 
 	/*
 	 * Either group has not been allocated yet or it is not an unlimited
@@ -1199,6 +1191,8 @@ queue_bio:
 
 out_unlock:
 	spin_unlock_irq(q->queue_lock);
+out_unlock_rcu:
+	rcu_read_unlock();
 out:
 	return throttled;
 }
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index ee55019..9f6219f 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1128,13 +1128,10 @@ static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd)
 	struct cfq_group *cfqg = NULL, *__cfqg = NULL;
 	struct request_queue *q = cfqd->queue;
 
-	rcu_read_lock();
 	blkcg = task_blkio_cgroup(current);
 	cfqg = cfq_find_cfqg(cfqd, blkcg);
-	if (cfqg) {
-		rcu_read_unlock();
+	if (cfqg)
 		return cfqg;
-	}
 
 	/*
 	 * Need to allocate a group. Allocation of group also needs allocation
@@ -1164,7 +1161,6 @@ static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd)
 
 	if (__cfqg) {
 		kfree(cfqg);
-		rcu_read_unlock();
 		return __cfqg;
 	}
 
@@ -1172,7 +1168,6 @@ static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd)
 		cfqg = &cfqd->root_group;
 
 	cfq_init_add_cfqg_lists(cfqd, cfqg, blkcg);
-	rcu_read_unlock();
 	return cfqg;
 }
 
@@ -2860,6 +2855,8 @@ cfq_find_alloc_queue(struct cfq_data *cfqd, bool is_sync,
 	struct cfq_group *cfqg;
 
 retry:
+	rcu_read_lock();
+
 	cfqg = cfq_get_cfqg(cfqd);
 	cic = cfq_cic_lookup(cfqd, ioc);
 	/* cic always exists here */
@@ -2875,6 +2872,7 @@ retry:
 			cfqq = new_cfqq;
 			new_cfqq = NULL;
 		} else if (gfp_mask & __GFP_WAIT) {
+			rcu_read_unlock();
 			spin_unlock_irq(cfqd->queue->queue_lock);
 			new_cfqq = kmem_cache_alloc_node(cfq_pool,
 					gfp_mask | __GFP_ZERO,
@@ -2900,6 +2898,7 @@ retry:
 	if (new_cfqq)
 		kmem_cache_free(cfq_pool, new_cfqq);
 
+	rcu_read_unlock();
 	return cfqq;
 }
 
-- 
1.7.7.3

