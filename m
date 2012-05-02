Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab2EBJR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 05:17:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38134 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab2EBJR1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 05:17:27 -0400
MIME-Version: 1.0
In-Reply-To: <1335935266-25289-2-git-send-email-thomas.abraham@linaro.org>
References: <1335935266-25289-1-git-send-email-thomas.abraham@linaro.org>
	<1335935266-25289-2-git-send-email-thomas.abraham@linaro.org>
Date: Wed, 2 May 2012 10:17:26 +0100
Message-ID: <CAFbHwiTZOOP1HwZQPPKBei3aGhbBjFyJ4QLJ+Ea465L6r6vEYg@mail.gmail.com>
Subject: Re: [PATCH 1/7] mmc: dw_mmc: lookup for optional biu and ciu clocks
From: Will Newton <will.newton@gmail.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-mmc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 2, 2012 at 6:07 AM, Thomas Abraham
<thomas.abraham@linaro.org> wrote:
> Some platforms allow for clock gating and control of bus interface unit clock
> and card interface unit clock. Add support for clock lookup of optional biu
> and ciu clocks for clock gating and clock speed determination.
>
> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> ---
>  drivers/mmc/host/dw_mmc.c  |   35 +++++++++++++++++++++++++++++++----
>  include/linux/mmc/dw_mmc.h |    4 ++++
>  2 files changed, 35 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 1532357..036846f 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -1938,19 +1938,35 @@ int dw_mci_probe(struct dw_mci *host)
>                return -ENODEV;
>        }
>
> -       if (!host->pdata->bus_hz) {
> +       host->biu_clk = clk_get(&host->dev, "biu");
> +       if (IS_ERR(host->biu_clk))
> +               dev_info(&host->dev, "biu clock not available\n");
> +       else
> +               clk_enable(host->biu_clk);
> +
> +       host->ciu_clk = clk_get(&host->dev, "ciu");
> +       if (IS_ERR(host->ciu_clk))
> +               dev_info(&host->dev, "ciu clock not available\n");

Should these printks be at debug level? I'm not 100% sure either way
but it could be a little noisy on systems that do not use these
clocks.

> +       else
> +               clk_enable(host->ciu_clk);
> +
> +       if (IS_ERR(host->ciu_clk))
> +               host->bus_hz = host->pdata->bus_hz;
> +       else
> +               host->bus_hz = clk_get_rate(host->ciu_clk);
> +
> +       if (!host->bus_hz) {
>                dev_err(&host->dev,
>                        "Platform data must supply bus speed\n");
> -               return -ENODEV;
> +               ret = -ENODEV;
> +               goto err_clk;
>        }
>
> -       host->bus_hz = host->pdata->bus_hz;
>        host->quirks = host->pdata->quirks;
>
>        spin_lock_init(&host->lock);
>        INIT_LIST_HEAD(&host->queue);
>
> -
>        host->dma_ops = host->pdata->dma_ops;
>        dw_mci_init_dma(host);
>
> @@ -2095,6 +2111,13 @@ err_dmaunmap:
>                regulator_disable(host->vmmc);
>                regulator_put(host->vmmc);
>        }
> +       kfree(host);
> +
> +err_clk:
> +       clk_disable(host->ciu_clk);
> +       clk_disable(host->biu_clk);
> +       clk_put(host->ciu_clk);
> +       clk_put(host->biu_clk);

Are these calls safe, or do we need to check IS_ERR as above?

>        return ret;
>  }
>  EXPORT_SYMBOL(dw_mci_probe);
> @@ -2128,6 +2151,10 @@ void dw_mci_remove(struct dw_mci *host)
>                regulator_put(host->vmmc);
>        }
>
> +       clk_disable(host->ciu_clk);
> +       clk_disable(host->biu_clk);
> +       clk_put(host->ciu_clk);
> +       clk_put(host->biu_clk);

Likewise.

>  }
>  EXPORT_SYMBOL(dw_mci_remove);
>
> diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
> index 7a7ebd3..fa9a139 100644
> --- a/include/linux/mmc/dw_mmc.h
> +++ b/include/linux/mmc/dw_mmc.h
> @@ -78,6 +78,8 @@ struct mmc_data;
>  * @data_offset: Set the offset of DATA register according to VERID.
>  * @dev: Device associated with the MMC controller.
>  * @pdata: Platform data associated with the MMC controller.
> + * @biu_clk: Pointer to bus interface unit clock instance.
> + * @ciu_clk: Pointer to card interface unit clock instance.
>  * @slot: Slots sharing this MMC controller.
>  * @fifo_depth: depth of FIFO.
>  * @data_shift: log2 of FIFO item size.
> @@ -158,6 +160,8 @@ struct dw_mci {
>        u16                     data_offset;
>        struct device           dev;
>        struct dw_mci_board     *pdata;
> +       struct clk              *biu_clk;
> +       struct clk              *ciu_clk;
>        struct dw_mci_slot      *slot[MAX_MCI_SLOTS];
>
>        /* FIFO push and pull */
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
