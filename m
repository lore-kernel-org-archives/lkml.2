Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328Ab2BCB4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 20:56:13 -0500
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:50293
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754920Ab2BCB4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 20:56:10 -0500
X-SpamScore: -3
X-BigFish: VS-3(zz1432Nzz1202h1082kzz8275bhz2dh2a8h668h839h941h35h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4F2B3F20.3060401@freescale.com>
Date: Fri, 3 Feb 2012 09:57:52 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Huang Shijie <b32955@freescale.com>
CC: <vinod.koul@intel.com>, <shawn.guo@linaro.org>,
        <artem.bityutskiy@intel.com>, <shijie8@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <w.sang@pengutronix.de>,
        <LW@KARO-electronics.de>, <alsa-devel@alsa-project.org>,
        <b29396@freescale.com>
Subject: Re: [PATCH v2 2/2] mxs-dma : rewrite the last parameter of mxs_dma_prep_slave_sg()
References: <1327044818-4464-1-git-send-email-b32955@freescale.com> <1327044818-4464-3-git-send-email-b32955@freescale.com>
In-Reply-To: <1327044818-4464-3-git-send-email-b32955@freescale.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Due the DMA api changes, please ignore this patch.


thanks

Huang Shijie
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
>     <2> For gpmi-nand driver, add new field `gpmi_version` to distinguish
>         different gpmi versions, and use the new flags.
>
> Signed-off-by: Huang Shijie <b32955@freescale.com>
> ---
>  drivers/dma/mxs-dma.c                  |   32 ++++++++++++++++++++++++++++----
>  drivers/mmc/host/mxs-mmc.c             |   10 +++++-----
>  drivers/mtd/nand/gpmi-nand/gpmi-lib.c  |   28 ++++++++++++++++++++++------
>  drivers/mtd/nand/gpmi-nand/gpmi-nand.h |    4 ++++
>  drivers/mtd/nand/gpmi-nand/gpmi-regs.h |    2 ++
>  5 files changed, 61 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
> index c80fbed..7d7498b 100644
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
> index 1e18970..120669b 100644
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
> index 7f68042..2029995 100644
> --- a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
> +++ b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
> @@ -133,6 +133,9 @@ int gpmi_init(struct gpmi_nand_data *this)
>  	if (ret)
>  		goto err_out;
>  
> +	/* Read out the GPMI version */
> +	this->gpmi_version = readl(r->gpmi_regs + HW_GPMI_VERSION);
> +
>  	/* Choose NAND mode. */
>  	writel(BM_GPMI_CTRL1_GPMI_MODE, r->gpmi_regs + HW_GPMI_CTRL1_CLR);
>  
> @@ -839,7 +842,9 @@ int gpmi_send_command(struct gpmi_nand_data *this)
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
> @@ -881,7 +886,8 @@ int gpmi_send_data(struct gpmi_nand_data *this)
>  	/* [2] send DMA request */
>  	prepare_data_dma(this, DMA_TO_DEVICE);
>  	desc = channel->device->device_prep_slave_sg(channel, &this->data_sgl,
> -						1, DMA_MEM_TO_DEV, 1);
> +					1, DMA_MEM_TO_DEV,
> +					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>  	if (!desc) {
>  		pr_err("step 2 error\n");
>  		return -1;
> @@ -917,7 +923,8 @@ int gpmi_read_data(struct gpmi_nand_data *this)
>  	/* [2] : send DMA request */
>  	prepare_data_dma(this, DMA_FROM_DEVICE);
>  	desc = channel->device->device_prep_slave_sg(channel, &this->data_sgl,
> -						1, DMA_DEV_TO_MEM, 1);
> +					1, DMA_DEV_TO_MEM,
> +					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>  	if (!desc) {
>  		pr_err("step 2 error\n");
>  		return -1;
> @@ -964,7 +971,8 @@ int gpmi_send_page(struct gpmi_nand_data *this,
>  
>  	desc = channel->device->device_prep_slave_sg(channel,
>  					(struct scatterlist *)pio,
> -					ARRAY_SIZE(pio), DMA_TRANS_NONE, 0);
> +					ARRAY_SIZE(pio), DMA_TRANS_NONE,
> +					DMA_CTRL_ACK);
>  	if (!desc) {
>  		pr_err("step 2 error\n");
>  		return -1;
> @@ -984,6 +992,7 @@ int gpmi_read_page(struct gpmi_nand_data *this,
>  	struct dma_async_tx_descriptor *desc;
>  	struct dma_chan *channel = get_dma_chan(this);
>  	int chip = this->current_chip;
> +	unsigned long flags;
>  	u32 pio[6];
>  
>  	/* [1] Wait for the chip to report ready. */
> @@ -1026,9 +1035,14 @@ int gpmi_read_page(struct gpmi_nand_data *this,
>  	pio[3] = geo->page_size;
>  	pio[4] = payload;
>  	pio[5] = auxiliary;
> +
> +	/* Check GPMI's version, set DMA_CTRL_ACK if needed. */
> +	flags = DMA_PREP_INTERRUPT;
> +	if (this->gpmi_version == GPMI_VERSION_0501)
> +		flags |= DMA_CTRL_ACK;
>  	desc = channel->device->device_prep_slave_sg(channel,
>  					(struct scatterlist *)pio,
> -					ARRAY_SIZE(pio), DMA_TRANS_NONE, 1);
> +					ARRAY_SIZE(pio), DMA_TRANS_NONE, flags);
>  	if (!desc) {
>  		pr_err("step 2 error\n");
>  		return -1;
> @@ -1045,9 +1059,11 @@ int gpmi_read_page(struct gpmi_nand_data *this,
>  		| BF_GPMI_CTRL0_ADDRESS(address)
>  		| BF_GPMI_CTRL0_XFER_COUNT(geo->page_size);
>  	pio[1] = 0;
> +	pio[2] = 0;
>  	desc = channel->device->device_prep_slave_sg(channel,
>  				(struct scatterlist *)pio, 2,
> -				DMA_TRANS_NONE, 1);
> +				DMA_TRANS_NONE,
> +				DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>  	if (!desc) {
>  		pr_err("step 3 error\n");
>  		return -1;
> diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.h b/drivers/mtd/nand/gpmi-nand/gpmi-nand.h
> index 1c7fdbb..5c277e3 100644
> --- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.h
> +++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.h
> @@ -132,6 +132,10 @@ struct gpmi_nand_data {
>  	/* Flash Hardware */
>  	struct nand_timing	timing;
>  
> +	/* GPMI hardware version */
> +#define GPMI_VERSION_0501	(0x05010000)
> +	u32			gpmi_version;
> +
>  	/* BCH */
>  	struct bch_geometry	bch_geometry;
>  	struct completion	bch_done;
> diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-regs.h b/drivers/mtd/nand/gpmi-nand/gpmi-regs.h
> index 8343124..f005b24 100644
> --- a/drivers/mtd/nand/gpmi-nand/gpmi-regs.h
> +++ b/drivers/mtd/nand/gpmi-nand/gpmi-regs.h
> @@ -169,4 +169,6 @@
>  #define HW_GPMI_DEBUG					0x000000c0
>  #define MX23_BP_GPMI_DEBUG_READY0			28
>  #define MX23_BM_GPMI_DEBUG_READY0	(1 << MX23_BP_GPMI_DEBUG_READY0)
> +
> +#define HW_GPMI_VERSION					0x000000d0
>  #endif


