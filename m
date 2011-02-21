Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab1BUOyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 09:54:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866Ab1BUOyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 09:54:20 -0500
Date: Mon, 21 Feb 2011 15:53:50 +0100
From: Johannes Weiner <jweiner@redhat.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
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
Message-ID: <20110221145350.GH25382@redhat.com>
References: <20110204012109.GP5843@random.random>
 <4D4C6F45.6010204@goop.org>
 <20110207232045.GJ3347@random.random>
 <20110215190710.GL5935@random.random>
 <alpine.LFD.2.00.1102152020590.26192@localhost6.localdomain6>
 <20110215195450.GO5935@random.random>
 <alpine.LFD.2.00.1102152102530.26192@localhost6.localdomain6>
 <20110216183304.GD5935@random.random>
 <20110217101941.GH2380@redhat.com>
 <20110221143023.GF13092@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110221143023.GF13092@random.random>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 03:30:23PM +0100, Andrea Arcangeli wrote:
> On Thu, Feb 17, 2011 at 11:19:41AM +0100, Johannes Weiner wrote:
> > So Xen needs all page tables protected when pinning/unpinning and
> > extended page_table_lock to cover kernel range, which it does nowhere
> > else AFAICS.  But the places it extended are also taking the pgd_lock,
> > so I wonder if Xen could just take the pgd_lock itself in these paths
> > and we could revert page_table_lock back to cover user va only?
> > Jeremy, could this work?  Untested.
> 
> If this works for Xen, I definitely prefer this.

Below is real submission, with changelog and sign-off and all (except
testing on Xen itself, sorry).  I moved pgd_lock acquisition in this
version to make the lock ordering perfectly clear.  Xen people, could
you have a look at this?

> Still there's no point to insist on _irqsave if nothing takes the
> pgd_lock from irq, so my patch probably should be applied anyway or
> it's confusing and there's even a comment saying pgd_dtor is called
> from irq, if it's not it should be corrected. But then it becomes a
> cleanup notafix.

Absolutely agreed, I like your clean-up but would prefer it not being
a requirement for this fix.

---
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch] x86, mm: fix mm->page_table_lock deadlock

'617d34d x86, mm: Hold mm->page_table_lock while doing vmalloc_sync'
made two paths grab mm->page_table_lock while having IRQs disabled.
This is not safe as rmap waits for IPI responses with this lock held
when clearing young bits and flushing the TLB.

What 617d34d wanted was to exclude any changes to the page tables,
including demand kernel page table propagation from init_mm, so that
Xen could pin and unpin page tables atomically.

Kernel page table propagation takes the pgd_lock to protect the list
of page directories, however, so instead of adding mm->page_table_lock
to this side, this patch has Xen exclude it by taking pgd_lock itself.

The pgd_lock will then nest within mm->page_table_lock to exclude rmap
before disabling IRQs, thus fixing the deadlock.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 arch/x86/include/asm/pgtable.h |    2 --
 arch/x86/mm/fault.c            |   14 ++------------
 arch/x86/mm/init_64.c          |    6 ------
 arch/x86/mm/pgtable.c          |   20 +++-----------------
 arch/x86/xen/mmu.c             |   12 ++++++++++++
 5 files changed, 17 insertions(+), 37 deletions(-)

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
index 5e92b61..498e6ae 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1117,15 +1117,23 @@ void xen_mm_unpin_all(void)
 
 void xen_activate_mm(struct mm_struct *prev, struct mm_struct *next)
 {
+	unsigned long flags;
+
 	spin_lock(&next->page_table_lock);
+	spin_lock_irqsave(&pgd_lock, flags);
 	xen_pgd_pin(next);
+	spin_unlock_irqrestore(&pgd_lock, flags);
 	spin_unlock(&next->page_table_lock);
 }
 
 void xen_dup_mmap(struct mm_struct *oldmm, struct mm_struct *mm)
 {
+	unsigned long flags;
+
 	spin_lock(&mm->page_table_lock);
+	spin_lock_irqsave(&pgd_lock, flags);
 	xen_pgd_pin(mm);
+	spin_unlock_irqrestore(&pgd_lock, flags);
 	spin_unlock(&mm->page_table_lock);
 }
 
@@ -1211,16 +1219,20 @@ static void xen_drop_mm_ref(struct mm_struct *mm)
  */
 void xen_exit_mmap(struct mm_struct *mm)
 {
+	unsigned long flags;
+
 	get_cpu();		/* make sure we don't move around */
 	xen_drop_mm_ref(mm);
 	put_cpu();
 
 	spin_lock(&mm->page_table_lock);
+	spin_lock_irqsave(&pgd_lock, flags);
 
 	/* pgd may not be pinned in the error exit path of execve */
 	if (xen_page_pinned(mm->pgd))
 		xen_pgd_unpin(mm);
 
+	spin_unlock_irqrestore(&pgd_lock, flags);
 	spin_unlock(&mm->page_table_lock);
 }
 
-- 
1.7.4

