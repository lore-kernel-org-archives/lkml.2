Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab2K1Rmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 12:42:37 -0500
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:48556
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752324Ab2K1Rmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 12:42:36 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432I4015Izz1de0h1202h1d1ah1d2ahzzz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1155h)
X-WSS-ID: 0ME7L6M-02-16K-02
X-M-MSG: 
Date: Wed, 28 Nov 2012 11:42:20 -0600
From: Jacob Shin <jacob.shin@amd.com>
To: Robert Richter <rric@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] perf, amd: Enable northbridge performance counters
 on AMD family 15h
Message-ID: <20121128174220.GD4581@jshin-Toonie>
References: <1353015113-13262-1-git-send-email-jacob.shin@amd.com>
 <1353015113-13262-5-git-send-email-jacob.shin@amd.com>
 <20121116184344.GR2504@rric.localhost>
 <20121116190030.GA21468@jshin-Toonie>
 <20121116193224.GS2504@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20121116193224.GS2504@rric.localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert,

On Fri, Nov 16, 2012 at 08:32:24PM +0100, Robert Richter wrote:
> On 16.11.12 13:00:30, Jacob Shin wrote:
> > On Fri, Nov 16, 2012 at 07:43:44PM +0100, Robert Richter wrote:
> > > On 15.11.12 15:31:53, Jacob Shin wrote:
> > > > @@ -323,6 +368,16 @@ __amd_get_nb_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *ev
> > > >  	if (new == -1)
> > > >  		return &emptyconstraint;
> > > >  
> > > > +	/* set up interrupts to be delivered only to this core */
> > > > +	if (cpu_has_perfctr_nb) {
> > > > +		struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
> > > > +
> > > > +		hwc->config |= AMD_PERFMON_EVENTSEL_INT_CORE_ENABLE;
> > > > +		hwc->config &= ~AMD_PERFMON_EVENTSEL_INT_CORE_SEL_MASK;
> > > > +		hwc->config |= (0ULL | (c->cpu_core_id)) <<
> > > > +			AMD_PERFMON_EVENTSEL_INT_CORE_SEL_SHIFT;
> > > > +	}
> > > 
> > > Looks like a hack to me. The constaints handler is only supposed to
> > > determine constraints and not to touch anything in the event's
> > > structure. This should be done later when setting up hwc->config in
> > > amd_nb_event_config() or so.
> > 
> > Hm.. is the hwc->config called after constraints have been set up
> > already? If so, I'll change it ..
> 
> Should be, since the hw register can be setup only after the counter
> is selected.

Ahh .. looking at this further, it looks like ->config is called
before constraints are set up (before we know what cpu we are going to
run on).

Sorry for not seeing this sooner, but it really looks like the event
constraints function is the right time to set up the INT_CORE_SEL bits
. Are you okay with this?

> > > I also do not think that smp_processor_id() is the right thing to do
> > > here. Since cpu_hw_events is per-cpu the cpu is already selected.
> > 
> > Yeah, I could not figure out how to get the cpu number from cpuc. Is
> > there a container_of kind of thing that I can do to get the cpu number
> > ?
> 
> At some point event->cpu is assigned, I think.

Furthermore, event->cpu can only be used if --cpu flag is specified
from userlan, otherwise event->cpu is 0xffff. And we do not know until
the schedule happens, what cpu we are going to be running on.

I tried to figure out if there was a way to get from cpu_hw_events to
a cpu number, but I didn't see any obvious ways. The cpu_hw_events is
derived from __get_cpu_var from the schedule function that calls the
constraints, so smp_processor_id seems okay to use here.

..

So I'll have to change things back, unless do you have any other
ideas ?

Thanks,

-Jacob

> 
> -Robert
> 

