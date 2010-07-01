Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534Ab0GATmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 15:42:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756244Ab0GATmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 15:42:23 -0400
Message-ID: <4C2CEF5D.8060609@redhat.com>
Date: Thu, 01 Jul 2010 15:41:17 -0400
From: Don Dutile <ddutile@redhat.com>
Reply-To: ddutile@redhat.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081113)
MIME-Version: 1.0
To: stefano@stabellini.net
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       Stefano.Stabellini@eu.citrix.com, sheng@linux.intel.com,
       jeremy@goop.org
Subject: Re: [PATCH 11/13] Use xen_vcpuop_clockevent, xen_clocksource and
 xen wallclock.
References: <alpine.DEB.2.00.1006211456360.18470@kaball-desktop> <1277136847-13266-11-git-send-email-stefano@stabellini.net>
In-Reply-To: <1277136847-13266-11-git-send-email-stefano@stabellini.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stefano@stabellini.net wrote:
> From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> Use xen_vcpuop_clockevent instead of hpet and APIC timers as main
> clockevent device on all vcpus, use the xen wallclock time as wallclock
> instead of rtc and use xen_clocksource as clocksource.
> The pv clock algorithm needs to work correctly for the xen_clocksource
> and xen wallclock to be usable, only modern Xen versions offer a
> reliable pv clock in HVM guests (XENFEAT_hvm_safe_pvclock).
> 
> Using the hpet as clocksource means a VMEXIT every time we read/write to
> the hpet mmio addresses, pvclock give us a better rating without
> VMEXITs. Same goes for the xen wallclock and xen_vcpuop_clockevent
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/x86/xen/enlighten.c         |   14 +--------
>  arch/x86/xen/suspend.c           |    4 ++
>  arch/x86/xen/time.c              |   59 ++++++++++++++++++++++++++++++++++---
>  arch/x86/xen/xen-ops.h           |    7 +---
>  include/xen/interface/features.h |    3 ++
>  5 files changed, 65 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 90bac21..bcd98a9 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -933,10 +933,6 @@ static const struct pv_init_ops xen_init_ops __initdata = {
>  	.patch = xen_patch,
>  };
>  
> -static const struct pv_time_ops xen_time_ops __initdata = {
> -	.sched_clock = xen_sched_clock,
> -};
> -
>  static const struct pv_cpu_ops xen_cpu_ops __initdata = {
>  	.cpuid = xen_cpuid,
>  
> @@ -1074,7 +1070,6 @@ asmlinkage void __init xen_start_kernel(void)
>  	/* Install Xen paravirt ops */
>  	pv_info = xen_info;
>  	pv_init_ops = xen_init_ops;
> -	pv_time_ops = xen_time_ops;
>  	pv_cpu_ops = xen_cpu_ops;
>  	pv_apic_ops = xen_apic_ops;
>  
> @@ -1082,13 +1077,7 @@ asmlinkage void __init xen_start_kernel(void)
>  	x86_init.oem.arch_setup = xen_arch_setup;
>  	x86_init.oem.banner = xen_banner;
>  
> -	x86_init.timers.timer_init = xen_time_init;
> -	x86_init.timers.setup_percpu_clockev = x86_init_noop;
> -	x86_cpuinit.setup_percpu_clockev = x86_init_noop;
> -
> -	x86_platform.calibrate_tsc = xen_tsc_khz;
> -	x86_platform.get_wallclock = xen_get_wallclock;
> -	x86_platform.set_wallclock = xen_set_wallclock;
> +	xen_init_time_ops();
>  
>  	/*
>  	 * Set up some pagetable state before starting to set any ptes.
> @@ -1330,4 +1319,5 @@ void __init xen_hvm_guest_init(void)
>  	register_cpu_notifier(&xen_hvm_cpu_notifier);
>  	have_vcpu_info_placement = 0;
>  	x86_init.irqs.intr_init = xen_init_IRQ;
> +	xen_hvm_init_time_ops();
>  }
> diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
> index 6ff9665..0774c67 100644
> --- a/arch/x86/xen/suspend.c
> +++ b/arch/x86/xen/suspend.c
> @@ -28,8 +28,12 @@ void xen_pre_suspend(void)
>  
>  void xen_hvm_post_suspend(int suspend_cancelled)
>  {
> +	int cpu;
>  	xen_hvm_init_shared_info();
>  	xen_callback_vector();
> +	for_each_online_cpu(cpu) {
> +		xen_setup_runstate_info(cpu);
> +	}
>  }
>  

As I found out on older xen (non 'modern Xen version' ;-) )
w/o XENFEAT_hvm_safe_pvclock, the above patch should look like:

        if (xen_feature(XENFEAT_hvm_safe_pvclock)) {
                int cpu;
                for_each_online_cpu(cpu) {
                        xen_setup_runstate_info(cpu);
                }
        }

- Don

>  void xen_post_suspend(int suspend_cancelled)
> diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
> index 32764b8..2d76c28 100644
> --- a/arch/x86/xen/time.c
> +++ b/arch/x86/xen/time.c
> @@ -20,6 +20,7 @@
>  #include <asm/xen/hypercall.h>
>  
>  #include <xen/events.h>
> +#include <xen/features.h>
>  #include <xen/interface/xen.h>
>  #include <xen/interface/vcpu.h>
>  
> @@ -160,7 +161,7 @@ static void do_stolen_accounting(void)
>   * nanoseconds, which is nanoseconds the VCPU spent in RUNNING+BLOCKED
>   * states.
>   */
> -unsigned long long xen_sched_clock(void)
> +static unsigned long long xen_sched_clock(void)
>  {
>  	struct vcpu_runstate_info state;
>  	cycle_t now;
> @@ -195,7 +196,7 @@ unsigned long long xen_sched_clock(void)
>  
>  
>  /* Get the TSC speed from Xen */
> -unsigned long xen_tsc_khz(void)
> +static unsigned long xen_tsc_khz(void)
>  {
>  	struct pvclock_vcpu_time_info *info =
>  		&HYPERVISOR_shared_info->vcpu_info[0].time;
> @@ -230,7 +231,7 @@ static void xen_read_wallclock(struct timespec *ts)
>  	put_cpu_var(xen_vcpu);
>  }
>  
> -unsigned long xen_get_wallclock(void)
> +static unsigned long xen_get_wallclock(void)
>  {
>  	struct timespec ts;
>  
> @@ -238,7 +239,7 @@ unsigned long xen_get_wallclock(void)
>  	return ts.tv_sec;
>  }
>  
> -int xen_set_wallclock(unsigned long now)
> +static int xen_set_wallclock(unsigned long now)
>  {
>  	/* do nothing for domU */
>  	return -1;
> @@ -473,7 +474,11 @@ void xen_timer_resume(void)
>  	}
>  }
>  
> -__init void xen_time_init(void)
> +static const struct pv_time_ops xen_time_ops __initdata = {
> +	.sched_clock = xen_sched_clock,
> +};
> +
> +static __init void xen_time_init(void)
>  {
>  	int cpu = smp_processor_id();
>  
> @@ -497,3 +502,47 @@ __init void xen_time_init(void)
>  	xen_setup_timer(cpu);
>  	xen_setup_cpu_clockevents();
>  }
> +
> +__init void xen_init_time_ops(void)
> +{
> +	pv_time_ops = xen_time_ops;
> +
> +	x86_init.timers.timer_init = xen_time_init;
> +	x86_init.timers.setup_percpu_clockev = x86_init_noop;
> +	x86_cpuinit.setup_percpu_clockev = x86_init_noop;
> +
> +	x86_platform.calibrate_tsc = xen_tsc_khz;
> +	x86_platform.get_wallclock = xen_get_wallclock;
> +	x86_platform.set_wallclock = xen_set_wallclock;
> +}
> +
> +static void xen_hvm_setup_cpu_clockevents(void)
> +{
> +	int cpu = smp_processor_id();
> +	xen_setup_runstate_info(cpu);
> +	xen_setup_timer(cpu);
> +	xen_setup_cpu_clockevents();
> +}
> +
> +__init void xen_hvm_init_time_ops(void)
> +{
> +	/* vector callback is needed otherwise we cannot receive interrupts
> +	 * on cpu > 0 */
> +	if (!xen_have_vector_callback && num_present_cpus() > 1)
> +		return;
> +	if (!xen_feature(XENFEAT_hvm_safe_pvclock)) {
> +		printk(KERN_INFO "Xen doesn't support pvclock on HVM,"
> +				"disable pv timer\n");
> +		return;
> +	}
> +
> +	pv_time_ops = xen_time_ops;
> +	x86_init.timers.timer_init = xen_time_init;
> +	x86_init.timers.setup_percpu_clockev = x86_init_noop;
> +	x86_cpuinit.setup_percpu_clockev = xen_hvm_setup_cpu_clockevents;
> +
> +	x86_platform.calibrate_tsc = xen_tsc_khz;
> +	x86_platform.get_wallclock = xen_get_wallclock;
> +	x86_platform.set_wallclock = xen_set_wallclock;
> +}
> +
> diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
> index 01c9dd3..089d189 100644
> --- a/arch/x86/xen/xen-ops.h
> +++ b/arch/x86/xen/xen-ops.h
> @@ -49,11 +49,8 @@ void xen_setup_runstate_info(int cpu);
>  void xen_teardown_timer(int cpu);
>  cycle_t xen_clocksource_read(void);
>  void xen_setup_cpu_clockevents(void);
> -unsigned long xen_tsc_khz(void);
> -void __init xen_time_init(void);
> -unsigned long xen_get_wallclock(void);
> -int xen_set_wallclock(unsigned long time);
> -unsigned long long xen_sched_clock(void);
> +void __init xen_init_time_ops(void);
> +void __init xen_hvm_init_time_ops(void);
>  
>  irqreturn_t xen_debug_interrupt(int irq, void *dev_id);
>  
> diff --git a/include/xen/interface/features.h b/include/xen/interface/features.h
> index 8ab08b9..70d2563 100644
> --- a/include/xen/interface/features.h
> +++ b/include/xen/interface/features.h
> @@ -44,6 +44,9 @@
>  /* x86: Does this Xen host support the HVM callback vector type? */
>  #define XENFEAT_hvm_callback_vector        8
>  
> +/* x86: pvclock algorithm is safe to use on HVM */
> +#define XENFEAT_hvm_safe_pvclock           9
> +
>  #define XENFEAT_NR_SUBMAPS 1
>  
>  #endif /* __XEN_PUBLIC_FEATURES_H__ */

