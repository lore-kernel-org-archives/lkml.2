Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab2CTNVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 09:21:55 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62058 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756625Ab2CTNVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 09:21:53 -0400
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Michal Simek <monstr@monstr.eu>
Cc: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
        Kautuk Consul <consul.kautuk@gmail.com>
Subject: [PATCH 07/20] microblaze/mm/fault.c: Port OOM changes to do_page_fault
Date: Tue, 20 Mar 2012 09:21:40 -0400
Message-Id: <1332249700-2781-1-git-send-email-consul.kautuk@gmail.com>
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

Port these changes to microblaze.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
---
 arch/microblaze/mm/fault.c |   33 ++++++++++++++++++++++++++++-----
 1 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/arch/microblaze/mm/fault.c b/arch/microblaze/mm/fault.c
index ae97d2c..60e19e6 100644
--- a/arch/microblaze/mm/fault.c
+++ b/arch/microblaze/mm/fault.c
@@ -93,6 +93,8 @@ void do_page_fault(struct pt_regs *regs, unsigned long address,
 	int code = SEGV_MAPERR;
 	int is_write = error_code & ESR_S;
 	int fault;
+	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE |
+					 (is_write ? FAULT_FLAG_WRITE : 0);
 
 	regs->ear = address;
 	regs->esr = error_code;
@@ -139,6 +141,7 @@ void do_page_fault(struct pt_regs *regs, unsigned long address,
 		if (kernel_mode(regs) && !search_exception_tables(regs->pc))
 			goto bad_area_nosemaphore;
 
+retry:
 		down_read(&mm->mmap_sem);
 	}
 
@@ -211,7 +214,11 @@ good_area:
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
@@ -219,11 +226,27 @@ good_area:
 			goto do_sigbus;
 		BUG();
 	}
-	if (unlikely(fault & VM_FAULT_MAJOR))
-		current->maj_flt++;
-	else
-		current->min_flt++;
+
+	if (flags & FAULT_FLAG_ALLOW_RETRY) {
+		if (unlikely(fault & VM_FAULT_MAJOR))
+			current->maj_flt++;
+		else
+			current->min_flt++;
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
+	}
+
 	up_read(&mm->mmap_sem);
+
 	/*
 	 * keep track of tlb+htab misses that are good addrs but
 	 * just need pte's created via handle_mm_fault()
-- 
1.7.5.4

