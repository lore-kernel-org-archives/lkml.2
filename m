Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421Ab1IAMxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 08:53:19 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41096 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129Ab1IAMxO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 08:53:14 -0400
MIME-Version: 1.0
In-Reply-To: <1313117333-26763-1-git-send-email-sonic.adi@gmail.com>
References: <1313117333-26763-1-git-send-email-sonic.adi@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 1 Sep 2011 20:52:54 +0800
Message-ID: <CAGsJ_4xGJoz7JNQHBtK7pC+sn+pUZsibgiBNPnL=Vdyii-JsDA@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] [PATCH v2] spi:spi_bfin5xx: SPI SSEL
 deasserted too early in soft irq mode.
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/12 Sonic Zhang <sonic.adi@gmail.com>:
> From: Sonic Zhang <sonic.zhang@analog.com>
>
> Poll the FIFO till it is empty before deassert SSEL in pump_transfers in
> soft irq mode. No polling is necessary in interrupt mode and error handling.
>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>

Acked-by: Barry Song <21cnbao@gmail.com>

it is actually making sure the last message is finished.

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
> _______________________________________________
> Uclinux-dist-devel mailing list
> Uclinux-dist-devel@blackfin.uclinux.org
> https://blackfin.uclinux.org/mailman/listinfo/uclinux-dist-devel
