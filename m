Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab0IHO7D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 10:59:03 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37553 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab0IHO7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 10:59:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=U+FwIZTReyTbq3bIZQVNeug9ZLBZZiSCcAwl6TWUsG7RXgwODWxc8AST2PmW6moB4h
         Znzh2L58fdJ1VDDng1LpbKwQyKXTv7nsoKULgQv7j9TPwKbwD56p/3MwbyKnuxvQkobJ
         RLjOH0qEpHx2QGHNl8w9qQ/ON/S0wTCN9y4P4=
Date: Wed, 8 Sep 2010 23:58:51 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 08/10] vmscan: isolated_lru_pages() stop neighbour
 search if neighbour cannot be isolated
Message-ID: <20100908145851.GH4620@barrios-desktop>
References: <1283770053-18833-1-git-send-email-mel@csn.ul.ie>
 <1283770053-18833-9-git-send-email-mel@csn.ul.ie>
 <20100907153708.GF4620@barrios-desktop>
 <20100908111230.GC29263@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100908111230.GC29263@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, 2010 at 12:12:30PM +0100, Mel Gorman wrote:
> On Wed, Sep 08, 2010 at 12:37:08AM +0900, Minchan Kim wrote:
> > On Mon, Sep 06, 2010 at 11:47:31AM +0100, Mel Gorman wrote:
> > > From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > > 
> > > isolate_lru_pages() does not just isolate LRU tail pages, but also isolate
> > > neighbour pages of the eviction page. The neighbour search does not stop even
> > > if neighbours cannot be isolated which is excessive as the lumpy reclaim will
> > > no longer result in a successful higher order allocation. This patch stops
> > > the PFN neighbour pages if an isolation fails and moves on to the next block.
> > > 
> > > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > > ---
> > >  mm/vmscan.c |   24 ++++++++++++++++--------
> > >  1 files changed, 16 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index 64f9ca5..ff52b46 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -1047,14 +1047,18 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
> > >  				continue;
> > >  
> > >  			/* Avoid holes within the zone. */
> > > -			if (unlikely(!pfn_valid_within(pfn)))
> > > +			if (unlikely(!pfn_valid_within(pfn))) {
> > > +				nr_lumpy_failed++;
> > >  				break;
> > > +			}
> > >  
> > >  			cursor_page = pfn_to_page(pfn);
> > >  
> > >  			/* Check that we have not crossed a zone boundary. */
> > > -			if (unlikely(page_zone_id(cursor_page) != zone_id))
> > > -				continue;
> > > +			if (unlikely(page_zone_id(cursor_page) != zone_id)) {
> > > +				nr_lumpy_failed++;
> > > +				break;
> > > +			}
> > >  
> > >  			/*
> > >  			 * If we don't have enough swap space, reclaiming of
> > > @@ -1062,8 +1066,10 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
> > >  			 * pointless.
> > >  			 */
> > >  			if (nr_swap_pages <= 0 && PageAnon(cursor_page) &&
> > > -					!PageSwapCache(cursor_page))
> > > -				continue;
> > > +			    !PageSwapCache(cursor_page)) {
> > > +				nr_lumpy_failed++;
> > > +				break;
> > > +			}
> > >  
> > >  			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
> > >  				list_move(&cursor_page->lru, dst);
> > > @@ -1074,9 +1080,11 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
> > >  					nr_lumpy_dirty++;
> > >  				scan++;
> > >  			} else {
> > > -				if (mode == ISOLATE_BOTH &&
> > 
> > Why can we remove ISOLATION_BOTH check?
> 
> Because this is lumpy reclaim and whether we are isolating inactive, active
> or both doesn't matter. The fact we failed to isolate the page and it has
> a reference count means that a contiguous allocation in that area will fail.
> 
> > Is it a intentionall behavior change?
> > 
> 
> Yes.

It looks good to me. 
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
