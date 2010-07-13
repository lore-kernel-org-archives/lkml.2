Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab0GMJc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 05:32:27 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51357 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab0GMJcZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 05:32:25 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH v2 1/2] vmscan: don't subtraction of unsined
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <20100709152851.330bf2b2.akpm@linux-foundation.org>
References: <20100709090956.CD51.A69D9226@jp.fujitsu.com> <20100709152851.330bf2b2.akpm@linux-foundation.org>
Message-Id: <20100713182918.EA67.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 13 Jul 2010 18:32:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri,  9 Jul 2010 10:16:33 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -2588,7 +2588,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
> >  		.swappiness = vm_swappiness,
> >  		.order = order,
> >  	};
> > -	unsigned long slab_reclaimable;
> > +	unsigned long nr_slab_pages0, nr_slab_pages1;
> >  
> >  	disable_swap_token();
> >  	cond_resched();
> > @@ -2615,8 +2615,8 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
> >  		} while (priority >= 0 && sc.nr_reclaimed < nr_pages);
> >  	}
> >  
> > -	slab_reclaimable = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
> > -	if (slab_reclaimable > zone->min_slab_pages) {
> > +	nr_slab_pages0 = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
> > +	if (nr_slab_pages0 > zone->min_slab_pages) {
> >  		/*
> >  		 * shrink_slab() does not currently allow us to determine how
> >  		 * many pages were freed in this zone.
> 
> Well no, but it could do so, with some minor changes to struct
> reclaim_state and its handling.  Put a zone* and a counter in
> reclaim_state, handle them in sl?b.c.
> 
> > So we take the current
> > @@ -2628,16 +2628,17 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
> >  		 * take a long time.
> >  		 */
> >  		while (shrink_slab(sc.nr_scanned, gfp_mask, order) &&
> > -			zone_page_state(zone, NR_SLAB_RECLAIMABLE) >
> > -				slab_reclaimable - nr_pages)
> > +		       (zone_page_state(zone, NR_SLAB_RECLAIMABLE) + nr_pages >
> > +				nr_slab_pages0))
> >  			;
> >  
> >  		/*
> >  		 * Update nr_reclaimed by the number of slab pages we
> >  		 * reclaimed from this zone.
> >  		 */
> > -		sc.nr_reclaimed += slab_reclaimable -
> > -			zone_page_state(zone, NR_SLAB_RECLAIMABLE);
> > +		nr_slab_pages1 = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
> > +		if (nr_slab_pages1 < nr_slab_pages0)
> > +			sc.nr_reclaimed += nr_slab_pages0 - nr_slab_pages1;
> 
> My, that's horrible.  The whole expression says "this number is
> basically a pile of random junk.  Let's add it in anyway".
> 
> 
> >  	}
> >  
> >  	p->reclaim_state = NULL;


How's this?

Christoph, Can we hear your opinion about to add new branch in slab-free path?
I think this is ok, because reclaim makes a lot of cache miss then branch
mistaken is relatively minor penalty. thought?



>From 9f7d7a9bd836b7373ade3056e6a3d2a3d82ac7ce Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Tue, 13 Jul 2010 14:43:21 +0900
Subject: [PATCH] vmscan: count reclaimed slab pages properly

Andrew Morton pointed out __zone_reclaim() shouldn't compare old and new
zone_page_state(NR_SLAB_RECLAIMABLE) result. Instead, it have to account
number of free slab pages by to enhance reclaim_state.

This patch does it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/swap.h |    3 ++-
 mm/slab.c            |    4 +++-
 mm/slob.c            |    4 +++-
 mm/slub.c            |    7 +++++--
 mm/vmscan.c          |   44 ++++++++++++++++----------------------------
 5 files changed, 29 insertions(+), 33 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index ff4acea..b8d3f33 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -107,7 +107,8 @@ typedef struct {
  * memory reclaim
  */
 struct reclaim_state {
-	unsigned long reclaimed_slab;
+	unsigned long	reclaimed_slab;
+	struct zone	*zone;
 };
 
 #ifdef __KERNEL__
diff --git a/mm/slab.c b/mm/slab.c
index 4e9c46f..aac9306 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1741,7 +1741,9 @@ static void kmem_freepages(struct kmem_cache *cachep, void *addr)
 		page++;
 	}
 	if (current->reclaim_state)
-		current->reclaim_state->reclaimed_slab += nr_freed;
+		if (!current->reclaim_state->zone ||
+		    current->reclaim_state->zone == page_zone(page))
+			current->reclaim_state->reclaimed_slab += nr_freed;
 	free_pages((unsigned long)addr, cachep->gfporder);
 }
 
diff --git a/mm/slob.c b/mm/slob.c
index 3f19a34..192d05c 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -260,7 +260,9 @@ static void *slob_new_pages(gfp_t gfp, int order, int node)
 static void slob_free_pages(void *b, int order)
 {
 	if (current->reclaim_state)
-		current->reclaim_state->reclaimed_slab += 1 << order;
+		if (!current->reclaim_state->zone ||
+		    current->reclaim_state->zone == page_zone(page))
+			current->reclaim_state->reclaimed_slab += 1 << order;
 	free_pages((unsigned long)b, order);
 }
 
diff --git a/mm/slub.c b/mm/slub.c
index 7bb7940..f510b14 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1204,8 +1204,11 @@ static void __free_slab(struct kmem_cache *s, struct page *page)
 
 	__ClearPageSlab(page);
 	reset_page_mapcount(page);
-	if (current->reclaim_state)
-		current->reclaim_state->reclaimed_slab += pages;
+	if (current->reclaim_state) {
+		if (!current->reclaim_state->zone ||
+		    current->reclaim_state->zone == page_zone(page))
+			current->reclaim_state->reclaimed_slab += pages;
+	}
 	__free_pages(page, order);
 }
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 1bf9f72..8faef0c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2571,7 +2571,6 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 	/* Minimum pages needed in order to stay on node */
 	const unsigned long nr_pages = 1 << order;
 	struct task_struct *p = current;
-	struct reclaim_state reclaim_state;
 	int priority;
 	struct scan_control sc = {
 		.may_writepage = !!(zone_reclaim_mode & RECLAIM_WRITE),
@@ -2583,8 +2582,10 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 		.swappiness = vm_swappiness,
 		.order = order,
 	};
-	unsigned long nr_slab_pages0, nr_slab_pages1;
-
+	struct reclaim_state reclaim_state = {
+		.reclaimed_slab = 0,
+		.zone		= zone,
+	};
 
 	cond_resched();
 	/*
@@ -2594,7 +2595,6 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 	 */
 	p->flags |= PF_MEMALLOC | PF_SWAPWRITE;
 	lockdep_set_current_reclaim_state(gfp_mask);
-	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
 
 	if (zone_pagecache_reclaimable(zone) > zone->min_unmapped_pages) {
@@ -2610,34 +2610,22 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 		} while (priority >= 0 && sc.nr_reclaimed < nr_pages);
 	}
 
-	nr_slab_pages0 = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
-	if (nr_slab_pages0 > zone->min_slab_pages) {
+	if (zone_page_state(zone, NR_SLAB_RECLAIMABLE) > zone->min_slab_pages) {
 		unsigned long lru_pages = zone_reclaimable_pages(zone);
 
-		/*
-		 * shrink_slab() does not currently allow us to determine how
-		 * many pages were freed in this zone. So we take the current
-		 * number of slab pages and shake the slab until it is reduced
-		 * by the same nr_pages that we used for reclaiming unmapped
-		 * pages.
-		 *
-		 * Note that shrink_slab will free memory on all zones and may
-		 * take a long time.
-		 */
-		while (shrink_slab(sc.nr_scanned, gfp_mask, lru_pages) &&
-		       (zone_page_state(zone, NR_SLAB_RECLAIMABLE) + nr_pages >
-			nr_slab_pages0))
-			;
-
-		/*
-		 * Update nr_reclaimed by the number of slab pages we
-		 * reclaimed from this zone.
-		 */
-		nr_slab_pages1 = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
-		if (nr_slab_pages1 < nr_slab_pages0)
-			sc.nr_reclaimed += nr_slab_pages0 - nr_slab_pages1;
+		for(;;) {
+			/*
+			 * Note that shrink_slab will free memory on all zones
+			 * and may take a long time.
+			 */
+			if (!shrink_slab(sc.nr_scanned, gfp_mask, lru_pages))
+				break;
+			if (reclaim_state.reclaimed_slab >= nr_pages)
+				break;
+		}
 	}
 
+	sc.nr_reclaimed += reclaim_state.reclaimed_slab;
 	p->reclaim_state = NULL;
 	current->flags &= ~(PF_MEMALLOC | PF_SWAPWRITE);
 	lockdep_clear_current_reclaim_state();
-- 
1.6.5.2






