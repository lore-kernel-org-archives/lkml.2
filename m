Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab1BQMHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 07:07:30 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43815 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab1BQMH1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 07:07:27 -0500
Subject: Re: [PATCH 00/25] mm: Preemptibility -v7
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
In-Reply-To: <20110125173111.720927511@chello.nl>
References: <20110125173111.720927511@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 17 Feb 2011 13:06:39 +0100
Message-ID: <1297944399.2413.1672.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-25 at 18:31 +0100, Peter Zijlstra wrote:
>  - figure out what to do with sparc's tlb_batch lack of ->fullmm

David, how does this look?

---
Index: linux-2.6/arch/sparc/mm/tlb.c
===================================================================
--- linux-2.6.orig/arch/sparc/mm/tlb.c
+++ linux-2.6/arch/sparc/mm/tlb.c
@@ -43,7 +43,8 @@ void flush_tlb_pending(void)
 	put_cpu_var(tlb_batch);
 }
 
-void tlb_batch_add(struct mm_struct *mm, unsigned long vaddr, pte_t *ptep, pte_t orig)
+void tlb_batch_add(struct mm_struct *mm, unsigned long vaddr, 
+		   pte_t *ptep, pte_t orig, int fullmm)
 {
 	struct tlb_batch *tb = &get_cpu_var(tlb_batch);
 	unsigned long nr;
@@ -77,12 +78,10 @@ void tlb_batch_add(struct mm_struct *mm,
 
 no_cache_flush:
 
-	/*
-	if (tb->fullmm) {
+	if (fullmm) {
 		put_cpu_var(tlb_batch);
 		return;
 	}
-	*/
 
 	nr = tb->tlb_nr;
 
Index: linux-2.6/arch/sparc/include/asm/pgtable_64.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/pgtable_64.h
+++ linux-2.6/arch/sparc/include/asm/pgtable_64.h
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
 
@@ -670,12 +672,19 @@ static inline void set_pte_at(struct mm_
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

