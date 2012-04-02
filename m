Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab2DBPdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 11:33:06 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33848 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab2DBPdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 11:33:04 -0400
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: linux-kernel@vger.kernel.org, Kautuk Consul <consul.kautuk@gmail.com>,
        "Mohd. Faris" <mohdfarisq2010@gmail.com>
Subject: [PATCH 01/19 v2.1] avr32/mm/fault.c: Port OOM changes to do_page_fault
Date: Mon,  2 Apr 2012 21:02:49 +0530
Message-Id: <1333380769-2650-1-git-send-email-consul.kautuk@gmail.com>
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

Port these changes to AVR32.

Signed-off-by: Mohd. Faris <mohdfarisq2010@gmail.com>
Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
---
 arch/avr32/mm/fault.c |   33 +++++++++++++++++++++++++--------
 1 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/arch/avr32/mm/fault.c b/arch/avr32/mm/fault.c
index f7040a1..29a0fa0 100644
--- a/arch/avr32/mm/fault.c
+++ b/arch/avr32/mm/fault.c
@@ -61,10 +61,10 @@ asmlinkage void do_page_fault(unsigned long ecr, struct pt_regs *regs)
 	const struct exception_table_entry *fixup;
 	unsigned long address;
 	unsigned long page;
-	int writeaccess;
 	long signr;
 	int code;
 	int fault;
+	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
 
 	if (notify_page_fault(regs, ecr))
 		return;
@@ -86,6 +86,7 @@ asmlinkage void do_page_fault(unsigned long ecr, struct pt_regs *regs)
 
 	local_irq_enable();
 
+retry:
 	down_read(&mm->mmap_sem);
 
 	vma = find_vma(mm, address);
@@ -104,7 +105,6 @@ asmlinkage void do_page_fault(unsigned long ecr, struct pt_regs *regs)
 	 */
 good_area:
 	code = SEGV_ACCERR;
-	writeaccess = 0;
 
 	switch (ecr) {
 	case ECR_PROTECTION_X:
@@ -121,7 +121,7 @@ good_area:
 	case ECR_TLB_MISS_W:
 		if (!(vma->vm_flags & VM_WRITE))
 			goto bad_area;
-		writeaccess = 1;
+		flags |= FAULT_FLAG_WRITE;
 		break;
 	default:
 		panic("Unhandled case %lu in do_page_fault!", ecr);
@@ -132,7 +132,11 @@ good_area:
 	 * sure we exit gracefully rather than endlessly redo the
 	 * fault.
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
@@ -140,10 +144,23 @@ good_area:
 			goto do_sigbus;
 		BUG();
 	}
-	if (fault & VM_FAULT_MAJOR)
-		tsk->maj_flt++;
-	else
-		tsk->min_flt++;
+
+	if (flags & FAULT_FLAG_ALLOW_RETRY) {
+		if (fault & VM_FAULT_MAJOR)
+			tsk->maj_flt++;
+		else
+			tsk->min_flt++;
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

