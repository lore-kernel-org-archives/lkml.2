Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab2FTOB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 10:01:58 -0400
Received: from antcom.de ([188.40.178.216]:37108 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab2FTOB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 10:01:57 -0400
Message-ID: <4FE1D7D3.3080205@antcom.de>
Date: Wed, 20 Jun 2012 16:01:55 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: lpc32xx_udc: move clock init to clock framework
References: <1340193795-30805-1-git-send-email-aletes.xgr@gmail.com>
In-Reply-To: <1340193795-30805-1-git-send-email-aletes.xgr@gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2012 02:03 PM, Alexandre Pereira da Silva wrote:
> Moves clock initialization to the clock framework.
> 
> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

Acked-by: Roland Stigge <stigge@antcom.de>

> ---
>  drivers/usb/gadget/lpc32xx_udc.c |   84 +++++++++++---------------------------
>  1 file changed, 24 insertions(+), 60 deletions(-)
> 
> diff --git a/drivers/usb/gadget/lpc32xx_udc.c b/drivers/usb/gadget/lpc32xx_udc.c
> index 262acfd..d227d93 100644
> --- a/drivers/usb/gadget/lpc32xx_udc.c
> +++ b/drivers/usb/gadget/lpc32xx_udc.c
> @@ -164,6 +164,7 @@ struct lpc32xx_udc {
>  	int			udp_irq[4];
>  	struct clk		*usb_pll_clk;
>  	struct clk		*usb_slv_clk;
> +	struct clk		*usb_otg_clk;
>  
>  	/* DMA support */
>  	u32			*udca_v_base;
> @@ -226,33 +227,15 @@ static inline struct lpc32xx_udc *to_udc(struct usb_gadget *g)
>  #define UDCA_BUFF_SIZE (128)
>  
>  /* TODO: When the clock framework is introduced in LPC32xx, IO_ADDRESS will
> - * be replaced with an inremap()ed pointer, see USB_OTG_CLK_CTRL()
> + * be replaced with an inremap()ed pointer
>   * */
>  #define USB_CTRL		IO_ADDRESS(LPC32XX_CLK_PM_BASE + 0x64)
> -#define USB_CLOCK_MASK		(AHB_M_CLOCK_ON | OTG_CLOCK_ON | \
> -				 DEV_CLOCK_ON | I2C_CLOCK_ON)
>  
>  /* USB_CTRL bit defines */
>  #define USB_SLAVE_HCLK_EN	(1 << 24)
>  #define USB_HOST_NEED_CLK_EN	(1 << 21)
>  #define USB_DEV_NEED_CLK_EN	(1 << 22)
>  
> -#define USB_OTG_CLK_CTRL(udc)	((udc)->udp_baseaddr + 0xFF4)
> -#define USB_OTG_CLK_STAT(udc)	((udc)->udp_baseaddr + 0xFF8)
> -
> -/* USB_OTG_CLK_CTRL bit defines */
> -#define AHB_M_CLOCK_ON		(1 << 4)
> -#define OTG_CLOCK_ON		(1 << 3)
> -#define I2C_CLOCK_ON		(1 << 2)
> -#define DEV_CLOCK_ON		(1 << 1)
> -#define HOST_CLOCK_ON		(1 << 0)
> -
> -#define USB_OTG_STAT_CONTROL(udc) (udc->udp_baseaddr + 0x110)
> -
> -/* USB_OTG_STAT_CONTROL bit defines */
> -#define TRANSPARENT_I2C_EN	(1 << 7)
> -#define HOST_EN			(1 << 0)
> -
>  /**********************************************************************
>   * USB device controller register offsets
>   **********************************************************************/
> @@ -676,7 +659,7 @@ static void isp1301_udc_configure(struct lpc32xx_udc *udc)
>  		ISP1301_I2C_INTERRUPT_RISING, INT_VBUS_VLD);
>  
>  	/* Enable usb_need_clk clock after transceiver is initialized */
> -	writel((readl(USB_CTRL) | (1 << 22)), USB_CTRL);
> +	writel((readl(USB_CTRL) | USB_DEV_NEED_CLK_EN), USB_CTRL);
>  
>  	dev_info(udc->dev, "ISP1301 Vendor ID  : 0x%04x\n",
>  		 i2c_smbus_read_word_data(udc->isp1301_i2c_client, 0x00));
> @@ -1009,11 +992,8 @@ static void udc_dd_free(struct lpc32xx_udc *udc, struct lpc32xx_usbd_dd_gad *dd)
>  /* Enables or disables most of the USB system clocks when low power mode is
>   * needed. Clocks are typically started on a connection event, and disabled
>   * when a cable is disconnected */
> -#define OTGOFF_CLK_MASK (AHB_M_CLOCK_ON | I2C_CLOCK_ON)
>  static void udc_clk_set(struct lpc32xx_udc *udc, int enable)
>  {
> -	int to = 1000;
> -
>  	if (enable != 0) {
>  		if (udc->clocked)
>  			return;
> @@ -1027,14 +1007,7 @@ static void udc_clk_set(struct lpc32xx_udc *udc, int enable)
>  		writel(readl(USB_CTRL) | USB_DEV_NEED_CLK_EN,
>  			     USB_CTRL);
>  
> -		/* Set to enable all needed USB OTG clocks */
> -		writel(USB_CLOCK_MASK, USB_OTG_CLK_CTRL(udc));
> -
> -		while (((readl(USB_OTG_CLK_STAT(udc)) & USB_CLOCK_MASK) !=
> -			USB_CLOCK_MASK) && (to > 0))
> -			to--;
> -		if (!to)
> -			dev_dbg(udc->dev, "Cannot enable USB OTG clocking\n");
> +		clk_enable(udc->usb_otg_clk);
>  	} else {
>  		if (!udc->clocked)
>  			return;
> @@ -1046,19 +1019,11 @@ static void udc_clk_set(struct lpc32xx_udc *udc, int enable)
>  		/* 48MHz PLL dpwn */
>  		clk_disable(udc->usb_pll_clk);
>  
> -		/* Enable the USB device clock */
> +		/* Disable the USB device clock */
>  		writel(readl(USB_CTRL) & ~USB_DEV_NEED_CLK_EN,
>  			     USB_CTRL);
>  
> -		/* Set to enable all needed USB OTG clocks */
> -		writel(OTGOFF_CLK_MASK, USB_OTG_CLK_CTRL(udc));
> -
> -		while (((readl(USB_OTG_CLK_STAT(udc)) &
> -			 OTGOFF_CLK_MASK) !=
> -			OTGOFF_CLK_MASK) && (to > 0))
> -			to--;
> -		if (!to)
> -			dev_dbg(udc->dev, "Cannot disable USB OTG clocking\n");
> +		clk_disable(udc->usb_otg_clk);
>  	}
>  }
>  
> @@ -3238,6 +3203,12 @@ static int __init lpc32xx_udc_probe(struct platform_device *pdev)
>  		retval = PTR_ERR(udc->usb_slv_clk);
>  		goto usb_clk_get_fail;
>  	}
> +	udc->usb_otg_clk = clk_get(&pdev->dev, "ck_usb_otg");
> +	if (IS_ERR(udc->usb_otg_clk)) {
> +		dev_err(udc->dev, "failed to acquire USB otg clock\n");
> +		retval = PTR_ERR(udc->usb_slv_clk);
> +		goto usb_otg_clk_get_fail;
> +	}
>  
>  	/* Setup PLL clock to 48MHz */
>  	retval = clk_enable(udc->usb_pll_clk);
> @@ -3261,15 +3232,12 @@ static int __init lpc32xx_udc_probe(struct platform_device *pdev)
>  		goto usb_clk_enable_fail;
>  	}
>  
> -	/* Set to enable all needed USB OTG clocks */
> -	writel(USB_CLOCK_MASK, USB_OTG_CLK_CTRL(udc));
> -
> -	i = 1000;
> -	while (((readl(USB_OTG_CLK_STAT(udc)) & USB_CLOCK_MASK) !=
> -		USB_CLOCK_MASK) && (i > 0))
> -		i--;
> -	if (!i)
> -		dev_dbg(udc->dev, "USB OTG clocks not correctly enabled\n");
> +	/* Enable USB OTG clock */
> +	retval = clk_enable(udc->usb_otg_clk);
> +	if (retval < 0) {
> +		dev_err(udc->dev, "failed to start USB otg clock\n");
> +		goto usb_otg_clk_enable_fail;
> +	}
>  
>  	/* Setup deferred workqueue data */
>  	udc->poweron = udc->pullup = 0;
> @@ -3389,12 +3357,16 @@ dma_alloc_fail:
>  	dma_free_coherent(&pdev->dev, UDCA_BUFF_SIZE,
>  			  udc->udca_v_base, udc->udca_p_base);
>  i2c_fail:
> +	clk_disable(udc->usb_otg_clk);
> +usb_otg_clk_enable_fail:
>  	clk_disable(udc->usb_slv_clk);
>  usb_clk_enable_fail:
>  pll_set_fail:
>  	clk_disable(udc->usb_pll_clk);
>  pll_enable_fail:
>  	clk_put(udc->usb_slv_clk);
> +usb_otg_clk_get_fail:
> +	clk_put(udc->usb_otg_clk);
>  usb_clk_get_fail:
>  	clk_put(udc->usb_pll_clk);
>  pll_get_fail:
> @@ -3432,6 +3404,8 @@ static int __devexit lpc32xx_udc_remove(struct platform_device *pdev)
>  
>  	device_unregister(&udc->gadget.dev);
>  
> +	clk_disable(udc->usb_otg_clk);
> +	clk_put(udc->usb_otg_clk);
>  	clk_disable(udc->usb_slv_clk);
>  	clk_put(udc->usb_slv_clk);
>  	clk_disable(udc->usb_pll_clk);
> @@ -3445,7 +3419,6 @@ static int __devexit lpc32xx_udc_remove(struct platform_device *pdev)
>  #ifdef CONFIG_PM
>  static int lpc32xx_udc_suspend(struct platform_device *pdev, pm_message_t mesg)
>  {
> -	int to = 1000;
>  	struct lpc32xx_udc *udc = platform_get_drvdata(pdev);
>  
>  	if (udc->clocked) {
> @@ -3460,15 +3433,6 @@ static int lpc32xx_udc_suspend(struct platform_device *pdev, pm_message_t mesg)
>  		   on resume */
>  		udc->clocked = 1;
>  
> -		/* Kill OTG and I2C clocks */
> -		writel(0, USB_OTG_CLK_CTRL(udc));
> -		while (((readl(USB_OTG_CLK_STAT(udc)) & OTGOFF_CLK_MASK) !=
> -			OTGOFF_CLK_MASK) && (to > 0))
> -			to--;
> -		if (!to)
> -			dev_dbg(udc->dev,
> -				"USB OTG clocks not correctly enabled\n");
> -
>  		/* Kill global USB clock */
>  		clk_disable(udc->usb_slv_clk);
>  	}

