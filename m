Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353Ab2KSCP3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 21:15:29 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:47823 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab2KSCP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 21:15:27 -0500
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Michel Lespinasse <walken@google.com>
Subject: [PATCH 01/27] mm/generic: Only flush the local TLB in ptep_set_access_flags()
Date: Mon, 19 Nov 2012 03:14:18 +0100
Message-Id: <1353291284-2998-2-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353291284-2998-1-git-send-email-mingo@kernel.org>
References: <1353291284-2998-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

The function ptep_set_access_flags() is only ever used to upgrade
access permissions to a page - i.e. they make it less restrictive.

That means the only negative side effect of not flushing remote
TLBs in this function is that other CPUs may incur spurious page
faults, if they happen to access the same address, and still have
a PTE with the old permissions cached in their TLB caches.

Having another CPU maybe incur a spurious page fault is faster
than always incurring the cost of a remote TLB flush, so replace
the remote TLB flush with a purely local one.

This should be safe on every architecture that correctly
implements flush_tlb_fix_spurious_fault() to actually invalidate
the local TLB entry that caused a page fault, as well as on
architectures where the hardware invalidates TLB entries that
cause page faults.

In the unlikely event that you are hitting what appears to be
an infinite loop of page faults, and 'git bisect' took you to
this changeset, your architecture needs to implement
flush_tlb_fix_spurious_fault() to actually flush the TLB entry.

Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Hugh Dickins <hughd@google.com>
[ Changelog massage. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 mm/pgtable-generic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index e642627..d8397da 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -12,8 +12,8 @@
 
 #ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 /*
- * Only sets the access flags (dirty, accessed, and
- * writable). Furthermore, we know it always gets set to a "more
+ * Only sets the access flags (dirty, accessed), as well as write 
+ * permission. Furthermore, we know it always gets set to a "more
  * permissive" setting, which allows most architectures to optimize
  * this. We return whether the PTE actually changed, which in turn
  * instructs the caller to do things like update__mmu_cache.  This
@@ -27,7 +27,7 @@ int ptep_set_access_flags(struct vm_area_struct *vma,
 	int changed = !pte_same(*ptep, entry);
 	if (changed) {
 		set_pte_at(vma->vm_mm, address, ptep, entry);
-		flush_tlb_page(vma, address);
+		flush_tlb_fix_spurious_fault(vma, address);
 	}
 	return changed;
 }
-- 
1.7.11.7

