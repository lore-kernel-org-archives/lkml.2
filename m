Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab2JEIkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:40:33 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54953 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab2JEIk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:40:26 -0400
Subject: Re: [PATCH v4 2/6] misc: Generic on-chip SRAM allocation driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Matt Porter <mporter@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, kernel@pengutronix.de,
        devicetree-discuss@lists.ozlabs.org
In-Reply-To: <20121004152509.GJ11149@beef>
References: <1347021828-23034-1-git-send-email-p.zabel@pengutronix.de>
	 <1347021828-23034-3-git-send-email-p.zabel@pengutronix.de>
	 <20121004152509.GJ11149@beef>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Oct 2012 10:40:17 +0200
Message-ID: <1349426417.2584.6.camel@pizza.hi.pengutronix.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 04.10.2012, 11:25 -0400 schrieb Matt Porter:
> On Fri, Sep 07, 2012 at 02:43:44PM +0200, Philipp Zabel wrote:
> > This driver requests and remaps a memory region as configured in the
> > device tree. It serves memory from this region via the genalloc API.
> > 
> > Other drivers can retrieve the genalloc pool from a phandle pointing
> > to this drivers' device node in the device tree.
> 
> <snip>
> 
> > +	sram->pool = gen_pool_create(PAGE_SHIFT, -1);
> > +	if (!sram->pool)
> > +		return -ENOMEM;
> 
> As mentioned in the uio_pruss/genalloc discussion, removing the
> hardcoded minimum allocation order will allow this to be used for
> a number of other cases. The most notable is moving mach-davinci/
> off of its own genalloc-based SRAM arch driver. Some of the davinci
> SoCs have very small SRAMs and need the ability to allocate a smaller
> chunk.
> 
> Here's a build-tested patch to add this option:

Thank you,

> From 6eced8c31eba2f86e72e854cf404d8f58fbeba85 Mon Sep 17 00:00:00 2001
> From: Matt Porter <mporter@ti.com>
> Date: Thu, 4 Oct 2012 11:08:02 -0400
> Subject: [PATCH] misc: sram: add support for configurable allocation order
> 
> Adds support for setting the genalloc pool's minimum allocation
> order via DT or platform data. The allocation order is optional
> for both the DT property and platform data case. If it is not
> present then the order defaults to PAGE_SHIFT to preserve the
> current behavior.
> 
> Signed-off-by: Matt Porter <mporter@ti.com>

Tested-by: Philipp Zabel <p.zabel@pengutronix.de>

> ---
>  Documentation/devicetree/bindings/misc/sram.txt |   12 ++++++++++-
>  drivers/misc/sram.c                             |   14 ++++++++++++-
>  include/linux/platform_data/sram.h              |   25 +++++++++++++++++++++++
>  3 files changed, 49 insertions(+), 2 deletions(-)
>  create mode 100644 include/linux/platform_data/sram.h
> 
> diff --git a/Documentation/devicetree/bindings/misc/sram.txt b/Documentation/devicetree/bindings/misc/sram.txt
> index b64136c..b1705ec 100644
> --- a/Documentation/devicetree/bindings/misc/sram.txt
> +++ b/Documentation/devicetree/bindings/misc/sram.txt
> @@ -8,10 +8,20 @@ Required properties:
>  
>  - reg : SRAM iomem address range
>  
> -Example:
> +Optional properties:
> +
> +- alloc-order : Minimum allocation order for the SRAM pool
> +
> +Examples:
> +
> +sram: sram@5c000000 {
> +	compatible = "sram";
> +	reg = <0x5c000000 0x40000>; /* 256 KiB SRAM at address 0x5c000000 */
> +};
>  
>  sram: sram@5c000000 {
>  	compatible = "sram";
>  	reg = <0x5c000000 0x40000>; /* 256 KiB SRAM at address 0x5c000000 */
> +	alloc-order = <9>; /* Minimum 512 byte allocation */
>  };
>  
> diff --git a/drivers/misc/sram.c b/drivers/misc/sram.c
> index 7a363f2..3bf8ed3 100644
> --- a/drivers/misc/sram.c
> +++ b/drivers/misc/sram.c
> @@ -26,6 +26,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/spinlock.h>
>  #include <linux/genalloc.h>
> +#include <linux/platform_data/sram.h>
>  
>  struct sram_dev {
>  	struct gen_pool *pool;
> @@ -37,6 +38,7 @@ static int __devinit sram_probe(struct platform_device *pdev)
>  	struct sram_dev *sram;
>  	struct resource *res;
>  	unsigned long size;
> +	u32 alloc_order = PAGE_SHIFT;
>  	int ret;
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> @@ -53,7 +55,17 @@ static int __devinit sram_probe(struct platform_device *pdev)
>  	if (!sram)
>  		return -ENOMEM;
>  
> -	sram->pool = gen_pool_create(PAGE_SHIFT, -1);
> +	if (pdev->dev.of_node)
> +		of_property_read_u32(pdev->dev.of_node,
> +				     "alloc-order", &alloc_order);
> +	else
> +		if (pdev->dev.platform_data) {
> +			struct sram_pdata *pdata = pdev->dev.platform_data;
> +			if (pdata->alloc_order)
> +				alloc_order = pdata->alloc_order;
> +		}
> +
> +	sram->pool = gen_pool_create(alloc_order, -1);
>  	if (!sram->pool)
>  		return -ENOMEM;
>  
> diff --git a/include/linux/platform_data/sram.h b/include/linux/platform_data/sram.h
> new file mode 100644
> index 0000000..e17bdaa
> --- /dev/null
> +++ b/include/linux/platform_data/sram.h
> @@ -0,0 +1,25 @@
> +/*
> + * include/linux/platform_data/sram.h
> + *
> + * Platform data for generic sram driver
> + *
> + * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com/
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef _SRAM_H_
> +#define _SRAM_H_
> +
> +struct sram_pdata {
> +	unsigned alloc_order;	/* Optional: driver defaults to PAGE_SHIFT */
> +};
> +
> +#endif /* _SRAM_H_ */


