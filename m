Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab2CHGZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 01:25:29 -0500
Received: from mga14.intel.com ([143.182.124.37]:5427 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754081Ab2CHGZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 01:25:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="116241858"
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to
 __dma_request_channel()
From: Vinod Koul <vinod.koul@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org,
        "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <Pine.LNX.4.64.1203071906040.19595@axis700.grange>
References: <1331101687.24656.319.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203070917380.19595@axis700.grange>
	 <20120307093026.GM17370@n2100.arm.linux.org.uk>
	 <Pine.LNX.4.64.1203071041030.19595@axis700.grange>
	 <20120307103112.GP17370@n2100.arm.linux.org.uk>
	 <Pine.LNX.4.64.1203071149190.19595@axis700.grange>
	 <20120307124620.GT17370@n2100.arm.linux.org.uk>
	 <Pine.LNX.4.64.1203071416060.19595@axis700.grange>
	 <20120307142634.GA18787@n2100.arm.linux.org.uk>
	 <Pine.LNX.4.64.1203071602330.19595@axis700.grange>
	 <20120307162755.GB18787@n2100.arm.linux.org.uk>
	 <Pine.LNX.4.64.1203071906040.19595@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Mar 2012 12:00:01 +0530
Message-ID: <1331188201.4657.51.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-07 at 19:21 +0100, Guennadi Liakhovetski wrote:
> > 
> > Why are you thinking that the filter function implementation has to be
> > provided by the peripheral driver?  That's just wrong and broken.
> 
> Again: because I don't like adding private APIs to a generic one.
> 
> > Think about it - how does the peripheral driver know what kind of dma
> > channel its filter function has been passed - to give an example, if
> > you built into your kernel support for the PL08x DMA engine, and lets
> > say you had PL08x DMA engine hardware, how would your filter function
> > decide whether it was one of your per-device channels or whether it
> > was a PL08x DMA engine channel?
> 
> Sorry, there must be a confusion here: I was not proposing the above 
> implementation for all hardware types, I don't have a good overview of all 
> possible DMA engine scenarious and, fortunately, I don't have to implement 
> anything that generic:-)
> 
> Even though I did write above "arch/arm/mach-shmobile/board-*.c" it 
> probably wasn't clear enough: I was only talking about the shdma DMA 
> engine driver and its clients. And so far on all sh-mobile hardware, that 
> I'm aware of, we haven't been mixing DMA engine types on the same 
> hardware. This is going to change soon, as soon as we get USBHS?-DMAC 
> support in the kernel, but even then, those controllers will not be 
> interchangeable: only USBHS devices will be served by USBHS-DMAC 
> controllers, the rest can be served by any other controller. So, matching 
> on a DMA controller device would perfectly suffice.
> 
> Of course, client drivers have no access to those device objects, that's 
> why those lists have to be provided to them by the platform code.
We are trying to solve this problem by making it a client or dmac
problem rather than a platform problem. We *miss* the point here in
discussion that platform *knows* the channel mapping and *not* dmac or
client, so any solution not based on this would not work, so let the
platform provide this to dmaengine.

We can have the map as* 
[*with due credit to Linus Walleij, whose idea I have extended a small
bit to have multiple channel and 1 to many mapping]

struct dmaengine_map {
	char *ch_name;
	char *client_name;
	char *dmac_name;
	unsigned int ch;
};

struct dmaengine_map[] = {
	{
		.name = "MMC-RX",
		.client_name = "mmc.0",
		.dmac_name = "pl08x.0",
		.ch = 0;
	},
	/* mmc.0 device can use pl08x.0 controller ch 0 */
	{
		.name = "MMC-TX",
		.client_name = "mmc.0",
		.dmac_name = "pl08x.0",
		.ch = 1;
	},
	/* mmc.0 device can use pl08x.0 controller ch 1 */
	{
		.name = "SSP-TX",
		.client_name = "pl022.0",
		.dmac_name = "pl022.0",
		.ch = 1;
	},
	/* SSP-TX device can use pl022.0 controller ch 1 */
	{
		.name = "SSP-RX",
		.client_name = "pl022.0",
		.dmac_name = "pl022.0",
		.ch = 2;
	},
	/* SSP-TX device can use pl022.0 controller ch 2 */
	{
		.name = "MMC-TX",
		.client_name = "pl022.0",
		.dmac_name = "pl022.0",
		.ch = 2;
	},
	/* BTW I ahve ultra spl hardware where
	 * SSP-TX device can also use pl022.0 controller ch 2 */
	...
};
This also takes care care of many to 1 mapping where a channel can talk
to multiple clients and dmaengine choose first in list.

If we do virtual channels (which I would advise) then we can have 1-1
mapping, even otherwise dmaengine can pick first channel, and client has
right to refuse (filter fn ofcourse!)

So we can add 
int dmaengine_add_channel_map(struct dmaengine_map *map, unsigned int num_entries)
{
	/* store this map into dmaengine and use for channle allocation */
}
This map can be given by device tree, board files, etc based on each
what the respective arch deems the best way.

And based on yesterday discussion, I like Russell's idea of hiding
dma_slave_config, so:

struct dma_chan *dma_request_channel_config(mask, fn, data, config)
{
        struct dma_chan *c = dma_request_channel(mask, fn, data);

        if (c) {
                if (dmaengine_slave_config(c, config)) {
                        dma_release_channel(c);
                        c = NULL;
                }
        }
        return c;
}

where
struct dma_chan *dma_request_channel(mask, fn, data)
{
	for_each_match_in_map(c, map) {
		if (fn && ! fn(c, data))
			continue;
		return chan;
	}
	return NULL;
}

At this point the client has the channel it needs to use .prepare_xxx
API without the need of anything else...

Does this model fit all?

-- 
~Vinod



