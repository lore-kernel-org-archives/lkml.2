Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933657Ab1D2TCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 15:02:18 -0400
Received: from kroah.org ([198.145.64.141]:50383 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933566Ab1D2S6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:42 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:56 2011
Message-Id: <20110429185656.527184904@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:56:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>
Subject: [41/55] mm: check if PTE is already allocated during page fault
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit cc03638df20acbec5d0d0d9e07234aadde9e698d upstream.

With transparent hugepage support, handle_mm_fault() has to be careful
that a normal PMD has been established before handling a PTE fault.  To
achieve this, it used __pte_alloc() directly instead of pte_alloc_map as
pte_alloc_map is unsafe to run against a huge PMD.  pte_offset_map() is
called once it is known the PMD is safe.

pte_alloc_map() is smart enough to check if a PTE is already present
before calling __pte_alloc but this check was lost.  As a consequence,
PTEs may be allocated unnecessarily and the page table lock taken.  Thi
useless PTE does get cleaned up but it's a performance hit which is
visible in page_test from aim9.

This patch simply re-adds the check normally done by pte_alloc_map to
check if the PTE needs to be allocated before taking the page table lock.
The effect is noticable in page_test from aim9.

  AIM9
                  2.6.38-vanilla 2.6.38-checkptenone
  creat-clo      446.10 ( 0.00%)   424.47 (-5.10%)
  page_test       38.10 ( 0.00%)    42.04 ( 9.37%)
  brk_test        52.45 ( 0.00%)    51.57 (-1.71%)
  exec_test      382.00 ( 0.00%)   456.90 (16.39%)
  fork_test       60.11 ( 0.00%)    67.79 (11.34%)
  MMTests Statistics: duration
  Total Elapsed Time (seconds)                611.90    612.22

(While this affects 2.6.38, it is a performance rather than a functional
bug and normally outside the rules -stable.  While the big performance
differences are to a microbench, the difference in fork and exec
performance may be significant enough that -stable wants to consider the
patch)

Reported-by: Raz Ben Yehuda <raziebe@gmail.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3332,7 +3332,7 @@ int handle_mm_fault(struct mm_struct *mm
 	 * run pte_offset_map on the pmd, if an huge pmd could
 	 * materialize from under us from a different thread.
 	 */
-	if (unlikely(__pte_alloc(mm, vma, pmd, address)))
+	if (unlikely(pmd_none(*pmd)) && __pte_alloc(mm, vma, pmd, address))
 		return VM_FAULT_OOM;
 	/* if an huge pmd materialized from under us just retry later */
 	if (unlikely(pmd_trans_huge(*pmd)))


