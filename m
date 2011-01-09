Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407Ab1AIAlT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 19:41:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:33316 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786Ab1AIAlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 19:41:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,295,1291622400"; 
   d="scan'208";a="694914662"
Subject: Re: [PATCH -tip/master] perf, x86: P4 PMU - Fix unflagged
 overflows handling v4
From: Lin Ming <ming.m.lin@intel.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jason Wessel <jason.wessel@windriver.com>,
        Don Zickus <dzickus@redhat.com>, Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4D275E7E.3040903@gmail.com>
References: <4D275E7E.3040903@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 09 Jan 2011 08:41:22 +0800
Message-Id: <1294533682.2308.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-01-08 at 02:42 +0800, Cyrill Gorcunov wrote:
> Don found that P4 PMU reads CCCR register instead of counter
> itself (in attempt to catch unflagged event) this makes P4
> NMI handler to consume all NMIs it observes. So the other
> NMI users such as kgdb simply have no chance to get NMI
> on their hands.
> 
> Side note: at moment there is no way to run nmi-watchdog
> together with perf tool. This is because both 'perf top' and
> nmi-watchdog use same event. So while nmi-watchdog reserves
> one event/counter for own needs there is no room for perf tool
> left (there is a way to disable nmi-watchdog on boot of course).
> 
> Ming has tested this patch with the following results
> 
>  | 1. watchdog disabled
>  |
>  | kgdb tests on boot OK
>  | perf works OK
>  |
>  | 2. watchdog enabled, without patch perf-x86-p4-nmi-4
>  |
>  | kgdb tests on boot hang
>  |
>  | 3. watchdog enabled, without patch perf-x86-p4-nmi-4 and do not run kgdb
>  | tests on boot
>  |
>  | "perf top" partialy works
>  |   cpu-cycles            no
>  |   instructions          yes
>  |   cache-references      no
>  |   cache-misses          no
>  |   branch-instructions   no
>  |   branch-misses         yes
>  |   bus-cycles            no
>  |
>  | 4. watchdog enabled, with patch perf-x86-p4-nmi-4 applied
>  |
>  | kgdb tests on boot OK
>  | perf does not work, NMI "Dazed and confused" messages show up
>  |
> 
> Which means we still have problems with p4 box due to 'unknown'
> nmi happens but at least it should fix kgdb test cases.
> 
> Reported-by: Jason Wessel <jason.wessel@windriver.com>
> Reported-by: Don Zickus <dzickus@redhat.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: Lin Ming <ming.m.lin@intel.com>
> CC: Stephane Eranian <eranian@google.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> ---
> 
> Don, your opinion?
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

Acked-by: Lin Ming <ming.m.lin@intel.com>


