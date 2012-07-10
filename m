Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab2GJG3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 02:29:33 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:33831 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752787Ab2GJG3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 02:29:30 -0400
Message-ID: <4FFBCBC0.5020603@ti.com>
Date: Tue, 10 Jul 2012 11:59:20 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org, b-cousson@ti.com,
        tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org, hvaibhav@ti.com
Subject: Re: [PATCH v1 11/11] arm: omap: phy: remove unused functions from
 omap-phy-internal.c
References: <1340884267-28908-1-git-send-email-kishon@ti.com> <1340884267-28908-12-git-send-email-kishon@ti.com>
In-Reply-To: <1340884267-28908-12-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 June 2012 05:21 PM, Kishon Vijay Abraham I wrote:
> All the unnessary functions in omap-phy-internal is removed.
> These functionality are now handled by omap-usb2 phy driver.
>
> Cc: Felipe Balbi<balbi@ti.com>
> Signed-off-by: Kishon Vijay Abraham I<kishon@ti.com>
> Acked-by: Tony Lindgren<tony@atomide.com>
> ---
>   arch/arm/mach-omap2/omap_phy_internal.c |  138 -------------------------------
>   arch/arm/mach-omap2/twl-common.c        |    5 -
>   arch/arm/mach-omap2/usb-musb.c          |    3 -
>   3 files changed, 0 insertions(+), 146 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/omap_phy_internal.c b/arch/arm/mach-omap2/omap_phy_internal.c
> index 4c90477..0c610b4 100644
> --- a/arch/arm/mach-omap2/omap_phy_internal.c
> +++ b/arch/arm/mach-omap2/omap_phy_internal.c
> @@ -31,144 +31,6 @@
>   #include<plat/usb.h>
>   #include "control.h"
>
> -/* OMAP control module register for UTMI PHY */
> -#define CONTROL_DEV_CONF		0x300
> -#define PHY_PD				0x1
> -
> -#define USBOTGHS_CONTROL		0x33c
> -#define	AVALID				BIT(0)
> -#define	BVALID				BIT(1)
> -#define	VBUSVALID			BIT(2)
> -#define	SESSEND				BIT(3)
> -#define	IDDIG				BIT(4)
> -
> -static struct clk *phyclk, *clk48m, *clk32k;
> -static void __iomem *ctrl_base;
> -static int usbotghs_control;
> -
> -int omap4430_phy_init(struct device *dev)
> -{
> -	ctrl_base = ioremap(OMAP443X_SCM_BASE, SZ_1K);
> -	if (!ctrl_base) {
> -		pr_err("control module ioremap failed\n");
> -		return -ENOMEM;
> -	}
> -	/* Power down the phy */
> -	__raw_writel(PHY_PD, ctrl_base + CONTROL_DEV_CONF);

Just checking, but I hope your new driver handles this too.
You might not see any issues with it now, but not doing this could
gate OMAP hitting low power in idle.

regards,
Rajendra

> -
> -	if (!dev) {
> -		iounmap(ctrl_base);
> -		return 0;
> -	}
> -
> -	phyclk = clk_get(dev, "ocp2scp_usb_phy_ick");
> -	if (IS_ERR(phyclk)) {
> -		dev_err(dev, "cannot clk_get ocp2scp_usb_phy_ick\n");
> -		iounmap(ctrl_base);
> -		return PTR_ERR(phyclk);
> -	}
> -
> -	clk48m = clk_get(dev, "ocp2scp_usb_phy_phy_48m");
> -	if (IS_ERR(clk48m)) {
> -		dev_err(dev, "cannot clk_get ocp2scp_usb_phy_phy_48m\n");
> -		clk_put(phyclk);
> -		iounmap(ctrl_base);
> -		return PTR_ERR(clk48m);
> -	}
> -
> -	clk32k = clk_get(dev, "usb_phy_cm_clk32k");
> -	if (IS_ERR(clk32k)) {
> -		dev_err(dev, "cannot clk_get usb_phy_cm_clk32k\n");
> -		clk_put(phyclk);
> -		clk_put(clk48m);
> -		iounmap(ctrl_base);
> -		return PTR_ERR(clk32k);
> -	}
> -	return 0;
> -}
> -
> -int omap4430_phy_set_clk(struct device *dev, int on)
> -{
> -	static int state;
> -
> -	if (on&&  !state) {
> -		/* Enable the phy clocks */
> -		clk_enable(phyclk);
> -		clk_enable(clk48m);
> -		clk_enable(clk32k);
> -		state = 1;
> -	} else if (state) {
> -		/* Disable the phy clocks */
> -		clk_disable(phyclk);
> -		clk_disable(clk48m);
> -		clk_disable(clk32k);
> -		state = 0;
> -	}
> -	return 0;
> -}
> -
> -int omap4430_phy_power(struct device *dev, int ID, int on)
> -{
> -	if (on) {
> -		if (ID)
> -			/* enable VBUS valid, IDDIG groung */
> -			__raw_writel(AVALID | VBUSVALID, ctrl_base +
> -							USBOTGHS_CONTROL);
> -		else
> -			/*
> -			 * Enable VBUS Valid, AValid and IDDIG
> -			 * high impedance
> -			 */
> -			__raw_writel(IDDIG | AVALID | VBUSVALID,
> -						ctrl_base + USBOTGHS_CONTROL);
> -	} else {
> -		/* Enable session END and IDIG to high impedance. */
> -		__raw_writel(SESSEND | IDDIG, ctrl_base +
> -					USBOTGHS_CONTROL);
> -	}
> -	return 0;
> -}
> -
> -int omap4430_phy_suspend(struct device *dev, int suspend)
> -{
> -	if (suspend) {
> -		/* Disable the clocks */
> -		omap4430_phy_set_clk(dev, 0);
> -		/* Power down the phy */
> -		__raw_writel(PHY_PD, ctrl_base + CONTROL_DEV_CONF);
> -
> -		/* save the context */
> -		usbotghs_control = __raw_readl(ctrl_base + USBOTGHS_CONTROL);
> -	} else {
> -		/* Enable the internel phy clcoks */
> -		omap4430_phy_set_clk(dev, 1);
> -		/* power on the phy */
> -		if (__raw_readl(ctrl_base + CONTROL_DEV_CONF)&  PHY_PD) {
> -			__raw_writel(~PHY_PD, ctrl_base + CONTROL_DEV_CONF);
> -			mdelay(200);
> -		}
> -
> -		/* restore the context */
> -		__raw_writel(usbotghs_control, ctrl_base + USBOTGHS_CONTROL);
> -	}
> -
> -	return 0;
> -}
> -
> -int omap4430_phy_exit(struct device *dev)
> -{
> -	if (ctrl_base)
> -		iounmap(ctrl_base);
> -	if (phyclk)
> -		clk_put(phyclk);
> -	if (clk48m)
> -		clk_put(clk48m);
> -	if (clk32k)
> -		clk_put(clk32k);
> -
> -	return 0;
> -}
> -
>   void am35x_musb_reset(void)
>   {
>   	u32	regval;
> diff --git a/arch/arm/mach-omap2/twl-common.c b/arch/arm/mach-omap2/twl-common.c
> index 119d5a9..396d189 100644
> --- a/arch/arm/mach-omap2/twl-common.c
> +++ b/arch/arm/mach-omap2/twl-common.c
> @@ -250,11 +250,6 @@ void __init omap3_pmic_get_config(struct twl4030_platform_data *pmic_data,
>
>   #if defined(CONFIG_ARCH_OMAP4)
>   static struct twl4030_usb_data omap4_usb_pdata = {
> -	.phy_init	= omap4430_phy_init,
> -	.phy_exit	= omap4430_phy_exit,
> -	.phy_power	= omap4430_phy_power,
> -	.phy_set_clock	= omap4430_phy_set_clk,
> -	.phy_suspend	= omap4430_phy_suspend,
>   };
>
>   static struct regulator_init_data omap4_vdac_idata = {
> diff --git a/arch/arm/mach-omap2/usb-musb.c b/arch/arm/mach-omap2/usb-musb.c
> index b19d1b4..e87ae49 100644
> --- a/arch/arm/mach-omap2/usb-musb.c
> +++ b/arch/arm/mach-omap2/usb-musb.c
> @@ -119,7 +119,4 @@ void __init usb_musb_init(struct omap_musb_board_data *musb_board_data)
>   	dev->dma_mask =&musb_dmamask;
>   	dev->coherent_dma_mask = musb_dmamask;
>   	put_device(dev);
> -
> -	if (cpu_is_omap44xx())
> -		omap4430_phy_init(dev);
>   }

