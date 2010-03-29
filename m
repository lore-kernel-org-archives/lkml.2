Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab0C2Wje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 18:39:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:59107 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771Ab0C2Wjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 18:39:32 -0400
Message-ID: <4BB12BBA.4060108@kernel.org>
Date: Mon, 29 Mar 2010 15:37:46 -0700
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
References: <1269830604-26214-1-git-send-email-yinghai@kernel.org>	 <1269830604-26214-8-git-send-email-yinghai@kernel.org>	 <1269865322.24620.42.camel@concordia>  <4BB0D92C.3010103@kernel.org> <1269901252.2286.11.camel@concordia>
In-Reply-To: <1269901252.2286.11.camel@concordia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2010 03:20 PM, Michael Ellerman wrote:
> On Mon, 2010-03-29 at 09:45 -0700, Yinghai Lu wrote:
>> On 03/29/2010 05:22 AM, Michael Ellerman wrote:
>>> On Sun, 2010-03-28 at 19:43 -0700, Yinghai Lu wrote:
>>>> They will check if the region array is big enough.
>>>>
>>>> __check_and_double_region_array will try to double the region if that array spare
>>>> slots if not big enough.
>>>> find_lmb_area() is used to find good postion for new region array.
>>>> Old array will be copied to new array.
>>>>
>>>> Arch code should provide to get_max_mapped, so the new array have accessiable
>>>> address
>>> ..
>>>> diff --git a/mm/lmb.c b/mm/lmb.c
>>>> index d5d5dc4..9798458 100644
>>>> --- a/mm/lmb.c
>>>> +++ b/mm/lmb.c
>>>> @@ -551,6 +551,95 @@ int lmb_find(struct lmb_property *res)
>>>>  	return -1;
>>>>  }
>>>>  
>>>> +u64 __weak __init get_max_mapped(void)
>>>> +{
>>>> +	u64 end = max_low_pfn;
>>>> +
>>>> +	end <<= PAGE_SHIFT;
>>>> +
>>>> +	return end;
>>>> +}
>>>
>>> ^ This is (sort of) what lmb.rmo_size represents. So maybe instead of
>>> adding this function, we could just say that the arch code needs to set
>>> rmo_size up with an appropriate value, and then use that below. Though
>>> maybe that's conflating things.
>>
>> ok
>>
>> will have another patch following this patchset. to use rmo_size replace get_max_mapped()
> 
> No don't, Benh's idea was better. Leave rmo_size for now, we can clean
> that up later.
> 
> We just need a lmb.alloc_limit and a lmb_set_alloc_limit() which arch
> code calls when it knows what the alloc limit is (and can call multiple
> times during boot). Or maybe it should be called "default_alloc_limit",
> but that's getting a bit long winded.

ok, I will get_max_mapped() for now, an will change to new field...later

> 
>>
>> long __init_lmb lmb_add(u64 base, u64 size)
>> {
>>         struct lmb_region *_rgn = &lmb.memory;
>>
>>         /* On pSeries LPAR systems, the first LMB is our RMO region. */
>>         if (base == 0)
>>                 lmb.rmo_size = size;
>>
>>         return lmb_add_region(_rgn, base, size);
>>
>> }
>>
>> looks scary.
>> maybe later powerpc could used lmb_find and set_lmb_rmo_size in their arch code.
> 
> It's not really scary, and it gives you a hint where the code came from
> originally :)
> 
> We can remove that later though, with some powerpc code to detect the
> first memory region before we put it into lmb.

good.

> 
>>> ...
>>>> +
>>>> +void __init add_lmb_memory(u64 start, u64 end)
>>>> +{
>>>> +	__check_and_double_region_array(&lmb.memory, &lmb_memory_region[0], start, end);
>>>> +	lmb_add(start, end - start);
>>>> +}
>>>> +
>>>> +void __init reserve_lmb(u64 start, u64 end, char *name)
>>>> +{
>>>> +	if (start == end)
>>>> +		return;
>>>> +
>>>> +	if (WARN_ONCE(start > end, "reserve_lmb: wrong range [%#llx, %#llx]\n", start, end))
>>>> +		return;
>>>> +
>>>> +	__check_and_double_region_array(&lmb.reserved, &lmb_reserved_region[0], start, end);
>>>> +	lmb_reserve(start, end - start);
>>>> +}
>>>> +
>>>> +void __init free_lmb(u64 start, u64 end)
>>>> +{
>>>> +	if (start == end)
>>>> +		return;
>>>> +
>>>> +	if (WARN_ONCE(start > end, "free_lmb: wrong range [%#llx, %#llx]\n", start, end))
>>>> +		return;
>>>> +
>>>> +	/* keep punching hole, could run out of slots too */
>>>> +	__check_and_double_region_array(&lmb.reserved, &lmb_reserved_region[0], start, end);
>>>> +	lmb_free(start, end - start);
>>>> +}
>>>
>>> Doesn't this mean that if I call lmb_alloc() or lmb_free() too many
>>> times then I'll potentially run out of space? So doesn't that
>>> essentially break the existing API?
>>
>> No, I didn't touch existing API, arches other than x86 should have little change about 
>> lmb.memory.region
>> lmb.reserved.region
>> become pointer from array.
> 
> But that's my point. You shouldn't need to touch the existing API, and
> you shouldn't need to add a new parallel API. You should just be able to
> add the logic for doubling the array in the lmb core, and then everyone
> gets dynamically expandable lmb. I don't see any reason why we want to
> have two APIs.

that will have too much change for all x86 caller.

that set of API is __init, and will be freed later. 

and these two are just wrapper for old one to make x86 transition more easily.

> 
>>> It seems to me that rather than adding these "special" routines that
>>> check for enough space on the way in, instead you should be checking in
>>> lmb_add_region() - which is where AFAICS all allocs/frees/reserves
>>> eventually end up if they need to insert a new region.
>>
>> later i prefer to replace lmb_alloc with find_lmb_area + reserve_lmb.
> 
> Why? The existing code has been working for years and is well tested?

We need to find_lmb_area to find good position for new reserved region array.

static void __init __reserve_lmb(u64 start, u64 end, char *name)
{
        __check_and_double_region_array(&lmb.reserved, &lmb_reserved_region[0], start, end);
        lmb_reserve(start, end - start);
}

with the execlude area in __check_and_double_region_lmb() will not put the new array overlap with area that we are going to reserve.

and find_lmb_area + reserve_lmb should be identical to lmb_alloc...

Thanks

Yinghai Lu
