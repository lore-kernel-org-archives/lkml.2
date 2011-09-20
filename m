Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab1ITGuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 02:50:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:33454 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791Ab1ITGue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 02:50:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,410,1312182000"; 
   d="scan'208";a="53466707"
Date: Tue, 20 Sep 2011 09:50:38 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Li Yang <leoli@freescale.com>,
        Pavankumar Kondeti <pkondeti@codeaurora.org>,
        Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Chen <peter.chen@freescale.com>,
        Lin Tony-B19295 <B19295@freescale.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: Re: [PATCHv4 00/19] First round in OTG rework
Message-ID: <20110920065038.GA28684@xps8300>
References: <1315379772-8830-1-git-send-email-heikki.krogerus@linux.intel.com>
 <20110912121255.GA2520@xps8300>
 <20110919115520.GX21769@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110919115520.GX21769@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Sep 19, 2011 at 01:55:20PM +0200, Sascha Hauer wrote:
> The following is needed to make i.MX compile and work. You renamed
> pdata->otg to pdata->xceiv in the driver, but not in the header file.
> Renaming it would also mean to rename it in the boards using this
> header, that's why I kept the name 'otg' for now instead of renaming
> it to 'xceiv' (or 'phy' which I like better).

Thanks for the review. Is it OK to make this part of the imx patch?


> diff --git a/arch/arm/mach-imx/mx31moboard-devboard.c b/arch/arm/mach-imx/mx31moboard-devboard.c
> index cb792d0..f11d0ef 100644
> --- a/arch/arm/mach-imx/mx31moboard-devboard.c
> +++ b/arch/arm/mach-imx/mx31moboard-devboard.c
> @@ -177,7 +177,7 @@ static int devboard_isp1105_init(struct usb_phy *otg)
>  }
>  
>  
> -static int devboard_isp1105_set_vbus(struct usb_phy *otg, bool on)
> +static int devboard_isp1105_set_vbus(struct usb_otg *otg, bool on)
>  {
>  	if (on)
>  		gpio_set_value(USBH1_VBUSEN_B, 0);
> diff --git a/arch/arm/mach-imx/mx31moboard-marxbot.c b/arch/arm/mach-imx/mx31moboard-marxbot.c
> index f921e47..0eb1d12 100644
> --- a/arch/arm/mach-imx/mx31moboard-marxbot.c
> +++ b/arch/arm/mach-imx/mx31moboard-marxbot.c
> @@ -291,7 +291,7 @@ static int marxbot_isp1105_init(struct usb_phy *otg)
>  }
>  
>  
> -static int marxbot_isp1105_set_vbus(struct usb_phy *otg, bool on)
> +static int marxbot_isp1105_set_vbus(struct usb_otg *otg, bool on)
>  {
>  	if (on)
>  		gpio_set_value(USBH1_VBUSEN_B, 0);
> diff --git a/arch/arm/plat-mxc/include/mach/mxc_ehci.h b/arch/arm/plat-mxc/include/mach/mxc_ehci.h
> index 2c159dc..9ffd1bb 100644
> --- a/arch/arm/plat-mxc/include/mach/mxc_ehci.h
> +++ b/arch/arm/plat-mxc/include/mach/mxc_ehci.h
> @@ -44,7 +44,7 @@ struct mxc_usbh_platform_data {
>  	int (*exit)(struct platform_device *pdev);
>  
>  	unsigned int		 portsc;
> -	struct otg_transceiver	*otg;
> +	struct usb_phy		*otg;
>  };
>  
>  int mx51_initialize_usb_hw(int port, unsigned int flags);
> diff --git a/drivers/usb/host/ehci-mxc.c b/drivers/usb/host/ehci-mxc.c
> index 6e32147..cf8f192 100644
> --- a/drivers/usb/host/ehci-mxc.c
> +++ b/drivers/usb/host/ehci-mxc.c
> @@ -218,15 +218,15 @@ static int ehci_mxc_drv_probe(struct platform_device *pdev)
>  	msleep(10);
>  
>  	/* Initialize the transceiver */
> -	if (pdata->xceiv) {
> -		pdata->xceiv->io_priv = hcd->regs + ULPI_VIEWPORT_OFFSET;
> -		ret = usb_phy_init(pdata->xceiv);
> +	if (pdata->otg) {
> +		pdata->otg->io_priv = hcd->regs + ULPI_VIEWPORT_OFFSET;
> +		ret = usb_phy_init(pdata->otg);
>  		if (ret) {
>  			dev_err(dev, "unable to init transceiver, probably missing\n");
>  			ret = -ENODEV;
>  			goto err_add;
>  		}
> -		ret = otg_set_vbus(pdata->xceiv->otg, 1);
> +		ret = otg_set_vbus(pdata->otg->otg, 1);
>  		if (ret) {
>  			dev_err(dev, "unable to enable vbus on transceiver\n");
>  			goto err_add;
> @@ -240,17 +240,17 @@ static int ehci_mxc_drv_probe(struct platform_device *pdev)
>  	if (ret)
>  		goto err_add;
>  
> -	if (pdata->xceiv) {
> +	if (pdata->otg) {
>  		/*
>  		 * efikamx and efikasb have some hardware bug which is
>  		 * preventing usb to work unless CHRGVBUS is set.
>  		 * It's in violation of USB specs
>  		 */
>  		if (machine_is_mx51_efikamx() || machine_is_mx51_efikasb()) {
> -			flags = usb_phy_io_read(pdata->xceiv,
> +			flags = usb_phy_io_read(pdata->otg,
>  							ULPI_OTG_CTRL);
>  			flags |= ULPI_OTG_CTRL_CHRGVBUS;
> -			ret = usb_phy_io_write(pdata->xceiv, flags,
> +			ret = usb_phy_io_write(pdata->otg, flags,
>  							ULPI_OTG_CTRL);
>  			if (ret) {
>  				dev_err(dev, "unable to set CHRVBUS\n");
> @@ -298,8 +298,8 @@ static int __exit ehci_mxc_drv_remove(struct platform_device *pdev)
>  	if (pdata && pdata->exit)
>  		pdata->exit(pdev);
>  
> -	if (pdata->xceiv)
> -		usb_phy_shutdown(pdata->xceiv);
> +	if (pdata->otg)
> +		usb_phy_shutdown(pdata->otg);
>  
>  	usb_remove_hcd(hcd);
>  	iounmap(hcd->regs);

-- 
heikki
