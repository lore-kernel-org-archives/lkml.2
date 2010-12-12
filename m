Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab0LLBmx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 20:42:53 -0500
Received: from mail-iw0-f170.google.com ([209.85.214.170]:35469 "EHLO
	mail-iw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab0LLBmv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 20:42:51 -0500
X-Greylist: delayed 311 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Dec 2010 20:42:50 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wwLxrvGLc5/iApH7pu1yjBuK89rN4LulcIG2mFsfI8q9mgsqb9vc/lk+Bp3wexsKDs
         Q79BF6yCyDrl1hz0su2z9yGLYsos383MCbcRRg45O1BIChbpvbcQK9hGWKqtGHnRrSXb
         3AA0JtlF2xhWXNB1QnvgLncBwyflz3X0ZPsFo=
MIME-Version: 1.0
In-Reply-To: <1291902441-24712-10-git-send-email-s.hauer@pengutronix.de>
References: <1291902441-24712-1-git-send-email-s.hauer@pengutronix.de>
	<1291902441-24712-10-git-send-email-s.hauer@pengutronix.de>
Date: Sun, 12 Dec 2010 09:37:38 +0800
Message-ID: <AANLkTi=vT8pX1QQ6DjzQatceO-tQb3Zu90CRAVi2DcpZ@mail.gmail.com>
Subject: Re: [PATCH 9/9] ARM i.MX51 babbage: Add framebuffer support
From: Liu Ying <liu.y.victor@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, Zhang Lily-R58066 <r58066@freescale.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Sascha,

I have following 3 comments to this patch:
1) I think DISP1_DATx pins need not be set specially, as they keep the
default register values.
2) Please define 'MX51_PAD_DI_GP4__IPU_DI2_PIN15' in
arch/arm/plat-mxc/include/mach/iomux-mx51.h, and rename the pin to be
'MX51_PAD_DI_GP4__DI2_PIN15', as we name it according to the MX51
iomux reference manual.
3) It is better to exchange the following two lines or just remove the
first line:
+       gpio_set_value(GPIO_DVI_RESET, 0);
+       gpio_direction_output(GPIO_DVI_RESET, 0);

Best Regards,
Liu Ying

2010/12/9 Sascha Hauer <s.hauer@pengutronix.de>:
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  arch/arm/mach-mx5/Kconfig              |    1 +
>  arch/arm/mach-mx5/board-mx51_babbage.c |   74 ++++++++++++++++++++++++++++++++
>  2 files changed, 75 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-mx5/Kconfig b/arch/arm/mach-mx5/Kconfig
> index 5011f42..2a936b7 100644
> --- a/arch/arm/mach-mx5/Kconfig
> +++ b/arch/arm/mach-mx5/Kconfig
> @@ -22,6 +22,7 @@ config MACH_MX51_BABBAGE
>        select IMX_HAVE_PLATFORM_IMX_UART
>        select IMX_HAVE_PLATFORM_SDHCI_ESDHC_IMX
>        select IMX_HAVE_PLATFORM_SPI_IMX
> +       select IMX_HAVE_PLATFORM_IMX_IPUV3
>        help
>          Include support for MX51 Babbage platform, also known as MX51EVK in
>          u-boot. This includes specific configurations for the board and its
> diff --git a/arch/arm/mach-mx5/board-mx51_babbage.c b/arch/arm/mach-mx5/board-mx51_babbage.c
> index a896f84..169c48c 100644
> --- a/arch/arm/mach-mx5/board-mx51_babbage.c
> +++ b/arch/arm/mach-mx5/board-mx51_babbage.c
> @@ -22,11 +22,13 @@
>  #include <linux/input.h>
>  #include <linux/spi/flash.h>
>  #include <linux/spi/spi.h>
> +#include <linux/mfd/imx-ipu-v3.h>
>
>  #include <mach/common.h>
>  #include <mach/hardware.h>
>  #include <mach/iomux-mx51.h>
>  #include <mach/mxc_ehci.h>
> +#include <mach/ipu-v3.h>
>
>  #include <asm/irq.h>
>  #include <asm/setup.h>
> @@ -158,6 +160,41 @@ static iomux_v3_cfg_t mx51babbage_pads[] = {
>        MX51_PAD_CSPI1_SCLK__ECSPI1_SCLK,
>        MX51_PAD_CSPI1_SS0__GPIO_4_24,
>        MX51_PAD_CSPI1_SS1__GPIO_4_25,
> +
> +       /* Display */
> +       MX51_PAD_DISPB2_SER_DIN__GPIO_3_5,
> +       MX51_PAD_DISPB2_SER_DIO__GPIO_3_6,
> +       MX51_PAD_NANDF_D12__GPIO_3_28,
> +
> +       MX51_PAD_DISP1_DAT0__DISP1_DAT0,
> +       MX51_PAD_DISP1_DAT1__DISP1_DAT1,
> +       MX51_PAD_DISP1_DAT2__DISP1_DAT2,
> +       MX51_PAD_DISP1_DAT3__DISP1_DAT3,
> +       MX51_PAD_DISP1_DAT4__DISP1_DAT4,
> +       MX51_PAD_DISP1_DAT5__DISP1_DAT5,
> +       MX51_PAD_DISP1_DAT6__DISP1_DAT6,
> +       MX51_PAD_DISP1_DAT7__DISP1_DAT7,
> +       MX51_PAD_DISP1_DAT8__DISP1_DAT8,
> +       MX51_PAD_DISP1_DAT9__DISP1_DAT9,
> +       MX51_PAD_DISP1_DAT10__DISP1_DAT10,
> +       MX51_PAD_DISP1_DAT11__DISP1_DAT11,
> +       MX51_PAD_DISP1_DAT12__DISP1_DAT12,
> +       MX51_PAD_DISP1_DAT13__DISP1_DAT13,
> +       MX51_PAD_DISP1_DAT14__DISP1_DAT14,
> +       MX51_PAD_DISP1_DAT15__DISP1_DAT15,
> +       MX51_PAD_DISP1_DAT16__DISP1_DAT16,
> +       MX51_PAD_DISP1_DAT17__DISP1_DAT17,
> +       MX51_PAD_DISP1_DAT18__DISP1_DAT18,
> +       MX51_PAD_DISP1_DAT19__DISP1_DAT19,
> +       MX51_PAD_DISP1_DAT20__DISP1_DAT20,
> +       MX51_PAD_DISP1_DAT21__DISP1_DAT21,
> +       MX51_PAD_DISP1_DAT22__DISP1_DAT22,
> +       MX51_PAD_DISP1_DAT23__DISP1_DAT23,
> +#define MX51_PAD_DI_GP4__IPU_DI2_PIN15                 IOMUX_PAD(0x758, 0x350, 4, 0x0,   0, NO_PAD_CTRL)
> +       MX51_PAD_DI_GP4__IPU_DI2_PIN15,
> +
> +       /* I2C DVI enable */
> +       MX51_PAD_CSI2_HSYNC__GPIO_4_14,
>  };
>
>  /* Serial ports */
> @@ -342,6 +379,21 @@ static const struct spi_imx_master mx51_babbage_spi_pdata __initconst = {
>        .num_chipselect = ARRAY_SIZE(mx51_babbage_spi_cs),
>  };
>
> +static struct ipuv3_fb_platform_data babbage_fb0_data = {
> +       .interface_pix_fmt = IPU_PIX_FMT_RGB24,
> +       .flags = IMX_IPU_FB_USE_MODEDB | IMX_IPU_FB_USE_OVERLAY,
> +};
> +
> +static struct ipuv3_fb_platform_data babbage_fb1_data = {
> +       .interface_pix_fmt = IPU_PIX_FMT_RGB565,
> +       .flags = IMX_IPU_FB_USE_MODEDB,
> +};
> +
> +static struct imx_ipuv3_platform_data ipu_data = {
> +       .fb0_platform_data = &babbage_fb0_data,
> +       .fb1_platform_data = &babbage_fb1_data,
> +};
> +
>  /*
>  * Board specific initialization.
>  */
> @@ -388,6 +440,28 @@ static void __init mxc_board_init(void)
>                ARRAY_SIZE(mx51_babbage_spi_board_info));
>        imx51_add_ecspi(0, &mx51_babbage_spi_pdata);
>        imx51_add_imx2_wdt(0, NULL);
> +
> +#define GPIO_DVI_DETECT        (2 * 32 + 28)
> +#define GPIO_DVI_RESET (2 * 32 + 5)
> +#define GPIO_DVI_PWRDN (2 * 32 + 6)
> +#define GPIO_DVI_I2C   (3 * 32 + 14)
> +
> +       /* DVI Detect */
> +       gpio_request(GPIO_DVI_DETECT, "dvi detect");
> +       gpio_direction_input(GPIO_DVI_DETECT);
> +       /* DVI Reset - Assert for i2c disabled mode */
> +       gpio_request(GPIO_DVI_RESET, "dvi reset");
> +       gpio_set_value(GPIO_DVI_RESET, 0);
> +       gpio_direction_output(GPIO_DVI_RESET, 0);
> +       /* DVI Power-down */
> +       gpio_request(GPIO_DVI_PWRDN, "dvi pwdn");
> +       gpio_direction_output(GPIO_DVI_PWRDN, 0);
> +       gpio_set_value(GPIO_DVI_PWRDN, 1);
> +
> +       gpio_request(GPIO_DVI_I2C, "dvi i2c");
> +       gpio_direction_output(GPIO_DVI_I2C, 0);
> +
> +       imx51_add_ipuv3(&ipu_data);
>  }
>
>  static void __init mx51_babbage_timer_init(void)
> --
> 1.7.2.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
