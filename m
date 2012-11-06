Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644Ab2KFKXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 05:23:47 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44770 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab2KFKXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 05:23:45 -0500
Message-ID: <5098E52C.7080203@googlemail.com>
Date: Tue, 06 Nov 2012 10:23:40 +0000
From: Chris Clayton <chris2553@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121030 Thunderbird/16.0.2
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@huawei.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Jianguo Wu <wujianguo@huawei.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix a regression with HIGHMEM introduced by changeset
 7f1290f2f2a4d
References: <1352165517-9732-1-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1352165517-9732-1-git-send-email-jiang.liu@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/06/12 01:31, Jiang Liu wrote:
> Changeset 7f1290f2f2 tries to fix a issue when calculating
> zone->present_pages, but it causes a regression to 32bit systems with
> HIGHMEM. With that changeset, function reset_zone_present_pages()
> resets all zone->present_pages to zero, and fixup_zone_present_pages()
> is called to recalculate zone->present_pages when boot allocator frees
> core memory pages into buddy allocator. Because highmem pages are not
> freed by bootmem allocator, all highmem zones' present_pages becomes
> zero.
>
> Actually there's no need to recalculate present_pages for highmem zone
> because bootmem allocator never allocates pages from them. So fix the
> regression by skipping highmem in function reset_zone_present_pages()
> and fixup_zone_present_pages().
>
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
> Reported-by: Maciej Rutecki <maciej.rutecki@gmail.com>
> Tested-by: Maciej Rutecki <maciej.rutecki@gmail.com>
> Cc: Chris Clayton <chris2553@googlemail.com>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
>
> ---
>
> Hi Maciej,
> 	Thanks for reporting and bisecting. We have analyzed the regression
> and worked out a patch for it. Could you please help to verify whether it
> fix the regression?
> 	Thanks!
> 	Gerry
>

Thanks Gerry.

I've applied this patch to 3.7.0-rc4 and can confirm that it fixes the 
problem I had with my laptop failing to resume after a suspend to disk.

Tested-by: Chris Clayton <chris2553@googlemail.com>

> ---
>   mm/page_alloc.c |    8 +++++---
>   1 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 5b74de6..2311f15 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6108,7 +6108,8 @@ void reset_zone_present_pages(void)
>   	for_each_node_state(nid, N_HIGH_MEMORY) {
>   		for (i = 0; i < MAX_NR_ZONES; i++) {
>   			z = NODE_DATA(nid)->node_zones + i;
> -			z->present_pages = 0;
> +			if (!is_highmem(z))
> +				z->present_pages = 0;
>   		}
>   	}
>   }
> @@ -6123,10 +6124,11 @@ void fixup_zone_present_pages(int nid, unsigned long start_pfn,
>
>   	for (i = 0; i < MAX_NR_ZONES; i++) {
>   		z = NODE_DATA(nid)->node_zones + i;
> +		if (is_highmem(z))
> +			continue;
> +
>   		zone_start_pfn = z->zone_start_pfn;
>   		zone_end_pfn = zone_start_pfn + z->spanned_pages;
> -
> -		/* if the two regions intersect */
>   		if (!(zone_start_pfn >= end_pfn	|| zone_end_pfn <= start_pfn))
>   			z->present_pages += min(end_pfn, zone_end_pfn) -
>   					    max(start_pfn, zone_start_pfn);
>
