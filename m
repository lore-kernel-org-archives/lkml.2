Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762653Ab0HGN0M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 09:26:12 -0400
Received: from netrider.rowland.org ([192.131.102.5]:52478 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753213Ab0HGN0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 09:26:10 -0400
Date: Sat, 7 Aug 2010 09:26:08 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: david@lang.hm
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <arve@android.com>, <mjg59@srcf.ucam.org>, <pavel@ucw.cz>,
        <florian@mickler.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        <swetland@google.com>, <peterz@infradead.org>, <tglx@linutronix.de>,
        <alan@lxorguk.ukuu.org.uk>, <menage@google.com>,
        David Brownell <david-b@pacbell.net>, <James.Bottomley@suse.de>,
        <tytso@mit.edu>, <arjan@infradead.org>, <swmike@swm.pp.se>,
        <galibert@pobox.com>, <dipankar@in.ibm.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
In-Reply-To: <alpine.DEB.2.00.1008061950050.30564@asgard.lang.hm>
Message-ID: <Pine.LNX.4.44L0.1008070857120.20673-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Aug 2010 david@lang.hm wrote:

> >> 1. the ability to decide to suspend while there are still some
> >> 'unimportant' apps running.
> >
> > While this may be true in some literal sense, it certainly is not the
> > best way to view the situation.  Linux already has the ability to
> > suspend (or to decide to suspend) whenever you want.  What Android has
> > added is the ability to suspend conditionally, based on whether or not
> > some applications or drivers want to keep the system running.
> 
> Ok, aside from possibly drivers, what' stopping this from being done on a 
> valilla system today?

Nothing much.  Mainly just the fact that Rafael's code is so new.  It 
hasn't yet been integrated into the drivers that should use it.

> > Furthermore, this statement leaves out the primary purpose of
> > wakelocks: to avoid races between suspending and wakeup events.  And it
> > also ignores a very important distinction: the difference between
> > drivers and applications.  Wakelocks are used by both, but it has been
> > shown that only the wakelocks used by drivers need to be implemented in
> > the kernel -- the others can be implemented entirely in userspace.
> 
> Ok, this is the first I've heard in this discussion that wakelocks would 
> not be available to userspace. In fact it was explicitly stated that 
> userspace applications called IOCTLs to get/release the wakelock.

Android's wakelock implementation does make wakelocks available to
userspace.  In Rafael's approach there is nothing comparable.  Instead
"userspace wakelock"-equivalents have to be handled by a power manager
program.

> many of my objections (voiced in another thread) about Android specific 
> features are not relavent if the wakelock in userspace is just part of 
> that application framework and not tied into the kernel.
> 
> > All of these issues are addressed by Raphael's new wakeup_events code.
> 
> Ok, then why is there still discussion about wakelocks at all if Raphael 
> has implemnetd the needed kernel functionality and userspace is Android 
> SDK specific?

This thread started when Paul posted his list of requirements for
Android power management (or power management in general).  It wasn't
really specific to wakelocks, but people brought them up when
discussing how those requirements are currently being met.

In fact, it seems to me that _you_ are the person most responsible for 
prolonging this discussion.

> the heated replys from some people about what Android needs 
> (from people who I assumed were Android maintainers due to the way they 
> were answering questions) sure didn't sound like this was a solved 
> problem.

The solution is still in its early stages, and it hasn't yet been 
accepted into Android.  Things will improve over time.  (Or they won't, 
and Android will continue to go its separate way...)


> > This is nonsense.  Nothing was changed.  Instead, Android implemented
> > system suspend on their platform in a way that would leave some devices
> > running while the rest of the system powered down.  There's nothing out
> > of the ordinary about this.  Platforms are free to implement system
> > suspend in whatever way they deem most appropriate.  On modern PCs, the
> > most appropriate technique is to go into ACPI's S3 or S4 state.  On
> > embedded systems, the technique will vary from one platform to another.
> 
> the difference is that not all suspends on Android are the same, 
> sometimes when you suspend you power down the audio components, sometimes 
> you don't.

That's not a difference; it is their decision.  For all you or I know, 
other platforms have been doing the same thing for years.

> As far as I am aware (and please correct meif I am mistaken), this is 
> significantly different from suspend elsewhere where suspend always takes 
> you to the same state.

You are mistaken.  Or at best, you are overgeneralizing.  It may be 
true now that all other suspend implementations always go to the same 
state, but there is no requirement that they do so.

> >> If these two features were available, I think that the rest of what they
> >> are looking for could be built up without requireing other changes.
> >
> > They already _are_ available.  Admittedly, only since quite recently.
> > (Rafael's new code was accepted during the 2.6.36 merge window.)
> 
> Do Brian and Arve agree that this solves their problem?

I think you should ask them instead of asking me.

> to be fair, there have been numerous complaints about suspend being 
> separate from deep sleep long before Android. Linus' blow-up that resulted 
> in Hibernation and Suspend being separated from each other is a case in 
> point. He was making the point that there shouldn't be a difference 
> between the deepest sleep and suspend.

This may be controversial, but I think Rafael will agree when I say
that (in this one respect) Linus was wrong.  Separating hibernation
from suspend makes sense, and I agree that the differences between
deepest idle and suspend should be minimized.  But to get rid of them
altogether would be wrong (and probably not possible anyway).

> As deep sleep gains the ability to use even less power and as suspend 
> gains the ability to leave things on sometimes, the difference between 
> them is dissapearing. I wouldn't be at all surprised to see them start 
> overlaping soon. So it's not that I think Android should use deep sleeps 
> instead of suspend, but rather that suspend should just be the deepest 
> sleep, one mechanism instead of two.

I disagree.  There are critical differences between them:

	Suspend uses the freezer and idle doesn't.

	Suspend generally forces devices to go into their low-power 
	states immediately, whereas idle tends to leave unused devices
	at full power for some time before going to low power (to
	minimize average latency).

	Overall, suspend generally has longer latency than idle.  (This 
	varies among platforms.)

	The set of wakeup sources (including timers) is different.

	On some systems, suspend uses platform-specific mechanisms to 
	go into lower power states than are available to idle.

There may be others I have left out.

Alan Stern

