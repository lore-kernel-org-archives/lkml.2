Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab0KSC7y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 21:59:54 -0500
Received: from mail.windriver.com ([147.11.1.11]:50034 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab0KSC7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 21:59:53 -0500
Message-ID: <4CE5E849.9010406@windriver.com>
Date: Fri, 19 Nov 2010 11:00:25 +0800
From: DDD <dongdong.deng@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>, Don Zickus <dzickus@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH 3/3] x86: Avoid calling	arch_trigger_all_cpu_backtrace()
 at the same time
References: <1289573455-3410-1-git-send-email-dzickus@redhat.com> <1289573455-3410-3-git-send-email-dzickus@redhat.com> <20101118155722.GC5374@nowhere>
In-Reply-To: <20101118155722.GC5374@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Nov 2010 02:59:21.0943 (UTC) FILETIME=[C40FAE70:01CB8795]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Fri, Nov 12, 2010 at 09:50:55AM -0500, Don Zickus wrote:
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
>>
>> The "backtrace_mask" will be cleaned by the first NMI interrupt
>> at nmi_watchdog_tick(), then the following NMI interrupts generated
>> by other cpus's arch_trigger_all_cpu_backtrace() will be taken as
>> unknown reason NMI interrupts.
>>
>> This patch uses a test_and_set to avoid the problem, and stop the
>> arch_trigger_all_cpu_backtrace() from calling to avoid dumping a
>> double cpu backtrace info when there is already a
>> trigger_all_cpu_backtrace() in progress.
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
>>  arch/x86/kernel/apic/hw_nmi.c |   24 ++++++++++++++++++++++++
>>  1 files changed, 24 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
>> index f349647..d892896 100644
>> --- a/arch/x86/kernel/apic/hw_nmi.c
>> +++ b/arch/x86/kernel/apic/hw_nmi.c
>> @@ -27,9 +27,27 @@ u64 hw_nmi_get_sample_period(void)
>>  /* For reliability, we're prepared to waste bits here. */
>>  static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
>>  
>> +/* "in progress" flag of arch_trigger_all_cpu_backtrace */
>> +static unsigned long backtrace_flag;
>> +
>>  void arch_trigger_all_cpu_backtrace(void)
>>  {
>>  	int i;
>> +	unsigned long flags;
>> +
>> +	/*
>> +	 * Have to disable irq here, as the
>> +	 * arch_trigger_all_cpu_backtrace() could be
>> +	 * triggered by "spin_lock()" with irqs on.
>> +	 */
>> +	local_irq_save(flags);
> 
> 
> 
> I'm not sure I understand why you disable irqs here. It looks
> safe with the test_and_set_bit already.

Hi Frederic,

Yep, after we use test_and_set_bit to replace spin_lock,
the disable irqs ops obvious could be removed here.

I will redo this patch, and send it to Don.

Thanks,
Dongdong

> 
> 
> 
>> +
>> +	if (test_and_set_bit(0, &backtrace_flag))
>> +		/*
>> +		 * If there is already a trigger_all_cpu_backtrace() in progress
>> +		 * (backtrace_flag == 1), don't output double cpu dump infos.
>> +		 */
>> +		goto out_restore_irq;
>>  
>>  	cpumask_copy(to_cpumask(backtrace_mask), cpu_online_mask);
>>  
>> @@ -42,6 +60,12 @@ void arch_trigger_all_cpu_backtrace(void)
>>  			break;
>>  		mdelay(1);
>>  	}
>> +
>> +	clear_bit(0, &backtrace_flag);
>> +	smp_mb__after_clear_bit();
>> +
>> +out_restore_irq:
>> +	local_irq_restore(flags);
>>  }
>>  
>>  static int __kprobes
>> -- 
>> 1.7.2.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

