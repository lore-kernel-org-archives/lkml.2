Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837Ab2EOOeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:34:50 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43728 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757166Ab2EOOet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:34:49 -0400
Date: Tue, 15 May 2012 15:34:28 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Roland Stigge <stigge@antcom.de>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        dwmw2@infradead.org, kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] MTD: LPC32xx MLC NAND driver
Message-ID: <20120515143428.GC13860@n2100.arm.linux.org.uk>
References: <1337091832-10138-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337091832-10138-1-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 04:23:52PM +0200, Roland Stigge wrote:
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
> +	if (dmaengine_slave_config(host->dma_chan, &host->dma_slave_config)) {
> +		dev_err(mtd->dev.parent, "Failed to setup DMA slave\n");
> +		return -ENXIO;
> +	}

Can you explain why you need to issue this call for every transfer?

The 'direction' argument should be ignored by all modern DMA engine
drivers (we've decided previously to get rid of it).  As far as I can
see, the device address nor any of the other parameters ever change
between transfers.

> +
> +	sg_init_one(&host->sgl, mem, len);
> +
> +	res = dma_map_sg(host->dma_chan->device->dev, &host->sgl, 1, dir);

Also note that dma transfer directions and dma data directions are
different things.  You shouldn't mix the two.

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
> +	init_completion(&host->comp_dma);
> +	desc->callback = lpc32xx_dma_complete_func;
> +	desc->callback_param = &host->comp_dma;
> +
> +	cookie = dmaengine_submit(desc);
> +	if (dma_submit_error(cookie)) {
> +		dev_err(mtd->dev.parent, "Failed to dmaengine_submit()\n");
> +		goto out1;
> +	}
> +	dma_async_issue_pending(host->dma_chan);
> +
> +	wait_for_completion_timeout(&host->comp_dma, msecs_to_jiffies(1000));
> +
> +	dma_sync_sg_for_cpu(host->dma_chan->device->dev, &host->sgl, 1, dir);

Why sync?  What's wrong with dma_unmap()?  Have you tested this with
DMA API debugging enabled?

> +	if (dma_set_mask(host->dma_chan->device->dev, 0xFFFFFFFF)) {
> +		dev_err(mtd->dev.parent, "Failed to set dma mask\n");
> +		goto out1;
> +	}

No.  You shouldn't do this to a device that you're not in charge of.  If
that's important for the DMA engine device, then the DMA engine device
driver should have already done that.

Otherwise, you'll be potentially modifying the DMA mask for a device
_you_ don't own, and which is potentially already in use.
