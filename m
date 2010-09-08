Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab0IHN15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 09:27:57 -0400
Received: from gir.skynet.ie ([193.1.99.77]:42664 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574Ab0IHN1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 09:27:55 -0400
Date: Wed, 8 Sep 2010 14:27:42 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 08/10] vmscan: isolated_lru_pages() stop neighbour
	search if neighbour cannot be isolated
Message-ID: <20100908132742.GF29263@csn.ul.ie>
References: <1283770053-18833-1-git-send-email-mel@csn.ul.ie> <1283770053-18833-9-git-send-email-mel@csn.ul.ie> <20100908113734.GC7597@localhost> <20100908125044.GE29263@csn.ul.ie> <20100908131404.GA12660@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100908131404.GA12660@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, 2010 at 09:14:04PM +0800, Wu Fengguang wrote:
> On Wed, Sep 08, 2010 at 08:50:44PM +0800, Mel Gorman wrote:
> > On Wed, Sep 08, 2010 at 07:37:34PM +0800, Wu Fengguang wrote:
> > > On Mon, Sep 06, 2010 at 06:47:31PM +0800, Mel Gorman wrote:
> > > > From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > > > 
> > > > isolate_lru_pages() does not just isolate LRU tail pages, but also isolate
> > > > neighbour pages of the eviction page. The neighbour search does not stop even
> > > > if neighbours cannot be isolated which is excessive as the lumpy reclaim will
> > > > no longer result in a successful higher order allocation. This patch stops
> > > > the PFN neighbour pages if an isolation fails and moves on to the next block.
> > > > 
> > > > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > > > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > > > ---
> > > >  mm/vmscan.c |   24 ++++++++++++++++--------
> > > >  1 files changed, 16 insertions(+), 8 deletions(-)
> > > > 
> > > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > > index 64f9ca5..ff52b46 100644
> > > > --- a/mm/vmscan.c
> > > > +++ b/mm/vmscan.c
> > > > @@ -1047,14 +1047,18 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
> > > >  				continue;
> > > >  
> > > >  			/* Avoid holes within the zone. */
> > > > -			if (unlikely(!pfn_valid_within(pfn)))
> > > > +			if (unlikely(!pfn_valid_within(pfn))) {
> > > > +				nr_lumpy_failed++;
> > > >  				break;
> > > > +			}
> > > >  
> > > >  			cursor_page = pfn_to_page(pfn);
> > > >  
> > > >  			/* Check that we have not crossed a zone boundary. */
> > > > -			if (unlikely(page_zone_id(cursor_page) != zone_id))
> > > > -				continue;
> > > > +			if (unlikely(page_zone_id(cursor_page) != zone_id)) {
> > > > +				nr_lumpy_failed++;
> > > > +				break;
> > > > +			}
> > > >  
> > > >  			/*
> > > >  			 * If we don't have enough swap space, reclaiming of
> > > > @@ -1062,8 +1066,10 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
> > > >  			 * pointless.
> > > >  			 */
> > > >  			if (nr_swap_pages <= 0 && PageAnon(cursor_page) &&
> > > > -					!PageSwapCache(cursor_page))
> > > > -				continue;
> > > > +			    !PageSwapCache(cursor_page)) {
> > > > +				nr_lumpy_failed++;
> > > > +				break;
> > > > +			}
> > > >  
> > > >  			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
> > > >  				list_move(&cursor_page->lru, dst);
> > > > @@ -1074,9 +1080,11 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
> > > >  					nr_lumpy_dirty++;
> > > >  				scan++;
> > > >  			} else {
> > > > -				if (mode == ISOLATE_BOTH &&
> > > > -						page_count(cursor_page))
> > > > -					nr_lumpy_failed++;
> > > > +				/* the page is freed already. */
> > > > +				if (!page_count(cursor_page))
> > > > +					continue;
> > > > +				nr_lumpy_failed++;
> > > > +				break;
> > > >  			}
> > > >  		}
> > > 
> > > The many nr_lumpy_failed++ can be moved here:
> > > 
> > >                 if (pfn < end_pfn)
> > >                         nr_lumpy_failed++;
> > > 
> > 
> > Because the break stops the loop iterating, is there an advantage to
> > making it a pfn check instead? I might be misunderstanding your
> > suggestion.
> 
> The complete view in my mind is
> 
>                 for (; pfn < end_pfn; pfn++) {
>                         if (failed 1)
>                                 break;
>                         if (failed 2)
>                                 break;
>                         if (failed 3)
>                                 break;
>                 }
>                 if (pfn < end_pfn)
>                         nr_lumpy_failed++;
> 
> Sure it just reduces several lines of code :)
> 

Fair point. I applied the following patch on top.

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 33d27a4..54df972 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1091,18 +1091,14 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 				continue;
 
 			/* Avoid holes within the zone. */
-			if (unlikely(!pfn_valid_within(pfn))) {
-				nr_lumpy_failed++;
+			if (unlikely(!pfn_valid_within(pfn)))
 				break;
-			}
 
 			cursor_page = pfn_to_page(pfn);
 
 			/* Check that we have not crossed a zone boundary. */
-			if (unlikely(page_zone_id(cursor_page) != zone_id)) {
-				nr_lumpy_failed++;
+			if (unlikely(page_zone_id(cursor_page) != zone_id))
 				break;
-			}
 
 			/*
 			 * If we don't have enough swap space, reclaiming of
@@ -1110,10 +1106,8 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 			 * pointless.
 			 */
 			if (nr_swap_pages <= 0 && PageAnon(cursor_page) &&
-			    !PageSwapCache(cursor_page)) {
-				nr_lumpy_failed++;
+			    !PageSwapCache(cursor_page))
 				break;
-			}
 
 			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
 				list_move(&cursor_page->lru, dst);
@@ -1127,10 +1121,13 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 				/* the page is freed already. */
 				if (!page_count(cursor_page))
 					continue;
-				nr_lumpy_failed++;
 				break;
 			}
 		}
+
+		/* If we break out of the loop above, lumpy reclaim failed */
+		if (pfn < end_pfn)
+			nr_lumpy_failed++;
 	}
 
 	*scanned = scan;
