Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab0DPGaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 02:30:11 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60772 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab0DPGaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 02:30:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 08/10] vmscan: Setup pagevec as late as possible in shrink_inactive_list()
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>,
       Dave Chinner <david@fromorbit.com>, Andi Kleen <andi@firstfloor.org>,
       Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <1271352103-2280-9-git-send-email-mel@csn.ul.ie>
References: <1271352103-2280-1-git-send-email-mel@csn.ul.ie> <1271352103-2280-9-git-send-email-mel@csn.ul.ie>
Message-Id: <20100416115215.27A4.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 16 Apr 2010 15:30:00 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> shrink_inactive_list() sets up a pagevec to release unfreeable pages. It
> uses significant amounts of stack doing this. This patch splits
> shrink_inactive_list() to take the stack usage out of the main path so
> that callers to writepage() do not contain an unused pagevec on the
> stack.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  mm/vmscan.c |   93 +++++++++++++++++++++++++++++++++-------------------------
>  1 files changed, 53 insertions(+), 40 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index a232ad6..9bc1ede 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1120,6 +1120,54 @@ static int too_many_isolated(struct zone *zone, int file,
>  }
>  
>  /*
> + * TODO: Try merging with migrations version of putback_lru_pages
> + */

I also think this stuff need more cleanups. but this patch works and
no downside. So, Let's merge this at first.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


but please fix Dave's pointed one.


> +static noinline void putback_lru_pages(struct zone *zone,
> +				struct zone_reclaim_stat *reclaim_stat,
> +				unsigned long nr_anon, unsigned long nr_file,
> + 				struct list_head *page_list)
> +{
> +	struct page *page;
> +	struct pagevec pvec;
> +
> +	pagevec_init(&pvec, 1);
> +
> +	/*
> +	 * Put back any unfreeable pages.
> +	 */
> +	spin_lock(&zone->lru_lock);
> +	while (!list_empty(page_list)) {
> +		int lru;
> +		page = lru_to_page(page_list);
> +		VM_BUG_ON(PageLRU(page));
> +		list_del(&page->lru);
> +		if (unlikely(!page_evictable(page, NULL))) {
> +			spin_unlock_irq(&zone->lru_lock);
> +			putback_lru_page(page);
> +			spin_lock_irq(&zone->lru_lock);
> +			continue;
> +		}
> +		SetPageLRU(page);
> +		lru = page_lru(page);
> +		add_page_to_lru_list(zone, page, lru);
> +		if (is_active_lru(lru)) {
> +			int file = is_file_lru(lru);
> +			reclaim_stat->recent_rotated[file]++;
> +		}
> +		if (!pagevec_add(&pvec, page)) {
> +			spin_unlock_irq(&zone->lru_lock);
> +			__pagevec_release(&pvec);
> +			spin_lock_irq(&zone->lru_lock);
> +		}
> +	}
> +	__mod_zone_page_state(zone, NR_ISOLATED_ANON, -nr_anon);
> +	__mod_zone_page_state(zone, NR_ISOLATED_FILE, -nr_file);
> +
> +	spin_unlock_irq(&zone->lru_lock);
> +	pagevec_release(&pvec);
> +}
> +
> +/*
>   * shrink_inactive_list() is a helper for shrink_zone().  It returns the number
>   * of reclaimed pages
>   */
> @@ -1128,12 +1176,10 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
>  			int file)
>  {
>  	LIST_HEAD(page_list);
> -	struct pagevec pvec;
>  	unsigned long nr_scanned;
>  	unsigned long nr_reclaimed = 0;
>  	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
>  	int lumpy_reclaim = 0;
> -	struct page *page;
>  	unsigned long nr_taken;
>  	unsigned long nr_active;
>  	unsigned int count[NR_LRU_LISTS] = { 0, };
> @@ -1160,8 +1206,6 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
>  	else if (sc->order && sc->priority < DEF_PRIORITY - 2)
>  		lumpy_reclaim = 1;
>  
> -	pagevec_init(&pvec, 1);
> -
>  	lru_add_drain();
>  	spin_lock_irq(&zone->lru_lock);
>  	nr_taken = sc->isolate_pages(nr_to_scan,
> @@ -1177,8 +1221,10 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
>  			__count_zone_vm_events(PGSCAN_DIRECT, zone, nr_scanned);
>  	}
>  
> -	if (nr_taken == 0)
> -		goto done;
> +	if (nr_taken == 0) {
> +		spin_unlock_irq(&zone->lru_lock);
> +		return 0;
> +	}
>  
>  	nr_active = clear_active_flags(&page_list, count);
>  	__count_vm_events(PGDEACTIVATE, nr_active);
> @@ -1229,40 +1275,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
>  		__count_vm_events(KSWAPD_STEAL, nr_reclaimed);
>  	__count_zone_vm_events(PGSTEAL, zone, nr_reclaimed);
>  
> -	spin_lock(&zone->lru_lock);
> -	/*
> -	 * Put back any unfreeable pages.
> -	 */
> -	while (!list_empty(&page_list)) {
> -		int lru;
> -		page = lru_to_page(&page_list);
> -		VM_BUG_ON(PageLRU(page));
> -		list_del(&page->lru);
> -		if (unlikely(!page_evictable(page, NULL))) {
> -			spin_unlock_irq(&zone->lru_lock);
> -			putback_lru_page(page);
> -			spin_lock_irq(&zone->lru_lock);
> -			continue;
> -		}
> -		SetPageLRU(page);
> -		lru = page_lru(page);
> -		add_page_to_lru_list(zone, page, lru);
> -		if (is_active_lru(lru)) {
> -			int file = is_file_lru(lru);
> -			reclaim_stat->recent_rotated[file]++;
> -		}
> -		if (!pagevec_add(&pvec, page)) {
> -			spin_unlock_irq(&zone->lru_lock);
> -			__pagevec_release(&pvec);
> -			spin_lock_irq(&zone->lru_lock);
> -		}
> -	}
> -	__mod_zone_page_state(zone, NR_ISOLATED_ANON, -nr_anon);
> -	__mod_zone_page_state(zone, NR_ISOLATED_FILE, -nr_file);
> -
> -done:
> -	spin_unlock_irq(&zone->lru_lock);
> -	pagevec_release(&pvec);
> +	putback_lru_pages(zone, reclaim_stat, nr_anon, nr_file, &page_list);
>  	return nr_reclaimed;
>  }
>  
> -- 
> 1.6.5
> 



