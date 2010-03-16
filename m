Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938167Ab0CPRrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 13:47:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938143Ab0CPRrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:47:33 -0400
Date: Tue, 16 Mar 2010 13:47:16 -0400
From: Jason Baron <jbaron@redhat.com>
To: fweisbec@gmail.com, mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com,
       hpa@zytor.com, tglx@linutronix.de, mhiramat@redhat.com,
       heiko.carstens@de.ibm.com, benh@kernel.crashing.org,
       davem@davemloft.net, lethal@linux-sh.org, schwidefsky@de.ibm.com,
       brueckner@linux.vnet.ibm.com, tony.luck@intel.com
Message-Id: <480e19e0b30c412a77f5030ad6c2bd350819bd12.1268749695.git.jbaron@redhat.com>
In-Reply-To: <cover.1268749695.git.jbaron@redhat.com>
References: <cover.1268749695.git.jbaron@redhat.com>
Subject: [PATCH 14/14] tracing: make a "compat_syscalls" tracing subsys
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a new "compat_syscalls" subsys for tracing

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/syscalls.h |   38 +++++++++++++++++++-------------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 501cd46..94caf73 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -128,7 +128,7 @@ struct perf_event_attr;
 #define __SC_STR_TDECL5(t, a, ...)	#t, __SC_STR_TDECL4(__VA_ARGS__)
 #define __SC_STR_TDECL6(t, a, ...)	#t, __SC_STR_TDECL5(__VA_ARGS__)
 
-#define SYSCALL_TRACE_ENTER_EVENT(sname)				\
+#define SYSCALL_TRACE_ENTER_EVENT(sname, subsys)			\
 	static const struct syscall_metadata __syscall_meta_##sname;	\
 	static struct ftrace_event_call					\
 	__attribute__((__aligned__(4))) event_enter_##sname;		\
@@ -140,7 +140,7 @@ struct perf_event_attr;
 	  __attribute__((section("_ftrace_events")))			\
 	  event_enter_##sname = {					\
 		.name                   = "enter_"#sname,		\
-		.system                 = "syscalls",			\
+		.system                 = #subsys,			\
 		.event                  = &enter_syscall_print_##sname,	\
 		.raw_init		= init_syscall_trace,		\
 		.define_fields		= syscall_enter_define_fields,	\
@@ -150,7 +150,7 @@ struct perf_event_attr;
 		TRACE_SYS_ENTER_PROFILE_INIT				\
 	}
 
-#define SYSCALL_TRACE_EXIT_EVENT(sname)					\
+#define SYSCALL_TRACE_EXIT_EVENT(sname, subsys)			\
 	static const struct syscall_metadata __syscall_meta_##sname;	\
 	static struct ftrace_event_call					\
 	__attribute__((__aligned__(4))) event_exit_##sname;		\
@@ -162,7 +162,7 @@ struct perf_event_attr;
 	  __attribute__((section("_ftrace_events")))			\
 	  event_exit_##sname = {					\
 		.name                   = "exit_"#sname,		\
-		.system                 = "syscalls",			\
+		.system                 = #subsys,			\
 		.event                  = &exit_syscall_print_##sname,	\
 		.raw_init		= init_syscall_trace,		\
 		.define_fields		= syscall_exit_define_fields,	\
@@ -172,9 +172,9 @@ struct perf_event_attr;
 		TRACE_SYS_EXIT_PROFILE_INIT				\
 	}
 
-#define SYSCALL_METADATA(rname, sname, nb)			\
-	SYSCALL_TRACE_ENTER_EVENT(sname);			\
-	SYSCALL_TRACE_EXIT_EVENT(sname);			\
+#define SYSCALL_METADATA(rname, sname, nb, subsys)		\
+	SYSCALL_TRACE_ENTER_EVENT(sname, subsys);		\
+	SYSCALL_TRACE_EXIT_EVENT(sname, subsys);		\
 	static const struct syscall_metadata __used		\
 	  __attribute__((__aligned__(4)))			\
 	  __attribute__((section("__syscalls_metadata")))	\
@@ -192,8 +192,8 @@ struct perf_event_attr;
 	};
 
 #define SYSCALL_DEFINE0(sname)					\
-	SYSCALL_TRACE_ENTER_EVENT(sys_##sname);			\
-	SYSCALL_TRACE_EXIT_EVENT(sys_##sname);			\
+	SYSCALL_TRACE_ENTER_EVENT(sys_##sname, syscalls);	\
+	SYSCALL_TRACE_EXIT_EVENT(sys_##sname, syscalls);	\
 	static const struct syscall_metadata __used		\
 	  __attribute__((__aligned__(4)))			\
 	  __attribute__((section("__syscalls_metadata")))	\
@@ -236,17 +236,17 @@ struct perf_event_attr;
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
+	SYSCALL_METADATA(syscall, compat_sys_##sname, x, compat_syscalls);\
 	asmlinkage long syscall(__SC_DECL##x(__VA_ARGS__))
 #else
-#define COMPAT_SYSCALL_DEFINEx(x, sname, ...)			\
+#define COMPAT_SYSCALL_DEFINEx(x, sname, ...)				\
 	asmlinkage long syscall(__SC_DECL##x(__VA_ARGS__))
 #endif
 
@@ -274,7 +274,7 @@ struct perf_event_attr;
 	static const char *args_sys##sname[] = {		\
 		__SC_STR_ADECL##x(__VA_ARGS__)			\
 	};							\
-	SYSCALL_METADATA(sys##sname, sys##sname, x);		\
+	SYSCALL_METADATA(sys##sname, sys##sname, x, syscalls);	\
 	__SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
 #else
 #define SYSCALL_DEFINEx(x, sname, ...)				\
-- 
1.6.5.1

