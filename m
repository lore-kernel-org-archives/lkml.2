Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab0LAGFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 01:05:06 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:44344 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750998Ab0LAGFE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 01:05:04 -0500
MIME-Version: 1.0
In-Reply-To: <1291147139-23472-2-git-send-email-davidsin@ti.com>
References: <1291147139-23472-1-git-send-email-davidsin@ti.com> <1291147139-23472-2-git-send-email-davidsin@ti.com>
From: "Varadarajan, Charulatha" <charu@ti.com>
Date: Wed, 1 Dec 2010 11:34:22 +0530
Message-ID: <AANLkTi=q1HzYBpMH_pP+S5BtBQpHs62+zNfd_MtWHFuu@mail.gmail.com>
Subject: Re: [RFC v2 1/8] TILER-DMM: DMM-PAT driver for TI TILER
To: David Sin <davidsin@ti.com>
Cc: Greg KH <greg@kroah.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Lajos Molnar <molnar@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On Wed, Dec 1, 2010 at 01:28, David Sin <davidsin@ti.com> wrote:
> This patch adds support for DMM-PAT initialization and programming.
>
> Signed-off-by: David Sin <davidsin@ti.com>
> Signed-off-by: Lajos Molnar <molnar@ti.com>
> ---
>  arch/arm/mach-omap2/dmm-omap44xx.c     |   81 ++++++++++++++
>  arch/arm/mach-omap2/include/mach/dmm.h |   92 ++++++++++++++++
>  drivers/misc/tiler/dmm-main.c          |  187 ++++++++++++++++++++++++++++++++
>  3 files changed, 360 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-omap2/dmm-omap44xx.c
>  create mode 100644 arch/arm/mach-omap2/include/mach/dmm.h
>  create mode 100644 drivers/misc/tiler/dmm-main.c
>
> diff --git a/arch/arm/mach-omap2/dmm-omap44xx.c b/arch/arm/mach-omap2/dmm-omap44xx.c
> new file mode 100644
> index 0000000..2919d8e
> --- /dev/null
> +++ b/arch/arm/mach-omap2/dmm-omap44xx.c
> @@ -0,0 +1,81 @@
> +/*
> + * DMM driver support functions for TI OMAP processors.
> + *
> + * Copyright (C) 2010 Texas Instruments Incorporated - http://www.ti.com/
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <mach/dmm.h>
> +#include <plat/omap_device.h>
> +#include <plat/omap_hwmod.h>
> +#include <linux/errno.h>
> +#include <linux/err.h>
> +
> +static struct dmm *plat_data;
> +static int pdata;
> +
> +#ifdef CONFIG_ARCH_OMAP4

Do not use these #ifdefs as it would not work as intended in multi-omap build.
This driver is making use of omap_hwmod fw. Try to take advantage of hwmod_fw
and avoid these checks.

> +static struct dmm omap4_plat_data[] = {
> +       {
> +               .oh_name = "dmm",

Do not use "oh_name" as it is confusing.

> +       },
> +};
> +#define NUM_PDATA ARRAY_SIZE(omap4_plat_data)
> +#else
> +#define omap4_plat_data NULL
> +#define NUM_PDATA 0
> +#endif
> +
> +static struct omap_device_pm_latency omap_dmm_latency[] = {
> +       [0] = {
> +               .deactivate_func = omap_device_idle_hwmods,
> +               .activate_func = omap_device_enable_hwmods,
> +               .flags = OMAP_DEVICE_LATENCY_AUTO_ADJUST,
> +       },
> +};
> +
> +static s32 __init dmm_omap_init(void)
> +{
> +       struct omap_hwmod *oh = NULL;
> +       struct omap_device *od = NULL;
> +       struct omap_device_pm_latency *ohl = NULL;

Any specific reson for not assigning it directly to omap_dmm_latency?
I think this is redundant and omap_dmm_latency can be directly passed
to omap_device_build()

> +       int ohlc = 0, i = 0;
> +
> +       plat_data = omap4_plat_data;
> +       pdata = NUM_PDATA;

name "pdata" is confusing. Also no need to iterate over the list of
devices using
NUM_PDATA. If you have multiple devices, make use of hwmod class.

> +
> +       for (i = 0; i < pdata; i++) {
> +               struct dmm *data = &plat_data[i];
> +
> +               oh = omap_hwmod_lookup(data->oh_name)

I do not find any other devices sharing same name for the device name
and oh->name.
Normally the device's name is preferred to be "omap_devname.id" to be
consistent across all drivers
and the oh->name is given as "devname(id)"

example: McSPI's device name could be "omap_mcspi" and it's hwmod name
could be "mcspi"

> +               if (!oh)
> +                       goto error;
> +
> +               data->base = oh->_mpu_rt_va;

not required. Make use of platform_get APIs in probe to extract the
base, dma and irq info using pdev.

> +               ohl = omap_dmm_latency;
> +               ohlc = ARRAY_SIZE(omap_dmm_latency);
> +
> +               od = omap_device_build(data->oh_name, i, oh, data,
> +                                        sizeof(*data), ohl, ohlc, false);
> +               if (IS_ERR(od))
> +                       goto error;
> +       }
> +       return 0;
> +error:
> +       return -ENODEV;

print the error message.

> +}
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("David Sin <davidsin@ti.com>");
> +MODULE_AUTHOR("Lajos Molnar <molnar@ti.com>");
> +device_initcall(dmm_omap_init);

<<snip>>
