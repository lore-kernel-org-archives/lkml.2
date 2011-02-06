Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab1BFAp5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 19:45:57 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65080 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab1BFAp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 19:45:56 -0500
Date: Sun, 6 Feb 2011 00:45:51 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: John Linn <john.linn@xilinx.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, catalin.marinas@arm.com, glikely@secretlab.ca
Subject: Re: [PATCH 2/4] ARM: Xilinx: Adding Xilinx board support
Message-ID: <20110206004551.GA5563@pulham.picochip.com>
References: <1296922637-24662-1-git-send-email-john.linn@xilinx.com>
 <1296922637-24662-2-git-send-email-john.linn@xilinx.com>
 <280e5bea-00b4-46a2-a644-a3ca04e32975@VA3EHSMHS011.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <280e5bea-00b4-46a2-a644-a3ca04e32975@VA3EHSMHS011.ehs.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

A couple of nitpicks inline, otherwise looks nice.

Jamie

On Sat, Feb 05, 2011 at 09:17:15AM -0700, John Linn wrote:
> The 1st board support is minimal to get a system up and running
> on the Xilinx platform.
> 
> Signed-off-by: John Linn <john.linn@xilinx.com>
> ---
>  arch/arm/mach-xilinx/Kconfig       |   14 ++++
>  arch/arm/mach-xilinx/Makefile      |    6 ++
>  arch/arm/mach-xilinx/Makefile.boot |    3 +
>  arch/arm/mach-xilinx/board_ep107.c |   81 ++++++++++++++++++++++
>  arch/arm/mach-xilinx/common.c      |  132 ++++++++++++++++++++++++++++++++++++
>  arch/arm/mach-xilinx/common.h      |   32 +++++++++
>  6 files changed, 268 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-xilinx/Kconfig
>  create mode 100644 arch/arm/mach-xilinx/Makefile
>  create mode 100644 arch/arm/mach-xilinx/Makefile.boot
>  create mode 100644 arch/arm/mach-xilinx/board_ep107.c
>  create mode 100644 arch/arm/mach-xilinx/common.c
>  create mode 100644 arch/arm/mach-xilinx/common.h
> 
> diff --git a/arch/arm/mach-xilinx/Kconfig b/arch/arm/mach-xilinx/Kconfig
> new file mode 100644
> index 0000000..11f9e65
> --- /dev/null
> +++ b/arch/arm/mach-xilinx/Kconfig
> @@ -0,0 +1,14 @@
> +if ARCH_XILINX
> +
> +choice
> +        prompt "Board Selection"
> +	default XILINX_EP107
> +
> +config XILINX_EP107
> +	bool "Xilinx EP107 Board"
> +	help
> +	  Select if you are using a Xilinx EP107 board.
> +
> +endchoice
> +
> +endif
> diff --git a/arch/arm/mach-xilinx/Makefile b/arch/arm/mach-xilinx/Makefile
> new file mode 100644
> index 0000000..194f9e4
> --- /dev/null
> +++ b/arch/arm/mach-xilinx/Makefile
> @@ -0,0 +1,6 @@
> +#
> +# Makefile for the linux kernel.
> +#
> +
> +# Common support
> +obj-y := common.o board_ep107.o timer.o
> diff --git a/arch/arm/mach-xilinx/Makefile.boot b/arch/arm/mach-xilinx/Makefile.boot
> new file mode 100644
> index 0000000..67039c3
> --- /dev/null
> +++ b/arch/arm/mach-xilinx/Makefile.boot
> @@ -0,0 +1,3 @@
> +   zreladdr-y	:= 0x00008000
> +params_phys-y	:= 0x00000100
> +initrd_phys-y	:= 0x00800000
> diff --git a/arch/arm/mach-xilinx/board_ep107.c b/arch/arm/mach-xilinx/board_ep107.c
> new file mode 100644
> index 0000000..233e744
> --- /dev/null
> +++ b/arch/arm/mach-xilinx/board_ep107.c
> @@ -0,0 +1,81 @@
> +/* arch/arm/mach-xilinx/board_ep107.c
> + *
> + * This file contains code specific to the Xilinx EP107 board.
> + *
> + *  Copyright (C) 2011 Xilinx
> + *
> + * based on /arch/arm/mach-realview/core.c
> + *
> + *  Copyright (C) 1999 - 2003 ARM Limited
> + *  Copyright (C) 2000 Deep Blue Solutions Ltd
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + */
> +
> +#include <linux/platform_device.h>
> +#include <asm/mach-types.h>
> +#include <asm/mach/arch.h>
> +#include <mach/hardware.h>
> +#include <linux/clkdev.h>
> +#include "common.h"
> +
> +/*
> + * Fixed clocks for now
> + */
> +
> +static struct clk ref50_clk = {
> +	.rate	= 50000000,
> +};
> +
> +/* Create all the platform devices for the board */
> +
> +static struct resource uart0[] = {
> +	{
> +		.start = UART0_BASE,
> +		.end = UART0_BASE + 0xFFF,
> +		.flags = IORESOURCE_MEM,
> +	}, {
> +		.start = IRQ_UART0,
> +		.end = IRQ_UART0,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct platform_device uart_device0 = {
> +	.name = "xuartpss",
> +	.id = 0,
> +	.dev = {
> +		.platform_data = &ref50_clk.rate,
> +	},
> +	.resource = uart0,
> +	.num_resources = ARRAY_SIZE(uart0),
> +};
> +
> +static struct platform_device *xilinx_pdevices[] __initdata = {
> +	&uart_device0,
> +};
> +
> +/**
> + * board_ep107_init - Board specific initialization for the Xilinx EP107 board.
> + *
> + **/
> +static void __init board_ep107_init(void)
> +{
> +	system_init();
> +	platform_device_init(xilinx_pdevices, ARRAY_SIZE(xilinx_pdevices));
> +}
> +
> +MACHINE_START(XILINX_EP107, "Xilinx EP107")
> +	.boot_params    = PHYS_OFFSET + 0x00000100,
> +	.map_io         = map_io,
> +	.init_irq       = irq_init,
> +	.init_machine   = board_ep107_init,
> +	.timer          = &xttcpss_sys_timer,
> +MACHINE_END
> diff --git a/arch/arm/mach-xilinx/common.c b/arch/arm/mach-xilinx/common.c
> new file mode 100644
> index 0000000..f7c51a7
> --- /dev/null
> +++ b/arch/arm/mach-xilinx/common.c
> @@ -0,0 +1,132 @@
> +/* arch/arm/mach-xilinx/common.c
> + *
> + * This file contains common code that is intended to be used across
> + * boards so that it's not replicated.
> + *
> + *  Copyright (C) 2011 Xilinx
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + */
> +
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/cpumask.h>
> +#include <linux/platform_device.h>
> +#include <linux/clk.h>
> +
> +#include <asm/mach/map.h>
> +#include <asm/page.h>
> +#include <asm/hardware/gic.h>
> +#include <asm/hardware/cache-l2x0.h>
> +
> +#include <mach/hardware.h>
> +
> +int clk_enable(struct clk *clk)
> +{
> +	return 0;
> +}
> +
> +void clk_disable(struct clk *clk)
> +{
> +}

According to include/linux/clk.h you should also implement 
clk_get_rate() here too.

> +
> +/**
> + * system_init - System specific initialization, intended to be called from
> + *			board specific initialization.
> + *
> + **/
> +void __init system_init(void)
> +{
> +#ifdef CONFIG_CACHE_L2X0
> +	void *l2cache_base = (void *)PL310_L2CC_BASE;
> +
> +	/*
> +	 * 64KB way size, 8-way associativity, parity disabled
> +	 */
> +	l2x0_init(l2cache_base, 0x02060000, 0xF0F0FFFF);
> +#endif
> +}
> +
> +/**
> + * irq_init - Interrupt controller initialization for the GIC.
> + *
> + **/
> +void __init irq_init(void)
> +{
> +	gic_cpu_base_addr = (void __iomem *)SCU_GIC_CPU_BASE;
> +	gic_init(0, 29, (void __iomem *)SCU_GIC_DIST_BASE, gic_cpu_base_addr);
> +}
> +
> +/* The minimum devices needed to be mapped before the VM system is up and
> + * running include the GIC, UART and Timer Counter.
> + */
> +
> +static struct map_desc io_desc[] __initdata = {
> +	{
> +		.virtual	= TTC0_BASE,
> +		.pfn		= __phys_to_pfn(TTC0_BASE),
> +		.length		= SZ_4K,
> +		.type		= MT_DEVICE,
> +	}, {
> +		.virtual	= SCU_PERIPH_BASE,
> +		.pfn		= __phys_to_pfn(SCU_PERIPH_BASE),
> +		.length		= SZ_8K,
> +		.type		= MT_DEVICE,
> +	}, {
> +		.virtual	= PL310_L2CC_BASE,
> +		.pfn		= __phys_to_pfn(PL310_L2CC_BASE),
> +		.length		= SZ_4K,
> +		.type		= MT_DEVICE,
> +	},
> +
> +#ifdef CONFIG_DEBUG_LL
> +	{
> +		.virtual	= UART0_BASE,
> +		.pfn		= __phys_to_pfn(UART0_BASE),
> +		.length		= SZ_4K,
> +		.type		= MT_DEVICE,
> +	},
> +#endif
> +
> +};
> +
> +/**
> + * map_io - Create memory mappings needed for early I/O.
> + *
> + **/
> +void __init map_io(void)
> +{
> +	iotable_init(io_desc, ARRAY_SIZE(io_desc));
> +}
> +
> +/**
> + * platform_device_init - Initialize all the platform devices.
> + *
> + **/
> +void __init platform_device_init(struct platform_device *xilinx_pdevices[],
> +					int count)
> +{
> +	int ret, i;
> +
> +	/* Initialize all the platform devices */
> +
> +	for (i = 0; i < count; i++) {
> +
> +		pr_info("registering platform device '%s' id %d\n",
> +			xilinx_pdevices[i]->name,
> +			xilinx_pdevices[i]->id);
> +
> +		ret = platform_device_register(xilinx_pdevices[i]);
> +		if (ret)
> +			pr_info("Unable to register platform device '%s': %d\n",
> +				xilinx_pdevices[i]->name, ret);
> +	}
> +}

Would platform_add_devices() do here?  It does the same thing minus the 
pr_info() and will cleanup if any of the registration fails.

> +
> diff --git a/arch/arm/mach-xilinx/common.h b/arch/arm/mach-xilinx/common.h
> new file mode 100644
> index 0000000..49de295
> --- /dev/null
> +++ b/arch/arm/mach-xilinx/common.h
> @@ -0,0 +1,32 @@
> +/* arch/arm/mach-xilinx/common.h
> + *
> + * This file contains common function prototypes to avoid externs
> + * in the c files.
> + *
> + *  Copyright (C) 2011 Xilinx
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + */
> +
> +#ifndef __MACH_XILINX_COMMON_H__
> +#define __MACH_XILINX_COMMON_H__
> +
> +#include <linux/init.h>
> +#include <linux/platform_device.h>
> +
> +void __init system_init(void);
> +void __init irq_init(void);
> +void __init map_io(void);
> +void __init platform_device_init(struct platform_device *pdevices[],
> +					int count);
> +
> +extern struct sys_timer xttcpss_sys_timer;
> +
> +#endif
> -- 
> 1.6.2.1
> 
> 
> 
> This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.
> 
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
