Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab1ANKAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 05:00:23 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43778 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab1ANKAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 05:00:19 -0500
Date: Fri, 14 Jan 2011 10:00:13 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Hong Xu <hong.xu@atmel.com>
Cc: linux-mtd@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com
Subject: Re: [PATCH] MTD: atmel_nand: Add DMA support to access Nandflash
Message-ID: <20110114100013.GH2822@pulham.picochip.com>
References: <1294997687-12515-1-git-send-email-hong.xu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294997687-12515-1-git-send-email-hong.xu@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hong,

A couple of minor comments inline but otherwise looks good to me.

Jamie

On Fri, Jan 14, 2011 at 05:34:47PM +0800, Hong Xu wrote:
> diff --git a/drivers/mtd/nand/atmel_nand.c 
> b/drivers/mtd/nand/atmel_nand.c
> index ccce0f0..c2fbffe 100644
> --- a/drivers/mtd/nand/atmel_nand.c
> +++ b/drivers/mtd/nand/atmel_nand.c
> @@ -48,6 +48,12 @@
>  #define no_ecc		0
>  #endif
>  
> +/* DMA for large buffers only */
> +#define DMA_MIN_BYTES	512
> +

Is it worth making this a module parameter and defaulting to 512?

> +static int use_dma = 1;
> +module_param(use_dma, int, 0);
> +
>  static int on_flash_bbt = 0;
>  module_param(on_flash_bbt, int, 0);
>  
> @@ -89,11 +95,20 @@ struct atmel_nand_host {
>  	struct nand_chip	nand_chip;
>  	struct mtd_info		mtd;
>  	void __iomem		*io_base;
> +	void __iomem		*io_phys;

This should be of type dma_addr_t and this will eliminate some casting 
later.

>  	struct atmel_nand_data	*board;
>  	struct device		*dev;
>  	void __iomem		*ecc;
> +
> +	struct completion comp;
> +	struct dma_chan *dma_chan;
>  };
>  
> +static int cpu_has_dma(void)
> +{
> +	return cpu_is_at91sam9rl() || cpu_is_at91sam9g45();
> +}
> +
>  /*
>   * Enable NAND.
>   */
> @@ -150,7 +165,7 @@ static int atmel_nand_device_ready(struct mtd_info *mtd)
>  /*
>   * Minimal-overhead PIO for data access.
>   */
> -static void atmel_read_buf(struct mtd_info *mtd, u8 *buf, int len)
> +static void atmel_read_buf8(struct mtd_info *mtd, u8 *buf, int len)
>  {
>  	struct nand_chip	*nand_chip = mtd->priv;
>  
> @@ -164,7 +179,7 @@ static void atmel_read_buf16(struct mtd_info *mtd, u8 *buf, int len)
>  	__raw_readsw(nand_chip->IO_ADDR_R, buf, len / 2);
>  }
>  
> -static void atmel_write_buf(struct mtd_info *mtd, const u8 *buf, int len)
> +static void atmel_write_buf8(struct mtd_info *mtd, const u8 *buf, int len)
>  {
>  	struct nand_chip	*nand_chip = mtd->priv;
>  
> @@ -178,6 +193,102 @@ static void atmel_write_buf16(struct mtd_info *mtd, const u8 *buf, int len)
>  	__raw_writesw(nand_chip->IO_ADDR_W, buf, len / 2);
>  }
>  
> +static void dma_complete_func(void *completion)
> +{
> +	complete(completion);
> +}
> +
> +static void atmel_nand_dma_op(struct mtd_info *mtd, void *buf, int len,
> +			       int is_read)
> +{
> +	struct dma_device *dma_dev;
> +	enum dma_ctrl_flags flags;
> +	dma_addr_t dma_src_addr, dma_dst_addr, phys_addr;
> +	struct dma_async_tx_descriptor *tx = NULL;
> +	dma_cookie_t cookie;
> +	struct nand_chip *chip = mtd->priv;
> +	struct atmel_nand_host *host = chip->priv;
> +
> +	dma_dev = host->dma_chan->device;
> +
> +	flags = DMA_CTRL_ACK | DMA_COMPL_SKIP_DEST_UNMAP | DMA_PREP_INTERRUPT |
> +			DMA_COMPL_SKIP_SRC_UNMAP;
> +
> +	if (is_read)
> +		phys_addr = dma_map_single(dma_dev->dev, buf, len,
> +					   DMA_FROM_DEVICE);
> +	else
> +		phys_addr = dma_map_single(dma_dev->dev, buf, len,
> +					   DMA_TO_DEVICE);
> +	if (!phys_addr) {
> +		dev_err(host->dev, "Failed to dma_map_single\n");
> +		goto err_dma_map;
> +	}

I don't think this is right - you should check phys_addr() with 
dma_mapping_error() rather than comparing to 0.

> +
> +	if (is_read) {
> +		dma_src_addr = (dma_addr_t)host->io_phys;
> +		dma_dst_addr = phys_addr;
> +	} else {
> +		dma_src_addr = phys_addr;
> +		dma_dst_addr = (dma_addr_t)host->io_phys;
> +	}
> +
> +	tx = dma_dev->device_prep_dma_memcpy(host->dma_chan, dma_dst_addr,
> +					     dma_src_addr, len, flags);
> +	if (!tx) {
> +		dev_err(host->dev, "Failed to prepare DMA memcpy\n");
> +		goto err;
> +	}
> +
> +	init_completion(&host->comp);
> +	tx->callback = dma_complete_func;
> +	tx->callback_param = &host->comp;
> +
> +	cookie = tx->tx_submit(tx);
> +	if (dma_submit_error(cookie)) {
> +		dev_err(host->dev, "Failed to do DMA tx_submit\n");
> +		goto err;
> +	}
> +
> +	dma_async_issue_pending(host->dma_chan);
> +
> +	wait_for_completion(&host->comp);
> +
> +err:
> +	if (is_read)
> +		dma_unmap_single(dma_dev->dev, phys_addr, len, DMA_FROM_DEVICE);
> +	else
> +		dma_unmap_single(dma_dev->dev, phys_addr, len, DMA_TO_DEVICE);
> +err_dma_map:
> +	return;
> +}
> +
> +static void atmel_read_buf(struct mtd_info *mtd, u8 *buf, int len)
> +{
> +	struct nand_chip *chip = mtd->priv;
> +	struct atmel_nand_host *host = chip->priv;
> +
> +	if (use_dma && len >= DMA_MIN_BYTES)
> +		atmel_nand_dma_op(mtd, buf, len, 1);
> +	else if (host->board->bus_width_16)
> +		atmel_read_buf16(mtd, buf, len);
> +	else
> +		atmel_read_buf8(mtd, buf, len);
> +}
> +
> +static void atmel_write_buf(struct mtd_info *mtd, const u8 *buf, int len)
> +{
> +	struct nand_chip *chip = mtd->priv;
> +	struct atmel_nand_host *host = chip->priv;
> +
> +	if (use_dma && len >= DMA_MIN_BYTES)
> +		atmel_nand_dma_op(mtd, (u8 *)buf, len, 0);
> +	else if (host->board->bus_width_16)
> +		atmel_write_buf16(mtd, buf, len);
> +	else
> +		atmel_write_buf8(mtd, buf, len);
> +}
> +
>  /*
>   * Calculate HW ECC
>   *
> @@ -398,6 +509,8 @@ static int __init atmel_nand_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  	}
>  
> +	host->io_phys = (void __iomem *)mem->start;
> +
>  	host->io_base = ioremap(mem->start, mem->end - mem->start + 1);
>  	if (host->io_base == NULL) {
>  		printk(KERN_ERR "atmel_nand: ioremap failed\n");
> @@ -516,6 +629,23 @@ static int __init atmel_nand_probe(struct platform_device *pdev)
>  		}
>  	}
>  
> +	if (cpu_has_dma() && use_dma) {
> +		dma_cap_mask_t mask;
> +
> +		dma_cap_zero(mask);
> +		dma_cap_set(DMA_MEMCPY, mask);
> +		host->dma_chan = dma_request_channel(mask, 0, NULL);
> +
> +		if (!host->dma_chan) {
> +			dev_err(host->dev, "Failed to request DMA channel\n");
> +			use_dma = 0;
> +		}
> +	}
> +	if (use_dma)
> +		dev_info(host->dev, "Using DMA for NAND access.\n");
> +	else
> +		dev_info(host->dev, "No DMA support for NAND access.\n");
> +
>  	/* second phase scan */
>  	if (nand_scan_tail(mtd)) {
>  		res = -ENXIO;
> @@ -555,6 +685,8 @@ err_scan_ident:
>  err_no_card:
>  	atmel_nand_disable(host);
>  	platform_set_drvdata(pdev, NULL);
> +	if (host->dma_chan)
> +		dma_release_channel(host->dma_chan);
>  	if (host->ecc)
>  		iounmap(host->ecc);
>  err_ecc_ioremap:
> @@ -578,6 +710,10 @@ static int __exit atmel_nand_remove(struct platform_device *pdev)
>  
>  	if (host->ecc)
>  		iounmap(host->ecc);
> +
> +	if (host->dma_chan)
> +		dma_release_channel(host->dma_chan);
> +
>  	iounmap(host->io_base);
>  	kfree(host);
>  
> -- 
> 1.7.3.3
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
