Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab2ILM4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:56:51 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:55028 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758452Ab2ILM4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:56:49 -0400
Message-ID: <50508689.50904@linux.vnet.ibm.com>
Date: Wed, 12 Sep 2012 20:56:41 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] thp: move release mmap_sem lock out of khugepaged_alloc_page
References: <50508632.9090003@linux.vnet.ibm.com>
In-Reply-To: <50508632.9090003@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12091212-1396-0000-0000-000001DCFDD8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To make the code more clear, move release the lock out of khugepaged_alloc_page

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 mm/huge_memory.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 66d2bc6..5622347 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1854,11 +1854,6 @@ static struct page
 	*hpage  = alloc_hugepage_vma(khugepaged_defrag(), vma, address,
 				      node, __GFP_OTHER_NODE);

-	/*
-	 * After allocating the hugepage, release the mmap_sem read lock in
-	 * preparation for taking it in write mode.
-	 */
-	up_read(&mm->mmap_sem);
 	if (unlikely(!*hpage)) {
 		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
 		*hpage = ERR_PTR(-ENOMEM);
@@ -1905,7 +1900,6 @@ static struct page
 		       struct vm_area_struct *vma, unsigned long address,
 		       int node)
 {
-	up_read(&mm->mmap_sem);
 	VM_BUG_ON(!*hpage);
 	return  *hpage;
 }
@@ -1931,8 +1925,14 @@ static void collapse_huge_page(struct mm_struct *mm,

 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);

-	/* release the mmap_sem read lock. */
 	new_page = khugepaged_alloc_page(hpage, mm, vma, address, node);
+
+	/*
+	 * After allocating the hugepage, release the mmap_sem read lock in
+	 * preparation for taking it in write mode.
+	 */
+	up_read(&mm->mmap_sem);
+
 	if (!new_page)
 		return;

-- 
1.7.7.6

