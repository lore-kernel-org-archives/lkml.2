Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab1DZKOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 06:14:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58346 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114Ab1DZKOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 06:14:03 -0400
Date: Tue, 26 Apr 2011 11:13:58 +0100
From: Mel Gorman <mgorman@suse.de>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        Arve Hj?nnev?g <arve@android.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: Check if any page in a pageblock is reserved before
 marking it MIGRATE_RESERVE
Message-ID: <20110426101358.GC4658@suse.de>
References: <1303436043-26644-1-git-send-email-john.stultz@linaro.org>
 <20110426073410.GA4658@suse.de>
 <20110426185114.F3A4.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110426185114.F3A4.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 06:49:39PM +0900, KOSAKI Motohiro wrote:
> > On Thu, Apr 21, 2011 at 06:34:03PM -0700, John Stultz wrote:
> > > From: Arve Hjønnevåg <arve@android.com>
> > > 
> > > This fixes a problem where the first pageblock got marked MIGRATE_RESERVE even
> > > though it only had a few free pages. This in turn caused no contiguous memory
> > > to be reserved and frequent kswapd wakeups that emptied the caches to get more
> > > contiguous memory.
> > > 
> > > CC: Dave Hansen <dave@linux.vnet.ibm.com>
> > > CC: Mel Gorman <mgorman@suse.de>
> > > CC: Andrew Morton <akpm@linux-foundation.org>
> > > Signed-off-by: Arve Hjønnevåg <arve@android.com>
> > > Acked-by: Mel Gorman <mel@csn.ul.ie>
> > > 
> > > [This patch was submitted and acked a little over a year ago
> > > (see: http://lkml.org/lkml/2010/4/6/172 ), but never seemingly
> > > made it upstream. Resending for comments. -jstultz]
> > > 
> > > Signed-off-by: John Stultz <john.stultz@linaro.org>
> > 
> > Whoops, should have spotted it slipped through. FWIW, I'm still happy
> > with my Ack being stuck onto it.
> 
> Hehe, No.
> 
> You acked another patch at last year and John taked up old one. Sigh.
> Look,  correct one has pfn_valid_within(). 
> 	http://lkml.org/lkml/2010/4/6/172
> 

Bah, you're right thanks for catching that. A pfn_valid_within check is
indeed required, particularly on ARM where there can be holes punched within
pageblock boundaries. Thanks

> 
> Subject: [PATCH] mm: Check if any page in a pageblock is reserved before marking it MIGRATE_RESERVE
> From: Arve Hjonnevag <arve@android.com>
> 
> This fixes a problem where the first pageblock got marked MIGRATE_RESERVE even
> though it only had a few free pages. eg, On current ARM port, The kernel starts
> at offset 0x8000 to leave room for boot parameters, and the memory is freed later.
> 
> This in turn caused no contiguous memory to be reserved and frequent kswapd
> wakeups that emptied the caches to get more contiguous memory.
> 
> Unfortunatelly, ARM need order-2 allocation for pgd (see arm/mm/pgd.c#pgd_alloc()).
> Therefore the issue is not minor nor easy avoidable.
> 
> CC: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Arve Hjonnevag <arve@android.com>
> Acked-by: Mel Gorman <mel@csn.ul.ie>
> Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [added a
> few explanation]
> ---
>  mm/page_alloc.c |   16 +++++++++++++++-
>  1 files changed, 15 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 1d5c189..10d9fa7 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3282,6 +3282,20 @@ static inline unsigned long wait_table_bits(unsigned long size)
>  #define LONG_ALIGN(x) (((x)+(sizeof(long))-1)&~((sizeof(long))-1))
>  
>  /*
> + * Check if a pageblock contains reserved pages
> + */
> +static int pageblock_is_reserved(unsigned long start_pfn)
> +{
> +	unsigned long end_pfn = start_pfn + pageblock_nr_pages;
> +	unsigned long pfn;
> +
> +	for (pfn = start_pfn; pfn < end_pfn; pfn++)
> +		if (!pfn_valid_within(pfn) || PageReserved(pfn_to_page(pfn)))
> +			return 1;
> +	return 0;
> +}
> +
> +/*
>   * Mark a number of pageblocks as MIGRATE_RESERVE. The number
>   * of blocks reserved is based on min_wmark_pages(zone). The memory within
>   * the reserve will tend to store contiguous free pages. Setting min_free_kbytes
> @@ -3320,7 +3334,7 @@ static void setup_zone_migrate_reserve(struct zone *zone)
>  			continue;
>  
>  		/* Blocks with reserved pages will never free, skip them. */
> -		if (PageReserved(page))
> +		if (pageblock_is_reserved(pfn))
>  			continue;
>  
>  		block_migratetype = get_pageblock_migratetype(page);

-- 
Mel Gorman
SUSE Labs
