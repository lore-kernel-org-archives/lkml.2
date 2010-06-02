Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665Ab0FBLCl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 07:02:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55398 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580Ab0FBLCj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 07:02:39 -0400
Date: Wed, 2 Jun 2010 21:02:24 +1000
From: Neil Brown <neilb@suse.de>
To: Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] - race-free suspend. Was: Re: [linux-pm] [PATCH 0/8] 
 Suspend block api (version 8)
Message-ID: <20100602210224.6ae2333f@notabene.brown>
In-Reply-To: <AANLkTimISbs4X2YR_Pal9A80mpkNyCy8laWBcOgR2Cl7@mail.gmail.com>
References: <Pine.LNX.4.44L0.1005271303190.3239-100000@iolanthe.rowland.org>
	<201006010005.19554.rjw@sisk.pl>
	<20100601090023.788cabf4@notabene.brown>
	<201006010232.20263.rjw@sisk.pl>
	<20100601113309.609349fd@notabene.brown>
	<alpine.LFD.2.00.1006010340160.2933@localhost.localdomain>
	<20100601122012.1edeaf48@notabene.brown>
	<alpine.LFD.2.00.1006011243350.2933@localhost.localdomain>
	<20100602153235.340a7852@notabene.brown>
	<AANLkTikVjAf5nHdMx2bcHRAUSkq99s-b5YZCECXIJJLy@mail.gmail.com>
	<20100602180614.729246ea@notabene.brown>
	<AANLkTimISbs4X2YR_Pal9A80mpkNyCy8laWBcOgR2Cl7@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jun 2010 02:12:10 -0700
Arve Hjønnevåg <arve@android.com> wrote:

> 2010/6/2 Neil Brown <neilb@suse.de>:
> > On Wed, 2 Jun 2010 00:05:14 -0700
> > Arve Hjønnevåg <arve@android.com> wrote:
> >
> >> On Tue, Jun 1, 2010 at 10:32 PM, Neil Brown <neilb@suse.de> wrote:
> >> > On Tue, 1 Jun 2010 12:50:01 +0200 (CEST)
> >> > Thomas Gleixner <tglx@linutronix.de> wrote:
> >> >
> >> >> On Tue, 1 Jun 2010, Neil Brown wrote:
> >> >> >
> >> >> > I think you have acknowledged that there is a race with suspend - thanks.
> >> >> > Next step was "can it be closed".
> >> >> > You seem to suggest that it can, but you describe it as a "work around"
> >> >> > rather than a "bug fix"...
> >> >> >
> >> >> > Do you agree that the race is a "bug", and therefore it is appropriate to
> >> >> > "fix" it assuming an acceptable fix can be found (which I think it can)?
> >> >>
> >> >> If we can fix it, yes we definitely should do and not work around it.
> >> >>
> >> >> Thanks,
> >> >>
> >> >>       tglx
> >> >
> >> > OK.
> >> > Here is my suggestion.
> >> >
> >> > While I think this patch would actually work, and hope the ugly aspects are
> >> > reasonably balanced by the simplicity, I present it primarily as a base for
> >> > improvement.
> >> > The important part is to present how drivers and user-space can co-operate
> >> > to avoid losing wake-events.  The details of what happens in the kernel are
> >> > certainly up for discussion (as is everything else really of course).
> >> >
> >> > The user-space suspend daemon avoids losing wake-events by using
> >> > fcntl(F_OWNER) to ensure it gets a signal whenever any important wake-event
> >> > is ready to be read by user-space.  This may involve:
> >> >  - the one daemon processing all wake events
> >>
> >> Wake up events are not all processed by one daemon.
> >
> > Not with your current user-space code, no.  Are you saying that you are not
> > open to any significant change in the Android user-space code?  That would
> > make the situation a lot harder to resolve.
> >
> 
> Some wakeup events like the an incoming phone may be handled by a
> vendor supplied daemon that I do not have the source code for. And, no
> I'm not open to a change that would require all wakeup events to go to
> a single process.

Ahh..  Well I have no answer for the "I must support a closed-source app"
card that has not been heard 1000 times already.

My proposal doesn't require all wakeup events to go through one single
process - it was just one of (at least) 3 options.

> 
> >>
> >> >  - Both the suspend daemon and the main event handling daemon opening any
> >> >    given device that delivers wake events (this should work with input
> >> >    events ... unless grabbing is needed)
> >>
> >> Not all wakeup events are broadcast like input events so they cannot
> >> be read by both daemons. Not that this really matters, since reading
> >> the event from the suspend daemon does not mean that it has been
> >> delivered to and processed by the other daemon.
> >
> > There would still need to be some sort of communication between the the
> > suspend daemon on any event daemon to ensure that the events had been
> > processed.  This could be very light weight interaction.  The point though is
> > that with this patch it becomes possible to avoid races.  Possible is better
> > than impossible.
> >
> 
> We already have a solution. I don't think rejecting our solution but
> merging a worse solution should be the goal.
> 
> >>
> >> >  - The event handling daemon giving the suspend-daemon's pid as F_OWNER, and
> >> >    using poll/select to get the events itself.
> >>
> >> I don't like the idea of using signals for this. Without the hack Alan
> >> Stern suggested, you will temporarily block suspend if the wakeup
> >> event happened before the suspend daemon thread made it to the kernel,
> >> but abort suspend if it happened right after.
> >
> > I'm not sure why that difference matters.  But I'm also not sure that it is
> > true.
> > When any wakeup event happen, a signal will be delivered to the suspend
> > daemon.
> > This will interrupt a pending suspend request, or a sleep, or whatever else
> > the daemon is doing.
> > It can then go back to waiting for a good time to suspend, and then try to
> > suspend again.
> >
> 
> This is inferior to the solution that is in the android kernel and the
> suspend blocker patchset. Both suspend as soon as possible and do not
> require signal handlers that modify the argument to your kernel call.
> 

The solution in the android kernel and the suspend blocker patchset both
share one fairly fatal flaw - they are not being accepted upstream.
I am trying to find a minimal suitable solution that does not share that
flaw.
I do not know yet if it does or not, but as it is fixing a real (design) bug,
I feel it has some chance.  Of course if it doesn't meet your need, then
that becomes irrelevant....

And there is no requirement to modify any arguments in any signal handlers.

> >
> >>
> >> >
> >> > When 'mem' is written to /sys/power/state, suspend_prepare waits in an
> >> > interruptible wait until any wake-event that might have been initiated before
> >> > the suspend was request, has had a chance to be queued for user-space and
> >> > trigger kill_fasync.
> >>
> >> And what happens if you are not waiting when this happens?
> >
> > I'm not sure I understand the question.  Could you explain it please?
> >
> 
> If the thread is not already in the kernel how does your signal
> handler abort suspend.

setjmp / longjmp.  This is the time-honoured method for allowing a signal to
break the flow of a program and re-start somewhere else.

> 
> > Either the initial event happens late enough to abort/resume the suspend, or
> > the signal happens early enough to abort the suspend, or alert the daemon not
> > to do a suspend.  Either way we don't get stuck in suspend.
> >
> >
> >>
> >> > Currently this wait is a configurable time after the last wake-event was
> >> > initiated.  This is hackish, but simple and probably adequate.
> >>
> >> Waiting after a wake event is the same as suspend_block_timeout. This
> >> is useful when passing events through layers of code that does no
> >> block suspend, but we should strive to avoid it. Other people had much
> >> stronger objections to this, which is why it is not included in the
> >> last suspend blocker patchset.
> >
> > Absolutely agree.  The idea of of waiting was just a simple way to present
> > code that actually could work.  There are doubtlessly better ways and I
> > assume they have been implemented in the suspend-blocker code.
> > We just need some way to wait for the suspend-block count to reach zero, with
> > some confidence that this amount of time is limited.
> >
> > (though to be honest ... the incredible simplicity of waiting a little while
> > is very compelling.... :-))
> >
> 
> Sure, but forcing that as the only way to prevent suspend is taking to too far.
> 
> >>
> >> It also does not work for drivers that need to block suspend for more
> >> than a few seconds. For instance the gpio keypad matrix driver needs
> >> to block suspend while keys are pressed so it can scan the keypad.
> >
> > I cannot imagine why it would take multiple seconds to scan a keypad.
> > Can you explain that?
> >
> > Do you mean while keys are held pressed?
> 
> Yes.
> 
> >  Maybe you don't get a wake-up event
> > on key-release?
> 
> We should.
> 
> >  In that case your user-space daemon could block suspend
> > while there are any pressed keys....  confused.
> >
> 
> The user-space daemon should not need to know which keys are in a
> matrix. We also have other drivers that need to block suspend. For
> instance, some devices need to block suspend while connected to a USB
> host.

And this decision (to block suspend) really needs to be made in the driver,
not in userspace?

You could get those drivers to return EBUSY from PM_SUSPEND_PREPARE (which
would need to be a configurable option), but then I guess you have no way to
wait for the device to become non-busy.

If user-space really cannot tell if the driver is busy or not, then I would
suggest that the driver is fairly poorly designed.

It would seem then that a user-space requested suspend is not sufficient for
your needs even if we remove the race window, as you have drivers that want
to avoid suspend indefinitely, and that "need to avoid suspend" status is not
visible from user-space.
It is a pity that this extra requirement was not clear from your introduction
to the "Opportunistic suspend support" patch.

If that be the case, I'll stop bothering you with suggestions that can never
work.
Thanks for your time,
NeilBrown
