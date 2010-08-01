Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272Ab0HAEg2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 00:36:28 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44862 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840Ab0HAEg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 00:36:27 -0400
Date: Sat, 31 Jul 2010 21:36:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, swetland@google.com,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100801043610.GF2470@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100731175841.GA9367@linux.vnet.ibm.com>
 <Pine.LNX.4.44L0.1007311544470.5418-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1007311544470.5418-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 31, 2010 at 04:19:48PM -0400, Alan Stern wrote:
> On Sat, 31 Jul 2010, Paul E. McKenney wrote:
> 
> > Rushing in where angels fear to tread...
> > 
> > I had been quite happily ignoring the suspend-blockers controversy.
> > However, now that I have signed up for the Linaro project that involves
> > embedded battery-powered devices, I find that ignorance is no longer
> > bliss.  I have therefore reviewed much of the suspend-blocker/wakelock
> > material, but have not yet seen a clear exposition of the requirements
> > that suspend blockers are supposed to meet.  This email is a attempt
> > to present the requirements, based on my interpretation of the LKML
> > discussions.
> > 
> > Please note that I am not proposing a solution that meets these
> > requirements, nor am I attempting to judge the various proposed solutions.
> > In fact, I am not even trying to judge whether the requirements are
> > optimal, or even whether or not they make sense at all.  My only goal
> > at the moment is to improve my understanding of what the Android folks'
> > requirements are.  That said, I do include example mechanisms as needed to
> > clarify the meaning of the requirements.  This should not be interpreted
> > as a preference for any given example mechanism.
> > 
> > But first I am going to look at nomenclature, as it appears to me that
> > at least some of the flamage was due to conflicting definitions.  Following
> > that, the requirements, nice-to-haves, apparent non-requirements,
> > an example power-optimized applications, and finally a brief look
> > at other applications.
> > 
> > Donning the asbestos suit, the one with the tungsten pinstripes...
> > 
> > 							Thanx, Paul
> 
> At the risk of sticking my neck out, I think a few of your statements
> don't fully capture the important ideas.

Fair enough!  ;-)

And thank you for looking this over!!!

> > ------------------------------------------------------------------------
> > 
> > DEFINITIONS
> > 
> > o	"Ill-behaved application" AKA "untrusted application" AKA
> > 	"crappy application".  The Android guys seem to be thinking in
> > 	terms of applications that are well-designed and well-implemented
> > 	in general, but which do not take power consumption or battery
> > 	life into account.  Examples include applications designed for
> > 	AC-powered PCs.  Many other people seemed to instead be thinking
> > 	in terms of an ill-conceived or useless application, perhaps
> > 	exemplified by "bouncing cows".
> > 
> > 	Assuming I have correctly guessed what the Android guys were
> > 	thinking of, perhaps "power-naive applications" would be a
> > 	better description, which I will use until someone convinces
> > 	me otherwise.
> > 
> > o	"Power-aware application" are applications that are permitted
> > 	to acquire suspend blockers on Android.  Verion 8 of the
> > 	suspend-blocker patch seems to use group permissions to determine
> > 	which applications are classified as power aware.
> > 
> > 	More generally, power-aware applications seem to be those that
> > 	have permission to exert some control over the system's
> > 	power state.
> 
> Notice that these definitions allow a program to be both power-naive
> and power-aware.  In addition, "power-awareness" isn't an inherent
> property of the application itself, since users are allowed to decide
> which programs may exert control over the system's power state.  The 
> same application could be power-aware on one system and non-power-aware 
> on another.

Agreed.

> > o	Oddly enough, "power-optimized applications" were not discussed.
> > 	See "POWER-OPTIMIZED APPLICATIONS" below for a brief introduction.
> > 	The short version is that power-optimized applications are those
> > 	power-aware applications that have been aggressively tuned to
> > 	reduce power consumption.
> 
> This would be essentially the same as power-aware && !power_naive, 
> right?

It certainly seems to me that most power-optimized applications would
need to be classified as power-aware to work properly.  But there could
easily be power-aware applications that aren't heavily power-optimized,
for example, such an application might make use of the CPU for operations
that could be handled by a power-efficient hardware accelerator.
Perhaps power-aware is to power-optimized as SMP-safe is to perfectly
optimized for SMP scalability and performance.

Though it seems that heavy power-efficiency optimizations might come
at the expense of portability in some cases.

> > REQUIREMENTS
> > 
> > o	Reduce the system's power consumption in order to (1) extend
> > 	battery life and (2) preserve state until AC power can be obtained.
> 
> External power, not necessarily AC power (a very minor point).

A good one, though.

> > o	It is necessary to be able to use power-naive applications.
> > 	Many of these applications were designed for use in PC platforms
> > 	where power consumption has historically not been of great
> > 	concern, due to either (1) the availability of AC power or (2)
> > 	relatively undemanding laptop battery-lifetime expectations.  The
> > 	system must be capable of running these power-naive applications
> > 	without requiring that these applications be modified, and must
> > 	be capable of reasonable power efficiency even when power-naive
> > 	applications are available.
> > 
> > o	If the display is powered off, there is no need to run any
> > 	application whose only effect is to update the display.
> 
> On Android this goes somewhat farther.  IIUC, they want hardly anything 
> to run while the display is powered off.  (But my understanding could 
> be wrong.)

I agree that this requirement is but one piece of the Android puzzle.

> For computers in general, of course, this statement is correct.  The
> same is true for any output-only device.  For example, if the audio
> speakers are powered off, there is no need to run any application whose
> only effect is to play sounds through the speakers.

Good point -- I didn't find any example of this in the email threads,
but it does seem plausible.

> > 	Although one could simply block such an application when it next
> > 	tries to access the display, it appears that it is highly
> > 	desirable that the application also be prevented from
> > 	consuming power computing anything that will not be displayed.
> > 	Furthermore, whatever mechanism is used must operate on
> > 	power-naive applications that do not use blocking system calls.
> > 
> > o	In order to avoid overrunning hardware and/or kernel buffers,
> > 	input events must be delivered to the corresponding application
> > 	in a timely fashion.  The application might or might not be
> > 	required to actually process the events in a timely fashion,
> > 	depending on the specific application.
> 
> This goes well beyond overrunning buffers!  Events must be delivered in
> a timely fashion so that the system isn't perceived to be inoperative.

Agreed for power-aware applications.  For power-naive applications,
the last event delivered can be buffered by the application with no
response if I understand correctly.  If there is a subsequent event
for that same application, then the prior event can be processed.

> > 	In particular, if user input that would prevent the system
> > 	from entering a low-power state is received while the system is
> > 	transitioning into a low-power state, the system must transition
> > 	back out of the low-power state so that it can hand the user
> > 	input off to the corresponding application.
> > 
> > o	If a power-aware application receives user input, then that
> > 	application must be given the opportunity to process that
> > 	input.
> 
> A better way to put this is: The API must provide a means for
> power-aware applications receiving user input to keep themselves
> running until they have been able to process the input.

Good point!  Would it also make sense to say "events" in general rather
than "input" in particular?

> This is probably also true for power-aware applications having other
> needs (e.g., non-input-driven computation).  In general, power-aware
> applications must have a mechanism to prevent themselves from being
> stopped for power-related reasons.

I thought I covered this in the next requirement.  Did I miss some aspect?

> > o	A power-aware application must be able to efficiently communicate
> > 	its needs to the system, so that such communication can be
> > 	performed on hot code paths.  Communication via open() and
> > 	close() is considered too slow, but communication via ioctl()
> > 	is acceptable.
> > 
> > o	Power-naive applications must be prohibited from controlling
> > 	the system power state.  One acceptable approach is through
> > 	use of group permissions on a special power-control device.
> 
> You mean non-power-aware applications, not power-naive applications.  
> But then the statement is redundant; it follows directly from the
> definition of "power-aware".

I see your point, but I don't feel comfortable deleting this requirement.
My rationale is that the definition needs some enforcement mechanism,
and this requirement is calling out the need for such a mechanism.

> > o	Statistics of the power-control actions taken by power-aware
> > 	applications must be provided, and must be keyed off of program
> > 	name.
> > 
> > o	Power-aware applications can make use of power-naive infrastructure.
> > 	This means that a power-aware application must have some way,
> > 	whether explicit or implicit, to ensure that any power-naive
> > 	infrastructure is permitted to run when a power-aware application
> > 	needs it to run.
> > 
> > o	When a power-aware application is preventing the system from
> > 	shutting down, and is also waiting on a power-naive application,
> > 	the power-aware application must set a timeout to handle
> > 	the possibility that the power-naive application might halt
> > 	or otherwise fail.  (Such timeouts are also used to limit the
> > 	number of kernel modifications required.)
> 
> No, this is not a requirement.  A power-optimized application would do 
> this, of course, by definition.  But a power-aware application doesn't 
> have to.

I am not sure we agree on the definition of "power-optimized application".
But leaving that aside, I thought that Arve and Brian explicitly
stated this as a requirement on power-aware applications -- one of the
responsibilities that came with the power to block suspend.

> > o	If no power-aware or power-optimized application are indicating
> > 	a need for the system to remain operating, the system is permitted
> > 	(even encouraged!) to suspend all execution, even if power-naive
> > 	applications are runnable.  (This requirement did appear to be
> > 	somewhat controversial.)
> 
> The controversy was not over the basic point but rather over the 
> detailed meaning of "runnable".  A technical matter, related to the 
> implementation of the scheduler.

OK, what would you suggest for the wording of this requirement?

> > o	Transition to low-power state must be efficient.  In particular,
> > 	methods based on repeated attempts to suspend are considered to
> > 	be too inefficient to be useful.
> > 
> > o	Individual peripherals and CPUs must still use standard
> > 	power-conservation measures, for example, transitioning CPUs into
> > 	low-power states on idle and powering down peripheral devices
> > 	and hardware accelerators that have not been recently used.
> > 
> > o	The API that controls the system power state must be
> > 	accessible both from Android's Java replacement, from
> > 	userland C code, and from kernel C code (both process
> > 	level and irq code, but not NMI handlers).
> > 
> > o	Any initialization of the API that controls the system power
> > 	state must be unconditional, so as to be free from failure.
> > 	(I don't currently understand how this relates, probably due to
> > 	my current insufficient understanding of the proposed patch set.)
> 
> I suspect this is not a critical requirement, more like a NICE-TO-HAVE.

You could well be correct, though the Android guys stated it pretty
strongly.  Seems like the usual memory and mass-storage shortages would
be hard to handle with an unconditional API, though the usual solution
seems to be to make sure that there is enough for normal operation.

> > o	The API that controls the system power state must operate
> > 	correctly on SMP systems of modest size.  (My guess is that
> > 	"modest" means up to four CPUs, maybe up to eight CPUs.)
> 
> For present-day phones this obviously doesn't matter, but if the API is
> going to be used on more general systems then it does.

Indeed, at least if the API is not to be stubbed out for all
large systems.  Though it might be possible to make a more-scalable
implementation of this API, especially if larger systems were more
forgiving of time delays in noting any transitions.

> > o	Any QoS-based solution must take display and user-input
> > 	state into account.  In other words, the QoS must be
> > 	expressed as a function of the display and the user-input
> > 	states.
> > 
> > o	Transitioning to extremely low power states requires saving
> > 	and restoring DRAM and/or cache SRAM state, which in itself
> > 	consumes significant energy.  The power savings must therefore
> > 	be balanced against the energy consumed in the state
> > 	transitions.
> > 
> > o	The current Android userspace API must be supported in order
> > 	to support existing device software.

Thank you again for looking this over!

							Thanx, Paul
