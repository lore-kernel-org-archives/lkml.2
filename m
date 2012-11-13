Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab2KMKHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 05:07:42 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:63439 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019Ab2KMKHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 05:07:41 -0500
Date: Tue, 13 Nov 2012 11:07:36 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/19] mm: numa: teach gup_fast about pmd_numa
Message-ID: <20121113100735.GC21522@gmail.com>
References: <1352193295-26815-1-git-send-email-mgorman@suse.de>
 <1352193295-26815-7-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352193295-26815-7-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mel Gorman <mgorman@suse.de> wrote:

> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> When scanning pmds, the pmd may be of numa type (_PAGE_PRESENT not set),
> however the pte might be present. Therefore, gup_pmd_range() must return
> 0 in this case to avoid losing a NUMA hinting page fault during gup_fast.
> 
> Note: gup_fast will skip over non present ptes (like numa 
> types), so no explicit check is needed for the pte_numa case. 
> [...]

So, why not fix all architectures that choose to expose 
pte_numa() and pmd_numa() methods - via the patch below?

Thanks,

	Ingo

----------------->
>From db4aa58db59a2a296141c698be8b4535d0051ca1 Mon Sep 17 00:00:00 2001
From: Andrea Arcangeli <aarcange@redhat.com>
Date: Fri, 5 Oct 2012 21:36:27 +0200
Subject: [PATCH] numa, mm: Support NUMA hinting page faults from gup/gup_fast

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
 include/linux/mm.h |  1 +
 mm/memory.c        | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0025bf9..1821629 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1600,6 +1600,7 @@ struct page *follow_page(struct vm_area_struct *, unsigned long address,
 #define FOLL_MLOCK	0x40	/* mark page as mlocked */
 #define FOLL_SPLIT	0x80	/* don't return transhuge pages, split them */
 #define FOLL_HWPOISON	0x100	/* check page is hwpoisoned */
+#define FOLL_NUMA	0x200	/* force NUMA hinting page fault */
 
 typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
 			void *data);
diff --git a/mm/memory.c b/mm/memory.c
index e3e8ab2..a660fd0 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1536,6 +1536,8 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
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
 
@@ -1716,6 +1720,19 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
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
