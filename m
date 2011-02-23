Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab1BWQki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 11:40:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755018Ab1BWQkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 11:40:37 -0500
Date: Wed, 23 Feb 2011 17:40:01 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Arthur Marsh <arthur.marsh@internode.on.net>
Cc: Clemens Ladisch <cladisch@googlemail.com>, alsa-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [Alsa-user] new source of MIDI playback slow-down identified -
 5a03b051ed87e72b959f32a86054e1142ac4cf55 thp: use compaction in kswapd for
 GFP_ATOMIC order > 0
Message-ID: <20110223164001.GN31195@random.random>
References: <g0ia38-jj6.ln1@ppp121-45-136-118.lns11.adl6.internode.on.net>
 <4D6367B3.9050306@googlemail.com>
 <20110222134047.GT13092@random.random>
 <20110222161513.GC13092@random.random>
 <4D63F6C0.7060204@internode.on.net>
 <20110223162432.GL31195@random.random>
 <20110223163639.GM31195@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110223163639.GM31195@random.random>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 05:36:39PM +0100, Andrea Arcangeli wrote:
> +		if (need_resched() || spin_is_contended(&zone->lru_lock)) {
> +			if (fatal_signal_pending(current))
> +				break;

I noticed a buglet in this break... need to repost sorry. compaction-no-kswapd-2.

===
Subject: compaction: fix high compaction latencies and remove compaction-kswapd

From: Andrea Arcangeli <aarcange@redhat.com>

We need to proper spin_unlock_irq/cond_resched in the compaction loop to avoid
hurting latencies. We must also stop calling compaction from kswapd as that
creates too high load during memory pressure that can't be offseted by the
improved performance of hugepage allocations. NOTE: this is not related to THP
as all THP allocations uses __GFP_NO_KSWAPD, this is only related to usually
small order allocations like the kernel stack that make kswapd go wild with
compaction.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 mm/compaction.c |   40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -271,9 +271,27 @@ static unsigned long isolate_migratepage
 	}
 
 	/* Time to isolate some pages for migration */
+	cond_resched();
 	spin_lock_irq(&zone->lru_lock);
 	for (; low_pfn < end_pfn; low_pfn++) {
 		struct page *page;
+		int unlocked = 0;
+
+		/* give a chance to irqs before checking need_resched() */
+		if (!((low_pfn+1) % SWAP_CLUSTER_MAX)) {
+			spin_unlock_irq(&zone->lru_lock);
+			unlocked = 1;
+		}
+		if (need_resched() || spin_is_contended(&zone->lru_lock)) {
+			if (!unlocked)
+				spin_unlock_irq(&zone->lru_lock);
+			cond_resched();
+			spin_lock_irq(&zone->lru_lock);
+			if (fatal_signal_pending(current))
+				break;
+		} else if (unlocked)
+			spin_lock_irq(&zone->lru_lock);
+
 		if (!pfn_valid_within(low_pfn))
 			continue;
 		nr_scanned++;
@@ -397,10 +415,7 @@ static int compact_finished(struct zone 
 		return COMPACT_COMPLETE;
 
 	/* Compaction run is not finished if the watermark is not met */
-	if (cc->compact_mode != COMPACT_MODE_KSWAPD)
-		watermark = low_wmark_pages(zone);
-	else
-		watermark = high_wmark_pages(zone);
+	watermark = low_wmark_pages(zone);
 	watermark += (1 << cc->order);
 
 	if (!zone_watermark_ok(zone, cc->order, watermark, 0, 0))
@@ -413,15 +428,6 @@ static int compact_finished(struct zone 
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
@@ -543,8 +549,7 @@ static int compact_zone(struct zone *zon
 
 unsigned long compact_zone_order(struct zone *zone,
 				 int order, gfp_t gfp_mask,
-				 bool sync,
-				 int compact_mode)
+				 bool sync)
 {
 	struct compact_control cc = {
 		.nr_freepages = 0,
@@ -553,7 +558,6 @@ unsigned long compact_zone_order(struct 
 		.migratetype = allocflags_to_migratetype(gfp_mask),
 		.zone = zone,
 		.sync = sync,
-		.compact_mode = compact_mode,
 	};
 	INIT_LIST_HEAD(&cc.freepages);
 	INIT_LIST_HEAD(&cc.migratepages);
@@ -599,8 +603,7 @@ unsigned long try_to_compact_pages(struc
 								nodemask) {
 		int status;
 
-		status = compact_zone_order(zone, order, gfp_mask, sync,
-					    COMPACT_MODE_DIRECT_RECLAIM);
+		status = compact_zone_order(zone, order, gfp_mask, sync);
 		rc = max(status, rc);
 
 		/* If a normal allocation would succeed, stop compacting */
@@ -631,7 +634,6 @@ static int compact_node(int nid)
 			.nr_freepages = 0,
 			.nr_migratepages = 0,
 			.order = -1,
-			.compact_mode = COMPACT_MODE_DIRECT_RECLAIM,
 		};
 
 		zone = &pgdat->node_zones[zoneid];
