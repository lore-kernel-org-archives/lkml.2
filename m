Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759414Ab1D1Mmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 08:42:51 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37299 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463Ab1D1Mmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 08:42:49 -0400
Date: Thu, 28 Apr 2011 13:42:42 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Joerg Roedel <joro@8bytes.org>
Cc: linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC] ARM DMA mapping TODO, v1
Message-ID: <20110428124242.GJ17290@n2100.arm.linux.org.uk>
References: <201104212129.17013.arnd@arndb.de> <20110427073514.GH17290@n2100.arm.linux.org.uk> <20110428104143.GB13402@8bytes.org> <20110428110129.GE17290@n2100.arm.linux.org.uk> <20110428122508.GC13402@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110428122508.GC13402@8bytes.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 02:25:09PM +0200, Joerg Roedel wrote:
> On Thu, Apr 28, 2011 at 12:01:29PM +0100, Russell King - ARM Linux wrote:
> 
> > dma_addr_t dma_map_page(struct device *dev, struct page *page, size_t offset,
> >                         size_t size, enum dma_data_direction dir)
> > {
> > 	struct dma_map_ops *ops = get_dma_ops(dev);
> > 	dma_addr_t addr;
> > 
> > 	BUG_ON(!valid_dma_direction(dir));
> > 	if (ops->flags & DMA_MANAGE_CACHE || !dev->dma_cache_coherent)
> > 		__dma_page_cpu_to_dev(page, offset, size, dir);
> > 	addr = ops->map_page(dev, page, offset, size, dir, NULL);
> > 	debug_dma_map_page(dev, page, offset, size, dir, addr, false);
> > 
> > 	return addr;
> > }
> > 
> > Things like swiotlb and dmabounce would not set DMA_MANAGE_CACHE in
> > ops->flags, but real iommus and the standard no-iommu implementations
> > would be required to set it to ensure that data is visible in memory
> > for CPUs which have DMA incoherent caches.
> 
> Do we need flags for that? A flag is necessary if the cache-management
> differs between IOMMU implementations on the same platform. If
> cache-management is only specific to the platform (or architecture) then
> it does make more sense to just call the function without flag checking
> and every platform with coherent DMA just implements these as static
> inline noops.

Sigh.  You're not seeing the point.

There is _no_ point doing the cache management _if_ we're using something
like dmabounce or swiotlb, as we'll be using memcpy() at some point with
the buffer.  Moreover, dmabounce or swiotlb may have to do its own cache
management _after_ that memcpy() to ensure that the page cache requirements
are met.

Doing DMA cache management for dmabounce or swiotlb will result in
unnecessary overhead - and as we can see from the MMC discussions,
it has a _significant_ performance impact.

Think about it.  If you're using dmabounce, but still do the cache
management:

1. you flush the data out of the CPU cache back to memory.
2. you allocate new memory using dma_alloc_coherent() for the DMA buffer
   which is accessible to the device.
3. you memcpy() the data out of the buffer you just flushed into the
   DMA buffer - this re-fills the cache, evicting entries which may
   otherwise be hot due to the cache fill policy.

Step 1 is entirely unnecessary and is just a complete and utter waste of
CPU resources.
