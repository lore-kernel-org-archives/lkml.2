Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759407Ab0EFSci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 14:32:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52029 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759362Ab0EFScf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 14:32:35 -0400
X-Authority-Analysis: v=1.1 cv=OMZqYO3L41gFG4eI735GctFZkIqa2t9YKv4cWfI71LE= c=1 sm=0 a=t3i6yefhEEwA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=Tk-uERMGYb6i1njx_SwA:9 a=954CgXezdE0Et1hZoCwA:7 a=mcuNmC4Q9Co-Gv_X3p32l1_c4rsA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH -tip] x86,perf: P4 PMU -- protect sensible procedures
 from preemption
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20100506152646.GC5583@lenovo>
References: <20100505150740.GB5686@lenovo> <20100505165731.GA6320@nowhere>
	 <20100505174234.GH5686@lenovo> <20100506064453.GI1172@elte.hu>
	 <w2vaa79d98a1005060039ua7dd1b0t952fcd8662d4d759@mail.gmail.com>
	 <20100506074231.GA8625@elte.hu>
	 <n2maa79d98a1005060045ke0f87f4aw8b86da0440a019b3@mail.gmail.com>
	 <1273153525.22438.39.camel@gandalf.stny.rr.com>
	 <20100506144854.GB5583@lenovo>  <20100506152646.GC5583@lenovo>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 06 May 2010 14:32:33 -0400
Message-ID: <1273170753.22438.45.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-06 at 19:26 +0400, Cyrill Gorcunov wrote:
> On Thu, May 06, 2010 at 06:48:54PM +0400, Cyrill Gorcunov wrote:
> > On Thu, May 06, 2010 at 09:45:24AM -0400, Steven Rostedt wrote:
> > ...
> > > > > We want the one with the least runtime overhead. These are instrumentation
> > > > > routines, so we want to optimize them as much as possible.
> > > 
> > > 
> > > Yeah, my point was either disable preemption or keep the checks. In
> > > other words, if you don't disable preemption, do not use
> > > raw_smp_procesor_id(), because then we will not catch it if it changes
> > > in the future.
> > > 
> > > > ok, Ingo, dont apply this patch then for a while.
> > > 
> > > Send another patch, I'll test it again ;-)
> > > 
> > > -- Steve
> > > 
> > > 
> > 
> > Ingo, Steven, it seems we have potential preemtion available
> > in perf_event.c:validate_group:x86_pmu.schedule_events() which
> > is reached via syscall from userspace perf_event_open() call,
> > so get_cpu is still needed. But I'm a bit messed with call
> > graph at the moment :(
> > 
> > 	-- Cyrill
> 
> Steve, while I'm diving through call graph could you give this
> patch a shot? If preemtion happens -- it'll trigger it fast.

This one works too.

Tested-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> 
> 	-- Cyrill
> ---
>  arch/x86/kernel/cpu/perf_event_p4.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
> +++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> @@ -421,7 +421,7 @@ static u64 p4_pmu_event_map(int hw_event
>  
>  static int p4_hw_config(struct perf_event *event)
>  {
> -	int cpu = raw_smp_processor_id();
> +	int cpu = get_cpu();
>  	u32 escr, cccr;
>  
>  	/*
> @@ -440,7 +440,7 @@ static int p4_hw_config(struct perf_even
>  		event->hw.config = p4_set_ht_bit(event->hw.config);
>  
>  	if (event->attr.type != PERF_TYPE_RAW)
> -		return 0;
> +		goto out;
>  
>  	/*
>  	 * We don't control raw events so it's up to the caller
> @@ -455,6 +455,8 @@ static int p4_hw_config(struct perf_even
>  		(p4_config_pack_escr(P4_ESCR_MASK_HT) |
>  		 p4_config_pack_cccr(P4_CCCR_MASK_HT));
>  
> +out:
> +	put_cpu();
>  	return 0;
>  }
>  
> @@ -741,7 +743,7 @@ static int p4_pmu_schedule_events(struct
>  {
>  	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
>  	unsigned long escr_mask[BITS_TO_LONGS(ARCH_P4_TOTAL_ESCR)];
> -	int cpu = raw_smp_processor_id();
> +	int cpu = smp_processor_id();
>  	struct hw_perf_event *hwc;
>  	struct p4_event_bind *bind;
>  	unsigned int i, thread, num;


