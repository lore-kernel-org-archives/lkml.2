Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab1JQOGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 10:06:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:17718 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426Ab1JQOGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 10:06:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,359,1315206000"; 
   d="scan'208";a="78855455"
Subject: Re: [PATCH v3] dmaengine: add CSR SiRFprimaII DMAC driver
From: Vinod Koul <vinod.koul@intel.com>
To: Barry Song <Barry.Song@csr.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Jassi Brar <jaswinder.singh@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Rongjun Ying <rongjun.ying@csr.com>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <1318844199-19303-1-git-send-email-Barry.Song@csr.com>
References: <1318844199-19303-1-git-send-email-Barry.Song@csr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Oct 2011 19:27:41 +0530
Message-ID: <1318859861.23438.137.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-17 at 02:36 -0700, Barry Song wrote:
> From: Rongjun Ying <Rongjun.Ying@csr.com>
> 
> Cc: Jassi Brar <jaswinder.singh@linaro.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Rongjun Ying <rongjun.ying@csr.com>
> Signed-off-by: Barry Song <Barry.Song@csr.com>
> ---
>  -v3:
>  use new dma_transfer_direction API from Jassi and Vinod;
>  use new dma_interleaved_template API from Jassi Brar;
>  fix comment minor issues from Arnd and Vinod in v2;
>  add prima2 loop DMA mode support.
> 
>  MAINTAINERS            |    1 +
>  drivers/dma/Kconfig    |    7 +
>  drivers/dma/Makefile   |    1 +
>  drivers/dma/sirf-dma.c |  685 ++++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 694 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/dma/sirf-dma.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5483e0c..adcb6ce 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -739,6 +739,7 @@ M:	Barry Song <baohua.song@csr.com>
>  L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  S:	Maintained
>  F:	arch/arm/mach-prima2/
> +F:	drivers/dma/sirf-dma*
>  
>  ARM/EBSA110 MACHINE SUPPORT
>  M:	Russell King <linux@arm.linux.org.uk>
> +++ b/drivers/dma/sirf-dma.c
> @@ -0,0 +1,685 @@
> +/*
> + * DMA controller driver for CSR SiRFprimaII
> + *
> + * Copyright (c) 2011 Cambridge Silicon Radio Limited, a CSR plc group company.
> + *
> + * Licensed under GPLv2 or later.
There is a mismatch between this and MODULE_LICENSE()
> + 
> +
> +struct sirfsoc_dma_chan {
> +	struct dma_chan			chan;
> +	struct list_head		free;
> +	struct list_head		prepared;
> +	struct list_head		queued;
> +	struct list_head		active;
> +	struct list_head		completed;
> +	dma_cookie_t			completed_cookie;
> +	unsigned long			happened_cyclic;
> +	unsigned long			completed_cyclic;
> +
> +	/* Lock for this structure */
> +	spinlock_t			lock;
> +
> +	int             mode;
alignment pls...

> +
> +/* Execute all queued DMA descriptors */
> +static void sirfsoc_dma_execute(struct sirfsoc_dma_chan *schan)
> +{
> +	struct sirfsoc_dma *sdma = dma_chan_to_sirfsoc_dma(&schan->chan);
> +	int cid = schan->chan.chan_id;
> +	struct sirfsoc_dma_desc *sdesc = NULL;
> +
> +	sdesc = list_first_entry(&schan->queued, struct sirfsoc_dma_desc,
> +		node);
> +	/* Move the first queued descriptor to active list */
> +	list_move_tail(&schan->queued, &schan->active);
shouldn't lock be held before this, and if this function is called with
lock held, would help to mention that explicitly
> +
> +	/* Start the DMA transfer */
> +	writel_relaxed(sdesc->width, sdma->base + SIRFSOC_DMA_WIDTH_0 + cid * 4);
> +	writel_relaxed(cid | (schan->mode << SIRFSOC_DMA_MODE_CTRL_BIT) |
> +		(sdesc->dir << SIRFSOC_DMA_DIR_CTRL_BIT),
> +		sdma->base + cid * 0x10 + SIRFSOC_DMA_CH_CTRL);
> +	writel_relaxed(sdesc->xlen, sdma->base + cid * 0x10 + SIRFSOC_DMA_CH_XLEN);
> +	writel_relaxed(sdesc->ylen, sdma->base + cid * 0x10 + SIRFSOC_DMA_CH_YLEN);
> +	writel_relaxed(readl_relaxed(sdma->base + SIRFSOC_DMA_INT_EN) | (1 << cid),
> +		sdma->base + SIRFSOC_DMA_INT_EN);
> +	writel(sdesc->addr >> 2, sdma->base + cid * 0x10 + SIRFSOC_DMA_CH_ADDR);
> +
> +	if (sdesc->cyclic) {
> +		writel((1 << cid) | 1 << (cid + 16) |
> +			readl_relaxed(sdma->base + SIRFSOC_DMA_CH_LOOP_CTRL),
> +			sdma->base + SIRFSOC_DMA_CH_LOOP_CTRL);
> +		schan->happened_cyclic = schan->completed_cyclic = 0;
> +	}
any reason why we have mixed use of writel_relaxes and writel?
Shouldn't all the DMA register writes be done only using writel?

> +}
> +
> +
> +static struct dma_async_tx_descriptor *sirfsoc_dma_prep_interleaved(
> +	struct dma_chan *chan, struct dma_interleaved_template *xt)
> +{
> +	struct sirfsoc_dma *sdma = dma_chan_to_sirfsoc_dma(chan);
> +	struct sirfsoc_dma_chan *schan = dma_chan_to_sirfsoc_dma_chan(chan);
> +	struct sirfsoc_dma_desc *sdesc = NULL;
> +	unsigned long iflags;
> +	int ret;
> +
> +	if ((xt->dir != MEM_TO_DEV) || (xt->dir != DEV_TO_MEM)) {
> +		ret = -EINVAL;
> +		goto err_dir;
> +	}
> +
> +	/* Get free descriptor */
> +	spin_lock_irqsave(&schan->lock, iflags);
> +	if (!list_empty(&schan->free)) {
> +		sdesc = list_first_entry(&schan->free, struct sirfsoc_dma_desc,
> +			node);
> +		list_del(&sdesc->node);
> +	}
> +	spin_unlock_irqrestore(&schan->lock, iflags);
> +
> +	if (!sdesc) {
> +		/* try to free completed descriptors */
> +		sirfsoc_dma_process_completed(sdma);
> +		ret = 0;
> +		goto no_desc;
> +	}
> +
> +	/* Place descriptor in prepared list */
> +	spin_lock_irqsave(&schan->lock, iflags);
> +	if ((xt->frame_size == 1) && (xt->numf > 0)) {
what does this mean?
> +		sdesc->cyclic = 0;
> +		sdesc->xlen = xt->sgl[0].size / 4;
> +		sdesc->width = (xt->sgl[0].size + xt->sgl[0].icg) / 4;
whats so magical about 4?
> +		sdesc->ylen = xt->numf - 1;
> +		if (xt->dir == MEM_TO_DEV) {
> +			sdesc->addr = xt->src_start;
> +			sdesc->dir = 1;
> +		} else {
> +			sdesc->addr = xt->dst_start;
> +			sdesc->dir = 0;
> +		}
> +
> +		list_add_tail(&sdesc->node, &schan->prepared);
> +	} else {
> +		pr_err("sirfsoc DMA Invalid xfer\n");
> +		ret = -EINVAL;
> +		goto err_xfer;
> +	}
> +	spin_unlock_irqrestore(&schan->lock, iflags);
> +
> +	return &sdesc->desc;
> +err_xfer:
> +	spin_unlock_irqrestore(&schan->lock, iflags);
> +no_desc:
> +err_dir:
> +	return ERR_PTR(ret);
> +}
> +
> +static struct dma_async_tx_descriptor *
> +sirfsoc_dma_prep_cyclic(struct dma_chan *chan, dma_addr_t addr,
> +	size_t buf_len, size_t period_len,
> +	enum dma_transfer_direction direction)
> +{
> +	struct sirfsoc_dma_chan *schan = dma_chan_to_sirfsoc_dma_chan(chan);
> +	struct sirfsoc_dma_desc *sdesc = NULL;
> +	unsigned long iflags;
> +
> +	/*
> +	 * we only support cycle transfer with 2 period
> +	 * If the X-length is set to 0, it would be the loop mode.
> +	 * The DMA address keeps increasing until reaching the end of a loop
> +	 * area whose size is defined by (DMA_WIDTH x (Y_LENGTH + 1)). Then
> +	 * the DMA address goes back to the beginning of this area.
> +	 * In loop mode, the DMA data region is divided into two parts, BUFA
> +	 * and BUFB. DMA controller generates interrupts twice in each loop:
> +	 * when the DMA address reaches the end of BUFA or the end of the
> +	 * BUFB
> +	 */
> +	if (buf_len !=  2 * period_len)
> +		return ERR_PTR(-EINVAL);
> +
> +	/* Get free descriptor */
> +	spin_lock_irqsave(&schan->lock, iflags);
> +	if (!list_empty(&schan->free)) {
> +		sdesc = list_first_entry(&schan->free, struct sirfsoc_dma_desc,
> +			node);
> +		list_del(&sdesc->node);
> +	}
> +	spin_unlock_irqrestore(&schan->lock, iflags);
> +
> +	if (!sdesc)
> +		return 0;
> +
> +	/* Place descriptor in prepared list */
> +	spin_lock_irqsave(&schan->lock, iflags);
> +	sdesc->addr = addr;
> +	sdesc->cyclic = 1;
> +	sdesc->xlen = 0;
> +	sdesc->ylen = buf_len / 4 - 1;
> +	sdesc->width = 1;
> +	list_add_tail(&sdesc->node, &schan->prepared);
> +	spin_unlock_irqrestore(&schan->lock, iflags);
> +
> +	return &sdesc->desc;
> +}
is this interleave cyclic dma or plain sg?
> +
> +/*
> + * The DMA controller consists of 16 independent DMA channels.
> + * Each channel is allocated to a different function
> + */
> +bool sirfsoc_dma_filter_id(struct dma_chan *chan, void *chan_id)
> +{
> +	unsigned int ch_nr = (unsigned int) chan_id;
> +
> +	if (ch_nr == chan->chan_id +
> +		chan->device->dev_id * SIRFSOC_DMA_CHANNELS)
> +		return true;
pls fix indent here
> +
> +	return false;
> +}
> +EXPORT_SYMBOL(sirfsoc_dma_filter_id);
> +
> +static int __devinit sirfsoc_dma_probe(struct platform_device *op)
> +{
> +	struct device_node *dn = op->dev.of_node;
> +	struct device *dev = &op->dev;
> +	struct dma_device *dma;
> +	struct sirfsoc_dma *sdma;
> +	struct sirfsoc_dma_chan *schan;
> +	struct resource res;
> +	ulong regs_start, regs_size;
> +	u32 id;
> +	int retval, i;
> +
> +	sdma = devm_kzalloc(dev, sizeof(*sdma), GFP_KERNEL);
> +	if (!sdma) {
> +		dev_err(dev, "Memory exhausted!\n");
> +		return -ENOMEM;
> +	}
> +
> +	if (of_property_read_u32(dn, "cell-index", &id)) {
> +		dev_err(dev, "Fail to get DMAC index\n");
and you leak memory!!
> +		return -ENODEV;
> +	}
> +
> +	sdma->irq = irq_of_parse_and_map(dn, 0);
> +	if (sdma->irq == NO_IRQ) {
> +		dev_err(dev, "Error mapping IRQ!\n");
and again...
> +		return -EINVAL;
> +	}
> +
> +	retval = of_address_to_resource(dn, 0, &res);
> +	if (retval) {
> +		dev_err(dev, "Error parsing memory region!\n");
and again...
> +		return retval;
> +	}
> +
> +	regs_start = res.start;
> +	regs_size = resource_size(&res);
> +
> +	if (!devm_request_mem_region(dev, regs_start, regs_size, DRV_NAME)) {
> +		dev_err(dev, "Error requesting memory region!\n");
> +		return -EBUSY;
> +	}
> +
> +	sdma->base = devm_ioremap(dev, regs_start, regs_size);
> +	if (!sdma->base) {
> +		dev_err(dev, "Error mapping memory region!\n");
> +		return -ENOMEM;
> +	}
> +
> +	retval = devm_request_irq(dev, sdma->irq, &sirfsoc_dma_irq, 0, DRV_NAME,
> +		sdma);
> +	if (retval) {
> +		dev_err(dev, "Error requesting IRQ!\n");
> +		return -EINVAL;
> +	}
> +
> +	dma = &sdma->dma;
> +	dma->dev = dev;
> +	dma->chancnt = SIRFSOC_DMA_CHANNELS;
> +
> +	dma->device_alloc_chan_resources = sirfsoc_dma_alloc_chan_resources;
> +	dma->device_free_chan_resources = sirfsoc_dma_free_chan_resources;
> +	dma->device_issue_pending = sirfsoc_dma_issue_pending;
> +	dma->device_control = sirfsoc_dma_control;
> +	dma->device_tx_status = sirfsoc_dma_tx_status;
> +	dma->device_prep_interleaved_dma = sirfsoc_dma_prep_interleaved;
> +	dma->device_prep_dma_cyclic = sirfsoc_dma_prep_cyclic;
> +
> +	INIT_LIST_HEAD(&dma->channels);
> +	dma_cap_set(DMA_SLAVE, dma->cap_mask);
> +	dma_cap_set(DMA_CYCLIC, dma->cap_mask);
> +	dma_cap_set(DMA_INTERLEAVE, dma->cap_mask);
> +	dma_cap_set(DMA_PRIVATE, dma->cap_mask);
> +
> +	for (i = 0; i < dma->chancnt; i++) {
> +		schan = &sdma->channels[i];
> +
> +		schan->chan.device = dma;
> +		schan->chan.cookie = 1;
> +		schan->completed_cookie = schan->chan.cookie;
> +
> +		INIT_LIST_HEAD(&schan->free);
> +		INIT_LIST_HEAD(&schan->prepared);
> +		INIT_LIST_HEAD(&schan->queued);
> +		INIT_LIST_HEAD(&schan->active);
> +		INIT_LIST_HEAD(&schan->completed);
> +
> +		spin_lock_init(&schan->lock);
> +		list_add_tail(&schan->chan.device_node, &dma->channels);
> +	}
> +
> +	tasklet_init(&sdma->tasklet, sirfsoc_dma_tasklet, (unsigned long)sdma);
> +
> +	/* Register DMA engine */
> +	dev_set_drvdata(dev, sdma);
> +	retval = dma_async_device_register(dma);
> +	if (retval) {
> +		devm_free_irq(dev, sdma->irq, sdma);
> +		irq_dispose_mapping(sdma->irq);
> +	}
> +
> +	return retval;
> +}
the error path handling in this function is totally non existent!!

> +
> +static int __devexit sirfsoc_dma_remove(struct platform_device *op)
> +{
> +	struct device *dev = &op->dev;
> +	struct sirfsoc_dma *sdma = dev_get_drvdata(dev);
> +
> +	dma_async_device_unregister(&sdma->dma);
> +	devm_free_irq(dev, sdma->irq, sdma);
> +	irq_dispose_mapping(sdma->irq);
who will free mem allocated in probe?
> +
> +	return 0;
> +}
> +
-- 
~Vinod

