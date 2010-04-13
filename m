Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab0DMQpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 12:45:40 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:42627 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab0DMQpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 12:45:38 -0400
Date: Tue, 13 Apr 2010 18:45:32 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, amit.kucheria@canonical.com,
       linux@arm.linux.org.uk, s.hauer@pengutronix.de,
       grant.likely@secretlab.ca, r.herring@freescale.com,
       linux-arm-kernel@lists.infradead.org, bryan.wu@canonical.com,
       valentin.longchamp@epfl.ch
Subject: Re: [PATCH 2.6.34-rc4 1/8] mx5: Add registration of GPIOs for MX51
 Babbage board.
Message-ID: <20100413164532.GM30801@buzzloop.caiaq.de>
References: <1271175030-3635-1-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271175030-3635-1-git-send-email-Dinh.Nguyen@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, I'm glad to see Freescale sending patches for mainline code -
thanks for doing this :)

Other people might give more detailed feedback, but I'll still comment
on some things that caught my eye.

On Tue, Apr 13, 2010 at 11:10:24AM -0500, Dinh.Nguyen@freescale.com wrote:

[...]

> index d6fd396..73f2342 100644
> --- a/arch/arm/mach-mx5/devices.c
> +++ b/arch/arm/mach-mx5/devices.c
> @@ -1,5 +1,6 @@
>  /*
>   * Copyright 2009 Amit Kucheria <amit.kucheria@canonical.com>
> + * Copyright (C) 2010 Freescale Semiconductor, Inc. All Rights Reserved.
>   *
>   * The code contained herein is licensed under the GNU General Public
>   * License. You may obtain a copy of the GNU General Public License
> @@ -11,7 +12,9 @@
>  
>  #include <linux/platform_device.h>
>  #include <mach/hardware.h>
> +#include <mach/gpio.h>
>  #include <mach/imx-uart.h>
> +#include <mach/irqs.h>
>  
>  static struct resource uart0[] = {
>  	{
> @@ -89,8 +92,34 @@ struct platform_device mxc_fec_device = {
>  	.resource = mxc_fec_resources,
>  };
>  
> -/* Dummy definition to allow compiling in AVIC and TZIC simultaneously */
> +struct mxc_gpio_port mxc_gpio_ports[] = {
> +	{
> +		.chip.label = "gpio-0",
> +		.base = MX51_IO_ADDRESS(MX51_GPIO1_BASE_ADDR),
> +		.irq = MX51_MXC_INT_GPIO1_LOW,
> +		.virtual_irq_start = MXC_GPIO_IRQ_START
> +	},
> +	{
> +		.chip.label = "gpio-1",
> +		.base = MX51_IO_ADDRESS(MX51_GPIO2_BASE_ADDR),
> +		.irq = MX51_MXC_INT_GPIO2_LOW,
> +		.virtual_irq_start = MXC_GPIO_IRQ_START + 32 * 1
> +	},
> +	{
> +		.chip.label = "gpio-2",
> +		.base = MX51_IO_ADDRESS(MX51_GPIO3_BASE_ADDR),
> +		.irq = MX51_MXC_INT_GPIO3_LOW,
> +		.virtual_irq_start = MXC_GPIO_IRQ_START + 32 * 2
> +	},
> +	{
> +		.chip.label = "gpio-3",
> +		.base = MX51_IO_ADDRESS(MX51_GPIO4_BASE_ADDR),
> +		.irq = MX51_MXC_INT_GPIO4_LOW,
> +		.virtual_irq_start = MXC_GPIO_IRQ_START + 32 * 3
> +	},
> +};
> +
>  int __init mxc_register_gpios(void)
>  {
> -	return 0;
> +	return mxc_gpio_init(mxc_gpio_ports, 4);

Use ARRAY_SIZE() instead of the hard-coded constant.

> diff --git a/arch/arm/plat-mxc/gpio.c b/arch/arm/plat-mxc/gpio.c
> index 70b2389..1df23b2 100644
> --- a/arch/arm/plat-mxc/gpio.c
> +++ b/arch/arm/plat-mxc/gpio.c
> @@ -3,7 +3,7 @@
>   * Copyright 2008 Juergen Beisert, kernel@pengutronix.de
>   *
>   * Based on code from Freescale,
> - * Copyright 2004-2006 Freescale Semiconductor, Inc. All Rights Reserved.
> + * Copyright (C) 2004-2010 Freescale Semiconductor, Inc. All Rights Reserved.
>   *
>   * This program is free software; you can redistribute it and/or
>   * modify it under the terms of the GNU General Public License
> @@ -38,7 +38,6 @@ static int gpio_table_size;
>  #define GPIO_ICR2	(cpu_is_mx1_mx2() ? 0x2C : 0x10)
>  #define GPIO_IMR	(cpu_is_mx1_mx2() ? 0x30 : 0x14)
>  #define GPIO_ISR	(cpu_is_mx1_mx2() ? 0x34 : 0x18)
> -#define GPIO_ISR	(cpu_is_mx1_mx2() ? 0x34 : 0x18)
>  
>  #define GPIO_INT_LOW_LEV	(cpu_is_mx1_mx2() ? 0x3 : 0x0)
>  #define GPIO_INT_HIGH_LEV	(cpu_is_mx1_mx2() ? 0x2 : 0x1)
> @@ -171,6 +170,25 @@ static void mxc_gpio_irq_handler(struct mxc_gpio_port *port, u32 irq_stat)
>  	}
>  }
>  
> +/* one interrupt *per* gpio port */
> +static void mx5_gpio_irq_handler(u32 irq, struct irq_desc *desc)
> +{
> +	u32 irq_stat;
> +	u32 mask = 0xFFFFFFFF;
> +	struct mxc_gpio_port *port = (struct mxc_gpio_port *)get_irq_data(irq);
> +
> +#ifdef MXC_GPIO_SPLIT_IRQ_2

Where is that macro defined?

> +	if (irq == port->irq)
> +		mask = 0x0000FFFF;
> +	else
> +		mask = 0xFFFF0000;
> +#endif
> +
> +	irq_stat = __raw_readl(port->base + GPIO_ISR) &
> +			(__raw_readl(port->base + GPIO_IMR) & mask);
> +	mxc_gpio_irq_handler(port, irq_stat);
> +}
> +
>  /* MX1 and MX3 has one interrupt *per* gpio port */
>  static void mx3_gpio_irq_handler(u32 irq, struct irq_desc *desc)
>  {
> @@ -289,11 +307,13 @@ int __init mxc_gpio_init(struct mxc_gpio_port *port, int cnt)
>  		/* its a serious configuration bug when it fails */
>  		BUG_ON( gpiochip_add(&port[i].chip) < 0 );
>  
> -		if (cpu_is_mx1() || cpu_is_mx3() || cpu_is_mx25()) {
> -			/* setup one handler for each entry */
> +		/* setup one handler for each entry */
> +		if (cpu_is_mx1() || cpu_is_mx3() || cpu_is_mx25())
>  			set_irq_chained_handler(port[i].irq, mx3_gpio_irq_handler);
> -			set_irq_data(port[i].irq, &port[i]);
> -		}
> +		else if (cpu_is_mx51())
> +			set_irq_chained_handler(port[i].irq, mx5_gpio_irq_handler);
> +
> +		set_irq_data(port[i].irq, &port[i]);
>  	}
>  
>  	if (cpu_is_mx2()) {
> -- 
> 1.6.0.4
