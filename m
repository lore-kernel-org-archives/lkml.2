Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724Ab1BPOu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 09:50:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094Ab1BPOuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 09:50:24 -0500
Date: Wed, 16 Feb 2011 15:49:47 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Jan Beulich <JBeulich@novell.com>, Larry Woodman <lwoodman@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] fix pgd_lock deadlock
Message-ID: <20110216144947.GA5935@random.random>
References: <alpine.LFD.2.00.1102152020590.26192@localhost6.localdomain6>
 <20110215195450.GO5935@random.random>
 <alpine.LFD.2.00.1102152102530.26192@localhost6.localdomain6>
 <alpine.LFD.2.00.1102152125180.26192@localhost6.localdomain6>
 <20110215225234.GP5935@random.random>
 <alpine.LFD.2.00.1102160002300.26192@localhost6.localdomain6>
 <20110215231733.GR5935@random.random>
 <1297850294.2413.30.camel@twins>
 <20110216101521.GU5935@random.random>
 <20110216102801.GA23082@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216102801.GA23082@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 11:28:01AM +0100, Ingo Molnar wrote:
> The point both Thomas and Peter tried to point out to you, that adding 7 instances 
> of redundant debug checks:
> 
> +		VM_BUG_ON(in_interrupt());
> +		VM_BUG_ON(in_interrupt());
> +	VM_BUG_ON(in_interrupt());
> +	VM_BUG_ON(in_interrupt());
> +	VM_BUG_ON(in_interrupt());
> +	VM_BUG_ON(in_interrupt());
> +	VM_BUG_ON(in_interrupt());
> 
> to arch/x86/ is not acceptable, for the reasons stated. Please remove it from the 
> patch.

Ok sorry, but whenever I'm asked if I tested my patch with lockdep, I
think if it was tested for other bugs, not to remove debug code
overlapping with some lockdep feature.

===
Subject: fix pgd_lock deadlock

From: Andrea Arcangeli <aarcange@redhat.com>

It's forbidden to take the page_table_lock with the irq disabled or if there's
contention the IPIs (for tlb flushes) sent with the page_table_lock held will
never run leading to a deadlock.

Apparently nobody takes the pgd_lock from irq so the _irqsave can be removed.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/x86/mm/fault.c    |    7 +++----
 arch/x86/mm/init_64.c  |    6 +++---
 arch/x86/mm/pageattr.c |   18 ++++++++----------
 arch/x86/mm/pgtable.c  |   11 ++++-------
 arch/x86/xen/mmu.c     |   10 ++++------
 5 files changed, 22 insertions(+), 30 deletions(-)

--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -229,15 +229,14 @@ void vmalloc_sync_all(void)
 	for (address = VMALLOC_START & PMD_MASK;
 	     address >= TASK_SIZE && address < FIXADDR_TOP;
 	     address += PMD_SIZE) {
-
-		unsigned long flags;
 		struct page *page;
 
-		spin_lock_irqsave(&pgd_lock, flags);
+		spin_lock(&pgd_lock);
 		list_for_each_entry(page, &pgd_list, lru) {
 			spinlock_t *pgt_lock;
 			pmd_t *ret;
 
+			/* the pgt_lock only for Xen */
 			pgt_lock = &pgd_page_get_mm(page)->page_table_lock;
 
 			spin_lock(pgt_lock);
@@ -247,7 +246,7 @@ void vmalloc_sync_all(void)
 			if (!ret)
 				break;
 		}
-		spin_unlock_irqrestore(&pgd_lock, flags);
+		spin_unlock(&pgd_lock);
 	}
 }
 
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -105,18 +105,18 @@ void sync_global_pgds(unsigned long star
 
 	for (address = start; address <= end; address += PGDIR_SIZE) {
 		const pgd_t *pgd_ref = pgd_offset_k(address);
-		unsigned long flags;
 		struct page *page;
 
 		if (pgd_none(*pgd_ref))
 			continue;
 
-		spin_lock_irqsave(&pgd_lock, flags);
+		spin_lock(&pgd_lock);
 		list_for_each_entry(page, &pgd_list, lru) {
 			pgd_t *pgd;
 			spinlock_t *pgt_lock;
 
 			pgd = (pgd_t *)page_address(page) + pgd_index(address);
+			/* the pgt_lock only for Xen */
 			pgt_lock = &pgd_page_get_mm(page)->page_table_lock;
 			spin_lock(pgt_lock);
 
@@ -128,7 +128,7 @@ void sync_global_pgds(unsigned long star
 
 			spin_unlock(pgt_lock);
 		}
-		spin_unlock_irqrestore(&pgd_lock, flags);
+		spin_unlock(&pgd_lock);
 	}
 }
 
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -57,12 +57,10 @@ static unsigned long direct_pages_count[
 
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
@@ -394,7 +392,7 @@ static int
 try_preserve_large_page(pte_t *kpte, unsigned long address,
 			struct cpa_data *cpa)
 {
-	unsigned long nextpage_addr, numpages, pmask, psize, flags, addr, pfn;
+	unsigned long nextpage_addr, numpages, pmask, psize, addr, pfn;
 	pte_t new_pte, old_pte, *tmp;
 	pgprot_t old_prot, new_prot, req_prot;
 	int i, do_split = 1;
@@ -403,7 +401,7 @@ try_preserve_large_page(pte_t *kpte, uns
 	if (cpa->force_split)
 		return 1;
 
-	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 	/*
 	 * Check for races, another CPU might have split this page
 	 * up already:
@@ -498,14 +496,14 @@ try_preserve_large_page(pte_t *kpte, uns
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
@@ -519,7 +517,7 @@ static int split_large_page(pte_t *kpte,
 	if (!base)
 		return -ENOMEM;
 
-	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 	/*
 	 * Check for races, another CPU might have split this page
 	 * up for us already:
@@ -591,7 +589,7 @@ out_unlock:
 	 */
 	if (base)
 		__free_page(base);
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 
 	return 0;
 }
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -121,14 +121,12 @@ static void pgd_ctor(struct mm_struct *m
 
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
@@ -260,7 +258,6 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 {
 	pgd_t *pgd;
 	pmd_t *pmds[PREALLOCATED_PMDS];
-	unsigned long flags;
 
 	pgd = (pgd_t *)__get_free_page(PGALLOC_GFP);
 
@@ -280,12 +277,12 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 	 * respect to anything walking the pgd_list, so that they
 	 * never see a partially populated pgd.
 	 */
-	spin_lock_irqsave(&pgd_lock, flags);
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
