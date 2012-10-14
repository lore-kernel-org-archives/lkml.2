Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab2JNUIc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 16:08:32 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:59349 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab2JNUIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 16:08:31 -0400
MIME-Version: 1.0
In-Reply-To: <507A6FA5.1000800@yahoo.es>
References: <507A6FA5.1000800@yahoo.es>
Date: Sun, 14 Oct 2012 23:08:30 +0300
Message-ID: <CAHp75VdaqzoJPwJpQ9U1kpR-egveajeM71FLAxveWHz7gB+6Eg@mail.gmail.com>
Subject: Re: [PATCH REGRESSION FIX] dw_dmac: make driver's endianness configurable
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Hein Tibosch <hein_tibosch@yahoo.es>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        viresh kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2012 at 10:54 AM, Hein Tibosch <hein_tibosch@yahoo.es> wrote:
> From: Hein Tibosch <hein_tibosch@yahoo.es>
>
> The dw_dmac was originally developed for avr32 to be used with the Synopsys
> DesignWare AHB DMA controller. Starting from 2.6.38, access to the device's i/o
> memory was done with the little-endian readl/writel functions(1)
>
> This broke the driver for the avr32 platform, because it needs big (native)
> endian accessors.
> This patch makes the endianness configurable using 'DW_DMAC_BIG_ENDIAN_IO',
> which will default be true for AVR32
>
> I submitted this patch before(2) but then waited for Andy to finish other
> changes to the same module(3).
>
> (1) https://patchwork.kernel.org/patch/608211
> (2) https://lkml.org/lkml/2012/8/26/148
> (3) https://lkml.org/lkml/2012/9/21/173
>
> Signed-off-by: Hein Tibosch <hein_tibosch@yahoo.es>
>
> ---
>  drivers/dma/Kconfig        |   11 +++++++++++
>  drivers/dma/dw_dmac_regs.h |   18 +++++++++++++-----
>  2 files changed, 24 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index 677cd6e..d4c1218 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -90,6 +90,17 @@ config DW_DMAC
>           Support the Synopsys DesignWare AHB DMA controller.  This
>           can be integrated in chips such as the Atmel AT32ap7000.
>
> +config DW_DMAC_BIG_ENDIAN_IO
> +       bool "Use big endian I/O register access"
> +       default y if AVR32
> +       depends on DW_DMAC
> +       help
> +         Say yes here to use big endian I/O access when reading and writing
> +         to the DMA controller registers. This is needed on some platforms,
> +         like the Atmel AVR32 architecture.
> +
> +         If unsure, use the default setting.
> +
>  config AT_HDMAC
>         tristate "Atmel AHB DMA support"
>         depends on ARCH_AT91
> diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
> index ff39fa6..8896559 100644
> --- a/drivers/dma/dw_dmac_regs.h
> +++ b/drivers/dma/dw_dmac_regs.h
> @@ -98,9 +98,17 @@ struct dw_dma_regs {
>         u32     DW_PARAMS;
>  };
>
> +#ifdef CONFIG_DW_DMAC_BIG_ENDIAN_IO
> +#define dma_readl_native ioread32be
> +#define dma_writel_native iowrite32be
> +#else
> +#define dma_readl_native readl
> +#define dma_writel_native writel
> +#endif
> +
>  /* To access the registers in early stage of probe */
>  #define dma_read_byaddr(addr, name) \
> -       readl((addr) + offsetof(struct dw_dma_regs, name))
> +       dma_readl_native((addr) + offsetof(struct dw_dma_regs, name))
>
>  /* Bitfields in DW_PARAMS */
>  #define DW_PARAMS_NR_CHAN      8               /* number of channels */
> @@ -216,9 +224,9 @@ __dwc_regs(struct dw_dma_chan *dwc)
>  }
>
>  #define channel_readl(dwc, name) \
> -       readl(&(__dwc_regs(dwc)->name))
> +       dma_readl_native(&(__dwc_regs(dwc)->name))
>  #define channel_writel(dwc, name, val) \
> -       writel((val), &(__dwc_regs(dwc)->name))
> +       dma_writel_native((val), &(__dwc_regs(dwc)->name))
>
>  static inline struct dw_dma_chan *to_dw_dma_chan(struct dma_chan *chan)
>  {
> @@ -246,9 +254,9 @@ static inline struct dw_dma_regs __iomem *__dw_regs(struct dw_dma *dw)
>  }
>
>  #define dma_readl(dw, name) \
> -       readl(&(__dw_regs(dw)->name))
> +       dma_readl_native(&(__dw_regs(dw)->name))
>  #define dma_writel(dw, name, val) \
> -       writel((val), &(__dw_regs(dw)->name))
> +       dma_writel_native((val), &(__dw_regs(dw)->name))
>
>  #define channel_set_bit(dw, reg, mask) \
>         dma_writel(dw, reg, ((mask) << 8) | (mask))
Why did you not change this one?


-- 
With Best Regards,
Andy Shevchenko
