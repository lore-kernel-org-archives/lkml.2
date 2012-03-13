Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab2CMEQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 00:16:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:10332 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016Ab2CMEQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 00:16:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="137803977"
Subject: Re: [PATCH 1/2 V2] dmaengine/dma_slave: introduce inline wrappers
From: Vinod Koul <vinod.koul@intel.com>
To: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: dan.j.williams@intel.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, jaswinder.singh@linaro.org,
        linus.walleij@stericsson.com, leoli@freescale.com, zw@zh-kernel.org,
        STEricsson_nomadik_linux@list.st.com, ben-linux@fluff.org,
        kgene.kim@samsung.com, mchehab@infradead.org,
        ludovic.desroches@atmel.com, cjb@laptop.org, g.liakhovetski@gmx.de,
        ian@mnementh.co.uk, dwmw2@infradead.org, grant.likely@secretlab.ca,
        alan@linux.intel.com, balbi@ti.com, FlorianSchandinat@gmx.de,
        perex@perex.cz, tiwai@suse.de, viresh.kumar@st.com,
        baohua.song@csr.com, srinidhi.kasagar@stericsson.com
In-Reply-To: <1331241078-29977-1-git-send-email-alexandre.bounine@idt.com>
References: <1331241078-29977-1-git-send-email-alexandre.bounine@idt.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Mar 2012 09:52:22 +0530
Message-ID: <1331612542.1727.12.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-08 at 16:11 -0500, Alexandre Bounine wrote:
> Add inline wrappers for device_prep_slave_sg() and device_prep_dma_cyclic()
> interfaces to hide new parameter from current users of affected interfaces.
> Convert current users to use new wrappers instead of direct calls.
> Suggested by Russell King [https://lkml.org/lkml/2012/2/3/269].
> 
> Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
It would have been better if this patch was split to 
1 dmaengine changes
2...n: respective client driver changes

Nevertheless, changes look good otherwise. If all other subsystem
maintainers agree (with their ACK) then we could merge this one

> ---
>  arch/arm/plat-nomadik/include/plat/ste_dma40.h |    3 +-
>  arch/arm/plat-samsung/dma-ops.c                |    4 +-
>  drivers/media/video/mx3_camera.c               |    2 +-
>  drivers/media/video/timblogiw.c                |    2 +-
>  drivers/mmc/host/atmel-mci.c                   |    2 +-
>  drivers/mmc/host/mmci.c                        |    2 +-
>  drivers/mmc/host/mxcmmc.c                      |    2 +-
>  drivers/mmc/host/mxs-mmc.c                     |    2 +-
>  drivers/mmc/host/sh_mmcif.c                    |    4 +-
>  drivers/mmc/host/tmio_mmc_dma.c                |    4 +-
>  drivers/mtd/nand/gpmi-nand/gpmi-lib.c          |   25 ++++++++++-------------
>  drivers/net/ethernet/micrel/ks8842.c           |    4 +-
>  drivers/spi/spi-dw-mid.c                       |    4 +-
>  drivers/spi/spi-ep93xx.c                       |    4 +-
>  drivers/spi/spi-pl022.c                        |    4 +-
>  drivers/spi/spi-topcliff-pch.c                 |    4 +-
>  drivers/tty/serial/amba-pl011.c                |    6 +---
>  drivers/tty/serial/pch_uart.c                  |    4 +-
>  drivers/tty/serial/sh-sci.c                    |    4 +-
>  drivers/usb/musb/ux500_dma.c                   |    3 +-
>  drivers/usb/renesas_usbhs/fifo.c               |    5 +--
>  drivers/video/mx3fb.c                          |    4 +-
>  include/linux/dmaengine.h                      |   16 +++++++++++++++
>  sound/soc/ep93xx/ep93xx-pcm.c                  |    3 +-
>  sound/soc/imx/imx-pcm-dma-mx2.c                |    2 +-
>  sound/soc/mxs/mxs-pcm.c                        |    2 +-
>  sound/soc/sh/siu_pcm.c                         |    4 +-
>  sound/soc/txx9/txx9aclc.c                      |    2 +-
>  28 files changed, 67 insertions(+), 60 deletions(-)
> 
> diff --git a/arch/arm/plat-nomadik/include/plat/ste_dma40.h b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
> index fd0ee84..9ff93b0 100644
> --- a/arch/arm/plat-nomadik/include/plat/ste_dma40.h
> +++ b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
> @@ -200,8 +200,7 @@ dma_async_tx_descriptor *stedma40_slave_mem(struct dma_chan *chan,
>  	sg.dma_address = addr;
>  	sg.length = size;
>  
> -	return chan->device->device_prep_slave_sg(chan, &sg, 1,
> -						  direction, flags);
> +	return dmaengine_prep_slave_sg(chan, &sg, 1, direction, flags);
>  }
>  
>  #else
> diff --git a/arch/arm/plat-samsung/dma-ops.c b/arch/arm/plat-samsung/dma-ops.c
> index 0747c77..a6ef396 100644
> --- a/arch/arm/plat-samsung/dma-ops.c
> +++ b/arch/arm/plat-samsung/dma-ops.c
> @@ -79,11 +79,11 @@ static int samsung_dmadev_prepare(unsigned ch,
>  			    info->len, offset_in_page(info->buf));
>  		sg_dma_address(&sg) = info->buf;
>  
> -		desc = chan->device->device_prep_slave_sg(chan,
> +		desc = dmaengine_prep_slave_sg(chan,
>  			&sg, 1, info->direction, DMA_PREP_INTERRUPT);
>  		break;
>  	case DMA_CYCLIC:
> -		desc = chan->device->device_prep_dma_cyclic(chan,
> +		desc = dmaengine_prep_dma_cyclic(chan,
>  			info->buf, info->len, info->period, info->direction);
>  		break;
>  	default:
> diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
> index 7452277..93c35ef 100644
> --- a/drivers/media/video/mx3_camera.c
> +++ b/drivers/media/video/mx3_camera.c
> @@ -286,7 +286,7 @@ static void mx3_videobuf_queue(struct vb2_buffer *vb)
>  		sg_dma_address(sg)	= vb2_dma_contig_plane_dma_addr(vb, 0);
>  		sg_dma_len(sg)		= new_size;
>  
> -		txd = ichan->dma_chan.device->device_prep_slave_sg(
> +		txd = dmaengine_prep_slave_sg(
>  			&ichan->dma_chan, sg, 1, DMA_DEV_TO_MEM,
>  			DMA_PREP_INTERRUPT);
>  		if (!txd)
> diff --git a/drivers/media/video/timblogiw.c b/drivers/media/video/timblogiw.c
> index 4ed1c7c2..02194c0 100644
> --- a/drivers/media/video/timblogiw.c
> +++ b/drivers/media/video/timblogiw.c
> @@ -564,7 +564,7 @@ static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
>  
>  	spin_unlock_irq(&fh->queue_lock);
>  
> -	desc = fh->chan->device->device_prep_slave_sg(fh->chan,
> +	desc = dmaengine_prep_slave_sg(fh->chan,
>  		buf->sg, sg_elems, DMA_DEV_TO_MEM,
>  		DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_SRC_UNMAP);
>  	if (!desc) {
> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
> index e4449a5..f658348 100644
> --- a/drivers/mmc/host/atmel-mci.c
> +++ b/drivers/mmc/host/atmel-mci.c
> @@ -872,7 +872,7 @@ atmci_prepare_data_dma(struct atmel_mci *host, struct mmc_data *data)
>  	sglen = dma_map_sg(chan->device->dev, data->sg,
>  			data->sg_len, direction);
>  
> -	desc = chan->device->device_prep_slave_sg(chan,
> +	desc = dmaengine_prep_slave_sg(chan,
>  			data->sg, sglen, slave_dirn,
>  			DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>  	if (!desc)
> diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
> index 11e589c..31747f9 100644
> --- a/drivers/mmc/host/mmci.c
> +++ b/drivers/mmc/host/mmci.c
> @@ -411,7 +411,7 @@ static int mmci_dma_prep_data(struct mmci_host *host, struct mmc_data *data,
>  		return -EINVAL;
>  
>  	dmaengine_slave_config(chan, &conf);
> -	desc = device->device_prep_slave_sg(chan, data->sg, nr_sg,
> +	desc = dmaengine_prep_slave_sg(chan, data->sg, nr_sg,
>  					    conf.direction, DMA_CTRL_ACK);
>  	if (!desc)
>  		goto unmap_exit;
> diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
> index 4184b79..411a79e 100644
> --- a/drivers/mmc/host/mxcmmc.c
> +++ b/drivers/mmc/host/mxcmmc.c
> @@ -254,7 +254,7 @@ static int mxcmci_setup_data(struct mxcmci_host *host, struct mmc_data *data)
>  	if (nents != data->sg_len)
>  		return -EINVAL;
>  
> -	host->desc = host->dma->device->device_prep_slave_sg(host->dma,
> +	host->desc = dmaengine_prep_slave_sg(host->dma,
>  		data->sg, data->sg_len, slave_dirn,
>  		DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>  
> diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
> index 382c835..65f36cf 100644
> --- a/drivers/mmc/host/mxs-mmc.c
> +++ b/drivers/mmc/host/mxs-mmc.c
> @@ -324,7 +324,7 @@ static struct dma_async_tx_descriptor *mxs_mmc_prep_dma(
>  		sg_len = SSP_PIO_NUM;
>  	}
>  
> -	desc = host->dmach->device->device_prep_slave_sg(host->dmach,
> +	desc = dmaengine_prep_slave_sg(host->dmach,
>  				sgl, sg_len, host->slave_dirn, append);
>  	if (desc) {
>  		desc->callback = mxs_mmc_dma_irq_callback;
> diff --git a/drivers/mmc/host/sh_mmcif.c b/drivers/mmc/host/sh_mmcif.c
> index 352d479..4002a82 100644
> --- a/drivers/mmc/host/sh_mmcif.c
> +++ b/drivers/mmc/host/sh_mmcif.c
> @@ -285,7 +285,7 @@ static void sh_mmcif_start_dma_rx(struct sh_mmcif_host *host)
>  			 DMA_FROM_DEVICE);
>  	if (ret > 0) {
>  		host->dma_active = true;
> -		desc = chan->device->device_prep_slave_sg(chan, sg, ret,
> +		desc = dmaengine_prep_slave_sg(chan, sg, ret,
>  			DMA_DEV_TO_MEM, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>  	}
>  
> @@ -334,7 +334,7 @@ static void sh_mmcif_start_dma_tx(struct sh_mmcif_host *host)
>  			 DMA_TO_DEVICE);
>  	if (ret > 0) {
>  		host->dma_active = true;
> -		desc = chan->device->device_prep_slave_sg(chan, sg, ret,
> +		desc = dmaengine_prep_slave_sg(chan, sg, ret,
>  			DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>  	}
>  
> diff --git a/drivers/mmc/host/tmio_mmc_dma.c b/drivers/mmc/host/tmio_mmc_dma.c
> index 8253ec1..fff9286 100644
> --- a/drivers/mmc/host/tmio_mmc_dma.c
> +++ b/drivers/mmc/host/tmio_mmc_dma.c
> @@ -88,7 +88,7 @@ static void tmio_mmc_start_dma_rx(struct tmio_mmc_host *host)
>  
>  	ret = dma_map_sg(chan->device->dev, sg, host->sg_len, DMA_FROM_DEVICE);
>  	if (ret > 0)
> -		desc = chan->device->device_prep_slave_sg(chan, sg, ret,
> +		desc = dmaengine_prep_slave_sg(chan, sg, ret,
>  			DMA_DEV_TO_MEM, DMA_CTRL_ACK);
>  
>  	if (desc) {
> @@ -169,7 +169,7 @@ static void tmio_mmc_start_dma_tx(struct tmio_mmc_host *host)
>  
>  	ret = dma_map_sg(chan->device->dev, sg, host->sg_len, DMA_TO_DEVICE);
>  	if (ret > 0)
> -		desc = chan->device->device_prep_slave_sg(chan, sg, ret,
> +		desc = dmaengine_prep_slave_sg(chan, sg, ret,
>  			DMA_MEM_TO_DEV, DMA_CTRL_ACK);
>  
>  	if (desc) {
> diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
> index 7db6555..590dd5c 100644
> --- a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
> +++ b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
> @@ -835,7 +835,7 @@ int gpmi_send_command(struct gpmi_nand_data *this)
>  		| BM_GPMI_CTRL0_ADDRESS_INCREMENT
>  		| BF_GPMI_CTRL0_XFER_COUNT(this->command_length);
>  	pio[1] = pio[2] = 0;
> -	desc = channel->device->device_prep_slave_sg(channel,
> +	desc = dmaengine_prep_slave_sg(channel,
>  					(struct scatterlist *)pio,
>  					ARRAY_SIZE(pio), DMA_TRANS_NONE, 0);
>  	if (!desc) {
> @@ -848,8 +848,7 @@ int gpmi_send_command(struct gpmi_nand_data *this)
>  
>  	sg_init_one(sgl, this->cmd_buffer, this->command_length);
>  	dma_map_sg(this->dev, sgl, 1, DMA_TO_DEVICE);
> -	desc = channel->device->device_prep_slave_sg(channel,
> -					sgl, 1, DMA_MEM_TO_DEV, 1);
> +	desc = dmaengine_prep_slave_sg(channel, sgl, 1, DMA_MEM_TO_DEV, 1);
>  	if (!desc) {
>  		pr_err("step 2 error\n");
>  		return -1;
> @@ -880,8 +879,7 @@ int gpmi_send_data(struct gpmi_nand_data *this)
>  		| BF_GPMI_CTRL0_ADDRESS(address)
>  		| BF_GPMI_CTRL0_XFER_COUNT(this->upper_len);
>  	pio[1] = 0;
> -	desc = channel->device->device_prep_slave_sg(channel,
> -					(struct scatterlist *)pio,
> +	desc = dmaengine_prep_slave_sg(channel, (struct scatterlist *)pio,
>  					ARRAY_SIZE(pio), DMA_TRANS_NONE, 0);
>  	if (!desc) {
>  		pr_err("step 1 error\n");
> @@ -890,7 +888,7 @@ int gpmi_send_data(struct gpmi_nand_data *this)
>  
>  	/* [2] send DMA request */
>  	prepare_data_dma(this, DMA_TO_DEVICE);
> -	desc = channel->device->device_prep_slave_sg(channel, &this->data_sgl,
> +	desc = dmaengine_prep_slave_sg(channel, &this->data_sgl,
>  						1, DMA_MEM_TO_DEV, 1);
>  	if (!desc) {
>  		pr_err("step 2 error\n");
> @@ -916,7 +914,7 @@ int gpmi_read_data(struct gpmi_nand_data *this)
>  		| BF_GPMI_CTRL0_ADDRESS(BV_GPMI_CTRL0_ADDRESS__NAND_DATA)
>  		| BF_GPMI_CTRL0_XFER_COUNT(this->upper_len);
>  	pio[1] = 0;
> -	desc = channel->device->device_prep_slave_sg(channel,
> +	desc = dmaengine_prep_slave_sg(channel,
>  					(struct scatterlist *)pio,
>  					ARRAY_SIZE(pio), DMA_TRANS_NONE, 0);
>  	if (!desc) {
> @@ -926,8 +924,8 @@ int gpmi_read_data(struct gpmi_nand_data *this)
>  
>  	/* [2] : send DMA request */
>  	prepare_data_dma(this, DMA_FROM_DEVICE);
> -	desc = channel->device->device_prep_slave_sg(channel, &this->data_sgl,
> -						1, DMA_DEV_TO_MEM, 1);
> +	desc = dmaengine_prep_slave_sg(channel, &this->data_sgl,
> +					1, DMA_DEV_TO_MEM, 1);
>  	if (!desc) {
>  		pr_err("step 2 error\n");
>  		return -1;
> @@ -972,8 +970,7 @@ int gpmi_send_page(struct gpmi_nand_data *this,
>  	pio[4] = payload;
>  	pio[5] = auxiliary;
>  
> -	desc = channel->device->device_prep_slave_sg(channel,
> -					(struct scatterlist *)pio,
> +	desc = dmaengine_prep_slave_sg(channel, (struct scatterlist *)pio,
>  					ARRAY_SIZE(pio), DMA_TRANS_NONE, 0);
>  	if (!desc) {
>  		pr_err("step 2 error\n");
> @@ -1007,7 +1004,7 @@ int gpmi_read_page(struct gpmi_nand_data *this,
>  		| BF_GPMI_CTRL0_ADDRESS(address)
>  		| BF_GPMI_CTRL0_XFER_COUNT(0);
>  	pio[1] = 0;
> -	desc = channel->device->device_prep_slave_sg(channel,
> +	desc = dmaengine_prep_slave_sg(channel,
>  				(struct scatterlist *)pio, 2,
>  				DMA_TRANS_NONE, 0);
>  	if (!desc) {
> @@ -1036,7 +1033,7 @@ int gpmi_read_page(struct gpmi_nand_data *this,
>  	pio[3] = geo->page_size;
>  	pio[4] = payload;
>  	pio[5] = auxiliary;
> -	desc = channel->device->device_prep_slave_sg(channel,
> +	desc = dmaengine_prep_slave_sg(channel,
>  					(struct scatterlist *)pio,
>  					ARRAY_SIZE(pio), DMA_TRANS_NONE, 1);
>  	if (!desc) {
> @@ -1055,7 +1052,7 @@ int gpmi_read_page(struct gpmi_nand_data *this,
>  		| BF_GPMI_CTRL0_ADDRESS(address)
>  		| BF_GPMI_CTRL0_XFER_COUNT(geo->page_size);
>  	pio[1] = 0;
> -	desc = channel->device->device_prep_slave_sg(channel,
> +	desc = dmaengine_prep_slave_sg(channel,
>  				(struct scatterlist *)pio, 2,
>  				DMA_TRANS_NONE, 1);
>  	if (!desc) {
> diff --git a/drivers/net/ethernet/micrel/ks8842.c b/drivers/net/ethernet/micrel/ks8842.c
> index 0a85690..554fef3 100644
> --- a/drivers/net/ethernet/micrel/ks8842.c
> +++ b/drivers/net/ethernet/micrel/ks8842.c
> @@ -458,7 +458,7 @@ static int ks8842_tx_frame_dma(struct sk_buff *skb, struct net_device *netdev)
>  	if (sg_dma_len(&ctl->sg) % 4)
>  		sg_dma_len(&ctl->sg) += 4 - sg_dma_len(&ctl->sg) % 4;
>  
> -	ctl->adesc = ctl->chan->device->device_prep_slave_sg(ctl->chan,
> +	ctl->adesc = dmaengine_prep_slave_sg(ctl->chan,
>  		&ctl->sg, 1, DMA_MEM_TO_DEV,
>  		DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_SRC_UNMAP);
>  	if (!ctl->adesc)
> @@ -570,7 +570,7 @@ static int __ks8842_start_new_rx_dma(struct net_device *netdev)
>  
>  		sg_dma_len(sg) = DMA_BUFFER_SIZE;
>  
> -		ctl->adesc = ctl->chan->device->device_prep_slave_sg(ctl->chan,
> +		ctl->adesc = dmaengine_prep_slave_sg(ctl->chan,
>  			sg, 1, DMA_DEV_TO_MEM,
>  			DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_SRC_UNMAP);
>  
> diff --git a/drivers/spi/spi-dw-mid.c b/drivers/spi/spi-dw-mid.c
> index 8418eb0..e6afb84 100644
> --- a/drivers/spi/spi-dw-mid.c
> +++ b/drivers/spi/spi-dw-mid.c
> @@ -144,7 +144,7 @@ static int mid_spi_dma_transfer(struct dw_spi *dws, int cs_change)
>  	dws->tx_sgl.dma_address = dws->tx_dma;
>  	dws->tx_sgl.length = dws->len;
>  
> -	txdesc = txchan->device->device_prep_slave_sg(txchan,
> +	txdesc = dmaengine_prep_slave_sg(txchan,
>  				&dws->tx_sgl,
>  				1,
>  				DMA_MEM_TO_DEV,
> @@ -166,7 +166,7 @@ static int mid_spi_dma_transfer(struct dw_spi *dws, int cs_change)
>  	dws->rx_sgl.dma_address = dws->rx_dma;
>  	dws->rx_sgl.length = dws->len;
>  
> -	rxdesc = rxchan->device->device_prep_slave_sg(rxchan,
> +	rxdesc = dmaengine_prep_slave_sg(rxchan,
>  				&dws->rx_sgl,
>  				1,
>  				DMA_DEV_TO_MEM,
> diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
> index d46e55c..6db2887 100644
> --- a/drivers/spi/spi-ep93xx.c
> +++ b/drivers/spi/spi-ep93xx.c
> @@ -633,8 +633,8 @@ ep93xx_spi_dma_prepare(struct ep93xx_spi *espi, enum dma_data_direction dir)
>  	if (!nents)
>  		return ERR_PTR(-ENOMEM);
>  
> -	txd = chan->device->device_prep_slave_sg(chan, sgt->sgl, nents,
> -						 slave_dirn, DMA_CTRL_ACK);
> +	txd = dmaengine_prep_slave_sg(chan, sgt->sgl, nents,
> +					slave_dirn, DMA_CTRL_ACK);
>  	if (!txd) {
>  		dma_unmap_sg(chan->device->dev, sgt->sgl, sgt->nents, dir);
>  		return ERR_PTR(-ENOMEM);
> diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
> index 2f9cb43..94ccede 100644
> --- a/drivers/spi/spi-pl022.c
> +++ b/drivers/spi/spi-pl022.c
> @@ -1038,7 +1038,7 @@ static int configure_dma(struct pl022 *pl022)
>  		goto err_tx_sgmap;
>  
>  	/* Send both scatterlists */
> -	rxdesc = rxchan->device->device_prep_slave_sg(rxchan,
> +	rxdesc = dmaengine_prep_slave_sg(rxchan,
>  				      pl022->sgt_rx.sgl,
>  				      rx_sglen,
>  				      DMA_DEV_TO_MEM,
> @@ -1046,7 +1046,7 @@ static int configure_dma(struct pl022 *pl022)
>  	if (!rxdesc)
>  		goto err_rxdesc;
>  
> -	txdesc = txchan->device->device_prep_slave_sg(txchan,
> +	txdesc = dmaengine_prep_slave_sg(txchan,
>  				      pl022->sgt_tx.sgl,
>  				      tx_sglen,
>  				      DMA_MEM_TO_DEV,
> diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
> index 10182eb..8a06403 100644
> --- a/drivers/spi/spi-topcliff-pch.c
> +++ b/drivers/spi/spi-topcliff-pch.c
> @@ -1078,7 +1078,7 @@ static void pch_spi_handle_dma(struct pch_spi_data *data, int *bpw)
>  		sg_dma_address(sg) = dma->rx_buf_dma + sg->offset;
>  	}
>  	sg = dma->sg_rx_p;
> -	desc_rx = dma->chan_rx->device->device_prep_slave_sg(dma->chan_rx, sg,
> +	desc_rx = dmaengine_prep_slave_sg(dma->chan_rx, sg,
>  					num, DMA_DEV_TO_MEM,
>  					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>  	if (!desc_rx) {
> @@ -1123,7 +1123,7 @@ static void pch_spi_handle_dma(struct pch_spi_data *data, int *bpw)
>  		sg_dma_address(sg) = dma->tx_buf_dma + sg->offset;
>  	}
>  	sg = dma->sg_tx_p;
> -	desc_tx = dma->chan_tx->device->device_prep_slave_sg(dma->chan_tx,
> +	desc_tx = dmaengine_prep_slave_sg(dma->chan_tx,
>  					sg, num, DMA_MEM_TO_DEV,
>  					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>  	if (!desc_tx) {
> diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
> index 6800f5f..3e33bf3 100644
> --- a/drivers/tty/serial/amba-pl011.c
> +++ b/drivers/tty/serial/amba-pl011.c
> @@ -481,7 +481,7 @@ static int pl011_dma_tx_refill(struct uart_amba_port *uap)
>  		return -EBUSY;
>  	}
>  
> -	desc = dma_dev->device_prep_slave_sg(chan, &dmatx->sg, 1, DMA_MEM_TO_DEV,
> +	desc = dmaengine_prep_slave_sg(chan, &dmatx->sg, 1, DMA_MEM_TO_DEV,
>  					     DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>  	if (!desc) {
>  		dma_unmap_sg(dma_dev->dev, &dmatx->sg, 1, DMA_TO_DEVICE);
> @@ -664,7 +664,6 @@ static void pl011_dma_rx_callback(void *data);
>  static int pl011_dma_rx_trigger_dma(struct uart_amba_port *uap)
>  {
>  	struct dma_chan *rxchan = uap->dmarx.chan;
> -	struct dma_device *dma_dev;
>  	struct pl011_dmarx_data *dmarx = &uap->dmarx;
>  	struct dma_async_tx_descriptor *desc;
>  	struct pl011_sgbuf *sgbuf;
> @@ -675,8 +674,7 @@ static int pl011_dma_rx_trigger_dma(struct uart_amba_port *uap)
>  	/* Start the RX DMA job */
>  	sgbuf = uap->dmarx.use_buf_b ?
>  		&uap->dmarx.sgbuf_b : &uap->dmarx.sgbuf_a;
> -	dma_dev = rxchan->device;
> -	desc = rxchan->device->device_prep_slave_sg(rxchan, &sgbuf->sg, 1,
> +	desc = dmaengine_prep_slave_sg(rxchan, &sgbuf->sg, 1,
>  					DMA_DEV_TO_MEM,
>  					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>  	/*
> diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
> index 17ae657..61743bd 100644
> --- a/drivers/tty/serial/pch_uart.c
> +++ b/drivers/tty/serial/pch_uart.c
> @@ -763,7 +763,7 @@ static int dma_handle_rx(struct eg20t_port *priv)
>  
>  	sg_dma_address(sg) = priv->rx_buf_dma;
>  
> -	desc = priv->chan_rx->device->device_prep_slave_sg(priv->chan_rx,
> +	desc = dmaengine_prep_slave_sg(priv->chan_rx,
>  			sg, 1, DMA_DEV_TO_MEM,
>  			DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>  
> @@ -922,7 +922,7 @@ static unsigned int dma_handle_tx(struct eg20t_port *priv)
>  			sg_dma_len(sg) = size;
>  	}
>  
> -	desc = priv->chan_tx->device->device_prep_slave_sg(priv->chan_tx,
> +	desc = dmaengine_prep_slave_sg(priv->chan_tx,
>  					priv->sg_tx_p, nent, DMA_MEM_TO_DEV,
>  					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>  	if (!desc) {
> diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
> index 7508579..872557f 100644
> --- a/drivers/tty/serial/sh-sci.c
> +++ b/drivers/tty/serial/sh-sci.c
> @@ -1338,7 +1338,7 @@ static void sci_submit_rx(struct sci_port *s)
>  		struct scatterlist *sg = &s->sg_rx[i];
>  		struct dma_async_tx_descriptor *desc;
>  
> -		desc = chan->device->device_prep_slave_sg(chan,
> +		desc = dmaengine_prep_slave_sg(chan,
>  			sg, 1, DMA_DEV_TO_MEM, DMA_PREP_INTERRUPT);
>  
>  		if (desc) {
> @@ -1453,7 +1453,7 @@ static void work_fn_tx(struct work_struct *work)
>  
>  	BUG_ON(!sg_dma_len(sg));
>  
> -	desc = chan->device->device_prep_slave_sg(chan,
> +	desc = dmaengine_prep_slave_sg(chan,
>  			sg, s->sg_len_tx, DMA_MEM_TO_DEV,
>  			DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>  	if (!desc) {
> diff --git a/drivers/usb/musb/ux500_dma.c b/drivers/usb/musb/ux500_dma.c
> index 97cb459..03ad80f 100644
> --- a/drivers/usb/musb/ux500_dma.c
> +++ b/drivers/usb/musb/ux500_dma.c
> @@ -119,8 +119,7 @@ static bool ux500_configure_channel(struct dma_channel *channel,
>  	dma_chan->device->device_control(dma_chan, DMA_SLAVE_CONFIG,
>  					     (unsigned long) &slave_conf);
>  
> -	dma_desc = dma_chan->device->
> -			device_prep_slave_sg(dma_chan, &sg, 1, direction,
> +	dma_desc = dmaengine_prep_slave_sg(dma_chan, &sg, 1, direction,
>  					     DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>  	if (!dma_desc)
>  		return false;
> diff --git a/drivers/usb/renesas_usbhs/fifo.c b/drivers/usb/renesas_usbhs/fifo.c
> index 72339bd..7b43093 100644
> --- a/drivers/usb/renesas_usbhs/fifo.c
> +++ b/drivers/usb/renesas_usbhs/fifo.c
> @@ -783,9 +783,8 @@ static void usbhsf_dma_prepare_tasklet(unsigned long data)
>  	sg_dma_address(&sg) = pkt->dma + pkt->actual;
>  	sg_dma_len(&sg) = pkt->trans;
>  
> -	desc = chan->device->device_prep_slave_sg(chan, &sg, 1, dir,
> -						  DMA_PREP_INTERRUPT |
> -						  DMA_CTRL_ACK);
> +	desc = dmaengine_prep_slave_sg(chan, &sg, 1, dir,
> +					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>  	if (!desc)
>  		return;
>  
> diff --git a/drivers/video/mx3fb.c b/drivers/video/mx3fb.c
> index 727a514..eec0d7b 100644
> --- a/drivers/video/mx3fb.c
> +++ b/drivers/video/mx3fb.c
> @@ -337,7 +337,7 @@ static void sdc_enable_channel(struct mx3fb_info *mx3_fbi)
>  
>  	/* This enables the channel */
>  	if (mx3_fbi->cookie < 0) {
> -		mx3_fbi->txd = dma_chan->device->device_prep_slave_sg(dma_chan,
> +		mx3_fbi->txd = dmaengine_prep_slave_sg(dma_chan,
>  		      &mx3_fbi->sg[0], 1, DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT);
>  		if (!mx3_fbi->txd) {
>  			dev_err(mx3fb->dev, "Cannot allocate descriptor on %d\n",
> @@ -1091,7 +1091,7 @@ static int mx3fb_pan_display(struct fb_var_screeninfo *var,
>  	if (mx3_fbi->txd)
>  		async_tx_ack(mx3_fbi->txd);
>  
> -	txd = dma_chan->device->device_prep_slave_sg(dma_chan, sg +
> +	txd = dmaengine_prep_slave_sg(dma_chan, sg +
>  		mx3_fbi->cur_ipu_buf, 1, DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT);
>  	if (!txd) {
>  		dev_err(fbi->device,
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 679b349..6e88f09 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -615,6 +615,22 @@ static inline struct dma_async_tx_descriptor *dmaengine_prep_slave_single(
>  	return chan->device->device_prep_slave_sg(chan, &sg, 1, dir, flags);
>  }
>  
> +static inline struct dma_async_tx_descriptor *dmaengine_prep_slave_sg(
> +	struct dma_chan *chan, struct scatterlist *sgl,	unsigned int sg_len,
> +	enum dma_transfer_direction dir, unsigned long flags)
> +{
> +	return chan->device->device_prep_slave_sg(chan, sgl, sg_len,
> +						  dir, flags);
> +}
> +
> +static inline struct dma_async_tx_descriptor *dmaengine_prep_dma_cyclic(
> +		struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
> +		size_t period_len, enum dma_transfer_direction dir)
> +{
> +	return chan->device->device_prep_dma_cyclic(chan, buf_addr, buf_len,
> +							period_len, dir);
> +}
> +
>  static inline int dmaengine_terminate_all(struct dma_chan *chan)
>  {
>  	return dmaengine_device_control(chan, DMA_TERMINATE_ALL, 0);
> diff --git a/sound/soc/ep93xx/ep93xx-pcm.c b/sound/soc/ep93xx/ep93xx-pcm.c
> index de83904..50593e5 100644
> --- a/sound/soc/ep93xx/ep93xx-pcm.c
> +++ b/sound/soc/ep93xx/ep93xx-pcm.c
> @@ -142,11 +142,10 @@ static int ep93xx_pcm_dma_submit(struct snd_pcm_substream *substream)
>  	struct snd_pcm_runtime *runtime = substream->runtime;
>  	struct ep93xx_runtime_data *rtd = runtime->private_data;
>  	struct dma_chan *chan = rtd->dma_chan;
> -	struct dma_device *dma_dev = chan->device;
>  	struct dma_async_tx_descriptor *desc;
>  
>  	rtd->pointer_bytes = 0;
> -	desc = dma_dev->device_prep_dma_cyclic(chan, runtime->dma_addr,
> +	desc = dmaengine_prep_dma_cyclic(chan, runtime->dma_addr,
>  					       rtd->period_bytes * rtd->periods,
>  					       rtd->period_bytes,
>  					       rtd->dma_data.direction);
> diff --git a/sound/soc/imx/imx-pcm-dma-mx2.c b/sound/soc/imx/imx-pcm-dma-mx2.c
> index 5780c9b..c727123 100644
> --- a/sound/soc/imx/imx-pcm-dma-mx2.c
> +++ b/sound/soc/imx/imx-pcm-dma-mx2.c
> @@ -157,7 +157,7 @@ static int snd_imx_pcm_hw_params(struct snd_pcm_substream *substream,
>  
>  	iprtd->buf = (unsigned int *)substream->dma_buffer.area;
>  
> -	iprtd->desc = chan->device->device_prep_dma_cyclic(chan, dma_addr,
> +	iprtd->desc = dmaengine_prep_dma_cyclic(chan, dma_addr,
>  			iprtd->period_bytes * iprtd->periods,
>  			iprtd->period_bytes,
>  			substream->stream == SNDRV_PCM_STREAM_PLAYBACK ?
> diff --git a/sound/soc/mxs/mxs-pcm.c b/sound/soc/mxs/mxs-pcm.c
> index 105f42a..661b678 100644
> --- a/sound/soc/mxs/mxs-pcm.c
> +++ b/sound/soc/mxs/mxs-pcm.c
> @@ -132,7 +132,7 @@ static int snd_mxs_pcm_hw_params(struct snd_pcm_substream *substream,
>  
>  	iprtd->buf = substream->dma_buffer.area;
>  
> -	iprtd->desc = chan->device->device_prep_dma_cyclic(chan, dma_addr,
> +	iprtd->desc = dmaengine_prep_dma_cyclic(chan, dma_addr,
>  			iprtd->period_bytes * iprtd->periods,
>  			iprtd->period_bytes,
>  			substream->stream == SNDRV_PCM_STREAM_PLAYBACK ?
> diff --git a/sound/soc/sh/siu_pcm.c b/sound/soc/sh/siu_pcm.c
> index 0193e59..5cfcc65 100644
> --- a/sound/soc/sh/siu_pcm.c
> +++ b/sound/soc/sh/siu_pcm.c
> @@ -130,7 +130,7 @@ static int siu_pcm_wr_set(struct siu_port *port_info,
>  	sg_dma_len(&sg) = size;
>  	sg_dma_address(&sg) = buff;
>  
> -	desc = siu_stream->chan->device->device_prep_slave_sg(siu_stream->chan,
> +	desc = dmaengine_prep_slave_sg(siu_stream->chan,
>  		&sg, 1, DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>  	if (!desc) {
>  		dev_err(dev, "Failed to allocate a dma descriptor\n");
> @@ -180,7 +180,7 @@ static int siu_pcm_rd_set(struct siu_port *port_info,
>  	sg_dma_len(&sg) = size;
>  	sg_dma_address(&sg) = buff;
>  
> -	desc = siu_stream->chan->device->device_prep_slave_sg(siu_stream->chan,
> +	desc = dmaengine_prep_slave_sg(siu_stream->chan,
>  		&sg, 1, DMA_DEV_TO_MEM, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>  	if (!desc) {
>  		dev_err(dev, "Failed to allocate dma descriptor\n");
> diff --git a/sound/soc/txx9/txx9aclc.c b/sound/soc/txx9/txx9aclc.c
> index 2155461..b609d2c 100644
> --- a/sound/soc/txx9/txx9aclc.c
> +++ b/sound/soc/txx9/txx9aclc.c
> @@ -132,7 +132,7 @@ txx9aclc_dma_submit(struct txx9aclc_dmadata *dmadata, dma_addr_t buf_dma_addr)
>  	sg_set_page(&sg, pfn_to_page(PFN_DOWN(buf_dma_addr)),
>  		    dmadata->frag_bytes, buf_dma_addr & (PAGE_SIZE - 1));
>  	sg_dma_address(&sg) = buf_dma_addr;
> -	desc = chan->device->device_prep_slave_sg(chan, &sg, 1,
> +	desc = dmaengine_prep_slave_sg(chan, &sg, 1,
>  		dmadata->substream->stream == SNDRV_PCM_STREAM_PLAYBACK ?
>  		DMA_MEM_TO_DEV : DMA_DEV_TO_MEM,
>  		DMA_PREP_INTERRUPT | DMA_CTRL_ACK);


-- 
~Vinod

