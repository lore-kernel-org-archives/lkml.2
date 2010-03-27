Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab0C0ATB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 20:19:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:46149 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691Ab0C0AS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 20:18:59 -0400
Message-ID: <4BAD4E9C.2040808@kernel.org>
Date: Fri, 26 Mar 2010 17:17:32 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 02/24] x86: Make sure free_init_pages() free pages in
 boundary
References: <1269642114-16588-1-git-send-email-yinghai@kernel.org> <1269642114-16588-3-git-send-email-yinghai@kernel.org> <20100326230615.GB29222@cmpxchg.org> <4BAD4734.8020503@kernel.org> <20100327000723.GF29222@cmpxchg.org>
In-Reply-To: <20100327000723.GF29222@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2010 05:07 PM, Johannes Weiner wrote:
> On Fri, Mar 26, 2010 at 04:45:56PM -0700, Yinghai Lu wrote:
>> On 03/26/2010 04:06 PM, Johannes Weiner wrote:
>>> On Fri, Mar 26, 2010 at 03:21:32PM -0700, Yinghai Lu wrote:
>>>> diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
>>>> index adedeef..fe3d953 100644
>>>> --- a/arch/x86/kernel/head32.c
>>>> +++ b/arch/x86/kernel/head32.c
>>>> @@ -47,6 +47,7 @@ void __init i386_start_kernel(void)
>>>>  		u64 ramdisk_image = boot_params.hdr.ramdisk_image;
>>>>  		u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
>>>>  		u64 ramdisk_end   = ramdisk_image + ramdisk_size;
>>>> +		ramdisk_end = PFN_UP(ramdisk_end) << PAGE_SHIFT;
>>>
>>> Why not PAGE_ALIGN()?
>>
>> looks like PFN_UP is more clear.
> 
> Why would you convert to a pfn just to go back to a physical address,
> when all you wanted is align at the next page boundary?  It looks
> rather clumsy.

reserve_early() will take phys addr

> 
> PAGE_ALIGN() is pretty wide spread and I think it's clear to most
> people what it does.

we may need to clean up all those:
round_up
round_down
roundup
ALIGN
PAGE_ALIGN etc.

> 
...
>>>> --- a/arch/x86/mm/init.c
>>>> +++ b/arch/x86/mm/init.c
>>>> @@ -332,6 +332,16 @@ int devmem_is_allowed(unsigned long pagenr)
>>>>  void free_init_pages(char *what, unsigned long begin, unsigned long end)
>>>>  {
>>>>  	unsigned long addr = begin;
>>>> +	unsigned long addr_aligned, end_aligned;
>>>> +
>>>> +	/* Make sure boundaries are page aligned */
>>>> +	addr_aligned = PFN_UP(addr) << PAGE_SHIFT;
>>>> +	end_aligned = PFN_DOWN(end) << PAGE_SHIFT;
>>>> +
>>>> +	if (WARN(addr_aligned != addr || end_aligned != end, "free_init_pages: range [%#lx, %#lx] is not aligned\n", addr, end)) {
>>>> +		addr = addr_aligned;
>>>> +		end = end_aligned;
>>>> +	}
>>>
>>> Maybe realign only for when it is not aligned?  So to keep the fixup
>>> out of line.
>>>
>>> I suppose WARN_ON() is enough as it will print a stack trace which
>>> should be enough clue of what went wrong.
>>
>> we need to PFN_DOWN the end, and don't free the partial page.
>> otherwise could crash the system.
> 
> Dito.
> 
> 	if (WARN_ON(not_aligned)) {
> 		align
> 	}
> 
> is what I meant.
> 
ok i got it.

YH
