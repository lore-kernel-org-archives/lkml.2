Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab1HWIQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 04:16:54 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34945 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab1HWIQw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 04:16:52 -0400
MIME-Version: 1.0
In-Reply-To: <1313117333-26763-1-git-send-email-sonic.adi@gmail.com>
References: <1313117333-26763-1-git-send-email-sonic.adi@gmail.com>
Date: Tue, 23 Aug 2011 16:16:51 +0800
Message-ID: <CAJxxZ0ME9vKgLHbFA1ZmuYRwfNvQaojDLhgBbeMa9qcoWj7-7Q@mail.gmail.com>
Subject: Re: [PATCH v2] spi:spi_bfin5xx: SPI SSEL deasserted too early in soft
 irq mode.
From: Sonic Zhang <sonic.adi@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: spi-devel-general@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Any comments?


Sonic Zhang

On Fri, Aug 12, 2011 at 10:48 AM, Sonic Zhang <sonic.adi@gmail.com> wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
>
> Poll the FIFO till it is empty before deassert SSEL in pump_transfers in
> soft irq mode. No polling is necessary in interrupt mode and error handling.
>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> ---
>  drivers/spi/spi-bfin5xx.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/spi/spi-bfin5xx.c b/drivers/spi/spi-bfin5xx.c
> index b8d25f2..7e03e7d 100644
> --- a/drivers/spi/spi-bfin5xx.c
> +++ b/drivers/spi/spi-bfin5xx.c
> @@ -587,6 +587,7 @@ static void bfin_spi_pump_transfers(unsigned long data)
>        if (message->state == DONE_STATE) {
>                dev_dbg(&drv_data->pdev->dev, "transfer: all done!\n");
>                message->status = 0;
> +               bfin_spi_flush(drv_data);
>                bfin_spi_giveback(drv_data);
>                return;
>        }
> @@ -870,8 +871,10 @@ static void bfin_spi_pump_transfers(unsigned long data)
>                message->actual_length += drv_data->len_in_bytes;
>                /* Move to next transfer of this msg */
>                message->state = bfin_spi_next_transfer(drv_data);
> -               if (drv_data->cs_change)
> +               if (drv_data->cs_change) {
> +                       bfin_spi_flush(drv_data);
>                        bfin_spi_cs_deactive(drv_data, chip);
> +               }
>        }
>
>        /* Schedule next transfer tasklet */
> --
> 1.7.0.4
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
