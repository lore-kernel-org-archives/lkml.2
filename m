Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab0LTJor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 04:44:47 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34604 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175Ab0LTJop convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 04:44:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WRrLw7zoz9S+yCo+5GuKU0Em+NxW4kWjuzcExt2yjccYTSK9FRWe7e97gHOgNwo+//
         Rp9zl5aC0o16Ky6sgIN+GEr9nLM1MGHTTPyj27Z93hjuAk1d8jtWgB/RmgB6M7fhh3tS
         F6ChdIgyFucA36ZXln3vOLO+Ifb8g1Ylcd4lI=
MIME-Version: 1.0
In-Reply-To: <4D0E9F20.6080606@sssup.it>
References: <7997200675c1a53b1954fdc3f46dd208db5dea77.1292578808.git.harald.gustafsson@ericsson.com>
	<1292596194.2266.283.camel@twins>
	<1292612166.2697.68.camel@Palantir>
	<1292612385.2708.108.camel@laptop>
	<AANLkTikO56++q906A1XRbomeASY77wxeEuBqAdx=EttW@mail.gmail.com>
	<4D0E9F20.6080606@sssup.it>
Date: Mon, 20 Dec 2010 10:44:43 +0100
Message-ID: <AANLkTikidJBXT=vfbncd5=832VTPRwQps7UNru+DAw0e@mail.gmail.com>
Subject: Re: [PATCH 1/3] Added runqueue clock normalized with cpufreq
From: Harald Gustafsson <hgu1972@gmail.com>
To: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Cc: Peter Zijlstra <peterz@infradead.org>, Dario Faggioli <raistlin@linux.it>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Michael Trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/20 Tommaso Cucinotta <tommaso.cucinotta@sssup.it>:
> 1. from a requirements analysis phase, it comes out that it should be
> possible to specify the individual runtimes for each possible frequency, as
> it is well-known that the way computation times scale to CPU frequency is
> application-dependent (and platform-dependent); this assumes that as a
> developer I can specify the possible configurations of my real-time app,
> then the OS will be free to pick the CPU frequency that best suites its
> power management logic (i.e., keeping the minimum frequency by which I can
> meet all the deadlines).

I think this make perfect sense, and I have explored related ideas,
but for the Linux kernel and
softer realtime use cases I think it is likely too much at least if
this info needs to be passed to the kernel.

> 2. this was also assuming, at an API level, a quite static settings (typical
> of hard RT), in which I configure the system and don't change its frequency
> too often; for example, implications of power switches on hard real-time
> requirements (i.e., time windows in which the CPU is not operating during
> the switch, and limits on the max sustainable switching frequencies by apps
> and the like) have not been stated through the API;

I would not worry too much about switch transition effects. They are
in the same order of magnitude
as other disturbances from timers and interrupts and can easily be set
to a certain smallest periodicity.
But if I was designing a system that needed real hard RT tasks I would
probably not enable cpufreq
when those tasks were active.

> 3. for soft real-time contexts and Linux (consider FRESCOR targeted both
> hard RT on RT OSes and soft RT on Linux), we played with a much simpler
> trivial linear scaling, which is exactly what has been proposed and
> implemented by someone in this thread on top of SCHED_DEADLINE (AFAIU);
> however, there's a trick which cannot be neglected, i.e., *change protocol*
> (see 5); benchmarks on MPEG-2 decoding times showed that the linear
> approximation is not that bad, but the best interpolating ratio between the
> computing times in different CPU frequencies do not perfectly conform to the
> frequencies ratios; we didn't make any attempt of extensive evaluation over
> different workloads so far. See Figure 4.1 in D-AQ2v2:

Totally agree on this as well, and it would not be that difficult to
implement in Linux.
For example not just use the frequency as the normalization but have a
different
architecture dependent normalization. This would capture the general
normalization but
not on an application level. But, others might think this is
complicating matter too much.
The other solution is that the deadline task do some over-reservation,
which is going to be
less over-reservation compared to if no normalization existed.

> 4. I would say that, given the tendency to over-provision the runtime (WCET)
> for hard real-time contexts, it would not bee too much of a burden for a
> hard RT developer to properly over-provision the required budget in presence
> of a trivial runtime rescaling policy like in 2.; however, in order to make
> everybody happy, it doesn't seem a bad idea to have something like:
>  4a) use the fine runtimes specified by the user if they are available;
>  4b) use the trivially rescaled runtimes if the user only specified a single
> runtime, of course it should be clear through the API what is the frequency
> the user is referring its runtime to, in such case (e.g., maximum one ?)

You mean this on an application level? I think we should test the
trivial rescaling first
and if any users steps forward that need this lets reconsider.

> 5. Mode Change Protocol: whenever a frequency switch occurs (e.g., dictated
> by the non-RT workload fluctuations), runtimes cannot simply be rescaled
> instantaneously: keeping it short, the simplest thing we can do is relying
> on the various CBS servers implemented in the scheduler to apply the change
> from the next "runtime recharge", i.e., the next period. This creates the
> potential problem that the RT tasks have a non-negligible transitory for the
> instances crossing the CPU frequency switch, in which they do not have
> enough runtime for their work. Now, the general "rule of thumb" is
> straightforward: make room first, then "pack", i.e., we need to consider 2
> distinct cases:

If we use the trivial rescaling is this a problem? In my
implementation the runtime
accounting is correct even when the frequency switch happens during a period.
Also with Peter's suggested implementation the runtime will be correct
as I understand it.

>  5a) we want to *increase the CPU frequency*; we can immediately increase
> the frequency, then the RT applications will have a temporary
> over-provisioning of runtime (still tuned for the slower frequency case),
> however as soon as we're sure the CPU frequency switch completed, we can
> lower the runtimes to the new values;

Don't you think that this was due to that you did it from user space,
I actually change the
scheduler's accounting for the rest of the runtime, i.e. can deal with
partial runtimes.

> The protocol in 5. has been implemented completely in user-space as a
> modification to the powernowd daemon, in the context of an extended version
> of a paper in which we were automagically guessing the whole set of
> scheduling parameters for periodic RT applications (EuroSys 2010). The
> modified powernowd was considering both the whole RT utilization as imposed
> by the RT reservations, and the non-RT utilization as measured on the CPU.
> The paper will appear on ACM TECS, but who knows when, so here u can find it
> (see Section 7.5 "Power Management"):
>
>  http://retis.sssup.it/~tommaso/publications/ACM-TECS-2010.pdf

Thanks I will take a look as soon as I find the time.

> Last, but not least, the whole point in the above discussion is the
> assumption that it is meaningful to have a CPU frequency switching policy,
> as opposed to merely CPU idle-ing. Perhaps on old embedded CPUs this is
> still the case. Unfortunately, from preliminary measurements made on a few
> systems I use every day through a cheap power measurement device attached on
> the power cable, I could actually see that for RT workloads only it is worth
> to leave the system at the maximum frequency and exploit the much higher
> time spent in idle mode(s), except when the system is completely idle.

I was also of this impression for a while that cpufreq scaling would
be of less importance.
But when I looked at complex use cases, which are common on embedded devices and
also new chip technology nodes I had to reconsider. Unfortunately I
don't have any information
that I can share publicly. What is true is that the whole system
energy needs to be considered,
including peripherals, and this is very application dependent.

> If you're interested, I can share the collected data sets.
Sure, more data is always of interest.
