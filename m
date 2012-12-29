Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab2L2Ai7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 19:38:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755105Ab2L2Ai4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 19:38:56 -0500
Date: Fri, 28 Dec 2012 22:09:42 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-arch@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-m68k@vger.kernel.org
Subject: Re: [PATCH/RFC 4/4] common: dma-mapping: Move dma_common_*() to
 <linux/dma-mapping.h>
Message-ID: <20121228220942.5e6a5361@redhat.com>
In-Reply-To: <1356722614-18224-5-git-send-email-geert@linux-m68k.org>
References: <CAMuHMdVPBUzN8fsNHFzrEqev9BsvVCVR2fWySCOecjVA-J1qjg@mail.gmail.com>
	<1356722614-18224-5-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, 28 Dec 2012 20:23:34 +0100
Geert Uytterhoeven <geert@linux-m68k.org> escreveu:

> dma_common_mmap() and dma_common_get_sgtable() are defined in
> drivers/base/dma-mapping.c, and always compiled if CONFIG_HAS_DMA=y.
> 
> However, their forward declarations and the inline functions defined on top
> of them (dma_mmap_attrs(), dma_mmap_coherent(), dma_mmap_writecombine(),
> dma_get_sgtable_attrs()), dma_get_sgtable()) are in
> <asm-generic/dma-mapping-common.h>, which is not included by all
> architectures supporting CONFIG_HAS_DMA=y.  There exist no alternative
> implementations.
> 
> Hence for e.g. m68k allmodconfig, I get:
> 
> drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_mmap’:
> drivers/media/v4l2-core/videobuf2-dma-contig.c:204: error: implicit declaration of function ‘dma_mmap_coherent’
> drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_get_base_sgt’:
> drivers/media/v4l2-core/videobuf2-dma-contig.c:387: error: implicit declaration of function ‘dma_get_sgtable’
> 
> To fix this
>   - Move the forward declarations and inline definitions to
>     <linux/dma-mapping.h>, so all CONFIG_HAS_DMA=y architectures can use
>     them,
>   - Replace the hard "BUG_ON(!ops)" checks for dma_map_ops by soft checks,
>     so architectures can fall back to the common code by returning NULL
>     from their get_dma_ops(). Note that there are no "BUG_ON(!ops)" checks
>     in other functions in <asm-generic/dma-mapping-common.h>,
>   - Make "struct dma_map_ops *ops" const while we're at it.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

>From my side:

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

> ---
>  include/asm-generic/dma-mapping-common.h |   55 ------------------------------
>  include/linux/dma-mapping.h              |   54 +++++++++++++++++++++++++++++
>  2 files changed, 54 insertions(+), 55 deletions(-)
> 
> diff --git a/include/asm-generic/dma-mapping-common.h b/include/asm-generic/dma-mapping-common.h
> index de8bf89..2e248d8 100644
> --- a/include/asm-generic/dma-mapping-common.h
> +++ b/include/asm-generic/dma-mapping-common.h
> @@ -176,59 +176,4 @@ dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
>  #define dma_map_sg(d, s, n, r) dma_map_sg_attrs(d, s, n, r, NULL)
>  #define dma_unmap_sg(d, s, n, r) dma_unmap_sg_attrs(d, s, n, r, NULL)
>  
> -extern int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
> -			   void *cpu_addr, dma_addr_t dma_addr, size_t size);
> -
> -/**
> - * dma_mmap_attrs - map a coherent DMA allocation into user space
> - * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
> - * @vma: vm_area_struct describing requested user mapping
> - * @cpu_addr: kernel CPU-view address returned from dma_alloc_attrs
> - * @handle: device-view address returned from dma_alloc_attrs
> - * @size: size of memory originally requested in dma_alloc_attrs
> - * @attrs: attributes of mapping properties requested in dma_alloc_attrs
> - *
> - * Map a coherent DMA buffer previously allocated by dma_alloc_attrs
> - * into user space.  The coherent DMA buffer must not be freed by the
> - * driver until the user space mapping has been released.
> - */
> -static inline int
> -dma_mmap_attrs(struct device *dev, struct vm_area_struct *vma, void *cpu_addr,
> -	       dma_addr_t dma_addr, size_t size, struct dma_attrs *attrs)
> -{
> -	struct dma_map_ops *ops = get_dma_ops(dev);
> -	BUG_ON(!ops);
> -	if (ops->mmap)
> -		return ops->mmap(dev, vma, cpu_addr, dma_addr, size, attrs);
> -	return dma_common_mmap(dev, vma, cpu_addr, dma_addr, size);
> -}
> -
> -#define dma_mmap_coherent(d, v, c, h, s) dma_mmap_attrs(d, v, c, h, s, NULL)
> -
> -static inline int dma_mmap_writecombine(struct device *dev, struct vm_area_struct *vma,
> -		      void *cpu_addr, dma_addr_t dma_addr, size_t size)
> -{
> -	DEFINE_DMA_ATTRS(attrs);
> -	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
> -	return dma_mmap_attrs(dev, vma, cpu_addr, dma_addr, size, &attrs);
> -}
> -
> -int
> -dma_common_get_sgtable(struct device *dev, struct sg_table *sgt,
> -		       void *cpu_addr, dma_addr_t dma_addr, size_t size);
> -
> -static inline int
> -dma_get_sgtable_attrs(struct device *dev, struct sg_table *sgt, void *cpu_addr,
> -		      dma_addr_t dma_addr, size_t size, struct dma_attrs *attrs)
> -{
> -	struct dma_map_ops *ops = get_dma_ops(dev);
> -	BUG_ON(!ops);
> -	if (ops->get_sgtable)
> -		return ops->get_sgtable(dev, sgt, cpu_addr, dma_addr, size,
> -					attrs);
> -	return dma_common_get_sgtable(dev, sgt, cpu_addr, dma_addr, size);
> -}
> -
> -#define dma_get_sgtable(d, t, v, h, s) dma_get_sgtable_attrs(d, t, v, h, s, NULL)
> -
>  #endif
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index 94af418..4b47150 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -74,6 +74,60 @@ static inline int is_device_dma_capable(struct device *dev)
>  
>  #ifdef CONFIG_HAS_DMA
>  #include <asm/dma-mapping.h>
> +
> +extern int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
> +			   void *cpu_addr, dma_addr_t dma_addr, size_t size);
> +
> +/**
> + * dma_mmap_attrs - map a coherent DMA allocation into user space
> + * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
> + * @vma: vm_area_struct describing requested user mapping
> + * @cpu_addr: kernel CPU-view address returned from dma_alloc_attrs
> + * @handle: device-view address returned from dma_alloc_attrs
> + * @size: size of memory originally requested in dma_alloc_attrs
> + * @attrs: attributes of mapping properties requested in dma_alloc_attrs
> + *
> + * Map a coherent DMA buffer previously allocated by dma_alloc_attrs
> + * into user space.  The coherent DMA buffer must not be freed by the
> + * driver until the user space mapping has been released.
> + */
> +static inline int
> +dma_mmap_attrs(struct device *dev, struct vm_area_struct *vma, void *cpu_addr,
> +	       dma_addr_t dma_addr, size_t size, struct dma_attrs *attrs)
> +{
> +	const struct dma_map_ops *ops = get_dma_ops(dev);
> +	if (ops && ops->mmap)
> +		return ops->mmap(dev, vma, cpu_addr, dma_addr, size, attrs);
> +	return dma_common_mmap(dev, vma, cpu_addr, dma_addr, size);
> +}
> +
> +#define dma_mmap_coherent(d, v, c, h, s) dma_mmap_attrs(d, v, c, h, s, NULL)
> +
> +static inline int dma_mmap_writecombine(struct device *dev, struct vm_area_struct *vma,
> +		      void *cpu_addr, dma_addr_t dma_addr, size_t size)
> +{
> +	DEFINE_DMA_ATTRS(attrs);
> +	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
> +	return dma_mmap_attrs(dev, vma, cpu_addr, dma_addr, size, &attrs);
> +}
> +
> +int
> +dma_common_get_sgtable(struct device *dev, struct sg_table *sgt,
> +		       void *cpu_addr, dma_addr_t dma_addr, size_t size);
> +
> +static inline int
> +dma_get_sgtable_attrs(struct device *dev, struct sg_table *sgt, void *cpu_addr,
> +		      dma_addr_t dma_addr, size_t size, struct dma_attrs *attrs)
> +{
> +	const struct dma_map_ops *ops = get_dma_ops(dev);
> +	if (ops && ops->get_sgtable)
> +		return ops->get_sgtable(dev, sgt, cpu_addr, dma_addr, size,
> +					attrs);
> +	return dma_common_get_sgtable(dev, sgt, cpu_addr, dma_addr, size);
> +}
> +
> +#define dma_get_sgtable(d, t, v, h, s) dma_get_sgtable_attrs(d, t, v, h, s, NULL)
> +
>  #else
>  #include <asm-generic/dma-mapping-broken.h>
>  #endif


-- 

Cheers,
Mauro
