Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab0FWKJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:09:19 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:57860 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab0FWKE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:04:29 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Jason Baron <jbaron@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Robert Richter <robert.richter@amd.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 18/40] compat_syscalls: introduce CONFIG_COMPAT_FTRACE_SYSCALLS
Date: Wed, 23 Jun 2010 20:02:59 +1000
Message-Id: <1277287401-28571-19-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

move the logic for enabling compat syscalls to common arch/Kconfig, where
config_compat_ftrace_syscalls depends on CONFIG_COMPAT, CONFIG_FTRACE_SYSCALLS,
and a per-arch CONFIG_HAVE_COMPAT_FTRACE_SYSCALLS. In this way arches that
want to add support for compat syscalls, can request it via selecting
HAVE_COMPAT_FTRACE_SYSCALLS in their respective arch Kconfig files.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 arch/Kconfig                   |    7 +++++++
 arch/x86/Kconfig               |    1 +
 arch/x86/include/asm/syscall.h |    4 ----
 arch/x86/kernel/ftrace.c       |    2 +-
 include/linux/syscalls.h       |    2 +-
 kernel/trace/trace_syscalls.c  |    2 +-
 6 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 4877a8c..056f81f 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -158,4 +158,11 @@ config HAVE_PERF_EVENTS_NMI
 	  subsystem.  Also has support for calculating CPU cycle events
 	  to determine how many clock cycles in a given period.
 
+config HAVE_COMPAT_FTRACE_SYSCALLS
+	bool
+
+config COMPAT_FTRACE_SYSCALLS
+	def_bool y
+	depends on COMPAT && FTRACE_SYSCALLS && HAVE_COMPAT_FTRACE_SYSCALLS
+
 source "kernel/gcov/Kconfig"
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3069a6d..2a2d65c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -40,6 +40,7 @@ config X86
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_FTRACE_NMI_ENTER if DYNAMIC_FTRACE
 	select HAVE_SYSCALL_TRACEPOINTS
+	select HAVE_COMPAT_FTRACE_SYSCALLS
 	select HAVE_KVM
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
index 4e462cc..f734812 100644
--- a/arch/x86/include/asm/syscall.h
+++ b/arch/x86/include/asm/syscall.h
@@ -16,10 +16,6 @@
 #include <linux/sched.h>
 #include <linux/err.h>
 
-#if defined(CONFIG_COMPAT) && defined(CONFIG_FTRACE_SYSCALLS)
- #define __HAVE_ARCH_FTRACE_COMPAT_SYSCALLS
-#endif
-
 extern const unsigned long sys_call_table[];
 extern const unsigned long *ia32_sys_call_table;
 
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 4b36a0b..662343b 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -512,7 +512,7 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
 }
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
-#ifdef __HAVE_ARCH_FTRACE_COMPAT_SYSCALLS
+#ifdef CONFIG_COMPAT_FTRACE_SYSCALLS
 unsigned long __init arch_compat_syscall_addr(int nr)
 {
 	return (unsigned long)(&ia32_sys_call_table)[nr];
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index e115569..55a9f2b 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -222,7 +222,7 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 #define COMPAT_SYSCALL_DEFINE5(name, ...) COMPAT_SYSCALL_DEFINEx(5, compat_sys_##name, name, __VA_ARGS__)
 #define COMPAT_SYSCALL_DEFINE6(name, ...) COMPAT_SYSCALL_DEFINEx(6, compat_sys_##name, name, __VA_ARGS__)
 
-#ifdef CONFIG_FTRACE_SYSCALLS
+#ifdef CONFIG_COMPAT_FTRACE_SYSCALLS
 #define COMPAT_SYSCALL_DEFINEx(x, syscall, sname, ...)			\
 	static const char *types_compat_sys_##sname[] = {		\
 		__SC_STR_TDECL##x(__VA_ARGS__)				\
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index ff6cd7a..6acba20 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -519,7 +519,7 @@ int __init init_ftrace_syscalls(void)
 		meta->syscall_nr = i;
 		syscalls_metadata[i] = meta;
 	}
-#ifdef __HAVE_ARCH_FTRACE_COMPAT_SYSCALLS
+#ifdef CONFIG_COMPAT_FTRACE_SYSCALLS
 	if (NR_syscalls_compat) {
 		int match;
 		struct ftrace_event_call *ftrace_event;
-- 
1.7.1

