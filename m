Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab2JQNBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 09:01:53 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36386 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752100Ab2JQNBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 09:01:49 -0400
Date: Wed, 17 Oct 2012 14:01:25 +0100
From: Will Deacon <will.deacon@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "mhocko@suse.cz" <mhocko@suse.cz>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Steve Capper <Steve.Capper@arm.com>
Subject: Re: [PATCH v2] mm: thp: Set the accessed flag for old pages on
 access fault.
Message-ID: <20121017130125.GH5973@mudshark.cambridge.arm.com>
References: <1349197151-19645-1-git-send-email-will.deacon@arm.com>
 <20121002150104.da57fa94.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002150104.da57fa94.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Tue, Oct 02, 2012 at 11:01:04PM +0100, Andrew Morton wrote:
> On Tue,  2 Oct 2012 17:59:11 +0100
> Will Deacon <will.deacon@arm.com> wrote:
> 
> > On x86 memory accesses to pages without the ACCESSED flag set result in the
> > ACCESSED flag being set automatically. With the ARM architecture a page access
> > fault is raised instead (and it will continue to be raised until the ACCESSED
> > flag is set for the appropriate PTE/PMD).
> > 
> > For normal memory pages, handle_pte_fault will call pte_mkyoung (effectively
> > setting the ACCESSED flag). For transparent huge pages, pmd_mkyoung will only
> > be called for a write fault.
> > 
> > This patch ensures that faults on transparent hugepages which do not result
> > in a CoW update the access flags for the faulting pmd.
> 
> Alas, the code you're altering has changed so much in linux-next that I
> am reluctant to force this fix in there myself.  Can you please
> redo/retest/resend?  You can do that on 3.7-rc1 if you like, then we
> can feed this into -rc2.

Here's the updated patch against -rc1...

Cheers,

Will

--->8

>From 16b73aea010832cd3d6f22ada60ae055937ef6c0 Mon Sep 17 00:00:00 2001
From: Will Deacon <will.deacon@arm.com>
Date: Tue, 2 Oct 2012 11:18:52 +0100
Subject: [PATCH] mm: thp: Set the accessed flag for old pages on access fault.

On x86 memory accesses to pages without the ACCESSED flag set result in the
ACCESSED flag being set automatically. With the ARM architecture a page access
fault is raised instead (and it will continue to be raised until the ACCESSED
flag is set for the appropriate PTE/PMD).

For normal memory pages, handle_pte_fault will call pte_mkyoung (effectively
setting the ACCESSED flag). For transparent huge pages, pmd_mkyoung will only
be called for a write fault.

This patch ensures that faults on transparent hugepages which do not result
in a CoW update the access flags for the faulting pmd.

Cc: Chris Metcalf <cmetcalf@tilera.com>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Steve Capper <steve.capper@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 include/linux/huge_mm.h |    2 ++
 mm/huge_memory.c        |    8 ++++++++
 mm/memory.c             |    9 ++++++++-
 3 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index b31cb7d..62a0d5a 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -8,6 +8,8 @@ extern int do_huge_pmd_anonymous_page(struct mm_struct *mm,
 extern int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 			 pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
 			 struct vm_area_struct *vma);
+extern void huge_pmd_set_accessed(struct vm_area_struct *vma,
+				  unsigned long address, pmd_t *pmd, int dirty);
 extern int do_huge_pmd_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			       unsigned long address, pmd_t *pmd,
 			       pmd_t orig_pmd);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index a863af2..5a7ce24 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -878,6 +878,14 @@ out_free_pages:
 	goto out;
 }
 
+void huge_pmd_set_accessed(struct vm_area_struct *vma, unsigned long address,
+			   pmd_t *pmd, int dirty)
+{
+	pmd_t entry = pmd_mkyoung(*pmd);
+	if (pmdp_set_access_flags(vma, address & HPAGE_PMD_MASK, pmd, entry, dirty))
+		update_mmu_cache(vma, address, pmd);
+}
+
 int do_huge_pmd_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, pmd_t *pmd, pmd_t orig_pmd)
 {
diff --git a/mm/memory.c b/mm/memory.c
index fb135ba..c55c17c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3539,7 +3539,8 @@ retry:
 
 		barrier();
 		if (pmd_trans_huge(orig_pmd)) {
-			if (flags & FAULT_FLAG_WRITE &&
+			unsigned int dirty = flags & FAULT_FLAG_WRITE;
+			if (dirty &&
 			    !pmd_write(orig_pmd) &&
 			    !pmd_trans_splitting(orig_pmd)) {
 				ret = do_huge_pmd_wp_page(mm, vma, address, pmd,
@@ -3552,7 +3553,13 @@ retry:
 				if (unlikely(ret & VM_FAULT_OOM))
 					goto retry;
 				return ret;
+			} else if (pmd_trans_huge_lock(pmd, vma) == 1) {
+				if (likely(pmd_same(*pmd, orig_pmd)))
+					huge_pmd_set_accessed(vma, address, pmd,
+							      dirty);
+				spin_unlock(&mm->page_table_lock);
 			}
+
 			return 0;
 		}
 	}
-- 
1.7.4.1

