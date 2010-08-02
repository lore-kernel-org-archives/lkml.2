Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab0HBP2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 11:28:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:41075 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490Ab0HBP22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 11:28:28 -0400
Message-ID: <4C56E42D.5010300@suse.de>
Date: Mon, 02 Aug 2010 17:28:45 +0200
From: Tejun Heo <teheo@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: [GIT PULL tip/genirq] Please pull from lost-spurious-irq
References: <4C5033D9.7030800@kernel.org> <4C50349F.7020002@suse.de> <alpine.LFD.2.00.1007291042441.2471@localhost.localdomain> <4C529F59.3020404@suse.de> <alpine.LFD.2.00.1008020956080.9198@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1008020956080.9198@localhost.localdomain>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Thomas.

On 08/02/2010 04:07 PM, Thomas Gleixner wrote:
> Yup, but I have some other issues with this series as well. That thing
> is massively overengineered. You mangle all the various functions into
> irq_poll which makes it really hard to understand what the code does
> under which circumstances.

Oh, I'll explain why I muliplexed timers this way below.

> I understand most of the problems you want to solve, but I don't like
> the outcome too much.
>
> Let's look at the various parts:

Heh, fair enough.  Let's talk about it.

> 1) irq polling

Do you mean spurious irq polling here?

>    - Get rid of the for_each_irq() loop in the poll timer.
> 
>      You can solve this by adding the interrupt to a linked list and
>      let the poll timer run through the list.

I suppose you're talking about using per-desc timer.  I first thought
about using a single common timer too but decided against it because
timer events can be merged from timer code (depending on the interval
and slack) and I wanted to use different polling frequencies for
different cases.  We can of course implement logic to put polled irqs
on a list in chronological order but that's basically redoing the work
timer code already does.

>      Also why is the simple counter based decision not good enough?
>      Why do we need an extra time period for this?

Because in many cases IRQ storms are transient and spurious IRQ
polling worsens performance a lot, it's worthwhile to be able to
recover from such conditions, so the extra time period is there to
trigger reenabling of the offending IRQ to see whether the storm is
over now.  Please note that many of this type of IRQ storms are
extremely obscure (for example, happens during resume from STR once in
a blue moon due to bad interaction between legacy ATA state machine in
the controller and the drive's certain behavior) and some are very
difficult to avoid from the driver in any reasonable way.

>    - Reenable the interrupt from time to time to check whether the irq
>      storm subsided.

Or maybe you were talking about something else?

>      Generally a good idea, but we really do not want to wait for
>      another 10k unhandled interrupts flooding the machine. Ideally we
>      should read out the irq pending register from the irq chip to see
>      whether the interrupt is still asserted.

In simulated tests with hosed IRQ routing the behavior was already
quite acceptable, but yeah if peeking at interrupt state can be done
easily that would definitely be an improvement.

> 2) irq watch
> 
>    I have to admit, that I have no clue what this thing exactly
>    does. After staring into the code for quite a while I came to the
>    conclusion that it's a dynamic polling machinery, which adjusts
>    it's polling frequency depending on the number of good and bad
>    samples. The heuristics for this are completely non obvious.

Eh, I thought I did pretty good on documenting each mechanism.
Obviously, not enough at all.  :-)

It basically allows drivers to tell the irq code that IRQs are likely
to happen.  In response, IRQ code polls the desc for a while and sees
whether poll detects IRQ handling w/o actual IRQ deliveries.  If that
seems to happen more than usual, IRQ code can determine that IRQ is
not being delivered and enables full blown IRQ polling.

The WARY state is inbetween state between good and bad.  Dropping this
will simplify the logic a bit.  It's basically to avoid false
positives as it would suck to enable polling for a working IRQ line.

Anyways, the basic heuristics is it watches certain number of IRQ
events and count how many are good (via IRQ) and bad (via poll).  If
bad goes over certain threshold, polling is enabled.

>    Aside of that the watch mechanism adds unneccesary code to the hard
>    interrupt context. There is no reason why you need to update that
>    watch magic in the hard interrupt context. Analysing the stats can
>    be done in the watch timer as well. All it takes is in
>    handle_irq_event()
> 
>    case IRQ_HANDLED:
>       	action->handled++;
> 
>    and in the watch timer function
> 
>         if (ret == IRQ_HANDLED)
> 	        action->polled++;

The whole thing is executed iff unlikely(desc->status &
IRQ_CHECK_WATCHES) which the processor will be predicting correctly
most of the time.  Do you think it would make any noticeable
difference?

>    irq_watch should use a separate global timer and a linked list. The
>    timer is started when an interrupt is added to the watch mechanism
>    and stopped when the list becomes empty.
>    
>    That's a clear separation of watch and poll and simplifies the
>    whole business a lot.

The reason why poll_irq() looks complicated is because different types
of timers on the same desc shares the timer.  The reason why it's
shared this way instead of across different descs of the same type is
to avoid locking overhead in maintaining the timer and linked lists of
its targets.  By sharing the timer in the same desc, everything can be
protected by desc->lock but if we use timers across different descs,
we need another layer of locking.

> 3) irq expect
> 
>    So you basically poll the interrupt until either the interrupt
>    happened or the device driver timeout occured.
> 
>    That's really weird. What does it solve ? Not running into the
>    device driver timeout routine if the hardware interrupt has been
>    lost?
> 
>    That's overkill, isn't it ? When the hardware loses an interrupt
>    occasionally then why isn't the device driver timeout routine
>    sufficient? If it does not check whether the device has an
>    interrupt pending despite the fact that it has not been delivered,
>    then this code needs to be fixed and not worked around with weird
>    polling in the generic irq code.

Delays caused by lost interrupt and by other failures can differ a lot
in their magnitude and, for example, libata does check IRQ delivery
failure in its timeout handler but at that point it doesn't really
matter why the timeout has occurred for recovery of that specific
command.  Too much time has passed anyway.

We definitely can implement such quick polling timeouts which check
for IRQ misdeliveries in drivers so that it can detect such events and
maybe add an interface in the IRQ polling code which the driver can
call to enable polling on the IRQ.  But then again the pattern of such
failures and handling of them would be very similar across different
drivers and we already of most of polling machinary implemented in IRQ
code, so I think it makes sense to have a generic implementation which
drivers can use.  Moreover, given the difference in test/review
coverage and general complexity of doing it right, I think it is far
better to do it in the core code and make it easy to use for drivers.

>    Btw, this polling is pretty bad in terms of power savings.
> 
>    - The timers are not aligned, so if there are several expects armed
>      you get unbatched wakeups.

In usual operation conditions, the timer interval will quickly become
3 seconds w/ 1 sec slack.  I doubt it can cause much problem.  Right?

>    - If the poll interval is smaller than the average hardware
>      interrupt delivery time, you add more wakeups than necessary.

The same thing as above.  If IRQ delivery is working, it will be
polling every 3 seconds w/ 1 sec slack.  It wouldn't really matter.

>    - If the hardware interrupt has happened, you let the poll timer
>      pending, which gives us an extra wakeup for each interrupt in the
>      worst case.

That's to avoid the overhead of constantly manipulating the timer for
high frequency commands.  expect/unexpect fast paths don't do much, no
locking, no timer manipulations.  No matter how busy the IRQ is, the
timer will only activate and rearmed occassionally.

>    I assume your concern is to detect and deal with flaky interrupts,
>    but avoiding the permanent poll when the device is not used, right?
> 
>    So that can be done simpler as well. One timer and a linked list
>    again.
>
>    expect_irq() adds the irq to the linked list and arms the timer, if
>    it is not armed already. unexpect_irq() removes the irq from the
>    linked list and deletes the timer when the list becomes empty.
>
>    That can reuse the list_head in irq_desc which you need for irq
>    poll and the timer interval should be fixed without dynamic
>    adjustment.

The main problem here is that expect/unexpect_irq() needs to be low
overhead so that drivers can easily call in w/o worrying too much
about performance overhead and I would definitely want to avoid
locking in fast paths.

>    Keep it simple!

To me, the more interesting question is where to put the complexity.
In many cases, the most we can do is pushing complexity around, and if
we can make things easier for drivers by making the core IRQ code
somewhat more complex, I'll definitely go for that every time.

That's also the main theme of this IRQ spurious/missing patchset.  The
implementation might be a bit complex but using it from the driver
side is almost no brainer.  The drivers just need to give hints to the
IRQ polling code and the IRQ polling code will take care of everything
else, and the low overhead for irq_expect/unexpect() is important in
that aspect because drivers can only use it without worrying iff its
overhead is sufficiently low.

That said, I definitely think poll_irq() can be better factored.  Its
current form is mainly due to its transition from spurious poller to
the current multiplexed form.  Factoring out different parts and
possibly killing watch handling should simplify it quite a bit.

Thank you.

-- 
tejun
