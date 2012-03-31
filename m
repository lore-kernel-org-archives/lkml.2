Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759805Ab2CaMHQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 08:07:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46047 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759446Ab2CaMHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 08:07:14 -0400
From: Kautuk Consul <consul.kautuk@gmail.com>
To: davem@davemloft.net, Paul Gortmaker <paul.gortmaker@windriver.com>,
        Ingo Molnar <mingo@elte.hu>, Joe Perches <joe@perches.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kautuk Consul <consul.kautuk@gmail.com>
Subject: [PATCH 18/19 v2] sparc/mm/fault_32.c: Port OOM changes to do_sparc_fault
Date: Sat, 31 Mar 2012 08:06:48 -0400
Message-Id: <1333195608-5524-1-git-send-email-consul.kautuk@gmail.com>
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

Port these changes to 32-bit sparc.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
Reviewed-By: Joe Perches <joe@perches.com>
Acked-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/mm/fault_32.c |   37 ++++++++++++++++++++++++++++++-------
 1 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/arch/sparc/mm/fault_32.c b/arch/sparc/mm/fault_32.c
index 7705c67..df3155a 100644
--- a/arch/sparc/mm/fault_32.c
+++ b/arch/sparc/mm/fault_32.c
@@ -225,6 +225,8 @@ asmlinkage void do_sparc_fault(struct pt_regs *regs, int text_fault, int write,
 	unsigned long g2;
 	int from_user = !(regs->psr & PSR_PS);
 	int fault, code;
+	unsigned int flags = (FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE |
+			      (write ? FAULT_FLAG_WRITE : 0));
 
 	if(text_fault)
 		address = regs->pc;
@@ -251,6 +253,7 @@ asmlinkage void do_sparc_fault(struct pt_regs *regs, int text_fault, int write,
 
 	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
 
+retry:
 	down_read(&mm->mmap_sem);
 
 	/*
@@ -289,7 +292,11 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(mm, vma, address, write ? FAULT_FLAG_WRITE : 0);
+	fault = handle_mm_fault(mm, vma, address, flags);
+
+	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
+		return;
+
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		if (fault & VM_FAULT_OOM)
 			goto out_of_memory;
@@ -297,13 +304,29 @@ good_area:
 			goto do_sigbus;
 		BUG();
 	}
-	if (fault & VM_FAULT_MAJOR) {
-		current->maj_flt++;
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, regs, address);
-	} else {
-		current->min_flt++;
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, regs, address);
+
+	if (flags & FAULT_FLAG_ALLOW_RETRY) {
+		if (fault & VM_FAULT_MAJOR) {
+			current->maj_flt++;
+			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ,
+				      1, regs, address);
+		} else {
+			current->min_flt++;
+			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN,
+				      1, regs, address);
+		}
+		if (fault & VM_FAULT_RETRY) {
+			flags &= ~FAULT_FLAG_ALLOW_RETRY;
+
+			/* No need to up_read(&mm->mmap_sem) as we would
+			 * have already released it in __lock_page_or_retry
+			 * in mm/filemap.c.
+			 */
+
+			goto retry;
+		}
 	}
+
 	up_read(&mm->mmap_sem);
 	return;
 
-- 
1.7.5.4

