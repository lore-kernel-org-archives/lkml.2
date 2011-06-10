Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089Ab1FJGsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 02:48:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:16424 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158Ab1FJGsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 02:48:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,345,1304319600"; 
   d="scan'208";a="10619786"
Subject: Re: [RFC] dmaengine: add new api for preparing simple slave
 transfer
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dan <dan.j.williams@intel.com>
Cc: "Raju, Sundaram" <sundaram@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <20110609163206.GB24636@n2100.arm.linux.org.uk>
References: <E0D41E29EB0DAC4E9F3FF173962E9E940301FE2DED@dbde02.ent.ti.com>
	 <20110609124723.GA24636@n2100.arm.linux.org.uk>
	 <E0D41E29EB0DAC4E9F3FF173962E9E940301FE2EFB@dbde02.ent.ti.com>
	 <20110609163206.GB24636@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Jun 2011 11:43:17 +0530
Message-ID: <1307686397.10976.116.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-09 at 17:32 +0100, Russell King - ARM Linux wrote:
> On Thu, Jun 09, 2011 at 09:31:56PM +0530, Raju, Sundaram wrote:
> > Here it is, with proper line wrapping;
> 
> Thanks.  This is much easier to reply to.
> 
> > I believe that even though the dmaengine framework addresses and 
> > supports most of the required use cases of a client driver to a DMA 
> > controller, some extensions are required in it to make it still more 
> > generic.
> > 
> > Current framework contains two APIs to prepare for slave transfers: 
> > 
> > struct dma_async_tx_descriptor *(*device_prep_slave_sg)(
> > 		struct dma_chan *chan, struct scatterlist *sgl,
> > 		unsigned int sg_len, enum dma_data_direction direction,
> > 		unsigned long flags);
> > 
> > struct dma_async_tx_descriptor *(*device_prep_dma_cyclic)(
> > 		struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
> > 		size_t period_len, enum dma_data_direction direction);
> > 
> > and one control API. 
> > int (*device_control)(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
> > 		unsigned long arg);
> > 
> > A simple single buffer transfer (i.e. non sg transfer) can be done only
> > as a trivial case of the device_prep_slave_sg API. The client driver is
> > expected to prepare a sg list and provide to the dmaengine API for that
> > single buffer also.
> 
> We can avoid preparing a sg list in every driver which wants this by
> having dmaengine.h provide a helper for this case:
> 
> static inline dma_async_tx_descriptor *dmaengine_prep_slave_single(
> 	struct dma_chan *chan, void *buf, size_t len,
> 	enum dma_data_direction dir, unsigned long flags)
> {
> 	struct scatterlist sg;
> 
> 	sg_init_one(&sg, buf, len);
> 
> 	return chan->device->device_prep_slave_sg(chan, &sg, 1, dir, flags);
> }
That sounds good...

> 
> I think also providing dmaengine_prep_slave_sg() and
> dmaengine_prep_dma_cyclic() as wrappers to hide the chan->device->blah
> bit would also be beneficial (and helps keep that detail out of the
> users of DMA engine.)
> 
> > In a slave transfer, the client has to define all the buffer related 
> > attributes and the peripheral related attributes. 
> 
> I'd argue that it is incorrect to have drivers specify the buffer
> related attributes - that makes the API unnecessarily complicated
> to use, requiring two calls (one to configure the channel, and one
> to prepare the transfer) each time it needs to be used.
> 
> Not only that but the memory side of the transfer should be no business
> of the driver - the driver itself should only specify the attributes
> for the device being driven.  The attributes for the memory side of the
> transfer should be a property of the DMA engine itself.
> 
> I would like to see in the long term the dma_slave_config structure
> lose its 'direction' argument, and the rest of the parameters used to
> define the device side parameters only.
I am not sure why direction flag is required and can be done away with.
Both sg and cyclic API have a direction parameter and that should be
used. A channel can be used in any direction client wishes to.
> 
> This will allow the channel to be configured once when its requested,
> and then the prepare call can configure the direction as required.
> 
> > Now coming to the buffer related attributes, sg list is a nice way to 
> > represent a disjoint buffer; all the offload engines in drivers/dma 
> > create a descriptor for each of the contiguous chunk in the sg list 
> > buffer and pass it to the controller. 
> 
> The sg list is the standard Linux way to describe scattered buffers.
> 
> > But many a times a client may want to transfer from a single buffer to
> > the peripheral and most of the DMA controllers have the capability to 
> > transfer data in chunks/frames directly at a stretch. 
> 
> So far, I've only seen DMA controllers which operate on a linked list of
> source, destination, length, attributes, and next entry pointer.
> 
> > All the attributes of a buffer, which are required for the transfer 
> > can be programmed in single descriptor and submitted to the 
> > DMA controller. 
> 
> I'm not sure that this is useful - in order to make use of the data, the
> data would have to be copied in between the descriptors - and doesn't that
> rather negate the point of DMA if you have to memcpy() the data around?
> 
> Isn't it far more efficient to have DMA place the data exactly where it's
> required in memory right from the start without any memcpy() operations?
> 
> Can you explain where and how you would use something like this:
> 
> > -------------------------------------------------------------------
> >  | Chunk 0 |ICG| Chunk 1 |ICG| ... |ICG| Chunk n | Frame 0 
> > -------------------------------------------------------------------
> >  |		Inter Frame Gap			     | 
> > -------------------------------------------------------------------
> >  | Chunk 0 |ICG| Chunk 1 |ICG| ... |ICG| Chunk n | Frame 1 
> > -------------------------------------------------------------------
> >  |		Inter Frame Gap			     | 
> > -------------------------------------------------------------------
> >  |		........					     | 
> > -------------------------------------------------------------------
> >  |		Inter Frame Gap			     | 
> > -------------------------------------------------------------------
> >  | Chunk 0 |ICG| Chunk 1 |ICG| ... |ICG| Chunk n | Frame m 
> > -------------------------------------------------------------------
> 
> Can you also explain what a chunk contains, what a frame contains,
> how they're different and how they're processed?  Where does the
> data to be transferred to the device live?
> 
> Also, bear in mind that in Linux, we try hard to avoid allocating
> buffers larger than one page at a time - as soon as we get to multiple
> contiguous page buffers, allocations can start failing because of
> memory fragmentation.  This is why we much prefer scatterlists over
> single contiguous buffers for DMA.


-- 
~Vinod

