Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab1ABHYZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:24:25 -0500
Received: from mail.windriver.com ([147.11.1.11]:36286 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab1ABHYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:22 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Christoph Lameter <cl@linux.com>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 147/260] mm: page allocator: calculate a better estimate of NR_FREE_PAGES when memory is low and kswapd is awake
Date: Sun,  2 Jan 2011 02:17:23 -0500
Message-Id: <1293952756-15010-148-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:51.0540 (UTC) FILETIME=[DD7DBD40:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <cl@linux.com>

commit aa45484031ddee09b06350ab8528bfe5b2c76d1c upstream.

Ordinarily watermark checks are based on the vmstat NR_FREE_PAGES as it is
cheaper than scanning a number of lists.  To avoid synchronization
overhead, counter deltas are maintained on a per-cpu basis and drained
both periodically and when the delta is above a threshold.  On large CPU
systems, the difference between the estimated and real value of
NR_FREE_PAGES can be very high.  If NR_FREE_PAGES is much higher than
number of real free page in buddy, the VM can allocate pages below min
watermark, at worst reducing the real number of pages to zero.  Even if
the OOM killer kills some victim for freeing memory, it may not free
memory if the exit path requires a new page resulting in livelock.

This patch introduces a zone_page_state_snapshot() function (courtesy of
Christoph) that takes a slightly more accurate view of an arbitrary vmstat
counter.  It is used to read NR_FREE_PAGES while kswapd is awake to avoid
the watermark being accidentally broken.  The estimate is not perfect and
may result in cache line bounces but is expected to be lighter than the
IPI calls necessary to continually drain the per-cpu counters while kswapd
is awake.

Signed-off-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/mmzone.h |   13 +++++++++++++
 include/linux/vmstat.h |   22 ++++++++++++++++++++++
 mm/mmzone.c            |   21 +++++++++++++++++++++
 mm/page_alloc.c        |    4 ++--
 mm/vmstat.c            |   15 ++++++++++++++-
 5 files changed, 72 insertions(+), 3 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index cf9e458..468e9fb 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -284,6 +284,13 @@ struct zone {
 	unsigned long watermark[NR_WMARK];
 
 	/*
+	 * When free pages are below this point, additional steps are taken
+	 * when reading the number of free pages to avoid per-cpu counter
+	 * drift allowing watermarks to be breached
+	 */
+	unsigned long percpu_drift_mark;
+
+	/*
 	 * We don't know if the memory that we're going to allocate will be freeable
 	 * or/and it will be released eventually, so to avoid totally wasting several
 	 * GB of ram we must reserve some of the lower zone memory (otherwise we risk
@@ -447,6 +454,12 @@ static inline int zone_is_oom_locked(const struct zone *zone)
 	return test_bit(ZONE_OOM_LOCKED, &zone->flags);
 }
 
+#ifdef CONFIG_SMP
+unsigned long zone_nr_free_pages(struct zone *zone);
+#else
+#define zone_nr_free_pages(zone) zone_page_state(zone, NR_FREE_PAGES)
+#endif /* CONFIG_SMP */
+
 /*
  * The "priority" of VM scanning is how much of the queues we will scan in one
  * go. A value of 12 for DEF_PRIORITY implies that we will scan 1/4096th of the
diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 117f0dd..5c9c132 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -166,6 +166,28 @@ static inline unsigned long zone_page_state(struct zone *zone,
 	return x;
 }
 
+/*
+ * More accurate version that also considers the currently pending
+ * deltas. For that we need to loop over all cpus to find the current
+ * deltas. There is no synchronization so the result cannot be
+ * exactly accurate either.
+ */
+static inline unsigned long zone_page_state_snapshot(struct zone *zone,
+					enum zone_stat_item item)
+{
+	long x = atomic_long_read(&zone->vm_stat[item]);
+
+#ifdef CONFIG_SMP
+	int cpu;
+	for_each_online_cpu(cpu)
+		x += per_cpu_ptr(zone->pageset, cpu)->vm_stat_diff[item];
+
+	if (x < 0)
+		x = 0;
+#endif
+	return x;
+}
+
 extern unsigned long global_reclaimable_pages(void);
 extern unsigned long zone_reclaimable_pages(struct zone *zone);
 
diff --git a/mm/mmzone.c b/mm/mmzone.c
index f5b7d17..e35bfb8 100644
--- a/mm/mmzone.c
+++ b/mm/mmzone.c
@@ -87,3 +87,24 @@ int memmap_valid_within(unsigned long pfn,
 	return 1;
 }
 #endif /* CONFIG_ARCH_HAS_HOLES_MEMORYMODEL */
+
+#ifdef CONFIG_SMP
+/* Called when a more accurate view of NR_FREE_PAGES is needed */
+unsigned long zone_nr_free_pages(struct zone *zone)
+{
+	unsigned long nr_free_pages = zone_page_state(zone, NR_FREE_PAGES);
+
+	/*
+	 * While kswapd is awake, it is considered the zone is under some
+	 * memory pressure. Under pressure, there is a risk that
+	 * per-cpu-counter-drift will allow the min watermark to be breached
+	 * potentially causing a live-lock. While kswapd is awake and
+	 * free pages are low, get a better estimate for free pages
+	 */
+	if (nr_free_pages < zone->percpu_drift_mark &&
+			!waitqueue_active(&zone->zone_pgdat->kswapd_wait))
+		return zone_page_state_snapshot(zone, NR_FREE_PAGES);
+
+	return nr_free_pages;
+}
+#endif /* CONFIG_SMP */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a2af9bc..0de096a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1377,7 +1377,7 @@ int zone_watermark_ok(struct zone *z, int order, unsigned long mark,
 {
 	/* free_pages my go negative - that's OK */
 	long min = mark;
-	long free_pages = zone_page_state(z, NR_FREE_PAGES) - (1 << order) + 1;
+	long free_pages = zone_nr_free_pages(z) - (1 << order) + 1;
 	int o;
 
 	if (alloc_flags & ALLOC_HIGH)
@@ -2271,7 +2271,7 @@ void show_free_areas(void)
 			" all_unreclaimable? %s"
 			"\n",
 			zone->name,
-			K(zone_page_state(zone, NR_FREE_PAGES)),
+			K(zone_nr_free_pages(zone)),
 			K(min_wmark_pages(zone)),
 			K(low_wmark_pages(zone)),
 			K(high_wmark_pages(zone)),
diff --git a/mm/vmstat.c b/mm/vmstat.c
index fa12ea3..97f64e4 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -137,11 +137,24 @@ static void refresh_zone_stat_thresholds(void)
 	int threshold;
 
 	for_each_populated_zone(zone) {
+		unsigned long max_drift, tolerate_drift;
+
 		threshold = calculate_threshold(zone);
 
 		for_each_online_cpu(cpu)
 			per_cpu_ptr(zone->pageset, cpu)->stat_threshold
 							= threshold;
+
+		/*
+		 * Only set percpu_drift_mark if there is a danger that
+		 * NR_FREE_PAGES reports the low watermark is ok when in fact
+		 * the min watermark could be breached by an allocation
+		 */
+		tolerate_drift = low_wmark_pages(zone) - min_wmark_pages(zone);
+		max_drift = num_online_cpus() * threshold;
+		if (max_drift > tolerate_drift)
+			zone->percpu_drift_mark = high_wmark_pages(zone) +
+					max_drift;
 	}
 }
 
@@ -721,7 +734,7 @@ static void zoneinfo_show_print(struct seq_file *m, pg_data_t *pgdat,
 		   "\n        scanned  %lu"
 		   "\n        spanned  %lu"
 		   "\n        present  %lu",
-		   zone_page_state(zone, NR_FREE_PAGES),
+		   zone_nr_free_pages(zone),
 		   min_wmark_pages(zone),
 		   low_wmark_pages(zone),
 		   high_wmark_pages(zone),
-- 
1.7.3.3

