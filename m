Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841Ab2EAACz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 20:02:55 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:51303 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757738Ab2EAACx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 20:02:53 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 24/41] x86: Syscall hooks for nohz cpusets
Date: Tue,  1 May 2012 01:54:58 +0200
Message-Id: <1335830115-14335-25-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add syscall hooks to notify syscall entry and exit on
CPUs running in adative nohz mode.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/thread_info.h |   10 +++++++---
 arch/x86/kernel/ptrace.c           |   10 ++++++++++
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index cfd8144..0c1724e 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -88,6 +88,7 @@ struct thread_info {
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
 #define _TIF_FORCED_TF		(1 << TIF_FORCED_TF)
@@ -120,12 +122,13 @@ struct thread_info {
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
@@ -135,7 +138,8 @@ struct thread_info {
 
 /* work to do on any return to user space */
 #define _TIF_ALLWORK_MASK						\
-	((0x0000FFFF & ~_TIF_SECCOMP) | _TIF_SYSCALL_TRACEPOINT)
+	((0x0000FFFF & ~_TIF_SECCOMP) | _TIF_SYSCALL_TRACEPOINT |	\
+	_TIF_NOHZ)
 
 /* Only used for 64 bit */
 #define _TIF_DO_NOTIFY_MASK						\
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 5026738..2966791 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -21,6 +21,7 @@
 #include <linux/signal.h>
 #include <linux/perf_event.h>
 #include <linux/hw_breakpoint.h>
+#include <linux/tick.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -1369,6 +1370,9 @@ long syscall_trace_enter(struct pt_regs *regs)
 {
 	long ret = 0;
 
+	/* Notify nohz task syscall early so the rest can use rcu */
+	tick_nohz_enter_kernel();
+
 	/*
 	 * If we stepped into a sysenter/syscall insn, it trapped in
 	 * kernel mode; do_debug() cleared TF and set TIF_SINGLESTEP.
@@ -1427,4 +1431,10 @@ void syscall_trace_leave(struct pt_regs *regs)
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

