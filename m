Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab2AMLqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 06:46:34 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:34494 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068Ab2AMLqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 06:46:33 -0500
Message-ID: <4F101904.8090405@linux.vnet.ibm.com>
Date: Fri, 13 Jan 2012 19:44:04 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: William Irwin <wli@holomorphy.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] hugetlbfs: fix hugetlb_get_unmapped_area
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12011301-9264-0000-0000-0000009D251C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using/updating cached_hole_size and free_area_cache properly to speedup
find free region

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 fs/hugetlbfs/inode.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index e425ad9..9e0794a 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -154,10 +154,12 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 			return addr;
 	}

-	start_addr = mm->free_area_cache;
-
-	if (len <= mm->cached_hole_size)
+	if (len > mm->cached_hole_size)
+		start_addr = mm->free_area_cache;
+	else {
 		start_addr = TASK_UNMAPPED_BASE;
+		mm->cached_hole_size = 0;
+	}

 full_search:
 	addr = ALIGN(start_addr, huge_page_size(h));
@@ -171,13 +173,18 @@ full_search:
 			 */
 			if (start_addr != TASK_UNMAPPED_BASE) {
 				start_addr = TASK_UNMAPPED_BASE;
+				mm->cached_hole_size = 0;
 				goto full_search;
 			}
 			return -ENOMEM;
 		}

-		if (!vma || addr + len <= vma->vm_start)
+		if (!vma || addr + len <= vma->vm_start) {
+			mm->free_area_cache = addr + len;
 			return addr;
+		}
+		if (addr + mm->cached_hole_size < vma->vm_start)
+			mm->cached_hole_size = vma->vm_start - addr;
 		addr = ALIGN(vma->vm_end, huge_page_size(h));
 	}
 }
-- 
1.7.7.5

