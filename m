Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378Ab2CaMCs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 08:02:48 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:49908 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757391Ab2CaMCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 08:02:46 -0400
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Michal Simek <monstr@monstr.eu>
Cc: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
        Kautuk Consul <consul.kautuk@gmail.com>
Subject: [PATCH 06/19 v2] microblaze/mm/fault.c: Port OOM changes to do_page_fault
Date: Sat, 31 Mar 2012 08:02:01 -0400
Message-Id: <1333195321-5115-1-git-send-email-consul.kautuk@gmail.com>
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
Acked-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/mm/fault.c |   32 +++++++++++++++++++++++++++-----
 1 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/arch/microblaze/mm/fault.c b/arch/microblaze/mm/fault.c
index c38a265..5f8b6fa0 100644
--- a/arch/microblaze/mm/fault.c
+++ b/arch/microblaze/mm/fault.c
@@ -92,6 +92,8 @@ void do_page_fault(struct pt_regs *regs, unsigned long address,
 	int code = SEGV_MAPERR;
 	int is_write = error_code & ESR_S;
 	int fault;
+	unsigned int flags = (FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE |
+			      (is_write ? FAULT_FLAG_WRITE : 0));
 
 	regs->ear = address;
 	regs->esr = error_code;
@@ -138,6 +140,7 @@ void do_page_fault(struct pt_regs *regs, unsigned long address,
 		if (kernel_mode(regs) && !search_exception_tables(regs->pc))
 			goto bad_area_nosemaphore;
 
+retry:
 		down_read(&mm->mmap_sem);
 	}
 
@@ -210,7 +213,11 @@ good_area:
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
@@ -218,11 +225,26 @@ good_area:
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
+			 /* No need to up_read(&mm->mmap_sem) as we would
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

