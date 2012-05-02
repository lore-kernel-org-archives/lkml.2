Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab2EBKVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 06:21:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:47894 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab2EBKVX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 06:21:23 -0400
Message-ID: <1335954040.13683.175.camel@twins>
Subject: Re: [RFC PATCH v1 3/5] KVM: Add paravirt kvm_flush_tlb_others
From: Peter Zijlstra <peterz@infradead.org>
To: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, mingo@elte.hu, jeremy@goop.org,
        mtosatti@redhat.com, kvm@vger.kernel.org, x86@kernel.org,
        vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, hpa@zytor.com
Date: Wed, 02 May 2012 12:20:40 +0200
In-Reply-To: <87obq7ge4d.fsf@linux.vnet.ibm.com>
References: <20120427161727.27082.43096.stgit@abhimanyu>
	 <20120427162401.27082.59387.stgit@abhimanyu> <4F9D32B4.8040002@redhat.com>
	 <1335865176.13683.120.camel@twins> <87obq7ge4d.fsf@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-02 at 14:21 +0530, Nikunj A Dadhania wrote:
> [root@krm1 linux]# grep HAVE_RCU_TABLE .config
> CONFIG_HAVE_RCU_TABLE_FREE=y
> [root@krm1 linux]# make -j32  -s
> mm/memory.c: In function ‘tlb_remove_table_one’:
> mm/memory.c:315: error: implicit declaration of function ‘__tlb_remove_table’
> 
> I suppose we need to have __tlb_remove_table. Trying to understand what
> needs to be done there. 

Argh, I really should get back to unifying all mmu-gather
implementations :/

I think something like the below ought to sort it.

Completely untested though..

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
index f96a5b5..8ca33e9 100644
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
+static inline void tlb_remove_table(struct mmu_gather *tlb, void *table)
+{
+	tlb_remove_page(tlb, page);
+}
+
 #endif
 
 /*
diff --git a/mm/memory.c b/mm/memory.c
index bf8b403..6ca6561 100644
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

