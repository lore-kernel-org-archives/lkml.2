Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933415Ab1JRRaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 13:30:30 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55830 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756076Ab1JRRa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 13:30:29 -0400
Date: Tue, 18 Oct 2011 13:30:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: NeilBrown <neilb@suse.de>, Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of suspend/hibernate
 interfaces
In-Reply-To: <201110172327.18954.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1110181318420.1697-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Oct 2011, Rafael J. Wysocki wrote:

> > This requirement remains somewhat tricky.  Can we guarantee it?  It 
> > comes down to two things.  When an event occurs that will cause a 
> > program to want to keep the system awake:
> > 
> >      A. The event must be capable of interrupting a poll system
> > 	call.  I don't think it matters whether this interruption
> > 	takes the form of a signal or of completing the system call.
> > 
> >      B. The program must be able to detect, in a non-blocking way, 
> > 	whether the event has occurred.
> > 
> > Of course, any event that adds data to an input queue will be okay.  
> > But I don't know what other sorts of things we will have to handle.
> 
> Well, wakealarms don't do that, for one exaple.  Similarly for WoL through
> a magic packet AFAICS.  Similarly for "a cable has been plugged in"
> type of events.

I think we already know how to handle alarms.  For WoL we'd need 
something else -- a process would have to be notified about each resume 
and it would have to prevent further suspends until it knew that no 
more work needed to be done.

I don't know about the "cable has been plugged in" thing.  Is that 
generally regarded as a wakeup event?  I suspect it usually isn't.


> Well, it's not a bad idea in principle and I think it will work, so long
> as we can ensure that the PM daemon will be the only process using
> suspend/hibernate interfaces.
> 
> Apart from this, steps 1.-3. represent a loop with quite a bit of socket
> traffic if wakeup events occur relatively often (think someone typing on
> a keyboard being a wakeup device or moving a mouse being a wakeup device).

The socket traffic is troubling in that it takes time which could be 
spent at a lower power level.  On the other hand, this traffic occurs 
only when the processes involved are otherwise idle.  The only 
alternative seems to involve informing the PM daemon (or the kernel) 
at every wakeup event.


> > That's another thing we need to think about more carefully.  How 
> > extravagant do we want to make the wakeup/hibernation interaction?  My 
> > own feeling is: as little as possible (whatever that amounts to).
> 
> I don't agree with that.  In my opinion all system sleep interfaces should
> be handled.

I didn't mean it shouldn't be handled.  Just that hibernation should be
treated, to the extent we can, simply as a rather slow suspend -- not
specially.

> > Converting the programs that currently use Android's userspace
> > wakelocks might be somewhat more difficult.  Simply releasing a
> > wakelock would no longer be sufficient; a program would need to respond
> > to polls from the PM daemon whenever it was willing to let the system
> > go to sleep.
> 
> I honestly don't think it will be very practical to expect all of the
> existing Androig applications to be reworked this way ...

Android would probably use a different PM daemon design -- one that
could directly interact with their existing wakelock stuff.  Then all
they would need to do is change the implementation of userspace
wakelocks to communicate with this daemon instead of with the kernel.

Assuming they want to change their current design at all...

Alan Stern

