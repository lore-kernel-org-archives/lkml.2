Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab1BVTbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 14:31:13 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:65505 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107Ab1BVTbM (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 22 Feb 2011 14:31:12 -0500
Date: Tue, 22 Feb 2011 14:30:52 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: stefano.stabellini@eu.citrix.com
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Jeremy.Fitzhardinge@citrix.com
Subject: Re: [PATCH 6/7] xen: enable event channels to send and receive
 IPIs for PV on HVM guests
Message-ID: <20110222193052.GB17866@dumpdata.com>
References: <alpine.DEB.2.00.1102161739370.2826@kaball-desktop>
 <1297878787-378-6-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297878787-378-6-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4D640EFA.0072:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 05:53:06PM +0000, stefano.stabellini@eu.citrix.com wrote:
> From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> Enable the usage of event channels to send and receive IPIs when
> running as a PV on HVM guest.

Why not squash this with the other patch? After this, the only thing
that the other patch had done was to add in the 'xen_hvm_cpu_notify' function
a call to setup the spinlocks..

> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/x86/xen/enlighten.c |   16 +---------------
>  arch/x86/xen/smp.c       |   42 ++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/xen/xen-ops.h   |    2 ++
>  3 files changed, 45 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 9c1628b..fe02574 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1343,20 +1343,6 @@ static struct notifier_block __cpuinitdata xen_hvm_cpu_notifier = {
>  	.notifier_call	= xen_hvm_cpu_notify,
>  };
>  
> -static void xen_hvm_spinlock_init(void)
> -{
> -	if (!xen_have_vector_callback)
> -		return;
> -	xen_init_lock_cpu(0);
> -	xen_init_spinlocks();
> -}
> -
> -static void __init xen_hvm_smp_prepare_cpus(unsigned int max_cpus)
> -{
> -	native_smp_prepare_cpus(max_cpus);
> -	xen_hvm_spinlock_init();
> -}
> -
>  static void __init xen_hvm_guest_init(void)
>  {
>  	int r;
> @@ -1370,13 +1356,13 @@ static void __init xen_hvm_guest_init(void)
>  
>  	if (xen_feature(XENFEAT_hvm_callback_vector))
>  		xen_have_vector_callback = 1;
> +	xen_hvm_smp_init();
>  	register_cpu_notifier(&xen_hvm_cpu_notifier);
>  	xen_unplug_emulated_devices();
>  	have_vcpu_info_placement = 0;
>  	x86_init.irqs.intr_init = xen_init_IRQ;
>  	xen_hvm_init_time_ops();
>  	xen_hvm_init_mmu_ops();
> -	smp_ops.smp_prepare_cpus = xen_hvm_smp_prepare_cpus;
>  }
>  
>  static bool __init xen_hvm_platform(void)
> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> index 72a4c79..2300d4b 100644
> --- a/arch/x86/xen/smp.c
> +++ b/arch/x86/xen/smp.c
> @@ -509,3 +509,45 @@ void __init xen_smp_init(void)
>  	xen_fill_possible_map();
>  	xen_init_spinlocks();
>  }
> +
> +static void xen_hvm_spinlock_init(void)
> +{
> +	if (!xen_have_vector_callback)
> +		return;
> +	xen_init_lock_cpu(0);
> +	xen_init_spinlocks();
> +}
> +
> +static void __init xen_hvm_smp_prepare_cpus(unsigned int max_cpus)
> +{
> +	native_smp_prepare_cpus(max_cpus);
> +	WARN_ON(xen_smp_intr_init(0));
> +	xen_hvm_spinlock_init();

Why not merge 'xen_hvm_spinlock_init' in here?

> +}
> +
> +static int __cpuinit xen_hvm_cpu_up(unsigned int cpu)
> +{
> +	int rc;
> +	rc = native_cpu_up(cpu);
> +	WARN_ON (xen_smp_intr_init(cpu));
> +	return rc;
> +}
> +
> +static void xen_hvm_cpu_die(unsigned int cpu)
> +{
> +	unbind_from_irqhandler(per_cpu(xen_resched_irq, cpu), NULL);
> +	unbind_from_irqhandler(per_cpu(xen_callfunc_irq, cpu), NULL);
> +	unbind_from_irqhandler(per_cpu(xen_debug_irq, cpu), NULL);
> +	unbind_from_irqhandler(per_cpu(xen_callfuncsingle_irq, cpu), NULL);
> +	native_cpu_die(cpu);
> +}
> +
> +void __init xen_hvm_smp_init(void)
> +{
> +	smp_ops.smp_prepare_cpus = xen_hvm_smp_prepare_cpus;
> +	smp_ops.smp_send_reschedule = xen_smp_send_reschedule;
> +	smp_ops.cpu_up = xen_hvm_cpu_up;
> +	smp_ops.cpu_die = xen_hvm_cpu_die;
> +	smp_ops.send_call_func_ipi = xen_smp_send_call_function_ipi;
> +	smp_ops.send_call_func_single_ipi = xen_smp_send_call_function_single_ipi;
> +}
> diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
> index 9d41bf9..3112f55 100644
> --- a/arch/x86/xen/xen-ops.h
> +++ b/arch/x86/xen/xen-ops.h
> @@ -64,10 +64,12 @@ void xen_setup_vcpu_info_placement(void);
>  
>  #ifdef CONFIG_SMP
>  void xen_smp_init(void);
> +void __init xen_hvm_smp_init(void);
>  
>  extern cpumask_var_t xen_cpu_initialized_map;
>  #else
>  static inline void xen_smp_init(void) {}
> +static inline void xen_hvm_smp_init(void) {}
>  #endif
>  
>  #ifdef CONFIG_PARAVIRT_SPINLOCKS
> -- 
> 1.5.6.5
