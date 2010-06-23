Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab0FWKKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:10:47 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:50567 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab0FWKEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:04:24 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Jason Baron <jbaron@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH 17/40] tracing: make a "compat_syscalls" tracing subsys
Date: Wed, 23 Jun 2010 20:02:58 +1000
Message-Id: <1277287401-28571-18-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

Create a new "compat_syscalls" subsys for tracing

Signed-off-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 include/linux/syscalls.h      |   40 +++++++++++++++++++++-------------------
 kernel/trace/trace_syscalls.c |   16 ++++++++++++++++
 2 files changed, 37 insertions(+), 19 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index a7d1114..e115569 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -120,10 +120,12 @@ struct perf_event_attr;
 
 extern struct ftrace_event_class event_class_syscall_enter;
 extern struct ftrace_event_class event_class_syscall_exit;
+extern struct ftrace_event_class event_class_compat_syscall_enter;
+extern struct ftrace_event_class event_class_compat_syscall_exit;
 extern struct trace_event_functions enter_syscall_print_funcs;
 extern struct trace_event_functions exit_syscall_print_funcs;
 
-#define SYSCALL_TRACE_ENTER_EVENT(sname)				\
+#define SYSCALL_TRACE_ENTER_EVENT(sname, event_class)			\
 	static struct syscall_metadata __syscall_meta_##sname;		\
 	static struct ftrace_event_call					\
 	__attribute__((__aligned__(4))) event_enter_##sname;		\
@@ -132,12 +134,12 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	  __attribute__((section("_ftrace_events")))			\
 	  event_enter_##sname = {					\
 		.name                   = "enter_"#sname,		\
-		.class			= &event_class_syscall_enter,	\
+		.class			= &event_class_##event_class##_enter,\
 		.event.funcs            = &enter_syscall_print_funcs,	\
 		.data			= (void *)&__syscall_meta_##sname,\
 	}
 
-#define SYSCALL_TRACE_EXIT_EVENT(sname)					\
+#define SYSCALL_TRACE_EXIT_EVENT(sname, event_class)			\
 	static struct syscall_metadata __syscall_meta_##sname;		\
 	static struct ftrace_event_call					\
 	__attribute__((__aligned__(4))) event_exit_##sname;		\
@@ -146,14 +148,14 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	  __attribute__((section("_ftrace_events")))			\
 	  event_exit_##sname = {					\
 		.name                   = "exit_"#sname,		\
-		.class			= &event_class_syscall_exit,	\
+		.class			= &event_class_##event_class##_exit,\
 		.event.funcs		= &exit_syscall_print_funcs,	\
 		.data			= (void *)&__syscall_meta_##sname,\
 	}
 
-#define SYSCALL_METADATA(rname, sname, nb)			\
-	SYSCALL_TRACE_ENTER_EVENT(sname);			\
-	SYSCALL_TRACE_EXIT_EVENT(sname);			\
+#define SYSCALL_METADATA(rname, sname, nb, event_class)		\
+	SYSCALL_TRACE_ENTER_EVENT(sname, event_class);		\
+	SYSCALL_TRACE_EXIT_EVENT(sname, event_class);		\
 	static struct syscall_metadata __used			\
 	  __attribute__((__aligned__(4)))			\
 	  __attribute__((section("__syscalls_metadata")))	\
@@ -174,8 +176,8 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	};
 
 #define SYSCALL_DEFINE0(sname)					\
-	SYSCALL_TRACE_ENTER_EVENT(sys_##sname);			\
-	SYSCALL_TRACE_EXIT_EVENT(sys_##sname);			\
+	SYSCALL_TRACE_ENTER_EVENT(sys_##sname, syscall);	\
+	SYSCALL_TRACE_EXIT_EVENT(sys_##sname, syscall);		\
 	static struct syscall_metadata __used			\
 	  __attribute__((__aligned__(4)))			\
 	  __attribute__((section("__syscalls_metadata")))	\
@@ -221,17 +223,17 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 #define COMPAT_SYSCALL_DEFINE6(name, ...) COMPAT_SYSCALL_DEFINEx(6, compat_sys_##name, name, __VA_ARGS__)
 
 #ifdef CONFIG_FTRACE_SYSCALLS
-#define COMPAT_SYSCALL_DEFINEx(x, syscall, sname, ...)		\
-	static const char *types_compat_sys_##sname[] = {	\
-		__SC_STR_TDECL##x(__VA_ARGS__)			\
-	};							\
-	static const char *args_compat_sys_##sname[] = {	\
-		__SC_STR_ADECL##x(__VA_ARGS__)			\
-	};							\
-	SYSCALL_METADATA(syscall, compat_sys_##sname, x);	\
+#define COMPAT_SYSCALL_DEFINEx(x, syscall, sname, ...)			\
+	static const char *types_compat_sys_##sname[] = {		\
+		__SC_STR_TDECL##x(__VA_ARGS__)				\
+	};								\
+	static const char *args_compat_sys_##sname[] = {		\
+		__SC_STR_ADECL##x(__VA_ARGS__)				\
+	};								\
+	SYSCALL_METADATA(syscall, compat_sys_##sname, x, compat_syscall);\
 	asmlinkage long syscall(__SC_DECL##x(__VA_ARGS__))
 #else
-#define COMPAT_SYSCALL_DEFINEx(x, syscall, sname, ...)		\
+#define COMPAT_SYSCALL_DEFINEx(x, syscall, sname, ...)			\
 	asmlinkage long syscall(__SC_DECL##x(__VA_ARGS__))
 #endif
 
@@ -259,7 +261,7 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	static const char *args_sys##sname[] = {		\
 		__SC_STR_ADECL##x(__VA_ARGS__)			\
 	};							\
-	SYSCALL_METADATA(sys##sname, sys##sname, x);		\
+	SYSCALL_METADATA(sys##sname, sys##sname, x, syscall);	\
 	__SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
 #else
 #define SYSCALL_DEFINEx(x, sname, ...)				\
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index d910cba..ff6cd7a 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -62,6 +62,22 @@ struct ftrace_event_class event_class_syscall_exit = {
 	.raw_init		= init_syscall_trace,
 };
 
+struct ftrace_event_class event_class_compat_syscall_enter = {
+	.system			= "compat_syscalls",
+	.reg			= syscall_enter_register,
+	.define_fields		= syscall_enter_define_fields,
+	.get_fields		= syscall_get_enter_fields,
+	.raw_init		= init_syscall_trace,
+};
+
+struct ftrace_event_class event_class_compat_syscall_exit = {
+	.system			= "compat_syscalls",
+	.reg			= syscall_exit_register,
+	.define_fields		= syscall_exit_define_fields,
+	.get_fields		= syscall_get_exit_fields,
+	.raw_init		= init_syscall_trace,
+};
+
 extern unsigned long __start_syscalls_metadata[];
 extern unsigned long __stop_syscalls_metadata[];
 
-- 
1.7.1

