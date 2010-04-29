Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681Ab0D3UTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 16:19:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60009 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758294Ab0D3UTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 16:19:13 -0400
Date: Thu, 29 Apr 2010 11:41:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Ming Lei <tom.leiming@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 1/8] PM: Add suspend block api.
In-Reply-To: <h2wd6200be21004281635x9740a6abl2664a1eef8be061d@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1004291124580.1697-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Apr 2010, Arve Hjønnevåg wrote:

> >> >  suspend blockers can be used to allow
> >> > +user-space to decide whether a keystroke received while the system is suspended
> >> > +should cause the screen to be turned back on or allow the system to go back into
> >> > +suspend.
> >>
> >> That's not right.  Handling the screen doesn't need suspend blockers:
> >> The program decides what to do and then either turns on the screen or
> >> else writes "mem" to /sys/power/state.
> 
> That does not work though. Unless every key turns the screen on you
> will have a race every time the user presses a key you want to ignore.

Of course.  You are confirming what I wrote immediately below: Suspend
blockers help resolve races.  Note that this race has nothing to do
with the _screen_ in particular -- exactly the same race occurs if you
decide to turn on the audio speaker or some other piece of hardware.

> >>  What suspend blockers add is
> >> the ability to resolve races and satisfy multiple constraints when
> >> going into suspend -- which has nothing to do with operating the
> >> screen.
> 
> I'm not sure I agree with this. You cannot reliably turn the screen on
> from user space when the user presses a wakeup-key without suspend
> blockers.

Let's say that it has nothing to do _specifically_ with the screen.  
_Any_ action you want to take in userspace is difficult to coordinate 
with system suspends if you don't have suspend blockers.

> >>
> >> I _think_ what you're trying to get at can be expressed this way:
> >>
> >>       Here's an example showing how a cell phone or other embedded
> >>       system can handle keystrokes (or other input events) in the
> >>       presence of suspend blockers.  Use set_irq_wake...
> 
> OK, but the last version was what you (Alan) suggested last year.

So at least my mental processes have remained consistent over the span
of a year.  Nice to know I haven't undergone a complete personality 
change...  :-)

> >>       ...
> >>
> >>       - The user-space input-event thread returns from read.  It
> >>       carries out whatever activities are appropriate (for example,
> >>       powering up the display screen, running other programs, and so
> >>       on).  When it is finished, it calls suspend_unblock on the
> >>       process_input_events suspend_blocker and then calls select or
> >>       poll.  The system will automatically suspend again when it is
> >>       idle and no suspend blockers remain active.
> >
> > Yeah, that sounds better.  Arve, what do you think?
> >
> 
> Idle is irrelevant and needs to be removed. This new last step is also
> no longer a concrete example, but if you really think is it better I
> can change it.

Perhaps you would prefer to change this completely.  Write up a 
description of what can go wrong when suspend blockers _aren't_ used, 
and show how suspend blockers can prevent the problem from occurring.

But whatever you do, don't make it appear that suspend blockers allow
user programs to make decisions (which is what you wrote before).  They 
don't -- programs can make whatever decisions they want.  Suspend 
blockers merely help them carry out the actions they have decided upon 
in a safe manner.

And don't make it appear that suspend blockers can only be used for
solving screen-related problems.

Alan Stern

