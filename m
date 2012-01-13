Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab2AMLri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 06:47:38 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:45788 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121Ab2AMLre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 06:47:34 -0500
Message-ID: <4F101935.1040108@linux.vnet.ibm.com>
Date: Fri, 13 Jan 2012 19:44:53 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        William Irwin <wli@holomorphy.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] hugetlb: drop prev_vma in hugetlb_get_unmapped_area_topdown
References: <4F101904.8090405@linux.vnet.ibm.com>
In-Reply-To: <4F101904.8090405@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12011301-5490-0000-0000-000000885F10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Afte call find_vma_prev(mm, addr, &prev_vma), following condition is always
true:
	!prev_vma || (addr >= prev_vma->vm_end)
it can be happily drop prev_vma and use find_vma instead of find_vma_prev

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/mm/hugetlbpage.c |   21 ++++++---------------
 1 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
index f581a18..e12debc 100644
--- a/arch/x86/mm/hugetlbpage.c
+++ b/arch/x86/mm/hugetlbpage.c
@@ -308,7 +308,7 @@ static unsigned long hugetlb_get_unmapped_area_topdown(struct file *file,
 {
 	struct hstate *h = hstate_file(file);
 	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma, *prev_vma;
+	struct vm_area_struct *vma;
 	unsigned long base = mm->mmap_base, addr = addr0;
 	unsigned long largest_hole = mm->cached_hole_size;
 	int first_time = 1;
@@ -333,24 +333,15 @@ try_again:
 		 * Lookup failure means no vma is above this address,
 		 * i.e. return with success:
 		 */
-		if (!(vma = find_vma_prev(mm, addr, &prev_vma)))
-			return addr;
-
-		/*
-		 * new region fits between prev_vma->vm_end and
-		 * vma->vm_start, use it:
-		 */
-		if (addr + len <= vma->vm_start &&
-		            (!prev_vma || (addr >= prev_vma->vm_end))) {
+		vma = find_vma(mm, addr);
+		if (!vma || addr + len <= vma->vm_start) {
 			/* remember the address as a hint for next time */
 		        mm->cached_hole_size = largest_hole;
 		        return (mm->free_area_cache = addr);
-		} else {
+		} else if (mm->free_area_cache == vma->vm_end) {
 			/* pull free_area_cache down to the first hole */
-		        if (mm->free_area_cache == vma->vm_end) {
-				mm->free_area_cache = vma->vm_start;
-				mm->cached_hole_size = largest_hole;
-			}
+			mm->free_area_cache = vma->vm_start;
+			mm->cached_hole_size = largest_hole;
 		}

 		/* remember the largest hole we saw so far */
-- 
1.7.7.5

