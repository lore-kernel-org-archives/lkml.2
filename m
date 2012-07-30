Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab2G3NQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 09:16:55 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:56528 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754097Ab2G3NQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 09:16:53 -0400
MIME-Version: 1.0
In-Reply-To: <1343613881-6803-1-git-send-email-kyungsik.lee@lge.com>
References: <1343613881-6803-1-git-send-email-kyungsik.lee@lge.com>
From: "S, Venkatraman" <svenkatr@ti.com>
Date: Mon, 30 Jul 2012 18:46:31 +0530
Message-ID: <CANfBPZ-pa++A=OSmhaEfVs-TDVtTbsBi4FacaPxuvfNJRe-Jxw@mail.gmail.com>
Subject: Re: [PATCH RESEND v2] mmc: core: Remove bounce buffer in mmc_send_cxd_data()
To: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: Chris Ball <cjb@laptop.org>, Jaehoon Chung <jh80.chung@samsung.com>,
        raphael.andy.lee@gmail.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 7:34 AM, Kyungsik Lee <kyungsik.lee@lge.com> wrote:
> It is expected that Extended CSD register(the size of this register
> is larger than CID/CSD) will be referenced more frequently as more
> fields have been added to Extended CSD and it seems that it is not
> a good option to double the memory used.
>
> This patch is intended to avoid the use of bounce buffer for reading
> Extended CSD register in mmc_send_cxd_data().
Maybe I am reading this wrong, but mmc_send_cid and mmc_send_csd are always
called with card->raw_cid and card->raw_csd, which are allocated from the heap,
(from mmc_alloc_card).
So the second half of your changes are not required, or a WARN_ON
might suffice ?

>
> Signed-off-by: Kyungsik Lee <kyungsik.lee@lge.com>
> ---
> Changes in v2:
> - Handling on-stack buffer if it's used in caller.
> ---
>  drivers/mmc/core/mmc_ops.c |   56 ++++++++++++++++++++++++++++++++++---------
>  1 files changed, 44 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
> index 0ed2cc5..dae5492 100644
> --- a/drivers/mmc/core/mmc_ops.c
> +++ b/drivers/mmc/core/mmc_ops.c
> @@ -239,13 +239,19 @@ mmc_send_cxd_data(struct mmc_card *card, struct mmc_host *host,
>         struct mmc_data data = {0};
>         struct scatterlist sg;
>         void *data_buf;
> +       int is_on_stack;
>
> -       /* dma onto stack is unsafe/nonportable, but callers to this
> -        * routine normally provide temporary on-stack buffers ...
> -        */
> -       data_buf = kmalloc(len, GFP_KERNEL);
> -       if (data_buf == NULL)
> -               return -ENOMEM;
> +       is_on_stack = object_is_on_stack(buf);
> +       if (is_on_stack) {
> +
> +               /* dma onto stack is unsafe/nonportable, but callers to this
> +                * routine normally provide temporary on-stack buffers ...
> +                */
> +               data_buf = kmalloc(len, GFP_KERNEL);
> +               if (data_buf == NULL)
> +                       return -ENOMEM;
> +       } else
> +               data_buf = buf;
>
>         mrq.cmd = &cmd;
>         mrq.data = &data;
> @@ -280,8 +286,10 @@ mmc_send_cxd_data(struct mmc_card *card, struct mmc_host *host,
>
>         mmc_wait_for_req(host, &mrq);
>
> -       memcpy(buf, data_buf, len);
> -       kfree(data_buf);
> +       if (is_on_stack) {
> +               memcpy(buf, data_buf, len);
> +               kfree(data_buf);
> +       }
>
>         if (cmd.error)
>                 return cmd.error;
> @@ -294,24 +302,37 @@ mmc_send_cxd_data(struct mmc_card *card, struct mmc_host *host,
>  int mmc_send_csd(struct mmc_card *card, u32 *csd)
>  {
>         int ret, i;
> +       u32 *csd_tmp;
>
>         if (!mmc_host_is_spi(card->host))
>                 return mmc_send_cxd_native(card->host, card->rca << 16,
>                                 csd, MMC_SEND_CSD);
>
> -       ret = mmc_send_cxd_data(card, card->host, MMC_SEND_CSD, csd, 16);
> +       csd_tmp = kmalloc(16, GFP_KERNEL);
> +       if (!csd_tmp)
> +               return -ENOMEM;
> +
> +       ret = mmc_send_cxd_data(card, card->host, MMC_SEND_CSD, csd_tmp, 16);
>         if (ret)
> -               return ret;
> +               goto err;
> +
> +       memcpy(csd, csd_tmp, 16);
>
>         for (i = 0;i < 4;i++)
>                 csd[i] = be32_to_cpu(csd[i]);
>
> +       kfree(csd_tmp);
>         return 0;
> +
> +err:
> +       kfree(csd_tmp);
> +       return ret;
>  }
>
>  int mmc_send_cid(struct mmc_host *host, u32 *cid)
>  {
>         int ret, i;
> +       u32 *cid_tmp;
>
>         if (!mmc_host_is_spi(host)) {
>                 if (!host->card)
> @@ -320,14 +341,25 @@ int mmc_send_cid(struct mmc_host *host, u32 *cid)
>                                 cid, MMC_SEND_CID);
>         }
>
> -       ret = mmc_send_cxd_data(NULL, host, MMC_SEND_CID, cid, 16);
> +       cid_tmp = kmalloc(16, GFP_KERNEL);
> +       if (!cid_tmp)
> +               return -ENOMEM;
> +
> +       ret = mmc_send_cxd_data(NULL, host, MMC_SEND_CID, cid_tmp, 16);
>         if (ret)
> -               return ret;
> +               goto err;
> +
> +       memcpy(cid, cid_tmp, 16);
>
>         for (i = 0;i < 4;i++)
>                 cid[i] = be32_to_cpu(cid[i]);
>
> +       kfree(cid_tmp);
>         return 0;
> +
> +err:
> +       kfree(cid_tmp);
> +       return ret;
>  }
>
>  int mmc_send_ext_csd(struct mmc_card *card, u8 *ext_csd)
> --
> 1.7.0.4
>
