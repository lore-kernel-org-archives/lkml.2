Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab0HXAGo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 20:06:44 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:37528 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab0HXAGm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 20:06:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tWYCRr+LJFq946ZjjllzRKl9FcBe6xDSF64JAgDw4XhjaNjBHDBobSyHjaGAXTg6Tn
         ioDPxHrlvPEQ3C+q+xJsQhrz9Kj5hnGq9HU3wRbjWstAOS9bApizahru/m2loxNzkXub
         mmgN7A10g7iACJz7iqvBO50eSRXhLlXtyeneo=
MIME-Version: 1.0
In-Reply-To: <1282581656-26137-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1282581656-26137-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Tue, 24 Aug 2010 09:06:40 +0900
Message-ID: <AANLkTim6+6-L8ALM0YO01D44PmZgsbcMrrwRxrPJMkpT@mail.gmail.com>
Subject: Re: [spi-devel-general] [PATCH] spi/spi_s3c64xx: Warn if PIO
 transfers time out
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 1:40 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> When using PIO we have a timeout for the TX and RX FIFOs to ensure that
> the data actually gets transferred. Warn if we hit that timeout - it
> should never happen, but this makes sure we'll find out if it does.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/spi/spi_s3c64xx.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/spi/spi_s3c64xx.c b/drivers/spi/spi_s3c64xx.c
> index 7e627f7..f72e1c0 100644
> --- a/drivers/spi/spi_s3c64xx.c
> +++ b/drivers/spi/spi_s3c64xx.c
> @@ -200,6 +200,9 @@ static void flush_fifo(struct s3c64xx_spi_driver_data *sdd)
>                val = readl(regs + S3C64XX_SPI_STATUS);
>        } while (TX_FIFO_LVL(val, sci) && loops--);
>
> +       if (loops == 0)
> +               dev_warn(&sdd->pdev->dev, "Timed out flushing TX FIFO\n");
> +
>        /* Flush RxFIFO*/
>        loops = msecs_to_loops(1);
>        do {
> @@ -210,6 +213,9 @@ static void flush_fifo(struct s3c64xx_spi_driver_data *sdd)
>                        break;
>        } while (loops--);
>
> +       if (loops == 0)
> +               dev_warn(&sdd->pdev->dev, "Timed out flushing RX FIFO\n");
> +
>        val = readl(regs + S3C64XX_SPI_CH_CFG);
>        val &= ~S3C64XX_SPI_CH_SW_RST;
>        writel(val, regs + S3C64XX_SPI_CH_CFG);

Ok, though I'll be very surprised to see the FIFO flush failing. We
are not waiting
for data to be transferred, but for SW Reset to make its effect.

Acked-by: Jassi Brar <jassi.brar@samsung.com>
