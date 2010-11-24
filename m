Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab0KXEHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 23:07:51 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48499 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab0KXEHt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 23:07:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LSsycJ8E4sWNfTCKOpMLeV5DhblTO8xxmf3UJLy502c5JG7/wfNfqn0AmQeK5PMewC
         l1sVpLaoLKMi94PFnKs8WLlbMhB4rMSGkyilVkGFeNKyFKMj5txCKBRMo/Sm0wBNx6QO
         gzjdIwLpOcRwj3u0Dd+J5cPC0pvye79bY+Rwo=
MIME-Version: 1.0
In-Reply-To: <20101123084510.GE17754@intel.com>
References: <20101123084510.GE17754@intel.com>
Date: Wed, 24 Nov 2010 13:07:46 +0900
X-Google-Sender-Auth: ddeXTXAYUSCB_RtM6lQ6gJ7iAVk
Message-ID: <AANLkTinF3+nUb8ugttyw-A_ss8cyX1iHFzG6bLdGf5d6@mail.gmail.com>
Subject: Re: [PATCH v1 4/4]use HPI to interrupt background operations
From: Kyungmin Park <kmpark@infradead.org>
To: Chuanxiao Dong <chuanxiao.dong@intel.com>
Cc: linux-mmc@vger.kernel.org, cjb@laptop.org, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, arjan@linux.intel.com, hang.yuan@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 5:45 PM, Chuanxiao Dong
<chuanxiao.dong@intel.com> wrote:
> From 8d2cf8e4b890a3ef0c7b63da57b8b184ab64725d Mon Sep 17 00:00:00 2001
> From: Chuanxiao Dong <chuanxiao.dong@intel.com>
> Date: Tue, 23 Nov 2010 12:01:58 +0800
> Subject: [PATCH 4/4] mmc: Add HPI operation to interrupt BKOPS
>
> Before start a new user request, driver need to wait until the
> BKOPS finished, or use HPI to interrupt the BKOPS since user request
> has a higher priority than BKOPS.
>
> This patch implemented using HPI to interrupt BKOPS if eMMC card
> supports HPI.
>
> Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
> ---
>  drivers/mmc/core/core.c |   51 ++++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 50 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 6891169..644ce9d 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -202,6 +202,50 @@ static void mmc_wait_done(struct mmc_request *mrq)
>  }
>
>  /**
> + *     mmc_issue_hpi_cmd - start a hpi to interrupt background
> + *     operations
> + *     @card: MMC card need to interrupt
> + *
> + *  start MMC_SEND_STATUS/MMC_STOP_TRANSMISSION to stop the
> + *  background operations.
> + *
> + *  return value:
> + *  0: successfully interrupt BKOPS
> + *  -EINVAL: HPI command invalid
> + *  -EIO: failed when interrupt BKOPS
> + */
> +static int mmc_issue_hpi_cmd(struct mmc_card *card)
> +{
> +       struct mmc_command cmd;
> +       unsigned int opcode;
> +       unsigned int flags;
> +       int err;
> +
> +       opcode = card->ext_csd.hpi_cmd;
> +       if (opcode == MMC_STOP_TRANSMISSION)
> +               flags = MMC_RSP_R1B | MMC_CMD_AC;
> +       else if (opcode == MMC_SEND_STATUS)
> +               flags = MMC_RSP_R1 | MMC_CMD_AC;
> +       else
> +               return -EINVAL;
> +
> +       memset(&cmd, 0, sizeof(struct mmc_command));
> +       cmd.opcode = opcode;
> +       cmd.arg = card->rca << 16 | 1;
Maybe missing set the flags;
            cmd.flags = flags;

Thank you,
Kyungmin Park
> +       err = mmc_wait_for_cmd(card->host, &cmd, 0);
> +       if (err || (cmd.resp[0] & 0xFDF92000)) {
> +               printk(KERN_ERR "error %d requesting status %#x\n",
> +                       err, cmd.resp[0]);
> +               /*
> +                * abandon this BKOPS, let block layer handle
> +                * this
> +                */
> +               return -EIO;
> +       }
> +       return 0;
> +}
> +
> +/**
>  *     mmc_wait_for_bkops- start a bkops check and wait for
>  *     completion
>  *     @card: MMC card need to check
> @@ -224,9 +268,14 @@ retry:
>
>        if (card->ext_csd.hpi_en) {
>                /*
> -                * TODO
>                 * HPI to interrupt BKOPS if supported
>                 */
> +               err = mmc_issue_hpi_cmd(card);
> +               if (err == -EINVAL) {
> +                       /* disable HPI feature */
> +                       card->ext_csd.hpi_en = 0;
> +                       goto retry;
> +               }
>        } else {
>                memset(&cmd, 0, sizeof(struct mmc_command));
>
> --
> 1.6.6.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
