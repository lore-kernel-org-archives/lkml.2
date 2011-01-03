Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab1ACUZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 15:25:36 -0500
Received: from ms01.sssup.it ([193.205.80.99]:48832 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750947Ab1ACUZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 15:25:34 -0500
Message-ID: <4D2230BA.1020607@sssup.it>
Date: Mon, 03 Jan 2011 21:25:30 +0100
From: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Harald Gustafsson <hgu1972@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Dario Faggioli <raistlin@linux.it>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Michael Trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [PATCH 1/3] Added runqueue clock normalized with cpufreq
References: <7997200675c1a53b1954fdc3f46dd208db5dea77.1292578808.git.harald.gustafsson@ericsson.com>	<1292596194.2266.283.camel@twins>	<1292612166.2697.68.camel@Palantir>	<1292612385.2708.108.camel@laptop>	<AANLkTikO56++q906A1XRbomeASY77wxeEuBqAdx=EttW@mail.gmail.com>	<4D0E9F20.6080606@sssup.it> <AANLkTikidJBXT=vfbncd5=832VTPRwQps7UNru+DAw0e@mail.gmail.com>
In-Reply-To: <AANLkTikidJBXT=vfbncd5=832VTPRwQps7UNru+DAw0e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 20/12/2010 10:44, Harald Gustafsson ha scritto:
> 2010/12/20 Tommaso Cucinotta<tommaso.cucinotta@sssup.it>:
>> 1. from a requirements analysis phase, it comes out that it should be
>> possible to specify the individual runtimes for each possible frequency, as
>> it is well-known that the way computation times scale to CPU frequency is
>> application-dependent (and platform-dependent); this assumes that as a
>> developer I can specify the possible configurations of my real-time app,
>> then the OS will be free to pick the CPU frequency that best suites its
>> power management logic (i.e., keeping the minimum frequency by which I can
>> meet all the deadlines).
> I think this make perfect sense, and I have explored related ideas,
> but for the Linux kernel and
> softer realtime use cases I think it is likely too much at least if
> this info needs to be passed to the kernel.

That's why we proposed a user-space daemon taking care of this (see
our paper at the last RTLWS in Kenya). This way, the kernel only sees
the minimal information it needs to have, and all the rest is handled
from the user-space (i.e., awareness of different budgets for the various
CPU speeds, extra complexity due the mode-change protocol, power
management logic). However, this is compatible with a user-space
power-management logic. Instead, if we wanted a kernel-space one
(e.g., the current governors), then we would have to pass all the
additional info to the kernel as well.
> But if I was designing a system that needed real hard RT tasks I would
> probably not enable cpufreq
> when those tasks were active.
This is what has always been done. However, there's an interesting thread
on the Jack mailing list in these weeks about the support for power
management (Jack may be considered to a certain extent hard RT due to
its professional usage [ audio glitches cannot be tolerated at all ], 
even if
it is definitely not safety critical). Interestingly, there they 
proposed jackfreqd:

   http://comments.gmane.org/gmane.comp.audio.jackit/22884

>
>> 4. I would say that, given the tendency to over-provision the runtime (WCET)
>> for hard real-time contexts, it would not bee too much of a burden for a
>> hard RT developer to properly over-provision the required budget in presence
>> of a trivial runtime rescaling policy like in 2.; however, in order to make
>> everybody happy, it doesn't seem a bad idea to have something like:
>>   4a) use the fine runtimes specified by the user if they are available;
>>   4b) use the trivially rescaled runtimes if the user only specified a single
>> runtime, of course it should be clear through the API what is the frequency
>> the user is referring its runtime to, in such case (e.g., maximum one ?)
> You mean this on an application level?
I was referring to the possibility to both specify (from within the app) the
additional budgets for the additional power modes, or not. In the former
case, the kernel would use the app-supplied values, in the latter case the
kernel would be free to use its dumb linear rescaling policy.
>> 5. Mode Change Protocol: whenever a frequency switch occurs (e.g., dictated
>> by the non-RT workload fluctuations), runtimes cannot simply be rescaled
>> instantaneously: keeping it short, the simplest thing we can do is relying
>> on the various CBS servers implemented in the scheduler to apply the change
>> from the next "runtime recharge", i.e., the next period. This creates the
>> potential problem that the RT tasks have a non-negligible transitory for the
>> instances crossing the CPU frequency switch, in which they do not have
>> enough runtime for their work. Now, the general "rule of thumb" is
>> straightforward: make room first, then "pack", i.e., we need to consider 2
>> distinct cases:
> If we use the trivial rescaling is this a problem?
This is independent on how the budgets for the various CPU speeds are
computed. It is simply a matter of how to dynamically change the runtime
assigned to a reservation. The change cannot be instantaneous, and the
easiest thing to implement is that, at the next recharge, the new value is
applied. If you try to simply "reset" the current reservation without
precautions, you put at risk schedulability of other reservations.
CPU frequency changes make things slightly more complex: if you reduce
the runtimes and increase the speed, you need to be sure the frequency
increase already occurred before recharging with a halved runtime.
Similarly, if you increase the runtimes and decrease the speed, you need
to ensure runtimes are already incremented when the frequency switch
actually occurs, and this takes time because the increase in runtimes
cannot be instantaneous (and the request comes asynchronously with
the various deadline tasks, where they consumed different parts of their
runtime at that moment).
> In my
> implementation the runtime
> accounting is correct even when the frequency switch happens during a period.
> Also with Peter's suggested implementation the runtime will be correct
> as I understand it.
Is it too much of a burden for you to detail how these "accounting" are
made, in your implementations ? (please, avoid me to go through the
whole code if possible).
>>   5a) we want to *increase the CPU frequency*; we can immediately increase
>> the frequency, then the RT applications will have a temporary
>> over-provisioning of runtime (still tuned for the slower frequency case),
>> however as soon as we're sure the CPU frequency switch completed, we can
>> lower the runtimes to the new values;
> Don't you think that this was due to that you did it from user space,
nope. The problem is the one I tried to detail above, and is there both
if you change things from the user-space, and if you do that from the
kernel-space.
> I actually change the
> scheduler's accounting for the rest of the runtime, i.e. can deal with
> partial runtimes.
... same request as above, if possible (detail, please) ...

... and, happy new year to everybody ...

     T.

-- 
Tommaso Cucinotta, Computer Engineering PhD, Researcher
ReTiS Lab, Scuola Superiore Sant'Anna, Pisa, Italy
Tel +39 050 882 024, Fax +39 050 882 003
http://retis.sssup.it/people/tommaso

