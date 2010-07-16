Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935258Ab0GPBkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 21:40:05 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39040 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935038Ab0GPBkC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 21:40:02 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 2/2] vmscan: shrink_slab() require number of lru_pages,  not page order
Cc: kosaki.motohiro@jp.fujitsu.com, Minchan Kim <minchan.kim@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <20100715121551.bd5ccc61.akpm@linux-foundation.org>
References: <20100713144008.EA52.A69D9226@jp.fujitsu.com> <20100715121551.bd5ccc61.akpm@linux-foundation.org>
Message-Id: <20100716090302.7351.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 16 Jul 2010 10:39:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  	nr_slab_pages0 = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
> >  	if (nr_slab_pages0 > zone->min_slab_pages) {
> > +		unsigned long lru_pages = zone_reclaimable_pages(zone);
> > +
> >  		/*
> >  		 * shrink_slab() does not currently allow us to determine how
> >  		 * many pages were freed in this zone. So we take the current
> > @@ -2622,7 +2624,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
> >  		 * Note that shrink_slab will free memory on all zones and may
> >  		 * take a long time.
> >  		 */
> > -		while (shrink_slab(sc.nr_scanned, gfp_mask, order) &&
> > +		while (shrink_slab(sc.nr_scanned, gfp_mask, lru_pages) &&
> >  		       (zone_page_state(zone, NR_SLAB_RECLAIMABLE) + nr_pages >
> >  			nr_slab_pages0))
> >  			;
> 
> Wouldn't it be better to recalculate zone_reclaimable_pages() each time
> around the loop?  For example, shrink_icache_memory()->prune_icache()
> will remove pagecache from an inode if it hits the tail of the list. 
> This can change the number of reclaimable pages by squigabytes, but
> this code thinks nothing changed?

Ah, I missed this. incrementa patch is here.

thank you!



>From 8f7c70cfb4a25f8292a59564db6c3ff425a69b53 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 16 Jul 2010 08:40:01 +0900
Subject: [PATCH] vmscan: recalculate lru_pages on each shrink_slab()

Andrew Morton pointed out shrink_slab() may change number of reclaimable
pages (e.g. shrink_icache_memory()->prune_icache() will remove unmapped
pagecache).

So, we need to recalculate lru_pages on each shrink_slab() calling.
This patch fixes it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 1bf9f72..1da9b14 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2612,8 +2612,6 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 
 	nr_slab_pages0 = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
 	if (nr_slab_pages0 > zone->min_slab_pages) {
-		unsigned long lru_pages = zone_reclaimable_pages(zone);
-
 		/*
 		 * shrink_slab() does not currently allow us to determine how
 		 * many pages were freed in this zone. So we take the current
@@ -2624,10 +2622,18 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 		 * Note that shrink_slab will free memory on all zones and may
 		 * take a long time.
 		 */
-		while (shrink_slab(sc.nr_scanned, gfp_mask, lru_pages) &&
-		       (zone_page_state(zone, NR_SLAB_RECLAIMABLE) + nr_pages >
-			nr_slab_pages0))
-			;
+		for (;;) {
+			unsigned long lru_pages = zone_reclaimable_pages(zone);
+
+			/* No reclaimable slab or very low memroy pressure */
+			if (!shrink_slab(sc.nr_scanned, gfp_mask, lru_pages))
+				break;
+
+			/* Freed enouch memory */
+			nr_slab_pages1 = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
+			if (nr_slab_pages1 + nr_pages <= nr_slab_pages0)
+				break;
+		}
 
 		/*
 		 * Update nr_reclaimed by the number of slab pages we
-- 
1.6.5.2



