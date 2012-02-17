Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab2BQKFB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 05:05:01 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:38497 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab2BQKE7 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Fri, 17 Feb 2012 05:04:59 -0500
Message-Id: <4F3E345802000078000739B2@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 17 Feb 2012 10:04:56 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Jinsong Liu" <jinsong.liu@intel.com>
Cc: "keir.xen@gmail.com" <keir.xen@gmail.com>,
        "Shaohua Li" <shaohua.li@intel.com>,
        "xen-devel" <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "Kerneldevelopment list" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] PAD helper for native and paravirt platform
References: <DE8DF0795D48FD4CA783C40EC829233509D853@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC829233509D853@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 17.02.12 at 09:56, "Liu, Jinsong" <jinsong.liu@intel.com> wrote:
> From f66a2df1392bbe69426387657a220177be50d58a Mon Sep 17 00:00:00 2001
> From: Liu, Jinsong <jinsong.liu@intel.com>
> Date: Fri, 10 Feb 2012 20:32:50 +0800
> Subject: [PATCH 1/3] PAD helper for native and paravirt platform
> 
> This patch is PAD (Processor Aggregator Device) helper.
> It provides a native interface for natvie platform, and a template
> for paravirt platform, so that os can implicitly hook to proper ops 
> accordingly.
> The paravirt template will further redirect to Xen pv ops in later patch for 
> Xen
>  core parking.
> 
> Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
> ---
>  arch/x86/include/asm/paravirt.h       |   10 +++++
>  arch/x86/include/asm/paravirt_types.h |    7 ++++
>  arch/x86/kernel/paravirt.c            |    9 +++++
>  drivers/acpi/acpi_pad.c               |   15 +++-----
>  include/acpi/acpi_pad.h               |   61 
> +++++++++++++++++++++++++++++++++
>  5 files changed, 93 insertions(+), 9 deletions(-)
>  create mode 100644 include/acpi/acpi_pad.h
> 
> diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
> index a7d2db9..02e6df0 100644
> --- a/arch/x86/include/asm/paravirt.h
> +++ b/arch/x86/include/asm/paravirt.h
> @@ -54,6 +54,16 @@ static inline unsigned long read_cr0(void)
>  	return PVOP_CALL0(unsigned long, pv_cpu_ops.read_cr0);
>  }
>  
> +static inline int __acpi_pad_init(void)
> +{
> +	return PVOP_CALL0(int, pv_pad_ops.acpi_pad_init);
> +}
> +
> +static inline void __acpi_pad_exit(void)
> +{
> +	PVOP_VCALL0(pv_pad_ops.acpi_pad_exit);
> +}

With this you, aiui, you aim at getting the calls patched. Are the callers
of this really on performance critical paths? If not, the simpler approach
of having an ops structure the fields of which get overwritten by
Xen initialization would seem a more appropriate approach.

Jan

> +
>  static inline void write_cr0(unsigned long x)
>  {
>  	PVOP_VCALL1(pv_cpu_ops.write_cr0, x);
> diff --git a/arch/x86/include/asm/paravirt_types.h 
> b/arch/x86/include/asm/paravirt_types.h
> index 8e8b9a4..61e20de 100644
> --- a/arch/x86/include/asm/paravirt_types.h
> +++ b/arch/x86/include/asm/paravirt_types.h
> @@ -336,6 +336,11 @@ struct pv_lock_ops {
>  	void (*spin_unlock)(struct arch_spinlock *lock);
>  };
>  
> +struct pv_pad_ops {
> +	int (*acpi_pad_init)(void);
> +	void (*acpi_pad_exit)(void);
> +};
> +
>  /* This contains all the paravirt structures: we get a convenient
>   * number for each function using the offset which we use to indicate
>   * what to patch. */
> @@ -347,6 +352,7 @@ struct paravirt_patch_template {
>  	struct pv_apic_ops pv_apic_ops;
>  	struct pv_mmu_ops pv_mmu_ops;
>  	struct pv_lock_ops pv_lock_ops;
> +	struct pv_pad_ops pv_pad_ops;
>  };
>  
>  extern struct pv_info pv_info;
> @@ -357,6 +363,7 @@ extern struct pv_irq_ops pv_irq_ops;
>  extern struct pv_apic_ops pv_apic_ops;
>  extern struct pv_mmu_ops pv_mmu_ops;
>  extern struct pv_lock_ops pv_lock_ops;
> +extern struct pv_pad_ops pv_pad_ops;
>  
>  #define PARAVIRT_PATCH(x)					\
>  	(offsetof(struct paravirt_patch_template, x) / sizeof(void *))
> diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
> index d90272e..ec778f6 100644
> --- a/arch/x86/kernel/paravirt.c
> +++ b/arch/x86/kernel/paravirt.c
> @@ -38,6 +38,8 @@
>  #include <asm/tlbflush.h>
>  #include <asm/timer.h>
>  
> +#include <acpi/acpi_pad.h>
> +
>  /* nop stub */
>  void _paravirt_nop(void)
>  {
> @@ -132,6 +134,7 @@ static void *get_call_destination(u8 type)
>  #ifdef CONFIG_PARAVIRT_SPINLOCKS
>  		.pv_lock_ops = pv_lock_ops,
>  #endif
> +		.pv_pad_ops = pv_pad_ops,
>  	};
>  	return *((void **)&tmpl + type);
>  }
> @@ -480,9 +483,15 @@ struct pv_mmu_ops pv_mmu_ops = {
>  	.set_fixmap = native_set_fixmap,
>  };
>  
> +struct pv_pad_ops pv_pad_ops = {
> +	.acpi_pad_init = native_acpi_pad_init,
> +	.acpi_pad_exit = native_acpi_pad_exit,
> +};
> +
>  EXPORT_SYMBOL_GPL(pv_time_ops);
>  EXPORT_SYMBOL    (pv_cpu_ops);
>  EXPORT_SYMBOL    (pv_mmu_ops);
>  EXPORT_SYMBOL_GPL(pv_apic_ops);
>  EXPORT_SYMBOL_GPL(pv_info);
>  EXPORT_SYMBOL    (pv_irq_ops);
> +EXPORT_SYMBOL_GPL(pv_pad_ops);
> diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
> index a43fa1a..3f0fd27 100644
> --- a/drivers/acpi/acpi_pad.c
> +++ b/drivers/acpi/acpi_pad.c
> @@ -30,6 +30,7 @@
>  #include <linux/slab.h>
>  #include <acpi/acpi_bus.h>
>  #include <acpi/acpi_drivers.h>
> +#include <acpi/acpi_pad.h>
>  #include <asm/mwait.h>
>  
>  #define ACPI_PROCESSOR_AGGREGATOR_CLASS	"acpi_pad"
> @@ -37,14 +38,14 @@
>  #define ACPI_PROCESSOR_AGGREGATOR_NOTIFY 0x80
>  static DEFINE_MUTEX(isolated_cpus_lock);
>  
> -static unsigned long power_saving_mwait_eax;
> +unsigned long power_saving_mwait_eax;
>  
>  static unsigned char tsc_detected_unstable;
>  static unsigned char tsc_marked_unstable;
>  static unsigned char lapic_detected_unstable;
>  static unsigned char lapic_marked_unstable;
>  
> -static void power_saving_mwait_init(void)
> +void power_saving_mwait_init(void)
>  {
>  	unsigned int eax, ebx, ecx, edx;
>  	unsigned int highest_cstate = 0;
> @@ -500,7 +501,7 @@ static const struct acpi_device_id pad_device_ids[] = {
>  };
>  MODULE_DEVICE_TABLE(acpi, pad_device_ids);
>  
> -static struct acpi_driver acpi_pad_driver = {
> +struct acpi_driver acpi_pad_driver = {
>  	.name = "processor_aggregator",
>  	.class = ACPI_PROCESSOR_AGGREGATOR_CLASS,
>  	.ids = pad_device_ids,
> @@ -512,16 +513,12 @@ static struct acpi_driver acpi_pad_driver = {
>  
>  static int __init acpi_pad_init(void)
>  {
> -	power_saving_mwait_init();
> -	if (power_saving_mwait_eax == 0)
> -		return -EINVAL;
> -
> -	return acpi_bus_register_driver(&acpi_pad_driver);
> +	return __acpi_pad_init();
>  }
>  
>  static void __exit acpi_pad_exit(void)
>  {
> -	acpi_bus_unregister_driver(&acpi_pad_driver);
> +	__acpi_pad_exit();
>  }
>  
>  module_init(acpi_pad_init);
> diff --git a/include/acpi/acpi_pad.h b/include/acpi/acpi_pad.h
> new file mode 100644
> index 0000000..1a1471d
> --- /dev/null
> +++ b/include/acpi/acpi_pad.h
> @@ -0,0 +1,61 @@
> +/*
> + *  acpi_pad.h - pad device helper for native and paravirt platform
> + *
> + *  Copyright (C) 2012, Intel Corporation.
> + *     Author: Liu, Jinsong <jinsong.liu@intel.com>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or (at
> + *  your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful, but
> + *  WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + *  General Public License for more details.
> + */
> +
> +#ifndef __ACPI_PAD_H__
> +#define __ACPI_PAD_H__
> +
> +#include <acpi/acpi_bus.h>
> +
> +extern unsigned long power_saving_mwait_eax;
> +extern struct acpi_driver acpi_pad_driver;
> +extern void power_saving_mwait_init(void);
> +
> +static inline int native_acpi_pad_init(void)
> +{
> +#ifdef CONFIG_ACPI_PROCESSOR_AGGREGATOR
> +	power_saving_mwait_init();
> +	if (power_saving_mwait_eax == 0)
> +		return -EINVAL;
> +
> +	return acpi_bus_register_driver(&acpi_pad_driver);
> +#else
> +	return 0;
> +#endif
> +}
> +
> +static inline void native_acpi_pad_exit(void)
> +{
> +#ifdef CONFIG_ACPI_PROCESSOR_AGGREGATOR
> +	acpi_bus_unregister_driver(&acpi_pad_driver);
> +#endif
> +}
> +
> +#ifdef CONFIG_PARAVIRT
> +#include <asm/paravirt.h>
> +#else
> +static inline int __acpi_pad_init(void)
> +{
> +	return native_acpi_pad_init();
> +}
> +
> +static inline void __acpi_pad_exit(void)
> +{
> +	native_acpi_pad_exit();
> +}
> +#endif
> +
> +#endif /* __ACPI_PAD_H__ */
> -- 
> 1.7.1


