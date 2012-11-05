Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964797Ab2KEWrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 17:47:49 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:51281 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab2KEWrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 17:47:45 -0500
From: Michel Lespinasse <walken@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>, Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, x86@kernel.org,
        William Irwin <wli@holomorphy.com>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@linux-mips.org, linux-sh@vger.kernel.org,
        sparclinux@vger.kernel.org
Subject: [PATCH 08/16] mm: use vm_unmapped_area() in hugetlbfs
Date: Mon,  5 Nov 2012 14:47:05 -0800
Message-Id: <1352155633-8648-9-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1352155633-8648-1-git-send-email-walken@google.com>
References: <1352155633-8648-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the hugetlb_get_unmapped_area function to make use of
vm_unmapped_area() instead of implementing a brute force search.

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 fs/hugetlbfs/inode.c |   42 ++++++++----------------------------------
 1 files changed, 8 insertions(+), 34 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index c5bc355d8243..14bc0c1fb4fb 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -151,8 +151,8 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
-	unsigned long start_addr;
 	struct hstate *h = hstate_file(file);
+	struct vm_unmapped_area_info info;
 
 	if (len & ~huge_page_mask(h))
 		return -EINVAL;
@@ -173,39 +173,13 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 			return addr;
 	}
 
-	if (len > mm->cached_hole_size)
-		start_addr = mm->free_area_cache;
-	else {
-		start_addr = TASK_UNMAPPED_BASE;
-		mm->cached_hole_size = 0;
-	}
-
-full_search:
-	addr = ALIGN(start_addr, huge_page_size(h));
-
-	for (vma = find_vma(mm, addr); ; vma = vma->vm_next) {
-		/* At this point:  (!vma || addr < vma->vm_end). */
-		if (TASK_SIZE - len < addr) {
-			/*
-			 * Start a new search - just in case we missed
-			 * some holes.
-			 */
-			if (start_addr != TASK_UNMAPPED_BASE) {
-				start_addr = TASK_UNMAPPED_BASE;
-				mm->cached_hole_size = 0;
-				goto full_search;
-			}
-			return -ENOMEM;
-		}
-
-		if (!vma || addr + len <= vma->vm_start) {
-			mm->free_area_cache = addr + len;
-			return addr;
-		}
-		if (addr + mm->cached_hole_size < vma->vm_start)
-			mm->cached_hole_size = vma->vm_start - addr;
-		addr = ALIGN(vma->vm_end, huge_page_size(h));
-	}
+	info.flags = 0;
+	info.length = len;
+	info.low_limit = TASK_UNMAPPED_BASE;
+	info.high_limit = TASK_SIZE;
+	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
+	info.align_offset = 0;
+	return vm_unmapped_area(&info);
 }
 #endif
 
-- 
1.7.7.3
