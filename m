Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717Ab1GQXO4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 19:14:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:55164 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730Ab1GQXOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 19:14:55 -0400
Subject: Re: [PATCH 1/1] Fixup write permission of TLB on powerpc e500 core
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Shan Hai <haishan.bai@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        paulus@samba.org, tglx@linutronix.de, walken@google.com,
        dhowells@redhat.com, cmetcalf@tilera.com, tony.luck@intel.com,
        akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1310912990.25044.203.camel@pasglop>
References: <1310717238-13857-1-git-send-email-haishan.bai@gmail.com>
	 <1310717238-13857-2-git-send-email-haishan.bai@gmail.com>
	 <1310725418.2586.309.camel@twins> <4E21A526.8010904@gmail.com>
	 <1310860194.25044.17.camel@pasglop>
	 <4b337921-d430-4b63-bc36-ad31753cf800@email.android.com>
	 <1310912990.25044.203.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jul 2011 09:14:13 +1000
Message-ID: <1310944453.25044.262.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-18 at 00:29 +1000, Benjamin Herrenschmidt wrote:

> A better approach might be a flag to pass to gup (via the "write"
> argument ? top bits ?) to tell it to immediately perform dirty/young
> updates.

So I dug a bit now that it's not 1am anymore :-)

Looks like gup changed a lot since I last looked. In fact, it already
has a very similar logic to what I want, with FOLL_TOUCH (which is set
by gup always and passed to __gup):

	if (flags & FOLL_TOUCH) {
		if ((flags & FOLL_WRITE) &&
		    !pte_dirty(pte) && !PageDirty(page))
			set_page_dirty(page);
		/*
		 * pte_mkyoung() would be more correct here, but atomic care
		 * is needed to avoid losing the dirty bit: it is easier to use
		 * mark_page_accessed().
		 */
		mark_page_accessed(page);
	}

The problem here, is that we assume that having the struct page bits is
enough and we don't bother setting the PTE for either bits.

The problem with setting the PTE here is that while it would be
perfectly ok to do so under the PTL for archs that maintain dirty and
young in SW, for archs that do it in HW, this needs to be done in a way
that will be atomic vs. potential concurrent HW updates.

This could be done, I believe by using ptep_set_access_flags() but that
would be a waste on things like x86 or hash based powerpc who don't need
the PTE to be updated (x86 because of HW dirty/young updates, hash based
powerpc because our hash code does the updates and so looks to Linux
like it is HW updates).

At this point, I believe, we need to introduce a different behaviour
between architectures depending on how their mm works.

Peter, what do you reckon ? We could just have an
_ARCH_NEEDS_GUP_PTE_UPDATES and call ptep_set_access_flags() on those, I
believe that would be enough (it, it would mimmic what
handle_pte_fault() does to do the updates).

Something (not even compile tested) like:

diff --git a/mm/memory.c b/mm/memory.c
index 40b7531..32024ac 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1515,6 +1515,17 @@ split_fallthrough:
 	if (flags & FOLL_GET)
 		get_page(page);
 	if (flags & FOLL_TOUCH) {
+#ifdef _ARCH_NEEDS_GUP_PTE_UPDATES
+		if (!pte_young(pte) ||
+		    ((flags & FOLL_WRITE) && !pte_dirty(pte))) {
+			pte_t new_pte = pte_mkyoung(pte);
+
+			if (flags & FOLL_WRITE)
+				new_pte = pte_mkdirty(pte);
+			ptep_set_access_flags(vma, address, ptep, pte,
+					      flags & FOLL_WRITE);
+		}
+#else
 		if ((flags & FOLL_WRITE) &&
 		    !pte_dirty(pte) && !PageDirty(page))
 			set_page_dirty(page);
@@ -1524,6 +1535,7 @@ split_fallthrough:
 		 * mark_page_accessed().
 		 */
 		mark_page_accessed(page);
+#endif
 	}
 	if ((flags & FOLL_MLOCK) && (vma->vm_flags & VM_LOCKED)) {
 		/*

I though we could try to factor the young/dirty update from handle_pte_fault
into a separate function and call it there, but I'm not sure whether we want
gup to go to the else case in there for flushing spurrious mappings.... actually,
thinking baout it:

That leads to another potential issue with the way we use gup
here to "fixup" atomic user access (ie, fake fault)... this call to
flush_tlb_fix_spurious_fault(), I'm not entirely certain what it's
doing, ie, it shouldn't be necessary on powerpc and is #ifdef'ed out on
x86, but I suppose -some- archs at least may lazily fixup permissions in a way
that requires it.

That means that an arch that needs that fixup will potentially also break with
the way the futex code relies on gup to do the faulting, since here too, we are
in a situation where gup -will- find a valid struct page and valid write
permission, but some kind of fixup is still needed.

It looks like a more robust fix would be to indeed factor out that code from
handle_pte_fault() and call it from gup as well, at least if the arch requires
it (and we can make "safe" archs like x86 not require it).

We do want to avoid that flush spurrious mapping on common gup's however,
it's going to be a killer. That means we need to inform gup that it's been
called in order to fixup a previously EFAULT'ing atomic user access, and
thus that we require it to perform all the necessary fixups.

In fact, with such a flag, we could probably avoid the ifdef entirely, and
always go toward the PTE fixup path when called in such a fixup case, my gut
feeling is that this is going to be seldom enough not to hurt x86 measurably
but we'll have to try it out.

That leads to that even less tested patch:

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
index fe28dc2..7480a93 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -355,8 +355,8 @@ static int fault_in_user_writeable(u32 __user *uaddr)
 	int ret;
 
 	down_read(&mm->mmap_sem);
-	ret = get_user_pages(current, mm, (unsigned long)uaddr,
-			     1, 1, 0, NULL, NULL);
+	ret = __get_user_pages(current, mm, (unsigned long)uaddr,
+			       FOLL_WRITE | FOLL_FIXFAULT, NULL, NULL, NULL);
 	up_read(&mm->mmap_sem);
 
 	return ret < 0 ? ret : 0;
diff --git a/mm/memory.c b/mm/memory.c
index 40b7531..c61fddc 100644
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
+	if (ptep_set_access_flags(vma, address, pte, entry, write)) {
+		update_mmu_cache(vma, address, pte);
+	} else if (fault) {
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
@@ -1514,16 +1537,22 @@ split_fallthrough:
 
 	if (flags & FOLL_GET)
 		get_page(page);
-	if (flags & FOLL_TOUCH) {
-		if ((flags & FOLL_WRITE) &&
-		    !pte_dirty(pte) && !PageDirty(page))
-			set_page_dirty(page);
-		/*
-		 * pte_mkyoung() would be more correct here, but atomic care
-		 * is needed to avoid losing the dirty bit: it is easier to use
-		 * mark_page_accessed().
-		 */
-		mark_page_accessed(page);
+
+	if (!pte_young(pte) || ((flags & FOLL_WRITE) && !pte_dirty(pte))) {
+		if (flags & FOLL_FIXFAULT)
+			handle_pte_sw_young_dirty(vma, address, ptep,
+						  flags & FOLL_WRITE);
+		else if (flags & FOLL_TOUCH) {
+			if ((flags & FOLL_WRITE) &&
+			    !pte_dirty(pte) && !PageDirty(page))
+				set_page_dirty(page);
+			/*
+			 * pte_mkyoung() would be more correct here, but atomic care
+			 * is needed to avoid losing the dirty bit: it is easier to use
+			 * mark_page_accessed().
+			 */
+			mark_page_accessed(page);
+		}
 	}
 	if ((flags & FOLL_MLOCK) && (vma->vm_flags & VM_LOCKED)) {
 		/*
@@ -3358,21 +3387,8 @@ int handle_pte_fault(struct mm_struct *mm,
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

Any comment ?

Cheers,
Ben.


