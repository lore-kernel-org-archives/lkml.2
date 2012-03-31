Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237Ab2CaMAw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 08:00:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36240 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757391Ab2CaMAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 08:00:50 -0400
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>
Cc: linux-kernel@vger.kernel.org, Kautuk Consul <consul.kautuk@gmail.com>,
        "Mohd. Faris" <mohdfarisq2010@gmail.com>
Subject: [PATCH 03/19 v2] score/mm/fault.c: Port OOM changes to do_page_fault
Date: Sat, 31 Mar 2012 08:00:05 -0400
Message-Id: <1333195205-5012-1-git-send-email-consul.kautuk@gmail.com>
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

Port these changes to score.

Signed-off-by: Mohd. Faris <mohdfarisq2010@gmail.com>
Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
---
 arch/score/mm/fault.c |   30 +++++++++++++++++++++++++-----
 1 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/arch/score/mm/fault.c b/arch/score/mm/fault.c
index 47b600e..f263ba7 100644
--- a/arch/score/mm/fault.c
+++ b/arch/score/mm/fault.c
@@ -49,6 +49,8 @@ asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long write,
 	const int field = sizeof(unsigned long) * 2;
 	siginfo_t info;
 	int fault;
+	unsigned int flags = (FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE |
+			      (write ? FAULT_FLAG_WRITE : 0));
 
 	info.si_code = SEGV_MAPERR;
 
@@ -75,6 +77,7 @@ asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long write,
 	if (in_atomic() || !mm)
 		goto bad_area_nosemaphore;
 
+retry:
 	down_read(&mm->mmap_sem);
 	vma = find_vma(mm, address);
 	if (!vma)
@@ -106,7 +109,11 @@ survive:
 	* make sure we exit gracefully rather than endlessly redo
 	* the fault.
 	*/
-	fault = handle_mm_fault(mm, vma, address, write);
+	fault = handle_mm_fault(mm, vma, address, flags);
+
+	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
+		return;
+
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		if (fault & VM_FAULT_OOM)
 			goto out_of_memory;
@@ -114,10 +121,23 @@ survive:
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

