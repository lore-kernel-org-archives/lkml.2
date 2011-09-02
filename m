Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab1IBMcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 08:32:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35130 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab1IBMcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 08:32:45 -0400
Message-ID: <4E60CCE9.5050900@monstr.eu>
Date: Fri, 02 Sep 2011 14:32:41 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Eli Billauer <eli@billauer.co.il>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/microblaze: Added sync method support for DMA and
 made refinements
References: <4E60A276.7010903@billauer.co.il>
In-Reply-To: <4E60A276.7010903@billauer.co.il>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eli Billauer wrote:
> Hi,
> 
> 
> This was supposed to be a small patch, but as I dug in, I found that 
> several things needed fixing. The sync support was tested by using a 
> hardware driver which calls these methods extensively. Scatter-gather 
> methods remain completely untested. General DMA operations work, or the 
> system would crash, I suppose.
> 
> 
> Here's a summary of the changes:
> 
> 
> * Added support for sync_single_for_*
> 
> * Added support for sync_sg_for_*
> 
> * Removed the previous (static) function __dma_sync_page() in favor of 
> __dma_sync(), so a single function can be used for all needs. This 
> (inline)  function was moved to dma_mapping.h, since it's used by 
> dma_cache_sync() there.
> 
> * Cache is now flushed on all dma mapping functions, regardless of 
> direction. It's obvious for DMA_TO_DEVICE, but not so obvious regarding 
> DMA_FROM_DEVICE. The reason in the latter case is that an unflushed 
> cache line will be written back to memory sooner or later, possibly 
> overwriting DMAed data.
> 
> * Cache is never invalidated on dma mapping. It's pointless, since the 
> CPU isn't supposed to touch the memory segment anyhow until unmap or sync.
> 
> * dma_cache_sync() now really syncs the cache (is was effectively a NOP)
> 
> 
> Patch follows.
> 
> 
>    Eli
> 
> 
> 
> Signed-off-by: Eli Billauer <eli.billauer@gmail.com>
> ---
> arch/microblaze/include/asm/dma-mapping.h |   20 +++++-
> arch/microblaze/kernel/dma.c              |  109 
> ++++++++++++++++++++++-------
> 2 files changed, 101 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/microblaze/include/asm/dma-mapping.h 
> b/arch/microblaze/include/asm/dma-mapping.h
> index 8fbb0ec..cddeca5 100644
> --- a/arch/microblaze/include/asm/dma-mapping.h
> +++ b/arch/microblaze/include/asm/dma-mapping.h
> @@ -28,12 +28,12 @@
> #include <linux/dma-attrs.h>
> #include <asm/io.h>
> #include <asm-generic/dma-coherent.h>
> +#include <asm/cacheflush.h>
> 
> #define DMA_ERROR_CODE        (~(dma_addr_t)0x0)
> 
> #define __dma_alloc_coherent(dev, gfp, size, handle)    NULL
> #define __dma_free_coherent(size, addr)        ((void)0)
> -#define __dma_sync(addr, size, rw)        ((void)0)
> 
> static inline unsigned long device_to_mask(struct device *dev)
> {
> @@ -95,6 +95,22 @@ static inline int dma_set_mask(struct device *dev, 
> u64 dma_mask)
> 
> #include <asm-generic/dma-mapping-common.h>
> 
> +static inline void __dma_sync(unsigned long paddr,
> +                  size_t size, enum dma_data_direction direction)
> +{
> +    switch (direction) {
> +    case DMA_TO_DEVICE:
> +    case DMA_BIDIRECTIONAL:
> +        flush_dcache_range(paddr, paddr + size);
> +        break;
> +    case DMA_FROM_DEVICE:
> +        invalidate_dcache_range(paddr, paddr + size);
> +        break;
> +    default:
> +        BUG();
> +    }
> +}
> +
> static inline int dma_mapping_error(struct device *dev, dma_addr_t 
> dma_addr)
> {
>     struct dma_map_ops *ops = get_dma_ops(dev);
> @@ -135,7 +151,7 @@ static inline void dma_cache_sync(struct device 
> *dev, void *vaddr, size_t size,
>         enum dma_data_direction direction)
> {
>     BUG_ON(direction == DMA_NONE);
> -    __dma_sync(vaddr, size, (int)direction);
> +    __dma_sync(virt_to_phys(vaddr), size, (int)direction);
> }
> 
> #endif    /* _ASM_MICROBLAZE_DMA_MAPPING_H */
> diff --git a/arch/microblaze/kernel/dma.c b/arch/microblaze/kernel/dma.c
> index 393e6b2..9fa9d82 100644
> --- a/arch/microblaze/kernel/dma.c
> +++ b/arch/microblaze/kernel/dma.c
> @@ -11,7 +11,6 @@
> #include <linux/gfp.h>
> #include <linux/dma-debug.h>
> #include <asm/bug.h>
> -#include <asm/cacheflush.h>
> 
> /*
>  * Generic direct DMA implementation
> @@ -21,21 +20,6 @@
>  * can set archdata.dma_data to an unsigned long holding the offset. By
>  * default the offset is PCI_DRAM_OFFSET.
>  */
> -static inline void __dma_sync_page(unsigned long paddr, unsigned long 
> offset,
> -                size_t size, enum dma_data_direction direction)
> -{
> -    switch (direction) {
> -    case DMA_TO_DEVICE:
> -    case DMA_BIDIRECTIONAL:
> -        flush_dcache_range(paddr + offset, paddr + offset + size);
> -        break;
> -    case DMA_FROM_DEVICE:
> -        invalidate_dcache_range(paddr + offset, paddr + offset + size);
> -        break;
> -    default:
> -        BUG();
> -    }
> -}
> 
> static unsigned long get_dma_direct_offset(struct device *dev)
> {
> @@ -91,17 +75,24 @@ static int dma_direct_map_sg(struct device *dev, 
> struct scatterlist *sgl,
>     /* FIXME this part of code is untested */
>     for_each_sg(sgl, sg, nents, i) {
>         sg->dma_address = sg_phys(sg) + get_dma_direct_offset(dev);
> -        __dma_sync_page(page_to_phys(sg_page(sg)), sg->offset,
> -                            sg->length, direction);
> +        __dma_sync(page_to_phys(sg_page(sg)) + sg->offset,
> +               sg->length, DMA_TO_DEVICE);
>     }
> 
>     return nents;
> }
> 
> -static void dma_direct_unmap_sg(struct device *dev, struct scatterlist 
> *sg,
> +static void dma_direct_unmap_sg(struct device *dev, struct scatterlist 
> *sgl,
>                 int nents, enum dma_data_direction direction,
>                 struct dma_attrs *attrs)
> {
> +    struct scatterlist *sg;
> +    int i;
> +
> +    /* FIXME this part of code is untested */
> +    if (direction == DMA_FROM_DEVICE)
> +        for_each_sg(sgl, sg, nents, i)
> +            __dma_sync(sg->dma_address, sg->length, direction);
> }
> 
> static int dma_direct_dma_supported(struct device *dev, u64 mask)
> @@ -116,7 +107,15 @@ static inline dma_addr_t dma_direct_map_page(struct 
> device *dev,
>                          enum dma_data_direction direction,
>                          struct dma_attrs *attrs)
> {
> -    __dma_sync_page(page_to_phys(page), offset, size, direction);
> +    /* We're before the DMA transfer, so cache invalidation makes no
> +       sense in the case of DMA_FROM_DEVICE. Flushing is necessary
> +       in either case, or an unflushed cache line may overwrite
> +       data written by device, in the event of that line being allocated
> +       for other use. Calling __dma_sync with DMA_TO_DEVICE makes this
> +       flush.
> +    */

Please fix this comment.

DMA_TO_DEVICE is fine - data has to be flushed.

For DMA_FROM_DEVICE you expect that allocated space will contains data from device.
Which means if you flush them, they will be rewritten by DMA in the next step.
Which means that IMHO you can invalidate them which is faster than flushing.
Of course if you flush them it shouldn't be any problem.

The question is if this case can happen.
offset + size is not cache align and code invalidate data which should be flush
but I think this can't happen.

Have you seen any problem with invalidation?


> +
> +    __dma_sync(page_to_phys(page) + offset, size, DMA_TO_DEVICE);
>     return page_to_phys(page) + offset + get_dma_direct_offset(dev);
> }
> 
> @@ -126,12 +125,66 @@ static inline void dma_direct_unmap_page(struct 
> device *dev,
>                      enum dma_data_direction direction,
>                      struct dma_attrs *attrs)
> {
> -/* There is not necessary to do cache cleanup
> - *
> - * phys_to_virt is here because in __dma_sync_page is __virt_to_phys and
> - * dma_address is physical address
> - */
> -    __dma_sync_page(dma_address, 0 , size, direction);
> +/* On a DMA to the device, the data has already been flushed and read by
> +   the device at the point unmapping is done. No point doing anything.
> +   In the other direction, unmapping may be used just before accessing the
> +   data on the CPU, so cache invalidation is necessary.
> +*/

fix this comment to linux style.

> +
> +    if (direction == DMA_FROM_DEVICE)
> +        __dma_sync(dma_address, size, direction);
> +}
> +
> +static inline void
> +dma_direct_sync_single_for_cpu(struct device *dev,
> +                   dma_addr_t dma_handle, size_t size,
> +                   enum dma_data_direction direction)
> +{
> +    /* It's pointless to invalidate the cache if the device isn't supposed
> +       to write to the relevant region */

ditto

> +
> +    if (direction == DMA_FROM_DEVICE)
> +        __dma_sync(dma_handle, size, direction);
> +}
> +
> +static inline void
> +dma_direct_sync_single_for_device(struct device *dev,
> +                  dma_addr_t dma_handle, size_t size,
> +                  enum dma_data_direction direction)
> +{
> +    /* It's pointless to flush the cache if the CPU isn't supposed
> +       to write to the relevant region */

ditto

> +
> +    if (direction == DMA_TO_DEVICE)
> +        __dma_sync(dma_handle, size, direction);
> +}
> +
> +static inline void
> +dma_direct_sync_sg_for_cpu(struct device *dev,
> +               struct scatterlist *sgl, int nents,
> +               enum dma_data_direction direction)
> +{
> +    struct scatterlist *sg;
> +    int i;
> +
> +    /* FIXME this part of code is untested */
> +    if (direction == DMA_FROM_DEVICE)
> +        for_each_sg(sgl, sg, nents, i)
> +            __dma_sync(sg->dma_address, sg->length, direction);
> +}
> +
> +static inline void
> +dma_direct_sync_sg_for_device(struct device *dev,
> +                  struct scatterlist *sgl, int nents,
> +                  enum dma_data_direction direction)
> +{
> +    struct scatterlist *sg;
> +    int i;
> +
> +    /* FIXME this part of code is untested */
> +    if (direction == DMA_TO_DEVICE)
> +        for_each_sg(sgl, sg, nents, i)
> +            __dma_sync(sg->dma_address, sg->length, direction);
> }
> 
> struct dma_map_ops dma_direct_ops = {
> @@ -142,6 +195,10 @@ struct dma_map_ops dma_direct_ops = {
>     .dma_supported    = dma_direct_dma_supported,
>     .map_page    = dma_direct_map_page,
>     .unmap_page    = dma_direct_unmap_page,
> +    .sync_single_for_cpu        = dma_direct_sync_single_for_cpu,
> +    .sync_single_for_device        = dma_direct_sync_single_for_device,
> +    .sync_sg_for_cpu        = dma_direct_sync_sg_for_cpu,
> +    .sync_sg_for_device        = dma_direct_sync_sg_for_device,
> };
> EXPORT_SYMBOL(dma_direct_ops);
> 

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
