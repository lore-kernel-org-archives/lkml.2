Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab1BZGoT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 01:44:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376Ab1BZGoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 01:44:17 -0500
Date: Sat, 26 Feb 2011 07:43:39 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Arthur Marsh <arthur.marsh@internode.on.net>
Cc: Clemens Ladisch <cladisch@googlemail.com>, alsa-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [Alsa-user] new source of MIDI playback slow-down identified -
 5a03b051ed87e72b959f32a86054e1142ac4cf55 thp: use compaction in kswapd for
 GFP_ATOMIC order > 0
Message-ID: <20110226064339.GC19630@random.random>
References: <20110222161513.GC13092@random.random>
 <4D63F6C0.7060204@internode.on.net>
 <20110223162432.GL31195@random.random>
 <20110223165550.GP31195@random.random>
 <4D65691E.9080600@internode.on.net>
 <20110223212541.GV31195@random.random>
 <4D65825F.5080403@internode.on.net>
 <20110223235946.GW31195@random.random>
 <4D65B71D.5030109@internode.on.net>
 <20110224015405.GD31195@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110224015405.GD31195@random.random>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 02:54:05AM +0100, Andrea Arcangeli wrote:
> Ok so tomorrow I'll get all results on these 3 kernels (
> compaction-kswapd-3+compaction_alloc_lowlat-2 vs
> compaction-no-kswapd-3+compaction_alloc_lowlat-2 vs
> compaction_alloc_lowlat2) on network server load, where throughout is
> measured in addition to latency. Then we'll have a better picture to

Latency is still lowest with compaction-no-kswapd-3. compaction_alloc
still is at the top of the profiling with
compaction-kswapd-3+compaction_alloc_lowlat-2. However
compaction-kswapd-3 reduced the overhead somewhat but not enough to be
as fast as with compaction-no-kswapd-3 (even if much better than
before).

So we should apply compaction-no-kswapd-3 to 2.6.38 I think.

====
Subject: compaction: fix high compaction latencies and remove compaction-kswapd

From: Andrea Arcangeli <aarcange@redhat.com>

It's safer to stop calling compaction from kswapd as that creates too
high load during memory pressure that can't be offseted by the
improved performance of compound allocations. NOTE: this is not
related to THP (THP allocations uses __GFP_NO_KSWAPD), this is only
related to frequent and small order allocations that make kswapd go
wild with compaction.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---

--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -405,10 +423,7 @@ static int compact_finished(struct zone 
 		return COMPACT_COMPLETE;
 
 	/* Compaction run is not finished if the watermark is not met */
-	if (cc->compact_mode != COMPACT_MODE_KSWAPD)
-		watermark = low_wmark_pages(zone);
-	else
-		watermark = high_wmark_pages(zone);
+	watermark = low_wmark_pages(zone);
 	watermark += (1 << cc->order);
 
 	if (!zone_watermark_ok(zone, cc->order, watermark, 0, 0))
@@ -421,15 +436,6 @@ static int compact_finished(struct zone 
 	if (cc->order == -1)
 		return COMPACT_CONTINUE;
 
-	/*
-	 * Generating only one page of the right order is not enough
-	 * for kswapd, we must continue until we're above the high
-	 * watermark as a pool for high order GFP_ATOMIC allocations
-	 * too.
-	 */
-	if (cc->compact_mode == COMPACT_MODE_KSWAPD)
-		return COMPACT_CONTINUE;
-
 	/* Direct compactor: Is a suitable page free? */
 	for (order = cc->order; order < MAX_ORDER; order++) {
 		/* Job done if page is free of the right migratetype */
@@ -551,8 +557,7 @@ static int compact_zone(struct zone *zon
 
 unsigned long compact_zone_order(struct zone *zone,
 				 int order, gfp_t gfp_mask,
-				 bool sync,
-				 int compact_mode)
+				 bool sync)
 {
 	struct compact_control cc = {
 		.nr_freepages = 0,
@@ -561,7 +566,6 @@ unsigned long compact_zone_order(struct 
 		.migratetype = allocflags_to_migratetype(gfp_mask),
 		.zone = zone,
 		.sync = sync,
-		.compact_mode = compact_mode,
 	};
 	INIT_LIST_HEAD(&cc.freepages);
 	INIT_LIST_HEAD(&cc.migratepages);
@@ -607,8 +611,7 @@ unsigned long try_to_compact_pages(struc
 								nodemask) {
 		int status;
 
-		status = compact_zone_order(zone, order, gfp_mask, sync,
-					    COMPACT_MODE_DIRECT_RECLAIM);
+		status = compact_zone_order(zone, order, gfp_mask, sync);
 		rc = max(status, rc);
 
 		/* If a normal allocation would succeed, stop compacting */
@@ -639,7 +642,6 @@ static int compact_node(int nid)
 			.nr_freepages = 0,
 			.nr_migratepages = 0,
 			.order = -1,
-			.compact_mode = COMPACT_MODE_DIRECT_RECLAIM,
 		};
 
 		zone = &pgdat->node_zones[zoneid];
--- a/include/linux/compaction.h
+++ b/include/linux/compaction.h
@@ -11,9 +11,6 @@
 /* The full zone was compacted */
 #define COMPACT_COMPLETE	3
 
-#define COMPACT_MODE_DIRECT_RECLAIM	0
-#define COMPACT_MODE_KSWAPD		1
-
 #ifdef CONFIG_COMPACTION
 extern int sysctl_compact_memory;
 extern int sysctl_compaction_handler(struct ctl_table *table, int write,
@@ -28,8 +25,7 @@ extern unsigned long try_to_compact_page
 			bool sync);
 extern unsigned long compaction_suitable(struct zone *zone, int order);
 extern unsigned long compact_zone_order(struct zone *zone, int order,
-					gfp_t gfp_mask, bool sync,
-					int compact_mode);
+					gfp_t gfp_mask, bool sync);
 
 /* Do not skip compaction more than 64 times */
 #define COMPACT_MAX_DEFER_SHIFT 6
@@ -74,8 +70,7 @@ static inline unsigned long compaction_s
 }
 
 static inline unsigned long compact_zone_order(struct zone *zone, int order,
-					       gfp_t gfp_mask, bool sync,
-					       int compact_mode)
+					       gfp_t gfp_mask, bool sync)
 {
 	return COMPACT_CONTINUE;
 }
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2385,7 +2385,6 @@ loop_again:
 		 * cause too much scanning of the lower zones.
 		 */
 		for (i = 0; i <= end_zone; i++) {
-			int compaction;
 			struct zone *zone = pgdat->node_zones + i;
 			int nr_slab;
 			unsigned long balance_gap;
@@ -2426,24 +2425,9 @@ loop_again:
 			sc.nr_reclaimed += reclaim_state->reclaimed_slab;
 			total_scanned += sc.nr_scanned;
 
-			compaction = 0;
-			if (order &&
-			    zone_watermark_ok(zone, 0,
-					       high_wmark_pages(zone),
-					      end_zone, 0) &&
-			    !zone_watermark_ok(zone, order,
-					       high_wmark_pages(zone),
-					       end_zone, 0)) {
-				compact_zone_order(zone,
-						   order,
-						   sc.gfp_mask, false,
-						   COMPACT_MODE_KSWAPD);
-				compaction = 1;
-			}
-
 			if (zone->all_unreclaimable)
 				continue;
-			if (!compaction && nr_slab == 0 &&
+			if (nr_slab == 0 &&
 			    !zone_reclaimable(zone))
 				zone->all_unreclaimable = 1;
 			/*
