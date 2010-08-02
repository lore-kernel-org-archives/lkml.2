Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab0HBVTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 17:19:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:53599 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642Ab0HBVTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 17:19:38 -0400
Message-ID: <4C572F26.1040200@suse.de>
Date: Mon, 02 Aug 2010 22:48:38 +0200
From: Tejun Heo <teheo@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: [GIT PULL tip/genirq] Please pull from lost-spurious-irq
References: <4C5033D9.7030800@kernel.org> <4C50349F.7020002@suse.de> <alpine.LFD.2.00.1007291042441.2471@localhost.localdomain> <4C529F59.3020404@suse.de> <alpine.LFD.2.00.1008020956080.9198@localhost.localdomain> <4C56E42D.5010300@suse.de> <alpine.LFD.2.00.1008021730250.27107@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1008021730250.27107@localhost.localdomain>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

On 08/02/2010 07:10 PM, Thomas Gleixner wrote:
>> I suppose you're talking about using per-desc timer.  I first thought
>> about using a single common timer too but decided against it because
>> timer events can be merged from timer code (depending on the interval
>> and slack) and I wanted to use different polling frequencies for
>> different cases.  We can of course implement logic to put polled irqs
>> on a list in chronological order but that's basically redoing the work
>> timer code already does.
> 
> They might be merged depending on interval and slack, but why do we
> need different frequencies at all ?

Yeah, these differences all come down to expecting.  If it weren't for
expecting, one timer to rule them all should have been enough.  I'll
continue below.

>> Because in many cases IRQ storms are transient and spurious IRQ
>> polling worsens performance a lot, it's worthwhile to be able to
>> recover from such conditions, so the extra time period is there to
>> trigger reenabling of the offending IRQ to see whether the storm is
>> over now.  Please note that many of this type of IRQ storms are
>> extremely obscure (for example, happens during resume from STR once in
>> a blue moon due to bad interaction between legacy ATA state machine in
>> the controller and the drive's certain behavior) and some are very
>> difficult to avoid from the driver in any reasonable way.
> 
> If the IRQ has been marked as spurious, then switch to polling for a
> defined time period (simply count the number of poll timer runs for
> that irq). After that switch back to non polling and keep a flag which
> kicks the stupid thing back to poll after 10 spurious ones in a row.

The current logic isn't that different except that it always considers
periods instead of consecutive ones and uses exponential backoff for
re-enable timing.

>> Or maybe you were talking about something else?
> 
> No, that stuff is so convoluted that I did not understand it.

Hmmm... there _are_ some complications but they're mainly how
different mechanisms may interact with each other (ie. watching
delayed while spurious polling is in effect kind of thing) and turning
IRQs on/off (mostly due to locking), but the spurious irq polling part
isn't exactly convoluted.  Which part do you find so convoluted?  I do
agree it's somewhat complex and if you have different model in mind,
it might not match your expectations.  I tried to clean it up at least
in its current structure but I could have been looking at it for a bit
too long.

>>> 2) irq watch
>>
>> The whole thing is executed iff unlikely(desc->status &
>> IRQ_CHECK_WATCHES) which the processor will be predicting correctly
>> most of the time.  Do you think it would make any noticeable
>> difference?
> 
> It's not about the !WATCH case. I don't like the extra work for those
> watched ones.

WATCH shouldn't be used in normal paths because the polling code
doesn't have enough information to reduce overhead.  It can only be
used in occassional events like IRQ enable, timeout detected by driver
kind of events, so WATCH case overhead doesn't really matter.  Its
primary use case would be invoking it right after requesting IRQ as
USB does.

> The locking overhead for a global timer + linked list is minimal.
> 
> There is only one additional lock, the one which protects the
> list_head. So you take it when watch_irq() adds the watch, when the
> watch is removed and in the timer routine. That's zero overhead as
> lock contention is totaly unlikely. There is no need to fiddle with
> the timer interval. Watch the stupid thing for a while, if it behaves
> remove it from the list, if not you need to keep polling anyway.

For watch only, I agree that global timer would work better.

>>> 3) irq expect
> I'm not opposed to have a generic solution for this, but I want a
> simple and understandable one. The irq_poll() works for everything
> magic is definitely not in this category.

It's just multiplexing timer.  If the biggest issue is convolution in
irq_poll(), I can try to make it prettier for sure, but I guess that
discussion is for later time.

>> In usual operation conditions, the timer interval will quickly become
>> 3 seconds w/ 1 sec slack.  I doubt it can cause much problem.  Right?
> 
> And those 4 seconds are probably larger than the device timeouts in
> most cases. So what's the point of running that timer at all ?

Well, it's fairly common to have tens of secs for timeouts.  Even
going into minute range isn't too uncommon.

>> The main problem here is that expect/unexpect_irq() needs to be low
>> overhead so that drivers can easily call in w/o worrying too much
>> about performance overhead and I would definitely want to avoid
>> locking in fast paths.
> 
> In general you only want to use this expect thing when you detected
> that the device has a problem. So why not use the watch mechanism for
> this ?

No, the goal is to use it for normal cases, so that we can provide
reasonable level of protection against occassional hiccups at fairly
low overhead.  Otherwise, it wouldn't be different at all from IRQ
watching.

> When you detect the first timeout in the device driver, set the watch
> on that action and let it figure out whether it goes back to
> normal. If it goes back to normal the watch disappears. If it happens
> again, repeat. 

Yeah, that's how irq_watch is supposed to be used.  irq_expect is for
cases where drivers can provide better information about when to start
and finish expecting interrupts.  For these cases, we can provide
protection against occassional IRQ hiccups too.  A few secs of hiccup
would be an order of magnitude better and will actually make such
failures mostly bearable.

> Though we need a reference to irqaction.watch of that device, but
> that's not a big deal. With that we can call
> 
>      unexpect_irq(watch, false/true);
> 
> which would be an inline function:
> 
> static inline void unexpect_irq(watch, timeout)
> {
> 	if (unlikely(watch->active ^ timeout))
> 	       __unexpect_irq(watch, timeout);
> }
> 
> Simple, right ?

Well, now we're talking about different problems.  If it were not for
using it in normal cases, it would be better to just rip off expecting
and use watching.

>> To me, the more interesting question is where to put the complexity.
>> In many cases, the most we can do is pushing complexity around, and if
>> we can make things easier for drivers by making the core IRQ code
>> somewhat more complex, I'll definitely go for that every time.
> 
> No objections, but I doubt, that we need all the heuristics and
> complex code to deal with it.

Cool, I'm happy as long as you agree on that.  So, here's where I'm
coming from: There are two classes of ATA bugs which have been
bothering me for quite some time now.  Both are pretty cumbersome to
solve from libata proper.

The first is some ATAPI devices locking up because we use different
probing sequence than windows and other media presence polling related
issues.  I think we'll need in-kernel media presence detection and
with cmwq it shouldn't be too hard to implement.

The other, as you might have expected, is these frigging IRQ issues.
There are several different patterns of failures.  One is misrouting
or other persistent delivery failure.  irq_watch alone should be able
to solve most part of this.  Another common one is stuck IRQ line.
Cases where this condition is sporadic and transient aren't too rare,
so the updates to spurious handling.  The last is occassional delivery
failures which unnecessarily lead to full blown command timeouts.
This is what irq_expect tries to work around.

After spending some time w/ ATA, what I've learned is that shit
happens no matter what and os/driver better be ready to handle them
and, for a lot of cases, the driver has enough information to be able
to work around and survive most IRQ problems.

I don't think that IRQ expect/unexpect is pushing it too far.  It sure
adds some level of complexity but I don't think it is an inherently
complex thing - it could be just that my code sucks.  Anyways, so
there are two things to discuss here, I guess.  First, irq_expect
itself and second the implementation deatils.  If you can think of
something which is simpler and achieves about the same thing, it would
great.

Thanks.

-- 
tejun
