Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758340Ab1FJXeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 19:34:12 -0400
Received: from sous-sol.org ([216.99.217.87]:39633 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758297Ab1FJXeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 19:34:11 -0400
Date: Fri, 10 Jun 2011 16:33:55 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, chrisw@sous-sol.org
Subject: [PATCH] mm: thp: minor lock simplification in __khugepaged_exit
Message-ID: <20110610233355.GO23047@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lock is released first thing in all three branches.  Simplify this
by unconditionally releasing lock and remove else clause which was only
there to be sure lock was released.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 mm/huge_memory.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 615d974..a032ddd 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1596,14 +1596,13 @@ void __khugepaged_exit(struct mm_struct *mm)
 		list_del(&mm_slot->mm_node);
 		free = 1;
 	}
+	spin_unlock(&khugepaged_mm_lock);
 
 	if (free) {
-		spin_unlock(&khugepaged_mm_lock);
 		clear_bit(MMF_VM_HUGEPAGE, &mm->flags);
 		free_mm_slot(mm_slot);
 		mmdrop(mm);
 	} else if (mm_slot) {
-		spin_unlock(&khugepaged_mm_lock);
 		/*
 		 * This is required to serialize against
 		 * khugepaged_test_exit() (which is guaranteed to run
@@ -1614,8 +1613,7 @@ void __khugepaged_exit(struct mm_struct *mm)
 		 */
 		down_write(&mm->mmap_sem);
 		up_write(&mm->mmap_sem);
-	} else
-		spin_unlock(&khugepaged_mm_lock);
+	}
 }
 
 static void release_pte_page(struct page *page)
