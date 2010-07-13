Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab0GMFlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 01:41:32 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43120 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab0GMFlb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 01:41:31 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH v2 2/2] vmscan: shrink_slab() require number of lru_pages,  not page order
Cc: kosaki.motohiro@jp.fujitsu.com,
        Christoph Lameter <cl@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <AANLkTinwZfaQiTJhP8RcGhlSS-ynEXtbpzorrIZrNyIH@mail.gmail.com>
References: <20100708163934.CD37.A69D9226@jp.fujitsu.com> <AANLkTinwZfaQiTJhP8RcGhlSS-ynEXtbpzorrIZrNyIH@mail.gmail.com>
Message-Id: <20100713144008.EA52.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 13 Jul 2010 14:41:28 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Jul 8, 2010 at 4:40 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> > Fix simple argument error. Usually 'order' is very small value than
> > lru_pages. then it can makes unnecessary icache dropping.
> >
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> 
> With your test result, This patch makes sense to me.
> Please, include your test result in description.

How's this?

==============================================================
>From 19872d74875e2331cbe7eca46c8ef65f5f00d7c4 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Tue, 13 Jul 2010 13:39:11 +0900
Subject: [PATCH] vmscan: shrink_slab() require number of lru_pages, not page order

Now, shrink_slab() has following scanning equation.

                            lru_scanned        max_pass
  basic_scan_objects = 4 x -------------  x -----------------------------
                            lru_pages        shrinker->seeks (default:2)

  scan_objects = min(basic_scan_objects, max_pass * 2)

Then, If we pass very small value as lru_pages instead real number of
lru pages, shrink_slab() drop much objects rather than necessary. and
now, __zone_reclaim() pass 'order' as lru_pages by mistake. that makes
bad result.

Example, If we receive very low memory pressure (scan = 32, order = 0),
shrink_slab() via zone_reclaim() always drop _all_ icache/dcache
objects. (see above equation, very small lru_pages make very big
scan_objects result)

This patch fixes it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Acked-by: Rik van Riel <riel@redhat.com>
---
 mm/vmscan.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6ff51c0..1bf9f72 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2612,6 +2612,8 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 
 	nr_slab_pages0 = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
 	if (nr_slab_pages0 > zone->min_slab_pages) {
+		unsigned long lru_pages = zone_reclaimable_pages(zone);
+
 		/*
 		 * shrink_slab() does not currently allow us to determine how
 		 * many pages were freed in this zone. So we take the current
@@ -2622,7 +2624,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 		 * Note that shrink_slab will free memory on all zones and may
 		 * take a long time.
 		 */
-		while (shrink_slab(sc.nr_scanned, gfp_mask, order) &&
+		while (shrink_slab(sc.nr_scanned, gfp_mask, lru_pages) &&
 		       (zone_page_state(zone, NR_SLAB_RECLAIMABLE) + nr_pages >
 			nr_slab_pages0))
 			;
-- 
1.6.5.2




