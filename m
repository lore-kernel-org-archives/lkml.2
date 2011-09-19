Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab1ISJDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 05:03:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:48559 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790Ab1ISJDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 05:03:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,404,1312182000"; 
   d="scan'208";a="50334244"
Subject: Re: [PATCH v2] dmaengine: add CSR SiRFprimaII DMAC driver
From: Vinod Koul <vinod.koul@intel.com>
To: Barry Song <Baohua.Song@csr.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Jassi Brar <jaswinder.singh@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Rongjun Ying <rongjun.ying@csr.com>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <1316166960-20964-1-git-send-email-Baohua.Song@csr.com>
References: <1316166960-20964-1-git-send-email-Baohua.Song@csr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Sep 2011 14:29:34 +0530
Message-ID: <1316422774.26662.30.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-16 at 02:56 -0700, Barry Song wrote:
> From: Rongjun Ying <rongjun.ying@csr.com>
> 
> Cc: Jassi Brar <jaswinder.singh@linaro.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Rongjun Ying <rongjun.ying@csr.com>
> Signed-off-by: Barry Song <Baohua.Song@csr.com>
> ---
>  -v2:
>  use generic xfer API from jassi;
>  delete sirf self-defined slave config;
>  fix feedback from vinod;
>  fix filter function: we have two dmac, clients drivers think the chan id as 0~31;
>  rename regs to base;
>  delete redundant chan_id initialization in probe since dmaengine core will
>  re-write it, refer to my patch too:
>  [PATCH] dmaengine: delete redundant chan_id and chancnt initialization in dma drivers
>  http://www.spinics.net/lists/kernel/msg1237455.html
> 
>  this patch doesn't provide a common way for filter and doesn't use the jassi's v2 patch.
> +
> +static int sirfsoc_dma_slave_config(struct sirfsoc_dma_chan *schan,
> +	struct dma_slave_config *config)
> +{
> +	u32 addr, direction;
> +	unsigned long flags;
> +
> +	switch (config->direction) {
> +	case DMA_FROM_DEVICE:
> +		direction = 0;
> +		addr = config->dst_addr;
> +		break;
> +
> +	case DMA_TO_DEVICE:
> +		direction = 1;
> +		addr = config->src_addr;
> +		break;
> +
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	if ((config->src_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES) ||
> +		(config->dst_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES))
> +		return -EINVAL;
> +
> +	spin_lock_irqsave(&schan->lock, flags);
> +	schan->addr = addr;
> +	schan->direction = direction;
> +	schan->mode = (config->src_maxburst == 4 ? 1 : 0);
> +	spin_unlock_irqrestore(&schan->lock, flags);
Not sure why you support this, there seem to be no DMA_SLAVE support in
this version ate least
> +
> +	return 0;
> +}
> +
> +
> +
> +/* Alloc channel resources */
> +static int sirfsoc_dma_alloc_chan_resources(struct dma_chan *chan)
> +{
> +	struct sirfsoc_dma *sdma = dma_chan_to_sirfsoc_dma(chan);
> +	struct sirfsoc_dma_chan *schan = dma_chan_to_sirfsoc_dma_chan(chan);
> +	struct sirfsoc_dma_desc *sdesc;
> +	unsigned long flags;
> +	LIST_HEAD(descs);
> +	int i;
> +
> +	/* Alloc descriptors for this channel */
> +	for (i = 0; i < SIRFSOC_DMA_DESCRIPTORS; i++) {
> +		sdesc = kzalloc(sizeof(struct sirfsoc_dma_desc), GFP_KERNEL);
kernel convention is kzalloc(sizeof(*sdesc),....)

> +		if (!sdesc) {
> +			dev_notice(sdma->dma.dev, "Memory allocation error. "
> +				"Allocated only %u descriptors\n", i);
> +			break;
> +		}
> +
> +		dma_async_tx_descriptor_init(&sdesc->desc, chan);
> +		sdesc->desc.flags = DMA_CTRL_ACK;
> +		sdesc->desc.tx_submit = sirfsoc_dma_tx_submit;
> +
> +		list_add_tail(&sdesc->node, &descs);
> +	}
> +
> +	/* Return error only if no descriptors were allocated */
> +	if (i == 0)
> +		return -ENOMEM;
> +
> +	spin_lock_irqsave(&schan->lock, flags);
> +
> +	list_splice_tail_init(&descs, &schan->free);
> +	spin_unlock_irqrestore(&schan->lock, flags);
> +
> +	return 0;
it should be return i; You are supposed to return the number of desc
allocated.


> +
> +/* Check request completion status */
> +static enum dma_status
> +sirfsoc_dma_tx_status(struct dma_chan *chan, dma_cookie_t cookie,
> +	struct dma_tx_state *txstate)
> +{
> +	struct sirfsoc_dma_chan *schan = dma_chan_to_sirfsoc_dma_chan(chan);
> +	unsigned long flags;
> +	dma_cookie_t last_used;
> +	dma_cookie_t last_complete;
> +
> +	spin_lock_irqsave(&schan->lock, flags);
> +	last_used = schan->chan.cookie;
> +	last_complete = schan->completed_cookie;
> +	spin_unlock_irqrestore(&schan->lock, flags);
> +
> +	dma_set_tx_state(txstate, last_complete, last_used, 0);
> +	return dma_async_is_complete(cookie, last_complete, last_used);
> +}
> +
> +static struct dma_async_tx_descriptor *sirfsoc_dma_prep_slave_sg(
> +	struct dma_chan *chan, struct scatterlist *sgl,
> +	unsigned int sg_len, enum dma_data_direction direction,
> +	unsigned long flags)
> +{
> +	return NULL;
> +}
Please remove this until you support it...


> +}
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
> +	sdma = devm_kzalloc(dev, sizeof(struct sirfsoc_dma), GFP_KERNEL);
ditto...

> +	if (!sdma) {
> +		dev_err(dev, "Memory exhausted!\n");
> +		return -ENOMEM;
> +	}
> +
> +	if (of_property_read_u32(dn, "cell-index", &id)) {
> +		dev_err(dev, "Fail to get DMAC index\n");
> +		return -ENODEV;
kfree(sdma) ??

> +	}
> +
> +	sdma->irq = irq_of_parse_and_map(dn, 0);
> +	if (sdma->irq == NO_IRQ) {
> +		dev_err(dev, "Error mapping IRQ!\n");
> +		return -EINVAL;
> +	}
> +
> +	retval = of_address_to_resource(dn, 0, &res);
> +	if (retval) {
> +		dev_err(dev, "Error parsing memory region!\n");
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
> +	dma->device_prep_slave_sg = sirfsoc_dma_prep_slave_sg;
> +	dma->device_prep_dma_genxfer = sirfsoc_dma_prep_genxfer;
> +
> +	INIT_LIST_HEAD(&dma->channels);
> +	dma_cap_set(DMA_SLAVE, dma->cap_mask);
No you don't support DMA_SLAVE yet.


> +MODULE_AUTHOR("Rongjun Ying <rongjun.ying@csr.com>, "
> +	"Barry Song <baohua.song@csr.com>");
> +MODULE_DESCRIPTION("SIRFSOC DMA control driver");
> +MODULE_LICENSE("GPL");
Your header says GPLV2 or later, here its GPL only???


-- 
~Vinod

