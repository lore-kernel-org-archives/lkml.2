Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab2KSPiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:38:23 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:9720 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab2KSPiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:38:21 -0500
Message-id: <50AA526A.7080505@samsung.com>
Date: Mon, 19 Nov 2012 16:38:18 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026
 Thunderbird/16.0.2
MIME-version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>, Mel Gorman <mel@csn.ul.ie>,
        Michal Nazarewicz <mina86@mina86.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH] mm: cma: allocate pages from CMA if NR_FREE_PAGES
 approaches low water mark
References: <1352710782-25425-1-git-send-email-m.szyprowski@samsung.com>
 <20121114145848.8224e8b0.akpm@linux-foundation.org>
In-reply-to: <20121114145848.8224e8b0.akpm@linux-foundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/14/2012 11:58 PM, Andrew Morton wrote:
> On Mon, 12 Nov 2012 09:59:42 +0100
> Marek Szyprowski <m.szyprowski@samsung.com> wrote:
>
> > It has been observed that system tends to keep a lot of CMA free pages
> > even in very high memory pressure use cases. The CMA fallback for movable
> > pages is used very rarely, only when system is completely pruned from
> > MOVABLE pages, what usually means that the out-of-memory even will be
> > triggered very soon. To avoid such situation and make better use of CMA
> > pages, a heuristics is introduced which turns on CMA fallback for movable
> > pages when the real number of free pages (excluding CMA free pages)
> > approaches low water mark.
> >
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
> > CC: Michal Nazarewicz <mina86@mina86.com>
> > ---
> >  mm/page_alloc.c |    9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index fcb9719..90b51f3 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1076,6 +1076,15 @@ static struct page *__rmqueue(struct zone *zone, unsigned int order,
> >  {
> >  	struct page *page;
> >
> > +#ifdef CONFIG_CMA
> > +	unsigned long nr_free = zone_page_state(zone, NR_FREE_PAGES);
> > +	unsigned long nr_cma_free = zone_page_state(zone, NR_FREE_CMA_PAGES);
> > +
> > +	if (migratetype == MIGRATE_MOVABLE && nr_cma_free &&
> > +	    nr_free - nr_cma_free < 2 * low_wmark_pages(zone))
> > +		migratetype = MIGRATE_CMA;
> > +#endif /* CONFIG_CMA */
> > +
> >  retry_reserve:
> >  	page = __rmqueue_smallest(zone, order, migratetype);
>
> erk, this is right on the page allocator hotpath.  Bad.

Yes, I know that it adds an overhead to allocation hot path, but I found 
no other
place for such change. Do You have any suggestion where such change can 
be applied
to avoid additional load on hot path?

>
> At the very least, we could code it so it is not quite so dreadfully
> inefficient:
>
> 	if (migratetype == MIGRATE_MOVABLE) {
> 		unsigned long nr_cma_free;
>
> 		nr_cma_free = zone_page_state(zone, NR_FREE_CMA_PAGES);
> 		if (nr_cma_free) {
> 			unsigned long nr_free;
>
> 			nr_free = zone_page_state(zone, NR_FREE_PAGES);
>
> 			if (nr_free - nr_cma_free < 2 * low_wmark_pages(zone))
> 				migratetype = MIGRATE_CMA;
> 		}
> 	}
>
> but it still looks pretty bad.

Do You want me to resend such patch?

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


