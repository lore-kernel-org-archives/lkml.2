Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360Ab2CaMCA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 08:02:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60009 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757391Ab2CaMB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 08:01:58 -0400
From: Kautuk Consul <consul.kautuk@gmail.com>
To: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        Kautuk Consul <consul.kautuk@gmail.com>
Subject: [PATCH 05/19 v2] mn10300/mm/fault.c: Port OOM changes to do_page_fault
Date: Sat, 31 Mar 2012 08:01:33 -0400
Message-Id: <1333195293-5081-1-git-send-email-consul.kautuk@gmail.com>
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

Port these changes to mn10300.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
---
 arch/mn10300/mm/fault.c |   33 +++++++++++++++++++++++++--------
 1 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/arch/mn10300/mm/fault.c b/arch/mn10300/mm/fault.c
index 90f346f..d48a84f 100644
--- a/arch/mn10300/mm/fault.c
+++ b/arch/mn10300/mm/fault.c
@@ -123,7 +123,8 @@ asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long fault_code,
 	struct mm_struct *mm;
 	unsigned long page;
 	siginfo_t info;
-	int write, fault;
+	int fault;
+	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
 
 #ifdef CONFIG_GDBSTUB
 	/* handle GDB stub causing a fault */
@@ -170,6 +171,7 @@ asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long fault_code,
 	if (in_atomic() || !mm)
 		goto no_context;
 
+retry:
 	down_read(&mm->mmap_sem);
 
 	vma = find_vma(mm, address);
@@ -220,7 +222,6 @@ asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long fault_code,
  */
 good_area:
 	info.si_code = SEGV_ACCERR;
-	write = 0;
 	switch (fault_code & (MMUFCR_xFC_PGINVAL|MMUFCR_xFC_TYPE)) {
 	default:	/* 3: write, present */
 	case MMUFCR_xFC_TYPE_WRITE:
@@ -232,7 +233,7 @@ good_area:
 	case MMUFCR_xFC_PGINVAL | MMUFCR_xFC_TYPE_WRITE:
 		if (!(vma->vm_flags & VM_WRITE))
 			goto bad_area;
-		write++;
+		flags |= FAULT_FLAG_WRITE;
 		break;
 
 		/* read from protected page */
@@ -251,7 +252,11 @@ good_area:
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
@@ -259,10 +264,22 @@ good_area:
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

