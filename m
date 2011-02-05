Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab1BERDW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 12:03:22 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43642 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab1BERDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 12:03:21 -0500
Date: Sat, 5 Feb 2011 17:02:55 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Per Forlin <per.forlin@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@lists.linaro.org,
        Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH 0/5] mmc: add double buffering for mmc block requests
Message-ID: <20110205170255.GG29411@n2100.arm.linux.org.uk>
References: <1294856043-13447-1-git-send-email-per.forlin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294856043-13447-1-git-send-email-per.forlin@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 07:13:58PM +0100, Per Forlin wrote:
> Add support to prepare one MMC request while another is active on
> the host. This is done by making the issue_rw_rq() asynchronous.
> The increase in throughput is proportional to the time it takes to
> prepare a request and how fast the memory is. The faster the MMC/SD is
> the more significant the prepare request time becomes. Measurements on U5500
> and U8500 on eMMC shows significant performance gain for DMA on MMC for large
> reads. In the PIO case there is some gain in performance for large reads too.
> There seems to be no or small performance gain for write, don't have a good
> explanation for this yet.

It might be worth seeing what effect the following patch has.  This
moves the dsb out of the cache operations into a separate function,
so we only do one dsb per DMA mapping/unmapping operation.  That's
particularly significant for the scattergather code.

I don't remember the reason why this was dropped as a candidate for
merging - could that be because the dsb needs to be before the outer
cache maintainence?  Adding Catalin for comment on that.

 arch/arm/include/asm/cacheflush.h  |    4 ++++
 arch/arm/include/asm/dma-mapping.h |    8 ++++++++
 arch/arm/mm/cache-fa.S             |   13 +++++++------
 arch/arm/mm/cache-v3.S             |    3 +++
 arch/arm/mm/cache-v4.S             |    3 +++
 arch/arm/mm/cache-v4wb.S           |    9 +++++++--
 arch/arm/mm/cache-v4wt.S           |    3 +++
 arch/arm/mm/cache-v6.S             |   13 +++++++------
 arch/arm/mm/cache-v7.S             |    9 ++++++---
 arch/arm/mm/dma-mapping.c          |   12 ++++++++++++
 arch/arm/mm/proc-arm1020e.S        |   10 +++++++---
 arch/arm/mm/proc-arm1022.S         |   10 +++++++---
 arch/arm/mm/proc-arm1026.S         |   10 +++++++---
 arch/arm/mm/proc-arm920.S          |   10 +++++++---
 arch/arm/mm/proc-arm922.S          |   10 +++++++---
 arch/arm/mm/proc-arm925.S          |   10 +++++++---
 arch/arm/mm/proc-arm926.S          |   10 +++++++---
 arch/arm/mm/proc-arm940.S          |   10 +++++++---
 arch/arm/mm/proc-arm946.S          |   10 +++++++---
 arch/arm/mm/proc-feroceon.S        |   13 ++++++++-----
 arch/arm/mm/proc-mohawk.S          |   10 +++++++---
 arch/arm/mm/proc-xsc3.S            |   10 +++++++---
 arch/arm/mm/proc-xscale.S          |   10 +++++++---
 23 files changed, 152 insertions(+), 58 deletions(-)

diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
index e290885..5928e78 100644
--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -223,6 +223,7 @@ struct cpu_cache_fns {
 
 	void (*dma_map_area)(const void *, size_t, int);
 	void (*dma_unmap_area)(const void *, size_t, int);
+	void (*dma_barrier)(void);
 
 	void (*dma_flush_range)(const void *, const void *);
 };
@@ -250,6 +251,7 @@ extern struct cpu_cache_fns cpu_cache;
  */
 #define dmac_map_area			cpu_cache.dma_map_area
 #define dmac_unmap_area		cpu_cache.dma_unmap_area
+#define dmac_barrier			cpu_cache.dma_barrier
 #define dmac_flush_range		cpu_cache.dma_flush_range
 
 #else
@@ -278,10 +280,12 @@ extern void __cpuc_flush_dcache_area(void *, size_t);
  */
 #define dmac_map_area			__glue(_CACHE,_dma_map_area)
 #define dmac_unmap_area		__glue(_CACHE,_dma_unmap_area)
+#define dmac_barrier			__glue(_CACHE,_dma_barrier)
 #define dmac_flush_range		__glue(_CACHE,_dma_flush_range)
 
 extern void dmac_map_area(const void *, size_t, int);
 extern void dmac_unmap_area(const void *, size_t, int);
+extern void dmac_barrier(void);
 extern void dmac_flush_range(const void *, const void *);
 
 #endif
diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
index 256ee1c..1371db7 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -115,6 +115,8 @@ static inline void __dma_page_dev_to_cpu(struct page *page, unsigned long off,
 		___dma_page_dev_to_cpu(page, off, size, dir);
 }
 
+extern void __dma_barrier(enum dma_data_direction);
+
 /*
  * Return whether the given device DMA address mask can be supported
  * properly.  For example, if your device can only drive the low 24-bits
@@ -378,6 +380,7 @@ static inline dma_addr_t dma_map_single(struct device *dev, void *cpu_addr,
 	BUG_ON(!valid_dma_direction(dir));
 
 	addr = __dma_map_single(dev, cpu_addr, size, dir);
+	__dma_barrier(dir);
 	debug_dma_map_page(dev, virt_to_page(cpu_addr),
 			(unsigned long)cpu_addr & ~PAGE_MASK, size,
 			dir, addr, true);
@@ -407,6 +410,7 @@ static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
 	BUG_ON(!valid_dma_direction(dir));
 
 	addr = __dma_map_page(dev, page, offset, size, dir);
+	__dma_barrier(dir);
 	debug_dma_map_page(dev, page, offset, size, dir, addr, false);
 
 	return addr;
@@ -431,6 +435,7 @@ static inline void dma_unmap_single(struct device *dev, dma_addr_t handle,
 {
 	debug_dma_unmap_page(dev, handle, size, dir, true);
 	__dma_unmap_single(dev, handle, size, dir);
+	__dma_barrier(dir);
 }
 
 /**
@@ -452,6 +457,7 @@ static inline void dma_unmap_page(struct device *dev, dma_addr_t handle,
 {
 	debug_dma_unmap_page(dev, handle, size, dir, false);
 	__dma_unmap_page(dev, handle, size, dir);
+	__dma_barrier(dir);
 }
 
 /**
@@ -484,6 +490,7 @@ static inline void dma_sync_single_range_for_cpu(struct device *dev,
 		return;
 
 	__dma_single_dev_to_cpu(dma_to_virt(dev, handle) + offset, size, dir);
+	__dma_barrier(dir);
 }
 
 static inline void dma_sync_single_range_for_device(struct device *dev,
@@ -498,6 +505,7 @@ static inline void dma_sync_single_range_for_device(struct device *dev,
 		return;
 
 	__dma_single_cpu_to_dev(dma_to_virt(dev, handle) + offset, size, dir);
+	__dma_barrier(dir);
 }
 
 static inline void dma_sync_single_for_cpu(struct device *dev,
diff --git a/arch/arm/mm/cache-fa.S b/arch/arm/mm/cache-fa.S
index 7148e53..cdcfae2 100644
--- a/arch/arm/mm/cache-fa.S
+++ b/arch/arm/mm/cache-fa.S
@@ -179,8 +179,6 @@ fa_dma_inv_range:
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mov	r0, #0
-	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
 	mov	pc, lr
 
 /*
@@ -197,8 +195,6 @@ fa_dma_clean_range:
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mov	r0, #0	
-	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
 	mov	pc, lr
 
 /*
@@ -212,8 +208,6 @@ ENTRY(fa_dma_flush_range)
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mov	r0, #0	
-	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
 	mov	pc, lr
 
 /*
@@ -240,6 +234,12 @@ ENTRY(fa_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(fa_dma_unmap_area)
 
+ENTRY(fa_dma_barrier)
+	mov	r0, #0	
+	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
+	mov	pc, lr
+ENDPROC(fa_dma_barrier)
+
 	__INITDATA
 
 	.type	fa_cache_fns, #object
@@ -253,5 +253,6 @@ ENTRY(fa_cache_fns)
 	.long	fa_flush_kern_dcache_area
 	.long	fa_dma_map_area
 	.long	fa_dma_unmap_area
+	.long	fa_dma_barrier
 	.long	fa_dma_flush_range
 	.size	fa_cache_fns, . - fa_cache_fns
diff --git a/arch/arm/mm/cache-v3.S b/arch/arm/mm/cache-v3.S
index c2ff3c5..df34458 100644
--- a/arch/arm/mm/cache-v3.S
+++ b/arch/arm/mm/cache-v3.S
@@ -123,9 +123,11 @@ ENTRY(v3_dma_unmap_area)
  *	- dir	- DMA direction
  */
 ENTRY(v3_dma_map_area)
+ENTRY(v3_dma_barrier)
 	mov	pc, lr
 ENDPROC(v3_dma_unmap_area)
 ENDPROC(v3_dma_map_area)
+ENDPROC(v3_dma_barrier)
 
 	__INITDATA
 
@@ -140,5 +142,6 @@ ENTRY(v3_cache_fns)
 	.long	v3_flush_kern_dcache_area
 	.long	v3_dma_map_area
 	.long	v3_dma_unmap_area
+	.long	v3_dma_barrier
 	.long	v3_dma_flush_range
 	.size	v3_cache_fns, . - v3_cache_fns
diff --git a/arch/arm/mm/cache-v4.S b/arch/arm/mm/cache-v4.S
index 4810f7e..20260b1 100644
--- a/arch/arm/mm/cache-v4.S
+++ b/arch/arm/mm/cache-v4.S
@@ -135,9 +135,11 @@ ENTRY(v4_dma_unmap_area)
  *	- dir	- DMA direction
  */
 ENTRY(v4_dma_map_area)
+ENTRY(v4_dma_barrier)
 	mov	pc, lr
 ENDPROC(v4_dma_unmap_area)
 ENDPROC(v4_dma_map_area)
+ENDPROC(v4_dma_barrier)
 
 	__INITDATA
 
@@ -152,5 +154,6 @@ ENTRY(v4_cache_fns)
 	.long	v4_flush_kern_dcache_area
 	.long	v4_dma_map_area
 	.long	v4_dma_unmap_area
+	.long	v4_dma_barrier
 	.long	v4_dma_flush_range
 	.size	v4_cache_fns, . - v4_cache_fns
diff --git a/arch/arm/mm/cache-v4wb.S b/arch/arm/mm/cache-v4wb.S
index df8368a..9c9c875 100644
--- a/arch/arm/mm/cache-v4wb.S
+++ b/arch/arm/mm/cache-v4wb.S
@@ -194,7 +194,6 @@ v4wb_dma_inv_range:
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
 	mov	pc, lr
 
 /*
@@ -211,7 +210,6 @@ v4wb_dma_clean_range:
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
 	mov	pc, lr
 
 /*
@@ -251,6 +249,12 @@ ENTRY(v4wb_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(v4wb_dma_unmap_area)
 
+ENTRY(v4wb_dma_barrier)
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
+	mov	pc, lr
+ENDPROC(v4wb_dma_barrier)
+
 	__INITDATA
 
 	.type	v4wb_cache_fns, #object
@@ -264,5 +268,6 @@ ENTRY(v4wb_cache_fns)
 	.long	v4wb_flush_kern_dcache_area
 	.long	v4wb_dma_map_area
 	.long	v4wb_dma_unmap_area
+	.long	v4wb_dma_barrier
 	.long	v4wb_dma_flush_range
 	.size	v4wb_cache_fns, . - v4wb_cache_fns
diff --git a/arch/arm/mm/cache-v4wt.S b/arch/arm/mm/cache-v4wt.S
index 45c7031..223eea4 100644
--- a/arch/arm/mm/cache-v4wt.S
+++ b/arch/arm/mm/cache-v4wt.S
@@ -191,9 +191,11 @@ ENTRY(v4wt_dma_unmap_area)
  *	- dir	- DMA direction
  */
 ENTRY(v4wt_dma_map_area)
+ENTRY(v4wt_dma_barrier)
 	mov	pc, lr
 ENDPROC(v4wt_dma_unmap_area)
 ENDPROC(v4wt_dma_map_area)
+ENDPROC(v4wt_dma_barrier)
 
 	__INITDATA
 
@@ -208,5 +210,6 @@ ENTRY(v4wt_cache_fns)
 	.long	v4wt_flush_kern_dcache_area
 	.long	v4wt_dma_map_area
 	.long	v4wt_dma_unmap_area
+	.long	v4wt_dma_barrier
 	.long	v4wt_dma_flush_range
 	.size	v4wt_cache_fns, . - v4wt_cache_fns
diff --git a/arch/arm/mm/cache-v6.S b/arch/arm/mm/cache-v6.S
index 9d89c67..b294854 100644
--- a/arch/arm/mm/cache-v6.S
+++ b/arch/arm/mm/cache-v6.S
@@ -238,8 +238,6 @@ v6_dma_inv_range:
 	strlo	r2, [r0]			@ write for ownership
 #endif
 	blo	1b
-	mov	r0, #0
-	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
 	mov	pc, lr
 
 /*
@@ -261,8 +259,6 @@ v6_dma_clean_range:
 	add	r0, r0, #D_CACHE_LINE_SIZE
 	cmp	r0, r1
 	blo	1b
-	mov	r0, #0
-	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
 	mov	pc, lr
 
 /*
@@ -289,8 +285,6 @@ ENTRY(v6_dma_flush_range)
 	strlob	r2, [r0]			@ write for ownership
 #endif
 	blo	1b
-	mov	r0, #0
-	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
 	mov	pc, lr
 
 /*
@@ -327,6 +321,12 @@ ENTRY(v6_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(v6_dma_unmap_area)
 
+ENTRY(v6_dma_barrier)
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
+	mov	pc, lr
+ENDPROC(v6_dma_barrier)
+
 	__INITDATA
 
 	.type	v6_cache_fns, #object
@@ -340,5 +340,6 @@ ENTRY(v6_cache_fns)
 	.long	v6_flush_kern_dcache_area
 	.long	v6_dma_map_area
 	.long	v6_dma_unmap_area
+	.long	v6_dma_barrier
 	.long	v6_dma_flush_range
 	.size	v6_cache_fns, . - v6_cache_fns
diff --git a/arch/arm/mm/cache-v7.S b/arch/arm/mm/cache-v7.S
index bcd64f2..d89d55a 100644
--- a/arch/arm/mm/cache-v7.S
+++ b/arch/arm/mm/cache-v7.S
@@ -255,7 +255,6 @@ v7_dma_inv_range:
 	add	r0, r0, r2
 	cmp	r0, r1
 	blo	1b
-	dsb
 	mov	pc, lr
 ENDPROC(v7_dma_inv_range)
 
@@ -273,7 +272,6 @@ v7_dma_clean_range:
 	add	r0, r0, r2
 	cmp	r0, r1
 	blo	1b
-	dsb
 	mov	pc, lr
 ENDPROC(v7_dma_clean_range)
 
@@ -291,7 +289,6 @@ ENTRY(v7_dma_flush_range)
 	add	r0, r0, r2
 	cmp	r0, r1
 	blo	1b
-	dsb
 	mov	pc, lr
 ENDPROC(v7_dma_flush_range)
 
@@ -321,6 +318,11 @@ ENTRY(v7_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(v7_dma_unmap_area)
 
+ENTRY(v7_dma_barrier)
+	dsb
+	mov	pc, lr
+ENDPROC(v7_dma_barrier)
+
 	__INITDATA
 
 	.type	v7_cache_fns, #object
@@ -334,5 +336,6 @@ ENTRY(v7_cache_fns)
 	.long	v7_flush_kern_dcache_area
 	.long	v7_dma_map_area
 	.long	v7_dma_unmap_area
+	.long	v7_dma_barrier
 	.long	v7_dma_flush_range
 	.size	v7_cache_fns, . - v7_cache_fns
diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 64daef2..d807f38 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -97,6 +97,7 @@ static struct page *__dma_alloc_buffer(struct device *dev, size_t size, gfp_t gf
 	memset(ptr, 0, size);
 	dmac_flush_range(ptr, ptr + size);
 	outer_flush_range(__pa(ptr), __pa(ptr) + size);
+	dmac_barrier();
 
 	return page;
 }
@@ -542,6 +543,12 @@ void ___dma_page_dev_to_cpu(struct page *page, unsigned long off,
 }
 EXPORT_SYMBOL(___dma_page_dev_to_cpu);
 
+void __dma_barrier(enum dma_data_direction dir)
+{
+	dmac_barrier();
+}
+EXPORT_SYMBOL(__dma_barrier);
+
 /**
  * dma_map_sg - map a set of SG buffers for streaming mode DMA
  * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
@@ -572,6 +579,7 @@ int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 		if (dma_mapping_error(dev, s->dma_address))
 			goto bad_mapping;
 	}
+	__dma_barrier(dir);
 	debug_dma_map_sg(dev, sg, nents, nents, dir);
 	return nents;
 
@@ -602,6 +610,8 @@ void dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
 
 	for_each_sg(sg, s, nents, i)
 		__dma_unmap_page(dev, sg_dma_address(s), sg_dma_len(s), dir);
+
+	__dma_barrier(dir);
 }
 EXPORT_SYMBOL(dma_unmap_sg);
 
@@ -627,6 +637,7 @@ void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
 				      s->length, dir);
 	}
 
+	__dma_barrier(dir);
 	debug_dma_sync_sg_for_cpu(dev, sg, nents, dir);
 }
 EXPORT_SYMBOL(dma_sync_sg_for_cpu);
@@ -653,6 +664,7 @@ void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 				      s->length, dir);
 	}
 
+	__dma_barrier(dir);
	debug_dma_sync_sg_for_device(dev, sg, nents, dir);
 }
 EXPORT_SYMBOL(dma_sync_sg_for_device);
diff --git a/arch/arm/mm/proc-arm1020e.S b/arch/arm/mm/proc-arm1020e.S
index d278298..fea33c9 100644
--- a/arch/arm/mm/proc-arm1020e.S
+++ b/arch/arm/mm/proc-arm1020e.S
@@ -281,7 +281,6 @@ arm1020e_dma_inv_range:
 	cmp	r0, r1
 	blo	1b
 #endif
-	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -303,7 +302,6 @@ arm1020e_dma_clean_range:
 	cmp	r0, r1
 	blo	1b
 #endif
-	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -323,7 +321,6 @@ ENTRY(arm1020e_dma_flush_range)
 	cmp	r0, r1
 	blo	1b
 #endif
-	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -350,6 +347,12 @@ ENTRY(arm1020e_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(arm1020e_dma_unmap_area)
 
+ENTRY(arm1020e_dma_barrier)
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
+	mov	pc, lr
+ENDPROC(arm1020e_dma_barrier)
+
 ENTRY(arm1020e_cache_fns)
 	.long	arm1020e_flush_icache_all
 	.long	arm1020e_flush_kern_cache_all
@@ -360,6 +363,7 @@ ENTRY(arm1020e_cache_fns)
 	.long	arm1020e_flush_kern_dcache_area
 	.long	arm1020e_dma_map_area
 	.long	arm1020e_dma_unmap_area
+	.long	arm1020e_dma_barrier
 	.long	arm1020e_dma_flush_range
 
 	.align	5
diff --git a/arch/arm/mm/proc-arm1022.S b/arch/arm/mm/proc-arm1022.S
index ce13e4a..ba1a7df 100644
--- a/arch/arm/mm/proc-arm1022.S
+++ b/arch/arm/mm/proc-arm1022.S
@@ -270,7 +270,6 @@ arm1022_dma_inv_range:
 	cmp	r0, r1
 	blo	1b
 #endif
-	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -292,7 +291,6 @@ arm1022_dma_clean_range:
 	cmp	r0, r1
 	blo	1b
 #endif
-	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -312,7 +310,6 @@ ENTRY(arm1022_dma_flush_range)
 	cmp	r0, r1
 	blo	1b
 #endif
-	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -339,6 +336,12 @@ ENTRY(arm1022_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(arm1022_dma_unmap_area)
 
+ENTRY(arm1022_dma_barrier)
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
+	mov	pc, lr
+ENDPROC(arm1022_dma_barrier)
+
 ENTRY(arm1022_cache_fns)
 	.long	arm1022_flush_icache_all
 	.long	arm1022_flush_kern_cache_all
@@ -349,6 +352,7 @@ ENTRY(arm1022_cache_fns)
 	.long	arm1022_flush_kern_dcache_area
 	.long	arm1022_dma_map_area
 	.long	arm1022_dma_unmap_area
+	.long	arm1022_dma_barrier
 	.long	arm1022_dma_flush_range
 
 	.align	5
diff --git a/arch/arm/mm/proc-arm1026.S b/arch/arm/mm/proc-arm1026.S
index 636672a..de648f1 100644
--- a/arch/arm/mm/proc-arm1026.S
+++ b/arch/arm/mm/proc-arm1026.S
@@ -264,7 +264,6 @@ arm1026_dma_inv_range:
 	cmp	r0, r1
 	blo	1b
 #endif
-	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -286,7 +285,6 @@ arm1026_dma_clean_range:
 	cmp	r0, r1
 	blo	1b
 #endif
-	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -306,7 +304,6 @@ ENTRY(arm1026_dma_flush_range)
 	cmp	r0, r1
 	blo	1b
 #endif
-	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -333,6 +330,12 @@ ENTRY(arm1026_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(arm1026_dma_unmap_area)
 
+ENTRY(arm1026_dma_barrier)
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
+	mov	pc, lr
+ENDPROC(arm1026_dma_barrier)
+
 ENTRY(arm1026_cache_fns)
 	.long	arm1026_flush_icache_all
 	.long	arm1026_flush_kern_cache_all
@@ -343,6 +346,7 @@ ENTRY(arm1026_cache_fns)
 	.long	arm1026_flush_kern_dcache_area
 	.long	arm1026_dma_map_area
 	.long	arm1026_dma_unmap_area
+	.long	arm1026_dma_barrier
 	.long	arm1026_dma_flush_range
 
 	.align	5
diff --git a/arch/arm/mm/proc-arm920.S b/arch/arm/mm/proc-arm920.S
index 8be8199..ec74093 100644
--- a/arch/arm/mm/proc-arm920.S
+++ b/arch/arm/mm/proc-arm920.S
@@ -252,7 +252,6 @@ arm920_dma_inv_range:
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -271,7 +270,6 @@ arm920_dma_clean_range:
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -288,7 +286,6 @@ ENTRY(arm920_dma_flush_range)
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -315,6 +312,12 @@ ENTRY(arm920_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(arm920_dma_unmap_area)
 
+ENTRY(arm920_dma_barrier)
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
+	mov	pc, lr
+ENDPROC(arm920_dma_barrier)
+
 ENTRY(arm920_cache_fns)
 	.long	arm920_flush_icache_all
 	.long	arm920_flush_kern_cache_all
@@ -325,6 +328,7 @@ ENTRY(arm920_cache_fns)
 	.long	arm920_flush_kern_dcache_area
 	.long	arm920_dma_map_area
 	.long	arm920_dma_unmap_area
+	.long	arm920_dma_barrier
 	.long	arm920_dma_flush_range
 
 #endif
diff --git a/arch/arm/mm/proc-arm922.S b/arch/arm/mm/proc-arm922.S
index c0ff8e4..474d4c6 100644
--- a/arch/arm/mm/proc-arm922.S
+++ b/arch/arm/mm/proc-arm922.S
@@ -254,7 +254,6 @@ arm922_dma_inv_range:
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -273,7 +272,6 @@ arm922_dma_clean_range:
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -290,7 +288,6 @@ ENTRY(arm922_dma_flush_range)
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -317,6 +314,12 @@ ENTRY(arm922_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(arm922_dma_unmap_area)
 
+ENTRY(arm922_dma_barrier)
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
+	mov	pc, lr
+ENDPROC(arm922_dma_barrier)
+
 ENTRY(arm922_cache_fns)
 	.long	arm922_flush_icache_all
 	.long	arm922_flush_kern_cache_all
@@ -327,6 +330,7 @@ ENTRY(arm922_cache_fns)
 	.long	arm922_flush_kern_dcache_area
 	.long	arm922_dma_map_area
 	.long	arm922_dma_unmap_area
+	.long	arm922_dma_barrier
 	.long	arm922_dma_flush_range
 
 #endif
diff --git a/arch/arm/mm/proc-arm925.S b/arch/arm/mm/proc-arm925.S
index 3c6cffe..0336ae3 100644
--- a/arch/arm/mm/proc-arm925.S
+++ b/arch/arm/mm/proc-arm925.S
@@ -302,7 +302,6 @@ arm925_dma_inv_range:
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -323,7 +322,6 @@ arm925_dma_clean_range:
 	cmp	r0, r1
 	blo	1b
 #endif
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -345,7 +343,6 @@ ENTRY(arm925_dma_flush_range)
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -372,6 +369,12 @@ ENTRY(arm925_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(arm925_dma_unmap_area)
 
+ENTRY(arm925_dma_barrier)
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
+	mov	pc, lr
+ENDPROC(arm925_dma_barrier)
+
 ENTRY(arm925_cache_fns)
 	.long	arm925_flush_icache_all
 	.long	arm925_flush_kern_cache_all
@@ -382,6 +385,7 @@ ENTRY(arm925_cache_fns)
 	.long	arm925_flush_kern_dcache_area
 	.long	arm925_dma_map_area
 	.long	arm925_dma_unmap_area
+	.long	arm925_dma_barrier
 	.long	arm925_dma_flush_range
 
 ENTRY(cpu_arm925_dcache_clean_area)
diff --git a/arch/arm/mm/proc-arm926.S b/arch/arm/mm/proc-arm926.S
index 75b707c..473bbe6 100644
--- a/arch/arm/mm/proc-arm926.S
+++ b/arch/arm/mm/proc-arm926.S
@@ -265,7 +265,6 @@ arm926_dma_inv_range:
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -286,7 +285,6 @@ arm926_dma_clean_range:
 	cmp	r0, r1
 	blo	1b
 #endif
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -308,7 +306,6 @@ ENTRY(arm926_dma_flush_range)
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -335,6 +332,12 @@ ENTRY(arm926_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(arm926_dma_unmap_area)
 
+ENTRY(arm926_dma_barrier)
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
+	mov	pc, lr
+ENDPROC(arm926_dma_barrier)
+
 ENTRY(arm926_cache_fns)
 	.long	arm926_flush_icache_all
 	.long	arm926_flush_kern_cache_all
@@ -345,6 +348,7 @@ ENTRY(arm926_cache_fns)
 	.long	arm926_flush_kern_dcache_area
 	.long	arm926_dma_map_area
 	.long	arm926_dma_unmap_area
+	.long	arm926_dma_barrier
 	.long	arm926_dma_flush_range
 
 ENTRY(cpu_arm926_dcache_clean_area)
diff --git a/arch/arm/mm/proc-arm940.S b/arch/arm/mm/proc-arm940.S
index 1af1657..c44c963 100644
--- a/arch/arm/mm/proc-arm940.S
+++ b/arch/arm/mm/proc-arm940.S
@@ -187,7 +187,6 @@ arm940_dma_inv_range:
 	bcs	2b				@ entries 63 to 0
 	subs	r1, r1, #1 << 4
 	bcs	1b				@ segments 7 to 0
-	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -211,7 +210,6 @@ ENTRY(cpu_arm940_dcache_clean_area)
 	subs	r1, r1, #1 << 4
 	bcs	1b				@ segments 7 to 0
 #endif
-	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -237,7 +235,6 @@ ENTRY(arm940_dma_flush_range)
 	bcs	2b				@ entries 63 to 0
 	subs	r1, r1, #1 << 4
 	bcs	1b				@ segments 7 to 0
-	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -264,6 +261,12 @@ ENTRY(arm940_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(arm940_dma_unmap_area)
 
+ENTRY(arm940_dma_barrier)
+	mov	r0, #0
+	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
+	mov	pc, lr
+ENDPROC(arm940_dma_barrier)
+
 ENTRY(arm940_cache_fns)
 	.long	arm940_flush_icache_all
 	.long	arm940_flush_kern_cache_all
@@ -274,6 +277,7 @@ ENTRY(arm940_cache_fns)
 	.long	arm940_flush_kern_dcache_area
 	.long	arm940_dma_map_area
 	.long	arm940_dma_unmap_area
+	.long	arm940_dma_barrier
 	.long	arm940_dma_flush_range
 
 	__CPUINIT
diff --git a/arch/arm/mm/proc-arm946.S b/arch/arm/mm/proc-arm946.S
index 1664b6a..11e9ad7 100644
--- a/arch/arm/mm/proc-arm946.S
+++ b/arch/arm/mm/proc-arm946.S
@@ -234,7 +234,6 @@ arm946_dma_inv_range:
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -255,7 +254,6 @@ arm946_dma_clean_range:
 	cmp	r0, r1
 	blo	1b
 #endif
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -279,7 +277,6 @@ ENTRY(arm946_dma_flush_range)
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -306,6 +303,12 @@ ENTRY(arm946_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(arm946_dma_unmap_area)
 
+ENTRY(arm946_dma_barrier)
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
+	mov	pc, lr
+ENDPROC(arm946_dma_barrier)
+
 ENTRY(arm946_cache_fns)
 	.long	arm946_flush_icache_all
 	.long	arm946_flush_kern_cache_all
@@ -316,6 +319,7 @@ ENTRY(arm946_cache_fns)
 	.long	arm946_flush_kern_dcache_area
 	.long	arm946_dma_map_area
 	.long	arm946_dma_unmap_area
+	.long	arm946_dma_barrier
 	.long	arm946_dma_flush_range
 
 
diff --git a/arch/arm/mm/proc-feroceon.S b/arch/arm/mm/proc-feroceon.S
index 53e6323..50a309e 100644
--- a/arch/arm/mm/proc-feroceon.S
+++ b/arch/arm/mm/proc-feroceon.S
@@ -290,7 +290,6 @@ feroceon_dma_inv_range:
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 	.align	5
@@ -326,7 +325,6 @@ feroceon_dma_clean_range:
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 	.align	5
@@ -339,7 +337,6 @@ feroceon_range_dma_clean_range:
 	mcr	p15, 5, r0, c15, c13, 0		@ D clean range start
 	mcr	p15, 5, r1, c15, c13, 1		@ D clean range top
 	msr	cpsr_c, r2			@ restore interrupts
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -357,7 +354,6 @@ ENTRY(feroceon_dma_flush_range)
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 	.align	5
@@ -370,7 +366,6 @@ ENTRY(feroceon_range_dma_flush_range)
 	mcr	p15, 5, r0, c15, c15, 0		@ D clean/inv range start
 	mcr	p15, 5, r1, c15, c15, 1		@ D clean/inv range top
 	msr	cpsr_c, r2			@ restore interrupts
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -411,6 +406,12 @@ ENTRY(feroceon_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(feroceon_dma_unmap_area)
 
+ENTRY(feroceon_dma_barrier)
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
+	mov	pc, lr
+ENDPROC(feroceon_dma_barrier)
+
 ENTRY(feroceon_cache_fns)
 	.long	feroceon_flush_icache_all
 	.long	feroceon_flush_kern_cache_all
@@ -421,6 +422,7 @@ ENTRY(feroceon_cache_fns)
 	.long	feroceon_flush_kern_dcache_area
 	.long	feroceon_dma_map_area
 	.long	feroceon_dma_unmap_area
+	.long	feroceon_dma_barrier
 	.long	feroceon_dma_flush_range
 
 ENTRY(feroceon_range_cache_fns)
@@ -433,6 +435,7 @@ ENTRY(feroceon_range_cache_fns)
 	.long	feroceon_range_flush_kern_dcache_area
 	.long	feroceon_range_dma_map_area
 	.long	feroceon_dma_unmap_area
+	.long	feroceon_dma_barrier
 	.long	feroceon_range_dma_flush_range
 
 	.align	5
diff --git a/arch/arm/mm/proc-mohawk.S b/arch/arm/mm/proc-mohawk.S
index caa3115..09e8883 100644
--- a/arch/arm/mm/proc-mohawk.S
+++ b/arch/arm/mm/proc-mohawk.S
@@ -224,7 +224,6 @@ mohawk_dma_inv_range:
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -243,7 +242,6 @@ mohawk_dma_clean_range:
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -261,7 +259,6 @@ ENTRY(mohawk_dma_flush_range)
 	add	r0, r0, #CACHE_DLINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr
 
 /*
@@ -288,6 +285,12 @@ ENTRY(mohawk_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(mohawk_dma_unmap_area)
 
+ENTRY(mohawk_dma_barrier)
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
+	mov	pc, lr
+ENDPROC(mohawk_dma_barrier)
+
 ENTRY(mohawk_cache_fns)
 	.long	mohawk_flush_kern_cache_all
 	.long	mohawk_flush_user_cache_all
@@ -297,6 +300,7 @@ ENTRY(mohawk_cache_fns)
 	.long	mohawk_flush_kern_dcache_area
 	.long	mohawk_dma_map_area
 	.long	mohawk_dma_unmap_area
+	.long	mohawk_dma_barrier
 	.long	mohawk_dma_flush_range
 
 ENTRY(cpu_mohawk_dcache_clean_area)
diff --git a/arch/arm/mm/proc-xsc3.S b/arch/arm/mm/proc-xsc3.S
index 046b3d8..d033ed4 100644
--- a/arch/arm/mm/proc-xsc3.S
+++ b/arch/arm/mm/proc-xsc3.S
@@ -274,7 +274,6 @@ xsc3_dma_inv_range:
 	add	r0, r0, #CACHELINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ data write barrier
 	mov	pc, lr
 
 /*
@@ -291,7 +290,6 @@ xsc3_dma_clean_range:
 	add	r0, r0, #CACHELINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ data write barrier
 	mov	pc, lr
 
 /*
@@ -308,7 +306,6 @@ ENTRY(xsc3_dma_flush_range)
 	add	r0, r0, #CACHELINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ data write barrier
 	mov	pc, lr
 
 /*
@@ -335,6 +332,12 @@ ENTRY(xsc3_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(xsc3_dma_unmap_area)
 
+ENTRY(xsc3_dma_barrier)
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c10, 4		@ data write barrier
+	mov	pc, lr
+ENDPROC(xsc3_dma_barrier)
+
 ENTRY(xsc3_cache_fns)
 	.long	xsc3_flush_icache_all
 	.long	xsc3_flush_kern_cache_all
@@ -345,6 +348,7 @@ ENTRY(xsc3_cache_fns)
 	.long	xsc3_flush_kern_dcache_area
 	.long	xsc3_dma_map_area
 	.long	xsc3_dma_unmap_area
+	.long	xsc3_dma_barrier
 	.long	xsc3_dma_flush_range
 
 ENTRY(cpu_xsc3_dcache_clean_area)
diff --git a/arch/arm/mm/proc-xscale.S b/arch/arm/mm/proc-xscale.S
index 63037e2..e390ae6 100644
--- a/arch/arm/mm/proc-xscale.S
+++ b/arch/arm/mm/proc-xscale.S
@@ -332,7 +332,6 @@ xscale_dma_inv_range:
 	add	r0, r0, #CACHELINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ Drain Write (& Fill) Buffer
 	mov	pc, lr
 
 /*
@@ -349,7 +348,6 @@ xscale_dma_clean_range:
 	add	r0, r0, #CACHELINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ Drain Write (& Fill) Buffer
 	mov	pc, lr
 
 /*
@@ -367,7 +365,6 @@ ENTRY(xscale_dma_flush_range)
 	add	r0, r0, #CACHELINESIZE
 	cmp	r0, r1
 	blo	1b
-	mcr	p15, 0, r0, c7, c10, 4		@ Drain Write (& Fill) Buffer
 	mov	pc, lr
 
 /*
@@ -407,6 +404,12 @@ ENTRY(xscale_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(xscale_dma_unmap_area)
 
+ENTRY(xscale_dma_barrier)
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c10, 4		@ Drain Write (& Fill) Buffer
+	mov	pc, lr
+ENDPROC(xscsale_dma_barrier)
+
 ENTRY(xscale_cache_fns)
 	.long	xscale_flush_icache_all
 	.long	xscale_flush_kern_cache_all
@@ -417,6 +420,7 @@ ENTRY(xscale_cache_fns)
 	.long	xscale_flush_kern_dcache_area
 	.long	xscale_dma_map_area
 	.long	xscale_dma_unmap_area
+	.long	xscale_dma_barrier
 	.long	xscale_dma_flush_range
 
 /*

