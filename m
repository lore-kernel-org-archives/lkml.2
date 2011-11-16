Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab1KPHI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 02:08:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46331 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab1KPHIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 02:08:25 -0500
Message-ID: <4EC36165.3090002@google.com>
Date: Tue, 15 Nov 2011 23:08:21 -0800
From: Paul Turner <pjt@google.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Mike Galbraith <efault@gmx.de>
CC: john stultz <johnstul@us.ibm.com>, Salman Qazi <sqazi@google.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] sched: avoid unnecessary overflow in sched_clock
References: <20111115221121.7262.88871.stgit@dungbeetle.mtv.corp.google.com>  <1321398123.2352.29.camel@work-vm> <1321425705.12017.1.camel@marge.simson.net>
In-Reply-To: <1321425705.12017.1.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2011 10:41 PM, Mike Galbraith wrote:
> On Tue, 2011-11-15 at 15:02 -0800, john stultz wrote:
>> On Tue, 2011-11-15 at 14:12 -0800, Salman Qazi wrote:
>>> (Added the missing signed-off-by line)
>>>
>>> In hundreds of days, the __cycles_2_ns calculation in sched_clock
>>> has an overflow.  cyc * per_cpu(cyc2ns, cpu) exceeds 64 bits, causing
>>> the final value to become zero.  We can solve this without losing
>>> any precision.
>>>
>>> We can decompose TSC into quotient and remainder of division by the
>>> scale factor, and then use this to convert TSC into nanoseconds.
>>>
>>> Signed-off-by: Salman Qazi<sqazi@google.com>
>>
>> Acked-by: John Stultz<johnstul@us.ibm.com>
>
> This wants a stable tag, no?
>
> 	-Mike
>

Probably a good idea -- This especially sucks rocks in the sched_clock_stable==1 
case; resulting in it coming straight back out of sched_clock_cpu() and trashing 
rq->clock.

- Paul

>>> ---
>>>   arch/x86/include/asm/timer.h |   23 ++++++++++++++++++++++-
>>>   1 files changed, 22 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/arch/x86/include/asm/timer.h b/arch/x86/include/asm/timer.h
>>> index fa7b917..431793e 100644
>>> --- a/arch/x86/include/asm/timer.h
>>> +++ b/arch/x86/include/asm/timer.h
>>> @@ -32,6 +32,22 @@ extern int no_timer_check;
>>>    *  (mathieu.desnoyers@polymtl.ca)
>>>    *
>>>    *			-johnstul@us.ibm.com "math is hard, lets go shopping!"
>>> + *
>>> + * In:
>>> + *
>>> + * ns = cycles * cyc2ns_scale / SC
>>> + *
>>> + * Although we may still have enough bits to store the value of ns,
>>> + * in some cases, we may not have enough bits to store cycles * cyc2ns_scale,
>>> + * leading to an incorrect result.
>>> + *
>>> + * To avoid this, we can decompose 'cycles' into quotient and remainder
>>> + * of division by SC.  Then,
>>> + *
>>> + * ns = (quot * SC + rem) * cyc2ns_scale / SC
>>> + *    = quot * cyc2ns_scale + (rem * cyc2ns_scale) / SC
>>> + *
>>> + *			- sqazi@google.com
>>>    */
>>>
>>>   DECLARE_PER_CPU(unsigned long, cyc2ns);
>>> @@ -41,9 +57,14 @@ DECLARE_PER_CPU(unsigned long long, cyc2ns_offset);
>>>
>>>   static inline unsigned long long __cycles_2_ns(unsigned long long cyc)
>>>   {
>>> +	unsigned long long quot;
>>> +	unsigned long long rem;
>>>   	int cpu = smp_processor_id();
>>>   	unsigned long long ns = per_cpu(cyc2ns_offset, cpu);
>>> -	ns += cyc * per_cpu(cyc2ns, cpu)>>  CYC2NS_SCALE_FACTOR;
>>> +	quot = (cyc>>  CYC2NS_SCALE_FACTOR);
>>> +	rem = cyc&  ((1ULL<<  CYC2NS_SCALE_FACTOR) - 1);
>>> +	ns += quot * per_cpu(cyc2ns, cpu) +
>>> +		((rem * per_cpu(cyc2ns, cpu))>>  CYC2NS_SCALE_FACTOR);
>>>   	return ns;
>>>   }
>>>
>>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>

