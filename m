Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab2I1Hhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 03:37:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49330 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755299Ab2I1HhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 03:37:18 -0400
X-IronPort-AV: E=Sophos;i="4.80,501,1344182400"; 
   d="scan'208";a="5933028"
Message-ID: <50655433.7000108@cn.fujitsu.com>
Date: Fri, 28 Sep 2012 15:39:31 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, Xishi Qiu <qiuxishi@huawei.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] memory_hotplug: Don't modify the zone_start_pfn outside
 of zone_span_writelock()
References: <1348728470-5580-1-git-send-email-laijs@cn.fujitsu.com> <1348728470-5580-4-git-send-email-laijs@cn.fujitsu.com> <5064D391.5080102@gmail.com>
In-Reply-To: <5064D391.5080102@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/28 15:37:25,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/28 15:37:26,
	Serialize complete at 2012/09/28 15:37:26
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, KOSAKI

On 09/28/2012 06:30 AM, KOSAKI Motohiro wrote:
> (9/27/12 2:47 AM), Lai Jiangshan wrote:
>> The __add_zone() maybe call sleep-able init_currently_empty_zone()
>> to init wait_table,
> 
> This doesn't explain why sleepable is critical important. I think sleepable
> is jsut unrelated. The fact is only: to write zone->zone_start_pfn require
> zone_span_writelock, but init_currently_empty_zone() doesn't take it.

You are right, sleepable is not critical important, but the lock is critical.

I am Sorry that I added "sleep-able" and misled guys.

Actually I want to say:

1) to write zone->zone_start_pfn require zone_span_writelock
2) init_currently_empty_zone() is sleepable, so we can't use zone_span_writelock()
   protect the whole init_currently_empty_zone().
3) so we have to move the modification code out of init_currently_empty_zone()
   as this patch does.

> 
> 
>>
>> But this function also modifies the zone_start_pfn without any lock.
>> It is bugy.
> 
> buggy?
> 
> 
>> So we move this modification out, and we ensure the modification
>> of zone_start_pfn is only done with zone_span_writelock() held or in booting.
>>
>> Since zone_start_pfn is not modified by init_currently_empty_zone()
>> grow_zone_span() needs to check zone_start_pfn before update it.
>>
>> CC: Mel Gorman <mel@csn.ul.ie>
>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>> Reported-by: Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
>> Tested-by: Wen Congyang <wency@cn.fujitsu.com>
>> ---
>>  mm/memory_hotplug.c |    2 +-
>>  mm/page_alloc.c     |    3 +--
>>  2 files changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index b62d429b..790561f 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -205,7 +205,7 @@ static void grow_zone_span(struct zone *zone, unsigned long start_pfn,
>>  	zone_span_writelock(zone);
>>  
>>  	old_zone_end_pfn = zone->zone_start_pfn + zone->spanned_pages;
>> -	if (start_pfn < zone->zone_start_pfn)
>> +	if (!zone->zone_start_pfn || start_pfn < zone->zone_start_pfn)
>>  		zone->zone_start_pfn = start_pfn;
> 
> Wrong. zone->zone_start_pfn==0 may be valid pfn. You shouldn't assume it is uninitialized
> value.

Good catch, I will use zone->spanned_pages instead.


Thanks,
Lai

> 
> 
>>  
>>  	zone->spanned_pages = max(old_zone_end_pfn, end_pfn) -
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index c13ea75..2545013 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -3997,8 +3997,6 @@ int __meminit init_currently_empty_zone(struct zone *zone,
>>  		return ret;
>>  	pgdat->nr_zones = zone_idx(zone) + 1;
>>  
>> -	zone->zone_start_pfn = zone_start_pfn;
>> -
>>  	mminit_dprintk(MMINIT_TRACE, "memmap_init",
>>  			"Initialising map node %d zone %lu pfns %lu -> %lu\n",
>>  			pgdat->node_id,
>> @@ -4465,6 +4463,7 @@ static void __paginginit free_area_init_core(struct pglist_data *pgdat,
>>  		ret = init_currently_empty_zone(zone, zone_start_pfn,
>>  						size, MEMMAP_EARLY);
>>  		BUG_ON(ret);
>> +		zone->zone_start_pfn = zone_start_pfn;
>>  		memmap_init(size, nid, j, zone_start_pfn);
>>  		zone_start_pfn += size;
>>  	}
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

