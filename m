Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab2ARMep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 07:34:45 -0500
Received: from linux-sh.org ([111.68.239.195]:34325 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156Ab2ARMeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 07:34:44 -0500
Date: Wed, 18 Jan 2012 21:34:31 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Vinod Koul <vinod.koul@intel.com>, Magnus Damm <magnus.damm@gmail.com>,
        "Shimoda, Yoshihiro" <yoshihiro.shimoda.uh@renesas.com>
Subject: Re: [PATCH 1/7] dma: add a simple dma library
Message-ID: <20120118123431.GH8182@linux-sh.org>
References: <Pine.LNX.4.64.1201181025280.28782@axis700.grange> <Pine.LNX.4.64.1201181111340.28782@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1201181111340.28782@axis700.grange>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 11:22:18AM +0100, Guennadi Liakhovetski wrote:
> This patch adds a library of functions, helping to implement dmaengine
> drivers for hardware, unable to handle scatter-gather lists natively.
> The first version of this driver only supports memcpy and slave DMA
> operation.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

While I like the direction this is going there are just a few minor
things that have popped up.

> +/*
> + * For slave DMA we assume, that there is a finate number of DMA slaves in the
> + * system, and that each such slave can only use a finate number of channels.
> + * We use slave channel IDs to make sure, that no such slave channel ID is
> + * allocated more than once.
> + */
Presumably you meant finite.

> +static unsigned int slave_num = 256;
> +module_param(slave_num, uint, 0444);
> +
> +/* A bitmask with slave_num bits */
> +static unsigned long *simple_slave_used;
> +
The shdma code explicitly used BITS_TO_LONGS here which explicitly
requires a defined (or max) size, but this could all presumably be buried
under DECLARE_BITMAP().

> +		BUG_ON(tx->cookie > 0 && tx->cookie != desc->cookie);
> +		BUG_ON(desc->mark != DESC_SUBMITTED &&
> +		       desc->mark != DESC_COMPLETED &&
> +		       desc->mark != DESC_WAITING);
> +
..
> +			BUG_ON(desc->chunks != 1);
..
> +				BUG_ON(tx->cookie < 0);

This seems to depend on BUG_ON() as its primary assert/sanity check path,
which seems a bit excessive. Drivers get fed garbage all the time,
some effort to provide meaningful debug output or less fatal error
handling would be nice. As it is, one misbehaving user can pretty much
grind everything else to a halt for things that aren't really that big of
a deal.

> +/*
> + * simple_chan_ld_cleanup - Clean up link descriptors
> + *
> + * Clean up the ld_queue of DMA channel.
> + */
> +static void simple_chan_ld_cleanup(struct dma_simple_chan *schan, bool all)
> +{
> +	while (__ld_cleanup(schan, all))
> +		;
> +}
> +
cpu_relax()

> +/*
> + * simple_free_chan_resources - Free all resources of the channel.
> + */
> +static void simple_free_chan_resources(struct dma_chan *chan)
> +{
> +	struct dma_simple_chan *schan = to_simple_chan(chan);
> +	struct dma_simple_dev *sdev = to_simple_dev(chan->device);
> +	const struct dma_simple_ops *ops = sdev->ops;
> +	LIST_HEAD(list);
> +
> +	/* Protect against ISR */
> +	spin_lock_irq(&schan->chan_lock);
> +	ops->halt_channel(schan);
> +	spin_unlock_irq(&schan->chan_lock);
> +
> +	/* Now no new interrupts will occur */
> +
> +	/* Prepared and not submitted descriptors can still be on the queue */
> +	if (!list_empty(&schan->ld_queue))
> +		simple_chan_ld_cleanup(schan, true);
> +
Why doesn't simple_chan_ld_cleanup() do a list_empty test instead?

> +int __devinit dma_simple_init(struct device *dev, struct dma_simple_dev *sdev,
> +			      int chan_num)
> +{
..
> +}
> +EXPORT_SYMBOL(dma_simple_init);
> +
> +void __devexit dma_simple_cleanup(struct dma_simple_dev *sdev)
> +{
..
> +}
> +EXPORT_SYMBOL(dma_simple_cleanup);
> +
__devinit/exit on exported symbols? You could try __init_or_module, but I
think it's more trouble than it is worth.

> +static int __init dma_simple_enter(void)
> +{
> +	simple_slave_used = kzalloc(DIV_ROUND_UP(slave_num, BITS_PER_BYTE),
> +				    GFP_KERNEL);
> +	if (!simple_slave_used)
> +		return -ENOMEM;

Pretty weird way to do BITS_PER_LONGS, and as noted above can just be
handled by DECLARE_BITMAP() if the max case isn't too outlandish.

> +module_init(dma_simple_enter);
> +
> +static void __exit dma_simple_exit(void)
> +{
> +	kfree(simple_slave_used);
> +}
> +module_exit(dma_simple_exit);
> +
At which point these can probably just go away completely.

> +static inline void dma_simple_lock(struct dma_simple_chan *schan)
> +{
> +	spin_lock(&schan->chan_lock);
> +}
> +
> +static inline void dma_simple_unlock(struct dma_simple_chan *schan)
> +{
> +	spin_unlock(&schan->chan_lock);
> +}
> +
These deserve to die a violent death, it's ok for driver writers to
handle a spinlock on their own, or so one hopes.

> +void dma_simple_chan_remove(struct dma_simple_chan *schan);
> +int dma_simple_init(struct device *dev, struct dma_simple_dev *sdev,
> +		    int chan_num) __devinit;
> +void dma_simple_cleanup(struct dma_simple_dev *sdev) __devexit;
> +
Not really convinced about the section annotations here, either.
