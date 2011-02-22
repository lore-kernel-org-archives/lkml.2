Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab1BVQPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 11:15:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665Ab1BVQPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 11:15:50 -0500
Date: Tue, 22 Feb 2011 17:15:13 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Clemens Ladisch <cladisch@googlemail.com>
Cc: Arthur Marsh <arthur.marsh@internode.on.net>,
        alsa-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [Alsa-user] new source of MIDI playback slow-down identified -
 5a03b051ed87e72b959f32a86054e1142ac4cf55 thp: use compaction in kswapd for
 GFP_ATOMIC order > 0
Message-ID: <20110222161513.GC13092@random.random>
References: <g0ia38-jj6.ln1@ppp121-45-136-118.lns11.adl6.internode.on.net>
 <4D6367B3.9050306@googlemail.com>
 <20110222134047.GT13092@random.random>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="uxuisgdDHaNETlh8"
Content-Disposition: inline
In-Reply-To: <20110222134047.GT13092@random.random>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uxuisgdDHaNETlh8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 22, 2011 at 02:40:47PM +0100, Andrea Arcangeli wrote:
>  	spin_lock_irq(&zone->lru_lock);
>  	for (; low_pfn < end_pfn; low_pfn++) {
>  		struct page *page;
> +
> +		cond_resched();
> +

my bad, see the above spin_lock_irq oops...

I attached two replacement patches to apply in order (both of them
should be applied at the same time on top of git upstream, and they
shouldn't lockup this time).

--uxuisgdDHaNETlh8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=kswapd-high_wmark

Subject: vmscan: kswapd must not free more than high_wmark pages

From: Andrea Arcangeli <aarcange@redhat.com>

When the min_free_kbytes is set with `hugeadm
--set-recommended-min_free_kbytes" or with THP enabled (which runs the
equivalent of "hugeadm --set-recommended-min_free_kbytes" to activate
anti-frag at full effectiveness automatically at boot) the high wmark
of some zone is as high as ~88M. 88M free on a 4G system isn't
horrible, but 88M*8 = 704M free on a 4G system is definitely
unbearable. This only tends to be visible on 4G systems with tiny
over-4g zone where kswapd insists to reach the high wmark on the
over-4g zone but doing so it shrunk up to 704M from the normal zone by
mistake.

For the trivial case where kswapd isn't waken until all zones hit the low wmark
and there is no concurrency between allocator and kswapd freeing, rotating more
the tiny above4g lru than "high-low" despite we only allocated "high-low" cache
into it doesn't sound obviously right either. Bigger gap to me looks like will
do more harm than good and if we need a real guarantee of balancing we should
rotate the allocations across the zones (bigger lru in a zone will require it
to be hit more frequently because it'll rotate slower than the other zones, the
bias should not even dependent on the zone size but on the lru size).

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2408,7 +2408,7 @@ loop_again:
 			 * zone has way too many pages free already.
 			 */
 			if (!zone_watermark_ok_safe(zone, order,
-					8*high_wmark_pages(zone), end_zone, 0))
+					high_wmark_pages(zone), end_zone, 0))
 				shrink_zone(priority, zone, &sc);
 			reclaim_state->reclaimed_slab = 0;
 			nr_slab = shrink_slab(sc.nr_scanned, GFP_KERNEL,

--uxuisgdDHaNETlh8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=compaction-kswapd

---
 mm/compaction.c |   19 ++++++++++---------
 mm/vmscan.c     |    8 ++------
 2 files changed, 12 insertions(+), 15 deletions(-)

--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -271,9 +271,19 @@ static unsigned long isolate_migratepage
 	}
 
 	/* Time to isolate some pages for migration */
+	cond_resched();
 	spin_lock_irq(&zone->lru_lock);
 	for (; low_pfn < end_pfn; low_pfn++) {
 		struct page *page;
+
+		if (need_resched() || spin_is_contended(&zone->lru_lock)) {
+			if (fatal_signal_pending(current))
+				break;
+			spin_unlock_irq(&zone->lru_lock);
+			cond_resched();
+			spin_lock_irq(&zone->lru_lock);
+		}
+
 		if (!pfn_valid_within(low_pfn))
 			continue;
 		nr_scanned++;
@@ -413,15 +423,6 @@ static int compact_finished(struct zone 
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
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2385,7 +2385,6 @@ loop_again:
 		 * cause too much scanning of the lower zones.
 		 */
 		for (i = 0; i <= end_zone; i++) {
-			int compaction;
 			struct zone *zone = pgdat->node_zones + i;
 			int nr_slab;
 
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

--uxuisgdDHaNETlh8--
