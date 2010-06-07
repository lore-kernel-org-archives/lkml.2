Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab0FGBJA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 21:09:00 -0400
Received: from www.tglx.de ([62.245.132.106]:45496 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735Ab0FGBI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 21:08:58 -0400
Date: Mon, 7 Jun 2010 03:07:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Matthew Garrett <mjg59@srcf.ucam.org>, Vitaly Wool <vitalywool@gmail.com>,
       Neil Brown <neilb@suse.de>, tytso@mit.edu,
       Peter Zijlstra <peterz@infradead.org>,
       Brian Swetland <swetland@google.com>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       James Bottomley <James.Bottomley@suse.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [linux-pm] suspend blockers & Android integrationy
In-Reply-To: <Pine.LNX.4.44L0.1006061956510.4894-100000@netrider.rowland.org>
Message-ID: <alpine.LFD.2.00.1006070206060.2933@localhost.localdomain>
References: <Pine.LNX.4.44L0.1006061956510.4894-100000@netrider.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

On Sun, 6 Jun 2010, Alan Stern wrote:

> On Sun, 6 Jun 2010, Matthew Garrett wrote:
> 
> > The difference between idle-based suspend and opportunistic suspend is 
> > that the former will continue to wake up for timers and will never be 
> > entered if something is using CPU, whereas the latter will be entered 
> > whenever no suspend blocks are held. The problem with opportunistic 
> > suspend is that you might make the decision to suspend simultaneusly 
> > with a wakeup event being received. Suspend blocks facilitate 
> > synchronisation between the kernel and userspace to ensure that all such 
> > events have been consumed and handld appropriately.
> 
> Remember that suspend takes place in several phases, the first of which 
> is to freeze tasks.  The phases can be controlled individually by the 
> process carrying out a suspend, and there's nothing to prevent you from 
> stopping after the freezer phase.  Devices won't get powered down, but 
> Android uses aggressive runtime power management for its devices 
> anyway.
> 
> If you do this then the synchronization can be carried out entirely
> from userspace, with no need for kernel modifications such as suspend
> blockers. And since Android can reach essentially the same low-power
> state from idle as from suspend, it appears that they really don't need
> any kernel changes at all.

Well there are some things to solve:

     1) the confinement of untrusted apps 

     2) the confinement of trusted apps firing periodic timers. 

     Aside of that they need to shut off undesired interrupt sources,
     but that's not a real problem to solve and probably possible
     today already.

#1 can be solved elegantly by cgroups. We know how to freeze the
   cgroup timers when the need arises, but that's not a real problem
   as all periodic timers are firing only once when the target app
   does not handle them.

   Though the cgroup based approach of freezing timers might be
   interesting for containers c/r as well and it might be necessary to
   emulate the suspend semantics of freezing CLOCK_MONOTONIC, but
   that's simple to do and basically no overhead.

#2 is a tad harder, as it requires to fix the trusted apps not to fire
   timers when there is nothing to do.

   Though you can solve it with cgroups as well. The unfreeze problem
   for real wakeups can be solved as mhelsley pointed out somewhere
   else in this thread.

But that depends on user space changes ....

Though as we learned today that suspend blockers are the least of the
problems which android is facing vs. mainline and we have a plan to
get the drivers in we can relax a bit and think more about it.

I'm not saying that we should ignore the shortcomings of todays code,
but in the face of hardware which perfectly goes into the same power
state from idle as it does from suspend we can IMNSHO safely ignore
the x86/ACPI/BIOS crap and the user space wreckage (see above) and
just focus on a sane design based on current/future hardware.

That's nothing new, we do not go and make NOHZ/HIGHRES work on crappy
hardware either, even if there have been patches around to do so. We
do not make broken TSCs work, even if there are brute force ways to do
so. ....

It's more sane to say "Sorry, it does not work on your system" than
trying to make it work under all circumstances for a questionable
benefit and paying the price for it in terms of maintainability and/or
complexity.

Thanks,

	tglx
