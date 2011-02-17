Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab1BQKVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 05:21:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754041Ab1BQKVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 05:21:01 -0500
Date: Thu, 17 Feb 2011 11:19:41 +0100
From: Johannes Weiner <jweiner@redhat.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Jan Beulich <JBeulich@novell.com>, Larry Woodman <lwoodman@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] fix pgd_lock deadlock
Message-ID: <20110217101941.GH2380@redhat.com>
References: <20110203024838.GI5843@random.random>
 <4D4B1392.5090603@goop.org>
 <20110204012109.GP5843@random.random>
 <4D4C6F45.6010204@goop.org>
 <20110207232045.GJ3347@random.random>
 <20110215190710.GL5935@random.random>
 <alpine.LFD.2.00.1102152020590.26192@localhost6.localdomain6>
 <20110215195450.GO5935@random.random>
 <alpine.LFD.2.00.1102152102530.26192@localhost6.localdomain6>
 <20110216183304.GD5935@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216183304.GD5935@random.random>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 07:33:04PM +0100, Andrea Arcangeli wrote:
> On Tue, Feb 15, 2011 at 09:05:20PM +0100, Thomas Gleixner wrote:
> > Did you try with DEBUG_PAGEALLOC, which is calling into cpa quite a
> > lot?
> 
> I tried DEBUG_PAGEALLOC and it seems to work fine (in addition to
> lockdep), it doesn't spwan any debug check.
> 
> In addition to testing it (both prev patch and below one) I looked
> into the code and the free_pages calling into
> pageattr->split_large_page apparently happens all at boot time.
> 
> Now one doubt remains if we need change_page_attr to run from irqs
> (not from DEBUG_PAGEALLOC though). Now is change_page_attr really sane
> to run from irqs? I thought __flush_tlb_all was delivering IPI (in
> that case it also wouldn't have been safe in the first place to run
> with irq disabled) but of course the "__" version is local, so after
> all maybe it's safe to run with interrupts too (I'd be amazed if
> somebody is calling it from irq, if not even DEBUG_PAGEALLOC does) but
> with the below patch it will remain safe from irq as far as the
> pgd_lock is concerned.
> 
> I think the previous patch was safe too though, avoiding VM
> manipulations from interrupts makes everything simpler. Normally only
> gart drivers should call it at init time to avoid prefetching of
> cachelines in the next 2m page with different (writeback) cache
> attributes of the pages physically aliased in the gart and mapped with
> different cache attribute, that init stuff happening from interrupt
> sounds weird. Anyway I post the below patch too as an alternative to
> still allow pageattr from irq.
> 
> With both patches the big dependency remains on __mmdrop not to run
> from irq. The alternative approach is to remove the page_table_lock
> from vmalloc_sync_all (which is only needed by Xen paravirt guest
> AFIK) and solve that problem in a different way, but I don't even know
> why they need it exactly, I tried not to impact that.

So Xen needs all page tables protected when pinning/unpinning and
extended page_table_lock to cover kernel range, which it does nowhere
else AFAICS.  But the places it extended are also taking the pgd_lock,
so I wonder if Xen could just take the pgd_lock itself in these paths
and we could revert page_table_lock back to cover user va only?
Jeremy, could this work?  Untested.

	Hannes

---
 arch/x86/include/asm/pgtable.h |    2 --
 arch/x86/mm/fault.c            |   14 ++------------
 arch/x86/mm/init_64.c          |    6 ------
 arch/x86/mm/pgtable.c          |   20 +++-----------------
 arch/x86/xen/mmu.c             |    8 ++++++++
 5 files changed, 13 insertions(+), 37 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 18601c8..8c0335a 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -28,8 +28,6 @@ extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
 extern spinlock_t pgd_lock;
 extern struct list_head pgd_list;
 
-extern struct mm_struct *pgd_page_get_mm(struct page *page);
-
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else  /* !CONFIG_PARAVIRT */
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 7d90ceb..5da4155 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -234,19 +234,9 @@ void vmalloc_sync_all(void)
 		struct page *page;
 
 		spin_lock_irqsave(&pgd_lock, flags);
-		list_for_each_entry(page, &pgd_list, lru) {
-			spinlock_t *pgt_lock;
-			pmd_t *ret;
-
-			pgt_lock = &pgd_page_get_mm(page)->page_table_lock;
-
-			spin_lock(pgt_lock);
-			ret = vmalloc_sync_one(page_address(page), address);
-			spin_unlock(pgt_lock);
-
-			if (!ret)
+		list_for_each_entry(page, &pgd_list, lru)
+			if (!vmalloc_sync_one(page_address(page), address))
 				break;
-		}
 		spin_unlock_irqrestore(&pgd_lock, flags);
 	}
 }
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 71a5929..9332f21 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -114,19 +114,13 @@ void sync_global_pgds(unsigned long start, unsigned long end)
 		spin_lock_irqsave(&pgd_lock, flags);
 		list_for_each_entry(page, &pgd_list, lru) {
 			pgd_t *pgd;
-			spinlock_t *pgt_lock;
 
 			pgd = (pgd_t *)page_address(page) + pgd_index(address);
-			pgt_lock = &pgd_page_get_mm(page)->page_table_lock;
-			spin_lock(pgt_lock);
-
 			if (pgd_none(*pgd))
 				set_pgd(pgd, *pgd_ref);
 			else
 				BUG_ON(pgd_page_vaddr(*pgd)
 				       != pgd_page_vaddr(*pgd_ref));
-
-			spin_unlock(pgt_lock);
 		}
 		spin_unlock_irqrestore(&pgd_lock, flags);
 	}
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 500242d..72107ab 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -87,19 +87,7 @@ static inline void pgd_list_del(pgd_t *pgd)
 #define UNSHARED_PTRS_PER_PGD				\
 	(SHARED_KERNEL_PMD ? KERNEL_PGD_BOUNDARY : PTRS_PER_PGD)
 
-
-static void pgd_set_mm(pgd_t *pgd, struct mm_struct *mm)
-{
-	BUILD_BUG_ON(sizeof(virt_to_page(pgd)->index) < sizeof(mm));
-	virt_to_page(pgd)->index = (pgoff_t)mm;
-}
-
-struct mm_struct *pgd_page_get_mm(struct page *page)
-{
-	return (struct mm_struct *)page->index;
-}
-
-static void pgd_ctor(struct mm_struct *mm, pgd_t *pgd)
+static void pgd_ctor(pgd_t *pgd)
 {
 	/* If the pgd points to a shared pagetable level (either the
 	   ptes in non-PAE, or shared PMD in PAE), then just copy the
@@ -113,10 +101,8 @@ static void pgd_ctor(struct mm_struct *mm, pgd_t *pgd)
 	}
 
 	/* list required to sync kernel mapping updates */
-	if (!SHARED_KERNEL_PMD) {
-		pgd_set_mm(pgd, mm);
+	if (!SHARED_KERNEL_PMD)
 		pgd_list_add(pgd);
-	}
 }
 
 static void pgd_dtor(pgd_t *pgd)
@@ -282,7 +268,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 	 */
 	spin_lock_irqsave(&pgd_lock, flags);
 
-	pgd_ctor(mm, pgd);
+	pgd_ctor(pgd);
 	pgd_prepopulate_pmd(mm, pgd, pmds);
 
 	spin_unlock_irqrestore(&pgd_lock, flags);
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 5e22810..97fbfce 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1021,7 +1021,11 @@ static void __xen_pgd_pin(struct mm_struct *mm, pgd_t *pgd)
 
 static void xen_pgd_pin(struct mm_struct *mm)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&pgd_lock, flags);
 	__xen_pgd_pin(mm, mm->pgd);
+	spin_unlock_irqrestore(&pgd_lock, flags);
 }
 
 /*
@@ -1140,7 +1144,11 @@ static void __xen_pgd_unpin(struct mm_struct *mm, pgd_t *pgd)
 
 static void xen_pgd_unpin(struct mm_struct *mm)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&pgd_lock, flags);
 	__xen_pgd_unpin(mm, mm->pgd);
+	spin_unlock_irqrestore(&pgd_lock, flags);
 }
 
 /*
