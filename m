Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab0GaR6y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 13:58:54 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56939 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373Ab0GaR6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 13:58:52 -0400
Date: Sat, 31 Jul 2010 10:58:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz, florian@mickler.org,
        rjw@sisk.pl, stern@rowland.harvard.edu, swetland@google.com,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100731175841.GA9367@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rushing in where angels fear to tread...

I had been quite happily ignoring the suspend-blockers controversy.
However, now that I have signed up for the Linaro project that involves
embedded battery-powered devices, I find that ignorance is no longer
bliss.  I have therefore reviewed much of the suspend-blocker/wakelock
material, but have not yet seen a clear exposition of the requirements
that suspend blockers are supposed to meet.  This email is a attempt
to present the requirements, based on my interpretation of the LKML
discussions.

Please note that I am not proposing a solution that meets these
requirements, nor am I attempting to judge the various proposed solutions.
In fact, I am not even trying to judge whether the requirements are
optimal, or even whether or not they make sense at all.  My only goal
at the moment is to improve my understanding of what the Android folks'
requirements are.  That said, I do include example mechanisms as needed to
clarify the meaning of the requirements.  This should not be interpreted
as a preference for any given example mechanism.

But first I am going to look at nomenclature, as it appears to me that
at least some of the flamage was due to conflicting definitions.  Following
that, the requirements, nice-to-haves, apparent non-requirements,
an example power-optimized applications, and finally a brief look
at other applications.

Donning the asbestos suit, the one with the tungsten pinstripes...

							Thanx, Paul

------------------------------------------------------------------------

DEFINITIONS

o	"Ill-behaved application" AKA "untrusted application" AKA
	"crappy application".  The Android guys seem to be thinking in
	terms of applications that are well-designed and well-implemented
	in general, but which do not take power consumption or battery
	life into account.  Examples include applications designed for
	AC-powered PCs.  Many other people seemed to instead be thinking
	in terms of an ill-conceived or useless application, perhaps
	exemplified by "bouncing cows".

	Assuming I have correctly guessed what the Android guys were
	thinking of, perhaps "power-naive applications" would be a
	better description, which I will use until someone convinces
	me otherwise.

o	"Power-aware application" are applications that are permitted
	to acquire suspend blockers on Android.  Verion 8 of the
	suspend-blocker patch seems to use group permissions to determine
	which applications are classified as power aware.

	More generally, power-aware applications seem to be those that
	have permission to exert some control over the system's
	power state.

o	Oddly enough, "power-optimized applications" were not discussed.
	See "POWER-OPTIMIZED APPLICATIONS" below for a brief introduction.
	The short version is that power-optimized applications are those
	power-aware applications that have been aggressively tuned to
	reduce power consumption.


REQUIREMENTS

o	Reduce the system's power consumption in order to (1) extend
	battery life and (2) preserve state until AC power can be obtained.

o	It is necessary to be able to use power-naive applications.
	Many of these applications were designed for use in PC platforms
	where power consumption has historically not been of great
	concern, due to either (1) the availability of AC power or (2)
	relatively undemanding laptop battery-lifetime expectations.  The
	system must be capable of running these power-naive applications
	without requiring that these applications be modified, and must
	be capable of reasonable power efficiency even when power-naive
	applications are available.

o	If the display is powered off, there is no need to run any
	application whose only effect is to update the display.

	Although one could simply block such an application when it next
	tries to access the display, it appears that it is highly
	desirable that the application also be prevented from
	consuming power computing anything that will not be displayed.
	Furthermore, whatever mechanism is used must operate on
	power-naive applications that do not use blocking system calls.

o	In order to avoid overrunning hardware and/or kernel buffers,
	input events must be delivered to the corresponding application
	in a timely fashion.  The application might or might not be
	required to actually process the events in a timely fashion,
	depending on the specific application.

	In particular, if user input that would prevent the system
	from entering a low-power state is received while the system is
	transitioning into a low-power state, the system must transition
	back out of the low-power state so that it can hand the user
	input off to the corresponding application.

o	If a power-aware application receives user input, then that
	application must be given the opportunity to process that
	input.

o	A power-aware application must be able to efficiently communicate
	its needs to the system, so that such communication can be
	performed on hot code paths.  Communication via open() and
	close() is considered too slow, but communication via ioctl()
	is acceptable.

o	Power-naive applications must be prohibited from controlling
	the system power state.  One acceptable approach is through
	use of group permissions on a special power-control device.

o	Statistics of the power-control actions taken by power-aware
	applications must be provided, and must be keyed off of program
	name.

o	Power-aware applications can make use of power-naive infrastructure.
	This means that a power-aware application must have some way,
	whether explicit or implicit, to ensure that any power-naive
	infrastructure is permitted to run when a power-aware application
	needs it to run.

o	When a power-aware application is preventing the system from
	shutting down, and is also waiting on a power-naive application,
	the power-aware application must set a timeout to handle
	the possibility that the power-naive application might halt
	or otherwise fail.  (Such timeouts are also used to limit the
	number of kernel modifications required.)

o	If no power-aware or power-optimized application are indicating
	a need for the system to remain operating, the system is permitted
	(even encouraged!) to suspend all execution, even if power-naive
	applications are runnable.  (This requirement did appear to be
	somewhat controversial.)

o	Transition to low-power state must be efficient.  In particular,
	methods based on repeated attempts to suspend are considered to
	be too inefficient to be useful.

o	Individual peripherals and CPUs must still use standard
	power-conservation measures, for example, transitioning CPUs into
	low-power states on idle and powering down peripheral devices
	and hardware accelerators that have not been recently used.

o	The API that controls the system power state must be
	accessible both from Android's Java replacement, from
	userland C code, and from kernel C code (both process
	level and irq code, but not NMI handlers).

o	Any initialization of the API that controls the system power
	state must be unconditional, so as to be free from failure.
	(I don't currently understand how this relates, probably due to
	my current insufficient understanding of the proposed patch set.)

o	The API that controls the system power state must operate
	correctly on SMP systems of modest size.  (My guess is that
	"modest" means up to four CPUs, maybe up to eight CPUs.)

o	Any QoS-based solution must take display and user-input
	state into account.  In other words, the QoS must be
	expressed as a function of the display and the user-input
	states.

o	Transitioning to extremely low power states requires saving
	and restoring DRAM and/or cache SRAM state, which in itself
	consumes significant energy.  The power savings must therefore
	be balanced against the energy consumed in the state
	transitions.

o	The current Android userspace API must be supported in order
	to support existing device software.


NICE-TO-HAVES

o	It would be nice to be able to identify power-naive applications
	that never were depended on by power-aware applications.  This
	particular class of power-naive applications could be shut down
	when the screen blanks even if some power-aware application
	was preventing the system from powering down.  (I am guessing
	at this one based on the momentary excitement that cgroup
	freezing raised in the Android folks.  Of course, this approach
	requires a reliable way to identify such applications.)


APPARENT NON-REQUIREMENTS

o	Transitioning to low-power states need not be highly scalable,
	as evidenced by the global locks.  (If you believe that this
	will in fact be required, please provide a use case.  But please
	understand that I do know something about scalability trends,
	but also about uses for transistors beyond more cores.)


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
SRAMS in order to put the system into an extremely low power state over
the several hundred milliseconds of playback.

Now suppose that this device is also recording audio -- perhaps the
device is being used to monitor an area for noise pollution, and the
user is also using the device to play music via earphones.  The audio
input process will be the inverse of the audio output process: the
microphone data will fill a data buffer, which must be collected into
DRAM, then encoded (perhaps again via MP3) and stored into flash.
It would be easy to create an optimal application for audio input,
but running this optimal audio input program concurrently with the
optimal audio playback program would not necessarily result in
a power-optimized combination.  This lack of optimality is due to
the fact that the input and output programs would each burn power
separately powering down and up.  In contrast, an optimal solution
would align the input and output programs' timers so that a single
power-down/power-up event would cover both programs' processing.
This would trade off optimal processing of each (for example,
by draining the input buffer before it was full) in order to attain
global optimality (by sharing power-down/power-up overhead).

There are a number of ways to acheive this:

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

4.	Use of hardware facilities that allow DMA to be scheduled across
	time.  This would allow the CPU to be turned on only for
	decode/encode operations.  I am under the impression that this
	sort of time-based DMA hardware does exist in the embedded space
	and that it is actually used for this purpose.

5.	Your favorite solution here.

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

	This requires a power-aware (and preferably a power-optimized)
	application.  Because the CPU need only run intermittently,
	suspend blockers can handle this use case.  Presumably switching
	the device off would halt playback.

Bouncing cows.

	This can work with a power-naive application that is shut down
	whenever the display is powered off or the device is switched off,
	similar to the GPS application that silently displays position.
