Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab2KWL2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 06:28:32 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35410 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab2KWL2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 06:28:30 -0500
MIME-Version: 1.0
In-Reply-To: <1353600769-28693-1-git-send-email-fabio.estevam@freescale.com>
References: <1353600769-28693-1-git-send-email-fabio.estevam@freescale.com>
Date: Fri, 23 Nov 2012 12:28:28 +0100
Message-ID: <CACKLOr296rVjv3ECL_WyV2eS7OHEKFzBomz=i-6dJWOvJQ9pkQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] ARM: imx27_visstrim_m10: Do not reserve DMA pools
 on board file
From: javier Martin <javier.martin@vista-silicon.com>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: kernel@pengutronix.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabio,
have you actually tested CMA with mx2_camera and coda drivers in i.MX27?


On 22 November 2012 17:12, Fabio Estevam <fabio.estevam@freescale.com> wrote:
> Do not reserve DMA pools on board file as this can be done via CMA.
>
> The motivation for doing this is to allow to register the VPU driver via a common
> SoC file instead of per board.
>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
> This applies against 20121115 linux-next.
>
> Changes since v3:
> - Remove all the DMA pools
> Changes since v2:
> - No changes. Newly introduced on this series
>  arch/arm/mach-imx/mach-imx27_visstrim_m10.c |   66 ++-------------------------
>  1 file changed, 3 insertions(+), 63 deletions(-)
>
> diff --git a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
> index b744226..914b2f8 100644
> --- a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
> +++ b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
> @@ -30,7 +30,6 @@
>  #include <linux/input.h>
>  #include <linux/gpio.h>
>  #include <linux/delay.h>
> -#include <linux/dma-mapping.h>
>  #include <linux/leds.h>
>  #include <linux/platform_data/asoc-mx27vis.h>
>  #include <media/soc_camera.h>
> @@ -39,7 +38,6 @@
>  #include <asm/mach/arch.h>
>  #include <asm/mach/time.h>
>  #include <asm/system_info.h>
> -#include <asm/memblock.h>
>
>  #include "common.h"
>  #include "devices-imx27.h"
> @@ -234,14 +232,8 @@ static struct mx2_camera_platform_data visstrim_camera = {
>         .clk = 100000,
>  };
>
> -static phys_addr_t mx2_camera_base __initdata;
> -#define MX2_CAMERA_BUF_SIZE SZ_8M
> -
>  static void __init visstrim_camera_init(void)
>  {
> -       struct platform_device *pdev;
> -       int dma;
> -
>         gpio_set_value(TVP5150_PWDN, 1);
>         ndelay(1);
>         gpio_set_value(TVP5150_RSTN, 0);
> @@ -249,23 +241,7 @@ static void __init visstrim_camera_init(void)
>         gpio_set_value(TVP5150_RSTN, 1);
>         ndelay(200000);
>
> -       pdev = imx27_add_mx2_camera(&visstrim_camera);
> -       if (IS_ERR(pdev))
> -               return;
> -
> -       dma = dma_declare_coherent_memory(&pdev->dev,
> -                               mx2_camera_base, mx2_camera_base,
> -                               MX2_CAMERA_BUF_SIZE,
> -                               DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE);
> -       if (!(dma & DMA_MEMORY_MAP))
> -               return;
> -}
> -
> -static void __init visstrim_reserve(void)
> -{
> -       /* reserve 4 MiB for mx2-camera */
> -       mx2_camera_base = arm_memblock_steal(3 * MX2_CAMERA_BUF_SIZE,
> -                       MX2_CAMERA_BUF_SIZE);
> +       imx27_add_mx2_camera(&visstrim_camera);
>  }
>
>  /* GPIOs used as events for applications */
> @@ -434,47 +410,12 @@ static const struct imx_ssi_platform_data visstrim_m10_ssi_pdata __initconst = {
>         .flags                  = IMX_SSI_DMA | IMX_SSI_SYN,
>  };
>
> -/* coda */
> -
> -static void __init visstrim_coda_init(void)
> -{
> -       struct platform_device *pdev;
> -       int dma;
> -
> -       pdev = imx27_add_coda();
> -       dma = dma_declare_coherent_memory(&pdev->dev,
> -                                         mx2_camera_base + MX2_CAMERA_BUF_SIZE,
> -                                         mx2_camera_base + MX2_CAMERA_BUF_SIZE,
> -                                         MX2_CAMERA_BUF_SIZE,
> -                                         DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE);
> -       if (!(dma & DMA_MEMORY_MAP))
> -               return;
> -}
> -
>  /* DMA deinterlace */
>  static struct platform_device visstrim_deinterlace = {
>         .name = "m2m-deinterlace",
>         .id = 0,
>  };
>
> -static void __init visstrim_deinterlace_init(void)
> -{
> -       int ret = -ENOMEM;
> -       struct platform_device *pdev = &visstrim_deinterlace;
> -       int dma;
> -
> -       ret = platform_device_register(pdev);
> -
> -       dma = dma_declare_coherent_memory(&pdev->dev,
> -                                         mx2_camera_base + 2 * MX2_CAMERA_BUF_SIZE,
> -                                         mx2_camera_base + 2 * MX2_CAMERA_BUF_SIZE,
> -                                         MX2_CAMERA_BUF_SIZE,
> -                                         DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE);
> -       if (!(dma & DMA_MEMORY_MAP))
> -               return;
> -}
> -
> -
>  /* Audio */
>  static const struct snd_mx27vis_platform_data snd_mx27vis_pdata __initconst = {
>         .amp_gain0_gpio = AMP_GAIN_0,
> @@ -546,9 +487,9 @@ static void __init visstrim_m10_board_init(void)
>         platform_device_register_resndata(NULL, "soc-camera-pdrv", 0, NULL, 0,
>                                       &iclink_tvp5150, sizeof(iclink_tvp5150));
>         gpio_led_register_device(0, &visstrim_m10_led_data);
> -       visstrim_deinterlace_init();
> +       platform_device_register(&visstrim_deinterlace);
>         visstrim_camera_init();
> -       visstrim_coda_init();
> +       imx27_add_coda();
>  }
>
>  static void __init visstrim_m10_timer_init(void)
> @@ -562,7 +503,6 @@ static struct sys_timer visstrim_m10_timer = {
>
>  MACHINE_START(IMX27_VISSTRIM_M10, "Vista Silicon Visstrim_M10")
>         .atag_offset = 0x100,
> -       .reserve = visstrim_reserve,
>         .map_io = mx27_map_io,
>         .init_early = imx27_init_early,
>         .init_irq = mx27_init_irq,
> --
> 1.7.9.5
>
>



-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
