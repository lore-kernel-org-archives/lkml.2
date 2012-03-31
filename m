Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759761Ab2CaMGt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 08:06:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46047 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759446Ab2CaMGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 08:06:47 -0400
From: Kautuk Consul <consul.kautuk@gmail.com>
To: <jejb@parisc-linux.org>, Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kautuk Consul <consul.kautuk@gmail.com>
Subject: [PATCH 17/19 v2] parisc/mm/fault.c: Port OOM changes to do_page_fault
Date: Sat, 31 Mar 2012 08:06:28 -0400
Message-Id: <1333195588-5490-1-git-send-email-consul.kautuk@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d065bd810b6deb67d4897a14bfe21f8eb526ba99
(mm: retry page fault when blocking on disk transfer) and
commit 37b23e0525d393d48a7d59f870b3bc061a30ccdb
(x86,mm: make pagefault killable)

The above commits introduced changes into the x86 pagefault handler
for making the page fault handler retryable as well as killable.

These changes reduce the mmap_sem hold time, which is crucial
during OOM killer invocation.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
---
 arch/parisc/mm/fault.c |   29 ++++++++++++++++++++++++-----
 1 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/arch/parisc/mm/fault.c b/arch/parisc/mm/fault.c
index 18162ce..bd66ed6 100644
--- a/arch/parisc/mm/fault.c
+++ b/arch/parisc/mm/fault.c
@@ -175,10 +175,12 @@ void do_page_fault(struct pt_regs *regs, unsigned long code,
 	struct mm_struct *mm = tsk->mm;
 	unsigned long acc_type;
 	int fault;
+	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
 
 	if (in_atomic() || !mm)
 		goto no_context;
 
+retry:
 	down_read(&mm->mmap_sem);
 	vma = find_vma_prev(mm, address, &prev_vma);
 	if (!vma || address < vma->vm_start)
@@ -201,7 +203,12 @@ good_area:
 	 * fault.
 	 */
 
-	fault = handle_mm_fault(mm, vma, address, (acc_type & VM_WRITE) ? FAULT_FLAG_WRITE : 0);
+	fault = handle_mm_fault(mm, vma, address,
+			flags | ((acc_type & VM_WRITE) ? FAULT_FLAG_WRITE : 0));
+
+	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
+		return;
+
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		/*
 		 * We hit a shared mapping outside of the file, or some
@@ -214,10 +221,22 @@ good_area:
 			goto bad_area;
 		BUG();
 	}
-	if (fault & VM_FAULT_MAJOR)
-		current->maj_flt++;
-	else
-		current->min_flt++;
+	if (flags & FAULT_FLAG_ALLOW_RETRY) {
+		if (fault & VM_FAULT_MAJOR)
+			current->maj_flt++;
+		else
+			current->min_flt++;
+		if (fault & VM_FAULT_RETRY) {
+			flags &= ~FAULT_FLAG_ALLOW_RETRY;
+
+			 /* No need to up_read(&mm->mmap_sem) as we would
+			 * have already released it in __lock_page_or_retry
+			 * in mm/filemap.c.
+			 */
+
+			goto retry;
+		}
+	}
 	up_read(&mm->mmap_sem);
 	return;
 
-- 
1.7.5.4

