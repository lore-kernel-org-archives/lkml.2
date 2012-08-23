Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab2HWHd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 03:33:28 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15186 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756045Ab2HWHdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 03:33:23 -0400
X-AuditID: cbfee61a-b7fc66d0000043b7-15-5035dcc11443
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: "'Hiroshi Doyu'" <hdoyu@nvidia.com>
Cc: linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, arnd@arndb.de, linux@arm.linux.org.uk,
        chunsang.jeong@linaro.org, vdumpa@nvidia.com, konrad.wilk@oracle.com,
        subashrp@gmail.com, minchan@kernel.org, pullip.cho@samsung.com
References: <1345702229-9539-1-git-send-email-hdoyu@nvidia.com>
 <1345702229-9539-5-git-send-email-hdoyu@nvidia.com>
In-reply-to: <1345702229-9539-5-git-send-email-hdoyu@nvidia.com>
Subject: RE: [v2 4/4] ARM: dma-mapping: IOMMU allocates pages from atomic_pool
 with GFP_ATOMIC
Date: Thu, 23 Aug 2012 09:33:05 +0200
Organization: SPRC
Message-id: <013c01cd8101$8ccfa020$a66ee060$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2A9h7CzkK+INy8SvaHo8LoKpe3bAACDvgw
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t9jAd1Dd0wDDFY+Y7S4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZv2//YyroV66Y/mMFawPjNKkuRk4OCQETiQsrFrJD2GISF+6t
	Z+ti5OIQEljEKPHi6Rx2CGcWk8TkUy0sIFVsAoYSXW+7gKo4OEQEVCWezmUEqWEWOMUk0fup
	hRWkRkigVOLQvtVgUzkFHCSeP18HZgsLJEjs+HKXEcRmAep98OwD2Bx+ASGJibMUQMK8Ai4S
	92bNZoOwBSV+TL4HtpZZQEti/c7jTBC2vMTmNW+ZQVolBNQlHv3VBQmLCBhJrP7xFKpcROJu
	w3PWCYzCs5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzi8n0nt
	YFzZYHGIUYCDUYmHNyPWNECINbGsuDL3EKMEB7OSCG/4PKAQb0piZVVqUX58UWlOavEhRmkO
	FiVxXv4+wwAhgfTEktTs1NSC1CKYLBMHp1QD4wLHm4fETV4tljr9+sOT4MsuDI0ZJ77uam7W
	+rfxoqpnossB51/3OcIN7ime6a15pC5/b1vmgTnZkg4ebcFP46cohOfO2Cy5Qlbt4Zdep8tP
	ulZ/Ws38f8tuDvnrHOU14QdernOOvCncE5SQ8TTzUKFcg0H7DtauZ1Wt5zaFHn59zv2f4Oea
	AiWW4oxEQy3mouJEAGV9u9JrAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hiroshi,

On Thursday, August 23, 2012 8:10 AM Hiroshi Doyu wrote:

> Makes use of the same atomic pool from DMA, and skips kernel page
> mapping which can involve sleep'able operations at allocating a kernel
> page table.
> 
> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> ---
>  arch/arm/mm/dma-mapping.c |   30 +++++++++++++++++++++++++-----
>  1 files changed, 25 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index 7ab016b..433312a 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -1063,7 +1063,6 @@ static struct page **__iommu_alloc_buffer(struct device *dev, size_t
> size,
>  	struct page **pages;
>  	int count = size >> PAGE_SHIFT;
>  	int array_size = count * sizeof(struct page *);
> -	int err;
> 
>  	if ((array_size <= PAGE_SIZE) || (gfp & GFP_ATOMIC))
>  		pages = kzalloc(array_size, gfp);
> @@ -1072,9 +1071,20 @@ static struct page **__iommu_alloc_buffer(struct device *dev, size_t
> size,
>  	if (!pages)
>  		return NULL;
> 
> -	err = __alloc_fill_pages(&pages, count, gfp);
> -	if (err)
> -		goto error
> +	if (gfp & GFP_ATOMIC) {
> +		struct page *page;
> +		int i;
> +		void *addr = __alloc_from_pool(size, &page);
> +		if (!addr)
> +			goto error;
> +
> +		for (i = 0; i < count; i++)
> +			pages[i] = page + i;
> +	} else {
> +		int err = __alloc_fill_pages(&pages, count, gfp);
> +		if (err)
> +			goto error;
> +	}
> 
>  	return pages;
> 
> @@ -1091,9 +1101,15 @@ static int __iommu_free_buffer(struct device *dev, struct page **pages,
> size_t s
>  	int count = size >> PAGE_SHIFT;
>  	int array_size = count * sizeof(struct page *);
>  	int i;
> +
> +	if (__free_from_pool(page_address(pages[0]), size))
> +		goto out;
> +
>  	for (i = 0; i < count; i++)
>  		if (pages[i])
>  			__free_pages(pages[i], 0);
> +
> +out:
>  	if ((array_size <= PAGE_SIZE) ||
>  	    __in_atomic_pool(page_address(pages[0]), size))
>  		kfree(pages);
> @@ -1221,6 +1237,9 @@ static void *arm_iommu_alloc_attrs(struct device *dev, size_t size,
>  	if (*handle == DMA_ERROR_CODE)
>  		goto err_buffer;
> 
> +	if (gfp & GFP_ATOMIC)
> +		return page_address(pages[0]);
> +
>  	if (dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, attrs))
>  		return pages;
> 

I've read the whole code and it looks that it starts to become a little spaghetti - there are too
many places altered by those atomic changes and it is hard to follow the logic at the first sight.

IMHO it will be better to add a following function:

static void *__iommu_alloc_atomic(struct device *dev, size_t size,
                                  dma_addr_t *handle)
{
        struct page *page, **pages;
        int count = size >> PAGE_SHIFT;
        int array_size = count * sizeof(struct page *);
        void *addr;
        int i;

        pages = kzalloc(array_size, gfp);
        if (!pages)
                return NULL;

        addr = __alloc_from_pool(size, &page);
        if (!addr)
                goto err_pool;

        for (i = 0; i < count; i++)
                pages[i] = page + i;

        *handle = __iommu_create_mapping(dev, pages, size);
        if (*handle == DMA_ERROR_CODE)
                goto err_mapping;

        return addr;

err_mapping:
        __free_from_pool(addr, size);
err_pool:
        kfree(pages);
        return NULL;
}

and then call it at the beginning of the arm_iommu_alloc_attrs():

        if (gfp & GFP_ATOMIC)
                return __iommu_alloc_atomic(dev, size, handle);

You should also add support for the allocation from atomic_pool to __iommu_get_pages() function
to get dma_mmap() and dma_get_sgtable() working correctly.
 
> @@ -1279,7 +1298,8 @@ void arm_iommu_free_attrs(struct device *dev, size_t size, void
> *cpu_addr,
>  		return;
>  	}
> 
> -	if (!dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, attrs)) {
> +	if (!dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, attrs) ||
> +	    !__in_atomic_pool(cpu_addr, size)) {
>  		unmap_kernel_range((unsigned long)cpu_addr, size);
>  		vunmap(cpu_addr);
>  	}

Are you sure this one works?  __iommu_get_pages() won't find pages array, because atomic
allocations don't get their separate vm_struct area, so this check will be never reached. Maybe
a __iommu_free_atomic() function would also make it safer and easier to understand.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


