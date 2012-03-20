Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759972Ab2CTNqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 09:46:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44560 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757911Ab2CTNqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 09:46:15 -0400
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Kautuk Consul <consul.kautuk@gmail.com>
Subject: [PATCH 1/1] um/kernel/trap.c: Port OOM changes to handle_page_fault
Date: Tue, 20 Mar 2012 09:45:59 -0400
Message-Id: <1332251159-3582-1-git-send-email-consul.kautuk@gmail.com>
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

Port these changes to um.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
---
 arch/um/kernel/trap.c |   24 +++++++++++++++++++-----
 1 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/arch/um/kernel/trap.c b/arch/um/kernel/trap.c
index dafc947..76adb61 100644
--- a/arch/um/kernel/trap.c
+++ b/arch/um/kernel/trap.c
@@ -30,6 +30,8 @@ int handle_page_fault(unsigned long address, unsigned long ip,
 	pmd_t *pmd;
 	pte_t *pte;
 	int err = -EFAULT;
+	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE |
+				 (is_write ? FAULT_FLAG_WRITE : 0);
 
 	*code_out = SEGV_MAPERR;
 
@@ -40,6 +42,7 @@ int handle_page_fault(unsigned long address, unsigned long ip,
 	if (in_atomic())
 		goto out_nosemaphore;
 
+retry:
 	down_read(&mm->mmap_sem);
 	vma = find_vma(mm, address);
 	if (!vma)
@@ -65,7 +68,11 @@ good_area:
 	do {
 		int fault;
 
-		fault = handle_mm_fault(mm, vma, address, is_write ? FAULT_FLAG_WRITE : 0);
+		fault = handle_mm_fault(mm, vma, address, flags);
+
+		if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
+			goto out;
+
 		if (unlikely(fault & VM_FAULT_ERROR)) {
 			if (fault & VM_FAULT_OOM) {
 				goto out_of_memory;
@@ -75,10 +82,17 @@ good_area:
 			}
 			BUG();
 		}
-		if (fault & VM_FAULT_MAJOR)
-			current->maj_flt++;
-		else
-			current->min_flt++;
+		if (flags & FAULT_FLAG_ALLOW_RETRY) {
+			if (fault & VM_FAULT_MAJOR)
+				current->maj_flt++;
+			else
+				current->min_flt++;
+			if (fault & VM_FAULT_RETRY) {
+				flags &= ~FAULT_FLAG_ALLOW_RETRY;
+
+				goto retry;
+			}
+		}
 
 		pgd = pgd_offset(mm, address);
 		pud = pud_offset(pgd, address);
-- 
1.7.5.4

