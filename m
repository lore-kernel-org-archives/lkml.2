Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449Ab1CBA4e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 19:56:34 -0500
Received: from mga11.intel.com ([192.55.52.93]:9974 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757226Ab1CBA4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 19:56:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,250,1297065600"; 
   d="scan'208";a="662849117"
Subject: Re: [PATCH] perf_events: update PEBS event constraints (v2)
From: Lin Ming <ming.m.lin@intel.com>
To: "eranian@google.com" <eranian@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "paulus@samba.org" <paulus@samba.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "perfmon2-devel@lists.sf.net" <perfmon2-devel@lists.sf.net>,
        "eranian@gmail.com" <eranian@gmail.com>,
        "robert.richter@amd.com" <robert.richter@amd.com>,
        "acme@redhat.com" <acme@redhat.com>
In-Reply-To: <4d6d636b.98a1df0a.15d8.57d1@mx.google.com>
References: <4d6d636b.98a1df0a.15d8.57d1@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Mar 2011 08:56:41 +0800
Message-ID: <1299027401.4937.106.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-02 at 04:20 +0800, Stephane Eranian wrote:
> This patch updates PEBS event constraints for Intel Atom, Nehalem, Westmere.
> 
> This patch also reorganizes the PEBS format/constraint detection code. It is
> now based on processor model and not PEBS format. Two processors may use the
> same PEBS format without have the same list of PEBS events.
> 
> In this second version, we simplified the initialization of the PEBS constraints
> by leveraging the existing switch() statement in perf_event_intel.c. We also
> renamed the constraint tables to be more consistent with regular constraints.

Hi, Stephane

Nice updates.
Wondering where did you get these PEBS event constraints? I didn't find
these in the latest manual.

And some small things, see below.

> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index 084b383..ddf6c4f 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -1024,6 +1024,7 @@ static __init int intel_pmu_init(void)
>  		intel_pmu_lbr_init_core();
>  
>  		x86_pmu.event_constraints = intel_core2_event_constraints;
> +		x86_pmu.pebs_constraints = intel_core2_pebs_event_constraints;
>  		pr_cont("Core2 events, ");
>  		break;
>  
> @@ -1036,6 +1037,7 @@ static __init int intel_pmu_init(void)
>  		intel_pmu_lbr_init_nhm();
>  
>  		x86_pmu.event_constraints = intel_nehalem_event_constraints;
> +		x86_pmu.pebs_constraints = intel_nehalem_pebs_event_constraints;
>  		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
>  		pr_cont("Nehalem events, ");
>  		break;
> @@ -1047,6 +1049,7 @@ static __init int intel_pmu_init(void)
>  		intel_pmu_lbr_init_atom();
>  
>  		x86_pmu.event_constraints = intel_gen_event_constraints;
> +		x86_pmu.pebs_constraints = intel_atom_pebs_event_constraints;
>  		pr_cont("Atom events, ");
>  		break;
>  
> @@ -1059,6 +1062,8 @@ static __init int intel_pmu_init(void)
>  
>  		x86_pmu.event_constraints = intel_westmere_event_constraints;
>  		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
> +		x86_pmu.pebs_constraints =
> +				intel_westmere_pebs_event_constraints;
>  		pr_cont("Westmere events, ");
>  		break;
>  
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> index b7dcd9f..916e6c7 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> @@ -361,30 +361,49 @@ static int intel_pmu_drain_bts_buffer(void)
>  /*
>   * PEBS
>   */
> -
> -static struct event_constraint intel_core_pebs_events[] = {
> +static struct event_constraint intel_core2_pebs_event_constraints[] = {
>  	PEBS_EVENT_CONSTRAINT(0x00c0, 0x1), /* INSTR_RETIRED.ANY */
>  	PEBS_EVENT_CONSTRAINT(0xfec1, 0x1), /* X87_OPS_RETIRED.ANY */
>  	PEBS_EVENT_CONSTRAINT(0x00c5, 0x1), /* BR_INST_RETIRED.MISPRED */
>  	PEBS_EVENT_CONSTRAINT(0x1fc7, 0x1), /* SIMD_INST_RETURED.ANY */
> -	PEBS_EVENT_CONSTRAINT(0x01cb, 0x1), /* MEM_LOAD_RETIRED.L1D_MISS */
> -	PEBS_EVENT_CONSTRAINT(0x02cb, 0x1), /* MEM_LOAD_RETIRED.L1D_LINE_MISS */
> -	PEBS_EVENT_CONSTRAINT(0x04cb, 0x1), /* MEM_LOAD_RETIRED.L2_MISS */
> -	PEBS_EVENT_CONSTRAINT(0x08cb, 0x1), /* MEM_LOAD_RETIRED.L2_LINE_MISS */
> -	PEBS_EVENT_CONSTRAINT(0x10cb, 0x1), /* MEM_LOAD_RETIRED.DTLB_MISS */
> +	INTEL_EVENT_CONSTRAINT(0xcb, 0x1),  /* MEM_LOAD_RETIRED.* */
> +	EVENT_CONSTRAINT_END
> +};
> +
> +static struct event_constraint intel_atom_pebs_event_constraints[] = {
> +	PEBS_EVENT_CONSTRAINT(0x00c0, 0x1), /* INSTR_RETIRED.ANY */
> +	PEBS_EVENT_CONSTRAINT(0x00c5, 0x1), /* BR_INST_RETIRED.MISPRED */
> +	PEBS_EVENT_CONSTRAINT(0x0ac4, 0x1), /* BR_INST_RETIRED.MISPRED */
> +	INTEL_EVENT_CONSTRAINT(0xcb, 0x1),  /* MEM_LOAD_RETIRED.* */
>  	EVENT_CONSTRAINT_END
>  };
>  
> -static struct event_constraint intel_nehalem_pebs_events[] = {
> -	PEBS_EVENT_CONSTRAINT(0x00c0, 0xf), /* INSTR_RETIRED.ANY */
> -	PEBS_EVENT_CONSTRAINT(0xfec1, 0xf), /* X87_OPS_RETIRED.ANY */
> -	PEBS_EVENT_CONSTRAINT(0x00c5, 0xf), /* BR_INST_RETIRED.MISPRED */
> -	PEBS_EVENT_CONSTRAINT(0x1fc7, 0xf), /* SIMD_INST_RETURED.ANY */
> -	PEBS_EVENT_CONSTRAINT(0x01cb, 0xf), /* MEM_LOAD_RETIRED.L1D_MISS */
> -	PEBS_EVENT_CONSTRAINT(0x02cb, 0xf), /* MEM_LOAD_RETIRED.L1D_LINE_MISS */
> -	PEBS_EVENT_CONSTRAINT(0x04cb, 0xf), /* MEM_LOAD_RETIRED.L2_MISS */
> -	PEBS_EVENT_CONSTRAINT(0x08cb, 0xf), /* MEM_LOAD_RETIRED.L2_LINE_MISS */
> -	PEBS_EVENT_CONSTRAINT(0x10cb, 0xf), /* MEM_LOAD_RETIRED.DTLB_MISS */
> +static struct event_constraint intel_nehalem_pebs_event_constraints[] = {
> +	INTEL_EVENT_CONSTRAINT(0x0b, 0xf),  /* MEM_INST_RETIRED.* */
> +	INTEL_EVENT_CONSTRAINT(0x0f, 0xf),  /* MEM_UNCORE_RETIRED.* */
> +	PEBS_EVENT_CONSTRAINT(0x010c, 0xf), /* MEM_STORE_RETIRED.DTLB_MISS */
> +	INTEL_EVENT_CONSTRAINT(0xc0, 0xf),  /* INST_RETIRED.ANY */
> +	INTEL_EVENT_CONSTRAINT(0xc2, 0xf),  /* UOPS_RETIRED.* */
> +	INTEL_EVENT_CONSTRAINT(0x00c4, 0xf),/* BR_INST_RETIRED.* */

- INTEL_EVENT_CONSTRAINT(0x00c4, 0xf)
+ INTEL_EVENT_CONSTRAINT(0xc4, 0xf)

> +	PEBS_EVENT_CONSTRAINT(0x02c5, 0xf), /* BR_MISP_RETIRED.NEAR_CALL */
> +	INTEL_EVENT_CONSTRAINT(0xc7, 0xf),  /* SSEX_UOPS_RETIRED.* */
> +	PEBS_EVENT_CONSTRAINT(0x20c8, 0xf), /* ITLB_MISS_RETIRED */
> +	INTEL_EVENT_CONSTRAINT(0xcb, 0xf),  /* MEM_LOAD_RETIRED.* */
> +	EVENT_CONSTRAINT_END
> +};
> +
> +static struct event_constraint intel_westmere_pebs_event_constraints[] = {
> +	INTEL_EVENT_CONSTRAINT(0x0b, 0xf), /* MEM_INST_RETIRED.* */
> +	INTEL_EVENT_CONSTRAINT(0x0f, 0xf), /* MEM_UNCORE_RETIRED.* */
> +	PEBS_EVENT_CONSTRAINT(0x010c, 0xf), /* MEM_STORE_RETIRED.DTLB_MISS */
> +	INTEL_EVENT_CONSTRAINT(0xc0, 0xf),  /* INSTR_RETIRED.* */
> +	INTEL_EVENT_CONSTRAINT(0xc2, 0xf),  /* UOPS_RETIRED.* */
> +
> +	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),  /* BR_INST_RETIRED.* */
> +	INTEL_EVENT_CONSTRAINT(0xc5, 0xf),  /* BR_MISP_RETIRED.* */
> +	INTEL_EVENT_CONSTRAINT(0xc7, 0xf),  /* SSEX_UOPS_RETIRED.* */
> +	PEBS_EVENT_CONSTRAINT(0x20c8, 0xf), /* ITLB_MISS_RETIRED */
> +	INTEL_EVENT_CONSTRAINT(0xcb, 0xf),  /* MEM_LOAD_RETIRED.* */
>  	EVENT_CONSTRAINT_END
>  };
>  
> @@ -695,20 +714,18 @@ static void intel_ds_init(void)
>  			printk(KERN_CONT "PEBS fmt0%c, ", pebs_type);
>  			x86_pmu.pebs_record_size = sizeof(struct pebs_record_core);
>  			x86_pmu.drain_pebs = intel_pmu_drain_pebs_core;
> -			x86_pmu.pebs_constraints = intel_core_pebs_events;
>  			break;
>  
>  		case 1:
>  			printk(KERN_CONT "PEBS fmt1%c, ", pebs_type);
>  			x86_pmu.pebs_record_size = sizeof(struct pebs_record_nhm);
>  			x86_pmu.drain_pebs = intel_pmu_drain_pebs_nhm;
> -			x86_pmu.pebs_constraints = intel_nehalem_pebs_events;
>  			break;
>  
>  		default:
> -			printk(KERN_CONT "no PEBS fmt%d%c, ", format, pebs_type);
> +			printk(KERN_CONT "no PEBS fmt%d%c, ",
> +			       format, pebs_type);

No changes?

>  			x86_pmu.pebs = 0;
> -			break;
>  		}
>  	}
>  }


