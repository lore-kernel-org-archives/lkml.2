Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981Ab0FUP52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 11:57:28 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54946 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757148Ab0FUP50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 11:57:26 -0400
Date: Mon, 21 Jun 2010 11:57:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: markgross@thegnar.org
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
Subject: Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
In-Reply-To: <20100621055522.GE9735@gvim.org>
Message-ID: <Pine.LNX.4.44L0.1006211125470.1687-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jun 2010, mark gross wrote:

> > > 1) I don't think suspend blockers really solve or effectively articulate
> > > the suspend wake event race problem.
> > 
> > Why not?
> 
> For starters the suspend block patch is about suspend blocking, at least
> at first before competing ideas starting coming out and this race issue
> was offered up as an excuse to not consider the alternative ideas, then
> suddenly suspend blocking became a wake event notification mechanism
> implementation that was baked into the implementation.  The arguments
> are still a blur and irritating to recall / look up again.

I get the feeling you didn't fully absorb the intent of the original
wakelock patches.  Right from the start they were about fixing a race
in system suspend: The system may go to sleep even though a pending
wakeup event should have blocked or prevented the suspend.  In
particular that means notifying the PM core about wakeup events, when
they occur, and when the system may once again be allowed to suspend.

The userspace parts of the original patches did cloud the issue,
admittedly.  But the purpose of the in-kernel parts has always been
clear.

> But, the point I'm trying to make is that wake event serialization /
> event handling suddenly became a big FUD-pie tightly bound to a specific
> feature for suspend blocking (or was is auto suspending?  Its a magical
> solution to all the PM problems in the kernel.  I'm being sarcastic.)  
> 
> Its much better to call out the issue and provide a clean targeted
> solution to it without binding it to some other solution to a different
> problem.

That's exactly what the wakelock patches did:  They called out the
issue of the system suspending even while there were pending wakeup
events, they provided a targeted solution, and it wasn't bound to
another solution to a different problem.

Indeed, if you go back through the (I agree, irritating) threads on
this topic, you'll see that the FUD and other issues were all
introduced by other kernel developers, mainly because they didn't like
the idea of using system suspend as a mechanism for dynamic power
management.

> > > I don't think suspend-blocker handles both kinds of races as well as you
> > > seem to think.
> > 
> > Can you give any counterexamples?
> 
> I knew you'd ask such a thing.  Do you have any correctness proofs of it
> working right?

If you want, sure.  But what you think "working right" means may not be 
the same as what I think.

> Lets consider the RIL incoming call race:

"RIL"?

> 1) user mode initiates an "opportunistic suspend" or whatever we call
> this these days by writing to some sys interface.

Okay.

> 2) a call comes in (multi-threaded cpu) just after the write.

Right.  Presumably we want the suspend to be delayed until the call 
can be handled by a user programm, yes?

> 3) the caif driver grabs a blocker, stopping the in flight suspend in the
> nick of time.  But, when should it release it without racing?  How does
> one implement that kernel code such that its portable to non-android user
> mode stacks? 

I don't know anything about the caif driver so I can't answer this
question in detail.  Here's the general idea: Somehow the kernel has to
notify userspace that an incoming call has arrived.  Whatever driver or
subsystem sends that notification should release the suspend blocker
once userspace indicates that the notification has been received (for
example, by reading all the data in an input event queue).  That's true
for both Android and non-Android.

In some cases there may not be any mechanism for userspace to tell the 
kernel when a notification has been received.  For thoses cases, the 
Android people used timer-based blockers.  This is not necessarily the 
best approach but they seem happy with it.  Others might prefer to add 
an explicit "notification received" mechanism.

Still others take the view that since suspends are initiated by 
userspace anyway, it's not necessary to tell the kernel when suspend is 
safe again.  Just tell the user process responsible for initiating 
suspends.

> > >  A single tool that conflates multiple kernel facilities
> > > is not an advantage.  It limits applications outside of the scope of
> > > doing it the "android way".
> > 
> > I don't see that necessarily as a drawback.  You might just as well say
> > that the entire Linux kernel limits applications to doing things the
> > "Unix" way.  Often have fewer choices is an advantage.
> 
> I disagree with your analogy.  One problem one solution with minimal
> coupling to other implementation details is nice.  Two problems with one
> solution dependent on the system wide architecture bound to a user mode
> PM design is fragile and not portable.

I assume the "two problems" you refer to are: telling the PM core that 
the kernel has a wakeup event in progress, and telling the PM core that 
userspace has a wakeup event in progress.  To me these don't seem to be 
vastly different problems, and having a single solution for both 
doesn't seem out of line.

The fact that this is bound to a user-mode PM design was inevitable, 
given the whole idea was to overcome weaknesses in the system suspend 
implementation and that implementation already is driven by userspace.

> > (Incidentally, even on Android the centralized PM process does not 
> > handle _all_ of the userspace/kernel wakelock interactions.)
> >
> 
> Yeah, I've been told that too.  I've grepped for where the wake_unlock
> sysfs interfaces are hit from user mode android (eclair) and I would
> like some help in identifying those guys. Maybe its in the FroYo code I
> don't get to look at yet?
> 
> There is libhardware_legacy/power/power.c and  an out of tree kernel
> broadcom bcm4329 driver under hardware/broadcom but that doesn't count
> as it looks like a kernel driver to me.

I don't know -- I have never looked at the Android userspace.  No doubt 
Arve can provide some examples.

Alan Stern

