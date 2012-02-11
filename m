Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab2BKGFT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 01:05:19 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47960 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab2BKGFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 01:05:18 -0500
Date: Fri, 10 Feb 2012 22:05:11 -0800
From: Shawn Guo <shawn.guo@linaro.org>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, patches@linaro.org, eric.miao@linaro.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v4 1/2] mfd: Add anatop mfd driver
Message-ID: <20120211060510.GB2198@r65073-Latitude-D630>
References: <1324980994-18462-1-git-send-email-paul.liu@linaro.org>
 <1328734286-30091-1-git-send-email-paul.liu@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328734286-30091-1-git-send-email-paul.liu@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 04:51:25AM +0800, Ying-Chun Liu (PaulLiu) wrote:
> From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
> 
> Anatop is a mfd chip embedded in Freescale i.MX6Q SoC.
> Anatop provides regulators and thermal.
> This driver handles the address space and the operation of the mfd device.
> 
> Signed-off-by: Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ---
>  drivers/mfd/Kconfig        |    6 ++
>  drivers/mfd/Makefile       |    1 +
>  drivers/mfd/anatop-mfd.c   |  152 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/anatop.h |   39 +++++++++++
>  4 files changed, 198 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/mfd/anatop-mfd.c
>  create mode 100644 include/linux/mfd/anatop.h
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index cd13e9f..4f71627 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -830,6 +830,12 @@ config MFD_INTEL_MSIC
>  	  Passage) chip. This chip embeds audio, battery, GPIO, etc.
>  	  devices used in Intel Medfield platforms.
>  
> +config MFD_ANATOP
> +        bool "Support for Anatop"
> +	depends on SOC_IMX6Q
> +	help
> +	  Select this option to enable Anatop MFD driver.
> +
>  endmenu
>  endif
>  
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index b953bab..8e11060 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -112,3 +112,4 @@ obj-$(CONFIG_TPS65911_COMPARATOR)	+= tps65911-comparator.o
>  obj-$(CONFIG_MFD_AAT2870_CORE)	+= aat2870-core.o
>  obj-$(CONFIG_MFD_INTEL_MSIC)	+= intel_msic.o
>  obj-$(CONFIG_MFD_S5M_CORE)	+= s5m-core.o s5m-irq.o
> +obj-$(CONFIG_MFD_ANATOP)	+= anatop-mfd.o
> diff --git a/drivers/mfd/anatop-mfd.c b/drivers/mfd/anatop-mfd.c
> new file mode 100644
> index 0000000..58c6054
> --- /dev/null
> +++ b/drivers/mfd/anatop-mfd.c
> @@ -0,0 +1,152 @@
> +/*
> + * Anatop MFD driver
> + *
> + * Copyright (C) 2012 Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>
> + * Copyright (C) 2012 Linaro
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *   (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License along
> + *  with this program; if not, write to the Free Software Foundation, Inc.,
> + *  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License along
> + *  with this program; if not, write to the Free Software Foundation, Inc.,
> + *  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
> + *
> + */
> +
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
> +#include <linux/of_address.h>
> +#include <linux/mfd/anatop.h>
> +
> +static u32 anatop_read(struct anatop *adata, u32 addr, int bit_shift, int bits)
> +{
> +	u32 val;
> +	int mask;

Nit: it may be nice to put a blank line here.

> +	if (bits == 32)
> +		mask = 0xff;

Shouldn't it be ~0?

> +	else
> +		mask = (1 << bits) - 1;
> +
> +	val = ioread32(adata->ioreg+addr);

Why not just readl()?  Nit: put space before and after '+'.

> +	val = (val >> bit_shift) & mask;

Nit: it may be nice to put a blank line here.

> +	return val;
> +}
> +
> +static void anatop_write(struct anatop *adata, u32 addr, int bit_shift,
> +			 int bits, u32 data)
> +{
> +	u32 val;
> +	int mask;
> +	if (bits == 32)
> +		mask = 0xff;
> +	else
> +		mask = (1 << bits) - 1;
> +
> +	val = ioread32(adata->ioreg+addr) & ~(mask << bit_shift);
> +	iowrite32((data << bit_shift) | val, adata->ioreg);

Same comments on anatop_read apply on anatop_write here.

> +}
> +
> +static const struct of_device_id of_anatop_regulator_match[] = {

A better naming of of_anatop_regulator_match, since it covers not only
regulator but also thermal as below?

> +	{
> +		.compatible = "fsl,anatop-regulator",
> +	},

Nit: since you only have one line here, it could be just:

	{ .compatible = "fsl,anatop-regulator", },

> +	{
> +		.compatible = "fsl,anatop-thermal",
> +	},
> +	{ },
> +};
> +
> +static int of_anatop_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct device_node *np = dev->of_node;
> +	u64 ofaddr;
> +	u64 ofsize;
> +	void *ioreg;
> +	struct anatop *drvdata;
> +	int ret = 0;
> +	const __be32 *rval;
> +
---
> +	rval = of_get_address(np, 0, &ofsize, NULL);
> +	if (rval)
> +		ofaddr = be32_to_cpu(*rval);
> +	else
> +		return -EINVAL;
> +
> +	ioreg = ioremap(ofaddr, ofsize);
---

Above lines can just be of_iomap(np, 0);

> +	if (!ioreg)
> +		return -EINVAL;
> +	drvdata = devm_kzalloc(dev, sizeof(struct anatop), GFP_KERNEL);
> +	if (!drvdata)
> +		return -EINVAL;
> +	drvdata->ioreg = ioreg;
> +	drvdata->read = anatop_read;
> +	drvdata->write = anatop_write;
> +	platform_set_drvdata(pdev, drvdata);
> +	of_platform_bus_probe(np, of_anatop_regulator_match, dev);

Nit: it may be nice to put a blank line here.

> +	return ret;

The 'ret' is used nowhere, so the above line can just be:

	return 0;

> +}
> +
> +static int of_anatop_remove(struct platform_device *pdev)
> +{

Nothing to do here?  At least iounmap?

> +	return 0;
> +}
> +
> +static const struct of_device_id of_anatop_match[] = {
> +	{
> +		.compatible = "fsl,imx6q-anatop",
> +	},

	{ .compatible = "fsl,imx6q-anatop", },

> +	{ },
> +};
> +
> +static struct platform_driver anatop_of_driver = {
> +	.driver = {
> +		.name = "anatop-mfd",
> +		.owner = THIS_MODULE,
> +		.of_match_table = of_anatop_match,
> +	},
> +	.probe		= of_anatop_probe,
> +	.remove		= of_anatop_remove,
> +};
> +
> +static int __init anatop_init(void)
> +{
> +	int ret;
> +	ret = platform_driver_register(&anatop_of_driver);
> +	return ret;

	return platform_driver_register(&anatop_of_driver);

> +}
> +
> +static void __exit anatop_exit(void)
> +{
> +	platform_driver_unregister(&anatop_of_driver);
> +}
> +
> +postcore_initcall(anatop_init);
> +module_exit(anatop_exit);
> +
> +MODULE_AUTHOR("Ying-Chun Liu (PaulLiu)");

Missing your email address here.

> +MODULE_DESCRIPTION("ANATOP MFD driver");
> +MODULE_LICENSE("GPL");

"GPL v2" for better?

> diff --git a/include/linux/mfd/anatop.h b/include/linux/mfd/anatop.h
> new file mode 100644
> index 0000000..4425538
> --- /dev/null
> +++ b/include/linux/mfd/anatop.h
> @@ -0,0 +1,39 @@
> +/*
> + * anatop.h - Anatop MFD driver
> + *
> + *  Copyright (C) 2012 Ying-Chun Liu (PaulLiu) <paulliu@debian.org>

It would nice to use a consistent email address through the patch.

Regards,
Shawn

> + *  Copyright (C) 2012 Linaro
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + */
> +
> +#ifndef __LINUX_MFD_ANATOP_H
> +#define __LINUX_MFD_ANATOP_H
> +
> +/**
> + * anatop - MFD data
> + * @ioreg: ioremap register
> + * @read: function to read bits from the device
> + * @write: function to write bits to the device
> + */
> +struct anatop {
> +	void *ioreg;
> +	u32 (*read) (struct anatop *adata, u32 addr, int bit_shift, int bits);
> +	void (*write) (struct anatop *adata, u32 addr, int bit_shift,
> +		       int bits, u32 data);
> +
> +};
> +
> +#endif /*  __LINUX_MFD_ANATOP_H */
> -- 
> 1.7.8.3
> 
