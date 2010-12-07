Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab0LGGw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 01:52:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:43243 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742Ab0LGGw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 01:52:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,310,1288594800"; 
   d="scan'208";a="581255392"
Subject: Re: [PATCH] perf, x86: P4 PMU - Fix unflagged overflows handling v4
From: Lin Ming <ming.m.lin@intel.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101205223419.GE7799@lenovo>
References: <20101205223419.GE7799@lenovo>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Dec 2010 14:56:18 +0800
Message-ID: <1291704978.3678.140.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-06 at 06:34 +0800, Cyrill Gorcunov wrote:
> Don found that P4 PMU reads CCCR register instead of counter
> itself (in attempt to catch unflagged event) this makes P4
> NMI handler to consume all NMIs it observes. So the other
> NMI users such as kgdb simply have no chance to get NMI
> on their hands.
> 
> v2: Call checking_wrmsrl only if needed.
> v3: Check the valuable bits.
> v4: Leave p4_pmu_clear_cccr_ovf early if P4_CCCR_OVF flag is set.
> 
> Reported-by: Jason Wessel <jason.wessel@windriver.com>
> Reported-by: Don Zickus <dzickus@redhat.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: Lin Ming <ming.m.lin@intel.com>
> CC: Stephane Eranian <eranian@google.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> ---
> 
> Ming, Jason, mind to give this patch a shot? Note that it
> seems you have to disable nmi-watchdog at bootstrap to be
> able to run perf top. I believe it's a different issue
> unrelated to this particular nit.

perf top gets nothing with current -tip/master(93edb453), both with and
without this patch.

I'm checking where the problem is.

Lin Ming

> 
>  arch/x86/include/asm/perf_event_p4.h |    3 +++
>  arch/x86/kernel/cpu/perf_event_p4.c  |   28 +++++++++++++++-------------
>  2 files changed, 18 insertions(+), 13 deletions(-)
> 
> Index: linux-2.6.git/arch/x86/include/asm/perf_event_p4.h
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/include/asm/perf_event_p4.h
> +++ linux-2.6.git/arch/x86/include/asm/perf_event_p4.h
> @@ -20,6 +20,9 @@
>  #define ARCH_P4_MAX_ESCR	(ARCH_P4_TOTAL_ESCR - ARCH_P4_RESERVED_ESCR)
>  #define ARCH_P4_MAX_CCCR	(18)
>  
> +#define ARCH_P4_CNTRVAL_BITS	(40)
> +#define ARCH_P4_CNTRVAL_MASK	((1ULL << ARCH_P4_CNTRVAL_BITS) - 1)
> +
>  #define P4_ESCR_EVENT_MASK	0x7e000000U
>  #define P4_ESCR_EVENT_SHIFT	25
>  #define P4_ESCR_EVENTMASK_MASK	0x01fffe00U
> Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
> +++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> @@ -753,19 +753,21 @@ out:
>  
>  static inline int p4_pmu_clear_cccr_ovf(struct hw_perf_event *hwc)
>  {
> -	int overflow = 0;
> -	u32 low, high;
> +	u64 v;
>  
> -	rdmsr(hwc->config_base + hwc->idx, low, high);
> -
> -	/* we need to check high bit for unflagged overflows */
> -	if ((low & P4_CCCR_OVF) || !(high & (1 << 31))) {
> -		overflow = 1;
> -		(void)checking_wrmsrl(hwc->config_base + hwc->idx,
> -			((u64)low) & ~P4_CCCR_OVF);
> +	/* an official way for overflow indication */
> +	rdmsrl(hwc->config_base + hwc->idx, v);
> +	if (v & P4_CCCR_OVF) {
> +		wrmsrl(hwc->config_base + hwc->idx, v & ~P4_CCCR_OVF);
> +		return 1;
>  	}
>  
> -	return overflow;
> +	/* it might be unflagged overflow */
> +	rdmsrl(hwc->event_base + hwc->idx, v);
> +	if (!(v & ARCH_P4_CNTRVAL_MASK))
> +		return 1;
> +
> +	return 0;
>  }
>  
>  static void p4_pmu_disable_pebs(void)
> @@ -1152,9 +1154,9 @@ static __initconst const struct x86_pmu 
>  	 */
>  	.num_counters		= ARCH_P4_MAX_CCCR,
>  	.apic			= 1,
> -	.cntval_bits		= 40,
> -	.cntval_mask		= (1ULL << 40) - 1,
> -	.max_period		= (1ULL << 39) - 1,
> +	.cntval_bits		= ARCH_P4_CNTRVAL_BITS,
> +	.cntval_mask		= ARCH_P4_CNTRVAL_MASK,
> +	.max_period		= (1ULL << (ARCH_P4_CNTRVAL_BITS - 1)) - 1,
>  	.hw_config		= p4_hw_config,
>  	.schedule_events	= p4_pmu_schedule_events,
>  	/*


