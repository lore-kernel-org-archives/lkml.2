Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab0EFH1k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 03:27:40 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33798 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778Ab0EFH1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 03:27:38 -0400
Date: Thu, 6 May 2010 09:27:37 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Dinh Nguyen <Dinh.Nguyen@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, valentin.longchamp@epfl.ch,
       daniel@caiaq.de, grant.likely@secretlab.ca, bryan.wu@canonical.com,
       amit.kucheria@canonical.com, Jun.Li@freescale.com,
       xiao-lizhang@freescale.com
Subject: Re: [PATCHv1 2.6.34-rc6 3/3] mx5: enable usb gadget for freescale
	mx51 babbage board
Message-ID: <20100506072737.GP31199@pengutronix.de>
References: <1273100171-3235-1-git-send-email-Dinh.Nguyen@freescale.com> <1273100171-3235-2-git-send-email-Dinh.Nguyen@freescale.com> <1273100171-3235-3-git-send-email-Dinh.Nguyen@freescale.com> <1273100171-3235-4-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273100171-3235-4-git-send-email-Dinh.Nguyen@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:16:41 up 10 days, 42 min, 20 users,  load average: 0.09, 0.16,
	0.21
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 05:56:11PM -0500, Dinh Nguyen wrote:
> This patch enables usb gadget for freescale mx51 babbage hw. It adds
> a kconfig condition for enabling either host or gadget on the OTG
> port.

I used a command line option for our boards which I find far more
convenient. Have a look at arch/arch/mach-mx2/mach-pca100.c how this is
done.
As a side effect you get rid of the 'defined but not used' warnings this
patch introduces and you don't have to put platform related kconfig
options to a totally unrelated place.

Sascha


> 
> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> ---
>  arch/arm/mach-mx5/board-mx51_babbage.c |   11 +++++++++++
>  arch/arm/mach-mx5/clock-mx51.c         |    2 ++
>  arch/arm/mach-mx5/devices.c            |   12 ++++++++++++
>  arch/arm/mach-mx5/devices.h            |    1 +
>  drivers/usb/host/Kconfig               |    8 ++++++++
>  5 files changed, 34 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-mx5/board-mx51_babbage.c b/arch/arm/mach-mx5/board-mx51_babbage.c
> index 99f7ea9..fac8ce0 100644
> --- a/arch/arm/mach-mx5/board-mx51_babbage.c
> +++ b/arch/arm/mach-mx5/board-mx51_babbage.c
> @@ -15,6 +15,7 @@
>  #include <linux/gpio.h>
>  #include <linux/delay.h>
>  #include <linux/io.h>
> +#include <linux/fsl_devices.h>
>  
>  #include <mach/common.h>
>  #include <mach/hardware.h>
> @@ -179,6 +180,11 @@ static struct mxc_usbh_platform_data dr_utmi_config = {
>  	.flags	= MXC_EHCI_INTERNAL_PHY,
>  };
>  
> +static struct fsl_usb2_platform_data usb_pdata = {
> +	.operating_mode	= FSL_USB2_DR_DEVICE,
> +	.phy_mode	= FSL_USB2_PHY_UTMI_WIDE,
> +};
> +
>  static struct mxc_usbh_platform_data usbh1_config = {
>  	.init		= initialize_usbh1_port,
>  	.portsc	= MXC_EHCI_MODE_ULPI,
> @@ -197,7 +203,12 @@ static void __init mxc_board_init(void)
>  	mxc_init_imx_uart();
>  	platform_add_devices(devices, ARRAY_SIZE(devices));
>  
> +#if defined(CONFIG_USB_EHCI_MXC_OTG)
>  	mxc_register_device(&mxc_usbdr_host_device, &dr_utmi_config);
> +#elif defined(CONFIG_USB_GADGET_FSL_USB2)
> +	initialize_otg_port(NULL);
> +	mxc_register_device(&mxc_usbdr_udc_device, &usb_pdata);
> +#endif
>  
>  	gpio_usbh1_active();
>  	mxc_register_device(&mxc_usbh1_device, &usbh1_config);
> diff --git a/arch/arm/mach-mx5/clock-mx51.c b/arch/arm/mach-mx5/clock-mx51.c
> index 933c0d1..ff15424 100644
> --- a/arch/arm/mach-mx5/clock-mx51.c
> +++ b/arch/arm/mach-mx5/clock-mx51.c
> @@ -786,6 +786,8 @@ static struct clk_lookup lookups[] = {
>  	_REGISTER_CLOCK("mxc-ehci.0", "usb_ahb", ahb_clk)
>  	_REGISTER_CLOCK("mxc-ehci.1", "usb", usboh3_clk)
>  	_REGISTER_CLOCK("mxc-ehci.1", "usb_ahb", ahb_clk)
> +	_REGISTER_CLOCK("fsl-usb2-udc", "usb", usboh3_clk)
> +	_REGISTER_CLOCK("fsl-usb2-udc", "usb_ahb", ahb_clk)
>  };
>  
>  static void clk_tree_init(void)
> diff --git a/arch/arm/mach-mx5/devices.c b/arch/arm/mach-mx5/devices.c
> index e6262f3..23850e6 100644
> --- a/arch/arm/mach-mx5/devices.c
> +++ b/arch/arm/mach-mx5/devices.c
> @@ -107,6 +107,18 @@ static struct resource usbotg_resources[] = {
>  	},
>  };
>  
> +/* OTG gadget device */
> +struct platform_device mxc_usbdr_udc_device = {
> +	.name		= "fsl-usb2-udc",
> +	.id		= -1,
> +	.num_resources	= ARRAY_SIZE(usbotg_resources),
> +	.resource	= usbotg_resources,
> +	.dev		= {
> +		.dma_mask		= &usb_dma_mask,
> +		.coherent_dma_mask	= DMA_BIT_MASK(32),
> +	},
> +};
> +
>  struct platform_device mxc_usbdr_host_device = {
>  	.name = "mxc-ehci",
>  	.id = 0,
> diff --git a/arch/arm/mach-mx5/devices.h b/arch/arm/mach-mx5/devices.h
> index 95c45f9..0494d6b 100644
> --- a/arch/arm/mach-mx5/devices.h
> +++ b/arch/arm/mach-mx5/devices.h
> @@ -4,3 +4,4 @@ extern struct platform_device mxc_uart_device2;
>  extern struct platform_device mxc_fec_device;
>  extern struct platform_device mxc_usbdr_host_device;
>  extern struct platform_device mxc_usbh1_device;
> +extern struct platform_device mxc_usbdr_udc_device;
> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> index 8d3df03..da58a2e 100644
> --- a/drivers/usb/host/Kconfig
> +++ b/drivers/usb/host/Kconfig
> @@ -123,6 +123,14 @@ config USB_EHCI_MXC
>  	---help---
>  	  Variation of ARC USB block used in some Freescale chips.
>  
> +config USB_EHCI_MXC_OTG
> +	bool "Support for DR host port on Freescale controller"
> +	depends on USB_EHCI_MXC	&& (ARCH_MX51)
> +	---help---
> +	  Enable support for the USB OTG port in HS/FS Host mode.
> +	  NOTE: Unless the OTG feature is enabled, EHCI and Gadget feature
> +	  for the OTG port should be mutually exclusive.
> +
>  config USB_EHCI_HCD_PPC_OF
>  	bool "EHCI support for PPC USB controller on OF platform bus"
>  	depends on USB_EHCI_HCD && PPC_OF
> -- 
> 1.6.0.4
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
