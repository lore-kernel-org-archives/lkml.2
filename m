Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab0L3InP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 03:43:15 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50758 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab0L3InO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 03:43:14 -0500
Date: Thu, 30 Dec 2010 01:43:11 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 02/15] x86: Add device tree support
Message-ID: <20101230084311.GD11721@angua.secretlab.ca>
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de>
 <1292600033-12271-3-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292600033-12271-3-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 04:33:40PM +0100, Sebastian Andrzej Siewior wrote:
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
> 
> Cc: devicetree-discuss@lists.ozlabs.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>

Mostly looks good. Some comments below.

g.

> ---
>  Documentation/x86/boot_with_dtb.txt |   26 +++++++++++++++
>  arch/x86/Kconfig                    |    7 ++++
>  arch/x86/include/asm/bootparam.h    |    1 +
>  arch/x86/include/asm/prom.h         |   59 +++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/Makefile            |    1 +
>  arch/x86/kernel/irqinit.c           |    1 +
>  arch/x86/kernel/prom.c              |   54 ++++++++++++++++++++++++++++++++
>  arch/x86/kernel/setup.c             |    4 ++
>  8 files changed, 153 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/x86/boot_with_dtb.txt
>  create mode 100644 arch/x86/include/asm/prom.h
>  create mode 100644 arch/x86/kernel/prom.c
> 
> diff --git a/Documentation/x86/boot_with_dtb.txt b/Documentation/x86/boot_with_dtb.txt
> new file mode 100644
> index 0000000..6a357aa
> --- /dev/null
> +++ b/Documentation/x86/boot_with_dtb.txt
> @@ -0,0 +1,26 @@
> +  Booting x86 with device tree
> +=================================
> +
> +1. Introduction
> +~~~~~~~~~~~~~~~
> +This document contains device tree information which are specific to
> +the x86 platform. Generic informations as bindings can be found in
> +Documentation/powerpc/dts-bindings/
> +
> +2. Passing the device tree
> +~~~~~~~~~~~~~~~~~~~~~~~~~~
> +The pointer to the device tree block (dtb) is passed via setup_data
> +(see [0]) which requires at least boot protocol 2.09. The type filed is
> +defined as
> +
> +#define SETUP_DTB                      2
> +
> +3. Purpose
> +~~~~~~~~~~~
> +The device tree is used as an extension to the "boot page". As such it does not
> +parse / consider data which are already covered by the boot page. This includes
> +memory size, command line arguments or initrd address.
> +It simply holds information which can not be retrieved otherwise like interrupt
> +routing or a list of devices behind an I2C bus.
> +
> +[0] Documentation/x86/boot.txt
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index b6fccb0..0522354 100644
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
> index 0000000..2fbe3e8
> --- /dev/null
> +++ b/arch/x86/include/asm/prom.h
> @@ -0,0 +1,59 @@
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
> +#ifndef __ASSEMBLY__
> +
> +#include <linux/of.h>
> +#include <linux/types.h>
> +#include <asm/irq.h>
> +#include <asm/atomic.h>
> +#include <asm/setup.h>
> +
> +#ifdef CONFIG_OF
> +extern void add_dtb(u64 data);
> +#else
> +static inline void add_dtb(u64 data) { }
> +#endif
> +
> +extern char cmd_line[COMMAND_LINE_SIZE];
> +/* This number is used when no interrupt has been assigned */
> +#define NO_IRQ		(-1)

0 means NO_IRQ on x86 and most architectures.  I will change this when
I pick up the patch.

> +
> +#define pci_address_to_pio pci_address_to_pio
> +unsigned long pci_address_to_pio(phys_addr_t addr);
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
> index f60153d..40bc33d 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -108,6 +108,7 @@ obj-$(CONFIG_MICROCODE)			+= microcode.o
>  obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) += check.o
>  
>  obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb.o
> +obj-$(CONFIG_X86_OF)			+= prom.o
>  
>  ###
>  # 64 bit specific files
> diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
> index c752e97..149c87f 100644
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
> diff --git a/arch/x86/kernel/prom.c b/arch/x86/kernel/prom.c
> new file mode 100644
> index 0000000..249ebd3
> --- /dev/null
> +++ b/arch/x86/kernel/prom.c
> @@ -0,0 +1,54 @@
> +/*
> + * Architecture specific OF callbacks.
> + */
> +#include <linux/bootmem.h>
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
> +	/*
> +	 * The ioport address can be directly used by inX / outX
> +	 */
> +	BUG_ON(address >= (1 << 16));
> +	return (unsigned long)address;
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
> +	mem = __alloc_bootmem(size, align, __pa(MAX_DMA_ADDRESS));
> +	return virt_to_phys(mem);
> +}
> +
> +void __init add_dtb(u64 data)
> +{
> +	initial_boot_params = (struct boot_param_header *)
> +		phys_to_virt((u64) (u32) data +
> +				offsetof(struct setup_data, data));
> +}
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 577d06b..26f2c9a 100644
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
> @@ -445,6 +446,9 @@ static void __init parse_setup_data(void)
>  		case SETUP_E820_EXT:
>  			parse_e820_ext(data);
>  			break;
> +		case SETUP_DTB:
> +			add_dtb(pa_data);
> +			break;

Why is the physical address being passed in when the virtual address
is needed to be stored in initial_boot_params by add_dtb()?


>  		default:
>  			break;
>  		}
> -- 
> 1.7.3.2
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
