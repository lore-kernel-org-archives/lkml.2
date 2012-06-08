Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762037Ab2FHIpn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 04:45:43 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37238 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762011Ab2FHIpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 04:45:33 -0400
Date: Fri, 8 Jun 2012 10:45:27 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] perf, x86: Add basic Ivy Bridge support v2
Message-ID: <20120608084527.GA2426@gmail.com>
References: <1339111137-7329-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339111137-7329-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> Very similar to Sandy Bridge, but there is no PEBS problem.
> 
> As Stephane pointed out .code=0xb1, .umask=0x01 is gone, so don't
> do a generic backend stall event on IvyBridge.
> 
> v2: Remove stall event
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel.c |   19 ++++++++++++++-----
>  1 files changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index 166546e..0f58590 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -1698,6 +1698,7 @@ __init int intel_pmu_init(void)
>  	union cpuid10_ebx ebx;
>  	unsigned int unused;
>  	int version;
> +	char *name;
>  
>  	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
>  		switch (boot_cpu_data.x86) {
> @@ -1839,9 +1840,21 @@ __init int intel_pmu_init(void)
>  		pr_cont("Westmere events, ");
>  		break;
>  
> +	case 58: /* IvyBridge */
> +		name = "Ivy";
> +		/* No backend stall event */
> +		goto snb_ivb_common;
> +
>  	case 42: /* SandyBridge */
>  		x86_add_quirk(intel_sandybridge_quirk);
>  	case 45: /* SandyBridge, "Romely-EP" */
> +		name = "Sandy";
> +
> +		/* UOPS_DISPATCHED.THREAD,c=1,i=1 to count stall cycles*/
> +		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] =
> +			X86_CONFIG(.event=0xb1, .umask=0x01, .inv=1, .cmask=1);
> +
> +	snb_ivb_common:
>  		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
>  		       sizeof(hw_cache_event_ids));
>  
> @@ -1857,11 +1870,7 @@ __init int intel_pmu_init(void)
>  		/* UOPS_ISSUED.ANY,c=1,i=1 to count stall cycles */
>  		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] =
>  			X86_CONFIG(.event=0x0e, .umask=0x01, .inv=1, .cmask=1);
> -		/* UOPS_DISPATCHED.THREAD,c=1,i=1 to count stall cycles*/
> -		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] =
> -			X86_CONFIG(.event=0xb1, .umask=0x01, .inv=1, .cmask=1);
> -
> -		pr_cont("SandyBridge events, ");
> +		pr_cont("%sBridge events, ", name);
>  		break;

First round review feedback: your patch does not apply to the 
perf development/fixes tree (-tip), please send one that will.

Thanks,

	Ingo
