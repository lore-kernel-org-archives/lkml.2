Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab2INGpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 02:45:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54203 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752852Ab2INGp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 02:45:28 -0400
X-IronPort-AV: E=Sophos;i="4.80,421,1344182400"; 
   d="scan'208";a="5844999"
Message-ID: <5052CF76.3070402@cn.fujitsu.com>
Date: Fri, 14 Sep 2012 14:32:22 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 1/2] mm: refactor out __alloc_contig_migrate_alloc
References: <1347414231-31451-1-git-send-email-minchan@kernel.org>
In-Reply-To: <1347414231-31451-1-git-send-email-minchan@kernel.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/14 14:26:08,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/14 14:26:14,
	Serialize complete at 2012/09/14 14:26:14
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 09/12/2012 09:43 AM, Minchan Kim Wrote:
> __alloc_contig_migrate_alloc can be used by memory-hotplug so
> refactor out(move + rename as a common name) it into
> page_isolation.c.
> 
> Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Cc: Michal Nazarewicz <mina86@mina86.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Wen Congyang <wency@cn.fujitsu.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
> 
> This patch is intended for preparing next bug fix patch.
> 
>  include/linux/page-isolation.h |    3 ++-
>  mm/page_alloc.c                |   14 +-------------
>  mm/page_isolation.c            |   11 +++++++++++
>  3 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/page-isolation.h b/include/linux/page-isolation.h
> index 105077a..1c82261 100644
> --- a/include/linux/page-isolation.h
> +++ b/include/linux/page-isolation.h
> @@ -37,6 +37,7 @@ int test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn);
>   */
>  int set_migratetype_isolate(struct page *page);
>  void unset_migratetype_isolate(struct page *page, unsigned migratetype);
> -
> +struct page *alloc_migrate_target(struct page *page, unsigned long private,
> +				int **resultp);
>  
>  #endif
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index a4ff74e..6716023 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5648,18 +5648,6 @@ static unsigned long pfn_max_align_up(unsigned long pfn)
>  				pageblock_nr_pages));
>  }
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
>  /* [start, end) must belong to a single zone. */
>  static int __alloc_contig_migrate_range(unsigned long start, unsigned long end)
>  {
> @@ -5700,7 +5688,7 @@ static int __alloc_contig_migrate_range(unsigned long start, unsigned long end)
>  		}
>  
>  		ret = migrate_pages(&cc.migratepages,
> -				    __alloc_contig_migrate_alloc,
> +				    alloc_migrate_target,
>  				    0, false, MIGRATE_SYNC);
>  	}
>  
> diff --git a/mm/page_isolation.c b/mm/page_isolation.c
> index 247d1f1..6936545 100644
> --- a/mm/page_isolation.c
> +++ b/mm/page_isolation.c
> @@ -233,3 +233,14 @@ int test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn)
>  	spin_unlock_irqrestore(&zone->lock, flags);
>  	return ret ? 0 : -EBUSY;
>  }
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

alloc_page() will use current task's memory policy. If we offline memory like this:
numactl -m n echo offline >/sys/devices/system/memory/memoryX/state # n is page's nid

It may trigger OOM event.

Thanks
Wen Congyang

