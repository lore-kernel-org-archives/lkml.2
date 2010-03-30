Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab0C3QAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 12:00:08 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:27611
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754614Ab0C3QAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 12:00:05 -0400
X-SpamScore: -20
X-BigFish: VPS-20(zba6lz1432R98dN936eM62a3Lab9bhzz1202hzzz32i6bh2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0L03R3R-01-8O1-02
X-M-MSG: 
Date: Tue, 30 Mar 2010 17:59:49 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 0/3] perf/core, x86: unify perfctr bitmasks
Message-ID: <20100330155949.GJ11907@erda.amd.com>
References: <1269880612-25800-1-git-send-email-robert.richter@amd.com>
 <bd4cb8901003300311l4178891dvf1e63293a0ac51fe@mail.gmail.com>
 <20100330134145.GI11907@erda.amd.com>
 <bd4cb8901003300653lc8e414bp3930b03fee2fffbf@mail.gmail.com>
 <1269961255.5258.221.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1269961255.5258.221.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 30 Mar 2010 15:59:50.0076 (UTC) FILETIME=[072437C0:01CAD022]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.03.10 17:00:55, Peter Zijlstra wrote:
> On Tue, 2010-03-30 at 15:53 +0200, Stephane Eranian wrote:
> > > So, there are some ARCH_PERFMON_EVENTSEL_* masks that are Intel only,
> > > which is true for ARCH_PERFMON_EVENTSEL_ANY. And indead, the code
> > > should be checked for this. ARCH_PERFMON_EVENTSEL_ANY is always
> > > cleared on AMD cpus, so this code is ok. Actually the bit is cleared
> > 
> > Until AMD uses that bit too and you won't notice this test. This is a security
> > check specific to Intel and it should be in an Intel-specific function.
> > 
> > > for *all* cpus in x86_pmu_raw_event(), the code was and is broken for
> > > this.
> > >
> > Yes, needs to be authorized for any perfmon v3 and later revisions.
> 
> So how about something like this on top of Robert's patches?
> 
> ---
>  arch/x86/kernel/cpu/perf_event.c       |   16 ++++++----------
>  arch/x86/kernel/cpu/perf_event_amd.c   |    5 +++--
>  arch/x86/kernel/cpu/perf_event_intel.c |   15 ++++++++++++++-
>  arch/x86/kernel/cpu/perf_event_p4.c    |    5 +++--
>  4 files changed, 26 insertions(+), 15 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
> +++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
> @@ -201,7 +201,7 @@ struct x86_pmu {
>  	unsigned	eventsel;
>  	unsigned	perfctr;
>  	u64		(*event_map)(int);
> -	u64		(*raw_event)(u64);
> +	int		(*raw_event)(struct perf_event *event);
>  	int		max_events;
>  	int		num_counters;
>  	int		num_counters_fixed;
> @@ -445,9 +445,10 @@ static int x86_hw_config(struct perf_eve
>  	return 0;
>  }
>  
> -static u64 x86_pmu_raw_event(u64 hw_event)
> +static int x86_pmu_raw_event(struct perf_event *event)
>  {
> -	return hw_event & X86_RAW_EVENT_MASK;
> +	event->hw.config |= event->attr.config & X86_RAW_EVENT_MASK;

This still clears the ANY bit. See below.

> +	return 0;
>  }
>  
>  /*
> @@ -511,13 +512,8 @@ static int __hw_perf_event_init(struct p
>  	/*
>  	 * Raw hw_event type provide the config in the hw_event structure
>  	 */
> -	if (attr->type == PERF_TYPE_RAW) {
> -		hwc->config |= x86_pmu.raw_event(attr->config);
> -		if ((hwc->config & ARCH_PERFMON_EVENTSEL_ANY) &&
> -		    perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
> -			return -EACCES;
> -		return 0;
> -	}
> +	if (attr->type == PERF_TYPE_RAW)
> +		return x86_pmu.raw_event(event);

We could go on with this and move this into *_hw_config(), but so far
this change is fine to me. This would then remove .raw_event() at all.

[...]

> Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel.c
> +++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -758,6 +758,19 @@ intel_get_event_constraints(struct cpu_h
>  	return x86_get_event_constraints(cpuc, event);
>  }
>  
> +static int intel_pmu_raw_event(struct perf_event *event)
> +{
> +	int ret = x86_pmu_raw_event(event);
> +	if (ret)
> +		return ret;
> +
> +	if ((event->hw.config & ARCH_PERFMON_EVENTSEL_ANY) &&
> +			perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
> +		return -EACCES;
> +
> +	return 0;

Maybe this?

	if (!(event->attr.config & ARCH_PERFMON_EVENTSEL_ANY))
		return 0;
	if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
		return -EACCES;
	event->hw.config |= ARCH_PERFMON_EVENTSEL_ANY;
	return 0;

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

