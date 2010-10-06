Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759637Ab0JFSQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 14:16:33 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:45329
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759582Ab0JFSQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 14:16:31 -0400
X-SpamScore: -10
X-BigFish: VPS-10(zzbb2cK1432N98dN4015L78fbpzz1202hzz8275dhz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L9VS2F-01-OZ3-02
X-M-MSG: 
Date: Wed, 6 Oct 2010 20:15:48 +0200
From: Robert Richter <robert.richter@amd.com>
To: Matt Fleming <matt@console-pimps.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mundt <lethal@linux-sh.org>
CC: Will Deacon <will.deacon@arm.com>, Russell King <linux@arm.linux.org.uk>,
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
Message-ID: <20101006181548.GU13563@erda.amd.com>
References: <cover.1286222593.git.matt@console-pimps.org>
 <59a8e68894a2e755232189abbe9b1a3b892e309c.1286222593.git.matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <59a8e68894a2e755232189abbe9b1a3b892e309c.1286222593.git.matt@console-pimps.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
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

Matt,

as an outcome of the discussion we have had in this thread I think we
agree on the following:

We extend the generic perf interface with perf_pmu_name() implenting a
default with the __weak attribute.  On sh we override this function
and will use it for perf/oprofile string translation. This will be
implemented in the oprofile function op_name_from_perf_name().

Later we implement a generic oprofile function that derives the
cpu_type from perf_pmu_name() in a generic way and add other
architectures. Thus, we will drop the ARM changes with this patch set.

Paul,

please correct me if I am wrong with the above.

Peter,

please ack the perf_pmu_name() interface introduced below.

See also my comments below. If there are any other objections, please
let me know.

Thanks,

-Robert

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

Please drop all arm changes in this patch. We will do the change after
a generic patch for perf/oprofile string translation is available.

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

The implementation should be moved to function
op_name_from_perf_name() in sh oprofile code. perf_pmu_name() should
simply return sh_pmu->name.

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

