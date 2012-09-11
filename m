Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678Ab2IKKTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 06:19:20 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46408 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab2IKKTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 06:19:17 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <504F0FE6.5090709@jp.fujitsu.com>
Date: Tue, 11 Sep 2012 19:18:14 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Yinghai Lu <yinghai@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "'FNST-Wen Congyang'" <wency@cn.fujitsu.com>
Subject: Re: [V4 PATCH 27/27] memory,hotplug: Don't modify the zone_start_pfn
 outside of zone_span_writelock()
References: <1347267558-6707-1-git-send-email-laijs@cn.fujitsu.com> <504E8874.5020605@jp.fujitsu.com> <504F07ED.3070502@cn.fujitsu.com>
In-Reply-To: <504F07ED.3070502@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lai,

2012/09/11 18:44, Lai Jiangshan wrote:
> On 09/11/2012 08:40 AM, Yasuaki Ishimatsu wrote:
>> Hi Lai,
>>
>> Using memory_online to hot-added node's memory, the following kernel messages
>> were shown. Is this a known issue?
>
> Fixed.
>
> Subject: Don't modify the zone_start_pfn outside of zone_span_writelock()
>
> Original __add_zone() and new online_movable/online_kernel
> maybe call sleep-able init_currently_empty_zone() to init wait_table,
>
> but this function also modifies the zone_start_pfn without lock.
> so we move this code out, and ensure the modification of zone_start_pfn is done
> with zone_span_writelock() held or booting.
>
> Since zone_start_pfn is not modified by init_currently_empty_zone()
> grow_zone_span() needs to be updated to be aware of empty zone.
>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Reported-by: Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
> Tested-by: Wen Congyang <wency@cn.fujitsu.com>

Applying the patch, the kernel messages disappeared. Thanks.
But I have a question. Using online_movable, the following messages are shown.

[  608.314608] Built 3 zonelists in Node order, mobility grouping on.  Total pages: 7844412
[  608.411478] Policy zone: Normal

I think memory is allocated to ZONE_MOVABLE by using online_movable.
So why is "Policy zone: Normal" shown? It should be "Policy zone: Movable"

Thanks,
Yasuaki Ishimatsu

> ---
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 3ad25f9..c26a4ea 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -201,7 +201,7 @@ static void grow_zone_span(struct zone *zone, unsigned long start_pfn,
>   	zone_span_writelock(zone);
>
>   	old_zone_end_pfn = zone->zone_start_pfn + zone->spanned_pages;
> -	if (start_pfn < zone->zone_start_pfn)
> +	if (!zone->zone_start_pfn || start_pfn < zone->zone_start_pfn)
>   		zone->zone_start_pfn = start_pfn;
>
>   	zone->spanned_pages = max(old_zone_end_pfn, end_pfn) -
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 009ac28..637b4f8 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3991,8 +3991,6 @@ int __meminit init_currently_empty_zone(struct zone *zone,
>   		return ret;
>   	pgdat->nr_zones = zone_idx(zone) + 1;
>
> -	zone->zone_start_pfn = zone_start_pfn;
> -
>   	mminit_dprintk(MMINIT_TRACE, "memmap_init",
>   			"Initialising map node %d zone %lu pfns %lu -> %lu\n",
>   			pgdat->node_id,
> @@ -4459,6 +4457,7 @@ static void __paginginit free_area_init_core(struct pglist_data *pgdat,
>   		ret = init_currently_empty_zone(zone, zone_start_pfn,
>   						size, MEMMAP_EARLY);
>   		BUG_ON(ret);
> +		zone->zone_start_pfn = zone_start_pfn;
>   		memmap_init(size, nid, j, zone_start_pfn);
>   		zone_start_pfn += size;
>   	}
>


