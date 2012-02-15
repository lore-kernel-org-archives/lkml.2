Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab2BOT4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 14:56:04 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35933 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab2BOT4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 14:56:01 -0500
Date: Wed, 15 Feb 2012 11:55:53 -0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Huang Shijie <b32955@freescale.com>
Cc: vinod.koul@intel.com, artem.bityutskiy@intel.com, w.sang@pengutronix.de,
        LW@KARO-electronics.de, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com, cjb@laptop.org, linux-arm-kernel@lists.infradead.org,
        linux-mtd@lists.infradead.org, linux-mmc@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/2] mxs-dma : rewrite the last parameter of
 mxs_dma_prep_slave_sg()
Message-ID: <20120215195552.GB2399@r65073-Latitude-D630>
References: <1329110756-14434-1-git-send-email-b32955@freescale.com>
 <1329110756-14434-3-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329110756-14434-3-git-send-email-b32955@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 01:25:56PM +0800, Huang Shijie wrote:
> [1] Background :
>     The GPMI does ECC read page operation with a DMA chain consist of three DMA
>     Command Structures. The middle one of the chain is used to enable the BCH,
>     and read out the NAND page.
> 
>     The WAIT4END(wait for command end) is a comunication signal between
>     the GPMI and MXS-DMA.
> 
> [2] The current DMA code sets the WAIT4END bit at the last one, such as:
> 
>     +-----+               +-----+                      +-----+
>     | cmd | ------------> | cmd | ------------------>  | cmd |
>     +-----+               +-----+                      +-----+
>                                                           ^
>                                                           |
>                                                           |
>                                                      set WAIT4END here
> 
>     This chain works fine in the mx23/mx28.
> 
> [3] But in the new GPMI version (used in MX50/MX60), the WAIT4END bit should
>     be set not only at the last DMA Command Structure,
>     but also at the middle one, such as:
> 
>     +-----+               +-----+                      +-----+
>     | cmd | ------------> | cmd | ------------------>  | cmd |
>     +-----+               +-----+                      +-----+
>                              ^                            ^
>                              |                            |
>                              |                            |
>                         set WAIT4END here too        set WAIT4END here
> 
>     If we do not set WAIT4END, the BCH maybe stalls in "ECC reading page" state.
>     In the next ECC write page operation, a DMA-timeout occurs.
>     This has been catched in the MX6Q board.
> 
> [4] In order to fix the bug, rewrite the last parameter of mxs_dma_prep_slave_sg(),
>     and use the dma_ctrl_flags:
>     ---------------------------------------------------------
>       DMA_PREP_INTERRUPT : append a new DMA Command Structrue.
>       DMA_CTRL_ACK       : set the WAIT4END bit for this DMA Command Structure.
>     ---------------------------------------------------------
> 
> [5] changes to the relative drivers:
>     <1> For mxs-mmc driver, just use the new flags, do not change any logic.
>     <2> For gpmi-nand driver, and use the new flags to set the DMA chain for
>         ecc read page.
> 
> Signed-off-by: Huang Shijie <b32955@freescale.com>
> ---
>  drivers/dma/mxs-dma.c                 |   32 ++++++++++++++++++++++++++++----
>  drivers/mmc/host/mxs-mmc.c            |   10 +++++-----
>  drivers/mtd/nand/gpmi-nand/gpmi-lib.c |   19 +++++++++++++------
>  3 files changed, 46 insertions(+), 15 deletions(-)
> 
I'm trying to give it a test.  But it does not apply on either mainline
or next tree.  You probably had a wrong base for this patch.

> diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
> index 0afcedb..0ddfd30 100644
> --- a/drivers/dma/mxs-dma.c
> +++ b/drivers/dma/mxs-dma.c
> @@ -349,10 +349,32 @@ static void mxs_dma_free_chan_resources(struct dma_chan *chan)
>  	clk_disable_unprepare(mxs_dma->clk);
>  }
>  
> +/*
> + * How to use the flags for ->device_prep_slave_sg() :
> + *    [1] If there is only one DMA command in the DMA chain, the code should be:
> + *            ......
> + *            ->device_prep_slave_sg(DMA_CTRL_ACK);
> + *            ......
> + *    [2] If there are two DMA commands in the DMA chain, the code should be
> + *            ......
> + *            ->device_prep_slave_sg(0);
> + *            ......
> + *            ->device_prep_slave_sg(DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
> + *            ......
> + *    [3] If there are more than two DMA commands in the DMA chain, the code
> + *        should be:
> + *            ......
> + *            ->device_prep_slave_sg(0);                                // First
> + *            ......
> + *            ->device_prep_slave_sg(DMA_PREP_INTERRUPT [| DMA_CTRL_ACK]);
> + *            ......
> + *            ->device_prep_slave_sg(DMA_PREP_INTERRUPT | DMA_CTRL_ACK); // Last
> + *            ......
> + */
>  static struct dma_async_tx_descriptor *mxs_dma_prep_slave_sg(
>  		struct dma_chan *chan, struct scatterlist *sgl,
>  		unsigned int sg_len, enum dma_transfer_direction direction,
> -		unsigned long append)
> +		unsigned long flags)
>  {
>  	struct mxs_dma_chan *mxs_chan = to_mxs_dma_chan(chan);
>  	struct mxs_dma_engine *mxs_dma = mxs_chan->mxs_dma;
> @@ -360,6 +382,7 @@ static struct dma_async_tx_descriptor *mxs_dma_prep_slave_sg(
>  	struct scatterlist *sg;
>  	int i, j;
>  	u32 *pio;
> +	bool append = flags & DMA_PREP_INTERRUPT;
>  	int idx = append ? mxs_chan->desc_count : 0;
>  
>  	if (mxs_chan->status == DMA_IN_PROGRESS && !append)
> @@ -386,7 +409,6 @@ static struct dma_async_tx_descriptor *mxs_dma_prep_slave_sg(
>  		ccw->bits |= CCW_CHAIN;
>  		ccw->bits &= ~CCW_IRQ;
>  		ccw->bits &= ~CCW_DEC_SEM;
> -		ccw->bits &= ~CCW_WAIT4END;
>  	} else {
>  		idx = 0;
>  	}
> @@ -401,7 +423,8 @@ static struct dma_async_tx_descriptor *mxs_dma_prep_slave_sg(
>  		ccw->bits = 0;
>  		ccw->bits |= CCW_IRQ;
>  		ccw->bits |= CCW_DEC_SEM;
> -		ccw->bits |= CCW_WAIT4END;
> +		if (flags & DMA_CTRL_ACK)
> +			ccw->bits |= CCW_WAIT4END;
>  		ccw->bits |= CCW_HALT_ON_TERM;
>  		ccw->bits |= CCW_TERM_FLUSH;
>  		ccw->bits |= BF_CCW(sg_len, PIO_NUM);
> @@ -432,7 +455,8 @@ static struct dma_async_tx_descriptor *mxs_dma_prep_slave_sg(
>  				ccw->bits &= ~CCW_CHAIN;
>  				ccw->bits |= CCW_IRQ;
>  				ccw->bits |= CCW_DEC_SEM;
> -				ccw->bits |= CCW_WAIT4END;
> +				if (flags & DMA_CTRL_ACK)
> +					ccw->bits |= CCW_WAIT4END;
>  			}
>  		}
>  	}
> diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
> index e5ea2b1..4062812 100644
> --- a/drivers/mmc/host/mxs-mmc.c
> +++ b/drivers/mmc/host/mxs-mmc.c
> @@ -305,7 +305,7 @@ static irqreturn_t mxs_mmc_irq_handler(int irq, void *dev_id)
>  }
>  
>  static struct dma_async_tx_descriptor *mxs_mmc_prep_dma(
> -	struct mxs_mmc_host *host, unsigned int append)
> +	struct mxs_mmc_host *host, unsigned long flags)
>  {
>  	struct dma_async_tx_descriptor *desc;
>  	struct mmc_data *data = host->data;
> @@ -325,7 +325,7 @@ static struct dma_async_tx_descriptor *mxs_mmc_prep_dma(
>  	}
>  
>  	desc = host->dmach->device->device_prep_slave_sg(host->dmach,
> -				sgl, sg_len, host->slave_dirn, append);
> +				sgl, sg_len, host->slave_dirn, flags);
>  	if (desc) {
>  		desc->callback = mxs_mmc_dma_irq_callback;
>  		desc->callback_param = host;
> @@ -358,7 +358,7 @@ static void mxs_mmc_bc(struct mxs_mmc_host *host)
>  	host->ssp_pio_words[2] = cmd1;
>  	host->dma_dir = DMA_NONE;
>  	host->slave_dirn = DMA_TRANS_NONE;
> -	desc = mxs_mmc_prep_dma(host, 0);
> +	desc = mxs_mmc_prep_dma(host, DMA_CTRL_ACK);
>  	if (!desc)
>  		goto out;
>  
> @@ -398,7 +398,7 @@ static void mxs_mmc_ac(struct mxs_mmc_host *host)
>  	host->ssp_pio_words[2] = cmd1;
>  	host->dma_dir = DMA_NONE;
>  	host->slave_dirn = DMA_TRANS_NONE;
> -	desc = mxs_mmc_prep_dma(host, 0);
> +	desc = mxs_mmc_prep_dma(host, DMA_CTRL_ACK);
>  	if (!desc)
>  		goto out;
>  
> @@ -526,7 +526,7 @@ static void mxs_mmc_adtc(struct mxs_mmc_host *host)
>  	host->data = data;
>  	host->dma_dir = dma_data_dir;
>  	host->slave_dirn = slave_dirn;
> -	desc = mxs_mmc_prep_dma(host, 1);
> +	desc = mxs_mmc_prep_dma(host, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>  	if (!desc)
>  		goto out;
>  
> diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
> index cbcf022..420ca08 100644
> --- a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
> +++ b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
> @@ -850,7 +850,9 @@ int gpmi_send_command(struct gpmi_nand_data *this)
>  	sg_init_one(sgl, this->cmd_buffer, this->command_length);
>  	dma_map_sg(this->dev, sgl, 1, DMA_TO_DEVICE);
>  	desc = channel->device->device_prep_slave_sg(channel,
> -					sgl, 1, DMA_MEM_TO_DEV, 1);
> +				sgl, 1, DMA_MEM_TO_DEV,
> +				DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
> +
>  	if (!desc) {
>  		pr_err("step 2 error\n");
>  		return -1;
> @@ -892,7 +894,8 @@ int gpmi_send_data(struct gpmi_nand_data *this)
>  	/* [2] send DMA request */
>  	prepare_data_dma(this, DMA_TO_DEVICE);
>  	desc = channel->device->device_prep_slave_sg(channel, &this->data_sgl,
> -						1, DMA_MEM_TO_DEV, 1);
> +					1, DMA_MEM_TO_DEV,
> +					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>  	if (!desc) {
>  		pr_err("step 2 error\n");
>  		return -1;
> @@ -928,7 +931,8 @@ int gpmi_read_data(struct gpmi_nand_data *this)
>  	/* [2] : send DMA request */
>  	prepare_data_dma(this, DMA_FROM_DEVICE);
>  	desc = channel->device->device_prep_slave_sg(channel, &this->data_sgl,
> -						1, DMA_DEV_TO_MEM, 1);
> +					1, DMA_DEV_TO_MEM,
> +					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>  	if (!desc) {
>  		pr_err("step 2 error\n");
>  		return -1;
> @@ -975,7 +979,8 @@ int gpmi_send_page(struct gpmi_nand_data *this,
>  
>  	desc = channel->device->device_prep_slave_sg(channel,
>  					(struct scatterlist *)pio,
> -					ARRAY_SIZE(pio), DMA_TRANS_NONE, 0);
> +					ARRAY_SIZE(pio), DMA_TRANS_NONE,
> +					DMA_CTRL_ACK);
>  	if (!desc) {
>  		pr_err("step 2 error\n");
>  		return -1;
> @@ -1039,7 +1044,8 @@ int gpmi_read_page(struct gpmi_nand_data *this,
>  	pio[5] = auxiliary;
>  	desc = channel->device->device_prep_slave_sg(channel,
>  					(struct scatterlist *)pio,
> -					ARRAY_SIZE(pio), DMA_TRANS_NONE, 1);
> +					ARRAY_SIZE(pio), DMA_TRANS_NONE,
> +					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>  	if (!desc) {
>  		pr_err("step 2 error\n");
>  		return -1;
> @@ -1059,7 +1065,8 @@ int gpmi_read_page(struct gpmi_nand_data *this,
>  	pio[2] = 0; /* Set GPMI_HW_GPMI_ECCCTRL, disable the BCH. */
>  	desc = channel->device->device_prep_slave_sg(channel,
>  				(struct scatterlist *)pio, 3,

I have the mainline code show above line as 

                                (struct scatterlist *)pio, 2,

That's why I think you got a wrong base.  But I tested it with manually
applying it.  So other than the base issue,

Acked-by: Shawn Guo <shawn.guo@linaro.org>

Regards,
Shawn

> -				DMA_TRANS_NONE, 1);
> +				DMA_TRANS_NONE,
> +				DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>  	if (!desc) {
>  		pr_err("step 3 error\n");
>  		return -1;
> -- 
> 1.7.0.4
> 
> 
