Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab1EYHJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 03:09:53 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41117 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab1EYHJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 03:09:52 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDCAB35.60109@jp.fujitsu.com>
Date: Wed, 25 May 2011 16:09:41 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: kosaki.motohiro@jp.fujitsu.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, aarcange@redhat.com,
        akpm@linux-foundation.org, n-horiguchi@ah.jp.nec.com,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: [PATCH 2/4] pagewalk: don't look up vma if walk->hugetlb_entry is
 unused
References: <4DDCAAC0.20102@jp.fujitsu.com>
In-Reply-To: <4DDCAAC0.20102@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, walk_page_range() call find_vma() every page table
walk iteration. but it's completely unnecessary if walk->hugetlb_entry
is unused. And we don't have to assume find_vma() is lightweight
operation. Thus this patch check walk->hugetlb_entry and avoid
find_vma() call if possible.

This patch also makes some cleanups. 1) remove ugly uninitialized_var()
and 2) #ifdef in function body.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/pagewalk.c |   43 +++++++++++++++++++++++++++++++++++++------
 1 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 606bbb4..ee4ff87 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -126,7 +126,39 @@ static int walk_hugetlb_range(struct vm_area_struct *vma,

 	return 0;
 }
-#endif
+
+static struct vm_area_struct* hugetlb_vma(unsigned long addr, struct mm_walk *walk)
+{
+	struct vm_area_struct *vma;
+
+	/* We don't need vma lookup at all. */
+	if (!walk->hugetlb_entry)
+		return NULL;
+
+	VM_BUG_ON(!rwsem_is_locked(&walk->mm->mmap_sem));
+	vma = find_vma(walk->mm, addr);
+	if (vma && vma->vm_start <= addr && is_vm_hugetlb_page(vma))
+		return vma;
+
+	return NULL;
+}
+
+#else /* CONFIG_HUGETLB_PAGE */
+static struct vm_area_struct* hugetlb_vma(unsigned long addr, struct mm_walk *walk)
+{
+	return NULL;
+}
+
+static int walk_hugetlb_range(struct vm_area_struct *vma,
+			      unsigned long addr, unsigned long end,
+			      struct mm_walk *walk)
+{
+	return 0;
+}
+
+#endif /* CONFIG_HUGETLB_PAGE */
+
+

 /**
  * walk_page_range - walk a memory map's page tables with a callback
@@ -165,18 +197,17 @@ int walk_page_range(unsigned long addr, unsigned long end,

 	pgd = pgd_offset(walk->mm, addr);
 	do {
-		struct vm_area_struct *uninitialized_var(vma);
+		struct vm_area_struct *vma;

 		next = pgd_addr_end(addr, end);

-#ifdef CONFIG_HUGETLB_PAGE
 		/*
 		 * handle hugetlb vma individually because pagetable walk for
 		 * the hugetlb page is dependent on the architecture and
 		 * we can't handled it in the same manner as non-huge pages.
 		 */
-		vma = find_vma(walk->mm, addr);
-		if (vma && vma->vm_start <= addr && is_vm_hugetlb_page(vma)) {
+		vma = hugetlb_vma(addr, walk);
+		if (vma) {
 			if (vma->vm_end < next)
 				next = vma->vm_end;
 			/*
@@ -189,7 +220,7 @@ int walk_page_range(unsigned long addr, unsigned long end,
 			pgd = pgd_offset(walk->mm, next);
 			continue;
 		}
-#endif
+
 		if (pgd_none_or_clear_bad(pgd)) {
 			if (walk->pte_hole)
 				err = walk->pte_hole(addr, next, walk);
-- 
1.7.3.1



