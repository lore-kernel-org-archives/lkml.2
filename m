Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597Ab1EXRsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 13:48:51 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45670 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932362Ab1EXRsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 13:48:50 -0400
Date: Tue, 24 May 2011 18:48:40 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Dan <dan.j.williams@intel.com>
Subject: Re: [PATCH] dmaengine: Add API documentation for slave dma usage
Message-ID: <20110524174840.GA4652@n2100.arm.linux.org.uk>
References: <1306238657-30089-1-git-send-email-vinod.koul@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306238657-30089-1-git-send-email-vinod.koul@intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 05:34:17PM +0530, Koul, Vinod wrote:
> +1. Allocate a DMA slave channel
> +Channel allocation is slightly different in the slave DMA context, client
> +drivers typically need a channel from a particular DMA controller only and even
> +in some cases a specific channel is desired. To request a channel
> +__dma_request_channel() API is used.

Shouldn't this be "dma_request_channel" ?

> +
> +Interface:
> +struct dma_chan *dma_request_channel(dma_cap_mask_t mask,
> +		dma_filter_fn filter_fn,
> +		void *filter_param);
> +where dma_filter_fn is defined as:
> +typedef bool (*dma_filter_fn)(struct dma_chan *chan, void *filter_param);

This should have some description as to what contexts it can be called.

> +
> +When the optional 'filter_fn' parameter is set to NULL dma_request_channel
> +simply returns the first channel that satisfies the capability mask.  Otherwise,
> +when the mask parameter is insufficient for specifying the necessary channel,
> +the filter_fn routine can be used to disposition the available channels in the
> +system. The filter_fn routine is called once for each free channel in the
> +system.  Upon seeing a suitable channel filter_fn returns DMA_ACK which flags
> +that channel to be the return value from dma_request_channel.  A channel
> +allocated via this interface is exclusive to the caller, until
> +dma_release_channel() is called.
> +
> +2. Set slave and controller specific parameters
> +Next step is always to pass some specific information to the DMA driver. Most of
> +the generic information which a slave DMA can use is in struct dma_slave_config.
> +It allows the clients to specify DMA direction, DMA addresses, bus widths, DMA
> +burst lengths etc. If some DMA controllers have more parameters to be sent then
> +they should try to embed struct dma_slave_config in their controller specific
> +structure. That gives flexibility to client to pass more parameters, if
> +required.
> +

This doesn't give the interface for this.

Presumably there's section 3 missing here too for this interface:

> +Interface:
> +struct dma_async_tx_descriptor *(*chan->device->device_prep_dma_sg)(
> +		struct dma_chan *chan,
> +		struct scatterlist *dst_sg, unsigned int dst_nents,
> +		struct scatterlist *src_sg, unsigned int src_nents,
> +		unsigned long flags);
> +struct dma_async_tx_descriptor *(*chan->device->device_prep_dma_cyclic)(
> +		struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
> +		size_t period_len, enum dma_data_direction direction);

This should have some description as to what contexts it can be called.

> +
> +4. Submit the transaction(s) and wait for callback notification when slave API
> +is 3 above returns, the non NULL value would imply a "descriptor" for the

"when the slave API is 3 above returns" doesn't make sense - could you
re-phrase?

> +transaction. These transaction(s) would need to be submitted which pushes them
> +into queue in DMA driver. If DMA is idle then the first descriptor submit will
> +be pushed to DMA and subsequent ones will be queued. On completion of the DMA
> +operation the next in queue is submitted and a tasklet triggered. The tasklet
> +would then call the client driver completion callback routine for notification,
> +if set.
> +
> +Additional usage notes
> +1/ Although DMA engine specifies that completion callback routines cannot submit
> +any new operations, but typically for slave DMA subsequent transaction may not
> +be available for submit prior to callback routine being called. This requirement
> +|is not a requirement for DMA-slave devices. But they should take care to drop

spurious | character.

> +the spin-lock they might be holding before calling the callback routine

Is this document aimed at driver writers using the DMA engine slave API,
or DMA engine writers implemting the DMA engine slave API?  Most of the
document appears to be aimed at the users of the API except for this
last paragraph, and so could be confusing to users reading this document.
