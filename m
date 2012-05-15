Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301Ab2EOFMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 01:12:25 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:32801 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751413Ab2EOFMY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 01:12:24 -0400
From: Philip Rakity <prakity@marvell.com>
To: Yong Ding <yongd@marvell.com>
CC: "cjb@laptop.org" <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "ulf.hansson@stericsson.com" <ulf.hansson@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 14 May 2012 22:11:40 -0700
Subject: Re: [PATCH v2] mmc:sdio:guarantee setting card data bus width as
 4-bit
Thread-Topic: [PATCH v2] mmc:sdio:guarantee setting card data bus width as
 4-bit
Thread-Index: Ac0yWUWLYIuIBtd2Sf6LRNjjZ0d7Bw==
Message-ID: <E66B9D6E-297A-49E9-BF3D-B5C896E6E34A@marvell.com>
References: <1337058583-2014-1-git-send-email-yongd@marvell.com>
In-Reply-To: <1337058583-2014-1-git-send-email-yongd@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ACK

On May 14, 2012, at 10:09 PM, yongd wrote:

>  SDIO_CCCR_IF[1:0] in SDIO card is used for card data bus width
> setting as below,
>     00b: 1-bit bus
>     01b: Reserved
>     10b: 4-bit bus
>     11b: 8-bit bus(only for embedded SDIO)
>  And sdio_enable_wide is for setting data bus width as 4-bit. But
> currently, it 1stly read the register, 2ndly OR' 1b with SDIO_CCCR_IF[1],
> and then write it back.
>  As we can see, such way is based on such assumption that the
> SDIO_CCCR_IF[0] is always 0. Apparently, this is not right.
> 
> Signed-off-by: yongd <yongd@marvell.com>
> ---
> drivers/mmc/core/sdio.c  |    7 +++++++
> include/linux/mmc/sdio.h |    2 ++
> 2 files changed, 9 insertions(+)
> 
> diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
> index 13d0e95..7b528cf 100644
> --- a/drivers/mmc/core/sdio.c
> +++ b/drivers/mmc/core/sdio.c
> @@ -218,6 +218,13 @@ static int sdio_enable_wide(struct mmc_card *card)
> 	if (ret)
> 		return ret;
> 
> +	if ((ctrl & SDIO_BUS_WIDTH_MASK)
> +				== SDIO_BUS_WIDTH_RESERVED)
> +		printk(KERN_WARNING"%s: SDIO_CCCR_IF is invalid: 0x%02X\n",
> +					mmc_hostname(card->host), ctrl);
> +
> +	/* set as 4-bit bus width */
> +	ctrl &= ~SDIO_BUS_WIDTH_MASK;
> 	ctrl |= SDIO_BUS_WIDTH_4BIT;
> 
> 	ret = mmc_io_rw_direct(card, 1, 0, SDIO_CCCR_IF, ctrl, NULL);
> diff --git a/include/linux/mmc/sdio.h b/include/linux/mmc/sdio.h
> index c9fe66c..17446d3 100644
> --- a/include/linux/mmc/sdio.h
> +++ b/include/linux/mmc/sdio.h
> @@ -98,7 +98,9 @@
> 
> #define SDIO_CCCR_IF		0x07	/* bus interface controls */
> 
> +#define  SDIO_BUS_WIDTH_MASK	0x03	/* data bus width setting */
> #define  SDIO_BUS_WIDTH_1BIT	0x00
> +#define  SDIO_BUS_WIDTH_RESERVED 0x01
> #define  SDIO_BUS_WIDTH_4BIT	0x02
> #define  SDIO_BUS_ECSI		0x20	/* Enable continuous SPI interrupt */
> #define  SDIO_BUS_SCSI		0x40	/* Support continuous SPI interrupt */
> -- 
> 1.7.9.5
> 

