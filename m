Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347Ab1INLwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 07:52:31 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:64081 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932269Ab1INLwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 07:52:30 -0400
Message-ID: <4E70955D.8050106@metafoo.de>
Date: Wed, 14 Sep 2011 13:51:57 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: keguang.zhang@gmail.com
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, wuzhangjin@gmail.com, r0bertz@gentoo.org,
        chenj@lemote.com
Subject: Re: [PATCH] MIPS: Add basic support for Loongson1B
References: <1315997270-14332-1-git-send-email-keguang.zhang@gmail.com>
In-Reply-To: <1315997270-14332-1-git-send-email-keguang.zhang@gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2011 12:47 PM, keguang.zhang@gmail.com wrote:
> From: Zhang, Keguang <keguang.zhang@gmail.com>
> 
> This patch adds basic support for Loongson1B
> including serial, timer and interrupt handler.
> 
> Loongson 1B is a 32-bit SoC designed by Institute of
> Computing Technology (ICT), Chinese Academy of Sciences (CAS),
> which implements the MIPS32 release 2 instruction set.
> 
> Signed-off-by: Zhang, Keguang <keguang.zhang@gmail.com>
> ---
>  
> [...
> diff --git a/arch/mips/include/asm/mach-loongson1/regs-clk.h b/arch/mips/include/asm/mach-loongson1/regs-clk.h
> new file mode 100644
> index 0000000..acffd4f
> --- /dev/null
> +++ b/arch/mips/include/asm/mach-loongson1/regs-clk.h
> @@ -0,0 +1,32 @@
> +/*
> + * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
> + *
> + * Loongson1 Clock Register Definitions.
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#ifndef __ASM_MACH_LOONGSON1_REGS_CLK_H
> +#define __ASM_MACH_LOONGSON1_REGS_CLK_H
> +
> +#define LOONGSON1_CLK_REG(x)		((void __iomem *)(LOONGSON1_CLK_BASE + (x)))
> +
> +#define	CLK_PLL_FREQ			LOONGSON1_CLK_REG(0x0)
> +#define	CLK_PLL_DIV			LOONGSON1_CLK_REG(0x4)
> +
> +/* Clock PLL Divisor Register Bits */
> +#define	DIV_DC_EN			(0x1 << 31)
> +#define DIV_DC				(0x1f << 26)
> +#define	DIV_CPU_EN			(0x1 << 25)
> +#define DIV_CPU				(0x1f << 20)
> +#define	DIV_DDR_EN			(0x1 << 19)
> +#define DIV_DDR				(0x1f << 14)
> +
> +#define	DIV_DC_SHIFT			(26)
> +#define	DIV_CPU_SHIFT			(20)
> +#define	DIV_DDR_SHIFT			(14)
> +

In my opinion these defines should be namespaced, same goes for the other
register definitions.

> +#endif /* __ASM_MACH_LOONGSON1_REGS_CLK_H */
> [...]
> diff --git a/arch/mips/loongson1/Platform b/arch/mips/loongson1/Platform
> new file mode 100644
> index 0000000..92804c6
> --- /dev/null
> +++ b/arch/mips/loongson1/Platform
> @@ -0,0 +1,7 @@
> +cflags-$(CONFIG_CPU_LOONGSON1)  += \
> +	$(call cc-option,-march=mips32r2,-mips32r2 -U_MIPS_ISA -D_MIPS_ISA=_MIPS_ISA_MIPS32) \
> +	-Wa,-mips32r2 -Wa,--trap
> +
> +platform-$(CONFIG_MACH_LOONGSON1)	+= loongson1/
> +cflags-$(CONFIG_MACH_LOONGSON1)		+= -I$(srctree)/arch/mips/include/asm/mach-loongson1
> +load-$(CONFIG_LOONGSON1_LS1B)		+= 0xffffffff80010000
> diff --git a/arch/mips/loongson1/common/Makefile b/arch/mips/loongson1/common/Makefile
> new file mode 100644
> index 0000000..b279770
> --- /dev/null
> +++ b/arch/mips/loongson1/common/Makefile
> @@ -0,0 +1,5 @@
> +#
> +# Makefile for common code of loongson1 based machines.
> +#
> +
> +obj-y	+= clock.o irq.o platform.o prom.o reset.o setup.o
> diff --git a/arch/mips/loongson1/common/clock.c b/arch/mips/loongson1/common/clock.c
> new file mode 100644
> index 0000000..e854953
> --- /dev/null
> +++ b/arch/mips/loongson1/common/clock.c
> @@ -0,0 +1,164 @@
> +/*
> + * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/list.h>
> +#include <linux/mutex.h>
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <asm/clock.h>
> +#include <asm/time.h>
> +
> +#include <loongson1.h>
> +
> +static LIST_HEAD(clocks);
> +static DEFINE_MUTEX(clocks_mutex);
> +
> +struct clk *clk_get(struct device *dev, const char *name)
> +{
> +	struct clk *c;
> +	struct clk *ret = NULL;
> +
> +	mutex_lock(&clocks_mutex);
> +	list_for_each_entry(c, &clocks, node) {
> +		if (!strcmp(c->name, name)) {
> +			ret = c;
> +			break;
> +		}
> +	}
> +	mutex_unlock(&clocks_mutex);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(clk_get);
> +
> +unsigned long clk_get_rate(struct clk *clk)
> +{
> +	return clk->rate;
> +}
> +EXPORT_SYMBOL(clk_get_rate);
> +

Maybe use the generic clkdev implementation.

> [...]
> diff --git a/arch/mips/loongson1/common/irq.c b/arch/mips/loongson1/common/irq.c
> new file mode 100644
> index 0000000..8a7287f
> --- /dev/null
> +++ b/arch/mips/loongson1/common/irq.c
> @@ -0,0 +1,132 @@
> +/*
> + * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
> + *
> + * Based on Copyright (C) 2009 Lemote Inc.
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <asm/irq_cpu.h>
> +
> +#include <loongson1.h>
> +#include <irq.h>
> +
> +static void loongson1_irq_ack(struct irq_data *d)
> +{
> +	unsigned int bit = (d->irq - LOONGSON1_IRQ_BASE) & 0x1f;
> +	unsigned int n = (d->irq - LOONGSON1_IRQ_BASE) >> 5;
> +
> +	__raw_writel(__raw_readl(INTC_INTCLR(n)) | (1 << bit), INTC_INTCLR(n));
> +}
> +
> +static void loongson1_irq_mask(struct irq_data *d)
> +{
> +	unsigned int bit = (d->irq - LOONGSON1_IRQ_BASE) & 0x1f;
> +	unsigned int n = (d->irq - LOONGSON1_IRQ_BASE) >> 5;
> +
> +	__raw_writel(__raw_readl(INTC_INTIEN(n)) & ~(1 << bit), INTC_INTIEN(n));
> +}
> +
> +static void loongson1_irq_mask_ack(struct irq_data *d)
> +{
> +	unsigned int bit = (d->irq - LOONGSON1_IRQ_BASE) & 0x1f;
> +	unsigned int n = (d->irq - LOONGSON1_IRQ_BASE) >> 5;
> +
> +	__raw_writel(__raw_readl(INTC_INTIEN(n)) & ~(1 << bit), INTC_INTIEN(n));
> +	__raw_writel(__raw_readl(INTC_INTCLR(n)) | (1 << bit), INTC_INTCLR(n));
> +}
> +
> +static void loongson1_irq_unmask(struct irq_data *d)
> +{
> +	unsigned int bit = (d->irq - LOONGSON1_IRQ_BASE) & 0x1f;
> +	unsigned int n = (d->irq - LOONGSON1_IRQ_BASE) >> 5;
> +
> +	__raw_writel(__raw_readl(INTC_INTIEN(n)) | (1 << bit), INTC_INTIEN(n));
> +}
> +
> +static struct irq_chip loongson1_irq_chip = {
> +	.name		= "LOONGSON1-INTC",
> +	.irq_ack	= loongson1_irq_ack,
> +	.irq_mask	= loongson1_irq_mask,
> +	.irq_mask_ack	= loongson1_irq_mask_ack,
> +	.irq_unmask	= loongson1_irq_unmask,
> +};

looks like a perfect candidate for irq_chip_generic.
