Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab2B0Lji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 06:39:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:59018 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab2B0Ljh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 06:39:37 -0500
Message-ID: <1330342762.11248.69.camel@twins>
Subject: Re: [PATCH] perf_event use rdpmc rather than rdmsr when possible in
 kernel
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>
Date: Mon, 27 Feb 2012 12:39:22 +0100
In-Reply-To: <alpine.DEB.2.00.1202201722120.2753@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1202201722120.2753@cl320.eecs.utk.edu>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-20 at 17:38 -0500, Vince Weaver wrote:

> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 5adce10..5550047 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -85,7 +85,7 @@ u64 x86_perf_event_update(struct perf_event *event)
>  	 */
>  again:
>  	prev_raw_count = local64_read(&hwc->prev_count);
> -	rdmsrl(hwc->event_base, new_raw_count);
> +	new_raw_count=native_read_pmc(hwc->event_base_rdpmc);

That really wants to be rdpmc(), bypassing paravirt like that isn't
nice.

>  
>  	if (local64_cmpxchg(&hwc->prev_count, prev_raw_count,
>  					new_raw_count) != prev_raw_count)
> @@ -768,9 +768,11 @@ static inline void x86_assign_hw_event(struct perf_event *event,
>  	} else if (hwc->idx >= X86_PMC_IDX_FIXED) {
>  		hwc->config_base = MSR_ARCH_PERFMON_FIXED_CTR_CTRL;
>  		hwc->event_base = MSR_ARCH_PERFMON_FIXED_CTR0 + (hwc->idx - X86_PMC_IDX_FIXED);
> +		hwc->event_base_rdpmc = (hwc->idx - X86_PMC_IDX_FIXED) | 1<<30;
>  	} else {
>  		hwc->config_base = x86_pmu_config_addr(hwc->idx);
>  		hwc->event_base  = x86_pmu_event_addr(hwc->idx);
> +		hwc->event_base_rdpmc = x86_pmu_addr_offset(hwc->idx);
>  	}
>  }
>  
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index abb2776..432ac69 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -562,6 +562,7 @@ struct hw_perf_event {
>  			u64		last_tag;
>  			unsigned long	config_base;
>  			unsigned long	event_base;
> +			unsigned long	event_base_rdpmc;

We could make that unsigned int, the SDM explicitly states
rdmsr/wrmsr/rdpmc take ECX (and ignore the upper 32bits RCX).

>  			int		idx;
>  			int		last_cpu;
>  			struct hw_perf_event_extra extra_reg;

But yeah, avoiding the extra variable will add a conditional and extra
instructions to the rdpmc path.
