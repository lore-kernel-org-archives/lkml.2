Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab2BMSNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 13:13:53 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:46690 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640Ab2BMSNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 13:13:52 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6619"; a="160466223"
Message-ID: <4F3952C7.3040502@codeaurora.org>
Date: Mon, 13 Feb 2012 10:13:27 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Nicolas Pitre <nico@fluxnic.net>, Rabin Vincent <rabin@rab.in>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] ARM: cache-v7: Disable preemption when reading CCSIDR
References: <alpine.LFD.2.02.1202022016480.2759@xanadu.home> <1328234629-32735-1-git-send-email-sboyd@codeaurora.org> <CAH+eYFCKcPzMMp_Ef5iX0Xp=xK8MdvJoUBRgKGT56SVjY5DXoA@mail.gmail.com> <alpine.LFD.2.02.1202131307430.24536@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1202131307430.24536@xanadu.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/12 10:09, Nicolas Pitre wrote:
> On Mon, 13 Feb 2012, Rabin Vincent wrote:
>
>> On Fri, Feb 3, 2012 at 07:33, Stephen Boyd <sboyd@codeaurora.org> wrote:
>>> armv7's flush_cache_all() flushes caches via set/way. To
>>> determine the cache attributes (line size, number of sets,
>>> etc.) the assembly first writes the CSSELR register to select a
>>> cache level and then reads the CCSIDR register. The CSSELR register
>>> is banked per-cpu and is used to determine which cache level CCSIDR
>>> reads. If the task is migrated between when the CSSELR is written and
>>> the CCSIDR is read the CCSIDR value may be for an unexpected cache
>>> level (for example L1 instead of L2) and incorrect cache flushing
>>> could occur.
>>>
>>> Disable interrupts across the write and read so that the correct
>>> cache attributes are read and used for the cache flushing
>>> routine. We disable interrupts instead of disabling preemption
>>> because the critical section is only 3 instructions and we want
>>> to call v7_dcache_flush_all from __v7_setup which doesn't have a
>>> full kernel stack with a struct thread_info.
>>>
>>> This fixes a problem we see in scm_call() when flush_cache_all()
>>> is called from preemptible context and sometimes the L2 cache is
>>> not properly flushed out.
>>>
>>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>>> Cc: Nicolas Pitre <nico@fluxnic.net>
>>> ---
>>> diff --git a/arch/arm/mm/cache-v7.S b/arch/arm/mm/cache-v7.S
>>> index 07c4bc8..654a5fc 100644
>>> --- a/arch/arm/mm/cache-v7.S
>>> +++ b/arch/arm/mm/cache-v7.S
>>> @@ -54,9 +54,15 @@ loop1:
>>>        and     r1, r1, #7                      @ mask of the bits for current cache only
>>>        cmp     r1, #2                          @ see what cache we have at this level
>>>        blt     skip                            @ skip if no cache, or just i-cache
>>> +#ifdef CONFIG_PREEMPT
>>> +       save_and_disable_irqs r9                @ make cssr&csidr read atomic
>>> +#endif
>>>        mcr     p15, 2, r10, c0, c0, 0          @ select current cache level in cssr
>>>        isb                                     @ isb to sych the new cssr&csidr
>>>        mrc     p15, 1, r1, c0, c0, 0           @ read the new csidr
>>> +#ifdef CONFIG_PREEMPT
>>> +       restore_irqs r9
>>> +#endif
>>>        and     r2, r1, #7                      @ extract the length of the cache lines
>>>        add     r2, r2, #4                      @ add 4 (line length offset)
>>>        ldr     r4, =0x3ff
>> This patch breaks the kernel boot when lockdep is enabled.
>>
>> v7_setup (called before the MMU is enabled) calls v7_flush_dcache_all,
>> and the save_and_disable_irqs added by this patch ends up calling
>> into lockdep C code (trace_hardirqs_off()) when we are in no position
>> to execute it (no stack, no MMU).
>>
>> The following fixes it.  Perhaps it can be folded in?
> Absolutely.  
>
> No tracing what so ever should be involved here.
>

Thanks. Russell has already merged the original patch to the fixes
branch. Hopefully he can fold this one in.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

