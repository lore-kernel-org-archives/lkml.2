Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab2G0KZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 06:25:22 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34068 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab2G0KZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 06:25:19 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <50126BF8.3070901@jp.fujitsu.com>
Date: Fri, 27 Jul 2012 19:22:48 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, lliubbo@gmail.com
Subject: Re: [RESEND RFC 3/3] memory-hotplug: bug fix race between isolation
 and allocation
References: <1343004482-6916-1-git-send-email-minchan@kernel.org> <1343004482-6916-4-git-send-email-minchan@kernel.org>
In-Reply-To: <1343004482-6916-4-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/07/23 9:48), Minchan Kim wrote:
> Like below, memory-hotplug makes race between page-isolation
> and page-allocation so it can hit BUG_ON in __offline_isolated_pages.
> 
> 	CPU A					CPU B
> 
> start_isolate_page_range
> set_migratetype_isolate
> spin_lock_irqsave(zone->lock)
> 
> 				free_hot_cold_page(Page A)
> 				/* without zone->lock */
> 				migratetype = get_pageblock_migratetype(Page A);
> 				/*
> 				 * Page could be moved into MIGRATE_MOVABLE
> 				 * of per_cpu_pages
> 				 */
> 				list_add_tail(&page->lru, &pcp->lists[migratetype]);
> 
> set_pageblock_isolate
> move_freepages_block
> drain_all_pages
> 
> 				/* Page A could be in MIGRATE_MOVABLE of free_list. */
> 
> check_pages_isolated
> __test_page_isolated_in_pageblock
> /*
>   * We can't catch freed page which
>   * is free_list[MIGRATE_MOVABLE]
>   */
> if (PageBuddy(page A))
> 	pfn += 1 << page_order(page A);
> 
> 				/* So, Page A could be allocated */
> 
> __offline_isolated_pages
> /*
>   * BUG_ON hit or offline page
>   * which is used by someone
>   */
> BUG_ON(!PageBuddy(page A));
> 
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Ah, hm. Then, you say the page in MIGRATE_MOVABLE will not be isolated
and may be used again.


> ---
> I found this problem during code review so please confirm it.
> Kame?
> 
>   mm/page_isolation.c |    5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/page_isolation.c b/mm/page_isolation.c
> index acf65a7..4699d1f 100644
> --- a/mm/page_isolation.c
> +++ b/mm/page_isolation.c
> @@ -196,8 +196,11 @@ __test_page_isolated_in_pageblock(unsigned long pfn, unsigned long end_pfn)
>   			continue;
>   		}
>   		page = pfn_to_page(pfn);
> -		if (PageBuddy(page))
> +		if (PageBuddy(page)) {
> +			if (get_page_migratetype(page) != MIGRATE_ISOLATE)
> +				break;

Doesn't this work enough ? The problem is MIGRATE_TYPE and list_head mis-match.

Thanks,
-Kame
 


