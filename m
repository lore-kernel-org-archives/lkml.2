Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab1ABHbp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:31:45 -0500
Received: from mail.windriver.com ([147.11.1.11]:37143 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754903Ab1ABHZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:44 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Stefan Bader <stefan.bader@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 218/260] mm: Move vma_stack_continue into mm.h
Date: Sun,  2 Jan 2011 02:18:34 -0500
Message-Id: <1293952756-15010-219-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:24:07.0932 (UTC) FILETIME=[0B063BC0:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Bader <stefan.bader@canonical.com>

commit 39aa3cb3e8250db9188a6f1e3fb62ffa1a717678 upstream.

So it can be used by all that need to check for that.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/proc/task_mmu.c |    3 ++-
 include/linux/mm.h |    6 ++++++
 mm/mlock.c         |    6 ------
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 3544f60..971fd7a 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -224,7 +224,8 @@ static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
 	/* We don't show the stack guard page in /proc/maps */
 	start = vma->vm_start;
 	if (vma->vm_flags & VM_GROWSDOWN)
-		start += PAGE_SIZE;
+		if (!vma_stack_continue(vma->vm_prev, vma->vm_start))
+			start += PAGE_SIZE;
 
 	seq_printf(m, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",
 			start,
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 04fb7f6..433d7e2 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -859,6 +859,12 @@ int set_page_dirty(struct page *page);
 int set_page_dirty_lock(struct page *page);
 int clear_page_dirty_for_io(struct page *page);
 
+/* Is the vma a continuation of the stack vma above it? */
+static inline int vma_stack_continue(struct vm_area_struct *vma, unsigned long addr)
+{
+	return vma && (vma->vm_end == addr) && (vma->vm_flags & VM_GROWSDOWN);
+}
+
 extern unsigned long move_page_tables(struct vm_area_struct *vma,
 		unsigned long old_addr, struct vm_area_struct *new_vma,
 		unsigned long new_addr, unsigned long len);
diff --git a/mm/mlock.c b/mm/mlock.c
index 5e57ebc..6fe7001 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -135,12 +135,6 @@ void munlock_vma_page(struct page *page)
 	}
 }
 
-/* Is the vma a continuation of the stack vma above it? */
-static inline int vma_stack_continue(struct vm_area_struct *vma, unsigned long addr)
-{
-	return vma && (vma->vm_end == addr) && (vma->vm_flags & VM_GROWSDOWN);
-}
-
 static inline int stack_guard_page(struct vm_area_struct *vma, unsigned long addr)
 {
 	return (vma->vm_flags & VM_GROWSDOWN) &&
-- 
1.7.3.3

