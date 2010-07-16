Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965094Ab0GPKvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 06:51:44 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39380 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964971Ab0GPKvm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 06:51:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JyfGNmMFc/SSWvqKO+V3NCmi9qDRsjoPJuazz1Xv3Nq1DX+/dSGopIKnDm//UmCMQr
         kbAssA1xerwXRNA0INrj5CwZ3RdtM3jPo9w310Fogb5CU0/CdufqxVdAUlcnRvBjanQx
         eQqfFdtlMDUP9zu7ugXVIa3qzlZgvKnONKQfk=
MIME-Version: 1.0
In-Reply-To: <1278921056.22437.1.camel@eight.analog.com>
References: <1278921056.22437.1.camel@eight.analog.com>
Date: Fri, 16 Jul 2010 18:51:40 +0800
Message-ID: <AANLkTimwi7IuKZySIkDjlgBi7NDkIaW79CHNbhliJ2UY@mail.gmail.com>
Subject: Re: [PATCH v2] MMC:mmc_spi: Recover from CRC error for SD read/write 
	operation over SPI.
From: Sonic Zhang <sonic.adi@gmail.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-mmc@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any comments?


Sonic

On Mon, Jul 12, 2010 at 3:50 PM, sonic zhang <sonic.adi@gmail.com> wrote:
> >From 94d1ea57ac2fbe37133e25e99ccb265250f0027d Mon Sep 17 00:00:00 2001
> From: Sonic Zhang <sonic.zhang@analog.com>
> Date: Fri, 9 Jul 2010 15:36:20 +0800
> Subject: [PATCH v2] MMC:mmc_spi: Recover from crc error for SD read/write operation over SPI.
>
> SPI bus is not reliable on all platforms when doing large data transfer.
> Current mmc spi driver fails SD read/write command immediately, if
> occasional CRC error is reported by SD device. This patch makes the
> operation recover from the CRC error by doing last SD command again.
> The retry count is set to 5 to ensure the driver pass any stress test.
>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> ---
>  drivers/mmc/host/mmc_spi.c |   22 ++++++++++++++++++++++
>  1 files changed, 22 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
> index ad847a2..8192434 100644
> --- a/drivers/mmc/host/mmc_spi.c
> +++ b/drivers/mmc/host/mmc_spi.c
> @@ -1055,6 +1055,8 @@ static void mmc_spi_request(struct mmc_host *mmc, struct mmc_request *mrq)
>  {
>        struct mmc_spi_host     *host = mmc_priv(mmc);
>        int                     status = -EINVAL;
> +       int                     crc_retry = 5;
> +       struct mmc_command      stop;
>
>  #ifdef DEBUG
>        /* MMC core and layered drivers *MUST* issue SPI-aware commands */
> @@ -1084,10 +1086,30 @@ static void mmc_spi_request(struct mmc_host *mmc, struct mmc_request *mrq)
>        }
>  #endif
>
> +crc_recover:
>        /* issue command; then optionally data and stop */
>        status = mmc_spi_command_send(host, mrq, mrq->cmd, mrq->data != NULL);
>        if (status == 0 && mrq->data) {
>                mmc_spi_data_do(host, mrq->cmd, mrq->data, mrq->data->blksz);
> +
> +               /*
> +                * SPI bus is not reliable when doing large data transfer.
> +                * If occasional crc error is reported by SD device when do
> +                * data read/write over SPI, it can be recovered by doing
> +                * last SD command again. The retry count is set to 5 to
> +                * ensure the driver pass any stress test.
> +                */
> +               if (mrq->data->error == -EILSEQ && crc_retry) {
> +                       stop.opcode = MMC_STOP_TRANSMISSION;
> +                       stop.arg = 0;
> +                       stop.flags = MMC_RSP_SPI_R1B | MMC_RSP_R1B | MMC_CMD_AC;
> +
> +                       status = mmc_spi_command_send(host, mrq, &stop, 0);
> +                       crc_retry--;
> +                       mrq->data->error = 0;
> +                       goto crc_recover;
> +               }
> +
>                if (mrq->stop)
>                        status = mmc_spi_command_send(host, mrq, mrq->stop, 0);
>                else
> --
> 1.6.0
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
