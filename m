Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933692Ab1ERTOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 15:14:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933646Ab1ERTNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 15:13:30 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: dpshah@google.com, vgoyal@redhat.com
Subject: [PATCH 14/14] blk-throttle: Make no throttling rule group processing lockless
Date: Wed, 18 May 2011 15:13:26 -0400
Message-Id: <1305746006-5837-15-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1305746006-5837-1-git-send-email-vgoyal@redhat.com>
References: <1305746006-5837-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we take a queue lock on each bio to check if there are any
throttling rules associated with the group and also update the stats.
Now access the group under rcu and update the stats without taking
the queue lock. Queue lock is taken only if there are throttling rules
associated with the group.

So the common case of root group when there are no rules, save
unnecessary pounding of request queue lock.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-throttle.c |   53 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 44ce1a5..7df7067 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -229,6 +229,22 @@ __throtl_tg_fill_dev_details(struct throtl_data *td, struct throtl_grp *tg)
 	}
 }
 
+/*
+ * Should be called with without queue lock held. Here queue lock will be
+ * taken rarely. It will be taken only once during life time of a group
+ * if need be
+ */
+static void
+throtl_tg_fill_dev_details(struct throtl_data *td, struct throtl_grp *tg)
+{
+	if (!tg || tg->blkg.dev)
+		return;
+
+	spin_lock_irq(td->queue->queue_lock);
+	__throtl_tg_fill_dev_details(td, tg);
+	spin_unlock_irq(td->queue->queue_lock);
+}
+
 static void throtl_init_add_tg_lists(struct throtl_data *td,
 			struct throtl_grp *tg, struct blkio_cgroup *blkcg)
 {
@@ -666,6 +682,12 @@ static bool tg_with_in_bps_limit(struct throtl_data *td, struct throtl_grp *tg,
 	return 0;
 }
 
+static bool tg_no_rule_group(struct throtl_grp *tg, bool rw) {
+	if (tg->bps[rw] == -1 && tg->iops[rw] == -1)
+		return 1;
+	return 0;
+}
+
 /*
  * Returns whether one can dispatch a bio or not. Also returns approx number
  * of jiffies to wait before this bio is with-in IO rate and can be dispatched
@@ -730,10 +752,6 @@ static void throtl_charge_bio(struct throtl_grp *tg, struct bio *bio)
 	tg->bytes_disp[rw] += bio->bi_size;
 	tg->io_disp[rw]++;
 
-	/*
-	 * TODO: This will take blkg->stats_lock. Figure out a way
-	 * to avoid this cost.
-	 */
 	blkiocg_update_dispatch_stats(&tg->blkg, bio->bi_size, rw, sync);
 }
 
@@ -1111,12 +1129,39 @@ int blk_throtl_bio(struct request_queue *q, struct bio **biop)
 	struct throtl_grp *tg;
 	struct bio *bio = *biop;
 	bool rw = bio_data_dir(bio), update_disptime = true;
+	struct blkio_cgroup *blkcg;
 
 	if (bio->bi_rw & REQ_THROTTLED) {
 		bio->bi_rw &= ~REQ_THROTTLED;
 		return 0;
 	}
 
+	/*
+	 * A throtl_grp pointer retrieved under rcu can be used to access
+	 * basic fields like stats and io rates. If a group has no rules,
+	 * just update the dispatch stats in lockless manner and return.
+	 */
+
+	rcu_read_lock();
+	blkcg = task_blkio_cgroup(current);
+	tg = throtl_find_tg(td, blkcg);
+	if (tg) {
+		throtl_tg_fill_dev_details(td, tg);
+
+		if (tg_no_rule_group(tg, rw)) {
+			blkiocg_update_dispatch_stats(&tg->blkg, bio->bi_size,
+					rw, bio->bi_rw & REQ_SYNC);
+			rcu_read_unlock();
+			return 0;
+		}
+	}
+	rcu_read_unlock();
+
+	/*
+	 * Either group has not been allocated yet or it is not an unlimited
+	 * IO group
+	 */
+
 	spin_lock_irq(q->queue_lock);
 	tg = throtl_get_tg(td);
 
-- 
1.7.1

