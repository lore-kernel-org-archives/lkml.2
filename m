Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476Ab2JAXGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:06:31 -0400
Received: from 1wt.eu ([62.212.114.60]:35769 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165Ab2JAXG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:06:29 -0400
Message-Id: <20121001225157.866105297@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:03 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Philipp Hahn <hahn@univention.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, <stable@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Willy Tarreau <w@1wt.eu>
Subject: [ 006/180] fix pgd_lock deadlock
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Hahn <hahn@univention.de>

commit a79e53d85683c6dd9f99c90511028adc2043031f upstream.

On Wednesday 16 February 2011 15:49:47 Andrea Arcangeli wrote:
> Subject: fix pgd_lock deadlock
>
> From: Andrea Arcangeli <aarcange@redhat.com>
>
> It's forbidden to take the page_table_lock with the irq disabled or if
> there's contention the IPIs (for tlb flushes) sent with the page_table_lock
> held will never run leading to a deadlock.
>
> Apparently nobody takes the pgd_lock from irq so the _irqsave can be
> removed.
>
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>

This patch (original commit Id for 2.6.38 a79e53d85683c6dd9f99c90511028adc2043031f)
needs to be back-ported to 2.6.32.x as well.
I observed a dead-lock problem when running a PAE enabled Debian 2.6.32.46+
kernel with 6 VCPUs as a KVM on (2.6.32, 3.2, 3.3) kernel, which showed the
following behaviour:

1 VCPU is stuck in
  pgd_alloc() =E2=86=92 pgd_prepopulate_pmb() =E2=86=92... =E2=86=92  flush_tlb_others_ipi()
while (!cpumask_empty(to_cpumask(f->flush_cpumask)))
    cpu_relax();
(gdb) print f->flush_cpumask
$5 = {1}

while all other VCPUs are stuck in
  pgd_alloc() =E2=86=92 spin_lock_irqsave(pgd_lock)

I tracked it down to the commit
 2.6.39-rc1: 4981d01eada5354d81c8929d5b2836829ba3df7b
 2.6.32.34: ba456fd7ec1bdc31a4ad4a6bd02802dcaa730a33
 x86: Flush TLB if PGD entry is changed in i386 PAE mode
which when reverted made the bug disappear.

Comparing 3.2 to 2.6.32.34 showed that the 'pgd-deadlock'-patch went into
2.6.38, that is before the 'PAE correctness'-patch, so the problem was
probably never observed in the main development branch.
But for 2.6.32 the 'pgd-deadlock' patch is still missing, so the 'PAE
corretness'-patch made the problem worse with 2.6.32.

The Patch was also back-ported to the OpenSUSE Kernel
<http://kernel.opensuse.org/cgit/kernel-source/commit/?id=ac27c01aa880c65d17043ab87249c613ac4c3635>,
Since the patch didn't apply cleanly on the current Debian kernel, I had to
backport it for us and Debian. The patch is also available from our (German)
Bugzilla <https://forge.univention.org/bugzilla/show_bug.cgi?id=26661> or
from the Debian BTS at <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=669335>.

I have no easy test case, but running multiple parallel builds inside the VM
normally triggers the bug within seconds to minutes. With the patch applied
the VM survived a night building packages without any problem.

Signed-off-by: Philipp Hahn <hahn@univention.de>

Sincerely
Philipp
-
Philipp Hahn           Open Source Software Engineer      hahn@univention.de
Univention GmbH        be open.                       fon: +49 421 22 232- 0
Mary-Somerville-Str.1  D-28359 Bremen                 fax: +49 421 22 232-99
                                                   http://www.univention.de/

It's forbidden to take the page_table_lock with the irq disabled
or if there's contention the IPIs (for tlb flushes) sent with
the page_table_lock held will never run leading to a deadlock.

Nobody takes the pgd_lock from irq context so the _irqsave can be
removed.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <stable@kernel.org>
LKML-Reference: <201102162345.p1GNjMjm021738@imap1.linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Git-commit: a79e53d85683c6dd9f99c90511028adc2043031f
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/mm/fault.c    |   10 ++++------
 arch/x86/mm/pageattr.c |   18 ++++++++----------
 arch/x86/mm/pgtable.c  |   11 ++++-------
 arch/x86/xen/mmu.c     |   10 ++++------
 4 files changed, 20 insertions(+), 29 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 8ac0d76..249ad57 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -223,15 +223,14 @@ void vmalloc_sync_all(void)
 	     address >= TASK_SIZE && address < FIXADDR_TOP;
 	     address += PMD_SIZE) {
 
-		unsigned long flags;
 		struct page *page;
 
-		spin_lock_irqsave(&pgd_lock, flags);
+		spin_lock(&pgd_lock);
 		list_for_each_entry(page, &pgd_list, lru) {
 			if (!vmalloc_sync_one(page_address(page), address))
 				break;
 		}
-		spin_unlock_irqrestore(&pgd_lock, flags);
+		spin_unlock(&pgd_lock);
 	}
 }
 
@@ -331,13 +330,12 @@ void vmalloc_sync_all(void)
 	     address += PGDIR_SIZE) {
 
 		const pgd_t *pgd_ref = pgd_offset_k(address);
-		unsigned long flags;
 		struct page *page;
 
 		if (pgd_none(*pgd_ref))
 			continue;
 
-		spin_lock_irqsave(&pgd_lock, flags);
+		spin_lock(&pgd_lock);
 		list_for_each_entry(page, &pgd_list, lru) {
 			pgd_t *pgd;
 			pgd = (pgd_t *)page_address(page) + pgd_index(address);
@@ -346,7 +344,7 @@ void vmalloc_sync_all(void)
 			else
 				BUG_ON(pgd_page_vaddr(*pgd) != pgd_page_vaddr(*pgd_ref));
 		}
-		spin_unlock_irqrestore(&pgd_lock, flags);
+		spin_unlock(&pgd_lock);
 	}
 }
 
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index dd38bfb..6d44087 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -56,12 +56,10 @@ static unsigned long direct_pages_count[PG_LEVEL_NUM];
 
 void update_page_count(int level, unsigned long pages)
 {
-	unsigned long flags;
-
 	/* Protect against CPA */
-	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 	direct_pages_count[level] += pages;
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 }
 
 static void split_page_count(int level)
@@ -354,7 +352,7 @@ static int
 try_preserve_large_page(pte_t *kpte, unsigned long address,
 			struct cpa_data *cpa)
 {
-	unsigned long nextpage_addr, numpages, pmask, psize, flags, addr, pfn;
+	unsigned long nextpage_addr, numpages, pmask, psize, addr, pfn;
 	pte_t new_pte, old_pte, *tmp;
 	pgprot_t old_prot, new_prot;
 	int i, do_split = 1;
@@ -363,7 +361,7 @@ try_preserve_large_page(pte_t *kpte, unsigned long address,
 	if (cpa->force_split)
 		return 1;
 
-	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 	/*
 	 * Check for races, another CPU might have split this page
 	 * up already:
@@ -458,14 +456,14 @@ try_preserve_large_page(pte_t *kpte, unsigned long address,
 	}
 
 out_unlock:
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 
 	return do_split;
 }
 
 static int split_large_page(pte_t *kpte, unsigned long address)
 {
-	unsigned long flags, pfn, pfninc = 1;
+	unsigned long pfn, pfninc = 1;
 	unsigned int i, level;
 	pte_t *pbase, *tmp;
 	pgprot_t ref_prot;
@@ -479,7 +477,7 @@ static int split_large_page(pte_t *kpte, unsigned long address)
 	if (!base)
 		return -ENOMEM;
 
-	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 	/*
 	 * Check for races, another CPU might have split this page
 	 * up for us already:
@@ -551,7 +549,7 @@ out_unlock:
 	 */
 	if (base)
 		__free_page(base);
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 
 	return 0;
 }
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index e0e6fad..cb7cfc8 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -110,14 +110,12 @@ static void pgd_ctor(pgd_t *pgd)
 
 static void pgd_dtor(pgd_t *pgd)
 {
-	unsigned long flags; /* can be called from interrupt context */
-
 	if (SHARED_KERNEL_PMD)
 		return;
 
-	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 	pgd_list_del(pgd);
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 }
 
 /*
@@ -248,7 +246,6 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 {
 	pgd_t *pgd;
 	pmd_t *pmds[PREALLOCATED_PMDS];
-	unsigned long flags;
 
 	pgd = (pgd_t *)__get_free_page(PGALLOC_GFP);
 
@@ -268,12 +265,12 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 	 * respect to anything walking the pgd_list, so that they
 	 * never see a partially populated pgd.
 	 */
-	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 
 	pgd_ctor(pgd);
 	pgd_prepopulate_pmd(mm, pgd, pmds);
 
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 
 	return pgd;
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 3f90a2c..8f4452c 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -987,10 +987,9 @@ static void xen_pgd_pin(struct mm_struct *mm)
  */
 void xen_mm_pin_all(void)
 {
-	unsigned long flags;
 	struct page *page;
 
-	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 
 	list_for_each_entry(page, &pgd_list, lru) {
 		if (!PagePinned(page)) {
@@ -999,7 +998,7 @@ void xen_mm_pin_all(void)
 		}
 	}
 
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 }
 
 /*
@@ -1100,10 +1099,9 @@ static void xen_pgd_unpin(struct mm_struct *mm)
  */
 void xen_mm_unpin_all(void)
 {
-	unsigned long flags;
 	struct page *page;
 
-	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 
 	list_for_each_entry(page, &pgd_list, lru) {
 		if (PageSavePinned(page)) {
@@ -1113,7 +1111,7 @@ void xen_mm_unpin_all(void)
 		}
 	}
 
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 }
 
 void xen_activate_mm(struct mm_struct *prev, struct mm_struct *next)
-- 
1.7.2.1.45.g54fbc



