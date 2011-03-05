Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610Ab1CEBEr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:04:47 -0500
Received: from kroah.org ([198.145.64.141]:50421 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760530Ab1CEBAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:46 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:40 2011
Message-Id: <20110305005639.949655756@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:56:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [55/73] mm: vmstat: use a single setter function and callback for adjusting percpu thresholds
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mel Gorman <mel@csn.ul.ie>

commit b44129b30652c8771db2265939bb8b463724043d upstream.

reduce_pgdat_percpu_threshold() and restore_pgdat_percpu_threshold() exist
to adjust the per-cpu vmstat thresholds while kswapd is awake to avoid
errors due to counter drift.  The functions duplicate some code so this
patch replaces them with a single set_pgdat_percpu_threshold() that takes
a callback function to calculate the desired threshold as a parameter.

[akpm@linux-foundation.org: readability tweak]
[kosaki.motohiro@jp.fujitsu.com: set_pgdat_percpu_threshold(): don't use for_each_online_cpu]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Christoph Lameter <cl@linux.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/vmstat.h |   10 ++++++----
 mm/vmscan.c            |   19 +++++++++++++++++--
 mm/vmstat.c            |   36 +++++++-----------------------------
 3 files changed, 30 insertions(+), 35 deletions(-)

--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -254,8 +254,11 @@ extern void dec_zone_state(struct zone *
 extern void __dec_zone_state(struct zone *, enum zone_stat_item);
 
 void refresh_cpu_vm_stats(int);
-void reduce_pgdat_percpu_threshold(pg_data_t *pgdat);
-void restore_pgdat_percpu_threshold(pg_data_t *pgdat);
+
+int calculate_pressure_threshold(struct zone *zone);
+int calculate_normal_threshold(struct zone *zone);
+void set_pgdat_percpu_threshold(pg_data_t *pgdat,
+				int (*calculate_pressure)(struct zone *));
 #else /* CONFIG_SMP */
 
 /*
@@ -300,8 +303,7 @@ static inline void __dec_zone_page_state
 #define dec_zone_page_state __dec_zone_page_state
 #define mod_zone_page_state __mod_zone_page_state
 
-static inline void reduce_pgdat_percpu_threshold(pg_data_t *pgdat) { }
-static inline void restore_pgdat_percpu_threshold(pg_data_t *pgdat) { }
+#define set_pgdat_percpu_threshold(pgdat, callback) { }
 
 static inline void refresh_cpu_vm_stats(int cpu) { }
 #endif
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2448,9 +2448,24 @@ static int kswapd(void *p)
 				 */
 				if (!sleeping_prematurely(pgdat, order, remaining)) {
 					trace_mm_vmscan_kswapd_sleep(pgdat->node_id);
-					restore_pgdat_percpu_threshold(pgdat);
+
+					/*
+					 * vmstat counters are not perfectly
+					 * accurate and the estimated value
+					 * for counters such as NR_FREE_PAGES
+					 * can deviate from the true value by
+					 * nr_online_cpus * threshold. To
+					 * avoid the zone watermarks being
+					 * breached while under pressure, we
+					 * reduce the per-cpu vmstat threshold
+					 * while kswapd is awake and restore
+					 * them before going back to sleep.
+					 */
+					set_pgdat_percpu_threshold(pgdat,
+						calculate_normal_threshold);
 					schedule();
-					reduce_pgdat_percpu_threshold(pgdat);
+					set_pgdat_percpu_threshold(pgdat,
+						calculate_pressure_threshold);
 				} else {
 					if (remaining)
 						count_vm_event(KSWAPD_LOW_WMARK_HIT_QUICKLY);
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -83,7 +83,7 @@ EXPORT_SYMBOL(vm_stat);
 
 #ifdef CONFIG_SMP
 
-static int calculate_pressure_threshold(struct zone *zone)
+int calculate_pressure_threshold(struct zone *zone)
 {
 	int threshold;
 	int watermark_distance;
@@ -107,7 +107,7 @@ static int calculate_pressure_threshold(
 	return threshold;
 }
 
-static int calculate_threshold(struct zone *zone)
+int calculate_normal_threshold(struct zone *zone)
 {
 	int threshold;
 	int mem;	/* memory in 128 MB units */
@@ -166,7 +166,7 @@ static void refresh_zone_stat_thresholds
 	for_each_populated_zone(zone) {
 		unsigned long max_drift, tolerate_drift;
 
-		threshold = calculate_threshold(zone);
+		threshold = calculate_normal_threshold(zone);
 
 		for_each_online_cpu(cpu)
 			per_cpu_ptr(zone->pageset, cpu)->stat_threshold
@@ -185,46 +185,24 @@ static void refresh_zone_stat_thresholds
 	}
 }
 
-void reduce_pgdat_percpu_threshold(pg_data_t *pgdat)
+void set_pgdat_percpu_threshold(pg_data_t *pgdat,
+				int (*calculate_pressure)(struct zone *))
 {
 	struct zone *zone;
 	int cpu;
 	int threshold;
 	int i;
 
-	get_online_cpus();
 	for (i = 0; i < pgdat->nr_zones; i++) {
 		zone = &pgdat->node_zones[i];
 		if (!zone->percpu_drift_mark)
 			continue;
 
-		threshold = calculate_pressure_threshold(zone);
-		for_each_online_cpu(cpu)
-			per_cpu_ptr(zone->pageset, cpu)->stat_threshold
-							= threshold;
-	}
-	put_online_cpus();
-}
-
-void restore_pgdat_percpu_threshold(pg_data_t *pgdat)
-{
-	struct zone *zone;
-	int cpu;
-	int threshold;
-	int i;
-
-	get_online_cpus();
-	for (i = 0; i < pgdat->nr_zones; i++) {
-		zone = &pgdat->node_zones[i];
-		if (!zone->percpu_drift_mark)
-			continue;
-
-		threshold = calculate_threshold(zone);
-		for_each_online_cpu(cpu)
+		threshold = (*calculate_pressure)(zone);
+		for_each_possible_cpu(cpu)
 			per_cpu_ptr(zone->pageset, cpu)->stat_threshold
 							= threshold;
 	}
-	put_online_cpus();
 }
 
 /*


