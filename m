Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761401Ab2EJSjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 14:39:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:20978 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761009Ab2EJSjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 14:39:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="164574284"
Message-Id: <e6fa674d2f4ded80201f733d06b234b21559f0fe.1336674796.git.tony.luck@intel.com>
In-Reply-To: <cover.1336674796.git.tony.luck@intel.com>
References: <cover.1336674796.git.tony.luck@intel.com>
From: Tony Luck <tony.luck@intel.com>
Date: Thu, 10 May 2012 11:01:20 -0700
Subject: [PATCH 1/2] x86/mce: Only restart instruction after machine check
 recovery if it is safe
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        Chen Gong <gong.chen@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
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
it made a complete recovery ... e.g. replaced a clean LRU page).

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 66e1c51..3b8ebdc 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -947,9 +947,10 @@ struct mce_info {
 	atomic_t		inuse;
 	struct task_struct	*t;
 	__u64			paddr;
+	int			restartable;
 } mce_info[MCE_INFO_MAX];
 
-static void mce_save_info(__u64 addr)
+static void mce_save_info(__u64 addr, int c)
 {
 	struct mce_info *mi;
 
@@ -957,6 +958,7 @@ static void mce_save_info(__u64 addr)
 		if (atomic_cmpxchg(&mi->inuse, 0, 1) == 0) {
 			mi->t = current;
 			mi->paddr = addr;
+			mi->restartable = c;
 			return;
 		}
 	}
@@ -1136,7 +1138,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 			mce_panic("Fatal machine check on current CPU", &m, msg);
 		if (worst == MCE_AR_SEVERITY) {
 			/* schedule action before return to userland */
-			mce_save_info(m.addr);
+			mce_save_info(m.addr, m.mcgstatus & MCG_STATUS_RIPV);
 			set_thread_flag(TIF_MCE_NOTIFY);
 		} else if (kill_it) {
 			force_sig(SIGBUS, current);
@@ -1185,7 +1187,8 @@ void mce_notify_process(void)
 
 	pr_err("Uncorrected hardware memory error in user-access at %llx",
 		 mi->paddr);
-	if (memory_failure(pfn, MCE_VECTOR, MF_ACTION_REQUIRED) < 0) {
+	if (memory_failure(pfn, MCE_VECTOR, MF_ACTION_REQUIRED) < 0 ||
+			   mi->restartable == 0) {
 		pr_err("Memory error not recovered");
 		force_sig(SIGBUS, current);
 	}
-- 
1.7.9.rc2.1.g69204

