Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004Ab2INLTB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 07:19:01 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:32837 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab2INLS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 07:18:58 -0400
Date: Fri, 14 Sep 2012 12:18:42 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Vinod Koul <vinod.koul@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <djbw@fb.com>,
        Arnd Bergmann <arnd@arndb.de>, linus.walleij@linaro.org,
        Jon Hunter <jon-hunter@ti.com>, Stephen Warren <swarren@nvidia.com>,
        Benoit Cousson <b-cousson@ti.com>, Shawn Guo <shawn.guo@linaro.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sascha Hauer <kernel@pengutronix.de>,
        Kukjin Kim <kgene.kim@samsung.com>,
        viresh kumar <viresh.kumar@linaro.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] dmaengine: add dmanegine slave map api's
Message-ID: <20120914111842.GD12245@n2100.arm.linux.org.uk>
References: <1347615189-27052-1-git-send-email-vinod.koul@linux.intel.com> <20120914094155.GC12245@n2100.arm.linux.org.uk> <1347619868.1943.113.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347619868.1943.113.camel@vkoul-udesk3>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 04:21:08PM +0530, Vinod Koul wrote:
> On Fri, 2012-09-14 at 10:41 +0100, Russell King - ARM Linux wrote:
> > On Fri, Sep 14, 2012 at 03:03:09PM +0530, Vinod Koul wrote:
> > > +		/* now we hit an entry in map,
> > > +		 * see if we can get a channel in controller */
> > > +		slave = dmaengine_get_slave_channel(requestor, mask);
> > > +		if (!slave)
> > > +			continue;
> > 
> > Ok, so here we've got a channel - any old channel what so ever on the
> > device described by 'requestor'.  And we're holding a reference to it.
> > 
> > > +
> > > +		/* check if client is requesting some specfic slave channel */
> > > +		if ((entry->map->ch != -1) && (entry->map->ch != slave->chan_id))
> > > +			continue;
> > 
> > If the channel number isn't what we wanted, where do we drop this
> > reference?
> Yes that needs to be taken care :)
> 
> >   Also note that this 'continue' causes us to move to the
> > next entry in the map list - whereas what may have happened is that
> > the channel on the DMA engine is free, but it simply wasn't the first
> > free channel.  I don't see how this can work sanely.
> But that is not the controller we are interested in.
> Think of platform where we have 3 dma controllers and 3 peripherals,
> spi, mmc, i2s. Only third dmac can be used by i2s controller so even
> though we have free channel in first two controllers we are not
> interested in that.

What you're comparing here is not the DMA controller, but the DMA channel
number.  You're actually doing nothing to select a particular dma_device
(a DMA engine device driver may register more than one dma_device per
struct device.)

So, your comments do not tie up with the code you've shown - so I'm not
sure you actually understand the code you've published...

> > So, with this level, we're talking about tying DMA channels to slave IDs.
> > What about the case where you may have a DMA engine with just two channels
> > but 16 request signals?  (as is the case with PL081).
> 
> The idea is that we also keep the slave_id in the map. And use the map
> to find out slave_id and pass it to dmac to configure.
> In the above case for pl081 when it talks to say i2s it would use
> request line 3, so in map we would have this value in map.

I'm not saying take the slave_id out of the map.  I'm saying, let the
DMA engine driver itself figure out what dma_chan to return.

> > We're still into having 'virtual' DMA channels in DMA engines, this just
> > adds an additional layer of complexity on top.
> > Maybe a better idea would be to pass the map entry down to the DMA engine
> > driver itself, and let it return the appropriate struct dma_chan?
> 
> At dmaengine today you find a channel and allocate that. So we are doing
> same thing here, but just adding additional code to find the right
> channel required. 

No you're most certainly not.  You're finding the _first_ channel on a
DMA device, and matching its chan_id against slave_id (if slave_id is not
-1) and returning that.  If the slave ID doesn't match, you move to the
next DMA device.  This is insane.

It's also insane that you think that each DMA channel is equal.  It isn't.

At the moment, NAK against your patch, it can't work as it stands.
