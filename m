Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab2GIUdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 16:33:44 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:26391 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182Ab2GIUdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 16:33:43 -0400
Date: Mon, 9 Jul 2012 16:25:05 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Shuah Khan <shuah.khan@hp.com>, fujita.tomonori@lab.ntt.co.jp
Cc: LKML <linux-kernel@vger.kernel.org>, shuahkhan@gmail.com,
        akpm@linux-foundation.org, paul.gortmaker@windriver.com,
        bhelgaas@google.com, amwang@redhat.com
Subject: Re: [PATCH RFC] swiotlb: Remove SWIOTLB overflow buffer support
Message-ID: <20120709202505.GA9541@phenom.dumpdata.com>
References: <1341615972.3101.27.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341615972.3101.27.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 05:06:12PM -0600, Shuah Khan wrote:
> Remove SWIOTLB overflow buffer support and return DMA_ERROR_CODE
> (a value of zero) to make it consistent with iommu implementation
> on Intel, AMD, and swiotlb-xen.

While this is a good forward step and this needs to be done eventually,
you should first send out patches for the drivers that don't check
for the DMA_ERROR_CODE when doing mapping. In other words for the
drivers that map but don't call dma_mapping_error to check.

When that is fixed and *all the drivers that don't call dma_mapping_error
are fixed, then this patch makes sense. 

So for right now, NACK.

Also you missed CC-ing fujita.tomonori@lab.ntt.co.jp, so let me add
that to this email.

*: for those that it makes sense. I am not sure if folks are still using
ancient drivers..

> 
> Tested only on x86.
> 
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> ---
>  lib/swiotlb.c |   44 ++++++++------------------------------------
>  1 file changed, 8 insertions(+), 36 deletions(-)
> 
> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> index 45bc1f8..7f0a5d1 100644
> --- a/lib/swiotlb.c
> +++ b/lib/swiotlb.c
> @@ -15,6 +15,7 @@
>   * 05/09/10 linville	Add support for syncing ranges, support syncing for
>   *			DMA_BIDIRECTIONAL mappings, miscellaneous cleanup.
>   * 08/12/11 beckyb	Add highmem support
> + * 06/12    shuahkhan	Remove io tlb overflow support
>   */
>  
>  #include <linux/cache.h>
> @@ -66,13 +67,6 @@ static char *io_tlb_start, *io_tlb_end;
>  static unsigned long io_tlb_nslabs;
>  
>  /*
> - * When the IOMMU overflows we return a fallback buffer. This sets the size.
> - */
> -static unsigned long io_tlb_overflow = 32*1024;
> -
> -static void *io_tlb_overflow_buffer;
> -
> -/*
>   * This is a free list describing the number of free entries available from
>   * each index
>   */
> @@ -108,7 +102,6 @@ setup_io_tlb_npages(char *str)
>  	return 1;
>  }
>  __setup("swiotlb=", setup_io_tlb_npages);
> -/* make io_tlb_overflow tunable too? */
>  
>  unsigned long swiotlb_nr_tbl(void)
>  {
> @@ -156,12 +149,6 @@ void __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
>  	io_tlb_index = 0;
>  	io_tlb_orig_addr = alloc_bootmem_pages(PAGE_ALIGN(io_tlb_nslabs * sizeof(phys_addr_t)));
>  
> -	/*
> -	 * Get the overflow emergency buffer
> -	 */
> -	io_tlb_overflow_buffer = alloc_bootmem_low_pages(PAGE_ALIGN(io_tlb_overflow));
> -	if (!io_tlb_overflow_buffer)
> -		panic("Cannot allocate SWIOTLB overflow buffer!\n");
>  	if (verbose)
>  		swiotlb_print_info();
>  }
> @@ -195,7 +182,8 @@ swiotlb_init_with_default_size(size_t default_size, int verbose)
>  void __init
>  swiotlb_init(int verbose)
>  {
> -	swiotlb_init_with_default_size(64 * (1<<20), verbose);	/* default to 64MB */
> +	/* default to 64MB */
> +	swiotlb_init_with_default_size(64 * (1<<20), verbose);
>  }
>  
>  /*
> @@ -264,24 +252,12 @@ swiotlb_late_init_with_default_size(size_t default_size)
>  
>  	memset(io_tlb_orig_addr, 0, io_tlb_nslabs * sizeof(phys_addr_t));
>  
> -	/*
> -	 * Get the overflow emergency buffer
> -	 */
> -	io_tlb_overflow_buffer = (void *)__get_free_pages(GFP_DMA,
> -	                                          get_order(io_tlb_overflow));
> -	if (!io_tlb_overflow_buffer)
> -		goto cleanup4;
> -
>  	swiotlb_print_info();
>  
>  	late_alloc = 1;
>  
>  	return 0;
>  
> -cleanup4:
> -	free_pages((unsigned long)io_tlb_orig_addr,
> -		   get_order(io_tlb_nslabs * sizeof(phys_addr_t)));
> -	io_tlb_orig_addr = NULL;
>  cleanup3:
>  	free_pages((unsigned long)io_tlb_list, get_order(io_tlb_nslabs *
>  	                                                 sizeof(int)));
> @@ -297,12 +273,10 @@ cleanup1:
>  
>  void __init swiotlb_free(void)
>  {
> -	if (!io_tlb_overflow_buffer)
> +	if (!io_tlb_orig_addr)
>  		return;
>  
>  	if (late_alloc) {
> -		free_pages((unsigned long)io_tlb_overflow_buffer,
> -			   get_order(io_tlb_overflow));
>  		free_pages((unsigned long)io_tlb_orig_addr,
>  			   get_order(io_tlb_nslabs * sizeof(phys_addr_t)));
>  		free_pages((unsigned long)io_tlb_list, get_order(io_tlb_nslabs *
> @@ -310,8 +284,6 @@ void __init swiotlb_free(void)
>  		free_pages((unsigned long)io_tlb_start,
>  			   get_order(io_tlb_nslabs << IO_TLB_SHIFT));
>  	} else {
> -		free_bootmem_late(__pa(io_tlb_overflow_buffer),
> -				  PAGE_ALIGN(io_tlb_overflow));
>  		free_bootmem_late(__pa(io_tlb_orig_addr),
>  				  PAGE_ALIGN(io_tlb_nslabs * sizeof(phys_addr_t)));
>  		free_bootmem_late(__pa(io_tlb_list),
> @@ -639,7 +611,7 @@ swiotlb_full(struct device *dev, size_t size, enum dma_data_direction dir,
>  	printk(KERN_ERR "DMA: Out of SW-IOMMU space for %zu bytes at "
>  	       "device %s\n", size, dev ? dev_name(dev) : "?");
>  
> -	if (size <= io_tlb_overflow || !do_panic)
> +	if (!do_panic)
>  		return;
>  
>  	if (dir == DMA_BIDIRECTIONAL)
> @@ -681,7 +653,7 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
>  	map = map_single(dev, phys, size, dir);
>  	if (!map) {
>  		swiotlb_full(dev, size, dir, 1);
> -		map = io_tlb_overflow_buffer;
> +		return DMA_ERROR_CODE;
>  	}
>  
>  	dev_addr = swiotlb_virt_to_bus(dev, map);
> @@ -691,7 +663,7 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
>  	 */
>  	if (!dma_capable(dev, dev_addr, size)) {
>  		swiotlb_tbl_unmap_single(dev, map, size, dir);
> -		dev_addr = swiotlb_virt_to_bus(dev, io_tlb_overflow_buffer);
> +		dev_addr = 0;
>  	}
>  
>  	return dev_addr;
> @@ -910,7 +882,7 @@ EXPORT_SYMBOL(swiotlb_sync_sg_for_device);
>  int
>  swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr)
>  {
> -	return (dma_addr == swiotlb_virt_to_bus(hwdev, io_tlb_overflow_buffer));
> +	return !dma_addr;
>  }
>  EXPORT_SYMBOL(swiotlb_dma_mapping_error);
>  
> -- 
> 1.7.9.5
> 
> 
