Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab2ENWYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 18:24:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:46252 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932541Ab2ENWYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 18:24:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="166238484"
Message-Id: <dad1743e5993f19b3d7e7bd0fb35dc45b5326626.1337033510.git.tony.luck@intel.com>
From: Tony Luck <tony.luck@intel.com>
Date: Mon, 14 May 2012 15:07:48 -0700
Subject: [PATCH] x86/mce: Only restart instruction after machine check recovery if it is safe
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Section 15.3.1.2 of the software developer manual has this to say about the
RIPV bit in the IA32_MCG_STATUS register:

  RIPV (restart IP valid) flag, bit 0 — Indicates (when set) that program
  execution can be restarted reliably at the instruction pointed to by the
  instruction pointer pushed on the stack when the machine-check exception
  is generated.  When clear, the program cannot be reliably restarted at
  the pushed instruction pointer.

We need to save the state of this bit in do_machine_check() and use it
in mce_notify_process() to force a signal; even if memory_failure() says
it made a complete recovery ... e.g. replaced a clean LRU page.

Acked-by: Borislav Petkov <bp@amd64.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---

[Linus: I found this when I started testing instruction recovery (where
 it is common to have a clean LRU page) ... and was surprised to see my
 code try to resume execution. Clean LRU data pages are less common (absent
 in my tests - oops) but they do happen, and we shouldn't try to restart
 the instruction if the processor says we shouldn't]

 arch/x86/kernel/cpu/mcheck/mce.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index d086a09..11c9166 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -945,9 +945,10 @@ struct mce_info {
 	atomic_t		inuse;
 	struct task_struct	*t;
 	__u64			paddr;
+	int			restartable;
 } mce_info[MCE_INFO_MAX];
 
-static void mce_save_info(__u64 addr)
+static void mce_save_info(__u64 addr, int c)
 {
 	struct mce_info *mi;
 
@@ -955,6 +956,7 @@ static void mce_save_info(__u64 addr)
 		if (atomic_cmpxchg(&mi->inuse, 0, 1) == 0) {
 			mi->t = current;
 			mi->paddr = addr;
+			mi->restartable = c;
 			return;
 		}
 	}
@@ -1130,7 +1132,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 			mce_panic("Fatal machine check on current CPU", &m, msg);
 		if (worst == MCE_AR_SEVERITY) {
 			/* schedule action before return to userland */
-			mce_save_info(m.addr);
+			mce_save_info(m.addr, m.mcgstatus & MCG_STATUS_RIPV);
 			set_thread_flag(TIF_MCE_NOTIFY);
 		} else if (kill_it) {
 			force_sig(SIGBUS, current);
@@ -1179,7 +1181,13 @@ void mce_notify_process(void)
 
 	pr_err("Uncorrected hardware memory error in user-access at %llx",
 		 mi->paddr);
-	if (memory_failure(pfn, MCE_VECTOR, MF_ACTION_REQUIRED) < 0) {
+	/*
+	 * We must call memory_failure() here even if the current process is
+	 * doomed. We still need to mark the page as poisoned and alert any
+	 * other users of the page.
+	 */
+	if (memory_failure(pfn, MCE_VECTOR, MF_ACTION_REQUIRED) < 0 ||
+			   mi->restartable == 0) {
 		pr_err("Memory error not recovered");
 		force_sig(SIGBUS, current);
 	}
-- 
1.7.9.rc2.1.g69204

