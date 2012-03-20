Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759608Ab2CTN0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 09:26:54 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42875 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758639Ab2CTN0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 09:26:52 -0400
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kautuk Consul <consul.kautuk@gmail.com>
Subject: [PATCH 17/20] sh/mm/fault_32.c: Port OOM changes to do_page_fault
Date: Tue, 20 Mar 2012 09:26:37 -0400
Message-Id: <1332249997-3212-1-git-send-email-consul.kautuk@gmail.com>
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

Port these changes to the 32-bit SH platform.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
---
 arch/sh/mm/fault_32.c |   39 ++++++++++++++++++++++++++++++---------
 1 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/arch/sh/mm/fault_32.c b/arch/sh/mm/fault_32.c
index 7bebd04..7b279a7 100644
--- a/arch/sh/mm/fault_32.c
+++ b/arch/sh/mm/fault_32.c
@@ -129,6 +129,8 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 	int si_code;
 	int fault;
 	siginfo_t info;
+	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE |
+				 (writeaccess ? FAULT_FLAG_WRITE : 0);
 
 	tsk = current;
 	mm = tsk->mm;
@@ -169,6 +171,7 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 	if (in_atomic() || !mm)
 		goto no_context;
 
+retry:
 	down_read(&mm->mmap_sem);
 
 	vma = find_vma(mm, address);
@@ -200,7 +203,11 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(mm, vma, address, writeaccess ? FAULT_FLAG_WRITE : 0);
+	fault = handle_mm_fault(mm, vma, address, flags);
+
+	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
+		return;
+
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		if (fault & VM_FAULT_OOM)
 			goto out_of_memory;
@@ -208,14 +215,28 @@ good_area:
 			goto do_sigbus;
 		BUG();
 	}
-	if (fault & VM_FAULT_MAJOR) {
-		tsk->maj_flt++;
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1,
-				     regs, address);
-	} else {
-		tsk->min_flt++;
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1,
-				     regs, address);
+
+	if (flags & FAULT_FLAG_ALLOW_RETRY) {
+		if (fault & VM_FAULT_MAJOR) {
+			tsk->maj_flt++;
+			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1,
+					     regs, address);
+		} else {
+			tsk->min_flt++;
+			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1,
+					     regs, address);
+		}
+		if (fault & VM_FAULT_RETRY) {
+			flags &= ~FAULT_FLAG_ALLOW_RETRY;
+
+			/*
+			 * No need to up_read(&mm->mmap_sem) as we would
+			 * have already released it in __lock_page_or_retry
+			 * in mm/filemap.c.
+			 */
+
+			goto retry;
+		}
 	}
 
 	up_read(&mm->mmap_sem);
-- 
1.7.5.4

