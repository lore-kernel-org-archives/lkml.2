Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab1HOPyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:54:23 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46598 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176Ab1HOPyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:54:20 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: [PATCH 29/32] x86: Syscall hooks for nohz cpusets
Date: Mon, 15 Aug 2011 17:52:26 +0200
Message-Id: <1313423549-27093-30-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add syscall hooks to notify syscall entry and exit on
CPUs running in adative nohz mode.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Paul E . McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>
---
 arch/x86/include/asm/thread_info.h |   10 +++++++---
 arch/x86/kernel/ptrace.c           |   10 ++++++++++
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 1f2e61e..0e3329f 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -87,6 +87,7 @@ struct thread_info {
 #define TIF_NOTSC		16	/* TSC is not accessible in userland */
 #define TIF_IA32		17	/* 32bit process */
 #define TIF_FORK		18	/* ret_from_fork */
+#define TIF_NOHZ		19	/* in nohz userspace mode */
 #define TIF_MEMDIE		20	/* is terminating due to OOM killer */
 #define TIF_DEBUG		21	/* uses debug registers */
 #define TIF_IO_BITMAP		22	/* uses I/O bitmap */
@@ -110,6 +111,7 @@ struct thread_info {
 #define _TIF_NOTSC		(1 << TIF_NOTSC)
 #define _TIF_IA32		(1 << TIF_IA32)
 #define _TIF_FORK		(1 << TIF_FORK)
+#define _TIF_NOHZ		(1 << TIF_NOHZ)
 #define _TIF_DEBUG		(1 << TIF_DEBUG)
 #define _TIF_IO_BITMAP		(1 << TIF_IO_BITMAP)
 #define _TIF_FREEZE		(1 << TIF_FREEZE)
@@ -121,12 +123,13 @@ struct thread_info {
 /* work to do in syscall_trace_enter() */
 #define _TIF_WORK_SYSCALL_ENTRY	\
 	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_EMU | _TIF_SYSCALL_AUDIT |	\
-	 _TIF_SECCOMP | _TIF_SINGLESTEP | _TIF_SYSCALL_TRACEPOINT)
+	 _TIF_SECCOMP | _TIF_SINGLESTEP | _TIF_SYSCALL_TRACEPOINT |	\
+	 _TIF_NOHZ)
 
 /* work to do in syscall_trace_leave() */
 #define _TIF_WORK_SYSCALL_EXIT	\
 	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | _TIF_SINGLESTEP |	\
-	 _TIF_SYSCALL_TRACEPOINT)
+	 _TIF_SYSCALL_TRACEPOINT | _TIF_NOHZ)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK							\
@@ -136,7 +139,8 @@ struct thread_info {
 
 /* work to do on any return to user space */
 #define _TIF_ALLWORK_MASK						\
-	((0x0000FFFF & ~_TIF_SECCOMP) | _TIF_SYSCALL_TRACEPOINT)
+	((0x0000FFFF & ~_TIF_SECCOMP) | _TIF_SYSCALL_TRACEPOINT |	\
+	_TIF_NOHZ)
 
 /* Only used for 64 bit */
 #define _TIF_DO_NOTIFY_MASK						\
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 6e619f2..486a65c 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -21,6 +21,7 @@
 #include <linux/signal.h>
 #include <linux/perf_event.h>
 #include <linux/hw_breakpoint.h>
+#include <linux/tick.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -1385,6 +1386,9 @@ long syscall_trace_enter(struct pt_regs *regs)
 {
 	long ret = 0;
 
+	/* Notify nohz task syscall early so the rest can use rcu */
+	tick_nohz_enter_kernel();
+
 	/*
 	 * If we stepped into a sysenter/syscall insn, it trapped in
 	 * kernel mode; do_debug() cleared TF and set TIF_SINGLESTEP.
@@ -1446,4 +1450,10 @@ void syscall_trace_leave(struct pt_regs *regs)
 			!test_thread_flag(TIF_SYSCALL_EMU);
 	if (step || test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall_exit(regs, step);
+
+	/*
+	 * Notify nohz task exit syscall at last so the rest can
+	 * use rcu.
+	 */
+	tick_nohz_exit_kernel();
 }
-- 
1.7.5.4

