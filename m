Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab1JSE0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 00:26:49 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55885 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008Ab1JSE0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 00:26:46 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, vgoyal@redhat.com
Cc: ctalbott@google.com, ni@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/10] block: reorganize throtl_get_tg() and blk_throtl_bio()
Date: Tue, 18 Oct 2011 21:26:21 -0700
Message-Id: <1318998384-22525-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1318998384-22525-1-git-send-email-tj@kernel.org>
References: <1318998384-22525-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_throtl_bio() and throtl_get_tg() have rather unusual interface.

* throtl_get_tg() returns pointer to a valid tg or ERR_PTR(-ENODEV),
  and drops queue_lock in the latter case.  Different locking context
  depending on return value is error-prone and DEAD state is scheduled
  to be protected by queue_lock anyway.  Move DEAD check inside
  queue_lock and return valid tg or NULL.

* blk_throtl_bio() indicates return status both with its return value
  and in/out param **@bio.  The former is used to indicate whether
  queue is found to be dead during throtl processing.  The latter
  whether the bio is throttled.

  There's no point in returning DEAD check result from
  blk_throtl_bio().  The queue can die after blk_throtl_bio() is
  finished but before make_request_fn() grabs queue lock.

  Make it take *@bio instead and return boolean result indicating
  whether the request is throttled or not.

This patch doesn't cause any visible functional difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-core.c     |    8 ++------
 block/blk-throttle.c |   49 +++++++++++++++++--------------------------------
 block/blk.h          |    6 +++---
 3 files changed, 22 insertions(+), 41 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 50e3144..7a90317 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1516,12 +1516,8 @@ generic_make_request_checks(struct bio *bio)
 		goto end_io;
 	}
 
-	if (blk_throtl_bio(q, &bio))
-		goto end_io;
-
-	/* if bio = NULL, bio has been throttled and will be submitted later. */
-	if (!bio)
-		return false;
+	if (blk_throtl_bio(q, bio))
+		return false;	/* throttled, will be resubmitted later */
 
 	trace_block_bio_queue(q, bio);
 	return true;
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index ecba5fc..900a0c9 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -303,10 +303,6 @@ throtl_grp *throtl_find_tg(struct throtl_data *td, struct blkio_cgroup *blkcg)
 	return tg;
 }
 
-/*
- * This function returns with queue lock unlocked in case of error, like
- * request queue is no more
- */
 static struct throtl_grp * throtl_get_tg(struct throtl_data *td)
 {
 	struct throtl_grp *tg = NULL, *__tg = NULL;
@@ -330,20 +326,16 @@ static struct throtl_grp * throtl_get_tg(struct throtl_data *td)
 	spin_unlock_irq(q->queue_lock);
 
 	tg = throtl_alloc_tg(td);
-	/*
-	 * We might have slept in group allocation. Make sure queue is not
-	 * dead
-	 */
-	if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags))) {
-		if (tg)
-			kfree(tg);
-
-		return ERR_PTR(-ENODEV);
-	}
 
 	/* Group allocated and queue is still alive. take the lock */
 	spin_lock_irq(q->queue_lock);
 
+	/* Make sure @q is still alive */
+	if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags))) {
+		kfree(tg);
+		return NULL;
+	}
+
 	/*
 	 * Initialize the new group. After sleeping, read the blkcg again.
 	 */
@@ -1118,17 +1110,17 @@ static struct blkio_policy_type blkio_policy_throtl = {
 	.plid = BLKIO_POLICY_THROTL,
 };
 
-int blk_throtl_bio(struct request_queue *q, struct bio **biop)
+bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
 {
 	struct throtl_data *td = q->td;
 	struct throtl_grp *tg;
-	struct bio *bio = *biop;
 	bool rw = bio_data_dir(bio), update_disptime = true;
 	struct blkio_cgroup *blkcg;
+	bool throttled = false;
 
 	if (bio->bi_rw & REQ_THROTTLED) {
 		bio->bi_rw &= ~REQ_THROTTLED;
-		return 0;
+		goto out;
 	}
 
 	/*
@@ -1147,7 +1139,7 @@ int blk_throtl_bio(struct request_queue *q, struct bio **biop)
 			blkiocg_update_dispatch_stats(&tg->blkg, bio->bi_size,
 					rw, rw_is_sync(bio->bi_rw));
 			rcu_read_unlock();
-			return 0;
+			goto out;
 		}
 	}
 	rcu_read_unlock();
@@ -1156,18 +1148,10 @@ int blk_throtl_bio(struct request_queue *q, struct bio **biop)
 	 * Either group has not been allocated yet or it is not an unlimited
 	 * IO group
 	 */
-
 	spin_lock_irq(q->queue_lock);
 	tg = throtl_get_tg(td);
-
-	if (IS_ERR(tg)) {
-		if (PTR_ERR(tg)	== -ENODEV) {
-			/*
-			 * Queue is gone. No queue lock held here.
-			 */
-			return -ENODEV;
-		}
-	}
+	if (unlikely(!tg))
+		goto out_unlock;
 
 	if (tg->nr_queued[rw]) {
 		/*
@@ -1195,7 +1179,7 @@ int blk_throtl_bio(struct request_queue *q, struct bio **biop)
 		 * So keep on trimming slice even if bio is not queued.
 		 */
 		throtl_trim_slice(td, tg, rw);
-		goto out;
+		goto out_unlock;
 	}
 
 queue_bio:
@@ -1207,16 +1191,17 @@ queue_bio:
 			tg->nr_queued[READ], tg->nr_queued[WRITE]);
 
 	throtl_add_bio_tg(q->td, tg, bio);
-	*biop = NULL;
+	throttled = true;
 
 	if (update_disptime) {
 		tg_update_disptime(td, tg);
 		throtl_schedule_next_dispatch(td);
 	}
 
-out:
+out_unlock:
 	spin_unlock_irq(q->queue_lock);
-	return 0;
+out:
+	return throttled;
 }
 
 int blk_throtl_init(struct request_queue *q)
diff --git a/block/blk.h b/block/blk.h
index 2b66dc2..c018dba 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -190,13 +190,13 @@ static inline int blk_do_io_stat(struct request *rq)
 }
 
 #ifdef CONFIG_BLK_DEV_THROTTLING
-extern int blk_throtl_bio(struct request_queue *q, struct bio **bio);
+extern bool blk_throtl_bio(struct request_queue *q, struct bio *bio);
 extern int blk_throtl_init(struct request_queue *q);
 extern void blk_throtl_exit(struct request_queue *q);
 #else /* CONFIG_BLK_DEV_THROTTLING */
-static inline int blk_throtl_bio(struct request_queue *q, struct bio **bio)
+static inline bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
 {
-	return 0;
+	return false;
 }
 static inline int blk_throtl_init(struct request_queue *q) { return 0; }
 static inline void blk_throtl_exit(struct request_queue *q) { }
-- 
1.7.3.1

