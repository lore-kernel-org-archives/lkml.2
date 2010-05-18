Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab0ERSXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 14:23:37 -0400
Received: from claw.goop.org ([74.207.240.146]:49251 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424Ab0ERSXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 14:23:36 -0400
Message-ID: <4BF2DB26.9090803@goop.org>
Date: Tue, 18 May 2010 11:23:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       Don Dutile <ddutile@redhat.com>, Sheng Yang <sheng@linux.intel.com>
Subject: Re: [PATCH 11/12] Support VIRQ_TIMER and pvclock on HVM
References: <alpine.DEB.2.00.1005181054260.11380@kaball-desktop> <1274178187-20602-11-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1274178187-20602-11-git-send-email-stefano.stabellini@eu.citrix.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2010 03:23 AM, Stefano Stabellini wrote:

Please describe what you're doing, why its useful and how it works.

> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/x86/xen/enlighten.c         |   39 +++++++++++++++++++++++++++++++++++++-
>  arch/x86/xen/time.c              |    3 ++
>  drivers/xen/manage.c             |    1 +
>  include/xen/interface/features.h |    3 ++
>  4 files changed, 45 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 77ba321..41677fe 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1274,6 +1274,7 @@ void init_shared_info(void)
>  {
>  	struct xen_add_to_physmap xatp;
>  	static struct shared_info *shared_info_page = 0;
> +	int cpu;
>  
>  	if (!shared_info_page)
>  		shared_info_page = (struct shared_info *) alloc_bootmem_pages(PAGE_SIZE);
> @@ -1288,7 +1289,42 @@ void init_shared_info(void)
>  
>  	/* Don't do the full vcpu_info placement stuff until we have a
>  	   possible map and a non-dummy shared_info. */
> -	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
> +	/* This code is run at resume time so make sure all the online cpus
> +	 * have xen_vcpu properly set */
>   

Why is this necessary? Can the vcpu structures move on resume?

> +	for_each_online_cpu(cpu)
> +		per_cpu(xen_vcpu, cpu) = &HYPERVISOR_shared_info->vcpu_info[cpu];
> +}
> +
> +static void xen_hvm_setup_cpu_clockevents(void)
> +{
> +	int cpu = smp_processor_id();
> +	xen_setup_timer(cpu);
> +	per_cpu(xen_vcpu, cpu) = &HYPERVISOR_shared_info->vcpu_info[cpu];
> +	xen_setup_cpu_clockevents();
> +}
> +
> +static void init_hvm_time(void)
> +{
> +#ifdef CONFIG_SMP
> +	/* vector callback is needed otherwise we cannot receive interrupts
> +	 * on cpu > 0 */
> +	if (!xen_have_vector_callback)
> +		return;
>   

Putting this check in CONFIG_SMP is more or less pointless, since
effectively every kernel is built with SMP enabled now.  Can you either
check whether the max CPUs is 1, or just make it always depend on vector
callback, even on a UP kernel/domain?

> +#endif
> +	if (!xen_feature(XENFEAT_hvm_safe_pvclock)) {
> +		printk(KERN_WARNING "Xen doesn't support pvclock on HVM,"
> +				"disable pv timer\n");
>   

What does this mean?  Is it asking the user to do something?

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
>  }
>  
>  int xen_set_callback_via(uint64_t via)
> @@ -1373,6 +1409,7 @@ void __init xen_guest_init(void)
>  		outw(unplug, XEN_IOPORT_UNPLUG);
>  	have_vcpu_info_placement = 0;
>  	x86_init.irqs.intr_init = xen_init_IRQ;
> +	init_hvm_time();
>  }
>  
>  static int __init parse_unplug(char *arg)
> diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
> index 32764b8..620e68f 100644
> --- a/arch/x86/xen/time.c
> +++ b/arch/x86/xen/time.c
> @@ -19,6 +19,7 @@
>  #include <asm/xen/hypervisor.h>
>  #include <asm/xen/hypercall.h>
>  
> +#include <xen/xen.h>
>  #include <xen/events.h>
>  #include <xen/interface/xen.h>
>  #include <xen/interface/vcpu.h>
> @@ -470,6 +471,8 @@ void xen_timer_resume(void)
>  	for_each_online_cpu(cpu) {
>  		if (HYPERVISOR_vcpu_op(VCPUOP_stop_periodic_timer, cpu, NULL))
>  			BUG();
> +		if (xen_hvm_domain())
> +			xen_setup_runstate_info(cpu);
>  	}
>  }
>  
> diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
> index 49ee52d..4a8af22 100644
> --- a/drivers/xen/manage.c
> +++ b/drivers/xen/manage.c
> @@ -60,6 +60,7 @@ static int xen_hvm_suspend(void *data)
>  	if (!*cancelled) {
>  		xen_irq_resume();
>  		platform_pci_resume_hook();
> +		xen_timer_resume();
>  	}
>  
>  	return 0;
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
>   

Why is this needed?  When is it not safe?

> +
>  #define XENFEAT_NR_SUBMAPS 1
>  
>  #endif /* __XEN_PUBLIC_FEATURES_H__ */
>   

