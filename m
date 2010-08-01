Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494Ab0HAPnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 11:43:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53154 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756294Ab0HAPnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 11:43:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread
Date: Sun, 1 Aug 2010 17:41:30 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, swetland@google.com, peterz@infradead.org,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
References: <Pine.LNX.4.44L0.1007311544470.5418-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1007311544470.5418-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008011741.31086.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 31, 2010, Alan Stern wrote:
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
> 
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

I'd slightly prefer these to be called "power-oblvious applications", to
reflect the fact that their authors might not take power management into
consideration in any form.

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

Also, there is another type of "power-awareness", related to the ability to
react to power management events signaled, for example, by pm-utils using
dbus protocol (NetworkManager is one such application).  However, the
applications having that ability don't really participate in making a decision
to change the state of the system, while the applications using wakelocks do.

In the wakelocks (or suspend blockers, whatever you prefer to call them) world
no single entity is powerful enough to make the system go into a sleep state,
but some applications and device drivers collectively can make that happen.
The applications using wakelocks not only are aware of system power
management, but also are components of a "collective power manager", so
perhaps it's better to call them "PM-driving applications" or something like
this.

> > o	Oddly enough, "power-optimized applications" were not discussed.
> > 	See "POWER-OPTIMIZED APPLICATIONS" below for a brief introduction.
> > 	The short version is that power-optimized applications are those
> > 	power-aware applications that have been aggressively tuned to
> > 	reduce power consumption.
> 
> This would be essentially the same as power-aware && !power_naive, 
> right?

Not really, IMO.  !power_naive means "doesn't use wakelocks" in this context,
while "power-optimized" would mean something like "not only uses wakelocks,
but also tries to reduce energy consumption by as much as possible".

> > REQUIREMENTS
> > 
> > o	Reduce the system's power consumption in order to (1) extend
> > 	battery life and (2) preserve state until AC power can be obtained.
> 
> External power, not necessarily AC power (a very minor point).
> 
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

Not really.  Quite a lot of things happen on these systems while the display
is off (let alone the periodic battery monitoring on Nexus One :-)).  They
can send things over the network and do similar stuff in that state.

I think the opposite is true, ie. the display is aggressively turned off
whenever it appears not to be used, because it draws a lot of power.

> For computers in general, of course, this statement is correct.  The
> same is true for any output-only device.  For example, if the audio
> speakers are powered off, there is no need to run any application whose
> only effect is to play sounds through the speakers.

Agreed.

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

That's correct, although it doesn't seem to apply to any kind of input
events.  For example, on Nexus One the touchscreen doesn't generate wakeup
events (ie. events that wake the system up from a sleep states), so I'm not
sure to what extent they are supposed to block (automatic) suspends.

> > 	In particular, if user input that would prevent the system
> > 	from entering a low-power state is received while the system is
> > 	transitioning into a low-power state, the system must transition
> > 	back out of the low-power state so that it can hand the user
> > 	input off to the corresponding application.

Side note.  I'd like to avoid confusing device states with system-as-a-whole
states, so I always prefer to refer to the system-as-a-whole-low-power states
as "system sleep states", while term "low-power state" is reserved for
individual devices.

Also in some cases (ACPI mostly) a "system sleep state" is more than a
"system low-power state", because you can put the system into a low-power
state by putting a number of devices into low-power states, which is not
sufficient to put the system into a sleep state (the platform has to be
programmed in a special way to carry out that operation).  Now, wakelocks
are about "system sleep states", not about "system low-power states" in
general.

> > o	If a power-aware application receives user input, then that
> > 	application must be given the opportunity to process that
> > 	input.
> 
> A better way to put this is: The API must provide a means for
> power-aware applications receiving user input to keep themselves
> running until they have been able to process the input.
> 
> This is probably also true for power-aware applications having other
> needs (e.g., non-input-driven computation).  In general, power-aware
> applications must have a mechanism to prevent themselves from being
> stopped for power-related reasons.

Agreed.

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

Agreed.

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

Agreed.

> > o	If no power-aware or power-optimized application are indicating
> > 	a need for the system to remain operating, the system is permitted
> > 	(even encouraged!) to suspend all execution, even if power-naive
> > 	applications are runnable.  (This requirement did appear to be
> > 	somewhat controversial.)
> 
> The controversy was not over the basic point but rather over the 
> detailed meaning of "runnable".  A technical matter, related to the 
> implementation of the scheduler.

Well, I _think_ it was about the basic point too, since "all execution" means
periodic timers in particular and involves shutting down clock sources (except
for the RTC).

Arguably, suspending "all execution" is not necessary to achieve a satisfactory
level of energy saving, at least on a number of systems.

Thanks,
Rafael
