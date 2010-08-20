Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab0HTUFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 16:05:38 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:41862 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751792Ab0HTUFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 16:05:36 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19LXHkoEB1LBNsAM3LPcvbeLAw5LJxElz7T76JeEG
	rUqnGPs0R4z924
Date: Fri, 20 Aug 2010 22:05:30 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Marin Mitov <mitov@issp.bas.bg>
cc: linux-kernel@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Greg KH <greg@kroah.com>, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [RFC][PATCH] add dma_reserve_coherent_memory()/dma_free_reserved_memory()
 API
In-Reply-To: <201008191818.36068.mitov@issp.bas.bg>
Message-ID: <Pine.LNX.4.64.1008202148110.6103@axis700.grange>
References: <201008191818.36068.mitov@issp.bas.bg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Aug 2010, Marin Mitov wrote:

> Hi all,
> 
> struct device contains a member: struct dma_coherent_mem *dma_mem;
> to hold information for a piece of memory declared dma-coherent.
> Alternatively the same member could also be used to hold preallocated
> dma-coherent memory for latter per-device use.
> 
> This tric is already used in drivers/staging/dt3155v4l.c
> dt3155_alloc_coherent()/dt3155_free_coherent()
> 
> Here proposed for general use by popular demand from video4linux folks.
> Helps for videobuf-dma-contig framework.

Ok, so, we've got two solutions to this problem submitted on the same 
day;) Following this thread:

http://marc.info/?t=128128236400002&r=1&w=2

on the ARM Linux kernel ML, I submitted a patch series

http://thread.gmane.org/gmane.linux.ports.sh.devel/8595

with a couple of fixes and improvements, the actual new API and a use 
example. My approach is slightly different, in that instead of requiring 
drivers to issue two calls - one to reserve RAM (usually 
dma_alloc_coherent()) and one to assign it to a device, my patch follows 
the suggestion from Russell King from the first thread and unites these 
two operations. So, now we have a choice;) Unfortunately, these two patch 
series went to orthogonal sets of recepients, I'm trying to fix this by 
adding a couple of CC entries.

Thanks
Guennadi

> 
> Signed-off-by: Marin Mitov <mitov@issp.bas.bg>
> 
> ======================================================================
> --- a/drivers/base/dma-coherent.c	2010-08-19 15:50:42.000000000 +0300
> +++ b/drivers/base/dma-coherent.c	2010-08-19 17:27:56.000000000 +0300
> @@ -93,6 +93,83 @@ void *dma_mark_declared_memory_occupied(
>  EXPORT_SYMBOL(dma_mark_declared_memory_occupied);
>  
>  /**
> + * dma_reserve_coherent_memory() - reserve coherent memory for per-device use
> + *
> + * @dev:	device from which we allocate memory
> + * @size:	size of requested memory area in bytes
> + * @flags:	same as in dma_declare_coherent_memory()
> + *
> + * This function reserves coherent memory allocating it early (during probe())
> + * to support latter allocations from per-device coherent memory pools.
> + * For a given device one could use either dma_declare_coherent_memory() or
> + * dma_reserve_coherent_memory(), but not both, becase the result of these
> + * functions is stored in a single struct device member - dma_mem
> + *
> + * Returns DMA_MEMORY_MAP on success, or 0 if failed.
> + * (same as dma_declare_coherent_memory()
> + */
> +int dma_reserve_coherent_memory(struct device *dev, size_t size, int flags)
> +{
> +	struct dma_coherent_mem *mem;
> +	dma_addr_t dev_base;
> +	int pages = size >> PAGE_SHIFT;
> +	int bitmap_size = BITS_TO_LONGS(pages) * sizeof(long);
> +
> +	if ((flags & DMA_MEMORY_MAP) == 0)
> +		goto out;
> +	if (!size)
> +		goto out;
> +	if (dev->dma_mem)
> +		goto out;
> +
> +	mem = kzalloc(sizeof(*mem), GFP_KERNEL);
> +	if (!mem)
> +		goto out;
> +	mem->virt_base = dma_alloc_coherent(dev, size, &dev_base,
> +							DT3155_COH_FLAGS);
> +	if (!mem->virt_base)
> +		goto err_alloc_coherent;
> +	mem->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
> +	if (!mem->bitmap)
> +		goto err_bitmap;
> +
> +	mem->device_base = dev_base;
> +	mem->size = pages;
> +	mem->flags = flags;
> +	dev->dma_mem = mem;
> +	return DMA_MEMORY_MAP;
> +
> +err_bitmap:
> +	dma_free_coherent(dev, size, mem->virt_base, dev_base);
> +err_alloc_coherent:
> +	kfree(mem);
> +out:
> +	return 0;
> +}
> +EXPORT_SYMBOL(dma_reserve_coherent_memory);
> +
> +/**
> + * dma_free_reserved_memory() - free the reserved dma-coherent memoty
> + *
> + * @dev:	device for which we free the dma-coherent memory
> + *
> + * same as dma_release_declared_memory()
> + */
> +void dma_free_reserved_memory(struct device *dev)
> +{
> +	struct dma_coherent_mem *mem = dev->dma_mem;
> +
> +	if (!mem)
> +		return;
> +	dev->dma_mem = NULL;
> +	dma_free_coherent(dev, mem->size << PAGE_SHIFT,
> +					mem->virt_base, mem->device_base);
> +	kfree(mem->bitmap);
> +	kfree(mem);
> +}
> +EXPORT_SYMBOL(dma_free_reserved_memory);
> +
> +/**
>   * dma_alloc_from_coherent() - try to allocate memory from the per-device coherent area
>   *
>   * @dev:	device from which we allocate memory
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
