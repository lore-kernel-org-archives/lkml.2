Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907Ab1FPNOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 09:14:52 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:50445 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751892Ab1FPNOt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 09:14:49 -0400
MIME-Version: 1.0
In-Reply-To: <1306360653-6196-4-git-send-email-per.forlin@linaro.org>
References: <1306360653-6196-1-git-send-email-per.forlin@linaro.org>
	<1306360653-6196-4-git-send-email-per.forlin@linaro.org>
Date: Thu, 16 Jun 2011 18:44:47 +0530
Message-ID: <BANLkTikP8pveKPPG+_h6_hBenh91vAi4mQ@mail.gmail.com>
Subject: Re: [PATCH v4 03/12] omap_hsmmc: add support for pre_req and post_req
From: "S, Venkatraman" <svenkatr@ti.com>
To: Per Forlin <per.forlin@linaro.org>
Cc: linux-mmc <linux-mmc@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linaro-dev <linaro-dev@lists.linaro.org>,
        David Vrabel <david.vrabel@csr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 3:27 AM, Per Forlin <per.forlin@linaro.org> wrote:
> pre_req() runs dma_map_sg(), post_req() runs dma_unmap_sg.
> If not calling pre_req() before omap_hsmmc_request()
> dma_map_sg will be issued before starting the transfer.
> It is optional to use pre_req(). If issuing pre_req()
> post_req() must be to be called as well.
>
> Signed-off-by: Per Forlin <per.forlin@linaro.org>
> ---
>  drivers/mmc/host/omap_hsmmc.c |   87 +++++++++++++++++++++++++++++++++++++++--
>  1 files changed, 83 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index ad3731a..2116c09 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -141,6 +141,11 @@
>  #define OMAP_HSMMC_WRITE(base, reg, val) \
>        __raw_writel((val), (base) + OMAP_HSMMC_##reg)
>
> +struct omap_hsmmc_next {
> +       unsigned int    dma_len;
> +       s32             cookie;
> +};
> +
>  struct omap_hsmmc_host {
>        struct  device          *dev;
>        struct  mmc_host        *mmc;
> @@ -184,6 +189,7 @@ struct omap_hsmmc_host {
>        int                     reqs_blocked;
>        int                     use_reg;
>        int                     req_in_progress;
> +       struct omap_hsmmc_next  next_data;
>
>        struct  omap_mmc_platform_data  *pdata;
>  };
> @@ -1344,8 +1350,9 @@ static void omap_hsmmc_dma_cb(int lch, u16 ch_status, void *cb_data)
>                return;
>        }
>
> -       dma_unmap_sg(mmc_dev(host->mmc), data->sg, data->sg_len,
> -               omap_hsmmc_get_dma_dir(host, data));
> +       if (!data->host_cookie)
> +               dma_unmap_sg(mmc_dev(host->mmc), data->sg, data->sg_len,
> +                            omap_hsmmc_get_dma_dir(host, data));
>
>        req_in_progress = host->req_in_progress;
>        dma_ch = host->dma_ch;
> @@ -1363,6 +1370,45 @@ static void omap_hsmmc_dma_cb(int lch, u16 ch_status, void *cb_data)
>        }
>  }
>
> +static int omap_hsmmc_pre_dma_transfer(struct omap_hsmmc_host *host,
> +                                      struct mmc_data *data,
> +                                      struct omap_hsmmc_next *next)
> +{

As you are passing &host->next_data into next, next will always be a
valid pointer. So..

> +       int dma_len;
> +
> +       if (!next && data->host_cookie &&
> +           data->host_cookie != host->next_data.cookie) {

!next will always return false and hence the rest of the check will
never be executed.
Perhaps s/&&/||/g ?


> +               printk(KERN_WARNING "[%s] invalid cookie: data->host_cookie %d"
> +                      " host->next_data.cookie %d\n",
> +                      __func__, data->host_cookie, host->next_data.cookie);
> +               data->host_cookie = 0;
> +       }
> +
> +       /* Check if next job is already prepared */
> +       if (next ||
> +           (!next && data->host_cookie != host->next_data.cookie)) {

Cookie matching will never be checked..

> +               dma_len = dma_map_sg(mmc_dev(host->mmc), data->sg,
> +                                    data->sg_len,
> +                                    omap_hsmmc_get_dma_dir(host, data));
> +
> +       } else {

and this will never be executed as well?

> +               dma_len = host->next_data.dma_len;
> +               host->next_data.dma_len = 0;
> +       }
> +
> +
> +       if (dma_len == 0)
> +               return -EINVAL;
> +
> +       if (next) {
> +               next->dma_len = dma_len;
> +               data->host_cookie = ++next->cookie < 0 ? 1 : next->cookie;
> +       } else
> +               host->dma_len = dma_len;
> +
> +       return 0;
> +}
> +
