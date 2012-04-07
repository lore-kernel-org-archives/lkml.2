Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab2DGTBF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 15:01:05 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38527 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab2DGTBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 15:01:03 -0400
Subject: [PATCH v2 01/10] x86,
 pat: remove the dependency on 'vm_pgoff' in track/untrack pfn vma
 routines
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>
Date: Sat, 07 Apr 2012 23:00:58 +0400
Message-ID: <20120407190058.9726.15634.stgit@zurg>
In-Reply-To: <20120407185546.9726.62260.stgit@zurg>
References: <20120407185546.9726.62260.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Siddha <suresh.b.siddha@intel.com>

'pfn' argument for track_pfn_vma_new() can be used for reserving the attribute
for the pfn range. No need to depend on 'vm_pgoff'

Similarly, untrack_pfn_vma() can depend on the 'pfn' argument if it
is non-zero or can use follow_phys() to get the starting value of the pfn
range.

Also the non zero 'size' argument can be used instead of recomputing
it from vma.

This cleanup also prepares the ground for the track/untrack pfn vma routines
to take over the ownership of setting PAT specific vm_flag in the 'vma'.

[khlebnikov@openvz.org: Clear pfn to paddr conversion]

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Venkatesh Pallipadi <venki@google.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Ingo Molnar <mingo@redhat.com>
---
 arch/x86/mm/pat.c |   33 +++++++++++++++++++--------------
 1 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index f6ff57b..86d6590 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -692,21 +692,18 @@ int track_pfn_vma_copy(struct vm_area_struct *vma)
 int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t *prot,
 			unsigned long pfn, unsigned long size)
 {
+	resource_size_t paddr = (resource_size_t)pfn << PAGE_SHIFT;
 	unsigned long flags;
-	resource_size_t paddr;
-	unsigned long vma_size = vma->vm_end - vma->vm_start;
 
-	if (is_linear_pfn_mapping(vma)) {
-		/* reserve the whole chunk starting from vm_pgoff */
-		paddr = (resource_size_t)vma->vm_pgoff << PAGE_SHIFT;
-		return reserve_pfn_range(paddr, vma_size, prot, 0);
-	}
+	/* reserve the whole chunk starting from paddr */
+	if (is_linear_pfn_mapping(vma))
+		return reserve_pfn_range(paddr, size, prot, 0);
 
 	if (!pat_enabled)
 		return 0;
 
 	/* for vm_insert_pfn and friends, we set prot based on lookup */
-	flags = lookup_memtype(pfn << PAGE_SHIFT);
+	flags = lookup_memtype(paddr);
 	*prot = __pgprot((pgprot_val(vma->vm_page_prot) & (~_PAGE_CACHE_MASK)) |
 			 flags);
 
@@ -716,20 +713,28 @@ int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t *prot,
 /*
  * untrack_pfn_vma is called while unmapping a pfnmap for a region.
  * untrack can be called for a specific region indicated by pfn and size or
- * can be for the entire vma (in which case size can be zero).
+ * can be for the entire vma (in which case pfn, size are zero).
  */
 void untrack_pfn_vma(struct vm_area_struct *vma, unsigned long pfn,
 			unsigned long size)
 {
 	resource_size_t paddr;
-	unsigned long vma_size = vma->vm_end - vma->vm_start;
+	unsigned long prot;
 
-	if (is_linear_pfn_mapping(vma)) {
-		/* free the whole chunk starting from vm_pgoff */
-		paddr = (resource_size_t)vma->vm_pgoff << PAGE_SHIFT;
-		free_pfn_range(paddr, vma_size);
+	if (!is_linear_pfn_mapping(vma))
 		return;
+
+	/* free the chunk starting from pfn or the whole chunk */
+	paddr = (resource_size_t)pfn << PAGE_SHIFT;
+	if (!paddr && !size) {
+		if (follow_phys(vma, vma->vm_start, 0, &prot, &paddr)) {
+			WARN_ON_ONCE(1);
+			return;
+		}
+
+		size = vma->vm_end - vma->vm_start;
 	}
+	free_pfn_range(paddr, size);
 }
 
 pgprot_t pgprot_writecombine(pgprot_t prot)

