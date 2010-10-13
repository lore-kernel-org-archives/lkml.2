Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab0JMSND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 14:13:03 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53990 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab0JMSNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 14:13:01 -0400
Message-ID: <4CB5F688.5090205@kernel.org>
Date: Wed, 13 Oct 2010 11:12:24 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100914 SUSE/3.0.8 Thunderbird/3.0.8
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 0/4] memblock related fixes for -tip
References: <4CAA4DC1.6000104@kernel.org> <4CB4ABE2.3010300@goop.org> <4CB4CF4D.5020706@kernel.org> <4CB4F11F.4090104@goop.org> <4CB54640.4000003@kernel.org> <4CB5DEE8.2020400@goop.org>
In-Reply-To: <4CB5DEE8.2020400@goop.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2010 09:31 AM, Jeremy Fitzhardinge wrote:
>  On 10/12/2010 10:40 PM, Yinghai Lu wrote:
>> On 10/12/2010 04:37 PM, Jeremy Fitzhardinge wrote:
>>>  On 10/12/2010 02:12 PM, Yinghai Lu wrote:
>>>> On 10/12/2010 11:41 AM, Jeremy Fitzhardinge wrote:
>>>>>  On 10/04/2010 02:57 PM, Yinghai Lu wrote:
>>>>>> Please check memblock related patches
>>>>>>
>>>>>> [PATCH 1/4] memblock: Fix big size with find_region()
>>>>>> [PATCH -v5 2/4] x86, memblock: Fix crashkernel allocation
>>>>>> [PATCH 3/4] x86, memblock: Remove __memblock_x86_find_in_range_size()
>>>>>> [PATCH 4/4] x86, mm, memblock, 32bit: Make add_highpages honor early reserved ranges
>>>>>>
>>>>>> first one should get into core/memblock branch, and others should be in x86/mm/memeblock branch
>>>>> BTW, the memblock changes prevent the kernel from booting under Xen; it
>>>>> crashes while setting up the linear maps.  I haven't worked out what's
>>>>> failing yet, aside from bisecting it down to one of a9ce6bc151000 or
>>>>> 72d7c3b33c9808 (they don't compile in isolation so I had to skip them,
>>>>> but both are likely looking, but unfortunately large, complex and hard
>>>>> to further subdivide).
>>>>>
>>>>> I'll look further into this, but just a heads-up for the upcoming merge
>>>>> window.
>>>>>
>>>> please use 
>>>>
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-2.6-yinghai.git memblock
>>>>
>>>> to find which commit cause xen broken.
>>>>
>>>> two xen related patch are folded into first converting commit.
>>> Note that ce883cfc65c51e24 doesn't compile:
>>>
>>> /home/jeremy/git/upstream/arch/x86/kernel/e820.c: In function
>>> ‘find_e820_area_size’:
>>> /home/jeremy/git/upstream/arch/x86/kernel/e820.c:764: error: expected
>>> ‘;’ before ‘return’
>>>
>>> However, I can fix it with the obvious fix, and the Xen boot failure
>>> bisects to this change.
>>>
>>> The specific crash is when constructing the initial pagetable, when Xen
>>> tries to remap a newly allocated pagetable page read-only, and finds the
>>> allocated page isn't mapped within the linear map. Since it is in the
>>> middle of creating the linear map, I guess its quite possible that the
>>> allocation order has changed, and it starts allocating pages which are
>>> not yet mapped, whereas before it was allocating already-mapped ones.
>> you can limit the allocation of pagetable page further ...
>>
>> xen doesn't honor max_pfn_mapped?
> 
> What do you mean?  Xen sets max_pfn_mapped when it does the early
> mapping of the kernel space, but I don't see how it relates to this
> stage of mapping?

We are using max_pfn_mapped to upper limit to find range that can be used as early stage.

so maybe you have max_pfn_mapped set too early and too big?

> 
>>> I'll see if I can confirm this hypothesis and see if I can work around
>>> it (is poses some problems, because it means that when the pages later
>>> become mapped, I need to make sure they get mapped RO).
>> please check following debug patch, it will try find area bottom up...
>>
>> Subject: [PATCH] x86, memblock: Add x86 version of memblock_find_in_range()
>>
>> Generic version is going from high to low, and it seems it can not find
>> right area compact enough.
>>
>> the x86 version will go from goal to limit and just like the way We used
>> for early_res
>>
>> use ARCH_FIND_MEMBLOCK_AREA to select from them.
> 
> Thanks, that fixes the problem.  I would ideally like to make the the
> Xen code independent of the page allocation ordering, but it looks like
> it will be very tricky since we effectively make use of the pagetable as
> a way of storing one bit of information about each page before there's a
> struct page in place.
> 
> So this patch looks good to me (but there's no need to make it a
> separate config option).

that is for debug purpose only. We really want to do top-down than bottom-up.

Thanks

Yinghai
