Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab2HVDhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 23:37:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:12441 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752955Ab2HVDhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 23:37:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,807,1336374000"; 
   d="scan'208";a="212037588"
Subject: Re: [PATCH v2 1/3] dmaengine: add TI EDMA DMA engine driver
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Matt Porter <mporter@ti.com>
Cc: cjb@laptop.org, grant.likely@secretlab.ca,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Sekhar Nori <nsekhar@ti.com>
In-Reply-To: <1345574589-24757-2-git-send-email-mporter@ti.com>
References: <1345574589-24757-1-git-send-email-mporter@ti.com>
	 <1345574589-24757-2-git-send-email-mporter@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Aug 2012 09:09:26 +0530
Message-ID: <1345606766.1895.40.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-21 at 14:43 -0400, Matt Porter wrote:
> Add a DMA engine driver for the TI EDMA controller. This driver
> is implemented as a wrapper around the existing DaVinci private
> DMA implementation. This approach allows for incremental conversion
> of each peripheral driver to the DMA engine API. The EDMA driver
> supports slave transfers but does not yet support cyclic transfers.
> 
> Signed-off-by: Matt Porter <mporter@ti.com>
mostly looks decent and in shape.

> ---
> +config TI_EDMA
> +	tristate "TI EDMA support"
> +	depends on ARCH_DAVINCI
> +	select DMA_ENGINE
> +	select DMA_VIRTUAL_CHANNELS
> +	default y
default should be n for new drivers

> +	help
> +	  Enable support for the TI EDMA controller. This DMA
> +	  engine is found on TI DaVinci and AM33xx parts.
> +
>  config ARCH_HAS_ASYNC_TX_FIND_CHANNEL
>  	bool
>  
> +/* Max of 16 segments per channel to conserve PaRAM slots */
> +#define MAX_NR_SG		16
> +#define EDMA_MAX_SLOTS		MAX_NR_SG
> +#define EDMA_DESCRIPTORS	16
> +
> +struct edma_desc {
> +	struct virt_dma_desc		vdesc;
> +	struct list_head		node;
> +
dummy space?
> +	int				absync;
> +	int				pset_nr;
> +	struct edmacc_param		pset[0];
> +};
> +
> +struct edma_cc;
> +
> +struct edma_chan {
> +	struct virt_dma_chan		vchan;
> +	struct list_head		node;
> +	struct edma_desc		*edesc;
> +	struct edma_cc			*ecc;
> +	int				ch_num;
> +	bool				alloced;
> +	int				slot[EDMA_MAX_SLOTS];
> +
> +	dma_addr_t			addr;
> +	int				addr_width;
> +	int				maxburst;
> +};
> +

> +/* Dispatch a queued descriptor to the controller (caller holds lock) */
> +static void edma_execute(struct edma_chan *echan)
> +{
> +	struct virt_dma_desc *vdesc = vchan_next_desc(&echan->vchan);
> +	struct edma_desc *edesc;
> +	int i;
> +
> +	if (!vdesc) {
> +		echan->edesc = NULL;
> +		return;
> +	}
> +
> +	list_del(&vdesc->node);
> +
> +	echan->edesc = edesc = to_edma_desc(&vdesc->tx);
> +
> +	/* Write descriptor PaRAM set(s) */
> +	for (i = 0; i < edesc->pset_nr; i++) {
> +		edma_write_slot(echan->slot[i], &edesc->pset[i]);
> +		dev_dbg(echan->vchan.chan.device->dev,
> +			"\n pset[%d]:\n"
> +			"  chnum\t%d\n"
> +			"  slot\t%d\n"
> +			"  opt\t%08x\n"
> +			"  src\t%08x\n"
> +			"  dst\t%08x\n"
> +			"  abcnt\t%08x\n"
> +			"  ccnt\t%08x\n"
> +			"  bidx\t%08x\n"
> +			"  cidx\t%08x\n"
> +			"  lkrld\t%08x\n",
> +			i, echan->ch_num, echan->slot[i],
> +			edesc->pset[i].opt,
> +			edesc->pset[i].src,
> +			edesc->pset[i].dst,
> +			edesc->pset[i].a_b_cnt,
> +			edesc->pset[i].ccnt,
> +			edesc->pset[i].src_dst_bidx,
> +			edesc->pset[i].src_dst_cidx,
> +			edesc->pset[i].link_bcntrld);
> +		/* Link to the previous slot if not the last set */
> +		if (i != (edesc->pset_nr - 1))
> +			edma_link(echan->slot[i], echan->slot[i+1]);
> +		/* Final pset links to the dummy pset */
> +		else
> +			edma_link(echan->slot[i], echan->ecc->dummy_slot);
> +	}
> +
> +	edma_start(echan->ch_num);
> +}
> +
> +static int edma_terminate_all(struct edma_chan *echan)
> +{
> +	unsigned long flags;
> +	LIST_HEAD(head);
> +
> +	spin_lock_irqsave(&echan->vchan.lock, flags);
> +
> +	/*
> +	 * Stop DMA activity: we assume the callback will not be called
> +	 * after edma_dma() returns (even if it does, it will see
> +	 * echan->edesc is NULL and exit.)
> +	 */
> +	if (echan->edesc) {
> +		echan->edesc = NULL;
> +		edma_stop(echan->ch_num);
> +	}
> +
> +	vchan_get_all_descriptors(&echan->vchan, &head);
> +	spin_unlock_irqrestore(&echan->vchan.lock, flags);
> +	vchan_dma_desc_free_list(&echan->vchan, &head);
> +
> +	return 0;
> +}
> +
> +
> +static int edma_slave_config(struct edma_chan *echan,
> +	struct dma_slave_config *config)
> +{
> +	if ((config->src_addr_width > DMA_SLAVE_BUSWIDTH_4_BYTES) ||
> +		(config->dst_addr_width > DMA_SLAVE_BUSWIDTH_4_BYTES))
> +		return -EINVAL;
the indent needs help here
> +
> +	if (config->direction == DMA_MEM_TO_DEV) {
> +		if (config->dst_addr)
> +			echan->addr = config->dst_addr;
> +		if (config->dst_addr_width)
> +			echan->addr_width = config->dst_addr_width;
> +		if (config->dst_maxburst)
> +			echan->maxburst = config->dst_maxburst;
> +	} else if (config->direction == DMA_DEV_TO_MEM) {
> +		if (config->src_addr)
> +			echan->addr = config->src_addr;
> +		if (config->src_addr_width)
> +			echan->addr_width = config->src_addr_width;
> +		if (config->src_maxburst)
> +			echan->maxburst = config->src_maxburst;
> +	}
> +
> +	return 0;
> +}
> +
> +static int edma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
> +			unsigned long arg)
> +{
> +	int ret = 0;
> +	struct dma_slave_config *config;
> +	struct edma_chan *echan = to_edma_chan(chan);
> +
> +	switch (cmd) {
> +	case DMA_TERMINATE_ALL:
> +		edma_terminate_all(echan);
> +		break;
> +	case DMA_SLAVE_CONFIG:
> +		config = (struct dma_slave_config *)arg;
> +		ret = edma_slave_config(echan, config);
> +		break;
> +	default:
> +		ret = -ENOSYS;
> +	}
> +
> +	return ret;
> +}
> +
> +static struct dma_async_tx_descriptor *edma_prep_slave_sg(
> +	struct dma_chan *chan, struct scatterlist *sgl,
> +	unsigned int sg_len, enum dma_transfer_direction direction,
> +	unsigned long tx_flags, void *context)
> +{
> +	struct edma_chan *echan = to_edma_chan(chan);
> +	struct device *dev = echan->vchan.chan.device->dev;
> +	struct edma_desc *edesc;
> +	struct scatterlist *sg;
> +	int i;
> +	int acnt, bcnt, ccnt, src, dst, cidx;
> +	int src_bidx, dst_bidx, src_cidx, dst_cidx;
> +
> +	if (unlikely(!echan || !sgl || !sg_len))
> +		return NULL;
> +
> +	if (echan->addr_width == DMA_SLAVE_BUSWIDTH_UNDEFINED) {
> +		dev_err(dev, "Undefined slave buswidth\n");
> +		return NULL;
> +	}
> +
> +	if (sg_len > MAX_NR_SG) {
> +		dev_err(dev, "Exceeded max SG segments %d > %d\n",
> +			sg_len, MAX_NR_SG);
> +		return NULL;
> +	}
> +
> +	edesc = kzalloc(sizeof(*edesc) + sg_len *
> +		sizeof(edesc->pset[0]), GFP_ATOMIC);
> +	if (!edesc) {
> +		dev_dbg(dev, "Failed to allocate a descriptor\n");
> +		return NULL;
> +	}
> +
> +	edesc->pset_nr = sg_len;
> +
> +	for_each_sg(sgl, sg, sg_len, i) {
> +		/* Allocate a PaRAM slot, if needed */
> +		if (echan->slot[i] < 0) {
> +			echan->slot[i] =
> +				edma_alloc_slot(EDMA_CTLR(echan->ch_num),
> +						EDMA_SLOT_ANY);
> +			if (echan->slot[i] < 0) {
> +				dev_err(dev, "Failed to allocate slot\n");
> +				return NULL;
> +			}
> +		}
> +
> +		acnt = echan->addr_width;
> +
> +		/*
> +		 * If the maxburst is equal to the fifo width, use
> +		 * A-synced transfers. This allows for large contiguous
> +		 * buffer transfers using only one PaRAM set.
> +		 */
> +		if (echan->maxburst == 1) {
> +			edesc->absync = false;
> +			ccnt = sg_dma_len(sg) / acnt / (SZ_64K - 1);
> +			bcnt = sg_dma_len(sg) / acnt - ccnt * (SZ_64K - 1);
> +			if (bcnt)
> +				ccnt++;
> +			else
> +				bcnt = SZ_64K - 1;
> +			cidx = acnt;
> +		/*
> +		 * If maxburst is greater than the fifo address_width,
> +		 * use AB-synced transfers where A count is the fifo
> +		 * address_width and B count is the maxburst. In this
> +		 * case, we are limited to transfers of C count frames
> +		 * of (address_width * maxburst) where C count is limited
> +		 * to SZ_64K-1. This places an upper bound on the length
> +		 * of an SG segment that can be handled.
> +		 */
> +		} else {
> +			edesc->absync = true;
> +			bcnt = echan->maxburst;
> +			ccnt = sg_dma_len(sg) / (acnt * bcnt);
> +			if (ccnt > (SZ_64K - 1)) {
> +				dev_err(dev, "Exceeded max SG segment size\n");
> +				return NULL;
> +			}
> +			cidx = acnt * bcnt;
> +		}
> +
> +		if (direction == DMA_MEM_TO_DEV) {
> +			src = sg_dma_address(sg);
> +			dst = echan->addr;
> +			src_bidx = acnt;
> +			src_cidx = cidx;
> +			dst_bidx = 0;
> +			dst_cidx = 0;
> +		} else {
> +			src = echan->addr;
> +			dst = sg_dma_address(sg);
> +			src_bidx = 0;
> +			src_cidx = 0;
> +			dst_bidx = acnt;
> +			dst_cidx = cidx;
> +		}
> +
> +		edesc->pset[i].opt = EDMA_TCC(EDMA_CHAN_SLOT(echan->ch_num));
> +		/* Configure A or AB synchronized transfers */
> +		if (edesc->absync)
> +			edesc->pset[i].opt |= SYNCDIM;
> +		/* If this is the last set, enable completion interrupt flag */
> +		if (i == sg_len - 1)
> +			edesc->pset[i].opt |= TCINTEN;
> +
> +		edesc->pset[i].src = src;
> +		edesc->pset[i].dst = dst;
> +
> +		edesc->pset[i].src_dst_bidx = (dst_bidx << 16) | src_bidx;
> +		edesc->pset[i].src_dst_cidx = (dst_cidx << 16) | src_cidx;
> +
> +		edesc->pset[i].a_b_cnt = bcnt << 16 | acnt;
> +		edesc->pset[i].ccnt = ccnt;
> +		edesc->pset[i].link_bcntrld = 0xffffffff;
> +
> +	}
> +
> +	return vchan_tx_prep(&echan->vchan, &edesc->vdesc, tx_flags);
> +}
> +
> +static void edma_callback(unsigned ch_num, u16 ch_status, void *data)
> +{
> +	struct edma_chan *echan = data;
> +	struct device *dev = echan->vchan.chan.device->dev;
> +	struct edma_desc *edesc;
> +	unsigned long flags;
> +
> +	/* Stop the channel */
> +	edma_stop(echan->ch_num);
> +
> +	switch (ch_status) {
> +	case DMA_COMPLETE:
> +		dev_dbg(dev, "transfer complete on channel %d\n", ch_num);
> +
> +		spin_lock_irqsave(&echan->vchan.lock, flags);
> +
> +		edesc = echan->edesc;
> +		if (edesc) {
> +			edma_execute(echan);
> +			vchan_cookie_complete(&edesc->vdesc);
> +		}
> +
> +		spin_unlock_irqrestore(&echan->vchan.lock, flags);
> +
> +		break;
> +	case DMA_CC_ERROR:
> +		dev_dbg(dev, "transfer error on channel %d\n", ch_num);
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
> +/* Alloc channel resources */
> +static int edma_alloc_chan_resources(struct dma_chan *chan)
> +{
> +	struct edma_chan *echan = to_edma_chan(chan);
> +	struct device *dev = echan->vchan.chan.device->dev;
> +	int ret;
> +	int a_ch_num;
> +	LIST_HEAD(descs);
> +
> +	a_ch_num = edma_alloc_channel(echan->ch_num, edma_callback,
> +					chan, EVENTQ_DEFAULT);
> +
> +	if (a_ch_num < 0) {
> +		ret = -ENODEV;
> +		goto err_no_chan;
> +	}
> +
> +	if (a_ch_num != echan->ch_num) {
> +		dev_err(dev, "failed to allocate requested channel %u:%u\n",
> +			EDMA_CTLR(echan->ch_num),
> +			EDMA_CHAN_SLOT(echan->ch_num));
> +		ret = -ENODEV;
> +		goto err_wrong_chan;
> +	}
> +
> +	echan->alloced = true;
> +	echan->slot[0] = echan->ch_num;
> +
> +	dev_info(dev, "allocated channel for %u:%u\n",
> +		 EDMA_CTLR(echan->ch_num), EDMA_CHAN_SLOT(echan->ch_num));
> +
> +	return 0;
> +
> +err_wrong_chan:
> +	edma_free_channel(a_ch_num);
> +err_no_chan:
> +	return ret;
> +}
> +
> +/* Free channel resources */
> +static void edma_free_chan_resources(struct dma_chan *chan)
> +{
> +	struct edma_chan *echan = to_edma_chan(chan);
> +	struct device *dev = echan->vchan.chan.device->dev;
perhaps, chan->dev->device
> +	int i;
> +
> +	/* Terminate transfers */
> +	edma_stop(echan->ch_num);
> +
> +	vchan_free_chan_resources(&echan->vchan);
> +
> +	/* Free EDMA PaRAM slots */
> +	for (i = 1; i < EDMA_MAX_SLOTS; i++) {
> +		if (echan->slot[i] >= 0) {
> +			edma_free_slot(echan->slot[i]);
> +			echan->slot[i] = -1;
> +		}
> +	}
> +
> +	/* Free EDMA channel */
> +	if (echan->alloced) {
> +		edma_free_channel(echan->ch_num);
> +		echan->alloced = false;
> +	}
> +
> +	dev_info(dev, "freeing channel for %u\n", echan->ch_num);
> +}
> +
> +static void __init edma_chan_init(struct edma_cc *ecc,
> +				  struct dma_device *dma,
> +				  struct edma_chan *echans)
> +{
> +	int i, j;
> +	int chcnt = 0;
> +
> +	for (i = 0; i < EDMA_CHANS; i++) {
> +		struct edma_chan *echan = &echans[chcnt];
> +		echan->ch_num = EDMA_CTLR_CHAN(ecc->ctlr, i);
> +		echan->ecc = ecc;
> +		echan->vchan.desc_free = edma_desc_free;
> +
> +		vchan_init(&echan->vchan, dma);
> +
> +		INIT_LIST_HEAD(&echan->node);
> +		for (j = 0; j < EDMA_MAX_SLOTS; j++)
> +			echan->slot[j] = -1;
> +
> +		chcnt++;
i see no reason why you cant remove "chcnt" and use "i".
> +	}
> +}
> +
> +static void edma_dma_init(struct edma_cc *ecc, struct dma_device *dma,
> +			  struct device *dev)
> +{
> +	if (dma_has_cap(DMA_SLAVE, dma->cap_mask))
> +		dma->device_prep_slave_sg = edma_prep_slave_sg;
You have set DMA_SLAVE unconditionally in your probe, so this seems
bogus.
> +
> +	dma->device_alloc_chan_resources = edma_alloc_chan_resources;
> +	dma->device_free_chan_resources = edma_free_chan_resources;
> +	dma->device_issue_pending = edma_issue_pending;
> +	dma->device_tx_status = edma_tx_status;
> +	dma->device_control = edma_control;
> +	dma->dev = dev;
> +
> +	INIT_LIST_HEAD(&dma->channels);
> +}
> +
> +static int __devinit edma_probe(struct platform_device *pdev)
> +{
> +	struct edma_cc *ecc;
> +	int ret;
> +
> +	ecc = devm_kzalloc(&pdev->dev, sizeof(*ecc), GFP_KERNEL);
> +	if (!ecc) {
> +		dev_err(&pdev->dev, "Can't allocate controller\n");
> +		ret = -ENOMEM;
> +		goto err_alloc_ecc;
you can just return here, you are using devm_ friends here
> +	}
> +
> +	ecc->ctlr = pdev->id;
> +	ecc->dummy_slot = edma_alloc_slot(ecc->ctlr, EDMA_SLOT_ANY);
> +	if (ecc->dummy_slot < 0) {
> +		dev_err(&pdev->dev, "Can't allocate PaRAM dummy slot\n");
> +		ret = -EIO;
> +		goto err_alloc_slot;
ditto, just return!
> +	}
> +
> +	dma_cap_zero(ecc->dma_slave.cap_mask);
> +	dma_cap_set(DMA_SLAVE, ecc->dma_slave.cap_mask);
> +
> +	edma_dma_init(ecc, &ecc->dma_slave, &pdev->dev);
> +
> +	edma_chan_init(ecc, &ecc->dma_slave, ecc->slave_chans);
> +
> +	ret = dma_async_device_register(&ecc->dma_slave);
> +	if (ret)
> +		goto err_reg1;
> +
> +	platform_set_drvdata(pdev, ecc);
> +
> +	dev_info(&pdev->dev, "TI EDMA DMA engine driver\n");
> +
> +	return 0;
> +
> +err_reg1:
> +	edma_free_slot(ecc->dummy_slot);
> +err_alloc_slot:
> +	devm_kfree(&pdev->dev, ecc);
> +err_alloc_ecc:
> +	return ret;
> +}
> +
> +static int __devexit edma_remove(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct edma_cc *ecc = dev_get_drvdata(dev);
> +
> +	dma_async_device_unregister(&ecc->dma_slave);
> +	edma_free_slot(ecc->dummy_slot);
> +	devm_kfree(dev, ecc);
no need to call this, it is *managed* resource
> +
> +	return 0;
> +}
> +

-- 
~Vinod

