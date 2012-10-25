Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935618Ab2JYNOb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 09:14:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:51641 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422896Ab2JYNKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 09:10:12 -0400
Message-Id: <20121025124833.713589294@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 25 Oct 2012 14:16:33 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 16/31] numa, mm: Support NUMA hinting page faults from gup/gup_fast
References: <20121025121617.617683848@chello.nl>
Content-Disposition: inline; filename=0016-numa-mm-Support-NUMA-hinting-page-faults-from-gup-gu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

Introduce FOLL_NUMA to tell follow_page to check
pte/pmd_numa. get_user_pages must use FOLL_NUMA, and it's safe to do
so because it always invokes handle_mm_fault and retries the
follow_page later.

KVM secondary MMU page faults will trigger the NUMA hinting page
faults through gup_fast -> get_user_pages -> follow_page ->
handle_mm_fault.

Other follow_page callers like KSM should not use FOLL_NUMA, or they
would fail to get the pages if they use follow_page instead of
get_user_pages.

[ This patch was picked up from the AutoNUMA tree. ]

Originally-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
[ ported to this tree. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/mm.h |    1 +
 mm/memory.c        |   17 +++++++++++++++++
 2 files changed, 18 insertions(+)

Index: tip/include/linux/mm.h
===================================================================
--- tip.orig/include/linux/mm.h
+++ tip/include/linux/mm.h
@@ -1600,6 +1600,7 @@ struct page *follow_page(struct vm_area_
 #define FOLL_MLOCK	0x40	/* mark page as mlocked */
 #define FOLL_SPLIT	0x80	/* don't return transhuge pages, split them */
 #define FOLL_HWPOISON	0x100	/* check page is hwpoisoned */
+#define FOLL_NUMA	0x200	/* force NUMA hinting page fault */
 
 typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
 			void *data);
Index: tip/mm/memory.c
===================================================================
--- tip.orig/mm/memory.c
+++ tip/mm/memory.c
@@ -1536,6 +1536,8 @@ struct page *follow_page(struct vm_area_
 		page = follow_huge_pmd(mm, address, pmd, flags & FOLL_WRITE);
 		goto out;
 	}
+	if ((flags & FOLL_NUMA) && pmd_numa(vma, *pmd))
+		goto no_page_table;
 	if (pmd_trans_huge(*pmd)) {
 		if (flags & FOLL_SPLIT) {
 			split_huge_page_pmd(mm, pmd);
@@ -1565,6 +1567,8 @@ split_fallthrough:
 	pte = *ptep;
 	if (!pte_present(pte))
 		goto no_page;
+	if ((flags & FOLL_NUMA) && pte_numa(vma, pte))
+		goto no_page;
 	if ((flags & FOLL_WRITE) && !pte_write(pte))
 		goto unlock;
 
@@ -1716,6 +1720,19 @@ int __get_user_pages(struct task_struct
 			(VM_WRITE | VM_MAYWRITE) : (VM_READ | VM_MAYREAD);
 	vm_flags &= (gup_flags & FOLL_FORCE) ?
 			(VM_MAYREAD | VM_MAYWRITE) : (VM_READ | VM_WRITE);
+
+	/*
+	 * If FOLL_FORCE and FOLL_NUMA are both set, handle_mm_fault
+	 * would be called on PROT_NONE ranges. We must never invoke
+	 * handle_mm_fault on PROT_NONE ranges or the NUMA hinting
+	 * page faults would unprotect the PROT_NONE ranges if
+	 * _PAGE_NUMA and _PAGE_PROTNONE are sharing the same pte/pmd
+	 * bitflag. So to avoid that, don't set FOLL_NUMA if
+	 * FOLL_FORCE is set.
+	 */
+	if (!(gup_flags & FOLL_FORCE))
+		gup_flags |= FOLL_NUMA;
+
 	i = 0;
 
 	do {


