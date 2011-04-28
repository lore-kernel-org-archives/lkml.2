Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638Ab1D1Jhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 05:37:55 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35958 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673Ab1D1Jhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 05:37:53 -0400
Date: Thu, 28 Apr 2011 10:37:41 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC] ARM DMA mapping TODO, v1
Message-ID: <20110428093741.GV17290@n2100.arm.linux.org.uk>
References: <201104212129.17013.arnd@arndb.de> <20110427073514.GH17290@n2100.arm.linux.org.uk> <1303940271.2513.187.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303940271.2513.187.camel@pasglop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 07:37:51AM +1000, Benjamin Herrenschmidt wrote:
> On Wed, 2011-04-27 at 08:35 +0100, Russell King - ARM Linux wrote:
> > On Thu, Apr 21, 2011 at 09:29:16PM +0200, Arnd Bergmann wrote:
> > > 1. Fix the arm version of dma_alloc_coherent. It's in use today and
> > >    is broken on modern CPUs because it results in both cached and
> > >    uncached mappings. Rebecca suggested different approaches how to
> > >    get there.
> > 
> > I also suggested various approaches and produced patches, which I'm slowly
> > feeding in.  However, I think whatever we do, we'll end up breaking
> > something along the line - especially as various places assume that
> > dma_alloc_coherent() is ultimately backed by memory with a struct page.
> 
> Our implementation for embedded ppc has a similar problem. It currently
> uses a pool of memory and does virtual mappings on it which means no
> struct page easy to get to. How do you do on your side ? A fixed size
> pool that you take out of the linear mapping ? Or you allocate pages in
> the linear mapping and "unmap" them ? The problem I have with some
> embedded ppc's is that the linear map is mapped in chunks of 256M or
> so....

We don't - what I was referring to was people taking the DMA cookie and
treating it as a physical address, converting it to a PFN and then doing
pfn_to_page() on that.  (Yes, it's been tried.)

There have been some subsystems (eg ALSA) which also tried to use
virt_to_page() on dma_alloc_coherent(), but I think those got fixed to
use our dma_mmap_coherent() stuff when building on ARM.

> > > 2. Implement dma_alloc_noncoherent on ARM. Marek pointed out
> > >    that this is needed, and it currently is not implemented, with
> > >    an outdated comment explaining why it used to not be possible
> > >    to do it.
> > 
> > dma_alloc_noncoherent is an entirely pointless API afaics.
> 
> I was about to ask what the point is ... (what is the expected
> semantic ? Memory that is reachable but not necessarily cache
> coherent ?)

As far as I can see, dma_alloc_noncoherent() should just be a wrapper
around the normal page allocation function.  I don't see it ever needing
to do anything special - and the advantage of just being the normal
page allocation function is that its properties are well known and
architecture independent.

> > > 3. Convert ARM to use asm-generic/dma-mapping-common.h. We need
> > >    both IOMMU and direct mapped DMA on some machines.
> > > 
> > > 4. Implement an architecture independent version of dma_map_ops
> > >    based on the iommu.h API. As Joerg mentioned, this has been
> > >    missing for some time, and it would be better to do it once
> > >    than for each IOMMU separately. This is probably a lot of work.
> > 
> > dma_map_ops design is broken - we can't have the entire DMA API indirected
> > through that structure.
> 
> Why not ? That's the only way we can deal in my experience with multiple
> type of different iommu's etc... at runtime in a single kernel. We used
> to more/less have global function pointers in a long past but we moved
> to per device ops instead to cope with multiple DMA path within a given
> system and it works fine.
> 
> >   Whether you have an IOMMU or not is completely
> > independent of whether you have to do DMA cache handling.  Moreover, with
> > dmabounce, having the DMA cache handling in place doesn't make sense.

Here I've answered your question above.

> Right. For now I don't have that problem on ppc as my iommu archs are
> also fully coherent, so it's a bit more tricky that way but can be
> handled I suppose by having the cache mgmnt be lib functions based on
> flags added to the struct device.

Think about stuffing all the iommu drivers with DMA cache management for
ARM, and think about the maintainability for that when other folk come
along and change the iommu drivers.  I've no desire to keep going to fix
them each time someone breaks the DMA cache management because everyone
elses cache is DMA coherent.

Keep that in the arch code, out of the dma_ops and it doesn't have to be
thought about by each and every iommu driver.

> > So you can't have a dma_map_ops for the cache handling bits, a dma_map_ops
> > for IOMMU, and a dma_map_ops for the dmabounce stuff.  It just doesn't
> > work like that.
> 
> Well, the dmabounce and cache handling is one implementation that's just
> on/off with parameters no ?. iommu is different implementations. So the
> ops should be for the iommu backends. The dmabounce & cache handling is
> then done by those backends based on flags you stick in struct device
> for example.

You've completely missed the point.

