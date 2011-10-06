Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964937Ab1JFOp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 10:45:56 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:1953 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563Ab1JFOpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 10:45:54 -0400
Message-ID: <4E8DBF14.6010903@atmel.com>
Date: Thu, 06 Oct 2011 16:45:40 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: cjb@laptop.org, linux-mmc@vger.kernel.org
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nicolas.pitre@linaro.org, per.forlin@linaro.org
Subject: Re: [PATCH RESEND] mmc: sdio: rw extended, use a sg entry for each
 block
References: <1316598039-30238-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1316598039-30238-1-git-send-email-nicolas.ferre@atmel.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2011 11:40 AM, Nicolas Ferre :
> While using io multiple blocks operations, change the way that sg is built:
> use one sg entry for each block instead of aggregating the whole buffer
> in a single sg entry.
> Using a single sg entry for a multiple block command may lead to
> misunderstanding between the sd/mmc and the DMA controllers. In fact, the
> knowledge of the block length will allow both controllers to optimize burst
> sizes on internal bus while dealing with those data.

After having performed some tests I realize that it seems quite
difficult to benchmark this particular case (SDIO, CMD53, multi-block
case). Moreover, the SDIO card that I use is triggering this case on
pretty small blocks (16 x 32 bytes). For the record, I use Marvell 8686
with libertas driver.

The benchmark results hardly show an improvement! I guess that the
benefit of having optimized transfers on internal bus is completely
concealed by the overhead of multiple small blocks management by DMA...

Hopefully another SDIO card can use bigger multiple blocks but it could
be difficult to adapt this piece of code to the size of the block itself...

So, do you have ideas about how I can trigger bigger multiple SDIO and
test further?

> Use a sg table to store start addresses of blocks within the data buffer.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  drivers/mmc/core/sdio_ops.c |   38 +++++++++++++++++++++++++++++---------

For my platform the alternative would be to re-configure at runtime the
chunck size (max size of bursts between sd controller and DMA).
This operation will be conditioned by the identification of this case
(SDIO, CMD53, multi-block) and will involve both DMA and sd/mmc drivers.
I fear that it can be heavyweight.

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
