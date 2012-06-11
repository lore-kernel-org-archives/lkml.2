Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab2FKHWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 03:22:30 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36910 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab2FKHW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 03:22:28 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FD59C31.6000606@jp.fujitsu.com>
Date: Mon, 11 Jun 2012 16:20:17 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] mm: do not use page_count without a page pin
References: <1339373872-31969-1-git-send-email-minchan@kernel.org>
In-Reply-To: <1339373872-31969-1-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/11 9:17), Minchan Kim wrote:
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
> Cc: Andrea Arcangeli<aarcange@redhat.com>
> Cc: Mel Gorman<mgorman@suse.de>
> Cc: Michal Hocko<mhocko@suse.cz>
> Cc: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Minchan Kim<minchan@kernel.org>
> ---
>   mm/page_alloc.c |    6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 266f267..019c4fe 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5496,7 +5496,11 @@ __count_immobile_pages(struct zone *zone, struct page *page, int count)
>   			continue;
> 
>   		page = pfn_to_page(check);
> -		if (!page_count(page)) {
> +		/*
> +		 * We can't use page_count withou pin a page
> +		 * because another CPU can free compound page.
> +		 */
> +		if (!atomic_read(&page->_count)) {
>   			if (PageBuddy(page))
>   				iter += (1<<  page_order(page)) - 1;
>   			continue;
Nice Catch.

Other than the comment fix already pointed out..
Hmm...BTW, it seems this __count_xxx doesn't have any code for THP/Hugepage..
so, we need more fixes for better code, I think.
Hmm, Don't we need !PageTail() check and 'skip thp' code ?

Thanks,
-Kame

