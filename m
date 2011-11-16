Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680Ab1KPAHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 19:07:52 -0500
Received: from lo.gmane.org ([80.91.229.12]:40952 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757051Ab1KPAHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 19:07:51 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Paul Turner <pjt@google.com>
Subject: Re: [PATCH] sched: avoid unnecessary overflow in sched_clock
Date: Tue, 15 Nov 2011 16:07:38 -0800
Message-ID: <4EC2FECA.4080502@google.com>
References: <20111115221121.7262.88871.stgit@dungbeetle.mtv.corp.google.com> <1321398123.2352.29.camel@work-vm>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
Cc: Salman Qazi <sqazi@google.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
X-Gmane-NNTP-Posting-Host: 216-239-45-4.google.com
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
In-Reply-To: <1321398123.2352.29.camel@work-vm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2011 03:02 PM, john stultz wrote:
> On Tue, 2011-11-15 at 14:12 -0800, Salman Qazi wrote:
>> (Added the missing signed-off-by line)
>>
>> In hundreds of days, the __cycles_2_ns calculation in sched_clock
>> has an overflow.  cyc * per_cpu(cyc2ns, cpu) exceeds 64 bits, causing
>> the final value to become zero.  We can solve this without losing
>> any precision.
>>
>> We can decompose TSC into quotient and remainder of division by the
>> scale factor, and then use this to convert TSC into nanoseconds.
>>
>> Signed-off-by: Salman Qazi<sqazi@google.com>
>
> Acked-by: John Stultz<johnstul@us.ibm.com>
>

Reviewed-by: Paul Turner <pjt@google.com>

>
>> ---
>>   arch/x86/include/asm/timer.h |   23 ++++++++++++++++++++++-
>>   1 files changed, 22 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/timer.h b/arch/x86/include/asm/timer.h
>> index fa7b917..431793e 100644
>> --- a/arch/x86/include/asm/timer.h
>> +++ b/arch/x86/include/asm/timer.h
>> @@ -32,6 +32,22 @@ extern int no_timer_check;
>>    *  (mathieu.desnoyers@polymtl.ca)
>>    *
>>    *			-johnstul@us.ibm.com "math is hard, lets go shopping!"
>> + *
>> + * In:
>> + *
>> + * ns = cycles * cyc2ns_scale / SC
>> + *
>> + * Although we may still have enough bits to store the value of ns,
>> + * in some cases, we may not have enough bits to store cycles * cyc2ns_scale,
>> + * leading to an incorrect result.
>> + *
>> + * To avoid this, we can decompose 'cycles' into quotient and remainder
>> + * of division by SC.  Then,
>> + *
>> + * ns = (quot * SC + rem) * cyc2ns_scale / SC
>> + *    = quot * cyc2ns_scale + (rem * cyc2ns_scale) / SC
>> + *
>> + *			- sqazi@google.com
>>    */
>>
>>   DECLARE_PER_CPU(unsigned long, cyc2ns);
>> @@ -41,9 +57,14 @@ DECLARE_PER_CPU(unsigned long long, cyc2ns_offset);
>>
>>   static inline unsigned long long __cycles_2_ns(unsigned long long cyc)
>>   {
>> +	unsigned long long quot;
>> +	unsigned long long rem;
>>   	int cpu = smp_processor_id();
>>   	unsigned long long ns = per_cpu(cyc2ns_offset, cpu);
>> -	ns += cyc * per_cpu(cyc2ns, cpu)>>  CYC2NS_SCALE_FACTOR;
>> +	quot = (cyc>>  CYC2NS_SCALE_FACTOR);
>> +	rem = cyc&  ((1ULL<<  CYC2NS_SCALE_FACTOR) - 1);
>> +	ns += quot * per_cpu(cyc2ns, cpu) +
>> +		((rem * per_cpu(cyc2ns, cpu))>>  CYC2NS_SCALE_FACTOR);
>>   	return ns;
>>   }
>>
>>
>
>


