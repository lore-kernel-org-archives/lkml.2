Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab1BCCtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 21:49:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754991Ab1BCCtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 21:49:11 -0500
Date: Thu, 3 Feb 2011 03:48:38 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Jan Beulich <JBeulich@novell.com>, Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH] x86: hold mm->page_table_lock while doing vmalloc_sync
Message-ID: <20110203024838.GI5843@random.random>
References: <4CB76E8B.2090309@goop.org>
 <4CC0AB73.8060609@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC0AB73.8060609@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Larry (CC'ed) found a problem with the patch in subject. When
USE_SPLIT_PTLOCKS is not defined (NR_CPUS == 2) it will deadlock in
ptep_clear_flush_notify in rmap.c because it's sending IPIs with the
page_table_lock already held, and the other CPUs now spins on the
page_table_lock with irq disabled, so the IPI never runs. With
CONFIG_TRANSPARENT_HUGEPAGE=y this deadlocks happens even with
USE_SPLIT_PTLOCKS defined so it become visible but it needs to be
fixed regardless (for NR_CPUS == 2).

I'd like to understand why the pgd_lock needs irq disabled, it sounds
too easy that I can just remove the _irqsave, doesn't it?

A pgd_free comment says it can run from irq. page_table_lock having to
be taken there is for Xen only, but other archs also uses
spin_lock_irqsave(pgd_lock) so I guess it's either common code, or
it's superfluous and not another Xen special requirement.

If we could remove that _irqsave like below it'd solve it... But
clearly something must be taking the pgd_lock from irq. (using a
rwlock would also be possible as long as nobody takes it in write mode
during irq, but if it's pgd_free that really runs in irq, that would
need the write_lock so it wouldn't be a solution).

I'm trying this fix and the VM_BUG_ON never triggered yet.

In short: who takes the pgd_lock from an irq? (__mmdrop shouldn't but
maybe I'm overlooking some aio bit?)

======
Subject: fix pgd_lock deadlock

From: Andrea Arcangeli <aarcange@redhat.com>

It's forbidden to take the page_table_lock with the irq disabled or if there's
contention the IPIs (for tlb flushes) sent with the page_table_lock held will
never run leading to a deadlock.

Apparently nobody takes the pgd_lock from irq so the _irqsave can be removed.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/x86/mm/fault.c    |    7 ++++---
 arch/x86/mm/init_64.c  |    7 ++++---
 arch/x86/mm/pageattr.c |   21 +++++++++++----------
 arch/x86/mm/pgtable.c  |   10 ++++++----
 arch/x86/xen/mmu.c     |   10 ++++------
 5 files changed, 29 insertions(+), 26 deletions(-)

--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -230,14 +230,15 @@ void vmalloc_sync_all(void)
 	     address >= TASK_SIZE && address < FIXADDR_TOP;
 	     address += PMD_SIZE) {
 
-		unsigned long flags;
 		struct page *page;
 
-		spin_lock_irqsave(&pgd_lock, flags);
+		VM_BUG_ON(in_interrupt());
+		spin_lock(&pgd_lock);
 		list_for_each_entry(page, &pgd_list, lru) {
 			spinlock_t *pgt_lock;
 			pmd_t *ret;
 
+			/* the pgt_lock only for Xen */
 			pgt_lock = &pgd_page_get_mm(page)->page_table_lock;
 
 			spin_lock(pgt_lock);
@@ -247,7 +248,7 @@ void vmalloc_sync_all(void)
 			if (!ret)
 				break;
 		}
-		spin_unlock_irqrestore(&pgd_lock, flags);
+		spin_unlock(&pgd_lock, flags);
 	}
 }
 
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -105,18 +105,19 @@ void sync_global_pgds(unsigned long star
 
 	for (address = start; address <= end; address += PGDIR_SIZE) {
 		const pgd_t *pgd_ref = pgd_offset_k(address);
-		unsigned long flags;
 		struct page *page;
 
 		if (pgd_none(*pgd_ref))
 			continue;
 
-		spin_lock_irqsave(&pgd_lock, flags);
+		VM_BUG_ON(in_interrupt());
+		spin_lock(&pgd_lock);
 		list_for_each_entry(page, &pgd_list, lru) {
 			pgd_t *pgd;
 			spinlock_t *pgt_lock;
 
 			pgd = (pgd_t *)page_address(page) + pgd_index(address);
+			/* the pgt_lock only for Xen */
 			pgt_lock = &pgd_page_get_mm(page)->page_table_lock;
 			spin_lock(pgt_lock);
 
@@ -128,7 +129,7 @@ void sync_global_pgds(unsigned long star
 
 			spin_unlock(pgt_lock);
 		}
-		spin_unlock_irqrestore(&pgd_lock, flags);
+		spin_unlock(&pgd_lock);
 	}
 }
 
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -57,12 +57,11 @@ static unsigned long direct_pages_count[
 
 void update_page_count(int level, unsigned long pages)
 {
-	unsigned long flags;
-
 	/* Protect against CPA */
-	spin_lock_irqsave(&pgd_lock, flags);
+	VM_BUG_ON(in_interrupt());
+	spin_lock(&pgd_lock);
 	direct_pages_count[level] += pages;
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 }
 
 static void split_page_count(int level)
@@ -402,7 +401,7 @@ static int
 try_preserve_large_page(pte_t *kpte, unsigned long address,
 			struct cpa_data *cpa)
 {
-	unsigned long nextpage_addr, numpages, pmask, psize, flags, addr, pfn;
+	unsigned long nextpage_addr, numpages, pmask, psize, addr, pfn;
 	pte_t new_pte, old_pte, *tmp;
 	pgprot_t old_prot, new_prot, req_prot;
 	int i, do_split = 1;
@@ -411,7 +410,8 @@ try_preserve_large_page(pte_t *kpte, uns
 	if (cpa->force_split)
 		return 1;
 
-	spin_lock_irqsave(&pgd_lock, flags);
+	VM_BUG_ON(in_interrupt());
+	spin_lock(&pgd_lock);
 	/*
 	 * Check for races, another CPU might have split this page
 	 * up already:
@@ -506,14 +506,14 @@ try_preserve_large_page(pte_t *kpte, uns
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
@@ -527,7 +527,8 @@ static int split_large_page(pte_t *kpte,
 	if (!base)
 		return -ENOMEM;
 
-	spin_lock_irqsave(&pgd_lock, flags);
+	VM_BUG_ON(in_interrupt());
+	spin_lock(&pgd_lock);
 	/*
 	 * Check for races, another CPU might have split this page
 	 * up for us already:
@@ -599,7 +600,7 @@ out_unlock:
 	 */
 	if (base)
 		__free_page(base);
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 
 	return 0;
 }
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -126,9 +126,10 @@ static void pgd_dtor(pgd_t *pgd)
 	if (SHARED_KERNEL_PMD)
 		return;
 
-	spin_lock_irqsave(&pgd_lock, flags);
+	VM_BUG_ON(in_interrupt());
+	spin_lock(&pgd_lock);
 	pgd_list_del(pgd);
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 }
 
 /*
@@ -280,12 +281,13 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 	 * respect to anything walking the pgd_list, so that they
 	 * never see a partially populated pgd.
 	 */
-	spin_lock_irqsave(&pgd_lock, flags);
+	VM_BUG_ON(in_interrupt());
+	spin_lock(&pgd_lock);
 
 	pgd_ctor(mm, pgd);
 	pgd_prepopulate_pmd(mm, pgd, pmds);
 
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 
 	return pgd;
 
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -986,10 +986,9 @@ static void xen_pgd_pin(struct mm_struct
  */
 void xen_mm_pin_all(void)
 {
-	unsigned long flags;
 	struct page *page;
 
-	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 
 	list_for_each_entry(page, &pgd_list, lru) {
 		if (!PagePinned(page)) {
@@ -998,7 +997,7 @@ void xen_mm_pin_all(void)
 		}
 	}
 
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 }
 
 /*
@@ -1099,10 +1098,9 @@ static void xen_pgd_unpin(struct mm_stru
  */
 void xen_mm_unpin_all(void)
 {
-	unsigned long flags;
 	struct page *page;
 
-	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 
 	list_for_each_entry(page, &pgd_list, lru) {
 		if (PageSavePinned(page)) {
@@ -1112,7 +1110,7 @@ void xen_mm_unpin_all(void)
 		}
 	}
 
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 }
 
 void xen_activate_mm(struct mm_struct *prev, struct mm_struct *next)
