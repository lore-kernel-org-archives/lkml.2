Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030191Ab2CTNVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 09:21:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63920 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab2CTNV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 09:21:28 -0400
From: Kautuk Consul <consul.kautuk@gmail.com>
To: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        Kautuk Consul <consul.kautuk@gmail.com>
Subject: [PATCH 06/20] mn10300/mm/fault.c: Port OOM changes to do_page_fault
Date: Tue, 20 Mar 2012 09:20:54 -0400
Message-Id: <1332249654-2747-1-git-send-email-consul.kautuk@gmail.com>
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
 arch/mn10300/mm/fault.c |   30 +++++++++++++++++++++++++-----
 1 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/arch/mn10300/mm/fault.c b/arch/mn10300/mm/fault.c
index 0945409..f5111a1 100644
--- a/arch/mn10300/mm/fault.c
+++ b/arch/mn10300/mm/fault.c
@@ -125,6 +125,7 @@ asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long fault_code,
 	unsigned long page;
 	siginfo_t info;
 	int write, fault;
+	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
 
 #ifdef CONFIG_GDBSTUB
 	/* handle GDB stub causing a fault */
@@ -171,6 +172,7 @@ asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long fault_code,
 	if (in_atomic() || !mm)
 		goto no_context;
 
+retry:
 	down_read(&mm->mmap_sem);
 
 	vma = find_vma(mm, address);
@@ -234,6 +236,7 @@ good_area:
 		if (!(vma->vm_flags & VM_WRITE))
 			goto bad_area;
 		write++;
+		flags |= FAULT_FLAG_WRITE;
 		break;
 
 		/* read from protected page */
@@ -252,7 +255,11 @@ good_area:
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
@@ -260,10 +267,23 @@ good_area:
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
+			/*
+			 * No need to up_read(&mm->mmap_sem) as we would
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

