Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab1EZIMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 04:12:31 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58246 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756421Ab1EZIM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 04:12:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDE0B5C.9050907@jp.fujitsu.com>
Date: Thu, 26 May 2011 17:12:12 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: mingo@elte.hu, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hpa@zytor.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com,
        tglx@linutronix.de, willy@linux.intel.com
CC: kosaki.motohiro@jp.fujitsu.com
Subject: [PATCH] x86: add unlikely() to fatal signal check
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo suggested SIGKILL check should be moved into slowpath function.
It may reduce page fault fastpath impact. This patch do that.

Suggested-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 arch/x86/mm/fault.c |   35 ++++++++++++++++++++---------------
 1 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index f7a2a05..2dbf6bf 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -823,16 +823,30 @@ do_sigbus(struct pt_regs *regs, unsigned long error_code, unsigned long address,
 	force_sig_info_fault(SIGBUS, code, address, tsk, fault);
 }

-static noinline void
+static noinline int
 mm_fault_error(struct pt_regs *regs, unsigned long error_code,
 	       unsigned long address, unsigned int fault)
 {
+	/*
+	 * Pagefault was interrupted by SIGKILL. We have no reason to
+	 * continue pagefault.
+	 */
+	if (fatal_signal_pending(current)) {
+		if (!(fault & VM_FAULT_RETRY))
+			up_read(&current->mm->mmap_sem);
+		if (!(error_code & PF_USER))
+			no_context(regs, error_code, address);
+		return 1;
+	}
+	if (!(fault & VM_FAULT_ERROR))
+		return 0;
+
 	if (fault & VM_FAULT_OOM) {
 		/* Kernel mode? Handle exceptions or die: */
 		if (!(error_code & PF_USER)) {
 			up_read(&current->mm->mmap_sem);
 			no_context(regs, error_code, address);
-			return;
+			return 1;
 		}

 		out_of_memory(regs, error_code, address);
@@ -843,6 +857,7 @@ mm_fault_error(struct pt_regs *regs, unsigned long error_code,
 		else
 			BUG();
 	}
+	return 1;
 }

 static int spurious_fault_check(unsigned long error_code, pte_t *pte)
@@ -1133,19 +1148,9 @@ good_area:
 	 */
 	fault = handle_mm_fault(mm, vma, address, flags);

-	if (unlikely(fault & VM_FAULT_ERROR)) {
-		mm_fault_error(regs, error_code, address, fault);
-		return;
-	}
-
-	/*
-	 * Pagefault was interrupted by SIGKILL. We have no reason to
-	 * continue pagefault.
-	 */
-	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current)) {
-		if (!(error_code & PF_USER))
-			no_context(regs, error_code, address);
-		return;
+	if (unlikely(fault & (VM_FAULT_RETRY|VM_FAULT_ERROR))) {
+		if (mm_fault_error(regs, error_code, address, fault))
+			return;
 	}

 	/*
-- 
1.7.3.1


