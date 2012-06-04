Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab2FDFNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 01:13:18 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:33283 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab2FDFNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 01:13:16 -0400
Subject: [PATCH v2 6/7] kvm,x86: RCU based table free
To: peterz@infradead.org, mingo@elte.hu, mtosatti@redhat.com, avi@redhat.com
From: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Cc: raghukt@linux.vnet.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, jeremy@goop.org,
        vatsa@linux.vnet.ibm.com, hpa@zytor.com
Date: Mon, 04 Jun 2012 10:38:34 +0530
Message-ID: <20120604050822.4560.54662.stgit@abhimanyu.in.ibm.com>
In-Reply-To: <20120604050223.4560.2874.stgit@abhimanyu.in.ibm.com>
References: <20120604050223.4560.2874.stgit@abhimanyu.in.ibm.com>
User-Agent: StGit/0.16-2-g0d85
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12060318-5490-0000-0000-000001873D00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

get_user_pages_fast() depends on the IPI to hold off page table
teardown while they are locklessly walked with interrupts disabled.
If a vcpu were to be preempted while in this critical section, another
vcpu tearing down page tables would go ahead and destroy them.  when
the preempted vcpu resumes it then touches the freed pages.

Using HAVE_RCU_TABLE_FREE:

By using call_rcu_sched() to free the page-tables you'd need to
receive and process at least one tick on the woken up cpu after the
freeing, but since the in-progress gup_fast() will have IRQs disabled
this will be delayed.

http://article.gmane.org/gmane.linux.kernel/1290539

Tested-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/pgalloc.h  |    1 +
 arch/s390/mm/pgtable.c              |    1 +
 arch/sparc/include/asm/pgalloc_64.h |    1 +
 arch/x86/mm/pgtable.c               |    6 +++---
 include/asm-generic/tlb.h           |    9 +++++++++
 mm/memory.c                         |    7 +++++++
 6 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/pgalloc.h b/arch/powerpc/include/asm/pgalloc.h
index bf301ac..c33ae79 100644
--- a/arch/powerpc/include/asm/pgalloc.h
+++ b/arch/powerpc/include/asm/pgalloc.h
@@ -49,6 +49,7 @@ static inline void __tlb_remove_table(void *_table)
 
 	pgtable_free(table, shift);
 }
+#define __tlb_remove_table __tlb_remove_table
 #else /* CONFIG_SMP */
 static inline void pgtable_free_tlb(struct mmu_gather *tlb, void *table, unsigned shift)
 {
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 6e765bf..7029ed7 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -730,6 +730,7 @@ void __tlb_remove_table(void *_table)
 	else
 		free_pages((unsigned long) table, ALLOC_ORDER);
 }
+#define __tlb_remove_table __tlb_remove_table
 
 static void tlb_remove_table_smp_sync(void *arg)
 {
diff --git a/arch/sparc/include/asm/pgalloc_64.h b/arch/sparc/include/asm/pgalloc_64.h
index 40b2d7a..d10913a 100644
--- a/arch/sparc/include/asm/pgalloc_64.h
+++ b/arch/sparc/include/asm/pgalloc_64.h
@@ -106,6 +106,7 @@ static inline void __tlb_remove_table(void *_table)
 		is_page = true;
 	pgtable_free(table, is_page);
 }
+#define __tlb_remove_table __tlb_remove_table
 #else /* CONFIG_SMP */
 static inline void pgtable_free_tlb(struct mmu_gather *tlb, void *table, bool is_page)
 {
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 8573b83..34fa168 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -51,21 +51,21 @@ void ___pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
 {
 	pgtable_page_dtor(pte);
 	paravirt_release_pte(page_to_pfn(pte));
-	tlb_remove_page(tlb, pte);
+	tlb_remove_table(tlb, pte);
 }
 
 #if PAGETABLE_LEVELS > 2
 void ___pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
 {
 	paravirt_release_pmd(__pa(pmd) >> PAGE_SHIFT);
-	tlb_remove_page(tlb, virt_to_page(pmd));
+	tlb_remove_table(tlb, virt_to_page(pmd));
 }
 
 #if PAGETABLE_LEVELS > 3
 void ___pud_free_tlb(struct mmu_gather *tlb, pud_t *pud)
 {
 	paravirt_release_pud(__pa(pud) >> PAGE_SHIFT);
-	tlb_remove_page(tlb, virt_to_page(pud));
+	tlb_remove_table(tlb, virt_to_page(pud));
 }
 #endif	/* PAGETABLE_LEVELS > 3 */
 #endif	/* PAGETABLE_LEVELS > 2 */
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index f96a5b5..9ac30f7 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -19,6 +19,8 @@
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 
+static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page);
+
 #ifdef CONFIG_HAVE_RCU_TABLE_FREE
 /*
  * Semi RCU freeing of the page directories.
@@ -60,6 +62,13 @@ struct mmu_table_batch {
 extern void tlb_table_flush(struct mmu_gather *tlb);
 extern void tlb_remove_table(struct mmu_gather *tlb, void *table);
 
+#else
+
+static inline void tlb_remove_table(struct mmu_gather *tlb, void *page)
+{
+	tlb_remove_page(tlb, page);
+}
+
 #endif
 
 /*
diff --git a/mm/memory.c b/mm/memory.c
index 6105f47..c12685d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -297,6 +297,13 @@ int __tlb_remove_page(struct mmu_gather *tlb, struct page *page)
  * See the comment near struct mmu_table_batch.
  */
 
+#ifndef __tlb_remove_table
+static void __tlb_remove_table(void *table)
+{
+	free_page_and_swap_cache(table);
+}
+#endif
+
 static void tlb_remove_table_smp_sync(void *arg)
 {
 	/* Simply deliver the interrupt */

