Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434Ab0HMHHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 03:07:24 -0400
Received: from sh.osrg.net ([192.16.179.4]:58565 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609Ab0HMHHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 03:07:22 -0400
Date: Fri, 13 Aug 2010 16:06:43 +0900
To: miklos@szeredi.hu
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
        jdike@addtoit.com
Subject: Re: [PATCH] uml: fix compile error in dma_get_cache_alignment()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <E1OjTiF-0001KI-Rx@pomaz-ex.szeredi.hu>
References: <E1OjTiF-0001KI-Rx@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100813160536C.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 13 Aug 2010 16:06:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Aug 2010 11:04:35 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Fix uml compile error:
> 
> include/linux/dma-mapping.h:145: error: redefinition of 'dma_get_cache_alignment'
> /store/git/linux-2.6/arch/um/include/asm/dma-mapping.h:99: note: previous definition of 'dma_get_cache_alignment' was here
> 
> Introduced by this commit:
> 
> commit 4565f0170dfc849b3629c27d769db800467baa62
> Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Date:   Tue Aug 10 18:03:22 2010 -0700
> 
>     dma-mapping: unify dma_get_cache_alignment implementations

Very sorry about that.


> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  arch/um/include/asm/dma-mapping.h |    7 -------
>  1 file changed, 7 deletions(-)
> 
> Index: linux-2.6/arch/um/include/asm/dma-mapping.h
> ===================================================================
> --- linux-2.6.orig/arch/um/include/asm/dma-mapping.h	2010-08-12 09:32:16.000000000 +0200
> +++ linux-2.6/arch/um/include/asm/dma-mapping.h	2010-08-12 10:14:12.000000000 +0200
> @@ -95,13 +95,6 @@ dma_sync_sg_for_cpu(struct device *dev,
>  #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
>  #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
>  
> -static inline int
> -dma_get_cache_alignment(void)
> -{
> -	BUG();
> -	return(0);
> -}
> -

this isn't strictly correct for uml, right?  dma_get_cache_alignment()
should fail on uml, I suppose.

Can we treat uml like other !HAS_DMA architectures? That is, why does
uml need the own DMA API that just calls BUG()?

diff --git a/arch/um/Kconfig.um b/arch/um/Kconfig.um
index ec2b8da..3de40b8 100644
--- a/arch/um/Kconfig.um
+++ b/arch/um/Kconfig.um
@@ -147,3 +147,6 @@ config KERNEL_STACK_ORDER
 	  This option determines the size of UML kernel stacks.  They will
 	  be 1 << order pages.  The default is OK unless you're running Valgrind
 	  on UML, in which case, set this to 3.
+
+config HAS_DMA
+       def_bool n
diff --git a/arch/um/defconfig b/arch/um/defconfig
index 6bd456f..564f3de 100644
--- a/arch/um/defconfig
+++ b/arch/um/defconfig
@@ -566,7 +566,6 @@ CONFIG_CRC32=m
 # CONFIG_CRC7 is not set
 # CONFIG_LIBCRC32C is not set
 CONFIG_PLIST=y
-CONFIG_HAS_DMA=y
 
 #
 # SCSI device support
diff --git a/arch/um/include/asm/dma-mapping.h b/arch/um/include/asm/dma-mapping.h
deleted file mode 100644
index 17a2cb5..0000000
--- a/arch/um/include/asm/dma-mapping.h
+++ /dev/null
@@ -1,119 +0,0 @@
-#ifndef _ASM_DMA_MAPPING_H
-#define _ASM_DMA_MAPPING_H
-
-#include <asm/scatterlist.h>
-
-static inline int
-dma_supported(struct device *dev, u64 mask)
-{
-	BUG();
-	return(0);
-}
-
-static inline int
-dma_set_mask(struct device *dev, u64 dma_mask)
-{
-	BUG();
-	return(0);
-}
-
-static inline void *
-dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
-		   gfp_t flag)
-{
-	BUG();
-	return((void *) 0);
-}
-
-static inline void
-dma_free_coherent(struct device *dev, size_t size, void *cpu_addr,
-		  dma_addr_t dma_handle)
-{
-	BUG();
-}
-
-static inline dma_addr_t
-dma_map_single(struct device *dev, void *cpu_addr, size_t size,
-	       enum dma_data_direction direction)
-{
-	BUG();
-	return(0);
-}
-
-static inline void
-dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
-		 enum dma_data_direction direction)
-{
-	BUG();
-}
-
-static inline dma_addr_t
-dma_map_page(struct device *dev, struct page *page,
-	     unsigned long offset, size_t size,
-	     enum dma_data_direction direction)
-{
-	BUG();
-	return(0);
-}
-
-static inline void
-dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
-	       enum dma_data_direction direction)
-{
-	BUG();
-}
-
-static inline int
-dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
-	   enum dma_data_direction direction)
-{
-	BUG();
-	return(0);
-}
-
-static inline void
-dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
-	     enum dma_data_direction direction)
-{
-	BUG();
-}
-
-static inline void
-dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, size_t size,
-		enum dma_data_direction direction)
-{
-	BUG();
-}
-
-static inline void
-dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
-	    enum dma_data_direction direction)
-{
-	BUG();
-}
-
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-
-static inline int
-dma_get_cache_alignment(void)
-{
-	BUG();
-	return(0);
-}
-
-static inline void
-dma_cache_sync(struct device *dev, void *vaddr, size_t size,
-	       enum dma_data_direction direction)
-{
-	BUG();
-}
-
-static inline int
-dma_mapping_error(struct device *dev, dma_addr_t dma_handle)
-{
-	BUG();
-	return 0;
-}
-
-#endif
