Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab1D0UQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 16:16:23 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56896 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913Ab1D0UQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 16:16:22 -0400
Date: Wed, 27 Apr 2011 21:16:05 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC] ARM DMA mapping TODO, v1
Message-ID: <20110427201605.GW17290@n2100.arm.linux.org.uk>
References: <201104212129.17013.arnd@arndb.de> <201104271056.49920.arnd@arndb.de> <20110427090923.GO17290@n2100.arm.linux.org.uk> <201104271302.44249.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104271302.44249.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 01:02:43PM +0200, Arnd Bergmann wrote:
> On Wednesday 27 April 2011, Russell King - ARM Linux wrote:
> > On Wed, Apr 27, 2011 at 10:56:49AM +0200, Arnd Bergmann wrote:
> > > We probably still need to handle both the coherent and noncoherent case
> > > in each dma_map_ops implementation, at least for those combinations where
> > > they matter (definitely the linear mapping). However, I think that using
> > > dma_mapping_common.h would let us use an architecture-independent dma_map_ops
> > > for the generic iommu code that Marek wants to introduce now.
> > 
> > The 'do we have an iommu or not' question and the 'do we need to do cache
> > coherency' question are two independent questions which are unrelated to
> > each other.  There are four unique but equally valid combinations.
> > 
> > Pushing the cache coherency question down into the iommu stuff will mean
> > that we'll constantly be fighting against the 'but this iommu works on x86'
> > shite that we've fought with over block device crap for years.  I have
> > no desire to go there.
> 
> Ok, I see. I believe we could avoid having to fight with the people that
> only care about coherent architectures if we just have two separate
> implementations of dma_map_ops in the iommu code, one for coherent
> and one for noncoherent DMA. Any architecture that only needs one
> of them would then only enable the Kconfig options for that implementation
> and not care about the other one.

But then we have to invent yet another whole new API to deal with the
cache coherency issues - which makes for more documentation, and eventually
more abuse because it won't quite do what architectures want it to do,
etc.

> Yes, that sounds definitely possible. I guess it could be as simple
> as having a flag somewhere in struct device if we want to make it
> architecture independent.

I was referring to a flag in the dma_ops to say whether the DMA ops
implementation requires DMA cache coherency.  In the case of swiotlb,
performing full DMA cache coherency is a pure waste of CPU cycles -
and probably makes DMA much more expensive than merely switching back
to using PIO.

I'm really not interested in producing "generic" interfaces which end up
throwing the baby out with the bath water when we already have a better
implementation in place - even if the hardware sucks.  That's not
forward progress as far as I'm concerned.

> As for making the default being to do cache handling, I'm not completely
> sure how that would work on architectures where most devices are coherent.
> If I understood the DRM people correctly, some x86 machine have noncoherent
> DMA in their GPUs while everything else is coherent.

Well, it sounds like struct device needs a flag to indicate whether it is
coherent or not - but exactly how this gets set seems to be architecture
dependent.  I don't see bus or driver code being able to make the necessary
decisions - eg, tulip driver on x86 would be coherent, but tulip driver on
ARM would be non-coherent.

Nevertheless, doing it on a per-device basis is definitely the right
answer.
