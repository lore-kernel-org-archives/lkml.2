Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848Ab1CCVhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 16:37:18 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:25204 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793Ab1CCVhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 16:37:16 -0500
Message-ID: <4D7009BA.5030600@kernel.org>
Date: Thu, 03 Mar 2011 13:35:54 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, mm: clean up setup_node_bootmem
References: <4D6EECA1.70603@kernel.org> <alpine.DEB.2.00.1103031243020.9993@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1103031243020.9993@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4D7009F8.012B,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2011 12:49 PM, David Rientjes wrote:
> On Wed, 2 Mar 2011, Yinghai Lu wrote:
> 
>>
>> only one user now, so change it to static
>>
>> Also move validity checking into the fuction.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  arch/x86/include/asm/numa_64.h |    2 --
>>  arch/x86/mm/numa_64.c          |   10 +++-------
>>  2 files changed, 3 insertions(+), 9 deletions(-)
>>
>> Index: linux-2.6/arch/x86/include/asm/numa_64.h
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/include/asm/numa_64.h
>> +++ linux-2.6/arch/x86/include/asm/numa_64.h
>> @@ -13,8 +13,6 @@ struct bootnode {
>>  extern int numa_off;
>>  
>>  extern unsigned long numa_free_all_bootmem(void);
>> -extern void setup_node_bootmem(int nodeid, unsigned long start,
>> -			       unsigned long end);
>>  
>>  #ifdef CONFIG_NUMA
>>  /*
>> Index: linux-2.6/arch/x86/mm/numa_64.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/mm/numa_64.c
>> +++ linux-2.6/arch/x86/mm/numa_64.c
>> @@ -237,21 +237,18 @@ int __init numa_add_memblk(int nid, u64
>>  }
>>  
>>  /* Initialize bootmem allocator for a node */
>> -void __init
>> +static void __init
>>  setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
>>  {
>>  	unsigned long start_pfn, last_pfn, nodedata_phys;
>>  	const int pgdat_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
>>  	int nid;
>>  
>> -	if (!end)
>> -		return;
>> -
>>  	/*
>>  	 * Don't confuse VM with a node that doesn't have the
>>  	 * minimum amount of memory:
>>  	 */
>> -	if (end && (end - start) < NODE_MIN_SIZE)
>> +	if (end < (start +  NODE_MIN_SIZE))
>>  		return;
>>  
>>  	start = roundup(start, ZONE_ALIGN);
>> @@ -557,8 +554,7 @@ static int __init numa_register_memblks(
>>  			end = max(mi->blk[i].end, end);
>>  		}
>>  
>> -		if (start < end)
>> -			setup_node_bootmem(nid, start, end);
>> +		setup_node_bootmem(nid, start, end);
>>  	}
>>  
>>  	return 0;
>>
> 
> Good catch on finding only the one caller of setup_node_bootmem().
> 
> I'd actually rather see the validity checking being done in 
> numa_register_memblks(), though, because it's a bug for a node to be set 
> in node_possible_map without having a valid 
> [mi->blk[i].start, mi->blk[i].end) range.
> 
> So could this be
> 
> 	BUG_ON(end < start);

no, it could cause crash here

        /* Finally register nodes. */
        for_each_node_mask(nid, node_possible_map) {
                u64 start = (u64)max_pfn << PAGE_SHIFT;
                u64 end = 0;

                for (i = 0; i < mi->nr_blks; i++) {
                        if (nid != mi->blk[i].nid)
                                continue;
                        start = min(mi->blk[i].start, start);
                        end = max(mi->blk[i].end, end);
                }

could have some node without memory. and it could be set in node_possible_map, and it will have end = 0, and start max_pfn<<page_shift.


> 	/*
> 	 * Don't confuse the VM with a node that doesn't have the minimum
> 	 * amount of memory.
> 	 */
> 	if (end < start + NODE_MIN_SIZE) {
> 		node_clear(nid, node_possible_map);

why touch that possible_map ?
online_map is for that purpose that state node have ram.

> 		continue;
> 	}
> 	setup_node_bootmem(nid, start, end);
> 
> instead?

Thanks

Yinghai
