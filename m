Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279Ab2BHA6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 19:58:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55922 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756775Ab2BHA6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 19:58:52 -0500
X-Authority-Analysis: v=2.0 cv=fNy7LOme c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=TABqf7s45rQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=Vk4YdUWZStxAicFyZ70A:9 a=ArY0tTYLgxDt08WVWhsA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=J9w2sFfKyExy8wbb:21 a=_3NeGX4Lbnel7BDY:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120208005850.233662427@goodmis.org>
User-Agent: quilt/0.50-1
Date: Tue, 07 Feb 2012 19:56:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Andi Kleen <ak@linux.intel.com>, Oleg Nesterov <oleg@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Luis Goncalves <lgoncalv@redhat.com>, stable-rt@vger.kernel.org
Subject: [PATCH RT 2/2 v5] signal/x86: Delay calling signals in atomic
References: <20120208005612.852040607@goodmis.org>
Content-Disposition: inline; filename=oleg-signal-rt-fix.patch
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

Cc: stable-rt@vger.kernel.org
Signed-off-by: Oleg Nesterov <oleg@redhat.com>

 [ Switched from #ifdef CONFIG_PREEMPT_RT_FULL to ARCH_RT_DELAYS_SIGNAL_SEND
   and added comments to the code. ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---

 arch/x86/kernel/signal.c |    9 +++++++++
 include/linux/sched.h    |    4 ++++
 kernel/signal.c          |   31 +++++++++++++++++++++++++++++--
 3 files changed, 42 insertions(+), 2 deletions(-)

Index: linux-rt.git/arch/x86/kernel/signal.c
===================================================================
--- linux-rt.git.orig/arch/x86/kernel/signal.c
+++ linux-rt.git/arch/x86/kernel/signal.c
@@ -820,6 +820,15 @@ do_notify_resume(struct pt_regs *regs, v
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
Index: linux-rt.git/include/linux/sched.h
===================================================================
--- linux-rt.git.orig/include/linux/sched.h
+++ linux-rt.git/include/linux/sched.h
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
Index: linux-rt.git/kernel/signal.c
===================================================================
--- linux-rt.git.orig/kernel/signal.c
+++ linux-rt.git/kernel/signal.c
@@ -1273,8 +1273,8 @@ int do_send_sig_info(int sig, struct sig
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
@@ -1299,6 +1299,39 @@ force_sig_info(int sig, struct siginfo *
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
Index: linux-rt.git/arch/x86/include/asm/signal.h
===================================================================
--- linux-rt.git.orig/arch/x86/include/asm/signal.h
+++ linux-rt.git/arch/x86/include/asm/signal.h
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
 

