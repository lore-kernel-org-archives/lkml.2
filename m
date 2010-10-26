Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533Ab0JZCzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:55:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932345Ab0JZCz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:55:29 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 26/43] MN10300: Rename __flush_tlb*() to local_flush_tlb*()
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 26 Oct 2010 03:55:20 +0100
Message-ID: <20101026025520.23512.19909.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename __flush_tlb*() to local_flush_tlb*() as it's more appropriate, and ready
to differentiate local from global TLB flushes when SMP is introduced.

Whilst we're at it, get rid of __flush_tlb_global() and make
local_flush_tlb_page() take an mm_struct pointer rather than VMA pointer.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/include/asm/highmem.h     |    4 +-
 arch/mn10300/include/asm/mmu_context.h |    2 +
 arch/mn10300/include/asm/tlbflush.h    |   56 ++++++++++++++++++++------------
 arch/mn10300/mm/init.c                 |    2 +
 arch/mn10300/mm/mmu-context.c          |    4 +-
 arch/mn10300/mm/pgtable.c              |    2 +
 6 files changed, 42 insertions(+), 28 deletions(-)


diff --git a/arch/mn10300/include/asm/highmem.h b/arch/mn10300/include/asm/highmem.h
index b0b187a..5fd74d8 100644
--- a/arch/mn10300/include/asm/highmem.h
+++ b/arch/mn10300/include/asm/highmem.h
@@ -86,7 +86,7 @@ static inline unsigned long kmap_atomic(struct page *page, enum km_type type)
 		BUG();
 #endif
 	set_pte(kmap_pte - idx, mk_pte(page, kmap_prot));
-	__flush_tlb_one(vaddr);
+	local_flush_tlb_one(vaddr);
 
 	return vaddr;
 }
@@ -107,7 +107,7 @@ static inline void kunmap_atomic_notypecheck(unsigned long vaddr, enum km_type t
 	 * this pte without first remap it
 	 */
 	pte_clear(kmap_pte - idx);
-	__flush_tlb_one(vaddr);
+	local_flush_tlb_one(vaddr);
 #endif
 }
 
diff --git a/arch/mn10300/include/asm/mmu_context.h b/arch/mn10300/include/asm/mmu_context.h
index cb294c2..24d63f0 100644
--- a/arch/mn10300/include/asm/mmu_context.h
+++ b/arch/mn10300/include/asm/mmu_context.h
@@ -58,7 +58,7 @@ static inline unsigned long allocate_mmu_context(struct mm_struct *mm)
 	if (!(mc & MMU_CONTEXT_TLBPID_MASK)) {
 		/* we exhausted the TLB PIDs of this version on this CPU, so we
 		 * flush this CPU's TLB in its entirety and start new cycle */
-		flush_tlb_all();
+		local_flush_tlb_all();
 
 		/* fix the TLB version if needed (we avoid version #0 so as to
 		 * distingush MMU_NO_CONTEXT) */
diff --git a/arch/mn10300/include/asm/tlbflush.h b/arch/mn10300/include/asm/tlbflush.h
index 1a7e292..5d54bf5 100644
--- a/arch/mn10300/include/asm/tlbflush.h
+++ b/arch/mn10300/include/asm/tlbflush.h
@@ -13,21 +13,37 @@
 
 #include <asm/processor.h>
 
-#define __flush_tlb()						\
-do {								\
-	int w;							\
-	__asm__ __volatile__					\
-		("	mov %1,%0		\n"		\
-		 "	or %2,%0		\n"		\
-		 "	mov %0,%1		\n"		\
-		 : "=d"(w)					\
-		 : "m"(MMUCTR), "i"(MMUCTR_IIV|MMUCTR_DIV)	\
-		 : "cc", "memory"				\
-		 );						\
-} while (0)
+/**
+ * local_flush_tlb - Flush the current MM's entries from the local CPU's TLBs
+ */
+static inline void local_flush_tlb(void)
+{
+	int w;
+	asm volatile(
+		"	mov	%1,%0		\n"
+		"	or	%2,%0		\n"
+		"	mov	%0,%1		\n"
+		: "=d"(w)
+		: "m"(MMUCTR), "i"(MMUCTR_IIV|MMUCTR_DIV)
+		: "cc", "memory");
+}
 
-#define __flush_tlb_all() __flush_tlb()
-#define __flush_tlb_one(addr) __flush_tlb()
+/**
+ * local_flush_tlb_all - Flush all entries from the local CPU's TLBs
+ */
+#define local_flush_tlb_all()		local_flush_tlb()
+
+/**
+ * local_flush_tlb_one - Flush one entry from the local CPU's TLBs
+ */
+#define local_flush_tlb_one(addr)	local_flush_tlb()
+
+/**
+ * local_flush_tlb_page - Flush a page's entry from the local CPU's TLBs
+ * @mm: The MM to flush for
+ * @addr: The address of the target page in RAM (not its page struct)
+ */
+extern void local_flush_tlb_page(struct mm_struct *mm, unsigned long addr);
 
 
 /*
@@ -43,14 +59,14 @@ do {								\
 #define flush_tlb_all()				\
 do {						\
 	preempt_disable();			\
-	__flush_tlb_all();			\
+	local_flush_tlb_all();			\
 	preempt_enable();			\
 } while (0)
 
 #define flush_tlb_mm(mm)			\
 do {						\
 	preempt_disable();			\
-	__flush_tlb_all();			\
+	local_flush_tlb_all();			\
 	preempt_enable();			\
 } while (0)
 
@@ -59,13 +75,13 @@ do {								\
 	unsigned long __s __attribute__((unused)) = (start);	\
 	unsigned long __e __attribute__((unused)) = (end);	\
 	preempt_disable();					\
-	__flush_tlb_all();					\
+	local_flush_tlb_all();					\
 	preempt_enable();					\
 } while (0)
 
+#define flush_tlb_page(vma, addr)	local_flush_tlb_page((vma)->vm_mm, addr)
+#define flush_tlb()			flush_tlb_all()
 
-#define __flush_tlb_global()			flush_tlb_all()
-#define flush_tlb()				flush_tlb_all()
 #define flush_tlb_kernel_range(start, end)			\
 do {								\
 	unsigned long __s __attribute__((unused)) = (start);	\
@@ -73,8 +89,6 @@ do {								\
 	flush_tlb_all();					\
 } while (0)
 
-extern void flush_tlb_page(struct vm_area_struct *vma, unsigned long addr);
-
 #define flush_tlb_pgtables(mm, start, end)	do {} while (0)
 
 #endif /* _ASM_TLBFLUSH_H */
diff --git a/arch/mn10300/mm/init.c b/arch/mn10300/mm/init.c
index f86c283..1daf97f 100644
--- a/arch/mn10300/mm/init.c
+++ b/arch/mn10300/mm/init.c
@@ -73,7 +73,7 @@ void __init paging_init(void)
 	/* pass the memory from the bootmem allocator to the main allocator */
 	free_area_init(zones_size);
 
-	__flush_tlb_all();
+	local_flush_tlb_all();
 }
 
 /*
diff --git a/arch/mn10300/mm/mmu-context.c b/arch/mn10300/mm/mmu-context.c
index 36ba021..3d83966 100644
--- a/arch/mn10300/mm/mmu-context.c
+++ b/arch/mn10300/mm/mmu-context.c
@@ -23,7 +23,7 @@ unsigned long mmu_context_cache[NR_CPUS] = {
 /*
  * flush the specified TLB entry
  */
-void flush_tlb_page(struct vm_area_struct *vma, unsigned long addr)
+void local_flush_tlb_page(struct mm_struct *mm, unsigned long addr)
 {
 	unsigned long pteu, cnx, flags;
 
@@ -33,7 +33,7 @@ void flush_tlb_page(struct vm_area_struct *vma, unsigned long addr)
 	 * interference from vmalloc'd regions */
 	local_irq_save(flags);
 
-	cnx = mm_context(vma->vm_mm);
+	cnx = mm_context(mm);
 
 	if (cnx != MMU_NO_CONTEXT) {
 		pteu = addr | (cnx & 0x000000ffUL);
diff --git a/arch/mn10300/mm/pgtable.c b/arch/mn10300/mm/pgtable.c
index 9c1624c..450f7ba 100644
--- a/arch/mn10300/mm/pgtable.c
+++ b/arch/mn10300/mm/pgtable.c
@@ -59,7 +59,7 @@ void set_pmd_pfn(unsigned long vaddr, unsigned long pfn, pgprot_t flags)
 	 * It's enough to flush this one mapping.
 	 * (PGE mappings get flushed as well)
 	 */
-	__flush_tlb_one(vaddr);
+	local_flush_tlb_one(vaddr);
 }
 
 pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)

