Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693Ab0KLSEB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:04:01 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50895 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756452Ab0KLSBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:01:02 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 05/20] ARM: LPAE: Introduce L_PTE_NOEXEC and L_PTE_NOWRITE
Date: Fri, 12 Nov 2010 18:00:25 +0000
Message-Id: <1289584840-18097-6-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.3.2.164.g6f10c
In-Reply-To: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 12 Nov 2010 18:00:49.0641 (UTC) FILETIME=[89F32D90:01CB8293]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LPAE page table format needs to explicitly disable execution or
write permissions on a page by setting the corresponding bits (similar
to the classic page table format with Access Flag enabled). This patch
introduces null definitions for the 2-level format and the actual noexec
and nowrite bits for the LPAE format. It also changes several PTE
maintenance macros and masks.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/include/asm/pgtable-2level.h |    2 +
 arch/arm/include/asm/pgtable.h        |   44 +++++++++++++++++++++------------
 arch/arm/mm/mmu.c                     |    6 ++--
 3 files changed, 33 insertions(+), 19 deletions(-)

diff --git a/arch/arm/include/asm/pgtable-2level.h b/arch/arm/include/asm/pgtable-2level.h
index 36bdef7..4e21166 100644
--- a/arch/arm/include/asm/pgtable-2level.h
+++ b/arch/arm/include/asm/pgtable-2level.h
@@ -128,6 +128,8 @@
 #define L_PTE_USER		(1 << 8)
 #define L_PTE_EXEC		(1 << 9)
 #define L_PTE_SHARED		(1 << 10)	/* shared(v6), coherent(xsc3) */
+#define L_PTE_NOEXEC		(0)
+#define L_PTE_NOWRITE		(0)
 
 /*
  * These are the memory types, defined to be compatible with
diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index ea08ab7..5bd0e64 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -66,23 +66,23 @@ extern pgprot_t		pgprot_kernel;
 
 #define _MOD_PROT(p, b)	__pgprot(pgprot_val(p) | (b))
 
-#define PAGE_NONE		pgprot_user
-#define PAGE_SHARED		_MOD_PROT(pgprot_user, L_PTE_USER | L_PTE_WRITE)
+#define PAGE_NONE		_MOD_PROT(pgprot_user, L_PTE_NOEXEC | L_PTE_NOWRITE)
+#define PAGE_SHARED		_MOD_PROT(pgprot_user, L_PTE_USER | L_PTE_WRITE | L_PTE_NOEXEC)
 #define PAGE_SHARED_EXEC	_MOD_PROT(pgprot_user, L_PTE_USER | L_PTE_WRITE | L_PTE_EXEC)
-#define PAGE_COPY		_MOD_PROT(pgprot_user, L_PTE_USER)
-#define PAGE_COPY_EXEC		_MOD_PROT(pgprot_user, L_PTE_USER | L_PTE_EXEC)
-#define PAGE_READONLY		_MOD_PROT(pgprot_user, L_PTE_USER)
-#define PAGE_READONLY_EXEC	_MOD_PROT(pgprot_user, L_PTE_USER | L_PTE_EXEC)
-#define PAGE_KERNEL		pgprot_kernel
+#define PAGE_COPY		_MOD_PROT(pgprot_user, L_PTE_USER | L_PTE_NOEXEC | L_PTE_NOWRITE)
+#define PAGE_COPY_EXEC		_MOD_PROT(pgprot_user, L_PTE_USER | L_PTE_EXEC | L_PTE_NOWRITE)
+#define PAGE_READONLY		_MOD_PROT(pgprot_user, L_PTE_USER | L_PTE_NOEXEC | L_PTE_NOWRITE)
+#define PAGE_READONLY_EXEC	_MOD_PROT(pgprot_user, L_PTE_USER | L_PTE_EXEC | L_PTE_NOWRITE)
+#define PAGE_KERNEL		_MOD_PROT(pgprot_kernel, L_PTE_NOEXEC)
 #define PAGE_KERNEL_EXEC	_MOD_PROT(pgprot_kernel, L_PTE_EXEC)
 
-#define __PAGE_NONE		__pgprot(_L_PTE_DEFAULT)
-#define __PAGE_SHARED		__pgprot(_L_PTE_DEFAULT | L_PTE_USER | L_PTE_WRITE)
+#define __PAGE_NONE		__pgprot(_L_PTE_DEFAULT | L_PTE_NOEXEC | L_PTE_NOWRITE)
+#define __PAGE_SHARED		__pgprot(_L_PTE_DEFAULT | L_PTE_USER | L_PTE_WRITE | L_PTE_NOEXEC)
 #define __PAGE_SHARED_EXEC	__pgprot(_L_PTE_DEFAULT | L_PTE_USER | L_PTE_WRITE | L_PTE_EXEC)
-#define __PAGE_COPY		__pgprot(_L_PTE_DEFAULT | L_PTE_USER)
-#define __PAGE_COPY_EXEC	__pgprot(_L_PTE_DEFAULT | L_PTE_USER | L_PTE_EXEC)
-#define __PAGE_READONLY		__pgprot(_L_PTE_DEFAULT | L_PTE_USER)
-#define __PAGE_READONLY_EXEC	__pgprot(_L_PTE_DEFAULT | L_PTE_USER | L_PTE_EXEC)
+#define __PAGE_COPY		__pgprot(_L_PTE_DEFAULT | L_PTE_USER | L_PTE_NOEXEC | L_PTE_NOWRITE)
+#define __PAGE_COPY_EXEC	__pgprot(_L_PTE_DEFAULT | L_PTE_USER | L_PTE_EXEC | L_PTE_NOWRITE)
+#define __PAGE_READONLY		__pgprot(_L_PTE_DEFAULT | L_PTE_USER | L_PTE_NOEXEC | L_PTE_NOWRITE)
+#define __PAGE_READONLY_EXEC	__pgprot(_L_PTE_DEFAULT | L_PTE_USER | L_PTE_EXEC | L_PTE_NOWRITE)
 
 #endif /* __ASSEMBLY__ */
 
@@ -165,12 +165,18 @@ static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
  * Undefined behaviour if not..
  */
 #define pte_present(pte)	(pte_val(pte) & L_PTE_PRESENT)
-#define pte_write(pte)		(pte_val(pte) & L_PTE_WRITE)
 #define pte_dirty(pte)		(pte_val(pte) & L_PTE_DIRTY)
 #define pte_young(pte)		(pte_val(pte) & L_PTE_YOUNG)
-#define pte_exec(pte)		(pte_val(pte) & L_PTE_EXEC)
 #define pte_special(pte)	(0)
 
+#ifdef CONFIG_ARM_LPAE
+#define pte_write(pte)		(!(pte_val(pte) & L_PTE_NOWRITE))
+#define pte_exec(pte)		(!(pte_val(pte) & L_PTE_NOEXEC))
+#else
+#define pte_write(pte)		(pte_val(pte) & L_PTE_WRITE)
+#define pte_exec(pte)		(pte_val(pte) & L_PTE_EXEC)
+#endif
+
 #define pte_present_user(pte) \
 	((pte_val(pte) & (L_PTE_PRESENT | L_PTE_USER)) == \
 	 (L_PTE_PRESENT | L_PTE_USER))
@@ -178,8 +184,13 @@ static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
 #define PTE_BIT_FUNC(fn,op) \
 static inline pte_t pte_##fn(pte_t pte) { pte_val(pte) op; return pte; }
 
+#ifdef CONFIG_ARM_LPAE
+PTE_BIT_FUNC(wrprotect, |= L_PTE_NOWRITE);
+PTE_BIT_FUNC(mkwrite,   &= ~L_PTE_NOWRITE);
+#else
 PTE_BIT_FUNC(wrprotect, &= ~L_PTE_WRITE);
 PTE_BIT_FUNC(mkwrite,   |= L_PTE_WRITE);
+#endif
 PTE_BIT_FUNC(mkclean,   &= ~L_PTE_DIRTY);
 PTE_BIT_FUNC(mkdirty,   |= L_PTE_DIRTY);
 PTE_BIT_FUNC(mkold,     &= ~L_PTE_YOUNG);
@@ -272,7 +283,8 @@ static inline pte_t *pmd_page_vaddr(pmd_t pmd)
 
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 {
-	const unsigned long mask = L_PTE_EXEC | L_PTE_WRITE | L_PTE_USER;
+	const unsigned long mask = L_PTE_EXEC | L_PTE_WRITE | L_PTE_USER |
+		L_PTE_NOEXEC | L_PTE_NOWRITE;
 	pte_val(pte) = (pte_val(pte) & ~mask) | (pgprot_val(newprot) & mask);
 	return pte;
 }
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 7324fbc..0ca33dd 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -191,7 +191,7 @@ void adjust_cr(unsigned long mask, unsigned long set)
 }
 #endif
 
-#define PROT_PTE_DEVICE		L_PTE_PRESENT|L_PTE_YOUNG|L_PTE_DIRTY|L_PTE_WRITE
+#define PROT_PTE_DEVICE		L_PTE_PRESENT|L_PTE_YOUNG|L_PTE_DIRTY|L_PTE_WRITE|L_PTE_NOEXEC
 #define PROT_SECT_DEVICE	PMD_TYPE_SECT|PMD_SECT_AP_WRITE
 
 static struct mem_type mem_types[] = {
@@ -236,13 +236,13 @@ static struct mem_type mem_types[] = {
 	},
 	[MT_LOW_VECTORS] = {
 		.prot_pte  = L_PTE_PRESENT | L_PTE_YOUNG | L_PTE_DIRTY |
-				L_PTE_EXEC,
+				L_PTE_EXEC | L_PTE_NOWRITE,
 		.prot_l1   = PMD_TYPE_TABLE,
 		.domain    = DOMAIN_USER,
 	},
 	[MT_HIGH_VECTORS] = {
 		.prot_pte  = L_PTE_PRESENT | L_PTE_YOUNG | L_PTE_DIRTY |
-				L_PTE_USER | L_PTE_EXEC,
+				L_PTE_USER | L_PTE_EXEC | L_PTE_NOWRITE,
 		.prot_l1   = PMD_TYPE_TABLE,
 		.domain    = DOMAIN_USER,
 	},
