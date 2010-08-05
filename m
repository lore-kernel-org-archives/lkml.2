Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab0HEPM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 11:12:56 -0400
Received: from gir.skynet.ie ([193.1.99.77]:50642 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758937Ab0HEPMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 11:12:53 -0400
Date: Thu, 5 Aug 2010 16:12:37 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 3/7] vmscan: synchrounous lumpy reclaim use lock_page()
	instead trylock_page()
Message-ID: <20100805151237.GG25688@csn.ul.ie>
References: <20100805150624.31B7.A69D9226@jp.fujitsu.com> <20100805151304.31C0.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100805151304.31C0.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 03:13:39PM +0900, KOSAKI Motohiro wrote:
> When synchrounous lumpy reclaim, there is no reason to give up to
> reclaim pages even if page is locked. We use lock_page() instead
> trylock_page() in this case.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

The intention of the code looks fine so;

Acked-by: Mel Gorman <mel@csn.ul.ie>

Something like the following might just be easier on the eye but it's a
question of personal taste.

/* Returns true if the page is locked */
static bool lru_lock_page(struct page *page, enum pageout_io sync_writeback)
{
	if (likely(sync_writeback == PAGEOUT_IO_ASYNC))
		return trylock_page(page);

	lock_page(page);
	return true;
}

then replace trylock_page() with lru_lock_page(). The naming is vaguely
similar to other helpers like lru_to_page

> ---
>  mm/vmscan.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 1cdc3db..833b6ad 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -665,7 +665,9 @@ static unsigned long shrink_page_list(struct list_head *page_list,
>  		page = lru_to_page(page_list);
>  		list_del(&page->lru);
>  
> -		if (!trylock_page(page))
> +		if (sync_writeback == PAGEOUT_IO_SYNC)
> +			lock_page(page);
> +		else if (!trylock_page(page))
>  			goto keep;
>  
>  		VM_BUG_ON(PageActive(page));
> -- 
> 1.6.5.2
> 
> 
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
