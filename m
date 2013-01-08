Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab3AHD2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 22:28:08 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:43127 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab3AHD2H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 22:28:07 -0500
MIME-Version: 1.0
In-Reply-To: <1357555480-24022-2-git-send-email-mika.westerberg@linux.intel.com>
References: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com>
 <1357555480-24022-2-git-send-email-mika.westerberg@linux.intel.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Tue, 8 Jan 2013 11:27:45 +0800
Message-ID: <CAMPhdO9j_-zZUAfZ-u_tdB6C6iSzTVRtN9_at4Obe9wgTA8p4g@mail.gmail.com>
Subject: Re: [PATCH 01/11] spi/pxa2xx: allow building on a 64-bit kernel
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, chao.bi@intel.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 7, 2013 at 6:44 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> In addition fix following warnings seen when compiling 64-bit:
>
> drivers/spi/spi-pxa2xx.c: In function ‘map_dma_buffers’: drivers/spi/spi-pxa2xx.c:384:7: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
> drivers/spi/spi-pxa2xx.c:384:40: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
> drivers/spi/spi-pxa2xx.c: In function ‘pxa2xx_spi_probe’:
> drivers/spi/spi-pxa2xx.c:1572:34: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
> drivers/spi/spi-pxa2xx.c:1572:34: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
> drivers/spi/spi-pxa2xx.c:1572:34: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
> drivers/spi/spi-pxa2xx.c:1572:27: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>  drivers/spi/Kconfig      |    4 ++--
>  drivers/spi/spi-pxa2xx.c |    5 ++---
>  2 files changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
> index 2e188e1..a90393d 100644
> --- a/drivers/spi/Kconfig
> +++ b/drivers/spi/Kconfig
> @@ -299,7 +299,7 @@ config SPI_PPC4xx
>
>  config SPI_PXA2XX
>         tristate "PXA2xx SSP SPI master"
> -       depends on (ARCH_PXA || (X86_32 && PCI)) && EXPERIMENTAL
> +       depends on ARCH_PXA || PCI
>         select PXA_SSP if ARCH_PXA
>         help
>           This enables using a PXA2xx or Sodaville SSP port as a SPI master
> @@ -307,7 +307,7 @@ config SPI_PXA2XX
>           additional documentation can be found a Documentation/spi/pxa2xx.
>
>  config SPI_PXA2XX_PCI
> -       def_bool SPI_PXA2XX && X86_32 && PCI
> +       def_tristate SPI_PXA2XX && PCI
>

Generally looks good to me, I think we could split the changes to

* Kconfig (adding 64-bit support or removing restrictions of X86_32
for the driver)
* and to spi-pxa2xx.c (mostly to handle the alignment warnings)

>  config SPI_RSPI
>         tristate "Renesas RSPI controller"
> diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
> index 5c8c4f5..7fac65d 100644
> --- a/drivers/spi/spi-pxa2xx.c
> +++ b/drivers/spi/spi-pxa2xx.c
> @@ -47,7 +47,7 @@ MODULE_ALIAS("platform:pxa2xx-spi");
>
>  #define DMA_INT_MASK           (DCSR_ENDINTR | DCSR_STARTINTR | DCSR_BUSERR)
>  #define RESET_DMA_CHANNEL      (DCSR_NODESC | DMA_INT_MASK)
> -#define IS_DMA_ALIGNED(x)      ((((u32)(x)) & 0x07) == 0)
> +#define IS_DMA_ALIGNED(x)      IS_ALIGNED((unsigned long)x, DMA_ALIGNMENT)

OK.

>  #define MAX_DMA_LEN            8191
>  #define DMA_ALIGNMENT          8
>
> @@ -1569,8 +1569,7 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
>         master->transfer = transfer;
>
>         drv_data->ssp_type = ssp->type;
> -       drv_data->null_dma_buf = (u32 *)ALIGN((u32)(drv_data +
> -                                               sizeof(struct driver_data)), 8);
> +       drv_data->null_dma_buf = (u32 *)PTR_ALIGN(drv_data + 1, 8);

Hmm... the original code seems to have big problem and interestingly no
one has reported the issue, possibly due to null_dma_buf being seldomly
used.

However, it's still a bit obscure to have 'drv_data + 1', 'drv_data[1]' might
be a bit better for readability.

And it'll be better to have DMA_ALIGNTMENT here instead of a hard-coded
constant '8'.
    u

>
>         drv_data->ioaddr = ssp->mmio_base;
>         drv_data->ssdr_physical = ssp->phys_base + SSDR;
> --
> 1.7.10.4
>
