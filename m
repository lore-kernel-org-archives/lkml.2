Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab0ENGgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 02:36:42 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:62289 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab0ENGgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 02:36:38 -0400
Message-ID: <4BECEF07.8020700@oracle.com>
Date: Thu, 13 May 2010 23:34:47 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 11/35] lmb: Add find_memory_core_early()
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>	 <1273796396-29649-12-git-send-email-yinghai@kernel.org> <1273804173.21352.386.camel@pasglop>
In-Reply-To: <1273804173.21352.386.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090203.4BECEF62.005F:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2010 07:29 PM, Benjamin Herrenschmidt wrote:
> On Thu, 2010-05-13 at 17:19 -0700, Yinghai Lu wrote:
>> According to node range in early_node_map[] with __lmb_find_area
>> to find free range.
>>
>> Will be used by lmb_find_area_node()
>>
>> lmb_find_area_node will be used to find right buffer for NODE_DATA
> 
> The prototype for this has nothing to do in lmb.h under that name at
> least.

it is calling __lmb_find_area()

but it need to use early_node_map[], so put this function here

> 
> Cheers,
> Ben.
> 
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> ---
>>  include/linux/mm.h |    2 ++
>>  mm/page_alloc.c    |   29 +++++++++++++++++++++++++++++
>>  2 files changed, 31 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index fb19bb9..7774e1d 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -1159,6 +1159,8 @@ extern void free_bootmem_with_active_regions(int nid,
>>  						unsigned long max_low_pfn);
>>  int add_from_early_node_map(struct range *range, int az,
>>  				   int nr_range, int nid);
>> +u64 __init find_memory_core_early(int nid, u64 size, u64 align,
>> +					u64 goal, u64 limit);
>>  void *__alloc_memory_core_early(int nodeid, u64 size, u64 align,
>>  				 u64 goal, u64 limit);
>>  typedef int (*work_fn_t)(unsigned long, unsigned long, void *);
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index d03c946..72afd94 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -21,6 +21,7 @@
>>  #include <linux/pagemap.h>
>>  #include <linux/jiffies.h>
>>  #include <linux/bootmem.h>
>> +#include <linux/lmb.h>
>>  #include <linux/compiler.h>
>>  #include <linux/kernel.h>
>>  #include <linux/kmemcheck.h>
>> @@ -3393,6 +3394,34 @@ void __init free_bootmem_with_active_regions(int nid,
>>  	}
>>  }
>>  
>> +#ifdef CONFIG_HAVE_LMB
>> +u64 __init find_memory_core_early(int nid, u64 size, u64 align,
>> +					u64 goal, u64 limit)
>> +{
>> +	int i;
>> +
>> +	/* Need to go over early_node_map to find out good range for node */
>> +	for_each_active_range_index_in_nid(i, nid) {
>> +		u64 addr;
>> +		u64 ei_start, ei_last;
>> +
>> +		ei_last = early_node_map[i].end_pfn;
>> +		ei_last <<= PAGE_SHIFT;
>> +		ei_start = early_node_map[i].start_pfn;
>> +		ei_start <<= PAGE_SHIFT;
>> +		addr = __lmb_find_area(ei_start, ei_last,
>> +					 goal, limit, size, align);
>> +
>> +		if (addr == LMB_ERROR)
>> +			continue;
>> +
>> +		return addr;
>> +	}
>> +
>> +	return -1ULL;
>> +}
>> +#endif
>> +
>>  int __init add_from_early_node_map(struct range *range, int az,
>>  				   int nr_range, int nid)
>>  {
> 

