Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759606Ab2CaMEq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 08:04:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62848 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757424Ab2CaMEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 08:04:42 -0400
From: Kautuk Consul <consul.kautuk@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Kautuk Consul <consul.kautuk@gmail.com>
Subject: [PATCH 11/19 v2] frv/mm/fault.c: Port OOM changes to do_page_fault
Date: Sat, 31 Mar 2012 08:04:16 -0400
Message-Id: <1333195456-5285-1-git-send-email-consul.kautuk@gmail.com>
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

Port these changes to frv.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
---
 arch/frv/mm/fault.c |   29 ++++++++++++++++++++++++-----
 1 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/arch/frv/mm/fault.c b/arch/frv/mm/fault.c
index 331c1e2..7dc53e5 100644
--- a/arch/frv/mm/fault.c
+++ b/arch/frv/mm/fault.c
@@ -40,6 +40,7 @@ asmlinkage void do_page_fault(int datammu, unsigned long esr0, unsigned long ear
 	pte_t *pte;
 	int write;
 	int fault;
+	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
 
 #if 0
 	const char *atxc[16] = {
@@ -81,6 +82,7 @@ asmlinkage void do_page_fault(int datammu, unsigned long esr0, unsigned long ear
 	if (in_atomic() || !mm)
 		goto no_context;
 
+retry:
 	down_read(&mm->mmap_sem);
 
 	vma = find_vma(mm, ear0);
@@ -141,6 +143,7 @@ asmlinkage void do_page_fault(int datammu, unsigned long esr0, unsigned long ear
 		if (!(vma->vm_flags & VM_WRITE))
 			goto bad_area;
 		write = 1;
+		flags |= FAULT_FLAG_WRITE;
 		break;
 
 		 /* handle read from protected page */
@@ -162,7 +165,11 @@ asmlinkage void do_page_fault(int datammu, unsigned long esr0, unsigned long ear
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(mm, vma, ear0, write ? FAULT_FLAG_WRITE : 0);
+	fault = handle_mm_fault(mm, vma, ear0, flags);
+
+	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
+		return;
+
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		if (fault & VM_FAULT_OOM)
 			goto out_of_memory;
@@ -170,10 +177,22 @@ asmlinkage void do_page_fault(int datammu, unsigned long esr0, unsigned long ear
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

