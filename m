Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab2KPTcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 14:32:32 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42434 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab2KPTcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 14:32:31 -0500
Date: Fri, 16 Nov 2012 20:32:24 +0100
From: Robert Richter <rric@kernel.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] perf, amd: Enable northbridge performance counters
 on AMD family 15h
Message-ID: <20121116193224.GS2504@rric.localhost>
References: <1353015113-13262-1-git-send-email-jacob.shin@amd.com>
 <1353015113-13262-5-git-send-email-jacob.shin@amd.com>
 <20121116184344.GR2504@rric.localhost>
 <20121116190030.GA21468@jshin-Toonie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121116190030.GA21468@jshin-Toonie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.11.12 13:00:30, Jacob Shin wrote:
> On Fri, Nov 16, 2012 at 07:43:44PM +0100, Robert Richter wrote:
> > On 15.11.12 15:31:53, Jacob Shin wrote:
> > > @@ -156,31 +161,28 @@ static inline int amd_pmu_addr_offset(int index)
> > >  	if (offset)
> > >  		return offset;
> > >  
> > > -	if (!cpu_has_perfctr_core)
> > > +	if (!cpu_has_perfctr_core) {
> > >  		offset = index;
> > > -	else
> > > +		ncore = AMD64_NUM_COUNTERS;
> > > +	} else {

First calculation:

> > >  		offset = index << 1;
> > > +		ncore = AMD64_NUM_COUNTERS_CORE;
> > > +	}
> > > +
> > > +	/* find offset of NB counters with respect to x86_pmu.eventsel */
> > > +	if (cpu_has_perfctr_nb) {
> > > +		if (index >= ncore && index < (ncore + AMD64_NUM_COUNTERS_NB))

Second calculation:

> > > +			offset = (MSR_F15H_NB_PERF_CTL - x86_pmu.eventsel) +
> > > +				 ((index - ncore) << 1);
> > > +	}
> > 
> > There is duplicate calculatoin of offset in some cases. Better we
> > avoid this.
> 
> Which cases? The code calculates the offset for a given index the very
> first time it is called, stores it, and uses that stored offset from
> then on. My [PATCH 3/4] sets that up.

One case above.

It looks like the paths should be defined more clearly.

> > > @@ -323,6 +368,16 @@ __amd_get_nb_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *ev
> > >  	if (new == -1)
> > >  		return &emptyconstraint;
> > >  
> > > +	/* set up interrupts to be delivered only to this core */
> > > +	if (cpu_has_perfctr_nb) {
> > > +		struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
> > > +
> > > +		hwc->config |= AMD_PERFMON_EVENTSEL_INT_CORE_ENABLE;
> > > +		hwc->config &= ~AMD_PERFMON_EVENTSEL_INT_CORE_SEL_MASK;
> > > +		hwc->config |= (0ULL | (c->cpu_core_id)) <<
> > > +			AMD_PERFMON_EVENTSEL_INT_CORE_SEL_SHIFT;
> > > +	}
> > 
> > Looks like a hack to me. The constaints handler is only supposed to
> > determine constraints and not to touch anything in the event's
> > structure. This should be done later when setting up hwc->config in
> > amd_nb_event_config() or so.
> 
> Hm.. is the hwc->config called after constraints have been set up
> already? If so, I'll change it ..

Should be, since the hw register can be setup only after the counter
is selected.

> 
> > 
> > I also do not think that smp_processor_id() is the right thing to do
> > here. Since cpu_hw_events is per-cpu the cpu is already selected.
> 
> Yeah, I could not figure out how to get the cpu number from cpuc. Is
> there a container_of kind of thing that I can do to get the cpu number
> ?

At some point event->cpu is assigned, I think.

-Robert
