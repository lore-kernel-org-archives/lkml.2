Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab0EQPZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 11:25:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45207 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab0EQPZ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 11:25:27 -0400
MIME-Version: 1.0
Message-ID: <a3572531-ca89-4959-b190-bcb9309a0193@default>
Date: Mon, 17 May 2010 08:23:59 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Cc: Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: RE: [PATCH] x86: Export tsc related information in sysfs
References: <87tyq9mqrz.fsf@basil.nowhere.org>
 <35aa841b-e151-424d-b1c1-0c03dbcae5cc@default
 20100517102214.GA20761@basil.fritz.box>
In-Reply-To: <20100517102214.GA20761@basil.fritz.box>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090207.4BF15FA9.0192:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(note important alternate proposal suggested below, please
don't get bored and stop reading yet ;-)

> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> > "won't let my friends use rdtsc" :-)  Anything I can do
> > to help?
> 
> Yes, stop trying to convince me that rdtsc in apps is a good idea. :)

You've convinced ME that it is NOT a good idea in many many cases
and that some of those cases are very very hard to detect.  Unfortunately,
convincing ME is not sufficient.  The problem is that Pandora's
box is already open and it is getting ever more wide open. (Each
of you has implied that TSC on future systems is getting even
more likely to be reliable.) Not only is rdtsc unprivileged
but so is the CPUID Invariant TSC bit.  And the kernel already
publishes current_clocksource and puts a tempting MHz rate in
its logs.  While we all might hope that every system programmer
will read this long thread and also be convinced never to use
rdtsc, the problem is there is a high and increasing chance that
any given systems programmer will write code that uses rdtsc and,
in all of his/her test machines will NEVER see a problem.  But,
sadly, some of the customers using that app WILL see the problem
BUT neither the customers nor the systems programmer may ever know
what really went wrong (unless they hire Thomas to debug it :-)

So let me suggest inverting the logic of the patch and maybe
it will serve all of us better.  (see proposal below)

> From: Arjan van de Ven [mailto:arjan@infradead.org]
> If you want to find out yourself if the tsc is good enough for you
> that is one thing.... but if you want the kernel to have an official
> interface for it.... the kernel has to live by that commitment.
> We cannot put in that interface "oh and you need to implement the same
> workarounds, scaling and offsets as the kernel does", because that's
> in a huge flux, and will change from kernel version to kernel version.
> The only shot you could get is some vsyscall/vdso function that gives
> you a unit (but that is not easy given per cpu offset/frequency/etc..
> but at least the kernel can try)

> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Please understand that once we expose that tsc_reliable information we
> are responsible for its correctness. People will use it whether the
> enterprise entity who wants this feature has qualified that particular
> piece of hardware or not. And while the support of that enity refuses
> to help on non qualified hardware (your own words), we'll end up with
> the mess which was created to help that very entity.

OK, so let's invert the sense of the sysfs file and call it (for now)
"tsc_detected_as_UNreliable".  Then anytime the kernel detects
a failed warp test (or any other suspicious condition), it changes
the bit from 0 to 1 effectively saying "if you are using rdtsc
against our recommendation, we told you that it might go bad and
it has, so consider yourself warned that some of the timestamps
you've taken since the last time you've checked this flag
may be b*rked"

IMHO, addressing the issue directly and clearly documenting it
(instead of trying to hide the dirty laundry in the kernel)
will result in far better education of systems programmers
and far fewer end user problems. Which raises another good analogy:

You are telling teenagers to abstain and I am proposing that we
instead encourage them to use a condom.

You are simply not going to stop systems programmers from using
rdtsc... let's at least allow them to practice "safe TSC usage"
which, to extend the analogy, we all know is still not 100.0%
effective but, if they are going to do "it" anyway, is still
far better than completely unprotected TSC usage.

(The remainder of this response is discussion of individual
points raised, so can be skipped by most readers.)

====

> From: Arjan van de Ven [mailto:arjan@infradead.org]
> and 3) the kernel gets thermal interrupts and the app does not
> and 4) the kernel decides which power management to use when
> and 5) the kernel can find out if SMI's happened, and the app cannot.
> and 6) the kernel can access tsc and a per cpu offset/frequency
> data atomically, without being scheduled to another CPU. The app cannot
> [well it can ask the kernel to be pinned, and that's a 99.99% thing,
> but still]

These are all very good reasons where the kernel might turn
on a "tsc_detected_as_unreliable" bit.  And CPU-hotplug_add
too.

And, by the way, are any of these valid in a virtual machine?

> From: Andi Kleen [mailto:andi@firstfloor.org]
> What would the application do in the 10% case?

(and in the "tsc_detected_as_unreliable" == 1 case)
Well, some possibilities are:
- Disable the heavy TSC usage and log/notify that it has been
  disabled because the TSC is not reliable.
- Switch to gettimeofday and log/notify that, sorry, overall
  performance has become slower due to the fact that the
  TSC has become reliable
- Log a message telling the user to confirm that the hardware
  they are using is on the app's supported/compatibility list
  and that they are using the latest firmware and that their
  thermal logs are OK, because something might not be quite
  right with their system

> From: Andi Kleen [mailto:andi@firstfloor.org]
> 32bit doesn't have a fast ring 3 gtod() today but that could be also
> fixed.

That might have helped, because the enterprise app I mentioned
earlier was 32-bit... but I'll bet the genie is out of the
bottle now and the app has already shipped using rdtsc.

> From: Andi Kleen [mailto:andi@firstfloor.org]
> It seems to me you're bordering on violating Steinberg's rule
> of system programming here :-)

<Embarrassed to not know this rule, Dan goes off and googles
but fails to find any good matches before his TSC goes bad>

> From: Andi Kleen [mailto:andi@firstfloor.org]
> First the single instruction is typically quite slow. Then
> to really get monotonous time you need a barrier anyways.

Agreed, I've measured 30-ish and 60-ish cycles on a
couple of machines.

> From: Andi Kleen [mailto:andi@firstfloor.org]
> When I originally wrote vsyscalls that overhead wasn't that big
> with all that compared to open coding. The only thing that could
> be stripped might be the unit conversion. In principle
> a new vsyscall could be added for that (what units do you need?)
> 
> I remember when they were converted to clocksources they got
> somewhat slower, but I suspect with some tuning work that
> could be also fixed again.
> 
> I think glibc also still does a unnecessary indirect jump
> (might hurt you if your CPU cannot predict that), but that could
> be fixed too. I think I have an old patch for that in fact,
> if you're still willing to use the old style vsyscalls.

I think vsyscall is an excellent idea and I'm very much in
favor of continuing to improve it and encouraging people
to use it.  But until it either "always" "just works" in "all"
of the software/hardware environments used by a systems
programmer in their development and testing and in the systems
the apps get deployed on (including virtual machines) OR until
it clearly provides an indicator that it is hiding dirty performance
laundry, IMHO it won't convince the (admittedly undereducated)
pro-TSC crowd.

> > signal that drives the TSC, the system is badly broken and far
> > worse things -- like inter-processor cache incoherency -- may happen.
>
> From: Andi Kleen [mailto:andi@firstfloor.org]
> I don't think that's true. There are various large systems with
> non synchronized TSC and I haven't heard of any unique cache coherency
> problems on that.

Here I was referring to clock skew/drift, not the "fixed offset"
problem.  I'm far from an expert in PLL's etc, but I think if
the clock signal is delayed far enough to cause TSC to skew
significantly, eventually some critical cache coherency protocol
is eventually going to miss a beat and screw up and corrupt data.

> If the idea is to use the TSC on not fully synchronized systems?

That has never been my intent, though others might be interested
in that.

> From: Andi Kleen [mailto:andi@firstfloor.org]
> I haven't fully kept track, but at some point there was an attempt
> to have more POSIX clocks with loser semantics (like per thread
> monotonous). If you use that you'll get fast time (well not day time,
> but perhaps useful time) which might be good enough without
> hacks like this?
> 
> If the semantics are not exactly right I think more POSIX clocks
> could be added too.
> 
> Or if the time conversion is a problem we could add a
> posix_gettime_otherunit()
> or so (e.g. with a second vsyscall that converts units so you don't
> need to do it in the fast path)
> 
> A long time ago there was also the idea to export the information
> if gettimeofday()/clock_gettime() was fast or not. If this helps this
> could
> be probably revisited. But I'm not sure what the application
> should really do in this case.
> 
> 32bit doesn't have a fast ring 3 gtod() today but that could be also
> fixed.

I believe (and this is strictly a personal opinion based on my
view of human psychology) that adding more obscure interfaces and
more obscure options is a losing battle.

> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> I think you understand that I have no intention to put a ticking time
> bomb into the code I'm responsible for. I really have better things to
> do than shooting myself in the foot.

As we both know, the ticking time bomb is already there.  IMHO this
revised proposal provides you with "plausible deniability"**
"The kernel now advertises when it detects the TSC is bad or has gone
bad... did your app vendor check the kernel-provided info?"

** http://en.wikipedia.org/wiki/Plausible_deniability 
