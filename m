Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab0JFMOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 08:14:38 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:5474
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757940Ab0JFMOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 08:14:35 -0400
X-SpamScore: -10
X-BigFish: VPS-10(zzbb2cK1432N98dN4015L78fbpzz1202hzz8275bh8275dhz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L9VBBK-02-A0I-02
X-M-MSG: 
Date: Wed, 6 Oct 2010 14:14:10 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Matt Fleming <matt@console-pimps.org>, Will Deacon <will.deacon@arm.com>,
        Paul Mundt <lethal@linux-sh.org>,
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
Subject: Re: [PATCH 1/7] perf: Add helper function to return number of
 counters
Message-ID: <20101006121410.GK13563@erda.amd.com>
References: <cover.1286222593.git.matt@console-pimps.org>
 <c4eb88b09da564fe093cc6571ed747971425e69a.1286222593.git.matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c4eb88b09da564fe093cc6571ed747971425e69a.1286222593.git.matt@console-pimps.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.10.10 16:44:19, Matt Fleming wrote:
> The number of counters for the registered pmu is needed in a few places
> so provide a helper function that returns this number.
> 
> Signed-off-by: Matt Fleming <matt@console-pimps.org>
> Tested-by: Will Deacon <will.deacon@arm.com>
> ---
>  arch/arm/kernel/perf_event.c |    6 ++++++
>  arch/arm/oprofile/common.c   |   31 ++++++++++++++++++-------------
>  arch/sh/kernel/perf_event.c  |    9 +++++++++
>  include/linux/perf_event.h   |    1 +
>  4 files changed, 34 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
> index ecbb028..ef3bc33 100644
> --- a/arch/arm/kernel/perf_event.c
> +++ b/arch/arm/kernel/perf_event.c
> @@ -123,6 +123,12 @@ armpmu_get_max_events(void)
>  }
>  EXPORT_SYMBOL_GPL(armpmu_get_max_events);
>  
> +int perf_num_counters(void)
> +{
> +	return armpmu_get_max_events();
> +}
> +EXPORT_SYMBOL_GPL(perf_num_counters);

Peter,

can you please ack this interface?

Thanks,

-Robert

> +
>  #define HW_OP_UNSUPPORTED		0xFFFF
>  
>  #define C(_x) \
> diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
> index d660cb8..23f18a0 100644
> --- a/arch/arm/oprofile/common.c
> +++ b/arch/arm/oprofile/common.c
> @@ -43,7 +43,7 @@ static DEFINE_MUTEX(op_arm_mutex);
>  
>  static struct op_counter_config *counter_config;
>  static struct perf_event **perf_events[nr_cpumask_bits];
> -static int perf_num_counters;
> +static int perf_nr_counters;
>  
>  /*
>   * Overflow callback for oprofile.
> @@ -54,11 +54,11 @@ static void op_overflow_handler(struct perf_event *event, int unused,
>  	int id;
>  	u32 cpu = smp_processor_id();
>  
> -	for (id = 0; id < perf_num_counters; ++id)
> +	for (id = 0; id < perf_nr_counters; ++id)
>  		if (perf_events[cpu][id] == event)
>  			break;
>  
> -	if (id != perf_num_counters)
> +	if (id != perf_nr_counters)
>  		oprofile_add_sample(regs, id);
>  	else
>  		pr_warning("oprofile: ignoring spurious overflow "
> @@ -76,7 +76,7 @@ static void op_perf_setup(void)
>  	u32 size = sizeof(struct perf_event_attr);
>  	struct perf_event_attr *attr;
>  
> -	for (i = 0; i < perf_num_counters; ++i) {
> +	for (i = 0; i < perf_nr_counters; ++i) {
>  		attr = &counter_config[i].attr;
>  		memset(attr, 0, size);
>  		attr->type		= PERF_TYPE_RAW;
> @@ -131,7 +131,7 @@ static int op_perf_start(void)
>  	int cpu, event, ret = 0;
>  
>  	for_each_online_cpu(cpu) {
> -		for (event = 0; event < perf_num_counters; ++event) {
> +		for (event = 0; event < perf_nr_counters; ++event) {
>  			ret = op_create_counter(cpu, event);
>  			if (ret)
>  				goto out;
> @@ -150,7 +150,7 @@ static void op_perf_stop(void)
>  	int cpu, event;
>  
>  	for_each_online_cpu(cpu)
> -		for (event = 0; event < perf_num_counters; ++event)
> +		for (event = 0; event < perf_nr_counters; ++event)
>  			op_destroy_counter(cpu, event);
>  }
>  
> @@ -179,7 +179,7 @@ static int op_arm_create_files(struct super_block *sb, struct dentry *root)
>  {
>  	unsigned int i;
>  
> -	for (i = 0; i < perf_num_counters; i++) {
> +	for (i = 0; i < perf_nr_counters; i++) {
>  		struct dentry *dir;
>  		char buf[4];
>  
> @@ -353,14 +353,19 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
>  
>  	memset(&perf_events, 0, sizeof(perf_events));
>  
> -	perf_num_counters = armpmu_get_max_events();
> +	perf_nr_counters = perf_num_counters();
> +	if (perf_nr_counters <= 0) {
> +		pr_info("oprofile: no performance counters\n");
> +		ret = -ENODEV;
> +		goto out;
> +	}
>  
> -	counter_config = kcalloc(perf_num_counters,
> +	counter_config = kcalloc(perf_nr_counters,
>  			sizeof(struct op_counter_config), GFP_KERNEL);
>  
>  	if (!counter_config) {
>  		pr_info("oprofile: failed to allocate %d "
> -				"counters\n", perf_num_counters);
> +				"counters\n", perf_nr_counters);
>  		ret = -ENOMEM;
>  		goto out;
>  	}
> @@ -370,11 +375,11 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
>  		goto out;
>  
>  	for_each_possible_cpu(cpu) {
> -		perf_events[cpu] = kcalloc(perf_num_counters,
> +		perf_events[cpu] = kcalloc(perf_nr_counters,
>  				sizeof(struct perf_event *), GFP_KERNEL);
>  		if (!perf_events[cpu]) {
>  			pr_info("oprofile: failed to allocate %d perf events "
> -					"for cpu %d\n", perf_num_counters, cpu);
> +					"for cpu %d\n", perf_nr_counters, cpu);
>  			ret = -ENOMEM;
>  			goto out;
>  		}
> @@ -409,7 +414,7 @@ void __exit oprofile_arch_exit(void)
>  	struct perf_event *event;
>  
>  	for_each_possible_cpu(cpu) {
> -		for (id = 0; id < perf_num_counters; ++id) {
> +		for (id = 0; id < perf_nr_counters; ++id) {
>  			event = perf_events[cpu][id];
>  			if (event)
>  				perf_event_release_kernel(event);
> diff --git a/arch/sh/kernel/perf_event.c b/arch/sh/kernel/perf_event.c
> index 7a3dc35..2cb9ad5 100644
> --- a/arch/sh/kernel/perf_event.c
> +++ b/arch/sh/kernel/perf_event.c
> @@ -59,6 +59,15 @@ static inline int sh_pmu_initialized(void)
>  	return !!sh_pmu;
>  }
>  
> +int perf_num_counters(void)
> +{
> +	if (!sh_pmu)
> +		return 0;
> +
> +	return sh_pmu->num_events;
> +}
> +EXPORT_SYMBOL_GPL(perf_num_counters);
> +
>  /*
>   * Release the PMU if this is the last perf_event.
>   */
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 716f99b..1a02192 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -849,6 +849,7 @@ extern int perf_max_events;
>  
>  extern const struct pmu *hw_perf_event_init(struct perf_event *event);
>  
> +extern int perf_num_counters(void);
>  extern void perf_event_task_sched_in(struct task_struct *task);
>  extern void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next);
>  extern void perf_event_task_tick(struct task_struct *task);
> -- 
> 1.7.1
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

