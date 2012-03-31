Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759631Ab2CaMFS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 08:05:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56322 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758863Ab2CaMFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 08:05:16 -0400
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org, Kautuk Consul <consul.kautuk@gmail.com>
Subject: [PATCH 13/19 v2] xtensa/mm/fault.c: Port OOM changes to do_page_fault
Date: Sat, 31 Mar 2012 08:05:01 -0400
Message-Id: <1333195501-5353-1-git-send-email-consul.kautuk@gmail.com>
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

Port these changes to xtensa.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
---
 arch/xtensa/mm/fault.c |   29 ++++++++++++++++++++++++-----
 1 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/arch/xtensa/mm/fault.c b/arch/xtensa/mm/fault.c
index b17885a..5a74c53 100644
--- a/arch/xtensa/mm/fault.c
+++ b/arch/xtensa/mm/fault.c
@@ -44,6 +44,7 @@ void do_page_fault(struct pt_regs *regs)
 
 	int is_write, is_exec;
 	int fault;
+	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
 
 	info.si_code = SEGV_MAPERR;
 
@@ -71,6 +72,7 @@ void do_page_fault(struct pt_regs *regs)
 	       address, exccause, regs->pc, is_write? "w":"", is_exec? "x":"");
 #endif
 
+retry:
 	down_read(&mm->mmap_sem);
 	vma = find_vma(mm, address);
 
@@ -93,6 +95,7 @@ good_area:
 	if (is_write) {
 		if (!(vma->vm_flags & VM_WRITE))
 			goto bad_area;
+		flags |= FAULT_FLAG_WRITE;
 	} else if (is_exec) {
 		if (!(vma->vm_flags & VM_EXEC))
 			goto bad_area;
@@ -104,7 +107,11 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(mm, vma, address, is_write ? FAULT_FLAG_WRITE : 0);
+	fault = handle_mm_fault(mm, vma, address, flags);
+
+	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
+		return;
+
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		if (fault & VM_FAULT_OOM)
 			goto out_of_memory;
@@ -112,10 +119,22 @@ good_area:
 			goto do_sigbus;
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

