Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759281Ab0GVLpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 07:45:33 -0400
Received: from sh.osrg.net ([192.16.179.4]:56740 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755749Ab0GVLp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 07:45:28 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: JBottomley@novell.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH -mm 2/2] remove dma_is_consistent API
Date: Thu, 22 Jul 2010 20:40:11 +0900
Message-Id: <1279798811-21304-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1279798811-21304-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1279798811-21304-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 22 Jul 2010 20:45:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architectures implement dma_is_consistent() in different ways (some
misinterpret the definition of API in DMA-API.txt). So it hasn't been
so useful for drivers. We have only one user of the API in
tree. Unlikely out-of-tree drivers use the API.

Even if we fix dma_is_consistent() in some architectures, it doesn't
look useful at all. It was invented long ago for some old systems that
can't allocate coherent memory at all. It's better to export only APIs
that are definitely necessary for drivers.

Let's remove this API.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 Documentation/DMA-API.txt                 |    6 ------
 arch/alpha/include/asm/dma-mapping.h      |    1 -
 arch/arm/include/asm/dma-mapping.h        |    5 -----
 arch/avr32/include/asm/dma-mapping.h      |    5 -----
 arch/blackfin/include/asm/dma-mapping.h   |    1 -
 arch/cris/include/asm/dma-mapping.h       |    2 --
 arch/frv/include/asm/dma-mapping.h        |    2 --
 arch/ia64/include/asm/dma-mapping.h       |    2 --
 arch/m68k/include/asm/dma-mapping.h       |    5 -----
 arch/microblaze/include/asm/dma-mapping.h |    1 -
 arch/mips/include/asm/dma-mapping.h       |    2 --
 arch/mips/mm/dma-default.c                |    7 -------
 arch/mn10300/include/asm/dma-mapping.h    |    2 --
 arch/parisc/include/asm/dma-mapping.h     |    6 ------
 arch/powerpc/include/asm/dma-mapping.h    |    5 -----
 arch/sh/include/asm/dma-mapping.h         |    6 ------
 arch/sparc/include/asm/dma-mapping.h      |    1 -
 arch/tile/include/asm/dma-mapping.h       |    2 --
 arch/um/include/asm/dma-mapping.h         |    1 -
 arch/x86/include/asm/dma-mapping.h        |    1 -
 arch/xtensa/include/asm/dma-mapping.h     |    2 --
 include/asm-generic/dma-mapping-broken.h  |    3 ---
 22 files changed, 0 insertions(+), 68 deletions(-)

diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
index 05e2ae2..fe23269 100644
--- a/Documentation/DMA-API.txt
+++ b/Documentation/DMA-API.txt
@@ -456,12 +456,6 @@ be identical to those passed in (and returned by
 dma_alloc_noncoherent()).
 
 int
-dma_is_consistent(struct device *dev, dma_addr_t dma_handle)
-
-Returns true if the device dev is performing consistent DMA on the memory
-area pointed to by the dma_handle.
-
-int
 dma_get_cache_alignment(void)
 
 Returns the processor cache alignment.  This is the absolute minimum
diff --git a/arch/alpha/include/asm/dma-mapping.h b/arch/alpha/include/asm/dma-mapping.h
index b3423d9..4567aca 100644
--- a/arch/alpha/include/asm/dma-mapping.h
+++ b/arch/alpha/include/asm/dma-mapping.h
@@ -41,7 +41,6 @@ static inline int dma_set_mask(struct device *dev, u64 mask)
 
 #define dma_alloc_noncoherent(d, s, h, f)	dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h)	dma_free_coherent(d, s, v, h)
-#define dma_is_consistent(d, h)			(1)
 
 #define dma_cache_sync(dev, va, size, dir)		  ((void)0)
 
diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
index f4a996d..c568da7 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -144,11 +144,6 @@ static inline int dma_set_mask(struct device *dev, u64 dma_mask)
 	return 0;
 }
 
-static inline int dma_is_consistent(struct device *dev, dma_addr_t handle)
-{
-	return !!arch_is_coherent();
-}
-
 /*
  * DMA errors are defined by all-bits-set in the DMA address.
  */
diff --git a/arch/avr32/include/asm/dma-mapping.h b/arch/avr32/include/asm/dma-mapping.h
index af6b816..aaf5199 100644
--- a/arch/avr32/include/asm/dma-mapping.h
+++ b/arch/avr32/include/asm/dma-mapping.h
@@ -336,9 +336,4 @@ dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 
-static inline int dma_is_consistent(struct device *dev, dma_addr_t dma_addr)
-{
-	return 1;
-}
-
 #endif /* __ASM_AVR32_DMA_MAPPING_H */
diff --git a/arch/blackfin/include/asm/dma-mapping.h b/arch/blackfin/include/asm/dma-mapping.h
index 6694a0f..bbf4610 100644
--- a/arch/blackfin/include/asm/dma-mapping.h
+++ b/arch/blackfin/include/asm/dma-mapping.h
@@ -21,7 +21,6 @@ void dma_free_coherent(struct device *dev, size_t size, void *vaddr,
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 #define dma_supported(d, m)         (1)
-#define dma_is_consistent(d, h)     (1)
 
 static inline int
 dma_set_mask(struct device *dev, u64 dma_mask)
diff --git a/arch/cris/include/asm/dma-mapping.h b/arch/cris/include/asm/dma-mapping.h
index fc30fd0..8588b2c 100644
--- a/arch/cris/include/asm/dma-mapping.h
+++ b/arch/cris/include/asm/dma-mapping.h
@@ -152,8 +152,6 @@ dma_set_mask(struct device *dev, u64 mask)
 	return 0;
 }
 
-#define dma_is_consistent(d, h)	(1)
-
 static inline void
 dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 	       enum dma_data_direction direction)
diff --git a/arch/frv/include/asm/dma-mapping.h b/arch/frv/include/asm/dma-mapping.h
index 7b05ce1..dfb8110 100644
--- a/arch/frv/include/asm/dma-mapping.h
+++ b/arch/frv/include/asm/dma-mapping.h
@@ -125,8 +125,6 @@ int dma_set_mask(struct device *dev, u64 mask)
 	return 0;
 }
 
-#define dma_is_consistent(d, h)	(1)
-
 static inline
 void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 		    enum dma_data_direction direction)
diff --git a/arch/ia64/include/asm/dma-mapping.h b/arch/ia64/include/asm/dma-mapping.h
index 8d52dee..a2e7368 100644
--- a/arch/ia64/include/asm/dma-mapping.h
+++ b/arch/ia64/include/asm/dma-mapping.h
@@ -97,6 +97,4 @@ dma_cache_sync (struct device *dev, void *vaddr, size_t size,
 	mb();
 }
 
-#define dma_is_consistent(d, h)	(1)	/* all we do is coherent memory... */
-
 #endif /* _ASM_IA64_DMA_MAPPING_H */
diff --git a/arch/m68k/include/asm/dma-mapping.h b/arch/m68k/include/asm/dma-mapping.h
index a1ae732..17f7a45 100644
--- a/arch/m68k/include/asm/dma-mapping.h
+++ b/arch/m68k/include/asm/dma-mapping.h
@@ -16,11 +16,6 @@ static inline int dma_set_mask(struct device *dev, u64 mask)
 	return 0;
 }
 
-static inline int dma_is_consistent(struct device *dev, dma_addr_t dma_addr)
-{
-	return 0;
-}
-
 extern void *dma_alloc_coherent(struct device *, size_t,
 				dma_addr_t *, gfp_t);
 extern void dma_free_coherent(struct device *, size_t,
diff --git a/arch/microblaze/include/asm/dma-mapping.h b/arch/microblaze/include/asm/dma-mapping.h
index 21df7cb..8fbb0ec 100644
--- a/arch/microblaze/include/asm/dma-mapping.h
+++ b/arch/microblaze/include/asm/dma-mapping.h
@@ -106,7 +106,6 @@ static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-#define dma_is_consistent(d, h)	(1)
 
 static inline void *dma_alloc_coherent(struct device *dev, size_t size,
 					dma_addr_t *dma_handle, gfp_t flag)
diff --git a/arch/mips/include/asm/dma-mapping.h b/arch/mips/include/asm/dma-mapping.h
index d724a15..18fbf7a 100644
--- a/arch/mips/include/asm/dma-mapping.h
+++ b/arch/mips/include/asm/dma-mapping.h
@@ -62,8 +62,6 @@ dma_set_mask(struct device *dev, u64 mask)
 	return 0;
 }
 
-extern int dma_is_consistent(struct device *dev, dma_addr_t dma_addr);
-
 extern void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 	       enum dma_data_direction direction);
 
diff --git a/arch/mips/mm/dma-default.c b/arch/mips/mm/dma-default.c
index 9547bc0..7ba8908 100644
--- a/arch/mips/mm/dma-default.c
+++ b/arch/mips/mm/dma-default.c
@@ -357,13 +357,6 @@ int dma_supported(struct device *dev, u64 mask)
 
 EXPORT_SYMBOL(dma_supported);
 
-int dma_is_consistent(struct device *dev, dma_addr_t dma_addr)
-{
-	return plat_device_is_coherent(dev);
-}
-
-EXPORT_SYMBOL(dma_is_consistent);
-
 void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 	       enum dma_data_direction direction)
 {
diff --git a/arch/mn10300/include/asm/dma-mapping.h b/arch/mn10300/include/asm/dma-mapping.h
index 8d452a6..c1be439 100644
--- a/arch/mn10300/include/asm/dma-mapping.h
+++ b/arch/mn10300/include/asm/dma-mapping.h
@@ -161,8 +161,6 @@ int dma_set_mask(struct device *dev, u64 mask)
 	return 0;
 }
 
-#define dma_is_consistent(d)	(1)
-
 static inline
 void dma_cache_sync(void *vaddr, size_t size,
 		    enum dma_data_direction direction)
diff --git a/arch/parisc/include/asm/dma-mapping.h b/arch/parisc/include/asm/dma-mapping.h
index 44d3f62..4ef73b0 100644
--- a/arch/parisc/include/asm/dma-mapping.h
+++ b/arch/parisc/include/asm/dma-mapping.h
@@ -184,12 +184,6 @@ dma_set_mask(struct device *dev, u64 mask)
 	return 0;
 }
 
-static inline int
-dma_is_consistent(struct device *dev, dma_addr_t dma_addr)
-{
-	return (hppa_dma_ops->dma_sync_single_for_cpu == NULL);
-}
-
 static inline void
 dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 	       enum dma_data_direction direction)
diff --git a/arch/powerpc/include/asm/dma-mapping.h b/arch/powerpc/include/asm/dma-mapping.h
index a77ba28..8c9c6ad 100644
--- a/arch/powerpc/include/asm/dma-mapping.h
+++ b/arch/powerpc/include/asm/dma-mapping.h
@@ -209,11 +209,6 @@ static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t daddr)
 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-#ifdef CONFIG_NOT_COHERENT_CACHE
-#define dma_is_consistent(d, h)	(0)
-#else
-#define dma_is_consistent(d, h)	(1)
-#endif
 
 static inline void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 		enum dma_data_direction direction)
diff --git a/arch/sh/include/asm/dma-mapping.h b/arch/sh/include/asm/dma-mapping.h
index 6bb5cc9..1a73c3e 100644
--- a/arch/sh/include/asm/dma-mapping.h
+++ b/arch/sh/include/asm/dma-mapping.h
@@ -42,12 +42,6 @@ void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 
-#ifdef CONFIG_DMA_COHERENT
-#define dma_is_consistent(d, h) (1)
-#else
-#define dma_is_consistent(d, h) (0)
-#endif
-
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
diff --git a/arch/sparc/include/asm/dma-mapping.h b/arch/sparc/include/asm/dma-mapping.h
index 74db853..8c0e4f7 100644
--- a/arch/sparc/include/asm/dma-mapping.h
+++ b/arch/sparc/include/asm/dma-mapping.h
@@ -11,7 +11,6 @@ extern int dma_supported(struct device *dev, u64 mask);
 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-#define dma_is_consistent(d, h)	(1)
 
 extern struct dma_map_ops *dma_ops, pci32_dma_ops;
 extern struct bus_type pci_bus_type;
diff --git a/arch/tile/include/asm/dma-mapping.h b/arch/tile/include/asm/dma-mapping.h
index 1326b91..15e1dce 100644
--- a/arch/tile/include/asm/dma-mapping.h
+++ b/arch/tile/include/asm/dma-mapping.h
@@ -90,6 +90,4 @@ dma_set_mask(struct device *dev, u64 mask)
 	return 0;
 }
 
-#define dma_is_consistent(d, h)	(1)
-
 #endif /* _ASM_TILE_DMA_MAPPING_H */
diff --git a/arch/um/include/asm/dma-mapping.h b/arch/um/include/asm/dma-mapping.h
index b948c14..17a2cb5 100644
--- a/arch/um/include/asm/dma-mapping.h
+++ b/arch/um/include/asm/dma-mapping.h
@@ -94,7 +94,6 @@ dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-#define dma_is_consistent(d, h) (1)
 
 static inline int
 dma_get_cache_alignment(void)
diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index f9c67e8..d4c419f 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -54,7 +54,6 @@ static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-#define dma_is_consistent(d, h)	(1)
 
 extern int dma_supported(struct device *hwdev, u64 mask);
 extern int dma_set_mask(struct device *dev, u64 mask);
diff --git a/arch/xtensa/include/asm/dma-mapping.h b/arch/xtensa/include/asm/dma-mapping.h
index 7104f2f..492c957 100644
--- a/arch/xtensa/include/asm/dma-mapping.h
+++ b/arch/xtensa/include/asm/dma-mapping.h
@@ -161,8 +161,6 @@ dma_set_mask(struct device *dev, u64 mask)
 	return 0;
 }
 
-#define dma_is_consistent(d, h)	(1)
-
 static inline void
 dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 	       enum dma_data_direction direction)
diff --git a/include/asm-generic/dma-mapping-broken.h b/include/asm-generic/dma-mapping-broken.h
index 82cd0cb..ccf7b4f 100644
--- a/include/asm-generic/dma-mapping-broken.h
+++ b/include/asm-generic/dma-mapping-broken.h
@@ -72,9 +72,6 @@ dma_set_mask(struct device *dev, u64 mask);
 extern int
 dma_get_cache_alignment(void);
 
-extern int
-dma_is_consistent(struct device *dev, dma_addr_t dma_handle);
-
 extern void
 dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 	       enum dma_data_direction direction);
-- 
1.6.5

