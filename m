Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899Ab1BYWSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 17:18:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:38243 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932105Ab1BYWSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 17:18:38 -0500
Message-Id: <b9dded$i2hik6@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,228,1297065600"; 
   d="scan'208";a="606653062"
Date: Fri, 25 Feb 2011 22:18:16 +0000
To: Jan Niehusmann <jan@gondor.com>
Subject: Re: [PATCH] intel-gtt: fix memory corruption with GM965 and >4GB RAM
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
References: <20110223233022.GA3439@x61s.reliablesolutions.de> <20110225123056.GA3759@x61s.reliablesolutions.de> <b9dded$i2gkhr@orsmga002.jf.intel.com> <20110225211646.GA6837@x61s.reliablesolutions.de>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20110225211646.GA6837@x61s.reliablesolutions.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Feb 2011 22:16:46 +0100, Jan Niehusmann <jan@gondor.com> wrote:
> Hi Chris,
> 
> On Fri, Feb 25, 2011 at 08:22:53PM +0000, Chris Wilson wrote:
> > On Fri, 25 Feb 2011 13:30:56 +0100, Jan Niehusmann <jan@gondor.com> wrote:
> > > Further investigation revealed that the corrupted address is
> > > (dev_priv->status_page_dmah->busaddr & 0xffffffff), ie. the beginning of
> > > the hardware status page of the i965 graphics card, cut to 32 bits.
> > 
> > 965GM explicitly supports 36bits of addressing in the PTE. The only
> > exception is that general state (part of the 3D engine) must be located in
> > the lower 4GiB.
> 
> I'm not claiming that 965GM doesn't do 36 bits. In fact I actually see
> activity in /sys/kernel/debug/dri/64/i915_gem_hws, and everything seems
> to be working well, when the status page is above 4GB - if one ignores
> the tiny detail that the wrong memory location gets overwritten,
> sometimes...
> 
> > Simply ignoring the upper 4bits is the wrong approach and means that the
> > PTE then point to random pages, and completely irrelevant to the physical
> > address used in the hardware status page address register.
> 
> Doesn't setting DMA_BIT_MASK(32) only change the region DMA memory is
> allocated from? I made that change just to make sure one gets addresses
> which are safe even if the chipset sometimes ignores address bit 32. The
> only negative impact I could think of is the allocation may fail if no
> appropriate memory is available. Am I wrong?

I just thought Daniel had wired up the dma_mask_size differently and
didn't realise it also did pci_set_dma_mask on the same pci dev. So
our patches were morally equivalent. ;-)

> 
> > I have been considering:
> 
> > +       if (IS_BRROADWATER(dev) || IS_CRESTLINE(dev))
> > +               dma_set_coherent_mask(&dev->pdev->dev, DMA_BIT_MASK(32));
> 
> > to prevent hitting the erratum.
> 
> So is there a known erratum about these chips? I didn't find errata
> documents online, but I only did a short google search and may have
> missed them.

Hah. I wish our documentation were that organised. If you grab the PRM
for gen4 from intellinuxgraphics.org, you should find it mentioned in the
state descriptions for the 3D pipeline.

> > However your bug looks to be:
> 
> > -       if (INTEL_INFO(dev)->gen >= 4)
> > -               dev_priv->dma_status_page |= (dev_priv->dma_status_page >> 28) &
> > -                                            0xf0;
> > +       if (INTEL_INFO(dev)->gen >= 4) /* 36-bit addressing */
> > +               dev_priv->dma_status_page |=
> > +                       (dev_priv->status_page_dmah->busaddr >> 28) & 0xf0;
> 
> Don't think so. dev_priv->dma_status_page gets initialized to
> dev_priv->status_page_dmah->busaddr a few lines above, and it's 64 bit,
> so that diff doesn't change the result of the computation.

And here I was working on the assumption that the code to program a 32bit
register would indeed create a 32bit value.

So, I'm happy to use your patch to workaround the known erratum. I just
wish I had an explanation as to what is actually causing the corruption.
What I want to make sure is that we don't paper over a real bug by
thinking it is yet another silicon issue.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
