Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059Ab1HaW0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 18:26:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:24286 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756882Ab1HaW0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 18:26:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="43927820"
From: "Luck, Tony" <tony.luck@intel.com>
To: linux-kernel@vger.kernel.org
Cc: "Ingo Molnar" <mingo@elte.hu>, "Borislav Petkov" <bp@amd64.org>,
        "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>
In-Reply-To: <4e5eb3f12101199595@agluck-desktop.sc.intel.com>
Subject: [PATCH 4/5] mce: remove TIF_MCE_NOTIFY
Date: Wed, 31 Aug 2011 15:26:10 -0700
Message-Id: <4e5eb502210599ba11@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:	"Luck, Tony" <tony.luck@intel.com>

From: Tony Luck <tony.luck@intel.com>

Hidetoshi Seto has re-worked the notification code to use a
worker thread for propagating notifications. So TIF_MCE_NOTIFY
is unused. Previous plans to use this to somehow switch from
"machine check context" to a more friendly environment to
deal with immediate errors look like they will never pan out.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/thread_info.h |    4 +---
 arch/x86/kernel/cpu/mcheck/mce.c   |   18 ------------------
 arch/x86/kernel/signal.c           |    6 ------
 3 files changed, 1 insertions(+), 27 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index a1fe5c1..9cfde9f 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -82,7 +82,6 @@ struct thread_info {
 #define TIF_SYSCALL_EMU		6	/* syscall emulation active */
 #define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
 #define TIF_SECCOMP		8	/* secure computing */
-#define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
 #define TIF_USER_RETURN_NOTIFY	11	/* notify kernel of userspace return */
 #define TIF_NOTSC		16	/* TSC is not accessible in userland */
 #define TIF_IA32		17	/* 32bit process */
@@ -105,7 +104,6 @@ struct thread_info {
 #define _TIF_SYSCALL_EMU	(1 << TIF_SYSCALL_EMU)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
-#define _TIF_MCE_NOTIFY		(1 << TIF_MCE_NOTIFY)
 #define _TIF_USER_RETURN_NOTIFY	(1 << TIF_USER_RETURN_NOTIFY)
 #define _TIF_NOTSC		(1 << TIF_NOTSC)
 #define _TIF_IA32		(1 << TIF_IA32)
@@ -140,7 +138,7 @@ struct thread_info {
 
 /* Only used for 64 bit */
 #define _TIF_DO_NOTIFY_MASK						\
-	(_TIF_SIGPENDING | _TIF_MCE_NOTIFY | _TIF_NOTIFY_RESUME |	\
+	(_TIF_SIGPENDING | _TIF_NOTIFY_RESUME |				\
 	 _TIF_USER_RETURN_NOTIFY)
 
 /* flags to check in __switch_to() */
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 1ce64c3..135e12d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1052,10 +1052,6 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	if (kill_it && tolerant < 3)
 		force_sig(SIGBUS, current);
 
-	/* Trap this thread before returning to user, for action required */
-	if (worst == MCE_AR_SEVERITY)
-		set_thread_flag(TIF_MCE_NOTIFY);
-
 	if (worst > 0)
 		mce_report_event(regs);
 	mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);
@@ -1071,20 +1067,6 @@ void __attribute__((weak)) memory_failure(unsigned long pfn, int vector)
 	pr_err("Action optional memory failure at %lx ignored\n", pfn);
 }
 
-/*
- * Called in process context that interrupted by MCE and marked with
- * TIF_MCE_NOTFY, just before returning to errorneous userland.
- * This code is allowed to sleep.
- * Attempt possible recovery such as calling the high level VM handler to
- * process any corrupted pages, and kill/signal current process if required.
- */
-void mce_notify_process(void)
-{
-	clear_thread_flag(TIF_MCE_NOTIFY);
-
-	/* TBD: do recovery for action required event */
-}
-
 static void mce_process_work(struct work_struct *dummy)
 {
 	unsigned long pfn;
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 54ddaeb2..306fd6d 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -814,12 +814,6 @@ static void do_signal(struct pt_regs *regs)
 void
 do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 {
-#ifdef CONFIG_X86_MCE
-	/* notify userspace of pending MCEs */
-	if (thread_info_flags & _TIF_MCE_NOTIFY)
-		mce_notify_process();
-#endif /* CONFIG_X86_64 && CONFIG_X86_MCE */
-
 	/* deal with pending signal delivery */
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs);
-- 
1.7.3.1

