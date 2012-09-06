Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301Ab2IFErb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 00:47:31 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:49051 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab2IFEra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 00:47:30 -0400
X-AuditID: 9c930197-b7b93ae0000028a7-9b-50482adf274c
Date: Thu, 6 Sep 2012 13:49:03 +0900
From: Minchan Kim <minchan@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Xishi Qiu <qiuxishi@huawei.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] memory-hotplug: bug fix race between isolation and
 allocation
Message-ID: <20120906044903.GA16150@bbox>
References: <1346829962-31989-1-git-send-email-minchan@kernel.org>
 <1346829962-31989-4-git-send-email-minchan@kernel.org>
 <20120905094041.GF11266@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120905094041.GF11266@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 10:40:41AM +0100, Mel Gorman wrote:
> On Wed, Sep 05, 2012 at 04:26:02PM +0900, Minchan Kim wrote:
> > Like below, memory-hotplug makes race between page-isolation
> > and page-allocation so it can hit BUG_ON in __offline_isolated_pages.
> > 
> > 	CPU A					CPU B
> > 
> > start_isolate_page_range
> > set_migratetype_isolate
> > spin_lock_irqsave(zone->lock)
> > 
> > 				free_hot_cold_page(Page A)
> > 				/* without zone->lock */
> > 				migratetype = get_pageblock_migratetype(Page A);
> > 				/*
> > 				 * Page could be moved into MIGRATE_MOVABLE
> > 				 * of per_cpu_pages
> > 				 */
> > 				list_add_tail(&page->lru, &pcp->lists[migratetype]);
> > 
> > set_pageblock_isolate
> > move_freepages_block
> > drain_all_pages
> > 
> > 				/* Page A could be in MIGRATE_MOVABLE of free_list. */
> > 
> > check_pages_isolated
> > __test_page_isolated_in_pageblock
> > /*
> >  * We can't catch freed page which
> >  * is free_list[MIGRATE_MOVABLE]
> >  */
> > if (PageBuddy(page A))
> > 	pfn += 1 << page_order(page A);
> > 
> > 				/* So, Page A could be allocated */
> > 
> > __offline_isolated_pages
> > /*
> >  * BUG_ON hit or offline page
> >  * which is used by someone
> >  */
> > BUG_ON(!PageBuddy(page A));
> > 
> 
> offline_page calling BUG_ON because someone allocated the page is
> ridiculous. I did not spot where that check is but it should be changed. The
> correct action is to retry the isolation.

It is where __offline_isolated_pges.

..
        while (pfn < end_pfn) {
                if (!pfn_valid(pfn)) {
                        pfn++;
                        continue;
                }    
                page = pfn_to_page(pfn);
                BUG_ON(page_count(page));
                BUG_ON(!PageBuddy(page)); <---- HERE
                order = page_order(page);
...

Comment of offline_isolated_pages says following as.

        We cannot do rollback at this point

So if the comment is true, BUG_ON does make sense to me.
But I don't see why we can't retry it as I look thorugh code.
Anyway, It's another story which isn't related to this patch.

> 
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> 
> At no point in the changelog do you actually say what he patch does :/

Argh, I will do.

> 
> > ---
> >  mm/page_isolation.c |    5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/page_isolation.c b/mm/page_isolation.c
> > index acf65a7..4699d1f 100644
> > --- a/mm/page_isolation.c
> > +++ b/mm/page_isolation.c
> > @@ -196,8 +196,11 @@ __test_page_isolated_in_pageblock(unsigned long pfn, unsigned long end_pfn)
> >  			continue;
> >  		}
> >  		page = pfn_to_page(pfn);
> > -		if (PageBuddy(page))
> > +		if (PageBuddy(page)) {
> > +			if (get_page_migratetype(page) != MIGRATE_ISOLATE)
> > +				break;
> >  			pfn += 1 << page_order(page);
> > +		}
> 
> It is possible the page is moved to the MIGRATE_ISOLATE list between when
> the page was freed to the buddy allocator and this check was made. The
> page->index information is stale and the impact is that the hotplug
> operation fails when it could have succeeded. That said, I think it is a
> very unlikely race that will never happen in practice.

I understand you mean move_freepages which I have missed. Right?
Then, I will fix it, too.

> 
> More importantly, the effect of this path is that EBUSY gets bubbled all
> the way up and the hotplug operations fails. This is fine but as the page
> is free at the time this problem is detected you also have the option
> of moving the PageBuddy page to the MIGRATE_ISOLATE list at this time
> if you take the zone lock. This will mean you need to change the name of
> test_pages_isolated() of course.

Sorry, I can't get your point. Could you elaborate it more?
Is it related to this patch?


> 
> >  		else if (page_count(page) == 0 &&
> >  				get_page_migratetype(page) == MIGRATE_ISOLATE)
> >  			pfn += 1;
> > -- 
> > 1.7.9.5
> > 
> 
> -- 
> Mel Gorman
> SUSE Labs
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
