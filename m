Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784Ab0EMHoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 03:44:13 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:46441 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757577Ab0EMHoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 03:44:08 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
       Jason Baron <jbaron@redhat.com>, Ian Munsie <imunsie@au1.ibm.com>,
       Ian Munsie <imunsie@au1.ibm.com>
Subject: [PATCH 4/4] trace, powerpc: Implement raw syscall tracepoints on PowerPC
Date: Thu, 13 May 2010 17:43:14 +1000
Message-Id: <1273736594-19320-5-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1273736594-19320-1-git-send-email-imunsie@au1.ibm.com>
References: <1273736594-19320-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au.ibm.com>

This patch implements the raw syscall tracepoints on PowerPC required
for ftrace syscalls.

To minimise reworking existing code, I slightly re-ordered the thread
info flags such that the new TIF_SYSCALL_TRACEPOINT bit would still fit
within the 16 bits of the andi instruction's UI field.

In the case of 64bit PowerPC, arch_syscall_addr and
arch_syscall_match_sym_name are overridden to allow ftrace syscalls to
work given the unusual system call table structure and symbol names that
start with a period.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 arch/powerpc/Kconfig                   |    1 +
 arch/powerpc/include/asm/syscall.h     |    9 +++++++++
 arch/powerpc/include/asm/thread_info.h |    7 +++++--
 arch/powerpc/kernel/Makefile           |    1 +
 arch/powerpc/kernel/ftrace.c           |   13 +++++++++++++
 arch/powerpc/kernel/ptrace.c           |   10 ++++++++++
 6 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index c4c4549..41e2f3e 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -141,6 +141,7 @@ config PPC
 	select GENERIC_ATOMIC64 if PPC32
 	select HAVE_PERF_EVENTS
 	select HAVE_REGS_AND_STACK_ACCESS_API
+	select HAVE_SYSCALL_TRACEPOINTS
 
 config EARLY_PRINTK
 	bool
diff --git a/arch/powerpc/include/asm/syscall.h b/arch/powerpc/include/asm/syscall.h
index 23913e9..4098105 100644
--- a/arch/powerpc/include/asm/syscall.h
+++ b/arch/powerpc/include/asm/syscall.h
@@ -15,6 +15,15 @@
 
 #include <linux/sched.h>
 
+/* ftrace syscalls requires exporting the sys_call_table */
+#ifdef CONFIG_FTRACE_SYSCALLS
+#ifdef CONFIG_PPC64
+extern const unsigned long long *sys_call_table;
+#else /* !CONFIG_PPC64 */
+extern const unsigned long *sys_call_table;
+#endif /* CONFIG_PPC64 */
+#endif /* CONFIG_FTRACE_SYSCALLS */
+
 static inline long syscall_get_nr(struct task_struct *task,
 				  struct pt_regs *regs)
 {
diff --git a/arch/powerpc/include/asm/thread_info.h b/arch/powerpc/include/asm/thread_info.h
index aa9d383..e7a8af2 100644
--- a/arch/powerpc/include/asm/thread_info.h
+++ b/arch/powerpc/include/asm/thread_info.h
@@ -110,7 +110,8 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_NOERROR		12	/* Force successful syscall return */
 #define TIF_NOTIFY_RESUME	13	/* callback before returning to user */
 #define TIF_FREEZE		14	/* Freezing for suspend */
-#define TIF_RUNLATCH		15	/* Is the runlatch enabled? */
+#define TIF_SYSCALL_TRACEPOINT	15	/* syscall tracepoint instrumentation */
+#define TIF_RUNLATCH		16	/* Is the runlatch enabled? */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
@@ -127,8 +128,10 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_NOERROR		(1<<TIF_NOERROR)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
+#define _TIF_SYSCALL_TRACEPOINT	(1<<TIF_SYSCALL_TRACEPOINT)
 #define _TIF_RUNLATCH		(1<<TIF_RUNLATCH)
-#define _TIF_SYSCALL_T_OR_A	(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP)
+#define _TIF_SYSCALL_T_OR_A	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | \
+				 _TIF_SECCOMP | _TIF_SYSCALL_TRACEPOINT)
 
 #define _TIF_USER_WORK_MASK	(_TIF_SIGPENDING | _TIF_NEED_RESCHED | \
 				 _TIF_NOTIFY_RESUME)
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index 8773263..9c404bb 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -98,6 +98,7 @@ obj64-$(CONFIG_AUDIT)		+= compat_audit.o
 
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o
+obj-$(CONFIG_FTRACE_SYSCALLS)	+= ftrace.o
 obj-$(CONFIG_PERF_EVENTS)	+= perf_callchain.o
 
 obj-$(CONFIG_PPC_PERF_CTRS)	+= perf_event.o
diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index ce1f3e4..b34171e 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -22,6 +22,7 @@
 #include <asm/cacheflush.h>
 #include <asm/code-patching.h>
 #include <asm/ftrace.h>
+#include <asm/syscall.h>
 
 
 #ifdef CONFIG_DYNAMIC_FTRACE
@@ -600,3 +601,15 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 	}
 }
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+
+#if defined(CONFIG_FTRACE_SYSCALLS) && defined(CONFIG_PPC64)
+unsigned long __init arch_syscall_addr(int nr)
+{
+	return (unsigned long)sys_call_table[nr*2];
+}
+
+inline bool arch_syscall_match_sym_name(const char *sym, const char *name)
+{
+	return (!strcmp(sym + 4, name + 3));
+}
+#endif /* CONFIG_FTRACE_SYSCALLS && CONFIG_PPC64 */
diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index 7a0c019..eb7eeb8 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -29,6 +29,7 @@
 #include <linux/signal.h>
 #include <linux/seccomp.h>
 #include <linux/audit.h>
+#include <trace/syscall.h>
 #ifdef CONFIG_PPC32
 #include <linux/module.h>
 #endif
@@ -38,6 +39,9 @@
 #include <asm/pgtable.h>
 #include <asm/system.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/syscalls.h>
+
 /*
  * The parameter save area on the stack is used to store arguments being passed
  * to callee function and is located at fixed offset from stack pointer.
@@ -1615,6 +1619,9 @@ long do_syscall_trace_enter(struct pt_regs *regs)
 		 */
 		ret = -1L;
 
+	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
+		trace_sys_enter(regs, regs->gpr[0]);
+
 	if (unlikely(current->audit_context)) {
 #ifdef CONFIG_PPC64
 		if (!test_thread_flag(TIF_32BIT))
@@ -1643,6 +1650,9 @@ void do_syscall_trace_leave(struct pt_regs *regs)
 		audit_syscall_exit((regs->ccr&0x10000000)?AUDITSC_FAILURE:AUDITSC_SUCCESS,
 				   regs->result);
 
+	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
+		trace_sys_exit(regs, regs->result);
+
 	step = test_thread_flag(TIF_SINGLESTEP);
 	if (step || test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall_exit(regs, step);
-- 
1.7.1

