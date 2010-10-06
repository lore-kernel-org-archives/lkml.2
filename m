Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138Ab0JFM1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 08:27:53 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:56122
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755274Ab0JFM1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 08:27:51 -0400
X-SpamScore: -6
X-BigFish: VPS-6(zzbb2cK1432N98dN78fbpzz1202hzz8275dhz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L9VBXZ-01-01J-02
X-M-MSG: 
Date: Wed, 6 Oct 2010 14:27:36 +0200
From: Robert Richter <robert.richter@amd.com>
To: Matt Fleming <matt@console-pimps.org>
CC: Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/7] perf: New helper function for pmu name
Message-ID: <20101006122736.GL13563@erda.amd.com>
References: <cover.1286222593.git.matt@console-pimps.org>
 <59a8e68894a2e755232189abbe9b1a3b892e309c.1286222593.git.matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <59a8e68894a2e755232189abbe9b1a3b892e309c.1286222593.git.matt@console-pimps.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.10.10 16:44:20, Matt Fleming wrote:
> Introduce perf_pmu_name() helper function that returns the name of the
> pmu. This gives us a generic way to get the name of a pmu regardless of
> how an architecture identifies it internally, e.g. ARM uses an id
> whereas SH currently uses a string.
> 
> Signed-off-by: Matt Fleming <matt@console-pimps.org>
> ---
>  arch/arm/kernel/perf_event.c |   23 +++++++++++++++++++++++
>  arch/arm/oprofile/common.c   |   22 +---------------------
>  arch/sh/kernel/perf_event.c  |   14 ++++++++++++++
>  include/linux/perf_event.h   |    1 +
>  kernel/perf_event.c          |    5 +++++
>  5 files changed, 44 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
> index ef3bc33..3bff24d 100644
> --- a/arch/arm/kernel/perf_event.c
> +++ b/arch/arm/kernel/perf_event.c
> @@ -123,6 +123,29 @@ armpmu_get_max_events(void)
>  }
>  EXPORT_SYMBOL_GPL(armpmu_get_max_events);
>  
> +const char *perf_pmu_name(void)
> +{
> +	enum arm_perf_pmu_ids id = armpmu_get_pmu_id();
> +
> +	switch (id) {
> +	case ARM_PERF_PMU_ID_XSCALE1:
> +		return "arm/xscale1";
> +	case ARM_PERF_PMU_ID_XSCALE2:
> +		return "arm/xscale2";
> +	case ARM_PERF_PMU_ID_V6:
> +		return "arm/armv6";
> +	case ARM_PERF_PMU_ID_V6MP:
> +		return "arm/mpcore";
> +	case ARM_PERF_PMU_ID_CA8:
> +		return "arm/armv7";
> +	case ARM_PERF_PMU_ID_CA9:
> +		return "arm/armv7-ca9";
> +	default:
> +		return NULL;
> +	}
> +}
> +EXPORT_SYMBOL_GPL(perf_pmu_name);
> +
>  int perf_num_counters(void)
>  {
>  	return armpmu_get_max_events();
> diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
> index 23f18a0..cb224ee 100644
> --- a/arch/arm/oprofile/common.c
> +++ b/arch/arm/oprofile/common.c
> @@ -155,26 +155,6 @@ static void op_perf_stop(void)
>  }
>  
>  
> -static char *op_name_from_perf_id(enum arm_perf_pmu_ids id)
> -{
> -	switch (id) {
> -	case ARM_PERF_PMU_ID_XSCALE1:
> -		return "arm/xscale1";
> -	case ARM_PERF_PMU_ID_XSCALE2:
> -		return "arm/xscale2";
> -	case ARM_PERF_PMU_ID_V6:
> -		return "arm/armv6";
> -	case ARM_PERF_PMU_ID_V6MP:
> -		return "arm/mpcore";
> -	case ARM_PERF_PMU_ID_CA8:
> -		return "arm/armv7";
> -	case ARM_PERF_PMU_ID_CA9:
> -		return "arm/armv7-ca9";
> -	default:
> -		return NULL;
> -	}
> -}

I don't like moving this oprofile names out to perf. These strings
don't have much to do with the pmu names and are hints for the
oprofile daemon to detect the pmu type with no other use. Of course
this is more human readable than an enum or so, but it is of no worth
other than oprofile. So it should be kept inside oprofile.

> -
>  static int op_arm_create_files(struct super_block *sb, struct dentry *root)
>  {
>  	unsigned int i;
> @@ -391,7 +371,7 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
>  	ops->start		= op_arm_start;
>  	ops->stop		= op_arm_stop;
>  	ops->shutdown		= op_arm_stop;
> -	ops->cpu_type		= op_name_from_perf_id(armpmu_get_pmu_id());
> +	ops->cpu_type		= perf_pmu_name();
>  
>  	if (!ops->cpu_type)
>  		ret = -ENODEV;
> diff --git a/arch/sh/kernel/perf_event.c b/arch/sh/kernel/perf_event.c
> index 2cb9ad5..e065a1d 100644
> --- a/arch/sh/kernel/perf_event.c
> +++ b/arch/sh/kernel/perf_event.c
> @@ -59,6 +59,20 @@ static inline int sh_pmu_initialized(void)
>  	return !!sh_pmu;
>  }
>  
> +const char *perf_pmu_name(void)
> +{
> +	if (!sh_pmu)
> +		return NULL;
> +
> +	if (!strcmp(sh_pmu->name, "SH7750"))
> +		return "sh/sh7750";
> +	if (!strcmp(sh_pmu->name, "SH-4A"))
> +		return "sh/sh4a";
> +
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(perf_pmu_name);

I rather want use here the solution we discussed earlier, simply
including <asm/perf_event.h> and then access sh_pmu->name directly
from oprofile.

-Robert

> +
>  int perf_num_counters(void)
>  {
>  	if (!sh_pmu)
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 1a02192..33f08da 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -850,6 +850,7 @@ extern int perf_max_events;
>  extern const struct pmu *hw_perf_event_init(struct perf_event *event);
>  
>  extern int perf_num_counters(void);
> +extern const char *perf_pmu_name(void);
>  extern void perf_event_task_sched_in(struct task_struct *task);
>  extern void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next);
>  extern void perf_event_task_tick(struct task_struct *task);
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index db5b560..fc51268 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -85,6 +85,11 @@ void __weak hw_perf_enable(void)		{ barrier(); }
>  
>  void __weak perf_event_print_debug(void)	{ }
>  
> +extern __weak const char *perf_pmu_name(void)
> +{
> +	return "pmu";
> +}
> +
>  static DEFINE_PER_CPU(int, perf_disable_count);
>  
>  void perf_disable(void)
> -- 
> 1.7.1
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

