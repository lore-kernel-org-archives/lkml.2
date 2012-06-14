Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab2FNBOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 21:14:09 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:59559 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab2FNBOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 21:14:08 -0400
X-AuditID: 9c93016f-b7c3cae000001954-3d-4fd93adbf237
To: undisclosed-recipients:;
Message-ID: <4FD93ADD.1030609@kernel.org>
Date: Thu, 14 Jun 2012 10:14:05 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Wanpeng Li <liwp.linux@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v2 1/2][BUGFIX] mm: do not use page_count without a page
 pin
References: <1339636334-9238-1-git-send-email-minchan@kernel.org>
In-Reply-To: <1339636334-9238-1-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Missing Bartlomiej, Sorry!

On 06/14/2012 10:12 AM, Minchan Kim wrote:

> d179e84ba fixed the problem[1] in vmscan.c but same problem is here.
> Let's fix it.
> 
> [1] http://comments.gmane.org/gmane.linux.kernel.mm/65844
> 
> I copy and paste d179e84ba's contents for description.
> 
> "It is unsafe to run page_count during the physical pfn scan because
> compound_head could trip on a dangling pointer when reading
> page->first_page if the compound page is being freed by another CPU."
> 
> * changelog from v1
>   - Add comment about skip tail page of THP - Andrea
>   - fix typo - Wanpeng Li
>   - based on next-20120613
> 
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Wanpeng Li <liwp.linux@gmail.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  mm/page_alloc.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 266f267..543cc2d 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5496,11 +5496,18 @@ __count_immobile_pages(struct zone *zone, struct page *page, int count)
>  			continue;
>  
>  		page = pfn_to_page(check);
> -		if (!page_count(page)) {
> +		/*
> +		 * We can't use page_count without pin a page
> +		 * because another CPU can free compound page.
> +		 * This check already skips compound tails of THP
> +		 * because their page->_count is zero at all time.
> +		 */
> +		if (!atomic_read(&page->_count)) {
>  			if (PageBuddy(page))
>  				iter += (1 << page_order(page)) - 1;
>  			continue;
>  		}
> +
>  		if (!PageLRU(page))
>  			found++;
>  		/*



-- 
Kind regards,
Minchan Kim
