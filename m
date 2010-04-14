Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab0DNGU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 02:20:57 -0400
Received: from adelie.canonical.com ([91.189.90.139]:53740 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab0DNGUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 02:20:55 -0400
Message-ID: <4BC55EBE.1080407@canonical.com>
Date: Tue, 13 Apr 2010 23:20:46 -0700
From: Bryan Wu <bryan.wu@canonical.com>
Reply-To: bryan.wu@canonical.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100404 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dinh.Nguyen@freescale.com
CC: linux-kernel@vger.kernel.org, amit.kucheria@canonical.com,
       linux@arm.linux.org.uk, s.hauer@pengutronix.de,
       grant.likely@secretlab.ca, r.herring@freescale.com,
       linux-arm-kernel@lists.infradead.org, daniel@caiaq.de,
       valentin.longchamp@epfl.ch
Subject: Re: [PATCH 2.6.34-rc4 6/8] mx5: Add USB support for Freescale MX51
 Babbage
References: <1271175030-3635-1-git-send-email-Dinh.Nguyen@freescale.com>	<1271175030-3635-2-git-send-email-Dinh.Nguyen@freescale.com>	<1271175030-3635-3-git-send-email-Dinh.Nguyen@freescale.com>	<1271175030-3635-4-git-send-email-Dinh.Nguyen@freescale.com>	<1271175030-3635-5-git-send-email-Dinh.Nguyen@freescale.com> <1271175030-3635-6-git-send-email-Dinh.Nguyen@freescale.com>
In-Reply-To: <1271175030-3635-6-git-send-email-Dinh.Nguyen@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2010 09:10 AM, Dinh.Nguyen@freescale.com wrote:
> From: Dinh Nguyen<Dinh.Nguyen@freescale.com>
>
> This patch updates the clocks, gpios, iomuxing and device structures for
> enabling USB Host functionality on Freescale MX51 Babbage HW.
> This patch applies to 2.6.34-rc4.
>
> Signed-off-by: Dinh Nguyen<Dinh.Nguyen@freescale.com>
> ---
>   arch/arm/mach-mx5/board-mx51_babbage.c |   40 +++++++++++++++++++++++++-
>   arch/arm/mach-mx5/clock-mx51.c         |    8 +++++
>   arch/arm/mach-mx5/devices.c            |   49 ++++++++++++++++++++++++++++++++
>   arch/arm/mach-mx5/devices.h            |    2 +
>   4 files changed, 98 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/mach-mx5/board-mx51_babbage.c b/arch/arm/mach-mx5/board-mx51_babbage.c
> index 1338d6a..ddfa48b 100644
> --- a/arch/arm/mach-mx5/board-mx51_babbage.c
> +++ b/arch/arm/mach-mx5/board-mx51_babbage.c
> @@ -13,6 +13,7 @@
>   #include<linux/init.h>
>   #include<linux/platform_device.h>
>   #include<linux/gpio.h>
> +#include<linux/delay.h>
>
>   #include<mach/common.h>
>   #include<mach/hardware.h>
> @@ -30,6 +31,8 @@
>   extern void __init mx5_usb_dr_init(void);
>   extern void __init mx5_usbh1_init(void);
>
> +#define GPIO_1_7  (0*32+7)
> +

As this GPIO used below, it is better to name it just as
#define GPIO_USB_RESET	7	/* GPIO_1_7 */

>   static struct platform_device *devices[] __initdata = {
>   	&mxc_fec_device,
>   };
> @@ -50,6 +53,22 @@ static struct pad_desc mx51babbage_pads[] = {
>   	MX51_PAD_EIM_D26__UART3_TXD,
>   	MX51_PAD_EIM_D27__UART3_RTS,
>   	MX51_PAD_EIM_D24__UART3_CTS,
> +
> +	/* USB HOST1 */
> +	MX51_PAD_GPIO_1_25__USBH1_CLK,
> +	MX51_PAD_GPIO_1_26__USBH1_DIR,
> +	MX51_PAD_GPIO_1_28__USBH1_NXT,
> +	MX51_PAD_GPIO_1_11__USBH1_DATA0,
> +	MX51_PAD_GPIO_1_12__USBH1_DATA1,
> +	MX51_PAD_GPIO_1_13__USBH1_DATA2,
> +	MX51_PAD_GPIO_1_14__USBH1_DATA3,
> +	MX51_PAD_GPIO_1_15__USBH1_DATA4,
> +	MX51_PAD_GPIO_1_16__USBH1_DATA5,
> +	MX51_PAD_GPIO_1_17__USBH1_DATA6,
> +	MX51_PAD_GPIO_1_18__USBH1_DATA7,
> +
> +	/* USB HUB reset line*/
> +	MX51_PAD_GPIO_1_7__GPIO1_7

How about "MX51_PAD_GPIO_1_7__GPIO_USB_RESET",
,
>   };
>
>   /* Serial ports */
> @@ -64,12 +83,31 @@ static inline void mxc_init_imx_uart(void)
>   	mxc_register_device(&mxc_uart_device1,&uart_pdata);
>   	mxc_register_device(&mxc_uart_device2,&uart_pdata);
>   }
> -#else /* !SERIAL_IMX */
> +#else /* SERIAL_IMX */
>   static inline void mxc_init_imx_uart(void)
>   {
>   }
>   #endif /* SERIAL_IMX */
>
> +static inline void mx5_babbage_usbhub_reset(void)
> +{
> +	int ret;
> +
> +	/* Bring USB hub out of reset */
> +	ret = gpio_request(GPIO_1_7, "GPIO1_7");
> +	if (ret) {
> +		printk("failed to get GPIO_1_7: %d\n", ret);
> +		return;
> +	}
> +	gpio_direction_output(GPIO_1_7, 0);
> +
> +	/* USB HUB RESET - De-assert USB HUB RESET_N */
> +	msleep(1);
> +	gpio_set_value(GPIO_1_7, 0);
> +	msleep(1);
> +	gpio_set_value(GPIO_1_7, 1);
> +}
> +

%s/GPIO_1_7/GPIO_USB_RESET/g

>   /*
>    * Board specific initialization.
>    */
> diff --git a/arch/arm/mach-mx5/clock-mx51.c b/arch/arm/mach-mx5/clock-mx51.c
> index 8f85f73..36684d0 100644
> --- a/arch/arm/mach-mx5/clock-mx51.c
> +++ b/arch/arm/mach-mx5/clock-mx51.c
> @@ -765,6 +765,10 @@ DEFINE_CLOCK(gpt_ipg_clk, 0, MXC_CCM_CCGR2, MXC_CCM_CCGRx_CG10_OFFSET,
>   DEFINE_CLOCK(fec_clk, 0, MXC_CCM_CCGR2, MXC_CCM_CCGRx_CG12_OFFSET,
>   	NULL,  NULL,&ipg_clk, NULL);
>
> +/* USB */
> +DEFINE_CLOCK(usboh3_clk, 0, MXC_CCM_CCGR2, MXC_CCM_CCGRx_CG14_OFFSET,
> +	NULL,  NULL,&pll3_sw_clk, NULL);
> +

It should be
+	NULL, NULL, &pll3_sw_clk, NULL);

I'm a little bit picky here, but please use scripts/checkpatch.pl to fix this 
coding style issue.

>   #define _REGISTER_CLOCK(d, n, c) \
>          { \
>   		.dev_id = d, \
> @@ -778,6 +782,10 @@ static struct clk_lookup lookups[] = {
>   	_REGISTER_CLOCK("imx-uart.2", NULL, uart3_clk)
>   	_REGISTER_CLOCK(NULL, "gpt", gpt_clk)
>   	_REGISTER_CLOCK("fec.0", NULL, fec_clk)
> +	_REGISTER_CLOCK("mxc-ehci.0", "usb", usboh3_clk)
> +	_REGISTER_CLOCK("mxc-ehci.0", "usb_ahb", ahb_clk)
> +	_REGISTER_CLOCK("mxc-ehci.1", "usb", usboh3_clk)
> +	_REGISTER_CLOCK("mxc-ehci.1", "usb_ahb", ahb_clk)
>   };
>
>   static void clk_tree_init(void)
> diff --git a/arch/arm/mach-mx5/devices.c b/arch/arm/mach-mx5/devices.c
> index 73f2342..3d8f66a 100644
> --- a/arch/arm/mach-mx5/devices.c
> +++ b/arch/arm/mach-mx5/devices.c
> @@ -11,6 +11,7 @@
>    */
>
>   #include<linux/platform_device.h>
> +#include<linux/dma-mapping.h>
>   #include<mach/hardware.h>
>   #include<mach/gpio.h>
>   #include<mach/imx-uart.h>
> @@ -92,6 +93,54 @@ struct platform_device mxc_fec_device = {
>   	.resource = mxc_fec_resources,
>   };
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
> +		.dma_mask =&usb_dma_mask,
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
> +		.dma_mask =&usb_dma_mask,


+		.dma_mask = &usb_dma_mask,


> +		.coherent_dma_mask = DMA_BIT_MASK(32),
> +	},
> +};
> +
>   struct mxc_gpio_port mxc_gpio_ports[] = {
>   	{
>   		.chip.label = "gpio-0",
> diff --git a/arch/arm/mach-mx5/devices.h b/arch/arm/mach-mx5/devices.h
> index f339ab8..95c45f9 100644
> --- a/arch/arm/mach-mx5/devices.h
> +++ b/arch/arm/mach-mx5/devices.h
> @@ -2,3 +2,5 @@ extern struct platform_device mxc_uart_device0;
>   extern struct platform_device mxc_uart_device1;
>   extern struct platform_device mxc_uart_device2;
>   extern struct platform_device mxc_fec_device;
> +extern struct platform_device mxc_usbdr_host_device;
> +extern struct platform_device mxc_usbh1_device;


-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.138-1617-6545 Mobile
Ubuntu Kernel Team | Hardware Enablement Team
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
