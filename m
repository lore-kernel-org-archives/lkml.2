Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab2FCTJz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 15:09:55 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50050 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab2FCTJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 15:09:54 -0400
Date: Sun, 3 Jun 2012 20:09:32 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Roland Stigge <stigge@antcom.de>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        dwmw2@infradead.org, kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        linux-arm-kernel@lists.infradead.org, hechtb@googlemail.com,
        lars@metafoo.de, b32955@freescale.com, leiwen@marvell.com,
        dedekind1@gmail.com
Subject: Re: [PATCH v4] MTD: LPC32xx SLC NAND driver
Message-ID: <20120603190932.GB23368@n2100.arm.linux.org.uk>
References: <1338748689-29645-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338748689-29645-1-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 03, 2012 at 08:38:09PM +0200, Roland Stigge wrote:
> +static int lpc32xx_xmit_dma(struct mtd_info *mtd, dma_addr_t dma,
> +			    void *mem, int len, enum dma_transfer_direction dir)
> +{
> +	struct nand_chip *chip = mtd->priv;
> +	struct lpc32xx_nand_host *host = chip->priv;
> +	struct dma_async_tx_descriptor *desc;
> +	int flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT;
> +	int res;
> +	dma_cookie_t cookie;
> +
> +	host->dma_slave_config.direction = dir;
> +	host->dma_slave_config.src_addr = dma;
> +	host->dma_slave_config.dst_addr = dma;
> +	host->dma_slave_config.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
> +	host->dma_slave_config.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
> +	host->dma_slave_config.src_maxburst = 4;
> +	host->dma_slave_config.dst_maxburst = 4;
> +	/* DMA controller does flow control: */
> +	host->dma_slave_config.device_fc = false;
> +	if (dmaengine_slave_config(host->dma_chan, &host->dma_slave_config)) {
> +		dev_err(mtd->dev.parent, "Failed to setup DMA slave\n");
> +		return -ENXIO;
> +	}
> +
> +	sg_init_one(&host->sgl, mem, len);
> +
> +	res = dma_map_sg(host->dma_chan->device->dev, &host->sgl, 1,
> +			 DMA_BIDIRECTIONAL);
> +	if (res != 1) {
> +		dev_err(mtd->dev.parent, "Failed to map sg list\n");
> +		return -ENXIO;
> +	}
> +	desc = dmaengine_prep_slave_sg(host->dma_chan, &host->sgl, 1, dir,
> +				       flags);
> +	if (!desc) {
> +		dev_err(mtd->dev.parent, "Failed to prepare slave sg\n");
> +		goto out1;
> +	}
> +
> +	init_completion(&host->comp);
> +	desc->callback = lpc32xx_dma_complete_func;
> +	desc->callback_param = &host->comp;
> +
> +	cookie = dmaengine_submit(desc);
> +	if (dma_submit_error(cookie)) {
> +		dev_err(mtd->dev.parent, "Failed to dmaengine_submit()\n");
> +		goto out1;
> +	}

dmaengine_submit() is no longer allowed to fail, so you don't need this
check here anymore.  It's been that way for a long time.

> +	dma_async_issue_pending(host->dma_chan);
> +
> +	wait_for_completion_timeout(&host->comp, msecs_to_jiffies(1000));

What about unmapping the buffer upon completion?

> +
> +	return 0;
> +out1:
> +	dma_unmap_sg(host->dma_chan->device->dev, &host->sgl, 1,
> +		     DMA_BIDIRECTIONAL);
> +	return -ENXIO;
> +}
