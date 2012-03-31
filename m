Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620Ab2CaMFD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 08:05:03 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:39279 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758863Ab2CaME7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 08:04:59 -0400
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org,
        Kautuk Consul <consul.kautuk@gmail.com>
Subject: [PATCH 12/19 v2] cris/mm/fault.c: Port OOM changes to do_page_fault
Date: Sat, 31 Mar 2012 08:04:43 -0400
Message-Id: <1333195483-5319-1-git-send-email-consul.kautuk@gmail.com>
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

Port these changes to CRIS.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/mm/fault.c |   30 +++++++++++++++++++++++++-----
 1 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/arch/cris/mm/fault.c b/arch/cris/mm/fault.c
index b4760d8..60df236 100644
--- a/arch/cris/mm/fault.c
+++ b/arch/cris/mm/fault.c
@@ -58,6 +58,8 @@ do_page_fault(unsigned long address, struct pt_regs *regs,
 	struct vm_area_struct * vma;
 	siginfo_t info;
 	int fault;
+	unsigned int flags = (FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE |
+			      ((writeaccess & 1) ? FAULT_FLAG_WRITE : 0));
 
 	D(printk(KERN_DEBUG
 		 "Page fault for %lX on %X at %lX, prot %d write %d\n",
@@ -115,6 +117,7 @@ do_page_fault(unsigned long address, struct pt_regs *regs,
 	if (in_atomic() || !mm)
 		goto no_context;
 
+retry:
 	down_read(&mm->mmap_sem);
 	vma = find_vma(mm, address);
 	if (!vma)
@@ -163,7 +166,11 @@ do_page_fault(unsigned long address, struct pt_regs *regs,
 	 * the fault.
 	 */
 
-	fault = handle_mm_fault(mm, vma, address, (writeaccess & 1) ? FAULT_FLAG_WRITE : 0);
+	fault = handle_mm_fault(mm, vma, address, flags);
+
+	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
+		return;
+
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		if (fault & VM_FAULT_OOM)
 			goto out_of_memory;
@@ -171,10 +178,23 @@ do_page_fault(unsigned long address, struct pt_regs *regs,
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

