Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab0ENGp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 02:45:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57309 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132Ab0ENGp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 02:45:26 -0400
Message-ID: <4BECF0E2.90406@oracle.com>
Date: Thu, 13 May 2010 23:42:42 -0700
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
Subject: Re: [PATCH 13/35] x86, lmb: Add lmb_free_memory_size()
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>	 <1273796396-29649-14-git-send-email-yinghai@kernel.org> <1273804285.21352.392.camel@pasglop>
In-Reply-To: <1273804285.21352.392.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090206.4BECF150.006F:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2010 07:31 PM, Benjamin Herrenschmidt wrote:
> On Thu, 2010-05-13 at 17:19 -0700, Yinghai Lu wrote:
>> It will return free memory size in specified range.
>>
>> We can not use memory_size - reserved_size here, because some reserved area
>> may not be in the scope of lmb.memory.region.
>>
>> Use lmb.memory.region subtracting lmb.reserved.region to get free range array.
>> then count size of all free ranges.
> 
> I remember having already told you that the naming sucks.

any suggestion?

i think this name is clear.

> 
> Also, you fail to explain what this is actually needed for.

needed by 

[PATCH 21/35] x86, lmb: Use lmb_memory_size()/lmb_free_memory_size() to get correct dma_reserve


> 
> Cheers,
> Ben.
> 
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> ---
>>  arch/x86/include/asm/lmb.h |    1 +
>>  arch/x86/mm/lmb.c          |   51 ++++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 52 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/lmb.h b/arch/x86/include/asm/lmb.h
>> index 358d8a6..4fb94b5 100644
>> --- a/arch/x86/include/asm/lmb.h
>> +++ b/arch/x86/include/asm/lmb.h
>> @@ -16,5 +16,6 @@ void lmb_register_active_regions(int nid, unsigned long start_pfn,
>>  					 unsigned long last_pfn);
>>  u64 lmb_hole_size(u64 start, u64 end);
>>  u64 lmb_find_area_node(int nid, u64 start, u64 end, u64 size, u64 align);
>> +u64 lmb_free_memory_size(u64 addr, u64 limit);
>>  
>>  #endif
>> diff --git a/arch/x86/mm/lmb.c b/arch/x86/mm/lmb.c
>> index c5fa1dd..6c69e99 100644
>> --- a/arch/x86/mm/lmb.c
>> +++ b/arch/x86/mm/lmb.c
>> @@ -226,6 +226,57 @@ void __init lmb_to_bootmem(u64 start, u64 end)
>>  }
>>  #endif
>>  
>> +u64 __init lmb_free_memory_size(u64 addr, u64 limit)
>> +{
>> +	int i, count;
>> +	struct range *range;
>> +	int nr_range;
>> +	u64 final_start, final_end;
>> +	u64 free_size;
>> +
>> +	count = (lmb.reserved.cnt + lmb.memory.cnt) * 2;
>> +
>> +	range = find_range_array(count);
>> +	nr_range = 0;
>> +
>> +	addr = PFN_UP(addr);
>> +	limit = PFN_DOWN(limit);
>> +
>> +	for (i = 0; i < lmb.memory.cnt; i++) {
>> +		struct lmb_region *r = &lmb.memory.regions[i];
>> +
>> +		final_start = PFN_UP(r->base);
>> +		final_end = PFN_DOWN(r->base + r->size);
>> +		if (final_start >= final_end)
>> +			continue;
>> +		if (final_start >= limit || final_end <= addr)
>> +			continue;
>> +
>> +		nr_range = add_range(range, count, nr_range, final_start, final_end);
>> +	}
>> +	subtract_range(range, count, 0, addr);
>> +	subtract_range(range, count, limit, -1ULL);
>> +	for (i = 0; i < lmb.reserved.cnt; i++) {
>> +		struct lmb_region *r = &lmb.reserved.regions[i];
>> +
>> +		final_start = PFN_DOWN(r->base);
>> +		final_end = PFN_UP(r->base + r->size);
>> +		if (final_start >= final_end)
>> +			continue;
>> +		if (final_start >= limit || final_end <= addr)
>> +			continue;
>> +
>> +		subtract_range(range, count, final_start, final_end);
>> +	}
>> +	nr_range = clean_sort_range(range, count);
>> +
>> +	free_size = 0;
>> +	for (i = 0; i < nr_range; i++)
>> +		free_size += range[i].end - range[i].start;
>> +
>> +	return free_size << PAGE_SHIFT;
>> +}
>> +
>>  void __init lmb_add_memory(u64 start, u64 end)
>>  {
>>  	lmb_add_region(&lmb.memory, start, end - start);
> 

