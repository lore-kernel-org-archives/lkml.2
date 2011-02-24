Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478Ab1BXEWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 23:22:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932383Ab1BXEWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 23:22:42 -0500
Date: Thu, 24 Feb 2011 05:22:22 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>, Andi Kleen <andi@firstfloor.org>,
        Hugh Dickins <hughd@google.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Johannes Weiner <jweiner@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, Rik van Riel <riel@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] fix pgd_lock deadlock
Message-ID: <20110224042222.GG31195@random.random>
References: <alpine.LFD.2.00.1102152020590.26192@localhost6.localdomain6>
 <20110215195450.GO5935@random.random>
 <alpine.LFD.2.00.1102152102530.26192@localhost6.localdomain6>
 <20110216183304.GD5935@random.random>
 <20110217101941.GH2380@redhat.com>
 <20110221143023.GF13092@random.random>
 <20110221145350.GH25382@redhat.com>
 <4D6378760200007800033104@vpn.id2.novell.com>
 <20110222134956.GU13092@random.random>
 <4D63D4CD020000780003320A@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D63D4CD020000780003320A@vpn.id2.novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 02:22:53PM +0000, Jan Beulich wrote:
> >>> On 22.02.11 at 14:49, Andrea Arcangeli <aarcange@redhat.com> wrote:
> > On Tue, Feb 22, 2011 at 07:48:54AM +0000, Jan Beulich wrote:
> >> A possible alternative would be to acquire the page table lock
> >> in vmalloc_sync_all() only in the Xen case (perhaps by storing
> >> NULL into page->index in pgd_set_mm() when not running on
> >> Xen). This is utilizing the fact that there aren't (supposed to
> >> be - for non-pvops this is definitely the case) any TLB flush IPIs
> >> under Xen, and hence the race you're trying to fix doesn't
> >> exist there (while non-Xen doesn't need the extra locking).
> > 
> > That's sure ok with me. Can we use a global runtime to check if the
> > guest is running under Xen paravirt, instead of passing that info
> > through page->something?
> 
> If everyone's okay with putting a couple of "if (xen_pv_domain())"
> into mm/fault.c - sure. I would have thought that this wouldn't be
> liked, hence the suggestion to make this depend on seeing the
> backlink be non-NULL.

What about this? The page->private logic gets optimized away at
compile time with XEN=n.

The removal of _irqsave from pgd_lock, I'll delay it as it's no bugfix
anymore.

===
Subject: xen: stop taking the page_table_lock with irq disabled

From: Andrea Arcangeli <aarcange@redhat.com>

It's forbidden to take the page_table_lock with the irq disabled or if there's
contention the IPIs (for tlb flushes) sent with the page_table_lock held will
never run leading to a deadlock.

Only Xen needs the page_table_lock and Xen won't need IPI TLB flushes hence the
deadlock doesn't exist for Xen.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/x86/include/asm/pgtable.h |    5 +++--
 arch/x86/mm/fault.c            |   10 ++++++----
 arch/x86/mm/init_64.c          |   10 ++++++----
 arch/x86/mm/pgtable.c          |    9 +++------
 4 files changed, 18 insertions(+), 16 deletions(-)

--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -235,14 +235,16 @@ void vmalloc_sync_all(void)
 
 		spin_lock_irqsave(&pgd_lock, flags);
 		list_for_each_entry(page, &pgd_list, lru) {
-			spinlock_t *pgt_lock;
+			struct mm_struct *mm;
 			pmd_t *ret;
 
-			pgt_lock = &pgd_page_get_mm(page)->page_table_lock;
+			mm = pgd_page_get_mm(page);
 
-			spin_lock(pgt_lock);
+			if (mm)
+				spin_lock(&mm->page_table_lock);
 			ret = vmalloc_sync_one(page_address(page), address);
-			spin_unlock(pgt_lock);
+			if (mm)
+				spin_unlock(&mm->page_table_lock);
 
 			if (!ret)
 				break;
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -114,11 +114,12 @@ void sync_global_pgds(unsigned long star
 		spin_lock_irqsave(&pgd_lock, flags);
 		list_for_each_entry(page, &pgd_list, lru) {
 			pgd_t *pgd;
-			spinlock_t *pgt_lock;
+			struct mm_struct *mm;
 
 			pgd = (pgd_t *)page_address(page) + pgd_index(address);
-			pgt_lock = &pgd_page_get_mm(page)->page_table_lock;
-			spin_lock(pgt_lock);
+			mm = pgd_page_get_mm(page);
+			if (mm)
+				spin_lock(&mm->page_table_lock);
 
 			if (pgd_none(*pgd))
 				set_pgd(pgd, *pgd_ref);
@@ -126,7 +127,8 @@ void sync_global_pgds(unsigned long star
 				BUG_ON(pgd_page_vaddr(*pgd)
 				       != pgd_page_vaddr(*pgd_ref));
 
-			spin_unlock(pgt_lock);
+			if (mm)
+				spin_unlock(&mm->page_table_lock);
 		}
 		spin_unlock_irqrestore(&pgd_lock, flags);
 	}
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -4,6 +4,7 @@
 #include <asm/pgtable.h>
 #include <asm/tlb.h>
 #include <asm/fixmap.h>
+#include <xen/xen.h>
 
 #define PGALLOC_GFP GFP_KERNEL | __GFP_NOTRACK | __GFP_REPEAT | __GFP_ZERO
 
@@ -91,12 +92,8 @@ static inline void pgd_list_del(pgd_t *p
 static void pgd_set_mm(pgd_t *pgd, struct mm_struct *mm)
 {
 	BUILD_BUG_ON(sizeof(virt_to_page(pgd)->index) < sizeof(mm));
-	virt_to_page(pgd)->index = (pgoff_t)mm;
-}
-
-struct mm_struct *pgd_page_get_mm(struct page *page)
-{
-	return (struct mm_struct *)page->index;
+	if (xen_pv_domain())
+		virt_to_page(pgd)->index = (pgoff_t)mm;
 }
 
 static void pgd_ctor(struct mm_struct *mm, pgd_t *pgd)
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -28,8 +28,6 @@ extern unsigned long empty_zero_page[PAG
 extern spinlock_t pgd_lock;
 extern struct list_head pgd_list;
 
-extern struct mm_struct *pgd_page_get_mm(struct page *page);
-
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else  /* !CONFIG_PARAVIRT */
@@ -83,6 +81,9 @@ extern struct mm_struct *pgd_page_get_mm
 
 #endif	/* CONFIG_PARAVIRT */
 
+#define pgd_page_get_mm(__page) \
+	((struct mm_struct *)(xen_pv_domain() ? (__page)->index : 0))
+
 /*
  * The following only work if pte_present() is true.
  * Undefined behaviour if not..
