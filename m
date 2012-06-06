Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab2FFNXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 09:23:42 -0400
Received: from void.printf.net ([89.145.121.20]:45614 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754227Ab2FFNXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 09:23:40 -0400
From: Chris Ball <cjb@laptop.org>
To: yongd <yongd@marvell.com>
Cc: linux-mmc@vger.kernel.org, prakity@marvell.com, ohad@wizery.com,
        linus.walleij@linaro.org, ulf.hansson@stericsson.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mmc:sdio:guarantee setting card data bus width as 4-bit
References: <1337058583-2014-1-git-send-email-yongd@marvell.com>
Date: Wed, 06 Jun 2012 09:23:32 -0400
In-Reply-To: <1337058583-2014-1-git-send-email-yongd@marvell.com>
	(yongd@marvell.com's message of "Tue, 15 May 2012 13:09:43 +0800")
Message-ID: <87r4ts4lrf.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, May 15 2012, yongd wrote:
>   SDIO_CCCR_IF[1:0] in SDIO card is used for card data bus width
> setting as below,
>      00b: 1-bit bus
>      01b: Reserved
>      10b: 4-bit bus
>      11b: 8-bit bus(only for embedded SDIO)
>   And sdio_enable_wide is for setting data bus width as 4-bit. But
> currently, it 1stly read the register, 2ndly OR' 1b with SDIO_CCCR_IF[1],
> and then write it back.
>   As we can see, such way is based on such assumption that the
> SDIO_CCCR_IF[0] is always 0. Apparently, this is not right.
>
> Signed-off-by: yongd <yongd@marvell.com>
> ---
>  drivers/mmc/core/sdio.c  |    7 +++++++
>  include/linux/mmc/sdio.h |    2 ++
>  2 files changed, 9 insertions(+)
>
> diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
> index 13d0e95..7b528cf 100644
> --- a/drivers/mmc/core/sdio.c
> +++ b/drivers/mmc/core/sdio.c
> @@ -218,6 +218,13 @@ static int sdio_enable_wide(struct mmc_card *card)
>  	if (ret)
>  		return ret;
>  
> +	if ((ctrl & SDIO_BUS_WIDTH_MASK)
> +				== SDIO_BUS_WIDTH_RESERVED)
> +		printk(KERN_WARNING"%s: SDIO_CCCR_IF is invalid: 0x%02X\n",
> +					mmc_hostname(card->host), ctrl);
> +
> +	/* set as 4-bit bus width */
> +	ctrl &= ~SDIO_BUS_WIDTH_MASK;
>  	ctrl |= SDIO_BUS_WIDTH_4BIT;
>  
>  	ret = mmc_io_rw_direct(card, 1, 0, SDIO_CCCR_IF, ctrl, NULL);
> diff --git a/include/linux/mmc/sdio.h b/include/linux/mmc/sdio.h
> index c9fe66c..17446d3 100644
> --- a/include/linux/mmc/sdio.h
> +++ b/include/linux/mmc/sdio.h
> @@ -98,7 +98,9 @@
>  
>  #define SDIO_CCCR_IF		0x07	/* bus interface controls */
>  
> +#define  SDIO_BUS_WIDTH_MASK	0x03	/* data bus width setting */
>  #define  SDIO_BUS_WIDTH_1BIT	0x00
> +#define  SDIO_BUS_WIDTH_RESERVED 0x01
>  #define  SDIO_BUS_WIDTH_4BIT	0x02
>  #define  SDIO_BUS_ECSI		0x20	/* Enable continuous SPI interrupt */
>  #define  SDIO_BUS_SCSI		0x40	/* Support continuous SPI interrupt */

Thanks, pushed to mmc-next for 3.5.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
