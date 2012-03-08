Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab2CHVYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 16:24:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60965 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab2CHVYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 16:24:16 -0500
Date: Thu, 8 Mar 2012 13:24:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20120308132415.15359fc7.akpm@linux-foundation.org>
In-Reply-To: <4F5882E6.8080202@linux.vnet.ibm.com>
References: <20120308175307.b295b1013728a5666fe4571a@canb.auug.org.au>
	<20120307233220.5a76aa3c.akpm@linux-foundation.org>
	<20120308184105.5b03ec90bcddf90562181277@canb.auug.org.au>
	<20120307235012.847af577.akpm@linux-foundation.org>
	<4F5882E6.8080202@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Mar 2012 17:59:02 +0800
Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> Andrew, the patch has been reworked.
> 
> Subject: [PATCH] hugetlb: drop prev_vma in hugetlb_get_unmapped_area_topdown()
> 
> After the call find_vma_prev(mm, addr, &prev_vma), the following condition
> is always true:
> 
> 	!prev_vma || (addr >= prev_vma->vm_end)
> 
> it can happily drop prev_vma and use find_vma() instead of find_vma_prev().
> 

Well OK, but the changelog is wrong - we don't call find_vma_prev()
here any more.

How does this look?


From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: hugetlb: remove prev_vma from hugetlb_get_unmapped_area_topdown()

After looking up the vma which covers or follows the cached search
address, the following condition is always true:

	!prev_vma || (addr >= prev_vma->vm_end)

so we can stop checking the previous VMA altogether.

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/hugetlbpage.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff -puN arch/x86/mm/hugetlbpage.c~hugetlb-drop-prev_vma-in-hugetlb_get_unmapped_area_topdown arch/x86/mm/hugetlbpage.c
--- a/arch/x86/mm/hugetlbpage.c~hugetlb-drop-prev_vma-in-hugetlb_get_unmapped_area_topdown
+++ a/arch/x86/mm/hugetlbpage.c
@@ -308,7 +308,7 @@ static unsigned long hugetlb_get_unmappe
 {
 	struct hstate *h = hstate_file(file);
 	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma, *prev_vma;
+	struct vm_area_struct *vma;
 	unsigned long base = mm->mmap_base;
 	unsigned long addr = addr0;
 	unsigned long largest_hole = mm->cached_hole_size;
@@ -340,22 +340,14 @@ try_again:
 		if (!vma)
 			return addr;
 
-		/*
-		 * new region fits between prev_vma->vm_end and
-		 * vma->vm_start, use it:
-		 */
-		prev_vma = vma->vm_prev;
-		if (addr + len <= vma->vm_start &&
-		            (!prev_vma || (addr >= prev_vma->vm_end))) {
+		if (addr + len <= vma->vm_start) {
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
_

