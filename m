Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab0FWKEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:04:53 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:36937 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab0FWKEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:04:47 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Jason Baron <jbaron@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Ian Munsie <imunsie@au1.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 39/40] trace syscalls: Clean confusing {s,r,}name and fix ABI breakage
Date: Wed, 23 Jun 2010 20:03:20 +1000
Message-Id: <1277287401-28571-40-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This patch cleans up the preprocessor macros defining system calls by
standidising on the parameters passing around the system call name, with
and without it's prefix.

Overall this makes the preprocessor code easier to understand and
follow and less likely to introduce bugs due to misunderstanding what to
place into each parameter.

The parameters henceforth should be named:

sname is the system call name WITHOUT the prefix (e.g. read)
prefix is the prefix INCLUDING the trailing underscore (e.g. sys_)

These are mashed together to form the full syscall name when required
like blah##prefix##sname. For just prefix##sname please use the provided
SYSNAME(prefix,sname) macro instead as it will be safe if prefix itself
is a macro.

This patch also fixes an ABI breakage - the ftrace events are once again
named like 'sys_enter_read' instead of 'enter_sys_read'. The rwtop
script shipped with perf relies on this ABI. Others may as well.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 arch/powerpc/include/asm/syscalls.h |   58 +++++-----
 include/linux/syscalls.h            |  200 ++++++++++++++++++-----------------
 2 files changed, 131 insertions(+), 127 deletions(-)

diff --git a/arch/powerpc/include/asm/syscalls.h b/arch/powerpc/include/asm/syscalls.h
index 050cca3..b01fedf 100644
--- a/arch/powerpc/include/asm/syscalls.h
+++ b/arch/powerpc/include/asm/syscalls.h
@@ -21,48 +21,50 @@ struct sigaction;
 #define __SC_DUMMY_ARGS6
 
 /* Native syscalls that require register access */
-#define PPC_REGS_SYSCALL_DEFINE1_RET(ret, name, regs, ...) PPC_REGS_SYSCALL_DEFINEx(1, ret, sys_##name, _##name, regs, __VA_ARGS__)
-#define PPC_REGS_SYSCALL_DEFINE2_RET(ret, name, regs, ...) PPC_REGS_SYSCALL_DEFINEx(2, ret, sys_##name, _##name, regs, __VA_ARGS__)
-#define PPC_REGS_SYSCALL_DEFINE3_RET(ret, name, regs, ...) PPC_REGS_SYSCALL_DEFINEx(3, ret, sys_##name, _##name, regs, __VA_ARGS__)
-#define PPC_REGS_SYSCALL_DEFINE4_RET(ret, name, regs, ...) PPC_REGS_SYSCALL_DEFINEx(4, ret, sys_##name, _##name, regs, __VA_ARGS__)
-#define PPC_REGS_SYSCALL_DEFINE5_RET(ret, name, regs, ...) PPC_REGS_SYSCALL_DEFINEx(5, ret, sys_##name, _##name, regs, __VA_ARGS__)
-#define PPC_REGS_SYSCALL_DEFINE6_RET(ret, name, regs, ...) PPC_REGS_SYSCALL_DEFINEx(6, ret, sys_##name, _##name, regs, __VA_ARGS__)
+#define PPC_REGS_SYSCALL_DEFINE0_RET(ret, sname, regs     ) PPC_REGS_SYSCALL_DEFINE0(   ret, sys_, sname, regs)
+#define PPC_REGS_SYSCALL_DEFINE1_RET(ret, sname, regs, ...) PPC_REGS_SYSCALL_DEFINEx(1, ret, sys_, sname, regs, __VA_ARGS__)
+#define PPC_REGS_SYSCALL_DEFINE2_RET(ret, sname, regs, ...) PPC_REGS_SYSCALL_DEFINEx(2, ret, sys_, sname, regs, __VA_ARGS__)
+#define PPC_REGS_SYSCALL_DEFINE3_RET(ret, sname, regs, ...) PPC_REGS_SYSCALL_DEFINEx(3, ret, sys_, sname, regs, __VA_ARGS__)
+#define PPC_REGS_SYSCALL_DEFINE4_RET(ret, sname, regs, ...) PPC_REGS_SYSCALL_DEFINEx(4, ret, sys_, sname, regs, __VA_ARGS__)
+#define PPC_REGS_SYSCALL_DEFINE5_RET(ret, sname, regs, ...) PPC_REGS_SYSCALL_DEFINEx(5, ret, sys_, sname, regs, __VA_ARGS__)
+#define PPC_REGS_SYSCALL_DEFINE6_RET(ret, sname, regs, ...) PPC_REGS_SYSCALL_DEFINEx(6, ret, sys_, sname, regs, __VA_ARGS__)
 
 #ifdef CONFIG_COMPAT
 
 /* 32bit compat syscalls that require register access */
-#define PPC_REGS_COMPAT_SYSCALL_DEFINE1_RET(ret, name, regs, ...) PPC_REGS_COMPAT_SYSCALL_DEFINEx(1, ret, compat_sys_##name, name, regs, __VA_ARGS__)
-#define PPC_REGS_COMPAT_SYSCALL_DEFINE2_RET(ret, name, regs, ...) PPC_REGS_COMPAT_SYSCALL_DEFINEx(2, ret, compat_sys_##name, name, regs, __VA_ARGS__)
-#define PPC_REGS_COMPAT_SYSCALL_DEFINE3_RET(ret, name, regs, ...) PPC_REGS_COMPAT_SYSCALL_DEFINEx(3, ret, compat_sys_##name, name, regs, __VA_ARGS__)
-#define PPC_REGS_COMPAT_SYSCALL_DEFINE4_RET(ret, name, regs, ...) PPC_REGS_COMPAT_SYSCALL_DEFINEx(4, ret, compat_sys_##name, name, regs, __VA_ARGS__)
-#define PPC_REGS_COMPAT_SYSCALL_DEFINE5_RET(ret, name, regs, ...) PPC_REGS_COMPAT_SYSCALL_DEFINEx(5, ret, compat_sys_##name, name, regs, __VA_ARGS__)
-#define PPC_REGS_COMPAT_SYSCALL_DEFINE6_RET(ret, name, regs, ...) PPC_REGS_COMPAT_SYSCALL_DEFINEx(6, ret, compat_sys_##name, name, regs, __VA_ARGS__)
-
-#define PPC_REGS_COMPAT_SYSCALL_DEFINEx(x, ret, sysname, sname, regs,  ...)	\
-	SYSCALL_METADATAx(sysname, compat_sys_##sname, x, compat_syscall, __VA_ARGS__);\
-	__PPC_REGS_SYSCALL_DEFINEx(x, ret, sysname, regs, __VA_ARGS__)
-
-#define PPC_REGS_COMPAT_SYSCALL_DEFINE0_RET(ret, name, regs)			\
-	SYSCALL_METADATA0(compat_sys_##name, name, syscall)			\
-	__PPC_REGS_SYSCALL_DEFINE0(ret, compat_sys_##name, regs)
+#define PPC_REGS_COMPAT_SYSCALL_DEFINE0_RET(ret, sname, regs     ) PPC_REGS_COMPAT_SYSCALL_DEFINE0(   ret, compat_sys_, sname, regs)
+#define PPC_REGS_COMPAT_SYSCALL_DEFINE1_RET(ret, sname, regs, ...) PPC_REGS_COMPAT_SYSCALL_DEFINEx(1, ret, compat_sys_, sname, regs, __VA_ARGS__)
+#define PPC_REGS_COMPAT_SYSCALL_DEFINE2_RET(ret, sname, regs, ...) PPC_REGS_COMPAT_SYSCALL_DEFINEx(2, ret, compat_sys_, sname, regs, __VA_ARGS__)
+#define PPC_REGS_COMPAT_SYSCALL_DEFINE3_RET(ret, sname, regs, ...) PPC_REGS_COMPAT_SYSCALL_DEFINEx(3, ret, compat_sys_, sname, regs, __VA_ARGS__)
+#define PPC_REGS_COMPAT_SYSCALL_DEFINE4_RET(ret, sname, regs, ...) PPC_REGS_COMPAT_SYSCALL_DEFINEx(4, ret, compat_sys_, sname, regs, __VA_ARGS__)
+#define PPC_REGS_COMPAT_SYSCALL_DEFINE5_RET(ret, sname, regs, ...) PPC_REGS_COMPAT_SYSCALL_DEFINEx(5, ret, compat_sys_, sname, regs, __VA_ARGS__)
+#define PPC_REGS_COMPAT_SYSCALL_DEFINE6_RET(ret, sname, regs, ...) PPC_REGS_COMPAT_SYSCALL_DEFINEx(6, ret, compat_sys_, sname, regs, __VA_ARGS__)
+
+#define PPC_REGS_COMPAT_SYSCALL_DEFINEx(x, ret, prefix, sname, regs,  ...)	\
+	SYSCALL_METADATAx(prefix, sname, x, compat_syscall, __VA_ARGS__);	\
+	__PPC_REGS_SYSCALL_DEFINEx(x, ret, prefix, sname, regs, __VA_ARGS__)
+
+#define PPC_REGS_COMPAT_SYSCALL_DEFINE0(ret, prefix, sname, regs)		\
+	SYSCALL_METADATA0(prefix, sname, syscall)				\
+	__PPC_REGS_SYSCALL_DEFINE0(ret, prefix, sname, regs)
 
 #endif /*CONFIG_COMPAT */
 
-#define PPC_REGS_SYSCALL_DEFINEx(x, ret, sysname, sname, regs, ...)		\
-	SYSCALL_METADATAx(sysname, sname, x, syscall, __VA_ARGS__);		\
-	__PPC_REGS_SYSCALL_DEFINEx(x, ret, sysname, regs, __VA_ARGS__)
+#define PPC_REGS_SYSCALL_DEFINEx(x, ret, prefix, sname, regs, ...)		\
+	SYSCALL_METADATAx(prefix, sname, x, syscall, __VA_ARGS__);		\
+	__PPC_REGS_SYSCALL_DEFINEx(x, ret, prefix, sname, regs, __VA_ARGS__)
 
-#define PPC_REGS_SYSCALL_DEFINE0_RET(ret, name, regs)				\
-	SYSCALL_METADATA0(sys_##name, name, syscall)				\
-	__PPC_REGS_SYSCALL_DEFINE0(ret, sys_##name, regs)
+#define PPC_REGS_SYSCALL_DEFINE0(ret, prefix, sname, regs)			\
+	SYSCALL_METADATA0(prefix, sname, syscall)				\
+	__PPC_REGS_SYSCALL_DEFINE0(ret, prefix, sname, regs)
 
-#define __PPC_REGS_SYSCALL_DEFINEx(x, ret, sysname, regs, ...)			\
-	ret sysname(__SC_DECL##x(__VA_ARGS__),					\
+#define __PPC_REGS_SYSCALL_DEFINEx(x, ret, prefix, sname, regs, ...)		\
+	ret SYSNAME(prefix, sname)(__SC_DECL##x(__VA_ARGS__),			\
 			__SC_DUMMY_ARGS##x					\
 			struct pt_regs *regs)
 
-#define __PPC_REGS_SYSCALL_DEFINE0(ret, sysname, regs)				\
-	ret sysname(__SC_DUMMY_ARGS0 struct pt_regs *regs)
+#define __PPC_REGS_SYSCALL_DEFINE0(ret, prefix, sname, regs)			\
+	ret SYSNAME(prefix, sname)(__SC_DUMMY_ARGS0 struct pt_regs *regs)
 
 
 asmlinkage unsigned long sys_mmap(unsigned long addr, size_t len,
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 0cef707..dbc630a 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -103,6 +103,8 @@ struct perf_event_attr;
 #define __SC_TEST5(t5, a5, ...)	__SC_TEST(t5); __SC_TEST4(__VA_ARGS__)
 #define __SC_TEST6(t6, a6, ...)	__SC_TEST(t6); __SC_TEST5(__VA_ARGS__)
 
+#define SYSNAME(prefix, sname) prefix##sname
+
 #ifdef CONFIG_FTRACE_SYSCALLS
 #define __SC_STR_ADECL1(t, a)		#a
 #define __SC_STR_ADECL2(t, a, ...)	#a, __SC_STR_ADECL1(__VA_ARGS__)
@@ -125,42 +127,42 @@ extern struct ftrace_event_class event_class_compat_syscall_exit;
 extern struct trace_event_functions enter_syscall_print_funcs;
 extern struct trace_event_functions exit_syscall_print_funcs;
 
-#define SYSCALL_TRACE_ENTER_EVENT(sname, event_class)			\
-	static struct syscall_metadata __syscall_meta_##sname;		\
+#define SYSCALL_TRACE_ENTER_EVENT(prefix, sname, event_class)		\
+	static struct syscall_metadata __syscall_meta_##prefix##sname;	\
 	static struct ftrace_event_call					\
-	__attribute__((__aligned__(4))) event_enter_##sname;		\
+	__attribute__((__aligned__(4))) event_enter_##prefix##sname;	\
 	static struct ftrace_event_call __used				\
 	  __attribute__((__aligned__(4)))				\
 	  __attribute__((section("_ftrace_events")))			\
-	  event_enter_##sname = {					\
-		.name                   = "enter_"#sname,		\
+	  event_enter_##prefix##sname = {				\
+		.name                   = #prefix"enter_"#sname,	\
 		.class			= &event_class_##event_class##_enter,\
 		.event.funcs            = &enter_syscall_print_funcs,	\
-		.data			= (void *)&__syscall_meta_##sname,\
+		.data			= (void *)&__syscall_meta_##prefix##sname,\
 	}
 
-#define SYSCALL_TRACE_EXIT_EVENT(sname, event_class)			\
-	static struct syscall_metadata __syscall_meta_##sname;		\
+#define SYSCALL_TRACE_EXIT_EVENT(prefix, sname, event_class)		\
+	static struct syscall_metadata __syscall_meta_##prefix##sname;	\
 	static struct ftrace_event_call					\
-	__attribute__((__aligned__(4))) event_exit_##sname;		\
+	__attribute__((__aligned__(4))) event_exit_##prefix##sname;	\
 	static struct ftrace_event_call __used				\
 	  __attribute__((__aligned__(4)))				\
 	  __attribute__((section("_ftrace_events")))			\
-	  event_exit_##sname = {					\
-		.name                   = "exit_"#sname,		\
+	  event_exit_##prefix##sname = {				\
+		.name                   = #prefix"exit_"#sname,		\
 		.class			= &event_class_##event_class##_exit,\
 		.event.funcs		= &exit_syscall_print_funcs,	\
-		.data			= (void *)&__syscall_meta_##sname,\
+		.data			= (void *)&__syscall_meta_##prefix##sname,\
 	}
 
-#define SYSCALL_METADATA(rname, sname, nb, event_class, stypes, sargs)\
-	SYSCALL_TRACE_ENTER_EVENT(sname, event_class);		\
-	SYSCALL_TRACE_EXIT_EVENT(sname, event_class);		\
+#define SYSCALL_METADATA(prefix, sname, nb, event_class, stypes, sargs)\
+	SYSCALL_TRACE_ENTER_EVENT(prefix, sname, event_class);	\
+	SYSCALL_TRACE_EXIT_EVENT(prefix, sname, event_class);	\
 	static struct syscall_metadata __used			\
 	  __attribute__((__aligned__(4)))			\
 	  __attribute__((section("__syscalls_metadata")))	\
-	  __syscall_meta_##sname = {				\
-		.name 		= #rname,			\
+	  __syscall_meta_##prefix##sname = {			\
+		.name 		= #prefix#sname,		\
 		.syscall_nr	= -1,	/* Filled in at boot */	\
 		.compat_syscall_nr = -1,/* Filled in at boot */	\
 		.nb_args 	= nb,				\
@@ -170,85 +172,85 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 		.ftrace_exit	= 0,				\
 		.perf_enter	= 0,				\
 		.perf_exit	= 0,				\
-		.enter_event	= &event_enter_##sname,		\
-		.exit_event	= &event_exit_##sname,		\
-		.enter_fields	= LIST_HEAD_INIT(__syscall_meta_##sname.enter_fields), \
-		.exit_fields	= LIST_HEAD_INIT(__syscall_meta_##sname.exit_fields), \
+		.enter_event	= &event_enter_##prefix##sname,	\
+		.exit_event	= &event_exit_##prefix##sname,	\
+		.enter_fields	= LIST_HEAD_INIT(__syscall_meta_##prefix##sname.enter_fields), \
+		.exit_fields	= LIST_HEAD_INIT(__syscall_meta_##prefix##sname.exit_fields), \
 	};
 
-#define SYSCALL_METADATAx(rname, sname, nb, event_class, ...)	\
-	static const char *types_##sname[] = {			\
+#define SYSCALL_METADATAx(prefix, sname, nb, event_class, ...)	\
+	static const char *types_##prefix##sname[] = {		\
 		__SC_STR_TDECL##nb(__VA_ARGS__)			\
 	};							\
-	static const char *args_##sname[] = {			\
+	static const char *args_##prefix##sname[] = {		\
 		__SC_STR_ADECL##nb(__VA_ARGS__)			\
 	};							\
-	SYSCALL_METADATA(rname, sname, nb, event_class, types_##sname, args_##sname)
+	SYSCALL_METADATA(prefix, sname, nb, event_class, types_##prefix##sname, args_##prefix##sname)
 
-#define SYSCALL_METADATA0(rname, sname, event_class)			\
-	SYSCALL_METADATA(rname, sname, 0, event_class, NULL, NULL)
+#define SYSCALL_METADATA0(prefix, sname, event_class)		\
+	SYSCALL_METADATA(prefix, sname, 0, event_class, NULL, NULL)
 
 #else /* !CONFIG_FTRACE_SYSCALLS */
 #define SYSCALL_METADATAx(...)
 #define SYSCALL_METADATA0(...)
 #endif /* CONFIG_FTRACE_SYSCALLS */
 
-#define SYSCALL_DEFINE0(name) SYSCALL_DEFINE0_RET(long, name)
-#define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, long, _##name, __VA_ARGS__)
-#define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, long, _##name, __VA_ARGS__)
-#define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, long, _##name, __VA_ARGS__)
-#define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, long, _##name, __VA_ARGS__)
-#define SYSCALL_DEFINE5(name, ...) SYSCALL_DEFINEx(5, long, _##name, __VA_ARGS__)
-#define SYSCALL_DEFINE6(name, ...) SYSCALL_DEFINEx(6, long, _##name, __VA_ARGS__)
-
-#define SYSCALL_DEFINE1_RET(ret, name, ...) SYSCALL_DEFINEx(1, ret, _##name, __VA_ARGS__)
-#define SYSCALL_DEFINE2_RET(ret, name, ...) SYSCALL_DEFINEx(2, ret, _##name, __VA_ARGS__)
-#define SYSCALL_DEFINE3_RET(ret, name, ...) SYSCALL_DEFINEx(3, ret, _##name, __VA_ARGS__)
-#define SYSCALL_DEFINE4_RET(ret, name, ...) SYSCALL_DEFINEx(4, ret, _##name, __VA_ARGS__)
-#define SYSCALL_DEFINE5_RET(ret, name, ...) SYSCALL_DEFINEx(5, ret, _##name, __VA_ARGS__)
-#define SYSCALL_DEFINE6_RET(ret, name, ...) SYSCALL_DEFINEx(6, ret, _##name, __VA_ARGS__)
+#define SYSCALL_DEFINE0(sname) SYSCALL_DEFINE0_RET(long, sname)
+#define SYSCALL_DEFINE1(sname, ...) SYSCALL_DEFINEx(1, long, sname, __VA_ARGS__)
+#define SYSCALL_DEFINE2(sname, ...) SYSCALL_DEFINEx(2, long, sname, __VA_ARGS__)
+#define SYSCALL_DEFINE3(sname, ...) SYSCALL_DEFINEx(3, long, sname, __VA_ARGS__)
+#define SYSCALL_DEFINE4(sname, ...) SYSCALL_DEFINEx(4, long, sname, __VA_ARGS__)
+#define SYSCALL_DEFINE5(sname, ...) SYSCALL_DEFINEx(5, long, sname, __VA_ARGS__)
+#define SYSCALL_DEFINE6(sname, ...) SYSCALL_DEFINEx(6, long, sname, __VA_ARGS__)
+
+#define SYSCALL_DEFINE1_RET(ret, sname, ...) SYSCALL_DEFINEx(1, ret, sname, __VA_ARGS__)
+#define SYSCALL_DEFINE2_RET(ret, sname, ...) SYSCALL_DEFINEx(2, ret, sname, __VA_ARGS__)
+#define SYSCALL_DEFINE3_RET(ret, sname, ...) SYSCALL_DEFINEx(3, ret, sname, __VA_ARGS__)
+#define SYSCALL_DEFINE4_RET(ret, sname, ...) SYSCALL_DEFINEx(4, ret, sname, __VA_ARGS__)
+#define SYSCALL_DEFINE5_RET(ret, sname, ...) SYSCALL_DEFINEx(5, ret, sname, __VA_ARGS__)
+#define SYSCALL_DEFINE6_RET(ret, sname, ...) SYSCALL_DEFINEx(6, ret, sname, __VA_ARGS__)
 
 #ifdef CONFIG_COMPAT
 
-#define ARCH_COMPAT_SYSCALL_DEFINE0(name) COMPAT_SYSCALL_DEFINE0_RET(long, sys32_##name, name)
-#define ARCH_COMPAT_SYSCALL_DEFINE1(name, ...) COMPAT_SYSCALL_DEFINEx(1, long, sys32_##name, name, __VA_ARGS__)
-#define ARCH_COMPAT_SYSCALL_DEFINE2(name, ...) COMPAT_SYSCALL_DEFINEx(2, long, sys32_##name, name, __VA_ARGS__)
-#define ARCH_COMPAT_SYSCALL_DEFINE3(name, ...) COMPAT_SYSCALL_DEFINEx(3, long, sys32_##name, name, __VA_ARGS__)
-#define ARCH_COMPAT_SYSCALL_DEFINE4(name, ...) COMPAT_SYSCALL_DEFINEx(4, long, sys32_##name, name, __VA_ARGS__)
-#define ARCH_COMPAT_SYSCALL_DEFINE5(name, ...) COMPAT_SYSCALL_DEFINEx(5, long, sys32_##name, name, __VA_ARGS__)
-#define ARCH_COMPAT_SYSCALL_DEFINE6(name, ...) COMPAT_SYSCALL_DEFINEx(6, long, sys32_##name, name, __VA_ARGS__)
-
-#define ARCH_COMPAT_SYSCALL_DEFINE0_RET(ret, name) COMPAT_SYSCALL_DEFINE0_RET(0, ret, sys32_##name, name)
-#define ARCH_COMPAT_SYSCALL_DEFINE1_RET(ret, name, ...) COMPAT_SYSCALL_DEFINEx(1, ret, sys32_##name, name, __VA_ARGS__)
-#define ARCH_COMPAT_SYSCALL_DEFINE2_RET(ret, name, ...) COMPAT_SYSCALL_DEFINEx(2, ret, sys32_##name, name, __VA_ARGS__)
-#define ARCH_COMPAT_SYSCALL_DEFINE3_RET(ret, name, ...) COMPAT_SYSCALL_DEFINEx(3, ret, sys32_##name, name, __VA_ARGS__)
-#define ARCH_COMPAT_SYSCALL_DEFINE4_RET(ret, name, ...) COMPAT_SYSCALL_DEFINEx(4, ret, sys32_##name, name, __VA_ARGS__)
-#define ARCH_COMPAT_SYSCALL_DEFINE5_RET(ret, name, ...) COMPAT_SYSCALL_DEFINEx(5, ret, sys32_##name, name, __VA_ARGS__)
-#define ARCH_COMPAT_SYSCALL_DEFINE6_RET(ret, name, ...) COMPAT_SYSCALL_DEFINEx(6, ret, sys32_##name, name, __VA_ARGS__)
-
-#define COMPAT_SYSCALL_DEFINE0(name) COMPAT_SYSCALL_DEFINE0_RET(long, compat_sys_##name, name)
-#define COMPAT_SYSCALL_DEFINE1(name, ...) COMPAT_SYSCALL_DEFINEx(1, long, compat_sys_##name, name, __VA_ARGS__)
-#define COMPAT_SYSCALL_DEFINE2(name, ...) COMPAT_SYSCALL_DEFINEx(2, long, compat_sys_##name, name, __VA_ARGS__)
-#define COMPAT_SYSCALL_DEFINE3(name, ...) COMPAT_SYSCALL_DEFINEx(3, long, compat_sys_##name, name, __VA_ARGS__)
-#define COMPAT_SYSCALL_DEFINE4(name, ...) COMPAT_SYSCALL_DEFINEx(4, long, compat_sys_##name, name, __VA_ARGS__)
-#define COMPAT_SYSCALL_DEFINE5(name, ...) COMPAT_SYSCALL_DEFINEx(5, long, compat_sys_##name, name, __VA_ARGS__)
-#define COMPAT_SYSCALL_DEFINE6(name, ...) COMPAT_SYSCALL_DEFINEx(6, long, compat_sys_##name, name, __VA_ARGS__)
-
-#define COMPAT_SYSCALL_DEFINE0_RET(ret, name) __COMPAT_SYSCALL_DEFINE0(ret, compat_sys_##name, name)
-#define COMPAT_SYSCALL_DEFINE1_RET(ret, name, ...) COMPAT_SYSCALL_DEFINEx(1, ret, compat_sys_##name, name, __VA_ARGS__)
-#define COMPAT_SYSCALL_DEFINE2_RET(ret, name, ...) COMPAT_SYSCALL_DEFINEx(2, ret, compat_sys_##name, name, __VA_ARGS__)
-#define COMPAT_SYSCALL_DEFINE3_RET(ret, name, ...) COMPAT_SYSCALL_DEFINEx(3, ret, compat_sys_##name, name, __VA_ARGS__)
-#define COMPAT_SYSCALL_DEFINE4_RET(ret, name, ...) COMPAT_SYSCALL_DEFINEx(4, ret, compat_sys_##name, name, __VA_ARGS__)
-#define COMPAT_SYSCALL_DEFINE5_RET(ret, name, ...) COMPAT_SYSCALL_DEFINEx(5, ret, compat_sys_##name, name, __VA_ARGS__)
-#define COMPAT_SYSCALL_DEFINE6_RET(ret, name, ...) COMPAT_SYSCALL_DEFINEx(6, ret, compat_sys_##name, name, __VA_ARGS__)
-
-#define COMPAT_SYSCALL_DEFINEx(x, ret, syscall, sname, ...)		\
-	SYSCALL_METADATAx(syscall, compat_sys_##sname, x, compat_syscall, __VA_ARGS__);\
-	asmlinkage ret syscall(__SC_DECL##x(__VA_ARGS__))
-
-#define __COMPAT_SYSCALL_DEFINE0_RET(ret, syscall, name)		\
-	SYSCALL_METADATA0(syscall, name, compat_syscall)		\
-	asmlinkage ret syscall()
+#define ARCH_COMPAT_SYSCALL_DEFINE0(sname) COMPAT_SYSCALL_DEFINE0_RET(long, sys32_, sname)
+#define ARCH_COMPAT_SYSCALL_DEFINE1(sname, ...) COMPAT_SYSCALL_DEFINEx(1, long, sys32_, sname, __VA_ARGS__)
+#define ARCH_COMPAT_SYSCALL_DEFINE2(sname, ...) COMPAT_SYSCALL_DEFINEx(2, long, sys32_, sname, __VA_ARGS__)
+#define ARCH_COMPAT_SYSCALL_DEFINE3(sname, ...) COMPAT_SYSCALL_DEFINEx(3, long, sys32_, sname, __VA_ARGS__)
+#define ARCH_COMPAT_SYSCALL_DEFINE4(sname, ...) COMPAT_SYSCALL_DEFINEx(4, long, sys32_, sname, __VA_ARGS__)
+#define ARCH_COMPAT_SYSCALL_DEFINE5(sname, ...) COMPAT_SYSCALL_DEFINEx(5, long, sys32_, sname, __VA_ARGS__)
+#define ARCH_COMPAT_SYSCALL_DEFINE6(sname, ...) COMPAT_SYSCALL_DEFINEx(6, long, sys32_, sname, __VA_ARGS__)
+
+#define ARCH_COMPAT_SYSCALL_DEFINE0_RET(ret, sname) COMPAT_SYSCALL_DEFINE0_RET(0, ret, sys32_, sname)
+#define ARCH_COMPAT_SYSCALL_DEFINE1_RET(ret, sname, ...) COMPAT_SYSCALL_DEFINEx(1, ret, sys32_, sname, __VA_ARGS__)
+#define ARCH_COMPAT_SYSCALL_DEFINE2_RET(ret, sname, ...) COMPAT_SYSCALL_DEFINEx(2, ret, sys32_, sname, __VA_ARGS__)
+#define ARCH_COMPAT_SYSCALL_DEFINE3_RET(ret, sname, ...) COMPAT_SYSCALL_DEFINEx(3, ret, sys32_, sname, __VA_ARGS__)
+#define ARCH_COMPAT_SYSCALL_DEFINE4_RET(ret, sname, ...) COMPAT_SYSCALL_DEFINEx(4, ret, sys32_, sname, __VA_ARGS__)
+#define ARCH_COMPAT_SYSCALL_DEFINE5_RET(ret, sname, ...) COMPAT_SYSCALL_DEFINEx(5, ret, sys32_, sname, __VA_ARGS__)
+#define ARCH_COMPAT_SYSCALL_DEFINE6_RET(ret, sname, ...) COMPAT_SYSCALL_DEFINEx(6, ret, sys32_, sname, __VA_ARGS__)
+
+#define COMPAT_SYSCALL_DEFINE0(sname) COMPAT_SYSCALL_DEFINE0_RET(long, compat_sys_, sname)
+#define COMPAT_SYSCALL_DEFINE1(sname, ...) COMPAT_SYSCALL_DEFINEx(1, long, compat_sys_, sname, __VA_ARGS__)
+#define COMPAT_SYSCALL_DEFINE2(sname, ...) COMPAT_SYSCALL_DEFINEx(2, long, compat_sys_, sname, __VA_ARGS__)
+#define COMPAT_SYSCALL_DEFINE3(sname, ...) COMPAT_SYSCALL_DEFINEx(3, long, compat_sys_, sname, __VA_ARGS__)
+#define COMPAT_SYSCALL_DEFINE4(sname, ...) COMPAT_SYSCALL_DEFINEx(4, long, compat_sys_, sname, __VA_ARGS__)
+#define COMPAT_SYSCALL_DEFINE5(sname, ...) COMPAT_SYSCALL_DEFINEx(5, long, compat_sys_, sname, __VA_ARGS__)
+#define COMPAT_SYSCALL_DEFINE6(sname, ...) COMPAT_SYSCALL_DEFINEx(6, long, compat_sys_, sname, __VA_ARGS__)
+
+#define COMPAT_SYSCALL_DEFINE0_RET(ret, sname) __COMPAT_SYSCALL_DEFINE0(ret, compat_sys_, sname)
+#define COMPAT_SYSCALL_DEFINE1_RET(ret, sname, ...) COMPAT_SYSCALL_DEFINEx(1, ret, compat_sys_, sname, __VA_ARGS__)
+#define COMPAT_SYSCALL_DEFINE2_RET(ret, sname, ...) COMPAT_SYSCALL_DEFINEx(2, ret, compat_sys_, sname, __VA_ARGS__)
+#define COMPAT_SYSCALL_DEFINE3_RET(ret, sname, ...) COMPAT_SYSCALL_DEFINEx(3, ret, compat_sys_, sname, __VA_ARGS__)
+#define COMPAT_SYSCALL_DEFINE4_RET(ret, sname, ...) COMPAT_SYSCALL_DEFINEx(4, ret, compat_sys_, sname, __VA_ARGS__)
+#define COMPAT_SYSCALL_DEFINE5_RET(ret, sname, ...) COMPAT_SYSCALL_DEFINEx(5, ret, compat_sys_, sname, __VA_ARGS__)
+#define COMPAT_SYSCALL_DEFINE6_RET(ret, sname, ...) COMPAT_SYSCALL_DEFINEx(6, ret, compat_sys_, sname, __VA_ARGS__)
+
+#define COMPAT_SYSCALL_DEFINEx(x, ret, prefix, sname, ...)		\
+	SYSCALL_METADATAx(prefix, sname, x, compat_syscall, __VA_ARGS__);\
+	asmlinkage ret SYSNAME(prefix, sname)(__SC_DECL##x(__VA_ARGS__))
+
+#define __COMPAT_SYSCALL_DEFINE0_RET(ret, prefix, sname)		\
+	SYSCALL_METADATA0(prefix, sname, compat_syscall)		\
+	asmlinkage ret SYSNAME(prefix, sname)()
 
 #endif /* CONFIG_COMPAT */
 
@@ -268,38 +270,38 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 #endif
 
 #define SYSCALL_DEFINEx(x, ret, sname, ...)				\
-	SYSCALL_METADATAx(sys##sname, sys##sname, x, syscall, __VA_ARGS__);\
+	SYSCALL_METADATAx(sys_, sname, x, syscall, __VA_ARGS__);	\
 	__SYSCALL_DEFINEx(x, ret, sname, __VA_ARGS__)
 
-#define SYSCALL_DEFINE0_RET(ret, name)					\
-	SYSCALL_METADATA0(sys_##name, name, syscall)			\
-	asmlinkage ret sys_##name(void)
+#define SYSCALL_DEFINE0_RET(ret, sname)					\
+	SYSCALL_METADATA0(sys_, sname, syscall)				\
+	asmlinkage ret sys_##sname(void)
 
 #ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
 
-#define SYSCALL_DEFINE(name, x, ...)					\
-	SYSCALL_METADATAx(sys_##name, sys_##name, x, syscall, __VA_ARGS__);\
-	static inline long SYSC_##name(__SC_DECL##x(__VA_ARGS__))
+#define SYSCALL_DEFINE(sname, x, ...)					\
+	SYSCALL_METADATAx(sys_, sname, x, syscall, __VA_ARGS__);	\
+	static inline long SYSC_##sname(__SC_DECL##x(__VA_ARGS__))
 
-#define __SYSCALL_DEFINEx(x, ret, name, ...)				\
-	asmlinkage ret sys##name(__SC_DECL##x(__VA_ARGS__));		\
-	static inline ret SYSC##name(__SC_DECL##x(__VA_ARGS__));	\
-	asmlinkage ret SyS##name(__SC_LONG##x(__VA_ARGS__))		\
+#define __SYSCALL_DEFINEx(x, ret, sname, ...)				\
+	asmlinkage ret sys_##sname(__SC_DECL##x(__VA_ARGS__));		\
+	static inline ret SYSC_##sname(__SC_DECL##x(__VA_ARGS__));	\
+	asmlinkage ret SyS_##sname(__SC_LONG##x(__VA_ARGS__))		\
 	{								\
 		__SC_TEST##x(__VA_ARGS__);				\
-		return (ret) SYSC##name(__SC_CAST##x(__VA_ARGS__));	\
+		return (ret) SYSC_##sname(__SC_CAST##x(__VA_ARGS__));	\
 	}								\
-	SYSCALL_ALIAS(sys##name, SyS##name);				\
-	static inline ret SYSC##name(__SC_DECL##x(__VA_ARGS__))
+	SYSCALL_ALIAS(sys_##sname, SyS_##sname);			\
+	static inline ret SYSC_##sname(__SC_DECL##x(__VA_ARGS__))
 
 #else /* CONFIG_HAVE_SYSCALL_WRAPPERS */
 
-#define SYSCALL_DEFINE(name, x, ...)					\
-	SYSCALL_METADATAx(sys_##name, sys_##name, x, syscall, __VA_ARGS__);\
-	asmlinkage long sys_##name(__SC_DECL##x(__VA_ARGS__))
+#define SYSCALL_DEFINE(sname, x, ...)					\
+	SYSCALL_METADATAx(sys_, sname, x, syscall, __VA_ARGS__);	\
+	asmlinkage long sys_##sname(__SC_DECL##x(__VA_ARGS__))
 
-#define __SYSCALL_DEFINEx(x, ret, name, ...)				\
-	asmlinkage ret sys##name(__SC_DECL##x(__VA_ARGS__))
+#define __SYSCALL_DEFINEx(x, ret, sname, ...)				\
+	asmlinkage ret sys_##sname(__SC_DECL##x(__VA_ARGS__))
 
 #endif /* CONFIG_HAVE_SYSCALL_WRAPPERS */
 
-- 
1.7.1

