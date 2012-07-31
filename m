Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab2GaKnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 06:43:45 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46258 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755693Ab2GaKmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 06:42:21 -0400
Subject: [PATCH v3 05/10] mm: kill vma flag VM_INSERTPAGE
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Carsten Otte <cotte@de.ibm.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nick Piggin <npiggin@kernel.dk>
Date: Tue, 31 Jul 2012 14:42:17 +0400
Message-ID: <20120731104217.20515.69943.stgit@zurg>
In-Reply-To: <20120731103724.20515.60334.stgit@zurg>
References: <20120731103724.20515.60334.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch merges VM_INSERTPAGE into VM_MIXEDMAP.
VM_MIXEDMAP VMA can mix pure-pfn ptes, special ptes and normal ptes.

Now copy_page_range() always copies VM_MIXEDMAP VMA on fork like VM_PFNMAP.
If driver populates whole VMA at mmap() it probably not expects page-faults.

This patch removes special check from vma_wants_writenotify() which disables
pages write tracking for VMA populated via vm_instert_page(). BDI below mapped
file should not use dirty-accounting, moreover do_wp_page() can handle this.

vm_insert_page() still marks vma after first usage. Usually it is called from
f_op->mmap() handler under mm->mmap_sem write-lock, so it able to change
vma->vm_flags. Caller must set VM_MIXEDMAP at mmap time if it wants to call
this function from other places, for example from page-fault handler.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Carsten Otte <cotte@de.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 include/linux/mm.h |    1 -
 mm/huge_memory.c   |    3 +--
 mm/ksm.c           |    2 +-
 mm/memory.c        |   14 ++++++++++++--
 mm/mmap.c          |    2 +-
 5 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 22c945b..cdff0ed 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -103,7 +103,6 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_HUGETLB	0x00400000	/* Huge TLB Page VM */
 #define VM_NONLINEAR	0x00800000	/* Is non-linear (remap_file_pages) */
 #define VM_ARCH_1	0x01000000	/* Architecture-specific flag */
-#define VM_INSERTPAGE	0x02000000	/* The vma has had "vm_insert_page()" done on it */
 #define VM_NODUMP	0x04000000	/* Do not include in the core dump */
 
 #define VM_CAN_NONLINEAR 0x08000000	/* Has ->fault & does nonlinear pages */
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 67721f8..8b3c55a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1491,8 +1491,7 @@ out:
 	return ret;
 }
 
-#define VM_NO_THP (VM_SPECIAL|VM_INSERTPAGE|VM_MIXEDMAP| \
-		   VM_HUGETLB|VM_SHARED|VM_MAYSHARE)
+#define VM_NO_THP (VM_SPECIAL|VM_MIXEDMAP|VM_HUGETLB|VM_SHARED|VM_MAYSHARE)
 
 int hugepage_madvise(struct vm_area_struct *vma,
 		     unsigned long *vm_flags, int advice)
diff --git a/mm/ksm.c b/mm/ksm.c
index d1cbe2a..f9ccb16 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1469,7 +1469,7 @@ int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 		 */
 		if (*vm_flags & (VM_MERGEABLE | VM_SHARED  | VM_MAYSHARE   |
 				 VM_PFNMAP    | VM_IO      | VM_DONTEXPAND |
-				 VM_RESERVED  | VM_HUGETLB | VM_INSERTPAGE |
+				 VM_RESERVED  | VM_HUGETLB |
 				 VM_NONLINEAR | VM_MIXEDMAP))
 			return 0;		/* just ignore the advice */
 
diff --git a/mm/memory.c b/mm/memory.c
index aca6f22..2fb27a0 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1047,7 +1047,8 @@ int copy_page_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	 * readonly mappings. The tradeoff is that copy_page_range is more
 	 * efficient than faulting.
 	 */
-	if (!(vma->vm_flags & (VM_HUGETLB|VM_NONLINEAR|VM_PFNMAP|VM_INSERTPAGE))) {
+	if (!(vma->vm_flags & (VM_HUGETLB | VM_NONLINEAR |
+			       VM_PFNMAP | VM_MIXEDMAP))) {
 		if (!vma->anon_vma)
 			return 0;
 	}
@@ -2082,6 +2083,11 @@ out:
  * ask for a shared writable mapping!
  *
  * The page does not need to be reserved.
+ *
+ * Usually this function is called from f_op->mmap() handler
+ * under mm->mmap_sem write-lock, so it can change vma->vm_flags.
+ * Caller must set VM_MIXEDMAP on vma if it wants to call this
+ * function from other places, for example from page-fault handler.
  */
 int vm_insert_page(struct vm_area_struct *vma, unsigned long addr,
 			struct page *page)
@@ -2090,7 +2096,11 @@ int vm_insert_page(struct vm_area_struct *vma, unsigned long addr,
 		return -EFAULT;
 	if (!page_count(page))
 		return -EINVAL;
-	vma->vm_flags |= VM_INSERTPAGE;
+	if (!(vma->vm_flags & VM_MIXEDMAP)) {
+		BUG_ON(down_read_trylock(&vma->vm_mm->mmap_sem));
+		BUG_ON(vma->vm_flags & VM_PFNMAP);
+		vma->vm_flags |= VM_MIXEDMAP;
+	}
 	return insert_page(vma, addr, page, vma->vm_page_prot);
 }
 EXPORT_SYMBOL(vm_insert_page);
diff --git a/mm/mmap.c b/mm/mmap.c
index 3edfcdf..47a74c4 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1188,7 +1188,7 @@ int vma_wants_writenotify(struct vm_area_struct *vma)
 		return 0;
 
 	/* Specialty mapping? */
-	if (vm_flags & (VM_PFNMAP|VM_INSERTPAGE))
+	if (vm_flags & VM_PFNMAP)
 		return 0;
 
 	/* Can the mapping track the dirty pages? */

