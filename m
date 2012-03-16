Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032811Ab2CPOLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 10:11:55 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52323 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030808Ab2CPOLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 10:11:53 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1203161128120.13465@axis700.grange>
References: <1331101687.24656.319.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203071416060.19595@axis700.grange>
	<20120307142634.GA18787@n2100.arm.linux.org.uk>
	<Pine.LNX.4.64.1203071602330.19595@axis700.grange>
	<20120307162755.GB18787@n2100.arm.linux.org.uk>
	<Pine.LNX.4.64.1203071906040.19595@axis700.grange>
	<1331188201.4657.51.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203080902170.29847@axis700.grange>
	<1331204128.4657.54.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203081200170.29847@axis700.grange>
	<1331206459.4657.59.camel@vkoul-udesk3>
	<1331211513.4657.67.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203081412550.29847@axis700.grange>
	<1331284918.4657.69.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203091022200.7852@axis700.grange>
	<1331285959.4657.76.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203091049060.7852@axis700.grange>
	<1331520476.4657.79.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203161029490.13465@axis700.grange>
	<CACRpkdYiuERV08=UhBRnj2AjC_RxF+EY+zHAtEp6KYf2W10C_Q@mail.gmail.com>
	<Pine.LNX.4.64.1203161128120.13465@axis700.grange>
Date: Fri, 16 Mar 2012 15:11:52 +0100
Message-ID: <CACRpkdY7ApBc-gbSdf+=7PLtKSMvzYuBi7RNnVgi=vjcd-KvhQ@mail.gmail.com>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to __dma_request_channel()
From: Linus Walleij <linus.walleij@linaro.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Vinod Koul <vinod.koul@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Jassi Brar <jassisinghbrar@gmail.com>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 12:09 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:

> And the least important question: who and when will implement the core
> support for this?

I'm trying to call the kernel HR department to hire a consultant for me but they
just put me on the phone queue all the time, I don't know what I might be
doing wrong ... :-)

If the question is whether we need more people writing complicated core
patches for the dmaengine I think the answer is "yes"?

> 1. the client issues a dma_request_channel() with _just_ a capability mask
> and a filter and its argument as parameters - _nothing_ about channel
> restrictions.
>
> 2. you propose to eliminate a filter - the core has no way to know, which
> channel to pick up...

Nah, thinking about it...

Eliminate the external filter, make it internal. We already have the
problem that these filter functions need to be passed around too much
in platform data e.g. so we need to do away with it.

The filter functions seem to come from the DMA drivers
themselves mostly. (Help me with the complete picture here...)
For example:

amba-pl08x.c:bool pl08x_filter_id(struct dma_chan *chan, void *chan_id)
coh901318.c:bool coh901318_filter_id(struct dma_chan *chan, void *chan_id)
pl330.c:bool pl330_filter(struct dma_chan *chan, void *param)
sirf-dma.c:bool sirfsoc_dma_filter_id(struct dma_chan *chan, void *chan_id)
ste_dma40.c:bool stedma40_filter(struct dma_chan *chan, void *data)

So delete the typedef for dma_filter_fn remove these filters from
external header files.

And stop that thing from being passed around and into
struct dma_device so the dmaengine core can still filter or process
channels, but nothing on the outside need to know about it. That way
we can centralize it to drivers/dma and not spread it out throughout
the kernel.

> 3. the wrapper, proposed by Russell, now calls dmaengine_slave_config(),
> which fails, because that's a wrong channel (hope I get this right this
> time - configuration has nothing to do with selection:-))

Oh I was not thinking of relying on config to sort out channels.

I was thinking of internalizing the dma_filter_fn and make it an
(optional, maybe?) part of dmaengine.

> 4. that's it, if you start again - the dmaengine core will enumerate the
> same channels again and propose the same unsuitable channel to you -
> there's no way to continue to the next channel / device.
>
> What am I missing? How is the mapping going to be used, if you eliminate
> the filter function?

As above, I guess factoring away the filter functions would be
the first real hard problem.

Thanks,
Linus Walleij
