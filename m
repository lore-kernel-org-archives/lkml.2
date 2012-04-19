Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab2DSTHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 15:07:42 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:45168 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab2DSTHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 15:07:41 -0400
Date: Thu, 19 Apr 2012 15:02:17 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Lin Ming <mlin@ss.pku.edu.cn>
Cc: linux-kernel@vger.kernel.org, Steven Noonan <steven@uplinklabs.net>,
        Ben Guthro <ben@guthro.net>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Marcus Granado <marcus.granado@citrix.com>, xen-devel@lists.xen.org
Subject: Re: [PATCH 1/2] xen: implement apic ipi interface
Message-ID: <20120419190217.GA29124@phenom.dumpdata.com>
References: <1334470172-3861-1-git-send-email-mlin@ss.pku.edu.cn>
 <1334470172-3861-2-git-send-email-mlin@ss.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334470172-3861-2-git-send-email-mlin@ss.pku.edu.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090207.4F90626E.0044,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2012 at 02:09:31PM +0800, Lin Ming wrote:
> From: Ben Guthro <ben@guthro.net>
> 
> Map native ipi vector to xen vector.
> Implement apic ipi interface with xen_send_IPI_one.

I keep on getting this (so PV guest without any SMP support,
and with just PV frontend drivers):


echo "CONFIG_PARAVIRT_GUEST=y" > linux.config
echo "CONFIG_XEN=y" >> linux.config
echo "CONFIG_XEN_XENBUS_FRONTEND=m" >> linux.config
cat xen.config | grep FRONTEND >> linux.config
echo "# CONFIG_XEN_PRIVILEGED_GUEST is not set" >> linux.config
echo "# CONFIG_XEN_DOM0 is not set" >> linux.config
echo "# CONFIG_ACPI is not set" >> linux.config
echo "# CONFIG_PCI is not set" >> linux.config
echo "# CONFIG_XENFS is not set" >> linux.config
echo "# CONFIG_SMP is not set" >> linux.config


make -j$((4 * 2)) -C /home/konrad/ssd/konrad/xtt-compile/linux O=/home/konrad/ssd/konrad/xtt-compile/linux-build- defconfig
make[2]: Entering directory `/home/konrad/ssd/konrad/linux'
  GEN     /home/konrad/ssd/konrad/xtt-compile/linux-build-/Makefile
*** Default configuration is based on 'x86_64_defconfig'
#
# configuration written to .config

cat linux.config >> linux-build-/.config

make -j4 ..

  LD      init/built-in.o
  LD      .tmp_vmlinux1
arch/x86/built-in.o: In function `xen_start_kernel':
(.init.text+0x5a8): undefined reference to `xen_send_IPI_allbutself'
arch/x86/built-in.o: In function `xen_start_kernel':
(.init.text+0x5b3): undefined reference to `xen_send_IPI_mask_allbutself'
arch/x86/built-in.o: In function `xen_start_kernel':
(.init.text+0x5be): undefined reference to `xen_send_IPI_mask'
arch/x86/built-in.o: In function `xen_start_kernel':
(.init.text+0x5c9): undefined reference to `xen_send_IPI_all'
arch/x86/built-in.o: In function `xen_start_kernel':
(.init.text+0x5d4): undefined reference to `xen_send_IPI_self'
make[2]: *** [.tmp_vmlinux1] Error 1
> 
> Signed-off-by: Ben Guthro <ben@guthro.net>
> Signed-off-by: Lin Ming <mlin@ss.pku.edu.cn>
> ---
> 
> Ben,
> 
> This patch was taken from part of your patch at:
> https://lkml.org/lkml/2012/2/10/681
> 
> Is it OK that I added your SOB?
> 
> I did some change to map native ipi vector to xen vector.
> Could you please review?
> 
> Thanks.
> 
>  arch/x86/xen/enlighten.c |    7 ++++
>  arch/x86/xen/smp.c       |   81 +++++++++++++++++++++++++++++++++++++++++++--
>  arch/x86/xen/smp.h       |   12 +++++++
>  3 files changed, 96 insertions(+), 4 deletions(-)
>  create mode 100644 arch/x86/xen/smp.h
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 4f51beb..be7dbc8 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -74,6 +74,7 @@
>  
>  #include "xen-ops.h"
>  #include "mmu.h"
> +#include "smp.h"
>  #include "multicalls.h"
>  
>  EXPORT_SYMBOL_GPL(hypercall_page);
> @@ -849,6 +850,12 @@ static void set_xen_basic_apic_ops(void)
>  	apic->icr_write = xen_apic_icr_write;
>  	apic->wait_icr_idle = xen_apic_wait_icr_idle;
>  	apic->safe_wait_icr_idle = xen_safe_apic_wait_icr_idle;
> +
> +	apic->send_IPI_allbutself = xen_send_IPI_allbutself;
> +	apic->send_IPI_mask_allbutself = xen_send_IPI_mask_allbutself;
> +	apic->send_IPI_mask = xen_send_IPI_mask;
> +	apic->send_IPI_all = xen_send_IPI_all;
> +	apic->send_IPI_self = xen_send_IPI_self;
>  }
>  
>  #endif
> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> index 5fac691..2dc6628 100644
> --- a/arch/x86/xen/smp.c
> +++ b/arch/x86/xen/smp.c
> @@ -465,8 +465,8 @@ static void xen_smp_send_reschedule(int cpu)
>  	xen_send_IPI_one(cpu, XEN_RESCHEDULE_VECTOR);
>  }
>  
> -static void xen_send_IPI_mask(const struct cpumask *mask,
> -			      enum ipi_vector vector)
> +static void __xen_send_IPI_mask(const struct cpumask *mask,
> +			      int vector)
>  {
>  	unsigned cpu;
>  
> @@ -478,7 +478,7 @@ static void xen_smp_send_call_function_ipi(const struct cpumask *mask)
>  {
>  	int cpu;
>  
> -	xen_send_IPI_mask(mask, XEN_CALL_FUNCTION_VECTOR);
> +	__xen_send_IPI_mask(mask, XEN_CALL_FUNCTION_VECTOR);
>  
>  	/* Make sure other vcpus get a chance to run if they need to. */
>  	for_each_cpu(cpu, mask) {
> @@ -491,10 +491,83 @@ static void xen_smp_send_call_function_ipi(const struct cpumask *mask)
>  
>  static void xen_smp_send_call_function_single_ipi(int cpu)
>  {
> -	xen_send_IPI_mask(cpumask_of(cpu),
> +	__xen_send_IPI_mask(cpumask_of(cpu),
>  			  XEN_CALL_FUNCTION_SINGLE_VECTOR);
>  }
>  
> +static inline int xen_map_vector(int vector)
> +{
> +	int xen_vector;
> +
> +	switch (vector) {
> +	case RESCHEDULE_VECTOR:
> +		xen_vector = XEN_RESCHEDULE_VECTOR;
> +		break;
> +	case CALL_FUNCTION_VECTOR:
> +		xen_vector = XEN_CALL_FUNCTION_VECTOR;
> +		break;
> +	case CALL_FUNCTION_SINGLE_VECTOR:
> +		xen_vector = XEN_CALL_FUNCTION_SINGLE_VECTOR;
> +		break;
> +	default:
> +		xen_vector = -1;
> +		printk(KERN_ERR "xen: vector 0x%x is not implemented\n",
> +			vector);
> +	}
> +
> +	return xen_vector;
> +}
> +
> +void xen_send_IPI_mask(const struct cpumask *mask,
> +			      int vector)
> +{
> +	int xen_vector = xen_map_vector(vector);
> +
> +	if (xen_vector >= 0)
> +		__xen_send_IPI_mask(mask, xen_vector);
> +}
> +
> +void xen_send_IPI_all(int vector)
> +{
> +	int xen_vector = xen_map_vector(vector);
> +
> +	if (xen_vector >= 0)
> +		__xen_send_IPI_mask(cpu_online_mask, xen_vector);
> +}
> +
> +void xen_send_IPI_self(int vector)
> +{
> +	int xen_vector = xen_map_vector(vector);
> +
> +	if (xen_vector >= 0)
> +		xen_send_IPI_one(smp_processor_id(), xen_vector);
> +}
> +
> +void xen_send_IPI_mask_allbutself(const struct cpumask *mask,
> +				int vector)
> +{
> +	unsigned cpu;
> +	unsigned int this_cpu = smp_processor_id();
> +
> +	if (!(num_online_cpus() > 1))
> +		return;
> +
> +	for_each_cpu_and(cpu, mask, cpu_online_mask) {
> +		if (this_cpu == cpu)
> +			continue;
> +
> +		xen_smp_send_call_function_single_ipi(cpu);
> +	}
> +}
> +
> +void xen_send_IPI_allbutself(int vector)
> +{
> +	int xen_vector = xen_map_vector(vector);
> +
> +	if (xen_vector >= 0)
> +		xen_send_IPI_mask_allbutself(cpu_online_mask, xen_vector);
> +}
> +
>  static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id)
>  {
>  	irq_enter();
> diff --git a/arch/x86/xen/smp.h b/arch/x86/xen/smp.h
> new file mode 100644
> index 0000000..8981a76
> --- /dev/null
> +++ b/arch/x86/xen/smp.h
> @@ -0,0 +1,12 @@
> +#ifndef _XEN_SMP_H
> +
> +extern void xen_send_IPI_mask(const struct cpumask *mask,
> +			      int vector);
> +extern void xen_send_IPI_mask_allbutself(const struct cpumask *mask,
> +				int vector);
> +extern void xen_send_IPI_allbutself(int vector);
> +extern void physflat_send_IPI_allbutself(int vector);
> +extern void xen_send_IPI_all(int vector);
> +extern void xen_send_IPI_self(int vector);
> +
> +#endif
> -- 
> 1.7.2.5
