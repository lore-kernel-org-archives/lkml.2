Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab0HRUXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 16:23:21 -0400
Received: from kroah.org ([198.145.64.141]:46037 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab0HRUXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 16:23:19 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 18 13:22:02 2010
Message-Id: <20100818202202.737219302@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 18 Aug 2010 13:19:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Pekka Enberg <penberg@kernel.org>
Subject: [1/2] mm: fix page table unmap for stack guard page properly
In-Reply-To: <20100818202224.GA32370@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 11ac552477e32835cb6970bf0a70c210807f5673 upstream.

We do in fact need to unmap the page table _before_ doing the whole
stack guard page logic, because if it is needed (mainly 32-bit x86 with
PAE and CONFIG_HIGHPTE, but other architectures may use it too) then it
will do a kmap_atomic/kunmap_atomic.

And those kmaps will create an atomic region that we cannot do
allocations in.  However, the whole stack expand code will need to do
anon_vma_prepare() and vma_lock_anon_vma() and they cannot do that in an
atomic region.

Now, a better model might actually be to do the anon_vma_prepare() when
_creating_ a VM_GROWSDOWN segment, and not have to worry about any of
this at page fault time.  But in the meantime, this is the
straightforward fix for the issue.

See https://bugzilla.kernel.org/show_bug.cgi?id=16588 for details.

Reported-by: Wylda <wylda@volny.cz>
Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Reported-by: Mike Pagano <mpagano@gentoo.org>
Reported-by: François Valenduc <francois.valenduc@tvcablenet.be>
Tested-by: Ed Tomlinson <edt@aei.ca>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/memory.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2662,24 +2662,23 @@ static int do_anonymous_page(struct mm_s
 	spinlock_t *ptl;
 	pte_t entry;
 
-	if (check_stack_guard_page(vma, address) < 0) {
-		pte_unmap(page_table);
+	pte_unmap(page_table);
+
+	/* Check if we need to add a guard page to the stack */
+	if (check_stack_guard_page(vma, address) < 0)
 		return VM_FAULT_SIGBUS;
-	}
 
+	/* Use the zero-page for reads */
 	if (!(flags & FAULT_FLAG_WRITE)) {
 		entry = pte_mkspecial(pfn_pte(my_zero_pfn(address),
 						vma->vm_page_prot));
-		ptl = pte_lockptr(mm, pmd);
-		spin_lock(ptl);
+		page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
 		if (!pte_none(*page_table))
 			goto unlock;
 		goto setpte;
 	}
 
 	/* Allocate our own private page. */
-	pte_unmap(page_table);
-
 	if (unlikely(anon_vma_prepare(vma)))
 		goto oom;
 	page = alloc_zeroed_user_highpage_movable(vma, address);


