Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab0IHBMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 21:12:05 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58111 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201Ab0IHBMB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 21:12:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZF4y4J8uzXVHfUfO4YpnXtkkqP9XcSGY5kFZBzn5fHfScW9C9BPbXQJXqjRnsvQUtF
         gfvG1RWyk88GHiEtMsPKKl6PzKWUfeKJzO5bqIHwOZIAgcXq7bT7pSK42lllkt+OUe5e
         MHrYJQJy/SN37zBp0+cwCM9c3jAgXj0rF1Lo8=
MIME-Version: 1.0
In-Reply-To: <1283873872-8633-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1283873872-8633-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Wed, 8 Sep 2010 10:11:59 +0900
Message-ID: <AANLkTi=6voS7WXcXgVTdK614W0Epy_Ehf5QzufErV2tD@mail.gmail.com>
Subject: Re: [PATCH 1/2] spi/spi_s3c64xx: Fix timeout handling in wait_for_xfer()
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Jassi Brar <jassi.brar@samsung.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 8, 2010 at 12:37 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> In wait_for_xfer() for PIO transfer we are using val as both a
> counter variable to track the number of spins we've waited for
> completion and the value we read from the controller, causing
> us to fail to ever actually notice the timeout. Fix this by using
> a separate value to hold the register readback.
>
> Also warn when we hit the timeout.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/spi/spi_s3c64xx.c |   11 +++++++----
>  1 files changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/spi/spi_s3c64xx.c b/drivers/spi/spi_s3c64xx.c
> index 6e48ea9..03b28e4 100644
> --- a/drivers/spi/spi_s3c64xx.c
> +++ b/drivers/spi/spi_s3c64xx.c
> @@ -321,7 +321,7 @@ static int wait_for_xfer(struct s3c64xx_spi_driver_data *sdd,
>  {
>        struct s3c64xx_spi_info *sci = sdd->cntrlr_info;
>        void __iomem *regs = sdd->regs;
> -       unsigned long val;
> +       unsigned long val, reg;
>        int ms;
>
>        /* millisecs to xfer 'len' bytes @ 'cur_speed' */
> @@ -333,13 +333,16 @@ static int wait_for_xfer(struct s3c64xx_spi_driver_data *sdd,
>                val = wait_for_completion_timeout(&sdd->xfer_completion, val);
>        } else {
>                val = msecs_to_loops(ms);
> +
>                do {
> -                       val = readl(regs + S3C64XX_SPI_STATUS);
> -               } while (RX_FIFO_LVL(val, sci) < xfer->len && --val);
> +                       reg = readl(regs + S3C64XX_SPI_STATUS);
> +               } while (RX_FIFO_LVL(reg, sci) < xfer->len && --val);
>        }
>
> -       if (!val)
> +       if (!val) {
> +               dev_warn(&sdd->pdev->dev, "Transfer timeout\n");
>                return -EIO;
> +       }

I have already submitted a patch a few days ago
https://patchwork.kernel.org/patch/151941/
(It's strange that Grant's id isn't there in the CC list, despite my writing it)
