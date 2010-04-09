Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab0DIEPt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 00:15:49 -0400
Received: from smtp-out.google.com ([216.239.44.51]:61361 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab0DIEPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 00:15:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=bidP6D5rx3E/uIYAbVDCg1qPe8HeRxBE/15P8dTwExN8VuKMqSjItk7hZLnNfJJl3
	faXc6hl8qCtlafiSbTArg==
From: Divyesh Shah <dpshah@google.com>
Subject: [PATCH 3/3] blkio: Add more debug-only per-cgroup stats
To: jens.axboe@oracle.com, vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, nauman@google.com, ctalbott@google.com
Date: Thu, 08 Apr 2010 21:15:35 -0700
Message-ID: <20100409041515.23105.11858.stgit@austin.mtv.corp.google.com>
In-Reply-To: <20100409041210.23105.13623.stgit@austin.mtv.corp.google.com>
References: <20100409041210.23105.13623.stgit@austin.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) group_wait_time - This is the amount of time the cgroup had to wait to get a
  timeslice for one of its queues from when it became busy, i.e., went from 0
  to 1 request queued. This is different from the io_wait_time which is the
  cumulative total of the amount of time spent by each IO in that cgroup waiting
  in the scheduler queue. This stat is a great way to find out any jobs in the
  fleet that are being starved or waiting for longer than what is expected (due
  to an IO controller bug or any other issue).
2) empty_time - This is the amount of time a cgroup spends w/o any pending
   requests. This stat is useful when a job does not seem to be able to use its
   assigned disk share by helping check if that is happening due to an IO
   controller bug or because the job is not submitting enough IOs.
3) idle_time - This is the amount of time spent by the IO scheduler idling
   for a given cgroup in anticipation of a better request than the exising ones
   from other queues/cgroups.

All these stats are recorded using start and stop events. When reading these
stats, we do not add the delta between the current time and the last start time
if we're between the start and stop events. We avoid doing this to make sure
that these numbers are always monotonically increasing when read. Since we're
using sched_clock() which may use the tsc as its source, it may induce some
inconsistency (due to tsc resync across cpus) if we included the current delta.

Signed-off-by: Divyesh Shah<dpshah@google.com>
---

 Documentation/cgroups/blkio-controller.txt |   29 +++++
 block/blk-cgroup.c                         |  159 +++++++++++++++++++++++++++-
 block/blk-cgroup.h                         |   54 ++++++++++
 block/cfq-iosched.c                        |   50 ++++++---
 4 files changed, 271 insertions(+), 21 deletions(-)

diff --git a/Documentation/cgroups/blkio-controller.txt b/Documentation/cgroups/blkio-controller.txt
index 6e52e7c..db054ea 100644
--- a/Documentation/cgroups/blkio-controller.txt
+++ b/Documentation/cgroups/blkio-controller.txt
@@ -150,6 +150,35 @@ Details of cgroup files
 	  cgroup's existence. Queue size samples are taken each time one of the
 	  queues of this cgroup gets a timeslice.
 
+- blkio.group_wait_time
+	- Debugging aid only enabled if CONFIG_DEBUG_CFQ_IOSCHED=y.
+	  This is the amount of time the cgroup had to wait since it became busy
+	  (i.e., went from 0 to 1 request queued) to get a timeslice for one of
+	  its queues. This is different from the io_wait_time which is the
+	  cumulative total of the amount of time spent by each IO in that cgroup
+	  waiting in the scheduler queue. This is in nanoseconds. If this is
+	  read when the cgroup is in a waiting (for timeslice) state, the stat
+	  will only report the group_wait_time accumulated till the last time it
+	  got a timeslice and will not include the current delta.
+
+- blkio.empty_time
+	- Debugging aid only enabled if CONFIG_DEBUG_CFQ_IOSCHED=y.
+	  This is the amount of time a cgroup spends without any pending
+	  requests when not being served, i.e., it does not include any time
+	  spent idling for one of the queues of the cgroup. This is in
+	  nanoseconds. If this is read when the cgroup is in an empty state,
+	  the stat will only report the empty_time accumulated till the last
+	  time it had a pending request and will not include the current delta.
+
+- blkio.idle_time
+	- Debugging aid only enabled if CONFIG_DEBUG_CFQ_IOSCHED=y.
+	  This is the amount of time spent by the IO scheduler idling for a
+	  given cgroup in anticipation of a better request than the exising ones
+	  from other queues/cgroups. This is in nanoseconds. If this is read
+	  when the cgroup is in an idling state, the stat will only report the
+	  idle_time accumulated till the last idle period and will not include
+	  the current delta.
+
 - blkio.dequeue
 	- Debugging aid only enabled if CONFIG_DEBUG_CFQ_IOSCHED=y. This
 	  gives the statistics about how many a times a group was dequeued
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 1e0c497..1ecff7a 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -105,6 +105,76 @@ static void blkio_check_and_dec_stat(uint64_t *stat, bool direction, bool sync)
 }
 
 #ifdef CONFIG_DEBUG_BLK_CGROUP
+/* This should be called with the blkg->stats_lock held. */
+static void blkio_set_start_group_wait_time(struct blkio_group *blkg,
+						struct blkio_group *curr_blkg)
+{
+	if (blkio_blkg_waiting(&blkg->stats))
+		return;
+	if (blkg == curr_blkg)
+		return;
+	blkg->stats.start_group_wait_time = sched_clock();
+	blkio_mark_blkg_waiting(&blkg->stats);
+}
+
+/* This should be called with the blkg->stats_lock held. */
+static void blkio_update_group_wait_time(struct blkio_group_stats *stats)
+{
+	unsigned long long now;
+
+	if (!blkio_blkg_waiting(stats))
+		return;
+
+	now = sched_clock();
+	if (time_after64(now, stats->start_group_wait_time))
+		stats->group_wait_time += now - stats->start_group_wait_time;
+	blkio_clear_blkg_waiting(stats);
+}
+
+/* This should be called with the blkg->stats_lock held. */
+static void blkio_end_empty_time(struct blkio_group_stats *stats)
+{
+	unsigned long long now;
+
+	if (!blkio_blkg_empty(stats))
+		return;
+
+	now = sched_clock();
+	if (time_after64(now, stats->start_empty_time))
+		stats->empty_time += now - stats->start_empty_time;
+	blkio_clear_blkg_empty(stats);
+}
+
+void blkiocg_update_set_idle_time_stats(struct blkio_group *blkg)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&blkg->stats_lock, flags);
+	BUG_ON(blkio_blkg_idling(&blkg->stats));
+	blkg->stats.start_idle_time = sched_clock();
+	blkio_mark_blkg_idling(&blkg->stats);
+	spin_unlock_irqrestore(&blkg->stats_lock, flags);
+}
+EXPORT_SYMBOL_GPL(blkiocg_update_set_idle_time_stats);
+
+void blkiocg_update_idle_time_stats(struct blkio_group *blkg)
+{
+	unsigned long flags;
+	unsigned long long now;
+	struct blkio_group_stats *stats;
+
+	spin_lock_irqsave(&blkg->stats_lock, flags);
+	stats = &blkg->stats;
+	if (blkio_blkg_idling(stats)) {
+		now = sched_clock();
+		if (time_after64(now, stats->start_idle_time))
+			stats->idle_time += now - stats->start_idle_time;
+		blkio_clear_blkg_idling(stats);
+	}
+	spin_unlock_irqrestore(&blkg->stats_lock, flags);
+}
+EXPORT_SYMBOL_GPL(blkiocg_update_idle_time_stats);
+
 void blkiocg_update_set_active_queue_stats(struct blkio_group *blkg)
 {
 	unsigned long flags;
@@ -116,9 +186,14 @@ void blkiocg_update_set_active_queue_stats(struct blkio_group *blkg)
 			stats->stat_arr[BLKIO_STAT_QUEUED][BLKIO_STAT_READ] +
 			stats->stat_arr[BLKIO_STAT_QUEUED][BLKIO_STAT_WRITE];
 	stats->avg_queue_size_samples++;
+	blkio_update_group_wait_time(stats);
 	spin_unlock_irqrestore(&blkg->stats_lock, flags);
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_set_active_queue_stats);
+#else
+static inline void blkio_set_start_group_wait_time(struct blkio_group *blkg,
+					struct blkio_group *curr_blkg) {}
+static inline void blkio_end_empty_time(struct blkio_group_stats *stats) {}
 #endif
 
 void blkiocg_update_request_add_stats(struct blkio_group *blkg,
@@ -130,6 +205,8 @@ void blkiocg_update_request_add_stats(struct blkio_group *blkg,
 	spin_lock_irqsave(&blkg->stats_lock, flags);
 	blkio_add_stat(blkg->stats.stat_arr[BLKIO_STAT_QUEUED], 1, direction,
 			sync);
+	blkio_end_empty_time(&blkg->stats);
+	blkio_set_start_group_wait_time(blkg, curr_blkg);
 	spin_unlock_irqrestore(&blkg->stats_lock, flags);
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_request_add_stats);
@@ -156,6 +233,33 @@ void blkiocg_update_timeslice_used(struct blkio_group *blkg, unsigned long time)
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_timeslice_used);
 
+void blkiocg_set_start_empty_time(struct blkio_group *blkg, bool ignore)
+{
+	unsigned long flags;
+	struct blkio_group_stats *stats;
+
+	spin_lock_irqsave(&blkg->stats_lock, flags);
+	stats = &blkg->stats;
+
+	if (stats->stat_arr[BLKIO_STAT_QUEUED][BLKIO_STAT_READ] ||
+			stats->stat_arr[BLKIO_STAT_QUEUED][BLKIO_STAT_WRITE]) {
+		spin_unlock_irqrestore(&blkg->stats_lock, flags);
+		return;
+	}
+
+	/*
+	 * If ignore is set, we do not panic on the empty flag being set
+	 * already. This is to avoid cases where there are superfluous timeslice
+	 * complete events (for eg., forced_dispatch in CFQ) when no IOs are
+	 * served which could result in triggering the empty check incorrectly.
+	 */
+	BUG_ON(!ignore && blkio_blkg_empty(stats));
+	stats->start_empty_time = sched_clock();
+	blkio_mark_blkg_empty(stats);
+	spin_unlock_irqrestore(&blkg->stats_lock, flags);
+}
+EXPORT_SYMBOL_GPL(blkiocg_set_start_empty_time);
+
 void blkiocg_update_dispatch_stats(struct blkio_group *blkg,
 				uint64_t bytes, bool direction, bool sync)
 {
@@ -317,19 +421,44 @@ blkiocg_reset_stats(struct cgroup *cgroup, struct cftype *cftype, u64 val)
 {
 	struct blkio_cgroup *blkcg;
 	struct blkio_group *blkg;
+	struct blkio_group_stats *stats;
 	struct hlist_node *n;
 	uint64_t queued[BLKIO_STAT_TOTAL];
 	int i;
+#ifdef CONFIG_DEBUG_BLK_CGROUP
+	bool idling, waiting, empty;
+	unsigned long long now = sched_clock();
+#endif
 
 	blkcg = cgroup_to_blkio_cgroup(cgroup);
 	spin_lock_irq(&blkcg->lock);
 	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
 		spin_lock(&blkg->stats_lock);
+		stats = &blkg->stats;
+#ifdef CONFIG_DEBUG_BLK_CGROUP
+		idling = blkio_blkg_idling(stats);
+		waiting = blkio_blkg_waiting(stats);
+		empty = blkio_blkg_empty(stats);
+#endif
 		for (i = 0; i < BLKIO_STAT_TOTAL; i++)
-			queued[i] = blkg->stats.stat_arr[BLKIO_STAT_QUEUED][i];
-		memset(&blkg->stats, 0, sizeof(struct blkio_group_stats));
+			queued[i] = stats->stat_arr[BLKIO_STAT_QUEUED][i];
+		memset(stats, 0, sizeof(struct blkio_group_stats));
 		for (i = 0; i < BLKIO_STAT_TOTAL; i++)
-			blkg->stats.stat_arr[BLKIO_STAT_QUEUED][i] = queued[i];
+			stats->stat_arr[BLKIO_STAT_QUEUED][i] = queued[i];
+#ifdef CONFIG_DEBUG_BLK_CGROUP
+		if (idling) {
+			blkio_mark_blkg_idling(stats);
+			stats->start_idle_time = now;
+		}
+		if (waiting) {
+			blkio_mark_blkg_waiting(stats);
+			stats->start_group_wait_time = now;
+		}
+		if (empty) {
+			blkio_mark_blkg_empty(stats);
+			stats->start_empty_time = now;
+		}
+#endif
 		spin_unlock(&blkg->stats_lock);
 	}
 	spin_unlock_irq(&blkcg->lock);
@@ -401,6 +530,15 @@ static uint64_t blkio_get_stat(struct blkio_group *blkg,
 			sum = 0;
 		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1, sum, cb, dev);
 	}
+	if (type == BLKIO_STAT_GROUP_WAIT_TIME)
+		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
+					blkg->stats.group_wait_time, cb, dev);
+	if (type == BLKIO_STAT_IDLE_TIME)
+		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
+					blkg->stats.idle_time, cb, dev);
+	if (type == BLKIO_STAT_EMPTY_TIME)
+		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
+					blkg->stats.empty_time, cb, dev);
 	if (type == BLKIO_STAT_DEQUEUE)
 		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
 					blkg->stats.dequeue, cb, dev);
@@ -458,6 +596,9 @@ SHOW_FUNCTION_PER_GROUP(io_queued, BLKIO_STAT_QUEUED, 1);
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 SHOW_FUNCTION_PER_GROUP(dequeue, BLKIO_STAT_DEQUEUE, 0);
 SHOW_FUNCTION_PER_GROUP(avg_queue_size, BLKIO_STAT_AVG_QUEUE_SIZE, 0);
+SHOW_FUNCTION_PER_GROUP(group_wait_time, BLKIO_STAT_GROUP_WAIT_TIME, 0);
+SHOW_FUNCTION_PER_GROUP(idle_time, BLKIO_STAT_IDLE_TIME, 0);
+SHOW_FUNCTION_PER_GROUP(empty_time, BLKIO_STAT_EMPTY_TIME, 0);
 #endif
 #undef SHOW_FUNCTION_PER_GROUP
 
@@ -518,6 +659,18 @@ struct cftype blkio_files[] = {
 		.read_map = blkiocg_avg_queue_size_read,
 	},
 	{
+		.name = "group_wait_time",
+		.read_map = blkiocg_group_wait_time_read,
+	},
+	{
+		.name = "idle_time",
+		.read_map = blkiocg_idle_time_read,
+	},
+	{
+		.name = "empty_time",
+		.read_map = blkiocg_empty_time_read,
+	},
+	{
 		.name = "dequeue",
 		.read_map = blkiocg_dequeue_read,
 	},
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index bea7f3b..bfce085 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -43,6 +43,9 @@ enum stat_type {
 	BLKIO_STAT_SECTORS,
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 	BLKIO_STAT_AVG_QUEUE_SIZE,
+	BLKIO_STAT_IDLE_TIME,
+	BLKIO_STAT_EMPTY_TIME,
+	BLKIO_STAT_GROUP_WAIT_TIME,
 	BLKIO_STAT_DEQUEUE
 #endif
 };
@@ -55,6 +58,13 @@ enum stat_sub_type {
 	BLKIO_STAT_TOTAL
 };
 
+/* blkg state flags */
+enum blkg_state_flags {
+	BLKG_waiting = 0,
+	BLKG_idling,
+	BLKG_empty,
+};
+
 struct blkio_cgroup {
 	struct cgroup_subsys_state css;
 	unsigned int weight;
@@ -74,6 +84,21 @@ struct blkio_group_stats {
 	uint64_t avg_queue_size_samples;
 	/* How many times this group has been removed from service tree */
 	unsigned long dequeue;
+
+	/* Total time spent waiting for it to be assigned a timeslice. */
+	uint64_t group_wait_time;
+	uint64_t start_group_wait_time;
+
+	/* Time spent idling for this blkio_group */
+	uint64_t idle_time;
+	uint64_t start_idle_time;
+	/*
+	 * Total time when we have requests queued and do not contain the
+	 * current active queue.
+	 */
+	uint64_t empty_time;
+	uint64_t start_empty_time;
+	uint16_t flags;
 #endif
 };
 
@@ -137,12 +162,41 @@ static inline char *blkg_path(struct blkio_group *blkg)
 void blkiocg_update_set_active_queue_stats(struct blkio_group *blkg);
 void blkiocg_update_dequeue_stats(struct blkio_group *blkg,
 				unsigned long dequeue);
+void blkiocg_update_set_idle_time_stats(struct blkio_group *blkg);
+void blkiocg_update_idle_time_stats(struct blkio_group *blkg);
+void blkiocg_set_start_empty_time(struct blkio_group *blkg, bool ignore);
+
+#define BLKG_FLAG_FNS(name)						\
+static inline void blkio_mark_blkg_##name(				\
+		struct blkio_group_stats *stats)			\
+{									\
+	stats->flags |= (1 << BLKG_##name);				\
+}									\
+static inline void blkio_clear_blkg_##name(				\
+		struct blkio_group_stats *stats)			\
+{									\
+	stats->flags &= ~(1 << BLKG_##name);				\
+}									\
+static inline int blkio_blkg_##name(struct blkio_group_stats *stats)	\
+{									\
+	return (stats->flags & (1 << BLKG_##name)) != 0;		\
+}									\
+
+BLKG_FLAG_FNS(waiting)
+BLKG_FLAG_FNS(idling)
+BLKG_FLAG_FNS(empty)
+#undef BLKG_FLAG_FNS
 #else
 static inline char *blkg_path(struct blkio_group *blkg) { return NULL; }
 static inline void blkiocg_update_set_active_queue_stats(
 						struct blkio_group *blkg) {}
 static inline void blkiocg_update_dequeue_stats(struct blkio_group *blkg,
 						unsigned long dequeue) {}
+static inline void blkiocg_update_set_idle_time_stats(struct blkio_group *blkg)
+{}
+static inline void blkiocg_update_idle_time_stats(struct blkio_group *blkg) {}
+static inline void blkiocg_set_start_empty_time(struct blkio_group *blkg,
+						bool ignore) {}
 #endif
 
 #if defined(CONFIG_BLK_CGROUP) || defined(CONFIG_BLK_CGROUP_MODULE)
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 8e0b86a..b6e095c 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -886,7 +886,7 @@ static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq)
 }
 
 static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
-				struct cfq_queue *cfqq)
+				struct cfq_queue *cfqq, bool forced)
 {
 	struct cfq_rb_root *st = &cfqd->grp_service_tree;
 	unsigned int used_sl, charge_sl;
@@ -916,6 +916,7 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 	cfq_log_cfqg(cfqd, cfqg, "served: vt=%llu min_vt=%llu", cfqg->vdisktime,
 					st->min_vdisktime);
 	blkiocg_update_timeslice_used(&cfqg->blkg, used_sl);
+	blkiocg_set_start_empty_time(&cfqg->blkg, forced);
 }
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
@@ -1528,6 +1529,12 @@ static int cfq_allow_merge(struct request_queue *q, struct request *rq,
 	return cfqq == RQ_CFQQ(rq);
 }
 
+static inline void cfq_del_timer(struct cfq_data *cfqd, struct cfq_queue *cfqq)
+{
+	del_timer(&cfqd->idle_slice_timer);
+	blkiocg_update_idle_time_stats(&cfqq->cfqg->blkg);
+}
+
 static void __cfq_set_active_queue(struct cfq_data *cfqd,
 				   struct cfq_queue *cfqq)
 {
@@ -1547,7 +1554,7 @@ static void __cfq_set_active_queue(struct cfq_data *cfqd,
 		cfq_clear_cfqq_fifo_expire(cfqq);
 		cfq_mark_cfqq_slice_new(cfqq);
 
-		del_timer(&cfqd->idle_slice_timer);
+		cfq_del_timer(cfqd, cfqq);
 	}
 
 	cfqd->active_queue = cfqq;
@@ -1558,12 +1565,12 @@ static void __cfq_set_active_queue(struct cfq_data *cfqd,
  */
 static void
 __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
-		    bool timed_out)
+		    bool timed_out, bool forced)
 {
 	cfq_log_cfqq(cfqd, cfqq, "slice expired t=%d", timed_out);
 
 	if (cfq_cfqq_wait_request(cfqq))
-		del_timer(&cfqd->idle_slice_timer);
+		cfq_del_timer(cfqd, cfqq);
 
 	cfq_clear_cfqq_wait_request(cfqq);
 	cfq_clear_cfqq_wait_busy(cfqq);
@@ -1585,7 +1592,7 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		cfq_log_cfqq(cfqd, cfqq, "resid=%ld", cfqq->slice_resid);
 	}
 
-	cfq_group_served(cfqd, cfqq->cfqg, cfqq);
+	cfq_group_served(cfqd, cfqq->cfqg, cfqq, forced);
 
 	if (cfq_cfqq_on_rr(cfqq) && RB_EMPTY_ROOT(&cfqq->sort_list))
 		cfq_del_cfqq_rr(cfqd, cfqq);
@@ -1604,12 +1611,13 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	}
 }
 
-static inline void cfq_slice_expired(struct cfq_data *cfqd, bool timed_out)
+static inline void cfq_slice_expired(struct cfq_data *cfqd, bool timed_out,
+					bool forced)
 {
 	struct cfq_queue *cfqq = cfqd->active_queue;
 
 	if (cfqq)
-		__cfq_slice_expired(cfqd, cfqq, timed_out);
+		__cfq_slice_expired(cfqd, cfqq, timed_out, forced);
 }
 
 /*
@@ -1865,6 +1873,7 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	sl = cfqd->cfq_slice_idle;
 
 	mod_timer(&cfqd->idle_slice_timer, jiffies + sl);
+	blkiocg_update_set_idle_time_stats(&cfqq->cfqg->blkg);
 	cfq_log_cfqq(cfqd, cfqq, "arm_idle: %lu", sl);
 }
 
@@ -2176,7 +2185,7 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 	}
 
 expire:
-	cfq_slice_expired(cfqd, 0);
+	cfq_slice_expired(cfqd, 0, false);
 new_queue:
 	/*
 	 * Current queue expired. Check if we have to switch to a new
@@ -2202,7 +2211,7 @@ static int __cfq_forced_dispatch_cfqq(struct cfq_queue *cfqq)
 	BUG_ON(!list_empty(&cfqq->fifo));
 
 	/* By default cfqq is not expired if it is empty. Do it explicitly */
-	__cfq_slice_expired(cfqq->cfqd, cfqq, 0);
+	__cfq_slice_expired(cfqq->cfqd, cfqq, 0, true);
 	return dispatched;
 }
 
@@ -2218,7 +2227,7 @@ static int cfq_forced_dispatch(struct cfq_data *cfqd)
 	while ((cfqq = cfq_get_next_queue_forced(cfqd)) != NULL)
 		dispatched += __cfq_forced_dispatch_cfqq(cfqq);
 
-	cfq_slice_expired(cfqd, 0);
+	cfq_slice_expired(cfqd, 0, true);
 	BUG_ON(cfqd->busy_queues);
 
 	cfq_log(cfqd, "forced_dispatch=%d", dispatched);
@@ -2382,10 +2391,15 @@ static int cfq_dispatch_requests(struct request_queue *q, int force)
 	    cfqq->slice_dispatch >= cfq_prio_to_maxrq(cfqd, cfqq)) ||
 	    cfq_class_idle(cfqq))) {
 		cfqq->slice_end = jiffies + 1;
-		cfq_slice_expired(cfqd, 0);
+		cfq_slice_expired(cfqd, 0, false);
 	}
 
 	cfq_log_cfqq(cfqd, cfqq, "dispatched a request");
+	/*
+	 * This is needed since we don't exactly match the mod_timer() and
+	 * del_timer() calls in CFQ.
+	 */
+	blkiocg_update_idle_time_stats(&cfqq->cfqg->blkg);
 	return 1;
 }
 
@@ -2413,7 +2427,7 @@ static void cfq_put_queue(struct cfq_queue *cfqq)
 	orig_cfqg = cfqq->orig_cfqg;
 
 	if (unlikely(cfqd->active_queue == cfqq)) {
-		__cfq_slice_expired(cfqd, cfqq, 0);
+		__cfq_slice_expired(cfqd, cfqq, 0, false);
 		cfq_schedule_dispatch(cfqd);
 	}
 
@@ -2514,7 +2528,7 @@ static void cfq_exit_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	struct cfq_queue *__cfqq, *next;
 
 	if (unlikely(cfqq == cfqd->active_queue)) {
-		__cfq_slice_expired(cfqd, cfqq, 0);
+		__cfq_slice_expired(cfqd, cfqq, 0, false);
 		cfq_schedule_dispatch(cfqd);
 	}
 
@@ -3143,7 +3157,7 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 static void cfq_preempt_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
 	cfq_log_cfqq(cfqd, cfqq, "preempt");
-	cfq_slice_expired(cfqd, 1);
+	cfq_slice_expired(cfqd, 1, false);
 
 	/*
 	 * Put the new queue at the front of the of the current list,
@@ -3191,7 +3205,7 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		if (cfq_cfqq_wait_request(cfqq)) {
 			if (blk_rq_bytes(rq) > PAGE_CACHE_SIZE ||
 			    cfqd->busy_queues > 1) {
-				del_timer(&cfqd->idle_slice_timer);
+				cfq_del_timer(cfqd, cfqq);
 				cfq_clear_cfqq_wait_request(cfqq);
 				__blk_run_queue(cfqd->queue);
 			} else
@@ -3352,7 +3366,7 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 		 * - when there is a close cooperator
 		 */
 		if (cfq_slice_used(cfqq) || cfq_class_idle(cfqq))
-			cfq_slice_expired(cfqd, 1);
+			cfq_slice_expired(cfqd, 1, false);
 		else if (sync && cfqq_empty &&
 			 !cfq_close_cooperator(cfqd, cfqq)) {
 			cfqd->noidle_tree_requires_idle |= !rq_noidle(rq);
@@ -3612,7 +3626,7 @@ static void cfq_idle_slice_timer(unsigned long data)
 		cfq_clear_cfqq_deep(cfqq);
 	}
 expire:
-	cfq_slice_expired(cfqd, timed_out);
+	cfq_slice_expired(cfqd, timed_out, false);
 out_kick:
 	cfq_schedule_dispatch(cfqd);
 out_cont:
@@ -3655,7 +3669,7 @@ static void cfq_exit_queue(struct elevator_queue *e)
 	spin_lock_irq(q->queue_lock);
 
 	if (cfqd->active_queue)
-		__cfq_slice_expired(cfqd, cfqd->active_queue, 0);
+		__cfq_slice_expired(cfqd, cfqd->active_queue, 0, false);
 
 	while (!list_empty(&cfqd->cic_list)) {
 		struct cfq_io_context *cic = list_entry(cfqd->cic_list.next,

