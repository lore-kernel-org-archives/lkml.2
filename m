Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab0K2Adq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 19:33:46 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42071 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab0K2Adp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 19:33:45 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH v2 1/3] deactivate invalidated pages
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Ben Gamari <bgamari.foss@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>,
        Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <7b50614882592047dfd96f6ca2bb2d0baa8f5367.1290956059.git.minchan.kim@gmail.com>
References: <7b50614882592047dfd96f6ca2bb2d0baa8f5367.1290956059.git.minchan.kim@gmail.com>
Message-Id: <20101129090514.829C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 29 Nov 2010 09:33:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ---
>  mm/swap.c |   84 +++++++++++++++++++++++++++++++++++++++++++++---------------
>  1 files changed, 63 insertions(+), 21 deletions(-)
> 
> diff --git a/mm/swap.c b/mm/swap.c
> index 31f5ec4..345eca1 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -268,10 +268,65 @@ void add_page_to_unevictable_list(struct page *page)
>  	spin_unlock_irq(&zone->lru_lock);
>  }
>  
> -static void __pagevec_lru_deactive(struct pagevec *pvec)
> +/*
> + * This function is used by invalidate_mapping_pages.
> + * If the page can't be invalidated, this function moves the page
> + * into inative list's head or tail to reclaim ASAP and evict
> + * working set page.
> + *
> + * PG_reclaim means when the page's writeback completes, the page
> + * will move into tail of inactive for reclaiming ASAP.
> + *
> + * 1. active, mapped page -> inactive, head
> + * 2. active, dirty/writeback page -> inactive, head, PG_reclaim
> + * 3. inactive, mapped page -> none
> + * 4. inactive, dirty/writeback page -> inactive, head, PG_reclaim
> + * 5. others -> none
> + *
> + * In 4, why it moves inactive's head, the VM expects the page would
> + * be writeout by flusher. The flusher's writeout is much effective than
> + * reclaimer's random writeout.
> + */
> +static void __lru_deactivate(struct page *page, struct zone *zone)
>  {
> -	int i, lru, file;
> +	int lru, file;
> +	int active = 0;
> +
> +	if (!PageLRU(page))
> +		return;
> +
> +	if (PageActive(page))
> +		active = 1;
> +	/* Some processes are using the page */
> +	if (page_mapped(page) && !active)
> +		return;
> +
> +	else if (PageWriteback(page)) {
> +		SetPageReclaim(page);
> +		/* Check race with end_page_writeback */
> +		if (!PageWriteback(page))
> +			ClearPageReclaim(page);
> +	} else if (PageDirty(page))
> +		SetPageReclaim(page);
> +
> +	file = page_is_file_cache(page);
> +	lru = page_lru_base_type(page);
> +	del_page_from_lru_list(zone, page, lru + active);
> +	ClearPageActive(page);
> +	ClearPageReferenced(page);
> +	add_page_to_lru_list(zone, page, lru);
> +	if (active)
> +		__count_vm_event(PGDEACTIVATE);
> +
> +	update_page_reclaim_stat(zone, page, file, 0);
> +}

I don't like this change because fadvise(DONT_NEED) is rarely used
function and this PG_reclaim trick doesn't improve so much. In the
other hand, It increase VM state mess.

However, I haven't found any fault and unworked reason in this patch.


