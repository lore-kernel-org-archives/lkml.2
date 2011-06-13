Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540Ab1FMUWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 16:22:05 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:41188 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751099Ab1FMUWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 16:22:03 -0400
From: Kevin Hilman <khilman@ti.com>
To: Carlos Chinea <carlos.chinea@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [RFC PATCHv5 2/7] HSI: omap_ssi: Introducing OMAP SSI driver
Organization: Texas Instruments, Inc.
References: <1307713124-3946-1-git-send-email-carlos.chinea@nokia.com>
	<1307713124-3946-3-git-send-email-carlos.chinea@nokia.com>
Date: Mon, 13 Jun 2011 13:21:59 -0700
In-Reply-To: <1307713124-3946-3-git-send-email-carlos.chinea@nokia.com>
	(Carlos Chinea's message of "Fri, 10 Jun 2011 16:38:39 +0300")
Message-ID: <874o3tmqhk.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carlos Chinea <carlos.chinea@nokia.com> writes:

> Introduces the OMAP SSI driver in the kernel.
>
> The Synchronous Serial Interface (SSI) is a legacy version
> of HSI. As in the case of HSI, it is mainly used to connect
> Application engines (APE) with cellular modem engines (CMT)
> in cellular handsets.
>
> It provides a multichannel, full-duplex, multi-core communication
> with no reference clock. The OMAP SSI block is capable of reaching
> speeds of 110 Mbit/s.
>
> Signed-off-by: Carlos Chinea <carlos.chinea@nokia.com>
> ---
>  arch/arm/mach-omap2/ssi.c             |  134 +++
>  arch/arm/plat-omap/include/plat/ssi.h |  204 ++++
>  drivers/hsi/controllers/omap_ssi.c    | 1852 +++++++++++++++++++++++++++++++++
>  3 files changed, 2190 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-omap2/ssi.c
>  create mode 100644 arch/arm/plat-omap/include/plat/ssi.h
>  create mode 100644 drivers/hsi/controllers/omap_ssi.c
>
> diff --git a/arch/arm/mach-omap2/ssi.c b/arch/arm/mach-omap2/ssi.c
> new file mode 100644
> index 0000000..e822a77
> --- /dev/null
> +++ b/arch/arm/mach-omap2/ssi.c
> @@ -0,0 +1,134 @@
> +/*
> + * linux/arch/arm/mach-omap2/ssi.c

Minor: Please don't include filenames in the comments.  Files tend to move
around and these comments don't get updated.

> + * Copyright (C) 2010 Nokia Corporation. All rights reserved.
> + *
> + * Contact: Carlos Chinea <carlos.chinea@nokia.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> + * 02110-1301 USA
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/err.h>
> +#include <linux/gpio.h>
> +#include <linux/platform_device.h>
> +#include <plat/omap-pm.h>
> +#include <plat/ssi.h>
> +
> +static struct omap_ssi_platform_data ssi_pdata = {
> +	.num_ports			= SSI_NUM_PORTS,
> +	.get_dev_context_loss_count	= omap_pm_get_dev_context_loss_count,
> +};
> +
> +static struct resource ssi_resources[] = {
> +	/* SSI controller */
> +	[0] = {
> +		.start	= 0x48058000,
> +		.end	= 0x48058fff,
> +		.name	= "omap_ssi_sys",
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	/* GDD */
> +	[1] = {
> +		.start	= 0x48059000,
> +		.end	= 0x48059fff,
> +		.name	= "omap_ssi_gdd",
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	[2] = {
> +		.start	= 71,
> +		.end	= 71,
> +		.name	= "ssi_gdd",
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +	/* SSI port 1 */
> +	[3] = {
> +		.start	= 0x4805a000,
> +		.end	= 0x4805a7ff,
> +		.name	= "omap_ssi_sst1",
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	[4] = {
> +		.start	= 0x4805a800,
> +		.end	= 0x4805afff,
> +		.name	= "omap_ssi_ssr1",
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	[5] = {
> +		.start	= 67,
> +		.end	= 67,
> +		.name	= "ssi_p1_mpu_irq0",
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +	[6] = {
> +		.start	= 68,
> +		.end	= 68,
> +		.name	= "ssi_p1_mpu_irq1",
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +	[7] = {
> +		.start	= 0,
> +		.end	= 0,
> +		.name	= "ssi_p1_cawake",
> +		.flags	= IORESOURCE_IRQ | IORESOURCE_UNSET,
> +	},
> +};
> +
> +static struct platform_device ssi_pdev = {
> +	.name		= "omap_ssi",
> +	.id		= 0,
> +	.num_resources	= ARRAY_SIZE(ssi_resources),
> +	.resource	= ssi_resources,
> +	.dev		= {
> +				.platform_data	= &ssi_pdata,
> +	},
> +};

omap_hwmod has all the base address and IRQ data, will construct the
struct resources and the platform_devices for you.  Please use
omap_hwmod + omap_device for this part of the code.

Kevin


