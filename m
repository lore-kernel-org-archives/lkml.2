Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565Ab2BICEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 21:04:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44936 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756953Ab2BICCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 21:02:01 -0500
X-Authority-Analysis: v=2.0 cv=MaXuSuDf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=au89j_qggzEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=Vk4YdUWZStxAicFyZ70A:9 a=7BJf-PLp0tEGnFdQj38A:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Zh68SRI7RUMA:10 a=041IZyjGyWdR1Ypf:21 a=GiNtxJvZbjlA0y-_:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120209020159.542950429@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 08 Feb 2012 20:59:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, stable-rt@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH RT 3/8] signal/x86: Delay calling signals in atomic
References: <20120209015926.851312665@goodmis.org>
Content-Disposition: inline; filename=0003-signal-x86-Delay-calling-signals-in-atomic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

On x86_64 we must disable preemption before we enable interrupts
for stack faults, int3 and debugging, because the current task is using
a per CPU debug stack defined by the IST. If we schedule out, another task
can come in and use the same stack and cause the stack to be corrupted
and crash the kernel on return.

When CONFIG_PREEMPT_RT_FULL is enabled, spin_locks become mutexes, and
one of these is the spin lock used in signal handling.

Some of the debug code (int3) causes do_trap() to send a signal.
This function calls a spin lock that has been converted to a mutex
and has the possibility to sleep. If this happens, the above issues with
the corrupted stack is possible.

Instead of calling the signal right away, for PREEMPT_RT and x86_64,
the signal information is stored on the stacks task_struct and
TIF_NOTIFY_RESUME is set. Then on exit of the trap, the signal resume
code will send the signal when preemption is enabled.

[ rostedt: Switched from #ifdef CONFIG_PREEMPT_RT_FULL to
  ARCH_RT_DELAYS_SIGNAL_SEND and added comments to the code. ]

Cc: stable-rt@vger.kernel.org
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/signal.h |   13 +++++++++++++
 arch/x86/kernel/signal.c      |    9 +++++++++
 include/linux/sched.h         |    4 ++++
 kernel/signal.c               |   37 +++++++++++++++++++++++++++++++++++--
 4 files changed, 61 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/signal.h b/arch/x86/include/asm/signal.h
index 598457c..1213ebd 100644
--- a/arch/x86/include/asm/signal.h
+++ b/arch/x86/include/asm/signal.h
@@ -31,6 +31,19 @@ typedef struct {
 	unsigned long sig[_NSIG_WORDS];
 } sigset_t;
 
+/*
+ * Because some traps use the IST stack, we must keep
+ * preemption disabled while calling do_trap(), but do_trap()
+ * may call force_sig_info() which will grab the signal spin_locks
+ * for the task, which in PREEMPT_RT_FULL are mutexes.
+ * By defining ARCH_RT_DELAYS_SIGNAL_SEND the force_sig_info() will
+ * set TIF_NOTIFY_RESUME and set up the signal to be sent on exit
+ * of the trap.
+ */
+#if defined(CONFIG_PREEMPT_RT_FULL) && defined(CONFIG_X86_64)
+#define ARCH_RT_DELAYS_SIGNAL_SEND
+#endif
+
 #else
 /* Here we must cater to libcs that poke about in kernel headers.  */
 
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 40a2493..7d88255 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -840,6 +840,15 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 		mce_notify_process();
 #endif /* CONFIG_X86_64 && CONFIG_X86_MCE */
 
+#ifdef ARCH_RT_DELAYS_SIGNAL_SEND
+	if (unlikely(current->forced_info.si_signo)) {
+		struct task_struct *t = current;
+		force_sig_info(t->forced_info.si_signo,
+					&t->forced_info, t);
+		t->forced_info.si_signo = 0;
+	}
+#endif
+
 	/* deal with pending signal delivery */
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4cd3278..77e132f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1405,6 +1405,10 @@ struct task_struct {
 	sigset_t blocked, real_blocked;
 	sigset_t saved_sigmask;	/* restored if set_restore_sigmask() was used */
 	struct sigpending pending;
+#ifdef CONFIG_PREEMPT_RT_FULL
+	/* TODO: move me into ->restart_block ? */
+	struct siginfo forced_info;
+#endif
 
 	unsigned long sas_ss_sp;
 	size_t sas_ss_size;
diff --git a/kernel/signal.c b/kernel/signal.c
index 3f15914..6650b2c 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1200,8 +1200,8 @@ int do_send_sig_info(int sig, struct siginfo *info, struct task_struct *p,
  * We don't want to have recursive SIGSEGV's etc, for example,
  * that is why we also clear SIGNAL_UNKILLABLE.
  */
-int
-force_sig_info(int sig, struct siginfo *info, struct task_struct *t)
+static int
+do_force_sig_info(int sig, struct siginfo *info, struct task_struct *t)
 {
 	unsigned long int flags;
 	int ret, blocked, ignored;
@@ -1226,6 +1226,39 @@ force_sig_info(int sig, struct siginfo *info, struct task_struct *t)
 	return ret;
 }
 
+int force_sig_info(int sig, struct siginfo *info, struct task_struct *t)
+{
+/*
+ * On some archs, PREEMPT_RT has to delay sending a signal from a trap
+ * since it can not enable preemption, and the signal code's spin_locks
+ * turn into mutexes. Instead, it must set TIF_NOTIFY_RESUME which will
+ * send the signal on exit of the trap.
+ */
+#ifdef ARCH_RT_DELAYS_SIGNAL_SEND
+	if (in_atomic()) {
+		if (WARN_ON_ONCE(t != current))
+			return 0;
+		if (WARN_ON_ONCE(t->forced_info.si_signo))
+			return 0;
+
+		if (is_si_special(info)) {
+			WARN_ON_ONCE(info != SEND_SIG_PRIV);
+			t->forced_info.si_signo = sig;
+			t->forced_info.si_errno = 0;
+			t->forced_info.si_code = SI_KERNEL;
+			t->forced_info.si_pid = 0;
+			t->forced_info.si_uid = 0;
+		} else {
+			t->forced_info = *info;
+		}
+
+		set_tsk_thread_flag(t, TIF_NOTIFY_RESUME);
+		return 0;
+	}
+#endif
+	return do_force_sig_info(sig, info, t);
+}
+
 /*
  * Nuke all other threads in the group.
  */
-- 
1.7.8.3


