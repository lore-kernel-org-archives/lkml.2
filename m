Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab0FWKEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:04:34 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:37772 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab0FWKEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:04:31 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Jason Baron <jbaron@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 25/40] trace syscalls: Refactor syscall metadata creation
Date: Wed, 23 Jun 2010 20:03:06 +1000
Message-Id: <1277287401-28571-26-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

The syscall metadata creation macros are a bit convoluted with some
duplicated code - particularly the duplication in SYSCALL_DEFINE0 with
SYSCALL_METADATA and related macros.

As demonstrated by the compat syscalls, there may be needs to introduce
additional high level *_SYSCALL_DEFINE[0-6] macros with subtle
differences from the existing ones. This patch aims to make the macros
more atomic, move more of the complexity of the macros down, and remove
some duplicated code without changing existing functionality so that
defining new high level macros is easier.

In particular, certain system calls on PowerPC access the state of the
registers, through the use of some assembly that places the registers on
the stack in the place of the 7th argument to the function. These system
calls require specialised macros to record their metadata and this patch
greatly simplifies their implementation.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 include/linux/syscalls.h |   77 ++++++++++++++++------------------------------
 1 files changed, 27 insertions(+), 50 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 55a9f2b..a608565 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -153,7 +153,7 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 		.data			= (void *)&__syscall_meta_##sname,\
 	}
 
-#define SYSCALL_METADATA(rname, sname, nb, event_class)		\
+#define SYSCALL_METADATA(rname, sname, nb, event_class, stypes, sargs)\
 	SYSCALL_TRACE_ENTER_EVENT(sname, event_class);		\
 	SYSCALL_TRACE_EXIT_EVENT(sname, event_class);		\
 	static struct syscall_metadata __used			\
@@ -162,9 +162,10 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	  __syscall_meta_##sname = {				\
 		.name 		= #rname,			\
 		.syscall_nr	= -1,	/* Filled in at boot */	\
+		.compat_syscall_nr = -1,/* Filled in at boot */	\
 		.nb_args 	= nb,				\
-		.types		= types_##sname,		\
-		.args		= args_##sname,			\
+		.types		= stypes,			\
+		.args		= sargs,			\
 		.ftrace_enter	= 0,				\
 		.ftrace_exit	= 0,				\
 		.perf_enter	= 0,				\
@@ -175,29 +176,22 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 		.exit_fields	= LIST_HEAD_INIT(__syscall_meta_##sname.exit_fields), \
 	};
 
-#define SYSCALL_DEFINE0(sname)					\
-	SYSCALL_TRACE_ENTER_EVENT(sys_##sname, syscall);	\
-	SYSCALL_TRACE_EXIT_EVENT(sys_##sname, syscall);		\
-	static struct syscall_metadata __used			\
-	  __attribute__((__aligned__(4)))			\
-	  __attribute__((section("__syscalls_metadata")))	\
-	  __syscall_meta_sys_##sname = {			\
-		.name 		= "sys_"#sname,			\
-		.syscall_nr	= -1,	/* Filled in at boot */	\
-		.nb_args 	= 0,				\
-		.ftrace_enter	= 0,				\
-		.ftrace_exit	= 0,				\
-		.perf_enter	= 0,				\
-		.perf_exit	= 0,				\
-		.enter_event	= &event_enter_sys_##sname,	\
-		.exit_event	= &event_exit_sys_##sname,	\
-		.enter_fields	= LIST_HEAD_INIT(__syscall_meta__##sname.enter_fields), \
-		.exit_fields	= LIST_HEAD_INIT(__syscall_meta__##sname.exit_fields), \
+#define SYSCALL_METADATAx(rname, sname, nb, event_class, ...)	\
+	static const char *types_##sname[] = {			\
+		__SC_STR_TDECL##nb(__VA_ARGS__)			\
 	};							\
-	asmlinkage long sys_##sname(void)
-#else
-#define SYSCALL_DEFINE0(name)	   asmlinkage long sys_##name(void)
-#endif
+	static const char *args_##sname[] = {			\
+		__SC_STR_ADECL##nb(__VA_ARGS__)			\
+	};							\
+	SYSCALL_METADATA(rname, sname, nb, event_class, types_##sname, args_##sname)
+
+#define SYSCALL_METADATA0(rname, sname, event_class)			\
+	SYSCALL_METADATA(rname, sname, 0, event_class, NULL, NULL)
+
+#else /* !CONFIG_FTRACE_SYSCALLS */
+#define SYSCALL_METADATAx(...)
+#define SYSCALL_METADATA0(...)
+#endif /* CONFIG_FTRACE_SYSCALLS */
 
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
@@ -222,22 +216,12 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 #define COMPAT_SYSCALL_DEFINE5(name, ...) COMPAT_SYSCALL_DEFINEx(5, compat_sys_##name, name, __VA_ARGS__)
 #define COMPAT_SYSCALL_DEFINE6(name, ...) COMPAT_SYSCALL_DEFINEx(6, compat_sys_##name, name, __VA_ARGS__)
 
-#ifdef CONFIG_COMPAT_FTRACE_SYSCALLS
 #define COMPAT_SYSCALL_DEFINEx(x, syscall, sname, ...)			\
-	static const char *types_compat_sys_##sname[] = {		\
-		__SC_STR_TDECL##x(__VA_ARGS__)				\
-	};								\
-	static const char *args_compat_sys_##sname[] = {		\
-		__SC_STR_ADECL##x(__VA_ARGS__)				\
-	};								\
-	SYSCALL_METADATA(syscall, compat_sys_##sname, x, compat_syscall);\
+	SYSCALL_METADATAx(syscall, compat_sys_##sname, x, compat_syscall, __VA_ARGS__);\
 	asmlinkage long syscall(__SC_DECL##x(__VA_ARGS__))
-#else
-#define COMPAT_SYSCALL_DEFINEx(x, syscall, sname, ...)			\
-	asmlinkage long syscall(__SC_DECL##x(__VA_ARGS__))
-#endif
 
-#endif
+#endif /* CONFIG_COMPAT */
+
 
 #ifdef CONFIG_PPC64
 #define SYSCALL_ALIAS(alias, name)					\
@@ -253,20 +237,13 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 #endif
 #endif
 
-#ifdef CONFIG_FTRACE_SYSCALLS
-#define SYSCALL_DEFINEx(x, sname, ...)				\
-	static const char *types_sys##sname[] = {		\
-		__SC_STR_TDECL##x(__VA_ARGS__)			\
-	};							\
-	static const char *args_sys##sname[] = {		\
-		__SC_STR_ADECL##x(__VA_ARGS__)			\
-	};							\
-	SYSCALL_METADATA(sys##sname, sys##sname, x, syscall);	\
-	__SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
-#else
 #define SYSCALL_DEFINEx(x, sname, ...)				\
+	SYSCALL_METADATAx(sys##sname, sys##sname, x, syscall, __VA_ARGS__);\
 	__SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
-#endif
+
+#define SYSCALL_DEFINE0(name)					\
+	SYSCALL_METADATA0(sys_##name, name, syscall)		\
+	asmlinkage long sys_##name(void)
 
 #ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
 
-- 
1.7.1

