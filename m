Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab1GGXfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 19:35:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38700 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab1GGXfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 19:35:01 -0400
Date: Fri, 8 Jul 2011 01:34:57 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH v3] trace: Add x86 irq vector entry/exit tracepoints
Message-ID: <20110707233453.GE21115@somewhere>
References: <1306877298-31713-1-git-send-email-vnagarnaik@google.com>
 <1308681903-12840-1-git-send-email-vnagarnaik@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308681903-12840-1-git-send-email-vnagarnaik@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 11:45:03AM -0700, Vaibhav Nagarnaik wrote:
> From: Jiaying Zhang <jiayingz@google.com>
> 
> The current interrupt trace of irq_handler_entry and irq_handler_exit
> give traces of when an interrupt is handled. They provide good data
> about when the system is running in kernel space and how it affects the
> currently running applications.
> 
> Apart from this, they are IRQ vectors which trigger the system into
> kernel space. Tracing such events gives us the trace of where the system
> is spending its time. We want to know which cores are handling
> interrupts and how they are affecting other processes in the system.
> Also, the trace provides information about when the cores are idle and
> which interrupts are changing that state.
> 
> The following patch adds the event definition and trace instrumentation
> for interrupt vectors. A lookup table is provided to print out readable
> IRQ vector names. Apart from the IRQ vectors handled in the generic
> kernel code, some x86 specific IRQ vectors are also traced. The lookup
> table can be extended by adding other arch-specific IRQ vectors.
> 
> Changelog:
> v2-v3
> * Move the irq_vector_{entry|exit} tracepoints back under irq/ sub
>   folder
> * Trace the common IRQs in generic kernel code so that all archs can
>   benefit.
> 
> v1-v2
> * Move the irq_vector_{entry|exit} tracepoints under irq_vectors/ sub
>   folder
> 
> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
> ---
>  arch/x86/kernel/apic/apic.c              |    4 ++
>  arch/x86/kernel/cpu/mcheck/therm_throt.c |    2 +
>  arch/x86/kernel/cpu/mcheck/threshold.c   |    2 +
>  arch/x86/kernel/irq.c                    |    4 ++
>  arch/x86/kernel/time.c                   |   16 ++++--
>  arch/x86/kernel/traps.c                  |    3 +
>  arch/x86/mm/tlb.c                        |    2 +
>  include/trace/events/irq.h               |   84 ++++++++++++++++++++++++++++++
>  kernel/hrtimer.c                         |    6 ++
>  kernel/irq_work.c                        |    4 ++
>  kernel/sched.c                           |    4 ++
>  kernel/smp.c                             |    5 ++
>  kernel/time/tick-broadcast.c             |   16 +++++-
>  kernel/time/tick-common.c                |    8 +++-
>  kernel/time/tick-sched.c                 |    4 ++
>  15 files changed, 155 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index b9338b8..159851c 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -1792,6 +1792,7 @@ void smp_spurious_interrupt(struct pt_regs *regs)
>  
>  	exit_idle();
>  	irq_enter();
> +	trace_irq_vector_entry(TRACE_SPURIOUS_APIC_VECTOR);
>  	/*
>  	 * Check if this really is a spurious interrupt and ACK it
>  	 * if it is a vectored one.  Just in case...
> @@ -1806,6 +1807,7 @@ void smp_spurious_interrupt(struct pt_regs *regs)
>  	/* see sw-dev-man vol 3, chapter 7.4.13.5 */
>  	pr_info("spurious APIC interrupt on CPU#%d, "
>  		"should never happen.\n", smp_processor_id());
> +	trace_irq_vector_exit(TRACE_SPURIOUS_APIC_VECTOR);
>  	irq_exit();
>  }
>

Seems a lot of these tracepoints fit under that pattern:

                irq_enter();
        +       trace_irq_entry_entry(foo)

                do things

        +       trace_irq_exit(foo)
                irq_exit();


What if we instead had trace_irq_enter() inside irq_enter() and
trace_irq_exit() inside irq_exit() ?

Then your specific irq tracepoints would just be one thing that inform us
about the nature of the interrupt:

                irq_enter();
        +       trace_irq_vector_entry(foo);

                do things

                irq_exit();

Those who are only interested in knowing when we have irqs can just turn
on trace_irq_enter() and trace_irq_exit().

Those who want more details about the nature of these interrupts can turn
on trace_irq_vector() and trace_irq_exit().

So you don't need the trace_irq_vector_exit anymore.

How does that sound?

  
> diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
> index 00cbb27..9179dca 100644
> --- a/arch/x86/kernel/time.c
> +++ b/arch/x86/kernel/time.c
> @@ -13,6 +13,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/time.h>
>  #include <linux/mca.h>
> +#include <trace/events/irq.h>
>  
>  #include <asm/vsyscall.h>
>  #include <asm/x86_init.h>
> @@ -51,6 +52,13 @@ unsigned long profile_pc(struct pt_regs *regs)
>  }
>  EXPORT_SYMBOL(profile_pc);
>  
> +static irqreturn_t timer_interrupt(int irq, void *dev_id);
> +static struct irqaction irq0  = {
> +	.handler = timer_interrupt,
> +	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL | IRQF_TIMER,
> +	.name = "timer"
> +};
> +
>  /*
>   * Default timer interrupt handler for PIT/HPET
>   */
> @@ -59,7 +67,9 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
>  	/* Keep nmi watchdog up to date */
>  	inc_irq_stat(irq0_irqs);
>  
> +	trace_irq_handler_entry(irq, &irq0);
>  	global_clock_event->event_handler(global_clock_event);
> +	trace_irq_handler_exit(irq, &irq0, 1);

Seems it should go to generic event handlers in kernel/time ?

> diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
> index 4fc1205..d2f3f1f 100644
> --- a/include/trace/events/irq.h
> +++ b/include/trace/events/irq.h
> @@ -138,6 +138,90 @@ DEFINE_EVENT(softirq, softirq_raise,
>  	TP_ARGS(vec_nr)
>  );
>  
> +#if !defined(_TRACE_IRQ_VECTOR_ENUM)
> +#define _TRACE_IRQ_VECTOR_ENUM
> +enum {
> +	TRACE_NMI_VECTOR,
> +	TRACE_NOHZ_TIMER_VECTOR,
> +	TRACE_HRTIMER_VECTOR,
> +	TRACE_ONESHOT_TIMER_VECTOR,
> +	TRACE_PERIODIC_TIMER_BROADCAST_VECTOR,
> +	TRACE_PERIODIC_TIMER_VECTOR,
> +	TRACE_ERROR_APIC_VECTOR,
> +	TRACE_RESCHEDULE_VECTOR,
> +	TRACE_CALL_FUNCTION_VECTOR,
> +	TRACE_CALL_FUNCTION_SINGLE_VECTOR,
> +	TRACE_THERMAL_APIC_VECTOR,
> +	TRACE_THRESHOLD_APIC_VECTOR,
> +	TRACE_REBOOT_VECTOR,
> +	TRACE_SPURIOUS_APIC_VECTOR,
> +	TRACE_IRQ_WORK_VECTOR,
> +	TRACE_X86_PLATFORM_IPI_VECTOR,
> +	TRACE_INVALIDATE_TLB_VECTOR,
> +};
> +#endif

Pure x86 things shouldn't be in a generic header.

include/trace/event/irq.h should contain generic things. And I'm not sure
we want some generalized vector namespace for that but rather single contained
tracepoint names that make sense:

trace_ipi_function(), trace_irq_reschedule()...

But vector namespace makes sense for archs yeah.

>  /* This part must be outside protection */
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index a9205e3..84a0c70 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -48,6 +48,7 @@
>  
>  #include <asm/uaccess.h>
>  
> +#include <trace/events/irq.h>
>  #include <trace/events/timer.h>
>  
>  /*
> @@ -1244,6 +1245,8 @@ void hrtimer_interrupt(struct clock_event_device *dev)
>  	ktime_t expires_next, now, entry_time, delta;
>  	int i, retries = 0;
>  
> +	trace_irq_vector_entry(TRACE_HRTIMER_VECTOR);
> +
>  	BUG_ON(!cpu_base->hres_active);
>  	cpu_base->nr_events++;
>  	dev->next_event.tv64 = KTIME_MAX;
> @@ -1316,6 +1319,7 @@ retry:
>  	if (expires_next.tv64 == KTIME_MAX ||
>  	    !tick_program_event(expires_next, 0)) {
>  		cpu_base->hang_detected = 0;
> +		trace_irq_vector_exit(TRACE_HRTIMER_VECTOR);
>  		return;
>  	}
>  
> @@ -1355,6 +1359,8 @@ retry:
>  	tick_program_event(expires_next, 1);
>  	printk_once(KERN_WARNING "hrtimer: interrupt took %llu ns\n",
>  		    ktime_to_ns(delta));
> +
> +	trace_irq_vector_exit(TRACE_HRTIMER_VECTOR);

We already have hrtimer tracepoints.
