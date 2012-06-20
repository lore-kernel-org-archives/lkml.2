Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab2FTN7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 09:59:32 -0400
Received: from antcom.de ([188.40.178.216]:39655 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678Ab2FTN7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 09:59:30 -0400
Message-ID: <4FE1D73F.4060007@antcom.de>
Date: Wed, 20 Jun 2012 15:59:27 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Kevin Wells <kevin.wells@nxp.com>,
        Wolfram Sang <w.sang@pengutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: LPC32XX: Cleanup USB clock init
References: <1340193675-30717-1-git-send-email-aletes.xgr@gmail.com>
In-Reply-To: <1340193675-30717-1-git-send-email-aletes.xgr@gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2012 02:01 PM, Alexandre Pereira da Silva wrote:
> Move most of usb clock initialization from lpc32xx_udc and ohci-nxp to
> clock.c. Also adds ohci clocks and otg clocks.
> 
> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

Acked-by: Roland Stigge <stigge@antcom.de>

> ---
>  arch/arm/mach-lpc32xx/clock.c                 |   73 ++++++++++++++++++++++++-
>  arch/arm/mach-lpc32xx/include/mach/platform.h |   14 +++++
>  2 files changed, 86 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-lpc32xx/clock.c b/arch/arm/mach-lpc32xx/clock.c
> index f6a3ffe..c80f064 100644
> --- a/arch/arm/mach-lpc32xx/clock.c
> +++ b/arch/arm/mach-lpc32xx/clock.c
> @@ -727,14 +727,82 @@ static struct clk clk_rtc = {
>  	.get_rate	= local_return_parent_rate,
>  };
>  
> +static int local_usb_enable(struct clk *clk, int enable)
> +{
> +	u32 tmp;
> +
> +	if (enable) {
> +		/* Set up I2C pull levels
> +		 *
> +		 * This should never be disabled as the host/gadget driver may
> +		 * need to talk to the usb transceiver while the main clocks are
> +		 * disabled to save power.
> +		 */
> +		tmp = __raw_readl(LPC32XX_CLKPWR_I2C_CLK_CTRL);
> +		tmp |= LPC32XX_CLKPWR_I2CCLK_USBI2CHI_DRIVE;
> +		__raw_writel(tmp, LPC32XX_CLKPWR_I2C_CLK_CTRL);
> +	}
> +
> +	return local_onoff_enable(clk, enable);
> +}
> +
>  static struct clk clk_usbd = {
>  	.parent		= &clk_usbpll,
> -	.enable		= local_onoff_enable,
> +	.enable		= local_usb_enable,
>  	.enable_reg	= LPC32XX_CLKPWR_USB_CTRL,
>  	.enable_mask	= LPC32XX_CLKPWR_USBCTRL_HCLK_EN,
>  	.get_rate	= local_return_parent_rate,
>  };
>  
> +#define OTG_ALWAYS_MASK		(LPC32XX_USB_OTG_OTG_CLOCK_ON | \
> +				 LPC32XX_USB_OTG_I2C_CLOCK_ON)
> +
> +static int local_usb_otg_enable(struct clk *clk, int enable)
> +{
> +	int to = 1000;
> +
> +	if (enable) {
> +		__raw_writel(clk->enable_mask, clk->enable_reg);
> +
> +		while (((__raw_readl(LPC32XX_USB_OTG_CLK_STAT) &
> +			clk->enable_mask) != clk->enable_mask) && (to > 0))
> +			to--;
> +	} else {
> +		__raw_writel(OTG_ALWAYS_MASK, clk->enable_reg);
> +
> +		while (((__raw_readl(LPC32XX_USB_OTG_CLK_STAT) &
> +			OTG_ALWAYS_MASK) != OTG_ALWAYS_MASK) && (to > 0))
> +			to--;
> +	}
> +
> +	if (to)
> +		return 0;
> +	else
> +		return -1;
> +}
> +
> +static struct clk clk_usb_otg_dev = {
> +	.parent		= &clk_usbpll,
> +	.enable		= local_usb_otg_enable,
> +	.enable_reg	= LPC32XX_USB_OTG_CLK_CTRL,
> +	.enable_mask	= LPC32XX_USB_OTG_AHB_M_CLOCK_ON |
> +			  LPC32XX_USB_OTG_OTG_CLOCK_ON |
> +			  LPC32XX_USB_OTG_DEV_CLOCK_ON |
> +			  LPC32XX_USB_OTG_I2C_CLOCK_ON,
> +	.get_rate	= local_return_parent_rate,
> +};
> +
> +static struct clk clk_usb_otg_host = {
> +	.parent		= &clk_usbpll,
> +	.enable		= local_usb_otg_enable,
> +	.enable_reg	= LPC32XX_USB_OTG_CLK_CTRL,
> +	.enable_mask	= LPC32XX_USB_OTG_AHB_M_CLOCK_ON |
> +			  LPC32XX_USB_OTG_OTG_CLOCK_ON |
> +			  LPC32XX_USB_OTG_HOST_CLOCK_ON |
> +			  LPC32XX_USB_OTG_I2C_CLOCK_ON,
> +	.get_rate	= local_return_parent_rate,
> +};
> +
>  static int tsc_onoff_enable(struct clk *clk, int enable)
>  {
>  	u32 tmp;
> @@ -1130,6 +1198,9 @@ static struct clk_lookup lookups[] = {
>  	CLKDEV_INIT("31060000.ethernet", NULL, &clk_net),
>  	CLKDEV_INIT("dev:clcd", NULL, &clk_lcd),
>  	CLKDEV_INIT("31020000.usbd", "ck_usbd", &clk_usbd),
> +	CLKDEV_INIT("31020000.ohci", "ck_usbd", &clk_usbd),
> +	CLKDEV_INIT("31020000.usbd", "ck_usb_otg", &clk_usb_otg_dev),
> +	CLKDEV_INIT("31020000.ohci", "ck_usb_otg", &clk_usb_otg_host),
>  	CLKDEV_INIT("lpc32xx_rtc", NULL, &clk_rtc),
>  };
>  
> diff --git a/arch/arm/mach-lpc32xx/include/mach/platform.h b/arch/arm/mach-lpc32xx/include/mach/platform.h
> index c584f5b..acc4aab 100644
> --- a/arch/arm/mach-lpc32xx/include/mach/platform.h
> +++ b/arch/arm/mach-lpc32xx/include/mach/platform.h
> @@ -694,4 +694,18 @@
>  #define LPC32XX_GPIO_P2_MUX_CLR			_GPREG(0x02C)
>  #define LPC32XX_GPIO_P2_MUX_STATE		_GPREG(0x030)
>  
> +/*
> + * USB Otg Registers
> + */
> +#define _OTGREG(x)			io_p2v(LPC32XX_USB_OTG_BASE + (x))
> +#define LPC32XX_USB_OTG_CLK_CTRL	_OTGREG(0xFF4)
> +#define LPC32XX_USB_OTG_CLK_STAT	_OTGREG(0xFF8)
> +
> +/* USB OTG CLK CTRL bit defines */
> +#define LPC32XX_USB_OTG_AHB_M_CLOCK_ON	_BIT(4)
> +#define LPC32XX_USB_OTG_OTG_CLOCK_ON	_BIT(3)
> +#define LPC32XX_USB_OTG_I2C_CLOCK_ON	_BIT(2)
> +#define LPC32XX_USB_OTG_DEV_CLOCK_ON	_BIT(1)
> +#define LPC32XX_USB_OTG_HOST_CLOCK_ON	_BIT(0)
> +
>  #endif

