Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758452Ab2ERQYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:24:52 -0400
Received: from service87.mimecast.com ([91.220.42.44]:51114 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757931Ab2ERQYt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:24:49 -0400
Date: Fri, 18 May 2012 17:24:45 +0100
From: Morten Rasmussen <Morten.Rasmussen@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "panto@antoniou-consulting.com" <panto@antoniou-consulting.com>,
        "smuckle@quicinc.com" <smuckle@quicinc.com>,
        Juri Lelli <juri.lelli@gmail.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "linaro-sched-sig@lists.linaro.org" 
	<linaro-sched-sig@lists.linaro.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "geoff@infradead.org" <geoff@infradead.org>,
        "efault@gmx.de" <efault@gmx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
Message-ID: <20120518162445.GF18312@e103034-lin.cambridge.arm.com>
References: <CAKfTPtDSDAOAdv0GTDswZeRM7TmACrjok+5kddSaQpvy6_6xWw@mail.gmail.com>
 <CAKfTPtCfiY7A29+e50F+6awd8BjNJjg4=uNN4ReZfdS_4FbpkA@mail.gmail.com>
 <1337084609.27020.156.camel@laptop>
 <CAKfTPtDz1-fR2i5x7AVd8sGZhX2VNtz2rnQC3ePrcHO9MWK3FQ@mail.gmail.com>
 <1337086834.27020.162.camel@laptop>
 <CAKfTPtDrZ-tfC81jnxwpB+DCtmxhU+VfoYbtSBr8MkFt+P8JcA@mail.gmail.com>
 <1337096141.27694.82.camel@twins>
 <20120518161817.GE18312@e103034-lin.cambridge.arm.com>
MIME-Version: 1.0
In-Reply-To: <20120518161817.GE18312@e103034-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 18 May 2012 16:24:50.0121 (UTC) FILETIME=[BF71EB90:01CD3512]
X-MC-Unique: 112051817244708201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 05:18:17PM +0100, Morten Rasmussen wrote:
> On Tue, May 15, 2012 at 04:35:41PM +0100, Peter Zijlstra wrote:
> > On Tue, 2012-05-15 at 17:05 +0200, Vincent Guittot wrote:
> > > On 15 May 2012 15:00, Peter Zijlstra <peterz@infradead.org> wrote:
> > > > On Tue, 2012-05-15 at 14:57 +0200, Vincent Guittot wrote:
> > > >>
> > > >> Not sure that nobody cares but it's much more that scheduler,
> > > >> load_balance and sched_mc are sensible enough that it's difficult to
> > > >> ensure that a modification will not break everything for someone
> > > >> else.
> > > >
> > > > Thing is, its already broken, there's nothing else to break :-)
> > > >
> > > 
> > > sched_mc is the only power-aware knob in the current scheduler. It's
> > > far from being perfect but it seems to work on some ARM platform at
> > > least. You mentioned at the scheduler mini-summit that we need a
> > > cleaner replacement and everybody has agreed on that point. Is anybody
> > > working on it yet ? 
> > 
> > Apparently not.. 
> > 
> > > and can we discuss at Plumber's what this replacement would look like ?
> > 
> > one knob: sched_balance_policy with tri-state {performance, power, auto}
> 
> Interesting. What would the power policy look like? Would performance
> and power be the two extremes of the power/performance trade-off? In
> that case I would assume that most embedded systems would be using auto.
> 
> > 
> > Where auto should likely look at things like are we on battery and
> > co-ordinate with cpufreq muck or whatever.
> > 
> > Per domain knobs are insane, large multi-state knobs are insane, the
> > existing scheme is therefore insane^2. Can you find a sysad who'd like
> > to explore 3^3=27 states for optimal power/perf for his workload on a
> > simple 2 socket hyper-threaded machine and 3^4=81 state space for 8
> > sockets etc..?
> > 
> > As to the exact policy, I think the current 2 (load-balance + wakeup) is
> > the sensible one..
> > 
> > Also, I still have this pending email from you asking about the topology
> > setup stuff I really need to reply to.. but people keep sending me bugs
> > reports :/
> > 
> > But really short, look at kernel/sched/core.c:default_topology[]
> > 
> > I'd like to get rid of sd_init_* into a single function like
> > sd_numa_init(), this would mean all archs would need to do is provide a
> > simple list of ever increasing masks that match their topology.
> > 
> > To aid this we can add some SDTL_flags, initially I was thinking of:
> > 
> >  SDTL_SHARE_CORE	-- aka SMT
> >  SDTL_SHARE_CACHE	-- LLC cache domain (typically multi-core)
> >  SDTL_SHARE_MEMORY	-- NUMA-node (typically socket)
> > 
> > The 'performance' policy is typically to spread over shared resources so
> > as to minimize contention on these.
> >
> 
> Would it be worth extending this architecture specification to contain
> more information like CPU_POWER for each core? After having experimented
> a bit with scheduling on big.LITTLE my experience is that more
> information about the platform is needed to make proper scheduling
> decisions. So if the topology definition is going to be more generic and
> be set up by the architecture it could be worth adding all the bits of
> information that the scheduler would need to that data structure.
> 
> With such data structure, the scheduler would only need one knob to
> adjust the power/performance trade-off. Any thoughts?
>  

One more thing. I have experimented with PJT's load-tracking patchset
and found it very useful for big.LITTLE scheduling. Is there any plans
for including them?

	Morten

> > If you want to add some power we need some extra flags, maybe something
> > like:
> > 
> >  SDTL_SHARE_POWERLINE	-- power domain (typically socket)
> > 
> > so you know where the boundaries are where you can turn stuff off so you
> > know what/where to pack bits.
> > 
> > Possibly we also add something like:
> > 
> >  SDTL_PERF_SPREAD	-- spread on performance mode
> >  SDTL_POWER_PACK	-- pack on power mode
> > 
> > To over-ride the defaults. But ideally I'd leave those until after we've
> > got the basics working and there is a clear need for them (with a
> > spread/pack default for perf/power aware).
> 
> In my experience power optimized scheduling is quite tricky, especially
> if you still want some level of performance. For heterogeneous
> architecture packing might not be the best solution. Some indication of
> the power/performance profile of each core could be useful.
> 
> Best regards,
> Morten
> 
> 
> _______________________________________________
> linaro-sched-sig mailing list
> linaro-sched-sig@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-sched-sig
> 

