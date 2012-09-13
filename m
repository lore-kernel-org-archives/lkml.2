Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763Ab2IMOWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 10:22:44 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36435 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250Ab2IMOWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 10:22:41 -0400
X-AuditID: cbfee61b-b7f826d000005fb5-fa-5051ec2f3248
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Minchan Kim <minchan@kernel.org>
Subject: Re: [RFC v2] memory-hotplug: remove MIGRATE_ISOLATE from
 free_area->free_list
Date: Thu, 13 Sep 2012 16:21:42 +0200
User-Agent: KMail/1.13.2 (Linux/3.5.0-rc2+; KDE/4.4.5; i686; ; )
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Nazarewicz <mina86@mina86.com>, Mel Gorman <mel@csn.ul.ie>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
References: <1346900018-14759-1-git-send-email-minchan@kernel.org>
 <201209061834.35473.b.zolnierkie@samsung.com>
In-reply-to: <201209061834.35473.b.zolnierkie@samsung.com>
MIME-version: 1.0
Message-id: <201209131621.43074.b.zolnierkie@samsung.com>
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsVy+t9jQV39N4EBBtuWa1lc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Md+/7WQtWq1Rc/zmNqYHxkUwXIyeHhICJxI/bh5ggbDGJC/fW
	s3UxcnEICUxnlJg+eSMzhLOUSWLGvW+MIFVsAlYSE9tXgdkiAioSf57+A7I5OIQFIiSu3rAE
	CbMIqEqsO30LrERUwEGic+oEsKHMArOYJfom/WcBSQgJFEmsuD2VFcTmBJo58+g7sAZeAUGJ
	H5PvsUDYlhK9m5aC2cwCWhLNbzYxQtjyEpvXvGWewCgwC0nLLCRls5CULWBkXsUomlqQXFCc
	lJ5rpFecmFtcmpeul5yfu4kRHILPpHcwrmqwOMQowMGoxMOb+TwgQIg1say4MvcQowQHs5II
	r3p3YIAQb0piZVVqUX58UWlOavEhRmkOFiVxXu/zQCmB9MSS1OzU1ILUIpgsEwenVANj70rd
	1Lrn+a/ylscu/Cx6gS103XTTKa3v1xxWfdazWnz+K6Eu1zWC8X93vLRPqJKZK/nj6Jf/LY7L
	jG1uLvnMNPu7mmLlyq4OUdW5T+2X10+esVZr9ifTYx2J329ncRTWV97U2B0ZeVhO9N1+n6uf
	knjqDqUaRq6S8b3dWX396575vH8jwu8eUmIpzkg01GIuKk4EAM9Xn3o9AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 September 2012 18:34:35 Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Thursday 06 September 2012 04:53:38 Minchan Kim wrote:
> > Normally, MIGRATE_ISOLATE type is used for memory-hotplug.
> > But it's irony type because the pages isolated would exist
> > as free page in free_area->free_list[MIGRATE_ISOLATE] so people
> > can think of it as allocatable pages but it is *never* allocatable.
> > It ends up confusing NR_FREE_PAGES vmstat so it would be
> > totally not accurate so some of place which depend on such vmstat
> > could reach wrong decision by the context.
> > 
> > There were already report about it.[1]
> > [1] 702d1a6e, memory-hotplug: fix kswapd looping forever problem
> > 
> > Then, there was other report which is other problem.[2]
> > [2] http://www.spinics.net/lists/linux-mm/msg41251.html
> > 
> > I believe it can make problems in future, too.
> > So I hope removing such irony type by another design.
> > 
> > I hope this patch solves it and let's revert [1] and doesn't need [2].

For our needs (CMA) patch [2] is much simpler / less intrusive way
to have correct NR_FREE_PAGES counter than this patch and currently
I would prefer to have it merged upstream instead of this one.

> > * Changelog v1
> >  * Fix from Michal's many suggestion
> > 
> > Cc: Michal Nazarewicz <mina86@mina86.com>
> > Cc: Mel Gorman <mel@csn.ul.ie>
> > Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> > Cc: Wen Congyang <wency@cn.fujitsu.com>
> > Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> > ---
> > It's very early version which show the concept so I still marked it with RFC.
> > I just tested it with simple test and works.
> > This patch is needed indepth review from memory-hotplug guys from fujitsu
> > because I saw there are lots of patches recenlty they sent to about
> > memory-hotplug change. Please take a look at this patch.
> 
> [...]
> 
> > @@ -948,8 +954,13 @@ static int move_freepages(struct zone *zone,
> >  		}
> >  
> >  		order = page_order(page);
> > -		list_move(&page->lru,
> > -			  &zone->free_area[order].free_list[migratetype]);
> > +		if (migratetype != MIGRATE_ISOLATE) {
> > +			list_move(&page->lru,
> > +				&zone->free_area[order].free_list[migratetype]);
> > +		} else {
> > +			list_del(&page->lru);
> > +			isolate_free_page(page, order);
> > +		}
> >  		page += 1 << order;
> >  		pages_moved += 1 << order;
> >  	}
> 
> Shouldn't NR_FREE_PAGES counter be decreased somewhere above?
> 
> [ I can see that it is not modified in __free_pages_ok() and
>   free_hot_cold_page() because page is still counted as non-free one but
>   here situation is different AFAICS. ]
> 
> I tested the patch locally here with CONFIG_CMA=y and it causes some
> major problems for CMA (multiple errors from dma_alloc_from_contiguous()
> about memory ranges being busy and allocation failures).
> 
> [ I'm sorry that I don't know more details yet but the issue should be
>   easily reproducible. ]

We spent some more time on the issue and it seems that the approach
taken in the patch (removal of MIGRATE_ISOLATE free_list) is currently
incompatible with CMA.

In alloc_contig_range() we have:

	order = 0;
	outer_start = start;
	while (!PageBuddy(pfn_to_page(outer_start))) {
		if (++order >= MAX_ORDER) {
			ret = -EBUSY;
			goto done;
		}
		outer_start &= ~0UL << order;
	}

for handling cases when the CMA area begins inside the higher order
page from buddy (that got already isolated).  Unfortunately this code
no longer works as isolated pages are no longer hold in buddy allocator
(isolate_free_page() clears buddy bit).

The other part of code that is probably affected by your patch is:

	/* Grab isolated pages from freelists. */
	outer_end = isolate_freepages_range(outer_start, end);
	if (!outer_end) {
		ret = -EBUSY;
		goto done;
	}

also in alloc_contig_range().  isolate_freepages_range() calls
isolate_freepages_block() which assume that free pages (in isolated
pageblock) are in buddy allocator:

		if (!PageBuddy(page)) {
			if (strict)
				return 0;
			continue;
		}

(which is no longer true) and also calls split_free_page() that
attempts to remove page from the free_list & buddy:

	/* Remove page from free list */
	list_del(&page->lru);
	zone->free_area[order].nr_free--;
	rmv_page_order(page);

(the isolated page is on the isolated_pages list instead).

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung Poland R&D Center
