Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649Ab2DXXyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 19:54:22 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33348 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab2DXXyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 19:54:21 -0400
X-AuditID: cbfee61a-b7b8eae00000534b-ae-4f973d2b61c5
Message-id: <4F973D2B.7000205@samsung.com>
Date: Wed, 25 Apr 2012 08:54:19 +0900
From: Minho Ban <mhban@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329
 Thunderbird/11.0.1
MIME-version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: [RFC/PATCH] Prevent wasting time to find out get_parent_ip
References: <4F969E53.9080307@samsung.com>
 <1335291397.28106.142.camel@gandalf.stny.rr.com>
In-reply-to: <1335291397.28106.142.camel@gandalf.stny.rr.com>
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2012 03:16 AM, Steven Rostedt wrote:
> On Tue, 2012-04-24 at 21:36 +0900, Minho Ban wrote:
>> trace_preempt_on/off looks empty if PREEMPT_TRACER is off. But actually it is
>> spending time to find out get_parent_ip(even CALLER_ADDR for some ARCH) which is
>> in argument. This seems not fair for those who expect to do nothing but increase
>> or decrease count.
>>
> 
> Yuck what an ugly patch. Please don't uglify the C code with #ifdefs!
> 

Yes, I agree.

>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Signed-off-by: Minho Ban <mhban@samsung.com>
>> ---
>>  include/linux/ftrace.h |    3 ---
>>  kernel/sched/core.c    |    5 ++++-
>>  kernel/softirq.c       |    3 ++-
>>  3 files changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
>> index 72a6cab..7cd11fe 100644
>> --- a/include/linux/ftrace.h
>> +++ b/include/linux/ftrace.h
>> @@ -484,9 +484,6 @@ static inline void __ftrace_enabled_restore(int enabled)
>>  #ifdef CONFIG_PREEMPT_TRACER
>>    extern void trace_preempt_on(unsigned long a0, unsigned long a1);
>>    extern void trace_preempt_off(unsigned long a0, unsigned long a1);
>> -#else
>> -  static inline void trace_preempt_on(unsigned long a0, unsigned long a1) { }
>> -  static inline void trace_preempt_off(unsigned long a0, unsigned long a1) { }
> 
> If you want to hide the "CALLER_ADDR" for other archs, then simply do:
> 
> # define trace_preempt_on(a0, a1) do { } while (0)
> # define trace_preempt_off(a0, a1) do { } while (0)
> 
> and be done with it.
> 
> Oh, you should add a comment before these defines to the effect of:
> 
>  /*
>   * Use defines instead of static inlines because some arches will make 
>   * code out of the CALLER_ADDR, when we really want these to be a real 
>   * nop.
>   */
> 
> That way, you will document why we use defines instead of static
> inlines.
> 
> -- Steve
> 

Very appreciate your explanation and detailed(even complete) sample code. 
I'll apply your code.

>>  #endif
>>  
>>  #ifdef CONFIG_FTRACE_MCOUNT_RECORD
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 4603b9d..efdd5a0 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -3068,8 +3068,10 @@ void __kprobes add_preempt_count(int val)
>>  	DEBUG_LOCKS_WARN_ON((preempt_count() & PREEMPT_MASK) >=
>>  				PREEMPT_MASK - 10);
>>  #endif
>> +#ifdef CONFIG_PREEMPT_TRACER
>>  	if (preempt_count() == val)
>>  		trace_preempt_off(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
>> +#endif
>>  }
>>  EXPORT_SYMBOL(add_preempt_count);
>>  
>> @@ -3088,9 +3090,10 @@ void __kprobes sub_preempt_count(int val)
>>  			!(preempt_count() & PREEMPT_MASK)))
>>  		return;
>>  #endif
>> -
>> +#ifdef CONFIG_PREEMPT_TRACER
>>  	if (preempt_count() == val)
>>  		trace_preempt_on(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
>> +#endif
>>  	preempt_count() -= val;
>>  }
>>  EXPORT_SYMBOL(sub_preempt_count);
>> diff --git a/kernel/softirq.c b/kernel/softirq.c
>> index 671f959..e7c8336 100644
>> --- a/kernel/softirq.c
>> +++ b/kernel/softirq.c
>> @@ -112,9 +112,10 @@ static void __local_bh_disable(unsigned long ip, unsigned int cnt)
>>  	if (softirq_count() == cnt)
>>  		trace_softirqs_off(ip);
>>  	raw_local_irq_restore(flags);
>> -
>> +#ifdef CONFIG_PREEMPT_TRACER
>>  	if (preempt_count() == cnt)
>>  		trace_preempt_off(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
>> +#endif
>>  }
>>  #else /* !CONFIG_TRACE_IRQFLAGS */
>>  static inline void __local_bh_disable(unsigned long ip, unsigned int cnt)
> 
> 
> 

