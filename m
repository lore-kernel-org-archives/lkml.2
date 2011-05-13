Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759675Ab1EMQ7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 12:59:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:10006 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759584Ab1EMQ7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 12:59:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,365,1301900400"; 
   d="scan'208";a="1883670"
Date: Fri, 13 May 2011 18:59:32 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com, Graeme Gregory <gg@slimlogic.co.uk>,
        grant.likely@secretlab.ca
Subject: Re: [PATCHv2 5/5] TPS65911: Comparator: Add comparator driver
Message-ID: <20110513165931.GK8970@sortiz-mobl>
References: <A9ADABDA-9D43-44CC-92D8-113C42AA5EE0@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A9ADABDA-9D43-44CC-92D8-113C42AA5EE0@slimlogic.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jorge,

On Wed, May 04, 2011 at 07:21:46PM -0500, Jorge Eduardo Candelaria wrote:
> This driver adds functionality to the tps65911 chip driver.
> 
> Two of the comparators are configurable by software and measures
> VCCS voltage to detect high or low voltage scenarios.
A few comments:

> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 65930a7..8c748f4 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -679,6 +679,13 @@ config MFD_TPS65910
>  	  if you say yes here you get support for the TPS65910 series of
>  	  Power Management chips.
>  
> +config TPS65911_COMPARATOR
> +	tristate "TPS65911 Comparator"
> +	depends on MFD_TPS65910
> +	help
> +	  if you say yes here you get support for the TPS65910 comparator
> +	  module.
> +
I still don't know what it compares and why I would want to enable that.


>  endif # MFD_SUPPORT
>  
>  menu "Multimedia Capabilities Port drivers"
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index c771eed..320de3e 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -89,3 +89,4 @@ obj-$(CONFIG_MFD_WL1273_CORE)	+= wl1273-core.o
>  obj-$(CONFIG_MFD_CS5535)	+= cs5535-mfd.o
>  obj-$(CONFIG_MFD_OMAP_USB_HOST)	+= omap-usb-host.o
>  obj-$(CONFIG_MFD_TPS65910)	+= tps65910.o tps65910-gpio.o tps65910-irq.o
> +obj-$(CONFIG_TPS65911_COMP)	+= tps65911-comparator.o
> diff --git a/drivers/mfd/tps65911-comparator.c b/drivers/mfd/tps65911-comparator.c
> new file mode 100644
> index 0000000..b8b985b
> --- /dev/null
> +++ b/drivers/mfd/tps65911-comparator.c
> @@ -0,0 +1,188 @@
> +/*
> + * tps65910.c  --  TI TPS6591x
> + *
> + * Copyright 2010 Texas Instruments Inc.
> + *
> + * Author: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
> + *
> + *  This program is free software; you can redistribute it and/or modify it
> + *  under  the terms of the GNU General  Public License as published by the
> + *  Free Software Foundation;  either version 2 of the License, or (at your
> + *  option) any later version.
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/slab.h>
> +#include <linux/err.h>
> +#include <linux/platform_device.h>
> +#include <linux/debugfs.h>
> +#include <linux/gpio.h>
> +#include <linux/mfd/tps65910.h>
> +
> +#define COMP					0
> +#define COMP1					1
> +#define COMP2					2
> +
> +/* Comparator 1 voltage selection table in milivolts */
> +static const u16 COMP_VSEL_TABLE[] = {
> +	0, 2500, 2500, 2500, 2500, 2550, 2600, 2650,
> +	2700, 2750, 2800, 2850, 2900, 2950, 3000, 3050,
> +	3100, 3150, 3200, 3250, 3300, 3350, 3400, 3450,
> +	3500,
> +};
> +
> +struct comparator {
> +	const char *name;
> +	int reg;
> +	int uV_max;
> +	const u16 *vsel_table;
> +};
> +
> +static struct comparator tps_comparators[] = {
> +	{
> +		.name = "COMP1",
> +		.reg = TPS65911_VMBCH,
> +		.uV_max = 3500,
> +		.vsel_table = COMP_VSEL_TABLE,
> +	},
> +	{
> +		.name = "COMP2",
> +		.reg = TPS65911_VMBCH2,
> +		.uV_max = 3500,
> +		.vsel_table = COMP_VSEL_TABLE,
> +	},
> +};
This driver really looks like it could belong to drivers/regulator.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
