Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab0KKTJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 14:09:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:42338 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252Ab0KKTJM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:09:12 -0500
Subject: Re: [PATCH 1/3] perf-events: Add support for supplementary event
 registers
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu,
        acme@redhat.com, eranian@google.com, Andi Kleen <ak@linux.intel.com>
In-Reply-To: <1289492117-18066-1-git-send-email-andi@firstfloor.org>
References: <1289492117-18066-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Nov 2010 20:09:14 +0100
Message-ID: <1289502554.2084.153.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 17:15 +0100, Andi Kleen wrote:

> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index ed63101..97133ec 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -93,6 +93,8 @@ struct amd_nb {
>  	struct event_constraint event_constraints[X86_PMC_IDX_MAX];
>  };
>  
> +struct intel_percore;
> +
>  #define MAX_LBR_ENTRIES		16
>  
>  struct cpu_hw_events {
> @@ -126,6 +128,8 @@ struct cpu_hw_events {
>  	void				*lbr_context;
>  	struct perf_branch_stack	lbr_stack;
>  	struct perf_branch_entry	lbr_entries[MAX_LBR_ENTRIES];

There wants to be a comment here, this is definitely not LBR stuff.

> +	int 				percore_used;
> +	struct intel_percore		*per_core;

Either per_core != NULL implies percore_used or it should be state
inside the struct.

>  
>  	/*
>  	 * AMD specific bits
> @@ -175,6 +179,24 @@ struct cpu_hw_events {
>  #define for_each_event_constraint(e, c)	\
>  	for ((e) = (c); (e)->weight; (e)++)
>  
> +/*
> + * Extra registers for specific events.
> + * Some events need large masks and require external MSRs.
> + * Define a mapping to these extra registers.
> + */
> +
> +struct extra_reg {
> +	unsigned event;
> +	unsigned msr;
> +	u64 config_mask;
> +	u64 valid_mask;
> +};

s/unsigned/unsigned int/ (also later in the patch) and then align the
variable names.

> +
> +#define EVENT_EXTRA_REG(event, msr, m, vm) { event, msr, m, vm }

C99 initializers please

> +#define INTEL_EVENT_EXTRA_REG(event, msr, vm) \
> +	EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT, vm)
> +#define EVENT_EXTRA_END {}

Does that imply a zero filled struct?

> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index c8f5c08..bbe7fba 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -1,5 +1,14 @@
>  #ifdef CONFIG_CPU_SUP_INTEL
>  
> +struct intel_percore {
> +	raw_spinlock_t lock;
> +	int ref;
> +	u64 config;
> +	unsigned extra_reg;
> +	u64 extra_config;
> +};
> +static DEFINE_PER_CPU(struct intel_percore, intel_percore);

Please dynamically allocate these when needed, just like the AMD
north-bridge structure.

>  /*
>   * Intel PerfMon, used on Core and later.
>   */

> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 057bf22..a353594 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -224,7 +224,10 @@ struct perf_event_attr {
>  	};
>  
>  	__u32			bp_type;
> -	__u64			bp_addr;
> +	union {
> +		__u64			bp_addr;
> +		__u64		        event_extra; /* Extra for some events */
> +	};
>  	__u64			bp_len;
>  };

I think I like Stephane's suggestion better, frob them into the existing
u64 word, since its model specific and we still have 33 empty bits in
the control register there's plenty space.



