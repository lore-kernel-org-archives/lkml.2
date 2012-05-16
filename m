Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664Ab2EPVVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 17:21:00 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:57671 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162Ab2EPVU7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 17:20:59 -0400
MIME-Version: 1.0
In-Reply-To: <1337096141.27694.82.camel@twins>
References: <CAKfTPtDSDAOAdv0GTDswZeRM7TmACrjok+5kddSaQpvy6_6xWw@mail.gmail.com>
	<CAKfTPtCfiY7A29+e50F+6awd8BjNJjg4=uNN4ReZfdS_4FbpkA@mail.gmail.com>
	<1337084609.27020.156.camel@laptop>
	<CAKfTPtDz1-fR2i5x7AVd8sGZhX2VNtz2rnQC3ePrcHO9MWK3FQ@mail.gmail.com>
	<1337086834.27020.162.camel@laptop>
	<CAKfTPtDrZ-tfC81jnxwpB+DCtmxhU+VfoYbtSBr8MkFt+P8JcA@mail.gmail.com>
	<1337096141.27694.82.camel@twins>
Date: Wed, 16 May 2012 23:20:57 +0200
Message-ID: <CAKfTPtAxG9JQEV-Y5b6=J50w66mS8_C6jjnD7T47tdQp1XBKKQ@mail.gmail.com>
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulmck@linux.vnet.ibm.com, smuckle@quicinc.com, khilman@ti.com,
        Robin.Randhawa@arm.com, suresh.b.siddha@intel.com,
        thebigcorporation@gmail.com, venki@google.com,
        panto@antoniou-consulting.com, mingo@elte.hu, paul.brett@intel.com,
        pdeschrijver@nvidia.com, pjt@google.com, efault@gmx.de,
        fweisbec@gmail.com, geoff@infradead.org, rostedt@goodmis.org,
        tglx@linutronix.de, amit.kucheria@linaro.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linaro-sched-sig@lists.linaro.org,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Juri Lelli <juri.lelli@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 May 2012 17:35, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2012-05-15 at 17:05 +0200, Vincent Guittot wrote:
>> On 15 May 2012 15:00, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Tue, 2012-05-15 at 14:57 +0200, Vincent Guittot wrote:
>> >>
>> >> Not sure that nobody cares but it's much more that scheduler,
>> >> load_balance and sched_mc are sensible enough that it's difficult to
>> >> ensure that a modification will not break everything for someone
>> >> else.
>> >
>> > Thing is, its already broken, there's nothing else to break :-)
>> >
>>
>> sched_mc is the only power-aware knob in the current scheduler. It's
>> far from being perfect but it seems to work on some ARM platform at
>> least. You mentioned at the scheduler mini-summit that we need a
>> cleaner replacement and everybody has agreed on that point. Is anybody
>> working on it yet ?
>
> Apparently not..
>
>> and can we discuss at Plumber's what this replacement would look like ?
>
> one knob: sched_balance_policy with tri-state {performance, power, auto}
>
> Where auto should likely look at things like are we on battery and
> co-ordinate with cpufreq muck or whatever.

IIUC performance and power will be platform and architecture agnostic
and will only rely on a "simple" cpu topology description and auto
mode would exchange information with framework like cpufreq which can
provide some platform specific information like a clock rate
dependency.

>
> Per domain knobs are insane, large multi-state knobs are insane, the
> existing scheme is therefore insane^2. Can you find a sysad who'd like
> to explore 3^3=27 states for optimal power/perf for his workload on a
> simple 2 socket hyper-threaded machine and 3^4=81 state space for 8
> sockets etc..?
>
> As to the exact policy, I think the current 2 (load-balance + wakeup) is
> the sensible one..
>
> Also, I still have this pending email from you asking about the topology
> setup stuff I really need to reply to.. but people keep sending me bugs
> reports :/
>

I'm interested to get feedback when you will have time

> But really short, look at kernel/sched/core.c:default_topology[]
>
> I'd like to get rid of sd_init_* into a single function like
> sd_numa_init(), this would mean all archs would need to do is provide a
> simple list of ever increasing masks that match their topology.
>
> To aid this we can add some SDTL_flags, initially I was thinking of:
>
>  SDTL_SHARE_CORE        -- aka SMT
>  SDTL_SHARE_CACHE       -- LLC cache domain (typically multi-core)
>  SDTL_SHARE_MEMORY      -- NUMA-node (typically socket)
>
> The 'performance' policy is typically to spread over shared resources so
> as to minimize contention on these.
>
> If you want to add some power we need some extra flags, maybe something
> like:
>
>  SDTL_SHARE_POWERLINE   -- power domain (typically socket)
>
> so you know where the boundaries are where you can turn stuff off so you
> know what/where to pack bits.

I'm not sure to see how this flag will be used compared to the others.
The first 3 SDTL_SHARE_XXX about topology are exclusive and described
different level of CPU but the SDTL_SHARE_POWERLINE could be used at
each level to describe is CPU in the sched_domain are sharing or not
the power domain

>
> Possibly we also add something like:
>
>  SDTL_PERF_SPREAD       -- spread on performance mode
>  SDTL_POWER_PACK        -- pack on power mode
>
> To over-ride the defaults. But ideally I'd leave those until after we've
> got the basics working and there is a clear need for them (with a
> spread/pack default for perf/power aware).
