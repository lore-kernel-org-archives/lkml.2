Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab1DANw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 09:52:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:38296 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab1DANw1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 09:52:27 -0400
Subject: Re: [PATCH 00/20] mm: Preemptibility -v10
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>
In-Reply-To: <20110401121258.211963744@chello.nl>
References: <20110401121258.211963744@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 01 Apr 2011 15:51:16 +0200
Message-ID: <1301665876.4859.683.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-01 at 14:12 +0200, Peter Zijlstra wrote:
> 
> Also provided is a rollup of these patches, which is used as a commit in the
> git tree referenced below. 

If only I'd actually added it ;-)

---
Subject: mm: mmu_gather rework
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri, 26 Nov 2010 15:38:51 +0100

Remove the first obstackle towards a fully preemptible mmu_gather.

The current scheme assumes mmu_gather is always done with preemption
disabled and uses per-cpu storage for the page batches. Change this to
try and allocate a page for batching and in case of failure, use a
small on-stack array to make some progress.

Preemptible mmu_gather is desired in general and usable once
i_mmap_lock becomes a mutex. Doing it before the mutex conversion
saves us from having to rework the code by moving the mmu_gather
bits inside the pte_lock.

Also avoid flushing the tlb batches from under the pte lock,
this is useful even without the i_mmap_lock conversion as it
significantly reduces pte lock hold times.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: David Miller <davem@davemloft.net>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Jeff Dike <jdike@addtoit.com>
Acked-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/alpha/mm/init.c                   |    2 -
 arch/arm/include/asm/tlb.h             |   53 ++++++++++++-----
 arch/arm/mm/mmu.c                      |    2 -
 arch/avr32/mm/init.c                   |    2 -
 arch/cris/mm/init.c                    |    2 -
 arch/frv/mm/init.c                     |    2 -
 arch/ia64/include/asm/tlb.h            |   66 +++++++++++++++-------
 arch/ia64/mm/init.c                    |    2 -
 arch/m32r/mm/init.c                    |    2 -
 arch/m68k/mm/init_mm.c                 |    2 -
 arch/microblaze/mm/init.c              |    2 -
 arch/mips/mm/init.c                    |    2 -
 arch/mn10300/mm/init.c                 |    2 -
 arch/parisc/mm/init.c                  |    2 -
 arch/powerpc/include/asm/pgalloc.h     |    4 +-
 arch/powerpc/include/asm/thread_info.h |    2 +
 arch/powerpc/include/asm/tlb.h         |   10 +++
 arch/powerpc/kernel/process.c          |   23 +++++++-
 arch/powerpc/mm/pgtable.c              |   14 +---
 arch/powerpc/mm/tlb_hash32.c           |    2 +-
 arch/powerpc/mm/tlb_hash64.c           |    6 +-
 arch/powerpc/mm/tlb_nohash.c           |    2 +-
 arch/s390/include/asm/tlb.h            |   62 ++++++++++++--------
 arch/s390/mm/pgtable.c                 |    1 -
 arch/score/mm/init.c                   |    2 -
 arch/sh/include/asm/tlb.h              |   28 ++++++----
 arch/sh/mm/init.c                      |    1 -
 arch/sparc/include/asm/pgalloc_64.h    |    3 +
 arch/sparc/include/asm/pgtable_64.h    |   15 ++++-
 arch/sparc/include/asm/tlb_64.h        |   91 ++----------------------------
 arch/sparc/include/asm/tlbflush_64.h   |   12 +++-
 arch/sparc/mm/init_32.c                |    2 -
 arch/sparc/mm/tlb.c                    |   43 ++++++++------
 arch/sparc/mm/tsb.c                    |   15 +++--
 arch/tile/mm/init.c                    |    2 -
 arch/um/include/asm/tlb.h              |   29 ++++------
 arch/um/kernel/smp.c                   |    3 -
 arch/unicore32/mm/mmu.c                |    2 -
 arch/x86/mm/init.c                     |    2 -
 arch/xtensa/mm/mmu.c                   |    2 -
 fs/exec.c                              |   10 ++--
 include/asm-generic/tlb.h              |   96 +++++++++++++++++++++++---------
 include/linux/mm.h                     |    2 +-
 mm/memory.c                            |   46 ++++++++--------
 mm/mmap.c                              |   18 +++---
 45 files changed, 364 insertions(+), 329 deletions(-)

diff --git a/arch/alpha/mm/init.c b/arch/alpha/mm/init.c
index 86425ab..69d0c57 100644
--- a/arch/alpha/mm/init.c
+++ b/arch/alpha/mm/init.c
@@ -32,8 +32,6 @@
 #include <asm/console.h>
 #include <asm/tlb.h>
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 extern void die_if_kernel(char *,struct pt_regs *,long);
 
 static struct pcb_struct original_pcb;
diff --git a/arch/arm/include/asm/tlb.h b/arch/arm/include/asm/tlb.h
index 82dfe5d..265f908 100644
--- a/arch/arm/include/asm/tlb.h
+++ b/arch/arm/include/asm/tlb.h
@@ -41,12 +41,12 @@
  */
 #if defined(CONFIG_SMP) || defined(CONFIG_CPU_32v7)
 #define tlb_fast_mode(tlb)	0
-#define FREE_PTE_NR		500
 #else
 #define tlb_fast_mode(tlb)	1
-#define FREE_PTE_NR		0
 #endif
 
+#define MMU_GATHER_BUNDLE	8
+
 /*
  * TLB handling.  This allows us to remove pages from the page
  * tables, and efficiently handle the TLB issues.
@@ -58,7 +58,9 @@ struct mmu_gather {
 	unsigned long		range_start;
 	unsigned long		range_end;
 	unsigned int		nr;
-	struct page		*pages[FREE_PTE_NR];
+	unsigned int		max;
+	struct page		**pages;
+	struct page		*local[MMU_GATHER_BUNDLE];
 };
 
 DECLARE_PER_CPU(struct mmu_gather, mmu_gathers);
@@ -97,26 +99,37 @@ static inline void tlb_add_flush(struct mmu_gather *tlb, unsigned long addr)
 	}
 }
 
+static inline void __tlb_alloc_page(struct mmu_gather *tlb)
+{
+	unsigned long addr = __get_free_pages(GFP_NOWAIT | __GFP_NOWARN, 0);
+
+	if (addr) {
+		tlb->pages = (void *)addr;
+		tlb->max = PAGE_SIZE / sizeof(struct page *);
+	}
+}
+
 static inline void tlb_flush_mmu(struct mmu_gather *tlb)
 {
 	tlb_flush(tlb);
 	if (!tlb_fast_mode(tlb)) {
 		free_pages_and_swap_cache(tlb->pages, tlb->nr);
 		tlb->nr = 0;
+		if (tlb->pages == tlb->local)
+			__tlb_alloc_page(tlb);
 	}
 }
 
-static inline struct mmu_gather *
-tlb_gather_mmu(struct mm_struct *mm, unsigned int full_mm_flush)
+static inline void
+tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, bool fullmm)
 {
-	struct mmu_gather *tlb = &get_cpu_var(mmu_gathers);
-
 	tlb->mm = mm;
-	tlb->fullmm = full_mm_flush;
+	tlb->fullmm = fullmm;
 	tlb->vma = NULL;
+	tlb->max = ARRAY_SIZE(tlb->local);
+	tlb->pages = tlb->local;
 	tlb->nr = 0;
-
-	return tlb;
+	__tlb_alloc_page(tlb);
 }
 
 static inline void
@@ -127,7 +140,8 @@ tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
 	/* keep the page table cache within bounds */
 	check_pgt_cache();
 
-	put_cpu_var(mmu_gathers);
+	if (tlb->pages != tlb->local)
+		free_pages((unsigned long)tlb->pages, 0);
 }
 
 /*
@@ -162,15 +176,22 @@ tlb_end_vma(struct mmu_gather *tlb, struct vm_area_struct *vma)
 		tlb_flush(tlb);
 }
 
-static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
+static inline int __tlb_remove_page(struct mmu_gather *tlb, struct page *page)
 {
 	if (tlb_fast_mode(tlb)) {
 		free_page_and_swap_cache(page);
-	} else {
-		tlb->pages[tlb->nr++] = page;
-		if (tlb->nr >= FREE_PTE_NR)
-			tlb_flush_mmu(tlb);
+		return 1; /* avoid calling tlb_flush_mmu */
 	}
+
+	tlb->pages[tlb->nr++] = page;
+	VM_BUG_ON(tlb->nr > tlb->max);
+	return tlb->max - tlb->nr;
+}
+
+static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
+{
+	if (!__tlb_remove_page(tlb, page))
+		tlb_flush_mmu(tlb);
 }
 
 static inline void __pte_free_tlb(struct mmu_gather *tlb, pgtable_t pte,
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 6cf76b3..08a9236 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -31,8 +31,6 @@
 
 #include "mm.h"
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 /*
  * empty_zero_page is a special page that is used for
  * zero-initialized data and COW.
diff --git a/arch/avr32/mm/init.c b/arch/avr32/mm/init.c
index a7314d4..2798c2d 100644
--- a/arch/avr32/mm/init.c
+++ b/arch/avr32/mm/init.c
@@ -25,8 +25,6 @@
 #include <asm/setup.h>
 #include <asm/sections.h>
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 pgd_t swapper_pg_dir[PTRS_PER_PGD] __page_aligned_data;
 
 struct page *empty_zero_page;
diff --git a/arch/cris/mm/init.c b/arch/cris/mm/init.c
index df33ab8..d72ab58 100644
--- a/arch/cris/mm/init.c
+++ b/arch/cris/mm/init.c
@@ -13,8 +13,6 @@
 #include <linux/bootmem.h>
 #include <asm/tlb.h>
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 unsigned long empty_zero_page;
 
 extern char _stext, _edata, _etext; /* From linkerscript */
diff --git a/arch/frv/mm/init.c b/arch/frv/mm/init.c
index ed64588..fbe5f0d 100644
--- a/arch/frv/mm/init.c
+++ b/arch/frv/mm/init.c
@@ -41,8 +41,6 @@
 
 #undef DEBUG
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 /*
  * BAD_PAGE is the page that is used for page faults when linux
  * is out-of-memory. Older versions of linux just did a
diff --git a/arch/ia64/include/asm/tlb.h b/arch/ia64/include/asm/tlb.h
index 23cce99..c3ffe3e 100644
--- a/arch/ia64/include/asm/tlb.h
+++ b/arch/ia64/include/asm/tlb.h
@@ -47,21 +47,27 @@
 #include <asm/machvec.h>
 
 #ifdef CONFIG_SMP
-# define FREE_PTE_NR		2048
 # define tlb_fast_mode(tlb)	((tlb)->nr == ~0U)
 #else
-# define FREE_PTE_NR		0
 # define tlb_fast_mode(tlb)	(1)
 #endif
 
+/*
+ * If we can't allocate a page to make a big batch of page pointers
+ * to work on, then just handle a few from the on-stack structure.
+ */
+#define	IA64_GATHER_BUNDLE	8
+
 struct mmu_gather {
 	struct mm_struct	*mm;
 	unsigned int		nr;		/* == ~0U => fast mode */
+	unsigned int		max;
 	unsigned char		fullmm;		/* non-zero means full mm flush */
 	unsigned char		need_flush;	/* really unmapped some PTEs? */
 	unsigned long		start_addr;
 	unsigned long		end_addr;
-	struct page 		*pages[FREE_PTE_NR];
+	struct page		**pages;
+	struct page		*local[IA64_GATHER_BUNDLE];
 };
 
 struct ia64_tr_entry {
@@ -90,9 +96,6 @@ extern struct ia64_tr_entry *ia64_idtrs[NR_CPUS];
 #define RR_RID_MASK	0x00000000ffffff00L
 #define RR_TO_RID(val) 	((val >> 8) & 0xffffff)
 
-/* Users of the generic TLB shootdown code must declare this storage space. */
-DECLARE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 /*
  * Flush the TLB for address range START to END and, if not in fast mode, release the
  * freed pages that where gathered up to this point.
@@ -147,15 +150,23 @@ ia64_tlb_flush_mmu (struct mmu_gather *tlb, unsigned long start, unsigned long e
 	}
 }
 
-/*
- * Return a pointer to an initialized struct mmu_gather.
- */
-static inline struct mmu_gather *
-tlb_gather_mmu (struct mm_struct *mm, unsigned int full_mm_flush)
+static inline void __tlb_alloc_page(struct mmu_gather *tlb)
 {
-	struct mmu_gather *tlb = &get_cpu_var(mmu_gathers);
+	unsigned long addr = __get_free_pages(GFP_NOWAIT | __GFP_NOWARN, 0);
 
+	if (addr) {
+		tlb->pages = (void *)addr;
+		tlb->max = PAGE_SIZE / sizeof(void *);
+	}
+}
+
+
+static inline void
+tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned int full_mm_flush)
+{
 	tlb->mm = mm;
+	tlb->max = ARRAY_SIZE(tlb->local);
+	tlb->pages = tlb->local;
 	/*
 	 * Use fast mode if only 1 CPU is online.
 	 *
@@ -172,7 +183,6 @@ tlb_gather_mmu (struct mm_struct *mm, unsigned int full_mm_flush)
 	tlb->nr = (num_online_cpus() == 1) ? ~0U : 0;
 	tlb->fullmm = full_mm_flush;
 	tlb->start_addr = ~0UL;
-	return tlb;
 }
 
 /*
@@ -180,7 +190,7 @@ tlb_gather_mmu (struct mm_struct *mm, unsigned int full_mm_flush)
  * collected.
  */
 static inline void
-tlb_finish_mmu (struct mmu_gather *tlb, unsigned long start, unsigned long end)
+tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
 {
 	/*
 	 * Note: tlb->nr may be 0 at this point, so we can't rely on tlb->start_addr and
@@ -191,7 +201,8 @@ tlb_finish_mmu (struct mmu_gather *tlb, unsigned long start, unsigned long end)
 	/* keep the page table cache within bounds */
 	check_pgt_cache();
 
-	put_cpu_var(mmu_gathers);
+	if (tlb->pages != tlb->local)
+		free_pages((unsigned long)tlb->pages, 0);
 }
 
 /*
@@ -199,18 +210,33 @@ tlb_finish_mmu (struct mmu_gather *tlb, unsigned long start, unsigned long end)
  * must be delayed until after the TLB has been flushed (see comments at the beginning of
  * this file).
  */
-static inline void
-tlb_remove_page (struct mmu_gather *tlb, struct page *page)
+static inline int __tlb_remove_page(struct mmu_gather *tlb, struct page *page)
 {
 	tlb->need_flush = 1;
 
 	if (tlb_fast_mode(tlb)) {
 		free_page_and_swap_cache(page);
-		return;
+		return 1; /* avoid calling tlb_flush_mmu */
 	}
+
+	if (!tlb->nr && tlb->pages == tlb->local)
+		__tlb_alloc_page(tlb);
+
 	tlb->pages[tlb->nr++] = page;
-	if (tlb->nr >= FREE_PTE_NR)
-		ia64_tlb_flush_mmu(tlb, tlb->start_addr, tlb->end_addr);
+	VM_BUG_ON(tlb->nr > tlb->max);
+
+	return tlb->max - tlb->nr;
+}
+
+static inline void tlb_flush_mmu(struct mmu_gather *tlb)
+{
+	ia64_tlb_flush_mmu(tlb, tlb->start_addr, tlb->end_addr);
+}
+
+static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
+{
+	if (!__tlb_remove_page(tlb, page))
+		tlb_flush_mmu(tlb);
 }
 
 /*
diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index ed41759..00cb0e2 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -36,8 +36,6 @@
 #include <asm/mca.h>
 #include <asm/paravirt.h>
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 extern void ia64_tlb_init (void);
 
 unsigned long MAX_DMA_ADDRESS = PAGE_OFFSET + 0x100000000UL;
diff --git a/arch/m32r/mm/init.c b/arch/m32r/mm/init.c
index 73e2205..78b660e 100644
--- a/arch/m32r/mm/init.c
+++ b/arch/m32r/mm/init.c
@@ -35,8 +35,6 @@ extern char __init_begin, __init_end;
 
 pgd_t swapper_pg_dir[1024];
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 /*
  * Cache of MMU context last used.
  */
diff --git a/arch/m68k/mm/init_mm.c b/arch/m68k/mm/init_mm.c
index 8bc8425..9113c2f 100644
--- a/arch/m68k/mm/init_mm.c
+++ b/arch/m68k/mm/init_mm.c
@@ -32,8 +32,6 @@
 #include <asm/sections.h>
 #include <asm/tlb.h>
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 pg_data_t pg_data_map[MAX_NUMNODES];
 EXPORT_SYMBOL(pg_data_map);
 
diff --git a/arch/microblaze/mm/init.c b/arch/microblaze/mm/init.c
index c843786..213f2d6 100644
--- a/arch/microblaze/mm/init.c
+++ b/arch/microblaze/mm/init.c
@@ -32,8 +32,6 @@ unsigned int __page_offset;
 EXPORT_SYMBOL(__page_offset);
 
 #else
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 static int init_bootmem_done;
 #endif /* CONFIG_MMU */
 
diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index 279599e..1aadeb4 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -64,8 +64,6 @@
 
 #endif /* CONFIG_MIPS_MT_SMTC */
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 /*
  * We have up to 8 empty zeroed pages so we can map one of the right colour
  * when needed.  This is necessary only on R4000 / R4400 SC and MC versions
diff --git a/arch/mn10300/mm/init.c b/arch/mn10300/mm/init.c
index 48907cc..1380182 100644
--- a/arch/mn10300/mm/init.c
+++ b/arch/mn10300/mm/init.c
@@ -37,8 +37,6 @@
 #include <asm/tlb.h>
 #include <asm/sections.h>
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 unsigned long highstart_pfn, highend_pfn;
 
 #ifdef CONFIG_MN10300_HAS_ATOMIC_OPS_UNIT
diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
index b7ed8d7..102f872 100644
--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -31,8 +31,6 @@
 #include <asm/mmzone.h>
 #include <asm/sections.h>
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 extern int  data_start;
 
 #ifdef CONFIG_DISCONTIGMEM
diff --git a/arch/powerpc/include/asm/pgalloc.h b/arch/powerpc/include/asm/pgalloc.h
index abe8532..df1b4cb 100644
--- a/arch/powerpc/include/asm/pgalloc.h
+++ b/arch/powerpc/include/asm/pgalloc.h
@@ -32,13 +32,13 @@ static inline void pte_free(struct mm_struct *mm, pgtable_t ptepage)
 
 #ifdef CONFIG_SMP
 extern void pgtable_free_tlb(struct mmu_gather *tlb, void *table, unsigned shift);
-extern void pte_free_finish(void);
+extern void pte_free_finish(struct mmu_gather *tlb);
 #else /* CONFIG_SMP */
 static inline void pgtable_free_tlb(struct mmu_gather *tlb, void *table, unsigned shift)
 {
 	pgtable_free(table, shift);
 }
-static inline void pte_free_finish(void) { }
+static inline void pte_free_finish(struct mmu_gather *tlb) { }
 #endif /* !CONFIG_SMP */
 
 static inline void __pte_free_tlb(struct mmu_gather *tlb, struct page *ptepage,
diff --git a/arch/powerpc/include/asm/thread_info.h b/arch/powerpc/include/asm/thread_info.h
index d8529ef..37c353e 100644
--- a/arch/powerpc/include/asm/thread_info.h
+++ b/arch/powerpc/include/asm/thread_info.h
@@ -139,10 +139,12 @@ static inline struct thread_info *current_thread_info(void)
 #define TLF_NAPPING		0	/* idle thread enabled NAP mode */
 #define TLF_SLEEPING		1	/* suspend code enabled SLEEP mode */
 #define TLF_RESTORE_SIGMASK	2	/* Restore signal mask in do_signal */
+#define TLF_LAZY_MMU		3	/* tlb_batch is active */
 
 #define _TLF_NAPPING		(1 << TLF_NAPPING)
 #define _TLF_SLEEPING		(1 << TLF_SLEEPING)
 #define _TLF_RESTORE_SIGMASK	(1 << TLF_RESTORE_SIGMASK)
+#define _TLF_LAZY_MMU		(1 << TLF_LAZY_MMU)
 
 #ifndef __ASSEMBLY__
 #define HAVE_SET_RESTORE_SIGMASK	1
diff --git a/arch/powerpc/include/asm/tlb.h b/arch/powerpc/include/asm/tlb.h
index e2b428b..8f0ed7a 100644
--- a/arch/powerpc/include/asm/tlb.h
+++ b/arch/powerpc/include/asm/tlb.h
@@ -28,6 +28,16 @@
 #define tlb_start_vma(tlb, vma)	do { } while (0)
 #define tlb_end_vma(tlb, vma)	do { } while (0)
 
+#define HAVE_ARCH_MMU_GATHER 1
+
+struct pte_freelist_batch;
+
+struct arch_mmu_gather {
+	struct pte_freelist_batch *batch;
+};
+
+#define ARCH_MMU_GATHER_INIT (struct arch_mmu_gather){ .batch = NULL, }
+
 extern void tlb_flush(struct mmu_gather *tlb);
 
 /* Get the generic bits... */
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index f74f355..3e37f37 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -395,6 +395,9 @@ struct task_struct *__switch_to(struct task_struct *prev,
 	struct thread_struct *new_thread, *old_thread;
 	unsigned long flags;
 	struct task_struct *last;
+#ifdef CONFIG_PPC_BOOK3S_64
+	struct ppc64_tlb_batch *batch;
+#endif
 
 #ifdef CONFIG_SMP
 	/* avoid complexity of lazy save/restore of fpu
@@ -513,7 +516,17 @@ struct task_struct *__switch_to(struct task_struct *prev,
 		old_thread->accum_tb += (current_tb - start_tb);
 		new_thread->start_tb = current_tb;
 	}
-#endif
+#endif /* CONFIG_PPC64 */
+
+#ifdef CONFIG_PPC_BOOK3S_64
+	batch = &__get_cpu_var(ppc64_tlb_batch);
+	if (batch->active) {
+		current_thread_info()->local_flags |= _TLF_LAZY_MMU;
+		if (batch->index)
+			__flush_tlb_pending(batch);
+		batch->active = 0;
+	}
+#endif /* CONFIG_PPC_BOOK3S_64 */
 
 	local_irq_save(flags);
 
@@ -528,6 +541,14 @@ struct task_struct *__switch_to(struct task_struct *prev,
 	hard_irq_disable();
 	last = _switch(old_thread, new_thread);
 
+#ifdef CONFIG_PPC_BOOK3S_64
+	if (current_thread_info()->local_flags & _TLF_LAZY_MMU) {
+		current_thread_info()->local_flags &= ~_TLF_LAZY_MMU;
+		batch = &__get_cpu_var(ppc64_tlb_batch);
+		batch->active = 1;
+	}
+#endif /* CONFIG_PPC_BOOK3S_64 */
+
 	local_irq_restore(flags);
 
 	return last;
diff --git a/arch/powerpc/mm/pgtable.c b/arch/powerpc/mm/pgtable.c
index 6a3997f..6e72788 100644
--- a/arch/powerpc/mm/pgtable.c
+++ b/arch/powerpc/mm/pgtable.c
@@ -33,8 +33,6 @@
 
 #include "mmu_decl.h"
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 #ifdef CONFIG_SMP
 
 /*
@@ -43,7 +41,6 @@ DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
  * freeing a page table page that is being walked without locks
  */
 
-static DEFINE_PER_CPU(struct pte_freelist_batch *, pte_freelist_cur);
 static unsigned long pte_freelist_forced_free;
 
 struct pte_freelist_batch
@@ -97,12 +94,10 @@ static void pte_free_submit(struct pte_freelist_batch *batch)
 
 void pgtable_free_tlb(struct mmu_gather *tlb, void *table, unsigned shift)
 {
-	/* This is safe since tlb_gather_mmu has disabled preemption */
-	struct pte_freelist_batch **batchp = &__get_cpu_var(pte_freelist_cur);
+	struct pte_freelist_batch **batchp = &tlb->arch.batch;
 	unsigned long pgf;
 
-	if (atomic_read(&tlb->mm->mm_users) < 2 ||
-	    cpumask_equal(mm_cpumask(tlb->mm), cpumask_of(smp_processor_id()))){
+	if (atomic_read(&tlb->mm->mm_users) < 2) {
 		pgtable_free(table, shift);
 		return;
 	}
@@ -124,10 +119,9 @@ void pgtable_free_tlb(struct mmu_gather *tlb, void *table, unsigned shift)
 	}
 }
 
-void pte_free_finish(void)
+void pte_free_finish(struct mmu_gather *tlb)
 {
-	/* This is safe since tlb_gather_mmu has disabled preemption */
-	struct pte_freelist_batch **batchp = &__get_cpu_var(pte_freelist_cur);
+	struct pte_freelist_batch **batchp = &tlb->arch.batch;
 
 	if (*batchp == NULL)
 		return;
diff --git a/arch/powerpc/mm/tlb_hash32.c b/arch/powerpc/mm/tlb_hash32.c
index 690566b..d555cdb 100644
--- a/arch/powerpc/mm/tlb_hash32.c
+++ b/arch/powerpc/mm/tlb_hash32.c
@@ -73,7 +73,7 @@ void tlb_flush(struct mmu_gather *tlb)
 	}
 
 	/* Push out batch of freed page tables */
-	pte_free_finish();
+	pte_free_finish(tlb);
 }
 
 /*
diff --git a/arch/powerpc/mm/tlb_hash64.c b/arch/powerpc/mm/tlb_hash64.c
index c14d09f..5c94ca3 100644
--- a/arch/powerpc/mm/tlb_hash64.c
+++ b/arch/powerpc/mm/tlb_hash64.c
@@ -155,7 +155,7 @@ void __flush_tlb_pending(struct ppc64_tlb_batch *batch)
 
 void tlb_flush(struct mmu_gather *tlb)
 {
-	struct ppc64_tlb_batch *tlbbatch = &__get_cpu_var(ppc64_tlb_batch);
+	struct ppc64_tlb_batch *tlbbatch = &get_cpu_var(ppc64_tlb_batch);
 
 	/* If there's a TLB batch pending, then we must flush it because the
 	 * pages are going to be freed and we really don't want to have a CPU
@@ -164,8 +164,10 @@ void tlb_flush(struct mmu_gather *tlb)
 	if (tlbbatch->index)
 		__flush_tlb_pending(tlbbatch);
 
+	put_cpu_var(ppc64_tlb_batch);
+
 	/* Push out batch of freed page tables */
-	pte_free_finish();
+	pte_free_finish(tlb);
 }
 
 /**
diff --git a/arch/powerpc/mm/tlb_nohash.c b/arch/powerpc/mm/tlb_nohash.c
index 2a030d8..8eaf67d 100644
--- a/arch/powerpc/mm/tlb_nohash.c
+++ b/arch/powerpc/mm/tlb_nohash.c
@@ -301,7 +301,7 @@ void tlb_flush(struct mmu_gather *tlb)
 	flush_tlb_mm(tlb->mm);
 
 	/* Push out batch of freed page tables */
-	pte_free_finish();
+	pte_free_finish(tlb);
 }
 
 /*
diff --git a/arch/s390/include/asm/tlb.h b/arch/s390/include/asm/tlb.h
index 9074a54..77eee54 100644
--- a/arch/s390/include/asm/tlb.h
+++ b/arch/s390/include/asm/tlb.h
@@ -29,65 +29,77 @@
 #include <asm/smp.h>
 #include <asm/tlbflush.h>
 
-#ifndef CONFIG_SMP
-#define TLB_NR_PTRS	1
-#else
-#define TLB_NR_PTRS	508
-#endif
-
 struct mmu_gather {
 	struct mm_struct *mm;
 	unsigned int fullmm;
 	unsigned int nr_ptes;
 	unsigned int nr_pxds;
-	void *array[TLB_NR_PTRS];
+	unsigned int max;
+	void **array;
+	void *local[8];
 };
 
-DECLARE_PER_CPU(struct mmu_gather, mmu_gathers);
-
-static inline struct mmu_gather *tlb_gather_mmu(struct mm_struct *mm,
-						unsigned int full_mm_flush)
+static inline void __tlb_alloc_page(struct mmu_gather *tlb)
 {
-	struct mmu_gather *tlb = &get_cpu_var(mmu_gathers);
+	unsigned long addr = __get_free_pages(GFP_NOWAIT | __GFP_NOWARN, 0);
 
+	if (addr) {
+		tlb->array = (void *) addr;
+		tlb->max = PAGE_SIZE / sizeof(void *);
+	}
+}
+
+static inline void tlb_gather_mmu(struct mmu_gather *tlb,
+				  struct mm_struct *mm,
+				  unsigned int full_mm_flush)
+{
 	tlb->mm = mm;
+	tlb->max = ARRAY_SIZE(tlb->local);
+	tlb->array = tlb->local;
 	tlb->fullmm = full_mm_flush;
-	tlb->nr_ptes = 0;
-	tlb->nr_pxds = TLB_NR_PTRS;
 	if (tlb->fullmm)
 		__tlb_flush_mm(mm);
-	return tlb;
+	else
+		__tlb_alloc_page(tlb);
+	tlb->nr_ptes = 0;
+	tlb->nr_pxds = tlb->max;
 }
 
-static inline void tlb_flush_mmu(struct mmu_gather *tlb,
-				 unsigned long start, unsigned long end)
+static inline void tlb_flush_mmu(struct mmu_gather *tlb)
 {
-	if (!tlb->fullmm && (tlb->nr_ptes > 0 || tlb->nr_pxds < TLB_NR_PTRS))
+	if (!tlb->fullmm && (tlb->nr_ptes > 0 || tlb->nr_pxds < tlb->max))
 		__tlb_flush_mm(tlb->mm);
 	while (tlb->nr_ptes > 0)
 		page_table_free_rcu(tlb->mm, tlb->array[--tlb->nr_ptes]);
-	while (tlb->nr_pxds < TLB_NR_PTRS)
+	while (tlb->nr_pxds < tlb->max)
 		crst_table_free_rcu(tlb->mm, tlb->array[tlb->nr_pxds++]);
 }
 
 static inline void tlb_finish_mmu(struct mmu_gather *tlb,
 				  unsigned long start, unsigned long end)
 {
-	tlb_flush_mmu(tlb, start, end);
+	tlb_flush_mmu(tlb);
 
 	rcu_table_freelist_finish();
 
 	/* keep the page table cache within bounds */
 	check_pgt_cache();
 
-	put_cpu_var(mmu_gathers);
+	if (tlb->array != tlb->local)
+		free_pages((unsigned long) tlb->array, 0);
 }
 
 /*
  * Release the page cache reference for a pte removed by
- * tlb_ptep_clear_flush. In both flush modes the tlb fo a page cache page
+ * tlb_ptep_clear_flush. In both flush modes the tlb for a page cache page
  * has already been freed, so just do free_page_and_swap_cache.
  */
+static inline int __tlb_remove_page(struct mmu_gather *tlb, struct page *page)
+{
+	free_page_and_swap_cache(page);
+	return 1; /* avoid calling tlb_flush_mmu */
+}
+
 static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
 {
 	free_page_and_swap_cache(page);
@@ -103,7 +115,7 @@ static inline void pte_free_tlb(struct mmu_gather *tlb, pgtable_t pte,
 	if (!tlb->fullmm) {
 		tlb->array[tlb->nr_ptes++] = pte;
 		if (tlb->nr_ptes >= tlb->nr_pxds)
-			tlb_flush_mmu(tlb, 0, 0);
+			tlb_flush_mmu(tlb);
 	} else
 		page_table_free(tlb->mm, (unsigned long *) pte);
 }
@@ -124,7 +136,7 @@ static inline void pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd,
 	if (!tlb->fullmm) {
 		tlb->array[--tlb->nr_pxds] = pmd;
 		if (tlb->nr_ptes >= tlb->nr_pxds)
-			tlb_flush_mmu(tlb, 0, 0);
+			tlb_flush_mmu(tlb);
 	} else
 		crst_table_free(tlb->mm, (unsigned long *) pmd);
 #endif
@@ -146,7 +158,7 @@ static inline void pud_free_tlb(struct mmu_gather *tlb, pud_t *pud,
 	if (!tlb->fullmm) {
 		tlb->array[--tlb->nr_pxds] = pud;
 		if (tlb->nr_ptes >= tlb->nr_pxds)
-			tlb_flush_mmu(tlb, 0, 0);
+			tlb_flush_mmu(tlb);
 	} else
 		crst_table_free(tlb->mm, (unsigned long *) pud);
 #endif
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index e1850c2..07fcc3f 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -36,7 +36,6 @@ struct rcu_table_freelist {
 	((PAGE_SIZE - sizeof(struct rcu_table_freelist)) \
 	  / sizeof(unsigned long))
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 static DEFINE_PER_CPU(struct rcu_table_freelist *, rcu_table_freelist);
 
 static void __page_table_free(struct mm_struct *mm, unsigned long *table);
diff --git a/arch/score/mm/init.c b/arch/score/mm/init.c
index 50fdec5..cee6bce 100644
--- a/arch/score/mm/init.c
+++ b/arch/score/mm/init.c
@@ -38,8 +38,6 @@
 #include <asm/sections.h>
 #include <asm/tlb.h>
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 unsigned long empty_zero_page;
 EXPORT_SYMBOL_GPL(empty_zero_page);
 
diff --git a/arch/sh/include/asm/tlb.h b/arch/sh/include/asm/tlb.h
index 75abb38..6c308d8 100644
--- a/arch/sh/include/asm/tlb.h
+++ b/arch/sh/include/asm/tlb.h
@@ -23,8 +23,6 @@ struct mmu_gather {
 	unsigned long		start, end;
 };
 
-DECLARE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 static inline void init_tlb_gather(struct mmu_gather *tlb)
 {
 	tlb->start = TASK_SIZE;
@@ -36,17 +34,13 @@ static inline void init_tlb_gather(struct mmu_gather *tlb)
 	}
 }
 
-static inline struct mmu_gather *
-tlb_gather_mmu(struct mm_struct *mm, unsigned int full_mm_flush)
+static inline void
+tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned int full_mm_flush)
 {
-	struct mmu_gather *tlb = &get_cpu_var(mmu_gathers);
-
 	tlb->mm = mm;
 	tlb->fullmm = full_mm_flush;
 
 	init_tlb_gather(tlb);
-
-	return tlb;
 }
 
 static inline void
@@ -57,8 +51,6 @@ tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
 
 	/* keep the page table cache within bounds */
 	check_pgt_cache();
-
-	put_cpu_var(mmu_gathers);
 }
 
 static inline void
@@ -91,7 +83,21 @@ tlb_end_vma(struct mmu_gather *tlb, struct vm_area_struct *vma)
 	}
 }
 
-#define tlb_remove_page(tlb,page)	free_page_and_swap_cache(page)
+static inline void tlb_flush_mmu(struct mmu_gather *tlb)
+{
+}
+
+static inline int __tlb_remove_page(struct mmu_gather *tlb, struct page *page)
+{
+	free_page_and_swap_cache(page);
+	return 1; /* avoid calling tlb_flush_mmu */
+}
+
+static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
+{
+	__tlb_remove_page(tlb, page);
+}
+
 #define pte_free_tlb(tlb, ptep, addr)	pte_free((tlb)->mm, ptep)
 #define pmd_free_tlb(tlb, pmdp, addr)	pmd_free((tlb)->mm, pmdp)
 #define pud_free_tlb(tlb, pudp, addr)	pud_free((tlb)->mm, pudp)
diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index 0d3f912..58a93fb3 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -28,7 +28,6 @@
 #include <asm/cache.h>
 #include <asm/sizes.h>
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 pgd_t swapper_pg_dir[PTRS_PER_PGD];
 
 void __init generic_mem_init(void)
diff --git a/arch/sparc/include/asm/pgalloc_64.h b/arch/sparc/include/asm/pgalloc_64.h
index 5bdfa2c..4e5e087 100644
--- a/arch/sparc/include/asm/pgalloc_64.h
+++ b/arch/sparc/include/asm/pgalloc_64.h
@@ -78,4 +78,7 @@ static inline void check_pgt_cache(void)
 	quicklist_trim(0, NULL, 25, 16);
 }
 
+#define __pte_free_tlb(tlb, pte, addr)	pte_free((tlb)->mm, pte)
+#define __pmd_free_tlb(tlb, pmd, addr)	pmd_free((tlb)->mm, pmd)
+
 #endif /* _SPARC64_PGALLOC_H */
diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index f8dddb7..b2e85bf 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -655,9 +655,11 @@ static inline int pte_special(pte_t pte)
 #define pte_unmap(pte)			do { } while (0)
 
 /* Actual page table PTE updates.  */
-extern void tlb_batch_add(struct mm_struct *mm, unsigned long vaddr, pte_t *ptep, pte_t orig);
+extern void tlb_batch_add(struct mm_struct *mm, unsigned long vaddr,
+			  pte_t *ptep, pte_t orig, int fullmm);
 
-static inline void set_pte_at(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte)
+static inline void __set_pte_at(struct mm_struct *mm, unsigned long addr,
+			     pte_t *ptep, pte_t pte, int fullmm)
 {
 	pte_t orig = *ptep;
 
@@ -670,12 +672,19 @@ static inline void set_pte_at(struct mm_struct *mm, unsigned long addr, pte_t *p
 	 *             and SUN4V pte layout, so this inline test is fine.
 	 */
 	if (likely(mm != &init_mm) && (pte_val(orig) & _PAGE_VALID))
-		tlb_batch_add(mm, addr, ptep, orig);
+		tlb_batch_add(mm, addr, ptep, orig, fullmm);
 }
 
+#define set_pte_at(mm,addr,ptep,pte)	\
+	__set_pte_at((mm), (addr), (ptep), (pte), 0)
+
 #define pte_clear(mm,addr,ptep)		\
 	set_pte_at((mm), (addr), (ptep), __pte(0UL))
 
+#define __HAVE_ARCH_PTE_CLEAR_NOT_PRESENT_FULL
+#define pte_clear_not_present_full(mm,addr,ptep,fullmm)	\
+	__set_pte_at((mm), (addr), (ptep), __pte(0UL), (fullmm))
+
 #ifdef DCACHE_ALIASING_POSSIBLE
 #define __HAVE_ARCH_MOVE_PTE
 #define move_pte(pte, prot, old_addr, new_addr)				\
diff --git a/arch/sparc/include/asm/tlb_64.h b/arch/sparc/include/asm/tlb_64.h
index dca406b..190e189 100644
--- a/arch/sparc/include/asm/tlb_64.h
+++ b/arch/sparc/include/asm/tlb_64.h
@@ -7,66 +7,11 @@
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 
-#define TLB_BATCH_NR	192
-
-/*
- * For UP we don't need to worry about TLB flush
- * and page free order so much..
- */
-#ifdef CONFIG_SMP
-  #define FREE_PTE_NR	506
-  #define tlb_fast_mode(bp) ((bp)->pages_nr == ~0U)
-#else
-  #define FREE_PTE_NR	1
-  #define tlb_fast_mode(bp) 1
-#endif
-
-struct mmu_gather {
-	struct mm_struct *mm;
-	unsigned int pages_nr;
-	unsigned int need_flush;
-	unsigned int fullmm;
-	unsigned int tlb_nr;
-	unsigned long vaddrs[TLB_BATCH_NR];
-	struct page *pages[FREE_PTE_NR];
-};
-
-DECLARE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 #ifdef CONFIG_SMP
 extern void smp_flush_tlb_pending(struct mm_struct *,
 				  unsigned long, unsigned long *);
 #endif
 
-extern void __flush_tlb_pending(unsigned long, unsigned long, unsigned long *);
-extern void flush_tlb_pending(void);
-
-static inline struct mmu_gather *tlb_gather_mmu(struct mm_struct *mm, unsigned int full_mm_flush)
-{
-	struct mmu_gather *mp = &get_cpu_var(mmu_gathers);
-
-	BUG_ON(mp->tlb_nr);
-
-	mp->mm = mm;
-	mp->pages_nr = num_online_cpus() > 1 ? 0U : ~0U;
-	mp->fullmm = full_mm_flush;
-
-	return mp;
-}
-
-
-static inline void tlb_flush_mmu(struct mmu_gather *mp)
-{
-	if (!mp->fullmm)
-		flush_tlb_pending();
-	if (mp->need_flush) {
-		free_pages_and_swap_cache(mp->pages, mp->pages_nr);
-		mp->pages_nr = 0;
-		mp->need_flush = 0;
-	}
-
-}
-
 #ifdef CONFIG_SMP
 extern void smp_flush_tlb_mm(struct mm_struct *mm);
 #define do_flush_tlb_mm(mm) smp_flush_tlb_mm(mm)
@@ -74,38 +19,14 @@ extern void smp_flush_tlb_mm(struct mm_struct *mm);
 #define do_flush_tlb_mm(mm) __flush_tlb_mm(CTX_HWBITS(mm->context), SECONDARY_CONTEXT)
 #endif
 
-static inline void tlb_finish_mmu(struct mmu_gather *mp, unsigned long start, unsigned long end)
-{
-	tlb_flush_mmu(mp);
-
-	if (mp->fullmm)
-		mp->fullmm = 0;
-
-	/* keep the page table cache within bounds */
-	check_pgt_cache();
-
-	put_cpu_var(mmu_gathers);
-}
-
-static inline void tlb_remove_page(struct mmu_gather *mp, struct page *page)
-{
-	if (tlb_fast_mode(mp)) {
-		free_page_and_swap_cache(page);
-		return;
-	}
-	mp->need_flush = 1;
-	mp->pages[mp->pages_nr++] = page;
-	if (mp->pages_nr >= FREE_PTE_NR)
-		tlb_flush_mmu(mp);
-}
-
-#define tlb_remove_tlb_entry(mp,ptep,addr) do { } while (0)
-#define pte_free_tlb(mp, ptepage, addr) pte_free((mp)->mm, ptepage)
-#define pmd_free_tlb(mp, pmdp, addr) pmd_free((mp)->mm, pmdp)
-#define pud_free_tlb(tlb,pudp, addr) __pud_free_tlb(tlb,pudp,addr)
+extern void __flush_tlb_pending(unsigned long, unsigned long, unsigned long *);
+extern void flush_tlb_pending(void);
 
-#define tlb_migrate_finish(mm)	do { } while (0)
 #define tlb_start_vma(tlb, vma) do { } while (0)
 #define tlb_end_vma(tlb, vma)	do { } while (0)
+#define __tlb_remove_tlb_entry(tlb, ptep, address) do { } while (0)
+#define tlb_flush(tlb)	flush_tlb_pending()
+
+#include <asm-generic/tlb.h>
 
 #endif /* _SPARC64_TLB_H */
diff --git a/arch/sparc/include/asm/tlbflush_64.h b/arch/sparc/include/asm/tlbflush_64.h
index fbb675d..2ef4634 100644
--- a/arch/sparc/include/asm/tlbflush_64.h
+++ b/arch/sparc/include/asm/tlbflush_64.h
@@ -5,9 +5,17 @@
 #include <asm/mmu_context.h>
 
 /* TSB flush operations. */
-struct mmu_gather;
+
+#define TLB_BATCH_NR	192
+
+struct tlb_batch {
+	struct mm_struct *mm;
+	unsigned long tlb_nr;
+	unsigned long vaddrs[TLB_BATCH_NR];
+};
+
 extern void flush_tsb_kernel_range(unsigned long start, unsigned long end);
-extern void flush_tsb_user(struct mmu_gather *mp);
+extern void flush_tsb_user(struct tlb_batch *tb);
 
 /* TLB flush operations. */
 
diff --git a/arch/sparc/mm/init_32.c b/arch/sparc/mm/init_32.c
index 4c31e2b..a755487 100644
--- a/arch/sparc/mm/init_32.c
+++ b/arch/sparc/mm/init_32.c
@@ -37,8 +37,6 @@
 #include <asm/prom.h>
 #include <asm/leon.h>
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 unsigned long *sparc_valid_addr_bitmap;
 EXPORT_SYMBOL(sparc_valid_addr_bitmap);
 
diff --git a/arch/sparc/mm/tlb.c b/arch/sparc/mm/tlb.c
index d8f21e2..b1f279c 100644
--- a/arch/sparc/mm/tlb.c
+++ b/arch/sparc/mm/tlb.c
@@ -19,33 +19,34 @@
 
 /* Heavily inspired by the ppc64 code.  */
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
+static DEFINE_PER_CPU(struct tlb_batch, tlb_batch);
 
 void flush_tlb_pending(void)
 {
-	struct mmu_gather *mp = &get_cpu_var(mmu_gathers);
+	struct tlb_batch *tb = &get_cpu_var(tlb_batch);
 
-	if (mp->tlb_nr) {
-		flush_tsb_user(mp);
+	if (tb->tlb_nr) {
+		flush_tsb_user(tb);
 
-		if (CTX_VALID(mp->mm->context)) {
+		if (CTX_VALID(tb->mm->context)) {
 #ifdef CONFIG_SMP
-			smp_flush_tlb_pending(mp->mm, mp->tlb_nr,
-					      &mp->vaddrs[0]);
+			smp_flush_tlb_pending(tb->mm, tb->tlb_nr,
+					      &tb->vaddrs[0]);
 #else
-			__flush_tlb_pending(CTX_HWBITS(mp->mm->context),
-					    mp->tlb_nr, &mp->vaddrs[0]);
+			__flush_tlb_pending(CTX_HWBITS(tb->mm->context),
+					    tb->tlb_nr, &tb->vaddrs[0]);
 #endif
 		}
-		mp->tlb_nr = 0;
+		tb->tlb_nr = 0;
 	}
 
-	put_cpu_var(mmu_gathers);
+	put_cpu_var(tlb_batch);
 }
 
-void tlb_batch_add(struct mm_struct *mm, unsigned long vaddr, pte_t *ptep, pte_t orig)
+void tlb_batch_add(struct mm_struct *mm, unsigned long vaddr,
+		   pte_t *ptep, pte_t orig, int fullmm)
 {
-	struct mmu_gather *mp = &__get_cpu_var(mmu_gathers);
+	struct tlb_batch *tb = &get_cpu_var(tlb_batch);
 	unsigned long nr;
 
 	vaddr &= PAGE_MASK;
@@ -77,21 +78,25 @@ void tlb_batch_add(struct mm_struct *mm, unsigned long vaddr, pte_t *ptep, pte_t
 
 no_cache_flush:
 
-	if (mp->fullmm)
+	if (fullmm) {
+		put_cpu_var(tlb_batch);
 		return;
+	}
 
-	nr = mp->tlb_nr;
+	nr = tb->tlb_nr;
 
-	if (unlikely(nr != 0 && mm != mp->mm)) {
+	if (unlikely(nr != 0 && mm != tb->mm)) {
 		flush_tlb_pending();
 		nr = 0;
 	}
 
 	if (nr == 0)
-		mp->mm = mm;
+		tb->mm = mm;
 
-	mp->vaddrs[nr] = vaddr;
-	mp->tlb_nr = ++nr;
+	tb->vaddrs[nr] = vaddr;
+	tb->tlb_nr = ++nr;
 	if (nr >= TLB_BATCH_NR)
 		flush_tlb_pending();
+
+	put_cpu_var(tlb_batch);
 }
diff --git a/arch/sparc/mm/tsb.c b/arch/sparc/mm/tsb.c
index 101d7c8..9484615 100644
--- a/arch/sparc/mm/tsb.c
+++ b/arch/sparc/mm/tsb.c
@@ -47,12 +47,13 @@ void flush_tsb_kernel_range(unsigned long start, unsigned long end)
 	}
 }
 
-static void __flush_tsb_one(struct mmu_gather *mp, unsigned long hash_shift, unsigned long tsb, unsigned long nentries)
+static void __flush_tsb_one(struct tlb_batch *tb, unsigned long hash_shift,
+			    unsigned long tsb, unsigned long nentries)
 {
 	unsigned long i;
 
-	for (i = 0; i < mp->tlb_nr; i++) {
-		unsigned long v = mp->vaddrs[i];
+	for (i = 0; i < tb->tlb_nr; i++) {
+		unsigned long v = tb->vaddrs[i];
 		unsigned long tag, ent, hash;
 
 		v &= ~0x1UL;
@@ -65,9 +66,9 @@ static void __flush_tsb_one(struct mmu_gather *mp, unsigned long hash_shift, uns
 	}
 }
 
-void flush_tsb_user(struct mmu_gather *mp)
+void flush_tsb_user(struct tlb_batch *tb)
 {
-	struct mm_struct *mm = mp->mm;
+	struct mm_struct *mm = tb->mm;
 	unsigned long nentries, base, flags;
 
 	spin_lock_irqsave(&mm->context.lock, flags);
@@ -76,7 +77,7 @@ void flush_tsb_user(struct mmu_gather *mp)
 	nentries = mm->context.tsb_block[MM_TSB_BASE].tsb_nentries;
 	if (tlb_type == cheetah_plus || tlb_type == hypervisor)
 		base = __pa(base);
-	__flush_tsb_one(mp, PAGE_SHIFT, base, nentries);
+	__flush_tsb_one(tb, PAGE_SHIFT, base, nentries);
 
 #ifdef CONFIG_HUGETLB_PAGE
 	if (mm->context.tsb_block[MM_TSB_HUGE].tsb) {
@@ -84,7 +85,7 @@ void flush_tsb_user(struct mmu_gather *mp)
 		nentries = mm->context.tsb_block[MM_TSB_HUGE].tsb_nentries;
 		if (tlb_type == cheetah_plus || tlb_type == hypervisor)
 			base = __pa(base);
-		__flush_tsb_one(mp, HPAGE_SHIFT, base, nentries);
+		__flush_tsb_one(tb, HPAGE_SHIFT, base, nentries);
 	}
 #endif
 	spin_unlock_irqrestore(&mm->context.lock, flags);
diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
index d6e87fd..4e10c40 100644
--- a/arch/tile/mm/init.c
+++ b/arch/tile/mm/init.c
@@ -60,8 +60,6 @@ unsigned long VMALLOC_RESERVE = CONFIG_VMALLOC_RESERVE;
 EXPORT_SYMBOL(VMALLOC_RESERVE);
 #endif
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 /* Create an L2 page table */
 static pte_t * __init alloc_pte(void)
 {
diff --git a/arch/um/include/asm/tlb.h b/arch/um/include/asm/tlb.h
index 660caed..4febacd 100644
--- a/arch/um/include/asm/tlb.h
+++ b/arch/um/include/asm/tlb.h
@@ -22,9 +22,6 @@ struct mmu_gather {
 	unsigned int		fullmm; /* non-zero means full mm flush */
 };
 
-/* Users of the generic TLB shootdown code must declare this storage space. */
-DECLARE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 static inline void __tlb_remove_tlb_entry(struct mmu_gather *tlb, pte_t *ptep,
 					  unsigned long address)
 {
@@ -47,27 +44,20 @@ static inline void init_tlb_gather(struct mmu_gather *tlb)
 	}
 }
 
-/* tlb_gather_mmu
- *	Return a pointer to an initialized struct mmu_gather.
- */
-static inline struct mmu_gather *
-tlb_gather_mmu(struct mm_struct *mm, unsigned int full_mm_flush)
+static inline void
+tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned int full_mm_flush)
 {
-	struct mmu_gather *tlb = &get_cpu_var(mmu_gathers);
-
 	tlb->mm = mm;
 	tlb->fullmm = full_mm_flush;
 
 	init_tlb_gather(tlb);
-
-	return tlb;
 }
 
 extern void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 			       unsigned long end);
 
 static inline void
-tlb_flush_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
+tlb_flush_mmu(struct mmu_gather *tlb)
 {
 	if (!tlb->need_flush)
 		return;
@@ -83,12 +73,10 @@ tlb_flush_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
 static inline void
 tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
 {
-	tlb_flush_mmu(tlb, start, end);
+	tlb_flush_mmu(tlb);
 
 	/* keep the page table cache within bounds */
 	check_pgt_cache();
-
-	put_cpu_var(mmu_gathers);
 }
 
 /* tlb_remove_page
@@ -96,11 +84,16 @@ tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
  *	while handling the additional races in SMP caused by other CPUs
  *	caching valid mappings in their TLBs.
  */
-static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
+static inline int __tlb_remove_page(struct mmu_gather *tlb, struct page *page)
 {
 	tlb->need_flush = 1;
 	free_page_and_swap_cache(page);
-	return;
+	return 1; /* avoid calling tlb_flush_mmu */
+}
+
+static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
+{
+	__tlb_remove_page(tlb, page);
 }
 
 /**
diff --git a/arch/um/kernel/smp.c b/arch/um/kernel/smp.c
index 106bf27..d9011e0 100644
--- a/arch/um/kernel/smp.c
+++ b/arch/um/kernel/smp.c
@@ -7,9 +7,6 @@
 #include "asm/pgalloc.h"
 #include "asm/tlb.h"
 
-/* For some reason, mmu_gathers are referenced when CONFIG_SMP is off. */
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 #ifdef CONFIG_SMP
 
 #include "linux/sched.h"
diff --git a/arch/unicore32/mm/mmu.c b/arch/unicore32/mm/mmu.c
index 7bf3d58..c5b2b65 100644
--- a/arch/unicore32/mm/mmu.c
+++ b/arch/unicore32/mm/mmu.c
@@ -30,8 +30,6 @@
 
 #include "mm.h"
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 /*
  * empty_zero_page is a special page that is used for
  * zero-initialized data and COW.
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 286d289..cda082e 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -16,8 +16,6 @@
 #include <asm/tlb.h>
 #include <asm/proto.h>
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 unsigned long __initdata pgt_buf_start;
 unsigned long __meminitdata pgt_buf_end;
 unsigned long __meminitdata pgt_buf_top;
diff --git a/arch/xtensa/mm/mmu.c b/arch/xtensa/mm/mmu.c
index 4bb91a9..ca81654 100644
--- a/arch/xtensa/mm/mmu.c
+++ b/arch/xtensa/mm/mmu.c
@@ -14,8 +14,6 @@
 #include <asm/mmu_context.h>
 #include <asm/page.h>
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 void __init paging_init(void)
 {
 	memset(swapper_pg_dir, 0, PAGE_SIZE);
diff --git a/fs/exec.c b/fs/exec.c
index 5e62d26..14e623e 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -553,7 +553,7 @@ static int shift_arg_pages(struct vm_area_struct *vma, unsigned long shift)
 	unsigned long length = old_end - old_start;
 	unsigned long new_start = old_start - shift;
 	unsigned long new_end = old_end - shift;
-	struct mmu_gather *tlb;
+	struct mmu_gather tlb;
 
 	BUG_ON(new_start > new_end);
 
@@ -579,12 +579,12 @@ static int shift_arg_pages(struct vm_area_struct *vma, unsigned long shift)
 		return -ENOMEM;
 
 	lru_add_drain();
-	tlb = tlb_gather_mmu(mm, 0);
+	tlb_gather_mmu(&tlb, mm, 0);
 	if (new_end > old_start) {
 		/*
 		 * when the old and new regions overlap clear from new_end.
 		 */
-		free_pgd_range(tlb, new_end, old_end, new_end,
+		free_pgd_range(&tlb, new_end, old_end, new_end,
 			vma->vm_next ? vma->vm_next->vm_start : 0);
 	} else {
 		/*
@@ -593,10 +593,10 @@ static int shift_arg_pages(struct vm_area_struct *vma, unsigned long shift)
 		 * have constraints on va-space that make this illegal (IA64) -
 		 * for the others its just a little faster.
 		 */
-		free_pgd_range(tlb, old_start, old_end, new_end,
+		free_pgd_range(&tlb, old_start, old_end, new_end,
 			vma->vm_next ? vma->vm_next->vm_start : 0);
 	}
-	tlb_finish_mmu(tlb, new_end, old_end);
+	tlb_finish_mmu(&tlb, new_end, old_end);
 
 	/*
 	 * Shrink the vma to just the new range.  Always succeeds.
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index e43f976..67f21e2 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -5,6 +5,8 @@
  * Copyright 2001 Red Hat, Inc.
  * Based on code from mm/memory.c Copyright Linus Torvalds and others.
  *
+ * Copyright 2011 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * as published by the Free Software Foundation; either version
@@ -22,51 +24,71 @@
  * and page free order so much..
  */
 #ifdef CONFIG_SMP
-  #ifdef ARCH_FREE_PTR_NR
-    #define FREE_PTR_NR   ARCH_FREE_PTR_NR
-  #else
-    #define FREE_PTE_NR	506
-  #endif
   #define tlb_fast_mode(tlb) ((tlb)->nr == ~0U)
 #else
-  #define FREE_PTE_NR	1
   #define tlb_fast_mode(tlb) 1
 #endif
 
+/*
+ * If we can't allocate a page to make a big patch of page pointers
+ * to work on, then just handle a few from the on-stack structure.
+ */
+#define MMU_GATHER_BUNDLE	8
+
 /* struct mmu_gather is an opaque type used by the mm code for passing around
  * any data needed by arch specific code for tlb_remove_page.
  */
 struct mmu_gather {
 	struct mm_struct	*mm;
 	unsigned int		nr;	/* set to ~0U means fast mode */
+	unsigned int		max;	/* nr < max */
 	unsigned int		need_flush;/* Really unmapped some ptes? */
 	unsigned int		fullmm; /* non-zero means full mm flush */
-	struct page *		pages[FREE_PTE_NR];
+#ifdef HAVE_ARCH_MMU_GATHER
+	struct arch_mmu_gather	arch;
+#endif
+	struct page		**pages;
+	struct page		*local[MMU_GATHER_BUNDLE];
 };
 
-/* Users of the generic TLB shootdown code must declare this storage space. */
-DECLARE_PER_CPU(struct mmu_gather, mmu_gathers);
+static inline void __tlb_alloc_page(struct mmu_gather *tlb)
+{
+	unsigned long addr = __get_free_pages(GFP_NOWAIT | __GFP_NOWARN, 0);
+
+	if (addr) {
+		tlb->pages = (void *)addr;
+		tlb->max = PAGE_SIZE / sizeof(struct page *);
+	}
+}
 
 /* tlb_gather_mmu
- *	Return a pointer to an initialized struct mmu_gather.
+ *	Called to initialize an (on-stack) mmu_gather structure for page-table
+ *	tear-down from @mm. The @fullmm argument is used when @mm is without
+ *	users and we're going to destroy the full address space (exit/execve).
  */
-static inline struct mmu_gather *
-tlb_gather_mmu(struct mm_struct *mm, unsigned int full_mm_flush)
+static inline void
+tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned int fullmm)
 {
-	struct mmu_gather *tlb = &get_cpu_var(mmu_gathers);
-
 	tlb->mm = mm;
 
-	/* Use fast mode if only one CPU is online */
-	tlb->nr = num_online_cpus() > 1 ? 0U : ~0U;
+	tlb->max = ARRAY_SIZE(tlb->local);
+	tlb->pages = tlb->local;
+
+	if (num_online_cpus() > 1) {
+		tlb->nr = 0;
+		__tlb_alloc_page(tlb);
+	} else /* Use fast mode if only one CPU is online */
+		tlb->nr = ~0U;
 
-	tlb->fullmm = full_mm_flush;
+	tlb->fullmm = fullmm;
 
-	return tlb;
+#ifdef HAVE_ARCH_MMU_GATHER
+	tlb->arch = ARCH_MMU_GATHER_INIT;
+#endif
 }
 
 static inline void
-tlb_flush_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
+tlb_flush_mmu(struct mmu_gather *tlb)
 {
 	if (!tlb->need_flush)
 		return;
@@ -75,6 +97,13 @@ tlb_flush_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
 	if (!tlb_fast_mode(tlb)) {
 		free_pages_and_swap_cache(tlb->pages, tlb->nr);
 		tlb->nr = 0;
+		/*
+		 * If we are using the local on-stack array of pages for MMU
+		 * gather, try allocating an off-stack array again as we have
+		 * recently freed pages.
+		 */
+		if (tlb->pages == tlb->local)
+			__tlb_alloc_page(tlb);
 	}
 }
 
@@ -85,29 +114,42 @@ tlb_flush_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
 static inline void
 tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
 {
-	tlb_flush_mmu(tlb, start, end);
+	tlb_flush_mmu(tlb);
 
 	/* keep the page table cache within bounds */
 	check_pgt_cache();
 
-	put_cpu_var(mmu_gathers);
+	if (tlb->pages != tlb->local)
+		free_pages((unsigned long)tlb->pages, 0);
 }
 
-/* tlb_remove_page
+/* __tlb_remove_page
  *	Must perform the equivalent to __free_pte(pte_get_and_clear(ptep)), while
  *	handling the additional races in SMP caused by other CPUs caching valid
- *	mappings in their TLBs.
+ *	mappings in their TLBs. Returns the number of free page slots left.
+ *	When out of page slots we must call tlb_flush_mmu().
  */
-static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
+static inline int __tlb_remove_page(struct mmu_gather *tlb, struct page *page)
 {
 	tlb->need_flush = 1;
 	if (tlb_fast_mode(tlb)) {
 		free_page_and_swap_cache(page);
-		return;
+		return 1; /* avoid calling tlb_flush_mmu() */
 	}
 	tlb->pages[tlb->nr++] = page;
-	if (tlb->nr >= FREE_PTE_NR)
-		tlb_flush_mmu(tlb, 0, 0);
+	VM_BUG_ON(tlb->nr > tlb->max);
+
+	return tlb->max - tlb->nr;
+}
+
+/* tlb_remove_page
+ *	Similar to __tlb_remove_page but will call tlb_flush_mmu() itself when
+ *	required.
+ */
+static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
+{
+	if (!__tlb_remove_page(tlb, page))
+		tlb_flush_mmu(tlb);
 }
 
 /**
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7606d7d..2bf8bf1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -904,7 +904,7 @@ int zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
 		unsigned long size);
 unsigned long zap_page_range(struct vm_area_struct *vma, unsigned long address,
 		unsigned long size, struct zap_details *);
-unsigned long unmap_vmas(struct mmu_gather **tlb,
+unsigned long unmap_vmas(struct mmu_gather *tlb,
 		struct vm_area_struct *start_vma, unsigned long start_addr,
 		unsigned long end_addr, unsigned long *nr_accounted,
 		struct zap_details *);
diff --git a/mm/memory.c b/mm/memory.c
index 9da8cab..e6eddc4 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -912,12 +912,13 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 				long *zap_work, struct zap_details *details)
 {
 	struct mm_struct *mm = tlb->mm;
+	int force_flush = 0;
 	pte_t *pte;
 	spinlock_t *ptl;
 	int rss[NR_MM_COUNTERS];
 
 	init_rss_vec(rss);
-
+again:
 	pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
 	arch_enter_lazy_mmu_mode();
 	do {
@@ -974,7 +975,9 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 			page_remove_rmap(page);
 			if (unlikely(page_mapcount(page) < 0))
 				print_bad_pte(vma, addr, ptent, page);
-			tlb_remove_page(tlb, page);
+			force_flush = !__tlb_remove_page(tlb, page);
+			if (force_flush)
+				break;
 			continue;
 		}
 		/*
@@ -1001,6 +1004,18 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 	arch_leave_lazy_mmu_mode();
 	pte_unmap_unlock(pte - 1, ptl);
 
+	/*
+	 * mmu_gather ran out of room to batch pages, we break out of
+	 * the PTE lock to avoid doing the potential expensive TLB invalidate
+	 * and page-free while holding it.
+	 */
+	if (force_flush) {
+		force_flush = 0;
+		tlb_flush_mmu(tlb);
+		if (addr != end)
+			goto again;
+	}
+
 	return addr;
 }
 
@@ -1121,17 +1136,14 @@ static unsigned long unmap_page_range(struct mmu_gather *tlb,
  * ensure that any thus-far unmapped pages are flushed before unmap_vmas()
  * drops the lock and schedules.
  */
-unsigned long unmap_vmas(struct mmu_gather **tlbp,
+unsigned long unmap_vmas(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, unsigned long start_addr,
 		unsigned long end_addr, unsigned long *nr_accounted,
 		struct zap_details *details)
 {
 	long zap_work = ZAP_BLOCK_SIZE;
-	unsigned long tlb_start = 0;	/* For tlb_finish_mmu */
-	int tlb_start_valid = 0;
 	unsigned long start = start_addr;
 	spinlock_t *i_mmap_lock = details? details->i_mmap_lock: NULL;
-	int fullmm = (*tlbp)->fullmm;
 	struct mm_struct *mm = vma->vm_mm;
 
 	mmu_notifier_invalidate_range_start(mm, start_addr, end_addr);
@@ -1152,11 +1164,6 @@ unsigned long unmap_vmas(struct mmu_gather **tlbp,
 			untrack_pfn_vma(vma, 0, 0);
 
 		while (start != end) {
-			if (!tlb_start_valid) {
-				tlb_start = start;
-				tlb_start_valid = 1;
-			}
-
 			if (unlikely(is_vm_hugetlb_page(vma))) {
 				/*
 				 * It is undesirable to test vma->vm_file as it
@@ -1177,7 +1184,7 @@ unsigned long unmap_vmas(struct mmu_gather **tlbp,
 
 				start = end;
 			} else
-				start = unmap_page_range(*tlbp, vma,
+				start = unmap_page_range(tlb, vma,
 						start, end, &zap_work, details);
 
 			if (zap_work > 0) {
@@ -1185,19 +1192,13 @@ unsigned long unmap_vmas(struct mmu_gather **tlbp,
 				break;
 			}
 
-			tlb_finish_mmu(*tlbp, tlb_start, start);
-
 			if (need_resched() ||
 				(i_mmap_lock && spin_needbreak(i_mmap_lock))) {
-				if (i_mmap_lock) {
-					*tlbp = NULL;
+				if (i_mmap_lock)
 					goto out;
-				}
 				cond_resched();
 			}
 
-			*tlbp = tlb_gather_mmu(vma->vm_mm, fullmm);
-			tlb_start_valid = 0;
 			zap_work = ZAP_BLOCK_SIZE;
 		}
 	}
@@ -1217,16 +1218,15 @@ unsigned long zap_page_range(struct vm_area_struct *vma, unsigned long address,
 		unsigned long size, struct zap_details *details)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	struct mmu_gather *tlb;
+	struct mmu_gather tlb;
 	unsigned long end = address + size;
 	unsigned long nr_accounted = 0;
 
 	lru_add_drain();
-	tlb = tlb_gather_mmu(mm, 0);
+	tlb_gather_mmu(&tlb, mm, 0);
 	update_hiwater_rss(mm);
 	end = unmap_vmas(&tlb, vma, address, end, &nr_accounted, details);
-	if (tlb)
-		tlb_finish_mmu(tlb, address, end);
+	tlb_finish_mmu(&tlb, address, end);
 	return end;
 }
 
diff --git a/mm/mmap.c b/mm/mmap.c
index 2ec8eb5..f8cbc86 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1913,17 +1913,17 @@ static void unmap_region(struct mm_struct *mm,
 		unsigned long start, unsigned long end)
 {
 	struct vm_area_struct *next = prev? prev->vm_next: mm->mmap;
-	struct mmu_gather *tlb;
+	struct mmu_gather tlb;
 	unsigned long nr_accounted = 0;
 
 	lru_add_drain();
-	tlb = tlb_gather_mmu(mm, 0);
+	tlb_gather_mmu(&tlb, mm, 0);
 	update_hiwater_rss(mm);
 	unmap_vmas(&tlb, vma, start, end, &nr_accounted, NULL);
 	vm_unacct_memory(nr_accounted);
-	free_pgtables(tlb, vma, prev? prev->vm_end: FIRST_USER_ADDRESS,
-				 next? next->vm_start: 0);
-	tlb_finish_mmu(tlb, start, end);
+	free_pgtables(&tlb, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
+				 next ? next->vm_start : 0);
+	tlb_finish_mmu(&tlb, start, end);
 }
 
 /*
@@ -2265,7 +2265,7 @@ EXPORT_SYMBOL(do_brk);
 /* Release all mmaps. */
 void exit_mmap(struct mm_struct *mm)
 {
-	struct mmu_gather *tlb;
+	struct mmu_gather tlb;
 	struct vm_area_struct *vma;
 	unsigned long nr_accounted = 0;
 	unsigned long end;
@@ -2290,14 +2290,14 @@ void exit_mmap(struct mm_struct *mm)
 
 	lru_add_drain();
 	flush_cache_mm(mm);
-	tlb = tlb_gather_mmu(mm, 1);
+	tlb_gather_mmu(&tlb, mm, 1);
 	/* update_hiwater_rss(mm) here? but nobody should be looking */
 	/* Use -1 here to ensure all VMAs in the mm are unmapped */
 	end = unmap_vmas(&tlb, vma, 0, -1, &nr_accounted, NULL);
 	vm_unacct_memory(nr_accounted);
 
-	free_pgtables(tlb, vma, FIRST_USER_ADDRESS, 0);
-	tlb_finish_mmu(tlb, 0, end);
+	free_pgtables(&tlb, vma, FIRST_USER_ADDRESS, 0);
+	tlb_finish_mmu(&tlb, 0, end);
 
 	/*
 	 * Walk the list again, actually closing and freeing it,

