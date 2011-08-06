Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab1HFKvL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 06:51:11 -0400
Received: from relay3.sgi.com ([192.48.152.1]:58520 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753358Ab1HFKvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 06:51:07 -0400
Date: Sat, 6 Aug 2011 05:51:04 -0500
From: Robin Holt <holt@sgi.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Jack Steiner <steiner@sgi.com>, Robin Holt <holt@sgi.com>,
        Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de, davej@redhat.com,
        yinghan@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86: Reduce clock calibration time during slave cpu
 startup
Message-ID: <20110806105104.GN4926@sgi.com>
References: <20110727135730.GA17717@sgi.com>
 <20110727140523.GA24206@redhat.com>
 <20110727141527.GA8453@sgi.com>
 <20110727155200.GA25381@redhat.com>
 <20110801184542.GA3939@sgi.com>
 <20110805104635.GB13055@elte.hu>
 <20110805131638.GA27779@sgi.com>
 <CAE9FiQWAmjTWGBLrqH9+_AH316Br-McW=PrSyiDWCtSYndL07w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQWAmjTWGBLrqH9+_AH316Br-McW=PrSyiDWCtSYndL07w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 05:21:39PM -0700, Yinghai Lu wrote:
> On Fri, Aug 5, 2011 at 6:16 AM, Jack Steiner <steiner@sgi.com> wrote:
> > Aside from the bogus comment (I'll send a V3 with a fixed comment), does the patch
> > look ok.
> 
> Several months ago, Robin said that he will test updated version

I am sorry I dropped that.  I was waiting for a large machine to become
available and then got loaned to another group within SGI and have not
done a very good job of keeping track of my obligations to people in
this forum.

When the time came to turn the cpu calibration stuff over to someone
else within SGI, I did tell Jack of efforts others had made in the past,
but forgot the specifics of the efforts or that they were waiting for me.

Please understand the situation has not allowed me much time and that
coupled with my inability to clearly remember how this had progressed
has allowed that effort to fall between the cracks.  I am sorry for
both your effort not being used and also wasting Jack's time in trying
to come up with a different method.

Hopefully, Jack can test this method now.

Robin

> 
> [PATCH] x86: Make calibrate_delay run in parallel.
> 
> so any reason that you sgi guyes stop that path?
> 
> Please check attached patch for updated version to current tip.
> 
> Thanks
> 
> Yinghai Lu

> [PATCH -v4] x86: Make calibrate_delay run in parallel.
> 
> On a 4096 cpu machine, we noticed that 318 seconds were taken for bringing
> up the cpus.  By specifying lpj=<value>, we reduced that to 75 seconds.
> Andi Kleen suggested we rework the calibrate_delay calls to run in
> parallel.
> 
> -v2: from Yinghai
>      two path: one for initial boot cpus. and one for hotplug cpus
> 	initial path:
> 	  after all cpu boot up, enter idle, use smp_call_function_many
> 	  let every ap call __calibrate_delay.
>           We can not put that calibrate_delay after local_irq_enable
>           in start_secondary(), at that time that cpu could be involed
> 	  with perf_event with nmi_watchdog enabling. that will cause
> 	  strange calibrating result.
>         hotplug path:
> 	  need to add cpu notify block.
>      add __calibrate_delay instead of changing calibrate_delay all over.
>      use cpu_calibrated_delay_mask instead.
>      use print_lpj to make print line complete.
> 
> Signed-off-by: Robin Holt <holt@sgi.com>
> To: Andi Kleen <andi@firstfloor.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/include/asm/cpumask.h |    1 
>  arch/x86/kernel/cpu/common.c   |    3 ++
>  arch/x86/kernel/smpboot.c      |   58 ++++++++++++++++++++++++++++++++++-------
>  include/linux/delay.h          |    1 
>  init/calibrate.c               |   54 +++++++++++++++++++-------------------
>  5 files changed, 81 insertions(+), 36 deletions(-)
> 
> 
> --
> Index: linux-2.6/arch/x86/include/asm/cpumask.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/cpumask.h
> +++ linux-2.6/arch/x86/include/asm/cpumask.h
> @@ -6,6 +6,7 @@
>  extern cpumask_var_t cpu_callin_mask;
>  extern cpumask_var_t cpu_callout_mask;
>  extern cpumask_var_t cpu_initialized_mask;
> +extern cpumask_var_t cpu_calibrated_delay_mask;
>  extern cpumask_var_t cpu_sibling_setup_mask;
>  
>  extern void setup_cpu_local_masks(void);
> Index: linux-2.6/arch/x86/kernel/cpu/common.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/cpu/common.c
> +++ linux-2.6/arch/x86/kernel/cpu/common.c
> @@ -45,6 +45,7 @@
>  cpumask_var_t cpu_initialized_mask;
>  cpumask_var_t cpu_callout_mask;
>  cpumask_var_t cpu_callin_mask;
> +cpumask_var_t cpu_calibrated_delay_mask;
>  
>  /* representing cpus for which sibling maps can be computed */
>  cpumask_var_t cpu_sibling_setup_mask;
> @@ -58,6 +59,8 @@ void __init setup_cpu_local_masks(void)
>  	alloc_bootmem_cpumask_var(&cpu_callin_mask);
>  	set_bootmem_name("cpu_callout_mask");
>  	alloc_bootmem_cpumask_var(&cpu_callout_mask);
> +	set_bootmem_name("cpu_calibrated_delay_mask");
> +	alloc_bootmem_cpumask_var(&cpu_calibrated_delay_mask);
>  	set_bootmem_name("cpu_sibling_setup_mask");
>  	alloc_bootmem_cpumask_var(&cpu_sibling_setup_mask);
>  }
> Index: linux-2.6/arch/x86/kernel/smpboot.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/smpboot.c
> +++ linux-2.6/arch/x86/kernel/smpboot.c
> @@ -52,6 +52,7 @@
>  #include <linux/gfp.h>
>  
>  #include <asm/acpi.h>
> +#include <asm/cpumask.h>
>  #include <asm/desc.h>
>  #include <asm/nmi.h>
>  #include <asm/irq.h>
> @@ -210,15 +211,7 @@ static void __cpuinit smp_callin(void)
>  	 * Need to setup vector mappings before we enable interrupts.
>  	 */
>  	setup_vector_irq(smp_processor_id());
> -	/*
> -	 * Get our bogomips.
> -	 *
> -	 * Need to enable IRQs because it can take longer and then
> -	 * the NMI watchdog might kill us.
> -	 */
> -	local_irq_enable();
> -	calibrate_delay();
> -	local_irq_disable();
> +
>  	pr_debug("Stack at about %p\n", &cpuid);
>  
>  	/*
> @@ -1038,6 +1031,8 @@ void __init native_smp_prepare_cpus(unsi
>  	}
>  	set_cpu_sibling_map(0);
>  
> +	/* already called earlier for boot cpu */
> +	cpumask_set_cpu(0, cpu_calibrated_delay_mask);
>  
>  	if (smp_sanity_check(max_cpus) < 0) {
>  		printk(KERN_INFO "SMP disabled\n");
> @@ -1126,8 +1121,53 @@ void __init native_smp_prepare_boot_cpu(
>  	per_cpu(cpu_state, me) = CPU_ONLINE;
>  }
>  
> +static void __cpuinit calibrate_delay_fn(void *info)
> +{
> +	int cpu = smp_processor_id();
> +
> +	cpu_data(cpu).loops_per_jiffy = __calibrate_delay(cpu);
> +	cpumask_set_cpu(cpu, cpu_calibrated_delay_mask);
> +}
> +
> +#ifdef CONFIG_HOTPLUG_CPU
> +static int __cpuinit
> +cal_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
> +{
> +	int cpu = (unsigned long)hcpu;
> +
> +	switch (action) {
> +	case CPU_ONLINE:
> +	case CPU_ONLINE_FROZEN:
> +		smp_call_function_single(cpu, calibrate_delay_fn, NULL, 1);
> +		break;
> +	}
> +
> +	return NOTIFY_OK;
> +}
> +
> +static __cpuinitdata struct notifier_block __cpuinitdata cal_cpu_nfb = {
> +	.notifier_call = cal_cpu_callback
> +};
> +
> +static void __init register_cal_cpu_nfb(void)
> +{
> +	register_cpu_notifier(&cal_cpu_nfb);
> +}
> +#else
> +static void __init register_cal_cpu_nfb(void)
> +{
> +}
> +#endif
> +
>  void __init native_smp_cpus_done(unsigned int max_cpus)
>  {
> +	smp_call_function_many(cpu_online_mask, calibrate_delay_fn, NULL, 0);
> +	while (cpumask_weight(cpu_calibrated_delay_mask) != num_online_cpus()) {
> +		cpu_relax();
> +		touch_nmi_watchdog();
> +	}
> +	register_cal_cpu_nfb();
> +
>  	pr_debug("Boot done.\n");
>  
>  	impress_friends();
> Index: linux-2.6/include/linux/delay.h
> ===================================================================
> --- linux-2.6.orig/include/linux/delay.h
> +++ linux-2.6/include/linux/delay.h
> @@ -43,6 +43,7 @@ static inline void ndelay(unsigned long
>  
>  extern unsigned long lpj_fine;
>  void calibrate_delay(void);
> +unsigned long __calibrate_delay(int cpu);
>  void msleep(unsigned int msecs);
>  unsigned long msleep_interruptible(unsigned int msecs);
>  void usleep_range(unsigned long min, unsigned long max);
> Index: linux-2.6/init/calibrate.c
> ===================================================================
> --- linux-2.6.orig/init/calibrate.c
> +++ linux-2.6/init/calibrate.c
> @@ -31,7 +31,7 @@ __setup("lpj=", lpj_setup);
>  #define DELAY_CALIBRATION_TICKS			((HZ < 100) ? 1 : (HZ/100))
>  #define MAX_DIRECT_CALIBRATION_RETRIES		5
>  
> -static unsigned long __cpuinit calibrate_delay_direct(void)
> +static unsigned long __cpuinit calibrate_delay_direct(int cpu)
>  {
>  	unsigned long pre_start, start, post_start;
>  	unsigned long pre_end, end, post_end;
> @@ -134,15 +134,9 @@ static unsigned long __cpuinit calibrate
>  		good_timer_count = 0;
>  		if ((measured_times[max] - estimate) <
>  				(estimate - measured_times[min])) {
> -			printk(KERN_NOTICE "calibrate_delay_direct() dropping "
> -					"min bogoMips estimate %d = %lu\n",
> -				min, measured_times[min]);
>  			measured_times[min] = 0;
>  			min = max;
>  		} else {
> -			printk(KERN_NOTICE "calibrate_delay_direct() dropping "
> -					"max bogoMips estimate %d = %lu\n",
> -				max, measured_times[max]);
>  			measured_times[max] = 0;
>  			max = min;
>  		}
> @@ -160,9 +154,9 @@ static unsigned long __cpuinit calibrate
>  
>  	}
>  
> -	printk(KERN_NOTICE "calibrate_delay_direct() failed to get a good "
> +	printk(KERN_NOTICE "CPU%d: calibrate_delay_direct() failed to get a good "
>  	       "estimate for loops_per_jiffy.\nProbably due to long platform "
> -		"interrupts. Consider using \"lpj=\" boot option.\n");
> +		"interrupts. Consider using \"lpj=\" boot option.\n", cpu);
>  	return 0;
>  }
>  #else
> @@ -246,32 +240,38 @@ recalibrate:
>  
>  static DEFINE_PER_CPU(unsigned long, cpu_loops_per_jiffy) = { 0 };
>  
> -void __cpuinit calibrate_delay(void)
> +static void __cpuinit print_lpj(int cpu, char *str, unsigned long lpj)
> +{
> +       pr_info("CPU%d: Calibrating delay%s"
> +               "%lu.%02lu BogoMIPS (lpj=%lu)\n", cpu, str,
> +               lpj/(500000/HZ), (lpj/(5000/HZ)) % 100, lpj);
> +}
> +
> +unsigned long __cpuinit __calibrate_delay(int cpu)
>  {
>  	unsigned long lpj;
> -	int this_cpu = smp_processor_id();
>  
> -	if (per_cpu(cpu_loops_per_jiffy, this_cpu)) {
> -		lpj = per_cpu(cpu_loops_per_jiffy, this_cpu);
> -		pr_info("Calibrating delay loop (skipped) "
> -				"already calibrated this CPU");
> +	if (per_cpu(cpu_loops_per_jiffy, cpu)) {
> +		lpj = per_cpu(cpu_loops_per_jiffy, cpu);
> +		print_lpj(cpu, " (skipped) already calibrated this CPU ", lpj);
>  	} else if (preset_lpj) {
>  		lpj = preset_lpj;
> -		pr_info("Calibrating delay loop (skipped) preset value.. ");
> -	} else if ((this_cpu == 0) && lpj_fine) {
> +		print_lpj(cpu, " (skipped) preset value.. ", lpj);
> +	} else if ((cpu == 0) && lpj_fine) {
>  		lpj = lpj_fine;
> -		pr_info("Calibrating delay loop (skipped), "
> -			"value calculated using timer frequency.. ");
> -	} else if ((lpj = calibrate_delay_direct()) != 0) {
> -		pr_info("Calibrating delay using timer specific routine.. ");
> +		print_lpj(cpu, " loop (skipped), value calculated using timer frequency.. ", lpj);
> +	} else if ((lpj = calibrate_delay_direct(cpu)) != 0) {
> +		print_lpj(cpu, " using timer specific routine.. ", lpj);
>  	} else {
> -		pr_info("Calibrating delay loop... ");
>  		lpj = calibrate_delay_converge();
> +		print_lpj(cpu, " delay loop... ", lpj);
>  	}
> -	per_cpu(cpu_loops_per_jiffy, this_cpu) = lpj;
> -	pr_cont("%lu.%02lu BogoMIPS (lpj=%lu)\n",
> -			lpj/(500000/HZ),
> -			(lpj/(5000/HZ)) % 100, lpj);
> +	per_cpu(cpu_loops_per_jiffy, cpu) = lpj;
>  
> -	loops_per_jiffy = lpj;
> +	return lpj;
> +}
> +
> +void __cpuinit calibrate_delay(void)
> +{
> +	loops_per_jiffy = __calibrate_delay(smp_processor_id());
>  }

