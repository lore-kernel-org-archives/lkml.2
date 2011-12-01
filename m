Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab1LALET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 06:04:19 -0500
Received: from mailx.hitachi.co.jp ([133.145.228.49]:52031 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab1LALER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 06:04:17 -0500
From: takuo.koguchi.sw@hitachi.com
X-AuditID: b753bd60-98c60ba00000359c-6a-4ed75ea22257
Message-Type: Multiple Part
MIME-Version: 1.0
Message-ID: <XNM1$5$0$1$$3$9$0$A$8005107U4ed75e6e@hitachi.com>
Content-Type: text/plain; charset=us-ascii
To: <linux-kernel@vger.kernel.org>
Cc: <masami.hiramatsu.pt@hitachi.com>, <linux@arm.linux.org.uk>,
        <rostedt@goodmis.org>, <fweisbec@gmail.com>, <mingo@redhat.com>,
        <jbaron@redhat.com>, <yrl.pp-manager.tt@hitachi.com>
Date: Thu, 1 Dec 2011 20:01:32 +0900
Importance: normal
Subject: [PATCH] ARM: Wire up HAVE_SYSCALL_TRACEPOINTS
X400-Content-Identifier: X4ED75E6E00000M
X400-MTS-Identifier: [/C=JP/ADMD=HITNET/PRMD=HITACHI/;gmml06111201200102JTH]
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    This patch is necessary to make ftrace syscall trace working for ARM.
The following events are added to /sys/kernel/debug/tracing/available_events
- raw_syscalls:sys_enter
- raw_syscalls:sys_exit
- syscalls:sys_enter_*
- syscalls:sys_exit_*

Sample output;
# tracer: nop
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
       trace-cmd-640   [000]  1174.164948: sys_write -> 0x1
       trace-cmd-640   [000]  1174.164948: sys_exit: NR 4 = 1
       trace-cmd-640   [000]  1174.165009: sys_write(fd: 1, buf: 400c2000, count: d0)
       trace-cmd-640   [000]  1174.165009: sys_enter: NR 4 (1, 400c2000, d0, 0, d0, f54f8)
       trace-cmd-640   [000]  1174.165070: sys_write -> 0xffffffe0
       trace-cmd-640   [000]  1174.165070: sys_exit: NR 4 = -32
              sh-637   [000]  1174.165649: sys_wait4 -> 0x280
              sh-637   [000]  1174.165649: sys_exit: NR 114 = 640
              sh-637   [000]  1174.165680: sys_ioctl(fd: 3ff, cmd: 5410, arg: be82fad4)
              sh-637   [000]  1174.165710: sys_enter: NR 54 (3ff, 5410, be82fad4, be82facc, 1d578, 1b6fc)
              sh-637   [000]  1174.165710: sys_ioctl -> 0x0
              sh-637   [000]  1174.165741: sys_exit: NR 54 = 0
              sh-637   [000]  1174.165771: sys_wait4(upid: ffffffff, stat_addr: be82fae4, options: 1, ru: 0)
              sh-637   [000]  1174.165771: sys_enter: NR 114 (ffffffff, be82fae4, 1, 0, 1, be82fae4)
              sh-637   [000]  1174.165771: sys_wait4 -> 0xfffffff6
              sh-637   [000]  1174.165802: sys_exit: NR 114 = -10
              sh-637   [000]  1174.165802: sys_wait4(upid: ffffffff, stat_addr: be82fae4, options: 1, ru: 0)

Signed-off-by: Takuo Koguchi <takuo.koguchi.sw@hitachi.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>
---
 arch/arm/Kconfig                   |    1 +
 arch/arm/include/asm/syscall.h     |   45 ++++++++++++++++++++++++++++++++++++
 arch/arm/include/asm/thread_info.h |    3 ++
 arch/arm/include/asm/unistd.h      |    3 ++
 arch/arm/kernel/entry-common.S     |    4 +-
 arch/arm/kernel/ptrace.c           |   10 ++++++++
 6 files changed, 64 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/include/asm/syscall.h

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 44789ef..84181b3 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -13,6 +13,7 @@ config ARM
 	select HAVE_KPROBES if !XIP_KERNEL
 	select HAVE_KRETPROBES if (HAVE_KPROBES)
 	select HAVE_FUNCTION_TRACER if (!XIP_KERNEL)
+	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_FTRACE_MCOUNT_RECORD if (!XIP_KERNEL)
 	select HAVE_DYNAMIC_FTRACE if (!XIP_KERNEL)
 	select HAVE_FUNCTION_GRAPH_TRACER if (!THUMB2_KERNEL)
diff --git a/arch/arm/include/asm/syscall.h b/arch/arm/include/asm/syscall.h
new file mode 100644
index 0000000..cabeb67
--- /dev/null
+++ b/arch/arm/include/asm/syscall.h
@@ -0,0 +1,45 @@
+#ifndef _ASM_ARM_SYSCALL_H
+#define _ASM_ARM_SYSCALL_H
+
+extern const unsigned long sys_call_table[];
+
+#include <linux/sched.h>
+
+static inline long syscall_get_nr(struct task_struct *task,
+				  struct pt_regs *regs)
+{
+	return regs->ARM_r7;
+}
+
+static inline long syscall_get_return_value(struct task_struct *task,
+					    struct pt_regs *regs)
+{
+	return regs->ARM_r0;
+}
+
+static inline void syscall_get_arguments(struct task_struct *task,
+					 struct pt_regs *regs,
+					 unsigned int i, unsigned int n,
+					 unsigned long *args)
+{
+	BUG_ON(i);
+	switch (n) {
+	case 6:
+		args[5] = regs->ARM_r5; /* fall through */
+	case 5:
+		args[4] = regs->ARM_r4;
+	case 4:
+		args[3] = regs->ARM_r3;
+	case 3:
+		args[2] = regs->ARM_r2;
+	case 2:
+		args[1] = regs->ARM_r1;
+	case 1:
+		args[0] = regs->ARM_r0;
+	case 0:
+		break;
+	default:
+		BUG();
+	}
+}
+#endif	/* _ASM_ARM_SYSCALL_H */
diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index 7b5cc8d..2509028 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -139,6 +139,7 @@ extern void vfp_flush_hwstate(struct thread_info *);
 #define TIF_NEED_RESCHED	1
 #define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
 #define TIF_SYSCALL_TRACE	8
+#define TIF_SYSCALL_TRACEPOINT	15
 #define TIF_POLLING_NRFLAG	16
 #define TIF_USING_IWMMXT	17
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
@@ -150,11 +151,13 @@ extern void vfp_flush_hwstate(struct thread_info *);
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
+#define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_USING_IWMMXT	(1 << TIF_USING_IWMMXT)
 #define _TIF_FREEZE		(1 << TIF_FREEZE)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
+#define _TIF_SYSCALL_T_OR_A	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_TRACEPOINT)
 
 /*
  * Change these and you break ASM code in entry-common.S
diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
index 4a11237..f4eac2d 100644
--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -405,6 +405,9 @@
 #define __NR_process_vm_readv		(__NR_SYSCALL_BASE+376)
 #define __NR_process_vm_writev		(__NR_SYSCALL_BASE+377)
 
+#ifndef __ASSEMBLY__
+#define NR_syscalls		378
+#endif
 /*
  * The following SWIs are ARM private.
  */
diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index b2a27b6..a1577c2 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -87,7 +87,7 @@ ENTRY(ret_from_fork)
 	get_thread_info tsk
 	ldr	r1, [tsk, #TI_FLAGS]		@ check for syscall tracing
 	mov	why, #1
-	tst	r1, #_TIF_SYSCALL_TRACE		@ are we tracing syscalls?
+	tst	r1, #_TIF_SYSCALL_T_OR_A	@ are we tracing syscalls?
 	beq	ret_slow_syscall
 	mov	r1, sp
 	mov	r0, #1				@ trace exit [IP = 1]
@@ -443,7 +443,7 @@ ENTRY(vector_swi)
 1:
 #endif
 
-	tst	r10, #_TIF_SYSCALL_TRACE		@ are we tracing syscalls?
+	tst	r10, #_TIF_SYSCALL_T_OR_A	@ are we tracing syscalls?
 	bne	__sys_trace
 
 	cmp	scno, #NR_syscalls		@ check upper syscall limit
diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 483727a..a690c9f 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -28,6 +28,9 @@
 #include <asm/system.h>
 #include <asm/traps.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/syscalls.h>
+
 #define REG_PC	15
 #define REG_PSR	16
 /*
@@ -906,6 +909,13 @@ asmlinkage int syscall_trace(int why, struct pt_regs *regs, int scno)
 {
 	unsigned long ip;
 
+	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT))) {
+		if (why)
+			trace_sys_exit(regs, regs->ARM_r0);
+		else
+			trace_sys_enter(regs, scno);
+	}
+
 	if (!test_thread_flag(TIF_SYSCALL_TRACE))
 		return scno;
 	if (!(current->ptrace & PT_PTRACED))
-- 
1.7.5.4

