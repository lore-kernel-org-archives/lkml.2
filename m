Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796Ab2CGPo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 10:44:28 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:61779 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602Ab2CGPo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 10:44:26 -0500
Date: Wed, 7 Mar 2012 16:44:12 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to __dma_request_channel()
In-Reply-To: <20120307142634.GA18787@n2100.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.64.1203071602330.19595@axis700.grange>
References: <1331035739.24656.201.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1203061339330.9300@axis700.grange> <1331101687.24656.319.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1203070917380.19595@axis700.grange>
 <20120307093026.GM17370@n2100.arm.linux.org.uk> <Pine.LNX.4.64.1203071041030.19595@axis700.grange>
 <20120307103112.GP17370@n2100.arm.linux.org.uk> <Pine.LNX.4.64.1203071149190.19595@axis700.grange>
 <20120307124620.GT17370@n2100.arm.linux.org.uk> <Pine.LNX.4.64.1203071416060.19595@axis700.grange>
 <20120307142634.GA18787@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:4Bg6nzT7I6rIhynFoVVWn7yM225vBuonn2c7Ni4R9RC
 XroGmZMX+KFRHXfzEYv4QKmKF/3T+LbiOF85mLRdrIyhL3Watg
 y5murmHGiKTqHMk9y9O4p+U07r9Bm0UbcqjmEiK32Vg6AZ3FDU
 hP4xh9ivvLymnA50AJ2ib3EOntoJdePW0noDDGtcF12ZgnwKao
 Wef7RDC2a8JrejFC4rz9fd1M/9/zuI4E/ZRcHyvYqR3lNXWXNB
 k9zov5VM3EspkJVBOwQuSjxgXIH4jsrdew/PPy+Tha8vkChEgu
 Wzq9mxSG4OvjVyf/vmZV0N91jXm9BZTku92RttYbLJFatHa3u6
 d9uz1eDd5g1wZfFtI4NiQm48hd6MOa2ewj6CwEJIJMlpi5tAwY
 e0+xNkjzUN/Rg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2012, Russell King - ARM Linux wrote:

> On Wed, Mar 07, 2012 at 02:49:25PM +0100, Guennadi Liakhovetski wrote:
> > On Wed, 7 Mar 2012, Russell King - ARM Linux wrote:
> > > What
> > > would be useful is to have a helper function along these lines:
> > > 
> > > struct dma_chan *dma_request_channel_config(mask, fn, data, config)
> > > {
> > > 	struct dma_chan *c = dma_request_channel(mask, fn, data);
> > > 
> > > 	if (c) {
> > > 		if (dmaengine_slave_config(c, config)) {
> > > 			dma_release_channel(c);
> > > 			c = NULL;
> > > 		}
> > > 	}
> > > 	return c;
> > > }
> > 
> > Hm, yeah... That seems like an over-complication to me: to "just" allocae 
> > a channel you cann dma_request_channel(), which scans your devices and 
> > channels on them, calls your filter, calls the DMA controller driver's 
> > allocation method, only to eventually call dmaengine_slave_config() and 
> > see it fail, after which you release the channel and start anew...
> 
> The point is _not_ that this uses dmaengine_slave_config() to find a
> channel at all.  As I already said, there's nothing in dma_slave_config
> which _could_ be used to decide whether a channel is suitable or not.

I completely agree, that's why I wrote in my previous mail:

> > > However, I don't see anything in struct dma_slave_config which could be
> > > used to select an appropriate channel.
> > 
> > That's also my problem with it, and the reason, why I suggested, that it 
> > has to be embedded in a hardware-specific channel configuration type.

So, the question remains: which way should we go? If we don't come up with 
a generic solution, I'd be inclined to just do something as silly as

arch/arm/mach-shmobile/board-*.c

static const struct device *group1_dma_dev[] = {
	&dma0.device,
	&dma1.device,
};

static const struct device *group2_dma_dev[] = {
	&dma2.device,
	&dma3.device,
};

static struct my_platform_data = {
	.dma_dev_list = group1_dma_dev,
	.dma_dev_list_num = ARRAY_SIZE(group1_dma_dev),
};

drivers/.../sh_*.c

static bool filter(struct dma_chan *chan, void *arg)
{
	struct device *dev = chan->dev->device.parent;
	struct my_platform_data *pdata = arg;

	for (i = 0; i < pdata->dma_dev_list_num; i++)
		if (pdata->dma_dev_list[i] == dev)
			return true;

	return false;
}

even though I find it silly to have to do this on every platform and in 
every driver.

Thanks
Guennadi

> So to try to filter on the slave configuration is a pure red herring.
> None of the DMA controllers I have access to (whether they be working
> or not) could make any kind of decision about whether a particular
> channel is suitable for the peripheral by looking at the dma_slave_config
> structure - it's very much the case that the decision would be that
> 'any channel will do', which in reality it won't because there's other
> information required to make the decision about which virtual channel
> should be used.  Specifically, the request signal information.
> 
> Even more specifically, the request signal information may not be _just_
> the request signal on the DMA controller but also incorporate an
> external MUX like on the Realview boards (which pl08x handles itself.)
> 
> I do not see any milage in trying to select a channel based on "I want
> a DMA engine to access register X, width Y, burst size Z."  As far as
> I can see, the common situation is that there's nothing in that set of
> information which would be useful to chose a specific channel on a
> DMA engine.

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
