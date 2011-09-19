Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab1ISJYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 05:24:14 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:33633 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab1ISJYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 05:24:08 -0400
From: Barry Song <Barry.Song@csr.com>
To: Vinod Koul <vinod.koul@intel.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>, Jassi Brar <jaswinder.singh@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DL-SHA-WorkGroupLinux <Workgroup.Linux@csr.com>,
        Rongjun Ying <Rongjun.Ying@csr.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v2] dmaengine: add CSR SiRFprimaII DMAC driver
Thread-Topic: [PATCH v2] dmaengine: add CSR SiRFprimaII DMAC driver
Thread-Index: AQHMdFbdVdy3M8u+O0iH2Esxb4MbWpVT5hwAgACLI2A=
Date: Mon, 19 Sep 2011 09:23:38 +0000
Message-ID: <5EB3BFCD089AD643B9BB63439F5FD5E9840F3A8D@SHAASIEXM01.ASIA.ROOT.PRI>
References: <1316166960-20964-1-git-send-email-Baohua.Song@csr.com>
 <1316422774.26662.30.camel@vkoul-udesk3>
In-Reply-To: <1316422774.26662.30.camel@vkoul-udesk3>
Accept-Language: zh-CN, en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.125.36.58]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p8J9OXO8013894

Hi Vinod,
Thanks!

> -----Original Message-----
> From: Vinod Koul [mailto:vinod.koul@intel.com]
> Sent: 2011å¹´9æœˆ19æ—¥ 17:00
> To: Barry Song
> Cc: Arnd Bergmann; Jassi Brar; Linus Walleij; linux-kernel@vger.kernel.org;
> DL-SHA-WorkGroupLinux; Rongjun Ying; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH v2] dmaengine: add CSR SiRFprimaII DMAC driver
> 
> On Fri, 2011-09-16 at 02:56 -0700, Barry Song wrote:
> > From: Rongjun Ying <rongjun.ying@csr.com>
> >
> > Cc: Jassi Brar <jaswinder.singh@linaro.org>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Linus Walleij <linus.walleij@linaro.org>
> > Signed-off-by: Rongjun Ying <rongjun.ying@csr.com>
> > Signed-off-by: Barry Song <Baohua.Song@csr.com>
> > ---
> >  -v2:
> >  use generic xfer API from jassi;
> >  delete sirf self-defined slave config;
> >  fix feedback from vinod;
> >  fix filter function: we have two dmac, clients drivers think the chan id as
> 0~31;
> >  rename regs to base;
> >  delete redundant chan_id initialization in probe since dmaengine core will
> >  re-write it, refer to my patch too:
> >  [PATCH] dmaengine: delete redundant chan_id and chancnt initialization in
> dma drivers
> >  http://www.spinics.net/lists/kernel/msg1237455.html
> >
> >  this patch doesn't provide a common way for filter and doesn't use the
> jassi's v2 patch.
> > +
> > +static int sirfsoc_dma_slave_config(struct sirfsoc_dma_chan *schan,
> > +	struct dma_slave_config *config)
> > +{
> > +	u32 addr, direction;
> > +	unsigned long flags;
> > +
> > +	switch (config->direction) {
> > +	case DMA_FROM_DEVICE:
> > +		direction = 0;
> > +		addr = config->dst_addr;
> > +		break;
> > +
> > +	case DMA_TO_DEVICE:
> > +		direction = 1;
> > +		addr = config->src_addr;
> > +		break;
> > +
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +
> > +	if ((config->src_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES) ||
> > +		(config->dst_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES))
> > +		return -EINVAL;
> > +
> > +	spin_lock_irqsave(&schan->lock, flags);
> > +	schan->addr = addr;
> > +	schan->direction = direction;
> > +	schan->mode = (config->src_maxburst == 4 ? 1 : 0);
> > +	spin_unlock_irqrestore(&schan->lock, flags);
> Not sure why you support this, there seem to be no DMA_SLAVE support in
> this version ate least

Not. I support dma_slave. But I have no prep_slave_sg function since I can use the gen xfer to replace it.

> > +
> > +	return 0;
> > +}
> > +
> > +
> > +
> > +/* Alloc channel resources */
> > +static int sirfsoc_dma_alloc_chan_resources(struct dma_chan *chan)
> > +{
> > +	struct sirfsoc_dma *sdma = dma_chan_to_sirfsoc_dma(chan);
> > +	struct sirfsoc_dma_chan *schan =
> dma_chan_to_sirfsoc_dma_chan(chan);
> > +	struct sirfsoc_dma_desc *sdesc;
> > +	unsigned long flags;
> > +	LIST_HEAD(descs);
> > +	int i;
> > +
> > +	/* Alloc descriptors for this channel */
> > +	for (i = 0; i < SIRFSOC_DMA_DESCRIPTORS; i++) {
> > +		sdesc = kzalloc(sizeof(struct sirfsoc_dma_desc), GFP_KERNEL);
> kernel convention is kzalloc(sizeof(*sdesc),....)

Ok.
> 
> > +		if (!sdesc) {
> > +			dev_notice(sdma->dma.dev, "Memory allocation error. "
> > +				"Allocated only %u descriptors\n", i);
> > +			break;
> > +		}
> > +
> > +		dma_async_tx_descriptor_init(&sdesc->desc, chan);
> > +		sdesc->desc.flags = DMA_CTRL_ACK;
> > +		sdesc->desc.tx_submit = sirfsoc_dma_tx_submit;
> > +
> > +		list_add_tail(&sdesc->node, &descs);
> > +	}
> > +
> > +	/* Return error only if no descriptors were allocated */
> > +	if (i == 0)
> > +		return -ENOMEM;
> > +
> > +	spin_lock_irqsave(&schan->lock, flags);
> > +
> > +	list_splice_tail_init(&descs, &schan->free);
> > +	spin_unlock_irqrestore(&schan->lock, flags);
> > +
> > +	return 0;
> it should be return i; You are supposed to return the number of desc
> allocated.
> 
Ok.
> 
> > +
> > +/* Check request completion status */
> > +static enum dma_status
> > +sirfsoc_dma_tx_status(struct dma_chan *chan, dma_cookie_t cookie,
> > +	struct dma_tx_state *txstate)
> > +{
> > +	struct sirfsoc_dma_chan *schan =
> dma_chan_to_sirfsoc_dma_chan(chan);
> > +	unsigned long flags;
> > +	dma_cookie_t last_used;
> > +	dma_cookie_t last_complete;
> > +
> > +	spin_lock_irqsave(&schan->lock, flags);
> > +	last_used = schan->chan.cookie;
> > +	last_complete = schan->completed_cookie;
> > +	spin_unlock_irqrestore(&schan->lock, flags);
> > +
> > +	dma_set_tx_state(txstate, last_complete, last_used, 0);
> > +	return dma_async_is_complete(cookie, last_complete, last_used);
> > +}
> > +
> > +static struct dma_async_tx_descriptor *sirfsoc_dma_prep_slave_sg(
> > +	struct dma_chan *chan, struct scatterlist *sgl,
> > +	unsigned int sg_len, enum dma_data_direction direction,
> > +	unsigned long flags)
> > +{
> > +	return NULL;
> > +}
> Please remove this until you support it...

Now I am supporting slave by gen xfer. I don't need this function, but a BUG_ON check will cause oops. Jassi would like to delete the BUG_ON check.

         BUG_ON(dma_has_cap(DMA_SLAVE, device->cap_mask) &&
                 !device->device_prep_slave_sg);
> 
> 
> > +}
> > +
> > +/*
> > + * The DMA controller consists of 16 independent DMA channels.
> > + * Each channel is allocated to a different function
> > + */
> > +bool sirfsoc_dma_filter_id(struct dma_chan *chan, void *chan_id)
> > +{
> > +	unsigned int ch_nr = (unsigned int) chan_id;
> > +
> > +	if (ch_nr == chan->chan_id +
> > +		chan->device->dev_id * SIRFSOC_DMA_CHANNELS)
> > +		return true;
> > +
> > +	return false;
> > +}
> > +EXPORT_SYMBOL(sirfsoc_dma_filter_id);
> > +
> > +static int __devinit sirfsoc_dma_probe(struct platform_device *op)
> > +{
> > +	struct device_node *dn = op->dev.of_node;
> > +	struct device *dev = &op->dev;
> > +	struct dma_device *dma;
> > +	struct sirfsoc_dma *sdma;
> > +	struct sirfsoc_dma_chan *schan;
> > +	struct resource res;
> > +	ulong regs_start, regs_size;
> > +	u32 id;
> > +	int retval, i;
> > +
> > +	sdma = devm_kzalloc(dev, sizeof(struct sirfsoc_dma), GFP_KERNEL);
> ditto...

ok. Just copied from mpc, but ignore this :-)

> 
> > +	if (!sdma) {
> > +		dev_err(dev, "Memory exhausted!\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	if (of_property_read_u32(dn, "cell-index", &id)) {
> > +		dev_err(dev, "Fail to get DMAC index\n");
> > +		return -ENODEV;
> kfree(sdma) ??
> 
> > +	}
> > +
> > +	sdma->irq = irq_of_parse_and_map(dn, 0);
> > +	if (sdma->irq == NO_IRQ) {
> > +		dev_err(dev, "Error mapping IRQ!\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	retval = of_address_to_resource(dn, 0, &res);
> > +	if (retval) {
> > +		dev_err(dev, "Error parsing memory region!\n");
> > +		return retval;
> > +	}
> > +
> > +	regs_start = res.start;
> > +	regs_size = resource_size(&res);
> > +
> > +	if (!devm_request_mem_region(dev, regs_start, regs_size, DRV_NAME)) {
> > +		dev_err(dev, "Error requesting memory region!\n");
> > +		return -EBUSY;
> > +	}
> > +
> > +	sdma->base = devm_ioremap(dev, regs_start, regs_size);
> > +	if (!sdma->base) {
> > +		dev_err(dev, "Error mapping memory region!\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	retval = devm_request_irq(dev, sdma->irq, &sirfsoc_dma_irq, 0,
> DRV_NAME,
> > +		sdma);
> > +	if (retval) {
> > +		dev_err(dev, "Error requesting IRQ!\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	dma = &sdma->dma;
> > +	dma->dev = dev;
> > +	dma->chancnt = SIRFSOC_DMA_CHANNELS;
> > +
> > +	dma->device_alloc_chan_resources = sirfsoc_dma_alloc_chan_resources;
> > +	dma->device_free_chan_resources = sirfsoc_dma_free_chan_resources;
> > +	dma->device_issue_pending = sirfsoc_dma_issue_pending;
> > +	dma->device_control = sirfsoc_dma_control;
> > +	dma->device_tx_status = sirfsoc_dma_tx_status;
> > +	dma->device_prep_slave_sg = sirfsoc_dma_prep_slave_sg;
> > +	dma->device_prep_dma_genxfer = sirfsoc_dma_prep_genxfer;
> > +
> > +	INIT_LIST_HEAD(&dma->channels);
> > +	dma_cap_set(DMA_SLAVE, dma->cap_mask);
> No you don't support DMA_SLAVE yet.
> 
> 
> > +MODULE_AUTHOR("Rongjun Ying <rongjun.ying@csr.com>, "
> > +	"Barry Song <baohua.song@csr.com>");
> > +MODULE_DESCRIPTION("SIRFSOC DMA control driver");
> > +MODULE_LICENSE("GPL");
> Your header says GPLV2 or later, here its GPL only???

Gpl v2 actually

> 
> 
> --
> ~Vinod

-barry



Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
More information can be found at www.csr.com. Follow CSR on Twitter at http://twitter.com/CSR_PLC and read our blog at www.csr.com/blog
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
