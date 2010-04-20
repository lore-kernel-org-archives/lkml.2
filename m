Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab0DTHHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 03:07:12 -0400
Received: from adelie.canonical.com ([91.189.90.139]:47040 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab0DTHHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 03:07:11 -0400
Date: Tue, 20 Apr 2010 10:07:06 +0300
From: Amit Kucheria <amit.kucheria@canonical.com>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux@arm.linux.org.uk, s.hauer@pengutronix.de,
       valentin.longchamp@epfl.ch, daniel@caiaq.de, grant.likely@secretlab.ca,
       bryan.wu@canonical.com, r.herring@freescale.com, Jun.Li@freescale.com,
       xiao-lizhang@freescale.com
Subject: Re: [PATCHv5 2.6.34-rc4 2/5] mx5: Add USB device definitions for
 Freescale MX51 Babbage HW
Message-ID: <20100420070706.GA2116@matterhorn.lan>
Mail-Followup-To: Dinh.Nguyen@freescale.com, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
	s.hauer@pengutronix.de, valentin.longchamp@epfl.ch, daniel@caiaq.de,
	grant.likely@secretlab.ca, bryan.wu@canonical.com,
	r.herring@freescale.com, Jun.Li@freescale.com,
	xiao-lizhang@freescale.com
References: <1271716024-22990-1-git-send-email-Dinh.Nguyen@freescale.com>
 <1271716024-22990-2-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1271716024-22990-2-git-send-email-Dinh.Nguyen@freescale.com>
X-URL: http://www.verdurent.com/
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dinh,

This patch fails to apply for me. Can you confirm?

Regards,
Amit

On 10 Apr 19, Dinh.Nguyen@freescale.com wrote:
> From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> 
> This patch is part of enabling USB for Freescale MX51 Babbage HW. This
> patch adds device structures for USB Host1 and OTG port, and adds
> clocking information for USB HW.
> 
> This patch applies to 2.6.34-rc4.
> 
> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> ---
>  arch/arm/mach-mx5/clock-mx51.c |    8 ++++++
>  arch/arm/mach-mx5/devices.c    |   49 ++++++++++++++++++++++++++++++++++++++++
>  arch/arm/mach-mx5/devices.h    |    2 +
>  3 files changed, 59 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-mx5/clock-mx51.c b/arch/arm/mach-mx5/clock-mx51.c
> index 1ee6ce4..1fe40e1 100644
> --- a/arch/arm/mach-mx5/clock-mx51.c
> +++ b/arch/arm/mach-mx5/clock-mx51.c
> @@ -762,6 +762,10 @@ DEFINE_CLOCK(gpt_clk, 0, MXC_CCM_CCGR2, MXC_CCM_CCGRx_CG9_OFFSET,
>  DEFINE_CLOCK(gpt_ipg_clk, 0, MXC_CCM_CCGR2, MXC_CCM_CCGRx_CG10_OFFSET,
>  	NULL,  NULL, &ipg_clk, NULL);
>  
> +/* USB */
> +DEFINE_CLOCK(usboh3_clk, 0, MXC_CCM_CCGR2, MXC_CCM_CCGRx_CG14_OFFSET,
> +	NULL, NULL, &pll3_sw_clk, NULL);
> +
>  /* FEC */
>  DEFINE_CLOCK(fec_clk, 0, MXC_CCM_CCGR2, MXC_CCM_CCGRx_CG12_OFFSET,
>  	NULL,  NULL, &ipg_clk, NULL);
> @@ -779,6 +783,10 @@ static struct clk_lookup lookups[] = {
>  	_REGISTER_CLOCK("imx-uart.2", NULL, uart3_clk)
>  	_REGISTER_CLOCK(NULL, "gpt", gpt_clk)
>  	_REGISTER_CLOCK("fec.0", NULL, fec_clk)
> +	_REGISTER_CLOCK("mxc-ehci.0", "usb", usboh3_clk)
> +	_REGISTER_CLOCK("mxc-ehci.0", "usb_ahb", ahb_clk)
> +	_REGISTER_CLOCK("mxc-ehci.1", "usb", usboh3_clk)
> +	_REGISTER_CLOCK("mxc-ehci.1", "usb_ahb", ahb_clk)
>  };
>  
>  static void clk_tree_init(void)
> diff --git a/arch/arm/mach-mx5/devices.c b/arch/arm/mach-mx5/devices.c
> index 5070ae1..4b456d5 100644
> --- a/arch/arm/mach-mx5/devices.c
> +++ b/arch/arm/mach-mx5/devices.c
> @@ -12,6 +12,7 @@
>  
>  #include <linux/platform_device.h>
>  #include <linux/gpio.h>
> +#include <linux/dma-mapping.h>
>  #include <mach/hardware.h>
>  #include <mach/imx-uart.h>
>  #include <mach/irqs.h>
> @@ -92,6 +93,54 @@ struct platform_device mxc_fec_device = {
>  	.resource = mxc_fec_resources,
>  };
>  
> +static u64 usb_dma_mask = DMA_BIT_MASK(32);
> +
> +static struct resource usbotg_resources[] = {
> +	{
> +		.start = MX51_OTG_BASE_ADDR,
> +		.end = MX51_OTG_BASE_ADDR + 0x1ff,
> +		.flags = IORESOURCE_MEM,
> +	},
> +	{
> +		.start = MX51_MXC_INT_USB_OTG,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +};
> +
> +struct platform_device mxc_usbdr_host_device = {
> +	.name = "mxc-ehci",
> +	.id = 0,
> +	.num_resources = ARRAY_SIZE(usbotg_resources),
> +	.resource = usbotg_resources,
> +	.dev = {
> +		.dma_mask = &usb_dma_mask,
> +		.coherent_dma_mask = DMA_BIT_MASK(32),
> +	},
> +};
> +
> +static struct resource usbh1_resources[] = {
> +	{
> +		.start = MX51_OTG_BASE_ADDR + 0x200,
> +		.end = MX51_OTG_BASE_ADDR + 0x200 + 0x1ff,
> +		.flags = IORESOURCE_MEM,
> +	},
> +	{
> +		.start = MX51_MXC_INT_USB_H1,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +};
> +
> +struct platform_device mxc_usbh1_device = {
> +	.name = "mxc-ehci",
> +	.id = 1,
> +	.num_resources = ARRAY_SIZE(usbh1_resources),
> +	.resource = usbh1_resources,
> +	.dev = {
> +		.dma_mask = &usb_dma_mask,
> +		.coherent_dma_mask = DMA_BIT_MASK(32),
> +	},
> +};
> +
>  static struct mxc_gpio_port mxc_gpio_ports[] = {
>  	{
>  		.chip.label = "gpio-0",
> diff --git a/arch/arm/mach-mx5/devices.h b/arch/arm/mach-mx5/devices.h
> index f339ab8..95c45f9 100644
> --- a/arch/arm/mach-mx5/devices.h
> +++ b/arch/arm/mach-mx5/devices.h
> @@ -2,3 +2,5 @@ extern struct platform_device mxc_uart_device0;
>  extern struct platform_device mxc_uart_device1;
>  extern struct platform_device mxc_uart_device2;
>  extern struct platform_device mxc_fec_device;
> +extern struct platform_device mxc_usbdr_host_device;
> +extern struct platform_device mxc_usbh1_device;
> -- 
> 1.6.0.4
> 

-- 
----------------------------------------------------------------------
Amit Kucheria, Kernel Engineer || amit.kucheria@canonical.com
----------------------------------------------------------------------
