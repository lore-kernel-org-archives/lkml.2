Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759109Ab2CaL70 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 07:59:26 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:38729 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757277Ab2CaL7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 07:59:24 -0400
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: linux-kernel@vger.kernel.org, Kautuk Consul <consul.kautuk@gmail.com>,
        "Mohd. Faris" <mohdfarisq2010@gmail.com>
Subject: [PATCH 01/19 v2] avr32/mm/fault.c: Port OOM changes to do_page_fault
Date: Sat, 31 Mar 2012 07:58:53 -0400
Message-Id: <1333195133-4944-1-git-send-email-consul.kautuk@gmail.com>
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
 arch/avr32/mm/fault.c |   30 +++++++++++++++++++++++++-----
 1 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/arch/avr32/mm/fault.c b/arch/avr32/mm/fault.c
index f7040a1..0362d03 100644
--- a/arch/avr32/mm/fault.c
+++ b/arch/avr32/mm/fault.c
@@ -65,6 +65,7 @@ asmlinkage void do_page_fault(unsigned long ecr, struct pt_regs *regs)
 	long signr;
 	int code;
 	int fault;
+	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
 
 	if (notify_page_fault(regs, ecr))
 		return;
@@ -86,6 +87,7 @@ asmlinkage void do_page_fault(unsigned long ecr, struct pt_regs *regs)
 
 	local_irq_enable();
 
+retry:
 	down_read(&mm->mmap_sem);
 
 	vma = find_vma(mm, address);
@@ -122,6 +124,7 @@ good_area:
 		if (!(vma->vm_flags & VM_WRITE))
 			goto bad_area;
 		writeaccess = 1;
+		flags |= FAULT_FLAG_WRITE;
 		break;
 	default:
 		panic("Unhandled case %lu in do_page_fault!", ecr);
@@ -132,7 +135,11 @@ good_area:
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
@@ -140,10 +147,23 @@ good_area:
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

