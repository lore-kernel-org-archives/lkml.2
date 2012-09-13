Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab2IMB5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 21:57:36 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34799 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab2IMB5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 21:57:34 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <50513D6D.3030609@jp.fujitsu.com>
Date: Thu, 13 Sep 2012 10:57:01 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] mm: refactor out __alloc_contig_migrate_alloc
References: <1347414231-31451-1-git-send-email-minchan@kernel.org>
In-Reply-To: <1347414231-31451-1-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/09/12 10:43, Minchan Kim wrote:
> __alloc_contig_migrate_alloc can be used by memory-hotplug so
> refactor out(move + rename as a common name) it into
> page_isolation.c.
> 
> Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasuaki Ishimatsu

> Cc: Michal Nazarewicz <mina86@mina86.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Wen Congyang <wency@cn.fujitsu.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
> 
> This patch is intended for preparing next bug fix patch.
> 
>   include/linux/page-isolation.h |    3 ++-
>   mm/page_alloc.c                |   14 +-------------
>   mm/page_isolation.c            |   11 +++++++++++
>   3 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/page-isolation.h b/include/linux/page-isolation.h
> index 105077a..1c82261 100644
> --- a/include/linux/page-isolation.h
> +++ b/include/linux/page-isolation.h
> @@ -37,6 +37,7 @@ int test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn);
>    */
>   int set_migratetype_isolate(struct page *page);
>   void unset_migratetype_isolate(struct page *page, unsigned migratetype);
> -
> +struct page *alloc_migrate_target(struct page *page, unsigned long private,
> +				int **resultp);
>   
>   #endif
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index a4ff74e..6716023 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5648,18 +5648,6 @@ static unsigned long pfn_max_align_up(unsigned long pfn)
>   				pageblock_nr_pages));
>   }
>   
> -static struct page *
> -__alloc_contig_migrate_alloc(struct page *page, unsigned long private,
> -			     int **resultp)
> -{
> -	gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE;
> -
> -	if (PageHighMem(page))
> -		gfp_mask |= __GFP_HIGHMEM;
> -
> -	return alloc_page(gfp_mask);
> -}
> -
>   /* [start, end) must belong to a single zone. */
>   static int __alloc_contig_migrate_range(unsigned long start, unsigned long end)
>   {
> @@ -5700,7 +5688,7 @@ static int __alloc_contig_migrate_range(unsigned long start, unsigned long end)
>   		}
>   
>   		ret = migrate_pages(&cc.migratepages,
> -				    __alloc_contig_migrate_alloc,
> +				    alloc_migrate_target,
>   				    0, false, MIGRATE_SYNC);
>   	}
>   
> diff --git a/mm/page_isolation.c b/mm/page_isolation.c
> index 247d1f1..6936545 100644
> --- a/mm/page_isolation.c
> +++ b/mm/page_isolation.c
> @@ -233,3 +233,14 @@ int test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn)
>   	spin_unlock_irqrestore(&zone->lock, flags);
>   	return ret ? 0 : -EBUSY;
>   }
> +
> +struct page *alloc_migrate_target(struct page *page, unsigned long private,
> +                             int **resultp)
> +{
> +        gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE;
> +
> +        if (PageHighMem(page))
> +                gfp_mask |= __GFP_HIGHMEM;
> +
> +        return alloc_page(gfp_mask);
> +}
> 


