Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858Ab2KNJTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 04:19:41 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55877 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab2KNJTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 04:19:14 -0500
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Paul Turner <pjt@google.com>, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hughd@google.com>
Subject: [PATCH 2/3] sched, numa, mm: Count WS scanning against present PTEs, not virtual memory ranges
Date: Wed, 14 Nov 2012 10:18:50 +0100
Message-Id: <1352884731-20024-3-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352884731-20024-1-git-send-email-mingo@kernel.org>
References: <1352884731-20024-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

By accounting against the present PTEs, scanning speed reflects the
actual present (mapped) memory.

Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2a843e7..adcad19 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -914,8 +914,8 @@ void task_numa_work(struct callback_head *work)
 	struct task_struct *p = current;
 	struct mm_struct *mm = p->mm;
 	struct vm_area_struct *vma;
-	unsigned long offset, end;
-	long length;
+	unsigned long start, end;
+	long pages;
 
 	WARN_ON_ONCE(p != container_of(work, struct task_struct, numa_work));
 
@@ -942,30 +942,35 @@ void task_numa_work(struct callback_head *work)
 	if (cmpxchg(&mm->numa_next_scan, migrate, next_scan) != migrate)
 		return;
 
-	offset = mm->numa_scan_offset;
-	length = sysctl_sched_numa_scan_size;
-	length <<= 20;
+	start = mm->numa_scan_offset;
+	pages = sysctl_sched_numa_scan_size;
+	pages <<= 20 - PAGE_SHIFT; /* MB in pages */
+	if (!pages)
+		return;
 
 	down_write(&mm->mmap_sem);
-	vma = find_vma(mm, offset);
+	vma = find_vma(mm, start);
 	if (!vma) {
 		ACCESS_ONCE(mm->numa_scan_seq)++;
-		offset = 0;
+		start = 0;
 		vma = mm->mmap;
 	}
-	for (; vma && length > 0; vma = vma->vm_next) {
+	for (; vma; vma = vma->vm_next) {
 		if (!vma_migratable(vma))
 			continue;
 
-		offset = max(offset, vma->vm_start);
-		end = min(ALIGN(offset + length, HPAGE_SIZE), vma->vm_end);
-		length -= end - offset;
-
-		change_prot_none(vma, offset, end);
-
-		offset = end;
+		do {
+			start = max(start, vma->vm_start);
+			end = ALIGN(start + (pages << PAGE_SHIFT), HPAGE_SIZE);
+			end = min(end, vma->vm_end);
+			pages -= change_prot_none(vma, start, end);
+			start = end;
+			if (pages <= 0)
+				goto out;
+		} while (end != vma->vm_end);
 	}
-	mm->numa_scan_offset = offset;
+out:
+	mm->numa_scan_offset = start;
 	up_write(&mm->mmap_sem);
 }
 
-- 
1.7.11.7

