Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965200Ab0HFWzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 18:55:00 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50074 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934096Ab0HFWy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 18:54:58 -0400
Date: Fri, 6 Aug 2010 15:54:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz, florian@mickler.org,
        rjw@sisk.pl, stern@rowland.harvard.edu, swetland@google.com,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk,
        david@lang.hm, menage@google.com, david-b@pacbell.net,
        James.Bottomley@suse.de, tytso@mit.edu, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Subject: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100806225453.GA3947@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100731175841.GA9367@linux.vnet.ibm.com>
 <20100804195704.GA23681@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100804195704.GA23681@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Final report from this particular angel-free zone for the time being...

This is the third and final version of my Android requirements list
(last version available at http://lkml.org/lkml/2010/8/4/409).  Again,
this email is an attempt to present the Android guys' requirements, based
on my interpretation of LKML discussions.  This past week's discussion
was quite productive, and I thank everyone who took part.

Please note that I am not proposing a solution that meets these
requirements, nor am I attempting to judge the various proposed solutions.
In fact, I am not even trying to judge whether the requirements are
optimal, or even whether or not they make sense at all.  My only goal at
the moment is to improve our collective understanding of what the Android
folks' requirements are.  That said, I do discuss example mechanisms
where needed to clarify the meaning of the requirements.  This should
not be interpreted as a preference for any given example mechanism.

							Thanx, Paul

------------------------------------------------------------------------

CONTENTS

o	DEFINITIONS
o	CATEGORIES OF APPLICATION BEHAVIOR
o	REQUIREMENTS
o	NICE-TO-HAVES
o	APPARENT NON-REQUIREMENTS
o	SUGGESTED USAGE
o	POWER-OPTIMIZED APPLICATIONS
o	OTHER EXAMPLE APPLICATIONS
o	ACKNOWLEDGMENTS


DEFINITIONS

These have been updated based on LKML and linux-pm discussions.  The names
are probably still sub-optimal, but incremental progress is nevertheless
a very good thing.

o	"Ill-behaved application" AKA "untrusted application" AKA
	"crappy application".  The Android guys seem to be thinking in
	terms of applications that are well-designed and well-implemented
	in general, but which do not take power consumption or battery
	life into account.  Examples include applications designed for
	externally powered PCs.  Many other people seemed to instead be
	thinking in terms of an ill-conceived or useless application,
	perhaps exemplified by "bouncing cows".

	This document uses "power-oblivious applications" to mean
	applications that are well-designed and well-implemented in in
	general, but which do not take power consumption or battery life
	into account.

o	"PM-driving application" are applications that are permitted
	to acquire suspend blockers on Android.  Verion 8 of the
	suspend-blocker patch seems to use group permissions to determine
	which processes are classified as power aware.	Android uses a
	user-level daemon to classify app-store apps as PM-driving or not.
	More generally, PM-driving applications are those that have
	permission to exert some control over the system's sleep state.

	Note that an application might be power-oblivious on one
	Android device and PM-driving on another, depending on whether
	the user allows that application to acquire suspend blockers.
	The classification might even change over time.  For example,
	a user might give an application PM-driving status initially,
	but change his or her mind after some experience with that
	application.

o	Oddly enough, "power-optimized applications" were not discussed.
	See "POWER-OPTIMIZED APPLICATIONS" below for a brief introduction.
	The short version is that power-optimized applications are those
	PM-driving applications that have been aggressively tuned to
	reduce power consumption.

o	Individual devices in an embedded system can enter "device
	low-power states" when not in use.

o	The system as a whole can enter a "system sleep state" when
	the system as a whole is not in use.  Suspend blockers are about
	system sleep states rather than device low-power states.

o	There was much discussion of "idle" (AKA "deep idle") and
	"suspend" (as in current Linux-kernel suspend operations).
	The following characteristics distinguish "idle" from "suspend":

	1.	Idle states are entered by a given CPU only there are no
		runnable tasks for that CPU.  In contrast, opportunistic
		suspend can halt the entire system even when there
		are tasks that are ready, willing, and able to run.
		(But please note that this might not apply to real-time
		tasks.)

		Freezing of subsets of applications is somewhat related
		to the idle/suspend discussion, but is covered in a
		later section of this document.

	2.	There can be a set of input events that do not bring
		the system out of suspend, but which would bring the
		system out of idle.  Exactly which events are in this
		set depends both on hardware capabilities and on the
		platform/application policy.  For example, on one of
		the Android-based smartphones, touchscreen input is
		ignored when the system is suspended, but is handled
		when idle.

	3.	The system comes out of idle when a timer expires.  In
		contrast, timers might or might not bring the system
		out of suspend, depending on both hardware capabilities
		and platform/application policy.


CATEGORIES OF APPLICATION BEHAVIOR

There are a number of categories of application behavior with respect
to power management and energy efficiency.  These can be classified via
the following questions:  (1) What degree of control is an application
permitted over its own behavior?  (2) What degree of control is an
application permitted over the power state of individual devices within
the system?  (3) What degree of control is an application permitted
over the system sleep state?  (4) To what degree has the application
been tuned to reduce its power consumption, either in isolation or in
conjunction with other applications that might be running concurrently?

These categories are discussed below.

o	What degree of control is an application permitted over its
	own behavior?

	The Linux kernel already has many controls over application
	behavior:

	o	the CAP_ capabilities from include/linux/capability.h.

	o	Processes can be assigned to multiple groups, allowing
		them privileged access to portions of the filesystem.

	o	The chroot() system call limits a process's access to the
		specified subtree of the filesystem.  

	o	The ulimit facility can limit CPU consumption, number
		of processes, memory, etc. on a per-user basis.  The
		rlimit facility has similar effects on a per-process
		basis.

	o	The mlockall() system call provides privileged access
		to memory, avoiding page-fault overhead.

	But more relevant to this discussion, real-time processes are
	permitted a much higher degree of control over the timing of their
	execution than are non-real-time processes.  However, suspending
	the system destroys any pretense of offering real-time guarantees,
	which might explain much of the annoyance towards suspend blockers
	from the real-time and scheduler folks.  For but one example,
	Peter Zijlstra suggested that he would merge a patch that acquired
	a suspend blocker any time that the runqueues were non-empty.
	My first reaction was amusement at this vintage Peter Zijlstra
	response, and my second reaction was that it was a futile gesture,
	as the Android guys would simply back out any such change.

	After more thought, however, a variation of Peter's approach
	might well be the key to resolving this tension between
	real-time response on the one hand and Android's desire to
	conserve power at any cost on the other.  Given that suspending
	destroys real-time response, why not acquire a suspend blocker
	any time there is a user-created real-time task in the system,
	whether runnable or not?  Of course, a simpler approach would
	be to make Android's OPPORTUNISTIC_SUSPEND depend on !PREEMPT_RT.

o	What degree of control is an application permitted over the power
	state of individual devices within the system?

	Is the application in question permitted to power down the
	CPU or peripheral devices?  As more of the power control is
	automated based on usage, it is possible that this question will
	become less relevant.  The longer the latency and the greater
	the energy consumption of a power-up/power-down sequence for
	a given device, the less suitable that device is for automatic
	power-up/power-down decisions.  Cache SRAMs and main-memory
	DRAM tend to be less suitable for automation for this reason.

o	What degree of control is an application permitted over the
	system sleep state?

	Is the application permitted to suspend the device?  Or in the
	case of Android, is the application permitted to acquire a
	suspend blocker, which prevents the device from being suspended?

o	To what degree has the application been tuned to reduce its
	power consumption, either in isolation or in conjunction with
	other applications that might be running concurrently?

	See the "POWER-OPTIMIZED APPLICATIONS" section below for more
	detail on the lengths that embedded developers go to in order
	to conserve power -- or, more accurately, to extend battery life.


REQUIREMENTS

o	Reduce the system's power consumption in order to (1) extend
	battery life and (2) preserve state until external power can
	be obtained.

o	It is necessary to be able to use power-oblivious applications.
	Many of these applications were designed for use in PC platforms
	where power consumption has historically not been of great
	concern, due to either (1) the availability of external power or
	(2) relatively undemanding laptop battery-lifetime expectations.
	The system must be capable of running these power-oblivious
	applications without requiring that these applications be
	modified, and must be capable of reasonable power efficiency
	even when power-oblivious applications are in use.

	In other words, it must be possible to automate the incorporation
	of a power-oblivious application into the Android environment,
	but without significantly degrading battery lifetime.

o	If the display is powered off, there is no need to run any
	application whose only effect is to update the display.

	Although one could simply block such an application when it next
	tries to access the display, it it is highly desirable that the
	application also be prevented from consuming power computing
	something that will not be displayed.  Furthermore, whatever
	mechanism is used must operate on power-oblivious applications
	that do not use blocking system calls.

	There might well be similar requirements for other output-only
	devices, as noted by Alan Stern.

o	In order to avoid overrunning hardware and/or kernel buffers,
	and to minimize response latencies, designated input events
	must be delivered to the corresponding application in a timely
	fashion.  The application might or might not be required to
	actually process the events in a timely fashion, depending on
	the specific application.

	In particular, if user input that would prevent the system
	from entering a sleep state is received while the system is
	transitioning into a sleep state, the system must transition
	back out of the sleep state so that it can hand the user
	input off to the corresponding application.

	Other input events do not force a wakeup, and such input events
	-can- be lost due to buffer overflow in hardware or the kernel.
	The response latency to such input events can of course be
	unbounded.

o	Because Android acquires a suspend blocker as soon as an
	input event is noticed and holds it until some application
	reads that input event, there must be a way to cause the
	suspend blocker to timeout.  If there was no such timeout
	facility, a power-oblivious application could block suspend by
	opening an input device and then refusing to ever read from it.
	(Yes, this can be considered to be a energy-efficiency bug in
	the power-oblivious application.  Please see the statistics
	requirement below.)

o	The API must provide a way for PM-driving applications that
	receive events to keep themselves running until they have been
	able to process those events.

o	Statistics of the power-control actions taken by PM-driving
	applications must be provided.	Statistics are aggregated by name,
	which is passed by the application in through the suspend-blocker
	interface.  The following specific statistics are collected in
	the kernel, in roughly decreasing order of importance:

	o	total_time, which accumulates the total amount of time
		that the corresponding suspend blocker has been held.

	o	active_since, which tracks how long a suspend blocker has
		been held since it was last acquired, or (presumably) zero
		if it is not currently held.

	o	count, which is the number of times that the suspend
		blocker has been acquired.  This is useful in combination
		with total_time, as it allows you to calculate the
		average hold time for the suspend blocker.

	o	expire_count, which is the number of times that the
		suspend blocker has timed out.  This indicates that
		some application has an input device open, but is
		not reading from it, which is a bug, as noted earlier.

	o	max_time, which is the longest hold time for the suspend
		blocker.  This allows finding cases where suspend blockers
		are held for too long, but are eventually released.
		(In contrast, active_since is more useful in the
		held-forever case.)

	o	sleep_time, which is the total time that the suspend
		blocker was held while the display was powered off.
		(This might have interesting implications should E-ink
		displays every become capable of full-motion color video,
		but it is easy to imagine that the definition of "powered
		off" would then include only those times during which
		the display wasn't actively being updated.)

	o	wake_count, which is the number of times that the
		suspend blocker was the first to be acquired in the
		resume path.  This is less than useful on some
		Android platforms; Arve is dissatisfied with it
		on Nexus One.

	Presumably, the userspace code collects similar statistics on
	application suspend-blocker activity, but that is out of the scope
	of this document, which focuses instead on kernel requirements.
	Given that the overhead of maintaining these statistics is
	quite low, it seems that it would be worthwhile to have them
	enabled in production systems, for example, in order to flag
	power-buggy applications that the user has naively downloaded.

o	Some PM-driving applications use power-oblivious infrastructure
	code.  This means that a PM-driving application must have
	some way, whether explicit or implicit, to ensure that any
	power-oblivious infrastructure code is permitted to run when a
	PM-driving application needs it to run.

o	If no PM-driving or power-optimized application are indicating
	a need for the system to remain operating, the system is permitted
	(even encouraged!) to suspend all execution, regardless of the
	state of power-oblivious applications.	(This requirement did
	appear to be somewhat controversial, both in terms of what is
	meant by "runnable" and in terms of what constitutes "execution".)

	In Android, this is implemented by suspending even while
	PM-driving or power-optimized applications are active, -unless-
	a suspend blocker is held.

o	Transition to system sleep state must be power-efficient.
	In particular, methods based on repeated attempts to suspend
	are considered to be too inefficient to be useful.

o	Transition to system sleep state must occur very soon after
	all PM-driving and power-optimized applications have indicated
	that they have no need for the system to remain operating.
	Quick transition is expecially important in cases where the wakeup
	was momentary, for example, when processing sporadic network
	input or processing widely spaced batches of audio output.
	For an example of the latter, MP3 playback allows 1-4 minute
	spacing between bursts of CPU activity).

o	Individual peripherals and CPUs must still use standard
	power-conservation measures, for example, transitioning CPUs into
	low-power states on idle and powering down peripheral devices
	and hardware accelerators that have not been recently used.

o	The API that controls the system sleep state must be accessible
	both from Android's Java replacement, from userland C code,
	and from kernel C code (both process level and irq code, but
	not NMI handlers).

o	The API that controls the system sleep state must operate
	correctly on SMP systems of modest size.  (My guess is that
	"modest" means up to four CPUs, maybe up to eight CPUs.)

o	Any QoS-based solution must take display and user-input
	state into account.  In other words, the QoS must be expressed
	as a function of the display and the user-input states.

o	Transitioning to extremely low-power sleep states requires saving
	and restoring DRAM and/or cache SRAM state, which in itself
	consumes significant energy.  The power savings must therefore
	be balanced against the energy consumed in the state transitions.

o	The current Android userspace API must be supported in order
	to support existing device software.  According to Brian
	Swetland:

		For Java/Dalvik apps, the wakelock API is pertty
		high level -- it talks to a service via RPC (Binder)
		that actually interacts with the kernel.  Changing the
		basic kernel<->userspace interface (within reason) is
		not unthinkable.  For example, Arve's suspend_blocker
		patch provides a device interface rather than the proc
		interface the older wakelock patches use.  We'd have to
		make some userspace changes to support that but they're
		pretty low level and minor.

		In the current model, only a few processes need to
		specifically interact with the kernel (the power
		management service in the system_server, possibly the
		media_server and the radio interface glue).  A model where
		every process needs to have a bunch of instrumentation is
		not very desirable from our point of view.  We definitely
		do need reasonable statistics in order to enable debugging
		and to enable reporting to endusers (through the Battery
		Usage UI) what's keeping the device awake.

o	Any mechanism that freezes some subset of the applications must
	ensure that none of the frozen applications hold any user-level
	resources, such as pthread mutexes.  The reason for this is that
	freezing an application that holds a shared pthread mutex will
	result in an application-level hang should some unfrozen process
	attempt to acquire that same pthread mutex.  Note that although
	the current cgroup freezer ensures that frozen applications do not
	hold any kernel-level mutexes (at least assuming these mutexes
	are not wrongly held when returning to user-level execution),
	it currently does nothing to prevent freezing processes holding
	pthread mutexes.  (There are some proposals to address this issue.)


NICE-TO-HAVES

o	It would be nice to be able to identify power-oblivious
	applications that never were depended on by PM-driving
	applications.  This particular class of power-oblivious
	applications could be shut down when the screen blanks even
	if some PM-driving application was preventing the system from
	powering down.

	There are two obstacles to meeting this requirement:

	1.	There must be a reliable way to identify such
		applications.  This should be doable, for example, the
		application might be tagged by its developer.

	2.	There must be a reliable way to freeze them such
		that no frozen application holds a resource that
		might be contended by a non-frozen application.

		Although the cgroup freezer does ensure that frozen
		tasks hold no kernel-level resources, it currently does
		nothing to ensure that no user-level resources are held.
		There are some alternative proposals, which might or
		might not be more successful:

		a.	Unfreeze this group periodically to ensure
			that any such resource is eventually released,
			while keeping power consumption down to a dull
			roar.

		b.	Perform the freeze at application level, where
			it is possible to determine whether an
			application-level resource is held.

o	Any initialization of the API that controls the system power
	state should be unconditional, so as to be free from failure.
	Such unconditional initialization reduces the intrusiveness of
	the Android patchset.


APPARENT NON-REQUIREMENTS

o	Transitioning to system sleep states need not be highly scalable,
	as evidenced by the global locks.  (If you believe that high
	scalability will in fact be required, please provide a use case.
	But please understand that I do know something about scalability
	trends, but also about uses for transistors beyond more cores.)

	That said, it should not be hard to provide a highly scalable
	implementation of suspend blockers, especially if large systems
	are allowed to take their time suspending themselves.

o	Conserving power in the WiFi and cellular telephony networks.
	At the moment, the focus is on increased battery life in the
	handheld device, perhaps even at the expense of additional
	power consumed by the externally powered WiFi and cell-telephony
	equipment.

o	Synchronizing wakeups of unrelated applications.  This is of
	course an important requirement for power savings overall, but
	seems to be left to other mechanisms (e.g., timer aggregation)
	by the Android folks.  Although one could implement suspend
	blockers so as to aggregate timers after a sufficiently long
	suspension, there are problems with this approach:

	o	There would be a "thundering herd" problem just after
		resume completed as almost every timer in the system
		would expire simultaneously.

	o	The applications would not necessarily stay aggregated
		without some other mechanism helping out.


SUGGESTED USAGE

These are constraints that the developer is expected to abide by,
"for best results" and all that.

o	When a PM-driving application is preventing the system from
	shutting down, and is also waiting on a power-oblivious
	application, the PM-driving application should set a timeout
	to handle the possibility that the power-oblivious application
	might halt or otherwise fail.


POWER-OPTIMIZED APPLICATIONS

A typical power-optimized application manually controls the power state
of many separately controlled hardware subsystems to minimize power
consumption.  Such optimization normally requires an understanding
of the hardware and of the full system's workload: strangely enough,
concurrently running two separately power-optimized applications often
does -not- result in a power-optimized system.  Such optimization also
requires knowledge of what the application will be doing in the future,
so that needed hardware subsystems can be proactively powered up just
when the application will need them.  This is especially important when
powering down cache SRAMS or banks of main memory, because such components
take significant time (and consume significant energy) when preparing them
to be powered off and when restoring their state after powering them on.

Consider an MP3 player as an example.  Such a player will periodically
read MP3-encoded data from flash memory, decode it (possibly using
hardware acceleration), and place the resulting audio data into main
memory.  Different systems have different ways of getting the data from
main memory to the audio output device, but let's assume that the audio
output device consumes data at a predictable rate such that the software
can use timers to schedule refilling of the device's output buffer.
The timer duration will of course need to allow for the time required to
power up the CPU and L2 cache.  The timer can be allowed to happen too
soon, albeit with a battery-lifetime penalty, but cannot be permitted
to happen too late, as this will cause "skips" in the playback.

If MP3 playback is the only application running in the system, things
are quite easy.  We calculate when the audio output device will empty
its buffer, allow a few milliseconds to power up the needed hardware,
and set a timer accordingly.  Because modern audio output devices have
buffers that can handle roughly a second's worth of output, it is well
worthwhile to spend the few milliseconds required to flush the cache
SRAMS in order to put the system into an extremely low-power sleep state
over the several hundred milliseconds of playback.

Now suppose that this device is also recording audio -- perhaps the device
is being used to monitor an area for noise pollution, and the user is also
using the device to play music via earphones.  The audio input process
will be the inverse of the audio output process: the microphone data
will fill a data buffer, which must be collected into DRAM, then encoded
(perhaps again via MP3) and stored into flash.  It would be easy to create
an optimal application for audio input, but running this optimal audio
input program concurrently with the optimal audio playback program would
not necessarily result in a power-optimized combination.  This lack of
optimality is due to the fact that the input and output programs would
each burn power separately powering down and up.  In contrast, an optimal
solution would align the input and output programs' timers so that a
single power-down/power-up event would cover both programs' processing.
This would trade off optimal processing of each (for example, by draining
the input buffer before it was full) in order to attain global optimality
(by sharing power-down/power-up overhead).

There are a number of ways to achieve this:

1.	Making the kernel group timers that occur at roughly the same
	time, as has been discussed on this list many times.  This can
	work in many cases, but can be problematic in the audio example,
	due to the presence of hard deadlines.

2.	Write the programs to be aware of each other, so that each
	adjusts its behavior when the other is present.  This seems
	to be current practice in the battery-powered embedded arena,
	but is quite complex, sensitive to both hardware configuration
	and software behavior, and requires that all combinations of
	programs be anticipated by the designer -- which can be a serious
	disadvantage given today's app stores.

3.	Use new features such as range timers, so that each program
	can indicate both its preference and the degree of flexibility
	that it can tolerate.  This also works in some cases, but as
	far as I know, current proposals do not allow the kernel to take
	power-consumption penalties into account.

4.	Provide "heartbeat" services that allow applications to
	synchronize with each other.  This seems most applicable for
	applications that run infrequently, such as email-checking and
	location-service applications.

5.	Use of hardware facilities that allow DMA to be scheduled across
	time.  This would allow the CPU to be turned on only for
	decode/encode operations.  I am under the impression that this
	sort of time-based DMA hardware does exist in the embedded space
	and that it is actually used for this purpose.

6.	Your favorite solution here.

Whatever solution is chosen, the key point to keep in mind is that
running power-optimized applications in combination does -not- result
in optimal system behavior.


OTHER EXAMPLE APPLICATIONS

GPS application that silently displays position.

	There is no point in this application consuming CPU cycles
	or in powering up the GPS hardware unless the display is
	active.  Such an application could be handled by the Android
	suspend-blocker proposal.  Of course, such an application could
	also periodically poll the display, shutting itself down if the
	display is inactive.  In this case, it would also need to have
	some way to be reactivated when the display comes back on.

GPS application that alerts the user when a given location is reached.

	This application should presumably run even when the display
	is powered down due to input timeout.  The question of whether
	or not it should continue running when the device is powered
	off is an interesting one that would be likely to spark much
	spirited discussion.  Regardless of the answer to this question,
	the GPS application would hopefully run very intermittently,
	adjusting the delay interval based on the device's velocity and
	distance from the location in question.

	I don't know enough about GPS hardware to say under what
	circumstances the GPS hardware itself should be powered off.
	However, my experience indicates that it takes significant
	time for the GPS hardware to get a position fix after being
	powered on, so presumably this decision would also be based
	on device velocity and distance from the location in question.

	Assuming that the application can run only intermittently,
	suspend blockers would work reasonably well for this use case.
	If the application needed to run continuously, battery life
	would be quite short regardless of the approach used.

MP3 playback.

	This requires a PM-driving (and preferably a power-optimized)
	application.  Because the CPU need only run intermittently,
	suspend blockers can handle this use case.  Presumably switching
	the device off would halt playback.

Bouncing cows.

	This can work with a power-oblivious application that is shut down
	whenever the display is powered off or the device is switched off,
	similar to the GPS application that silently displays position.


ACKNOWLEDGMENTS

	Of course, just because I acknowledge their contributions does
	not necessarily mean that I think they agree with my assessment
	of the requirements behind suspend blockers.  ;-)

	Nevertheless, I am grateful for any and all feedback, whatever
	the form of that feedback might be.  I am new to this area, and
	have much to learn.

	Alan Stern
	Anca Emanuel
	Arjan van de Ven
	Arve Hjønnevåg
	Brian Swetland
	David Brownell
	David Lang
	Florian Mickler
	James Bottomley
	Kevin Granade
	Mark Brown
	Matt Helsley
	Matthew Garrett
	Mikael Abrahamsson
	Olivier Galibert
	Paul Menage
	Pavel Machek
	Rafael J. Wysocki
	Richard Woodruff
	Ted Ts'o
