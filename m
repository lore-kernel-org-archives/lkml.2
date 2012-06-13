Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab2FMVYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 17:24:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49212 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab2FMVYo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 17:24:44 -0400
Message-ID: <1339622672.8980.61.camel@twins>
Subject: Re: [PATCH 1/2] perf, x86: Add basic Ivy Bridge support v3
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Date: Wed, 13 Jun 2012 23:24:32 +0200
In-Reply-To: <1339615201-7456-1-git-send-email-andi@firstfloor.org>
References: <1339615201-7456-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-13 at 12:20 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Very similar to Sandy Bridge, but there is no PEBS problem.
> 
> As Stephane pointed out .code=0xb1, .umask=0x01 is gone, so don't
> do a generic backend stall event on IvyBridge.
> 
> v2: Remove stall event
> v3: Fork init code from Sandy Bridge
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel.c |   23 +++++++++++++++++++++--
>  1 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index 187c294..abb29c2 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -1911,7 +1911,6 @@ __init int intel_pmu_init(void)
>  	case 42: /* SandyBridge */
>  	case 45: /* SandyBridge, "Romely-EP" */
>  		x86_add_quirk(intel_sandybridge_quirk);
> -	case 58: /* IvyBridge */
>  		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
>  		       sizeof(hw_cache_event_ids));
>  
> @@ -1928,11 +1927,31 @@ __init int intel_pmu_init(void)
>  		/* UOPS_ISSUED.ANY,c=1,i=1 to count stall cycles */
>  		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] =
>  			X86_CONFIG(.event=0x0e, .umask=0x01, .inv=1, .cmask=1);
> +		pr_cont("SandyBridge events, ");
> +		break;
> +
> +	case 58: /* IvyBridge */
>  		/* UOPS_DISPATCHED.THREAD,c=1,i=1 to count stall cycles*/
>  		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] =
>  			X86_CONFIG(.event=0xb1, .umask=0x01, .inv=1, .cmask=1);
>  
> -		pr_cont("SandyBridge events, ");
> +		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
> +		       sizeof(hw_cache_event_ids));
> +
> +		intel_pmu_lbr_init_snb();
> +
> +		x86_pmu.event_constraints = intel_snb_event_constraints;
> +		x86_pmu.pebs_constraints = intel_snb_pebs_event_constraints;
> +		x86_pmu.extra_regs = intel_snb_extra_regs;
> +		/* all extra regs are per-cpu when HT is on */
> +		x86_pmu.er_flags |= ERF_HAS_RSP_1;
> +		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
> +
> +		/* UOPS_ISSUED.ANY,c=1,i=1 to count stall cycles */
> +		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] =
> +			X86_CONFIG(.event=0x0e, .umask=0x01, .inv=1, .cmask=1);
> +		/* No backend stall event */
> +		pr_cont("IvyBridge events, ");
>  		break;
>  
>  	default:

I really don't see the point of this patch,.. it is in fact using the
SandyBridge events.. also you appear to have removed the backend stalls
which per SDM (may 2012) table 19-2 would be the very same.


