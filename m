Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab2EYIVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 04:21:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:46393 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488Ab2EYIVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 04:21:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="104184734"
Subject: Re: [PATCH 1/9 v3] dmaengine: add an shdma-base library
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>
In-Reply-To: <Pine.LNX.4.64.1205171912140.10086@axis700.grange>
References: <1336576161-27082-1-git-send-email-g.liakhovetski@gmx.de>
	 <1336576161-27082-2-git-send-email-g.liakhovetski@gmx.de>
	 <1337055734.16185.5360.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1205171912140.10086@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 May 2012 13:45:37 +0530
Message-ID: <1337933737.1580.8.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-18 at 10:21 +0200, Guennadi Liakhovetski wrote:
> Hi Vinod
> 
> Thanks for your review.
sorry for the late reply, was away for few days
> 
> On Tue, 15 May 2012, Vinod Koul wrote:
> 
> > On Wed, 2012-05-09 at 17:09 +0200, Guennadi Liakhovetski wrote: 
> > > This patch extracts code from shdma.c, that does not directly deal with
> > > hardware implementation details and can be re-used with diverse DMA
> > > controller variants, found on SH-based SoCs.
> > Have you see recent Russell's virtual dma patches [1]? I like the idea
> > and simplifies things for implementation in each driver.
> > Said that, do we need this libarry. Can you see if you can use/enhance
> > that one.
> 
> No, I haven't seen it. I had a look at it, and it doesn't seem to provide 
> an immediate solution to our problem. It can be used as a part of one, but 
> a significant amount of work would still be required to convert shdma to a 
> virtual-channel based design.
> 
> Let me try to describe, what such a virtual channel solution would look 
> like:
> 
> 1. One (virtual) DMA channel is allocated per client
> 2. As clients issue dma_request_channel(), the correct channel is selected
> 3. The client configures the channel with a call to 
>    dmaengine_slave_config()
> 4. As transfers are prepared and issued they are queued in per-virtual 
>    channel lists
> 5. Each virtual channel links to a list of suitable DMA devices and 
>    channels
> 6. As a new transfer request on a specific virtual channel has to be 
>    processed, a suitable free physical channel is picked up, configured 
>    and the request is sent out
> 
> If this my understanding is right, this should be doable, but not within 
> the current 3.5 time-frame. Further, if we first do this conversion, we'll 
> still have to split the driver similar to what is proposed by this patch 
> series, but then it would be largely a new effort, most of the work 
> invested into this so far will be lost. OTOH, if we now push the shdma 
> driver split, we enable the merge of the SUDMAC support and porting to the 
> virtual channel design should also become easier, because the hardware and 
> the software parts of the driver will already be separated and presumably 
> the hardware part will not need to be changed.
> 
> One more thing, before going into detail and replying to your comments: 
> this split doesn't change driver's functionality, it simply splits it into 
> two parts. So, most questions, that you ask in this your review would also 
> apply to the current driver. This patch just extracts hardware-neutral 
> code from the shdma driver into a separate file. I think, any functional 
> changes should be done separately from this driver-split series.
Yes most of my comments do apply to current driver.
IMO update to a driver should fix existing problems, that why I pointed
them out.

Let me know if you plan to fixing them or I will queue these up for 3.6

> 
> [snip]
> 
> > > +static dma_cookie_t shdma_tx_submit(struct dma_async_tx_descriptor *tx)
> > > +{
> > > +	struct shdma_desc *chunk, *c, *desc =
> > > +		container_of(tx, struct shdma_desc, async_tx),
> > > +		*last = desc;
> > > +	struct shdma_chan *schan = to_shdma_chan(tx->chan);
> > > +	struct shdma_slave *slave = tx->chan->private;
> > > +	dma_async_tx_callback callback = tx->callback;
> > > +	dma_cookie_t cookie;
> > > +	bool power_up;
> > > +
> > > +	spin_lock_irq(&schan->chan_lock);
> > > +
> > > +	power_up = list_empty(&schan->ld_queue);
> > > +
> > > +	cookie = dma_cookie_assign(tx);
> > > +
> > > +	/* Mark all chunks of this descriptor as submitted, move to the queue */
> > > +	list_for_each_entry_safe(chunk, c, desc->node.prev, node) {
> > > +		/*
> > > +		 * All chunks are on the global ld_free, so, we have to find
> > > +		 * the end of the chain ourselves
> > > +		 */
> > > +		if (chunk != desc && (chunk->mark == DESC_IDLE ||
> > > +				      chunk->async_tx.cookie > 0 ||
> > > +				      chunk->async_tx.cookie == -EBUSY ||
> > > +				      &chunk->node == &schan->ld_free))
> > > +			break;
> > > +		chunk->mark = DESC_SUBMITTED;
> > > +		/* Callback goes to the last chunk */
> > > +		chunk->async_tx.callback = NULL;
> > > +		chunk->cookie = cookie;
> > > +		list_move_tail(&chunk->node, &schan->ld_queue);
> > > +		last = chunk;
> > > +
> > > +		dev_dbg(schan->dev, "submit #%d@%p on %d\n",
> > > +			tx->cookie, &last->async_tx, schan->id);
> > > +	}
> > > +
> > > +	last->async_tx.callback = callback;
> > > +	last->async_tx.callback_param = tx->callback_param;
> > > +
> > > +	if (power_up) {
> > > +		int ret;
> > > +		schan->pm_state = SHDMA_PM_BUSY;
> > > +
> > > +		ret = pm_runtime_get(schan->dev);
> > any reason why this is here and not in issue pending?
> 
> Sorry, we have discussed this multiple times already. See, for example,
> 
> http://thread.gmane.org/gmane.linux.kernel/1181989/focus=12187
> 
> [snip]
> 
> > > +/*
> > > + * Drivers, using this library are expected to embed struct shdma_dev,
> > > + * struct shdma_chan, struct shdma_desc, and struct shdma_slave
> > > + * in their respective device, channel, descriptor and slave objects.
> > > + */
> > > +
> > > +struct shdma_slave {
> > > +	unsigned int slave_id;
> > this should be moved to struct dma_slave_config 
> 
> Again, this would be a functional change. And struct dma_slave_config 
> doesn't have a slave-ID field in it, which is the only thing we need for 
> now. Instead it has a bunch of other fields, of which none is so far used 
> by this driver.
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
~Vinod

