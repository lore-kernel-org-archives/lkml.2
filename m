Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab2BWWbt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 17:31:49 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52037 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756505Ab2BWWbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 17:31:11 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.130.234 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com, akpm@linux-foundation.org,
        hughd@google.com
Cc: avi@redhat.com, nate@cpanel.net, cl@linux-foundation.org,
        linux-kernel@vger.kernel.org, dpshah@google.com, ctalbott@google.com,
        rni@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/8] blkcg: simplify stat reset
Date: Thu, 23 Feb 2012 14:30:44 -0800
Message-Id: <1330036246-21633-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1330036246-21633-1-git-send-email-tj@kernel.org>
References: <1330036246-21633-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blkiocg_reset_stats() implements stat reset for blkio.reset_stats
cgroupfs file.  This feature is very unconventional and something
which shouldn't have been merged.  It's only useful when there's only
one user or tool looking at the stats.  As soon as multiple users
and/or tools are involved, it becomes useless as resetting disrupts
other usages.  There are very good reasons why all other stats expect
readers to read values at the start and end of a period and subtract
to determine delta over the period.

The implementation is rather complex - some fields shouldn't be
cleared and it saves some fields, resets whole and restores for some
reason.  Reset of percpu stats is also racy.  The comment points to
64bit store atomicity for the reason but even without that stores for
zero can simply race with other CPUs doing RMW and get clobbered.

Simplify reset by

* Clear selectively instead of resetting and restoring.

* Grouping debug stat fields to be reset and using memset() over them.

* Not caring about stats_lock.

* Using memset() to reset percpu stats.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c |   80 ++++++++++++++++-----------------------------------
 block/blk-cgroup.h |   14 ++++++++-
 2 files changed, 37 insertions(+), 57 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index ced9acd..614b7b3 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -747,80 +747,50 @@ EXPORT_SYMBOL_GPL(__blkg_release);
 static void blkio_reset_stats_cpu(struct blkio_group *blkg, int plid)
 {
 	struct blkg_policy_data *pd = blkg->pd[plid];
-	struct blkio_group_stats_cpu *stats_cpu;
-	int i, j, k;
-	/*
-	 * Note: On 64 bit arch this should not be an issue. This has the
-	 * possibility of returning some inconsistent value on 32bit arch
-	 * as 64bit update on 32bit is non atomic. Taking care of this
-	 * corner case makes code very complicated, like sending IPIs to
-	 * cpus, taking care of stats of offline cpus etc.
-	 *
-	 * reset stats is anyway more of a debug feature and this sounds a
-	 * corner case. So I am not complicating the code yet until and
-	 * unless this becomes a real issue.
-	 */
-	for_each_possible_cpu(i) {
-		stats_cpu = per_cpu_ptr(pd->stats_cpu, i);
-		stats_cpu->sectors = 0;
-		for(j = 0; j < BLKIO_STAT_CPU_NR; j++)
-			for (k = 0; k < BLKIO_STAT_TOTAL; k++)
-				stats_cpu->stat_arr_cpu[j][k] = 0;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		struct blkio_group_stats_cpu *sc =
+			per_cpu_ptr(pd->stats_cpu, cpu);
+
+		sc->sectors = 0;
+		memset(sc->stat_arr_cpu, 0, sizeof(sc->stat_arr_cpu));
 	}
 }
 
 static int
 blkiocg_reset_stats(struct cgroup *cgroup, struct cftype *cftype, u64 val)
 {
-	struct blkio_cgroup *blkcg;
+	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
 	struct blkio_group *blkg;
-	struct blkio_group_stats *stats;
 	struct hlist_node *n;
-	uint64_t queued[BLKIO_STAT_TOTAL];
 	int i;
-#ifdef CONFIG_DEBUG_BLK_CGROUP
-	bool idling, waiting, empty;
-	unsigned long long now = sched_clock();
-#endif
 
-	blkcg = cgroup_to_blkio_cgroup(cgroup);
 	spin_lock(&blkio_list_lock);
 	spin_lock_irq(&blkcg->lock);
+
+	/*
+	 * Note that stat reset is racy - it doesn't synchronize against
+	 * stat updates.  This is a debug feature which shouldn't exist
+	 * anyway.  If you get hit by a race, retry.
+	 */
 	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
 		struct blkio_policy_type *pol;
 
 		list_for_each_entry(pol, &blkio_list, list) {
 			struct blkg_policy_data *pd = blkg->pd[pol->plid];
-
-			spin_lock(&blkg->stats_lock);
-			stats = &pd->stats;
+			struct blkio_group_stats *stats = &pd->stats;
+
+			/* queued stats shouldn't be cleared */
+			for (i = 0; i < ARRAY_SIZE(stats->stat_arr); i++)
+				if (i != BLKIO_STAT_QUEUED)
+					memset(stats->stat_arr[i], 0,
+					       sizeof(stats->stat_arr[i]));
+			stats->time = 0;
 #ifdef CONFIG_DEBUG_BLK_CGROUP
-			idling = blkio_blkg_idling(stats);
-			waiting = blkio_blkg_waiting(stats);
-			empty = blkio_blkg_empty(stats);
+			memset((void *)stats + BLKG_STATS_DEBUG_CLEAR_START, 0,
+			       BLKG_STATS_DEBUG_CLEAR_SIZE);
 #endif
-			for (i = 0; i < BLKIO_STAT_TOTAL; i++)
-				queued[i] = stats->stat_arr[BLKIO_STAT_QUEUED][i];
-			memset(stats, 0, sizeof(struct blkio_group_stats));
-			for (i = 0; i < BLKIO_STAT_TOTAL; i++)
-				stats->stat_arr[BLKIO_STAT_QUEUED][i] = queued[i];
-#ifdef CONFIG_DEBUG_BLK_CGROUP
-			if (idling) {
-				blkio_mark_blkg_idling(stats);
-				stats->start_idle_time = now;
-			}
-			if (waiting) {
-				blkio_mark_blkg_waiting(stats);
-				stats->start_group_wait_time = now;
-			}
-			if (empty) {
-				blkio_mark_blkg_empty(stats);
-				stats->start_empty_time = now;
-			}
-#endif
-			spin_unlock(&blkg->stats_lock);
-
-			/* Reset Per cpu stats which don't take blkg->stats_lock */
 			blkio_reset_stats_cpu(blkg, pol->plid);
 		}
 	}
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index af6e00a..3937a9e 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -131,21 +131,31 @@ struct blkio_group_stats {
 
 	/* Total time spent waiting for it to be assigned a timeslice. */
 	uint64_t group_wait_time;
-	uint64_t start_group_wait_time;
 
 	/* Time spent idling for this blkio_group */
 	uint64_t idle_time;
-	uint64_t start_idle_time;
 	/*
 	 * Total time when we have requests queued and do not contain the
 	 * current active queue.
 	 */
 	uint64_t empty_time;
+
+	/* fields after this shouldn't be cleared on stat reset */
+	uint64_t start_group_wait_time;
+	uint64_t start_idle_time;
 	uint64_t start_empty_time;
 	uint16_t flags;
 #endif
 };
 
+#ifdef CONFIG_DEBUG_BLK_CGROUP
+#define BLKG_STATS_DEBUG_CLEAR_START	\
+	offsetof(struct blkio_group_stats, unaccounted_time)
+#define BLKG_STATS_DEBUG_CLEAR_SIZE	\
+	(offsetof(struct blkio_group_stats, start_group_wait_time) - \
+	 BLKG_STATS_DEBUG_CLEAR_START)
+#endif
+
 /* Per cpu blkio group stats */
 struct blkio_group_stats_cpu {
 	uint64_t sectors;
-- 
1.7.7.3

