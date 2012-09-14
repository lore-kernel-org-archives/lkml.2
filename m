Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab2INKyl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 06:54:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:1815 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727Ab2INKyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 06:54:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,422,1344236400"; 
   d="scan'208";a="222116902"
Subject: Re: [PATCH] dmaengine: add dmanegine slave map api's
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Dan Williams <djbw@fb.com>,
        Arnd Bergmann <arnd@arndb.de>, linus.walleij@linaro.org,
        Jon Hunter <jon-hunter@ti.com>, Stephen Warren <swarren@nvidia.com>,
        Benoit Cousson <b-cousson@ti.com>, Shawn Guo <shawn.guo@linaro.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sascha Hauer <kernel@pengutronix.de>,
        Kukjin Kim <kgene.kim@samsung.com>,
        viresh kumar <viresh.kumar@linaro.org>,
        Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <20120914094155.GC12245@n2100.arm.linux.org.uk>
References: <1347615189-27052-1-git-send-email-vinod.koul@linux.intel.com>
	 <20120914094155.GC12245@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Sep 2012 16:21:08 +0530
Message-ID: <1347619868.1943.113.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-14 at 10:41 +0100, Russell King - ARM Linux wrote:
> On Fri, Sep 14, 2012 at 03:03:09PM +0530, Vinod Koul wrote:
> > +/*called under lock held */
> > +static struct dma_chan *dmaengine_get_slave_channel(char *requestor, dma_cap_mask_t *mask)
> > +{
> > +
> > +	struct dma_device *device, *_d;
> > +	struct dma_chan *chan = NULL;
> > +	int err;
> > +
> > +	list_for_each_entry_safe(device, _d, &dma_device_list, global_node) {
> > +		if (strcmp(requestor, dev_name(device->dev)))
> > +			continue;
> 
> So, this finds a DMA device where the struct device's name corresponds
> with the name passed in as 'requestor' (note that requestor should be
> const.)
Yes that is the idea for search

> 
> > +
> > +		chan = private_candidate(mask, device, NULL, NULL);
> > +		if (chan) {
> 
> And this finds _any_ channel on the device.
initially yes, and then we further narrow down based on if _any_ channel
will suffice or we need specific channel (in cases where we have a mux
and not hardwired soc wiring)
> 
> > +			/* Found a suitable channel, try to grab, prep, and
> > +			 * return it.  We first set DMA_PRIVATE to disable
> > +			 * balance_ref_count as this channel will not be
> > +			 * published in the general-purpose allocator
> > +			 */
> > +			dma_cap_set(DMA_PRIVATE, device->cap_mask);
> > +			device->privatecnt++;
> > +			err = dma_chan_get(chan);
> > +
> > +			if (err == -ENODEV) {
> > +				pr_debug("%s: %s module removed\n",
> > +					 __func__, dma_chan_name(chan));
> > +				list_del_rcu(&device->global_node);
> > +			} else if (err)
> > +				pr_debug("%s: failed to get %s: (%d)\n",
> > +					 __func__, dma_chan_name(chan), err);
> > +			else
> > +				break;
> > +			if (--device->privatecnt == 0)
> > +				dma_cap_clear(DMA_PRIVATE, device->cap_mask);
> > +			chan = NULL;
> > +		}
> > +	}
> > +	return chan;
> 
> and returns it...
> 
> > +struct dma_chan *dmaengine_request_slave_channel(
> > +		char *requestor, struct dma_slave_config *config,
> > +		dma_cap_mask_t *mask, dma_filter_fn fn, void *fn_param)
> > +{
> > +	struct dma_chan *slave = NULL;
> > +	struct dmaengine_slave_map_entries *entry, *_e;
> > +
> > +	/* perhpas we dont need mask arg, it should be slave anyway */
> > +	if (!__dma_has_cap(DMA_SLAVE, mask))
> > +		return NULL;
> > +
> > +	mutex_lock(&dma_list_mutex);
> > +	/* find a channel which maps to this request */
> > +	list_for_each_entry_safe(entry, _e, &dma_slave_map, node) {
> > +		if (strcmp(requestor, entry->map->client))
> > +			continue;
> > +
> > +		/* have we already allocated this mapping */
> > +		if (entry->used == true)
> > +			continue;
> > +
> > +		/* now we hit an entry in map,
> > +		 * see if we can get a channel in controller */
> > +		slave = dmaengine_get_slave_channel(requestor, mask);
> > +		if (!slave)
> > +			continue;
> 
> Ok, so here we've got a channel - any old channel what so ever on the
> device described by 'requestor'.  And we're holding a reference to it.
> 
> > +
> > +		/* check if client is requesting some specfic slave channel */
> > +		if ((entry->map->ch != -1) && (entry->map->ch != slave->chan_id))
> > +			continue;
> 
> If the channel number isn't what we wanted, where do we drop this
> reference?
Yes that needs to be taken care :)

>   Also note that this 'continue' causes us to move to the
> next entry in the map list - whereas what may have happened is that
> the channel on the DMA engine is free, but it simply wasn't the first
> free channel.  I don't see how this can work sanely.
But that is not the controller we are interested in.
Think of platform where we have 3 dma controllers and 3 peripherals,
spi, mmc, i2s. Only third dmac can be used by i2s controller so even
though we have free channel in first two controllers we are not
interested in that.
So if someone wants to get specific controller they use this API

> 
> > +		/* now call filter fn but it should not be used anyway */
> > +		if (fn && !fn(slave, fn_param))
> > +			continue;
> > +
> > +		entry->used = true;
> > +		mutex_unlock(&dma_list_mutex);
> > +
> > +		/* pick slave id from map if not set */
> > +		if (!config->slave_id)
> > +			config->slave_id = entry->map->slave_id;
> 
> So, with this level, we're talking about tying DMA channels to slave IDs.
> What about the case where you may have a DMA engine with just two channels
> but 16 request signals?  (as is the case with PL081).

The idea is that we also keep the slave_id in the map. And use the map
to find out slave_id and pass it to dmac to configure.
In the above case for pl081 when it talks to say i2s it would use
request line 3, so in map we would have this value in map.

> We're still into having 'virtual' DMA channels in DMA engines, this just
> adds an additional layer of complexity on top.
> Maybe a better idea would be to pass the map entry down to the DMA engine
> driver itself, and let it return the appropriate struct dma_chan?
At dmaengine today you find a channel and allocate that. So we are doing
same thing here, but just adding additional code to find the right
channel required. 

Note that if you have configurable mux you should not have channel
number in mapping info, you would allocate first channel in controller.

-- 
~Vinod

