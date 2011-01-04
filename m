Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751192Ab1ADMQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 07:16:50 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:55453 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab1ADMQt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 07:16:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pnKqna42OVTzFdaHQAuEjo64MPmoniYNMa4s9tZ5GXGM7QGdMSex8N9gGh8kYC0kSI
         LGwPBU0+99wUQU3lBMlT71t1086goPxm01Bef0dfQo5KoscJfRFAKFWD86G4CKwb9qGE
         IBGEcwmSCHKzQt+dQho3B2qUrRqvIh3SmXgRg=
MIME-Version: 1.0
In-Reply-To: <4D2230BA.1020607@sssup.it>
References: <7997200675c1a53b1954fdc3f46dd208db5dea77.1292578808.git.harald.gustafsson@ericsson.com>
	<1292596194.2266.283.camel@twins>
	<1292612166.2697.68.camel@Palantir>
	<1292612385.2708.108.camel@laptop>
	<AANLkTikO56++q906A1XRbomeASY77wxeEuBqAdx=EttW@mail.gmail.com>
	<4D0E9F20.6080606@sssup.it>
	<AANLkTikidJBXT=vfbncd5=832VTPRwQps7UNru+DAw0e@mail.gmail.com>
	<4D2230BA.1020607@sssup.it>
Date: Tue, 4 Jan 2011 13:16:48 +0100
Message-ID: <AANLkTinjboHpEBHB3M=u5m=HhM+Qv-J6O5zFVWkPzRe3@mail.gmail.com>
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

> This is what has always been done. However, there's an interesting thread
> on the Jack mailing list in these weeks about the support for power
> management (Jack may be considered to a certain extent hard RT due to
> its professional usage [ audio glitches cannot be tolerated at all ], even
> if
> it is definitely not safety critical). Interestingly, there they proposed
> jackfreqd:
>
>  http://comments.gmane.org/gmane.comp.audio.jackit/22884
Being an embedded audio engineer for many years I know that we audio people take
audio quality and realtime performance seriously. If I understand what
the jackfreqd
does is that it make's sure that the CPU frequency is controlled by
the JACK DSP-load,
which sort of is a CPU time percentage devoted to JACK over an audio
frame period.
With sched deadline and a resource manager knowing about JACK's needs
this should be
possible to handle in an ondemand governor aware of sched deadline
bandwidths. The
RM would set the periods and runtime budgets based on JACK's DSP load,
e.g. period = audio frame duration and runtime = "max" DSP-load + margin.

> I was referring to the possibility to both specify (from within the app) the
> additional budgets for the additional power modes, or not. In the former
> case, the kernel would use the app-supplied values, in the latter case the
> kernel would be free to use its dumb linear rescaling policy.

OK, basically specifying the normalization values per power state for each
thread with the default being a linear scaling. I'll make sure that the default
normalization can be changed then but default initialized to linear based on
frequency in each freq state. Maybe a separate patch with a new prctl
call that can alter this, so we can evaluate it separately.

> This is independent on how the budgets for the various CPU speeds are
> computed. It is simply a matter of how to dynamically change the runtime
> assigned to a reservation. The change cannot be instantaneous, and the
But we don't change the runtime assigned to a reservation, think of it more
as the runtime is specified in "cycles". This is done either as in my patch that
the scheduler's runtime clock is running slower at lower clock speeds
or as Peter suggest that during runtime accounting the delta execution is
normalized with the cpu frequency.

> easiest thing to implement is that, at the next recharge, the new value is
> applied. If you try to simply "reset" the current reservation without
> precautions, you put at risk schedulability of other reservations.
> CPU frequency changes make things slightly more complex: if you reduce
> the runtimes and increase the speed, you need to be sure the frequency
> increase already occurred before recharging with a halved runtime.
Right now I only act on the post cpu frequency change notification. I think
that on most systems the error due to that it takes some time to change the
actual frequency of the core is on par with other errors like context switches,
migration (due to G-EDF) or cache misses. But I'm open for other views on that.

> Similarly, if you increase the runtimes and decrease the speed, you need
> to ensure runtimes are already incremented when the frequency switch
> actually occurs, and this takes time because the increase in runtimes
> cannot be instantaneous (and the request comes asynchronously with
> the various deadline tasks, where they consumed different parts of their
> runtime at that moment).
See previous comment about the change of the runtime vs accounting
a normalized runtime.

> Is it too much of a burden for you to detail how these "accounting" are
> made, in your implementations ? (please, avoid me to go through the
> whole code if possible).
It is simple, basically to things are introduced.
1) At every post cpufreq notification the factor between the current
frequency and the maximum frequency is calculated, i.e. the linear scaling.
I also keep track of the time this happens so that the runtime clock progress
is done with right factor also between sched clock updates. Hence I introduce
a clock that progress approximately proportional to the CPU clock frequency.
(On some systems this could actually be obtained directly, so that is
a potential
optimization by introducing a sched_cycle_in_ktime() next to the
sched_clock() call.)

2) For runtime accounting the CPU frequency normalized runtime clock is used.
Deadline accounting still use the real time. So for example if running
at 50% freq
and having a runtime budget of 20 ms and a period of 100 ms. The
deadline will still
happen at each 100 ms period, but the runtime progress is only half
compared with
real time. Hence it would correspond to setting the runtime to 40 ms,
but the nice part
of it is that when the CPU frequency is altered the accounting
progress as before
but with a new factor. For example if at 50 ms into the period the
runtime is at 10 ms
(i.e. have run 20 ms@ real time) and the CPU freq is now set to 100%
the remaining
10 ms of the runtime will finish in 10ms@real time.

Hope this helps explains how the runtime accounting is done in my
patches. With the
comments from Peter this would change slightly so that instead of
keeping an actual
normalized runtime clock we would normalize each threads progress
during the accounting
of the runtime. This would actually help also to incorporate your
comments about having
non-linear normalization per thread.

/Harald
