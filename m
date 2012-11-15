Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768640Ab2KOSN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 13:13:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19413 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768645Ab2KOSNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 13:13:25 -0500
X-Authority-Analysis: v=2.0 cv=RoZH3VaK c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=lD0sz97EK_QA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=CI89Ef65gYcA:10 a=_PDDHvuODchDdv3j_sQA:9 a=PUjeQqilurYA:10 a=Viw3QusGWpqWWhok:21 a=KJvy_1wnfT4TSePM:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1353003204.18025.109.camel@gandalf.local.home>
Subject: Re: [PATCH RFC] irq_work: Flush work on CPU_DYING (was: Re: [PATCH
 7/7] printk: Wake up klogd using irq_work)
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Thu, 15 Nov 2012 13:13:24 -0500
In-Reply-To: <1352997261.18025.103.camel@gandalf.local.home>
References: <1352925457-15700-1-git-send-email-fweisbec@gmail.com>
	 <1352925457-15700-8-git-send-email-fweisbec@gmail.com>
	 <1352953617.18025.94.camel@gandalf.local.home>
	 <CAFTL4hzzhd5__VwR7N+VKpq1C27xHGgi4vj87drbcLghJ+Od5g@mail.gmail.com>
	 <1352997261.18025.103.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-15 at 11:34 -0500, Steven Rostedt wrote:


Frederic,

Please add this one fix below:

> Index: linux-rt.git/kernel/irq_work.c
> ===================================================================
> --- linux-rt.git.orig/kernel/irq_work.c
> +++ linux-rt.git/kernel/irq_work.c
> @@ -14,6 +14,7 @@
>  #include <linux/irqflags.h>
>  #include <linux/sched.h>
>  #include <linux/tick.h>
> +#include <linux/cpu.h>
>  #include <asm/processor.h>
>  
> 
> @@ -105,11 +106,7 @@ bool irq_work_needs_cpu(void)
>  	return true;
>  }
>  
> -/*
> - * Run the irq_work entries on this cpu. Requires to be ran from hardirq
> - * context with local IRQs disabled.
> - */
> -void irq_work_run(void)
> +static void __irq_work_run(void)
>  {
>  	unsigned long flags;
>  	struct irq_work *work;
> @@ -128,7 +125,6 @@ void irq_work_run(void)
>  	if (llist_empty(this_list))
>  		return;
>  
> -	BUG_ON(!in_irq());
>  	BUG_ON(!irqs_disabled());
>  
>  	llnode = llist_del_all(this_list);
> @@ -155,8 +151,23 @@ void irq_work_run(void)
>  		(void)cmpxchg(&work->flags, flags, flags & ~IRQ_WORK_BUSY);
>  	}
>  }
> +
> +/*
> + * Run the irq_work entries on this cpu. Requires to be ran from hardirq
> + * context with local IRQs disabled.
> + */
> +void irq_work_run(void)
> +{
> +	BUG_ON(!in_irq());
> +	__irq_work_run();
> +}
>  EXPORT_SYMBOL_GPL(irq_work_run);

#ifdef CONFIG_HOTPLUG_CPU
>  
> +static void irq_work_run_cpu_down(void)
> +{
> +	__irq_work_run();
> +}
#endif

Or just move the function into the #ifdef that is below.

-- Steve

> +
>  /*
>   * Synchronize against the irq_work @entry, ensures the entry is not
>   * currently in use.
> @@ -169,3 +180,35 @@ void irq_work_sync(struct irq_work *work
>  		cpu_relax();
>  }
>  EXPORT_SYMBOL_GPL(irq_work_sync);
> +
> +#ifdef CONFIG_HOTPLUG_CPU
> +static int irq_work_cpu_notify(struct notifier_block *self,
> +			       unsigned long action, void *hcpu)
> +{
> +	long cpu = (long)hcpu;
> +
> +	switch (action) {
> +	case CPU_DYING:
> +		/* Called from stop_machine */
> +		if (WARN_ON_ONCE(cpu != smp_processor_id()))
> +			break;
> +		irq_work_run_cpu_down();
> +		break;
> +	default:
> +		break;
> +	}
> +	return NOTIFY_OK;
> +}
> +
> +static struct notifier_block cpu_notify;
> +
> +static __init int irq_work_init_cpu_notifier(void)
> +{
> +	cpu_notify.notifier_call = irq_work_cpu_notify;
> +	cpu_notify.priority = 0;
> +	register_cpu_notifier(&cpu_notify);
> +	return 0;
> +}
> +device_initcall(irq_work_init_cpu_notifier);
> +
> +#endif /* CONFIG_HOTPLUG_CPU */
> 


