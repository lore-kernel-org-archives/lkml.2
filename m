Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab0ENGWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 02:22:48 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:65248 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab0ENGWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 02:22:46 -0400
Message-ID: <4BECEB8D.8070600@oracle.com>
Date: Thu, 13 May 2010 23:19:57 -0700
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
Subject: Re: [PATCH 01/35] lmb: prepare x86 to use lmb to replace early_res
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>	 <1273796396-29649-2-git-send-email-yinghai@kernel.org> <1273803143.21352.353.camel@pasglop>
In-Reply-To: <1273803143.21352.353.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4BECEC01.0018:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2010 07:12 PM, Benjamin Herrenschmidt wrote:
> On Thu, 2010-05-13 at 17:19 -0700, Yinghai Lu wrote:
>> 1. expose lmb_debug
>> 2. expose lmb_reserved_init_regions
>> 3. expose lmb_add_region
>> 4. prection for include linux/lmb.h in mm/page_alloc.c and mm/bootmem.c
>> 5. lmb_find_base() should return LMB_ERROR in one failing path.
>>    (this one cost me 3 hours !)
>> 6. move LMB_ERROR to lmb.h
> 
> Oh well, let's start somewhere...
> 
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> ---
>>  include/linux/lmb.h |    4 ++++
>>  lib/lmb.c           |   21 +++++++++------------
>>  2 files changed, 13 insertions(+), 12 deletions(-)
>>
>> diff --git a/include/linux/lmb.h b/include/linux/lmb.h
>> index 6f8c4bd..7987766 100644
>> --- a/include/linux/lmb.h
>> +++ b/include/linux/lmb.h
>> @@ -19,6 +19,7 @@
>>  #include <asm/lmb.h>
>>  
>>  #define INIT_LMB_REGIONS 128
>> +#define LMB_ERROR	(~(phys_addr_t)0)
> 
> Ok so this was meant to remain internal. You seem to want to expose a
> whole lot of LMB internals, I suppose for your new arch/x86/lmb.c and I
> really really don't like it.
> 
> If we expose LMB_ERROR then all lmb calls that can fail should return
> that. However, the API calls all return 0 instead. Changing that means
> fixing all callers.

ok will stop use LMB_ERROR out lib/lmb.c

will go back to use -1ULL for x86 path.

> 
> We can't just have a mix bag of result code in stuff that is exposed.
> 
> If all you need LMB_ERROR is to expose lmb_find_area() and
> lmb_add_region() then make the above __ and export a public variant of
> it that returns 0.
> 
> But that's not the right approach. The right thing to do I believe is to
> instead change LMB to use proper errno.h values.
> 
> For things like lmb_add_region(), return then as a negative int. For
> things that return a phys_addr_t as well with a proper casting macro
> since I -think- we can safely consider that phys addrs in the range
> -PAGE_SIZE..-1 can be error codes. Just like we do for PTR_ERR etc...
> 
> This should be a separate patch btw.
> 
> I'm also not too happy with exposing lmb_add_region(). Why would you
> ever need to expose it ? Just call lmb_reserve() if you want to reserve
> something. lmb_add_region() is an internal function and has no business
> being used outside of the main lmb.c file.
> 
> Also:
> 
>>  	/* Calculate new doubled size */
>>  	old_size = type->max * sizeof(struct lmb_region);
>>  	new_size = old_size << 1;
>> @@ -206,7 +199,7 @@ static int lmb_double_array(struct lmb_type *type)
>>  		new_array = kmalloc(new_size, GFP_KERNEL);
>>  		addr = new_array == NULL ? LMB_ERROR : __pa(new_array);
>>  	} else
>> -		addr = lmb_find_base(new_size, sizeof(phys_addr_t), 0, LMB_ALLOC_ACCESSIBLE);
>> +		addr = lmb_find_base(new_size, sizeof(struct lmb_region), 0, LMB_ALLOC_ACCESSIBLE);
> 
> Why this change ? Does it need to be aligned to the struct size ? if you
> really want that and have a good justification, make this a separate
> patch and explain why you are doing that in the changeset comment.

will drop that

> 
>>  	if (addr == LMB_ERROR) {
>>  		pr_err("lmb: Failed to double %s array from %ld to %ld entries !\n",
>>  		       lmb_type_name(type), type->max, type->max * 2);
>> @@ -214,6 +207,10 @@ static int lmb_double_array(struct lmb_type *type)
>>  	}
>>  	new_array = __va(addr);
>>  
>> +	if (lmb_debug)
>> +		pr_info("lmb: %s array is doubled to %ld at %llx - %llx",
>> +			 lmb_type_name(type), type->max * 2, (u64)addr, (u64)addr + new_size);
>> +
>>  	/* Found space, we now need to move the array over before
>>  	 * we add the reserved region since it may be our reserved
>>  	 * array itself that is full.
>> @@ -249,7 +246,7 @@ extern int __weak lmb_memory_can_coalesce(phys_addr_t addr1, phys_addr_t size1,
>>  	return 1;
>>  }
> 
> Cheers,
> Ben.

