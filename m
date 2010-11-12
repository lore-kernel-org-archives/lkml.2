Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab0KLCiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 21:38:12 -0500
Received: from mail.windriver.com ([147.11.1.11]:39377 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab0KLCiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 21:38:10 -0500
Message-ID: <4CDCA895.7010806@windriver.com>
Date: Fri, 12 Nov 2010 10:38:13 +0800
From: DDD <dongdong.deng@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: dzickus@redhat.com
CC: Dongdong Deng <dongdong.deng@windriver.com>, mingo@elte.hu,
        peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [V3 PATCH] x86: avoid calling arch_trigger_all_cpu_backtrace()
 at the same time on SMP
References: <1289473307-7965-1-git-send-email-dongdong.deng@windriver.com>
In-Reply-To: <1289473307-7965-1-git-send-email-dongdong.deng@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Nov 2010 02:37:36.0744 (UTC) FILETIME=[9135DE80:01CB8212]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dongdong Deng wrote:
> The spin_lock_debug/rcu_cpu_stall detector uses
> trigger_all_cpu_backtrace() to dump cpu backtrace.
> Therefore it is possible that trigger_all_cpu_backtrace()
> could be called at the same time on different CPUs, which
> triggers and 'unknown reason NMI' warning. The following case
> illustrates the problem:
> 
>       CPU1                    CPU2                     ...   CPU N
>                        trigger_all_cpu_backtrace()
>                        set "backtrace_mask" to cpu mask
>                                |
> generate NMI interrupts  generate NMI interrupts       ...
>     \                          |                               /
>      \                         |                              /
>    The "backtrace_mask" will be cleaned by the first NMI interrupt
>   at nmi_watchdog_tick(), then the following NMI interrupts generated
> by other cpus's arch_trigger_all_cpu_backtrace() will be took as
> unknown reason NMI interrupts.
> 
> This patch uses a lock to avoid the problem, and stop the
> arch_trigger_all_cpu_backtrace() calling to avoid dumping double cpu
> backtrace info when there is already a trigger_all_cpu_backtrace()
> in progress.
> 
> Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
> Reviewed-by: Bruce Ashfield <bruce.ashfield@windriver.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: "H. Peter Anvin" <hpa@zytor.com>
> CC: x86@kernel.org
> CC: linux-kernel@vger.kernel.org
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> ---
>  arch/x86/kernel/apic/hw_nmi.c |   23 +++++++++++++++++++++++
>  arch/x86/kernel/apic/nmi.c    |   23 +++++++++++++++++++++++
>  2 files changed, 46 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
> index cefd694..bfdab3b 100644
> --- a/arch/x86/kernel/apic/hw_nmi.c
> +++ b/arch/x86/kernel/apic/hw_nmi.c
> @@ -26,9 +26,27 @@ u64 hw_nmi_get_sample_period(void)
>  }
>  
>  #ifdef ARCH_HAS_NMI_WATCHDOG
> +/* "in progress" flag of arch_trigger_all_cpu_backtrace */
> +static unsigned long backtrace_flag;
> +
>  void arch_trigger_all_cpu_backtrace(void)
>  {
>  	int i;
> +	unsigned long flags;
> +
> +	/*
> +	 * Have to disable irq here, as the
> +	 * arch_trigger_all_cpu_backtrace() could be
> +	 * triggered by "spin_lock()" with irqs on.
> +	 */
> +	local_irq_save(flags);
> +
> +	if (test_and_set_bit(0, &backtrace_flag))
> +		/*
> +		 * If there is already a trigger_all_cpu_backtrace() in progress
> +		 * (backtrace_flag == 1), don't output double cpu dump infos.
> +		 */
> +		goto out_restore_irq;
>  
>  	cpumask_copy(to_cpumask(backtrace_mask), cpu_online_mask);
>  
> @@ -41,6 +59,11 @@ void arch_trigger_all_cpu_backtrace(void)
>  			break;
>  		mdelay(1);
>  	}
> +
> +	clear_bit(0, &backtrace_flag);

Hi Don,

    The clear_bit() on x86 (arch/x86/include/asm/bitops.h) does not 
contain a memory barrier, Could you add a memory barrier ops here when 
you pick up this patch?

+	clear_bit(0, &backtrace_flag);
+	smp_mb__after_clear_bit();


Thanks,
Dongdong

> +
> +out_restore_irq:
> +	local_irq_restore(flags);
>  }
>  
>  static int __kprobes
> diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
> index c90041c..bd9cb79 100644
> --- a/arch/x86/kernel/apic/nmi.c
> +++ b/arch/x86/kernel/apic/nmi.c
> @@ -549,9 +549,27 @@ int do_nmi_callback(struct pt_regs *regs, int cpu)
>  	return 0;
>  }
>  
> +/* "in progress" flag of arch_trigger_all_cpu_backtrace */
> +static unsigned long backtrace_flag;
> +
>  void arch_trigger_all_cpu_backtrace(void)
>  {
>  	int i;
> +	unsigned long flags;
> +
> +	/*
> +	 * Have to disable irq here, as the
> +	 * arch_trigger_all_cpu_backtrace() could be
> +	 * triggered by "spin_lock()" with irqs on.
> +	 */
> +	local_irq_save(flags);
> +
> +	if (test_and_set_bit(0, &backtrace_flag))
> +		/*
> +		 * If there is already a trigger_all_cpu_backtrace() in progress
> +		 * (backtrace_flag == 1), don't output double cpu dump infos.
> +		 */
> +		goto out_restore_irq;
>  
>  	cpumask_copy(to_cpumask(backtrace_mask), cpu_online_mask);
>  
> @@ -564,4 +582,9 @@ void arch_trigger_all_cpu_backtrace(void)
>  			break;
>  		mdelay(1);
>  	}
> +
> +	clear_bit(0, &backtrace_flag);
> +
> +out_restore_irq:
> +	local_irq_restore(flags);
>  }

