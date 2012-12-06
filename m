Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964951Ab2LFH6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 02:58:30 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:45388 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab2LFH61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 02:58:27 -0500
X-AuditID: cbfec7f5-b7fd76d000007247-14-50c05021157f
Message-id: <50C05017.8080809@samsung.com>
Date: Thu, 06 Dec 2012 08:58:15 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Vitaly Andrianov <vitalya@ti.com>
Cc: mina86@mina86.com, kyungmin.park@samsung.com, arnd@arndb.de,
        linux-kernel@vger.kernel.org, linux-keystone@list.ti.com,
        Cyril Chemparathy <cyril@ti.com>
Subject: Re: [PATCH v3] drivers: cma: represent physical addresses as
 phys_addr_t
References: <1354717766-8071-1-git-send-email-vitalya@ti.com>
In-reply-to: <1354717766-8071-1-git-send-email-vitalya@ti.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupiluLIzCtJLcpLzFFi42I5/e/4FV3FgAMBBp+bBCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGufUf2Qq+aFVcf/WepYFxkVIXIweHhICJxOe5kV2MnECmmMSF
	e+vZuhi5OIQEljJK/Dj7lhHCWcIkcXPrK2aQKl4BLYnF12+wgNgsAqoSp569ALPZBAwlut52
	sYHYogK+EtN+XWOCqBeU+DH5HgvIMhGg+tu3akHCzALzGSX+bVIHsYUFgiVOTb3GDmILCdhK
	LL1+BszmFLCTWL/3FzNEvZnEo5Z1ULa8xOY1b5knMArMQrJhFpKyWUjKFjAyr2IUTS1NLihO
	Ss810itOzC0uzUvXS87P3cQICb+vOxiXHrM6xCjAwajEw/ugYn+AEGtiWXFl7iFGCQ5mJRHe
	c5+BQrwpiZVVqUX58UWlOanFhxiZODilGhj3SJ6fmnbz4tsNttwHnab/Y1Ytt1aUbNwkPsny
	X/jilRVipRpXzrh9+rz3jqnq8UdtHosD+s2VrS14u9i25FxrjLV7ovzKWHnDtN1WTXdbnvex
	uarermV+fJ9Z2n1R79m3wgrKGvNS7v/0/qb38GZT6xoPX3mzpT5x3AGl9zzq8pRm3LHwNVdi
	Kc5INNRiLipOBAC0Trj9HQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/5/2012 3:29 PM, Vitaly Andrianov wrote:
> This commit changes the CMA early initialization code to use phys_addr_t
> for representing physical addresses instead of unsigned long.
>
> Without this change, among other things, dma_declare_contiguous() simply
> discards any memory regions whose address is not representable as unsigned
> long.
>
> This is a problem on 32-bit PAE machines where unsigned long is 32-bit
> but physical address space is larger.
>
> Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
> Signed-off-by: Cyril Chemparathy <cyril@ti.com>

Applied to my dma-maping-next branch, thanks for your work!

> ---
>   drivers/base/dma-contiguous.c  |   24 ++++++++++--------------
>   include/linux/dma-contiguous.h |    4 ++--
>   2 files changed, 12 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
> index 9a14694..9b841e2 100644
> --- a/drivers/base/dma-contiguous.c
> +++ b/drivers/base/dma-contiguous.c
> @@ -60,8 +60,8 @@ struct cma *dma_contiguous_default_area;
>    * Users, who want to set the size of global CMA area for their system
>    * should use cma= kernel parameter.
>    */
> -static const unsigned long size_bytes = CMA_SIZE_MBYTES * SZ_1M;
> -static long size_cmdline = -1;
> +static const phys_addr_t size_bytes = CMA_SIZE_MBYTES * SZ_1M;
> +static phys_addr_t size_cmdline = -1;
>   
>   static int __init early_cma(char *p)
>   {
> @@ -73,7 +73,7 @@ early_param("cma", early_cma);
>   
>   #ifdef CONFIG_CMA_SIZE_PERCENTAGE
>   
> -static unsigned long __init __maybe_unused cma_early_percent_memory(void)
> +static phys_addr_t __init __maybe_unused cma_early_percent_memory(void)
>   {
>   	struct memblock_region *reg;
>   	unsigned long total_pages = 0;
> @@ -91,7 +91,7 @@ static unsigned long __init __maybe_unused cma_early_percent_memory(void)
>   
>   #else
>   
> -static inline __maybe_unused unsigned long cma_early_percent_memory(void)
> +static inline __maybe_unused phys_addr_t cma_early_percent_memory(void)
>   {
>   	return 0;
>   }
> @@ -109,7 +109,7 @@ static inline __maybe_unused unsigned long cma_early_percent_memory(void)
>    */
>   void __init dma_contiguous_reserve(phys_addr_t limit)
>   {
> -	unsigned long selected_size = 0;
> +	phys_addr_t selected_size = 0;
>   
>   	pr_debug("%s(limit %08lx)\n", __func__, (unsigned long)limit);
>   
> @@ -129,7 +129,7 @@ void __init dma_contiguous_reserve(phys_addr_t limit)
>   
>   	if (selected_size) {
>   		pr_debug("%s: reserving %ld MiB for global area\n", __func__,
> -			 selected_size / SZ_1M);
> +			 (unsigned long)selected_size / SZ_1M);
>   
>   		dma_declare_contiguous(NULL, selected_size, 0, limit);
>   	}
> @@ -230,11 +230,11 @@ core_initcall(cma_init_reserved_areas);
>    * called by board specific code when early allocator (memblock or bootmem)
>    * is still activate.
>    */
> -int __init dma_declare_contiguous(struct device *dev, unsigned long size,
> +int __init dma_declare_contiguous(struct device *dev, phys_addr_t size,
>   				  phys_addr_t base, phys_addr_t limit)
>   {
>   	struct cma_reserved *r = &cma_reserved[cma_reserved_count];
> -	unsigned long alignment;
> +	phys_addr_t alignment;
>   
>   	pr_debug("%s(size %lx, base %08lx, limit %08lx)\n", __func__,
>   		 (unsigned long)size, (unsigned long)base,
> @@ -271,10 +271,6 @@ int __init dma_declare_contiguous(struct device *dev, unsigned long size,
>   		if (!addr) {
>   			base = -ENOMEM;
>   			goto err;
> -		} else if (addr + size > ~(unsigned long)0) {
> -			memblock_free(addr, size);
> -			base = -EINVAL;
> -			goto err;
>   		} else {
>   			base = addr;
>   		}
> @@ -288,14 +284,14 @@ int __init dma_declare_contiguous(struct device *dev, unsigned long size,
>   	r->size = size;
>   	r->dev = dev;
>   	cma_reserved_count++;
> -	pr_info("CMA: reserved %ld MiB at %08lx\n", size / SZ_1M,
> +	pr_info("CMA: reserved %ld MiB at %08lx\n", (unsigned long)size / SZ_1M,
>   		(unsigned long)base);
>   
>   	/* Architecture specific contiguous memory fixup. */
>   	dma_contiguous_early_fixup(base, size);
>   	return 0;
>   err:
> -	pr_err("CMA: failed to reserve %ld MiB\n", size / SZ_1M);
> +	pr_err("CMA: failed to reserve %ld MiB\n", (unsigned long)size / SZ_1M);
>   	return base;
>   }
>   
> diff --git a/include/linux/dma-contiguous.h b/include/linux/dma-contiguous.h
> index 2f303e4..01b5c84 100644
> --- a/include/linux/dma-contiguous.h
> +++ b/include/linux/dma-contiguous.h
> @@ -68,7 +68,7 @@ struct device;
>   extern struct cma *dma_contiguous_default_area;
>   
>   void dma_contiguous_reserve(phys_addr_t addr_limit);
> -int dma_declare_contiguous(struct device *dev, unsigned long size,
> +int dma_declare_contiguous(struct device *dev, phys_addr_t size,
>   			   phys_addr_t base, phys_addr_t limit);
>   
>   struct page *dma_alloc_from_contiguous(struct device *dev, int count,
> @@ -83,7 +83,7 @@ bool dma_release_from_contiguous(struct device *dev, struct page *pages,
>   static inline void dma_contiguous_reserve(phys_addr_t limit) { }
>   
>   static inline
> -int dma_declare_contiguous(struct device *dev, unsigned long size,
> +int dma_declare_contiguous(struct device *dev, phys_addr_t size,
>   			   phys_addr_t base, phys_addr_t limit)
>   {
>   	return -ENOSYS;

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


