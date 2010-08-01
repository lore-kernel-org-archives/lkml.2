Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402Ab0HATl7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 15:41:59 -0400
Received: from netrider.rowland.org ([192.131.102.5]:46038 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751049Ab0HATl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 15:41:58 -0400
Date: Sun, 1 Aug 2010 15:41:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: linux-pm@lists.linux-foundation.org, <linux-kernel@vger.kernel.org>,
        <arve@android.com>, <mjg59@srcf.ucam.org>, <pavel@ucw.cz>,
        <florian@mickler.org>, <rjw@sisk.pl>, <swetland@google.com>,
        <peterz@infradead.org>, <tglx@linutronix.de>,
        <alan@lxorguk.ukuu.org.uk>
Subject: Re: Attempted summary of suspend-blockers LKML thread
In-Reply-To: <20100801043610.GF2470@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.44L0.1008011521390.20420-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > o	"Power-aware application" are applications that are permitted
> > > 	to acquire suspend blockers on Android.  Verion 8 of the
> > > 	suspend-blocker patch seems to use group permissions to determine
> > > 	which applications are classified as power aware.
> > > 
> > > 	More generally, power-aware applications seem to be those that
> > > 	have permission to exert some control over the system's
> > > 	power state.
> > 
> > Notice that these definitions allow a program to be both power-naive
> > and power-aware.  In addition, "power-awareness" isn't an inherent
> > property of the application itself, since users are allowed to decide
> > which programs may exert control over the system's power state.  The 
> > same application could be power-aware on one system and non-power-aware 
> > on another.

I should have made a stronger point: "power-aware" is _not_ a good
term for these applications.  "power-enabled" would be better but
still not ideal.  Maybe "power-permitted"?  The definition is that
they are _permitted_ to do something (acquire suspend blockers), not
that they actually _do_ something.

> > > REQUIREMENTS
> > > 
> > > o	Reduce the system's power consumption in order to (1) extend
> > > 	battery life and (2) preserve state until AC power can be obtained.
> > 
> > External power, not necessarily AC power (a very minor point).
> 
> A good one, though.

Arjan's point here is well taken.  Even systems that always run on
external power have motivation for conserving energy (e.g., they may
be required by government regulation to do so).

> > > o	In order to avoid overrunning hardware and/or kernel buffers,
> > > 	input events must be delivered to the corresponding application
> > > 	in a timely fashion.  The application might or might not be
> > > 	required to actually process the events in a timely fashion,
> > > 	depending on the specific application.
> > 
> > This goes well beyond overrunning buffers!  Events must be delivered in
> > a timely fashion so that the system isn't perceived to be inoperative.
> 
> Agreed for power-aware applications.  For power-naive applications,
> the last event delivered can be buffered by the application with no
> response if I understand correctly.  If there is a subsequent event
> for that same application, then the prior event can be processed.

I was agreeing with the requirement but disagreeing with the reason
given for it.  Even when buffers are large enough that the danger of
overrunning them is infinitesimal, delays in input event delivery are
still undesirable.

Besides, the Android kernel doesn't vary its behavior based on whether
the recipient is power-permitted or power-naive; it _always_ delivers
input events in a timely fashion.

> > > o	If a power-aware application receives user input, then that
> > > 	application must be given the opportunity to process that
> > > 	input.
> > 
> > A better way to put this is: The API must provide a means for
> > power-aware applications receiving user input to keep themselves
> > running until they have been able to process the input.
> 
> Good point!  Would it also make sense to say "events" in general rather
> than "input" in particular?

Sure.

> > > o	Power-naive applications must be prohibited from controlling
> > > 	the system power state.  One acceptable approach is through
> > > 	use of group permissions on a special power-control device.
> > 
> > You mean non-power-aware applications, not power-naive applications.  
> > But then the statement is redundant; it follows directly from the
> > definition of "power-aware".
> 
> I see your point, but I don't feel comfortable deleting this requirement.
> My rationale is that the definition needs some enforcement mechanism,
> and this requirement is calling out the need for such a mechanism.

Then state it immediately after the definition as an implication of
the definition, not as a separate system requirement.

> > > o	When a power-aware application is preventing the system from
> > > 	shutting down, and is also waiting on a power-naive application,
> > > 	the power-aware application must set a timeout to handle
> > > 	the possibility that the power-naive application might halt
> > > 	or otherwise fail.  (Such timeouts are also used to limit the
> > > 	number of kernel modifications required.)
> > 
> > No, this is not a requirement.  A power-optimized application would do 
> > this, of course, by definition.  But a power-aware application doesn't 
> > have to.
> 
> I am not sure we agree on the definition of "power-optimized application".
> But leaving that aside, I thought that Arve and Brian explicitly
> stated this as a requirement on power-aware applications -- one of the
> responsibilities that came with the power to block suspend.

No.  There are _no_ requirements on power-permitted (or power-aware if
you prefer) applications, other than that the user decides to give it
the appropriate permission.

Internally, of course, Android may enforce this rule on their own
software.  But it has no force in regard to external applications.

> > > o	If no power-aware or power-optimized application are indicating
> > > 	a need for the system to remain operating, the system is permitted
> > > 	(even encouraged!) to suspend all execution, even if power-naive
> > > 	applications are runnable.  (This requirement did appear to be
> > > 	somewhat controversial.)
> > 
> > The controversy was not over the basic point but rather over the 
> > detailed meaning of "runnable".  A technical matter, related to the 
> > implementation of the scheduler.
> 
> OK, what would you suggest for the wording of this requirement?

Change the last phrase to "regardless of the state of power-naive
applications".

Alan Stern

