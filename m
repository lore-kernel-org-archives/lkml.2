Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab2KMROp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 12:14:45 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37723 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab2KMROl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:14:41 -0500
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Paul Turner <pjt@google.com>, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michel Lespinasse <walken@google.com>
Subject: [PATCH 02/31] x86/mm: Only do a local tlb flush in ptep_set_access_flags()
Date: Tue, 13 Nov 2012 18:13:25 +0100
Message-Id: <1352826834-11774-3-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352826834-11774-1-git-send-email-mingo@kernel.org>
References: <1352826834-11774-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Because we only ever upgrade a PTE when calling ptep_set_access_flags(),
it is safe to skip flushing entries on remote TLBs.

The worst that can happen is a spurious page fault on other CPUs, which
would flush that TLB entry.

Lazily letting another CPU incur a spurious page fault occasionally
is (much!) cheaper than aggressively flushing everybody else's TLB.

Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/pgtable.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 8573b83..be3bb46 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -301,6 +301,13 @@ void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 	free_page((unsigned long)pgd);
 }
 
+/*
+ * Used to set accessed or dirty bits in the page table entries
+ * on other architectures. On x86, the accessed and dirty bits
+ * are tracked by hardware. However, do_wp_page calls this function
+ * to also make the pte writeable at the same time the dirty bit is
+ * set. In that case we do actually need to write the PTE.
+ */
 int ptep_set_access_flags(struct vm_area_struct *vma,
 			  unsigned long address, pte_t *ptep,
 			  pte_t entry, int dirty)
@@ -310,7 +317,7 @@ int ptep_set_access_flags(struct vm_area_struct *vma,
 	if (changed && dirty) {
 		*ptep = entry;
 		pte_update_defer(vma->vm_mm, address, ptep);
-		flush_tlb_page(vma, address);
+		__flush_tlb_one(address);
 	}
 
 	return changed;
-- 
1.7.11.7

