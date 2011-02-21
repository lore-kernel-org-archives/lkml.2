Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534Ab1BUXmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 18:42:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab1BUXmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 18:42:53 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: oleg@redhat.com, paulmck@linux.vnet.ibm.com, vgoyal@redhat.com
Subject: [PATCH 2/2] blk-throttle: Some cleanups and race fixes in limit update code
Date: Mon, 21 Feb 2011 18:42:50 -0500
Message-Id: <1298331770-20079-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1298331770-20079-1-git-send-email-vgoyal@redhat.com>
References: <1298331770-20079-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o When throttle group limits are updated through cgroups, a thread is woken
  up to process these updates. While reviewing that code, oleg noted couple
  of race conditions existed in the code and he also suggested that code can
  be simplified.

o This patch fixes the races simplifies the code based on Oleg's suggestions.
        - Use xchg().
        - Introduced a common function throtl_update_blkio_group_common()
          which is shared now by all iops/bps update functions.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-throttle.c |   96 +++++++++++++++++++++-----------------------------
 1 files changed, 40 insertions(+), 56 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 67bd250..bb7d21b 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -97,7 +97,7 @@ struct throtl_data
 	/* Work for dispatching throttled bios */
 	struct delayed_work throtl_work;
 
-	atomic_t limits_changed;
+	bool limits_changed;
 };
 
 enum tg_state_flags {
@@ -196,6 +196,7 @@ static struct throtl_grp * throtl_find_alloc_tg(struct throtl_data *td,
 	RB_CLEAR_NODE(&tg->rb_node);
 	bio_list_init(&tg->bio_lists[0]);
 	bio_list_init(&tg->bio_lists[1]);
+	td->limits_changed = false;
 
 	/*
 	 * Take the initial reference that will be released on destroy
@@ -733,34 +734,27 @@ static void throtl_process_limit_change(struct throtl_data *td)
 	struct throtl_grp *tg;
 	struct hlist_node *pos, *n;
 
-	if (!atomic_read(&td->limits_changed))
+	if (!td->limits_changed)
 		return;
 
-	throtl_log(td, "limit changed =%d", atomic_read(&td->limits_changed));
+	xchg(&td->limits_changed, false);
 
-	/*
-	 * Make sure updates from throtl_update_blkio_group_read_bps() group
-	 * of functions to tg->limits_changed are visible. We do not
-	 * want update td->limits_changed to be visible but update to
-	 * tg->limits_changed not being visible yet on this cpu. Hence
-	 * the read barrier.
-	 */
-	smp_rmb();
+	throtl_log(td, "limits changed");
 
 	hlist_for_each_entry_safe(tg, pos, n, &td->tg_list, tg_node) {
-		if (throtl_tg_on_rr(tg) && tg->limits_changed) {
-			throtl_log_tg(td, tg, "limit change rbps=%llu wbps=%llu"
-				" riops=%u wiops=%u", tg->bps[READ],
-				tg->bps[WRITE], tg->iops[READ],
-				tg->iops[WRITE]);
+		if (!tg->limits_changed)
+			continue;
+
+		if (!xchg(&tg->limits_changed, false))
+			continue;
+
+		throtl_log_tg(td, tg, "limit change rbps=%llu wbps=%llu"
+			" riops=%u wiops=%u", tg->bps[READ], tg->bps[WRITE],
+			tg->iops[READ], tg->iops[WRITE]);
+
+		if (throtl_tg_on_rr(tg))
 			tg_update_disptime(td, tg);
-			tg->limits_changed = false;
-		}
 	}
-
-	smp_mb__before_atomic_dec();
-	atomic_dec(&td->limits_changed);
-	smp_mb__after_atomic_dec();
 }
 
 /* Dispatch throttled bios. Should be called without queue lock held. */
@@ -895,6 +889,15 @@ void throtl_unlink_blkio_group(void *key, struct blkio_group *blkg)
 	spin_unlock_irqrestore(td->queue->queue_lock, flags);
 }
 
+static void throtl_update_blkio_group_common(struct throtl_data *td,
+				struct throtl_grp *tg)
+{
+	xchg(&tg->limits_changed, true);
+	xchg(&td->limits_changed, true);
+	/* Schedule a work now to process the limit change */
+	throtl_schedule_delayed_work(td->queue, 0);
+}
+
 /*
  * For all update functions, key should be a valid pointer because these
  * update functions are called under blkcg_lock, that means, blkg is
@@ -908,61 +911,40 @@ static void throtl_update_blkio_group_read_bps(void *key,
 				struct blkio_group *blkg, u64 read_bps)
 {
 	struct throtl_data *td = key;
+	struct throtl_grp *tg = tg_of_blkg(blkg);
 
-	tg_of_blkg(blkg)->bps[READ] = read_bps;
-	/* Make sure read_bps is updated before setting limits_changed */
-	smp_wmb();
-	tg_of_blkg(blkg)->limits_changed = true;
-
-	/* Make sure tg->limits_changed is updated before td->limits_changed */
-	smp_mb__before_atomic_inc();
-	atomic_inc(&td->limits_changed);
-	smp_mb__after_atomic_inc();
-
-	/* Schedule a work now to process the limit change */
-	throtl_schedule_delayed_work(td->queue, 0);
+	tg->bps[READ] = read_bps;
+	throtl_update_blkio_group_common(td, tg);
 }
 
 static void throtl_update_blkio_group_write_bps(void *key,
 				struct blkio_group *blkg, u64 write_bps)
 {
 	struct throtl_data *td = key;
+	struct throtl_grp *tg = tg_of_blkg(blkg);
 
-	tg_of_blkg(blkg)->bps[WRITE] = write_bps;
-	smp_wmb();
-	tg_of_blkg(blkg)->limits_changed = true;
-	smp_mb__before_atomic_inc();
-	atomic_inc(&td->limits_changed);
-	smp_mb__after_atomic_inc();
-	throtl_schedule_delayed_work(td->queue, 0);
+	tg->bps[WRITE] = write_bps;
+	throtl_update_blkio_group_common(td, tg);
 }
 
 static void throtl_update_blkio_group_read_iops(void *key,
 			struct blkio_group *blkg, unsigned int read_iops)
 {
 	struct throtl_data *td = key;
+	struct throtl_grp *tg = tg_of_blkg(blkg);
 
-	tg_of_blkg(blkg)->iops[READ] = read_iops;
-	smp_wmb();
-	tg_of_blkg(blkg)->limits_changed = true;
-	smp_mb__before_atomic_inc();
-	atomic_inc(&td->limits_changed);
-	smp_mb__after_atomic_inc();
-	throtl_schedule_delayed_work(td->queue, 0);
+	tg->iops[READ] = read_iops;
+	throtl_update_blkio_group_common(td, tg);
 }
 
 static void throtl_update_blkio_group_write_iops(void *key,
 			struct blkio_group *blkg, unsigned int write_iops)
 {
 	struct throtl_data *td = key;
+	struct throtl_grp *tg = tg_of_blkg(blkg);
 
-	tg_of_blkg(blkg)->iops[WRITE] = write_iops;
-	smp_wmb();
-	tg_of_blkg(blkg)->limits_changed = true;
-	smp_mb__before_atomic_inc();
-	atomic_inc(&td->limits_changed);
-	smp_mb__after_atomic_inc();
-	throtl_schedule_delayed_work(td->queue, 0);
+	tg->iops[WRITE] = write_iops;
+	throtl_update_blkio_group_common(td, tg);
 }
 
 void throtl_shutdown_timer_wq(struct request_queue *q)
@@ -1009,6 +991,7 @@ int blk_throtl_bio(struct request_queue *q, struct bio **biop)
 		 */
 		update_disptime = false;
 		goto queue_bio;
+
 	}
 
 	/* Bio is with-in rate limit of group */
@@ -1049,7 +1032,7 @@ int blk_throtl_init(struct request_queue *q)
 
 	INIT_HLIST_HEAD(&td->tg_list);
 	td->tg_service_tree = THROTL_RB_ROOT;
-	atomic_set(&td->limits_changed, 0);
+	td->limits_changed = false;
 
 	/* Init root group */
 	tg = &td->root_tg;
@@ -1061,6 +1044,7 @@ int blk_throtl_init(struct request_queue *q)
 	/* Practically unlimited BW */
 	tg->bps[0] = tg->bps[1] = -1;
 	tg->iops[0] = tg->iops[1] = -1;
+	td->limits_changed = false;
 
 	/*
 	 * Set root group reference to 2. One reference will be dropped when
-- 
1.7.1

