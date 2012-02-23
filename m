Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab2BWWbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 17:31:19 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51487 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756587Ab2BWWbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 17:31:15 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.210.12 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com, akpm@linux-foundation.org,
        hughd@google.com
Cc: avi@redhat.com, nate@cpanel.net, cl@linux-foundation.org,
        linux-kernel@vger.kernel.org, dpshah@google.com, ctalbott@google.com,
        rni@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 8/8] blkcg: remove blkio_group->stats_lock
Date: Thu, 23 Feb 2012 14:30:46 -0800
Message-Id: <1330036246-21633-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1330036246-21633-1-git-send-email-tj@kernel.org>
References: <1330036246-21633-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With recent plug merge updates, all non-percpu stat updates happen
under queue_lock making stats_lock unnecessary to synchronize stat
updates.  The only synchronization necessary is stat reading, which
can be done using u64_stats_sync instead.

This patch removes blkio_group->stats_lock and adds
blkio_group_stats->syncp for reader synchronization.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c |  209 +++++++++++++++++++++++++--------------------------
 block/blk-cgroup.h |    3 +-
 2 files changed, 103 insertions(+), 109 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index bc2d1f3..a0bd275 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -164,7 +164,7 @@ static inline void blkio_update_group_iops(struct blkio_group *blkg,
 
 /*
  * Add to the appropriate stat variable depending on the request type.
- * This should be called with the blkg->stats_lock held.
+ * This should be called with queue_lock held.
  */
 static void blkio_add_stat(uint64_t *stat, uint64_t add, bool direction,
 				bool sync)
@@ -182,7 +182,7 @@ static void blkio_add_stat(uint64_t *stat, uint64_t add, bool direction,
 /*
  * Decrements the appropriate stat variable if non-zero depending on the
  * request type. Panics on value being zero.
- * This should be called with the blkg->stats_lock held.
+ * This should be called with the queue_lock held.
  */
 static void blkio_check_and_dec_stat(uint64_t *stat, bool direction, bool sync)
 {
@@ -203,7 +203,7 @@ static void blkio_check_and_dec_stat(uint64_t *stat, bool direction, bool sync)
 }
 
 #ifdef CONFIG_DEBUG_BLK_CGROUP
-/* This should be called with the blkg->stats_lock held. */
+/* This should be called with the queue_lock held. */
 static void blkio_set_start_group_wait_time(struct blkio_group *blkg,
 					    struct blkio_policy_type *pol,
 					    struct blkio_group *curr_blkg)
@@ -218,7 +218,7 @@ static void blkio_set_start_group_wait_time(struct blkio_group *blkg,
 	blkio_mark_blkg_waiting(&pd->stats);
 }
 
-/* This should be called with the blkg->stats_lock held. */
+/* This should be called with the queue_lock held. */
 static void blkio_update_group_wait_time(struct blkio_group_stats *stats)
 {
 	unsigned long long now;
@@ -232,7 +232,7 @@ static void blkio_update_group_wait_time(struct blkio_group_stats *stats)
 	blkio_clear_blkg_waiting(stats);
 }
 
-/* This should be called with the blkg->stats_lock held. */
+/* This should be called with the queue_lock held. */
 static void blkio_end_empty_time(struct blkio_group_stats *stats)
 {
 	unsigned long long now;
@@ -249,84 +249,74 @@ static void blkio_end_empty_time(struct blkio_group_stats *stats)
 void blkiocg_update_set_idle_time_stats(struct blkio_group *blkg,
 					struct blkio_policy_type *pol)
 {
-	struct blkg_policy_data *pd = blkg->pd[pol->plid];
-	unsigned long flags;
+	struct blkio_group_stats *stats = &blkg->pd[pol->plid]->stats;
 
-	spin_lock_irqsave(&blkg->stats_lock, flags);
-	BUG_ON(blkio_blkg_idling(&pd->stats));
-	pd->stats.start_idle_time = sched_clock();
-	blkio_mark_blkg_idling(&pd->stats);
-	spin_unlock_irqrestore(&blkg->stats_lock, flags);
+	lockdep_assert_held(blkg->q->queue_lock);
+	BUG_ON(blkio_blkg_idling(stats));
+
+	stats->start_idle_time = sched_clock();
+	blkio_mark_blkg_idling(stats);
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_set_idle_time_stats);
 
 void blkiocg_update_idle_time_stats(struct blkio_group *blkg,
 				    struct blkio_policy_type *pol)
 {
-	struct blkg_policy_data *pd = blkg->pd[pol->plid];
-	unsigned long flags;
-	unsigned long long now;
-	struct blkio_group_stats *stats;
+	struct blkio_group_stats *stats = &blkg->pd[pol->plid]->stats;
+
+	lockdep_assert_held(blkg->q->queue_lock);
 
-	spin_lock_irqsave(&blkg->stats_lock, flags);
-	stats = &pd->stats;
 	if (blkio_blkg_idling(stats)) {
-		now = sched_clock();
-		if (time_after64(now, stats->start_idle_time))
+		unsigned long long now = sched_clock();
+
+		if (time_after64(now, stats->start_idle_time)) {
+			u64_stats_update_begin(&stats->syncp);
 			stats->idle_time += now - stats->start_idle_time;
+			u64_stats_update_end(&stats->syncp);
+		}
 		blkio_clear_blkg_idling(stats);
 	}
-	spin_unlock_irqrestore(&blkg->stats_lock, flags);
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_idle_time_stats);
 
 void blkiocg_update_avg_queue_size_stats(struct blkio_group *blkg,
 					 struct blkio_policy_type *pol)
 {
-	struct blkg_policy_data *pd = blkg->pd[pol->plid];
-	unsigned long flags;
-	struct blkio_group_stats *stats;
+	struct blkio_group_stats *stats = &blkg->pd[pol->plid]->stats;
 
-	spin_lock_irqsave(&blkg->stats_lock, flags);
-	stats = &pd->stats;
+	lockdep_assert_held(blkg->q->queue_lock);
+
+	u64_stats_update_begin(&stats->syncp);
 	stats->avg_queue_size_sum +=
 			stats->stat_arr[BLKIO_STAT_QUEUED][BLKIO_STAT_READ] +
 			stats->stat_arr[BLKIO_STAT_QUEUED][BLKIO_STAT_WRITE];
 	stats->avg_queue_size_samples++;
 	blkio_update_group_wait_time(stats);
-	spin_unlock_irqrestore(&blkg->stats_lock, flags);
+	u64_stats_update_end(&stats->syncp);
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_avg_queue_size_stats);
 
 void blkiocg_set_start_empty_time(struct blkio_group *blkg,
 				  struct blkio_policy_type *pol)
 {
-	struct blkg_policy_data *pd = blkg->pd[pol->plid];
-	unsigned long flags;
-	struct blkio_group_stats *stats;
+	struct blkio_group_stats *stats = &blkg->pd[pol->plid]->stats;
 
-	spin_lock_irqsave(&blkg->stats_lock, flags);
-	stats = &pd->stats;
+	lockdep_assert_held(blkg->q->queue_lock);
 
 	if (stats->stat_arr[BLKIO_STAT_QUEUED][BLKIO_STAT_READ] ||
-			stats->stat_arr[BLKIO_STAT_QUEUED][BLKIO_STAT_WRITE]) {
-		spin_unlock_irqrestore(&blkg->stats_lock, flags);
+			stats->stat_arr[BLKIO_STAT_QUEUED][BLKIO_STAT_WRITE])
 		return;
-	}
 
 	/*
 	 * group is already marked empty. This can happen if cfqq got new
 	 * request in parent group and moved to this group while being added
 	 * to service tree. Just ignore the event and move on.
 	 */
-	if(blkio_blkg_empty(stats)) {
-		spin_unlock_irqrestore(&blkg->stats_lock, flags);
+	if (blkio_blkg_empty(stats))
 		return;
-	}
 
 	stats->start_empty_time = sched_clock();
 	blkio_mark_blkg_empty(stats);
-	spin_unlock_irqrestore(&blkg->stats_lock, flags);
 }
 EXPORT_SYMBOL_GPL(blkiocg_set_start_empty_time);
 
@@ -336,6 +326,8 @@ void blkiocg_update_dequeue_stats(struct blkio_group *blkg,
 {
 	struct blkg_policy_data *pd = blkg->pd[pol->plid];
 
+	lockdep_assert_held(blkg->q->queue_lock);
+
 	pd->stats.dequeue += dequeue;
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_dequeue_stats);
@@ -351,15 +343,16 @@ void blkiocg_update_io_add_stats(struct blkio_group *blkg,
 				 struct blkio_group *curr_blkg, bool direction,
 				 bool sync)
 {
-	struct blkg_policy_data *pd = blkg->pd[pol->plid];
-	unsigned long flags;
+	struct blkio_group_stats *stats = &blkg->pd[pol->plid]->stats;
+
+	lockdep_assert_held(blkg->q->queue_lock);
+
+	u64_stats_update_begin(&stats->syncp);
+	blkio_add_stat(stats->stat_arr[BLKIO_STAT_QUEUED], 1, direction, sync);
+	blkio_end_empty_time(stats);
+	u64_stats_update_end(&stats->syncp);
 
-	spin_lock_irqsave(&blkg->stats_lock, flags);
-	blkio_add_stat(pd->stats.stat_arr[BLKIO_STAT_QUEUED], 1, direction,
-			sync);
-	blkio_end_empty_time(&pd->stats);
 	blkio_set_start_group_wait_time(blkg, pol, curr_blkg);
-	spin_unlock_irqrestore(&blkg->stats_lock, flags);
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_io_add_stats);
 
@@ -367,13 +360,14 @@ void blkiocg_update_io_remove_stats(struct blkio_group *blkg,
 				    struct blkio_policy_type *pol,
 				    bool direction, bool sync)
 {
-	struct blkg_policy_data *pd = blkg->pd[pol->plid];
-	unsigned long flags;
+	struct blkio_group_stats *stats = &blkg->pd[pol->plid]->stats;
 
-	spin_lock_irqsave(&blkg->stats_lock, flags);
-	blkio_check_and_dec_stat(pd->stats.stat_arr[BLKIO_STAT_QUEUED],
-					direction, sync);
-	spin_unlock_irqrestore(&blkg->stats_lock, flags);
+	lockdep_assert_held(blkg->q->queue_lock);
+
+	u64_stats_update_begin(&stats->syncp);
+	blkio_check_and_dec_stat(stats->stat_arr[BLKIO_STAT_QUEUED], direction,
+				 sync);
+	u64_stats_update_end(&stats->syncp);
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_io_remove_stats);
 
@@ -382,15 +376,16 @@ void blkiocg_update_timeslice_used(struct blkio_group *blkg,
 				   unsigned long time,
 				   unsigned long unaccounted_time)
 {
-	struct blkg_policy_data *pd = blkg->pd[pol->plid];
-	unsigned long flags;
+	struct blkio_group_stats *stats = &blkg->pd[pol->plid]->stats;
+
+	lockdep_assert_held(blkg->q->queue_lock);
 
-	spin_lock_irqsave(&blkg->stats_lock, flags);
-	pd->stats.time += time;
+	u64_stats_update_begin(&stats->syncp);
+	stats->time += time;
 #ifdef CONFIG_DEBUG_BLK_CGROUP
-	pd->stats.unaccounted_time += unaccounted_time;
+	stats->unaccounted_time += unaccounted_time;
 #endif
-	spin_unlock_irqrestore(&blkg->stats_lock, flags);
+	u64_stats_update_end(&stats->syncp);
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_timeslice_used);
 
@@ -432,20 +427,19 @@ void blkiocg_update_completion_stats(struct blkio_group *blkg,
 				     uint64_t io_start_time, bool direction,
 				     bool sync)
 {
-	struct blkg_policy_data *pd = blkg->pd[pol->plid];
-	struct blkio_group_stats *stats;
-	unsigned long flags;
+	struct blkio_group_stats *stats = &blkg->pd[pol->plid]->stats;
 	unsigned long long now = sched_clock();
 
-	spin_lock_irqsave(&blkg->stats_lock, flags);
-	stats = &pd->stats;
+	lockdep_assert_held(blkg->q->queue_lock);
+
+	u64_stats_update_begin(&stats->syncp);
 	if (time_after64(now, io_start_time))
 		blkio_add_stat(stats->stat_arr[BLKIO_STAT_SERVICE_TIME],
 				now - io_start_time, direction, sync);
 	if (time_after64(io_start_time, start_time))
 		blkio_add_stat(stats->stat_arr[BLKIO_STAT_WAIT_TIME],
 				io_start_time - start_time, direction, sync);
-	spin_unlock_irqrestore(&blkg->stats_lock, flags);
+	u64_stats_update_end(&stats->syncp);
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_completion_stats);
 
@@ -454,14 +448,13 @@ void blkiocg_update_io_merged_stats(struct blkio_group *blkg,
 				    struct blkio_policy_type *pol,
 				    bool direction, bool sync)
 {
-	struct blkg_policy_data *pd = blkg->pd[pol->plid];
-	struct blkio_group_stats *stats;
-	unsigned long flags;
+	struct blkio_group_stats *stats = &blkg->pd[pol->plid]->stats;
 
-	spin_lock_irqsave(&blkg->stats_lock, flags);
-	stats = &pd->stats;
+	lockdep_assert_held(blkg->q->queue_lock);
+
+	u64_stats_update_begin(&stats->syncp);
 	blkio_add_stat(stats->stat_arr[BLKIO_STAT_MERGED], 1, direction, sync);
-	spin_unlock_irqrestore(&blkg->stats_lock, flags);
+	u64_stats_update_end(&stats->syncp);
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_io_merged_stats);
 
@@ -508,7 +501,6 @@ static struct blkio_group *blkg_alloc(struct blkio_cgroup *blkcg,
 	if (!blkg)
 		return NULL;
 
-	spin_lock_init(&blkg->stats_lock);
 	blkg->q = q;
 	INIT_LIST_HEAD(&blkg->q_node);
 	blkg->blkcg = blkcg;
@@ -891,7 +883,6 @@ static uint64_t blkio_get_stat_cpu(struct blkio_group *blkg, int plid,
 	return disk_total;
 }
 
-/* This should be called with blkg->stats_lock held */
 static uint64_t blkio_get_stat(struct blkio_group *blkg, int plid,
 			       struct cgroup_map_cb *cb, const char *dname,
 			       enum stat_type type)
@@ -899,42 +890,46 @@ static uint64_t blkio_get_stat(struct blkio_group *blkg, int plid,
 	struct blkio_group_stats *stats = &blkg->pd[plid]->stats;
 	uint64_t v = 0, disk_total = 0;
 	char key_str[MAX_KEY_LEN];
+	unsigned int sync_start;
 	int st;
 
 	if (type >= BLKIO_STAT_ARR_NR) {
-		switch (type) {
-		case BLKIO_STAT_TIME:
-			v = stats->time;
-			break;
+		do {
+			sync_start = u64_stats_fetch_begin(&stats->syncp);
+			switch (type) {
+			case BLKIO_STAT_TIME:
+				v = stats->time;
+				break;
 #ifdef CONFIG_DEBUG_BLK_CGROUP
-		case BLKIO_STAT_UNACCOUNTED_TIME:
-			v = stats->unaccounted_time;
-			break;
-		case BLKIO_STAT_AVG_QUEUE_SIZE: {
-			uint64_t samples = stats->avg_queue_size_samples;
+			case BLKIO_STAT_UNACCOUNTED_TIME:
+				v = stats->unaccounted_time;
+				break;
+			case BLKIO_STAT_AVG_QUEUE_SIZE: {
+				uint64_t samples = stats->avg_queue_size_samples;
 
-			if (samples) {
-				v = stats->avg_queue_size_sum;
-				do_div(v, samples);
+				if (samples) {
+					v = stats->avg_queue_size_sum;
+					do_div(v, samples);
+				}
+				break;
 			}
-			break;
-		}
-		case BLKIO_STAT_IDLE_TIME:
-			v = stats->idle_time;
-			break;
-		case BLKIO_STAT_EMPTY_TIME:
-			v = stats->empty_time;
-			break;
-		case BLKIO_STAT_DEQUEUE:
-			v = stats->dequeue;
-			break;
-		case BLKIO_STAT_GROUP_WAIT_TIME:
-			v = stats->group_wait_time;
-			break;
+			case BLKIO_STAT_IDLE_TIME:
+				v = stats->idle_time;
+				break;
+			case BLKIO_STAT_EMPTY_TIME:
+				v = stats->empty_time;
+				break;
+			case BLKIO_STAT_DEQUEUE:
+				v = stats->dequeue;
+				break;
+			case BLKIO_STAT_GROUP_WAIT_TIME:
+				v = stats->group_wait_time;
+				break;
 #endif
-		default:
-			WARN_ON_ONCE(1);
-		}
+			default:
+				WARN_ON_ONCE(1);
+			}
+		} while (u64_stats_fetch_retry(&stats->syncp, sync_start));
 
 		blkio_get_key_name(0, dname, key_str, MAX_KEY_LEN, true);
 		cb->fill(cb, key_str, v);
@@ -942,7 +937,10 @@ static uint64_t blkio_get_stat(struct blkio_group *blkg, int plid,
 	}
 
 	for (st = BLKIO_STAT_READ; st < BLKIO_STAT_TOTAL; st++) {
-		v = stats->stat_arr[type][st];
+		do {
+			sync_start = u64_stats_fetch_begin(&stats->syncp);
+			v = stats->stat_arr[type][st];
+		} while (u64_stats_fetch_retry(&stats->syncp, sync_start));
 
 		blkio_get_key_name(st, dname, key_str, MAX_KEY_LEN, false);
 		cb->fill(cb, key_str, v);
@@ -1199,15 +1197,12 @@ static int blkio_read_blkg_stats(struct blkio_cgroup *blkcg,
 		const char *dname = dev_name(blkg->q->backing_dev_info.dev);
 		int plid = BLKIOFILE_POLICY(cft->private);
 
-		if (pcpu) {
+		if (pcpu)
 			cgroup_total += blkio_get_stat_cpu(blkg, plid,
 							   cb, dname, type);
-		} else {
-			spin_lock(&blkg->stats_lock);
+		else
 			cgroup_total += blkio_get_stat(blkg, plid,
 						       cb, dname, type);
-			spin_unlock(&blkg->stats_lock);
-		}
 	}
 	if (show_total)
 		cb->fill(cb, "Total", cgroup_total);
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 1425de1..7d92d3f 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -119,6 +119,7 @@ struct blkio_cgroup {
 };
 
 struct blkio_group_stats {
+	struct u64_stats_sync syncp;
 	/* total disk time and nr sectors dispatched by this group */
 	uint64_t time;
 	uint64_t stat_arr[BLKIO_STAT_ARR_NR][BLKIO_STAT_TOTAL];
@@ -200,8 +201,6 @@ struct blkio_group {
 	/* reference count */
 	int refcnt;
 
-	/* Need to serialize the stats in the case of reset/update */
-	spinlock_t stats_lock;
 	struct blkg_policy_data *pd[BLKIO_NR_POLICIES];
 
 	struct rcu_head rcu_head;
-- 
1.7.7.3

