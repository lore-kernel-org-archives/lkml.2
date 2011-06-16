Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab1FPGV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 02:21:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:17148 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550Ab1FPGVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 02:21:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,373,1304319600"; 
   d="scan'208";a="18824349"
Subject: RE: [RFC] dmaengine: add new api for preparing simple slave
 transfer
From: "Koul, Vinod" <vinod.koul@intel.com>
To: "Raju, Sundaram" <sundaram@ti.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dan <dan.j.williams@intel.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <E0D41E29EB0DAC4E9F3FF173962E9E9403020B7C2A@dbde02.ent.ti.com>
References: <E0D41E29EB0DAC4E9F3FF173962E9E940301FE2DED@dbde02.ent.ti.com>
	 <20110609124723.GA24636@n2100.arm.linux.org.uk>
	 <E0D41E29EB0DAC4E9F3FF173962E9E940301FE2EFB@dbde02.ent.ti.com>
	 <1307686140.10976.111.camel@vkoul-udesk3>
	 <E0D41E29EB0DAC4E9F3FF173962E9E940301FE3405@dbde02.ent.ti.com>
	 <1307724439.10976.188.camel@vkoul-udesk3>
	 <E0D41E29EB0DAC4E9F3FF173962E9E9403020B7C2A@dbde02.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Jun 2011 11:15:19 +0530
Message-ID: <1308203119.10976.234.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-14 at 12:12 +0530, Raju, Sundaram wrote:
> <snip>
> > 
> > The overall conclusion which I'm coming to is that we already support
> > what you're asking for, but the problem is that we're using different
> > (and I'd argue standard) terminology to describe what we have.
> > 
> > The only issue which I see that we don't cover is the case where you want
> > to describe a single buffer which is organised as N bytes to be transferred,
> > M following bytes to be skipped, N bytes to be transferred, M bytes to be
> > skipped.  I doubt there are many controllers which can be programmed with
> > both 'N' and 'M' parameters directly.
> >
> 
> Yes this is what I wanted to communicate and discuss in the list.
> Thanks for describing it in the standard terminology, and pointing me in the 
> right direction.
> 
> Also please note that if the gap between the buffers in a scatterlist is
> uniform and that can again be skipped by the DMAC automatically
> by programming that gap size, then that feature also is not available 
> in the current framework.
> 
> I understand it can be done with the existing scatterlist, but just writing
> a value in a DMAC register is much better if available, than preparing 
> a scatterlist and passing to the API.
> 
> > 
> > Please, don't generate special cases.  Design proper APIs from the
> > outset rather than abusing what's already there.  So no, don't abuse
> > the address width stuff.
> > 
> > In any case, the address width stuff must still be used to describe the
> > peripherals FIFO register.
> >
> 
> I did not intend to abuse the existing address width. It might look 
> like that because of how I described it here. 
> I agree that the dma_slave_config is for peripheral related 
> properties to be stored. I was pointing out that the chunk size
> variable in the dma_buffer_config I proposed will be in most cases 
> equal to FIFO register width, to describe what I actually meant by
> chunk size.
> 
> > IIUC, you have a buffer with gaps in between (given by above params).
> > Is your DMA h/w capable of parsing this buffer and directly do a
> > transfer based on above parameters (without any work for SW), or you are
> > doing this in your dma driver and then programming a list of buffers?
> > In former case (although i haven't seen such dma controller yet), can
> > you share the datasheet? It would make very little sense to change the
> > current API for your extra special case. This special case needs to be
> > handled differently rather than making rule out of it!!
> > 
> 
> Yes, Vinod. This is directly handled in the DMAC h/w.
> 
> This capability is present in 2 TI DMACs.
> EDMA (Enhanced DMA) in all TI DaVinci SoCs and the
> SDMA (System DMA) in all TI OMAP SoCs. The drivers of these
> controllers are present in the respective DaVinci tree and OMAP tree
> under the SoC folders.
> 
> <quote>
> > SDMA and EDMA are TI SoC specific DMA controllers. Their drivers have
> > been maintained in the respective SoC folders till now.
> > arch/arm/plat-omap/dma.c
> > arch/arm/mach-davinci/dma.c
> </quote>
> 
> The Manual of the EDMA controller in TI DaVinci SoCs is available at
> http://www.ti.com/litv/pdf/sprue23d
> Section 2.2 in the page 23 explains how transfers are made based
> on the gaps programmed. It also explains how the 3D buffer is 
> internally split in EDMA based on the gaps programmed.
> 
> The complete Reference manual of TI OMAP SoCs is available at
> http://www.ti.com/litv/pdf/spruf98s
> Chapter 9 in this document describes the SDMA controller.
> Section 9.4.3 in page 981 explains the various address modes,
> how the address is incremented by the DMAC and about the gaps 
> in between buffers and frames and how the DMAC handles them.
> 
> Linus,
> > 
> > Is it really so bad? It is a custom configuration after all. Even if
> > there were many DMACs out there supporting it, we'd probably
> > model it like this, just pass something like DMA_STRIDE_CONFIG
> > instead of something named after a specific slave controller.
> > 
> > This way DMACs that didn't support striding could NACK a
> > transfer for device drivers requesting it and then it could figure
> > out what to do.
> > 
> > If we can get some indication as to whether more DMACs can
> > do this kind of stuff, we'd maybe like to introduce
> > DMA_STRIDE_CONFIG already now.
> >
> 
> I wanted to discuss this feature in the list and get this feature 
> added to the current dmaengine framework. If the current APIs
> can handle this feature, then its very good 
> and I will follow that only.
> 
> If what you suggest is the right way to go then I am okay.
> IMHO the framework should always handle the complex case
> and individual implementations should implement a subset of
> the capability and hence I suggest the changes I posted to the list.
Okay now things are more clear on what you are trying to do...

1) The changes you need are to describe your buffer and convey to dmac
so please don't talk about slave here as that is specific to dmac config

2) I think this can be achieved in two ways:
a) you use current standard sg_list mechanism, the dmac driver parses
the list and  programs the dma offsets into dmac
Pros: you can use existing APIs, no changes to i/f.
If dmac has this capability they program dmac accordingly
Cons: you need to create sg-list in client driver

b) create a new api to describe these offset values, something like:
prep_buffer_offset(struct offset_description *buffer,.....)
I would not like to change the current API for this and rather have a 
new API for this, this should better then overriding current.

Overall I would prefer you to use approach 2-a above

-- 
~Vinod

