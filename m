Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab0LGE3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 23:29:35 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:47656 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478Ab0LGE3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 23:29:30 -0500
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: Avantika Mathur <mathur@linux.vnet.ibm.com>
Cc: Jason Baron <jbaron@redhat.com>, Ian Munsie <imunsie@au1.ibm.com>,
        Ian Munsie <imunsie@au1.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Nathan Lynch <ntl@pobox.com>,
        Andreas Schwab <schwab@linux-m68k.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andreas Dilger <adilger@dilger.ca>, Jiri Kosina <jkosina@suse.cz>,
        Kumar Gala <galak@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, Alexander Graf <agraf@suse.de>,
        Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Gibson <dwg@au1.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] trace, powerpc: Implement raw syscall tracepoints on PowerPC
Date: Tue,  7 Dec 2010 15:29:10 +1100
Message-Id: <1291696151-4336-6-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1291696151-4336-1-git-send-email-imunsie@au1.ibm.com>
References: <1291696151-4336-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au.ibm.com>

This patch implements the raw syscall tracepoints on PowerPC and exports
them for ftrace syscalls to use.

To minimise reworking existing code, I slightly re-ordered the thread
info flags such that the new TIF_SYSCALL_TRACEPOINT bit would still fit
within the 16 bits of the andi. instruction's UI field. The instructions
in question are in /arch/powerpc/kernel/entry_{32,64}.S to and the
_TIF_SYSCALL_T_OR_A with the thread flags to see if system call tracing
is enabled.

In the case of 64bit PowerPC, arch_syscall_addr and
arch_syscall_match_sym_name are overridden to allow ftrace syscalls to
work given the unusual system call table structure and symbol names that
start with a period.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 arch/powerpc/Kconfig                   |    1 +
 arch/powerpc/include/asm/syscall.h     |    5 +++++
 arch/powerpc/include/asm/thread_info.h |    7 +++++--
 arch/powerpc/kernel/Makefile           |    1 +
 arch/powerpc/kernel/ftrace.c           |   19 +++++++++++++++++++
 arch/powerpc/kernel/ptrace.c           |   10 ++++++++++
 6 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index e625e9e..6614b69 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -140,6 +140,7 @@ config PPC
 	select HAVE_PERF_EVENTS
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS && PPC_BOOK3S_64
+	select HAVE_SYSCALL_TRACEPOINTS
 
 config EARLY_PRINTK
 	bool
diff --git a/arch/powerpc/include/asm/syscall.h b/arch/powerpc/include/asm/syscall.h
index 23913e9..b54b2ad 100644
--- a/arch/powerpc/include/asm/syscall.h
+++ b/arch/powerpc/include/asm/syscall.h
@@ -15,6 +15,11 @@
 
 #include <linux/sched.h>
 
+/* ftrace syscalls requires exporting the sys_call_table */
+#ifdef CONFIG_FTRACE_SYSCALLS
+extern const unsigned long *sys_call_table;
+#endif /* CONFIG_FTRACE_SYSCALLS */
+
 static inline long syscall_get_nr(struct task_struct *task,
 				  struct pt_regs *regs)
 {
diff --git a/arch/powerpc/include/asm/thread_info.h b/arch/powerpc/include/asm/thread_info.h
index 65eb859..4403f09 100644
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
index 36c30f3..13d6eb0 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -106,6 +106,7 @@ obj64-$(CONFIG_AUDIT)		+= compat_audit.o
 
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o
+obj-$(CONFIG_FTRACE_SYSCALLS)	+= ftrace.o
 obj-$(CONFIG_PERF_EVENTS)	+= perf_callchain.o
 
 obj-$(CONFIG_PPC_PERF_CTRS)	+= perf_event.o
diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index ce1f3e4..f5fadbb 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -22,6 +22,7 @@
 #include <asm/cacheflush.h>
 #include <asm/code-patching.h>
 #include <asm/ftrace.h>
+#include <asm/syscall.h>
 
 
 #ifdef CONFIG_DYNAMIC_FTRACE
@@ -600,3 +601,21 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 	}
 }
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+
+#if defined(CONFIG_FTRACE_SYSCALLS) && defined(CONFIG_PPC64)
+unsigned long __init arch_syscall_addr(int nr)
+{
+	return sys_call_table[nr*2];
+}
+
+inline bool arch_syscall_match_sym_name(const char *sym, const char *name)
+{
+	/*
+	 * Compare the symbol name with the system call name. Skip the .sys or
+	 * .SyS prefix from the symbol name and the sys prefix from the system
+	 * call name and just match the rest. 32bit can use the generic
+	 * function since their symbol names don't start with a period.
+	 */
+	return (!strcmp(sym + 4, name + 3));
+}
+#endif /* CONFIG_FTRACE_SYSCALLS && CONFIG_PPC64 */
diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index a9b3296..f70d144 100644
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
@@ -40,6 +41,9 @@
 #include <asm/pgtable.h>
 #include <asm/system.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/syscalls.h>
+
 /*
  * The parameter save area on the stack is used to store arguments being passed
  * to callee function and is located at fixed offset from stack pointer.
@@ -1681,6 +1685,9 @@ long do_syscall_trace_enter(struct pt_regs *regs)
 		 */
 		ret = -1L;
 
+	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
+		trace_sys_enter(regs, regs->gpr[0]);
+
 	if (unlikely(current->audit_context)) {
 #ifdef CONFIG_PPC64
 		if (!is_32bit_task())
@@ -1709,6 +1716,9 @@ void do_syscall_trace_leave(struct pt_regs *regs)
 		audit_syscall_exit((regs->ccr&0x10000000)?AUDITSC_FAILURE:AUDITSC_SUCCESS,
 				   regs->result);
 
+	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
+		trace_sys_exit(regs, regs->result);
+
 	step = test_thread_flag(TIF_SINGLESTEP);
 	if (step || test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall_exit(regs, step);
-- 
1.7.2.3

