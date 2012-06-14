Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab2FNBPM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 21:15:12 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46852 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab2FNBPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 21:15:11 -0400
X-AuditID: 9c93016f-b7c3cae000001954-38-4fd93b1d44f2
To: undisclosed-recipients:;
Message-ID: <4FD93B1F.3010909@kernel.org>
Date: Thu, 14 Jun 2012 10:15:11 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v2 2/2] mm: clean up __count_immobile_pages
References: <1339636334-9238-1-git-send-email-minchan@kernel.org> <1339636334-9238-2-git-send-email-minchan@kernel.org>
In-Reply-To: <1339636334-9238-2-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Missing Bartlomiej, Sorry!

On 06/14/2012 10:12 AM, Minchan Kim wrote:

> __count_immobile_pages naming is rather awkward.
> This patch changes function name more clear and add comment.
> 
> * changelog from v1
>   - write down page flag race in function comment
>   - commit change log change
> 
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Michal Hocko <mhocko@suse.cz>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  mm/page_alloc.c |   34 ++++++++++++++++++----------------
>  1 file changed, 18 insertions(+), 16 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 543cc2d..dc7f8c5 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5467,26 +5467,28 @@ void set_pageblock_flags_group(struct page *page, unsigned long flags,
>  }
>  
>  /*
> - * This is designed as sub function...plz see page_isolation.c also.
> - * set/clear page block's type to be ISOLATE.
> - * page allocater never alloc memory from ISOLATE block.
> + * This function checks whether pageblock includes unmovable pages or not.
> + * If @count is not zero, it is okay to include less @count unmovable pages
> + *
> + * PageLRU check wihtout isolation or lru_lock could race so that
> + * MIGRATE_MOVABLE block might include unmovable pages. It means you can't
> + * expect this function should be exact.
>   */
> -
> -static int
> -__count_immobile_pages(struct zone *zone, struct page *page, int count)
> +static bool
> +__has_unmovable_pages(struct zone *zone, struct page *page, int count)
>  {
>  	unsigned long pfn, iter, found;
>  	int mt;
>  
>  	/*
>  	 * For avoiding noise data, lru_add_drain_all() should be called
> -	 * If ZONE_MOVABLE, the zone never contains immobile pages
> +	 * If ZONE_MOVABLE, the zone never contains unmovable pages
>  	 */
>  	if (zone_idx(zone) == ZONE_MOVABLE)
> -		return true;
> +		return false;
>  	mt = get_pageblock_migratetype(page);
>  	if (mt == MIGRATE_MOVABLE || is_migrate_cma(mt))
> -		return true;
> +		return false;
>  
>  	pfn = page_to_pfn(page);
>  	for (found = 0, iter = 0; iter < pageblock_nr_pages; iter++) {
> @@ -5524,9 +5526,9 @@ __count_immobile_pages(struct zone *zone, struct page *page, int count)
>  		 * page at boot.
>  		 */
>  		if (found > count)
> -			return false;
> +			return true;
>  	}
> -	return true;
> +	return false;
>  }
>  
>  bool is_pageblock_removable_nolock(struct page *page)
> @@ -5550,7 +5552,7 @@ bool is_pageblock_removable_nolock(struct page *page)
>  			zone->zone_start_pfn + zone->spanned_pages <= pfn)
>  		return false;
>  
> -	return __count_immobile_pages(zone, page, 0);
> +	return !__has_unmovable_pages(zone, page, 0);
>  }
>  
>  int set_migratetype_isolate(struct page *page)
> @@ -5589,12 +5591,12 @@ int set_migratetype_isolate(struct page *page)
>  	 * FIXME: Now, memory hotplug doesn't call shrink_slab() by itself.
>  	 * We just check MOVABLE pages.
>  	 */
> -	if (__count_immobile_pages(zone, page, arg.pages_found))
> +	if (!__has_unmovable_pages(zone, page, arg.pages_found))
>  		ret = 0;
> -
>  	/*
> -	 * immobile means "not-on-lru" paes. If immobile is larger than
> -	 * removable-by-driver pages reported by notifier, we'll fail.
> +	 * Unmovable means "not-on-lru" pages. If Unmovable pages are
> +	 * larger than removable-by-driver pages reported by notifier,
> +	 * we'll fail.
>  	 */
>  
>  out:



-- 
Kind regards,
Minchan Kim
