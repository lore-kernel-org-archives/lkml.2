Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab2HUEmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 00:42:37 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62811 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab2HUEmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 00:42:35 -0400
MIME-Version: 1.0
In-Reply-To: <50310F10.2080701@yahoo.es>
References: <502BC31E.4070200@yahoo.es>
	<502BDD0E.4030106@yahoo.es>
	<502CA8FC.7090705@atmel.com>
	<502CB89B.4070302@yahoo.es>
	<502CC326.8020605@atmel.com>
	<502CC6A0.3050603@atmel.com>
	<502F52E7.9050804@yahoo.es>
	<CACiLriS-GZg24TJqJGQ=P04n-Zk3FdHtGgh5VeqGcCMHG6TnMw@mail.gmail.com>
	<50310F10.2080701@yahoo.es>
Date: Tue, 21 Aug 2012 10:12:34 +0530
X-Google-Sender-Auth: _J4edGDGtwO-3TI27pSxh1tzjrE
Message-ID: <CAOh2x=kOxninn=o1i2-HE1is-G8vfi1ER_JjUQY=N0wTYwAotw@mail.gmail.com>
Subject: Re: [PATCH] Fixes for dw_dmac and atmel-mci for AP700x
From: viresh kumar <viresh.kumar@linaro.org>
To: Hein Tibosch <hein_tibosch@yahoo.es>
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hein,

I have added linux-kernel list in cc as there might be other users of
this patch.
Also, please try to keep spear-devel list in cc for dw_dmac as we are using this
driver for SPEAr.

On Sun, Aug 19, 2012 at 9:36 PM, Hein Tibosch <hein_tibosch@yahoo.es> wrote:
> Hi Hans-Christian,
>
> Do you know to which list I could send the patch(es) below?
>
> Viresh Kumar: did you have an urgent reason to replace __raw_readl
> and __raw_writel with readl/writel in the dw_dmac module?
> (see http://lists.infradead.org/pipermail/linux-arm-kernel/2011-March/044799.html)
>
> Here's a draft:
>
> Because of the changes since 2.6.38 to dw_dmac.c and atmel-mci.c,
> the MCI driver on the AP700x platforms didn't work anymore using DMA.
> The PIO method still worked well.
>
> I found several problems. The patch below makes it work again.
> It was tested on an atngw100 board.
>
> atmel-mci:
> - The AP700x has an MCI controller with version 0x210
>   Therefor it was supposed to work the PDC (peripheral DMA
>   controller). However, in this CPU the PDC is not connected
>   to the MCI.
> - When using DMA, the driver was accessing a register ATMCI_DMA
>   at offset 0x50, which is undefined for the AP700x. But it
>   probably doesn't hurt either...
>
> dw_dmac:
> - After 2.6.39, the registers were accessed using readl/writel
>   in stead of the __raw_readl and __raw_writel causing a 16-bit
>   swap of all values (little endian access)

Ahhhh!! Firstly we can't use __raw* for architectures >= ARMv6. It is not
only for endianess but for memory barriers. Why are they getting swapped
for your case? Does your processor and dw_dmac have different endianess?

And if i am not wrong, we should always try not to use __raw* variants just
due to endianess things... instead use either readl/writel OR
readl_/writel_ relaxed.
I am not sure if relaxed versions are available for architectures
other than ARM.

> - Access to memory was sometimes done in chunks of 64-bits,
>   which gives an undefined value of 0x03 for SRC/DST_TR_WIDTH
>   field in the CTLxL register

Looks fine. But there should be a separate patch for this.

> - The SMS field in the CTLxL register received the wrong value:
>   0 in stead of 1

I believe it is not for dw_dmac?

--
viresh

> Signed-off-by: Hein Tibosch <hein_tibosch@yahoo.es>
> ---
>  arch/avr32/mach-at32ap/at32ap700x.c |    6 ++++++
>  drivers/dma/dw_dmac.c               |    8 ++++++++
>  drivers/dma/dw_dmac_regs.h          |    8 ++++----
>  drivers/mmc/host/atmel-mci.c        |   19 ++++++++++++++++---
>  4 files changed, 34 insertions(+), 7 deletions(-)
>
> diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
> index 0445c4f..06b6eff 100644
> --- a/arch/avr32/mach-at32ap/at32ap700x.c
> +++ b/arch/avr32/mach-at32ap/at32ap700x.c
> @@ -1355,6 +1355,12 @@ at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
>                                 | DWC_CFGH_DST_PER(1));
>         slave->sdata.cfg_lo &= ~(DWC_CFGL_HS_DST_POL
>                                 | DWC_CFGL_HS_SRC_POL);
> +       /* value for SMS: Source Master Select */
> +       slave->sdata.src_master = 1;
> +       /* value for DMS: Destination Master Select */
> +       slave->sdata.dst_master = 0;
> +       /* SRC/DST_TR_WIDTH register only accepts 0,1,2 */
> +       slave->sdata.max_mem_width = 2;
>         data->dma_slave = slave;
>  diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 7212961..a4bdf1d 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -754,6 +754,10 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
>                                 mem_width = 1;
>                         else
>                                 mem_width = 0;
> +                       /* Some controllers don't support 64-bits mem access */
> +                       if (dws->max_mem_width &&
> +                               mem_width > dws->max_mem_width)
> +                               mem_width = dws->max_mem_width;
>   slave_sg_todev_fill_desc:
>                         desc = dwc_desc_get(dwc);
> @@ -821,6 +825,10 @@ slave_sg_todev_fill_desc:
>                                 mem_width = 1;
>                         else
>                                 mem_width = 0;
> +                       /* Some controllers don't support 64-bits mem access */
> +                       if (dws->max_mem_width &&
> +                               mem_width > dws->max_mem_width)
> +                               mem_width = dws->max_mem_width;
>   slave_sg_fromdev_fill_desc:
>                         desc = dwc_desc_get(dwc);
> diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
> index f298f69..b380d5f 100644
> --- a/drivers/dma/dw_dmac_regs.h
> +++ b/drivers/dma/dw_dmac_regs.h
> @@ -176,9 +176,9 @@ __dwc_regs(struct dw_dma_chan *dwc)
>  }
>   #define channel_readl(dwc, name) \
> -       readl(&(__dwc_regs(dwc)->name))
> +       __raw_readl(&(__dwc_regs(dwc)->name))
>  #define channel_writel(dwc, name, val) \
> -       writel((val), &(__dwc_regs(dwc)->name))
> +       __raw_writel((val), &(__dwc_regs(dwc)->name))
>   static inline struct dw_dma_chan *to_dw_dma_chan(struct dma_chan *chan)
>  {
> @@ -202,9 +202,9 @@ static inline struct dw_dma_regs __iomem *__dw_regs(struct dw_dma *dw)
>  }
>   #define dma_readl(dw, name) \
> -       readl(&(__dw_regs(dw)->name))
> +       __raw_readl(&(__dw_regs(dw)->name))
>  #define dma_writel(dw, name, val) \
> -       writel((val), &(__dw_regs(dw)->name))
> +       __raw_writel((val), &(__dw_regs(dw)->name))
>   #define channel_set_bit(dw, reg, mask) \
>         dma_writel(dw, reg, ((mask) << 8) | (mask))
> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
> index f2c115e..b78a674 100644
> --- a/drivers/mmc/host/atmel-mci.c
> +++ b/drivers/mmc/host/atmel-mci.c
> @@ -75,6 +75,7 @@ struct atmel_mci_caps {
>         bool    has_pdc;
>         bool    has_cfg_reg;
>         bool    has_cstor_reg;
> +       bool    has_dma_reg;
>         bool    has_highspeed;
>         bool    has_rwproof;
>         bool    has_odd_clk_div;
> @@ -411,7 +412,7 @@ static int atmci_regs_show(struct seq_file *s, void *v)
>         atmci_show_status_reg(s, "SR", buf[ATMCI_SR / 4]);
>         atmci_show_status_reg(s, "IMR", buf[ATMCI_IMR / 4]);
>  -      if (host->caps.has_dma) {
> +       if (host->caps.has_dma_reg) {
>                 u32 val;
>                 val = buf[ATMCI_DMA / 4];
> @@ -767,7 +768,7 @@ static void atmci_dma_complete(void *arg)
>         dev_vdbg(&host->pdev->dev, "DMA complete\n");
>  -      if (host->caps.has_dma)
> +       if (host->caps.has_dma_reg)
>                 /* Disable DMA hardware handshaking on MCI */
>                 atmci_writel(host, ATMCI_DMA, atmci_readl(host, ATMCI_DMA) & ~ATMCI_DMAEN);
>  @@ -954,7 +955,9 @@ atmci_prepare_data_dma(struct atmel_mci *host, struct mmc_data *data)
>                 maxburst = atmci_convert_chksize(host->dma_conf.dst_maxburst);
>         }
>  -      atmci_writel(host, ATMCI_DMA, ATMCI_DMA_CHKSIZE(maxburst) | ATMCI_DMAEN);
> +       if (host->caps.has_dma_reg)
> +               atmci_writel(host, ATMCI_DMA,
> +                       ATMCI_DMA_CHKSIZE(maxburst) | ATMCI_DMAEN);
>         sglen = dma_map_sg(chan->device->dev, data->sg,
>                         data->sg_len, direction);
> @@ -2203,7 +2206,11 @@ static void __init atmci_get_cap(struct atmel_mci *host)
>                         "version: 0x%x\n", version);
>         host->caps.has_dma = 0;
> +#if defined(CONFIG_CPU_AT32AP700X)
> +       host->caps.has_pdc = 0;
> +#else
>         host->caps.has_pdc = 1;
> +#endif
>         host->caps.has_cfg_reg = 0;
>         host->caps.has_cstor_reg = 0;
>         host->caps.has_highspeed = 0;
> @@ -2221,6 +2228,7 @@ static void __init atmci_get_cap(struct atmel_mci *host)
>         case 0x300:
>  #ifdef CONFIG_AT_HDMAC
>                 host->caps.has_dma = 1;
> +               host->caps.has_dma_reg = 1;
>  #else
>                 dev_info(&host->pdev->dev,
>                         "has dma capability but dma engine is not selected, then use pio\n");
> @@ -2230,6 +2238,11 @@ static void __init atmci_get_cap(struct atmel_mci *host)
>                 host->caps.has_cstor_reg = 1;
>                 host->caps.has_highspeed = 1;
>         case 0x200:
> +#if defined(CONFIG_DW_DMAC) && defined(CONFIG_MMC_ATMELMCI_DMA)
> +               host->caps.has_dma = 1;
> +               dev_info(&host->pdev->dev,
> +                       "using dma (AP7000)\n");
> +#endif
>                 host->caps.has_rwproof = 1;
>                 host->caps.need_blksz_mul_4 = 0;
>         case 0x100:
> --
> 1.7.8.0
>
>
