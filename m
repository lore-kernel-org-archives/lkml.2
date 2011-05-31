Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab1EaLIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 07:08:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50090 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab1EaLIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 07:08:39 -0400
Message-ID: <4DE4CC33.7090404@petalogix.com>
Date: Tue, 31 May 2011 13:08:35 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ingo Molnar <mingo@elte.hu>, Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Frank Rowand <frank.rowand@am.sony.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Yong Zhang <yong.zhang0@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Michal Simek <monstr@monstr.eu>
Subject: Re: [BUG] "sched: Remove rq->lock from the first half of ttwu()"
 locks up on ARM
References: <BANLkTi=XbTXQsu3jUEvQyCfBy6-aRnqSpw@mail.gmail.com>	 <1306405979.1200.63.camel@twins>	 <1306407759.27474.207.camel@e102391-lin.cambridge.arm.com>	 <1306409575.1200.71.camel@twins> <1306412511.1200.90.camel@twins>	 <20110526122623.GA11875@elte.hu>	 <20110526123137.GG24876@n2100.arm.linux.org.uk>	 <20110526125007.GA27083@elte.hu>	 <BANLkTinUZ7EwN_nBCi_RQ9u8-LBcr_A74g@mail.gmail.com>	 <20110527120629.GA32617@elte.hu>	 <20110527205240.GT24876@n2100.arm.linux.org.uk> <1306588381.2497.481.camel@laptop>
In-Reply-To: <1306588381.2497.481.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Fri, 2011-05-27 at 21:52 +0100, Russell King - ARM Linux wrote:
>> On Fri, May 27, 2011 at 02:06:29PM +0200, Ingo Molnar wrote:
>>> The expectations are to have irqs off (we are holding the runqueue 
>>> lock if !__ARCH_WANT_INTERRUPTS_ON_CTXSW), so that's not workable i 
>>> suspect.
>> Just a thought, but we _might_ be able to avoid a lot of this hastle if
>> we had a new arch hook in finish_task_switch(), after finish_lock_switch()
>> returns but before the old MM is dropped.
> 
> I'd be more than willing to provide this.
> 
>> For the new ASID-based switch_mm(), we currently do this:
>>
>> 1. check ASID validity
>> 2. flush branch predictor
>> 3. set reserved ASID value
>> 4. set new page tables
>> 5. set new ASID value
>>
>> This will be shortly changed to:
>>
>> 1. check ASID validity
>> 2. flush branch predictor
>> 3. set swapper_pg_dir tables
>> 4. set new ASID value
>> 5. set new page tables
>>
>> We could change switch_mm() to only do:
>>
>> 1. flush branch predictor
>> 2. set swapper_pg_dir tables
>> 3. check ASID validity
>> 4. set new ASID value
>>
>> At this point, we have no user mappings, and so nothing will be using the
>> ASID at this point.  Then in a new post-finish_lock_switch() arch hook:
>>
>> 5. check whether we need to do flushing as a result of ASID change
>> 6. set new page tables
>>
>> I think this may simplify the ASID code.  It needs prototyping out,
>> reviewing and testing, but I think it may work.
>>
>> And I think it may also be workable with the CPUs which need to flush
>> the caches on context switches - we can postpone their page table
>> switch to this new arch hook too, which will mean we wouldn't require
>> __ARCH_WANT_INTERRUPTS_ON_CTXSW on ARM at all.
>>
>> Any thoughts (if you've followed what I'm going on about) ?
> 
> Yeah, definitely worth a try, you mentioned on IRC the problem of
> detecting if switch_mm() happened in the new arch hook. Since
> switch_mm() gets a @next pointer we can set a TIF flag there and have
> the new arch hook test for that and conditionally perform the required
> work.
> 
> Now, supposing we can get ARM to not rely on
> __ARCH_WANT_INTERRUPTS_ON_CTXSW anymore, there's only microblaze left,
> Michal, would a similar scheme work for you? If so we can fully
> deprecate and remove this exception from the scheduler (yay!).

Hi,

please correct me if I am wrong but this is workaround just for ARM.
I am not aware that we need to do anything with caches. I enabled that options
after our discussion (http://lkml.org/lkml/2009/12/3/204) because of problems 
with lockdep. I will look if I can remove that option but it will be necessary 
to do some changes in code. switch_to should be called with irq OFF right?

Michal


Michal






-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663
