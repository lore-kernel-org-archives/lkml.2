Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab0HRPIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 11:08:10 -0400
Received: from kroah.org ([198.145.64.141]:47482 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828Ab0HRPHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 11:07:39 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 18 08:05:57 2010
Message-Id: <20100818150557.522312831@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 18 Aug 2010 08:01:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Pekka Enberg <penberg@kernel.org>
Subject: [5/6] mm: fix page table unmap for stack guard page properly
In-Reply-To: <20100818150615.GA4752@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

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
Cc: Greg KH <gregkh@suse.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/memory.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2428,14 +2428,13 @@ static int do_anonymous_page(struct mm_s
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
 
 	/* Allocate our own private page. */
-	pte_unmap(page_table);
-
 	if (unlikely(anon_vma_prepare(vma)))
 		goto oom;
 	page = alloc_zeroed_user_highpage_movable(vma, address);


