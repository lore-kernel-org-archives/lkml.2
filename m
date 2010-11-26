Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694Ab0KZVoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 16:44:55 -0500
Received: from gate.crashing.org ([63.228.1.57]:33754 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805Ab0KZVoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 16:44:54 -0500
Subject: Re: [PATCH 02/11] x86: Add device tree support
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org
In-Reply-To: <1290706801-7323-3-git-send-email-bigeasy@linutronix.de>
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
	 <1290706801-7323-3-git-send-email-bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 27 Nov 2010 08:42:16 +1100
Message-ID: <1290807736.32570.143.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-25 at 18:39 +0100, Sebastian Andrzej Siewior wrote:
> This patch adds minimal support for device tree support on x86. It will
> be passed to the kernel via setup_data which requires atleast boot
> protocol 2.09.
> Memory size, restricted memory regions, boot arguments are gathered the
> traditional way so things like cmd_line are just here to let the code
> compile.
> The current plan is use the device tree as an extension and to gather
> informations from it which can not be enumerated and have to be
> hardcoded otherwise. This includes things like
> - which devices are on this I2C/ SPI bus?
> - how are the interrupts wired to IO APIC?
> - where could my hpet be?

How do that work with platforms like OLPC that have a real OF ?

One thing we did on powerpc which among other things allow kexec to work
on such platforms when we kill OF at boot (it might stay alive on OLPC),
is to basically detect very early in asm that we are coming from OF,
have a trampoline that extract the DT and turns it into a flat dtb, then
continue to the main kernel entry using the dtb method.

That way, one can kexec using the dtb method over and there's one single
entry point for device-tree use.

Are you doing something similar for x86 ?

> Dirk is working on some patches which provide generic infrastructure for
> linking the dtb into the kernel. Once this is it its final shape, we
> will relocate the device tree unconditionally. This will remove the
> requirement for the boot loader to locate the device tree within lowmem.

Linking the dtb into the kernel is something we prefer not doing on
powerpc and I'm curious why you think that applies better on x86...

We -do- have ways to include it in the zImage wrapper. However, this is
different in subtle ways because of the way our zImage wrapper building
works. Basically, we always build all the per-platform .o's of the
wrapper that apply to supported platforms by the kernel. The
binding/linking together of the final wrapper with a kernel image, an
optional dtb and optional initrd is performed by a shell script that can
be used outside of the normal build context.

That means that it's possible for a distro for example to install a
kernel image, all the wrapper .o files and that script, and at runtime
rebuild zImage wrappers with the appropriate dtb without having the
whole built kernel tree at hand.

The direction taken by ARM (and possibly newer powerpc platforms as
well) is to have the dtb be passed by the bootloader. Typically
bootloaders like uboot provide a way to flash the dtb separately so it
can be udpated (*).

(*) That brings a separate topic we shall discuss: A consistent way for
versionning the device-tree would be really useful.

Cheers,
Ben.

> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> CC: x86@kernel.org
> Cc: devicetree-discuss@lists.ozlabs.org
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
> ---
>  Documentation/x86/boot_with_dtb.txt |   20 +++++++++++
>  arch/x86/Kconfig                    |    7 ++++
>  arch/x86/include/asm/bootparam.h    |    1 +
>  arch/x86/include/asm/prom.h         |   60 +++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/Makefile            |    1 +
>  arch/x86/kernel/irqinit.c           |    7 ++++
>  arch/x86/kernel/prom.c              |   60 +++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/setup.c             |    4 ++
>  8 files changed, 160 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/x86/boot_with_dtb.txt
>  create mode 100644 arch/x86/include/asm/prom.h
>  create mode 100644 arch/x86/kernel/prom.c
> 
> diff --git a/Documentation/x86/boot_with_dtb.txt b/Documentation/x86/boot_with_dtb.txt
> new file mode 100644
> index 0000000..3ba42b4
> --- /dev/null
> +++ b/Documentation/x86/boot_with_dtb.txt
> @@ -0,0 +1,20 @@
> +  Booting x86 with device tree
> +=================================
> +
> +1. Introduction
> +~~~~~~~~~~~~~~~
> +This document contains device tree informations which are specific to
> +the x86 platform. Generic informations as bindings can be found in
> +Documentation/powerpc/dts-bindings/
> +
> +2. Passing the device tree
> +~~~~~~~~~~~~~~~~~~~~~~~~~~
> +The pointer to the device tree block (dtb) is passed via setup_data
> +(see [0]) which requires atleast boot protocol 2.09. The type filed is
> +defined as
> +
> +#define SETUP_DTB                      2
> +
> +The setup_data struct has to be placed in lowmem.
> +
> +[0] Documentation/x86/boot.txt
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 6ab6310..6c9ab9e 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -299,6 +299,13 @@ config X86_BIGSMP
>  	---help---
>  	  This option is needed for the systems that have more than 8 CPUs
>  
> +config X86_OF
> +	bool "Support for device tree"
> +	select OF
> +	select OF_FLATTREE
> +	---help---
> +	  Device tree support on X86.
> +
>  if X86_32
>  config X86_EXTENDED_PLATFORM
>  	bool "Support for extended (non-PC) x86 platforms"
> diff --git a/arch/x86/include/asm/bootparam.h b/arch/x86/include/asm/bootparam.h
> index c8bfe63..e020d88 100644
> --- a/arch/x86/include/asm/bootparam.h
> +++ b/arch/x86/include/asm/bootparam.h
> @@ -12,6 +12,7 @@
>  /* setup data types */
>  #define SETUP_NONE			0
>  #define SETUP_E820_EXT			1
> +#define SETUP_DTB			2
>  
>  /* extensible setup data list node */
>  struct setup_data {
> diff --git a/arch/x86/include/asm/prom.h b/arch/x86/include/asm/prom.h
> new file mode 100644
> index 0000000..8fdb0d2
> --- /dev/null
> +++ b/arch/x86/include/asm/prom.h
> @@ -0,0 +1,60 @@
> +/*
> + * Definitions for Device tree / OpenFirmware handling on X86
> + *
> + * based on arch/powerpc/include/asm/prom.h which is
> + *         Copyright (C) 1996-2005 Paul Mackerras.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version
> + * 2 of the License, or (at your option) any later version.
> + */
> +
> +#ifndef _ASM_X86_PROM_H
> +#define _ASM_X86_PROM_H
> +#ifdef __KERNEL__
> +#ifndef __ASSEMBLY__
> +
> +#include <linux/of.h>
> +#include <linux/types.h>
> +#include <asm/irq.h>
> +#include <asm/atomic.h>
> +#include <asm/setup.h>
> +
> +#ifdef CONFIG_OF
> +extern void init_dtb(void);
> +extern void add_dtb(u64 data);
> +#else
> +static inline void init_dtb(void) { }
> +static inline void add_dtb(u64 data) { }
> +#endif
> +
> +extern char cmd_line[COMMAND_LINE_SIZE];
> +/* This number is used when no interrupt has been assigned */
> +#define NO_IRQ		(-1)
> +
> +/**
> + * irq_dispose_mapping - Unmap an interrupt
> + * @virq: linux virq number of the interrupt to unmap
> + *
> + * FIXME: We really should implement proper virq handling like power,
> + * but that's going to be major surgery.
> + */
> +static inline void irq_dispose_mapping(unsigned int virq) { }
> +
> +#define HAVE_ARCH_DEVTREE_FIXUPS
> +
> +#endif /* __ASSEMBLY__ */
> +#endif /* __KERNEL__ */
> +
> +/*
> + * These includes are put at the bottom because they may contain things
> + * that are overridden by this file.  Ideally they shouldn't be included
> + * by this file, but there are a bunch of .c files that currently depend
> + * on it.  Eventually they will be cleaned up.
> + */
> +#include <linux/of_fdt.h>
> +#include <linux/of_irq.h>
> +#include <linux/platform_device.h>
> +
> +#endif
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index 9e13763..e0a00c5 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -109,6 +109,7 @@ obj-$(CONFIG_MICROCODE)			+= microcode.o
>  obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) += check.o
>  
>  obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb.o
> +obj-$(CONFIG_X86_OF)			+= prom.o
>  
>  ###
>  # 64 bit specific files
> diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
> index c752e97..d5970e2 100644
> --- a/arch/x86/kernel/irqinit.c
> +++ b/arch/x86/kernel/irqinit.c
> @@ -25,6 +25,7 @@
>  #include <asm/setup.h>
>  #include <asm/i8259.h>
>  #include <asm/traps.h>
> +#include <asm/prom.h>
>  
>  /*
>   * ISA PIC or low IO-APIC triggered (INTA-cycle or APIC) interrupts:
> @@ -118,6 +119,12 @@ void __init init_IRQ(void)
>  	int i;
>  
>  	/*
> +	 * We probably need a better place for this, but it works for
> +	 * now ...
> +	 */
> +	init_dtb();
> +
> +	/*
>  	 * On cpu 0, Assign IRQ0_VECTOR..IRQ15_VECTOR's to IRQ 0..15.
>  	 * If these IRQ's are handled by legacy interrupt-controllers like PIC,
>  	 * then this configuration will likely be static after the boot. If
> diff --git a/arch/x86/kernel/prom.c b/arch/x86/kernel/prom.c
> new file mode 100644
> index 0000000..ba9a096
> --- /dev/null
> +++ b/arch/x86/kernel/prom.c
> @@ -0,0 +1,60 @@
> +/*
> + * Architecture specific OF callbacks.
> + */
> +
> +#include <linux/io.h>
> +#include <linux/list.h>
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
> +#include <linux/slab.h>
> +
> +char __initdata cmd_line[COMMAND_LINE_SIZE];
> +
> +unsigned int irq_create_of_mapping(struct device_node *controller,
> +		const u32 *intspec, unsigned int intsize)
> +{
> +	return intspec[0];
> +
> +}
> +EXPORT_SYMBOL_GPL(irq_create_of_mapping);
> +
> +unsigned long pci_address_to_pio(phys_addr_t address)
> +{
> +	BUG();
> +}
> +EXPORT_SYMBOL_GPL(pci_address_to_pio);
> +
> +void __init early_init_dt_scan_chosen_arch(unsigned long node)
> +{
> +	BUG();
> +}
> +
> +void __init early_init_dt_add_memory_arch(u64 base, u64 size)
> +{
> +	BUG();
> +}
> +
> +u64 __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
> +{
> +	void *mem;
> +
> +	mem = kmalloc(size + align, GFP_KERNEL);
> +	BUG_ON(!mem);
> +	mem = PTR_ALIGN(mem, align);
> +	return virt_to_phys(mem);
> +}
> +
> +void __init add_dtb(u64 data)
> +{
> +	initial_boot_params = (struct boot_param_header *)
> +		phys_to_virt((u64) (u32) data +
> +				offsetof(struct setup_data, data));
> +}
> +
> +void __init init_dtb(void)
> +{
> +	if (!initial_boot_params)
> +		return;
> +
> +	unflatten_device_tree();
> +}
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 52f10e6..b1e1bcb 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -113,6 +113,7 @@
>  #endif
>  #include <asm/mce.h>
>  #include <asm/alternative.h>
> +#include <asm/prom.h>
>  
>  /*
>   * end_pfn only includes RAM, while max_pfn_mapped includes all e820 entries.
> @@ -441,6 +442,9 @@ static void __init parse_setup_data(void)
>  		case SETUP_E820_EXT:
>  			parse_e820_ext(data);
>  			break;
> +		case SETUP_DTB:
> +			add_dtb(pa_data);
> +			break;
>  		default:
>  			break;
>  		}


