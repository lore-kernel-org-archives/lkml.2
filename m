Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab0HWXR5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 19:17:57 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52607 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab0HWXRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 19:17:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 3/3] mm: page allocator: Drain per-cpu lists after direct reclaim allocation fails
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1282550442-15193-4-git-send-email-mel@csn.ul.ie>
References: <1282550442-15193-1-git-send-email-mel@csn.ul.ie> <1282550442-15193-4-git-send-email-mel@csn.ul.ie>
Message-Id: <20100824081531.6035.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 24 Aug 2010 08:17:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When under significant memory pressure, a process enters direct reclaim
> and immediately afterwards tries to allocate a page. If it fails and no
> further progress is made, it's possible the system will go OOM. However,
> on systems with large amounts of memory, it's possible that a significant
> number of pages are on per-cpu lists and inaccessible to the calling
> process. This leads to a process entering direct reclaim more often than
> it should increasing the pressure on the system and compounding the problem.
> 
> This patch notes that if direct reclaim is making progress but
> allocations are still failing that the system is already under heavy
> pressure. In this case, it drains the per-cpu lists and tries the
> allocation a second time before continuing.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  mm/page_alloc.c |   20 ++++++++++++++++----
>  1 files changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index bbaa959..750e1dc 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1847,6 +1847,7 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
>  	struct page *page = NULL;
>  	struct reclaim_state reclaim_state;
>  	struct task_struct *p = current;
> +	bool drained = false;
>  
>  	cond_resched();
>  
> @@ -1865,14 +1866,25 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
>  
>  	cond_resched();
>  
> -	if (order != 0)
> -		drain_all_pages();
> +	if (unlikely(!(*did_some_progress)))
> +		return NULL;
>  
> -	if (likely(*did_some_progress))
> -		page = get_page_from_freelist(gfp_mask, nodemask, order,
> +retry:
> +	page = get_page_from_freelist(gfp_mask, nodemask, order,
>  					zonelist, high_zoneidx,
>  					alloc_flags, preferred_zone,
>  					migratetype);
> +
> +	/*
> +	 * If an allocation failed after direct reclaim, it could be because
> +	 * pages are pinned on the per-cpu lists. Drain them and try again
> +	 */
> +	if (!page && !drained) {
> +		drain_all_pages();
> +		drained = true;
> +		goto retry;
> +	}
> +
>  	return page;

I haven't read all of this patch series. (iow, this mail is luckly on top
of my mail box now) but at least I think this one is correct and good.

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>







