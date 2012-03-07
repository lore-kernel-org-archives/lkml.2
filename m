Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab2CGKDE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 05:03:04 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:50815 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab2CGKDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 05:03:01 -0500
Date: Wed, 7 Mar 2012 11:02:46 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to __dma_request_channel()
In-Reply-To: <20120307093026.GM17370@n2100.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.64.1203071041030.19595@axis700.grange>
References: <Pine.LNX.4.64.1202011610050.26261@axis700.grange>
 <Pine.LNX.4.64.1203021341590.913@axis700.grange> <1331022623.24656.191.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1203060935460.9300@axis700.grange> <1331035739.24656.201.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1203061339330.9300@axis700.grange> <1331101687.24656.319.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1203070917380.19595@axis700.grange>
 <20120307093026.GM17370@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:g91rc+WO3hPCfPAUBGtuIGe8OwBijtuyLNM/bCHlKz/
 bA+SC+a3fB5THL32NFYByXxzmseWHVpW5RkiPYFTaOctGKzYJR
 NhNPuLPwxEC6csNf3Pr0rRaOcKNCAfCKcetl3Wn12pcByeqlLE
 WFaNYUCD/LI/f7MIj0oHQnfzpvJ8GSK6npAC9BBelFKEy0VXLZ
 Re2bpN9Lsp7R7lQ0UrbdIBos6cEnAexqxmKyqULkTwlxDXpLYs
 w4hrRx/3Ndf0KqhMLt1hSWa046stZhmLxpY+qwFT51pAUPG12m
 FFw+qVjguunBSs21piIivC1hPq90b+GwMfhWhWutXZ+QX+siVm
 f0E1VdifrD58rwyXkYhOUNvqmPpkVZCyEF8sVMxVKKcZHIM+/F
 EqMeDrS17B84A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2012, Russell King - ARM Linux wrote:

> On Wed, Mar 07, 2012 at 10:18:42AM +0100, Guennadi Liakhovetski wrote:
> > I still don't see an answer to the very same question, that we've been 
> > discussing over multiple threads and mails now: how do we use that, if 
> > it's not a 1-to-1 mapping? I.e., many channels on many controllers can be 
> > run-time configured for use with different client devices. Also the above 
> > idea from Linus W doesn't directly address this.
> > 
> > Following his clock / regulator analogy. There the correspondence is 
> > clearly fixed: fixed clocks and power supplies are used with every 
> > specific device. Whereas in our DMAC case it's not.
> > 
> > I'm trying to think of an analogy, where you have several pools of 
> > resources, and each consumer can use any of the resources on some of those 
> > pools, but nothing pops up. Interrupts, GPIOs, clocks, regulators - they 
> > all are fixed to their consumers.
> > 
> > Also notice, this can become even worse, if we ever get controllers with 
> > channels with different capabilities on them. So, I really would let the 
> > DMAC driver do the mapping and not try to put it in the core.
> 
> Well, I am quite convinced (being on my third or fourth DMA engine driver)
> that DMA engine does stuff quite wrongly when it comes to slave stuff.
> Why?
> 
> The code required to support slave device transfers is very much the same
> for each driver (that's partly because I'm writing my drivers in the same
> way.)  Essentially, slave channels aren't physical channels themselves,
> but virtual channels which get assigned to physical channels at some point.
> I would really like to see some common infrastructure for handling these
> virtual channels so I don't have to write yet another version of that code,
> and that's something I'll be working on.

Right, I thought about virtual DMA channels, but I really hoped we 
wouldn't have to do that;-) Would we then also have to use virtual DMAC 
instances? Given that the core operates in terms of DMA-controller devices 
and channels and the hardware is also built around those concepts, it 
seems a natural choice to use a 1-to-1 correspondence.

In the sh-mobile case, AFAIK, until now we can have N DMA controllers of M 
types. Within each type the controllers are identical, meaning also, that 
all channels on them can be configured to work with all the same devices. 
Currently that's also what we present to the dmaengine core and to 
clients: N controllers. Whereas it has been suggested a couple of times, 
that neither the core nore clients should be bothered with specific DMA 
controller instances, so, we might as well just present M virtual 
controllers to the system - 1 of each type, each with a unique capability 
set?

Thanks
Guennadi

> My main critera for selecting a virtual channel is the DMA request signal
> into the DMA controller itself, and nothing more.  Most other non-specific
> configuration information (data register, data register width, burst size
> etc) comes from the peripheral driver.
> 
> Any other data relevant to the DMA engine needs to come from the platform
> in some way, that being DT or platform data or whatever.  For example,
> with a DMA engine which has two bus interfaces, where it matters which
> bus interface is used, that needs to be specified by the platform and not
> by the DMA engine itself nor the peripheral driver.
> 
> That would also include, if relevant, which physical channels a virtual
> channel (dma request) could be routed to.
> 
> Note that we've been omitting that from the PL08x driver so far - memory-
> to-memory requests are supposed to only be handled by a couple of channels
> which are designed for that purpose (so they don't flood the bus) but
> we currently allocate them to any channel...
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
