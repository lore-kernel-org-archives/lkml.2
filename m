Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab0HBW2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 18:28:39 -0400
Received: from www.tglx.de ([62.245.132.106]:33598 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109Ab0HBW2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 18:28:38 -0400
Date: Tue, 3 Aug 2010 00:28:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <teheo@suse.de>
cc: lkml <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: [GIT PULL tip/genirq] Please pull from lost-spurious-irq
In-Reply-To: <4C572F26.1040200@suse.de>
Message-ID: <alpine.LFD.2.00.1008022353220.3225@localhost.localdomain>
References: <4C5033D9.7030800@kernel.org> <4C50349F.7020002@suse.de> <alpine.LFD.2.00.1007291042441.2471@localhost.localdomain> <4C529F59.3020404@suse.de> <alpine.LFD.2.00.1008020956080.9198@localhost.localdomain> <4C56E42D.5010300@suse.de>
 <alpine.LFD.2.00.1008021730250.27107@localhost.localdomain> <4C572F26.1040200@suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun,

On Mon, 2 Aug 2010, Tejun Heo wrote:
 
> >> Because in many cases IRQ storms are transient and spurious IRQ
> >> polling worsens performance a lot, it's worthwhile to be able to
> >> recover from such conditions, so the extra time period is there to
> >> trigger reenabling of the offending IRQ to see whether the storm is
> >> over now.  Please note that many of this type of IRQ storms are
> >> extremely obscure (for example, happens during resume from STR once in
> >> a blue moon due to bad interaction between legacy ATA state machine in
> >> the controller and the drive's certain behavior) and some are very
> >> difficult to avoid from the driver in any reasonable way.
> > 
> > If the IRQ has been marked as spurious, then switch to polling for a
> > defined time period (simply count the number of poll timer runs for
> > that irq). After that switch back to non polling and keep a flag which
> > kicks the stupid thing back to poll after 10 spurious ones in a row.
> 
> The current logic isn't that different except that it always considers
> periods instead of consecutive ones and uses exponential backoff for
> re-enable timing.

There is no need for that exponential backoff. Either the thing works
or it does not. Where is the fcking point? If you switch the thing to
polling mode, then it does not matter at all whether you try once a
second, once a minute or once an hour to restore the thing. It only
matters when you insist on collecting another 10k spurious ones before
deciding another time that the thing is hosed.

> >> Or maybe you were talking about something else?
> > 
> > No, that stuff is so convoluted that I did not understand it.
> 
> Hmmm... there _are_ some complications but they're mainly how
> different mechanisms may interact with each other (ie. watching
> delayed while spurious polling is in effect kind of thing) and turning
> IRQs on/off (mostly due to locking), but the spurious irq polling part
> isn't exactly convoluted.  Which part do you find so convoluted?  I do
> agree it's somewhat complex and if you have different model in mind,
> it might not match your expectations.  I tried to clean it up at least
> in its current structure but I could have been looking at it for a bit
> too long.

My main concern is that you are trying to tie everything into one
function, which is always a clear sign for crap.
 
> >>> 2) irq watch
> >>
> >> The whole thing is executed iff unlikely(desc->status &
> >> IRQ_CHECK_WATCHES) which the processor will be predicting correctly
> >> most of the time.  Do you think it would make any noticeable
> >> difference?
> > 
> > It's not about the !WATCH case. I don't like the extra work for those
> > watched ones.
> 
> WATCH shouldn't be used in normal paths because the polling code
> doesn't have enough information to reduce overhead.  It can only be
> used in occassional events like IRQ enable, timeout detected by driver
> kind of events, so WATCH case overhead doesn't really matter.  Its
> primary use case would be invoking it right after requesting IRQ as
> USB does.

That's nonsense. You add the watch in the first place to figure out
whether that IRQ is reliably delivered or not. If it is not, then you
add the whole magic to the irq disabled hotpath forever. That's not a
problem for that particular IRQ, it's a problem for the overall
system.
 
> >>> 3) irq expect
> > I'm not opposed to have a generic solution for this, but I want a
> > simple and understandable one. The irq_poll() works for everything
> > magic is definitely not in this category.
> 
> It's just multiplexing timer.  If the biggest issue is convolution in
> irq_poll(), I can try to make it prettier for sure, but I guess that
> discussion is for later time.

It's _NOT_. You _CANNOT_ make it prettier because your "design" is sucky
by "multiplexing the timer". The multiplexing is the main issue and
there is no way to make this less convoluted as hard as you might try.
 
> >> In usual operation conditions, the timer interval will quickly become
> >> 3 seconds w/ 1 sec slack.  I doubt it can cause much problem.  Right?
> > 
> > And those 4 seconds are probably larger than the device timeouts in
> > most cases. So what's the point of running that timer at all ?
> 
> Well, it's fairly common to have tens of secs for timeouts.  Even
> going into minute range isn't too uncommon.

No. You just look at it from ATA or whatever, but there are tons of
drivers which have timeouts below 100ms. You _CANNOT_ generalize that
assumption. And if you want this for ATA where it possibly fits, then
you just make your whole argument of generalizing the approach moot.

> >> The main problem here is that expect/unexpect_irq() needs to be low
> >> overhead so that drivers can easily call in w/o worrying too much
> >> about performance overhead and I would definitely want to avoid
> >> locking in fast paths.
> > 
> > In general you only want to use this expect thing when you detected
> > that the device has a problem. So why not use the watch mechanism for
> > this ?
> 
> No, the goal is to use it for normal cases, so that we can provide
> reasonable level of protection against occassional hiccups at fairly
> low overhead.  Otherwise, it wouldn't be different at all from IRQ
> watching.

WTF ? Once you switched to IRQ_EXP_VERIFIED then you run with 3sec +
slack timeout. You only switch back when a timeout in the device
driver happens. That's at least how I understand the code. Correct me
if I'm wrong, but then you just deliver another proof for complete non
understandble horror.
 
> > When you detect the first timeout in the device driver, set the watch
> > on that action and let it figure out whether it goes back to
> > normal. If it goes back to normal the watch disappears. If it happens
> > again, repeat. 
> 
> Yeah, that's how irq_watch is supposed to be used.  irq_expect is for
> cases where drivers can provide better information about when to start
> and finish expecting interrupts.  For these cases, we can provide
> protection against occassional IRQ hiccups too.  A few secs of hiccup
> would be an order of magnitude better and will actually make such
> failures mostly bearable.

Err. That's complete nonsense. The device driver has a timeout for the
occasional hickup. If it happens you want to watch out for the device
to settle back to normal.
 
> > Though we need a reference to irqaction.watch of that device, but
> > that's not a big deal. With that we can call
> > 
> >      unexpect_irq(watch, false/true);
> > 
> > which would be an inline function:
> > 
> > static inline void unexpect_irq(watch, timeout)
> > {
> > 	if (unlikely(watch->active ^ timeout))
> > 	       __unexpect_irq(watch, timeout);
> > }
> > 
> > Simple, right ?
> 
> Well, now we're talking about different problems.  If it were not for
> using it in normal cases, it would be better to just rip off expecting
> and use watching.

Oh man. You seem to be lost in some different universe. The normal
case - and that's what it is according to your code is running the
expect thing at low frequency (>= 3 seconds) and just swicthes back to
quick polling when the driver code detected an error. So how is that
fcking different from my approach ?
 
> >> To me, the more interesting question is where to put the complexity.
> >> In many cases, the most we can do is pushing complexity around, and if
> >> we can make things easier for drivers by making the core IRQ code
> >> somewhat more complex, I'll definitely go for that every time.
> > 
> > No objections, but I doubt, that we need all the heuristics and
> > complex code to deal with it.
> 
> Cool, I'm happy as long as you agree on that.  So, here's where I'm
> coming from: There are two classes of ATA bugs which have been
> bothering me for quite some time now.  Both are pretty cumbersome to
> solve from libata proper.
> 
> The first is some ATAPI devices locking up because we use different
> probing sequence than windows and other media presence polling related
> issues.  I think we'll need in-kernel media presence detection and
> with cmwq it shouldn't be too hard to implement.

That's an unrelated issue.
 
> The other, as you might have expected, is these frigging IRQ issues.
> There are several different patterns of failures.  One is misrouting
> or other persistent delivery failure.  irq_watch alone should be able
> to solve most part of this.  Another common one is stuck IRQ line.
> Cases where this condition is sporadic and transient aren't too rare,
> so the updates to spurious handling.  The last is occassional delivery
> failures which unnecessarily lead to full blown command timeouts.
> This is what irq_expect tries to work around.

As I said, you can cope with transient failures with the modified
watch scheme as well.
 
> After spending some time w/ ATA, what I've learned is that shit
> happens no matter what and os/driver better be ready to handle them
> and, for a lot of cases, the driver has enough information to be able
> to work around and survive most IRQ problems.
> 
> I don't think that IRQ expect/unexpect is pushing it too far.  It sure
> adds some level of complexity but I don't think it is an inherently
> complex thing - it could be just that my code sucks.  Anyways, so
> there are two things to discuss here, I guess.  First, irq_expect
> itself and second the implementation deatils.  If you can think of
> something which is simpler and achieves about the same thing, it would
> great.

I pointed out the simple and acceptable solution already.

Thanks,

	tglx
