Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899Ab0FVCqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 22:46:55 -0400
Received: from netrider.rowland.org ([192.131.102.5]:45734 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758791Ab0FVCqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 22:46:53 -0400
Date: Mon, 21 Jun 2010 22:46:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: markgross@thegnar.org
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
Subject: Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
In-Reply-To: <20100622015837.GC12795@gvim.org>
Message-ID: <Pine.LNX.4.44L0.1006212224550.19813-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jun 2010, mark gross wrote:

> > I get the feeling you didn't fully absorb the intent of the original
> > wakelock patches.  Right from the start they were about fixing a race
> > in system suspend: The system may go to sleep even though a pending
> 
> wrong.  They are about 1) adding opportunistic suspend, and 2) adding
> critical sections to block suspend.  
> 
> No race issues where ever talked about until alternative solutions
> where put up.

That's not how I remember it.  But this point isn't important enough to 
be worth digging through the old emails to verify or disprove it.

> I am struck by how differently you are seeing things.

Those discussions were (and still are!) so long and annoying, it
wouldn't be surprising if _everybody_ saw them differently!  :-)  You
certainly must agree that a lot of differing personal viewpoints were
expressed.

> > > Lets consider the RIL incoming call race:
> > 
> > "RIL"?
> 
> You are not an android developer are you?

Nope.

>  RIL is the user mode Radio
> Interface Layer.
>  
> > > 1) user mode initiates an "opportunistic suspend" or whatever we call
> > > this these days by writing to some sys interface.
> > 
> > Okay.
> > 
> > > 2) a call comes in (multi-threaded cpu) just after the write.
> > 
> > Right.  Presumably we want the suspend to be delayed until the call 
> > can be handled by a user programm, yes?
> > 
> > > 3) the caif driver grabs a blocker, stopping the in flight suspend in the
> > > nick of time.  But, when should it release it without racing?  How does
> > > one implement that kernel code such that its portable to non-android user
> > > mode stacks? 
> > 
> > I don't know anything about the caif driver so I can't answer this
> > question in detail.  Here's the general idea: Somehow the kernel has to
> > notify userspace that an incoming call has arrived.  Whatever driver or
> > subsystem sends that notification should release the suspend blocker
> > once userspace indicates that the notification has been received (for
> > example, by reading all the data in an input event queue).  That's true
> > for both Android and non-Android.
> 
> so tell me how user space indicates to the kernel object will ever know
> when its ok to release the blocker?

First you tell me how the kernel indicates to userspace that an
incoming call has arrived.  My answer will depend on that.

> then tell me how suspend blocker provide an elegant portable solution
> to this that works for multiple user mode stacks.

When did I -- or anyone -- ever say it was "elegant"?

As for multiple user mode stacks, I don't see the issue.  If you grant
there is a mechanism whereby userspace indicates to the kernel that a
blocker may be released, then it seems obvious that this mechanism
could be used in multiple user mode stacks.

> problem 1) opportunistic enable suspend deferral for critical sections
> when suspending is "bad"
> problem 2) race between entering pm_suspend call tree and wake events. 

Can you point out any examples of kernel critical sections where 
suspending is "bad" that aren't started by arrival of a wakeup event?  
Unless you can, I'm justified in saying that these "two" problems are 
one and the same.

> > The fact that this is bound to a user-mode PM design was inevitable, 
> > given the whole idea was to overcome weaknesses in the system suspend 
> > implementation and that implementation already is driven by userspace.
> 
> I think we can do better.

Maybe we can.  I'm certainly not going to claim that suspend blockers
are the best possible solution.  And I'm not really keen on seeing them 
merged along with all the attendant opportunistic suspend and userspace 
API stuff.  But so far I haven't heard anything significantly better.

> > I don't know -- I have never looked at the Android userspace.  No doubt 
> > Arve can provide some examples.
> who are you?

You sound like a Vorlon.  Should I ask: "What do you want?"  :-)

>  You don't know about the Android stack, and you keep
> blowing about how suspend blockers solve all the PM problems?

Not all of them.  Just the race between wakeup events and suspend.

>  I'm
> starting to think your just trolling. 

You may think what you like.  Perhaps there is a certain degree of
truth to the accusation -- goodness knows, I do tend to prolong
technical conversations when I think I'm right.  (Ask anybody who has
corresponded with me for any length of time.)  But this is probably
true of a lot of kernel developers...

Alan Stern

