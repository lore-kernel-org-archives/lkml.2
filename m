Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab1GLSJJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 14:09:09 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54821 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab1GLSJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 14:09:07 -0400
Date: Tue, 12 Jul 2011 20:09:02 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: David Sharp <dhsharp@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH v3] trace: Add x86 irq vector entry/exit tracepoints
Message-ID: <20110712180859.GC9201@somewhere>
References: <1306877298-31713-1-git-send-email-vnagarnaik@google.com>
 <1308681903-12840-1-git-send-email-vnagarnaik@google.com>
 <20110707233453.GE21115@somewhere>
 <CAJL_eku7ezDhSOaOxN4ACFas1rnX=uaV184ZK3-0fE60Rmwh8g@mail.gmail.com>
 <20110711155404.GB4109@somewhere.redhat.com>
 <CAL26m8+ca64BDrQUohxcZfUpZQgn7bNkup=Q92LaTmpvorm9fQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL26m8+ca64BDrQUohxcZfUpZQgn7bNkup=Q92LaTmpvorm9fQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 11:21:04AM -0700, Vaibhav Nagarnaik wrote:
> On Mon, Jul 11, 2011 at 8:54 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > Let me clarify what I proposed, we have that:
> >
> >        irq_enter() // trace_irq_enter();
> >
> >        trace_irq_vector_entry(foo);
> >
> >        // handle irq...
> >
> >        irq_exit() // trace_irq_exit()
> >
> > So either you're only interested in tracing raw irqs and you don't care
> > about the nature of these and you only enable trace_irq_enter() and
> > trace_irq_exit(). Or you're interested in the nature of these and you
> > only enable trace_irq_vector_entry() and trace_irq_exit().
> >
> > In fact we could even drop the trace_irq_enter() thing because I'm
> > not sure it's interesting.
> >
> > All in one it doesn't bring more overhead.
> >
> > What I'm more worried about actually is that in the case of trace_irq_handler_entry()
> > and trace_irq_handler_exit(), it becomes a useless tracepoint. And if you enable it
> > for other irq tracepoint symetric purposes, you'll have it there too and that's a bit
> > odd.
> >
> > So perhaps we want to keep your way of doing this.
> >
> 
> We proposed this patch as a way of tracing raw interrupts from the
> platform, which is why it traces all the raw interrupts and does not use
> any specific interrupt data in the events. So when someone wants to know
> just the interrupts that are being triggered in the system, this
> tracepoint can be used.

Which one? Not sure I understand what you mean.

> There can be more involved and detailed tracepoints for individual IRQs,
> as you proposed to have trace_ipi_function(), etc.

I was arguing about having a tracepoint in irq_exit(), so I guess we are not talking about the same
things.
 
> > On Thu, Jul 07, 2011 at 05:54:02PM -0700, David Sharp wrote:
> >> Here's our motivation: We use interrupt events, along with traps,
> >> syscall, and sched_switch events to know when kernel code is running
> >> instead of user code. So, being clear that we got all interrupts (and
> >> which interrupt) is important.
> >
> > Ok I see your point then.
> >
> > But then have a generic single trace_irq_timer() (may be cut down in entry/exit if
> > you want).
> >
> > But I don't think we really want to  into HRTIMER, PERIODIC, ONESHOT, BROADCAST
> > vectors. That's sounds like the wrong place to provide these details.
> >
> > If we want higher level details, then we can enable hrtimer tracepoints, and/or we add some
> > tracepoints in the timer subsystem to know with what we are dealing with.
> >
> > Does that make sense?
> >
> 
> I added the details about the timer handler because it would be
> difficult to understand exactly which generic event handlers the
> platform LOCAL_TIMER_IRQ_VECTOR led to.

Generic event handler is already a high level detail. At the point we call
that generic event handler, we have climbed several steps, we have left the
world of pure irq vectors.

What is normally suitable here to get more semantic details is to use higher level
tracepoints like high resolution timer ones.

If these are not enough for you, you can add a trace_hrtimer_interrupt()
in the irq tracepoint subsystem. If it's in the irq subsystem you include
it with the rest of irq traces.

> Once again, this is meant as a raw interrupt tracepoint which provides 2
> things: an interrupt occurred and the nature of interrupt. As you
> mentioned there are high level hrtimer tracepoints and there can be
> similar highly detailed tracepoints for each IRQ as required with more
> data about the interrupt, but I believe this is the wrong patch to put
> them in.

But the problem is you are actually messing up irq raw events and higher
level details.

That vector space should lay in the arch low ground and never go further.
Finding one of these trace vector things elsewhere than arch/ shouldn't
ever happen.

As far as possible, tracepoints must be self-contained events and be
self-explanatory. We want granularity there.

There should never be a reschedule vector to trace. That event is self
contained and wants its own tracepoints. irq/reschedule_interrupt is
something any kernel developer can understand and give some sense out
by browsing the events. But irq/interrupt_vector is opaque as hell.

What happens if I want to trace only reschedule interrupts? I'd be
forced to enable that vector, browse its format, find the value
for the reschedule vector, apply a filter.
That requires a lot of time and skills compared to just enable a tracepoint.

Your patch mixes up too much things:

- pure arch tracepoints. Only those want that vector naming I think.

- IPIs that should go to kernel/smp.c

- reschedule interrupt

- irq work

- ...

If you cut the things into more self-contained topics, this is going to be
much easier to review and thus much faster to apply and push.

Also your goal is to not miss any interrupts. So if everything goes to the irq
tracepoint subsystem, you just need to enable everything there and you are
done. You don't need a big vector tracepoint to ensure you won't miss something.
