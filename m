Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab0KJIgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 03:36:14 -0500
Received: from mail.windriver.com ([147.11.1.11]:36023 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab0KJIgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 03:36:13 -0500
Message-ID: <4CDA5962.4030508@windriver.com>
Date: Wed, 10 Nov 2010 16:35:46 +0800
From: DDD <dongdong.deng@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: avoid calling arch_trigger_all_cpu_backtrace() at
 the same time on SMP
References: <1288721818-10851-1-git-send-email-dzickus@redhat.com> <20101110074307.GC29493@elte.hu>
In-Reply-To: <20101110074307.GC29493@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Nov 2010 08:35:16.0789 (UTC) FILETIME=[33915E50:01CB80B2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Don Zickus <dzickus@redhat.com> wrote:
> 
>> From: Dongdong Deng <dongdong.deng@windriver.com>
>>
>> The spin_lock_debug/rcu_cpu_stall detector uses
>> trigger_all_cpu_backtrace() to dump cpu backtrace.
>> Therefore it is possible that trigger_all_cpu_backtrace()
>> could be called at the same time on different CPUs, which
>> triggers and 'unknown reason NMI' warning. The following case
>> illustrates the problem:
>>
>>       CPU1                    CPU2                     ...   CPU N
>>                        trigger_all_cpu_backtrace()
>>                        set "backtrace_mask" to cpu mask
>>                                |
>> generate NMI interrupts  generate NMI interrupts       ...
>>     \                          |                               /
>>      \                         |                              /
>>    The "backtrace_mask" will be cleaned by the first NMI interrupt
>>   at nmi_watchdog_tick(), then the following NMI interrupts generated
>> by other cpus's arch_trigger_all_cpu_backtrace() will be took as
>> unknown reason NMI interrupts.
>>
>> This patch uses a lock to avoid the problem, and stop the
>> arch_trigger_all_cpu_backtrace() calling to avoid dumping double cpu
>> backtrace info when there is already a trigger_all_cpu_backtrace()
>> in progress.
>>
>> Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
>> Reviewed-by: Bruce Ashfield <bruce.ashfield@windriver.com>
>> CC: Thomas Gleixner <tglx@linutronix.de>
>> CC: Ingo Molnar <mingo@redhat.com>
>> CC: "H. Peter Anvin" <hpa@zytor.com>
>> CC: x86@kernel.org
>> CC: linux-kernel@vger.kernel.org
>> Signed-off-by: Don Zickus <dzickus@redhat.com>
>> ---
>>  arch/x86/kernel/apic/hw_nmi.c |   14 ++++++++++++++
>>  arch/x86/kernel/apic/nmi.c    |   14 ++++++++++++++
>>  2 files changed, 28 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
>> index cefd694..3aea0a5 100644
>> --- a/arch/x86/kernel/apic/hw_nmi.c
>> +++ b/arch/x86/kernel/apic/hw_nmi.c
>> @@ -29,6 +29,16 @@ u64 hw_nmi_get_sample_period(void)
>>  void arch_trigger_all_cpu_backtrace(void)
>>  {
>>  	int i;
>> +	static arch_spinlock_t lock = __ARCH_SPIN_LOCK_UNLOCKED;
> 
> Please dont put statics into the middle of local variables - put them into file 
> scope in a visible way.

Got it. will change it.

> 
>> +	unsigned long flags;
>> +
>> +	local_irq_save(flags);
>> +	if (!arch_spin_trylock(&lock))
>> +		/*
>> +		 * If there is already a trigger_all_cpu_backtrace()
>> +		 * in progress, don't output double cpu dump infos.
>> +		 */
>> +		goto out_restore_irq;
>>  
>>  	cpumask_copy(to_cpumask(backtrace_mask), cpu_online_mask);
>>  
>> @@ -41,6 +51,10 @@ void arch_trigger_all_cpu_backtrace(void)
>>  			break;
>>  		mdelay(1);
>>  	}
>> +
>> +	arch_spin_unlock(&lock);
>> +out_restore_irq:
>> +	local_irq_restore(flags);
>>  }
>>  
>>  static int __kprobes
>> diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
>> index a43f71c..5fa8a13 100644
>> --- a/arch/x86/kernel/apic/nmi.c
>> +++ b/arch/x86/kernel/apic/nmi.c
>> @@ -552,6 +552,16 @@ int do_nmi_callback(struct pt_regs *regs, int cpu)
>>  void arch_trigger_all_cpu_backtrace(void)
>>  {
>>  	int i;
>> +	static arch_spinlock_t lock = __ARCH_SPIN_LOCK_UNLOCKED;
>> +	unsigned long flags;
>> +
>> +	local_irq_save(flags);
>> +	if (!arch_spin_trylock(&lock))
>> +		/*
>> +		 * If there is already a trigger_all_cpu_backtrace()
>> +		 * in progress, don't output double cpu dump infos.
>> +		 */
>> +		goto out_restore_irq;
>>  
>>  	cpumask_copy(to_cpumask(backtrace_mask), cpu_online_mask);
>>  
>> @@ -564,4 +574,8 @@ void arch_trigger_all_cpu_backtrace(void)
>>  			break;
>>  		mdelay(1);
>>  	}
>> +
>> +	arch_spin_unlock(&lock);
>> +out_restore_irq:
>> +	local_irq_restore(flags);
> 
> This spinlock is never actually used as a spinlock - it's a "in progress" flag. Why 
> not use a flag and test_and_set_bit()?

Yep, it's a "in progress" flag, I will change to use a flag to replace 
the spinlock.


> Also, the irq disabling really needed, will this code ever be called with irqs on?

This code could be called with irqs on.

If the arch_trigger_all_cpu_backtrace() was triggered by
"spin_lock()"'s spin_lock_debug detector, it is possible that
the irq is enabled, thus we have to save and disable it here.


Thanks,

Dongdong

> 
> Thanks,
> 
> 	Ingo
> 

