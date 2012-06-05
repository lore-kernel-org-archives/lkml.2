Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761794Ab2FEKsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 06:48:12 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:48426 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab2FEKsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 06:48:10 -0400
X-IronPort-AV: E=Sophos;i="4.75,718,1330905600"; 
   d="scan'208";a="12835503"
Date: Tue, 5 Jun 2012 11:48:02 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
CC: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "avi@redhat.com" <avi@redhat.com>,
        "raghukt@linux.vnet.ibm.com" <raghukt@linux.vnet.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "jeremy@goop.org" <jeremy@goop.org>,
        "vatsa@linux.vnet.ibm.com" <vatsa@linux.vnet.ibm.com>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH v2 6/7] kvm,x86: RCU based table free
In-Reply-To: <20120604050822.4560.54662.stgit@abhimanyu.in.ibm.com>
Message-ID: <alpine.DEB.2.02.1206051137270.6030@kaball.uk.xensource.com>
References: <20120604050223.4560.2874.stgit@abhimanyu.in.ibm.com> <20120604050822.4560.54662.stgit@abhimanyu.in.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2012, Nikunj A. Dadhania wrote:
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> get_user_pages_fast() depends on the IPI to hold off page table
> teardown while they are locklessly walked with interrupts disabled.
> If a vcpu were to be preempted while in this critical section, another
> vcpu tearing down page tables would go ahead and destroy them.  when
> the preempted vcpu resumes it then touches the freed pages.
> 
> Using HAVE_RCU_TABLE_FREE:
> 
> By using call_rcu_sched() to free the page-tables you'd need to
> receive and process at least one tick on the woken up cpu after the
> freeing, but since the in-progress gup_fast() will have IRQs disabled
> this will be delayed.
> 
> http://article.gmane.org/gmane.linux.kernel/1290539
> 
> Tested-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
> Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
>
>  arch/powerpc/include/asm/pgalloc.h  |    1 +
>  arch/s390/mm/pgtable.c              |    1 +
>  arch/sparc/include/asm/pgalloc_64.h |    1 +
>  arch/x86/mm/pgtable.c               |    6 +++---
>  include/asm-generic/tlb.h           |    9 +++++++++
>  mm/memory.c                         |    7 +++++++
>  6 files changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/pgalloc.h b/arch/powerpc/include/asm/pgalloc.h
> index bf301ac..c33ae79 100644
> --- a/arch/powerpc/include/asm/pgalloc.h
> +++ b/arch/powerpc/include/asm/pgalloc.h
> @@ -49,6 +49,7 @@ static inline void __tlb_remove_table(void *_table)
>  
>  	pgtable_free(table, shift);
>  }
> +#define __tlb_remove_table __tlb_remove_table
>  #else /* CONFIG_SMP */
>  static inline void pgtable_free_tlb(struct mmu_gather *tlb, void *table, unsigned shift)
>  {
> diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
> index 6e765bf..7029ed7 100644
> --- a/arch/s390/mm/pgtable.c
> +++ b/arch/s390/mm/pgtable.c
> @@ -730,6 +730,7 @@ void __tlb_remove_table(void *_table)
>  	else
>  		free_pages((unsigned long) table, ALLOC_ORDER);
>  }
> +#define __tlb_remove_table __tlb_remove_table
>  
>  static void tlb_remove_table_smp_sync(void *arg)
>  {
> diff --git a/arch/sparc/include/asm/pgalloc_64.h b/arch/sparc/include/asm/pgalloc_64.h
> index 40b2d7a..d10913a 100644
> --- a/arch/sparc/include/asm/pgalloc_64.h
> +++ b/arch/sparc/include/asm/pgalloc_64.h
> @@ -106,6 +106,7 @@ static inline void __tlb_remove_table(void *_table)
>  		is_page = true;
>  	pgtable_free(table, is_page);
>  }
> +#define __tlb_remove_table __tlb_remove_table
>  #else /* CONFIG_SMP */
>  static inline void pgtable_free_tlb(struct mmu_gather *tlb, void *table, bool is_page)
>  {
> diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
> index 8573b83..34fa168 100644
> --- a/arch/x86/mm/pgtable.c
> +++ b/arch/x86/mm/pgtable.c
> @@ -51,21 +51,21 @@ void ___pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
>  {
>  	pgtable_page_dtor(pte);
>  	paravirt_release_pte(page_to_pfn(pte));
> -	tlb_remove_page(tlb, pte);
> +	tlb_remove_table(tlb, pte);
>  }
>  
>  #if PAGETABLE_LEVELS > 2
>  void ___pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
>  {
>  	paravirt_release_pmd(__pa(pmd) >> PAGE_SHIFT);
> -	tlb_remove_page(tlb, virt_to_page(pmd));
> +	tlb_remove_table(tlb, virt_to_page(pmd));
>  }
>  
>  #if PAGETABLE_LEVELS > 3
>  void ___pud_free_tlb(struct mmu_gather *tlb, pud_t *pud)
>  {
>  	paravirt_release_pud(__pa(pud) >> PAGE_SHIFT);
> -	tlb_remove_page(tlb, virt_to_page(pud));
> +	tlb_remove_table(tlb, virt_to_page(pud));
>  }
>  #endif	/* PAGETABLE_LEVELS > 3 */
>  #endif	/* PAGETABLE_LEVELS > 2 */
> diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
> index f96a5b5..9ac30f7 100644
> --- a/include/asm-generic/tlb.h
> +++ b/include/asm-generic/tlb.h
> @@ -19,6 +19,8 @@
>  #include <asm/pgalloc.h>
>  #include <asm/tlbflush.h>
>  
> +static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page);
> +
>  #ifdef CONFIG_HAVE_RCU_TABLE_FREE
>  /*
>   * Semi RCU freeing of the page directories.
> @@ -60,6 +62,13 @@ struct mmu_table_batch {
>  extern void tlb_table_flush(struct mmu_gather *tlb);
>  extern void tlb_remove_table(struct mmu_gather *tlb, void *table);
>  
> +#else
> +
> +static inline void tlb_remove_table(struct mmu_gather *tlb, void *page)
> +{
> +	tlb_remove_page(tlb, page);
> +}
> +
>  #endif
>  
>  /*
> diff --git a/mm/memory.c b/mm/memory.c
> index 6105f47..c12685d 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -297,6 +297,13 @@ int __tlb_remove_page(struct mmu_gather *tlb, struct page *page)
>   * See the comment near struct mmu_table_batch.
>   */
>  
> +#ifndef __tlb_remove_table
> +static void __tlb_remove_table(void *table)
> +{
> +	free_page_and_swap_cache(table);
> +}
> +#endif
> +
>  static void tlb_remove_table_smp_sync(void *arg)
>  {
>  	/* Simply deliver the interrupt */
 

I am also interested in introducing HAVE_RCU_TABLE_FREE on x86 for Xen.
Maybe we can pull our efforts together :-)

Giving a look at this patch, it doesn't look like it is introducing
CONFIG_HAVE_RCU_TABLE_FREE anywhere under arch/x86.
How is the user supposed to set it?

I am appending the version of this patch I was working on: it introduces
a pvop in order not to force HAVE_RCU_TABLE_FREE on native x86.


>From cbb816810f17b57627285383c3d0f771dc89939f Mon Sep 17 00:00:00 2001
From: Peter Zijlstra <peterz@infradead.org>
Date: Tue, 22 May 2012 11:39:44 +0000
Subject: [PATCH] [RFC] Introduce a new pv_mmu_op to free a directory page

At the moment get_user_pages_fast is unsafe on Xen, because it relies on
the fact that flush_tlb_others sends an IPI to flush the tlb but
xen_flush_tlb_others doesn't send any IPIs and always returns succesfully
and immediately.

The kernel offers HAVE_RCU_TABLE_FREE that enables an RCU lock to
protect this kind of software pagetable walks (see
include/asm-generic/tlb.h).
The goal of this patch is to enable HAVE_RCU_TABLE_FREE on Xen without
impacting the native x86 case.

The original patch to enable HAVE_RCU_TABLE_FREE on x86 is by Peter
Zijlstra, see http://marc.info/?l=linux-kernel&m=133595422305515&w=2; I
have only modified it so that it enables HAVE_RCU_TABLE_FREE on Xen
but not on native.
It does so by introducing a new pv_mmu_op to free a directory page:
pv_mmu_ops.tlb_remove_table.
The pvop is set to tlb_remove_page on native and to tlb_remove_table on
Xen.

The result is that if CONFIG_XEN is disabled, the behavior is the same
as today.
If CONFIG_XEN is enabled and we are running on native,
HAVE_RCU_TABLE_FREE is set but tlb_remove_table is never called: we
still call tlb_remove_page so there should be no performance penalty.
If CONFIG_XEN is enabled and we are running on Xen we make full usage of
the RCU directory page freeing as described in tlb.h.

Please advice on how to proceed: is it correct to enable
HAVE_RCU_TABLE_FREE but never call tlb_remove_table?
Is the pvops really the best thing to do here?
Maybe we can just implement get_user_pages_fast as a call to
get_user_pages on Xen?

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/powerpc/include/asm/pgalloc.h    |    1 +
 arch/s390/mm/pgtable.c                |    1 +
 arch/sparc/include/asm/pgalloc_64.h   |    1 +
 arch/x86/include/asm/paravirt.h       |    6 ++++++
 arch/x86/include/asm/paravirt_types.h |    3 +++
 arch/x86/include/asm/pgalloc.h        |    1 +
 arch/x86/kernel/paravirt.c            |    2 ++
 arch/x86/mm/pgtable.c                 |    6 +++---
 arch/x86/xen/Kconfig                  |    1 +
 arch/x86/xen/mmu.c                    |    7 +++++++
 mm/memory.c                           |    7 +++++++
 11 files changed, 33 insertions(+), 3 deletions(-)

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
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index aa0f913..42c6a9b 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -402,6 +402,12 @@ static inline void flush_tlb_others(const struct cpumask *cpumask,
 	PVOP_VCALL3(pv_mmu_ops.flush_tlb_others, cpumask, mm, va);
 }
 
+static inline void paravirt_tlb_remove_table(struct mmu_gather *tlb,
+		struct page *page)
+{
+	PVOP_VCALL2(pv_mmu_ops.tlb_remove_table, tlb, page);
+}
+
 static inline int paravirt_pgd_alloc(struct mm_struct *mm)
 {
 	return PVOP_CALL1(int, pv_mmu_ops.pgd_alloc, mm);
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 8e8b9a4..7e5ad6d 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -51,6 +51,7 @@ struct mm_struct;
 struct desc_struct;
 struct task_struct;
 struct cpumask;
+struct mmu_gather;
 
 /*
  * Wrapper type for pointers to code which uses the non-standard
@@ -251,6 +252,8 @@ struct pv_mmu_ops {
 	void (*flush_tlb_others)(const struct cpumask *cpus,
 				 struct mm_struct *mm,
 				 unsigned long va);
+	/* free a directory page */
+	void (*tlb_remove_table)(struct mmu_gather *tlb, struct page *page);
 
 	/* Hooks for allocating and freeing a pagetable top-level */
 	int  (*pgd_alloc)(struct mm_struct *mm);
diff --git a/arch/x86/include/asm/pgalloc.h b/arch/x86/include/asm/pgalloc.h
index b4389a4..0cc3251 100644
--- a/arch/x86/include/asm/pgalloc.h
+++ b/arch/x86/include/asm/pgalloc.h
@@ -20,6 +20,7 @@ static inline void paravirt_alloc_pud(struct mm_struct *mm, unsigned long pfn)	{
 static inline void paravirt_release_pte(unsigned long pfn) {}
 static inline void paravirt_release_pmd(unsigned long pfn) {}
 static inline void paravirt_release_pud(unsigned long pfn) {}
+#define paravirt_tlb_remove_table(tlb, page) tlb_remove_page(tlb, page)
 #endif
 
 /*
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index ab13760..370b3b4 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -37,6 +37,7 @@
 #include <asm/fixmap.h>
 #include <asm/apic.h>
 #include <asm/tlbflush.h>
+#include <asm/tlb.h>
 #include <asm/timer.h>
 #include <asm/special_insns.h>
 
@@ -422,6 +423,7 @@ struct pv_mmu_ops pv_mmu_ops = {
 	.flush_tlb_kernel = native_flush_tlb_global,
 	.flush_tlb_single = native_flush_tlb_single,
 	.flush_tlb_others = native_flush_tlb_others,
+	.tlb_remove_table = tlb_remove_page,
 
 	.pgd_alloc = __paravirt_pgd_alloc,
 	.pgd_free = paravirt_nop,
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 8573b83..904d45c 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -51,21 +51,21 @@ void ___pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
 {
 	pgtable_page_dtor(pte);
 	paravirt_release_pte(page_to_pfn(pte));
-	tlb_remove_page(tlb, pte);
+	paravirt_tlb_remove_table(tlb, pte);
 }
 
 #if PAGETABLE_LEVELS > 2
 void ___pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
 {
 	paravirt_release_pmd(__pa(pmd) >> PAGE_SHIFT);
-	tlb_remove_page(tlb, virt_to_page(pmd));
+	paravirt_tlb_remove_table(tlb, virt_to_page(pmd));
 }
 
 #if PAGETABLE_LEVELS > 3
 void ___pud_free_tlb(struct mmu_gather *tlb, pud_t *pud)
 {
 	paravirt_release_pud(__pa(pud) >> PAGE_SHIFT);
-	tlb_remove_page(tlb, virt_to_page(pud));
+	paravirt_tlb_remove_table(tlb, virt_to_page(pud));
 }
 #endif	/* PAGETABLE_LEVELS > 3 */
 #endif	/* PAGETABLE_LEVELS > 2 */
diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index fdce49c..e2efb29 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -6,6 +6,7 @@ config XEN
 	bool "Xen guest support"
 	select PARAVIRT
 	select PARAVIRT_CLOCK
+	select HAVE_RCU_TABLE_FREE if SMP
 	depends on X86_64 || (X86_32 && X86_PAE && !X86_VISWS)
 	depends on X86_CMPXCHG && X86_TSC
 	help
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 69f5857..a58153b 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -62,6 +62,7 @@
 #include <asm/init.h>
 #include <asm/pat.h>
 #include <asm/smp.h>
+#include <asm/tlb.h>
 
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
@@ -1281,6 +1282,11 @@ static void xen_flush_tlb_others(const struct cpumask *cpus,
 	xen_mc_issue(PARAVIRT_LAZY_MMU);
 }
 
+static void xen_tlb_remove_table(struct mmu_gather *tlb, struct page *page)
+{
+	tlb_remove_table(tlb, page);
+}
+
 static unsigned long xen_read_cr3(void)
 {
 	return this_cpu_read(xen_cr3);
@@ -2006,6 +2012,7 @@ static const struct pv_mmu_ops xen_mmu_ops __initconst = {
 	.flush_tlb_kernel = xen_flush_tlb,
 	.flush_tlb_single = xen_flush_tlb_single,
 	.flush_tlb_others = xen_flush_tlb_others,
+	.tlb_remove_table = xen_tlb_remove_table,
 
 	.pte_update = paravirt_nop,
 	.pte_update_defer = paravirt_nop,
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
-- 
1.7.2.5

