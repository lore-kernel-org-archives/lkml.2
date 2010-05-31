Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab0EaC6z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 22:58:55 -0400
Received: from sh.osrg.net ([192.16.179.4]:49668 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755593Ab0EaC6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 22:58:53 -0400
Date: Mon, 31 May 2010 11:58:13 +0900
To: cmetcalf@tilera.com
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 4/8] arch/tile: core kernel/ code.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <201005290334.o4T3Y6dP029952@farm-0002.internal.tilera.com>
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com>
	<201005290334.o4T3Y6dP029952@farm-0002.internal.tilera.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100531115731I.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 31 May 2010 11:58:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 May 2010 23:10:39 -0400
Chris Metcalf <cmetcalf@tilera.com> wrote:

> This omits just the tile-desc_32.c file, which is large enough to
> merit being in a separate commit.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

(snip)

> diff --git a/arch/tile/kernel/pci-dma.c b/arch/tile/kernel/pci-dma.c
> new file mode 100644
> index 0000000..b1ddc80
> --- /dev/null
> +++ b/arch/tile/kernel/pci-dma.c
> @@ -0,0 +1,231 @@
> +/*
> + * Copyright 2010 Tilera Corporation. All Rights Reserved.
> + *
> + *   This program is free software; you can redistribute it and/or
> + *   modify it under the terms of the GNU General Public License
> + *   as published by the Free Software Foundation, version 2.
> + *
> + *   This program is distributed in the hope that it will be useful, but
> + *   WITHOUT ANY WARRANTY; without even the implied warranty of
> + *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
> + *   NON INFRINGEMENT.  See the GNU General Public License for
> + *   more details.
> + */
> +
> +#include <linux/mm.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/vmalloc.h>
> +#include <asm/tlbflush.h>
> +#include <asm/homecache.h>
> +
> +/* Generic DMA mapping functions: */
> +
> +/*
> + * Allocate what Linux calls "coherent" memory, which for us just
> + * means uncached.
> + */
> +void *dma_alloc_coherent(struct device *dev,
> +			 size_t size,
> +			 dma_addr_t *dma_handle,
> +			 gfp_t gfp)
> +{
> +	int order;
> +	struct page *pg;
> +
> +	gfp |= GFP_KERNEL | __GFP_ZERO;
> +
> +	order = get_order(size);
> +	/* alloc on node 0 so the paddr fits in a u32 */

What "the paddr fits in a u32" means? If dev->coherent_dma_mask is
larger than DMA_BIT_MASK(32), you can return an address above it?


> +	pg = homecache_alloc_pages_node(0, gfp, order, PAGE_HOME_UNCACHED);
> +	if (pg == NULL)
> +		return NULL;
> +
> +	*dma_handle = page_to_pa(pg);
> +	return (void *) page_address(pg);
> +}
> +EXPORT_SYMBOL(dma_alloc_coherent);
> +
> +/*
> + * Free memory that was allocated with dma_alloc_coherent.
> + */
> +void dma_free_coherent(struct device *dev, size_t size,
> +		  void *vaddr, dma_addr_t dma_handle)
> +{
> +	homecache_free_pages((unsigned long)vaddr, get_order(size));
> +}
> +EXPORT_SYMBOL(dma_free_coherent);
> +
> +/*
> + * The map routines "map" the specified address range for DMA
> + * accesses.  The memory belongs to the device after this call is
> + * issued, until it is unmapped with dma_unmap_single.
> + *
> + * We don't need to do any mapping, we just flush the address range
> + * out of the cache and return a DMA address.
> + *
> + * The unmap routines do whatever is necessary before the processor
> + * accesses the memory again, and must be called before the driver
> + * touches the memory.  We can get away with a cache invalidate if we
> + * can count on nothing having been touched.
> + */
> +
> +
> +/*
> + * dma_map_single can be passed any memory address, and there appear
> + * to be no alignment constraints.
> + *
> + * There is a chance that the start of the buffer will share a cache
> + * line with some other data that has been touched in the meantime.
> + */
> +dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
> +	       enum dma_data_direction direction)
> +{
> +	struct page *page;
> +	dma_addr_t dma_addr;
> +	int thispage;
> +
> +	BUG_ON(!valid_dma_direction(direction));
> +	WARN_ON(size == 0);
> +
> +	dma_addr = __pa(ptr);
> +
> +	/* We might have been handed a buffer that wraps a page boundary */
> +	while ((int)size > 0) {
> +		/* The amount to flush that's on this page */
> +		thispage = PAGE_SIZE - ((unsigned long)ptr & (PAGE_SIZE - 1));
> +		thispage = min((int)thispage, (int)size);
> +		/* Is this valid for any page we could be handed? */
> +		page = pfn_to_page(kaddr_to_pfn(ptr));
> +		homecache_flush_cache(page, 0);
> +		ptr += thispage;
> +		size -= thispage;
> +	}
> +
> +	return dma_addr;
> +}
> +EXPORT_SYMBOL(dma_map_single);
> +
> +void dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
> +		 enum dma_data_direction direction)
> +{
> +	BUG_ON(!valid_dma_direction(direction));
> +}
> +EXPORT_SYMBOL(dma_unmap_single);
> +
> +int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
> +	   enum dma_data_direction direction)
> +{
> +	int i;
> +
> +	BUG_ON(!valid_dma_direction(direction));
> +
> +	WARN_ON(nents == 0 || sg[0].length == 0);
> +
> +	for (i = 0; i < nents; i++) {
> +		struct page *page;
> +		sg[i].dma_address = sg_phys(sg + i);
> +		page = pfn_to_page(sg[i].dma_address >> PAGE_SHIFT);
> +		homecache_flush_cache(page, 0);
> +	}

Can you use for_each_sg()?


> +	return nents;
> +}
> +EXPORT_SYMBOL(dma_map_sg);
> +
> +void dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
> +	     enum dma_data_direction direction)
> +{
> +	BUG_ON(!valid_dma_direction(direction));
> +}
> +EXPORT_SYMBOL(dma_unmap_sg);
> +
> +dma_addr_t dma_map_page(struct device *dev, struct page *page,
> +			unsigned long offset, size_t size,
> +			enum dma_data_direction direction)
> +{
> +	BUG_ON(!valid_dma_direction(direction));
> +
> +	homecache_flush_cache(page, 0);
> +
> +	return page_to_pa(page) + offset;
> +}
> +EXPORT_SYMBOL(dma_map_page);
> +
> +void dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
> +	       enum dma_data_direction direction)
> +{
> +	BUG_ON(!valid_dma_direction(direction));
> +}
> +EXPORT_SYMBOL(dma_unmap_page);
> +
> +void dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
> +			     size_t size, enum dma_data_direction direction)
> +{
> +	BUG_ON(!valid_dma_direction(direction));
> +}
> +EXPORT_SYMBOL(dma_sync_single_for_cpu);
> +
> +void dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
> +				size_t size, enum dma_data_direction direction)
> +{
> +	unsigned long start = PFN_DOWN(dma_handle);
> +	unsigned long end = PFN_DOWN(dma_handle + size - 1);
> +	unsigned long i;
> +
> +	BUG_ON(!valid_dma_direction(direction));
> +	for (i = start; i <= end; ++i)
> +		homecache_flush_cache(pfn_to_page(i), 0);
> +}
> +EXPORT_SYMBOL(dma_sync_single_for_device);
> +
> +void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
> +		    enum dma_data_direction direction)
> +{
> +	BUG_ON(!valid_dma_direction(direction));
> +	WARN_ON(nelems == 0 || sg[0].length == 0);
> +}
> +EXPORT_SYMBOL(dma_sync_sg_for_cpu);
> +
> +/*
> + * Flush and invalidate cache for scatterlist.
> + */
> +void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
> +			    int nelems, enum dma_data_direction direction)
> +{
> +	int i;
> +
> +	BUG_ON(!valid_dma_direction(direction));
> +	WARN_ON(nelems == 0 || sg[0].length == 0);
> +
> +	for (i = 0; i < nelems; i++)
> +		dma_sync_single_for_device(dev, sg[i].dma_address,
> +					   sg[i].dma_length, direction);

ditto.
