Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab1BVNlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 08:41:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437Ab1BVNlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 08:41:05 -0500
Date: Tue, 22 Feb 2011 14:40:47 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Clemens Ladisch <cladisch@googlemail.com>
Cc: Arthur Marsh <arthur.marsh@internode.on.net>,
        alsa-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [Alsa-user] new source of MIDI playback slow-down identified -
 5a03b051ed87e72b959f32a86054e1142ac4cf55 thp: use compaction in kswapd for
 GFP_ATOMIC order > 0
Message-ID: <20110222134047.GT13092@random.random>
References: <g0ia38-jj6.ln1@ppp121-45-136-118.lns11.adl6.internode.on.net>
 <4D6367B3.9050306@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6367B3.9050306@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 08:37:23AM +0100, Clemens Ladisch wrote:
> Arthur Marsh wrote:
> > I'm experiencing MIDI playback slow-downs when I'm observing kswapd0 
> > active (a few percent of cpu in top output) in recent kernels.
> > 
> > I git-bisected the problem down to:
> > 
> > commit 5a03b051ed87e72b959f32a86054e1142ac4cf55
> > Author: Andrea Arcangeli <aarcange@redhat.com>
> > Date:   Thu Jan 13 15:47:11 2011 -0800
> > 
> >      thp: use compaction in kswapd for GFP_ATOMIC order > 0
> > 
> >      This takes advantage of memory compaction to properly generate pages of
> >      order > 0 if regular page reclaim fails and priority level becomes more
> >      severe and we don't reach the proper watermarks.
> > 
> >      Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> >      Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >      Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > 
> > I ran git-bisect over the weekend, building and installing ALSA 1.0.24 
> > with each kernel. After identifying the above commit, I rebuilt the 2.6 
> > head with that commit reverted and verified that the problem was no 
> > longer present.
> 
> Apparently, huge page compaction disables interrupts for much too long.
> 
> > MIDI playback was via aplaymidi -p 17:0 to a Soundblaster Audigy 2 ZS 
> > (SB0350) wavetable.
> 
> The ALSA sequencer uses either the system timer or an HR timer at 1 kHz
> to deliver MIDI commands (notes); the wavetable driver requires its own
> interrupts in regular 5.3 ms intervals.

I asked Arthur to test this fix. We already know the attached z1 patch
fixed the problem 100%. But that was a debugging patch not meant for
merging, if the below works, I think we're done. This is the same
approach I'm also going to test in another benchmark that also showed
increased latencies that isn't related to multimedia or midi but pure nfs
load with jumbo frames. The problem is the same!

The below is untested, please let me know if it helps, because it may
not be enough.

=========
Subject: compaction: fix high latencies created by kswapd

From: Andrea Arcangeli <aarcange@redhat.com>

We need to cond_resched in the compaction loop to avoid hurting
latencies and stop being too aggressive in kswapd, and let it go in
all unreclaimable if needed (not order aware logic but it's not worth
being too aggressive with expensive compaction).

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---


diff --git a/mm/compaction.c b/mm/compaction.c
index 8be430b..fef06c4 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -274,6 +274,9 @@ static unsigned long isolate_migratepages(struct zone *zone,
 	spin_lock_irq(&zone->lru_lock);
 	for (; low_pfn < end_pfn; low_pfn++) {
 		struct page *page;
+
+		cond_resched();
+
 		if (!pfn_valid_within(low_pfn))
 			continue;
 		nr_scanned++;
@@ -413,15 +416,6 @@ static int compact_finished(struct zone *zone,
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
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 17497d0..564771c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2385,7 +2385,6 @@ loop_again:
 		 * cause too much scanning of the lower zones.
 		 */
 		for (i = 0; i <= end_zone; i++) {
-			int compaction;
 			struct zone *zone = pgdat->node_zones + i;
 			int nr_slab;
 
@@ -2408,7 +2407,7 @@ loop_again:
 			 * zone has way too many pages free already.
 			 */
 			if (!zone_watermark_ok_safe(zone, order,
-					8*high_wmark_pages(zone), end_zone, 0))
+					high_wmark_pages(zone), end_zone, 0))
 				shrink_zone(priority, zone, &sc);
 			reclaim_state->reclaimed_slab = 0;
 			nr_slab = shrink_slab(sc.nr_scanned, GFP_KERNEL,
@@ -2416,24 +2415,21 @@ loop_again:
 			sc.nr_reclaimed += reclaim_state->reclaimed_slab;
 			total_scanned += sc.nr_scanned;
 
-			compaction = 0;
 			if (order &&
 			    zone_watermark_ok(zone, 0,
 					       high_wmark_pages(zone),
 					      end_zone, 0) &&
 			    !zone_watermark_ok(zone, order,
 					       high_wmark_pages(zone),
-					       end_zone, 0)) {
+					       end_zone, 0))
 				compact_zone_order(zone,
 						   order,
 						   sc.gfp_mask, false,
 						   COMPACT_MODE_KSWAPD);
-				compaction = 1;
-			}
 
 			if (zone->all_unreclaimable)
 				continue;
-			if (!compaction && nr_slab == 0 &&
+			if (nr_slab == 0 &&
 			    !zone_reclaimable(zone))
 				zone->all_unreclaimable = 1;
 			/*
