Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983Ab1GKPyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 11:54:16 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62167 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757926Ab1GKPyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 11:54:14 -0400
Date: Mon, 11 Jul 2011 17:54:09 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Sharp <dhsharp@google.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH v3] trace: Add x86 irq vector entry/exit tracepoints
Message-ID: <20110711155404.GB4109@somewhere.redhat.com>
References: <1306877298-31713-1-git-send-email-vnagarnaik@google.com>
 <1308681903-12840-1-git-send-email-vnagarnaik@google.com>
 <20110707233453.GE21115@somewhere>
 <CAJL_eku7ezDhSOaOxN4ACFas1rnX=uaV184ZK3-0fE60Rmwh8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJL_eku7ezDhSOaOxN4ACFas1rnX=uaV184ZK3-0fE60Rmwh8g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 05:54:02PM -0700, David Sharp wrote:
> On Thu, Jul 7, 2011 at 4:34 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> >> index b9338b8..159851c 100644
> >> --- a/arch/x86/kernel/apic/apic.c
> >> +++ b/arch/x86/kernel/apic/apic.c
> >> @@ -1792,6 +1792,7 @@ void smp_spurious_interrupt(struct pt_regs *regs)
> >>
> >>       exit_idle();
> >>       irq_enter();
> >> +     trace_irq_vector_entry(TRACE_SPURIOUS_APIC_VECTOR);
> >>       /*
> >>        * Check if this really is a spurious interrupt and ACK it
> >>        * if it is a vectored one.  Just in case...
> >> @@ -1806,6 +1807,7 @@ void smp_spurious_interrupt(struct pt_regs *regs)
> >>       /* see sw-dev-man vol 3, chapter 7.4.13.5 */
> >>       pr_info("spurious APIC interrupt on CPU#%d, "
> >>               "should never happen.\n", smp_processor_id());
> >> +     trace_irq_vector_exit(TRACE_SPURIOUS_APIC_VECTOR);
> >>       irq_exit();
> >>  }
> >>
> >
> > Seems a lot of these tracepoints fit under that pattern:
> >
> >                irq_enter();
> >        +       trace_irq_entry_entry(foo)
> >
> >                do things
> >
> >        +       trace_irq_exit(foo)
> >                irq_exit();
> >
> >
> > What if we instead had trace_irq_enter() inside irq_enter() and
> > trace_irq_exit() inside irq_exit() ?
> >
> > Then your specific irq tracepoints would just be one thing that inform us
> > about the nature of the interrupt:
> >
> >                irq_enter();
> >        +       trace_irq_vector_entry(foo);
> >
> >                do things
> >
> >                irq_exit();
> >
> > Those who are only interested in knowing when we have irqs can just turn
> > on trace_irq_enter() and trace_irq_exit().
> >
> > Those who want more details about the nature of these interrupts can turn
> > on trace_irq_vector() and trace_irq_exit().
> >
> > So you don't need the trace_irq_vector_exit anymore.
> >
> > How does that sound?
> 
> That roughly doubles the overhead of hitting these irqs, and since
> irqs can be nested, it's not guaranteed that the "irq_vector" event
> immediately follows "irq_enter", so I think the trace could be
> confusing.

irqs can nest if irqs are unmasked which I believe doesn't happen until
we reach the handler or we switch to softirq.

> 
> I also think it's far more useful to know which interrupt occurred
> than "some" interrupt occurred, and I don't see a case where one would
> not want that info.
> 
> Moving the tracepoints into irq_enter() and irq_exit() might be
> sensible, but I'd want to pass down that info.

Let me clarify what I proposed, we have that:

	irq_enter() // trace_irq_enter();

	trace_irq_vector_entry(foo);

	// handle irq...

	irq_exit() // trace_irq_exit()

So either you're only interested in tracing raw irqs and you don't care
about the nature of these and you only enable trace_irq_enter() and
trace_irq_exit(). Or you're interested in the nature of these and you
only enable trace_irq_vector_entry() and trace_irq_exit().

In fact we could even drop the trace_irq_enter() thing because I'm
not sure it's interesting.

All in one it doesn't bring more overhead.

What I'm more worried about actually is that in the case of trace_irq_handler_entry()
and trace_irq_handler_exit(), it becomes a useless tracepoint. And if you enable it
for other irq tracepoint symetric purposes, you'll have it there too and that's a bit
odd.

So perhaps we want to keep your way of doing this.

> >
> >
> >> diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
> >> index 00cbb27..9179dca 100644
> >> --- a/arch/x86/kernel/time.c
> >> +++ b/arch/x86/kernel/time.c
> >> @@ -13,6 +13,7 @@
> >>  #include <linux/interrupt.h>
> >>  #include <linux/time.h>
> >>  #include <linux/mca.h>
> >> +#include <trace/events/irq.h>
> >>
> >>  #include <asm/vsyscall.h>
> >>  #include <asm/x86_init.h>
> >> @@ -51,6 +52,13 @@ unsigned long profile_pc(struct pt_regs *regs)
> >>  }
> >>  EXPORT_SYMBOL(profile_pc);
> >>
> >> +static irqreturn_t timer_interrupt(int irq, void *dev_id);
> >> +static struct irqaction irq0  = {
> >> +     .handler = timer_interrupt,
> >> +     .flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL | IRQF_TIMER,
> >> +     .name = "timer"
> >> +};
> >> +
> >>  /*
> >>   * Default timer interrupt handler for PIT/HPET
> >>   */
> >> @@ -59,7 +67,9 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
> >>       /* Keep nmi watchdog up to date */
> >>       inc_irq_stat(irq0_irqs);
> >>
> >> +     trace_irq_handler_entry(irq, &irq0);
> >>       global_clock_event->event_handler(global_clock_event);
> >> +     trace_irq_handler_exit(irq, &irq0, 1);
> >
> > Seems it should go to generic event handlers in kernel/time ?
> 
> (same response as hrtimers, below...)
> 
> >
> >> diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
> >> index 4fc1205..d2f3f1f 100644
> >> --- a/include/trace/events/irq.h
> >> +++ b/include/trace/events/irq.h
> >> @@ -138,6 +138,90 @@ DEFINE_EVENT(softirq, softirq_raise,
> >>       TP_ARGS(vec_nr)
> >>  );
> >>
> >> +#if !defined(_TRACE_IRQ_VECTOR_ENUM)
> >> +#define _TRACE_IRQ_VECTOR_ENUM
> >> +enum {
> >> +     TRACE_NMI_VECTOR,
> >> +     TRACE_NOHZ_TIMER_VECTOR,
> >> +     TRACE_HRTIMER_VECTOR,
> >> +     TRACE_ONESHOT_TIMER_VECTOR,
> >> +     TRACE_PERIODIC_TIMER_BROADCAST_VECTOR,
> >> +     TRACE_PERIODIC_TIMER_VECTOR,
> >> +     TRACE_ERROR_APIC_VECTOR,
> >> +     TRACE_RESCHEDULE_VECTOR,
> >> +     TRACE_CALL_FUNCTION_VECTOR,
> >> +     TRACE_CALL_FUNCTION_SINGLE_VECTOR,
> >> +     TRACE_THERMAL_APIC_VECTOR,
> >> +     TRACE_THRESHOLD_APIC_VECTOR,
> >> +     TRACE_REBOOT_VECTOR,
> >> +     TRACE_SPURIOUS_APIC_VECTOR,
> >> +     TRACE_IRQ_WORK_VECTOR,
> >> +     TRACE_X86_PLATFORM_IPI_VECTOR,
> >> +     TRACE_INVALIDATE_TLB_VECTOR,
> >> +};
> >> +#endif
> >
> > Pure x86 things shouldn't be in a generic header.
> 
> Other platforms have IPI vector interrupts, so we can just remove
> "X86_" from the name. Would that work?

If that's not a generic thing, we probably don't want that here.

I'd rather propose you to include an arch file from include/trace/events/irq.h
and define in that arch file specific things.

> > include/trace/event/irq.h should contain generic things. And I'm not sure
> > we want some generalized vector namespace for that but rather single contained
> > tracepoint names that make sense:
> >
> > trace_ipi_function(), trace_irq_reschedule()...
> 
> I don't see how that can fit with putting the tracepoints in
> irq_enter() and irq_exit()...

With my above explanations I think it's clearer.

> Also I'm not sure it makes sense to bloat the trace events with
> individual tracepoints for interrupts. Some of these events are
> relatively rare in archs: RESCHEDULE_VECTOR is only in x86 and ia64,
> and IPI will not be in any unicore machine, for example. They may not
> warrant having their own events instead of an enum entry.

10 tracepoints is no bloating really. And the bloating can only be seen in
slow path (tracing enablement) and in image size. And yeah on boot too
probably but perhaps we can defer that one day.
The point is we should split things when that makes sense. Having an
all-in-one irq tracepoint is very uncomfortable.

What if someone is interested in tracing only resched ipis (and I do
sometimes, using a trace_printk() currently)? He would be
forced to use those vector_entry/vector_exit with a filter. Filters
should not be used to cope with a lack of tracepoint granularity. They
are not really efficient for that.

Also about reschedule interrupt, it's not so rare:

$ git grep scheduler_ipi
arch/alpha/kernel/smp.c:                        scheduler_ipi();
arch/arm/kernel/smp.c:          scheduler_ipi();
arch/blackfin/mach-common/smp.c:                        scheduler_ipi();
arch/cris/arch-v32/kernel/smp.c:                scheduler_ipi();
arch/ia64/kernel/irq_ia64.c:                    scheduler_ipi();
arch/ia64/xen/irq_xen.c:        scheduler_ipi();
arch/m32r/kernel/smp.c: scheduler_ipi();
arch/mips/cavium-octeon/smp.c:          scheduler_ipi();
arch/mips/kernel/smtc.c:        scheduler_ipi();
arch/mips/mti-malta/malta-int.c:        scheduler_ipi();
arch/mips/pmc-sierra/yosemite/smp.c:                    scheduler_ipi();
arch/mips/pmc-sierra/yosemite/smp.c:                    scheduler_ipi();
arch/mips/sgi-ip27/ip27-irq.c:          scheduler_ipi();
arch/mips/sgi-ip27/ip27-irq.c:          scheduler_ipi();
arch/mips/sibyte/bcm1480/smp.c:         scheduler_ipi();
arch/mips/sibyte/sb1250/smp.c:          scheduler_ipi();
arch/mn10300/kernel/smp.c:      scheduler_ipi();
arch/parisc/kernel/smp.c:                               scheduler_ipi();
arch/powerpc/kernel/smp.c:      scheduler_ipi();
arch/powerpc/kernel/smp.c:                      scheduler_ipi();
arch/s390/kernel/smp.c:         scheduler_ipi();
arch/sh/kernel/smp.c:           scheduler_ipi();
arch/sparc/kernel/smp_32.c:     scheduler_ipi();
arch/sparc/kernel/smp_64.c:     scheduler_ipi();
arch/tile/kernel/smp.c: scheduler_ipi();
arch/um/kernel/smp.c:                   scheduler_ipi();
arch/x86/kernel/smp.c:  scheduler_ipi();
arch/x86/xen/smp.c:     scheduler_ipi();

Just put a tracepoint in scheduler_ipi() and you are done.

> >
> > But vector namespace makes sense for archs yeah.
> >
> >>  /* This part must be outside protection */
> >> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> >> index a9205e3..84a0c70 100644
> >> --- a/kernel/hrtimer.c
> >> +++ b/kernel/hrtimer.c
> >> @@ -48,6 +48,7 @@
> >>
> >>  #include <asm/uaccess.h>
> >>
> >> +#include <trace/events/irq.h>
> >>  #include <trace/events/timer.h>
> >>
> >>  /*
> >> @@ -1244,6 +1245,8 @@ void hrtimer_interrupt(struct clock_event_device *dev)
> >>       ktime_t expires_next, now, entry_time, delta;
> >>       int i, retries = 0;
> >>
> >> +     trace_irq_vector_entry(TRACE_HRTIMER_VECTOR);
> >> +
> >>       BUG_ON(!cpu_base->hres_active);
> >>       cpu_base->nr_events++;
> >>       dev->next_event.tv64 = KTIME_MAX;
> >> @@ -1316,6 +1319,7 @@ retry:
> >>       if (expires_next.tv64 == KTIME_MAX ||
> >>           !tick_program_event(expires_next, 0)) {
> >>               cpu_base->hang_detected = 0;
> >> +             trace_irq_vector_exit(TRACE_HRTIMER_VECTOR);
> >>               return;
> >>       }
> >>
> >> @@ -1355,6 +1359,8 @@ retry:
> >>       tick_program_event(expires_next, 1);
> >>       printk_once(KERN_WARNING "hrtimer: interrupt took %llu ns\n",
> >>                   ktime_to_ns(delta));
> >> +
> >> +     trace_irq_vector_exit(TRACE_HRTIMER_VECTOR);
> >
> > We already have hrtimer tracepoints.
> >
> 
> Yes, but those events are about hrtimer events and buried deep in
> hrtimer code. If I enable all events in the "irq" trace event
> subsystem, I want to see every interrupt. I don't want to remember "oh
> yeah, I need to enable x,y,z events too." Putting the event in the
> "irq" subsystem and in the interrupt handler makes this crystal clear.
> And if the hrtimer code is (or is ever) such that an interrupt path
> doesn't reach the hrtimer tracepoints, I still want to know that the
> interrupt occurred.
> 
> Here's our motivation: We use interrupt events, along with traps,
> syscall, and sched_switch events to know when kernel code is running
> instead of user code. So, being clear that we got all interrupts (and
> which interrupt) is important.

Ok I see your point then.

But then have a generic single trace_irq_timer() (may be cut down in entry/exit if
you want).

But I don't think we really want to  into HRTIMER, PERIODIC, ONESHOT, BROADCAST
vectors. That's sounds like the wrong place to provide these details.

If we want higher level details, then we can enable hrtimer tracepoints, and/or we add some
tracepoints in the timer subsystem to know with what we are dealing with.

Does that make sense?
