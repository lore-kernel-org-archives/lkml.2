Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933375Ab2CZSkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 14:40:53 -0400
Received: from mail-qc0-f202.google.com ([209.85.216.202]:51013 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933021Ab2CZSjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 14:39:33 -0400
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Cc: David Sharp <dhsharp@google.com>, Justin Teravest <teravest@google.com>,
        Laurent Chavey <chavey@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 4/6] trace: trace syscall in its handler not from ptrace handler
Date: Mon, 26 Mar 2012 11:39:26 -0700
Message-Id: <1332787168-20457-5-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332787168-20457-1-git-send-email-vnagarnaik@google.com>
References: <1332787168-20457-1-git-send-email-vnagarnaik@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The syscalls are a tricky bunch to trace, because of their multitude and
dynamic nature of the list. In order to solve this, a macro handled the
sycalls handler definition and it was expanded into setting up the
metadata for the syscall event. A handler hooked into the ptrace syscall
tracer to check whether an invoked syscall was supposed to be traced.

This added latency to all the invoked syscalls, since they had to be
checked for tracing and also affected the latency of syscall that was
actually getting traced. For e.g., using a simple program which invokes
getuid() in a repeated loop and calculates the average time per syscall
invocation found a latency of 570 - 117 = 453 ns added to every traced
syscall.

This patch changes the syscall macro expansion, to create a function
that adds the entry and exit tracepoints for the given syscall so that
the latency can be avoided. This was suggested by Mathieu Desnoyers in
https://lkml.org/lkml/2010/10/13/337

After this patch, the latency added is 370 - 117 = 253 ns per invocation
of a traced syscall. This is on par with a simple tracepoint added to
any kernel code path.

This patch also makes syscall tracing architecture independent as there
is no need to have a hook into the architecture specific syscall tracer
functions.

Suggested-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 arch/openrisc/include/asm/thread_info.h |    1 -
 arch/powerpc/Kconfig                    |    1 -
 arch/powerpc/include/asm/thread_info.h  |    4 +--
 arch/powerpc/kernel/ptrace.c            |    6 -----
 arch/s390/Kconfig                       |    1 -
 arch/s390/include/asm/thread_info.h     |    2 -
 arch/s390/kernel/entry.S                |    3 +-
 arch/s390/kernel/entry64.S              |    3 +-
 arch/s390/kernel/ptrace.c               |    9 -------
 arch/sh/Kconfig                         |    1 -
 arch/sh/include/asm/thread_info.h       |    8 +-----
 arch/sh/kernel/ptrace_32.c              |    9 -------
 arch/sh/kernel/ptrace_64.c              |    9 -------
 arch/sparc/Kconfig                      |    1 -
 arch/sparc/include/asm/thread_info_64.h |    2 -
 arch/sparc/kernel/ptrace_64.c           |    9 -------
 arch/sparc/kernel/syscalls.S            |   10 ++++----
 arch/x86/Kconfig                        |    1 -
 arch/x86/include/asm/thread_info.h      |   10 ++-----
 arch/x86/kernel/ptrace.c                |    9 -------
 include/linux/syscalls.h                |   38 ++++++++++++++++++++++++++++--
 include/trace/events/syscalls.h         |   19 +++------------
 kernel/trace/Kconfig                    |    6 -----
 kernel/trace/trace_syscalls.c           |   33 ++++++++++++++++++++++++--
 kernel/tracepoint.c                     |   38 -------------------------------
 25 files changed, 82 insertions(+), 151 deletions(-)

diff --git a/arch/openrisc/include/asm/thread_info.h b/arch/openrisc/include/asm/thread_info.h
index 07a8bc0..f39aa73 100644
--- a/arch/openrisc/include/asm/thread_info.h
+++ b/arch/openrisc/include/asm/thread_info.h
@@ -110,7 +110,6 @@ register struct thread_info *current_thread_info_reg asm("r10");
 #define TIF_SINGLESTEP		4	/* restore singlestep on return to user
 					 * mode
 					 */
-#define TIF_SYSCALL_TRACEPOINT  8       /* for ftrace syscall instrumentation */
 #define TIF_RESTORE_SIGMASK     9
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling						 * TIF_NEED_RESCHED
 					 */
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 1919634..ab6b8f5 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -139,7 +139,6 @@ config PPC
 	select GENERIC_IRQ_SHOW_LEVEL
 	select IRQ_FORCED_THREADING
 	select HAVE_RCU_TABLE_FREE if SMP
-	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_BPF_JIT if (PPC64 && NET)
 	select HAVE_ARCH_JUMP_LABEL
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
diff --git a/arch/powerpc/include/asm/thread_info.h b/arch/powerpc/include/asm/thread_info.h
index 96471494..b0721f2 100644
--- a/arch/powerpc/include/asm/thread_info.h
+++ b/arch/powerpc/include/asm/thread_info.h
@@ -109,7 +109,6 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_RESTOREALL		11	/* Restore all regs (implies NOERROR) */
 #define TIF_NOERROR		12	/* Force successful syscall return */
 #define TIF_NOTIFY_RESUME	13	/* callback before returning to user */
-#define TIF_SYSCALL_TRACEPOINT	15	/* syscall tracepoint instrumentation */
 #define TIF_RUNLATCH		16	/* Is the runlatch enabled? */
 
 /* as above, but as bit values */
@@ -126,10 +125,9 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_RESTOREALL		(1<<TIF_RESTOREALL)
 #define _TIF_NOERROR		(1<<TIF_NOERROR)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
-#define _TIF_SYSCALL_TRACEPOINT	(1<<TIF_SYSCALL_TRACEPOINT)
 #define _TIF_RUNLATCH		(1<<TIF_RUNLATCH)
 #define _TIF_SYSCALL_T_OR_A	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | \
-				 _TIF_SECCOMP | _TIF_SYSCALL_TRACEPOINT)
+				 _TIF_SECCOMP)
 
 #define _TIF_USER_WORK_MASK	(_TIF_SIGPENDING | _TIF_NEED_RESCHED | \
 				 _TIF_NOTIFY_RESUME)
diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index 5b43325..46a917c 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -1721,9 +1721,6 @@ long do_syscall_trace_enter(struct pt_regs *regs)
 		 */
 		ret = -1L;
 
-	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
-		trace_sys_enter(regs, regs->gpr[0]);
-
 #ifdef CONFIG_PPC64
 	if (!is_32bit_task())
 		audit_syscall_entry(AUDIT_ARCH_PPC64,
@@ -1748,9 +1745,6 @@ void do_syscall_trace_leave(struct pt_regs *regs)
 
 	audit_syscall_exit(regs);
 
-	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
-		trace_sys_exit(regs, regs->result);
-
 	step = test_thread_flag(TIF_SINGLESTEP);
 	if (step || test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall_exit(regs, step);
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 6d99a5f..3065759 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -69,7 +69,6 @@ config S390
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_C_RECORDMCOUNT
-	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_REGS_AND_STACK_ACCESS_API
diff --git a/arch/s390/include/asm/thread_info.h b/arch/s390/include/asm/thread_info.h
index a730381..4207a43 100644
--- a/arch/s390/include/asm/thread_info.h
+++ b/arch/s390/include/asm/thread_info.h
@@ -94,7 +94,6 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_SYSCALL_TRACE	8	/* syscall trace active */
 #define TIF_SYSCALL_AUDIT	9	/* syscall auditing active */
 #define TIF_SECCOMP		10	/* secure computing */
-#define TIF_SYSCALL_TRACEPOINT	11	/* syscall tracepoint instrumentation */
 #define TIF_SIE			12	/* guest execution active */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling
 					   TIF_NEED_RESCHED */
@@ -113,7 +112,6 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
-#define _TIF_SYSCALL_TRACEPOINT	(1<<TIF_SYSCALL_TRACEPOINT)
 #define _TIF_SIE		(1<<TIF_SIE)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_31BIT		(1<<TIF_31BIT)
diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index 3705700..7ad7929 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -40,8 +40,7 @@ _TIF_WORK_SVC = (_TIF_SIGPENDING | _TIF_NOTIFY_RESUME | _TIF_NEED_RESCHED | \
 		 _TIF_MCCK_PENDING | _TIF_PER_TRAP )
 _TIF_WORK_INT = (_TIF_SIGPENDING | _TIF_NOTIFY_RESUME | _TIF_NEED_RESCHED | \
 		 _TIF_MCCK_PENDING)
-_TIF_TRACE    = (_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | _TIF_SECCOMP | \
-		 _TIF_SYSCALL_TRACEPOINT)
+_TIF_TRACE    = (_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | _TIF_SECCOMP)
 
 STACK_SHIFT = PAGE_SHIFT + THREAD_ORDER
 STACK_SIZE  = 1 << STACK_SHIFT
diff --git a/arch/s390/kernel/entry64.S b/arch/s390/kernel/entry64.S
index 412a7b8..1459a5b 100644
--- a/arch/s390/kernel/entry64.S
+++ b/arch/s390/kernel/entry64.S
@@ -43,8 +43,7 @@ _TIF_WORK_SVC = (_TIF_SIGPENDING | _TIF_NOTIFY_RESUME | _TIF_NEED_RESCHED | \
 		 _TIF_MCCK_PENDING | _TIF_PER_TRAP )
 _TIF_WORK_INT = (_TIF_SIGPENDING | _TIF_NOTIFY_RESUME | _TIF_NEED_RESCHED | \
 		 _TIF_MCCK_PENDING)
-_TIF_TRACE    = (_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | _TIF_SECCOMP | \
-		 _TIF_SYSCALL_TRACEPOINT)
+_TIF_TRACE    = (_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | _TIF_SECCOMP)
 _TIF_EXIT_SIE = (_TIF_SIGPENDING | _TIF_NEED_RESCHED | _TIF_MCCK_PENDING)
 
 #define BASED(name) name-system_call(%r13)
diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index 61f9548..2151616 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -35,9 +35,6 @@
 #include "compat_ptrace.h"
 #endif
 
-#define CREATE_TRACE_POINTS
-#include <trace/events/syscalls.h>
-
 enum s390_regset {
 	REGSET_GENERAL,
 	REGSET_FP,
@@ -737,9 +734,6 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 		ret = -1;
 	}
 
-	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
-		trace_sys_enter(regs, regs->gprs[2]);
-
 	audit_syscall_entry(is_compat_task() ?
 				AUDIT_ARCH_S390 : AUDIT_ARCH_S390X,
 			    regs->gprs[2], regs->orig_gpr2,
@@ -752,9 +746,6 @@ asmlinkage void do_syscall_trace_exit(struct pt_regs *regs)
 {
 	audit_syscall_exit(regs);
 
-	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
-		trace_sys_exit(regs, regs->gprs[2]);
-
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall_exit(regs, 0);
 }
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 713fb58..e64c779 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -19,7 +19,6 @@ config SUPERH
 	select HAVE_KERNEL_LZMA
 	select HAVE_KERNEL_XZ
 	select HAVE_KERNEL_LZO
-	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_SPARSE_IRQ
diff --git a/arch/sh/include/asm/thread_info.h b/arch/sh/include/asm/thread_info.h
index 20ee40a..34abf14 100644
--- a/arch/sh/include/asm/thread_info.h
+++ b/arch/sh/include/asm/thread_info.h
@@ -119,7 +119,6 @@ extern void init_thread_xstate(void);
 #define TIF_SYSCALL_AUDIT	5	/* syscall auditing active */
 #define TIF_SECCOMP		6	/* secure computing */
 #define TIF_NOTIFY_RESUME	7	/* callback before returning to user */
-#define TIF_SYSCALL_TRACEPOINT	8	/* for ftrace syscall instrumentation */
 #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
 
@@ -130,7 +129,6 @@ extern void init_thread_xstate(void);
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
-#define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 
 /*
@@ -141,14 +139,12 @@ extern void init_thread_xstate(void);
 
 /* work to do in syscall trace */
 #define _TIF_WORK_SYSCALL_MASK	(_TIF_SYSCALL_TRACE | _TIF_SINGLESTEP | \
-				 _TIF_SYSCALL_AUDIT | _TIF_SECCOMP    | \
-				 _TIF_SYSCALL_TRACEPOINT)
+				 _TIF_SYSCALL_AUDIT | _TIF_SECCOMP)
 
 /* work to do on any return to u-space */
 #define _TIF_ALLWORK_MASK	(_TIF_SYSCALL_TRACE | _TIF_SIGPENDING      | \
 				 _TIF_NEED_RESCHED  | _TIF_SYSCALL_AUDIT   | \
-				 _TIF_SINGLESTEP    | _TIF_NOTIFY_RESUME   | \
-				 _TIF_SYSCALL_TRACEPOINT)
+				 _TIF_SINGLESTEP    | _TIF_NOTIFY_RESUME)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK		(_TIF_ALLWORK_MASK & ~(_TIF_SYSCALL_TRACE | \
diff --git a/arch/sh/kernel/ptrace_32.c b/arch/sh/kernel/ptrace_32.c
index a3e6515..a8c2aa2 100644
--- a/arch/sh/kernel/ptrace_32.c
+++ b/arch/sh/kernel/ptrace_32.c
@@ -34,9 +34,6 @@
 #include <asm/syscalls.h>
 #include <asm/fpu.h>
 
-#define CREATE_TRACE_POINTS
-#include <trace/events/syscalls.h>
-
 /*
  * This routine will get a word off of the process kernel stack.
  */
@@ -515,9 +512,6 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 		 */
 		ret = -1L;
 
-	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
-		trace_sys_enter(regs, regs->regs[0]);
-
 	audit_syscall_entry(audit_arch(), regs->regs[3],
 			    regs->regs[4], regs->regs[5],
 			    regs->regs[6], regs->regs[7]);
@@ -531,9 +525,6 @@ asmlinkage void do_syscall_trace_leave(struct pt_regs *regs)
 
 	audit_syscall_exit(regs);
 
-	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
-		trace_sys_exit(regs, regs->regs[0]);
-
 	step = test_thread_flag(TIF_SINGLESTEP);
 	if (step || test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall_exit(regs, step);
diff --git a/arch/sh/kernel/ptrace_64.c b/arch/sh/kernel/ptrace_64.c
index 3d0080b..7cf8212 100644
--- a/arch/sh/kernel/ptrace_64.c
+++ b/arch/sh/kernel/ptrace_64.c
@@ -40,9 +40,6 @@
 #include <asm/syscalls.h>
 #include <asm/fpu.h>
 
-#define CREATE_TRACE_POINTS
-#include <trace/events/syscalls.h>
-
 /* This mask defines the bits of the SR which the user is not allowed to
    change, which are everything except S, Q, M, PR, SZ, FR. */
 #define SR_MASK      (0xffff8cfd)
@@ -533,9 +530,6 @@ asmlinkage long long do_syscall_trace_enter(struct pt_regs *regs)
 		 */
 		ret = -1LL;
 
-	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
-		trace_sys_enter(regs, regs->regs[9]);
-
 	audit_syscall_entry(audit_arch(), regs->regs[1],
 			    regs->regs[2], regs->regs[3],
 			    regs->regs[4], regs->regs[5]);
@@ -549,9 +543,6 @@ asmlinkage void do_syscall_trace_leave(struct pt_regs *regs)
 
 	audit_syscall_exit(regs);
 
-	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
-		trace_sys_exit(regs, regs->regs[9]);
-
 	step = test_thread_flag(TIF_SINGLESTEP);
 	if (step || test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall_exit(regs, step);
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index ca5580e..df3ba69 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -50,7 +50,6 @@ config SPARC64
 	select HAVE_SYSCALL_WRAPPERS
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE_MCOUNT_RECORD
-	select HAVE_SYSCALL_TRACEPOINTS
 	select RTC_DRV_CMOS
 	select RTC_DRV_BQ4802
 	select RTC_DRV_SUN4V
diff --git a/arch/sparc/include/asm/thread_info_64.h b/arch/sparc/include/asm/thread_info_64.h
index 01d057f..2afad03 100644
--- a/arch/sparc/include/asm/thread_info_64.h
+++ b/arch/sparc/include/asm/thread_info_64.h
@@ -217,7 +217,6 @@ register struct thread_info *current_thread_info_reg asm("g6");
 /* flag bit 8 is available */
 #define TIF_SECCOMP		9	/* secure computing */
 #define TIF_SYSCALL_AUDIT	10	/* syscall auditing active */
-#define TIF_SYSCALL_TRACEPOINT	11	/* syscall tracepoint instrumentation */
 /* NOTE: Thread flags >= 12 should be ones we have no interest
  *       in using in assembly, else we can't use the mask as
  *       an immediate value in instructions such as andcc.
@@ -234,7 +233,6 @@ register struct thread_info *current_thread_info_reg asm("g6");
 #define _TIF_32BIT		(1<<TIF_32BIT)
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
-#define _TIF_SYSCALL_TRACEPOINT	(1<<TIF_SYSCALL_TRACEPOINT)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 
 #define _TIF_USER_WORK_MASK	((0xff << TI_FLAG_WSAVED_SHIFT) | \
diff --git a/arch/sparc/kernel/ptrace_64.c b/arch/sparc/kernel/ptrace_64.c
index 9388844..6f3ba31 100644
--- a/arch/sparc/kernel/ptrace_64.c
+++ b/arch/sparc/kernel/ptrace_64.c
@@ -38,9 +38,6 @@
 #include <asm/cpudata.h>
 #include <asm/cacheflush.h>
 
-#define CREATE_TRACE_POINTS
-#include <trace/events/syscalls.h>
-
 #include "entry.h"
 
 /* #define ALLOW_INIT_TRACING */
@@ -1068,9 +1065,6 @@ asmlinkage int syscall_trace_enter(struct pt_regs *regs)
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
 		ret = tracehook_report_syscall_entry(regs);
 
-	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
-		trace_sys_enter(regs, regs->u_regs[UREG_G1]);
-
 	audit_syscall_entry((test_thread_flag(TIF_32BIT) ?
 			     AUDIT_ARCH_SPARC :
 			     AUDIT_ARCH_SPARC64),
@@ -1087,9 +1081,6 @@ asmlinkage void syscall_trace_leave(struct pt_regs *regs)
 {
 	audit_syscall_exit(regs);
 
-	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
-		trace_sys_exit(regs, regs->u_regs[UREG_G1]);
-
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall_exit(regs, 0);
 }
diff --git a/arch/sparc/kernel/syscalls.S b/arch/sparc/kernel/syscalls.S
index 1d7e274..c8b3bb2 100644
--- a/arch/sparc/kernel/syscalls.S
+++ b/arch/sparc/kernel/syscalls.S
@@ -62,7 +62,7 @@ sys32_rt_sigreturn:
 #endif
 	.align	32
 1:	ldx	[%g6 + TI_FLAGS], %l5
-	andcc	%l5, (_TIF_SYSCALL_TRACE|_TIF_SECCOMP|_TIF_SYSCALL_AUDIT|_TIF_SYSCALL_TRACEPOINT), %g0
+	andcc	%l5, (_TIF_SYSCALL_TRACE|_TIF_SECCOMP|_TIF_SYSCALL_AUDIT), %g0
 	be,pt	%icc, rtrap
 	 nop
 	call	syscall_trace_leave
@@ -179,7 +179,7 @@ linux_sparc_syscall32:
 
 	srl	%i5, 0, %o5				! IEU1
 	srl	%i2, 0, %o2				! IEU0	Group
-	andcc	%l0, (_TIF_SYSCALL_TRACE|_TIF_SECCOMP|_TIF_SYSCALL_AUDIT|_TIF_SYSCALL_TRACEPOINT), %g0
+	andcc	%l0, (_TIF_SYSCALL_TRACE|_TIF_SECCOMP|_TIF_SYSCALL_AUDIT), %g0
 	bne,pn	%icc, linux_syscall_trace32		! CTI
 	 mov	%i0, %l5				! IEU1
 	call	%l7					! CTI	Group brk forced
@@ -202,7 +202,7 @@ linux_sparc_syscall:
 
 	mov	%i3, %o3				! IEU1
 	mov	%i4, %o4				! IEU0	Group
-	andcc	%l0, (_TIF_SYSCALL_TRACE|_TIF_SECCOMP|_TIF_SYSCALL_AUDIT|_TIF_SYSCALL_TRACEPOINT), %g0
+	andcc	%l0, (_TIF_SYSCALL_TRACE|_TIF_SECCOMP|_TIF_SYSCALL_AUDIT), %g0
 	bne,pn	%icc, linux_syscall_trace		! CTI	Group
 	 mov	%i0, %l5				! IEU0
 2:	call	%l7					! CTI	Group brk forced
@@ -226,7 +226,7 @@ ret_sys_call:
 
 	cmp	%o0, -ERESTART_RESTARTBLOCK
 	bgeu,pn	%xcc, 1f
-	 andcc	%l0, (_TIF_SYSCALL_TRACE|_TIF_SECCOMP|_TIF_SYSCALL_AUDIT|_TIF_SYSCALL_TRACEPOINT), %l6
+	 andcc	%l0, (_TIF_SYSCALL_TRACE|_TIF_SECCOMP|_TIF_SYSCALL_AUDIT), %l6
 80:
 	/* System call success, clear Carry condition code. */
 	andn	%g3, %g2, %g3
@@ -241,7 +241,7 @@ ret_sys_call:
 	/* System call failure, set Carry condition code.
 	 * Also, get abs(errno) to return to the process.
 	 */
-	andcc	%l0, (_TIF_SYSCALL_TRACE|_TIF_SECCOMP|_TIF_SYSCALL_AUDIT|_TIF_SYSCALL_TRACEPOINT), %l6	
+	andcc	%l0, (_TIF_SYSCALL_TRACE|_TIF_SECCOMP|_TIF_SYSCALL_AUDIT), %l6
 	sub	%g0, %o0, %o0
 	or	%g3, %g2, %g3
 	stx	%o0, [%sp + PTREGS_OFF + PT_V9_I0]
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5bed94e..1f19cf6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -41,7 +41,6 @@ config X86
 	select HAVE_FUNCTION_GRAPH_FP_TEST
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_FTRACE_NMI_ENTER if DYNAMIC_FTRACE
-	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_KVM
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index cfd8144..192b7a3 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -94,7 +94,6 @@ struct thread_info {
 #define TIF_FORCED_TF		24	/* true if TF in eflags artificially */
 #define TIF_BLOCKSTEP		25	/* set when we want DEBUGCTLMSR_BTF */
 #define TIF_LAZY_MMU_UPDATES	27	/* task is updating the mmu lazily */
-#define TIF_SYSCALL_TRACEPOINT	28	/* syscall tracepoint instrumentation */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
@@ -115,17 +114,15 @@ struct thread_info {
 #define _TIF_FORCED_TF		(1 << TIF_FORCED_TF)
 #define _TIF_BLOCKSTEP		(1 << TIF_BLOCKSTEP)
 #define _TIF_LAZY_MMU_UPDATES	(1 << TIF_LAZY_MMU_UPDATES)
-#define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
 
 /* work to do in syscall_trace_enter() */
 #define _TIF_WORK_SYSCALL_ENTRY	\
 	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_EMU | _TIF_SYSCALL_AUDIT |	\
-	 _TIF_SECCOMP | _TIF_SINGLESTEP | _TIF_SYSCALL_TRACEPOINT)
+	 _TIF_SECCOMP | _TIF_SINGLESTEP)
 
 /* work to do in syscall_trace_leave() */
 #define _TIF_WORK_SYSCALL_EXIT	\
-	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | _TIF_SINGLESTEP |	\
-	 _TIF_SYSCALL_TRACEPOINT)
+	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | _TIF_SINGLESTEP)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK							\
@@ -134,8 +131,7 @@ struct thread_info {
 	   _TIF_SINGLESTEP|_TIF_SECCOMP|_TIF_SYSCALL_EMU))
 
 /* work to do on any return to user space */
-#define _TIF_ALLWORK_MASK						\
-	((0x0000FFFF & ~_TIF_SECCOMP) | _TIF_SYSCALL_TRACEPOINT)
+#define _TIF_ALLWORK_MASK		(0x0000FFFF & ~_TIF_SECCOMP)
 
 /* Only used for 64 bit */
 #define _TIF_DO_NOTIFY_MASK						\
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 5026738..3f1bab2 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -36,9 +36,6 @@
 
 #include "tls.h"
 
-#define CREATE_TRACE_POINTS
-#include <trace/events/syscalls.h>
-
 enum x86_regset {
 	REGSET_GENERAL,
 	REGSET_FP,
@@ -1389,9 +1386,6 @@ long syscall_trace_enter(struct pt_regs *regs)
 	    tracehook_report_syscall_entry(regs))
 		ret = -1L;
 
-	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
-		trace_sys_enter(regs, regs->orig_ax);
-
 	if (IS_IA32)
 		audit_syscall_entry(AUDIT_ARCH_I386,
 				    regs->orig_ax,
@@ -1414,9 +1408,6 @@ void syscall_trace_leave(struct pt_regs *regs)
 
 	audit_syscall_exit(regs);
 
-	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
-		trace_sys_exit(regs, regs->ax);
-
 	/*
 	 * If TIF_SYSCALL_EMU is set, we only get here because of
 	 * TIF_SINGLESTEP (i.e. this is PTRACE_SYSEMU_SINGLESTEP).
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index fd4d37d..9f3e5cf 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -75,8 +75,9 @@ struct file_handle;
 #include <linux/quota.h>
 #include <linux/key.h>
 #include <trace/syscall.h>
+#include <asm/syscall.h>
 
-#define __SC_DECL0()
+#define __SC_DECL0() void
 #define __SC_DECL1(t1, a1)	t1 a1
 #define __SC_DECL2(t2, a2, ...) t2 a2, __SC_DECL1(__VA_ARGS__)
 #define __SC_DECL3(t3, a3, ...) t3 a3, __SC_DECL2(__VA_ARGS__)
@@ -232,6 +233,27 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	SYSCALL_METADATAx(x, sname, __VA_ARGS__)			\
 	__SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
 
+extern void trace_sys_enter_handler(struct pt_regs *regs, long id);
+extern void trace_sys_exit_handler(struct pt_regs *regs, long ret);
+
+#ifdef CONFIG_FTRACE_SYSCALLS
+#define SYSCALL_TRACE_HANDLERx(x, name, ...)				\
+	({								\
+		long ret;						\
+		struct pt_regs *regs = task_pt_regs(current);		\
+		long syscall_nr = syscall_get_nr(current, regs);	\
+		trace_sys_enter_handler(regs, syscall_nr);		\
+		ret = _sys_##name(__SC_CAST##x(__VA_ARGS__));		\
+		trace_sys_exit_handler(regs, ret);			\
+		ret;							\
+	 })
+#else
+#define SYSCALL_TRACE_HANDLERx(x, name, ...)				\
+	({								\
+		_sys_##name(__SC_CAST##x(__VA_ARGS__));			\
+	 })
+#endif
+
 #ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
 
 #define SYSCALL_DEFINE(name) static inline long SYSC_##name
@@ -245,13 +267,23 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 		return (long) SYSC_##name(__SC_CAST##x(__VA_ARGS__));	\
 	}								\
 	SYSCALL_ALIAS(sys_##name, SyS_##name);				\
-	static inline long SYSC_##name(__SC_DECL##x(__VA_ARGS__))
+	static inline long _sys_##name(__SC_DECL##x(__VA_ARGS__));	\
+	static inline long SYSC_##name(__SC_DECL##x(__VA_ARGS__))	\
+	{								\
+		return SYSCALL_TRACE_HANDLERx(x, name, __VA_ARGS__);	\
+	}								\
+	static inline long _sys_##name(__SC_DECL##x(__VA_ARGS__))
 
 #else /* CONFIG_HAVE_SYSCALL_WRAPPERS */
 
 #define SYSCALL_DEFINE(name) asmlinkage long sys_##name
 #define __SYSCALL_DEFINEx(x, name, ...)					\
-	asmlinkage long sys_##name(__SC_DECL##x(__VA_ARGS__))
+	static inline long _sys_##name(__SC_DECL##x(__VA_ARGS__));	\
+	asmlinkage long sys_##name(__SC_DECL##x(__VA_ARGS__))		\
+	{								\
+		return SYSCALL_TRACE_HANDLERx(x, name, __VA_ARGS__);	\
+	}								\
+	static inline long _sys_##name(__SC_DECL##x(__VA_ARGS__))
 
 #endif /* CONFIG_HAVE_SYSCALL_WRAPPERS */
 
diff --git a/include/trace/events/syscalls.h b/include/trace/events/syscalls.h
index 5a4c04a..aeaa536 100644
--- a/include/trace/events/syscalls.h
+++ b/include/trace/events/syscalls.h
@@ -11,12 +11,7 @@
 #include <asm/syscall.h>
 
 
-#ifdef CONFIG_HAVE_SYSCALL_TRACEPOINTS
-
-extern void syscall_regfunc(void);
-extern void syscall_unregfunc(void);
-
-TRACE_EVENT_FN(sys_enter,
+TRACE_EVENT(sys_enter,
 
 	TP_PROTO(struct pt_regs *regs, long id),
 
@@ -35,14 +30,12 @@ TRACE_EVENT_FN(sys_enter,
 	TP_printk("NR %ld (%lx, %lx, %lx, %lx, %lx, %lx)",
 		  __entry->id,
 		  __entry->args[0], __entry->args[1], __entry->args[2],
-		  __entry->args[3], __entry->args[4], __entry->args[5]),
-
-	syscall_regfunc, syscall_unregfunc
+		  __entry->args[3], __entry->args[4], __entry->args[5])
 );
 
 TRACE_EVENT_FLAGS(sys_enter, TRACE_EVENT_FL_CAP_ANY)
 
-TRACE_EVENT_FN(sys_exit,
+TRACE_EVENT(sys_exit,
 
 	TP_PROTO(struct pt_regs *regs, long ret),
 
@@ -59,15 +52,11 @@ TRACE_EVENT_FN(sys_exit,
 	),
 
 	TP_printk("NR %ld = %ld",
-		  __entry->id, __entry->ret),
-
-	syscall_regfunc, syscall_unregfunc
+		  __entry->id, __entry->ret)
 );
 
 TRACE_EVENT_FLAGS(sys_exit, TRACE_EVENT_FL_CAP_ANY)
 
-#endif /* CONFIG_HAVE_SYSCALL_TRACEPOINTS */
-
 #endif /* _TRACE_EVENTS_SYSCALLS_H */
 
 /* This part must be outside protection */
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index cd0954b..5afa3f5 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -44,11 +44,6 @@ config HAVE_FTRACE_MCOUNT_RECORD
 	help
 	  See Documentation/trace/ftrace-design.txt
 
-config HAVE_SYSCALL_TRACEPOINTS
-	bool
-	help
-	  See Documentation/trace/ftrace-design.txt
-
 config HAVE_C_RECORDMCOUNT
 	bool
 	help
@@ -234,7 +229,6 @@ config ENABLE_DEFAULT_TRACERS
 
 config FTRACE_SYSCALLS
 	bool "Trace syscalls"
-	depends on HAVE_SYSCALL_TRACEPOINTS
 	select GENERIC_TRACER
 	select KALLSYMS
 	help
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 43a8685..b757eba 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -1,5 +1,4 @@
 #include <trace/syscall.h>
-#include <trace/events/syscalls.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/module.h>	/* for MODULE_NAME_LEN via KSYM_SYMBOL_LEN */
@@ -11,6 +10,9 @@
 #include "trace_output.h"
 #include "trace.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/syscalls.h>
+
 static DEFINE_MUTEX(syscall_trace_lock);
 static int sys_refcount_enter;
 static int sys_refcount_exit;
@@ -369,7 +371,7 @@ void ftrace_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 
 	entry = ring_buffer_event_data(event);
 	entry->nr = syscall_nr;
-	entry->ret = syscall_get_return_value(current, regs);
+	entry->ret = ret;
 
 	if (!filter_current_check_discard(buffer, sys_data->exit_event,
 					  entry, event))
@@ -501,6 +503,31 @@ int __init init_ftrace_syscalls(void)
 }
 core_initcall(init_ftrace_syscalls);
 
+/*
+ * trace_sys_(enter|exit)_handler
+ *
+ * These functions provide a way to add tracepoints to every syscall.
+ * The macros that define syscall handlers using SYSCALL_DEFINE in
+ * include/linux/syscalls.h conflict with the recursive included ftrace
+ * macro magic defined in include/linux/tracepoint.h.
+ *
+ * So it not feasible to include events/trace/syscalls.h to provide the
+ * definition for trace_sys_(enter|exit) probes.
+ *
+ * Hence the need for these functions which are forward defined in
+ * include/linux/syscalls.h and are called from SYSCALL_DEFINE section
+ * for each syscall.
+ */
+void trace_sys_enter_handler(struct pt_regs *regs, long id)
+{
+	trace_sys_enter(regs, id);
+}
+
+void trace_sys_exit_handler(struct pt_regs *regs, long ret)
+{
+	trace_sys_exit(regs, ret);
+}
+
 #ifdef CONFIG_PERF_EVENTS
 
 static DECLARE_BITMAP(enabled_perf_enter_syscalls, NR_syscalls);
@@ -617,7 +644,7 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 		return;
 
 	rec->nr = syscall_nr;
-	rec->ret = syscall_get_return_value(current, regs);
+	rec->ret = ret;
 
 	head = this_cpu_ptr(sys_data->exit_event->perf_events);
 	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head);
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index f1539de..3b41d3e 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -726,41 +726,3 @@ static int init_tracepoints(void)
 }
 __initcall(init_tracepoints);
 #endif /* CONFIG_MODULES */
-
-#ifdef CONFIG_HAVE_SYSCALL_TRACEPOINTS
-
-/* NB: reg/unreg are called while guarded with the tracepoints_mutex */
-static int sys_tracepoint_refcount;
-
-void syscall_regfunc(void)
-{
-	unsigned long flags;
-	struct task_struct *g, *t;
-
-	if (!sys_tracepoint_refcount) {
-		read_lock_irqsave(&tasklist_lock, flags);
-		do_each_thread(g, t) {
-			/* Skip kernel threads. */
-			if (t->mm)
-				set_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
-		} while_each_thread(g, t);
-		read_unlock_irqrestore(&tasklist_lock, flags);
-	}
-	sys_tracepoint_refcount++;
-}
-
-void syscall_unregfunc(void)
-{
-	unsigned long flags;
-	struct task_struct *g, *t;
-
-	sys_tracepoint_refcount--;
-	if (!sys_tracepoint_refcount) {
-		read_lock_irqsave(&tasklist_lock, flags);
-		do_each_thread(g, t) {
-			clear_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
-		} while_each_thread(g, t);
-		read_unlock_irqrestore(&tasklist_lock, flags);
-	}
-}
-#endif
-- 
1.7.7.3

