Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab1EZMCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 08:02:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:41972 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757404Ab1EZMCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 08:02:07 -0400
Date: Thu, 26 May 2011 12:01:45 GMT
From: tip-bot for KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Message-ID: <tip-b80ef10e84d85a06bcd0b3a24a752ec32d0e0e40@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tglx@linutronix.de, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu
In-Reply-To: <4DDE0B5C.9050907@jp.fujitsu.com>
References: <4DDE0B5C.9050907@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Move do_page_fault()'s error path under unlikely()
Git-Commit-ID: b80ef10e84d85a06bcd0b3a24a752ec32d0e0e40
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 26 May 2011 12:01:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b80ef10e84d85a06bcd0b3a24a752ec32d0e0e40
Gitweb:     http://git.kernel.org/tip/b80ef10e84d85a06bcd0b3a24a752ec32d0e0e40
Author:     KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
AuthorDate: Thu, 26 May 2011 17:12:12 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 May 2011 13:54:03 +0200

x86: Move do_page_fault()'s error path under unlikely()

Ingo suggested SIGKILL check should be moved into slowpath
function. This will reduce the page fault fastpath impact
of this recent commit:

  37b23e0525d3: x86,mm: make pagefault killable

Suggested-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: kamezawa.hiroyu@jp.fujitsu.com
Cc: minchan.kim@gmail.com
Cc: willy@linux.intel.com
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/4DDE0B5C.9050907@jp.fujitsu.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
