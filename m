Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab0CRSX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 14:23:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035Ab0CRSXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 14:23:55 -0400
Date: Thu, 18 Mar 2010 14:22:39 -0400
From: Jason Baron <jbaron@redhat.com>
To: fweisbec@gmail.com, mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com,
       hpa@zytor.com, tglx@linutronix.de, mhiramat@redhat.com,
       heiko.carstens@de.ibm.com, benh@kernel.crashing.org,
       davem@davemloft.net, lethal@linux-sh.org, schwidefsky@de.ibm.com,
       brueckner@linux.vnet.ibm.com, tony.luck@intel.com
Subject: Re: [PATCH 15/14] compat_syscalls: introduce
	CONFIG_COMPAT_FTRACE_SYSCALLS
Message-ID: <20100318182238.GA2661@redhat.com>
References: <cover.1268749695.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1268749695.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move the logic for enabling compat syscalls to common arch/Kconfig, where
config_compat_ftrace_syscalls depends on CONFIG_COMPAT, CONFIG_FTRACE_SYSCALLS,
and a per-arch CONFIG_HAVE_COMPAT_FTRACE_SYSCALLS. In this way arches that
want to add support for compat syscalls, can request it via selecting
HAVE_COMPAT_FTRACE_SYSCALLS in their respective arch Kconfig files.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 arch/Kconfig                   |    7 +++++++
 arch/x86/Kconfig               |    1 +
 arch/x86/include/asm/syscall.h |    4 ----
 arch/x86/kernel/ftrace.c       |    2 +-
 include/linux/syscalls.h       |    2 +-
 kernel/trace/trace_syscalls.c  |    2 +-
 6 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index e0ad3ca..0aca622 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -153,4 +153,11 @@ config HAVE_HW_BREAKPOINT
 config HAVE_USER_RETURN_NOTIFIER
 	bool
 
+config HAVE_COMPAT_FTRACE_SYSCALLS
+	bool
+
+config COMPAT_FTRACE_SYSCALLS
+	def_bool y
+	depends on COMPAT && FTRACE_SYSCALLS && HAVE_COMPAT_FTRACE_SYSCALLS
+
 source "kernel/gcov/Kconfig"
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6de8f35..4083c0f 100644
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
index 2361d9a..cf230a6 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -235,7 +235,7 @@ struct perf_event_attr;
 #define COMPAT_SYSCALL_DEFINE5(name, ...) COMPAT_SYSCALL_DEFINEx(5, compat_sys_##name, name, __VA_ARGS__)
 #define COMPAT_SYSCALL_DEFINE6(name, ...) COMPAT_SYSCALL_DEFINEx(6, compat_sys_##name, name, __VA_ARGS__)
 
-#ifdef CONFIG_FTRACE_SYSCALLS
+#ifdef CONFIG_COMPAT_FTRACE_SYSCALLS
 #define COMPAT_SYSCALL_DEFINEx(x, syscall, sname, ...)			\
 	static const char *types_compat_sys_##sname[] = {		\
 		__SC_STR_TDECL##x(__VA_ARGS__)				\
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 3f88b8e..6db3794 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -439,7 +439,7 @@ int __init init_ftrace_syscalls(void)
 		meta->syscall_nr = i;
 		syscalls_metadata[i] = meta;
 	}
-#ifdef __HAVE_ARCH_FTRACE_COMPAT_SYSCALLS
+#ifdef CONFIG_COMPAT_FTRACE_SYSCALLS
 	if (NR_syscalls_compat) {
 		int match;
 		struct ftrace_event_call *ftrace_event;
-- 
1.6.5.1

