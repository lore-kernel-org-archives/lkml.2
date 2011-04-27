Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220Ab1D0LC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 07:02:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60735 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757961Ab1D0LC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 07:02:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [RFC] ARM DMA mapping TODO, v1
Date: Wed, 27 Apr 2011 13:02:43 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <201104212129.17013.arnd@arndb.de> <201104271056.49920.arnd@arndb.de> <20110427090923.GO17290@n2100.arm.linux.org.uk>
In-Reply-To: <20110427090923.GO17290@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104271302.44249.arnd@arndb.de>
X-Provags-ID: V02:K0:X5V6BoHXchxGFw3ylLPsTTKTioGNj+djTJa7YBezwuo
 nYyHch9DE/4mSMebXPw2pLObc4QpTBojNa5oobbt/z4MXSGy4P
 Y+BQekfZbmZqsbUrByHGxbunejTh29+T3vq55kHW+JRGjqzdaC
 xm6IVXglpf528bHzmuu8leLoM244CsJVR+GUdm7byCgLudX90W
 l0tIrUCYyzjUB0QxFjCCg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 April 2011, Russell King - ARM Linux wrote:
> On Wed, Apr 27, 2011 at 10:56:49AM +0200, Arnd Bergmann wrote:
> > We probably still need to handle both the coherent and noncoherent case
> > in each dma_map_ops implementation, at least for those combinations where
> > they matter (definitely the linear mapping). However, I think that using
> > dma_mapping_common.h would let us use an architecture-independent dma_map_ops
> > for the generic iommu code that Marek wants to introduce now.
> 
> The 'do we have an iommu or not' question and the 'do we need to do cache
> coherency' question are two independent questions which are unrelated to
> each other.  There are four unique but equally valid combinations.
> 
> Pushing the cache coherency question down into the iommu stuff will mean
> that we'll constantly be fighting against the 'but this iommu works on x86'
> shite that we've fought with over block device crap for years.  I have
> no desire to go there.

Ok, I see. I believe we could avoid having to fight with the people that
only care about coherent architectures if we just have two separate
implementations of dma_map_ops in the iommu code, one for coherent
and one for noncoherent DMA. Any architecture that only needs one
of them would then only enable the Kconfig options for that implementation
and not care about the other one.

> What we need is a proper abstraction where the DMA ops can say whether
> they can avoid DMA cache handling (eg, swiotlb or dmabounce stuff) but
> default to DMA cache handling being the norm - and the DMA cache handling
> performed in the level above the DMA ops indirection.

Yes, that sounds definitely possible. I guess it could be as simple
as having a flag somewhere in struct device if we want to make it
architecture independent.

As for making the default being to do cache handling, I'm not completely
sure how that would work on architectures where most devices are coherent.
If I understood the DRM people correctly, some x86 machine have noncoherent
DMA in their GPUs while everything else is coherent.

Maybe we can default to arch_is_coherent() and allow a device to override
that when it knows better.

	Arnd
