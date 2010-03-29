Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab0C2Qr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 12:47:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:47215 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754863Ab0C2Qr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 12:47:56 -0400
Message-ID: <4BB0D92C.3010103@kernel.org>
Date: Mon, 29 Mar 2010 09:45:32 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: michael@ellerman.id.au
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 07/31] lmb: Add reserve_lmb/free_lmb
References: <1269830604-26214-1-git-send-email-yinghai@kernel.org>	 <1269830604-26214-8-git-send-email-yinghai@kernel.org> <1269865322.24620.42.camel@concordia>
In-Reply-To: <1269865322.24620.42.camel@concordia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2010 05:22 AM, Michael Ellerman wrote:
> On Sun, 2010-03-28 at 19:43 -0700, Yinghai Lu wrote:
>> They will check if the region array is big enough.
>>
>> __check_and_double_region_array will try to double the region if that array spare
>> slots if not big enough.
>> find_lmb_area() is used to find good postion for new region array.
>> Old array will be copied to new array.
>>
>> Arch code should provide to get_max_mapped, so the new array have accessiable
>> address
> ..
>> diff --git a/mm/lmb.c b/mm/lmb.c
>> index d5d5dc4..9798458 100644
>> --- a/mm/lmb.c
>> +++ b/mm/lmb.c
>> @@ -551,6 +551,95 @@ int lmb_find(struct lmb_property *res)
>>  	return -1;
>>  }
>>  
>> +u64 __weak __init get_max_mapped(void)
>> +{
>> +	u64 end = max_low_pfn;
>> +
>> +	end <<= PAGE_SHIFT;
>> +
>> +	return end;
>> +}
> 
> ^ This is (sort of) what lmb.rmo_size represents. So maybe instead of
> adding this function, we could just say that the arch code needs to set
> rmo_size up with an appropriate value, and then use that below. Though
> maybe that's conflating things.

ok

will have another patch following this patchset. to use rmo_size replace get_max_mapped()

long __init_lmb lmb_add(u64 base, u64 size)
{
        struct lmb_region *_rgn = &lmb.memory;

        /* On pSeries LPAR systems, the first LMB is our RMO region. */
        if (base == 0)
                lmb.rmo_size = size;

        return lmb_add_region(_rgn, base, size);

}

looks scary.
maybe later powerpc could used lmb_find and set_lmb_rmo_size in their arch code.


> 
> ...
>> +
>> +void __init add_lmb_memory(u64 start, u64 end)
>> +{
>> +	__check_and_double_region_array(&lmb.memory, &lmb_memory_region[0], start, end);
>> +	lmb_add(start, end - start);
>> +}
>> +
>> +void __init reserve_lmb(u64 start, u64 end, char *name)
>> +{
>> +	if (start == end)
>> +		return;
>> +
>> +	if (WARN_ONCE(start > end, "reserve_lmb: wrong range [%#llx, %#llx]\n", start, end))
>> +		return;
>> +
>> +	__check_and_double_region_array(&lmb.reserved, &lmb_reserved_region[0], start, end);
>> +	lmb_reserve(start, end - start);
>> +}
>> +
>> +void __init free_lmb(u64 start, u64 end)
>> +{
>> +	if (start == end)
>> +		return;
>> +
>> +	if (WARN_ONCE(start > end, "free_lmb: wrong range [%#llx, %#llx]\n", start, end))
>> +		return;
>> +
>> +	/* keep punching hole, could run out of slots too */
>> +	__check_and_double_region_array(&lmb.reserved, &lmb_reserved_region[0], start, end);
>> +	lmb_free(start, end - start);
>> +}
> 
> Doesn't this mean that if I call lmb_alloc() or lmb_free() too many
> times then I'll potentially run out of space? So doesn't that
> essentially break the existing API?

No, I didn't touch existing API, arches other than x86 should have little change about 
lmb.memory.region
lmb.reserved.region
become pointer from array.

> 
> It seems to me that rather than adding these "special" routines that
> check for enough space on the way in, instead you should be checking in
> lmb_add_region() - which is where AFAICS all allocs/frees/reserves
> eventually end up if they need to insert a new region.

later i prefer to replace lmb_alloc with find_lmb_area + reserve_lmb.

Thanks

Yinghai
