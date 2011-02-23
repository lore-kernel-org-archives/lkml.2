Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab1BWQ40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 11:56:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755134Ab1BWQ4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 11:56:25 -0500
Date: Wed, 23 Feb 2011 17:55:50 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Arthur Marsh <arthur.marsh@internode.on.net>
Cc: Clemens Ladisch <cladisch@googlemail.com>, alsa-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [Alsa-user] new source of MIDI playback slow-down identified -
 5a03b051ed87e72b959f32a86054e1142ac4cf55 thp: use compaction in kswapd for
 GFP_ATOMIC order > 0
Message-ID: <20110223165550.GP31195@random.random>
References: <g0ia38-jj6.ln1@ppp121-45-136-118.lns11.adl6.internode.on.net>
 <4D6367B3.9050306@googlemail.com>
 <20110222134047.GT13092@random.random>
 <20110222161513.GC13092@random.random>
 <4D63F6C0.7060204@internode.on.net>
 <20110223162432.GL31195@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110223162432.GL31195@random.random>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 05:24:32PM +0100, Andrea Arcangeli wrote:
> On Wed, Feb 23, 2011 at 04:17:44AM +1030, Arthur Marsh wrote:
> > OK, these patches applied together against upstream didn't cause a crash 
> > but I did observe:
> > 
> > significant slowdowns of MIDI playback (moreso than in previous cases, 
> > and with less than 20 Meg of swap file in use);
> > 
> > kswapd0 sharing equal top place in CPU usage at times (e.g. 20 percent).
> > 
> > If I should try only one of the patches or something else entirely, 
> > please let me know.
> 
> Yes, with irq off, schedule won't run and need_resched won't get set.
> 
> So let's try this.
> 
> In case this doesn't fix I definitely give it up with compaction in
> kswapd as GFP_ATOMIC will likely not get an huge benefit out of
> compaction anyway because 1) the allocations from GFP_ATOMIC are
> likely short lived, 2) the cost of the compaction scan loop +
> migration may be higher than the benefit we get from jumbo frames
> 
> So if this doesn't fix it, I'll already post a definitive fix that
> removes compaction from kswapd (but leaves it enabled for direct
> reclaim for all order sizes including kernel stack). I already
> verified that this solves not just the midi latency issue but the
> other server benchmark that I'm dealing with. Then we can think at
> compaction+kswapd later for 2.6.39 but I think we need to close this
> kswapd issue in time for 2.6.38. So if the below isn't enough the next
> patch should be applied. I'll get those two patches tested in the
> server load too, and I'll let you know how the results are when it
> finishes.
> 
> Please apply also the attached "kswapd-high-wmark" before the below
> one.
> +		if (need_resched() || spin_is_contended(&zone->lru_lock)) {
> +			if (fatal_signal_pending(current))
> +				break;

this is compaction-kswapd-2, to fix the buglet same as in the other
patch.

In short (to avoid confusion) it'll be helpful if you can test
compaction-kswapd-2 vs compaction-no-kswapd-3 and let us know if both
are ok or if only compaction-no-kswapd-3 is ok. compaction-no-kswapd-3
should help, compaction-kswapd-2 I'm unsure. And as usual I suggest to
apply kswapd-high-wmark (attached to previous emails) _before_
applying both patches.

===
Subject: compaction: fix high latencies created by kswapd

From: Andrea Arcangeli <aarcange@redhat.com>

We need to proper spin_unlock_irq/cond_resched in the compaction loop to avoid
hurting latencies. We must also stop being too aggressive insisting with
compaction within kswapd if compaction don't make progress in every zone.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 include/linux/compaction.h |    6 +++++
 mm/compaction.c            |   53 +++++++++++++++++++++++++++++++++++++--------
 mm/vmscan.c                |   39 +++++++++++++++++++--------------
 3 files changed, 73 insertions(+), 25 deletions(-)

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
@@ -436,6 +454,28 @@ static int compact_finished(struct zone 
 	return COMPACT_CONTINUE;
 }
 
+static unsigned long compaction_watermark(struct zone *zone, int order)
+{
+	/*
+	 * Watermarks for order-0 must be met for compaction. Note the 2UL.
+	 * This is because during migration, copies of pages need to be
+	 * allocated and for a short time, the footprint is higher
+	 */
+	return low_wmark_pages(zone) + (2UL << order);
+}
+
+static int __compaction_need_reclaim(struct zone *zone, int order,
+				     unsigned long watermark)
+{
+	return !zone_watermark_ok(zone, 0, watermark, 0, 0);
+}
+
+int compaction_need_reclaim(struct zone *zone, int order)
+{
+	return __compaction_need_reclaim(zone, order,
+					 compaction_watermark(zone, order));
+}
+
 /*
  * compaction_suitable: Is this suitable to run compaction on this zone now?
  * Returns
@@ -449,21 +489,16 @@ unsigned long compaction_suitable(struct
 	unsigned long watermark;
 
 	/*
-	 * Watermarks for order-0 must be met for compaction. Note the 2UL.
-	 * This is because during migration, copies of pages need to be
-	 * allocated and for a short time, the footprint is higher
-	 */
-	watermark = low_wmark_pages(zone) + (2UL << order);
-	if (!zone_watermark_ok(zone, 0, watermark, 0, 0))
-		return COMPACT_SKIPPED;
-
-	/*
 	 * order == -1 is expected when compacting via
 	 * /proc/sys/vm/compact_memory
 	 */
 	if (order == -1)
 		return COMPACT_CONTINUE;
 
+	watermark = compaction_watermark(zone, order);
+	if (__compaction_need_reclaim(zone, order, watermark))
+		return COMPACT_SKIPPED;
+
 	/*
 	 * fragmentation index determines if allocation failures are due to
 	 * low memory or external fragmentation
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2385,9 +2385,9 @@ loop_again:
 		 * cause too much scanning of the lower zones.
 		 */
 		for (i = 0; i <= end_zone; i++) {
-			int compaction;
 			struct zone *zone = pgdat->node_zones + i;
 			int nr_slab;
+			int local_order;
 
 			if (!populated_zone(zone))
 				continue;
@@ -2407,20 +2407,21 @@ loop_again:
 			 * We put equal pressure on every zone, unless one
 			 * zone has way too many pages free already.
 			 */
-			if (!zone_watermark_ok_safe(zone, order,
-					high_wmark_pages(zone), end_zone, 0))
+			if (!zone_watermark_ok_safe(zone, 0,
+					high_wmark_pages(zone), end_zone, 0) ||
+			    compaction_need_reclaim(zone, order)) {
 				shrink_zone(priority, zone, &sc);
-			reclaim_state->reclaimed_slab = 0;
-			nr_slab = shrink_slab(sc.nr_scanned, GFP_KERNEL,
-						lru_pages);
-			sc.nr_reclaimed += reclaim_state->reclaimed_slab;
-			total_scanned += sc.nr_scanned;
+				reclaim_state->reclaimed_slab = 0;
+				nr_slab = shrink_slab(sc.nr_scanned,
+						      GFP_KERNEL,
+						      lru_pages);
+				sc.nr_reclaimed += reclaim_state->reclaimed_slab;
+				total_scanned += sc.nr_scanned;
+			}
 
-			compaction = 0;
+			local_order = order;
 			if (order &&
-			    zone_watermark_ok(zone, 0,
-					       high_wmark_pages(zone),
-					      end_zone, 0) &&
+			    !compaction_need_reclaim(zone, order) &&
 			    !zone_watermark_ok(zone, order,
 					       high_wmark_pages(zone),
 					       end_zone, 0)) {
@@ -2428,12 +2429,18 @@ loop_again:
 						   order,
 						   sc.gfp_mask, false,
 						   COMPACT_MODE_KSWAPD);
-				compaction = 1;
+				/*
+				 * Let kswapd stop immediately even if
+				 * compaction didn't succeed to
+				 * generate "high_wmark_pages" of the
+				 * max order wanted in every zone.
+				 */
+				local_order = 0;
 			}
 
 			if (zone->all_unreclaimable)
 				continue;
-			if (!compaction && nr_slab == 0 &&
+			if (nr_slab == 0 &&
 			    !zone_reclaimable(zone))
 				zone->all_unreclaimable = 1;
 			/*
@@ -2445,7 +2452,7 @@ loop_again:
 			    total_scanned > sc.nr_reclaimed + sc.nr_reclaimed / 2)
 				sc.may_writepage = 1;
 
-			if (!zone_watermark_ok_safe(zone, order,
+			if (!zone_watermark_ok_safe(zone, local_order,
 					high_wmark_pages(zone), end_zone, 0)) {
 				all_zones_ok = 0;
 				/*
@@ -2453,7 +2460,7 @@ loop_again:
 				 * means that we have a GFP_ATOMIC allocation
 				 * failure risk. Hurry up!
 				 */
-				if (!zone_watermark_ok_safe(zone, order,
+				if (!zone_watermark_ok_safe(zone, local_order,
 					    min_wmark_pages(zone), end_zone, 0))
 					has_under_min_watermark_zone = 1;
 			} else {
--- a/include/linux/compaction.h
+++ b/include/linux/compaction.h
@@ -26,6 +26,7 @@ extern int fragmentation_index(struct zo
 extern unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *mask,
 			bool sync);
+extern int compaction_need_reclaim(struct zone *zone, int order);
 extern unsigned long compaction_suitable(struct zone *zone, int order);
 extern unsigned long compact_zone_order(struct zone *zone, int order,
 					gfp_t gfp_mask, bool sync,
@@ -68,6 +69,11 @@ static inline unsigned long try_to_compa
 	return COMPACT_CONTINUE;
 }
 
+static inline int compaction_need_reclaim(struct zone *zone, int order)
+{
+	return 0;
+}
+
 static inline unsigned long compaction_suitable(struct zone *zone, int order)
 {
 	return COMPACT_SKIPPED;
