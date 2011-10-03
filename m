Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab1JCRzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 13:55:05 -0400
Received: from mxout1.idt.com ([157.165.5.25]:43481 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756728Ab1JCRy7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 13:54:59 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [RFC PATCH 2/2 -mm] RapidIO: TSI721 Add DMA Engine support
Date: Mon, 3 Oct 2011 10:53:45 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E55202291E8D@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <20110930151544.31875132.akpm00@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC PATCH 2/2 -mm] RapidIO: TSI721 Add DMA Engine support
Thread-Index: Acx/vov/LHGB7F0AQdCvobyOM3muJgCLwWrg
References: <1317418715-9666-1-git-send-email-alexandre.bounine@idt.com><1317418715-9666-2-git-send-email-alexandre.bounine@idt.com> <20110930151544.31875132.akpm00@gmail.com>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Andrew Morton <akpm00@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wroye:
> 
> On Fri, 30 Sep 2011 17:38:35 -0400
> Alexandre Bounine <alexandre.bounine@idt.com> wrote:
> 
> > Adds support for DMA Engine API.
> >
> > Includes following changes:
> > - Modifies BDMA register offset definitions to support per-channel
> handling
> > - Separates BDMA channel reserved for RIO Maintenance requests
> > - Adds DMA Engine callback routines
> >
> > ...
> >
> >  5 files changed, 1029 insertions(+), 90 deletions(-)
> 
> hm, what a lot of code.

This is mostly new stuff for that driver.

> 
> > +config TSI721_DMA
> > +	bool "IDT Tsi721 RapidIO DMA support"
> > +	depends on RAPIDIO_TSI721
> > +	default "n"
> > +	select RAPIDIO_DMA_ENGINE
> > +	help
> > +	  Enable DMA support for IDT Tsi721 PCIe-to-SRIO controller.
> 
> Do we really need to offer this decision to the user?  If possible it
> would be better to always enable the feature where that makes sense.
> Better code coverage, less maintenance effort, more effective testing
> effort, possibly cleaner code.

Agree. Influence of dmaengine here ;)
But we still need RAPIDIO_DMA_ENGINE option to control DMA
configuration for devices that are RIO targets only. 

> 
> >
> > ...
> >
> > +static int tsi721_bdma_ch_init(struct tsi721_bdma_chan *chan)
> > +{
> > +	struct tsi721_dma_desc *bd_ptr;
> > +	struct device *dev = chan->dchan.device->dev;
> > +	u64		*sts_ptr;
> > +	dma_addr_t	bd_phys;
> > +	dma_addr_t	sts_phys;
> > +	int		sts_size;
> > +	int		bd_num = chan->bd_num;
> > +
> > +	dev_dbg(dev, "Init Block DMA Engine, CH%d\n", chan->id);
> > +
> > +	/* Allocate space for DMA descriptors */
> > +	bd_ptr = dma_alloc_coherent(dev,
> > +				bd_num * sizeof(struct tsi721_dma_desc),
> > +				&bd_phys, GFP_KERNEL);
> > +	if (!bd_ptr)
> > +		return -ENOMEM;
> > +
> > +	chan->bd_phys = bd_phys;
> > +	chan->bd_base = bd_ptr;
> > +
> > +	memset(bd_ptr, 0, bd_num * sizeof(struct tsi721_dma_desc));
> > +
> > +	dev_dbg(dev, "DMA descriptors @ %p (phys = %llx)\n",
> > +		bd_ptr, (unsigned long long)bd_phys);
> > +
> > +	/* Allocate space for descriptor status FIFO */
> > +	sts_size = (bd_num >= TSI721_DMA_MINSTSSZ) ?
> > +					bd_num : TSI721_DMA_MINSTSSZ;
> > +	sts_size = roundup_pow_of_two(sts_size);
> > +	sts_ptr = dma_alloc_coherent(dev,
> > +				     sts_size * sizeof(struct
tsi721_dma_sts),
> > +				     &sts_phys, GFP_KERNEL);
> > +	if (!sts_ptr) {
> > +		/* Free space allocated for DMA descriptors */
> > +		dma_free_coherent(dev,
> > +				  bd_num * sizeof(struct
tsi721_dma_desc),
> > +				  bd_ptr, bd_phys);
> > +		chan->bd_base = NULL;
> > +		return -ENOMEM;
> > +	}
> > +
> > +	chan->sts_phys = sts_phys;
> > +	chan->sts_base = sts_ptr;
> > +	chan->sts_size = sts_size;
> > +
> > +	memset(sts_ptr, 0, sts_size);
> 
> You meant

I really need it here. That status block tracks progress by keeping
non-zero addresses of processed descriptors.
 
> 
> --- a/drivers/rapidio/devices/tsi721.c~rapidio-tsi721-add-dma-engine-
> support-fix
> +++ a/drivers/rapidio/devices/tsi721.c
> @@ -1006,7 +1006,7 @@ static int tsi721_bdma_maint_init(struct
>  	priv->mdma.sts_base = sts_ptr;
>  	priv->mdma.sts_size = sts_size;
> 
> -	memset(sts_ptr, 0, sts_size);
> +	memset(sts_ptr, 0, sts_size * sizeof(struct tsi721_dma_sts));
> 
>  	dev_dbg(&priv->pdev->dev,
>  		"desc status FIFO @ %p (phys = %llx) size=0x%x\n",
> 
> However that's at least two instances where you wanted a
> dma_zalloc_coherent().  How's about we give ourselves one?

Does this mean that I am on hook for it as a "most frequent user"?

> 
> 
> > +	dev_dbg(dev,
> > +		"desc status FIFO @ %p (phys = %llx) size=0x%x\n",
> > +		sts_ptr, (unsigned long long)sts_phys, sts_size);
> > +
> > +	/* Initialize DMA descriptors ring */
> > +	bd_ptr[bd_num - 1].type_id = cpu_to_le32(DTYPE3 << 29);
> > +	bd_ptr[bd_num - 1].next_lo = cpu_to_le32((u64)bd_phys &
> > +
TSI721_DMAC_DPTRL_MASK);
> > +	bd_ptr[bd_num - 1].next_hi = cpu_to_le32((u64)bd_phys >> 32);
> > +
> > +	/* Setup DMA descriptor pointers */
> > +	iowrite32(((u64)bd_phys >> 32),
> > +		chan->regs + TSI721_DMAC_DPTRH);
> > +	iowrite32(((u64)bd_phys & TSI721_DMAC_DPTRL_MASK),
> > +		chan->regs + TSI721_DMAC_DPTRL);
> > +
> > +	/* Setup descriptor status FIFO */
> > +	iowrite32(((u64)sts_phys >> 32),
> > +		chan->regs + TSI721_DMAC_DSBH);
> > +	iowrite32(((u64)sts_phys & TSI721_DMAC_DSBL_MASK),
> > +		chan->regs + TSI721_DMAC_DSBL);
> > +	iowrite32(TSI721_DMAC_DSSZ_SIZE(sts_size),
> > +		chan->regs + TSI721_DMAC_DSSZ);
> > +
> > +	/* Clear interrupt bits */
> > +	iowrite32(TSI721_DMAC_INT_ALL,
> > +		chan->regs + TSI721_DMAC_INT);
> > +
> > +	ioread32(chan->regs + TSI721_DMAC_INT);
> > +
> > +	/* Toggle DMA channel initialization */
> > +	iowrite32(TSI721_DMAC_CTL_INIT,	chan->regs + TSI721_DMAC_CTL);
> > +	ioread32(chan->regs + TSI721_DMAC_CTL);
> > +	chan->wr_count = chan->wr_count_next = 0;
> > +	chan->sts_rdptr = 0;
> > +	udelay(10);
> > +
> > +	return 0;
> > +}
> > +
> >
> > ...
> >
> > +{
> > +	/* Disable BDMA channel interrupts */
> > +	iowrite32(0, chan->regs + TSI721_DMAC_INTE);
> > +
> > +	tasklet_schedule(&chan->tasklet);
> 
> I'm not seeing any tasklet_disable()s on the shutdown/rmmod paths.  Is
> there anything here which prevents shutdown races against a
> still-pending tasklet?

Marked for review.

> 
> > +}
> > +
> >
> > ...
> >
> > +static
> > +int tsi721_fill_desc(struct tsi721_bdma_chan *chan, struct
> tsi721_tx_desc *desc,
> > +	struct scatterlist *sg, enum dma_rtype rtype, u32 sys_size)
> > +{
> > +	struct tsi721_dma_desc *bd_ptr = desc->hw_desc;
> > +	u64 rio_addr;
> > +
> > +	if (sg_dma_len(sg) > TSI721_DMAD_BCOUNT1 + 1) {
> > +		dev_err(chan->dchan.device->dev, "SG element is too
> large\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	dev_dbg(chan->dchan.device->dev,
> > +		"desc: 0x%llx, addr: 0x%llx len: 0x%x\n",
> > +		(u64)desc->txd.phys, (unsigned long
> long)sg_dma_address(sg),
> > +		sg_dma_len(sg));
> > +
> > +	dev_dbg(chan->dchan.device->dev, "bd_ptr = %p did=%d
> raddr=0x%llx\n",
> > +		bd_ptr, desc->destid, desc->rio_addr);
> > +
> > +	/* Initialize DMA descriptor */
> > +	bd_ptr->type_id = cpu_to_le32((DTYPE1 << 29) |
> > +					(rtype << 19) | desc->destid);
> > +	if (desc->interrupt)
> > +		bd_ptr->type_id |= cpu_to_le32(TSI721_DMAD_IOF);
> > +	bd_ptr->bcount = cpu_to_le32(((desc->rio_addr & 0x3) << 30) |
> > +					(sys_size << 26) |
sg_dma_len(sg));
> > +	rio_addr = (desc->rio_addr >> 2) |
> > +				((u64)(desc->rio_addr_u & 0x3) << 62);
> > +	bd_ptr->raddr_lo = cpu_to_le32(rio_addr & 0xffffffff);
> > +	bd_ptr->raddr_hi = cpu_to_le32(rio_addr >> 32);
> > +	bd_ptr->t1.bufptr_lo = cpu_to_le32(
> > +					(u64)sg_dma_address(sg) &
0xffffffff);
> > +	bd_ptr->t1.bufptr_hi = cpu_to_le32((u64)sg_dma_address(sg) >>
> 32);
> > +	bd_ptr->t1.s_dist = 0;
> > +	bd_ptr->t1.s_size = 0;
> > +
> > +	mb();
> 
> Mystery barrier needs a comment explaining why it's here, please.
This
> is almost always the case with barriers.

Marked for review.

> 
> > +	return 0;
> > +}
> > +
> >
> > ...
> >
> > +static int tsi721_alloc_chan_resources(struct dma_chan *dchan)
> > +{
> > +	struct tsi721_bdma_chan *chan = to_tsi721_chan(dchan);
> > +	struct tsi721_device *priv = to_tsi721(dchan->device);
> > +	struct tsi721_tx_desc *desc = NULL;
> > +	LIST_HEAD(tmp_list);
> > +	int i;
> > +	int rc;
> > +
> > +	if (chan->bd_base)
> > +		return chan->bd_num - 1;
> > +
> > +	/* Initialize BDMA channel */
> > +	if (tsi721_bdma_ch_init(chan)) {
> > +		dev_err(dchan->device->dev, "Unable to initialize data
DMA"
> > +			" channel %d, aborting\n", chan->id);
> > +		return -ENOMEM;
> > +	}
> > +
> > +	/* Allocate matching number of logical descriptors */
> > +	desc = kzalloc((chan->bd_num - 1) * sizeof(struct
> tsi721_tx_desc),
> > +			GFP_KERNEL);
> 
> kcalloc() would be a better fit here.

Agree. Would look more clear.

> 
> > +	if (!desc) {
> > +		dev_err(dchan->device->dev,
> > +			"Failed to allocate logical descriptors\n");
> > +		rc = -ENOMEM;
> > +		goto err_out;
> > +	}
> > +
> > +	chan->tx_desc = desc;
> > +
> > +	for (i = 0; i < chan->bd_num - 1; i++) {
> > +		dma_async_tx_descriptor_init(&desc[i].txd, dchan);
> > +		desc[i].txd.tx_submit = tsi721_tx_submit;
> > +		desc[i].txd.flags = DMA_CTRL_ACK;
> > +		INIT_LIST_HEAD(&desc[i].tx_list);
> > +		list_add_tail(&desc[i].desc_node, &tmp_list);
> > +	}
> > +
> > +	spin_lock_bh(&chan->lock);
> > +	list_splice(&tmp_list, &chan->free_list);
> > +	chan->completed_cookie = dchan->cookie = 1;
> > +	spin_unlock_bh(&chan->lock);
> > +
> > +#ifdef CONFIG_PCI_MSI
> > +	if (priv->flags & TSI721_USING_MSIX) {
> > +		/* Request interrupt service if we are in MSI-X mode */
> > +		rc = request_irq(
> > +			priv->msix[TSI721_VECT_DMA0_DONE +
chan->id].vector,
> > +			tsi721_bdma_msix, 0,
> > +			priv->msix[TSI721_VECT_DMA0_DONE + chan-
> >id].irq_name,
> > +			(void *)chan);
> > +
> > +		if (rc) {
> > +			dev_dbg(dchan->device->dev,
> > +				"Unable to allocate MSI-X interrupt for
"
> > +				"BDMA%d-DONE\n", chan->id);
> > +			goto err_out;
> > +		}
> > +
> > +		rc = request_irq(priv->msix[TSI721_VECT_DMA0_INT +
> > +					    chan->id].vector,
> > +			tsi721_bdma_msix, 0,
> > +			priv->msix[TSI721_VECT_DMA0_INT +
chan->id].irq_name,
> > +			(void *)chan);
> > +
> > +		if (rc)	{
> > +			dev_dbg(dchan->device->dev,
> > +				"Unable to allocate MSI-X interrupt for
"
> > +				"BDMA%d-INT\n", chan->id);
> > +			free_irq(
> > +				priv->msix[TSI721_VECT_DMA0_DONE +
> > +					   chan->id].vector,
> > +				(void *)chan);
> > +			rc = -EIO;
> > +			goto err_out;
> > +		}
> > +	}
> > +#endif /* CONFIG_PCI_MSI */
> > +
> > +	tsi721_bdma_interrupt_enable(chan, 1);
> > +
> > +	return chan->bd_num - 1;
> > +
> > +err_out:
> > +	kfree(desc);
> > +	tsi721_bdma_ch_free(chan);
> > +	return rc;
> > +}
> > +
> >
> > ...
> >
> > +static
> > +enum dma_status tsi721_tx_status(struct dma_chan *dchan,
> dma_cookie_t cookie,
> > +				 struct dma_tx_state *txstate)
> > +{
> > +	struct tsi721_bdma_chan *bdma_chan = to_tsi721_chan(dchan);
> > +	dma_cookie_t		last_used;
> > +	dma_cookie_t		last_completed;
> > +	int			ret;
> > +
> > +	spin_lock_irq(&bdma_chan->lock);
> > +	last_completed = bdma_chan->completed_cookie;
> > +	last_used = dchan->cookie;
> > +	spin_unlock_irq(&bdma_chan->lock);
> > +
> > +	ret = dma_async_is_complete(cookie, last_completed, last_used);
> > +
> > +	dma_set_tx_state(txstate, last_completed, last_used, 0);
> > +
> > +	dev_dbg(dchan->device->dev,
> > +		"%s: exit, ret: %d, last_completed: %d, last_used:
%d\n",
> > +		__func__, ret, last_completed, last_used);
> > +
> > +	return ret;
> > +}
> > +
> > +static void tsi721_issue_pending(struct dma_chan *dchan)
> > +{
> > +	struct tsi721_bdma_chan *chan = to_tsi721_chan(dchan);
> > +
> > +	dev_dbg(dchan->device->dev, "%s: Entry\n", __func__);
> > +
> > +	if (tsi721_dma_is_idle(chan)) {
> > +		spin_lock_bh(&chan->lock);
> > +		tsi721_advance_work(chan);
> > +		spin_unlock_bh(&chan->lock);
> > +	} else
> > +		dev_dbg(dchan->device->dev,
> > +			"%s: DMA channel still busy\n", __func__);
> > +}
> 
> I really don't like that a "struct tsi721_bdma_chan *" is called
"chan"
> in come places and "bdma_chan" in others.  "bdma_chan" is better.
> 
Agree. "bdma_chan" gives more device-specific meaning.
Opposite comment that I have heard was that this driver uses "dma" too
much.
Will unify to "bdma_chan".

> The code takes that lock with spin_lock_bh() in some places and
> spin_lock_irq() in others.  I trust there's some method to it all ;)
> Has
> it been carefully tested with lockdep enabled?

Ooops. Another prove that global replace does not work.
Cleared spin_lock_irqsave() well though ;)

lockdep is enabled on my test machine and it did not complain in
this case. I am using a test adopted from one in dmaengine and it
calls both routines that have spin_lock_irq(). 

> 
> >
> > ...
> >

Thank you,

Alex.
