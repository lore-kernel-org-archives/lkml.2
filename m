Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609Ab0JTIz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 04:55:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47062 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab0JTIzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 04:55:20 -0400
Date: Wed, 20 Oct 2010 10:55:17 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, amit.kucheria@canonical.com,
        linux@arm.linux.org.uk, s.hauer@pengutronix.de,
        grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org,
        daniel@caiaq.de, xiao-lizhang@freescale.com,
        valentin.longchamp@epfl.ch
Subject: Re: [PATCHv3 1/2] ARM: imx: Add gpio-keys to mx51 babbage board
Message-ID: <20101020085517.GG28166@pengutronix.de>
References: <1287513592-6655-1-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1287513592-6655-1-git-send-email-Dinh.Nguyen@freescale.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 01:39:51PM -0500, Dinh.Nguyen@freescale.com wrote:
> From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> 
> Add functionality for the power button on MX51 Babbage board.
> 
> This patch is based on Sascha Hauer's imx/linux-2.6 for-rmk tree.
> 
> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> ---
>  arch/arm/configs/mx51_defconfig             |    1 +
>  arch/arm/mach-mx5/board-mx51_babbage.c      |   35 +++++++++++++++++++++++++++
>  arch/arm/plat-mxc/include/mach/iomux-mx51.h |    2 +-
>  3 files changed, 37 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/configs/mx51_defconfig b/arch/arm/configs/mx51_defconfig
> index 163cfee..5c7a872 100644
> --- a/arch/arm/configs/mx51_defconfig
> +++ b/arch/arm/configs/mx51_defconfig
> @@ -82,6 +82,7 @@ CONFIG_FEC=y
>  CONFIG_INPUT_FF_MEMLESS=m
>  # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
>  CONFIG_INPUT_EVDEV=y
> +CONFIG_KEYBOARD_GPIO=y
>  CONFIG_INPUT_EVBUG=m
>  CONFIG_MOUSE_PS2=m
>  CONFIG_MOUSE_PS2_ELANTECH=y
> diff --git a/arch/arm/mach-mx5/board-mx51_babbage.c b/arch/arm/mach-mx5/board-mx51_babbage.c
> index 23ee4a4..20e9d13 100644
> --- a/arch/arm/mach-mx5/board-mx51_babbage.c
> +++ b/arch/arm/mach-mx5/board-mx51_babbage.c
> @@ -18,6 +18,8 @@
>  #include <linux/io.h>
>  #include <linux/fsl_devices.h>
>  #include <linux/fec.h>
> +#include <linux/gpio_keys.h>
> +#include <linux/input.h>
>  
>  #include <mach/common.h>
>  #include <mach/hardware.h>
> @@ -37,6 +39,7 @@
>  #define BABBAGE_USBH1_STP	(0*32 + 27)	/* GPIO_1_27 */
>  #define BABBAGE_PHY_RESET	(1*32 + 5)	/* GPIO_2_5 */
>  #define BABBAGE_FEC_PHY_RESET	(1*32 + 14)	/* GPIO_2_14 */
> +#define BABBAGE_POWER_KEY	(1*32 + 21)	/* GPIO_2_21 */
>  
>  /* USB_CTRL_1 */
>  #define MX51_USB_CTRL_1_OFFSET			0x10
> @@ -46,6 +49,34 @@
>  #define	MX51_USB_PLL_DIV_19_2_MHZ	0x01
>  #define	MX51_USB_PLL_DIV_24_MHZ	0x02
>  
> +static struct gpio_keys_button babbage_buttons[] = {
> +	{
> +		.gpio		= BABBAGE_POWER_KEY,
> +		.code		= BTN_0,
> +		.desc		= "PWR",
> +		.active_low	= 1,
> +		.wakeup		= 1,
> +	},
> +};
> +
> +static struct gpio_keys_platform_data babbage_button_data = {
> +	.buttons	= babbage_buttons,
> +	.nbuttons	= ARRAY_SIZE(babbage_buttons),
> +};
> +
> +static struct platform_device babbage_button_device = {
> +	.name		= "gpio-keys",
> +	.id		= -1,
> +	.num_resources	= 0,
> +	.dev		= {
> +		.platform_data	= &babbage_button_data,
> +	}
> +};
> +
> +static struct platform_device *platform_devices[] __initdata = {
> +	&babbage_button_device,
> +};
> +
>  static struct pad_desc mx51babbage_pads[] = {
>  	/* UART1 */
>  	MX51_PAD_UART1_RXD__UART1_RXD,
> @@ -112,6 +143,9 @@ static struct pad_desc mx51babbage_pads[] = {
>  
>  	/* FEC PHY reset line */
>  	MX51_PAD_EIM_A20__GPIO_2_14,
> +
> +	/* Power Key */
> +	MX51_PAD_EIM_A27__GPIO_2_21,
>  };
>  
>  /* Serial ports */
> @@ -285,6 +319,7 @@ static void __init mxc_board_init(void)
>  	mxc_iomux_v3_setup_multiple_pads(mx51babbage_pads,
>  					ARRAY_SIZE(mx51babbage_pads));
>  	mxc_init_imx_uart();
> +	platform_add_devices(platform_devices, ARRAY_SIZE(platform_devices));
would you mind to rework that to a function à la imx_add_fec?

>  	babbage_fec_reset();
>  	imx51_add_fec(NULL);
>  
> diff --git a/arch/arm/plat-mxc/include/mach/iomux-mx51.h b/arch/arm/plat-mxc/include/mach/iomux-mx51.h
> index e46b1c2..2699262 100644
> --- a/arch/arm/plat-mxc/include/mach/iomux-mx51.h
> +++ b/arch/arm/plat-mxc/include/mach/iomux-mx51.h
> @@ -114,7 +114,7 @@ typedef enum iomux_config {
>  #define MX51_PAD_EIM_A24__GPIO_2_18             IOMUX_PAD(0x450, 0x0bc, 1, 0x0,   0, NO_PAD_CTRL)
>  #define MX51_PAD_EIM_A25__GPIO_2_19             IOMUX_PAD(0x454, 0x0c0, 1, 0x0,   0, NO_PAD_CTRL)
>  #define MX51_PAD_EIM_A26__GPIO_2_20             IOMUX_PAD(0x458, 0x0c4, 1, 0x0,   0, NO_PAD_CTRL)
> -#define MX51_PAD_EIM_A27__GPIO_2_21             IOMUX_PAD(0x45c, 0x0c8, 1, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_EIM_A27__GPIO_2_21             IOMUX_PAD(0x45c, 0x0c8, 1, 0x0,   0, MX51_I2C_PAD_CTRL)
MX51_I2C_PAD_CTRL looks wrong here.  IIRC I already asked about this.

>  #define MX51_PAD_EIM_EB0__EIM_EB0               IOMUX_PAD(0x460, 0x0cc, 0, 0x0,   0, NO_PAD_CTRL)
>  #define MX51_PAD_EIM_EB1__EIM_EB1               IOMUX_PAD(0x464, 0x0d0, 0, 0x0,   0, NO_PAD_CTRL)
>  #define MX51_PAD_EIM_EB2__GPIO_2_22             IOMUX_PAD(0x468, 0x0d4, 1, 0x0,   0, NO_PAD_CTRL)
> -- 
> 1.6.0.4
> 
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
