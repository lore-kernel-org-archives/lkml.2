Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab0GHHAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 03:00:07 -0400
Received: from sh.osrg.net ([192.16.179.4]:43055 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980Ab0GHHAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 03:00:04 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       linux-arch@vger.kernel.org
Subject: [PATCH -mm 2/3] unify dma_get_cache_alignment implementations
Date: Thu,  8 Jul 2010 15:57:47 +0900
Message-Id: <1278572268-26146-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1278572268-26146-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1278572268-26146-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 08 Jul 2010 15:59:56 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_get_cache_alignment returns the minimum DMA
alignment. Architectures defines it as ARCH_DMA_MINALIGN (formally
ARCH_KMALLOC_MINALIGN). So we can unify dma_get_cache_alignment
implementations.

Note that some architectures implement dma_get_cache_alignment
wrongly. dma_get_cache_alignment() should return the minimum DMA
alignment. So fully-coherent architectures should return 1. This patch
also fixes this issue.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/alpha/include/asm/dma-mapping.h      |    1 -
 arch/arm/include/asm/dma-mapping.h        |    5 -----
 arch/avr32/include/asm/dma-mapping.h      |    5 -----
 arch/blackfin/include/asm/dma-mapping.h   |    1 -
 arch/cris/include/asm/dma-mapping.h       |    6 ------
 arch/frv/include/asm/dma-mapping.h        |    6 ------
 arch/ia64/include/asm/dma-mapping.h       |    2 --
 arch/ia64/kernel/setup.c                  |    6 ------
 arch/m68k/include/asm/dma-mapping.h       |    5 -----
 arch/microblaze/include/asm/dma-mapping.h |    5 -----
 arch/mips/include/asm/dma-mapping.h       |    7 -------
 arch/mn10300/include/asm/dma-mapping.h    |    6 ------
 arch/parisc/include/asm/dma-mapping.h     |    6 ------
 arch/powerpc/include/asm/dma-mapping.h    |   15 ---------------
 arch/sh/include/asm/dma-mapping.h         |    9 ---------
 arch/sparc/include/asm/dma-mapping.h      |    9 ---------
 arch/tile/include/asm/dma-mapping.h       |    7 -------
 arch/x86/include/asm/dma-mapping.h        |    7 -------
 arch/xtensa/include/asm/dma-mapping.h     |    6 ------
 include/linux/dma-mapping.h               |    8 ++++++++
 20 files changed, 8 insertions(+), 114 deletions(-)

diff --git a/arch/alpha/include/asm/dma-mapping.h b/arch/alpha/include/asm/dma-mapping.h
index 1bce816..b3423d9 100644
--- a/arch/alpha/include/asm/dma-mapping.h
+++ b/arch/alpha/include/asm/dma-mapping.h
@@ -44,6 +44,5 @@ static inline int dma_set_mask(struct device *dev, u64 mask)
 #define dma_is_consistent(d, h)			(1)
 
 #define dma_cache_sync(dev, va, size, dir)		  ((void)0)
-#define dma_get_cache_alignment()			  L1_CACHE_BYTES
 
 #endif	/* _ALPHA_DMA_MAPPING_H */
diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
index 69ce072..f4a996d 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -144,11 +144,6 @@ static inline int dma_set_mask(struct device *dev, u64 dma_mask)
 	return 0;
 }
 
-static inline int dma_get_cache_alignment(void)
-{
-	return 32;
-}
-
 static inline int dma_is_consistent(struct device *dev, dma_addr_t handle)
 {
 	return !!arch_is_coherent();
diff --git a/arch/avr32/include/asm/dma-mapping.h b/arch/avr32/include/asm/dma-mapping.h
index 0399359..af6b816 100644
--- a/arch/avr32/include/asm/dma-mapping.h
+++ b/arch/avr32/include/asm/dma-mapping.h
@@ -341,9 +341,4 @@ static inline int dma_is_consistent(struct device *dev, dma_addr_t dma_addr)
 	return 1;
 }
 
-static inline int dma_get_cache_alignment(void)
-{
-	return boot_cpu_data.dcache.linesz;
-}
-
 #endif /* __ASM_AVR32_DMA_MAPPING_H */
diff --git a/arch/blackfin/include/asm/dma-mapping.h b/arch/blackfin/include/asm/dma-mapping.h
index 212cb80..6694a0f 100644
--- a/arch/blackfin/include/asm/dma-mapping.h
+++ b/arch/blackfin/include/asm/dma-mapping.h
@@ -21,7 +21,6 @@ void dma_free_coherent(struct device *dev, size_t size, void *vaddr,
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 #define dma_supported(d, m)         (1)
-#define dma_get_cache_alignment()   (32)
 #define dma_is_consistent(d, h)     (1)
 
 static inline int
diff --git a/arch/cris/include/asm/dma-mapping.h b/arch/cris/include/asm/dma-mapping.h
index da8ef8e..fc30fd0 100644
--- a/arch/cris/include/asm/dma-mapping.h
+++ b/arch/cris/include/asm/dma-mapping.h
@@ -152,12 +152,6 @@ dma_set_mask(struct device *dev, u64 mask)
 	return 0;
 }
 
-static inline int
-dma_get_cache_alignment(void)
-{
-	return (1 << INTERNODE_CACHE_SHIFT);
-}
-
 #define dma_is_consistent(d, h)	(1)
 
 static inline void
diff --git a/arch/frv/include/asm/dma-mapping.h b/arch/frv/include/asm/dma-mapping.h
index 6af5d83..7b05ce1 100644
--- a/arch/frv/include/asm/dma-mapping.h
+++ b/arch/frv/include/asm/dma-mapping.h
@@ -125,12 +125,6 @@ int dma_set_mask(struct device *dev, u64 mask)
 	return 0;
 }
 
-static inline
-int dma_get_cache_alignment(void)
-{
-	return 1 << L1_CACHE_SHIFT;
-}
-
 #define dma_is_consistent(d, h)	(1)
 
 static inline
diff --git a/arch/ia64/include/asm/dma-mapping.h b/arch/ia64/include/asm/dma-mapping.h
index 7d09a09..8d52dee 100644
--- a/arch/ia64/include/asm/dma-mapping.h
+++ b/arch/ia64/include/asm/dma-mapping.h
@@ -86,8 +86,6 @@ static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t daddr)
 	return daddr;
 }
 
-extern int dma_get_cache_alignment(void);
-
 static inline void
 dma_cache_sync (struct device *dev, void *vaddr, size_t size,
 	enum dma_data_direction dir)
diff --git a/arch/ia64/kernel/setup.c b/arch/ia64/kernel/setup.c
index 41ae6a5..8fb958a 100644
--- a/arch/ia64/kernel/setup.c
+++ b/arch/ia64/kernel/setup.c
@@ -98,12 +98,6 @@ static struct resource bss_resource = {
 
 unsigned long ia64_max_cacheline_size;
 
-int dma_get_cache_alignment(void)
-{
-        return ia64_max_cacheline_size;
-}
-EXPORT_SYMBOL(dma_get_cache_alignment);
-
 unsigned long ia64_iobase;	/* virtual address for I/O accesses */
 EXPORT_SYMBOL(ia64_iobase);
 struct io_space io_space[MAX_IO_SPACES];
diff --git a/arch/m68k/include/asm/dma-mapping.h b/arch/m68k/include/asm/dma-mapping.h
index 26f5054..a1ae732 100644
--- a/arch/m68k/include/asm/dma-mapping.h
+++ b/arch/m68k/include/asm/dma-mapping.h
@@ -16,11 +16,6 @@ static inline int dma_set_mask(struct device *dev, u64 mask)
 	return 0;
 }
 
-static inline int dma_get_cache_alignment(void)
-{
-	return 1 << L1_CACHE_SHIFT;
-}
-
 static inline int dma_is_consistent(struct device *dev, dma_addr_t dma_addr)
 {
 	return 0;
diff --git a/arch/microblaze/include/asm/dma-mapping.h b/arch/microblaze/include/asm/dma-mapping.h
index 18b3731..e9f7c81 100644
--- a/arch/microblaze/include/asm/dma-mapping.h
+++ b/arch/microblaze/include/asm/dma-mapping.h
@@ -138,11 +138,6 @@ static inline void dma_free_coherent(struct device *dev, size_t size,
 	ops->free_coherent(dev, size, cpu_addr, dma_handle);
 }
 
-static inline int dma_get_cache_alignment(void)
-{
-	return L1_CACHE_BYTES;
-}
-
 static inline void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 		enum dma_data_direction direction)
 {
diff --git a/arch/mips/include/asm/dma-mapping.h b/arch/mips/include/asm/dma-mapping.h
index 664ba53..d724a15 100644
--- a/arch/mips/include/asm/dma-mapping.h
+++ b/arch/mips/include/asm/dma-mapping.h
@@ -62,13 +62,6 @@ dma_set_mask(struct device *dev, u64 mask)
 	return 0;
 }
 
-static inline int
-dma_get_cache_alignment(void)
-{
-	/* XXX Largest on any MIPS */
-	return 128;
-}
-
 extern int dma_is_consistent(struct device *dev, dma_addr_t dma_addr);
 
 extern void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
diff --git a/arch/mn10300/include/asm/dma-mapping.h b/arch/mn10300/include/asm/dma-mapping.h
index 4ed1522..8d452a6 100644
--- a/arch/mn10300/include/asm/dma-mapping.h
+++ b/arch/mn10300/include/asm/dma-mapping.h
@@ -161,12 +161,6 @@ int dma_set_mask(struct device *dev, u64 mask)
 	return 0;
 }
 
-static inline
-int dma_get_cache_alignment(void)
-{
-	return 1 << L1_CACHE_SHIFT;
-}
-
 #define dma_is_consistent(d)	(1)
 
 static inline
diff --git a/arch/parisc/include/asm/dma-mapping.h b/arch/parisc/include/asm/dma-mapping.h
index da69433..44d3f62 100644
--- a/arch/parisc/include/asm/dma-mapping.h
+++ b/arch/parisc/include/asm/dma-mapping.h
@@ -185,12 +185,6 @@ dma_set_mask(struct device *dev, u64 mask)
 }
 
 static inline int
-dma_get_cache_alignment(void)
-{
-	return dcache_stride;
-}
-
-static inline int
 dma_is_consistent(struct device *dev, dma_addr_t dma_addr)
 {
 	return (hppa_dma_ops->dma_sync_single_for_cpu == NULL);
diff --git a/arch/powerpc/include/asm/dma-mapping.h b/arch/powerpc/include/asm/dma-mapping.h
index c85ef23..a77ba28 100644
--- a/arch/powerpc/include/asm/dma-mapping.h
+++ b/arch/powerpc/include/asm/dma-mapping.h
@@ -215,21 +215,6 @@ static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t daddr)
 #define dma_is_consistent(d, h)	(1)
 #endif
 
-static inline int dma_get_cache_alignment(void)
-{
-#ifdef CONFIG_PPC64
-	/* no easy way to get cache size on all processors, so return
-	 * the maximum possible, to be safe */
-	return (1 << INTERNODE_CACHE_SHIFT);
-#else
-	/*
-	 * Each processor family will define its own L1_CACHE_SHIFT,
-	 * L1_CACHE_BYTES wraps to this, so this is always safe.
-	 */
-	return L1_CACHE_BYTES;
-#endif
-}
-
 static inline void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 		enum dma_data_direction direction)
 {
diff --git a/arch/sh/include/asm/dma-mapping.h b/arch/sh/include/asm/dma-mapping.h
index bea3337..6bb5cc9 100644
--- a/arch/sh/include/asm/dma-mapping.h
+++ b/arch/sh/include/asm/dma-mapping.h
@@ -48,15 +48,6 @@ void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 #define dma_is_consistent(d, h) (0)
 #endif
 
-static inline int dma_get_cache_alignment(void)
-{
-	/*
-	 * Each processor family will define its own L1_CACHE_SHIFT,
-	 * L1_CACHE_BYTES wraps to this, so this is always safe.
-	 */
-	return L1_CACHE_BYTES;
-}
-
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
diff --git a/arch/sparc/include/asm/dma-mapping.h b/arch/sparc/include/asm/dma-mapping.h
index 4b4a0c0..74db853 100644
--- a/arch/sparc/include/asm/dma-mapping.h
+++ b/arch/sparc/include/asm/dma-mapping.h
@@ -52,15 +52,6 @@ static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 	return (dma_addr == DMA_ERROR_CODE);
 }
 
-static inline int dma_get_cache_alignment(void)
-{
-	/*
-	 * no easy way to get cache size on all processors, so return
-	 * the maximum possible, to be safe
-	 */
-	return (1 << INTERNODE_CACHE_SHIFT);
-}
-
 static inline int dma_set_mask(struct device *dev, u64 mask)
 {
 #ifdef CONFIG_PCI
diff --git a/arch/tile/include/asm/dma-mapping.h b/arch/tile/include/asm/dma-mapping.h
index cf466b3..1326b91 100644
--- a/arch/tile/include/asm/dma-mapping.h
+++ b/arch/tile/include/asm/dma-mapping.h
@@ -90,13 +90,6 @@ dma_set_mask(struct device *dev, u64 mask)
 	return 0;
 }
 
-static inline int
-dma_get_cache_alignment(void)
-{
-	return L2_CACHE_BYTES;
-}
-
 #define dma_is_consistent(d, h)	(1)
 
-
 #endif /* _ASM_TILE_DMA_MAPPING_H */
diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index ac91eed..f9c67e8 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -87,13 +87,6 @@ dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 	flush_write_buffers();
 }
 
-static inline int dma_get_cache_alignment(void)
-{
-	/* no easy way to get cache size on all x86, so return the
-	 * maximum possible, to be safe */
-	return boot_cpu_data.x86_clflush_size;
-}
-
 static inline unsigned long dma_alloc_coherent_mask(struct device *dev,
 						    gfp_t gfp)
 {
diff --git a/arch/xtensa/include/asm/dma-mapping.h b/arch/xtensa/include/asm/dma-mapping.h
index 51882ae..7104f2f 100644
--- a/arch/xtensa/include/asm/dma-mapping.h
+++ b/arch/xtensa/include/asm/dma-mapping.h
@@ -161,12 +161,6 @@ dma_set_mask(struct device *dev, u64 mask)
 	return 0;
 }
 
-static inline int
-dma_get_cache_alignment(void)
-{
-	return L1_CACHE_BYTES;
-}
-
 #define dma_is_consistent(d, h)	(1)
 
 static inline void
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 89b7e1a..e0670a5 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -142,6 +142,14 @@ static inline int dma_set_seg_boundary(struct device *dev, unsigned long mask)
 		return -EIO;
 }
 
+static inline int dma_get_cache_alignment(void)
+{
+#ifdef ARCH_DMA_MINALIGN
+	return ARCH_DMA_MINALIGN;
+#endif
+	return 1;
+}
+
 /* flags for the coherent memory api */
 #define	DMA_MEMORY_MAP			0x01
 #define DMA_MEMORY_IO			0x02
-- 
1.6.5

