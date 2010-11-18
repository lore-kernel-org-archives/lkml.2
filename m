Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759087Ab0KRP5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 10:57:33 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40465 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab0KRP5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 10:57:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=j85orrSQMLqEEi8AXehO/OHz9URVB2HtTVujBVHWsoZ48SfgTvOgGlR/fVywIdtKRZ
         Q4znT3vxFwzugiKSIfnDYZ4NwMTpipWjzndtLMSeYTHH4rAGyl+b81jmb1t81TJS7cmE
         pgIadb91yio9RnS2FzfH80jsPV2oeVqI43zz8=
Date: Thu, 18 Nov 2010 16:57:26 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Dongdong Deng <dongdong.deng@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH 3/3] x86: Avoid calling
	arch_trigger_all_cpu_backtrace() at the same time
Message-ID: <20101118155722.GC5374@nowhere>
References: <1289573455-3410-1-git-send-email-dzickus@redhat.com> <1289573455-3410-3-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289573455-3410-3-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 09:50:55AM -0500, Don Zickus wrote:
> From: Dongdong Deng <dongdong.deng@windriver.com>
> 
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
> 
> The "backtrace_mask" will be cleaned by the first NMI interrupt
> at nmi_watchdog_tick(), then the following NMI interrupts generated
> by other cpus's arch_trigger_all_cpu_backtrace() will be taken as
> unknown reason NMI interrupts.
> 
> This patch uses a test_and_set to avoid the problem, and stop the
> arch_trigger_all_cpu_backtrace() from calling to avoid dumping a
> double cpu backtrace info when there is already a
> trigger_all_cpu_backtrace() in progress.
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
>  arch/x86/kernel/apic/hw_nmi.c |   24 ++++++++++++++++++++++++
>  1 files changed, 24 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
> index f349647..d892896 100644
> --- a/arch/x86/kernel/apic/hw_nmi.c
> +++ b/arch/x86/kernel/apic/hw_nmi.c
> @@ -27,9 +27,27 @@ u64 hw_nmi_get_sample_period(void)
>  /* For reliability, we're prepared to waste bits here. */
>  static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
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



I'm not sure I understand why you disable irqs here. It looks
safe with the test_and_set_bit already.



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
> @@ -42,6 +60,12 @@ void arch_trigger_all_cpu_backtrace(void)
>  			break;
>  		mdelay(1);
>  	}
> +
> +	clear_bit(0, &backtrace_flag);
> +	smp_mb__after_clear_bit();
> +
> +out_restore_irq:
> +	local_irq_restore(flags);
>  }
>  
>  static int __kprobes
> -- 
> 1.7.2.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

