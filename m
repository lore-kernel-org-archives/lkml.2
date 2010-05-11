Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932851Ab0EKGWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 02:22:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:43858 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932805Ab0EKGWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 02:22:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,205,1272870000"; 
   d="scan'208";a="797283172"
Subject: Re: [rfc] x86,perf: P4 PMU -- use hash for p4_get_escr_idx
From: Lin Ming <ming.m.lin@intel.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20100510152708.GS5104@lenovo>
References: <20100510152708.GS5104@lenovo>
Content-Type: text/plain
Date: Tue, 11 May 2010 14:21:19 +0800
Message-Id: <1273558879.30322.8.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 23:27 +0800, Cyrill Gorcunov wrote:
> Hi Ming,
> 
> could you give this patch a shot if possible? Compile
> tested only. I would appreciate review and complains
> as well :) I know you're busy with other perf task
> so there is no hurry. Just to share the patch as early
> as possible.

Hi, 

I'm going to test this patch, but current tip/master(c6661c5) seems has
problem.

When I run perf top, it shows

Message from syslogd@dell12 at May 11 13:44:38 ...
 kernel: Dazed and confused, but trying to continue

Message from syslogd@dell12 at May 11 13:44:38 ...
 kernel: Do you have a strange power saving mode enabled?

Message from syslogd@dell12 at May 11 13:44:38 ...
 kernel: Uhhuh. NMI received for unknown reason 00 on CPU 1.

Message from syslogd@dell12 at May 11 13:44:38 ...
 kernel: Do you have a strange power saving mode enabled?

Message from syslogd@dell12 at May 11 13:44:38 ...
 kernel: Uhhuh. NMI received for unknown reason 31 on CPU 0.

Message from syslogd@dell12 at May 11 13:44:38 ...
 kernel: Dazed and confused, but trying to continue

> 
> Have CC'ed a number of people involved in P4 as well ;)
> 
> 	-- Cyrill
> ---
> 
> x86,perf: P4 PMU -- use hash for p4_get_escr_idx
> 
> Linear search over all p4 MSRs should be fine if only
> we would not use it in events scheduling routine which
> is pretty time crititcal. Lets use hashes. It should speed
> scheduling up significantly.
> 
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: Lin Ming <ming.m.lin@intel.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>  arch/x86/kernel/cpu/perf_event_p4.c |  123 +++++++++++++++++++-----------------
>  1 file changed, 67 insertions(+), 56 deletions(-)
> 
> Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
> +++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> @@ -668,66 +668,77 @@ static void p4_pmu_swap_config_ts(struct
>  	}
>  }
>  
> -/* ESCRs are not sequential in memory so we need a map */
> -static const unsigned int p4_escr_map[ARCH_P4_TOTAL_ESCR] = {
> -	MSR_P4_ALF_ESCR0,	/*  0 */
> -	MSR_P4_ALF_ESCR1,	/*  1 */
> -	MSR_P4_BPU_ESCR0,	/*  2 */
> -	MSR_P4_BPU_ESCR1,	/*  3 */
> -	MSR_P4_BSU_ESCR0,	/*  4 */
> -	MSR_P4_BSU_ESCR1,	/*  5 */
> -	MSR_P4_CRU_ESCR0,	/*  6 */
> -	MSR_P4_CRU_ESCR1,	/*  7 */
> -	MSR_P4_CRU_ESCR2,	/*  8 */
> -	MSR_P4_CRU_ESCR3,	/*  9 */
> -	MSR_P4_CRU_ESCR4,	/* 10 */
> -	MSR_P4_CRU_ESCR5,	/* 11 */
> -	MSR_P4_DAC_ESCR0,	/* 12 */
> -	MSR_P4_DAC_ESCR1,	/* 13 */
> -	MSR_P4_FIRM_ESCR0,	/* 14 */
> -	MSR_P4_FIRM_ESCR1,	/* 15 */
> -	MSR_P4_FLAME_ESCR0,	/* 16 */
> -	MSR_P4_FLAME_ESCR1,	/* 17 */
> -	MSR_P4_FSB_ESCR0,	/* 18 */
> -	MSR_P4_FSB_ESCR1,	/* 19 */
> -	MSR_P4_IQ_ESCR0,	/* 20 */
> -	MSR_P4_IQ_ESCR1,	/* 21 */
> -	MSR_P4_IS_ESCR0,	/* 22 */
> -	MSR_P4_IS_ESCR1,	/* 23 */
> -	MSR_P4_ITLB_ESCR0,	/* 24 */
> -	MSR_P4_ITLB_ESCR1,	/* 25 */
> -	MSR_P4_IX_ESCR0,	/* 26 */
> -	MSR_P4_IX_ESCR1,	/* 27 */
> -	MSR_P4_MOB_ESCR0,	/* 28 */
> -	MSR_P4_MOB_ESCR1,	/* 29 */
> -	MSR_P4_MS_ESCR0,	/* 30 */
> -	MSR_P4_MS_ESCR1,	/* 31 */
> -	MSR_P4_PMH_ESCR0,	/* 32 */
> -	MSR_P4_PMH_ESCR1,	/* 33 */
> -	MSR_P4_RAT_ESCR0,	/* 34 */
> -	MSR_P4_RAT_ESCR1,	/* 35 */
> -	MSR_P4_SAAT_ESCR0,	/* 36 */
> -	MSR_P4_SAAT_ESCR1,	/* 37 */
> -	MSR_P4_SSU_ESCR0,	/* 38 */
> -	MSR_P4_SSU_ESCR1,	/* 39 */
> -	MSR_P4_TBPU_ESCR0,	/* 40 */
> -	MSR_P4_TBPU_ESCR1,	/* 41 */
> -	MSR_P4_TC_ESCR0,	/* 42 */
> -	MSR_P4_TC_ESCR1,	/* 43 */
> -	MSR_P4_U2L_ESCR0,	/* 44 */
> -	MSR_P4_U2L_ESCR1,	/* 45 */
> +/*
> + * ESCR address hashing is tricky, ESCRs are not sequential
> + * in memory but all starts from MSR_P4_BSU_ESCR0 (0x03e0) and
> + * the metric between any ESCRs is laid in range [0xa0,0xe1]
> + *
> + * so we make ~70% filled hashtable
> + */
> +
> +#define P4_ESCR_MSR_BASE		0x000003a0
> +#define P4_ESCR_MSR_MAX			0x000003e1
> +#define P4_ESCR_MSR_TABLE_SIZE		(P4_ESCR_MSR_MAX - P4_ESCR_MSR_BASE + 1)
> +#define P4_ESCR_MSR_IDX(msr)		(msr - P4_ESCR_MSR_BASE)
> +#define P4_ESCR_MSR_TABLE_ENTRY(msr)	[P4_ESCR_MSR_IDX(msr)] = msr
> +
> +static const unsigned int p4_escr_table[P4_ESCR_MSR_TABLE_SIZE] = {
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_ALF_ESCR0),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_ALF_ESCR1),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_BPU_ESCR0),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_BPU_ESCR1),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_BSU_ESCR0),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_BSU_ESCR1),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_CRU_ESCR0),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_CRU_ESCR1),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_CRU_ESCR2),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_CRU_ESCR3),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_CRU_ESCR4),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_CRU_ESCR5),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_DAC_ESCR0),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_DAC_ESCR1),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_FIRM_ESCR0),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_FIRM_ESCR1),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_FLAME_ESCR0),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_FLAME_ESCR1),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_FSB_ESCR0),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_FSB_ESCR1),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_IQ_ESCR0),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_IQ_ESCR1),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_IS_ESCR0),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_IS_ESCR1),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_ITLB_ESCR0),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_ITLB_ESCR1),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_IX_ESCR0),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_IX_ESCR1),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_MOB_ESCR0),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_MOB_ESCR1),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_MS_ESCR0),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_MS_ESCR1),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_PMH_ESCR0),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_PMH_ESCR1),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_RAT_ESCR0),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_RAT_ESCR1),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_SAAT_ESCR0),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_SAAT_ESCR1),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_SSU_ESCR0),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_SSU_ESCR1),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_TBPU_ESCR0),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_TBPU_ESCR1),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_TC_ESCR0),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_TC_ESCR1),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_U2L_ESCR0),
> +	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_U2L_ESCR1),
>  };
>  
>  static int p4_get_escr_idx(unsigned int addr)
>  {
> -	unsigned int i;
> +	unsigned int idx = P4_ESCR_MSR_IDX(addr);
>  
> -	for (i = 0; i < ARRAY_SIZE(p4_escr_map); i++) {
> -		if (addr == p4_escr_map[i])
> -			return i;
> -	}
> +	BUG_ON(idx >= P4_ESCR_MSR_TABLE_SIZE);
> +	BUG_ON(!p4_escr_table[idx]);
>  
> -	return -1;
> +	return idx;
>  }
>  
>  static int p4_next_cntr(int thread, unsigned long *used_mask,
> @@ -747,7 +758,7 @@ static int p4_next_cntr(int thread, unsi
>  static int p4_pmu_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
>  {
>  	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
> -	unsigned long escr_mask[BITS_TO_LONGS(ARCH_P4_TOTAL_ESCR)];
> +	unsigned long escr_mask[BITS_TO_LONGS(P4_ESCR_MSR_TABLE_SIZE)];
>  	int cpu = raw_smp_processor_id();
>  	struct hw_perf_event *hwc;
>  	struct p4_event_bind *bind;
> @@ -755,7 +766,7 @@ static int p4_pmu_schedule_events(struct
>  	int cntr_idx, escr_idx;
>  
>  	bitmap_zero(used_mask, X86_PMC_IDX_MAX);
> -	bitmap_zero(escr_mask, ARCH_P4_TOTAL_ESCR);
> +	bitmap_zero(escr_mask, P4_ESCR_MSR_TABLE_SIZE);
>  
>  	for (i = 0, num = n; i < n; i++, num--) {
>  

