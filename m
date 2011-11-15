Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab1KOPXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 10:23:07 -0500
Received: from 26.241.167.70.in-addr.border.exmeritus.com ([70.167.241.26]:45841
	"EHLO border.exmeritus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755946Ab1KOPXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 10:23:04 -0500
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: <linuxppc-dev@lists.ozlabs.org>
Cc: <linux-kernel@vger.kernel.org>, <benh@kernel.crashing.org>,
        <galak@kernel.crashing.org>, <scottwood@freescale.com>,
        <B04825@freescale.com>, <paul.gortmaker@windriver.com>,
        Kyle Moffett <Kyle.D.Moffett@boeing.com>
Subject: [RFC PATCH 2/2] WIP: PowerPC cache cleanup
Date: Tue, 15 Nov 2011 10:22:04 -0500
Message-Id: <1321370524-2740-1-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1320986410.21206.camel@pasglop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[My apologies for the resend, it does not seem to have hit the MLs.
I think my git send-email "cc-cmd" may have broken somehow, oops.]

This badly needs breaking up, and a better changelog... oh well...

The big changes:

* The "ppc64_caches" structure is now "powerpc_caches" and is used on
  both PPC32 and PPC64.  I hated staring at the pages and pages of
  assembly code, so nearly all of the functions are now C with tiny
  snippets of inline ASM in the loops.

* Lots of ugly assembly functions in arch/powerpc/kernel/misc_*.S were
  rewritten as cleaner inline ASM in arch/powerpc/mm/cache.c

* I'm not sure that the physical address functions from those files
  actually came out cleaner, but they are now more correct.

* I'm not 100% sure I like the new FOR_EACH_CACHE_LINE() macro, but it
  sure does make a lot of the other code much cleaner.

* I have a bit of a temptation to try to merge the 32/64-bit variants
  of copy_page() into a single C function.  A quick test seems to show
  that I can get nearly identical output to the 64-bit ASM with very
  little work.


---
 arch/powerpc/include/asm/cache.h             |  155 ++++++++++++---
 arch/powerpc/include/asm/cacheflush.h        |    3 -
 arch/powerpc/include/asm/page.h              |    6 +
 arch/powerpc/include/asm/page_32.h           |    4 +-
 arch/powerpc/include/asm/page_64.h           |   17 --
 arch/powerpc/kernel/align.c                  |    7 +-
 arch/powerpc/kernel/asm-offsets.c            |   13 +-
 arch/powerpc/kernel/head_32.S                |    9 +-
 arch/powerpc/kernel/head_64.S                |    2 +-
 arch/powerpc/kernel/misc_32.S                |  193 ------------------
 arch/powerpc/kernel/misc_64.S                |  182 -----------------
 arch/powerpc/kernel/ppc_ksyms.c              |    3 -
 arch/powerpc/kernel/setup-common.c           |  103 ++++++++++
 arch/powerpc/kernel/setup.h                  |    1 +
 arch/powerpc/kernel/setup_32.c               |   11 +-
 arch/powerpc/kernel/setup_64.c               |  118 +----------
 arch/powerpc/kernel/vdso.c                   |   27 +--
 arch/powerpc/lib/copypage_64.S               |   10 +-
 arch/powerpc/mm/Makefile                     |    2 +-
 arch/powerpc/mm/cache.c                      |  279 ++++++++++++++++++++++++++
 arch/powerpc/mm/dma-noncoherent.c            |    2 +-
 arch/powerpc/platforms/52xx/lite5200_sleep.S |    9 +-
 arch/powerpc/platforms/powermac/pci.c        |    2 +-
 arch/powerpc/xmon/xmon.c                     |   53 +++---
 drivers/macintosh/smu.c                      |    8 +-
 25 files changed, 599 insertions(+), 620 deletions(-)
 create mode 100644 arch/powerpc/mm/cache.c

diff --git a/arch/powerpc/include/asm/cache.h b/arch/powerpc/include/asm/cache.h
index 4b50941..b1dc08f 100644
--- a/arch/powerpc/include/asm/cache.h
+++ b/arch/powerpc/include/asm/cache.h
@@ -3,47 +3,142 @@
 
 #ifdef __KERNEL__
 
-
-/* bytes per L1 cache line */
-#if defined(CONFIG_8xx) || defined(CONFIG_403GCX)
-#define L1_CACHE_SHIFT		4
-#define MAX_COPY_PREFETCH	1
+/*
+ * Various PowerPC CPUs which are otherwise compatible have different L1
+ * cache line sizes.
+ *
+ * Unfortunately, lots of kernel code assumes that L1_CACHE_BYTES and
+ * L1_CACHE_SHIFT are compile-time constants that can be used to align
+ * data-structures to avoid false cacheline sharing, so we can't just
+ * compute them at runtime from the cputable values.
+ *
+ * So for alignment purposes, we will compute these values as safe maximums
+ * of all the CPU support compiled into the kernel.
+ */
+#if defined(CONFIG_PPC64) || defined(CONFIG_PPC_47x)
+# define L1_CACHE_SHIFT_MAX 7 /* 128-byte cache blocks */
 #elif defined(CONFIG_PPC_E500MC)
-#define L1_CACHE_SHIFT		6
-#define MAX_COPY_PREFETCH	4
-#elif defined(CONFIG_PPC32)
-#define MAX_COPY_PREFETCH	4
-#if defined(CONFIG_PPC_47x)
-#define L1_CACHE_SHIFT		7
+# define L1_CACHE_SHIFT_MAX 6 /* 64-byte cache blocks */
 #else
-#define L1_CACHE_SHIFT		5
+# define L1_CACHE_SHIFT_MAX 5 /* 32-byte cache blocks */
 #endif
+#define L1_CACHE_BYTES_MAX (1 << L1_CACHE_SHIFT_MAX)
+
+#define L1_CACHE_SHIFT  L1_CACHE_SHIFT_MAX
+#define L1_CACHE_BYTES  L1_CACHE_BYTES_MAX
+#define SMP_CACHE_BYTES L1_CACHE_BYTES_MAX
+
+/*
+ * Unfortunately, for other purposes, we can't just use a safe maximum value
+ * because it gets used in loops when invalidating or clearing cachelines and
+ * it would be very bad to only flush/invalidate/zero/etc every 4th one.
+ *
+ * During early initialization we load these values from the device-tree and
+ * the cputable into the powerpc_caches structure, but we need to be able to
+ * clear pages before that occurs, so these need sane default values.
+ *
+ * As explained in the powerpc_caches structure definition, the defaults
+ * should be safe minimums, so that's what we compute here.
+ */
+#if defined(CONFIG_8xx) || defined(CONFIG_403GCX)
+# define L1_CACHE_SHIFT_MIN 4 /* 16-byte cache blocks */
+#elif defined(CONFIG_PPC32)
+# define L1_CACHE_SHIFT_MIN 5 /* 32-byte cache blocks */
 #else /* CONFIG_PPC64 */
-#define L1_CACHE_SHIFT		7
+# define L1_CACHE_SHIFT_MIN 6 /* 64-byte cache blocks */
 #endif
+#define L1_CACHE_BYTES_MIN (1 << L1_CACHE_SHIFT_MIN)
 
-#define	L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
+/*
+ * Apparently the 8xx and the 403GCX have tiny caches, so they never prefetch
+ * more than a single cacheline in the ASM memory copy functions.
+ *
+ * All other 32-bit CPUs prefetch 4 cachelines, and the 64-bit CPUs have
+ * their own copy routines which prefetch the entire page.
+ */
+#ifdef PPC32
+# if defined(CONFIG_8xx) || defined(CONFIG_403GCX)
+#  define MAX_COPY_PREFETCH 1
+# else
+#  define MAX_COPY_PREFETCH 4
+# endif
+#endif
 
-#define	SMP_CACHE_BYTES		L1_CACHE_BYTES
+#ifndef __ASSEMBLY__
 
-#if defined(__powerpc64__) && !defined(__ASSEMBLY__)
-struct ppc64_caches {
-	u32	dsize;			/* L1 d-cache size */
-	u32	dline_size;		/* L1 d-cache line size	*/
-	u32	log_dline_size;
-	u32	dlines_per_page;
-	u32	isize;			/* L1 i-cache size */
-	u32	iline_size;		/* L1 i-cache line size	*/
-	u32	log_iline_size;
-	u32	ilines_per_page;
-};
+/*
+ * A handy macro to iterate over all the cachelines referring to memory from
+ * "START" through "STOP - 1", inclusive.
+ */
+#define FOR_EACH_CACHELINE(LINE, START, STOP, CACHE)			\
+	for (u32 linesize__ = powerpc_caches.CACHE##_block_bytes,	\
+			(LINE) = (START) & ~(linesize__ - 1);		\
+			(LINE) < (STOP); (LINE) += linesize__)
+
+/* Write out a data cache block if it is dirty */
+static inline void dcbst(unsigned long addr)
+{
+	asm volatile("dcbst %y0" :: "Z"(addr) : "memory");
+}
 
-extern struct ppc64_caches ppc64_caches;
-#endif /* __powerpc64__ && ! __ASSEMBLY__ */
+/* Invalidate a data cache block (will lose data if dirty!) */
+static inline void dcbi(unsigned long addr)
+{
+	asm volatile("dcbi %y0" :: "Z"(addr) : "memory");
+}
+
+/* Write out (if dirty) and invalidate a data cache block */
+static inline void dcbf(unsigned long addr)
+{
+	asm volatile("dcbf %y0" :: "Z"(addr) : "memory");
+}
+
+/* Populate a data cache block with zeros */
+static inline void dcbz(unsigned long addr)
+{
+	asm volatile("dcbz %y0" :: "Z"(addr) : "memory");
+}
+
+/* Invalidate an instruction cache block */
+static inline void icbi(unsigned long addr)
+{
+	asm volatile("icbi %y0" :: "Z"(addr) : "memory");
+}
+
+/*
+ * This structure contains the various PowerPC cache parameters computed
+ * shortly after the device-tree has been unflattened during boot.
+ *
+ * Prior to that they have statically initialized values from L1_CACHE_*_MIN
+ * computed above.
+ *
+ * NOTE: If the dcache/icache are separate then ucache_* should be zeroed,
+ *       otherwise dcache == icache == ucache.
+ */
+struct powerpc_caches {
+	/* Data cache parameters */
+	u32 dcache_total_bytes;
+	u32 dcache_block_bytes;
+	u32 dcache_block_shift;
+	u32 dcache_blocks_per_page;
+
+	/* Instruction cache parameters */
+	u32 icache_total_bytes;
+	u32 icache_block_bytes;
+	u32 icache_block_shift;
+	u32 icache_blocks_per_page;
+
+	/* Unified cache parameters (If != 0, all 3 caches must be equal) */
+	u32 ucache_total_bytes;
+	u32 ucache_block_bytes;
+	u32 ucache_block_shift;
+	u32 ucache_blocks_per_page;
+};
+extern struct powerpc_caches powerpc_caches;
 
-#if !defined(__ASSEMBLY__)
 #define __read_mostly __attribute__((__section__(".data..read_mostly")))
-#endif
+
+#endif /* not __ASSEMBLY__ */
 
 #endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_CACHE_H */
diff --git a/arch/powerpc/include/asm/cacheflush.h b/arch/powerpc/include/asm/cacheflush.h
index ab9e402..8646443 100644
--- a/arch/powerpc/include/asm/cacheflush.h
+++ b/arch/powerpc/include/asm/cacheflush.h
@@ -47,12 +47,9 @@ extern void __flush_dcache_icache_phys(unsigned long physaddr);
 #endif /* CONFIG_PPC32 && !CONFIG_BOOKE */
 
 extern void flush_dcache_range(unsigned long start, unsigned long stop);
-#ifdef CONFIG_PPC32
 extern void clean_dcache_range(unsigned long start, unsigned long stop);
 extern void invalidate_dcache_range(unsigned long start, unsigned long stop);
-#endif /* CONFIG_PPC32 */
 #ifdef CONFIG_PPC64
-extern void flush_inval_dcache_range(unsigned long start, unsigned long stop);
 extern void flush_dcache_phys_range(unsigned long start, unsigned long stop);
 #endif
 
diff --git a/arch/powerpc/include/asm/page.h b/arch/powerpc/include/asm/page.h
index dd9c4fd..b2e24ce 100644
--- a/arch/powerpc/include/asm/page.h
+++ b/arch/powerpc/include/asm/page.h
@@ -286,11 +286,17 @@ static inline int hugepd_ok(hugepd_t hpd)
 #endif /* CONFIG_HUGETLB_PAGE */
 
 struct page;
+extern void clear_pages(void *page, int order);
 extern void clear_user_page(void *page, unsigned long vaddr, struct page *pg);
 extern void copy_user_page(void *to, void *from, unsigned long vaddr,
 		struct page *p);
 extern int page_is_ram(unsigned long pfn);
 
+static inline void clear_page(void *page)
+{
+	clear_pages(page, 0);
+}
+
 #ifdef CONFIG_PPC_SMLPAR
 void arch_free_page(struct page *page, int order);
 #define HAVE_ARCH_FREE_PAGE
diff --git a/arch/powerpc/include/asm/page_32.h b/arch/powerpc/include/asm/page_32.h
index 68d73b2..12ae694 100644
--- a/arch/powerpc/include/asm/page_32.h
+++ b/arch/powerpc/include/asm/page_32.h
@@ -10,7 +10,7 @@
 #define VM_DATA_DEFAULT_FLAGS	VM_DATA_DEFAULT_FLAGS32
 
 #ifdef CONFIG_NOT_COHERENT_CACHE
-#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
+#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES_MAX
 #endif
 
 #ifdef CONFIG_PTE_64BIT
@@ -37,8 +37,6 @@ typedef unsigned long pte_basic_t;
 #endif
 
 struct page;
-extern void clear_pages(void *page, int order);
-static inline void clear_page(void *page) { clear_pages(page, 0); }
 extern void copy_page(void *to, void *from);
 
 #include <asm-generic/getorder.h>
diff --git a/arch/powerpc/include/asm/page_64.h b/arch/powerpc/include/asm/page_64.h
index fb40ede..7e156f6 100644
--- a/arch/powerpc/include/asm/page_64.h
+++ b/arch/powerpc/include/asm/page_64.h
@@ -42,23 +42,6 @@
 
 typedef unsigned long pte_basic_t;
 
-static __inline__ void clear_page(void *addr)
-{
-	unsigned long lines, line_size;
-
-	line_size = ppc64_caches.dline_size;
-	lines = ppc64_caches.dlines_per_page;
-
-	__asm__ __volatile__(
-	"mtctr	%1	# clear_page\n\
-1:      dcbz	0,%0\n\
-	add	%0,%0,%3\n\
-	bdnz+	1b"
-        : "=r" (addr)
-        : "r" (lines), "0" (addr), "r" (line_size)
-	: "ctr", "memory");
-}
-
 extern void copy_page(void *to, void *from);
 
 /* Log 2 of page table size */
diff --git a/arch/powerpc/kernel/align.c b/arch/powerpc/kernel/align.c
index 8184ee9..debfb99 100644
--- a/arch/powerpc/kernel/align.c
+++ b/arch/powerpc/kernel/align.c
@@ -233,14 +233,9 @@ static inline unsigned make_dsisr(unsigned instr)
  */
 static int emulate_dcbz(struct pt_regs *regs, unsigned char __user *addr)
 {
+	int i, size = powerpc_caches.dcache_block_bytes;
 	long __user *p;
-	int i, size;
 
-#ifdef __powerpc64__
-	size = ppc64_caches.dline_size;
-#else
-	size = L1_CACHE_BYTES;
-#endif
 	p = (long __user *) (regs->dar & -size);
 	if (user_mode(regs) && !access_ok(VERIFY_WRITE, p, size))
 		return -EFAULT;
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index 7c5324f..505b25a 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -126,13 +126,14 @@ int main(void)
 	DEFINE(TI_TASK, offsetof(struct thread_info, task));
 	DEFINE(TI_CPU, offsetof(struct thread_info, cpu));
 
+	DEFINE(DCACHE_BLOCK_SHIFT,	offsetof(struct powerpc_caches, dcache_block_shift));
+	DEFINE(DCACHE_BLOCK_BYTES,	offsetof(struct powerpc_caches, dcache_block_bytes));
+	DEFINE(DCACHE_BLOCKS_PER_PAGE,	offsetof(struct powerpc_caches, dcache_blocks_per_page));
+	DEFINE(ICACHE_BLOCK_SHIFT,	offsetof(struct powerpc_caches, icache_block_shift));
+	DEFINE(ICACHE_BLOCK_BYTES,	offsetof(struct powerpc_caches, icache_block_bytes));
+	DEFINE(ICACHE_BLOCKS_PER_PAGE,	offsetof(struct powerpc_caches, icache_blocks_per_page));
+
 #ifdef CONFIG_PPC64
-	DEFINE(DCACHEL1LINESIZE, offsetof(struct ppc64_caches, dline_size));
-	DEFINE(DCACHEL1LOGLINESIZE, offsetof(struct ppc64_caches, log_dline_size));
-	DEFINE(DCACHEL1LINESPERPAGE, offsetof(struct ppc64_caches, dlines_per_page));
-	DEFINE(ICACHEL1LINESIZE, offsetof(struct ppc64_caches, iline_size));
-	DEFINE(ICACHEL1LOGLINESIZE, offsetof(struct ppc64_caches, log_iline_size));
-	DEFINE(ICACHEL1LINESPERPAGE, offsetof(struct ppc64_caches, ilines_per_page));
 	/* paca */
 	DEFINE(PACA_SIZE, sizeof(struct paca_struct));
 	DEFINE(PACA_LOCK_TOKEN, offsetof(struct paca_struct, lock_token));
diff --git a/arch/powerpc/kernel/head_32.S b/arch/powerpc/kernel/head_32.S
index 0654dba..8abc44a 100644
--- a/arch/powerpc/kernel/head_32.S
+++ b/arch/powerpc/kernel/head_32.S
@@ -786,7 +786,14 @@ relocate_kernel:
 _ENTRY(copy_and_flush)
 	addi	r5,r5,-4
 	addi	r6,r6,-4
-4:	li	r0,L1_CACHE_BYTES/4
+4:	li	r0,L1_CACHE_BYTES_MIN/4	/* Use the smallest common	*/
+					/* denominator cache line	*/
+					/* size.  This results in	*/
+					/* extra cache line flushes	*/
+					/* but operation is correct.	*/
+					/* Can't get cache line size	*/
+					/* from device-tree yet		*/
+
 	mtctr	r0
 3:	addi	r6,r6,4			/* copy a cache line */
 	lwzx	r0,r6,r4
diff --git a/arch/powerpc/kernel/head_64.S b/arch/powerpc/kernel/head_64.S
index 06c7251..183d371 100644
--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -480,7 +480,7 @@ p_end:	.llong	_end - _stext
 _GLOBAL(copy_and_flush)
 	addi	r5,r5,-8
 	addi	r6,r6,-8
-4:	li	r0,8			/* Use the smallest common	*/
+4:	li	r0,L1_CACHE_BYTES_MIN/8	/* Use the smallest common	*/
 					/* denominator cache line	*/
 					/* size.  This results in	*/
 					/* extra cache line flushes	*/
diff --git a/arch/powerpc/kernel/misc_32.S b/arch/powerpc/kernel/misc_32.S
index f7d760a..ee61600 100644
--- a/arch/powerpc/kernel/misc_32.S
+++ b/arch/powerpc/kernel/misc_32.S
@@ -321,199 +321,6 @@ END_FTR_SECTION_IFSET(CPU_FTR_UNIFIED_ID_CACHE)
 	blr
 
 /*
- * Write any modified data cache blocks out to memory
- * and invalidate the corresponding instruction cache blocks.
- * This is a no-op on the 601.
- *
- * flush_icache_range(unsigned long start, unsigned long stop)
- */
-_KPROBE(__flush_icache_range)
-BEGIN_FTR_SECTION
-	blr				/* for 601, do nothing */
-END_FTR_SECTION_IFSET(CPU_FTR_COHERENT_ICACHE)
-	li	r5,L1_CACHE_BYTES-1
-	andc	r3,r3,r5
-	subf	r4,r3,r4
-	add	r4,r4,r5
-	srwi.	r4,r4,L1_CACHE_SHIFT
-	beqlr
-	mtctr	r4
-	mr	r6,r3
-1:	dcbst	0,r3
-	addi	r3,r3,L1_CACHE_BYTES
-	bdnz	1b
-	sync				/* wait for dcbst's to get to ram */
-#ifndef CONFIG_44x
-	mtctr	r4
-2:	icbi	0,r6
-	addi	r6,r6,L1_CACHE_BYTES
-	bdnz	2b
-#else
-	/* Flash invalidate on 44x because we are passed kmapped addresses and
-	   this doesn't work for userspace pages due to the virtually tagged
-	   icache.  Sigh. */
-	iccci	0, r0
-#endif
-	sync				/* additional sync needed on g4 */
-	isync
-	blr
-/*
- * Write any modified data cache blocks out to memory.
- * Does not invalidate the corresponding cache lines (especially for
- * any corresponding instruction cache).
- *
- * clean_dcache_range(unsigned long start, unsigned long stop)
- */
-_GLOBAL(clean_dcache_range)
-	li	r5,L1_CACHE_BYTES-1
-	andc	r3,r3,r5
-	subf	r4,r3,r4
-	add	r4,r4,r5
-	srwi.	r4,r4,L1_CACHE_SHIFT
-	beqlr
-	mtctr	r4
-
-1:	dcbst	0,r3
-	addi	r3,r3,L1_CACHE_BYTES
-	bdnz	1b
-	sync				/* wait for dcbst's to get to ram */
-	blr
-
-/*
- * Write any modified data cache blocks out to memory and invalidate them.
- * Does not invalidate the corresponding instruction cache blocks.
- *
- * flush_dcache_range(unsigned long start, unsigned long stop)
- */
-_GLOBAL(flush_dcache_range)
-	li	r5,L1_CACHE_BYTES-1
-	andc	r3,r3,r5
-	subf	r4,r3,r4
-	add	r4,r4,r5
-	srwi.	r4,r4,L1_CACHE_SHIFT
-	beqlr
-	mtctr	r4
-
-1:	dcbf	0,r3
-	addi	r3,r3,L1_CACHE_BYTES
-	bdnz	1b
-	sync				/* wait for dcbst's to get to ram */
-	blr
-
-/*
- * Like above, but invalidate the D-cache.  This is used by the 8xx
- * to invalidate the cache so the PPC core doesn't get stale data
- * from the CPM (no cache snooping here :-).
- *
- * invalidate_dcache_range(unsigned long start, unsigned long stop)
- */
-_GLOBAL(invalidate_dcache_range)
-	li	r5,L1_CACHE_BYTES-1
-	andc	r3,r3,r5
-	subf	r4,r3,r4
-	add	r4,r4,r5
-	srwi.	r4,r4,L1_CACHE_SHIFT
-	beqlr
-	mtctr	r4
-
-1:	dcbi	0,r3
-	addi	r3,r3,L1_CACHE_BYTES
-	bdnz	1b
-	sync				/* wait for dcbi's to get to ram */
-	blr
-
-/*
- * Flush a particular page from the data cache to RAM.
- * Note: this is necessary because the instruction cache does *not*
- * snoop from the data cache.
- * This is a no-op on the 601 which has a unified cache.
- *
- *	void __flush_dcache_icache(void *page)
- */
-_GLOBAL(__flush_dcache_icache)
-BEGIN_FTR_SECTION
-	blr
-END_FTR_SECTION_IFSET(CPU_FTR_COHERENT_ICACHE)
-	rlwinm	r3,r3,0,0,31-PAGE_SHIFT		/* Get page base address */
-	li	r4,PAGE_SIZE/L1_CACHE_BYTES	/* Number of lines in a page */
-	mtctr	r4
-	mr	r6,r3
-0:	dcbst	0,r3				/* Write line to ram */
-	addi	r3,r3,L1_CACHE_BYTES
-	bdnz	0b
-	sync
-#ifdef CONFIG_44x
-	/* We don't flush the icache on 44x. Those have a virtual icache
-	 * and we don't have access to the virtual address here (it's
-	 * not the page vaddr but where it's mapped in user space). The
-	 * flushing of the icache on these is handled elsewhere, when
-	 * a change in the address space occurs, before returning to
-	 * user space
-	 */
-BEGIN_MMU_FTR_SECTION
-	blr
-END_MMU_FTR_SECTION_IFSET(MMU_FTR_TYPE_44x)
-#endif /* CONFIG_44x */
-	mtctr	r4
-1:	icbi	0,r6
-	addi	r6,r6,L1_CACHE_BYTES
-	bdnz	1b
-	sync
-	isync
-	blr
-
-#ifndef CONFIG_BOOKE
-/*
- * Flush a particular page from the data cache to RAM, identified
- * by its physical address.  We turn off the MMU so we can just use
- * the physical address (this may be a highmem page without a kernel
- * mapping).
- *
- *	void __flush_dcache_icache_phys(unsigned long physaddr)
- */
-_GLOBAL(__flush_dcache_icache_phys)
-BEGIN_FTR_SECTION
-	blr					/* for 601, do nothing */
-END_FTR_SECTION_IFSET(CPU_FTR_COHERENT_ICACHE)
-	mfmsr	r10
-	rlwinm	r0,r10,0,28,26			/* clear DR */
-	mtmsr	r0
-	isync
-	rlwinm	r3,r3,0,0,31-PAGE_SHIFT		/* Get page base address */
-	li	r4,PAGE_SIZE/L1_CACHE_BYTES	/* Number of lines in a page */
-	mtctr	r4
-	mr	r6,r3
-0:	dcbst	0,r3				/* Write line to ram */
-	addi	r3,r3,L1_CACHE_BYTES
-	bdnz	0b
-	sync
-	mtctr	r4
-1:	icbi	0,r6
-	addi	r6,r6,L1_CACHE_BYTES
-	bdnz	1b
-	sync
-	mtmsr	r10				/* restore DR */
-	isync
-	blr
-#endif /* CONFIG_BOOKE */
-
-/*
- * Clear pages using the dcbz instruction, which doesn't cause any
- * memory traffic (except to write out any cache lines which get
- * displaced).  This only works on cacheable memory.
- *
- * void clear_pages(void *page, int order) ;
- */
-_GLOBAL(clear_pages)
-	li	r0,PAGE_SIZE/L1_CACHE_BYTES
-	slw	r0,r0,r4
-	mtctr	r0
-1:	dcbz	0,r3
-	addi	r3,r3,L1_CACHE_BYTES
-	bdnz	1b
-	blr
-
-/*
  * Copy a whole page.  We use the dcbz instruction on the destination
  * to reduce memory traffic (it eliminates the unnecessary reads of
  * the destination into cache).  This requires that the destination
diff --git a/arch/powerpc/kernel/misc_64.S b/arch/powerpc/kernel/misc_64.S
index 616921e..500fd61 100644
--- a/arch/powerpc/kernel/misc_64.S
+++ b/arch/powerpc/kernel/misc_64.S
@@ -53,188 +53,6 @@ _GLOBAL(call_handle_irq)
 	mtlr	r0
 	blr
 
-	.section	".toc","aw"
-PPC64_CACHES:
-	.tc		ppc64_caches[TC],ppc64_caches
-	.section	".text"
-
-/*
- * Write any modified data cache blocks out to memory
- * and invalidate the corresponding instruction cache blocks.
- *
- * flush_icache_range(unsigned long start, unsigned long stop)
- *
- *   flush all bytes from start through stop-1 inclusive
- */
-
-_KPROBE(__flush_icache_range)
-
-/*
- * Flush the data cache to memory 
- * 
- * Different systems have different cache line sizes
- * and in some cases i-cache and d-cache line sizes differ from
- * each other.
- */
- 	ld	r10,PPC64_CACHES@toc(r2)
-	lwz	r7,DCACHEL1LINESIZE(r10)/* Get cache line size */
-	addi	r5,r7,-1
-	andc	r6,r3,r5		/* round low to line bdy */
-	subf	r8,r6,r4		/* compute length */
-	add	r8,r8,r5		/* ensure we get enough */
-	lwz	r9,DCACHEL1LOGLINESIZE(r10)	/* Get log-2 of cache line size */
-	srw.	r8,r8,r9		/* compute line count */
-	beqlr				/* nothing to do? */
-	mtctr	r8
-1:	dcbst	0,r6
-	add	r6,r6,r7
-	bdnz	1b
-	sync
-
-/* Now invalidate the instruction cache */
-	
-	lwz	r7,ICACHEL1LINESIZE(r10)	/* Get Icache line size */
-	addi	r5,r7,-1
-	andc	r6,r3,r5		/* round low to line bdy */
-	subf	r8,r6,r4		/* compute length */
-	add	r8,r8,r5
-	lwz	r9,ICACHEL1LOGLINESIZE(r10)	/* Get log-2 of Icache line size */
-	srw.	r8,r8,r9		/* compute line count */
-	beqlr				/* nothing to do? */
-	mtctr	r8
-2:	icbi	0,r6
-	add	r6,r6,r7
-	bdnz	2b
-	isync
-	blr
-	.previous .text
-/*
- * Like above, but only do the D-cache.
- *
- * flush_dcache_range(unsigned long start, unsigned long stop)
- *
- *    flush all bytes from start to stop-1 inclusive
- */
-_GLOBAL(flush_dcache_range)
-
-/*
- * Flush the data cache to memory 
- * 
- * Different systems have different cache line sizes
- */
- 	ld	r10,PPC64_CACHES@toc(r2)
-	lwz	r7,DCACHEL1LINESIZE(r10)	/* Get dcache line size */
-	addi	r5,r7,-1
-	andc	r6,r3,r5		/* round low to line bdy */
-	subf	r8,r6,r4		/* compute length */
-	add	r8,r8,r5		/* ensure we get enough */
-	lwz	r9,DCACHEL1LOGLINESIZE(r10)	/* Get log-2 of dcache line size */
-	srw.	r8,r8,r9		/* compute line count */
-	beqlr				/* nothing to do? */
-	mtctr	r8
-0:	dcbst	0,r6
-	add	r6,r6,r7
-	bdnz	0b
-	sync
-	blr
-
-/*
- * Like above, but works on non-mapped physical addresses.
- * Use only for non-LPAR setups ! It also assumes real mode
- * is cacheable. Used for flushing out the DART before using
- * it as uncacheable memory 
- *
- * flush_dcache_phys_range(unsigned long start, unsigned long stop)
- *
- *    flush all bytes from start to stop-1 inclusive
- */
-_GLOBAL(flush_dcache_phys_range)
- 	ld	r10,PPC64_CACHES@toc(r2)
-	lwz	r7,DCACHEL1LINESIZE(r10)	/* Get dcache line size */
-	addi	r5,r7,-1
-	andc	r6,r3,r5		/* round low to line bdy */
-	subf	r8,r6,r4		/* compute length */
-	add	r8,r8,r5		/* ensure we get enough */
-	lwz	r9,DCACHEL1LOGLINESIZE(r10)	/* Get log-2 of dcache line size */
-	srw.	r8,r8,r9		/* compute line count */
-	beqlr				/* nothing to do? */
-	mfmsr	r5			/* Disable MMU Data Relocation */
-	ori	r0,r5,MSR_DR
-	xori	r0,r0,MSR_DR
-	sync
-	mtmsr	r0
-	sync
-	isync
-	mtctr	r8
-0:	dcbst	0,r6
-	add	r6,r6,r7
-	bdnz	0b
-	sync
-	isync
-	mtmsr	r5			/* Re-enable MMU Data Relocation */
-	sync
-	isync
-	blr
-
-_GLOBAL(flush_inval_dcache_range)
- 	ld	r10,PPC64_CACHES@toc(r2)
-	lwz	r7,DCACHEL1LINESIZE(r10)	/* Get dcache line size */
-	addi	r5,r7,-1
-	andc	r6,r3,r5		/* round low to line bdy */
-	subf	r8,r6,r4		/* compute length */
-	add	r8,r8,r5		/* ensure we get enough */
-	lwz	r9,DCACHEL1LOGLINESIZE(r10)/* Get log-2 of dcache line size */
-	srw.	r8,r8,r9		/* compute line count */
-	beqlr				/* nothing to do? */
-	sync
-	isync
-	mtctr	r8
-0:	dcbf	0,r6
-	add	r6,r6,r7
-	bdnz	0b
-	sync
-	isync
-	blr
-
-
-/*
- * Flush a particular page from the data cache to RAM.
- * Note: this is necessary because the instruction cache does *not*
- * snoop from the data cache.
- *
- *	void __flush_dcache_icache(void *page)
- */
-_GLOBAL(__flush_dcache_icache)
-/*
- * Flush the data cache to memory 
- * 
- * Different systems have different cache line sizes
- */
-
-/* Flush the dcache */
- 	ld	r7,PPC64_CACHES@toc(r2)
-	clrrdi	r3,r3,PAGE_SHIFT           	    /* Page align */
-	lwz	r4,DCACHEL1LINESPERPAGE(r7)	/* Get # dcache lines per page */
-	lwz	r5,DCACHEL1LINESIZE(r7)		/* Get dcache line size */
-	mr	r6,r3
-	mtctr	r4
-0:	dcbst	0,r6
-	add	r6,r6,r5
-	bdnz	0b
-	sync
-
-/* Now invalidate the icache */	
-
-	lwz	r4,ICACHEL1LINESPERPAGE(r7)	/* Get # icache lines per page */
-	lwz	r5,ICACHEL1LINESIZE(r7)		/* Get icache line size */
-	mtctr	r4
-1:	icbi	0,r3
-	add	r3,r3,r5
-	bdnz	1b
-	isync
-	blr
-
-
 #if defined(CONFIG_PPC_PMAC) || defined(CONFIG_PPC_MAPLE)
 /*
  * Do an IO access in real mode
diff --git a/arch/powerpc/kernel/ppc_ksyms.c b/arch/powerpc/kernel/ppc_ksyms.c
index acba8ce..ccdceb7 100644
--- a/arch/powerpc/kernel/ppc_ksyms.c
+++ b/arch/powerpc/kernel/ppc_ksyms.c
@@ -53,7 +53,6 @@ extern void program_check_exception(struct pt_regs *regs);
 extern void single_step_exception(struct pt_regs *regs);
 extern int sys_sigreturn(struct pt_regs *regs);
 
-EXPORT_SYMBOL(clear_pages);
 EXPORT_SYMBOL(ISA_DMA_THRESHOLD);
 EXPORT_SYMBOL(DMA_MODE_READ);
 EXPORT_SYMBOL(DMA_MODE_WRITE);
@@ -113,8 +112,6 @@ EXPORT_SYMBOL(giveup_spe);
 #ifndef CONFIG_PPC64
 EXPORT_SYMBOL(flush_instruction_cache);
 #endif
-EXPORT_SYMBOL(__flush_icache_range);
-EXPORT_SYMBOL(flush_dcache_range);
 
 #ifdef CONFIG_SMP
 #ifdef CONFIG_PPC32
diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index 77bb77d..3abfea4 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -83,6 +83,54 @@ unsigned long klimit = (unsigned long) _end;
 char cmd_line[COMMAND_LINE_SIZE];
 
 /*
+ * Initialize these values to minimum safe defaults in case they need to be
+ * used early during the boot process.  While this may not seem safe, it is
+ * actually safe in practice, because all of the kernel loops that use this
+ * data operate on whole pages.
+ *
+ * The PowerPC Book III-E spec documents that the pagesize is an even
+ * multiple of the cache block size and the cache blocks are always
+ * page-aligned.
+ *
+ * So, for example, when clearing a whole page there are only two things that
+ * can be done wrong with "dcbz":
+ *
+ *   (1) Call "dcbz" with an address outside the page you want to zero.
+ *
+ *   (2) Call "dcbz" too few times to actually hit all of the cachelines,
+ *       IE: Use a too-large cacheline stride.
+ *
+ * So as long as we ensure that this number is small enough for the current
+ * CPU everything will operate correctly, albeit with a slight performance
+ * hit, until we get a chance to parse the device-tree for the right value.
+ *
+ * NOTE: Userspace expects an exact value, so none of the above applies after
+ * the device tree has been unflattened and actual values computed.
+ *
+ * See arch/powerpc/asm/caches.h for more information.
+ */
+struct powerpc_caches powerpc_caches = {
+	/* Data cache sizes */
+	.dcache_total_bytes  = 0, /* Unknown */
+	.dcache_block_bytes = L1_CACHE_BYTES_MIN,
+	.dcache_block_shift = L1_CACHE_SHIFT_MIN,
+	.dcache_blocks_per_page = (PAGE_SIZE >> L1_CACHE_SHIFT_MIN),
+
+	/* Instruction cache sizes */
+	.icache_total_bytes = 0,
+	.icache_block_bytes = L1_CACHE_BYTES_MIN,
+	.icache_block_shift = L1_CACHE_SHIFT_MIN,
+	.icache_blocks_per_page = (PAGE_SIZE >> L1_CACHE_SHIFT_MIN),
+
+	/* Unified cache (assume cache is split by default) */
+	.ucache_total_bytes = 0,
+	.ucache_block_bytes = 0,
+	.ucache_block_shift = 0,
+	.ucache_blocks_per_page = 0,
+};
+EXPORT_SYMBOL_GPL(powerpc_caches);
+
+/*
  * This still seems to be needed... -- paulus
  */ 
 struct screen_info screen_info = {
@@ -349,6 +397,61 @@ const struct seq_operations cpuinfo_op = {
 	.show =	show_cpuinfo,
 };
 
+/* Helper functions to compute various values from a cache block size */
+static void __init set_dcache_block_data(u32 bytes)
+{
+	u32 shift = __ilog2(bytes);
+	powerpc_caches.dcache_block_bytes = bytes;
+	powerpc_caches.dcache_block_shift = shift;
+	powerpc_caches.dcache_blocks_per_page = (PAGE_SIZE >> shift);
+}
+static void __init set_icache_block_data(u32 bytes)
+{
+	u32 shift = __ilog2(bytes);
+	powerpc_caches.icache_block_bytes = bytes;
+	powerpc_caches.icache_block_shift = shift;
+	powerpc_caches.icache_blocks_per_page = (PAGE_SIZE >> shift);
+}
+
+/*
+ * Preinitialize the powerpc_caches structure from the cputable.  We will
+ * later scan the device-tree for this information, which may be more
+ * accurate.
+ */
+void __init initialize_early_cache_info(void)
+{
+	set_dcache_block_data(cur_cpu_spec->dcache_bsize);
+	set_icache_block_data(cur_cpu_spec->icache_bsize);
+}
+
+/*
+ * Initialize the powerpc_caches structure from the device-tree for use by
+ * copy_page(), cache flush routines, and AT_DCACHEBSIZE elf headers.
+ *
+ * In the unlikely event that the device-tree doesn't have this information,
+ * the defaults loaded by initialize_early_cache_info() from the cputable
+ * will be used.
+ */
+void __init initialize_cache_info(void)
+{
+	/* Assume that the cache properties are the same across all nodes */
+	struct device_node *np = of_find_node_by_type(NULL, "cpu");
+	u32 value = 0;
+
+	/* First check data/instruction cache block sizes */
+	if (	!of_property_read_u32(np, "d-cache-block-size", &value) ||
+		!of_property_read_u32(np, "d-cache-line-size", &value))
+		set_dcache_block_data(value);
+
+	if (	!of_property_read_u32(np, "i-cache-block-size", &value) ||
+		!of_property_read_u32(np, "i-cache-line-size", &value))
+		set_icache_block_data(value);
+
+	/* Also read total cache sizes (no defaults here) */
+	of_property_read_u32(np, "d-cache-size", &powerpc_caches.dcache_total_bytes);
+	of_property_read_u32(np, "i-cache-size", &powerpc_caches.icache_total_bytes);
+}
+
 void __init check_for_initrd(void)
 {
 #ifdef CONFIG_BLK_DEV_INITRD
diff --git a/arch/powerpc/kernel/setup.h b/arch/powerpc/kernel/setup.h
index 4c67ad7..1ae16ec 100644
--- a/arch/powerpc/kernel/setup.h
+++ b/arch/powerpc/kernel/setup.h
@@ -1,6 +1,7 @@
 #ifndef _POWERPC_KERNEL_SETUP_H
 #define _POWERPC_KERNEL_SETUP_H
 
+void initialize_cache_info(void);
 void check_for_initrd(void);
 void do_init_bootmem(void);
 void setup_panic(void);
diff --git a/arch/powerpc/kernel/setup_32.c b/arch/powerpc/kernel/setup_32.c
index c1ce863..1db2bfb 100644
--- a/arch/powerpc/kernel/setup_32.c
+++ b/arch/powerpc/kernel/setup_32.c
@@ -63,14 +63,6 @@ EXPORT_SYMBOL(vgacon_remap_base);
 #endif
 
 /*
- * These are used in binfmt_elf.c to put aux entries on the stack
- * for each elf executable being started.
- */
-int dcache_bsize;
-int icache_bsize;
-int ucache_bsize;
-
-/*
  * We're called here very early in the boot.  We determine the machine
  * type and call the appropriate low-level setup functions.
  *  -- Cort <cort@fsmlabs.com>
@@ -286,10 +278,13 @@ void __init setup_arch(char **cmdline_p)
 {
 	*cmdline_p = cmd_line;
 
+	initialize_early_cache_info();
+
 	/* so udelay does something sensible, assume <= 1000 bogomips */
 	loops_per_jiffy = 500000000 / HZ;
 
 	unflatten_device_tree();
+	initialize_cache_info();
 	check_for_initrd();
 
 	if (ppc_md.init_early)
diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 1a9dea8..bb686de 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -77,25 +77,6 @@ int boot_cpuid = 0;
 int __initdata spinning_secondaries;
 u64 ppc64_pft_size;
 
-/* Pick defaults since we might want to patch instructions
- * before we've read this from the device tree.
- */
-struct ppc64_caches ppc64_caches = {
-	.dline_size = 0x40,
-	.log_dline_size = 6,
-	.iline_size = 0x40,
-	.log_iline_size = 6
-};
-EXPORT_SYMBOL_GPL(ppc64_caches);
-
-/*
- * These are used in binfmt_elf.c to put aux entries on the stack
- * for each elf executable being started.
- */
-int dcache_bsize;
-int icache_bsize;
-int ucache_bsize;
-
 #ifdef CONFIG_SMP
 
 static char *smt_enabled_cmdline;
@@ -265,82 +246,6 @@ void smp_release_cpus(void)
 #endif /* CONFIG_SMP || CONFIG_KEXEC */
 
 /*
- * Initialize some remaining members of the ppc64_caches and systemcfg
- * structures
- * (at least until we get rid of them completely). This is mostly some
- * cache informations about the CPU that will be used by cache flush
- * routines and/or provided to userland
- */
-static void __init initialize_cache_info(void)
-{
-	struct device_node *np;
-	unsigned long num_cpus = 0;
-
-	DBG(" -> initialize_cache_info()\n");
-
-	for_each_node_by_type(np, "cpu") {
-		num_cpus += 1;
-
-		/*
-		 * We're assuming *all* of the CPUs have the same
-		 * d-cache and i-cache sizes... -Peter
-		 */
-		if (num_cpus == 1) {
-			const u32 *sizep, *lsizep;
-			u32 size, lsize;
-
-			size = 0;
-			lsize = cur_cpu_spec->dcache_bsize;
-			sizep = of_get_property(np, "d-cache-size", NULL);
-			if (sizep != NULL)
-				size = *sizep;
-			lsizep = of_get_property(np, "d-cache-block-size",
-						 NULL);
-			/* fallback if block size missing */
-			if (lsizep == NULL)
-				lsizep = of_get_property(np,
-							 "d-cache-line-size",
-							 NULL);
-			if (lsizep != NULL)
-				lsize = *lsizep;
-			if (sizep == 0 || lsizep == 0)
-				DBG("Argh, can't find dcache properties ! "
-				    "sizep: %p, lsizep: %p\n", sizep, lsizep);
-
-			ppc64_caches.dsize = size;
-			ppc64_caches.dline_size = lsize;
-			ppc64_caches.log_dline_size = __ilog2(lsize);
-			ppc64_caches.dlines_per_page = PAGE_SIZE / lsize;
-
-			size = 0;
-			lsize = cur_cpu_spec->icache_bsize;
-			sizep = of_get_property(np, "i-cache-size", NULL);
-			if (sizep != NULL)
-				size = *sizep;
-			lsizep = of_get_property(np, "i-cache-block-size",
-						 NULL);
-			if (lsizep == NULL)
-				lsizep = of_get_property(np,
-							 "i-cache-line-size",
-							 NULL);
-			if (lsizep != NULL)
-				lsize = *lsizep;
-			if (sizep == 0 || lsizep == 0)
-				DBG("Argh, can't find icache properties ! "
-				    "sizep: %p, lsizep: %p\n", sizep, lsizep);
-
-			ppc64_caches.isize = size;
-			ppc64_caches.iline_size = lsize;
-			ppc64_caches.log_iline_size = __ilog2(lsize);
-			ppc64_caches.ilines_per_page = PAGE_SIZE / lsize;
-		}
-	}
-
-	DBG(" <- initialize_cache_info()\n");
-}
-
-
-/*
  * Do some initial setup of the system.  The parameters are those which 
  * were passed in from the bootloader.
  */
@@ -365,10 +270,7 @@ void __init setup_system(void)
 	 */
 	unflatten_device_tree();
 
-	/*
-	 * Fill the ppc64_caches & systemcfg structures with informations
- 	 * retrieved from the device-tree.
-	 */
+	/* Fill the powerpc_caches structure with device-tree data */
 	initialize_cache_info();
 
 #ifdef CONFIG_PPC_RTAS
@@ -423,12 +325,10 @@ void __init setup_system(void)
 	printk("-----------------------------------------------------\n");
 	printk("ppc64_pft_size                = 0x%llx\n", ppc64_pft_size);
 	printk("physicalMemorySize            = 0x%llx\n", memblock_phys_mem_size());
-	if (ppc64_caches.dline_size != 0x80)
-		printk("ppc64_caches.dcache_line_size = 0x%x\n",
-		       ppc64_caches.dline_size);
-	if (ppc64_caches.iline_size != 0x80)
-		printk("ppc64_caches.icache_line_size = 0x%x\n",
-		       ppc64_caches.iline_size);
+	if (powerpc_caches.dcache_block_bytes != 0x80)
+		printk("dcache_block_bytes = 0x%x\n", powerpc_caches.dcache_block_bytes);
+	if (powerpc_caches.icache_block_bytes != 0x80)
+		printk("icache_block_bytes = 0x%x\n", powerpc_caches.icache_block_bytes);
 #ifdef CONFIG_PPC_STD_MMU_64
 	if (htab_address)
 		printk("htab_address                  = 0x%p\n", htab_address);
@@ -545,13 +445,7 @@ void __init setup_arch(char **cmdline_p)
 
 	*cmdline_p = cmd_line;
 
-	/*
-	 * Set cache line size based on type of cpu as a default.
-	 * Systems with OF can look in the properties on the cpu node(s)
-	 * for a possibly more accurate value.
-	 */
-	dcache_bsize = ppc64_caches.dline_size;
-	icache_bsize = ppc64_caches.iline_size;
+	initialize_early_cache_info();
 
 	/* reboot on panic */
 	panic_timeout = 180;
diff --git a/arch/powerpc/kernel/vdso.c b/arch/powerpc/kernel/vdso.c
index 7d14bb6..4a038fb 100644
--- a/arch/powerpc/kernel/vdso.c
+++ b/arch/powerpc/kernel/vdso.c
@@ -726,6 +726,7 @@ static int __init vdso_init(void)
 	vdso_data->version.major = SYSTEMCFG_MAJOR;
 	vdso_data->version.minor = SYSTEMCFG_MINOR;
 	vdso_data->processor = mfspr(SPRN_PVR);
+
 	/*
 	 * Fake the old platform number for pSeries and iSeries and add
 	 * in LPAR bit if necessary
@@ -734,29 +735,25 @@ static int __init vdso_init(void)
 	if (firmware_has_feature(FW_FEATURE_LPAR))
 		vdso_data->platform |= 1;
 	vdso_data->physicalMemorySize = memblock_phys_mem_size();
-	vdso_data->dcache_size = ppc64_caches.dsize;
-	vdso_data->dcache_line_size = ppc64_caches.dline_size;
-	vdso_data->icache_size = ppc64_caches.isize;
-	vdso_data->icache_line_size = ppc64_caches.iline_size;
 
-	/* XXXOJN: Blocks should be added to ppc64_caches and used instead */
-	vdso_data->dcache_block_size = ppc64_caches.dline_size;
-	vdso_data->icache_block_size = ppc64_caches.iline_size;
-	vdso_data->dcache_log_block_size = ppc64_caches.log_dline_size;
-	vdso_data->icache_log_block_size = ppc64_caches.log_iline_size;
+	/* There are more cache parameters saved for 64-bit than 32-bit */
+	vdso_data->dcache_size           = powerpc_caches.dcache_total_size;
+	vdso_data->icache_size           = powerpc_caches.icache_total_size;
+	vdso_data->dcache_line_size      = powerpc_caches.dcache_block_bytes;
+	vdso_data->icache_line_size      = powerpc_caches.icache_block_bytes;
 
 	/*
 	 * Calculate the size of the 64 bits vDSO
 	 */
 	vdso64_pages = (&vdso64_end - &vdso64_start) >> PAGE_SHIFT;
 	DBG("vdso64_kbase: %p, 0x%x pages\n", vdso64_kbase, vdso64_pages);
-#else
-	vdso_data->dcache_block_size = L1_CACHE_BYTES;
-	vdso_data->dcache_log_block_size = L1_CACHE_SHIFT;
-	vdso_data->icache_block_size = L1_CACHE_BYTES;
-	vdso_data->icache_log_block_size = L1_CACHE_SHIFT;
-#endif /* CONFIG_PPC64 */
+#endif
 
+	/* Save the cache-block sizes for the VDSO */
+	vdso_data->dcache_block_size     = powerpc_caches.dcache_block_bytes;
+	vdso_data->icache_block_size     = powerpc_caches.icache_block_bytes;
+	vdso_data->dcache_log_block_size = powerpc_caches.dcache_block_shift;
+	vdso_data->icache_log_block_size = powerpc_caches.icache_block_shift;
 
 	/*
 	 * Calculate the size of the 32 bits vDSO
diff --git a/arch/powerpc/lib/copypage_64.S b/arch/powerpc/lib/copypage_64.S
index 53dcb6b..c466977 100644
--- a/arch/powerpc/lib/copypage_64.S
+++ b/arch/powerpc/lib/copypage_64.S
@@ -12,17 +12,17 @@
 #include <asm/asm-offsets.h>
 
         .section        ".toc","aw"
-PPC64_CACHES:
-        .tc             ppc64_caches[TC],ppc64_caches
+POWERPC_CACHES:
+        .tc             powerpc_caches[TC],powerpc_caches
         .section        ".text"
 
 _GLOBAL(copy_page)
 	lis	r5,PAGE_SIZE@h
 	ori	r5,r5,PAGE_SIZE@l
 BEGIN_FTR_SECTION
-	ld      r10,PPC64_CACHES@toc(r2)
-	lwz	r11,DCACHEL1LOGLINESIZE(r10)	/* log2 of cache line size */
-	lwz     r12,DCACHEL1LINESIZE(r10)	/* get cache line size */
+	ld      r10,POWERPC_CACHES@toc(r2)
+	lwz	r11,DCACHE_BLOCK_SHIFT(r10)	/* log2 of cache line size */
+	lwz     r12,DCACHE_BLOCK_BYTES(r10)	/* get cache line size */
 	li	r9,0
 	srd	r8,r5,r11
 
diff --git a/arch/powerpc/mm/Makefile b/arch/powerpc/mm/Makefile
index 991ee81..8ad36a9 100644
--- a/arch/powerpc/mm/Makefile
+++ b/arch/powerpc/mm/Makefile
@@ -6,7 +6,7 @@ subdir-ccflags-$(CONFIG_PPC_WERROR) := -Werror
 
 ccflags-$(CONFIG_PPC64)	:= -mno-minimal-toc
 
-obj-y				:= fault.o mem.o pgtable.o gup.o \
+obj-y				:= cache.o fault.o mem.o pgtable.o gup.o \
 				   init_$(CONFIG_WORD_SIZE).o \
 				   pgtable_$(CONFIG_WORD_SIZE).o
 obj-$(CONFIG_PPC_MMU_NOHASH)	+= mmu_context_nohash.o tlb_nohash.o \
diff --git a/arch/powerpc/mm/cache.c b/arch/powerpc/mm/cache.c
new file mode 100644
index 0000000..0fbf2d6
--- /dev/null
+++ b/arch/powerpc/mm/cache.c
@@ -0,0 +1,279 @@
+#include <linux/kprobes.h>
+#include <linux/export.h>
+#include <linux/types.h>
+
+#include <asm/cputable.h>
+#include <asm/system.h>
+#include <asm/cache.h>
+#include <asm/page.h>
+#include <asm/mmu.h>
+
+/*
+ * Write any modified data cache blocks out to memory.
+ * Does not invalidate the corresponding cache lines (especially for
+ * any corresponding instruction cache).
+ */
+void clean_dcache_range(unsigned long start, unsigned long stop)
+{
+	unsigned long addr;
+	FOR_EACH_CACHELINE(addr, start, stop, dcache)
+		dcbst(addr);
+	mb();
+}
+
+/*
+ * Write any modified data cache blocks out to memory and invalidate them.
+ * Does not invalidate the corresponding instruction cache blocks.
+ */
+void flush_dcache_range(unsigned long start, unsigned long stop)
+{
+	unsigned long addr;
+	FOR_EACH_CACHELINE(addr, start, stop, dcache)
+		dcbf(addr);
+	mb();
+}
+EXPORT_SYMBOL(flush_dcache_range);
+
+/*
+ * Like above, but invalidate the D-cache.  This is used by the 8xx
+ * to invalidate the cache so the PPC core doesn't get stale data
+ * from the CPM (no cache snooping here :-).
+ *
+ * invalidate_dcache_range(unsigned long start, unsigned long stop)
+ */
+void invalidate_dcache_range(unsigned long start, unsigned long stop)
+{
+	unsigned long addr;
+	FOR_EACH_CACHELINE(addr, start, stop, dcache)
+		dcbi(addr);
+	mb();
+}
+
+/*
+ * Unfortunately, we cannot flush individual chunks of the icache on 44x as
+ * we are passed kmapped addresses and we have a virtually-tagged icache.
+ *
+ * The only workaround is to invalidate the whole icache.
+ *
+ * NOTE: The CPU does not use the operands for this instruction, so
+ *       they are passed as dummies.
+ */
+__kprobes void __flush_icache_range(unsigned long start, unsigned long stop)
+{
+	unsigned long addr;
+
+	if (cpu_has_feature(CPU_FTR_COHERENT_ICACHE))
+		return;
+
+	/* First ensure that data has been written to memory */
+	FOR_EACH_CACHELINE(addr, start, stop, dcache)
+		dcbst(addr);
+	mb();
+
+#ifdef CONFIG_44x
+	if (mmu_has_feature(MMU_FTR_TYPE_44x)) {
+		asm volatile("iccci 0, r0" ::: "memory");
+		return;
+	}
+#endif
+
+	/* Now discard the corresponding icache */
+	FOR_EACH_CACHELINE(addr, start, stop, icache)
+		icbi(addr);
+	mb();
+	isync();
+}
+EXPORT_SYMBOL(__flush_icache_range);
+
+/*
+ * Flush a particular page from the data cache to RAM.
+ * Note: this is necessary because the instruction cache does *not*
+ * snoop from the data cache.
+ * This is a no-op on the 601 which has a unified cache.
+ *
+ *	void __flush_dcache_icache(void *page)
+ */
+void __flush_dcache_icache(void *page)
+{
+	unsigned long base = ((unsigned long)page) & ~(PAGE_SIZE-1);
+	unsigned long addr;
+
+	if (cpu_has_feature(CPU_FTR_COHERENT_ICACHE))
+		return;
+
+	/* First ensure that data has been written to memory */
+	FOR_EACH_CACHELINE(addr, base, base + PAGE_SIZE, dcache)
+		dcbst(addr);
+
+#ifdef CONFIG_44x
+	/*
+	 * We don't flush the icache on 44x. Those have a virtual icache and
+	 * we don't have access to the virtual address here (it's not the
+	 * page vaddr but where it's mapped in user space). The flushing of
+	 * the icache on these is handled elsewhere, when a change in the
+	 * address space occurs, before returning to user space.
+	 */
+	if (mmu_has_feature(MMU_FTR_TYPE_44x))
+		return;
+#endif
+
+	FOR_EACH_CACHELINE(addr, base, base + PAGE_SIZE, icache)
+		icbi(addr);
+
+	mb();
+	isync();
+}
+
+/*
+ * Clear pages using the dcbz instruction, which doesn't cause any
+ * memory traffic (except to write out any cache lines which get
+ * displaced).  This only works on cacheable memory.
+ *
+ */
+void clear_pages(void *page, int order)
+{
+	unsigned long addr, base = (unsigned long)page;
+	FOR_EACH_CACHELINE(addr, base, base + (PAGE_SIZE << order), dcache)
+		dcbz(addr);
+}
+EXPORT_SYMBOL(clear_pages);
+
+#if defined(CONFIG_PPC32) && !defined(CONFIG_BOOKE)
+/*
+ * Flush a particular page from the data cache to RAM, identified
+ * by its physical address.  We turn off the MMU so we can just use
+ * the physical address (this may be a highmem page without a kernel
+ * mapping).
+ */
+void __flush_dcache_icache_phys(unsigned long phys_page)
+{
+	u32 d_size	= powerpc_caches.dcache_block_bytes;
+	u32 i_size	= powerpc_caches.icache_block_bytes;
+	u32 d_per_page	= powerpc_caches.dcache_blocks_per_page;
+	u32 i_per_page	= powerpc_caches.icache_blocks_per_page;
+
+	/* Temporary registers for the ASM to use */
+	unsigned long old_msr, tmp_msr, d_phys_page, i_phys_page;
+
+	if (cpu_has_feature(CPU_FTR_COHERENT_ICACHE))
+		return;
+
+	/* Page base address (used in 2 different loops) */
+	d_phys_page = i_phys_page = phys_page & ~(PAGE_SIZE - 1);
+
+	/*
+	 * This part needs to be 100% ASM because we disable the MMU, and we
+	 * can't accidentally let some C code go poking at memory while the
+	 * MMU isn't enabled.
+	 *
+	 * NOTE: This looks blatantly unsafe with respect to interrupts.
+	 *       Hopefully all the callers provide sufficient protection?
+	 */
+	asm volatile(
+		/* First disable the MMU */
+		"mfmsr %[old_msr]\n\t"
+		"rlwinm %[tmp_msr], %[old_msr], 0, 28, 26\n\t"
+		"mtmsr %[tmp_msr]\n\t"
+		"isync\n\t"
+
+		/* Clean the data cache */
+		"mtctr %[d_per_page]\n"
+	"0:	dcbst 0, %[d_phys_page]\n\t"
+		"add %[d_phys_page], %[d_phys_page], %[d_size]\n\t"
+		"bdnz 0b\n\t"
+		"sync\n\t"
+
+		/* Invalidate the instruction cache */
+		"mtctr %[i_per_page]\n"
+	"0:	icbi 0, %[i_phys_page]\n\t"
+		"add %[i_phys_page], %[i_phys_page], %[i_size]\n\t"
+		"bdnz 0b\n\t"
+
+		/* Finally, re-enable the MMU */
+		"sync\n\t"
+		"mtmsr %[old_msr]\n\t"
+		"isync\n\t"
+
+		/* Temporary variables and inputs */
+		: [old_msr]    "=&r" (old_msr),
+		  [tmp_msr]    "=&r" (tmp_msr),
+		  [d_phys_page] "=b" (d_phys_page),
+		  [i_phys_page] "=b" (i_phys_page)
+
+		/* Inputs */
+		: [d_size]     "b" (d_size),
+		  [i_size]     "b" (i_size),
+		  [d_per_page] "b" (d_per_page),
+		  [i_per_page] "b" (i_per_page),
+		  "[d_phys_page]"  (d_phys_page),
+		  "[i_phys_page]"  (i_phys_page)
+
+		/* Clobbers */
+		: "memory", "c"
+	);
+}
+#endif /* CONFIG_PPC32 && !CONFIG_BOOKE */
+
+#ifdef CONFIG_PPC64
+/*
+ * Data cache flush that works on non-mapped physical addresses.
+ * Use only for non-LPAR setups ! It also assumes real mode
+ * is cacheable. Used for flushing out the DART before using
+ * it as uncacheable memory 
+ */
+void flush_dcache_phys_range(unsigned long start, unsigned long stop)
+{
+	/* System data cache block size */
+	unsigned long bytes = powerpc_caches.dcache_block_bytes;
+	unsigned long shift = powerpc_caches.dcache_block_shift;
+
+	/* Temporary registers for the ASM to use */
+	unsigned long old_msr, tmp_msr;
+
+	/* Compute a start address and number of cachelines */
+	unsigned long phys_addr = start & ~(bytes - 1);
+	unsigned long nr_lines = ((stop - phys_addr) + (bytes - 1)) >> shift;
+
+	/*
+	 * This part needs to be 100% ASM because we disable the MMU, and we
+	 * can't accidentally let some C code go poking at memory while the
+	 * MMU isn't enabled.
+	 *
+	 * NOTE: This looks blatantly unsafe with respect to interrupts.
+	 *       Hopefully all the callers provide sufficient protection?
+	 */
+	asm volatile(
+		/* First disable the MMU */
+		"mfmsr %[old_msr]\n\t"
+		"rlwinm %[tmp_msr], %[old_msr], 0, 28, 26\n\t"
+		"mtmsr %[tmp_msr]\n\t"
+		"isync\n\t"
+
+		/* Clean the data cache */
+		"mtctr %[nr_lines]\n"
+	"0:	dcbst 0, %[phys_addr]\n\t"
+		"add %[phys_addr], %[phys_addr], %[bytes]\n\t"
+		"bdnz 0b\n\t"
+		"sync\n\t"
+		"isync\n\t"
+
+		/* Finally, re-enable the MMU */
+		"mtmsr %[old_msr]\n\t"
+		"sync\n\t"
+		"isync\n\t"
+
+		/* Temporary variables and inputs */
+		: [old_msr]  "=&r" (old_msr),
+		  [tmp_msr]  "=&r" (tmp_msr),
+		  [phys_addr] "=b" (phys_addr)
+
+		/* Inputs */
+		: [bytes]    "b" (bytes),
+		  [nr_lines] "b" (nr_lines),
+		  "[phys_addr]"  (phys_addr)
+
+		/* Clobbers */
+		: "memory", "c"
+	);
+}
+#endif /* CONFIG_PPC64 */
diff --git a/arch/powerpc/mm/dma-noncoherent.c b/arch/powerpc/mm/dma-noncoherent.c
index 329be36..3823f64 100644
--- a/arch/powerpc/mm/dma-noncoherent.c
+++ b/arch/powerpc/mm/dma-noncoherent.c
@@ -328,7 +328,7 @@ void __dma_sync(void *vaddr, size_t size, int direction)
 		 * invalidate only when cache-line aligned otherwise there is
 		 * the potential for discarding uncommitted data from the cache
 		 */
-		if ((start & (L1_CACHE_BYTES - 1)) || (size & (L1_CACHE_BYTES - 1)))
+		if ((start | size) & (powerpc_caches.dcache_block_bytes - 1))
 			flush_dcache_range(start, end);
 		else
 			invalidate_dcache_range(start, end);
diff --git a/arch/powerpc/platforms/52xx/lite5200_sleep.S b/arch/powerpc/platforms/52xx/lite5200_sleep.S
index 08ab6fe..ac285d9 100644
--- a/arch/powerpc/platforms/52xx/lite5200_sleep.S
+++ b/arch/powerpc/platforms/52xx/lite5200_sleep.S
@@ -394,11 +394,16 @@ restore_regs:
 
 
 /* cache flushing code. copied from arch/ppc/boot/util.S */
-#define NUM_CACHE_LINES (128*8)
+#define NUM_CACHE_LINES ((128 * 8) << (L1_CACHE_SHIFT_MAX - L1_CACHE_SHIFT_MIN))
 
 /*
  * Flush data cache
  * Do this by just reading lots of stuff into the cache.
+ *
+ * NOTE: This does not handle variable-sized cachelines properly, but since
+ *       we are just trying to flush the data cache by reading lots of data,
+ *       this works anyways.  We just make sure we read as many cachelines
+ *       as we could possibly need to overflow the cache on any hardware.
  */
 flush_data_cache:
 	lis	r3,CONFIG_KERNEL_START@h
@@ -407,6 +412,6 @@ flush_data_cache:
 	mtctr	r4
 1:
 	lwz	r4,0(r3)
-	addi	r3,r3,L1_CACHE_BYTES	/* Next line, please */
+	addi	r3,r3,L1_CACHE_BYTES_MIN /* Next line, please */
 	bdnz	1b
 	blr
diff --git a/arch/powerpc/platforms/powermac/pci.c b/arch/powerpc/platforms/powermac/pci.c
index 31a7d3a..8503e38 100644
--- a/arch/powerpc/platforms/powermac/pci.c
+++ b/arch/powerpc/platforms/powermac/pci.c
@@ -1135,7 +1135,7 @@ int pmac_pci_enable_device_hook(struct pci_dev *dev)
 		pci_write_config_byte(dev, PCI_LATENCY_TIMER, 16);
 
 		pci_write_config_byte(dev, PCI_CACHE_LINE_SIZE,
-				      L1_CACHE_BYTES >> 2);
+				powerpc_caches.dcache_block_bytes >> 2);
 	}
 
 	return 0;
diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index 03a217a..c537d49 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -26,6 +26,7 @@
 
 #include <asm/ptrace.h>
 #include <asm/string.h>
+#include <asm/cache.h>
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/xmon.h>
@@ -254,16 +255,6 @@ static inline void store_inst(void *p)
 	asm volatile ("dcbst 0,%0; sync; icbi 0,%0; isync" : : "r" (p));
 }
 
-static inline void cflush(void *p)
-{
-	asm volatile ("dcbf 0,%0; icbi 0,%0" : : "r" (p));
-}
-
-static inline void cinval(void *p)
-{
-	asm volatile ("dcbi 0,%0; icbi 0,%0" : : "r" (p));
-}
-
 /*
  * Disable surveillance (the service processor watchdog function)
  * while we are in xmon.
@@ -1513,10 +1504,9 @@ static void prregs(struct pt_regs *fp)
 
 static void cacheflush(void)
 {
-	int cmd;
-	unsigned long nflush;
+	unsigned long nflush, i;
 
-	cmd = inchar();
+	int cmd = inchar();
 	if (cmd != 'i')
 		termch = cmd;
 	scanhex((void *)&adrs);
@@ -1524,23 +1514,30 @@ static void cacheflush(void)
 		termch = 0;
 	nflush = 1;
 	scanhex(&nflush);
-	nflush = (nflush + L1_CACHE_BYTES - 1) / L1_CACHE_BYTES;
-	if (setjmp(bus_error_jmp) == 0) {
-		catch_memory_errors = 1;
-		sync();
 
-		if (cmd != 'i') {
-			for (; nflush > 0; --nflush, adrs += L1_CACHE_BYTES)
-				cflush((void *) adrs);
-		} else {
-			for (; nflush > 0; --nflush, adrs += L1_CACHE_BYTES)
-				cinval((void *) adrs);
-		}
-		sync();
-		/* wait a little while to see if we get a machine check */
-		__delay(200);
+	if (setjmp(bus_error_jmp) != 0) {
+		catch_memory_errors = 0;
+		return;
 	}
-	catch_memory_errors = 0;
+	catch_memory_errors = 1;
+	sync();
+
+	/* First flush/invalidate data caches */
+	if (cmd != 'i') {
+		FOR_EACH_CACHELINE(i, adrs, adrs + nflush, dcache)
+			dcbf(i);
+	} else {
+		FOR_EACH_CACHELINE(i, adrs, adrs + nflush, dcache)
+			dcbi(i);
+	}
+
+	/* Now invalidate instruction caches */
+	FOR_EACH_CACHELINE(i, adrs, adrs + nflush, icache)
+		icbi(i);
+
+	sync();
+	/* wait a little while to see if we get a machine check */
+	__delay(200);
 }
 
 static unsigned long
diff --git a/drivers/macintosh/smu.c b/drivers/macintosh/smu.c
index 116a49c..04ead15 100644
--- a/drivers/macintosh/smu.c
+++ b/drivers/macintosh/smu.c
@@ -136,7 +136,9 @@ static void smu_start_cmd(void)
 	/* Flush command and data to RAM */
 	faddr = (unsigned long)smu->cmd_buf;
 	fend = faddr + smu->cmd_buf->length + 2;
-	flush_inval_dcache_range(faddr, fend);
+	flush_dcache_range(faddr, fend);
+	mb();
+	isync();
 
 
 	/* We also disable NAP mode for the duration of the command
@@ -198,7 +200,9 @@ static irqreturn_t smu_db_intr(int irq, void *arg)
 		 * reply length (it's only 2 cache lines anyway)
 		 */
 		faddr = (unsigned long)smu->cmd_buf;
-		flush_inval_dcache_range(faddr, faddr + 256);
+		flush_dcache_range(faddr, faddr + 256);
+		mb();
+		isync();
 
 		/* Now check ack */
 		ack = (~cmd->cmd) & 0xff;
-- 
1.7.2.5

