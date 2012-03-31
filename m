Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759678Ab2CaMGL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 08:06:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46047 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759547Ab2CaMGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 08:06:09 -0400
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Chris Metcalf <cmetcalf@tilera.com>, <paul.mckenney@linaro.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, Kautuk Consul <consul.kautuk@gmail.com>
Subject: [PATCH 15/19 v2] tile/mm/fault.c: Port OOM changes to handle_page_fault
Date: Sat, 31 Mar 2012 08:05:39 -0400
Message-Id: <1333195539-5421-1-git-send-email-consul.kautuk@gmail.com>
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

Port these changes to tile.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
---
 arch/tile/mm/fault.c |   30 +++++++++++++++++++++++++-----
 1 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/arch/tile/mm/fault.c b/arch/tile/mm/fault.c
index cba30e9..bba4cd9 100644
--- a/arch/tile/mm/fault.c
+++ b/arch/tile/mm/fault.c
@@ -266,6 +266,8 @@ static int handle_page_fault(struct pt_regs *regs,
 	int si_code;
 	int is_kernel_mode;
 	pgd_t *pgd;
+	unsigned int flags = (FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE |
+			      (write ? FAULT_FLAG_WRITE : 0));
 
 	/* on TILE, protection faults are always writes */
 	if (!is_page_fault)
@@ -372,6 +374,8 @@ static int handle_page_fault(struct pt_regs *regs,
 			vma = NULL;  /* happy compiler */
 			goto bad_area_nosemaphore;
 		}
+
+retry:
 		down_read(&mm->mmap_sem);
 	}
 
@@ -419,7 +423,11 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(mm, vma, address, write);
+	fault = handle_mm_fault(mm, vma, address, flags);
+
+	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
+		return 0;
+
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		if (fault & VM_FAULT_OOM)
 			goto out_of_memory;
@@ -427,10 +435,22 @@ good_area:
 			goto do_sigbus;
 		BUG();
 	}
-	if (fault & VM_FAULT_MAJOR)
-		tsk->maj_flt++;
-	else
-		tsk->min_flt++;
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
 
 #if CHIP_HAS_TILE_DMA() || CHIP_HAS_SN_PROC()
 	/*
-- 
1.7.5.4

