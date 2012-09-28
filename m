Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab2I1HnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 03:43:16 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:38652 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754180Ab2I1HnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 03:43:14 -0400
Message-ID: <50655558.5010500@ti.com>
Date: Fri, 28 Sep 2012 10:44:24 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120917 Thunderbird/15.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: CMA broken in next-20120926
References: <20120927112911.GA25959@avionic-0098.mockup.avionic-design.de> <20120927151159.4427fc8f.akpm@linux-foundation.org> <20120928054330.GA27594@bbox>
In-Reply-To: <20120928054330.GA27594@bbox>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2012 08:43 AM, Minchan Kim wrote:
> From 24a547855fa2bd4212a779cc73997837148310b3 Mon Sep 17 00:00:00 2001
> From: Minchan Kim <minchan@kernel.org>
> Date: Fri, 28 Sep 2012 14:28:32 +0900
> Subject: [PATCH] revert mm: compaction: iron out isolate_freepages_block()
>  and isolate_freepages_range()
> 
> [1] made bug on CMA.
> The nr_scanned should be never equal to total_isolated for successful CMA.
> This patch reverts part of the patch.
> 
> [1] mm: compaction: iron out isolate_freepages_block() and isolate_freepages_range()

With this patch applied on top of today's linux-next CMA enabled kernel works
fine on OMAP platforms (without the patch audio was not working because
dma_alloc_writecombine() was failing, probably other things were broken as well).
Thank you for the quick fix!

Tested-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

> 
> Cc: Mel Gorman <mgorman@suse.de>
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  mm/compaction.c |   29 ++++++++++++++++-------------
>  1 file changed, 16 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 5037399..7721197 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -269,13 +269,14 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
>  		int isolated, i;
>  		struct page *page = cursor;
>  
> -		nr_scanned++;
>  		if (!pfn_valid_within(blockpfn))
> -			continue;
> +			goto strict_check;
> +		nr_scanned++;
> +
>  		if (!valid_page)
>  			valid_page = page;
>  		if (!PageBuddy(page))
> -			continue;
> +			goto strict_check;
>  
>  		/*
>  		 * The zone lock must be held to isolate freepages.
> @@ -296,12 +297,12 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
>  
>  		/* Recheck this is a buddy page under lock */
>  		if (!PageBuddy(page))
> -			continue;
> +			goto strict_check;
>  
>  		/* Found a free page, break it into order-0 pages */
>  		isolated = split_free_page(page);
>  		if (!isolated && strict)
> -			break;
> +			goto strict_check;
>  		total_isolated += isolated;
>  		for (i = 0; i < isolated; i++) {
>  			list_add(&page->lru, freelist);
> @@ -313,18 +314,20 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
>  			blockpfn += isolated - 1;
>  			cursor += isolated - 1;
>  		}
> +
> +		continue;
> +
> +strict_check:
> +		/* Abort isolation if the caller requested strict isolation */
> +		if (strict) {
> +			total_isolated = 0;
> +			goto out;
> +		}
>  	}
>  
>  	trace_mm_compaction_isolate_freepages(nr_scanned, total_isolated);
>  
> -	/*
> -	 * If strict isolation is requested by CMA then check that all the
> -	 * pages scanned were isolated. If there were any failures, 0 is
> -	 * returned and CMA will fail.
> -	 */
> -	if (strict && nr_scanned != total_isolated)
> -		total_isolated = 0;
> -
> +out:
>  	if (locked)
>  		spin_unlock_irqrestore(&cc->zone->lock, flags);
>  
> 


-- 
Péter
