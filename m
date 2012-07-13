Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab2GMJLk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 05:11:40 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55220 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172Ab2GMJLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 05:11:36 -0400
MIME-Version: 1.0
In-Reply-To: <1342097668-25243-4-git-send-email-thomas.abraham@linaro.org>
References: <1342097668-25243-1-git-send-email-thomas.abraham@linaro.org>
	<1342097668-25243-4-git-send-email-thomas.abraham@linaro.org>
Date: Fri, 13 Jul 2012 14:41:35 +0530
Message-ID: <CAGxe1ZGMvrec-nEYdZJ84Hub0fByYvnkCY_dRq2k489gCRSxQg@mail.gmail.com>
Subject: Re: [PATCH v3 3/6] mmc: dw_mmc: lookup for optional biu and ciu clocks
From: Girish K S <girish.shivananjappa@linaro.org>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-mmc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 July 2012 18:24, Thomas Abraham <thomas.abraham@linaro.org> wrote:
> Some platforms allow for clock gating and control of bus interface unit clock
> and card interface unit clock. Add support for clock lookup of optional biu
> and ciu clocks for clock gating and clock speed determination.
>
> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> ---
>  drivers/mmc/host/dw_mmc.c  |   42 +++++++++++++++++++++++++++++++++++++++---
>  include/linux/mmc/dw_mmc.h |    4 ++++
>  2 files changed, 43 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index cd58063..679473c 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -1953,18 +1953,38 @@ int dw_mci_probe(struct dw_mci *host)
>                 return -ENODEV;
>         }
>
> -       if (!host->pdata->bus_hz) {
> +       host->biu_clk = clk_get(host->dev, "biu");
> +       if (IS_ERR(host->biu_clk))
> +               dev_dbg(host->dev, "biu clock not available\n");
> +       else
> +               clk_prepare_enable(host->biu_clk);
> +
> +       host->ciu_clk = clk_get(host->dev, "ciu");
> +       if (IS_ERR(host->ciu_clk))
> +               dev_dbg(host->dev, "ciu clock not available\n");
> +       else
> +               clk_prepare_enable(host->ciu_clk);
> +
> +       if (IS_ERR(host->ciu_clk))
> +               host->bus_hz = host->pdata->bus_hz;
> +       else
> +               host->bus_hz = clk_get_rate(host->ciu_clk);
> +
> +       if (!host->bus_hz) {
>                 dev_err(host->dev,
>                         "Platform data must supply bus speed\n");
> -               return -ENODEV;
> +               ret = -ENODEV;
> +               goto err_clk;
>         }
>
> -       host->bus_hz = host->pdata->bus_hz;
>         host->quirks = host->pdata->quirks;
>
>         spin_lock_init(&host->lock);
>         INIT_LIST_HEAD(&host->queue);
>
> +       host->dma_ops = host->pdata->dma_ops;
> +       dw_mci_init_dma(host);
This initialization is already done.
> +
>         /*
>          * Get the host data width - this assumes that HCON has been set with
>          * the correct values.
> @@ -2109,6 +2129,16 @@ err_dmaunmap:
>                 regulator_disable(host->vmmc);
>                 regulator_put(host->vmmc);
>         }
> +
> +err_clk:
> +       if (!IS_ERR(host->ciu_clk)) {
> +               clk_disable_unprepare(host->ciu_clk);
> +               clk_put(host->ciu_clk);
> +       }
> +       if (!IS_ERR(host->biu_clk)) {
> +               clk_disable_unprepare(host->biu_clk);
> +               clk_put(host->biu_clk);
> +       }
>         return ret;
>  }
>  EXPORT_SYMBOL(dw_mci_probe);
> @@ -2142,6 +2172,12 @@ void dw_mci_remove(struct dw_mci *host)
>                 regulator_put(host->vmmc);
>         }
>
> +       if (!IS_ERR(host->ciu_clk))
> +               clk_disable_unprepare(host->ciu_clk);
> +       if (!IS_ERR(host->biu_clk))
> +               clk_disable_unprepare(host->biu_clk);
> +       clk_put(host->ciu_clk);
> +       clk_put(host->biu_clk);
>  }
>  EXPORT_SYMBOL(dw_mci_remove);
>
> diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
> index a37a573..787ad56 100644
> --- a/include/linux/mmc/dw_mmc.h
> +++ b/include/linux/mmc/dw_mmc.h
> @@ -78,6 +78,8 @@ struct mmc_data;
>   * @data_offset: Set the offset of DATA register according to VERID.
>   * @dev: Device associated with the MMC controller.
>   * @pdata: Platform data associated with the MMC controller.
> + * @biu_clk: Pointer to bus interface unit clock instance.
> + * @ciu_clk: Pointer to card interface unit clock instance.
>   * @slot: Slots sharing this MMC controller.
>   * @fifo_depth: depth of FIFO.
>   * @data_shift: log2 of FIFO item size.
> @@ -158,6 +160,8 @@ struct dw_mci {
>         u16                     data_offset;
>         struct device           *dev;
>         struct dw_mci_board     *pdata;
> +       struct clk              *biu_clk;
> +       struct clk              *ciu_clk;
>         struct dw_mci_slot      *slot[MAX_MCI_SLOTS];
>
>         /* FIFO push and pull */
> --
> 1.6.6.rc2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
