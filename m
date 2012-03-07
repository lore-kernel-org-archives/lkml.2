Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965191Ab2CGSV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 13:21:56 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:63469 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164Ab2CGSVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 13:21:55 -0500
Date: Wed, 7 Mar 2012 19:21:51 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to __dma_request_channel()
In-Reply-To: <20120307162755.GB18787@n2100.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.64.1203071906040.19595@axis700.grange>
References: <1331101687.24656.319.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1203070917380.19595@axis700.grange>
 <20120307093026.GM17370@n2100.arm.linux.org.uk> <Pine.LNX.4.64.1203071041030.19595@axis700.grange>
 <20120307103112.GP17370@n2100.arm.linux.org.uk> <Pine.LNX.4.64.1203071149190.19595@axis700.grange>
 <20120307124620.GT17370@n2100.arm.linux.org.uk> <Pine.LNX.4.64.1203071416060.19595@axis700.grange>
 <20120307142634.GA18787@n2100.arm.linux.org.uk> <Pine.LNX.4.64.1203071602330.19595@axis700.grange>
 <20120307162755.GB18787@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:GtDD6dY26HH0/jPRTnr3KuviSM/4rt9f7VjRbPUACnm
 5L8a33bTZ0/j1I3s2rZA0n5Gc+SJxlcURaOIvUU/WRWoZMAsjL
 aHErdNqQCDwgW2EeMUhvDQ9vBnnZ+ZN1E3xZ5WBdrJYGEB6Q6B
 3lTMDDGNByRwt9KnkJSofCaL9A75yfklNH42afnEjk98ngVozd
 WI13altp27xMP4oHkUH0YRl6IOu/thwv046COPgzwmR3U4QjMw
 JdhjXvAqYEEuBQwxgW2dLPxVV32FlSxFoDoNsJdiGWv48LXpeU
 IGexueuiRIqGtizlZ9fH99BR8yLA/OZvcgqI93EGOBasqTyJDu
 zbFqp9n6yesu5DblYhe7tPHt0RrSvQEObjT6QgtVUQQ+iE/bTa
 yzC20Q18DsSyg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for a detailed explanation!

On Wed, 7 Mar 2012, Russell King - ARM Linux wrote:

> On Wed, Mar 07, 2012 at 04:44:12PM +0100, Guennadi Liakhovetski wrote:
> > So, the question remains: which way should we go? If we don't come up with 
> > a generic solution, I'd be inclined to just do something as silly as
> > 
> > arch/arm/mach-shmobile/board-*.c
> > 
> > static const struct device *group1_dma_dev[] = {
> > 	&dma0.device,
> > 	&dma1.device,
> > };
> > 
> > static const struct device *group2_dma_dev[] = {
> > 	&dma2.device,
> > 	&dma3.device,
> > };
> > 
> > static struct my_platform_data = {
> > 	.dma_dev_list = group1_dma_dev,
> > 	.dma_dev_list_num = ARRAY_SIZE(group1_dma_dev),
> > };
> > 
> > drivers/.../sh_*.c
> > 
> > static bool filter(struct dma_chan *chan, void *arg)
> > {
> > 	struct device *dev = chan->dev->device.parent;
> > 	struct my_platform_data *pdata = arg;
> > 
> > 	for (i = 0; i < pdata->dma_dev_list_num; i++)
> > 		if (pdata->dma_dev_list[i] == dev)
> > 			return true;
> > 
> > 	return false;
> > }
> > 
> > even though I find it silly to have to do this on every platform and in 
> > every driver.
> 
> Why are you thinking that the filter function implementation has to be
> provided by the peripheral driver?  That's just wrong and broken.

Again: because I don't like adding private APIs to a generic one.

> Think about it - how does the peripheral driver know what kind of dma
> channel its filter function has been passed - to give an example, if
> you built into your kernel support for the PL08x DMA engine, and lets
> say you had PL08x DMA engine hardware, how would your filter function
> decide whether it was one of your per-device channels or whether it
> was a PL08x DMA engine channel?

Sorry, there must be a confusion here: I was not proposing the above 
implementation for all hardware types, I don't have a good overview of all 
possible DMA engine scenarious and, fortunately, I don't have to implement 
anything that generic:-)

Even though I did write above "arch/arm/mach-shmobile/board-*.c" it 
probably wasn't clear enough: I was only talking about the shdma DMA 
engine driver and its clients. And so far on all sh-mobile hardware, that 
I'm aware of, we haven't been mixing DMA engine types on the same 
hardware. This is going to change soon, as soon as we get USBHS?-DMAC 
support in the kernel, but even then, those controllers will not be 
interchangeable: only USBHS devices will be served by USBHS-DMAC 
controllers, the rest can be served by any other controller. So, matching 
on a DMA controller device would perfectly suffice.

Of course, client drivers have no access to those device objects, that's 
why those lists have to be provided to them by the platform code.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
