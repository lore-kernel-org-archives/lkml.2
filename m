Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab1IMQ7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 12:59:38 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:19398 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab1IMQ7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 12:59:37 -0400
Message-ID: <4E6F8BDC.70703@atmel.com>
Date: Tue, 13 Sep 2011 18:59:08 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: cjb@laptop.org, linux-mmc@vger.kernel.org
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org
Subject: Re: [RFC PATCH] mmc: sdio: rw extended, use a sg entry for each block
References: <1315395620-22641-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1315395620-22641-1-git-send-email-nicolas.ferre@atmel.com>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 07/09/2011 13:40, Nicolas Ferre :
> While using io multiple blocks operations, change the way that sg is built:
> use one sg entry for each block instead of aggregating the whole buffer
> in a single sg entry.
> Using a single sg entry for a multiple block command may lead to
> misunderstanding between the sd/mmc and the DMA controllers. In fact, the
> knowledge of the block length will allow both controllers to optimize burst
> sizes on internal bus while dealing with those data.
> 
> Use a sg table to store start addresses of blocks within the data buffer.

Ping?

I add linaro-dev so maybe other people can be interested...

> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  drivers/mmc/core/sdio_ops.c |   38 +++++++++++++++++++++++++++++---------
>  1 files changed, 29 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/mmc/core/sdio_ops.c b/drivers/mmc/core/sdio_ops.c
> index f087d87..aea6978 100644
> --- a/drivers/mmc/core/sdio_ops.c
> +++ b/drivers/mmc/core/sdio_ops.c
> @@ -124,7 +124,7 @@ int mmc_io_rw_extended(struct mmc_card *card, int write, unsigned fn,
>  	struct mmc_request mrq = {0};
>  	struct mmc_command cmd = {0};
>  	struct mmc_data data = {0};
> -	struct scatterlist sg;
> +	struct sg_table sgt;
>  
>  	BUG_ON(!card);
>  	BUG_ON(fn > 7);
> @@ -144,24 +144,44 @@ int mmc_io_rw_extended(struct mmc_card *card, int write, unsigned fn,
>  	cmd.arg |= fn << 28;
>  	cmd.arg |= incr_addr ? 0x04000000 : 0x00000000;
>  	cmd.arg |= addr << 9;
> -	if (blocks == 1 && blksz <= 512)
> -		cmd.arg |= (blksz == 512) ? 0 : blksz;	/* byte mode */
> -	else
> -		cmd.arg |= 0x08000000 | blocks;		/* block mode */
> +	if (blocks == 1 && blksz <= 512) {
> +		/* byte mode */
> +		struct scatterlist sg;
> +
> +		cmd.arg |= (blksz == 512) ? 0 : blksz;
> +		sg_init_one(&sg, buf, blksz * blocks);
> +
> +		data.sg = &sg;
> +		data.sg_len = 1;
> +	} else {
> +		/* block mode */
> +		struct scatterlist *sg_ptr;
> +		int i;
> +
> +		cmd.arg |= 0x08000000 | blocks;
> +		if (sg_alloc_table(&sgt, blocks, GFP_KERNEL))
> +			return -ENOMEM;
> +		for_each_sg(sgt.sgl, sg_ptr, sgt.nents, i) {
> +			sg_set_buf(sg_ptr, buf + i * blksz, blksz);
> +		}
> +
> +		data.sg = sgt.sgl;
> +		data.sg_len = sgt.nents;
> +	}
> +
>  	cmd.flags = MMC_RSP_SPI_R5 | MMC_RSP_R5 | MMC_CMD_ADTC;
>  
>  	data.blksz = blksz;
>  	data.blocks = blocks;
>  	data.flags = write ? MMC_DATA_WRITE : MMC_DATA_READ;
> -	data.sg = &sg;
> -	data.sg_len = 1;
> -
> -	sg_init_one(&sg, buf, blksz * blocks);
>  
>  	mmc_set_data_timeout(&data, card);
>  
>  	mmc_wait_for_req(card->host, &mrq);
>  
> +	if (blocks != 1 || blksz > 512)
> +		sg_free_table(&sgt);
> +
>  	if (cmd.error)
>  		return cmd.error;
>  	if (data.error)


Best regards,
-- 
Nicolas Ferre

