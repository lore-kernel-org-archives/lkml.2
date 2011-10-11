Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab1JKKD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 06:03:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45809 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab1JKKD0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 06:03:26 -0400
Subject: Re: sched: ARM: arch_scale_freq_power
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Amit Kucheria <amit.kucheria@linaro.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org,
        LAK <linux-arm-kernel@lists.infradead.org>,
        linaro-dev@lists.linaro.org, Paul Turner <pjt@google.com>
Date: Tue, 11 Oct 2011 12:03:05 +0200
In-Reply-To: <CAP245DXbj5nEB2ya5BWVYinvr2RQ+m7vmuHHT3fD1iVZZQ2C5g@mail.gmail.com>
References: <CAKfTPtB3sLWq5fHOTrFg6vfHSKnz2i17oYx9Btr0u_tWV2bsjQ@mail.gmail.com>
	 <CAP245DX8b45Nj5SAwtLivp_vMKpwfeUrqnR2sqjnVyqiRd61gg@mail.gmail.com>
	 <1318319852.14400.65.camel@laptop>
	 <CAKfTPtB_eXgggeEYmNsXkvL8NsoEoz_NJFgA4E5WtAm74F515Q@mail.gmail.com>
	 <1318324399.14400.71.camel@laptop>
	 <CAP245DXbj5nEB2ya5BWVYinvr2RQ+m7vmuHHT3fD1iVZZQ2C5g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318327385.8395.26.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-11 at 15:08 +0530, Amit Kucheria wrote:

> > That shouldn't be done using cpu_power, we have sched_smt_power_savings
> > and sched_mc_power_savings for stuff like that.
> 
> AFAICT, sched_mc assume all cores to have the same capacity - which is
> certainly true of the x86 architecture. But in ARM you can see hybrid
> cores[1] designed using different fab technology, so that some cores
> can run at 'n' GHz and some at 'm' GHz. The idea being that when there
> isn't much to do (e.g periodic keep alives for messaging, email, etc.)
> you don't wake up the higher power-consuming cores.
> 
> From TFA[1],  "Sheeva was already capable of 1.2GHz, but the new
> design can go up to 1.5GHz. But only two of the 628's Sheeva cores run
> at the full 1.5GHz. The third one is down-clocked to 624MHz, and
> interesting design choice that saves on power but adds some extra
> utility. In a sense, the 628 could be called a 2.5-core design."

Cute :-)

> Are we mistaken in thinking that sched_mc can not currently handle
> this usecase? How would we 'tune' sched_mc to do this w/o playing with
> cpu_power?

Yeah, sched_mc wants some TLC there.

> > Although I would really like to kill all those different
> > sched_*_power_savings knobs and reduce it to one.
> >
> >> If the cpu_power is
> >> higher than 1024, the cpu is no more seen out of capacity by the
> >> load_balance as soon as a short process is running and teh main result
> >> is that the small tasks will stay on the same cpu. This configuration
> >> is mainly usefull for ARM dual core system when we want to power gate
> >> one cpu. I use cyclictest to simulate such use case.
> >
> > Yeah, but that's wrong.
> 
> What is wrong - the use case simulation using cyclictest? Can you
> suggest better tools?

Using cpu_power to do power saving load-balancing like that.

So ideally cpu_power is simply a factor in the weight balance decision
such that:

	cpu_weight_i      cpu_weigjt_j
	------------  ~=  ------------
	cpu_power_i       cpu_power_j

This yields that under sufficient[*] load, eg. 5 equal weight tasks and
your 2.5 core thingy, you'd get 2:2:1

The decision on what to do on under-utilized systems should be separate
from this.

Currently the load-balancer doesn't know about 'short' running processes
at all, we just have nr_running and weight it doesn't know/care about
for how long those will be around for.

Now for some of the cgroup crap we track a time-weighted weight average,
and pjt was talking about pulling that up into the normal code to get
rid of our multitude of different ways to calculate actual load. [**]

(/me pokes pjt with a sharp stick, where those patches at!?)

But that only gets you half-way there, you also need to compute an
effective time-weighted load per task to go with that.. now while all
that is quite feasible, the problem is overhead. We very much already
are way to expensive and should be cutting back, not keep adding more
and more accounting.

[*] Sufficient such that the weight problem is feasible. eg. 3 equal
tasks on 2 equal cores can never be statically balanced, 2 unequal tasks
on 2 equal cores (or v.v.) can't ever be balanced.

[**] I suspect this might solve the over-balancing problem triggered by
tasks woken from the tick that also does the load-balance pass. This
load-balance pass will run in sIRQ context and thus preempt running all
those just woken tasks, thus giving the impression the CPU is very busy,
while in fact most those tasks will instantly go back to sleep after
finding nothing to do.
