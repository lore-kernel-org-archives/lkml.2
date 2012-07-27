Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab2G0LKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 07:10:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35291 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab2G0LKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 07:10:37 -0400
Date: Fri, 27 Jul 2012 20:10:27 +0900
From: Minchan Kim <minchan@kernel.org>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, lliubbo@gmail.com
Subject: Re: [RESEND RFC 3/3] memory-hotplug: bug fix race between isolation
 and allocation
Message-ID: <20120727111027.GA2079@barrios>
References: <1343004482-6916-1-git-send-email-minchan@kernel.org>
 <1343004482-6916-4-git-send-email-minchan@kernel.org>
 <50126BF8.3070901@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50126BF8.3070901@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 07:22:48PM +0900, Kamezawa Hiroyuki wrote:
> (2012/07/23 9:48), Minchan Kim wrote:
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
> >   * We can't catch freed page which
> >   * is free_list[MIGRATE_MOVABLE]
> >   */
> > if (PageBuddy(page A))
> > 	pfn += 1 << page_order(page A);
> > 
> > 				/* So, Page A could be allocated */
> > 
> > __offline_isolated_pages
> > /*
> >   * BUG_ON hit or offline page
> >   * which is used by someone
> >   */
> > BUG_ON(!PageBuddy(page A));
> > 
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> 
> Ah, hm. Then, you say the page in MIGRATE_MOVABLE will not be isolated
> and may be used again.

Yes.

> 
> 
> > ---
> > I found this problem during code review so please confirm it.
> > Kame?
> > 
> >   mm/page_isolation.c |    5 ++++-
> >   1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/page_isolation.c b/mm/page_isolation.c
> > index acf65a7..4699d1f 100644
> > --- a/mm/page_isolation.c
> > +++ b/mm/page_isolation.c
> > @@ -196,8 +196,11 @@ __test_page_isolated_in_pageblock(unsigned long pfn, unsigned long end_pfn)
> >   			continue;
> >   		}
> >   		page = pfn_to_page(pfn);
> > -		if (PageBuddy(page))
> > +		if (PageBuddy(page)) {
> > +			if (get_page_migratetype(page) != MIGRATE_ISOLATE)
> > +				break;
> 
> Doesn't this work enough ? The problem is MIGRATE_TYPE and list_head mis-match.

I guess you are confused between get_page_migratetype and get_pageblock_migratetype.
It's not get_pageblock_migratetype but get_page_migratetype which is introduced for detecting
MIGRATE_TYPE and list_head mismatch in [1,2/3].

> 
> Thanks,
> -Kame
>  
> 
> 
