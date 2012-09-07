Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123Ab2IGG0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:26:15 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53823 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab2IGG0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:26:14 -0400
MIME-Version: 1.0
In-Reply-To: <1346829962-31989-4-git-send-email-minchan@kernel.org>
References: <1346829962-31989-1-git-send-email-minchan@kernel.org>
	<1346829962-31989-4-git-send-email-minchan@kernel.org>
Date: Fri, 7 Sep 2012 14:26:13 +0800
Message-ID: <CAN6t85S2C4WU9pNG4uAw-NBS=FPBUYqCXPFPLxHPBv70ht31Qw@mail.gmail.com>
Subject: Re: [PATCH 3/3] memory-hotplug: bug fix race between isolation and allocation
From: jencce zhou <jencce2002@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Xishi Qiu <qiuxishi@huawei.com>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/5 Minchan Kim <minchan@kernel.org>:
> Like below, memory-hotplug makes race between page-isolation
> and page-allocation so it can hit BUG_ON in __offline_isolated_pages.
>
>         CPU A                                   CPU B
>
> start_isolate_page_range
> set_migratetype_isolate
> spin_lock_irqsave(zone->lock)
>
>                                 free_hot_cold_page(Page A)
>                                 /* without zone->lock */
>                                 migratetype = get_pageblock_migratetype(Page A);
>                                 /*
>                                  * Page could be moved into MIGRATE_MOVABLE
>                                  * of per_cpu_pages
>                                  */
>                                 list_add_tail(&page->lru, &pcp->lists[migratetype]);
>
> set_pageblock_isolate
here
> move_freepages_block
> drain_all_pages
>
>                                 /* Page A could be in MIGRATE_MOVABLE of free_list. */
             why ?  should it has been moved to MIGRATE_ISOLATE list ?
>
> check_pages_isolated
> __test_page_isolated_in_pageblock
> /*
>  * We can't catch freed page which
>  * is free_list[MIGRATE_MOVABLE]
>  */
> if (PageBuddy(page A))
>         pfn += 1 << page_order(page A);
>
>                                 /* So, Page A could be allocated */
>
> __offline_isolated_pages
> /*
>  * BUG_ON hit or offline page
>  * which is used by someone
>  */
> BUG_ON(!PageBuddy(page A));
>
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  mm/page_isolation.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/mm/page_isolation.c b/mm/page_isolation.c
> index acf65a7..4699d1f 100644
> --- a/mm/page_isolation.c
> +++ b/mm/page_isolation.c
> @@ -196,8 +196,11 @@ __test_page_isolated_in_pageblock(unsigned long pfn, unsigned long end_pfn)
>                         continue;
>                 }
>                 page = pfn_to_page(pfn);
> -               if (PageBuddy(page))
> +               if (PageBuddy(page)) {
> +                       if (get_page_migratetype(page) != MIGRATE_ISOLATE)
> +                               break;
>                         pfn += 1 << page_order(page);
> +               }
>                 else if (page_count(page) == 0 &&
>                                 get_page_migratetype(page) == MIGRATE_ISOLATE)
>                         pfn += 1;
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
