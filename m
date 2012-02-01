Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab2BAAJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 19:09:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:49864 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542Ab2BAAJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 19:09:40 -0500
Date: Wed, 1 Feb 2012 01:09:15 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@intel.com>
cc: Alexandre Bounine <alexandre.bounine@idt.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        dan.j.williams@intel.com, Jassi Brar <jaswinder.singh@linaro.org>,
        Russell King <rmk@arm.linux.org.uk>,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
Subject: Re: [RFC] dmaengine/dma_slave: add context parameter to prep_slave_sg
 callback
In-Reply-To: <1327915849.1527.17.camel@vkoul-udesk3>
Message-ID: <Pine.LNX.4.64.1202010022310.31226@axis700.grange>
References: <1327612946-29397-1-git-send-email-alexandre.bounine@idt.com>
 <1327915849.1527.17.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:S9qaVPT/j7xQQjJDljy2tTiQfAuuTy12bBppSTQfjhZ
 0vm/hRFRqCnaOPkKv+j+MWdoUvCX/9sCmFDzeLsTVxVmSwJ78k
 IeFcU3OOoR7irf3gp5SIWvn+vXAZx/sOE2Vx+nFrIlMFVrqVW0
 nHVhA6++9+cP8S9XHq3/lUH+JwA6cAfa8Z5rdqPDGcM5ajPQCa
 KzkvB7yVEO1rkz9g9cnZjdFdEQhmk9+V+HqxdADC+dnHMk7Jyv
 P+UX0UrcyW3N5Tku2YhJUIzsabN59WCQVd+kevszg7tm4aY9lP
 FDKCfVXCBfGwZJ+rBU1lCMxnWly7Kge/qy2Y2fCdnZvs/v6Ycs
 jCtPWsbA746fa1K/XVi25aC1vk5+hIYIwH//r+UqYu9YRxVfWv
 lO9Abi33fxsBQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jan 2012, Vinod Koul wrote:

> On Thu, 2012-01-26 at 16:22 -0500, Alexandre Bounine wrote:
> > As we agreed during our discussion about adding DMA Engine support for RapidIO
> > subsystem, RapidIO and similar clients may benefit from adding an extra context
> > parameter to device_prep_slave_sg() callback.
> > See https://lkml.org/lkml/2011/10/24/275 for more details.
> > 
> > Adding the context parameter will allow to pass client/target specific
> > information associated with an individual data transfer request.
> > 
> > In the case of RapidIO support this additional information consists of target
> > destination ID and its buffer address (which is not mapped into the local CPU
> > memory space). Because a single RapidIO-capable DMA channel may queue data
> > transfer requests to different target devices, the per-request configuration
> > is required.
> > 
> > The proposed change eliminates need for new subsystem-specific API.
> > Existing DMA_SLAVE clients will ignore the new parameter.
> > 
> > This RFC only demonstrates the API change and does not include corresponding
> > changes to existing DMA_SLAVE clients. Complete set of patches will be provided
> > after (if) this API change is accepted.
> This looks good to me. But was thinking if we need to add this new
> parameter for other slave calls (circular, interleaved, memcpy...)

Yes, we (shdma.c) also need to pass additional slave configuration 
information to the dmaengine driver and I also was thinking about 
extending the existing API, but my ideas were going more in the direction 
of adding a parameter to __dma_request_channel() along the lines of

-struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask, dma_filter_fn fn, void *fn_param);
+struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask, dma_filter_fn fn, void *fn_param,
+					struct dma_slave_desc *slave);

where struct dma_slave_desc would basically just contain an opaque slave 
ID and would be embedded by dmaengine drivers in their specific 
slave-configuration types. The main difference to the API change being 
proposed here is, that I was going to configure DMA channels only once for 
each slave upon channel allocation, whereas the proposed change does this 
on a per-transfer basis. Therefore my question: do I understand the 
explanation of the RapidIO DMA architecture from the above quoted thread 
right, that DMA channels can be freely used by client drivers, without 
binding them to specific DSP cards? In which case you, probably, don't use 
DMA_PRIVATE? But that the decision - to which DSP card this specific 
transfer is directed - is made by configuring the DMA channels rather than 
embedded in the actual data?

Thanks
Guennadi

> 
> > 
> > Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
> > Cc: Jassi Brar <jaswinder.singh@linaro.org>
> > Cc: Russell King <rmk@arm.linux.org.uk> 
> > Cc: Kumar Gala <galak@kernel.crashing.org>
> > Cc: Matt Porter <mporter@kernel.crashing.org>
> > Cc: Li Yang <leoli@freescale.com>
> > ---
> >  include/linux/dmaengine.h |    7 ++++---
> >  1 files changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> > index 679b349..79d71bb 100644
> > --- a/include/linux/dmaengine.h
> > +++ b/include/linux/dmaengine.h
> > @@ -575,7 +575,7 @@ struct dma_device {
> >  	struct dma_async_tx_descriptor *(*device_prep_slave_sg)(
> >  		struct dma_chan *chan, struct scatterlist *sgl,
> >  		unsigned int sg_len, enum dma_transfer_direction direction,
> > -		unsigned long flags);
> > +		unsigned long flags, void *context);
> >  	struct dma_async_tx_descriptor *(*device_prep_dma_cyclic)(
> >  		struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
> >  		size_t period_len, enum dma_transfer_direction direction);
> > @@ -607,12 +607,13 @@ static inline int dmaengine_slave_config(struct dma_chan *chan,
> >  
> >  static inline struct dma_async_tx_descriptor *dmaengine_prep_slave_single(
> >  	struct dma_chan *chan, void *buf, size_t len,
> > -	enum dma_transfer_direction dir, unsigned long flags)
> > +	enum dma_transfer_direction dir, unsigned long flags, void *context)
> >  {
> >  	struct scatterlist sg;
> >  	sg_init_one(&sg, buf, len);
> >  
> > -	return chan->device->device_prep_slave_sg(chan, &sg, 1, dir, flags);
> > +	return chan->device->device_prep_slave_sg(chan, &sg, 1, dir, flags,
> > +						  context);
> >  }
> >  
> >  static inline int dmaengine_terminate_all(struct dma_chan *chan)
> 
> 
> -- 
> ~Vinod
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
