Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974Ab2AMLuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 06:50:17 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:56949 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab2AMLuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 06:50:07 -0500
Message-ID: <4F1019D3.8020709@linux.vnet.ibm.com>
Date: Fri, 13 Jan 2012 19:47:31 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        William Irwin <wli@holomorphy.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] mm: search from free_area_cache for the bigger size
References: <4F101904.8090405@linux.vnet.ibm.com>
In-Reply-To: <4F101904.8090405@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12011301-6102-0000-0000-000000A22831
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the required size is bigger than cached_hole_size, we would better search
from free_area_cache, it is more easier to get free region, specifically for
the 64 bit process whose address space is large enough

Do it just as hugetlb_get_unmapped_area_topdown() in arch/x86/mm/hugetlbpage.c

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kernel/sys_x86_64.c |   34 +++++++++++++++++-----------------
 mm/mmap.c                    |   36 +++++++++++++++++++++---------------
 2 files changed, 38 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index 0514890..ef59642 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -195,7 +195,7 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 {
 	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
-	unsigned long addr = addr0;
+	unsigned long addr = addr0, start_addr;

 	/* requested length too big for entire address space */
 	if (len > TASK_SIZE)
@@ -223,25 +223,14 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 		mm->free_area_cache = mm->mmap_base;
 	}

+try_again:
 	/* either no address requested or can't fit in requested address hole */
-	addr = mm->free_area_cache;
-
-	/* make sure it can fit in the remaining address space */
-	if (addr > len) {
-		unsigned long tmp_addr = align_addr(addr - len, filp,
-						    ALIGN_TOPDOWN);
-
-		vma = find_vma(mm, tmp_addr);
-		if (!vma || tmp_addr + len <= vma->vm_start)
-			/* remember the address as a hint for next time */
-			return mm->free_area_cache = tmp_addr;
-	}
-
-	if (mm->mmap_base < len)
-		goto bottomup;
+	start_addr = addr = mm->free_area_cache;

-	addr = mm->mmap_base-len;
+	if (addr < len)
+		goto fail;

+	addr -= len;
 	do {
 		addr = align_addr(addr, filp, ALIGN_TOPDOWN);

@@ -263,6 +252,17 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 		addr = vma->vm_start-len;
 	} while (len < vma->vm_start);

+fail:
+	/*
+	 * if hint left us with no space for the requested
+	 * mapping then try again:
+	 */
+	if (start_addr != mm->mmap_base) {
+		mm->free_area_cache = mm->mmap_base;
+		mm->cached_hole_size = 0;
+		goto try_again;
+	}
+
 bottomup:
 	/*
 	 * A failed mmap() very likely causes application failure,
diff --git a/mm/mmap.c b/mm/mmap.c
index 970f572..e3c4b97 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1439,7 +1439,7 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 {
 	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
-	unsigned long addr = addr0;
+	unsigned long addr = addr0, start_addr;

 	/* requested length too big for entire address space */
 	if (len > TASK_SIZE)
@@ -1463,22 +1463,14 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
  		mm->free_area_cache = mm->mmap_base;
  	}

+try_again:
 	/* either no address requested or can't fit in requested address hole */
-	addr = mm->free_area_cache;
+	start_addr = addr = mm->free_area_cache;

-	/* make sure it can fit in the remaining address space */
-	if (addr > len) {
-		vma = find_vma(mm, addr-len);
-		if (!vma || addr <= vma->vm_start)
-			/* remember the address as a hint for next time */
-			return (mm->free_area_cache = addr-len);
-	}
-
-	if (mm->mmap_base < len)
-		goto bottomup;
-
-	addr = mm->mmap_base-len;
+	if (addr < len)
+		goto fail;

+	addr -= len;
 	do {
 		/*
 		 * Lookup failure means no vma is above this address,
@@ -1498,7 +1490,21 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 		addr = vma->vm_start-len;
 	} while (len < vma->vm_start);

-bottomup:
+fail:
+	/*
+	 * if hint left us with no space for the requested
+	 * mapping then try again:
+	 *
+	 * Note: this is different with the case of bottomup
+	 * which does the fully line-search, but we use find_vma
+	 * here that causes some holes skipped.
+	 */
+	if (start_addr != mm->mmap_base) {
+		mm->free_area_cache = mm->mmap_base;
+		mm->cached_hole_size = 0;
+		goto try_again;
+	}
+
 	/*
 	 * A failed mmap() very likely causes application failure,
 	 * so fall back to the bottom-up function here. This scenario
-- 
1.7.7.5

