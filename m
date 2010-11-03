Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575Ab0KCPbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:31:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932433Ab0KCPbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:31:08 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 57 of 66] avoid breaking huge pmd invariants in case of
	vma_adjust failures
X-Mercurial-Node: 7109b653df89696ed9f903cb5174eea5d94729f3
Message-Id: <7109b653df89696ed9f9.1288798112@v2.random>
In-Reply-To: <patchbomb.1288798055@v2.random>
References: <patchbomb.1288798055@v2.random>
User-Agent: Mercurial-patchbomb/1.4.1
Date: Wed, 03 Nov 2010 16:28:32 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Adam Litke <agl@us.ibm.com>,
        Avi Kivity <avi@redhat.com>, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>, bpicco@redhat.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrea Arcangeli <aarcange@redhat.com>

An huge pmd can only be mapped if the corresponding 2M virtual range
is fully contained in the vma. At times the VM calls split_vma twice,
if the first split_vma succeeds and the second fail, the first
split_vma remains in effect and it's not rolled back. For split_vma or
vma_adjust to fail an allocation failure is needed so it's a very
unlikely event (the out of memory killer would normally fire before
any allocation failure is visible to kernel and userland and if an out
of memory condition happens it's unlikely to happen exactly
here). Nevertheless it's safer to ensure that no huge pmd can be left
around if the vma is adjusted in a way that can't fit hugepages
anymore at the new vm_start/vm_end address.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -106,6 +106,19 @@ extern void __split_huge_page_pmd(struct
 
 extern unsigned long vma_address(struct page *page, struct vm_area_struct *vma);
 extern int hugepage_madvise(unsigned long *vm_flags);
+extern void __vma_adjust_trans_huge(struct vm_area_struct *vma,
+				    unsigned long start,
+				    unsigned long end,
+				    long adjust_next);
+static inline void vma_adjust_trans_huge(struct vm_area_struct *vma,
+					 unsigned long start,
+					 unsigned long end,
+					 long adjust_next)
+{
+	if (!vma->anon_vma || vma->vm_ops || vma->vm_file)
+		return;
+	__vma_adjust_trans_huge(vma, start, end, adjust_next);
+}
 static inline int PageTransHuge(struct page *page)
 {
 	VM_BUG_ON(PageTail(page));
@@ -138,6 +151,12 @@ static inline int hugepage_madvise(unsig
 	BUG_ON(0);
 	return 0;
 }
+static inline void vma_adjust_trans_huge(struct vm_area_struct *vma,
+					 unsigned long start,
+					 unsigned long end,
+					 long adjust_next)
+{
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #endif /* _LINUX_HUGE_MM_H */
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1071,8 +1071,16 @@ pmd_t *page_check_address_pmd(struct pag
 		goto out;
 	if (pmd_page(*pmd) != page)
 		goto out;
-	VM_BUG_ON(flag == PAGE_CHECK_ADDRESS_PMD_NOTSPLITTING_FLAG &&
-		  pmd_trans_splitting(*pmd));
+	/*
+	 * split_vma() may create temporary aliased mappings. There is
+	 * no risk as long as all huge pmd are found and have their
+	 * splitting bit set before __split_huge_page_refcount
+	 * runs. Finding the same huge pmd more than once during the
+	 * same rmap walk is not a problem.
+	 */
+	if (flag == PAGE_CHECK_ADDRESS_PMD_NOTSPLITTING_FLAG &&
+	    pmd_trans_splitting(*pmd))
+		goto out;
 	if (pmd_trans_huge(*pmd)) {
 		VM_BUG_ON(flag == PAGE_CHECK_ADDRESS_PMD_SPLITTING_FLAG &&
 			  !pmd_trans_splitting(*pmd));
@@ -2174,3 +2182,71 @@ void __split_huge_page_pmd(struct mm_str
 	put_page(page);
 	BUG_ON(pmd_trans_huge(*pmd));
 }
+
+static void split_huge_page_address(struct mm_struct *mm,
+				    unsigned long address)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+
+	VM_BUG_ON(!(address & ~HPAGE_PMD_MASK));
+
+	pgd = pgd_offset(mm, address);
+	if (!pgd_present(*pgd))
+		return;
+
+	pud = pud_offset(pgd, address);
+	if (!pud_present(*pud))
+		return;
+
+	pmd = pmd_offset(pud, address);
+	if (!pmd_present(*pmd))
+		return;
+	/*
+	 * Caller holds the mmap_sem write mode, so a huge pmd cannot
+	 * materialize from under us.
+	 */
+	split_huge_page_pmd(mm, pmd);
+}
+
+void __vma_adjust_trans_huge(struct vm_area_struct *vma,
+			     unsigned long start,
+			     unsigned long end,
+			     long adjust_next)
+{
+	/*
+	 * If the new start address isn't hpage aligned and it could
+	 * previously contain an hugepage: check if we need to split
+	 * an huge pmd.
+	 */
+	if (start & ~HPAGE_PMD_MASK &&
+	    (start & HPAGE_PMD_MASK) >= vma->vm_start &&
+	    (start & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE <= vma->vm_end)
+		split_huge_page_address(vma->vm_mm, start);
+
+	/*
+	 * If the new end address isn't hpage aligned and it could
+	 * previously contain an hugepage: check if we need to split
+	 * an huge pmd.
+	 */
+	if (end & ~HPAGE_PMD_MASK &&
+	    (end & HPAGE_PMD_MASK) >= vma->vm_start &&
+	    (end & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE <= vma->vm_end)
+		split_huge_page_address(vma->vm_mm, end);
+
+	/*
+	 * If we're also updating the vma->vm_next->vm_start, if the new
+	 * vm_next->vm_start isn't page aligned and it could previously
+	 * contain an hugepage: check if we need to split an huge pmd.
+	 */
+	if (adjust_next > 0) {
+		struct vm_area_struct *next = vma->vm_next;
+		unsigned long nstart = next->vm_start;
+		nstart += adjust_next << PAGE_SHIFT;
+		if (nstart & ~HPAGE_PMD_MASK &&
+		    (nstart & HPAGE_PMD_MASK) >= next->vm_start &&
+		    (nstart & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE <= next->vm_end)
+			split_huge_page_address(next->vm_mm, nstart);
+	}
+}
diff --git a/mm/mmap.c b/mm/mmap.c
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -589,6 +589,8 @@ again:			remove_next = 1 + (end > next->
 		}
 	}
 
+	vma_adjust_trans_huge(vma, start, end, adjust_next);
+
 	/*
 	 * When changing only vma->vm_end, we don't really need anon_vma
 	 * lock. This is a fairly rare case by itself, but the anon_vma
