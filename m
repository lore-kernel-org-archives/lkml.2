Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab0DUVAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 17:00:00 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59776 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab0DUU76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 16:59:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=paAL4ohm/ALP3pqg1fTygIW3hUq78uac8SEXJvOBwQ0Muqz8p5FZerw3cNOjmCMcx9
         Rj3TkIm6QiCT1IvYxQDwsftPgE6aO/Avy/S86n8tCf//F0r5v8YmlLzi/d12IIsAHGJg
         pkJouUzVCu0eDHL6vmgzGoLhuqP1visPIXE0Q=
Date: Wed, 21 Apr 2010 23:00:04 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: mingo@elte.hu, peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com
Subject: Re: [PATCH 5/6] [x86] watchdog: move trigger_all_cpu_backtrace to
	its own die_notifier
Message-ID: <20100421210003.GC8677@nowhere>
References: <1271777043-3807-1-git-send-email-dzickus@redhat.com> <1271777043-3807-6-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271777043-3807-6-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 11:24:02AM -0400, Don Zickus wrote:
> As part of the transition of the nmi watchdog to something more generic,
> the trigger_all_cpu_backtrace code is getting left behind.  Put it in its
> own die_notifier so it can still be used.
> 
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> ---
>  arch/x86/kernel/apic/hw_nmi.c |   65 ++++++++++++++++++++++++++++++++---------
>  1 files changed, 51 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
> index 79425f9..19d3435 100644
> --- a/arch/x86/kernel/apic/hw_nmi.c
> +++ b/arch/x86/kernel/apic/hw_nmi.c
> @@ -17,6 +17,10 @@
>  #include <linux/cpumask.h>
>  #include <linux/kernel_stat.h>
>  #include <asm/mce.h>
> +#include <linux/kdebug.h>
> +#include <linux/notifier.h>
> +#include <linux/kprobes.h>
> +
>  
>  #include <linux/nmi.h>
>  #include <linux/module.h>
> @@ -54,20 +58,6 @@ int hw_nmi_is_cpu_stuck(struct pt_regs *regs)
>  	unsigned int sum;
>  	int cpu = smp_processor_id();
>  
> -	/* FIXME: cheap hack for this check, probably should get its own
> -	 * die_notifier handler
> -	 */
> -	if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
> -		static DEFINE_SPINLOCK(lock);	/* Serialise the printks */
> -
> -		spin_lock(&lock);
> -		printk(KERN_WARNING "NMI backtrace for cpu %d\n", cpu);
> -		show_regs(regs);
> -		dump_stack();
> -		spin_unlock(&lock);
> -		cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
> -	}
> -
>  	/* if we are doing an mce, just assume the cpu is not stuck */
>  	/* Could check oops_in_progress here too, but it's safer not to */
>  	if (mce_in_progress())
> @@ -109,6 +99,53 @@ void arch_trigger_all_cpu_backtrace(void)
>  		mdelay(1);
>  	}
>  }
> +
> +static int __kprobes
> +arch_trigger_all_cpu_backtrace_handler(struct notifier_block *self,
> +			 unsigned long cmd, void *__args)
> +{
> +	struct die_args *args = __args;
> +	struct pt_regs *regs;
> +	int cpu = smp_processor_id();
> +
> +	switch (cmd) {
> +	case DIE_NMI:
> +	case DIE_NMI_IPI:
> +		break;
> +
> +	default:
> +		return NOTIFY_DONE;
> +	}
> +
> +	regs = args->regs;
> +
> +	if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
> +		static DEFINE_SPINLOCK(lock);	/* Serialise the printks */
> +
> +		spin_lock(&lock);



This should be an arch_spin_lock(), so that it won't sleep with rt mutex.


In fact this whole function can be moved to generic code, right?



> +		printk(KERN_WARNING "NMI backtrace for cpu %d\n", cpu);
> +		show_regs(regs);
> +		dump_stack();
> +		spin_unlock(&lock);
> +		cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
> +		return NOTIFY_STOP;
> +	}
> +
> +	return NOTIFY_DONE;
> +}
> +
> +static __read_mostly struct notifier_block backtrace_notifier = {
> +	.notifier_call          = arch_trigger_all_cpu_backtrace_handler,
> +	.next                   = NULL,
> +	.priority               = 1
> +};
> +
> +static int __init register_trigger_all_cpu_backtrace(void)
> +{
> +	register_die_notifier(&backtrace_notifier);
> +	return 0;
> +}
> +early_initcall(register_trigger_all_cpu_backtrace);
>  #endif
>  
>  /* STUB calls to mimic old nmi_watchdog behaviour */
> -- 
> 1.6.5.2
> 

