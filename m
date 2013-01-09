Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab3AIB3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 20:29:47 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:41415 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301Ab3AIB2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 20:28:34 -0500
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Matt Turner <mattst88@gmail.com>, David Howells <dhowells@redhat.com>,
        Tony Luck <tony.luck@intel.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev@lists.ozlabs.org, linux-parisc@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-ia64@vger.kernel.org
Subject: [PATCH 4/8] mm: use vm_unmapped_area() on ia64 architecture
Date: Tue,  8 Jan 2013 17:28:11 -0800
Message-Id: <1357694895-520-5-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1357694895-520-1-git-send-email-walken@google.com>
References: <1357694895-520-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the ia64 arch_get_unmapped_area function to make use of
vm_unmapped_area() instead of implementing a brute force search.

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 arch/ia64/kernel/sys_ia64.c |   37 ++++++++++++-------------------------
 1 files changed, 12 insertions(+), 25 deletions(-)

diff --git a/arch/ia64/kernel/sys_ia64.c b/arch/ia64/kernel/sys_ia64.c
index d9439ef2f661..41e33f84c185 100644
--- a/arch/ia64/kernel/sys_ia64.c
+++ b/arch/ia64/kernel/sys_ia64.c
@@ -25,9 +25,9 @@ arch_get_unmapped_area (struct file *filp, unsigned long addr, unsigned long len
 			unsigned long pgoff, unsigned long flags)
 {
 	long map_shared = (flags & MAP_SHARED);
-	unsigned long start_addr, align_mask = PAGE_SIZE - 1;
+	unsigned long align_mask = 0;
 	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma;
+	struct vm_unmapped_area_info info;
 
 	if (len > RGN_MAP_LIMIT)
 		return -ENOMEM;
@@ -44,7 +44,7 @@ arch_get_unmapped_area (struct file *filp, unsigned long addr, unsigned long len
 		addr = 0;
 #endif
 	if (!addr)
-		addr = mm->free_area_cache;
+		addr = TASK_UNMAPPED_BASE;
 
 	if (map_shared && (TASK_SIZE > 0xfffffffful))
 		/*
@@ -53,28 +53,15 @@ arch_get_unmapped_area (struct file *filp, unsigned long addr, unsigned long len
 		 * tasks, we prefer to avoid exhausting the address space too quickly by
 		 * limiting alignment to a single page.
 		 */
-		align_mask = SHMLBA - 1;
-
-  full_search:
-	start_addr = addr = (addr + align_mask) & ~align_mask;
-
-	for (vma = find_vma(mm, addr); ; vma = vma->vm_next) {
-		/* At this point:  (!vma || addr < vma->vm_end). */
-		if (TASK_SIZE - len < addr || RGN_MAP_LIMIT - len < REGION_OFFSET(addr)) {
-			if (start_addr != TASK_UNMAPPED_BASE) {
-				/* Start a new search --- just in case we missed some holes.  */
-				addr = TASK_UNMAPPED_BASE;
-				goto full_search;
-			}
-			return -ENOMEM;
-		}
-		if (!vma || addr + len <= vma->vm_start) {
-			/* Remember the address where we stopped this search:  */
-			mm->free_area_cache = addr + len;
-			return addr;
-		}
-		addr = (vma->vm_end + align_mask) & ~align_mask;
-	}
+		align_mask = PAGE_MASK & (SHMLBA - 1);
+
+	info.flags = 0;
+	info.length = len;
+	info.low_limit = addr;
+	info.high_limit = TASK_SIZE;
+	info.align_mask = align_mask;
+	info.align_offset = 0;
+	return vm_unmapped_area(&info);
 }
 
 asmlinkage long
-- 
1.7.7.3
