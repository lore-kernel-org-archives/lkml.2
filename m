Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab1D1DT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 23:19:27 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35010 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab1D1DT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 23:19:26 -0400
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: kees.cook@canonical.com, eparis@redhat.com, agl@chromium.org,
        mingo@elte.hu, jmorris@namei.org, rostedt@goodmis.org,
        Will Drewry <wad@chromium.org>, Steven Rostedt <srostedt@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 6/7] include/linux/syscalls.h: add __ layer of macros with return types.
Date: Wed, 27 Apr 2011 22:08:50 -0500
Message-Id: <1303960136-14298-5-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1303960136-14298-1-git-send-email-wad@chromium.org>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change addresses two issues directly:
1. The inability for ftrace to hook system calls that don't return
   a long.
2. The fact that SYSCALL_DEFINE() does not touch ftrace at all

1 is fixed by adding __SYSCALL_DEFINEx/0 and __SYSCALL_TRACEx/0
macros which lay underneath the normal call,
SYSCALL_DEFINE0, and SYSCALL_DEFINE[1-6].  All existing calls will
continue to work normally and SYSCALL_DEFINE calls will become
ftrace-able but without argument inspection  support.

2 is addressed by separating out SYSCALL_TRACE0 and pulling it under
SYSCALL_DEFINE.  It means that calls that may lack argument
introspection will still be traceable in a binary way without any
additional code changes.

There are still some challenges for wrapping calls that have a
trampoline directly in the assembly, like the ptregs calls in
arch/x86/kernel (e.g., sys_clone).  Given that the arguments to the
function do not directly map to those of the system call, the main
macros are not friendly for use.  However, the SYSCALL_TRACE0 macro in
this change could be used as a placeholder (declared above the function
definition) to allow limited tracing functionality until a better
solution is presented.

Signed-off-by: Will Drewry <wad@chromium.org>
---
 include/linux/syscalls.h |   52 +++++++++++++++++++++++++++++++---------------
 1 files changed, 35 insertions(+), 17 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 83ecc17..1c4a3fb 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -171,7 +171,7 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	  __attribute__((section("__syscalls_metadata")))	\
 	 *__p_syscall_meta_##sname = &__syscall_meta_##sname;
 
-#define SYSCALL_DEFINE0(sname)					\
+#define __SYSCALL_TRACE0(linkage, ret, sname)			\
 	SYSCALL_TRACE_ENTER_EVENT(_##sname);			\
 	SYSCALL_TRACE_EXIT_EVENT(_##sname);			\
 	static struct syscall_metadata __used			\
@@ -185,12 +185,16 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	};							\
 	static struct syscall_metadata __used			\
 	  __attribute__((section("__syscalls_metadata")))	\
-	 *__p_syscall_meta_##sname = &__syscall_meta__##sname;	\
-	asmlinkage long sys_##sname(void)
+	 *__p_syscall_meta_##sname = &__syscall_meta__##sname;
 #else
-#define SYSCALL_DEFINE0(name)	   asmlinkage long sys_##name(void)
+#define __SYSCALL_TRACE0(linkage, ret, sname)
 #endif
 
+#define __SYSCALL_DEFINE0(linkage, ret, sname)			\
+	__SYSCALL_TRACE0(linkage, ret, sname)			\
+	linkage ret sys_##sname(void)
+
+#define SYSCALL_DEFINE0(name) __SYSCALL_DEFINE0(asmlinkage, long, name)
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
 #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
@@ -214,39 +218,53 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 
 #ifdef CONFIG_FTRACE_SYSCALLS
 #define SYSCALL_DEFINEx(x, sname, ...)				\
+	__SYSCALL_DEFINEx(asmlinkage, long, x, sname, __VA_ARGS__)
+
+#define __SYSCALL_TRACEx(linkage, ret, x, sname, ...)	\
 	static const char *types_##sname[] = {			\
 		__SC_STR_TDECL##x(__VA_ARGS__)			\
 	};							\
 	static const char *args_##sname[] = {			\
 		__SC_STR_ADECL##x(__VA_ARGS__)			\
 	};							\
-	SYSCALL_METADATA(sname, x);				\
-	__SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
+	SYSCALL_METADATA(sname, x);				
 #else
 #define SYSCALL_DEFINEx(x, sname, ...)				\
-	__SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
+	__SYSCALL_DEFINEx(asmlinkage, long, x, sname, __VA_ARGS__)
+#define __SYSCALL_TRACEx(linkage, ret, x, sname, ...)
 #endif
 
 #ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
 
-#define SYSCALL_DEFINE(name) static inline long SYSC_##name
-
-#define __SYSCALL_DEFINEx(x, name, ...)					\
-	asmlinkage long sys##name(__SC_DECL##x(__VA_ARGS__));		\
-	static inline long SYSC##name(__SC_DECL##x(__VA_ARGS__));	\
-	asmlinkage long SyS##name(__SC_LONG##x(__VA_ARGS__))		\
+#define SYSCALL_DEFINE(name)						\
+	__SYSCALL_DEFINE(long, name)
+#define __SYSCALL_DEFINE(ret, name)				\
+	__SYSCALL_TRACE0(, ret, name)
+	static inline ret SYSC_##name
+
+#define __SYSCALL_DEFINEx(linkage, ret, x, name, ...)			\
+	__SYSCALL_TRACEx(linkage, ret, x, name, __VA_ARGS__)		\
+	linkage ret sys##name(__SC_DECL##x(__VA_ARGS__));		\
+	static inline ret SYSC##name(__SC_DECL##x(__VA_ARGS__));	\
+	linkage ret SyS##name(__SC_LONG##x(__VA_ARGS__))		\
 	{								\
 		__SC_TEST##x(__VA_ARGS__);				\
-		return (long) SYSC##name(__SC_CAST##x(__VA_ARGS__));	\
+		return (ret) SYSC##name(__SC_CAST##x(__VA_ARGS__));	\
 	}								\
 	SYSCALL_ALIAS(sys##name, SyS##name);				\
-	static inline long SYSC##name(__SC_DECL##x(__VA_ARGS__))
+	static inline ret SYSC##name(__SC_DECL##x(__VA_ARGS__))
 
 #else /* CONFIG_HAVE_SYSCALL_WRAPPERS */
 
-#define SYSCALL_DEFINE(name) asmlinkage long sys_##name
-#define __SYSCALL_DEFINEx(x, name, ...)					\
-	asmlinkage long sys##name(__SC_DECL##x(__VA_ARGS__))
+#define SYSCALL_DEFINE(name)						\
+	__SYSCALL_DEFINE(asmlinkage, long, name)
+#define __SYSCALL_DEFINE(linkage, ret, name)				\
+	__SYSCALL_TRACE0(linkage, ret, name)				\
+	linkage ret sys_##name
+
+#define __SYSCALL_DEFINEx(linkage, ret, x, name, ...)			\
+	__SYSCALL_TRACEx(linkage, ret, x, name, __VA_ARGS__)		\
+	linkage ret sys##name(__SC_DECL##x(__VA_ARGS__))
 
 #endif /* CONFIG_HAVE_SYSCALL_WRAPPERS */
 
-- 
1.7.0.4

