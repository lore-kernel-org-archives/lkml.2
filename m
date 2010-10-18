Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab0JRKxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 06:53:49 -0400
Received: from mail.windriver.com ([147.11.1.11]:41896 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab0JRKxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 06:53:48 -0400
Message-ID: <4CBC28BF.4090203@windriver.com>
Date: Mon, 18 Oct 2010 19:00:15 +0800
From: DDD <dongdong.deng@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: tglx@linutronix.de, hpa@zytor.com, mingo@elte.hu
CC: Dongdong Deng <dongdong.deng@windriver.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, bruce.ashfield@windriver.com
Subject: Re: [PATCH] x86: avoid calling arch_trigger_all_cpu_backtrace() at
 the same time on SMP
References: <1286793111-27579-1-git-send-email-dongdong.deng@windriver.com>
In-Reply-To: <1286793111-27579-1-git-send-email-dongdong.deng@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Oct 2010 10:53:30.0911 (UTC) FILETIME=[B3BFB2F0:01CB6EB2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC to Ingo's mingo@elte.hu and add some code explains for this patch.

Dongdong


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
> ---
>  arch/x86/kernel/apic/hw_nmi.c |   14 ++++++++++++++
>  arch/x86/kernel/apic/nmi.c    |   14 ++++++++++++++
>  2 files changed, 28 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
> index cefd694..3aea0a5 100644
> --- a/arch/x86/kernel/apic/hw_nmi.c
> +++ b/arch/x86/kernel/apic/hw_nmi.c
> @@ -29,6 +29,16 @@ u64 hw_nmi_get_sample_period(void)
>  void arch_trigger_all_cpu_backtrace(void)
>  {
>  	int i;
> +	static arch_spinlock_t lock = __ARCH_SPIN_LOCK_UNLOCKED;

Why an arch spin lock vs just using a raw spin lock?
for example. static DEFINE_RAW_SPINLOCK(lock);

The spin_lock_debug detector was used in raw_spinlock too.

arch_trigger_all_cpu_backtrace() -->
   raw_spin_lock(lock)      -->
   _raw_spin_lock(lock)     -->
   __raw_spin_lock(lock)    -->
   do_raw_spin_lock(lock)   -->
   __spin_lock_debug(lock)  -->
   trigger_all_cpu_backtrace()

Therefor, we have to use arch spin lock here.



> +	unsigned long flags;
> +
> +	local_irq_save(flags);

Why have to save the irq's here?

When the arch_trigger_all_cpu_backtrace() was triggered by
"spin_lock()"'s spin_lock_debug detector, it is possible that
the irq is enabled, thus we have to save and disable it here.



> +	if (!arch_spin_trylock(&lock))
> +		/*
> +		 * If there is already a trigger_all_cpu_backtrace()
> +		 * in progress, don't output double cpu dump infos.
> +		 */
> +		goto out_restore_irq;
>  
>  	cpumask_copy(to_cpumask(backtrace_mask), cpu_online_mask);
>  
> @@ -41,6 +51,10 @@ void arch_trigger_all_cpu_backtrace(void)
>  			break;
>  		mdelay(1);
>  	}
> +
> +	arch_spin_unlock(&lock);
> +out_restore_irq:
> +	local_irq_restore(flags);
>  }
>  
>  static int __kprobes
> diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
> index a43f71c..5fa8a13 100644
> --- a/arch/x86/kernel/apic/nmi.c
> +++ b/arch/x86/kernel/apic/nmi.c
> @@ -552,6 +552,16 @@ int do_nmi_callback(struct pt_regs *regs, int cpu)
>  void arch_trigger_all_cpu_backtrace(void)
>  {
>  	int i;
> +	static arch_spinlock_t lock = __ARCH_SPIN_LOCK_UNLOCKED;
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +	if (!arch_spin_trylock(&lock))
> +		/*
> +		 * If there is already a trigger_all_cpu_backtrace()
> +		 * in progress, don't output double cpu dump infos.
> +		 */
> +		goto out_restore_irq;
>  
>  	cpumask_copy(to_cpumask(backtrace_mask), cpu_online_mask);
>  
> @@ -564,4 +574,8 @@ void arch_trigger_all_cpu_backtrace(void)
>  			break;
>  		mdelay(1);
>  	}
> +
> +	arch_spin_unlock(&lock);
> +out_restore_irq:
> +	local_irq_restore(flags);
>  }





