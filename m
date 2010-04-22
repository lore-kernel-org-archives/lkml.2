Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab0DVOyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 10:54:37 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50244 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500Ab0DVOyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 10:54:36 -0400
Date: Thu, 22 Apr 2010 16:54:33 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Amit Kucheria <amit.kucheria@verdurent.com>
Cc: Dinh Nguyen <Dinh.Nguyen@freescale.com>,
       Amit Kucheria <amit.kucheria@canonical.com>,
       Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mx5: Add registration of GPIOs for MX5 devices
Message-ID: <20100422145433.GX7882@pengutronix.de>
References: <a2d23fc5b7650221913ad0d23d08fa4525efe194.1271942210.git.amit.kucheria@verdurent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2d23fc5b7650221913ad0d23d08fa4525efe194.1271942210.git.amit.kucheria@verdurent.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:53:47 up 33 days,  3:43, 54 users,  load average: 2.88, 3.63,
	3.92
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 04:28:42PM +0300, Amit Kucheria wrote:
> From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> 
> Register the gpio irqs on Freescale's MX51 Babbage HW.
> 
> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
> ---
>  arch/arm/mach-mx5/devices.c |   33 +++++++++++++++++++++++++++++++--
>  arch/arm/plat-mxc/gpio.c    |    5 ++---
>  arch/arm/plat-mxc/tzic.c    |    4 +++-
>  3 files changed, 36 insertions(+), 6 deletions(-)

Ok, applied to mxc-master.

Sascha


> 
> diff --git a/arch/arm/mach-mx5/devices.c b/arch/arm/mach-mx5/devices.c
> index d6fd396..5070ae1 100644
> --- a/arch/arm/mach-mx5/devices.c
> +++ b/arch/arm/mach-mx5/devices.c
> @@ -1,5 +1,6 @@
>  /*
>   * Copyright 2009 Amit Kucheria <amit.kucheria@canonical.com>
> + * Copyright (C) 2010 Freescale Semiconductor, Inc.
>   *
>   * The code contained herein is licensed under the GNU General Public
>   * License. You may obtain a copy of the GNU General Public License
> @@ -10,8 +11,10 @@
>   */
>  
>  #include <linux/platform_device.h>
> +#include <linux/gpio.h>
>  #include <mach/hardware.h>
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
> +static struct mxc_gpio_port mxc_gpio_ports[] = {
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
> +	return mxc_gpio_init(mxc_gpio_ports, ARRAY_SIZE(mxc_gpio_ports));
>  }
> diff --git a/arch/arm/plat-mxc/gpio.c b/arch/arm/plat-mxc/gpio.c
> index 70b2389..71437c6 100644
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
> @@ -289,7 +288,7 @@ int __init mxc_gpio_init(struct mxc_gpio_port *port, int cnt)
>  		/* its a serious configuration bug when it fails */
>  		BUG_ON( gpiochip_add(&port[i].chip) < 0 );
>  
> -		if (cpu_is_mx1() || cpu_is_mx3() || cpu_is_mx25()) {
> +		if (cpu_is_mx1() || cpu_is_mx3() || cpu_is_mx25() || cpu_is_mx51()) {
>  			/* setup one handler for each entry */
>  			set_irq_chained_handler(port[i].irq, mx3_gpio_irq_handler);
>  			set_irq_data(port[i].irq, &port[i]);
> diff --git a/arch/arm/plat-mxc/tzic.c b/arch/arm/plat-mxc/tzic.c
> index afa6709..9b86d2a 100644
> --- a/arch/arm/plat-mxc/tzic.c
> +++ b/arch/arm/plat-mxc/tzic.c
> @@ -1,5 +1,5 @@
>  /*
> - * Copyright 2004-2009 Freescale Semiconductor, Inc. All Rights Reserved.
> + * Copyright (C)2004-2010 Freescale Semiconductor, Inc. All Rights Reserved.
>   *
>   * The code contained herein is licensed under the GNU General Public
>   * License. You may obtain a copy of the GNU General Public License
> @@ -19,6 +19,7 @@
>  #include <asm/mach/irq.h>
>  
>  #include <mach/hardware.h>
> +#include <mach/common.h>
>  
>  /*
>   *****************************************
> @@ -144,6 +145,7 @@ void __init tzic_init_irq(void __iomem *irqbase)
>  		set_irq_handler(i, handle_level_irq);
>  		set_irq_flags(i, IRQF_VALID);
>  	}
> +	mxc_register_gpios();
>  
>  	pr_info("TrustZone Interrupt Controller (TZIC) initialized\n");
>  }
> -- 
> 1.7.0.4
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
