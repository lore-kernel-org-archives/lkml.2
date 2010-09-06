Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab0IFK4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 06:56:15 -0400
Received: from sh.osrg.net ([192.16.179.4]:49758 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010Ab0IFK4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 06:56:13 -0400
Date: Mon, 6 Sep 2010 19:55:18 +0900
To: akpm@linux-foundation.org
Cc: sam@ravnborg.org, miklos@szeredi.hu, jdike@addtoit.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] uml: define CONFIG_NO_DMA
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100906195310C.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 06 Sep 2010 19:55:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think that it's better to detect DMA misuse at build time rather
than calling BUG_ON. Architectures that can't do DMA need to define
CONFIG_NO_DMA.

Thanks to Sam Ravnborg for explaining how CONFIG_NO_DMA and
CONFIG_HAS_DMA work:

http://marc.info/?l=linux-kernel&m=128359913825550&w=2

HAS_DMA is defined like this:

config HAS_DMA
        boolean
        depends on !NO_DMA
        default y

So to set HAS_DMA to true an arch should do:
1) Do not define NO_DMA
2) Define NO_DMA abd set it to 'n'

Must archs - including um - used principle 1).

In the um case we want to say that we do NOT have any DMA.
This can be done in two ways.
a) define NO_DMA and set it to 'y'
b) redefine HAS_DMA and set it to 'n'.

The patch you provided used principle b) where other archs use principle a).
So I suggest you should use principle a) for um too.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/um/Kconfig.um                |    3 +
 arch/um/defconfig                 |    1 -
 arch/um/include/asm/dma-mapping.h |  112 -------------------------------------
 3 files changed, 3 insertions(+), 113 deletions(-)
 delete mode 100644 arch/um/include/asm/dma-mapping.h

diff --git a/arch/um/Kconfig.um b/arch/um/Kconfig.um
index ec2b8da..ffe0934 100644
--- a/arch/um/Kconfig.um
+++ b/arch/um/Kconfig.um
@@ -147,3 +147,6 @@ config KERNEL_STACK_ORDER
 	  This option determines the size of UML kernel stacks.  They will
 	  be 1 << order pages.  The default is OK unless you're running Valgrind
 	  on UML, in which case, set this to 3.
+
+config NO_DMA
+	def_bool y
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
index 1f469e8..0000000
--- a/arch/um/include/asm/dma-mapping.h
+++ /dev/null
@@ -1,112 +0,0 @@
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
-- 
1.7.1

