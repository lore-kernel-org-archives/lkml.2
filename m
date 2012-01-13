Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423Ab2AMAgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 19:36:55 -0500
Received: from mga03.intel.com ([143.182.124.21]:53986 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756349Ab2AMAgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 19:36:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="55988005"
From: Huang Ying <ying.huang@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@amd64.org>, Chen Gong <gong.chen@linux.intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>, ying.huang@intel.com
Subject: [RFC 2/2] x86, mce, Use user return notifier in mce
Date: Fri, 13 Jan 2012 08:36:41 +0800
Message-Id: <1326415001-2145-3-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1326415001-2145-1-git-send-email-ying.huang@intel.com>
References: <1326415001-2145-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the home-made TIF_MCE_NOTIFY based code in MCE with user
return notifier.

This saves one TIF_xx flag too.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <bp@amd64.org>
Cc: Chen Gong <gong.chen@linux.intel.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/include/asm/thread_info.h |    5 +----
 arch/x86/kernel/cpu/mcheck/mce.c   |   13 ++++++++++---
 arch/x86/kernel/signal.c           |    6 ------
 3 files changed, 11 insertions(+), 13 deletions(-)

--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -83,7 +83,6 @@ struct thread_info {
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
@@ -139,8 +137,7 @@ struct thread_info {
 
 /* Only used for 64 bit */
 #define _TIF_DO_NOTIFY_MASK						\
-	(_TIF_SIGPENDING | _TIF_MCE_NOTIFY | _TIF_NOTIFY_RESUME |	\
-	 _TIF_USER_RETURN_NOTIFY)
+	(_TIF_SIGPENDING | _TIF_NOTIFY_RESUME | _TIF_USER_RETURN_NOTIFY)
 
 /* flags to check in __switch_to() */
 #define _TIF_WORK_CTXSW							\
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -38,6 +38,7 @@
 #include <linux/debugfs.h>
 #include <linux/irq_work.h>
 #include <linux/export.h>
+#include <linux/user-return-notifier.h>
 
 #include <asm/processor.h>
 #include <asm/mce.h>
@@ -102,6 +103,8 @@ DEFINE_PER_CPU(mce_banks_t, mce_poll_ban
 
 static DEFINE_PER_CPU(struct work_struct, mce_work);
 
+static DEFINE_PER_CPU(struct user_return_notifier, mce_urn);
+
 /*
  * CPU/chipset specific EDAC code can register a notifier call here to print
  * MCE errors in a human-readable form.
@@ -1083,7 +1086,7 @@ void do_machine_check(struct pt_regs *re
 		force_sig(SIGBUS, current);
 
 	/* notify userspace ASAP */
-	set_thread_flag(TIF_MCE_NOTIFY);
+	user_return_notifier_register(&__get_cpu_var(mce_urn));
 
 	if (worst > 0)
 		mce_report_event(regs);
@@ -1119,6 +1122,11 @@ void mce_notify_process(void)
 		memory_failure(pfn, MCE_VECTOR);
 }
 
+static void mce_on_user_return(struct user_return_notifier *urn)
+{
+	mce_notify_process();
+}
+
 static void mce_process_work(struct work_struct *dummy)
 {
 	mce_notify_process();
@@ -1211,8 +1219,6 @@ int mce_notify_irq(void)
 	/* Not more than two messages every minute */
 	static DEFINE_RATELIMIT_STATE(ratelimit, 60*HZ, 2);
 
-	clear_thread_flag(TIF_MCE_NOTIFY);
-
 	if (test_and_clear_bit(0, &mce_need_notify)) {
 		/* wake processes polling /dev/mcelog */
 		wake_up_interruptible(&mce_chrdev_wait);
@@ -1476,6 +1482,7 @@ void __cpuinit mcheck_cpu_init(struct cp
 	__mcheck_cpu_init_timer();
 	INIT_WORK(&__get_cpu_var(mce_work), mce_process_work);
 	init_irq_work(&__get_cpu_var(mce_irq_work), &mce_irq_work_cb);
+	init_user_return_notifier(&__get_cpu_var(mce_urn), mce_on_user_return);
 }
 
 /*
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -814,12 +814,6 @@ static void do_signal(struct pt_regs *re
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
