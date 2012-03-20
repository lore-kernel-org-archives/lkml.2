Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373Ab2CTNZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 09:25:24 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44620 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758590Ab2CTNZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 09:25:20 -0400
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: linux-kernel@vger.kernel.org, Kautuk Consul <consul.kautuk@gmail.com>
Subject: [PATCH 15/20] unicore32/mm/fault.c: Port OOM changes to do_pf
Date: Tue, 20 Mar 2012 09:25:06 -0400
Message-Id: <1332249906-3106-1-git-send-email-consul.kautuk@gmail.com>
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

Port these changes to unicore32.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
---
 arch/unicore32/mm/fault.c |   37 +++++++++++++++++++++++++++----------
 1 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/arch/unicore32/mm/fault.c b/arch/unicore32/mm/fault.c
index 283aa4b..db40765 100644
--- a/arch/unicore32/mm/fault.c
+++ b/arch/unicore32/mm/fault.c
@@ -169,7 +169,7 @@ static inline bool access_error(unsigned int fsr, struct vm_area_struct *vma)
 }
 
 static int __do_pf(struct mm_struct *mm, unsigned long addr, unsigned int fsr,
-		struct task_struct *tsk)
+		unsigned int flags, struct task_struct *tsk)
 {
 	struct vm_area_struct *vma;
 	int fault;
@@ -195,14 +195,7 @@ good_area:
 	 * If for any reason at all we couldn't handle the fault, make
 	 * sure we exit gracefully rather than endlessly redo the fault.
 	 */
-	fault = handle_mm_fault(mm, vma, addr & PAGE_MASK,
-			    (!(fsr ^ 0x12)) ? FAULT_FLAG_WRITE : 0);
-	if (unlikely(fault & VM_FAULT_ERROR))
-		return fault;
-	if (fault & VM_FAULT_MAJOR)
-		tsk->maj_flt++;
-	else
-		tsk->min_flt++;
+	fault = handle_mm_fault(mm, vma, addr & PAGE_MASK, flags);
 	return fault;
 
 check_stack:
@@ -217,6 +210,8 @@ static int do_pf(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 	struct task_struct *tsk;
 	struct mm_struct *mm;
 	int fault, sig, code;
+	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE |
+				 ((!(fsr ^ 0x12)) ? FAULT_FLAG_WRITE : 0);
 
 	tsk = current;
 	mm = tsk->mm;
@@ -237,6 +232,7 @@ static int do_pf(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 		if (!user_mode(regs)
 		    && !search_exception_tables(regs->UCreg_pc))
 			goto no_context;
+retry:
 		down_read(&mm->mmap_sem);
 	} else {
 		/*
@@ -252,7 +248,28 @@ static int do_pf(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 #endif
 	}
 
-	fault = __do_pf(mm, addr, fsr, tsk);
+	fault = __do_pf(mm, addr, fsr, flags, tsk);
+
+	/* If we need to retry but a fatal signal is pending, handle the
+	 * signal first. We do not need to release the mmap_sem because
+	 * it would already be released in __lock_page_or_retry in
+	 * mm/filemap.c. */
+	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
+		return 0;
+
+	if (!(fault & VM_FAULT_ERROR) && (flags & FAULT_FLAG_ALLOW_RETRY)) {
+		if (fault & VM_FAULT_MAJOR)
+			tsk->maj_flt++;
+		else
+			tsk->min_flt++;
+		if (fault & VM_FAULT_RETRY) {
+			/* Clear FAULT_FLAG_ALLOW_RETRY to avoid any risk
+			* of starvation. */
+			flags &= ~FAULT_FLAG_ALLOW_RETRY;
+			goto retry;
+		}
+	}
+
 	up_read(&mm->mmap_sem);
 
 	/*
-- 
1.7.5.4

