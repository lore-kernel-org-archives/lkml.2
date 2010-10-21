Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab0JUTKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 15:10:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40334 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab0JUTKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 15:10:21 -0400
Date: Thu, 21 Oct 2010 21:10:18 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, s.hauer@pengutronix.de,
        valentin.longchamp@epfl.ch, daniel@caiaq.de, grant.likely@secretlab.ca,
        bryan.wu@canonical.com, amit.kucheria@canonical.com,
        xiao-lizhang@freescale.com
Subject: Re: [PATCHv4 1/2] ARM: imx: Add gpio-keys to mx51 babbage board
Message-ID: <20101021191018.GX19834@pengutronix.de>
References: <1287687324-6101-1-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1287687324-6101-1-git-send-email-Dinh.Nguyen@freescale.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 01:55:23PM -0500, Dinh.Nguyen@freescale.com wrote:
> From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> 
> Add functionality for the power button on MX51 Babbage board.
> 
> This patch is based on Sascha Hauer's imx/linux-2.6 for-rmk tree.
> 
> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> ---
>  arch/arm/configs/mx51_defconfig                 |    1 +
>  arch/arm/mach-mx5/board-mx51_babbage.c          |   22 +++++++++++++++++
>  arch/arm/mach-mx5/devices-imx51.h               |    2 +
>  arch/arm/plat-mxc/devices/Kconfig               |    5 ++++
>  arch/arm/plat-mxc/devices/Makefile              |    1 +
>  arch/arm/plat-mxc/devices/platform-buttons.c    |   29 +++++++++++++++++++++++
>  arch/arm/plat-mxc/include/mach/devices-common.h |    4 +++
>  arch/arm/plat-mxc/include/mach/iomux-mx51.h     |    2 +-
>  8 files changed, 65 insertions(+), 1 deletions(-)
>  create mode 100644 arch/arm/plat-mxc/devices/platform-buttons.c
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
> index 23ee4a4..f6ce0d6 100644
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
> @@ -46,6 +49,21 @@
>  #define	MX51_USB_PLL_DIV_19_2_MHZ	0x01
>  #define	MX51_USB_PLL_DIV_24_MHZ	0x02
>  
> +static struct gpio_keys_button babbage_buttons[] = {
const?  (Maybe gpio_keys_platform_data has to be changed for that.)
> +	{
> +		.gpio		= BABBAGE_POWER_KEY,
> +		.code		= BTN_0,
> +		.desc		= "PWR",
> +		.active_low	= 1,
> +		.wakeup		= 1,
> +	},
> +};
> +
> +static struct gpio_keys_platform_data imx_button_data = {
const and __initconst please

> +	.buttons	= babbage_buttons,
> +	.nbuttons	= ARRAY_SIZE(babbage_buttons),
> +};
> +
>  static struct pad_desc mx51babbage_pads[] = {
>  	/* UART1 */
>  	MX51_PAD_UART1_RXD__UART1_RXD,
> @@ -112,6 +130,9 @@ static struct pad_desc mx51babbage_pads[] = {
>  
>  	/* FEC PHY reset line */
>  	MX51_PAD_EIM_A20__GPIO_2_14,
> +
> +	/* Power Key */
> +	MX51_PAD_EIM_A27__GPIO_2_21,
>  };
>  
>  /* Serial ports */
> @@ -287,6 +308,7 @@ static void __init mxc_board_init(void)
>  	mxc_init_imx_uart();
>  	babbage_fec_reset();
>  	imx51_add_fec(NULL);
> +	imx51_add_buttons(&imx_button_data);
>  
>  	imx51_add_imx_i2c(0, &babbage_i2c_data);
>  	imx51_add_imx_i2c(1, &babbage_i2c_data);
> diff --git a/arch/arm/mach-mx5/devices-imx51.h b/arch/arm/mach-mx5/devices-imx51.h
> index 5cc910e..a114d65 100644
> --- a/arch/arm/mach-mx5/devices-imx51.h
> +++ b/arch/arm/mach-mx5/devices-imx51.h
> @@ -9,6 +9,8 @@
>  #include <mach/mx51.h>
>  #include <mach/devices-common.h>
>  
> +#define imx51_add_buttons(pdata) imx_add_buttons(pdata)
> +
>  extern const struct imx_fec_data imx51_fec_data __initconst;
>  #define imx51_add_fec(pdata)	\
>  	imx_add_fec(&imx51_fec_data, pdata)
> diff --git a/arch/arm/plat-mxc/devices/Kconfig b/arch/arm/plat-mxc/devices/Kconfig
> index 4047994..dbd688b 100644
> --- a/arch/arm/plat-mxc/devices/Kconfig
> +++ b/arch/arm/plat-mxc/devices/Kconfig
> @@ -23,3 +23,8 @@ config IMX_HAVE_PLATFORM_MXC_NAND
>  
>  config IMX_HAVE_PLATFORM_SPI_IMX
>  	bool
> +
> +config IMX_HAVE_PLATFORM_GPIO_BUTTONS
> +	bool
> +	default y if ARCH_MX51
> +
> diff --git a/arch/arm/plat-mxc/devices/Makefile b/arch/arm/plat-mxc/devices/Makefile
> index 0a3c1f0..41008be 100644
> --- a/arch/arm/plat-mxc/devices/Makefile
> +++ b/arch/arm/plat-mxc/devices/Makefile
> @@ -7,3 +7,4 @@ obj-$(CONFIG_IMX_HAVE_PLATFORM_IMX_SSI) += platform-imx-ssi.o
>  obj-$(CONFIG_IMX_HAVE_PLATFORM_IMX_UART) += platform-imx-uart.o
>  obj-$(CONFIG_IMX_HAVE_PLATFORM_MXC_NAND) += platform-mxc_nand.o
>  obj-$(CONFIG_IMX_HAVE_PLATFORM_SPI_IMX) +=  platform-spi_imx.o
> +obj-$(CONFIG_IMX_HAVE_PLATFORM_GPIO_BUTTONS) += platform-buttons.o
> \ No newline at end of file
This file is supposed to be ordered alphabetically and to have a newline
at the end of file.

> diff --git a/arch/arm/plat-mxc/devices/platform-buttons.c b/arch/arm/plat-mxc/devices/platform-buttons.c
> new file mode 100644
> index 0000000..23ceed8
> --- /dev/null
> +++ b/arch/arm/plat-mxc/devices/platform-buttons.c
> @@ -0,0 +1,29 @@
> +/*
> + * Copyright (C) 2010 Freescale Semiconductor, Inc. All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor,
> + * Boston, MA  02110-1301, USA.
> + */
> +#include <asm/sizes.h>
> +#include <mach/hardware.h>
> +#include <mach/devices-common.h>
> +
> +struct platform_device *__init imx_add_buttons(
I'd like to have that function named imx_add_gpio_keys to match the
device name (as good as possible).

> +		const struct gpio_keys_platform_data *pdata)
> +{
> +
> +	return imx_add_platform_device("gpio-keys", -1, NULL,
> +		NULL, pdata, sizeof(*pdata));
> +
> +}
> diff --git a/arch/arm/plat-mxc/include/mach/devices-common.h b/arch/arm/plat-mxc/include/mach/devices-common.h
> index 86d7575..0b37d6d 100644
> --- a/arch/arm/plat-mxc/include/mach/devices-common.h
> +++ b/arch/arm/plat-mxc/include/mach/devices-common.h
> @@ -14,6 +14,10 @@ struct platform_device *imx_add_platform_device(const char *name, int id,
>  		const struct resource *res, unsigned int num_resources,
>  		const void *data, size_t size_data);
>  
> +#include <linux/gpio_keys.h>
> +struct platform_device *__init imx_add_buttons(
> +		const struct gpio_keys_platform_data *pdata);
> +
>  #include <linux/fec.h>
>  struct imx_fec_data {
>  	resource_size_t iobase;
> diff --git a/arch/arm/plat-mxc/include/mach/iomux-mx51.h b/arch/arm/plat-mxc/include/mach/iomux-mx51.h
> index e46b1c2..7ae27e8 100644
> --- a/arch/arm/plat-mxc/include/mach/iomux-mx51.h
> +++ b/arch/arm/plat-mxc/include/mach/iomux-mx51.h
> @@ -114,7 +114,7 @@ typedef enum iomux_config {
>  #define MX51_PAD_EIM_A24__GPIO_2_18             IOMUX_PAD(0x450, 0x0bc, 1, 0x0,   0, NO_PAD_CTRL)
>  #define MX51_PAD_EIM_A25__GPIO_2_19             IOMUX_PAD(0x454, 0x0c0, 1, 0x0,   0, NO_PAD_CTRL)
>  #define MX51_PAD_EIM_A26__GPIO_2_20             IOMUX_PAD(0x458, 0x0c4, 1, 0x0,   0, NO_PAD_CTRL)
> -#define MX51_PAD_EIM_A27__GPIO_2_21             IOMUX_PAD(0x45c, 0x0c8, 1, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_EIM_A27__GPIO_2_21             IOMUX_PAD(0x45c, 0x0c8, 1, 0x0,   0, MX51_GPIO_PAD_CTRL | PAD_CTL_PUS_100K_UP)
Is this a generic change valid for all mx51 machines or only for the
babbage board?

>  #define MX51_PAD_EIM_EB0__EIM_EB0               IOMUX_PAD(0x460, 0x0cc, 0, 0x0,   0, NO_PAD_CTRL)
>  #define MX51_PAD_EIM_EB1__EIM_EB1               IOMUX_PAD(0x464, 0x0d0, 0, 0x0,   0, NO_PAD_CTRL)
>  #define MX51_PAD_EIM_EB2__GPIO_2_22             IOMUX_PAD(0x468, 0x0d4, 1, 0x0,   0, NO_PAD_CTRL)
> -- 
> 1.6.0.4

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
