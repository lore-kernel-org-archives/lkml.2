Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab2LUAui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 19:50:38 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:50807 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab2LUAuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 19:50:17 -0500
From: Michel Lespinasse <walken@google.com>
To: Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Jorn_Engel <joern@logfs.org>, Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/9] mm: use mm_populate() for blocking remap_file_pages()
Date: Thu, 20 Dec 2012 16:49:52 -0800
Message-Id: <1356050997-2688-5-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1356050997-2688-1-git-send-email-walken@google.com>
References: <1356050997-2688-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 mm/fremap.c |   22 ++++++----------------
 1 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/mm/fremap.c b/mm/fremap.c
index 2db886e31044..b42e32171530 100644
--- a/mm/fremap.c
+++ b/mm/fremap.c
@@ -129,6 +129,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
 	struct vm_area_struct *vma;
 	int err = -EINVAL;
 	int has_write_lock = 0;
+	vm_flags_t vm_flags;
 
 	if (prot)
 		return err;
@@ -228,30 +229,16 @@ get_write_lock:
 		/*
 		 * drop PG_Mlocked flag for over-mapped range
 		 */
-		vm_flags_t saved_flags = vma->vm_flags;
 		if (!has_write_lock)
 			goto get_write_lock;
+		vm_flags = vma->vm_flags;
 		munlock_vma_pages_range(vma, start, start + size);
-		vma->vm_flags = saved_flags;
+		vma->vm_flags = vm_flags;
 	}
 
 	mmu_notifier_invalidate_range_start(mm, start, start + size);
 	err = vma->vm_ops->remap_pages(vma, start, size, pgoff);
 	mmu_notifier_invalidate_range_end(mm, start, start + size);
-	if (!err) {
-		if (vma->vm_flags & VM_LOCKED) {
-			/*
-			 * might be mapping previously unmapped range of file
-			 */
-			mlock_vma_pages_range(vma, start, start + size);
-		} else if (!(flags & MAP_NONBLOCK)) {
-			if (unlikely(has_write_lock)) {
-				downgrade_write(&mm->mmap_sem);
-				has_write_lock = 0;
-			}
-			make_pages_present(start, start+size);
-		}
-	}
 
 	/*
 	 * We can't clear VM_NONLINEAR because we'd have to do
@@ -260,10 +247,13 @@ get_write_lock:
 	 */
 
 out:
+	vm_flags = vma->vm_flags;
 	if (likely(!has_write_lock))
 		up_read(&mm->mmap_sem);
 	else
 		up_write(&mm->mmap_sem);
+	if (!err && ((vm_flags & VM_LOCKED) || !(flags & MAP_NONBLOCK)))
+		mm_populate(start, size);
 
 	return err;
 }
-- 
1.7.7.3
