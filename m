Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582Ab0KCPhU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:37:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932393Ab0KCPbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:31:01 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 47 of 66] mincore transparent hugepage support
X-Mercurial-Node: 1d89c5a161ce2227cc7e419ed667288f7a2b6ecb
Message-Id: <1d89c5a161ce2227cc7e.1288798102@v2.random>
In-Reply-To: <patchbomb.1288798055@v2.random>
References: <patchbomb.1288798055@v2.random>
User-Agent: Mercurial-patchbomb/1.4.1
Date: Wed, 03 Nov 2010 16:28:22 +0100
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

From: Johannes Weiner <hannes@cmpxchg.org>

Handle transparent huge page pmd entries natively instead of splitting
them into subpages.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
---

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -19,6 +19,9 @@ extern struct page *follow_trans_huge_pm
 extern int zap_huge_pmd(struct mmu_gather *tlb,
 			struct vm_area_struct *vma,
 			pmd_t *pmd);
+extern int mincore_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
+			unsigned long addr, unsigned long end,
+			unsigned char *vec);
 
 enum transparent_hugepage_flag {
 	TRANSPARENT_HUGEPAGE_FLAG,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -919,6 +919,31 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 	return ret;
 }
 
+int mincore_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
+		unsigned long addr, unsigned long end,
+		unsigned char *vec)
+{
+	int ret = 0;
+
+	spin_lock(&vma->vm_mm->page_table_lock);
+	if (likely(pmd_trans_huge(*pmd))) {
+		ret = !pmd_trans_splitting(*pmd);
+		spin_unlock(&vma->vm_mm->page_table_lock);
+		if (unlikely(!ret))
+			wait_split_huge_page(vma->anon_vma, pmd);
+		else {
+			/*
+			 * All logical pages in the range are present
+			 * if backed by a huge page.
+			 */
+			memset(vec, 1, (end - addr) >> PAGE_SHIFT);
+		}
+	} else
+		spin_unlock(&vma->vm_mm->page_table_lock);
+
+	return ret;
+}
+
 pmd_t *page_check_address_pmd(struct page *page,
 			      struct mm_struct *mm,
 			      unsigned long address,
diff --git a/mm/mincore.c b/mm/mincore.c
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -154,7 +154,13 @@ static void mincore_pmd_range(struct vm_
 	pmd = pmd_offset(pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);
-		split_huge_page_pmd(vma->vm_mm, pmd);
+		if (pmd_trans_huge(*pmd)) {
+			if (mincore_huge_pmd(vma, pmd, addr, next, vec)) {
+				vec += (next - addr) >> PAGE_SHIFT;
+				continue;
+			}
+			/* fall through */
+		}
 		if (pmd_none_or_clear_bad(pmd))
 			mincore_unmapped_range(vma, addr, next, vec);
 		else
