Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab0KRSvD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 13:51:03 -0500
Received: from gir.skynet.ie ([193.1.99.77]:42559 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab0KRSvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 13:51:01 -0500
Date: Thu, 18 Nov 2010 18:50:46 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] mm: compaction: Perform a faster scan in
	try_to_compact_pages()
Message-ID: <20101118185046.GQ8135@csn.ul.ie>
References: <1290010969-26721-1-git-send-email-mel@csn.ul.ie> <1290010969-26721-7-git-send-email-mel@csn.ul.ie> <20101118183448.GC30376@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20101118183448.GC30376@random.random>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 07:34:48PM +0100, Andrea Arcangeli wrote:
> On Wed, Nov 17, 2010 at 04:22:47PM +0000, Mel Gorman wrote:
> > @@ -485,8 +500,8 @@ static unsigned long compact_zone_order(struct zone *zone,
> >  		.nr_migratepages = 0,
> >  		.order = order,
> >  		.migratetype = allocflags_to_migratetype(gfp_mask),
> > +		.migrate_fast_scan = true,
> >  		.zone = zone,
> > -		.sync = false,
> >  	};
> >  	INIT_LIST_HEAD(&cc.freepages);
> >  	INIT_LIST_HEAD(&cc.migratepages);
> > @@ -502,8 +517,8 @@ unsigned long reclaimcompact_zone_order(struct zone *zone,
> >  		.nr_migratepages = 0,
> >  		.order = order,
> >  		.migratetype = allocflags_to_migratetype(gfp_mask),
> > +		.migrate_fast_scan = false,
> >  		.zone = zone,
> > -		.sync = true,
> >  	};
> 
> Same as for the previous feature (sync/async migrate) I'd prefer if
> this was a __GFP_ flag (khugepaged will do the no-fast-scan version,
> page fault will only run compaction in fast scan mode) and if we

For THP in general, I think we can abuse __GFP_NO_KSWAPD. For other callers,
I'm not sure it's fair to push the responsibility of async/sync to them. We
don't do it for reclaim for example and I'd worry the wrong decisions would
be made or that they'd always select async for "performance" and then bitch
about an allocation failure.

> removed the reclaimcompact_zone_order and we stick with the
> interleaving of shrinker and try_to_compact_pages from the alloc_pages
> caller, with no nesting of compaction inside the shrinker.
> 
> Another possibility would be to not have those as __GFP flags, and to
> always do the first try_to_compact_pages with async+fast_scan, then
> call the shrinker and then all next try_to_compact_pages would be
> called with sync+no_fast_scan mode.
> 

I'll investigate this.

> But I love if we can further decrease the risk of too long page
> hugepage page fault before the normal page fallback, and to have a
> __GFP_ flag for these two. Even the same __GFP flag could work for
> both...
> 
> So my preference would be to nuke reclaimcompact_zone_order, only
> stick to compact_zone_order and the current interleaving, and add a
> __GFP_COMPACT_FAST used by the hugepmd page fault (that will enable
> both async migrate and fast-scan). khugepaged and hugetlbfs won't use
> __GFP_COMPACT_FAST.

My only whinge about the lack of reclaimcompact_zone_order is that it
makes it harder to even contemplate lumpy compaction in the future but
it could always be reintroduced if absolutely necessary.

> 
> I'm undecided if a __GFP_ flag is needed to differentiate the callers,
> or if we should just run the first try_to_compact_pages in
> "optimistic" mode by default.
> 

GFP flags would be my last preference. 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
