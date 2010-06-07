Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628Ab0FGOm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 10:42:26 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37244 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751424Ab0FGOmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 10:42:25 -0400
Date: Mon, 7 Jun 2010 10:42:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Thomas Gleixner <tglx@linutronix.de>
cc: Matthew Garrett <mjg59@srcf.ucam.org>, Vitaly Wool <vitalywool@gmail.com>,
       Neil Brown <neilb@suse.de>, <tytso@mit.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       =?ISO-8859-1?Q?Arve_Hj=EF=BF=BDnev=EF=BF=BD?= <arve@android.com>,
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
In-Reply-To: <alpine.LFD.2.00.1006070206060.2933@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.1006071010001.1398-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jun 2010, Thomas Gleixner wrote:

> Alan,

Thomas:

> On Sun, 6 Jun 2010, Alan Stern wrote:

> > Remember that suspend takes place in several phases, the first of which 
> > is to freeze tasks.  The phases can be controlled individually by the 
> > process carrying out a suspend, and there's nothing to prevent you from 
> > stopping after the freezer phase.  Devices won't get powered down, but 
> > Android uses aggressive runtime power management for its devices 
> > anyway.
> > 
> > If you do this then the synchronization can be carried out entirely
> > from userspace, with no need for kernel modifications such as suspend
> > blockers. And since Android can reach essentially the same low-power
> > state from idle as from suspend, it appears that they really don't need
> > any kernel changes at all.
> 
> Well there are some things to solve:
> 
>      1) the confinement of untrusted apps 
> 
>      2) the confinement of trusted apps firing periodic timers. 

No, these things don't need to be solved.

The difference between our approaches is that you're trying to find a
solution that can be used more generally, not just on Android, whereas
I'm simply trying to find a way to help Arve and Brian accomplish what
they want as easily as possible.

(Even though some kernel developers may consider their design to be
ill-conceived.  So long as the objectionable features are confined to
userspace nobody will mind.  And if a few small kernel patches are
needed, they will most likely be accepted if they aren't intrusive.)

This means sticking to the "big-gun" approach of system-wide suspend or
its equivalent, because Android's userspace is so unstructured and
has so many widespread (perhaps even conflicting!) requirements.  And 
of course the necessary changes to userspace should be minimal.

Thus, in my proposed scheme there is no need to confine untrusted apps,
just as there was no need to do so when using wakelocks in their
original form.  Likewise, there is no need to worry about trusted apps
firing periodic timers: Once processes are frozen, user timers really
don't matter much.

>      Aside of that they need to shut off undesired interrupt sources,
>      but that's not a real problem to solve and probably possible
>      today already.

Yes.  They may also need to shut off undesired kernel timers.  This 
should be doable as well, and it would benefit all platforms.

> #1 can be solved elegantly by cgroups. We know how to freeze the
>    cgroup timers when the need arises, but that's not a real problem
>    as all periodic timers are firing only once when the target app
>    does not handle them.

That's why I said they don't matter much.

>    Though the cgroup based approach of freezing timers might be
>    interesting for containers c/r as well and it might be necessary to
>    emulate the suspend semantics of freezing CLOCK_MONOTONIC, but
>    that's simple to do and basically no overhead.

Cgroups are not needed.  The power-manager process can simply freeze 
all tasks other than itself.

> #2 is a tad harder, as it requires to fix the trusted apps not to fire
>    timers when there is nothing to do.

No; all you have to do is handle the trusted apps as though they were 
untrusted -- just as in the original wakelock approach.

>    Though you can solve it with cgroups as well. The unfreeze problem
>    for real wakeups can be solved as mhelsley pointed out somewhere
>    else in this thread.
> 
> But that depends on user space changes ....

If you handle all the apps uniformly, very few userspace changes are
needed.

> Though as we learned today that suspend blockers are the least of the
> problems which android is facing vs. mainline and we have a plan to
> get the drivers in we can relax a bit and think more about it.

The only reason for inventing suspend blockers in the first place was
to make system suspend reliable in the face of races with wakeup
sources.  If system suspend doesn't run to completion, but stops after
freezing all tasks other than the power manager, then these races can
be handled entirely within userspace.  Hence there is no need to have
suspend blockers at all.

Assuming Arve doesn't find any fatal flaws in this approach, the issue 
will become moot.  We can relax and _avoid_ thinking about it!  :-)

> I'm not saying that we should ignore the shortcomings of todays code,
> but in the face of hardware which perfectly goes into the same power
> state from idle as it does from suspend we can IMNSHO safely ignore
> the x86/ACPI/BIOS crap and the user space wreckage (see above) and
> just focus on a sane design based on current/future hardware.

You're preaching to the choir.  If the Google people want to use
suspend blockers on ACPI-based systems ... well, we can resume the
arguments then.  They won't be nearly as pressing.

> That's nothing new, we do not go and make NOHZ/HIGHRES work on crappy
> hardware either, even if there have been patches around to do so. We
> do not make broken TSCs work, even if there are brute force ways to do
> so. ....
> 
> It's more sane to say "Sorry, it does not work on your system" than
> trying to make it work under all circumstances for a questionable
> benefit and paying the price for it in terms of maintainability and/or
> complexity.

Agreed.

Alan Stern

