Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030287Ab2CBWyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 17:54:09 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59398 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab2CBWyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 17:54:07 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of hughd@google.com designates 10.68.134.102 as permitted sender) smtp.mail=hughd@google.com; dkim=pass header.i=hughd@google.com
Date: Fri, 2 Mar 2012 14:53:32 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andrea Arcangeli <aarcange@redhat.com>, Dave Jones <davej@redhat.com>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, kernel-team@fedoraproject.org
Subject: Re: exit_mmap() BUG_ON triggering since 3.1
In-Reply-To: <20120216214245.GD23585@redhat.com>
Message-ID: <alpine.LSU.2.00.1203021444040.3448@eggly.anvils>
References: <20120215183317.GA26977@redhat.com> <alpine.LSU.2.00.1202151801020.19691@eggly.anvils> <20120216070753.GA23585@redhat.com> <alpine.LSU.2.00.1202160130500.16147@eggly.anvils> <20120216214245.GD23585@redhat.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Feb 2012, Andrea Arcangeli wrote:
> On Thu, Feb 16, 2012 at 01:53:04AM -0800, Hugh Dickins wrote:
> > Yes (and I think less troublesome than most BUGs, coming at exit
> > while not holding locks; though we could well make it a WARN_ON,
> > I don't think that existed back in the day).
> 
> A WARN_ON would be fine with me, go ahead if you prefer it... only
> risk would be to go unnoticed or be underestimated. I am ok with the
> BUG_ON too (even if this time it triggered false positives... sigh).
> 
> > Acked-by: Hugh Dickins <hughd@google.com>
> 
> Thanks for the quick review!
> 
> > In looking into the bug, it had actually bothered me a little that you
> > were setting aside those pages, yet not counting them into nr_ptes;
> > though the only thing that cares is oom_kill.c, and the count of pages
> > in each hugepage can only dwarf the count in nr_ptes (whereas, without
> > hugepages, it's possible to populate very sparsely and nr_ptes become
> > significant).
> 
> Agreed, it's not significant either ways.
> 
> Running my two primary systems with this applied for half a day and no
> problem so far so it should be good foro -mm at least.

And I've had no trouble running your patch since then (but I never hit
the bug it fixes either).  But we've all forgottent about it, so let me
bring your patch back inline (I've added one introductory sentence) and
address to akpm...


From: Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH] mm: thp: fix BUG on mm->nr_ptes

Dave Jones reports a few Fedora users hitting the BUG_ON(mm->nr_ptes...)
in exit_mmap() recently.

Quoting Hugh's discovery and explanation of the SMP race condition:

===
mm->nr_ptes had unusual locking: down_read mmap_sem plus
page_table_lock when incrementing, down_write mmap_sem (or mm_users 0)
when decrementing; whereas THP is careful to increment and decrement
it under page_table_lock.

Now most of those paths in THP also hold mmap_sem for read or write
(with appropriate checks on mm_users), but two do not: when
split_huge_page() is called by hwpoison_user_mappings(), and when
called by add_to_swap().

It's conceivable that the latter case is responsible for the
exit_mmap() BUG_ON mm->nr_ptes that has been reported on Fedora.
===

The simplest way to fix it without having to alter the locking is to
make split_huge_page() a noop in nr_ptes terms, so by counting the
preallocated pagetables that exists for every mapped hugepage. It was
an arbitrary choice not to count them and either way is not wrong or
right, because they are not used but they're still allocated.

Reported-by: Dave Jones <davej@redhat.com>
Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
---
 mm/huge_memory.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 91d3efb..8f7fc39 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -671,6 +671,7 @@ static int __do_huge_pmd_anonymous_page(struct mm_struct *mm,
 		set_pmd_at(mm, haddr, pmd, entry);
 		prepare_pmd_huge_pte(pgtable, mm);
 		add_mm_counter(mm, MM_ANONPAGES, HPAGE_PMD_NR);
+		mm->nr_ptes++;
 		spin_unlock(&mm->page_table_lock);
 	}
 
@@ -789,6 +790,7 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	pmd = pmd_mkold(pmd_wrprotect(pmd));
 	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
 	prepare_pmd_huge_pte(pgtable, dst_mm);
+	dst_mm->nr_ptes++;
 
 	ret = 0;
 out_unlock:
@@ -887,7 +889,6 @@ static int do_huge_pmd_wp_page_fallback(struct mm_struct *mm,
 	}
 	kfree(pages);
 
-	mm->nr_ptes++;
 	smp_wmb(); /* make pte visible before pmd */
 	pmd_populate(mm, pmd, pgtable);
 	page_remove_rmap(page);
@@ -1047,6 +1048,7 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			VM_BUG_ON(page_mapcount(page) < 0);
 			add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
 			VM_BUG_ON(!PageHead(page));
+			tlb->mm->nr_ptes--;
 			spin_unlock(&tlb->mm->page_table_lock);
 			tlb_remove_page(tlb, page);
 			pte_free(tlb->mm, pgtable);
@@ -1375,7 +1377,6 @@ static int __split_huge_page_map(struct page *page,
 			pte_unmap(pte);
 		}
 
-		mm->nr_ptes++;
 		smp_wmb(); /* make pte visible before pmd */
 		/*
 		 * Up to this point the pmd is present and huge and
@@ -1988,7 +1989,6 @@ static void collapse_huge_page(struct mm_struct *mm,
 	set_pmd_at(mm, address, pmd, _pmd);
 	update_mmu_cache(vma, address, _pmd);
 	prepare_pmd_huge_pte(pgtable, mm);
-	mm->nr_ptes--;
 	spin_unlock(&mm->page_table_lock);
 
 #ifndef CONFIG_NUMA
