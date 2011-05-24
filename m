Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933725Ab1EXVn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:43:29 -0400
Received: from service87.mimecast.com ([94.185.240.25]:34658 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932830Ab1EXVjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:39:42 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v6 06/18] ARM: LPAE: Add (pte|pmd|pgd|pgprot)val_t type definitions as u32
Date: Tue, 24 May 2011 22:39:12 +0100
Message-Id: <1306273164-18217-7-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1306273164-18217-1-git-send-email-catalin.marinas@arm.com>
References: <1306273164-18217-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 24 May 2011 21:39:46.0333 (UTC) FILETIME=[19C10CD0:01CC1A5B]
X-MC-Unique: 111052422394001201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p4OLhsg9005102

This patch defines the (pte|pmd|pgd|pgprot)val_t as u32 and changes the
page table types to be based on these. The PMD bits are converted to the
corresponding type using the _AT macro.

The flush_pmd_entry/clean_pmd_entry argument was changed to (void *) to
allow them to be used with both PGD and PMD pointers and avoid code
duplication.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/include/asm/pgalloc.h              |    4 +-
 arch/arm/include/asm/pgtable-2level-hwdef.h |   82 +++++++++++++-------------
 arch/arm/include/asm/pgtable-2level-types.h |   17 +++--
 arch/arm/include/asm/tlbflush.h             |    4 +-
 arch/arm/mm/mm.h                            |    4 +-
 arch/arm/mm/mmu.c                           |    4 +-
 6 files changed, 59 insertions(+), 56 deletions(-)

diff --git a/arch/arm/include/asm/pgalloc.h b/arch/arm/include/asm/pgalloc.h
index a87d4cf..7418894 100644
--- a/arch/arm/include/asm/pgalloc.h
+++ b/arch/arm/include/asm/pgalloc.h
@@ -105,9 +105,9 @@ static inline void pte_free(struct mm_struct *mm, pgtable_t pte)
 }
 
 static inline void __pmd_populate(pmd_t *pmdp, phys_addr_t pte,
-	unsigned long prot)
+				  pmdval_t prot)
 {
-	unsigned long pmdval = (pte + PTE_HWTABLE_OFF) | prot;
+	pmdval_t pmdval = (pte + PTE_HWTABLE_OFF) | prot;
 	pmdp[0] = __pmd(pmdval);
 	pmdp[1] = __pmd(pmdval + 256 * sizeof(pte_t));
 	flush_pmd_entry(pmdp);
diff --git a/arch/arm/include/asm/pgtable-2level-hwdef.h b/arch/arm/include/asm/pgtable-2level-hwdef.h
index 436529c..2b52c40 100644
--- a/arch/arm/include/asm/pgtable-2level-hwdef.h
+++ b/arch/arm/include/asm/pgtable-2level-hwdef.h
@@ -16,29 +16,29 @@
  * + Level 1 descriptor (PMD)
  *   - common
  */
-#define PMD_TYPE_MASK		(3 << 0)
-#define PMD_TYPE_FAULT		(0 << 0)
-#define PMD_TYPE_TABLE		(1 << 0)
-#define PMD_TYPE_SECT		(2 << 0)
-#define PMD_BIT4		(1 << 4)
-#define PMD_DOMAIN(x)		((x) << 5)
-#define PMD_PROTECTION		(1 << 9)	/* v5 */
+#define PMD_TYPE_MASK		(_AT(pmdval_t, 3) << 0)
+#define PMD_TYPE_FAULT		(_AT(pmdval_t, 0) << 0)
+#define PMD_TYPE_TABLE		(_AT(pmdval_t, 1) << 0)
+#define PMD_TYPE_SECT		(_AT(pmdval_t, 2) << 0)
+#define PMD_BIT4		(_AT(pmdval_t, 1) << 4)
+#define PMD_DOMAIN(x)		(_AT(pmdval_t, (x)) << 5)
+#define PMD_PROTECTION		(_AT(pmdval_t, 1) << 9)		/* v5 */
 /*
  *   - section
  */
-#define PMD_SECT_BUFFERABLE	(1 << 2)
-#define PMD_SECT_CACHEABLE	(1 << 3)
-#define PMD_SECT_XN		(1 << 4)	/* v6 */
-#define PMD_SECT_AP_WRITE	(1 << 10)
-#define PMD_SECT_AP_READ	(1 << 11)
-#define PMD_SECT_TEX(x)		((x) << 12)	/* v5 */
-#define PMD_SECT_APX		(1 << 15)	/* v6 */
-#define PMD_SECT_S		(1 << 16)	/* v6 */
-#define PMD_SECT_nG		(1 << 17)	/* v6 */
-#define PMD_SECT_SUPER		(1 << 18)	/* v6 */
-#define PMD_SECT_AF		(0)
+#define PMD_SECT_BUFFERABLE	(_AT(pmdval_t, 1) << 2)
+#define PMD_SECT_CACHEABLE	(_AT(pmdval_t, 1) << 3)
+#define PMD_SECT_XN		(_AT(pmdval_t, 1) << 4)		/* v6 */
+#define PMD_SECT_AP_WRITE	(_AT(pmdval_t, 1) << 10)
+#define PMD_SECT_AP_READ	(_AT(pmdval_t, 1) << 11)
+#define PMD_SECT_TEX(x)		(_AT(pmdval_t, (x)) << 12)	/* v5 */
+#define PMD_SECT_APX		(_AT(pmdval_t, 1) << 15)	/* v6 */
+#define PMD_SECT_S		(_AT(pmdval_t, 1) << 16)	/* v6 */
+#define PMD_SECT_nG		(_AT(pmdval_t, 1) << 17)	/* v6 */
+#define PMD_SECT_SUPER		(_AT(pmdval_t, 1) << 18)	/* v6 */
+#define PMD_SECT_AF		(_AT(pmdval_t, 0))
 
-#define PMD_SECT_UNCACHED	(0)
+#define PMD_SECT_UNCACHED	(_AT(pmdval_t, 0))
 #define PMD_SECT_BUFFERED	(PMD_SECT_BUFFERABLE)
 #define PMD_SECT_WT		(PMD_SECT_CACHEABLE)
 #define PMD_SECT_WB		(PMD_SECT_CACHEABLE | PMD_SECT_BUFFERABLE)
@@ -54,38 +54,38 @@
  * + Level 2 descriptor (PTE)
  *   - common
  */
-#define PTE_TYPE_MASK		(3 << 0)
-#define PTE_TYPE_FAULT		(0 << 0)
-#define PTE_TYPE_LARGE		(1 << 0)
-#define PTE_TYPE_SMALL		(2 << 0)
-#define PTE_TYPE_EXT		(3 << 0)	/* v5 */
-#define PTE_BUFFERABLE		(1 << 2)
-#define PTE_CACHEABLE		(1 << 3)
+#define PTE_TYPE_MASK		(_AT(pteval_t, 3) << 0)
+#define PTE_TYPE_FAULT		(_AT(pteval_t, 0) << 0)
+#define PTE_TYPE_LARGE		(_AT(pteval_t, 1) << 0)
+#define PTE_TYPE_SMALL		(_AT(pteval_t, 2) << 0)
+#define PTE_TYPE_EXT		(_AT(pteval_t, 3) << 0)		/* v5 */
+#define PTE_BUFFERABLE		(_AT(pteval_t, 1) << 2)
+#define PTE_CACHEABLE		(_AT(pteval_t, 1) << 3)
 
 /*
  *   - extended small page/tiny page
  */
-#define PTE_EXT_XN		(1 << 0)	/* v6 */
-#define PTE_EXT_AP_MASK		(3 << 4)
-#define PTE_EXT_AP0		(1 << 4)
-#define PTE_EXT_AP1		(2 << 4)
-#define PTE_EXT_AP_UNO_SRO	(0 << 4)
+#define PTE_EXT_XN		(_AT(pteval_t, 1) << 0)		/* v6 */
+#define PTE_EXT_AP_MASK		(_AT(pteval_t, 3) << 4)
+#define PTE_EXT_AP0		(_AT(pteval_t, 1) << 4)
+#define PTE_EXT_AP1		(_AT(pteval_t, 2) << 4)
+#define PTE_EXT_AP_UNO_SRO	(_AT(pteval_t, 0) << 4)
 #define PTE_EXT_AP_UNO_SRW	(PTE_EXT_AP0)
 #define PTE_EXT_AP_URO_SRW	(PTE_EXT_AP1)
 #define PTE_EXT_AP_URW_SRW	(PTE_EXT_AP1|PTE_EXT_AP0)
-#define PTE_EXT_TEX(x)		((x) << 6)	/* v5 */
-#define PTE_EXT_APX		(1 << 9)	/* v6 */
-#define PTE_EXT_COHERENT	(1 << 9)	/* XScale3 */
-#define PTE_EXT_SHARED		(1 << 10)	/* v6 */
-#define PTE_EXT_NG		(1 << 11)	/* v6 */
+#define PTE_EXT_TEX(x)		(_AT(pteval_t, (x)) << 6)	/* v5 */
+#define PTE_EXT_APX		(_AT(pteval_t, 1) << 9)		/* v6 */
+#define PTE_EXT_COHERENT	(_AT(pteval_t, 1) << 9)		/* XScale3 */
+#define PTE_EXT_SHARED		(_AT(pteval_t, 1) << 10)	/* v6 */
+#define PTE_EXT_NG		(_AT(pteval_t, 1) << 11)	/* v6 */
 
 /*
  *   - small page
  */
-#define PTE_SMALL_AP_MASK	(0xff << 4)
-#define PTE_SMALL_AP_UNO_SRO	(0x00 << 4)
-#define PTE_SMALL_AP_UNO_SRW	(0x55 << 4)
-#define PTE_SMALL_AP_URO_SRW	(0xaa << 4)
-#define PTE_SMALL_AP_URW_SRW	(0xff << 4)
+#define PTE_SMALL_AP_MASK	(_AT(pteval_t, 0xff) << 4)
+#define PTE_SMALL_AP_UNO_SRO	(_AT(pteval_t, 0x00) << 4)
+#define PTE_SMALL_AP_UNO_SRW	(_AT(pteval_t, 0x55) << 4)
+#define PTE_SMALL_AP_URO_SRW	(_AT(pteval_t, 0xaa) << 4)
+#define PTE_SMALL_AP_URW_SRW	(_AT(pteval_t, 0xff) << 4)
 
 #endif
diff --git a/arch/arm/include/asm/pgtable-2level-types.h b/arch/arm/include/asm/pgtable-2level-types.h
index 8a01f62..9cb877a 100644
--- a/arch/arm/include/asm/pgtable-2level-types.h
+++ b/arch/arm/include/asm/pgtable-2level-types.h
@@ -19,7 +19,10 @@
 #ifndef _ASM_PGTABLE_2LEVEL_TYPES_H
 #define _ASM_PGTABLE_2LEVEL_TYPES_H
 
-typedef unsigned long pteval_t;
+typedef u32 pteval_t;
+typedef u32 pmdval_t;
+typedef u32 pgdval_t;
+typedef u32 pgprotval_t;
 
 #undef STRICT_MM_TYPECHECKS
 
@@ -28,9 +31,9 @@ typedef unsigned long pteval_t;
  * These are used to make use of C type-checking..
  */
 typedef struct { pteval_t pte; } pte_t;
-typedef struct { unsigned long pmd; } pmd_t;
-typedef struct { unsigned long pgd[2]; } pgd_t;
-typedef struct { unsigned long pgprot; } pgprot_t;
+typedef struct { pmdval_t pmd; } pmd_t;
+typedef struct { pgdval_t pgd[2]; } pgd_t;
+typedef struct { pgprotval_t pgprot; } pgprot_t;
 
 #define pte_val(x)      ((x).pte)
 #define pmd_val(x)      ((x).pmd)
@@ -46,9 +49,9 @@ typedef struct { unsigned long pgprot; } pgprot_t;
  * .. while these make it easier on the compiler
  */
 typedef pteval_t pte_t;
-typedef unsigned long pmd_t;
-typedef unsigned long pgd_t[2];
-typedef unsigned long pgprot_t;
+typedef pmdval_t pmd_t;
+typedef pgdval_t pgd_t[2];
+typedef pgprotval_t pgprot_t;
 
 #define pte_val(x)      (x)
 #define pmd_val(x)      (x)
diff --git a/arch/arm/include/asm/tlbflush.h b/arch/arm/include/asm/tlbflush.h
index d2005de..2a49568 100644
--- a/arch/arm/include/asm/tlbflush.h
+++ b/arch/arm/include/asm/tlbflush.h
@@ -509,7 +509,7 @@ static inline void local_flush_tlb_kernel_page(unsigned long kaddr)
  *	these operations.  This is typically used when we are removing
  *	PMD entries.
  */
-static inline void flush_pmd_entry(pmd_t *pmd)
+static inline void flush_pmd_entry(void *pmd)
 {
 	const unsigned int __tlb_flag = __cpu_tlb_flags;
 
@@ -525,7 +525,7 @@ static inline void flush_pmd_entry(pmd_t *pmd)
 		dsb();
 }
 
-static inline void clean_pmd_entry(pmd_t *pmd)
+static inline void clean_pmd_entry(void *pmd)
 {
 	const unsigned int __tlb_flag = __cpu_tlb_flags;
 
diff --git a/arch/arm/mm/mm.h b/arch/arm/mm/mm.h
index d238410..2b179af 100644
--- a/arch/arm/mm/mm.h
+++ b/arch/arm/mm/mm.h
@@ -17,8 +17,8 @@ static inline pmd_t *pmd_off_k(unsigned long virt)
 
 struct mem_type {
 	pteval_t prot_pte;
-	unsigned int prot_l1;
-	unsigned int prot_sect;
+	pgprotval_t prot_l1;
+	pgprotval_t prot_sect;
 	unsigned int domain;
 };
 
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index a69f8e4..1a80749 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -62,7 +62,7 @@ EXPORT_SYMBOL(pgprot_kernel);
 struct cachepolicy {
 	const char	policy[16];
 	unsigned int	cr_mask;
-	unsigned int	pmd;
+	pmdval_t	pmd;
 	pteval_t	pte;
 };
 
@@ -290,7 +290,7 @@ static void __init build_mem_type_table(void)
 {
 	struct cachepolicy *cp;
 	unsigned int cr = get_cr();
-	unsigned int user_pgprot, kern_pgprot, vecs_pgprot;
+	pgprotval_t user_pgprot, kern_pgprot, vecs_pgprot;
 	int cpu_arch = cpu_architecture();
 	int i;
 

