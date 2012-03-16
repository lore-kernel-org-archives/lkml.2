Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761316Ab2CPLKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 07:10:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52569 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab2CPLJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 07:09:58 -0400
Date: Fri, 16 Mar 2012 12:09:55 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Linus Walleij <linus.walleij@linaro.org>
cc: Vinod Koul <vinod.koul@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Jassi Brar <jassisinghbrar@gmail.com>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to __dma_request_channel()
In-Reply-To: <CACRpkdYiuERV08=UhBRnj2AjC_RxF+EY+zHAtEp6KYf2W10C_Q@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1203161128120.13465@axis700.grange>
References: <1331101687.24656.319.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1203071416060.19595@axis700.grange>
 <20120307142634.GA18787@n2100.arm.linux.org.uk> <Pine.LNX.4.64.1203071602330.19595@axis700.grange>
 <20120307162755.GB18787@n2100.arm.linux.org.uk> <Pine.LNX.4.64.1203071906040.19595@axis700.grange>
 <1331188201.4657.51.camel@vkoul-udesk3> <Pine.LNX.4.64.1203080902170.29847@axis700.grange>
 <1331204128.4657.54.camel@vkoul-udesk3> <Pine.LNX.4.64.1203081200170.29847@axis700.grange>
 <1331206459.4657.59.camel@vkoul-udesk3> <1331211513.4657.67.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1203081412550.29847@axis700.grange> <1331284918.4657.69.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1203091022200.7852@axis700.grange> <1331285959.4657.76.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1203091049060.7852@axis700.grange> <1331520476.4657.79.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1203161029490.13465@axis700.grange>
 <CACRpkdYiuERV08=UhBRnj2AjC_RxF+EY+zHAtEp6KYf2W10C_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:r5q1az/5HKIRqt/k1ULQPG//lEdduvX8quVeMExHcIZ
 O8vIo4eSet/qO38q5SBBAsJCKChQ9qj/zkGoLlL8GN/MYrRtB9
 mqFJ//5skJGwa2eI6ExoGQAyoJrIVbAmoR4xqhwoXvYLdy4607
 L+72FbZjL8tG23pWnUyqHKXRy8ANXSqoO0kb7O9aSmSXakNVey
 p0cbQXSjV7SiV5NdvVjFOGM3M8Udc8cOH111fY5zG5FNT8e7n2
 nNk7KtwoB9mdKyekeIocOm2f046uXZnf/aQG1iE9/78D+IF4ql
 lcWQ5hImxgod/bT7LSCJM5KTuz8Et96yq2WKQ7GzoGcoQuaBut
 JKjju6Agk8yR3a9JZvLkuwICmUQuSydtAOtBqAKbHfT+rVRxdP
 g6LBDLTNaIfQg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2012, Linus Walleij wrote:

> On Fri, Mar 16, 2012 at 10:36 AM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> 
> > Ok, let me try to summarise, what this would mean for sh-mobile:
> >
> > 1. this proposal introduces a new special case: with or without a mapping,
> > that will have to be handled in affected client and DMA controller
> > drivers. E.g., on sh-mobile some devices might on some systems use
> > channels from "general purpose" DMA controllers (no mapping), on other
> > systems it will be a dedicated controller (fixed mapping).
> >
> > 2. this will break, if we get more than 1 "general purpose" type with
> > different supported client sets. So, we develop a new API with a
> > pre-programmed limitation.
> 
> I fail to see why this would not be solved by a one-to-many mapping?
> 
> Flag for each device which channels it may use in a mapping
> table in platform data or device tree, I don't see the problem.
> 
> You don't even have to specify that on a per-channel basis if
> you can come up with something more clever in the mapping
> table, such as "this device can use any channel on this DMAC,
> and channels 1-7 on that DMAC" - no problem?

Sure, everything is possible. So, would something like this make you 
happy:

struct dma_channel_range {
	const char *dma_device;
	int channel_start;
	int channel_end;
};

struct dma_map {
	const char *name;
	const char *client;
	const struct dma_channel_range *chan_range;
	int chan_range_num;
};

You really want to do this?...

And the least important question: who and when will implement the core 
support for this?

> > 3. this will mean a substantial driver and platform code modification.
> > Nothing super-complex, but still some.
> 
> Big deal. Refactoring is fun... ;-)
> 
> > 4. we'll need a 3-stage channel allocation / configuration: request,
> > filter, config.
> 
> In my world: channel request with *NO* filter function.

How??? Again:

1. the client issues a dma_request_channel() with _just_ a capability mask 
and a filter and its argument as parameters - _nothing_ about channel 
restrictions.

2. you propose to eliminate a filter - the core has no way to know, which 
channel to pick up...

3. the wrapper, proposed by Russell, now calls dmaengine_slave_config(), 
which fails, because that's a wrong channel (hope I get this right this 
time - configuration has nothing to do with selection:-))

4. that's it, if you start again - the dmaengine core will enumerate the 
same channels again and propose the same unsuitable channel to you - 
there's no way to continue to the next channel / device.

What am I missing? How is the mapping going to be used, if you eliminate 
the filter function?

> Filter functions are part of the problem. So we refactor these
> away as part of this change. That's the whole point...
> 
> The core gathers information from the platform and the
> DMAC driver(s) to build up the constraints necessary to
> hand out workling channels to each device that request
> one.
> 
> And Russell IIRC already suggested a request-and-config
> channel inline for the simple cases, and if you still need to
> explicitly runtime-reconfigure then that's for a good
> reason.
> 
> > Whereas with my configuration-parameter proposal it's just
> > one stage: allocate-and-configure.
> 
> For one specific hardware, yes. For DMAengine at large
> and the majority of the drivers, no.

Sorry, why? I don't think I saw an answer to it apart from - maintenance 
burden... You can use that parameter to actually pass information to be 
used by the core to scan your mapping tables, I really don't see how you 
want to use those tables with the existing dmaengine channel-allocation 
API.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
