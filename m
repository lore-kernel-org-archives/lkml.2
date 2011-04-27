Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760024Ab1D0ViO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 17:38:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:39771 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753869Ab1D0ViL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 17:38:11 -0400
Subject: Re: [RFC] ARM DMA mapping TODO, v1
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <20110427073514.GH17290@n2100.arm.linux.org.uk>
References: <201104212129.17013.arnd@arndb.de>
	 <20110427073514.GH17290@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Apr 2011 07:37:51 +1000
Message-ID: <1303940271.2513.187.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 08:35 +0100, Russell King - ARM Linux wrote:
> On Thu, Apr 21, 2011 at 09:29:16PM +0200, Arnd Bergmann wrote:
> > 1. Fix the arm version of dma_alloc_coherent. It's in use today and
> >    is broken on modern CPUs because it results in both cached and
> >    uncached mappings. Rebecca suggested different approaches how to
> >    get there.
> 
> I also suggested various approaches and produced patches, which I'm slowly
> feeding in.  However, I think whatever we do, we'll end up breaking
> something along the line - especially as various places assume that
> dma_alloc_coherent() is ultimately backed by memory with a struct page.

Our implementation for embedded ppc has a similar problem. It currently
uses a pool of memory and does virtual mappings on it which means no
struct page easy to get to. How do you do on your side ? A fixed size
pool that you take out of the linear mapping ? Or you allocate pages in
the linear mapping and "unmap" them ? The problem I have with some
embedded ppc's is that the linear map is mapped in chunks of 256M or
so....

> > 2. Implement dma_alloc_noncoherent on ARM. Marek pointed out
> >    that this is needed, and it currently is not implemented, with
> >    an outdated comment explaining why it used to not be possible
> >    to do it.
> 
> dma_alloc_noncoherent is an entirely pointless API afaics.

I was about to ask what the point is ... (what is the expected
semantic ? Memory that is reachable but not necessarily cache
coherent ?)

> > 3. Convert ARM to use asm-generic/dma-mapping-common.h. We need
> >    both IOMMU and direct mapped DMA on some machines.
> > 
> > 4. Implement an architecture independent version of dma_map_ops
> >    based on the iommu.h API. As Joerg mentioned, this has been
> >    missing for some time, and it would be better to do it once
> >    than for each IOMMU separately. This is probably a lot of work.
> 
> dma_map_ops design is broken - we can't have the entire DMA API indirected
> through that structure.

Why not ? That's the only way we can deal in my experience with multiple
type of different iommu's etc... at runtime in a single kernel. We used
to more/less have global function pointers in a long past but we moved
to per device ops instead to cope with multiple DMA path within a given
system and it works fine.

>   Whether you have an IOMMU or not is completely
> independent of whether you have to do DMA cache handling.  Moreover, with
> dmabounce, having the DMA cache handling in place doesn't make sense.

Right. For now I don't have that problem on ppc as my iommu archs are
also fully coherent, so it's a bit more tricky that way but can be
handled I suppose by having the cache mgmnt be lib functions based on
flags added to the struct device.

> So you can't have a dma_map_ops for the cache handling bits, a dma_map_ops
> for IOMMU, and a dma_map_ops for the dmabounce stuff.  It just doesn't
> work like that.

Well, the dmabounce and cache handling is one implementation that's just
on/off with parameters no ?. iommu is different implementations. So the
ops should be for the iommu backends. The dmabounce & cache handling is
then done by those backends based on flags you stick in struct device
for example.

> I believe the dma_map_ops stuff in asm-generic to be entirely unsuitable
> for ARM.

I don't think it is :-)

Cheers,
Ben.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


