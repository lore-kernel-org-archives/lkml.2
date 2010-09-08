Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595Ab0IHGQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 02:16:57 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:34909 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757464Ab0IHGQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 02:16:54 -0400
Date: Wed, 8 Sep 2010 08:16:50 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 05/10] vmscan: Synchrounous lumpy reclaim use lock_page()
 instead trylock_page()
Message-ID: <20100908061650.GE20955@cmpxchg.org>
References: <1283770053-18833-1-git-send-email-mel@csn.ul.ie>
 <1283770053-18833-6-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283770053-18833-6-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 06, 2010 at 11:47:28AM +0100, Mel Gorman wrote:
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> With synchrounous lumpy reclaim, there is no reason to give up to reclaim
> pages even if page is locked. This patch uses lock_page() instead of
> trylock_page() in this case.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

> ---
>  mm/vmscan.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 5979850..79bd812 100644
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
