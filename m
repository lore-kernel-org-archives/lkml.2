Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab0DMRjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 13:39:23 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:35413 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab0DMRjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 13:39:22 -0400
Date: Tue, 13 Apr 2010 19:39:17 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, amit.kucheria@canonical.com,
       linux@arm.linux.org.uk, s.hauer@pengutronix.de,
       grant.likely@secretlab.ca, r.herring@freescale.com,
       linux-arm-kernel@lists.infradead.org, bryan.wu@canonical.com,
       valentin.longchamp@epfl.ch
Subject: Re: [PATCH 2.6.34-rc4 5/8] mx5: Add USB Host1 port registration
Message-ID: <20100413173917.GQ30801@buzzloop.caiaq.de>
References: <1271175030-3635-1-git-send-email-Dinh.Nguyen@freescale.com>
 <1271175030-3635-2-git-send-email-Dinh.Nguyen@freescale.com>
 <1271175030-3635-3-git-send-email-Dinh.Nguyen@freescale.com>
 <1271175030-3635-4-git-send-email-Dinh.Nguyen@freescale.com>
 <1271175030-3635-5-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271175030-3635-5-git-send-email-Dinh.Nguyen@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 11:10:28AM -0500, Dinh.Nguyen@freescale.com wrote:
> diff --git a/arch/arm/mach-mx5/usb_h1.c b/arch/arm/mach-mx5/usb_h1.c
> new file mode 100644
> index 0000000..23ae336
> --- /dev/null
> +++ b/arch/arm/mach-mx5/usb_h1.c
> @@ -0,0 +1,90 @@
> +/*
> + * Copyright (C) 2010 Freescale Semiconductor, Inc. All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
> + * MA 02110-1301, USA.
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/gpio.h>
> +#include <linux/platform_device.h>
> +#include <mach/iomux-mx51.h>
> +#include <mach/mxc_ehci.h>
> +#include <mach/common.h>
> +#include "devices.h"
> +
> +#define	GPIO1_27	(0*32 +27)

I'm confident there is a better definition for this already ;)

> +
> +extern int fsl_usb_host_init(struct platform_device *pdev);
> +extern int fsl_usb_host_uninit(struct fsl_usb2_platform_data *pdata);
> +
> +static int fsl_usb_host_init_ext(struct platform_device *pdev);
> +static int fsl_usb_host_uninit_ext(struct platform_device *pdev);
> +
> +static struct mxc_usbh_platform_data usbh1_config = {
> +	.init	= fsl_usb_host_init_ext,
> +	.exit	= fsl_usb_host_uninit_ext,
> +	.portsc	= MXC_EHCI_MODE_ULPI,
> +	.flags	= MXC_EHCI_POWER_PINS_ENABLED,
> +};

This is actually the way to go. All driver code in lower layers should
use these flags eventually, and no assumptions should be hard-coded
anywhere.

> +/*
> + * USB Host1 HS port
> + */
> +static int gpio_usbh1_active(void)
> +{
> +	struct pad_desc usbh1stp_gpio = MX51_PAD_GPIO_1_27__USBH1_STP_ERR;
> +	int ret;
> +
> +	/* Set USBH1_STP to GPIO and toggle it */
> +	mxc_iomux_v3_setup_pad(&usbh1stp_gpio);
> +	ret = gpio_request(GPIO1_27, "usbh1_stp");
> +
> +	if (ret) {
> +		pr_debug("failed to get USBH1_STP_GPIO1_27: %d\n", ret);
> +		return ret;
> +	}
> +	gpio_direction_output(GPIO1_27, 0);
> +	gpio_set_value(GPIO1_27, 1);
> +
> +	msleep(100);
> +	gpio_free(GPIO1_27);
> +	return 0;
> +}
> +
> +static int fsl_usb_host_init_ext(struct platform_device *pdev)
> +{
> +	int ret;
> +	struct pad_desc usbh1stp = MX51_PAD_GPIO_1_27__USBH1_STP;
> +
> +	gpio_usbh1_active();
> +	ret = fsl_usb_host_init(pdev);
> +	if (ret)
> +		return ret;
> +
> +	/* setback USBH1_STP to be function */
> +	mxc_iomux_v3_setup_pad(&usbh1stp);
> +	return 0;
> +}
> +
> +static int fsl_usb_host_uninit_ext(struct platform_device *pdev)
> +{
> +	return fsl_usb_host_uninit(pdev);
> +}
> +void __init mx5_usbh1_init(void)
> +{
> +	mxc_register_device(&mxc_usbh1_device, &usbh1_config);
> +}
> +
> -- 
> 1.6.0.4
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
