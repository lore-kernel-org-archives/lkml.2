Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606Ab0HKAmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 20:42:47 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:36480 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720Ab0HKAmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 20:42:43 -0400
Date: Tue, 10 Aug 2010 17:42:23 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Ted Ts'o" <tytso@mit.edu>, Felipe Contreras <felipe.contreras@gmail.com>,
        david@lang.hm, Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, menage@google.com,
        david-b@pacbell.net, James.Bottomley@suse.de, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100811004223.GH2379@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100807061558.GA28087@thunk.org>
 <AANLkTi=sMVjya9CH6UoZwJCXJTDRgBhnPXmApU_RHVTi@mail.gmail.com>
 <20100808155719.GB3635@thunk.org>
 <AANLkTinM5e2HGOFavODPZNzZx4KshDSjsvKN4pLpGGgr@mail.gmail.com>
 <20100808213821.GD3635@thunk.org>
 <20100809112453.77210acc@lxorguk.ukuu.org.uk>
 <20100809181638.GI3026@linux.vnet.ibm.com>
 <20100809201822.441905f7@lxorguk.ukuu.org.uk>
 <20100810044541.GA2817@linux.vnet.ibm.com>
 <20100810093849.138e2318@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100810093849.138e2318@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 09:38:49AM +0100, Alan Cox wrote:
> > situation you call out can occur with manual suspend-to-RAM already:
> > the fact is that this is a design choice.  You could indeed make a
> 
> Losing data is a design choice ? The application set a timer, the OS
> shouldn't be ignoring it in that situation. It might want to delay it, it
> might want to warn the user its hogging things it shouldnt (powertop,
> battery usage monitors in Android etc)

Hmmm...  Let's put the two approaches side by side so that we can compare
them more easily:

	Opportunistic Suspend		Idle + Timer Jitter

	Set timer			Set timer
	Suspend				OS delays timer
	Resume				OS continues delaying timer
	Timer fires			Timer fires

These two cases look quite similar to me.

But as you say, the battery can run out.  So let's add that to the
comparison:

	Opportunistic Suspend		Idle + Timer Jitter

	Set timer			Set timer
	Suspend				OS delays timer
	Battery runs out		Battery runs out
	Data loss			Data loss

The two cases still look quite similar.  You might note, quite correctly,
that the time between suspend and resume might be quite a bit longer than
the typical time that the OS delays a timer.  But the power consumption
on some platforms is quite a bit lower in the suspend case than it is
in the delayed-timer case.

> > will by definition be the only user of that mechanism.  So the fact
> > that Android is most probably the only user of suspend blockers does
> > not prove anything about whether or not suspend blockers are sensible.
> 
> They don't appear to solve the constraints on power management that you
> have in other environments, nor do they happen to be conveniently
> backward compatible or available on other platforms - which makes code
> hard to port.

There does seem to be some debate (if you can call it that) over
whether suspend blockers (or something like them) apply to non-Android
environments, though I do understand that you believe that suspend blockers
are relevant only to Android.  And indeed, adding features to a particular
platform can degrade portability, but the same is true of any number of
pre-existing Linux-specific features.

> > But that doesn't guarantee that solutions developed for PCs and laptops
> > will be optimal (or even usable) on cellphones.  Sufficient difference
> 
> Your cellphone is to all intents a laptop from ten years ago, it even has
> a similar display resolution and internet availability. The underlying
> difference between the two is solely form factor - the laptop had a
> better keyboard.

There are similarities and differences.  You have called out some of
the similarities.  Differences include the more-aggressive hardware
power management on cellphones, the greater number and variety of
hardware accelerators on cellphones, battery capacity, and, as you say,
physical size.  People currently use cellphones differently than they
do laptops or desktops.  The usage might converge, but we will see.
There is as much reason to expect increasing specialization as there
is to expect increasing convergence.

> > I hope that no one is arguing that Android will remain unchanged, just
> > as I hope no one would argue that Linux will remain unchanged.  In fact,
> > I am quite confident that both Linux and Android will continue to change.
> > So exactly what point were you attempting to make here?
> 
> That anything which ties to a particular style of behaviour and set of
> current usage assumptions is broken. If you rewrite all the apps to
> Android 2.1 and design in a single tasking model then you'll have to
> unrewrite half of it again when Android grows up. Ditto suspend blockers
> - encode too much policy in your apps and you lose the ability to change
> the environment under them. See the mess Microsoft got into with Win16 on
> Win32. Compare with Linux 32bit on Linux 64bit.

Yes, sooner or later, changes in environment and usage will break our
assumptions.  This includes your assumptions, my assumptions, the Android
folks' assumptions, and everyone else's assumptions.  We nevertheless
build things anyway.

A better comparison for Win16->Win32 would be UNIX's move from 16-bit
PDP-11 to 32-bit VAX.  There was plenty of screaming over that one.

> > As to busting all apps, lthough there have been situations where busting
> > all the apps turned out to be the right thing to do, I agree that these
> > situations are extremely rare.  Such situations are usually associated
> > with the emergence of a new high-volume platform.
> 
> Like Microsoft Windows 16bit co-operative multi-tasking ? It's rarely
> right. It's merely that in certain cases the value in the market is large
> enough that it can be used as a big stick to beat people into doing lots
> of usually wasted work.

Interesting choice of example.  I do well remember the Sequent hardware
guys' frustration when the old printer driver would monopolize the desktop
while printing their large documents.  The fact was that Microsoft's
co-operative multi-tasking required all applications to be well behaved,
just as does your approach to power efficiency.

> > Hmmm...  Exactly which part do you consider flawed?  Let's take it
> > one sentence at a time.  The devices that I know of that lack suspend
> > blockers also lack opportunistic suspend.  Therefore, all applications on
> > such devices run as would an application that acquired a suspend blocker
> > when it started and did not release that suspend blocker until it exited.
> > Pretty straightforward.
> 
> What do you mean by "opportunistic suspend", lots of systems drop into
> lowest power states whenever they can. "Suspend is different" is a bit of
> Android religion that I am dubious has any basis in reality as seen from
> the application end of the universe.

Opportunistic suspend has been well defined in this discussion.  I do
understand that you don't like opportunistic suspend, but your distaste
for it does not undefine it.

> You may also wish to review the earlier parts of the discussion where it
> was explicitly stated by several developers that they were using
> "suspend" type modes as power states already and not using suspend
> blockers. So it's being done, today on ARM and your statement is directly
> contradicting the code. Modern ARM processors and x86 MID devices can
> suspend and resume extremely fast (fast enough that the fact Linux x86
> rewriting all the SMP alternatives on suspend/resume is a measurable
> problem). If this same property doesn't end up on big PC boxes in time
> then I'd be very surprised. At that point the openoffice with suspend
> blockers or oracle with suspend blockers question becomes rather relevant.

Here is the list of properties distinguishing idle from suspend:

1.	Idle states are entered by a given CPU only there are no runnable
	tasks for that CPU.  In contrast, opportunistic suspend can
	halt the entire system even when there are tasks that are ready,
	willing, and able to run.  (But please note that this might not
	apply to real-time tasks.)

2.	There can be a set of input events that do not bring the system
	out of suspend, but which would bring the system out of idle.
	Exactly which events are in this set depends both on hardware
	capabilities and on the platform/application policy.  For example,
	on one of the Android-based smartphones, touchscreen input is
	ignored when the system is suspended, but is handled when idle.

3.	The system comes out of idle when a timer expires.  In contrast,
	timers might or might not bring the system out of suspend,
	depending on both hardware capabilities and platform/application
	policy.

4.	Suspend generally forces devices to go into their low-power
	states immediately.  In contrast, idle generally leaves unused
	devices at full power, relying on timers to shut down these
	devices.  Idle thus has shorter average wakeup latencies, but
	worse energy efficiency.

5.	Suspend usually has longer wakeup latency than does idle.

This list was compiled from this thread.

It is the above semantics rather than the particular C-state that makes
the difference between idle and suspend.  Yes, you have claimed that
idle will render suspend obsolete, but you have not yet convinced me.

> > As for the first part of the second sentence, you yourself have argued
> > that each and every application should be carefully written to avoid
> > battery drain (or, equivalently, to promote energy efficiency), so
> 
> No. I've argued that applications need to be generally well behaved, not
> keep waking up, not burn cpu - which is a generic property applicable on
> all environments not a specialisation.

Either way you prefer to word it is fine by me -- I am fine with either
"carefully written" or "generally well behaved".  Alternatively, if you
were trying to say something different than what I said, I failed to
spot the difference.

> > > OpenOffice runs on netbooks, laptops, servers, even big non x86 boxes. It
> > > runs on virtual machines, it runs in power sensitive environments, it
> > > runs in thermally constrained environments, it runs in I/O constrained
> > > environments, it runs in latency constrained environments etc etc
> > 
> > And there are numerous environments in which it will not run.  So what?
> 
> It's one codebase for all of them

Yes, and there are still numerous environments where it does not run.

>                                   and furthermore almost all of that was
> done by modifying only the OS. Linux learned to do power throttling
> without the app being involved, it learned to do virtualisation without
> the app being changed, it is learning (with -rt) to handle to do real
> time this way. 

Except that you do modify the app to more effectively throttle power.
Which is fine; I have no problem with that.  I also have no problem
with things that reduce the need to modify the apps to more effectively
throttle power.

Real time indeed allows unmodified non-real-time apps to stay out of
the way of very carefully written real-time apps, so I do like that
example.

> > > All the same code, true some work has been done to make it behave
> > > politely but the rest is down to the OS doing its job - deploying the
> > > resources available while considering and obeying the constraints
> > > present, in a manner which makes best use of the resources to achieve the
> > > policy goals of the system.
> > 
> > And if the work has not been done on the application, and if there is
> > nothing like suspend blockers, the OS cannot do its job. 
> 
> I don't see any evidence to support that claim. I see evidence that there
> are cases where apps wish to communicate their intentions around power
> more clearly but a suspend blocker is a crude single case hammer. Today
> most applications communicate their sleep/wake requirements fairly well by
> sleeping, by executing code and by setting timers/alarms.

I will take your "there are cases where apps wish to communicate their
intentions around power more clearly", thank you very much.  And yes,
there is much debate over exactly what form that communication might take.

> > Given this context, are you sure that suspend blockers are not the next
> > step in the Real OS progression?  Or some QoS mechanism that subsumes
> > suspend blockers?  However, there is a lot of negative experience
> > around general-purpose QoS mechanisms -- you have to be quite careful
> > in order to avoid spending more energy computing QoS than you would
> > otherwise spend on the application's computations.  The usual way out of
> > this trap is to abandon generality in favor of exploiting the commonly
> > occurring special cases.  For all I know, raw suspend blockers might be
> > the appropriate special case.
> 
> For Android possibly and I've never had any objection to Android keeping
> suspend blockers in private patches. The claim is only a small number are
> needed in their kernel so its a tiddly patch and the patch context will
> no doubt keep it applying between releases and easy for them to maintain.
> 
> For the rest of us - I see no evidence it's generally useful. A QoS API
> does appear to be generally useful but as you say you need to get the
> performance right. However you can also tackle that the way we tackle
> several other examples of one interface/many needs - such as schedulers,
> security models and the like.

No one will know whether or not suspend blockers are generally useful
until they are willing to try them.

> One interface to applications and one interface to drivers so that its
> easy to maintain and you don't end up with hooks all over the place for
> different things, then if it proves neccessary different implementations.
> So yes maybe Android would use a "qos_basic" which returns -EOPNOTSUPP to
> anything but a suspend blocker behaviour. The important thing about that
> is that my device drivers, my applications and my other platforms don't
> have to care that Android made this choice - they can still be generic
> code.

If this can actually happen, I would consider it a good thing.

Of course, we might well find out some years down the road that the
qos_basic piece is the only part that was actually in common use.  Then
again, it would not be the first time.  System-V semaphores, anyone?  ;-)

> That is why I used the Win16 example. The Win16 model encapsulated an
> implementation into the API. Had they followed a more conventional
> interface based around yielding then like MacOS they'd have had a far
> smoother move to pre-emptive MT.

I am certainly no fan of Win16.  That said, if there is a qos_basic that
maps nicely to suspend blockers, the risk of adding suspend blockers in
their current form seems to me to be rather low.

							Thanx, Paul
