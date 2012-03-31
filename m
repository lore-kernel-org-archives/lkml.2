Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759520Ab2CaMDd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 08:03:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37796 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757424Ab2CaMDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 08:03:30 -0400
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Hirokazu Takata <takata@linux-m32r.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: linux-m32r@ml.linux-m32r.org, linux-m32r-ja@ml.linux-m32r.org,
        linux-kernel@vger.kernel.org, Kautuk Consul <consul.kautuk@gmail.com>
Subject: [PATCH 08/19 v2] m32r/mm/fault.c: Port OOM changes to do_page_fault
Date: Sat, 31 Mar 2012 08:03:05 -0400
Message-Id: <1333195385-5183-1-git-send-email-consul.kautuk@gmail.com>
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

Port these changes to m32r.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
---
 arch/m32r/mm/fault.c |   32 +++++++++++++++++++++++++++-----
 1 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/arch/m32r/mm/fault.c b/arch/m32r/mm/fault.c
index 3cdfa9c..d0e08e2 100644
--- a/arch/m32r/mm/fault.c
+++ b/arch/m32r/mm/fault.c
@@ -81,6 +81,7 @@ asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long error_code,
 	int write;
 	int fault;
 	siginfo_t info;
+	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
 
 	/*
 	 * If BPSW IE bit enable --> set PSW IE bit
@@ -136,6 +137,8 @@ asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long error_code,
 		if ((error_code & ACE_USERMODE) == 0 &&
 		    !search_exception_tables(regs->psw))
 			goto bad_area_nosemaphore;
+
+retry:
 		down_read(&mm->mmap_sem);
 	}
 
@@ -174,6 +177,7 @@ good_area:
 			if (!(vma->vm_flags & VM_WRITE))
 				goto bad_area;
 			write++;
+			flags |= FAULT_FLAG_WRITE;
 			break;
 		case ACE_PROTECTION:	/* read, present */
 		case 0:		/* read, not present */
@@ -194,7 +198,11 @@ good_area:
 	 */
 	addr = (address & PAGE_MASK);
 	set_thread_fault_code(error_code);
-	fault = handle_mm_fault(mm, vma, addr, write ? FAULT_FLAG_WRITE : 0);
+	fault = handle_mm_fault(mm, vma, addr, flags);
+
+	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
+		return;
+
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		if (fault & VM_FAULT_OOM)
 			goto out_of_memory;
@@ -202,10 +210,24 @@ good_area:
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
+
 	set_thread_fault_code(0);
 	up_read(&mm->mmap_sem);
 	return;
-- 
1.7.5.4

