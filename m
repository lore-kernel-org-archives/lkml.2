Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab1DFOcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 10:32:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:51765 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755871Ab1DFOcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 10:32:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,310,1299484800"; 
   d="scan'208";a="414792301"
Subject: Re: [PATCH 2/5] dmaengine: at_hdmac: add cyclic DMA operation
 support
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: dan.j.williams@intel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4D9C618A.9020708@atmel.com>
References: <3ee5a0e314a22339ad7a15a5425045f5ed244eab.1301678094.git.nicolas.ferre@atmel.com>
	 <426a1091ec74342f259f76ce404472b189730269.1301678094.git.nicolas.ferre@atmel.com>
	 <1302084507.27103.0.camel@vkoul-udesk3>  <4D9C618A.9020708@atmel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Apr 2011 19:32:35 +0530
Message-ID: <1302098555.27103.10.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-06 at 14:50 +0200, Nicolas Ferre wrote:
> Le 06/04/2011 12:08, Koul, Vinod :
> > On Fri, 2011-04-01 at 19:19 +0200, Nicolas Ferre wrote:
> >> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> >> ---
> >>  drivers/dma/at_hdmac.c      |  188 +++++++++++++++++++++++++++++++++++++++---
> >>  drivers/dma/at_hdmac_regs.h |   14 +++-
> >>  2 files changed, 186 insertions(+), 16 deletions(-)
> >>
> >> +static void atc_handle_cyclic(struct at_dma_chan *atchan)
> >> +{
> >> +	struct at_desc			*first = atc_first_active(atchan);
> >> +	struct dma_async_tx_descriptor	*txd = &first->txd;
> >> +	dma_async_tx_callback		callback = txd->callback;
> >> +	void				*param = txd->callback_param;
> >> +
> >> +	dev_vdbg(chan2dev(&atchan->chan_common),
> >> +			"new cyclic period llp 0x%08x\n",
> >> +			channel_readl(atchan, DSCR));
> >> +
> >> +	if (callback)
> >> +		callback(param);
> >> +}
> > You dont seem to be doing much expect calling callback, so doesn't it
> > make sense to write so much code for just calling callback? 
> 
> I do not totally follow you here: you mean that I should reduce the
> amount of variables in this function or is it a more global comment
> about my way of handling cyclic operations?
Well, in handling of cyclic operation you are only calling the callback
if set. If you plan to add more functionality to this function in future
then okay, otherwise you may reconsider this and avoid the function as
you are not doing much here, if it reduces code size. This is okay this
way also.
I had no comment on variables as I understand first two are unavoidable
> 
> >>  
> >>  /*--  IRQ & Tasklet  ---------------------------------------------------*/
> >>  
> >> @@ -434,8 +459,10 @@ static void atc_tasklet(unsigned long data)
> >>  	}
> >>  
> >>  	spin_lock(&atchan->lock);
> >> -	if (test_and_clear_bit(0, &atchan->error_status))
> >> +	if (test_and_clear_bit(ATC_IS_ERROR, &atchan->status))
> >>  		atc_handle_error(atchan);
> >> +	else if (test_bit(ATC_IS_CYCLIC, &atchan->status))
> >> +		atc_handle_cyclic(atchan);
> >>  	else
> >>  		atc_advance_work(atchan);
> >>  
> >> @@ -469,7 +496,7 @@ static irqreturn_t at_dma_interrupt(int irq, void *dev_id)
> >>  					/* Disable channel on AHB error */
> >>  					dma_writel(atdma, CHDR, atchan->mask);
> >>  					/* Give information to tasklet */
> >> -					set_bit(0, &atchan->error_status);
> >> +					set_bit(ATC_IS_ERROR, &atchan->status);
> >>  				}
> >>  				tasklet_schedule(&atchan->tasklet);
> >>  				ret = IRQ_HANDLED;
> >> @@ -759,6 +786,127 @@ err_desc_get:
> >>  	return NULL;
> >>  }
> >>  
> >> +/**
> >> + * atc_dma_cyclic_prep - prepare the cyclic DMA transfer
> >> + * @chan: the DMA channel to prepare
> >> + * @buf_addr: physical DMA address where the buffer starts
> >> + * @buf_len: total number of bytes for the entire buffer
> >> + * @period_len: number of bytes for each period
> >> + * @direction: transfer direction, to or from device
> >> + */
> >> +static struct dma_async_tx_descriptor *
> >> +atc_prep_dma_cyclic(struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
> >> +		size_t period_len, enum dma_data_direction direction)
> >> +{
> >> +	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
> >> +	struct at_dma_slave	*atslave = chan->private;
> >> +	struct at_desc		*first = NULL;
> >> +	struct at_desc		*prev = NULL;
> >> +	unsigned long		was_cyclic;
> >> +	unsigned int		periods = buf_len / period_len;
> >> +	unsigned int		reg_width;
> >> +	u32			ctrla;
> >> +	u32			ctrlb;
> >> +	unsigned int		i;
> >> +
> >> +	dev_vdbg(chan2dev(chan), "prep_dma_cyclic: %s buf@0x%08x - %d (%d/%d)\n",
> >> +			direction == DMA_TO_DEVICE ? "TO DEVICE" : "FROM DEVICE",
> >> +			buf_addr,
> >> +			periods, buf_len, period_len);
> >> +
> >> +	if (unlikely(!atslave || !buf_len || !period_len)) {
> >> +		dev_dbg(chan2dev(chan), "prep_dma_cyclic: length is zero!\n");
> >> +		return NULL;
> >> +	}
> >> +
> >> +	was_cyclic = test_and_set_bit(ATC_IS_CYCLIC, &atchan->status);
> >> +	if (was_cyclic) {
> >> +		dev_dbg(chan2dev(chan), "prep_dma_cyclic: channel in use!\n");
> >> +		return NULL;
> >> +	}
> >> +
> >> +	reg_width = atslave->reg_width;
> >> +
> >> +	/* Check for too big/unaligned periods and unaligned DMA buffer */
> >> +	if (period_len > (ATC_BTSIZE_MAX << reg_width))
> >> +		goto err_out;
> >> +	if (unlikely(period_len & ((1 << reg_width) - 1)))
> >> +		goto err_out;
> >> +	if (unlikely(buf_addr & ((1 << reg_width) - 1)))
> >> +		goto err_out;
> >> +	if (unlikely(!(direction & (DMA_TO_DEVICE | DMA_FROM_DEVICE))))
> >> +		goto err_out;
> >> +
> >> +	/* prepare common CRTLA/CTRLB values */
> >> +	ctrla =   ATC_DEFAULT_CTRLA | atslave->ctrla
> >> +		| ATC_DST_WIDTH(reg_width)
> >> +		| ATC_SRC_WIDTH(reg_width)
> >> +		| period_len >> reg_width;
> >> +	ctrlb = ATC_DEFAULT_CTRLB;
> >> +
> >> +	/* build cyclic linked list */
> >> +	for (i = 0; i < periods; i++) {
> > would help making code look cleaner if you split this one to seprate
> > function
> 
> Ok, I will see what I can do... and will post a v2 soon.
> 
> >> +		struct at_desc	*desc;
> >> +
> >> +		desc = atc_desc_get(atchan);
> >> +		if (!desc)
> >> +			goto err_desc_get;
> >> +
> >> +		switch (direction) {
> >> +		case DMA_TO_DEVICE:
> >> +			desc->lli.saddr = buf_addr + (period_len * i);
> >> +			desc->lli.daddr = atslave->tx_reg;
> >> +			desc->lli.ctrla = ctrla;
> >> +			desc->lli.ctrlb = ctrlb
> >> +					| ATC_DST_ADDR_MODE_FIXED
> >> +					| ATC_SRC_ADDR_MODE_INCR
> >> +					| ATC_FC_MEM2PER;
> >> +			break;
> >> +
> >> +		case DMA_FROM_DEVICE:
> >> +			desc->lli.saddr = atslave->rx_reg;
> >> +			desc->lli.daddr = buf_addr + (period_len * i);
> >> +			desc->lli.ctrla = ctrla;
> >> +			desc->lli.ctrlb = ctrlb
> >> +					| ATC_DST_ADDR_MODE_INCR
> >> +					| ATC_SRC_ADDR_MODE_FIXED
> >> +					| ATC_FC_PER2MEM;
> >> +			break;
> >> +
> >> +		default:
> >> +			return NULL;
> >> +		}
> >> +
> >> +		if (!first) {
> >> +			first = desc;
> >> +		} else {
> >> +			/* inform the HW lli about chaining */
> >> +			prev->lli.dscr = desc->txd.phys;
> >> +			/* insert the link descriptor to the LD ring */
> >> +			list_add_tail(&desc->desc_node,
> >> +					&first->tx_list);
> >> +		}
> >> +		prev = desc;
> >> +	}
> >> +
> >> +	/* lets make a cyclic list */
> >> +	prev->lli.dscr = first->txd.phys;
> >> +
> >> +	/* First descriptor of the chain embedds additional information */
> >> +	first->txd.cookie = -EBUSY;
> >> +	first->len = buf_len;
> >> +
> >> +	return &first->txd;
> >> +
> >> +err_desc_get:
> >> +	dev_err(chan2dev(chan), "not enough descriptors available\n");
> >> +	atc_desc_put(atchan, first);
> >> +err_out:
> >> +	clear_bit(ATC_IS_CYCLIC, &atchan->status);
> >> +	return NULL;
> >> +}
> >> +
> >> +
> >>  static int atc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
> >>  		       unsigned long arg)
> >>  {
> >> @@ -793,6 +941,9 @@ static int atc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
> >>  	list_for_each_entry_safe(desc, _desc, &list, desc_node)
> >>  		atc_chain_complete(atchan, desc);
> >>  
> >> +	/* if channel dedicated to cyclic operations, free it */
> >> +	clear_bit(ATC_IS_CYCLIC, &atchan->status);
> >> +
> >>  	spin_unlock_bh(&atchan->lock);
> >>  
> >>  	return 0;
> >> @@ -853,6 +1004,10 @@ static void atc_issue_pending(struct dma_chan *chan)
> >>  
> >>  	dev_vdbg(chan2dev(chan), "issue_pending\n");
> >>  
> >> +	/* Not needed for cyclic transfers */
> >> +	if (test_bit(ATC_IS_CYCLIC, &atchan->status))
> >> +		return;
> >> +
> >>  	spin_lock_bh(&atchan->lock);
> >>  	if (!atc_chan_is_enabled(atchan)) {
> >>  		atc_advance_work(atchan);
> >> @@ -1092,10 +1247,15 @@ static int __init at_dma_probe(struct platform_device *pdev)
> >>  	if (dma_has_cap(DMA_MEMCPY, atdma->dma_common.cap_mask))
> >>  		atdma->dma_common.device_prep_dma_memcpy = atc_prep_dma_memcpy;
> >>  
> >> -	if (dma_has_cap(DMA_SLAVE, atdma->dma_common.cap_mask)) {
> >> +	if (dma_has_cap(DMA_SLAVE, atdma->dma_common.cap_mask))
> >>  		atdma->dma_common.device_prep_slave_sg = atc_prep_slave_sg;
> >> +
> >> +	if (dma_has_cap(DMA_CYCLIC, atdma->dma_common.cap_mask))
> >> +		atdma->dma_common.device_prep_dma_cyclic = atc_prep_dma_cyclic;
> >> +
> >> +	if (dma_has_cap(DMA_SLAVE, atdma->dma_common.cap_mask) ||
> >> +	    dma_has_cap(DMA_CYCLIC, atdma->dma_common.cap_mask))
> >>  		atdma->dma_common.device_control = atc_control;
> >> -	}
> >>  
> >>  	dma_writel(atdma, EN, AT_DMA_ENABLE);
> >>  
> >> diff --git a/drivers/dma/at_hdmac_regs.h b/drivers/dma/at_hdmac_regs.h
> >> index 8303306..c79a9e0 100644
> >> --- a/drivers/dma/at_hdmac_regs.h
> >> +++ b/drivers/dma/at_hdmac_regs.h
> >> @@ -181,12 +181,22 @@ txd_to_at_desc(struct dma_async_tx_descriptor *txd)
> >>  /*--  Channels  --------------------------------------------------------*/
> >>  
> >>  /**
> >> + * atc_status - information bits stored in channel status flag
> >> + *
> >> + * Manipulated with atomic operations.
> >> + */
> >> +enum atc_status {
> >> +	ATC_IS_ERROR = 0,
> >> +	ATC_IS_CYCLIC = 24,
> >> +};
> >> +
> >> +/**
> >>   * struct at_dma_chan - internal representation of an Atmel HDMAC channel
> >>   * @chan_common: common dmaengine channel object members
> >>   * @device: parent device
> >>   * @ch_regs: memory mapped register base
> >>   * @mask: channel index in a mask
> >> - * @error_status: transmit error status information from irq handler
> >> + * @status: transmit status information from irq/prep* functions
> >>   *                to tasklet (use atomic operations)
> >>   * @tasklet: bottom half to finish transaction work
> >>   * @lock: serializes enqueue/dequeue operations to descriptors lists
> >> @@ -201,7 +211,7 @@ struct at_dma_chan {
> >>  	struct at_dma		*device;
> >>  	void __iomem		*ch_regs;
> >>  	u8			mask;
> >> -	unsigned long		error_status;
> >> +	unsigned long		status;
> >>  	struct tasklet_struct	tasklet;
> >>  
> >>  	spinlock_t		lock;
> 
> 
> Thanks for your review, best regards,


-- 
~Vinod

