Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759777Ab2IGDwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 23:52:51 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60507 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759443Ab2IGDwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 23:52:50 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <50496F7E.4080309@jp.fujitsu.com>
Date: Fri, 7 Sep 2012 12:52:30 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Xishi Qiu <qiuxishi@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>
Subject: Re: [PATCH v3 3/4] memory-hotplug: bug fix race between isolation
 and allocation
References: <1346978372-17903-1-git-send-email-minchan@kernel.org> <1346978372-17903-4-git-send-email-minchan@kernel.org>
In-Reply-To: <1346978372-17903-4-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/09/07 9:39, Minchan Kim wrote:
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
> This patch checks page's migratetype in freelist in __test_page_isolated_in_pageblock.
> So now __test_page_isolated_in_pageblock can check the page caused by above race and
> can fail of memory offlining.
> 
> * from v2
>    * Add Acked-by of Kame
> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasuaki Ishimatsu

> ---
>   mm/page_isolation.c |    5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/page_isolation.c b/mm/page_isolation.c
> index 87a7929..7ba7405 100644
> --- a/mm/page_isolation.c
> +++ b/mm/page_isolation.c
> @@ -193,8 +193,11 @@ __test_page_isolated_in_pageblock(unsigned long pfn, unsigned long end_pfn)
>   			continue;
>   		}
>   		page = pfn_to_page(pfn);
> -		if (PageBuddy(page))
> +		if (PageBuddy(page)) {
> +			if (get_freepage_migratetype(page) != MIGRATE_ISOLATE)
> +				break;
>   			pfn += 1 << page_order(page);
> +		}
>   		else if (page_count(page) == 0 &&
>   			get_freepage_migratetype(page) == MIGRATE_ISOLATE)
>   			pfn += 1;
> 


