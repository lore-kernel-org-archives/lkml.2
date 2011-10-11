Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab1JKK2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 06:28:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50882 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab1JKK2A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 06:28:00 -0400
Subject: Re: sched: ARM: arch_scale_freq_power
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Amit Kucheria <amit.kucheria@linaro.org>, linux-kernel@vger.kernel.org,
        LAK <linux-arm-kernel@lists.infradead.org>,
        linaro-dev@lists.linaro.org, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>
Date: Tue, 11 Oct 2011 12:27:28 +0200
In-Reply-To: <CAKfTPtDzY4pORvWd3Qa6kqpNsspKN7iEskQ+7F5D=mAwQWoKNg@mail.gmail.com>
References: <CAKfTPtB3sLWq5fHOTrFg6vfHSKnz2i17oYx9Btr0u_tWV2bsjQ@mail.gmail.com>
	 <CAP245DX8b45Nj5SAwtLivp_vMKpwfeUrqnR2sqjnVyqiRd61gg@mail.gmail.com>
	 <1318319852.14400.65.camel@laptop>
	 <CAKfTPtB_eXgggeEYmNsXkvL8NsoEoz_NJFgA4E5WtAm74F515Q@mail.gmail.com>
	 <1318324399.14400.71.camel@laptop>
	 <CAKfTPtDzY4pORvWd3Qa6kqpNsspKN7iEskQ+7F5D=mAwQWoKNg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318328848.8395.45.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-11 at 11:40 +0200, Vincent Guittot wrote:
> On 11 October 2011 11:13, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Tue, 2011-10-11 at 10:51 +0200, Vincent Guittot wrote:
> >> I have several goals. The 1st one is that I need to put more load on
> >> some cpus when I have packages with different cpu frequency.
> >
> > That should be rather easy.
> >
> 
> I agree, I was mainly wondering If I should use a [1-1024] or a
> [1024-xxxx] range and it seems that both can be used according : SMT
> uses <1024 and x86 turbo mode uses >1024

Well, turbo mode would typically only boost a cpu 25% or so, and only
while idling other cores to keep under its thermal limit. So its not
sufficient to actually affect the capacity calculation much if at all.

> >> Then, I have some use cases which have several running tasks but a low
> >> cpu load. In this case, the small tasks are spread on several cpu by
> >> the load_balance whereas they could be easily handled by one cpu
> >> without significant performance modification.
> >
> > That shouldn't be done using cpu_power, we have sched_smt_power_savings
> > and sched_mc_power_savings for stuff like that.
> >
> 
> sched_mc_power_saving works fine when we have more than 2 cpus but
> can't apply on a dual core because it needs at least 2 sched_groups
> and the nr_running of these sched_groups must be higher than 0 but
> smaller than group_capacity which is 1 on a dual core system.

SD_POWERSAVINGS_BALANCE does /=2 to nr_running, effectively doubling the
capacity iirc. And I know some IBM dudes were toying with the idea of
playing tricks with the capacity numbers, but that never went anywhere.

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
> That's the only way I have found to gathers small task without any
> relationship on one cpu. Do you know any better solution ?

How do you know the task is 'small' ?

For that you would need to track a time-weighted effective load average
of the task and we don't have that.

[ how bad is all this u64 math on ARM btw? and when will ARM finally
  agree all this 32bit nonsense is a waste of time and silicon? ]

But yeah, the whole nr_running vs capacity thing was traditionally to
deal with spreading single tasks around. And traditional power aware
scheduling was mostly about packing those on sockets (keeps other
sockets idle) instead of spreading them around sockets (optimizes
cache).

Now I wouldn't at all mind you ripping out all that
sched_*_power_savings crap and replacing it, I doubt it actually works
anyway. I haven't got many patches on the subject, and I know I don't
have the equipment to measure power usage.

Also, the few patches I got mostly made the sched_*_power_savings mess
bigger, which I refuse to do (what sysad wants to have a 27-state space
to configure his power aware scheduling). This has mostly made people go
away instead of fixing things up :-(

As to what the replacement would have to look like, dunno, its not
something I've really thought much about, but maybe the time-weighted
stuff is the only sane approach, that combined with options on how to
spread tasks (core, socket, node, etc..).

I really think changing the load-balancer is the right way to go about
solving your power issue (hot-plugging a cpu really is an insane way to
idle a core) and I'm open to discussing what would work for you.

All I really ask is to not cobble something together, the load-balancer
is a horridly complex thing already and the last thing it needs is more
special cases that don't interact properly.


