Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab2BVBra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 20:47:30 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41551 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab2BVBr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 20:47:27 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.239.170 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/36] blkcg: move rcu_read_lock() outside of blkio_group get functions
Date: Tue, 21 Feb 2012 17:46:36 -0800
Message-Id: <1329875223-5102-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1329875223-5102-1-git-send-email-tj@kernel.org>
References: <1329875223-5102-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rcu_read_lock() in throtl_get_tb() and cfq_get_cfqg() holds onto
@blkcg while looking up blkg.  For API cleanup, the next patch will
make the caller responsible for determining @blkcg to look blkg from
and let them specify it as a parameter.  Move rcu read locking out to
the callers to prepare for the change.

-v2: Originally this patch was described as a fix for RCU read locking
     bug around @blkg, which Vivek pointed out to be incorrect.  It
     was from misunderstanding the role of rcu locking as protecting
     @blkg not @blkcg.  Patch description updated.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-throttle.c |   18 ++++++------------
 block/cfq-iosched.c  |   11 +++++------
 2 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 3699ab4..9beaac7 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -313,25 +313,23 @@ static struct throtl_grp * throtl_get_tg(struct throtl_data *td)
 	if (unlikely(blk_queue_bypass(q)))
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
 
@@ -1150,7 +1145,6 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
 	 * basic fields like stats and io rates. If a group has no rules,
 	 * just update the dispatch stats in lockless manner and return.
 	 */
-
 	rcu_read_lock();
 	blkcg = task_blkio_cgroup(current);
 	tg = throtl_find_tg(td, blkcg);
@@ -1160,11 +1154,9 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
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
@@ -1222,6 +1214,8 @@ queue_bio:
 
 out_unlock:
 	spin_unlock_irq(q->queue_lock);
+out_unlock_rcu:
+	rcu_read_unlock();
 out:
 	return throttled;
 }
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 61693d3..6063c44 100644
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
 
@@ -2870,6 +2865,8 @@ cfq_find_alloc_queue(struct cfq_data *cfqd, bool is_sync,
 	struct cfq_group *cfqg;
 
 retry:
+	rcu_read_lock();
+
 	cfqg = cfq_get_cfqg(cfqd);
 	cic = cfq_cic_lookup(cfqd, ioc);
 	/* cic always exists here */
@@ -2885,6 +2882,7 @@ retry:
 			cfqq = new_cfqq;
 			new_cfqq = NULL;
 		} else if (gfp_mask & __GFP_WAIT) {
+			rcu_read_unlock();
 			spin_unlock_irq(cfqd->queue->queue_lock);
 			new_cfqq = kmem_cache_alloc_node(cfq_pool,
 					gfp_mask | __GFP_ZERO,
@@ -2910,6 +2908,7 @@ retry:
 	if (new_cfqq)
 		kmem_cache_free(cfq_pool, new_cfqq);
 
+	rcu_read_unlock();
 	return cfqq;
 }
 
-- 
1.7.7.3

