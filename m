Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab1JQPdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 11:33:22 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47985 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752107Ab1JQPdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 11:33:21 -0400
Date: Mon, 17 Oct 2011 11:33:20 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: NeilBrown <neilb@suse.de>, Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of suspend/hibernate
 interfaces
In-Reply-To: <201110162232.28547.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1110171046490.2430-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Oct 2011, Rafael J. Wysocki wrote:

> On Sunday, October 16, 2011, Alan Stern wrote:
> > On Sat, 15 Oct 2011, Alan Stern wrote:
> > 
> > > Basically, what we need is a reliable way to intercept the existing
> > > mechanisms for suspend/hibernate and to redirect the requests to the PM
> > > daemon.  When the daemon is started up in "legacy" mode, it assumes
> > > there is a legacy client (representing the entire set of
> > > non-wakeup-aware programs) that always forbids suspend _except_ when
> > > one of the old mechanisms is invoked.
> > 
> > The more I think about this, the better it seems.  In essence, it 
> > amounts to "virtualizing" the existing PM interface.
> > 
> > Let's add /sys/power/manage, and make it single-open.
> 
> I'm not sure how to do that in sysfs.

If we don't implement the virtualization in the kernel, as Neil
suggests, then /sys/power/manage isn't necessary.  (And yes, I don't 
know how to make sysfs files single-open either -- probably there's no 
way to do it.)

> Also I'm not sure what the real difference between /sys/power/manage
> and my /sys/power/sleep_mode is (I could make /sys/power/sleep_mode
> single-open too, if I knew how to do that).

We really need to determine up front what userspace environments we
want to support.  It seems reasonable to decide that wakeup-awareness
will be available only on systems that use a centralized mechanism for
initiating system sleeps.  Whether that mechanism is pm-utils or a
vendor-specific program in an embedded system shouldn't matter too much
-- the important thing is that it can easily be changed to send
requests to a PM daemon instead of writing directly to /sys/power/state
or /dev/snapshot.

(Sending requests to the daemon need not be difficult; we could write a 
special program just for that purpose.)

If we do things this way, it leaves open the possibility of bypassing 
all the wakeup-aware code.  That's not necessarily a bad thing.

> > The only important requirement is that processes can use poll system 
> > calls to wait for wakeup events.  This may not always be true (consider 
> > timer expirations, for example), but we ought to be able to make some 
> > sort of accomodation.

This requirement remains somewhat tricky.  Can we guarantee it?  It 
comes down to two things.  When an event occurs that will cause a 
program to want to keep the system awake:

     A. The event must be capable of interrupting a poll system
	call.  I don't think it matters whether this interruption
	takes the form of a signal or of completing the system call.

     B. The program must be able to detect, in a non-blocking way, 
	whether the event has occurred.

Of course, any event that adds data to an input queue will be okay.  
But I don't know what other sorts of things we will have to handle.

> > The PM daemon will communicate with its clients over a Unix-domain
> > socket.  The protocol can be extremely simple: The daemon sends a byte
> > to the client when it wants to sleep, and the client sends the byte
> > back when it is ready to allow the system to go to sleep.  There's
> > never more than one byte outstanding at any time in either direction.
> > 
> > The clients would be structured like this:
> > 
> > 	Open a socket connection to the PM daemon.
> > 
> > 	Loop:
> > 
> > 		Poll on possible events and the PM socket.
> > 
> > 		If any events occurred, handle them.
> > 
> > 		Otherwise if a byte was received from the PM daemon,
> > 		send it back.
> > 
> > In non-legacy mode, the PM daemon's main loop is also quite simple:
> > 
> > 	1. Read /sys/power/wakeup_count.
> > 
> > 	2. For each client socket:
> > 
> > 		If a response to the previous transmission is still
> > 		pending, wait for it.
> > 
> > 		Send a byte (the data can be just a sequence number).
> > 
> > 		Wait for the byte to be echoed back.
> > 
> > 	3. Write /sys/power/wakeup_count.
> > 
> > 	4. Write a sleep command to /sys/power/manage.
> > 
> > A timeout can be added to step 2 if desired, but in this mode it isn't
> > needed.
> > 
> > With legacy support enabled, we probably will want something like a 
> > 1-second timeout for step 2.  We'll also need an extra step at the 
> > beginning and one at the end:
> > 
> > 	0. Wait for somebody to write "standy" or "mem" to 
> > 	   /sys/power/state (received via the /sys/power/manage file).

This would be replaced by: Wait for a sleep request to be received over 
the legacy interface.

> > 	5. Send the final status of the suspend command back to the
> > 	   /sys/power/state writer.

I haven't received any comments on these designs so far.  They seem
quite simple and adequate for what we want.  We may want to make the PM
daemon also responsible for keeping track of RTC wakeup alarm requests,
as Neil pointed out; that shouldn't be hard to add on.

> > Equivalent support for hibernation is left as an exercise for the 
> > reader.
> 
> Hehe.  Quite a difficult one for that matter. :-)

That's another thing we need to think about more carefully.  How 
extravagant do we want to make the wakeup/hibernation interaction?  My 
own feeling is: as little as possible (whatever that amounts to).

> > This really seems like it could work, and it wouldn't be tremendously 
> > complicated.  The only changes needed in the kernel would be the 
> > "virtualization" (or forwarding) mechanism for legacy support.
> 
> Yes, it could be made work, just as the hibernate user space interface,
> but would it be really convenient to use?  I have some doubts.

In terms of integration with current systems (and without the
virtualization), it should be very easy.  There will be a new daemon to
run when the system starts up, and a new program that will communicate
with that daemon (or will write to /sys/power/state if the daemon isn't
available).  That's all.

In terms of writing wakeup-aware clients, it's a little hard to say in 
the absence of any examples.  The client protocol described above 
shouldn't be too hard to use, especially if a wakeup library can be 
provided.

For something like a firmware update program, all the program has to do
is open a connection to the PM daemon before writing the new firmware.  
Nothing more -- if the program does not send any data over the socket
then the PM daemon will not allow sleep requests to go through.

Of course, the Android people have the most experience with this sort
of thing.  In an earlier discussion with Arve, he expressed some
concerns about getting the PM daemon started early enough (obviously it
needs to be running before any of its clients) and the fact that the
daemon would have to be multi-threaded.  I got the feeling that he was
complaining just for the sake of complaining, not because these things
would present any serious problems.

Converting the programs that currently use Android's userspace
wakelocks might be somewhat more difficult.  Simply releasing a
wakelock would no longer be sufficient; a program would need to respond
to polls from the PM daemon whenever it was willing to let the system
go to sleep.

Alan Stern

