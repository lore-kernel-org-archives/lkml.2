Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933399Ab0KORno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 12:43:44 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59680 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933270Ab0KORng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:43:36 -0500
Date: Mon, 15 Nov 2010 17:42:51 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 04/20] ARM: LPAE: Do not assume Linux PTEs are
	always at PTRS_PER_PTE offset
Message-ID: <20101115174251.GB31421@n2100.arm.linux.org.uk>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com> <1289584840-18097-5-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289584840-18097-5-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 06:00:24PM +0000, Catalin Marinas wrote:
> Placing the Linux PTEs at a 2KB offset inside a page is a workaround for
> the 2-level page table format where not enough spare bits are available.
> With LPAE this is no longer required. This patch changes such assumption
> by using a different macro, LINUX_PTE_OFFSET, which is defined to
> PTRS_PER_PTE for the 2-level page tables.

Hmm.  I think we should be doing this a different way - in fact, I think
we should switch the order of the linux vs hardware page tables.  This
actually simplifies the code a bit too - notice that we lose the arith.
in __pte_map, __pte_unmap, pmd_page_vaddr, which is all page table
walking stuff.

 arch/arm/include/asm/pgalloc.h |   34 +++++++++++++++-------------------
 arch/arm/include/asm/pgtable.h |   30 +++++++++++++++---------------
 arch/arm/mm/fault.c            |    2 +-
 arch/arm/mm/mmu.c              |    2 +-
 arch/arm/mm/proc-macros.S      |   10 +++++-----
 arch/arm/mm/proc-v7.S          |    8 +++-----
 6 files changed, 40 insertions(+), 46 deletions(-)

diff --git a/arch/arm/include/asm/pgalloc.h b/arch/arm/include/asm/pgalloc.h
index b12cc98..e2a6613 100644
--- a/arch/arm/include/asm/pgalloc.h
+++ b/arch/arm/include/asm/pgalloc.h
@@ -38,6 +38,11 @@ extern void free_pgd_slow(struct mm_struct *mm, pgd_t *pgd);
 
 #define PGALLOC_GFP	(GFP_KERNEL | __GFP_NOTRACK | __GFP_REPEAT | __GFP_ZERO)
 
+static inline void clean_pte_table(void *ptr)
+{
+	clean_dcache_area(ptr + PTE_HWTABLE_OFF, PTE_HWTABLE_SIZE);
+}
+
 /*
  * Allocate one PTE table.
  *
@@ -60,10 +65,8 @@ pte_alloc_one_kernel(struct mm_struct *mm, unsigned long addr)
 	pte_t *pte;
 
 	pte = (pte_t *)__get_free_page(PGALLOC_GFP);
-	if (pte) {
-		clean_dcache_area(pte, sizeof(pte_t) * PTRS_PER_PTE);
-		pte += PTRS_PER_PTE;
-	}
+	if (pte)
+		clean_pte_table(pte);
 
 	return pte;
 }
@@ -79,10 +82,8 @@ pte_alloc_one(struct mm_struct *mm, unsigned long addr)
 	pte = alloc_pages(PGALLOC_GFP, 0);
 #endif
 	if (pte) {
-		if (!PageHighMem(pte)) {
-			void *page = page_address(pte);
-			clean_dcache_area(page, sizeof(pte_t) * PTRS_PER_PTE);
-		}
+		if (!PageHighMem(pte))
+			clean_pte_table(page_address(pte));
 		pgtable_page_ctor(pte);
 	}
 
@@ -94,10 +95,8 @@ pte_alloc_one(struct mm_struct *mm, unsigned long addr)
  */
 static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
 {
-	if (pte) {
-		pte -= PTRS_PER_PTE;
+	if (pte)
 		free_page((unsigned long)pte);
-	}
 }
 
 static inline void pte_free(struct mm_struct *mm, pgtable_t pte)
@@ -106,8 +105,9 @@ static inline void pte_free(struct mm_struct *mm, pgtable_t pte)
 	__free_page(pte);
 }
 
-static inline void __pmd_populate(pmd_t *pmdp, unsigned long pmdval)
+static inline void __pmd_populate(pmd_t *pmdp, unsigned long pte, unsigned long prot)
 {
+	unsigned long pmdval = (pte + PTE_HWTABLE_OFF) | prot;
 	pmdp[0] = __pmd(pmdval);
 	pmdp[1] = __pmd(pmdval + 256 * sizeof(pte_t));
 	flush_pmd_entry(pmdp);
@@ -122,20 +122,16 @@ static inline void __pmd_populate(pmd_t *pmdp, unsigned long pmdval)
 static inline void
 pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmdp, pte_t *ptep)
 {
-	unsigned long pte_ptr = (unsigned long)ptep;
-
 	/*
-	 * The pmd must be loaded with the physical
-	 * address of the PTE table
+	 * The pmd must be loaded with the physical address of the PTE table
 	 */
-	pte_ptr -= PTRS_PER_PTE * sizeof(void *);
-	__pmd_populate(pmdp, __pa(pte_ptr) | _PAGE_KERNEL_TABLE);
+	__pmd_populate(pmdp, __pa(ptep), _PAGE_KERNEL_TABLE);
 }
 
 static inline void
 pmd_populate(struct mm_struct *mm, pmd_t *pmdp, pgtable_t ptep)
 {
-	__pmd_populate(pmdp, page_to_pfn(ptep) << PAGE_SHIFT | _PAGE_USER_TABLE);
+	__pmd_populate(pmdp, page_to_pfn(ptep) << PAGE_SHIFT, _PAGE_USER_TABLE);
 }
 #define pmd_pgtable(pmd) pmd_page(pmd)
 
diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index b155414..d9f1bfa 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -54,7 +54,7 @@
  * Therefore, we tweak the implementation slightly - we tell Linux that we
  * have 2048 entries in the first level, each of which is 8 bytes (iow, two
  * hardware pointers to the second level.)  The second level contains two
- * hardware PTE tables arranged contiguously, followed by Linux versions
+ * hardware PTE tables arranged contiguously, preceded by Linux versions
  * which contain the state information Linux needs.  We, therefore, end up
  * with 512 entries in the "PTE" level.
  *
@@ -62,15 +62,15 @@
  *
  *    pgd             pte
  * |        |
- * +--------+ +0
- * |        |-----> +------------+ +0
+ * +--------+
+ * |        |       +------------+ +0
+ * +- - - - +       | Linux pt 0 |
+ * |        |       +------------+ +1024
+ * +--------+ +0    | Linux pt 1 |
+ * |        |-----> +------------+ +2048
  * +- - - - + +4    |  h/w pt 0  |
- * |        |-----> +------------+ +1024
+ * |        |-----> +------------+ +3072
  * +--------+ +8    |  h/w pt 1  |
- * |        |       +------------+ +2048
- * +- - - - +       | Linux pt 0 |
- * |        |       +------------+ +3072
- * +--------+       | Linux pt 1 |
  * |        |       +------------+ +4096
  *
  * See L_PTE_xxx below for definitions of bits in the "Linux pt", and
@@ -102,6 +102,10 @@
 #define PTRS_PER_PMD		1
 #define PTRS_PER_PGD		2048
 
+#define PTE_HWTABLE_PTRS	(PTRS_PER_PTE)
+#define PTE_HWTABLE_OFF		(PTE_HWTABLE_PTRS * sizeof(pte_t))
+#define PTE_HWTABLE_SIZE	(PTRS_PER_PTE * sizeof(u32))
+
 /*
  * PMD_SHIFT determines the size of the area a second-level page table can map
  * PGDIR_SHIFT determines what a third-level page table entry can map
@@ -270,8 +274,8 @@ extern struct page *empty_zero_page;
 #define __pte_map(dir)		pmd_page_vaddr(*(dir))
 #define __pte_unmap(pte)	do { } while (0)
 #else
-#define __pte_map(dir)		((pte_t *)kmap_atomic(pmd_page(*(dir))) + PTRS_PER_PTE)
-#define __pte_unmap(pte)	kunmap_atomic((pte - PTRS_PER_PTE))
+#define __pte_map(dir)		(pte_t *)kmap_atomic(pmd_page(*(dir)))
+#define __pte_unmap(pte)	kunmap_atomic(pte)
 #endif
 
 #define set_pte_ext(ptep,pte,ext) cpu_set_pte_ext(ptep,pte,ext)
@@ -364,11 +368,7 @@ extern pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 
 static inline pte_t *pmd_page_vaddr(pmd_t pmd)
 {
-	unsigned long ptr;
-
-	ptr = pmd_val(pmd) & ~(PTRS_PER_PTE * sizeof(void *) - 1);
-	ptr += PTRS_PER_PTE * sizeof(void *);
-
+	unsigned long ptr = pmd_val(pmd) & PAGE_MASK;
 	return __va(ptr);
 }
 
diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index 1e21e12..f10f9ba 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -108,7 +108,7 @@ void show_pte(struct mm_struct *mm, unsigned long addr)
 
 		pte = pte_offset_map(pmd, addr);
 		printk(", *pte=%08lx", pte_val(*pte));
-		printk(", *ppte=%08lx", pte_val(pte[-PTRS_PER_PTE]));
+		printk(", *ppte=%08lx", pte_val(pte[PTE_HWTABLE_PTRS]));
 		pte_unmap(pte);
 	} while(0);
 
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 72ad3e1..9963189 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -535,7 +535,7 @@ static pte_t * __init early_pte_alloc(pmd_t *pmd, unsigned long addr, unsigned l
 {
 	if (pmd_none(*pmd)) {
 		pte_t *pte = early_alloc(2 * PTRS_PER_PTE * sizeof(pte_t));
-		__pmd_populate(pmd, __pa(pte) | prot);
+		__pmd_populate(pmd, __pa(pte), prot);
 	}
 	BUG_ON(pmd_bad(*pmd));
 	return pte_offset_kernel(pmd, addr);
diff --git a/arch/arm/mm/proc-macros.S b/arch/arm/mm/proc-macros.S
index 7d63bea..cbedf9c 100644
--- a/arch/arm/mm/proc-macros.S
+++ b/arch/arm/mm/proc-macros.S
@@ -121,7 +121,7 @@
 	.endm
 
 	.macro	armv6_set_pte_ext pfx
-	str	r1, [r0], #-2048		@ linux version
+	str	r1, [r0], #2048			@ linux version
 
 	bic	r3, r1, #0x000003fc
 	bic	r3, r3, #PTE_TYPE_MASK
@@ -170,7 +170,7 @@
  *  1111  0xff	r/w	r/w
  */
 	.macro	armv3_set_pte_ext wc_disable=1
-	str	r1, [r0], #-2048		@ linux version
+	str	r1, [r0], #2048			@ linux version
 
 	eor	r3, r1, #L_PTE_PRESENT | L_PTE_YOUNG | L_PTE_WRITE | L_PTE_DIRTY
 
@@ -193,7 +193,7 @@
 	bicne	r2, r2, #PTE_BUFFERABLE
 #endif
 	.endif
-	str	r2, [r0]			@ hardware version
+	str	r2, [r0]		@ hardware version
 	.endm
 
 
@@ -213,7 +213,7 @@
  *  1111  11	r/w	r/w
  */
 	.macro	xscale_set_pte_ext_prologue
-	str	r1, [r0], #-2048		@ linux version
+	str	r1, [r0]			@ linux version
 
 	eor	r3, r1, #L_PTE_PRESENT | L_PTE_YOUNG | L_PTE_WRITE | L_PTE_DIRTY
 
@@ -232,7 +232,7 @@
 	tst	r3, #L_PTE_PRESENT | L_PTE_YOUNG	@ present and young?
 	movne	r2, #0				@ no -> fault
 
-	str	r2, [r0]			@ hardware version
+	str	r2, [r0, #2048]!		@ hardware version
 	mov	ip, #0
 	mcr	p15, 0, r0, c7, c10, 1		@ clean L1 D line
 	mcr	p15, 0, ip, c7, c10, 4		@ data write barrier
diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index 53cbe22..89c31a6 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -124,15 +124,13 @@ ENDPROC(cpu_v7_switch_mm)
  *	Set a level 2 translation table entry.
  *
  *	- ptep  - pointer to level 2 translation table entry
- *		  (hardware version is stored at -1024 bytes)
+ *		  (hardware version is stored at +2048 bytes)
  *	- pte   - PTE value to store
  *	- ext	- value for extended PTE bits
  */
 ENTRY(cpu_v7_set_pte_ext)
 #ifdef CONFIG_MMU
- ARM(	str	r1, [r0], #-2048	)	@ linux version
- THUMB(	str	r1, [r0]		)	@ linux version
- THUMB(	sub	r0, r0, #2048		)
+	str	r1, [r0]			@ linux version
 
 	bic	r3, r1, #0x000003f0
 	bic	r3, r3, #PTE_TYPE_MASK
@@ -158,7 +156,7 @@ ENTRY(cpu_v7_set_pte_ext)
 	tstne	r1, #L_PTE_PRESENT
 	moveq	r3, #0
 
-	str	r3, [r0]
+	str	r3, [r0, #2048]!
 	mcr	p15, 0, r0, c7, c10, 1		@ flush_pte
 #endif
 	mov	pc, lr

