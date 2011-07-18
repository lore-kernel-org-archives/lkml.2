Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167Ab1GRECc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 00:02:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:55641 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab1GRECZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 00:02:25 -0400
Subject: Re: [PATCH 1/1] Fixup write permission of TLB on powerpc e500 core
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Shan Hai <haishan.bai@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        paulus@samba.org, tglx@linutronix.de, walken@google.com,
        dhowells@redhat.com, cmetcalf@tilera.com, tony.luck@intel.com,
        akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1310944453.25044.262.camel@pasglop>
References: <1310717238-13857-1-git-send-email-haishan.bai@gmail.com>
	 <1310717238-13857-2-git-send-email-haishan.bai@gmail.com>
	 <1310725418.2586.309.camel@twins> <4E21A526.8010904@gmail.com>
	 <1310860194.25044.17.camel@pasglop>
	 <4b337921-d430-4b63-bc36-ad31753cf800@email.android.com>
	 <1310912990.25044.203.camel@pasglop>  <1310944453.25044.262.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jul 2011 14:01:31 +1000
Message-ID: <1310961691.25044.274.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-18 at 09:14 +1000, Benjamin Herrenschmidt wrote:

> In fact, with such a flag, we could probably avoid the ifdef entirely, and
> always go toward the PTE fixup path when called in such a fixup case, my gut
> feeling is that this is going to be seldom enough not to hurt x86 measurably
> but we'll have to try it out.
> 
> That leads to that even less tested patch:

And here's a version that builds and fixes a bug or two
(still not tested :-)

Shan, can you verify whether that fixes the problem for you ?

I also had a cursory glance at the ARM code and it seems to rely on the
same stuff as embedded powerpc does for dirty/young updates, so in
theory it should exhibit the same problem.

I suspect the scenario is rare enough in practice in embedded workloads
that nobody noticed until now.

Cheers,
Ben.

mm/futex: Fix use of gup() to "fixup" failing atomic user accesses

The futex code uses atomic (page fault disabled) accesses to user space,
and when they fail, uses get_user_pages() to "fixup" the PTE and try again.

However, on arch with SW tracking of the dirty and young bits, this will
not work properly as neither of the above will perform the necessary fixup
of those bits.

There's also a possible corner cases with archs who rely on
handle_pte_fault() to invalidate the TLB for "spurrious" faults (though
I don't know which arch actually needs that). Those would break the
same way.

This fixes it by factoring out the fixup code from handle_pte_fault() into
a separate function, and use it from within gup as well, whenever the
FOLL_FIXFAULT flag has been passed to it. The futex code is modified to
pass that flag.

This doesn't change the "normal" gup case (and thus avoids the overhead
of doing that tracking)

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 9670f71..8a76694 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1546,6 +1546,7 @@ struct page *follow_page(struct vm_area_struct *, unsigned long address,
 #define FOLL_MLOCK	0x40	/* mark page as mlocked */
 #define FOLL_SPLIT	0x80	/* don't return transhuge pages, split them */
 #define FOLL_HWPOISON	0x100	/* check page is hwpoisoned */
+#define FOLL_FIXFAULT	0x200	/* fixup after a fault (PTE dirty/young upd) */
 
 typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
 			void *data);
diff --git a/kernel/futex.c b/kernel/futex.c
index fe28dc2..02adff7 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -355,8 +355,8 @@ static int fault_in_user_writeable(u32 __user *uaddr)
 	int ret;
 
 	down_read(&mm->mmap_sem);
-	ret = get_user_pages(current, mm, (unsigned long)uaddr,
-			     1, 1, 0, NULL, NULL);
+	ret = __get_user_pages(current, mm, (unsigned long)uaddr, 1,
+			       FOLL_WRITE | FOLL_FIXFAULT, NULL, NULL, NULL);
 	up_read(&mm->mmap_sem);
 
 	return ret < 0 ? ret : 0;
diff --git a/mm/memory.c b/mm/memory.c
index 40b7531..3c4d502 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1419,6 +1419,29 @@ int zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
 }
 EXPORT_SYMBOL_GPL(zap_vma_ptes);
 
+static void handle_pte_sw_young_dirty(struct vm_area_struct *vma,
+				      unsigned long address,
+				      pte_t *ptep, int write)
+{
+	pte_t entry = *ptep;
+
+	if (write)
+		pte_mkdirty(entry);
+	entry = pte_mkyoung(entry);
+	if (ptep_set_access_flags(vma, address, ptep, entry, write)) {
+		update_mmu_cache(vma, address, ptep);
+	} else {
+		/*
+		 * This is needed only for protection faults but the arch code
+		 * is not yet telling us if this is a protection fault or not.
+		 * This still avoids useless tlb flushes for .text page faults
+		 * with threads.
+		 */
+		if (write)
+			flush_tlb_fix_spurious_fault(vma, address);
+	}
+}
+
 /**
  * follow_page - look up a page descriptor from a user-virtual address
  * @vma: vm_area_struct mapping @address
@@ -1514,6 +1537,10 @@ split_fallthrough:
 
 	if (flags & FOLL_GET)
 		get_page(page);
+
+	if (flags & FOLL_FIXFAULT)
+		handle_pte_sw_young_dirty(vma, address, ptep,
+					  flags & FOLL_WRITE);
 	if (flags & FOLL_TOUCH) {
 		if ((flags & FOLL_WRITE) &&
 		    !pte_dirty(pte) && !PageDirty(page))
@@ -1525,6 +1552,7 @@ split_fallthrough:
 		 */
 		mark_page_accessed(page);
 	}
+
 	if ((flags & FOLL_MLOCK) && (vma->vm_flags & VM_LOCKED)) {
 		/*
 		 * The preliminary mapping check is mainly to avoid the
@@ -3358,21 +3386,8 @@ int handle_pte_fault(struct mm_struct *mm,
 		if (!pte_write(entry))
 			return do_wp_page(mm, vma, address,
 					pte, pmd, ptl, entry);
-		entry = pte_mkdirty(entry);
-	}
-	entry = pte_mkyoung(entry);
-	if (ptep_set_access_flags(vma, address, pte, entry, flags & FAULT_FLAG_WRITE)) {
-		update_mmu_cache(vma, address, pte);
-	} else {
-		/*
-		 * This is needed only for protection faults but the arch code
-		 * is not yet telling us if this is a protection fault or not.
-		 * This still avoids useless tlb flushes for .text page faults
-		 * with threads.
-		 */
-		if (flags & FAULT_FLAG_WRITE)
-			flush_tlb_fix_spurious_fault(vma, address);
 	}
+	handle_pte_sw_young_dirty(vma, address, pte, flags & FAULT_FLAG_WRITE);
 unlock:
 	pte_unmap_unlock(pte, ptl);
 	return 0;


