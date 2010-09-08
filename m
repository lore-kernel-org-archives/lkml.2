Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab0IHNvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 09:51:42 -0400
Received: from www.tglx.de ([62.245.132.106]:36514 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163Ab0IHNvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 09:51:41 -0400
Date: Wed, 8 Sep 2010 15:50:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
        Robert Richter <robert.richter@amd.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Yanmin <yanmin_zhang@linux.intel.com>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 13/19] perf: Per cpu-context rotation timer
In-Reply-To: <1283880975.1930.1662.camel@laptop>
Message-ID: <alpine.LFD.2.00.1009081547270.2477@localhost6.localdomain6>
References: <20100907164633.879932949@chello.nl>  <20100907165011.939993481@chello.nl> <1283879247.1930.1629.camel@laptop>  <alpine.LFD.2.00.1009071932540.2477@localhost6.localdomain6> <1283880975.1930.1662.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Sep 2010, Peter Zijlstra wrote:

> On Tue, 2010-09-07 at 19:33 +0200, Thomas Gleixner wrote:
> > On Tue, 7 Sep 2010, Peter Zijlstra wrote:
> > 
> > > On Tue, 2010-09-07 at 18:46 +0200, Peter Zijlstra wrote:
> > > 
> > > > @@ -5904,6 +5930,9 @@ static void __init perf_event_init_all_c
> > > >  
> > > >                 cpuctx = &per_cpu(perf_cpu_context, cpu);
> > > >                 __perf_event_init_context(&cpuctx->ctx, NULL);
> > > > +               cpuctx->timer_interval = TICK_NSEC;
> > > > +               hrtimer_init(&cpuctx->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> > > > +               cpuctx->timer.function = perf_event_context_tick;
> > > >         }
> > > 
> > > > +static void perf_pmu_rotate_start(struct pmu *pmu)
> > > > +{
> > > > +       struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
> > > > +
> > > > +       if (hrtimer_active(&cpuctx->timer))
> > > > +               return;
> > > > +
> > > > +       __hrtimer_start_range_ns(&cpuctx->timer,
> > > > +                       ns_to_ktime(cpuctx->timer_interval), 0,
> > > > +                       HRTIMER_MODE_REL, 0);
> > > >  } 
> > > 
> > > This probably wants a fuzz factor that lets it fold into the tick we
> > > already have. Thomas what's the easiest way to do that, give it a soft
> > > limit of 1ns and hardlimit of TICK_NSEC?
> > 
> > Hmm, why don't you hang it off the tick right away ?
> 
> Because some people (Corey) want to be able to have different rotation
> periods per pmu driver, so a timer per context was the easy way out.

Makes sense. If you want it fully aligned with the tick, then you just
might get the real tick time from the tick code and make it proper
aligned.

Thanks,

	tglx
