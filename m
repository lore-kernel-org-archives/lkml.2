Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab1ILULJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 16:11:09 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:53949 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab1ILULG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 16:11:06 -0400
Date: Mon, 12 Sep 2011 14:11:02 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org, ming.lei@canonical.com,
        stern@rowland.harvard.edu, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 06/24] C6X: devicetree
Message-ID: <20110912201102.GF23345@ponder.secretlab.ca>
References: <1314826019-22330-1-git-send-email-msalter@redhat.com>
 <1314826019-22330-7-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314826019-22330-7-git-send-email-msalter@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 05:26:41PM -0400, Mark Salter wrote:
> This is the basic devicetree support for C6X. Currently, four boards are
> supported. Each one uses a different SoC part. Two of the four supported
> SoCs are multicore. One with 3 cores and the other with 6 cores. There is
> no coherency between the core-level caches, so SMP is not an option. It is
> possible to run separate kernel instances on the various cores. There is
> currently no C6X bootloader support for device trees so we build in the
> DTB for now.
> 
> There are some interesting twists to the hardware which are of note for device
> tree support. Each core has its own interrupt controller which is controlled
> by special purpose core registers. This core controller provides 12 general
> purpose prioritized interrupt sources. Each core is contained within a
> hardware "module" which provides L1 and L2 caches, power control, and another
> interrupt controller which cascades into the core interrupt controller. These
> core module functions are controlled by memory mapped registers. The addresses
> for these registers are the same for each core. That is, when coreN accesses
> a module-level MMIO register at a given address, it accesses the register for
> coreN even though other cores would use the same address to access the register
> in the module containing those cores. Other hardware modules (timers, enet, etc)
> which are memory mapped can be accessed by all cores.
> 
> The timers need some further explanation for multicore SoCs. Even though all
> timer control registers are visible to all cores, interrupt routing or other
> considerations may make a given timer more suitable for use by a core than
> some other timer. Because of this and the desire to have the same image run
> on more than one core, the timer nodes have a "ti,core-mask" property which
> is used by the driver to scan for a suitable timer to use.
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>
> Cc: devicetree-discuss@lists.ozlabs.org
> ---
>  arch/c6x/boot/dts/dsk6455.dts  |  128 +++++++++++++++
>  arch/c6x/boot/dts/evmc6457.dts |  106 +++++++++++++
>  arch/c6x/boot/dts/evmc6472.dts |  176 +++++++++++++++++++++
>  arch/c6x/boot/dts/evmc6474.dts |  133 ++++++++++++++++
>  arch/c6x/boot/install-dtb.c    |  333 ++++++++++++++++++++++++++++++++++++++++
>  arch/c6x/kernel/devicetree.c   |   53 +++++++
>  arch/c6x/platforms/platform.c  |   23 +++
>  7 files changed, 952 insertions(+), 0 deletions(-)
>  create mode 100644 arch/c6x/boot/dts/dsk6455.dts
>  create mode 100644 arch/c6x/boot/dts/evmc6457.dts
>  create mode 100644 arch/c6x/boot/dts/evmc6472.dts
>  create mode 100644 arch/c6x/boot/dts/evmc6474.dts
>  create mode 100644 arch/c6x/boot/install-dtb.c
>  create mode 100644 arch/c6x/kernel/devicetree.c
>  create mode 100644 arch/c6x/platforms/platform.c
> 
> diff --git a/arch/c6x/boot/dts/dsk6455.dts b/arch/c6x/boot/dts/dsk6455.dts
> new file mode 100644
> index 0000000..ef703aa
> --- /dev/null
> +++ b/arch/c6x/boot/dts/dsk6455.dts
> @@ -0,0 +1,128 @@
> +/*
> + * arch/c6x/boot/dts/dsk6455.dts
> + *
> + * DSK6455 Evaluation Platform For TMS320C6455
> + * Copyright (C) 2011 Texas Instruments Incorporated
> + *
> + * Author: Mark Salter <msalter@redhat.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + */
> +
> +/dts-v1/;
> +

I expect you'll want to use the /include/ functionality here to avoid
duplicating all the SoC details in each and every board file.

> +/ {
> +	model = "Spectrum Digital DSK6455";
> +	compatible = "spectrum-digital,dsk6455";
> +
> +	#address-cells = <1>;
> +	#size-cells = <1>;
> +
> +	chosen {
> +		bootargs = "root=/dev/nfs ip=dhcp rw";
> +	};
> +
> +	memory {
> +		device_type = "memory";
> +		reg = <0xE0000000 0x08000000>;
> +	};
> +
> +	cpus {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		cpu@0 {
> +			device_type = "cpu";
> +			model = "ti,c64x+";
> +			reg = <0>;
> +		};
> +	};
> +
> +	/*
> +	 * Core priority interrupt controller
> +	 */
> +	core_pic: interrupt-controller@0 {

@0 doesn't make sense without a 'reg' property.

> +		interrupt-controller;
> +		#interrupt-cells = <1>;
> +		compatible = "ti,c64x+core-pic";

The interrupt controller isn't addressable?  Is it integrated into
the CPU?

> +	};
> +
> +	soc@00000000 {

"soc@2a80000" to match the 'reg' property of this node.

> +		compatible = "ti,tms320c6455";

Make sure you add documentation for all new compatible properties to
Documentation/devicetree/bindings

> +		device_type = "soc";

Drop device_type from everything except the memory node.

> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		#interrupt-cells = <1>;

#interrupt-cells doesn't make any sense for nodes that aren't an
interrupt controller.

> diff --git a/arch/c6x/boot/install-dtb.c b/arch/c6x/boot/install-dtb.c
> new file mode 100644
> index 0000000..fa979ce
> --- /dev/null
> +++ b/arch/c6x/boot/install-dtb.c
> @@ -0,0 +1,333 @@
> +/*
> + * Program to hack in a DTB to an ELF file having a placeholder
> + * section named __fst_blob.
> + *
> + * This allows for building multiple images with builtin DTBs
> + * using a single vmlinux image. This is only necessary until
> + * bootloader support exists.
> + *
> + * Copyright 2011 Texas Instruments Incorporated
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version
> + * 2 of the License, or (at your option) any later version.
> + *
> + * Usage: install-dtb <image.dtb> <kernel.elf>
> + */

Surely this can be done with objcopy or with the linker.

> diff --git a/arch/c6x/kernel/devicetree.c b/arch/c6x/kernel/devicetree.c
> new file mode 100644
> index 0000000..bdb56f0
> --- /dev/null
> +++ b/arch/c6x/kernel/devicetree.c
> @@ -0,0 +1,53 @@
> +/*
> + *  Architecture specific OF callbacks.
> + *
> + *  Copyright (C) 2011 Texas Instruments Incorporated
> + *  Author: Mark Salter <msalter@redhat.com>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2 as
> + *  published by the Free Software Foundation.
> + *
> + */
> +#include <linux/init.h>
> +#include <linux/of.h>
> +#include <linux/of_fdt.h>
> +#include <linux/initrd.h>
> +#include <linux/memblock.h>
> +
> +void __init early_init_devtree(void *params)
> +{
> +	/* Setup flat device-tree pointer */
> +	initial_boot_params = params;
> +
> +	/* Retrieve various informations from the /chosen node of the
> +	 * device-tree, including the platform type, initrd location and
> +	 * size and more ...
> +	 */
> +	of_scan_flat_dt(early_init_dt_scan_chosen, c6x_command_line);
> +
> +	/* Scan memory nodes and rebuild MEMBLOCKs */
> +	of_scan_flat_dt(early_init_dt_scan_root, NULL);
> +	of_scan_flat_dt(early_init_dt_scan_memory, NULL);
> +}
> +
> +
> +#ifdef CONFIG_BLK_DEV_INITRD
> +void __init early_init_dt_setup_initrd_arch(unsigned long start,
> +		unsigned long end)
> +{
> +	initrd_start = (unsigned long)__va(start);
> +	initrd_end = (unsigned long)__va(end);
> +	initrd_below_start_ok = 1;
> +}
> +#endif
> +
> +void __init early_init_dt_add_memory_arch(u64 base, u64 size)
> +{
> +	c6x_add_memory(base, size);
> +}
> +
> +void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
> +{
> +	return __va(memblock_alloc(size, align));
> +}
> diff --git a/arch/c6x/platforms/platform.c b/arch/c6x/platforms/platform.c
> new file mode 100644
> index 0000000..83fbedd
> --- /dev/null
> +++ b/arch/c6x/platforms/platform.c
> @@ -0,0 +1,23 @@
> +/*
> + * Copyright 2011 Texas Instruments Incorporated
> + *
> + * This file is licensed under the terms of the GNU General Public License
> + * version 2. This program is licensed "as is" without any warranty of any
> + * kind, whether express or implied.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/of_platform.h>
> +
> +static struct of_device_id c6x_bus_ids[] __initdata = {
> +	{ .type = "soc", },

Drop .type matching.  Only ever use .compatible, unless supporting
legacy platforms.

> +	{ .compatible = "simple-bus", },
> +	{}
> +};
> +
> +static int __init c6x_device_probe(void)
> +{
> +	of_platform_bus_probe(NULL, c6x_bus_ids, NULL);

You can probably just use the stock of_default_bus_match_table

g.

