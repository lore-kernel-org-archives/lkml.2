Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896Ab0FVCYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 22:24:54 -0400
Received: from netrider.rowland.org ([192.131.102.5]:33811 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752899Ab0FVCYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 22:24:52 -0400
Date: Mon, 21 Jun 2010 22:24:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: markgross@thegnar.org
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
Subject: Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
In-Reply-To: <20100622012519.GB12795@gvim.org>
Message-ID: <Pine.LNX.4.44L0.1006212207410.19813-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jun 2010, mark gross wrote:

> On Mon, Jun 21, 2010 at 12:01:09PM -0400, Alan Stern wrote:
> > On Sun, 20 Jun 2010, mark gross wrote:
> > 
> > > Your confused about what problem this patch attempts to solve.
> > 
> > I don't think so.  Rafael's description was pretty clear.
> 
> Then how is it you don't understand the fact that Rafael's patch is to
> solve the wake event notification suspend race and not block opertunistic
> suspends or kernel critical sections where suspending should be disabled?

I don't know what gave you the idea that I think Rafael's patch is 
meant to block kernel critical sections.  I certainly don't think that.

However leaving that aside, the rest of the above is just two different
ways of saying the same thing:

	Wakeup events should cause suspend to be disabled until the
	events are processed.

	Arrival of wakeup events races with initiation of system 
	suspend (whether opportunistic or not).

Therefore blocking suspends when they ought to be disabled requires us 
to solve the wake event/suspend race.  You can't do one without doing 
the other.

> > >  There is
> > > a pm_qos patch in the works to address the suspend blocker
> > > functionality.
> > > http://lists.linux-foundation.org/pipermail/linux-pm/2010-June/026760.html
> > 
> > No.  That patch addresses something _similar_ to the suspend blocker
> > functionality.  The fact remains, though, that pm_qos is not used
> > during system suspend (the /sys/power/state interface), hence changes
> > to pm_qos won't solve the system-suspend problems that suspend blockers 
> > do solve.
> 
> You keep saying they solve something, I keep wondering what you are
> talking aobut.
> Lets see what problems it solves:
> * implements oppertunistic suspending (this is a feature not a problem)
> * enables kernel critical sections blocking suspending.
> * requiers overlapping application specific critcal sections from ISR
> into user mode to make implementation correct.
> * exposes a user mode interface to set a critical section.
> * reduces races between wake events (or suspend blocking events) but I'm
> not convinced it solves them. 

The last item on your list is what I meant.  The others are not 
problems solved by suspend blockers.  Well, maybe the second is, but I 
don't know of any kernel critical sections that need to block suspend 
other than those caused by wakeup events.

I agree with you that bundling opportunistic suspend and the user mode 
interface together with suspend blockers made the situation more 
difficult by mixing up the important issues.

> suspend blockers provide a way to block oppertunistic suspending, wich
> I'll have you know, is a pain to get working right and the enabling from
> device to device is not very portable and *that* doesn't say good things
> about the scheme.

The real problem with the scheme is to define which events should count
as "wakeup" events and to determine when they have been fully handled.  
I can see that these might well vary from one platform to another.  
(Maybe that's what you mean by saying the enabling is not very
portable.)  But these issues are unavoidable; any scheme will have to
address them.

Alan Stern

