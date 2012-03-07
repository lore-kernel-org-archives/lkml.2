Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965268Ab2CGWBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 17:01:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51803 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387Ab2CGWBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 17:01:03 -0500
Date: Wed, 7 Mar 2012 14:01:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: William Irwin <wli@holomorphy.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] hugetlb: drop prev_vma in
 hugetlb_get_unmapped_area_topdown
Message-Id: <20120307140101.b0624e80.akpm@linux-foundation.org>
In-Reply-To: <4F101935.1040108@linux.vnet.ibm.com>
References: <4F101904.8090405@linux.vnet.ibm.com>
	<4F101935.1040108@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jan 2012 19:44:53 +0800
Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> Afte call find_vma_prev(mm, addr, &prev_vma), following condition is always
> true:
> 	!prev_vma || (addr >= prev_vma->vm_end)
> it can be happily drop prev_vma and use find_vma instead of find_vma_prev

I had to rework this patch due to 097d59106a8e4b ("vm: avoid using
find_vma_prev() unnecessarily") in mainline.  Can you please check my
handiwork?



From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: hugetlb: drop prev_vma in hugetlb_get_unmapped_area_topdown()

After the call find_vma_prev(mm, addr, &prev_vma), the following condition
is always true:

	!prev_vma || (addr >= prev_vma->vm_end)

it can happily drop prev_vma and use find_vma() instead of find_vma_prev().

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/hugetlbpage.c |   23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff -puN arch/x86/mm/hugetlbpage.c~hugetlb-drop-prev_vma-in-hugetlb_get_unmapped_area_topdown arch/x86/mm/hugetlbpage.c
--- a/arch/x86/mm/hugetlbpage.c~hugetlb-drop-prev_vma-in-hugetlb_get_unmapped_area_topdown
+++ a/arch/x86/mm/hugetlbpage.c
@@ -308,7 +308,7 @@ static unsigned long hugetlb_get_unmappe
 {
 	struct hstate *h = hstate_file(file);
 	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma, *prev_vma;
+	struct vm_area_struct *vma;
 	unsigned long base = mm->mmap_base, addr = addr0;
 	unsigned long largest_hole = mm->cached_hole_size;
 	int first_time = 1;
@@ -334,25 +334,16 @@ try_again:
 		 * i.e. return with success:
 		 */
 		vma = find_vma(mm, addr);
-		if (!vma)
-			return addr;
-
-		/*
-		 * new region fits between prev_vma->vm_end and
-		 * vma->vm_start, use it:
-		 */
-		prev_vma = vma->vm_prev;
-		if (addr + len <= vma->vm_start &&
-		            (!prev_vma || (addr >= prev_vma->vm_end))) {
+		if (vma)
+			prev_vma = vma->vm_prev;
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
_

