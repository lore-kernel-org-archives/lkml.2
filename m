Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab0HBRKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 13:10:25 -0400
Received: from www.tglx.de ([62.245.132.106]:45511 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143Ab0HBRKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 13:10:24 -0400
Date: Mon, 2 Aug 2010 19:10:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <teheo@suse.de>
cc: lkml <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: [GIT PULL tip/genirq] Please pull from lost-spurious-irq
In-Reply-To: <4C56E42D.5010300@suse.de>
Message-ID: <alpine.LFD.2.00.1008021730250.27107@localhost.localdomain>
References: <4C5033D9.7030800@kernel.org> <4C50349F.7020002@suse.de> <alpine.LFD.2.00.1007291042441.2471@localhost.localdomain> <4C529F59.3020404@suse.de> <alpine.LFD.2.00.1008020956080.9198@localhost.localdomain> <4C56E42D.5010300@suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun,

On Mon, 2 Aug 2010, Tejun Heo wrote:

> Hello, Thomas.
> 
> On 08/02/2010 04:07 PM, Thomas Gleixner wrote:
> > 1) irq polling
> 
> Do you mean spurious irq polling here?

  Yep
 
> >    - Get rid of the for_each_irq() loop in the poll timer.
> > 
> >      You can solve this by adding the interrupt to a linked list and
> >      let the poll timer run through the list.
> 
> I suppose you're talking about using per-desc timer.  I first thought
> about using a single common timer too but decided against it because
> timer events can be merged from timer code (depending on the interval
> and slack) and I wanted to use different polling frequencies for
> different cases.  We can of course implement logic to put polled irqs
> on a list in chronological order but that's basically redoing the work
> timer code already does.

They might be merged depending on interval and slack, but why do we
need different frequencies at all ?

> >      Also why is the simple counter based decision not good enough?
> >      Why do we need an extra time period for this?
> 
> Because in many cases IRQ storms are transient and spurious IRQ
> polling worsens performance a lot, it's worthwhile to be able to
> recover from such conditions, so the extra time period is there to
> trigger reenabling of the offending IRQ to see whether the storm is
> over now.  Please note that many of this type of IRQ storms are
> extremely obscure (for example, happens during resume from STR once in
> a blue moon due to bad interaction between legacy ATA state machine in
> the controller and the drive's certain behavior) and some are very
> difficult to avoid from the driver in any reasonable way.

If the IRQ has been marked as spurious, then switch to polling for a
defined time period (simply count the number of poll timer runs for
that irq). After that switch back to non polling and keep a flag which
kicks the stupid thing back to poll after 10 spurious ones in a row.

> >    - Reenable the interrupt from time to time to check whether the irq
> >      storm subsided.
> 
> Or maybe you were talking about something else?

No, that stuff is so convoluted that I did not understand it.
 
> >      Generally a good idea, but we really do not want to wait for
> >      another 10k unhandled interrupts flooding the machine. Ideally we
> >      should read out the irq pending register from the irq chip to see
> >      whether the interrupt is still asserted.
> 
> In simulated tests with hosed IRQ routing the behavior was already
> quite acceptable, but yeah if peeking at interrupt state can be done
> easily that would definitely be an improvement.

It could be done on various irq chips, but not on all. So we need that
real retry anyway; no need to add another function to irq_chip.
 
> > 2) irq watch
> 
> The whole thing is executed iff unlikely(desc->status &
> IRQ_CHECK_WATCHES) which the processor will be predicting correctly
> most of the time.  Do you think it would make any noticeable
> difference?

It's not about the !WATCH case. I don't like the extra work for those
watched ones.
 
> >    irq_watch should use a separate global timer and a linked list. The
> >    timer is started when an interrupt is added to the watch mechanism
> >    and stopped when the list becomes empty.
> >    
> >    That's a clear separation of watch and poll and simplifies the
> >    whole business a lot.
> 
> The reason why poll_irq() looks complicated is because different types
> of timers on the same desc shares the timer.  The reason why it's
> shared this way instead of across different descs of the same type is
> to avoid locking overhead in maintaining the timer and linked lists of
> its targets.  By sharing the timer in the same desc, everything can be
> protected by desc->lock but if we use timers across different descs,
> we need another layer of locking.

The locking overhead for a global timer + linked list is minimal.

There is only one additional lock, the one which protects the
list_head. So you take it when watch_irq() adds the watch, when the
watch is removed and in the timer routine. That's zero overhead as
lock contention is totaly unlikely. There is no need to fiddle with
the timer interval. Watch the stupid thing for a while, if it behaves
remove it from the list, if not you need to keep polling anyway.

> > 3) irq expect
> > 
> We definitely can implement such quick polling timeouts which check
> for IRQ misdeliveries in drivers so that it can detect such events and
> maybe add an interface in the IRQ polling code which the driver can
> call to enable polling on the IRQ.  But then again the pattern of such
> failures and handling of them would be very similar across different
> drivers and we already of most of polling machinary implemented in IRQ
> code, so I think it makes sense to have a generic implementation which
> drivers can use.  Moreover, given the difference in test/review
> coverage and general complexity of doing it right, I think it is far
> better to do it in the core code and make it easy to use for drivers.

I'm not opposed to have a generic solution for this, but I want a
simple and understandable one. The irq_poll() works for everything
magic is definitely not in this category.
 
> >    Btw, this polling is pretty bad in terms of power savings.
> > 
> >    - The timers are not aligned, so if there are several expects armed
> >      you get unbatched wakeups.
> 
> In usual operation conditions, the timer interval will quickly become
> 3 seconds w/ 1 sec slack.  I doubt it can cause much problem.  Right?

And those 4 seconds are probably larger than the device timeouts in
most cases. So what's the point of running that timer at all ?

> >    I assume your concern is to detect and deal with flaky interrupts,
> >    but avoiding the permanent poll when the device is not used, right?
> > 
> >    So that can be done simpler as well. One timer and a linked list
> >    again.
> >
> >    expect_irq() adds the irq to the linked list and arms the timer, if
> >    it is not armed already. unexpect_irq() removes the irq from the
> >    linked list and deletes the timer when the list becomes empty.
> >
> >    That can reuse the list_head in irq_desc which you need for irq
> >    poll and the timer interval should be fixed without dynamic
> >    adjustment.
> 
> The main problem here is that expect/unexpect_irq() needs to be low
> overhead so that drivers can easily call in w/o worrying too much
> about performance overhead and I would definitely want to avoid
> locking in fast paths.

In general you only want to use this expect thing when you detected
that the device has a problem. So why not use the watch mechanism for
this ?

When you detect the first timeout in the device driver, set the watch
on that action and let it figure out whether it goes back to
normal. If it goes back to normal the watch disappears. If it happens
again, repeat. 

expect_irq() would be basically a NOP, but I like to keep it, as it
can be used for power management decisions.

unexpect_irq() would either add or remove the watch depending on the
timeout argument. So there is only overhead when things went bad and
when we go back to normal in all other cases it's zero. 

Though we need a reference to irqaction.watch of that device, but
that's not a big deal. With that we can call

     unexpect_irq(watch, false/true);

which would be an inline function:

static inline void unexpect_irq(watch, timeout)
{
	if (unlikely(watch->active ^ timeout))
	       __unexpect_irq(watch, timeout);
}

Simple, right ?

> To me, the more interesting question is where to put the complexity.
> In many cases, the most we can do is pushing complexity around, and if
> we can make things easier for drivers by making the core IRQ code
> somewhat more complex, I'll definitely go for that every time.

No objections, but I doubt, that we need all the heuristics and
complex code to deal with it.

Thanks,

	tglx
