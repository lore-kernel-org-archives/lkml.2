Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258Ab2CGQ2L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 11:28:11 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60341 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab2CGQ2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 11:28:09 -0500
Date: Wed, 7 Mar 2012 16:27:55 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to
	__dma_request_channel()
Message-ID: <20120307162755.GB18787@n2100.arm.linux.org.uk>
References: <1331101687.24656.319.camel@vkoul-udesk3> <Pine.LNX.4.64.1203070917380.19595@axis700.grange> <20120307093026.GM17370@n2100.arm.linux.org.uk> <Pine.LNX.4.64.1203071041030.19595@axis700.grange> <20120307103112.GP17370@n2100.arm.linux.org.uk> <Pine.LNX.4.64.1203071149190.19595@axis700.grange> <20120307124620.GT17370@n2100.arm.linux.org.uk> <Pine.LNX.4.64.1203071416060.19595@axis700.grange> <20120307142634.GA18787@n2100.arm.linux.org.uk> <Pine.LNX.4.64.1203071602330.19595@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1203071602330.19595@axis700.grange>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 04:44:12PM +0100, Guennadi Liakhovetski wrote:
> So, the question remains: which way should we go? If we don't come up with 
> a generic solution, I'd be inclined to just do something as silly as
> 
> arch/arm/mach-shmobile/board-*.c
> 
> static const struct device *group1_dma_dev[] = {
> 	&dma0.device,
> 	&dma1.device,
> };
> 
> static const struct device *group2_dma_dev[] = {
> 	&dma2.device,
> 	&dma3.device,
> };
> 
> static struct my_platform_data = {
> 	.dma_dev_list = group1_dma_dev,
> 	.dma_dev_list_num = ARRAY_SIZE(group1_dma_dev),
> };
> 
> drivers/.../sh_*.c
> 
> static bool filter(struct dma_chan *chan, void *arg)
> {
> 	struct device *dev = chan->dev->device.parent;
> 	struct my_platform_data *pdata = arg;
> 
> 	for (i = 0; i < pdata->dma_dev_list_num; i++)
> 		if (pdata->dma_dev_list[i] == dev)
> 			return true;
> 
> 	return false;
> }
> 
> even though I find it silly to have to do this on every platform and in 
> every driver.

Why are you thinking that the filter function implementation has to be
provided by the peripheral driver?  That's just wrong and broken.

Think about it - how does the peripheral driver know what kind of dma
channel its filter function has been passed - to give an example, if
you built into your kernel support for the PL08x DMA engine, and lets
say you had PL08x DMA engine hardware, how would your filter function
decide whether it was one of your per-device channels or whether it
was a PL08x DMA engine channel?

And in the case of a PL08x DMA engine channel (which for slaves are
all virtual channels depending on the request signal desired), how
would your peripheral driver know which channel would be the right
one?

This is why DMA engine drivers such as PL08x and SA11x0 export their
own filter functions.  The filter function will only match against a
channel owned by that exact driver - essentially this:

bool xxx_filter_id(struct dma_chan *chan, void *chan_id)
{
        /* Reject channels for devices not bound to this driver */
        if (chan->device->dev->driver != &xxx_driver)
                return false;

	... xxx device specific channel matching ...

        return false;
}

This ensures that when the filter function needs to dereference the
driver private parts of struct dma_chan, it can be sure that the channel
really is being driven by this driver, and the underlying structure
behind struct dma_chan is well known at that point.

Anything which isn't driven by this driver is (as far as the filter
function is concerned) an unknown.

Once you know that the channel is owned by the right driver you can then
take whatever action is necessary to check - with type safety - whether
the channel is correct or not.  You get type safety through two facts:

1. As described above, the filter function will reject any channel not
   driven by this driver.
2. You need to pass the drivers filter function and data together into
   the same API.  Because both are together you have locality of
   reference.

And... moreover, matching struct devices just would not fit for any DMA
engine I've worked with - that being PL08x, SA11x0 and OMAP.  Neither
does, as I've said, using the dma_slave_config struct.

Let me put it another way:

1. using struct device would be wrong for these DMA engines because a
   single DMA engine _device_ has multiple physical DMA channels, and
   not only do these physical channels share registers and interrupts,
   but they also share DMA requests.

2. the dma_slave_config struct can't be used to select a DMA engine or
   a DMA channel because it does not contain information about whether
   the DMA engine can access the peripheral, whether there's a link for
   the device request signals to the DMA engine channel.

I will give you that channel matching in DMA engine stuff is far from
perfect, but what I'm seeing are attempts to optimize the channel
allocation for a different set of DMA devices at the expense of
penalising those already there.

We could pass a struct device corresponding with the desired DMA engine
and DMA request number in, but that still won't fit the PL08x driver,
where there's a platform specific hardware mux in front of a subset of
the PL08x's request signals.

So, what this is all telling me is that the _right_ interface is the one
we currently have, that being the filter function and an opaque set of
data to be interpreted by the supplied filter function.  If you need to
match by a list of struct device, then the interface allows it.  If you
need to match by string against a channel driven by a specific DMA engine
driver, the interface allows it.  If you need to do something more
complicated, like one of N drivers, the interface allows it.

Hell, even with the PL08x and SA11x0 filter functions, lets say for
arguments sake that I had hardware with both these in, I could select
a channel like this:

bool pl08x_or_sa11x0_filter(struct dma_chan *chan, void *chan_id)
{
	if (pl08x_filter_id(chan, chan_id))
		return true;

	return sa11x0_filter_id(chan, chan_id);
}

where both treat 'chan_id' as a string.
