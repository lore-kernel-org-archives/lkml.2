Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab2CGJSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 04:18:51 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61668 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab2CGJSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 04:18:48 -0500
Date: Wed, 7 Mar 2012 10:18:42 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@intel.com>
cc: linux-kernel@vger.kernel.org, "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to __dma_request_channel()
In-Reply-To: <1331101687.24656.319.camel@vkoul-udesk3>
Message-ID: <Pine.LNX.4.64.1203070917380.19595@axis700.grange>
References: <Pine.LNX.4.64.1202011610050.26261@axis700.grange> 
 <Pine.LNX.4.64.1203021341590.913@axis700.grange>  <1331022623.24656.191.camel@vkoul-udesk3>
  <Pine.LNX.4.64.1203060935460.9300@axis700.grange>  <1331035739.24656.201.camel@vkoul-udesk3>
  <Pine.LNX.4.64.1203061339330.9300@axis700.grange> <1331101687.24656.319.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:y9SIJTlSv4oGavI6SsdsfqLZuElOReMnWsRVmR+GbEJ
 P0xVL1ivoK54HJnJLZC5ODVbZbHa5F3+SNy2cl3DmCOub6oTPH
 wfxu5ZMu807lA+S26L1Bi6sj9wzVT0rKvZqKsr7FI36nEqvta+
 gVviMHjrjOB6Vw9FkCdehtoYLrLgB+ZSNPhE1d9PcLRIHyKT21
 cmPX/+mWV5zhBDftHTlq26O0EqmhIw4gURbVqSMuSPBDZqgn/P
 7hbd0CBNkVYOcqcJjrtlukyO9ZjntQdOsiGezKZ90izhRetxLm
 HeD82NluTsesEuEexA2oo80+kekf0Hzhx/QVgF83CJ8pQTRRrm
 va7y+PbPfXimeKJlDd92V5xIw2WPlKwF8V6BtDuaAzkTUufNFf
 yMgliS/7hik8w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(changed Russell's address to the one from MAINTAINERS)

On Wed, 7 Mar 2012, Vinod Koul wrote:

> On Tue, 2012-03-06 at 14:03 +0100, Guennadi Liakhovetski wrote:
> <adding few folks to thread, who i may be intrested in this discussion>
> > But the DMAC is certainly a better match for making channel-selection 
> > decisions.
> I am not sure about that as well...
> > 
> > > Bigger question is who knows about this mapping and how do we
> > > incorporate this mapping into channel allocation
> > 
> > The platform does. And this knowledge has to be passed to the relevant 
> > driver. But I think it's the DMAC driver, that is relevant, not the client 
> > driver. The platform would supply information like
> > 
> > DMAC #1
> > 	channel #1
> > 		(can be used for) device #1
> > 		device #2
> > 		...
> > 	channel #2
> > 	...
> > ...
> right :-)
> and we need to ensure that somehow this information is presented to
> dmaengine and dmaengine uses this information to filter the channel
> requests. In past we had good discussion [1], [2], [3] on this topic but
> unfortunately nothing came out of it.
> 
> I like the approach outlined by Linus W [1], where we can get the
> information from platform (DT, FW,....) and its presented to dmaengine.

I still don't see an answer to the very same question, that we've been 
discussing over multiple threads and mails now: how do we use that, if 
it's not a 1-to-1 mapping? I.e., many channels on many controllers can be 
run-time configured for use with different client devices. Also the above 
idea from Linus W doesn't directly address this.

Following his clock / regulator analogy. There the correspondence is 
clearly fixed: fixed clocks and power supplies are used with every 
specific device. Whereas in our DMAC case it's not.

I'm trying to think of an analogy, where you have several pools of 
resources, and each consumer can use any of the resources on some of those 
pools, but nothing pops up. Interrupts, GPIOs, clocks, regulators - they 
all are fixed to their consumers.

Also notice, this can become even worse, if we ever get controllers with 
channels with different capabilities on them. So, I really would let the 
DMAC driver do the mapping and not try to put it in the core.

Thanks
Guennadi

> I think we need to solve this _now_. There are two aspects
> a) to ensure dmaengine understand channel-client mapping. For this we
> can start with idea in [1] and see if this suits everyones needs
> b) how to ensure the platform gives this information in variety of arch
> we have (arm, x86, sh-....)
> 
> Thoughts...?
> > And I don't think, it would be reasonable to let every slave driver use 
> > this information. These lists can also be optimised for specific 
> > platforms. E.g., on some sh-mobile SoCs you have two DMAC types. One of 
> > them can serve devices from list A on any channel, the other one - from 
> > list B. So, all you have to do, is to reference either A or B from your 
> > DMAC platform data. Whereas doing a reverse mapping: for each (potential) 
> > DMA user reference a list of channels, that it can use - would be really 
> > clumsy.
> > 
> [1]:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2011-August/060717.html
> [2]:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2011-July/059212.html
> [3]:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2011-July/059217.html
> 
> 
> -- 
> ~Vinod
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
