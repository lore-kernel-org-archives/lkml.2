Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab0EJSnP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 14:43:15 -0400
Received: from mail.gmx.net ([213.165.64.20]:40604 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750824Ab0EJSnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 14:43:12 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18YVUZYrDUYUT0zETWnIMNBmXcdKfXk5vx23Vs7+F
	0HRy0OXpmKuXs1
Date: Mon, 10 May 2010 20:43:12 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Dinh Nguyen <Dinh.Nguyen@freescale.com>
cc: linux-kernel@vger.kernel.org, amit.kucheria@canonical.com,
       s.hauer@pengutronix.de, linux-usb@vger.kernel.org, Jun.Li@freescale.com,
       grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org,
       daniel@caiaq.de, bryan.wu@canonical.com, xiao-lizhang@freescale.com,
       valentin.longchamp@epfl.ch
Subject: Re: [PATCHv2 2.6.34-rc7 1/3] mxc: gadget: remove 60mhz clock
 requirement for freescale mx51 usb core
In-Reply-To: <1273508519-23033-1-git-send-email-Dinh.Nguyen@freescale.com>
Message-ID: <Pine.LNX.4.64.1005102041040.15250@axis700.grange>
References: <1273508519-23033-1-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 May 2010, Dinh Nguyen wrote:

> renamed fsl_mx3_udc.c -> fsl_mxc_udc.c
> for mx51, usb core is clocked from sources that are not 60mhz.
> 
> This patch applies to 2.6.34-rc7.

For such patches it helps to use the "-M -C" options to "git format 
patch," which would then make reviewing your changes easier...

Thanks
Guennadi

> 
> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> ---
>  drivers/usb/gadget/Makefile      |    2 +-
>  drivers/usb/gadget/fsl_mx3_udc.c |  104 -------------------------------------
>  drivers/usb/gadget/fsl_mxc_udc.c |  106 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 107 insertions(+), 105 deletions(-)
>  delete mode 100644 drivers/usb/gadget/fsl_mx3_udc.c
>  create mode 100644 drivers/usb/gadget/fsl_mxc_udc.c
> 
> diff --git a/drivers/usb/gadget/Makefile b/drivers/usb/gadget/Makefile
> index 43b51da..c922eef 100644
> --- a/drivers/usb/gadget/Makefile
> +++ b/drivers/usb/gadget/Makefile
> @@ -20,7 +20,7 @@ obj-$(CONFIG_USB_ATMEL_USBA)	+= atmel_usba_udc.o
>  obj-$(CONFIG_USB_FSL_USB2)	+= fsl_usb2_udc.o
>  fsl_usb2_udc-objs		:= fsl_udc_core.o
>  ifeq ($(CONFIG_ARCH_MXC),y)
> -fsl_usb2_udc-objs		+= fsl_mx3_udc.o
> +fsl_usb2_udc-objs		+= fsl_mxc_udc.o
>  endif
>  obj-$(CONFIG_USB_M66592)	+= m66592-udc.o
>  obj-$(CONFIG_USB_R8A66597)	+= r8a66597-udc.o
> diff --git a/drivers/usb/gadget/fsl_mx3_udc.c b/drivers/usb/gadget/fsl_mx3_udc.c
> deleted file mode 100644
> index 20a802e..0000000
> --- a/drivers/usb/gadget/fsl_mx3_udc.c
> +++ /dev/null
> @@ -1,104 +0,0 @@
> -/*
> - * Copyright (C) 2009
> - * Guennadi Liakhovetski, DENX Software Engineering, <lg@denx.de>
> - *
> - * Description:
> - * Helper routines for i.MX3x SoCs from Freescale, needed by the fsl_usb2_udc.c
> - * driver to function correctly on these systems.
> - *
> - * This program is free software; you can redistribute  it and/or modify it
> - * under  the terms of  the GNU General  Public License as published by the
> - * Free Software Foundation;  either version 2 of the  License, or (at your
> - * option) any later version.
> - */
> -#include <linux/clk.h>
> -#include <linux/delay.h>
> -#include <linux/err.h>
> -#include <linux/fsl_devices.h>
> -#include <linux/platform_device.h>
> -
> -#include <mach/hardware.h>
> -
> -static struct clk *mxc_ahb_clk;
> -static struct clk *mxc_usb_clk;
> -
> -int fsl_udc_clk_init(struct platform_device *pdev)
> -{
> -	struct fsl_usb2_platform_data *pdata;
> -	unsigned long freq;
> -	int ret;
> -
> -	pdata = pdev->dev.platform_data;
> -
> -	if (!cpu_is_mx35()) {
> -		mxc_ahb_clk = clk_get(&pdev->dev, "usb_ahb");
> -		if (IS_ERR(mxc_ahb_clk))
> -			return PTR_ERR(mxc_ahb_clk);
> -
> -		ret = clk_enable(mxc_ahb_clk);
> -		if (ret < 0) {
> -			dev_err(&pdev->dev, "clk_enable(\"usb_ahb\") failed\n");
> -			goto eenahb;
> -		}
> -	}
> -
> -	/* make sure USB_CLK is running at 60 MHz +/- 1000 Hz */
> -	mxc_usb_clk = clk_get(&pdev->dev, "usb");
> -	if (IS_ERR(mxc_usb_clk)) {
> -		dev_err(&pdev->dev, "clk_get(\"usb\") failed\n");
> -		ret = PTR_ERR(mxc_usb_clk);
> -		goto egusb;
> -	}
> -
> -	freq = clk_get_rate(mxc_usb_clk);
> -	if (pdata->phy_mode != FSL_USB2_PHY_ULPI &&
> -	    (freq < 59999000 || freq > 60001000)) {
> -		dev_err(&pdev->dev, "USB_CLK=%lu, should be 60MHz\n", freq);
> -		ret = -EINVAL;
> -		goto eclkrate;
> -	}
> -
> -	ret = clk_enable(mxc_usb_clk);
> -	if (ret < 0) {
> -		dev_err(&pdev->dev, "clk_enable(\"usb_clk\") failed\n");
> -		goto eenusb;
> -	}
> -
> -	return 0;
> -
> -eenusb:
> -eclkrate:
> -	clk_put(mxc_usb_clk);
> -	mxc_usb_clk = NULL;
> -egusb:
> -	if (!cpu_is_mx35())
> -		clk_disable(mxc_ahb_clk);
> -eenahb:
> -	if (!cpu_is_mx35())
> -		clk_put(mxc_ahb_clk);
> -	return ret;
> -}
> -
> -void fsl_udc_clk_finalize(struct platform_device *pdev)
> -{
> -	struct fsl_usb2_platform_data *pdata = pdev->dev.platform_data;
> -
> -	/* ULPI transceivers don't need usbpll */
> -	if (pdata->phy_mode == FSL_USB2_PHY_ULPI) {
> -		clk_disable(mxc_usb_clk);
> -		clk_put(mxc_usb_clk);
> -		mxc_usb_clk = NULL;
> -	}
> -}
> -
> -void fsl_udc_clk_release(void)
> -{
> -	if (mxc_usb_clk) {
> -		clk_disable(mxc_usb_clk);
> -		clk_put(mxc_usb_clk);
> -	}
> -	if (!cpu_is_mx35()) {
> -		clk_disable(mxc_ahb_clk);
> -		clk_put(mxc_ahb_clk);
> -	}
> -}
> diff --git a/drivers/usb/gadget/fsl_mxc_udc.c b/drivers/usb/gadget/fsl_mxc_udc.c
> new file mode 100644
> index 0000000..d0b8bde
> --- /dev/null
> +++ b/drivers/usb/gadget/fsl_mxc_udc.c
> @@ -0,0 +1,106 @@
> +/*
> + * Copyright (C) 2009
> + * Guennadi Liakhovetski, DENX Software Engineering, <lg@denx.de>
> + *
> + * Description:
> + * Helper routines for i.MX3x SoCs from Freescale, needed by the fsl_usb2_udc.c
> + * driver to function correctly on these systems.
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/err.h>
> +#include <linux/fsl_devices.h>
> +#include <linux/platform_device.h>
> +
> +#include <mach/hardware.h>
> +
> +static struct clk *mxc_ahb_clk;
> +static struct clk *mxc_usb_clk;
> +
> +int fsl_udc_clk_init(struct platform_device *pdev)
> +{
> +	struct fsl_usb2_platform_data *pdata;
> +	unsigned long freq;
> +	int ret;
> +
> +	pdata = pdev->dev.platform_data;
> +
> +	if (!cpu_is_mx35()) {
> +		mxc_ahb_clk = clk_get(&pdev->dev, "usb_ahb");
> +		if (IS_ERR(mxc_ahb_clk))
> +			return PTR_ERR(mxc_ahb_clk);
> +
> +		ret = clk_enable(mxc_ahb_clk);
> +		if (ret < 0) {
> +			dev_err(&pdev->dev, "clk_enable(\"usb_ahb\") failed\n");
> +			goto eenahb;
> +		}
> +	}
> +
> +	/* make sure USB_CLK is running at 60 MHz +/- 1000 Hz */
> +	mxc_usb_clk = clk_get(&pdev->dev, "usb");
> +	if (IS_ERR(mxc_usb_clk)) {
> +		dev_err(&pdev->dev, "clk_get(\"usb\") failed\n");
> +		ret = PTR_ERR(mxc_usb_clk);
> +		goto egusb;
> +	}
> +
> +	if (!cpu_is_mx51()) {
> +		freq = clk_get_rate(mxc_usb_clk);
> +		if (pdata->phy_mode != FSL_USB2_PHY_ULPI &&
> +		    (freq < 59999000 || freq > 60001000)) {
> +			dev_err(&pdev->dev, "USB_CLK=%lu, should be 60MHz\n", freq);
> +			ret = -EINVAL;
> +			goto eclkrate;
> +		}
> +	}
> +
> +	ret = clk_enable(mxc_usb_clk);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "clk_enable(\"usb_clk\") failed\n");
> +		goto eenusb;
> +	}
> +
> +	return 0;
> +
> +eenusb:
> +eclkrate:
> +	clk_put(mxc_usb_clk);
> +	mxc_usb_clk = NULL;
> +egusb:
> +	if (!cpu_is_mx35())
> +		clk_disable(mxc_ahb_clk);
> +eenahb:
> +	if (!cpu_is_mx35())
> +		clk_put(mxc_ahb_clk);
> +	return ret;
> +}
> +
> +void fsl_udc_clk_finalize(struct platform_device *pdev)
> +{
> +	struct fsl_usb2_platform_data *pdata = pdev->dev.platform_data;
> +
> +	/* ULPI transceivers don't need usbpll */
> +	if (pdata->phy_mode == FSL_USB2_PHY_ULPI) {
> +		clk_disable(mxc_usb_clk);
> +		clk_put(mxc_usb_clk);
> +		mxc_usb_clk = NULL;
> +	}
> +}
> +
> +void fsl_udc_clk_release(void)
> +{
> +	if (mxc_usb_clk) {
> +		clk_disable(mxc_usb_clk);
> +		clk_put(mxc_usb_clk);
> +	}
> +	if (!cpu_is_mx35()) {
> +		clk_disable(mxc_ahb_clk);
> +		clk_put(mxc_ahb_clk);
> +	}
> +}
> -- 
> 1.6.0.4
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
