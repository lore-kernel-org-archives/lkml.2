Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934134Ab0D3Sl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:41:28 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38031 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758698Ab0D3SlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:41:14 -0400
Date: Fri, 30 Apr 2010 10:41:12 -0400 (EDT)
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
In-Reply-To: <p2qd6200be21004291639qd65002a8l4cfbf635962615ba@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1004301017170.1535-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Apr 2010, Arve Hjønnevåg wrote:

> >> That does not work though. Unless every key turns the screen on you
> >> will have a race every time the user presses a key you want to ignore.
> >
> > Of course.  You are confirming what I wrote immediately below: Suspend
> Yet you offered it as an example of why "Handling the screen doesn't
> need suspend blockers".

What I meant was this: Without suspend blockers you can still turn the
screen on and off, but you can't avoid races.  Therefore: You don't
need suspend blockers to handle the screen, but you do need them to
handle races.

> > blockers help resolve races.  Note that this race has nothing to do
> > with the _screen_ in particular -- exactly the same race occurs if you
> > decide to turn on the audio speaker or some other piece of hardware.
> >
> I agree with this, but that does not mean that describing how you can
> handle the screen with suspend blockers is a bad example.

Agreed; it's not a bad example.  My objection is to the way the example
is presented.

> I think suspend blockers do allow user programs to make decisions.
> Without suspend blockers some decisions can only be safely be made in
> the kernel/drivers.

This is our real disagreement -- it's mainly a question of the meaning
of words.  When one says "A allows B to make a decision", this means
that without A, B would literally be unable to decide what to do.  It
wouldn't be able to "make up its mind" (like the donkey that starves
while stuck halfway between two piles of hay because it can't decide 
which pile to eat).

That's not what you mean to say.  In your case there's no difficulty in
making the choice -- the program knows exactly what it wants to do.  
The problem is that without suspend blockers, it can't _carry out_ the
chosen action.  To put it another way, the suspend blockers don't help
with deciding which action to take; rather they help with taking the
action after it has been decided upon.

Or put this way: Suppose suspend blockers were not available.  Then the
desired action would not be safe, so the program wouldn't be able to
take it.  The decision would thus be even simpler, since one of the
choices would be eliminated.  In this way, lack of suspend blockers
makes the decision easier, not harder.  So you shouldn't say that
suspend blockers allow the program to make the decision.

What your example _really_ shows is how a program can carry out a 
prolonged action that requires the system to be awake for an extended 
period of time.  Even with suspend blockers, the right way to do this 
safely isn't necessarily obvious.  That's how the example helps.

> How about:
> 
> - The user-space input-event thread returns from read. If it
> determines that the key should be ignored, it calls suspend_unblock on
> the process_input_events suspend_blocker and then calls select or
> poll. The system will automatically suspend again, since now no
> suspend blockers are active.

Do you want to mention here that everything will work correctly even if 
the system suspends before the thread can call select or poll?

> If the key that was pressed instead should preform a simple action
> (for example, adjusting the volume), this action can be performed
> right before calling suspend_unblock on the process_input_events
> suspend_blocker. However, if the key triggers a longer-running action,
> that action needs its own suspend_blocker and suspend_block must be
> called on that suspend blocker before calling suspend_unblock on the
> process_input_events suspend_blocker.

That's good!  I like it.  Now if you can change the beginning of the
example, to say that it shows how programs should use suspend blockers
instead of showing that suspend blockers allow programs to make
decisions.

Alan Stern

