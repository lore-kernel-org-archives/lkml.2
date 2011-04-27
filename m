Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab1D0I45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 04:56:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56706 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689Ab1D0I4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 04:56:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [RFC] ARM DMA mapping TODO, v1
Date: Wed, 27 Apr 2011 10:56:49 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <201104212129.17013.arnd@arndb.de> <20110427073514.GH17290@n2100.arm.linux.org.uk>
In-Reply-To: <20110427073514.GH17290@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104271056.49920.arnd@arndb.de>
X-Provags-ID: V02:K0:koYVM6/io2dIjooF4t38IXGkySD3mAVQQRCDXJiAurM
 jX2f1eflDcYL6gNgYB1SGGx4askKoRblG+emdq/kNhdB4wgE2S
 C/7E/7M+OhTd47AQopwoPnO6KCrE/qIwkk4k6W6NXZPl/lunK5
 fxoUEBGDd9Gn25jRrw9mCHL9FBaTaoM5X6K05cWrq6ER+hh2pw
 qHYSO5dD52qEEPEDbye5Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 April 2011, Russell King - ARM Linux wrote:
> > 2. Implement dma_alloc_noncoherent on ARM. Marek pointed out
> >    that this is needed, and it currently is not implemented, with
> >    an outdated comment explaining why it used to not be possible
> >    to do it.
> 
> dma_alloc_noncoherent is an entirely pointless API afaics.

The main use case that I can see for dma_alloc_noncoherent is being
able to allocate a large cacheable memory chunk that is mapped
contiguous into both kernel virtual and bus virtual space, but not
necessarily in contiguous in physical memory.

Without an IOMMU, I agree that it is pointless, because the only
sensible imlpementation would be alloc_pages_exact + dma_map_single.

> > 3. Convert ARM to use asm-generic/dma-mapping-common.h. We need
> >    both IOMMU and direct mapped DMA on some machines.
> > 
> > 4. Implement an architecture independent version of dma_map_ops
> >    based on the iommu.h API. As Joerg mentioned, this has been
> >    missing for some time, and it would be better to do it once
> >    than for each IOMMU separately. This is probably a lot of work.
> 
> dma_map_ops design is broken - we can't have the entire DMA API indirected
> through that structure.  Whether you have an IOMMU or not is completely
> independent of whether you have to do DMA cache handling.  Moreover, with
> dmabounce, having the DMA cache handling in place doesn't make sense.
> 
> So you can't have a dma_map_ops for the cache handling bits, a dma_map_ops
> for IOMMU, and a dma_map_ops for the dmabounce stuff.  It just doesn't
> work like that.
> 
> I believe the dma_map_ops stuff in asm-generic to be entirely unsuitable
> for ARM.

We probably still need to handle both the coherent and noncoherent case
in each dma_map_ops implementation, at least for those combinations where
they matter (definitely the linear mapping). However, I think that using
dma_mapping_common.h would let us use an architecture-independent dma_map_ops
for the generic iommu code that Marek wants to introduce now.

I still don't understand how dmabounce works, but if it's similar to
swiotlb, we can have at least three different dma_map_ops: linear, dmabounce
and iommu.

Without the common iommu abstraction, there would be a bigger incentive
to go with dma_map_ops, because then we would need one operations structure
per IOMMU implementation, as some other architectures (x86, powerpc,
ia64, ...) have. If we only need to distinguish between the common linear
mapping code and the common iommu code, then you are right and we are likely
better off adding some more conditionals to the existing code to handle
the iommu case in addition to the ones we handle today.

	Arnd
