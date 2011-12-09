Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab1LIORJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:17:09 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:50083 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab1LIORH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:17:07 -0500
Date: Fri, 9 Dec 2011 09:17:03 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Sangwook Lee <sangwook.lee@linaro.org>
cc: cjb@laptop.org, linux-mmc@vger.kernel.org, per.forlin@linaro.org,
        linux-kernel@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH] mmc: sdio: optimization for process_sdio_pending_irq
In-Reply-To: <1323433757-3811-1-git-send-email-sangwook.lee@linaro.org>
Message-ID: <alpine.LFD.2.02.1112090914170.2907@xanadu.home>
References: <1323433757-3811-1-git-send-email-sangwook.lee@linaro.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Dec 2011, Sangwook Lee wrote:

> Skip fillng in mmc_command struct for CCCR_INTx
> everytime sdio_irq_thread (process_sdio_pending_irqs)
> calls mmc_io_rw_direct.
> 
> Signed-off-by: Sangwook Lee <sangwook.lee@linaro.org>

Is there a real advantage doing this?

While you might be saving on a few stores, you are increasing code size 
and therefore i-cache miss probabilities.  So this is not clear to me 
this is actually a gain.

> ---
>  drivers/mmc/core/sdio_irq.c |    2 +-
>  drivers/mmc/core/sdio_ops.c |   40 ++++++++++++++++++++++++++++++++++++++++
>  drivers/mmc/core/sdio_ops.h |    1 +
>  3 files changed, 42 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mmc/core/sdio_irq.c b/drivers/mmc/core/sdio_irq.c
> index 68f81b9..67f782a 100644
> --- a/drivers/mmc/core/sdio_irq.c
> +++ b/drivers/mmc/core/sdio_irq.c
> @@ -44,7 +44,7 @@ static int process_sdio_pending_irqs(struct mmc_card *card)
>  		return 1;
>  	}
>  
> -	ret = mmc_io_rw_direct(card, 0, 0, SDIO_CCCR_INTx, 0, &pending);
> +	ret = mmc_io_rw_direct_irq(card, &pending);
>  	if (ret) {
>  		pr_debug("%s: error %d reading SDIO_CCCR_INTx\n",
>  		       mmc_card_id(card), ret);
> diff --git a/drivers/mmc/core/sdio_ops.c b/drivers/mmc/core/sdio_ops.c
> index b0517cc..c80fc32 100644
> --- a/drivers/mmc/core/sdio_ops.c
> +++ b/drivers/mmc/core/sdio_ops.c
> @@ -111,6 +111,46 @@ static int mmc_io_rw_direct_host(struct mmc_host *host, int write, unsigned fn,
>  	return 0;
>  }
>  
> +static struct mmc_command sdio_intx_cmd = {
> +	.opcode = SD_IO_RW_DIRECT,
> +	.arg = SDIO_CCCR_INTx << 9,
> +	.flags = MMC_RSP_SPI_R5 | MMC_RSP_R5 | MMC_CMD_AC,
> +};
> +
> +int mmc_io_rw_direct_irq(struct mmc_card *card, u8 *out)
> +{
> +	int err;
> +	struct mmc_host *host ;
> +
> +	BUG_ON(!card);
> +	host = card->host;
> +	BUG_ON(!host);
> +
> +	err = mmc_wait_for_cmd(host, &sdio_intx_cmd, 0);
> +	if (err)
> +		return err;
> +
> +	if (mmc_host_is_spi(host)) {
> +		/* host driver already reported errors */
> +	} else {
> +		if (sdio_intx_cmd.resp[0] & R5_ERROR)
> +			return -EIO;
> +		if (sdio_intx_cmd.resp[0] & R5_FUNCTION_NUMBER)
> +			return -EINVAL;
> +		if (sdio_intx_cmd.resp[0] & R5_OUT_OF_RANGE)
> +			return -ERANGE;
> +	}
> +
> +	if (out) {
> +		if (mmc_host_is_spi(host))
> +			*out = (sdio_intx_cmd.resp[0] >> 8) & 0xFF;
> +		else
> +			*out = sdio_intx_cmd.resp[0] & 0xFF;
> +	}
> +
> +	return 0;
> +}
> +
>  int mmc_io_rw_direct(struct mmc_card *card, int write, unsigned fn,
>  	unsigned addr, u8 in, u8 *out)
>  {
> diff --git a/drivers/mmc/core/sdio_ops.h b/drivers/mmc/core/sdio_ops.h
> index 12a4d3a..5fe8ad6 100644
> --- a/drivers/mmc/core/sdio_ops.h
> +++ b/drivers/mmc/core/sdio_ops.h
> @@ -15,6 +15,7 @@
>  int mmc_send_io_op_cond(struct mmc_host *host, u32 ocr, u32 *rocr);
>  int mmc_io_rw_direct(struct mmc_card *card, int write, unsigned fn,
>  	unsigned addr, u8 in, u8* out);
> +int mmc_io_rw_direct_irq(struct mmc_card *card, u8 *out);
>  int mmc_io_rw_extended(struct mmc_card *card, int write, unsigned fn,
>  	unsigned addr, int incr_addr, u8 *buf, unsigned blocks, unsigned blksz);
>  int sdio_reset(struct mmc_host *host);
> -- 
> 1.7.4.1
> 
