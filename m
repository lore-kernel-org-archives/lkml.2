Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab0FWKEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:04:45 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:50630 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab0FWKEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:04:42 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Jason Baron <jbaron@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 33/40] trace syscalls: Infrastructure for syscalls different return types
Date: Wed, 23 Jun 2010 20:03:14 +1000
Message-Id: <1277287401-28571-34-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

A number of syscalls have return types other than long, which the
existing SYSCALL_DEFINE macros assumed. This patch adds aditional macros
that specify the return types (semantics of existing high level macros are
unchanged) for use with system calls with other return types.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 include/linux/syscalls.h |  102 +++++++++++++++++++++++++++++-----------------
 1 files changed, 64 insertions(+), 38 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index d7eaa4b..0cef707 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -193,36 +193,62 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 #define SYSCALL_METADATA0(...)
 #endif /* CONFIG_FTRACE_SYSCALLS */
 
-#define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
-#define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
-#define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
-#define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
-#define SYSCALL_DEFINE5(name, ...) SYSCALL_DEFINEx(5, _##name, __VA_ARGS__)
-#define SYSCALL_DEFINE6(name, ...) SYSCALL_DEFINEx(6, _##name, __VA_ARGS__)
+#define SYSCALL_DEFINE0(name) SYSCALL_DEFINE0_RET(long, name)
+#define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, long, _##name, __VA_ARGS__)
+#define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, long, _##name, __VA_ARGS__)
+#define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, long, _##name, __VA_ARGS__)
+#define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, long, _##name, __VA_ARGS__)
+#define SYSCALL_DEFINE5(name, ...) SYSCALL_DEFINEx(5, long, _##name, __VA_ARGS__)
+#define SYSCALL_DEFINE6(name, ...) SYSCALL_DEFINEx(6, long, _##name, __VA_ARGS__)
+
+#define SYSCALL_DEFINE1_RET(ret, name, ...) SYSCALL_DEFINEx(1, ret, _##name, __VA_ARGS__)
+#define SYSCALL_DEFINE2_RET(ret, name, ...) SYSCALL_DEFINEx(2, ret, _##name, __VA_ARGS__)
+#define SYSCALL_DEFINE3_RET(ret, name, ...) SYSCALL_DEFINEx(3, ret, _##name, __VA_ARGS__)
+#define SYSCALL_DEFINE4_RET(ret, name, ...) SYSCALL_DEFINEx(4, ret, _##name, __VA_ARGS__)
+#define SYSCALL_DEFINE5_RET(ret, name, ...) SYSCALL_DEFINEx(5, ret, _##name, __VA_ARGS__)
+#define SYSCALL_DEFINE6_RET(ret, name, ...) SYSCALL_DEFINEx(6, ret, _##name, __VA_ARGS__)
 
 #ifdef CONFIG_COMPAT
 
-#define ARCH_COMPAT_SYSCALL_DEFINE1(name, ...) COMPAT_SYSCALL_DEFINEx(1, sys32_##name, name, __VA_ARGS__)
-#define ARCH_COMPAT_SYSCALL_DEFINE2(name, ...) COMPAT_SYSCALL_DEFINEx(2, sys32_##name, name, __VA_ARGS__)
-#define ARCH_COMPAT_SYSCALL_DEFINE3(name, ...) COMPAT_SYSCALL_DEFINEx(3, sys32_##name, name, __VA_ARGS__)
-#define ARCH_COMPAT_SYSCALL_DEFINE4(name, ...) COMPAT_SYSCALL_DEFINEx(4, sys32_##name, name, __VA_ARGS__)
-#define ARCH_COMPAT_SYSCALL_DEFINE5(name, ...) COMPAT_SYSCALL_DEFINEx(5, sys32_##name, name, __VA_ARGS__)
-#define ARCH_COMPAT_SYSCALL_DEFINE6(name, ...) COMPAT_SYSCALL_DEFINEx(6, sys32_##name, name, __VA_ARGS__)
-
-#define COMPAT_SYSCALL_DEFINE1(name, ...) COMPAT_SYSCALL_DEFINEx(1, compat_sys_##name, name, __VA_ARGS__)
-#define COMPAT_SYSCALL_DEFINE2(name, ...) COMPAT_SYSCALL_DEFINEx(2, compat_sys_##name, name, __VA_ARGS__)
-#define COMPAT_SYSCALL_DEFINE3(name, ...) COMPAT_SYSCALL_DEFINEx(3, compat_sys_##name, name, __VA_ARGS__)
-#define COMPAT_SYSCALL_DEFINE4(name, ...) COMPAT_SYSCALL_DEFINEx(4, compat_sys_##name, name, __VA_ARGS__)
-#define COMPAT_SYSCALL_DEFINE5(name, ...) COMPAT_SYSCALL_DEFINEx(5, compat_sys_##name, name, __VA_ARGS__)
-#define COMPAT_SYSCALL_DEFINE6(name, ...) COMPAT_SYSCALL_DEFINEx(6, compat_sys_##name, name, __VA_ARGS__)
-
-#define COMPAT_SYSCALL_DEFINEx(x, syscall, sname, ...)			\
+#define ARCH_COMPAT_SYSCALL_DEFINE0(name) COMPAT_SYSCALL_DEFINE0_RET(long, sys32_##name, name)
+#define ARCH_COMPAT_SYSCALL_DEFINE1(name, ...) COMPAT_SYSCALL_DEFINEx(1, long, sys32_##name, name, __VA_ARGS__)
+#define ARCH_COMPAT_SYSCALL_DEFINE2(name, ...) COMPAT_SYSCALL_DEFINEx(2, long, sys32_##name, name, __VA_ARGS__)
+#define ARCH_COMPAT_SYSCALL_DEFINE3(name, ...) COMPAT_SYSCALL_DEFINEx(3, long, sys32_##name, name, __VA_ARGS__)
+#define ARCH_COMPAT_SYSCALL_DEFINE4(name, ...) COMPAT_SYSCALL_DEFINEx(4, long, sys32_##name, name, __VA_ARGS__)
+#define ARCH_COMPAT_SYSCALL_DEFINE5(name, ...) COMPAT_SYSCALL_DEFINEx(5, long, sys32_##name, name, __VA_ARGS__)
+#define ARCH_COMPAT_SYSCALL_DEFINE6(name, ...) COMPAT_SYSCALL_DEFINEx(6, long, sys32_##name, name, __VA_ARGS__)
+
+#define ARCH_COMPAT_SYSCALL_DEFINE0_RET(ret, name) COMPAT_SYSCALL_DEFINE0_RET(0, ret, sys32_##name, name)
+#define ARCH_COMPAT_SYSCALL_DEFINE1_RET(ret, name, ...) COMPAT_SYSCALL_DEFINEx(1, ret, sys32_##name, name, __VA_ARGS__)
+#define ARCH_COMPAT_SYSCALL_DEFINE2_RET(ret, name, ...) COMPAT_SYSCALL_DEFINEx(2, ret, sys32_##name, name, __VA_ARGS__)
+#define ARCH_COMPAT_SYSCALL_DEFINE3_RET(ret, name, ...) COMPAT_SYSCALL_DEFINEx(3, ret, sys32_##name, name, __VA_ARGS__)
+#define ARCH_COMPAT_SYSCALL_DEFINE4_RET(ret, name, ...) COMPAT_SYSCALL_DEFINEx(4, ret, sys32_##name, name, __VA_ARGS__)
+#define ARCH_COMPAT_SYSCALL_DEFINE5_RET(ret, name, ...) COMPAT_SYSCALL_DEFINEx(5, ret, sys32_##name, name, __VA_ARGS__)
+#define ARCH_COMPAT_SYSCALL_DEFINE6_RET(ret, name, ...) COMPAT_SYSCALL_DEFINEx(6, ret, sys32_##name, name, __VA_ARGS__)
+
+#define COMPAT_SYSCALL_DEFINE0(name) COMPAT_SYSCALL_DEFINE0_RET(long, compat_sys_##name, name)
+#define COMPAT_SYSCALL_DEFINE1(name, ...) COMPAT_SYSCALL_DEFINEx(1, long, compat_sys_##name, name, __VA_ARGS__)
+#define COMPAT_SYSCALL_DEFINE2(name, ...) COMPAT_SYSCALL_DEFINEx(2, long, compat_sys_##name, name, __VA_ARGS__)
+#define COMPAT_SYSCALL_DEFINE3(name, ...) COMPAT_SYSCALL_DEFINEx(3, long, compat_sys_##name, name, __VA_ARGS__)
+#define COMPAT_SYSCALL_DEFINE4(name, ...) COMPAT_SYSCALL_DEFINEx(4, long, compat_sys_##name, name, __VA_ARGS__)
+#define COMPAT_SYSCALL_DEFINE5(name, ...) COMPAT_SYSCALL_DEFINEx(5, long, compat_sys_##name, name, __VA_ARGS__)
+#define COMPAT_SYSCALL_DEFINE6(name, ...) COMPAT_SYSCALL_DEFINEx(6, long, compat_sys_##name, name, __VA_ARGS__)
+
+#define COMPAT_SYSCALL_DEFINE0_RET(ret, name) __COMPAT_SYSCALL_DEFINE0(ret, compat_sys_##name, name)
+#define COMPAT_SYSCALL_DEFINE1_RET(ret, name, ...) COMPAT_SYSCALL_DEFINEx(1, ret, compat_sys_##name, name, __VA_ARGS__)
+#define COMPAT_SYSCALL_DEFINE2_RET(ret, name, ...) COMPAT_SYSCALL_DEFINEx(2, ret, compat_sys_##name, name, __VA_ARGS__)
+#define COMPAT_SYSCALL_DEFINE3_RET(ret, name, ...) COMPAT_SYSCALL_DEFINEx(3, ret, compat_sys_##name, name, __VA_ARGS__)
+#define COMPAT_SYSCALL_DEFINE4_RET(ret, name, ...) COMPAT_SYSCALL_DEFINEx(4, ret, compat_sys_##name, name, __VA_ARGS__)
+#define COMPAT_SYSCALL_DEFINE5_RET(ret, name, ...) COMPAT_SYSCALL_DEFINEx(5, ret, compat_sys_##name, name, __VA_ARGS__)
+#define COMPAT_SYSCALL_DEFINE6_RET(ret, name, ...) COMPAT_SYSCALL_DEFINEx(6, ret, compat_sys_##name, name, __VA_ARGS__)
+
+#define COMPAT_SYSCALL_DEFINEx(x, ret, syscall, sname, ...)		\
 	SYSCALL_METADATAx(syscall, compat_sys_##sname, x, compat_syscall, __VA_ARGS__);\
-	asmlinkage long syscall(__SC_DECL##x(__VA_ARGS__))
+	asmlinkage ret syscall(__SC_DECL##x(__VA_ARGS__))
 
-#define COMPAT_SYSCALL_DEFINE0(name)					\
-	SYSCALL_METADATA0(compat_sys_##name, name, compat_syscall)	\
-	asmlinkage long compat_sys_##name()
+#define __COMPAT_SYSCALL_DEFINE0_RET(ret, syscall, name)		\
+	SYSCALL_METADATA0(syscall, name, compat_syscall)		\
+	asmlinkage ret syscall()
 
 #endif /* CONFIG_COMPAT */
 
@@ -241,13 +267,13 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 #endif
 #endif
 
-#define SYSCALL_DEFINEx(x, sname, ...)				\
+#define SYSCALL_DEFINEx(x, ret, sname, ...)				\
 	SYSCALL_METADATAx(sys##sname, sys##sname, x, syscall, __VA_ARGS__);\
-	__SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
+	__SYSCALL_DEFINEx(x, ret, sname, __VA_ARGS__)
 
-#define SYSCALL_DEFINE0(name)					\
-	SYSCALL_METADATA0(sys_##name, name, syscall)		\
-	asmlinkage long sys_##name(void)
+#define SYSCALL_DEFINE0_RET(ret, name)					\
+	SYSCALL_METADATA0(sys_##name, name, syscall)			\
+	asmlinkage ret sys_##name(void)
 
 #ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
 
@@ -255,16 +281,16 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	SYSCALL_METADATAx(sys_##name, sys_##name, x, syscall, __VA_ARGS__);\
 	static inline long SYSC_##name(__SC_DECL##x(__VA_ARGS__))
 
-#define __SYSCALL_DEFINEx(x, name, ...)					\
-	asmlinkage long sys##name(__SC_DECL##x(__VA_ARGS__));		\
-	static inline long SYSC##name(__SC_DECL##x(__VA_ARGS__));	\
-	asmlinkage long SyS##name(__SC_LONG##x(__VA_ARGS__))		\
+#define __SYSCALL_DEFINEx(x, ret, name, ...)				\
+	asmlinkage ret sys##name(__SC_DECL##x(__VA_ARGS__));		\
+	static inline ret SYSC##name(__SC_DECL##x(__VA_ARGS__));	\
+	asmlinkage ret SyS##name(__SC_LONG##x(__VA_ARGS__))		\
 	{								\
 		__SC_TEST##x(__VA_ARGS__);				\
-		return (long) SYSC##name(__SC_CAST##x(__VA_ARGS__));	\
+		return (ret) SYSC##name(__SC_CAST##x(__VA_ARGS__));	\
 	}								\
 	SYSCALL_ALIAS(sys##name, SyS##name);				\
-	static inline long SYSC##name(__SC_DECL##x(__VA_ARGS__))
+	static inline ret SYSC##name(__SC_DECL##x(__VA_ARGS__))
 
 #else /* CONFIG_HAVE_SYSCALL_WRAPPERS */
 
@@ -272,8 +298,8 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	SYSCALL_METADATAx(sys_##name, sys_##name, x, syscall, __VA_ARGS__);\
 	asmlinkage long sys_##name(__SC_DECL##x(__VA_ARGS__))
 
-#define __SYSCALL_DEFINEx(x, name, ...)					\
-	asmlinkage long sys##name(__SC_DECL##x(__VA_ARGS__))
+#define __SYSCALL_DEFINEx(x, ret, name, ...)				\
+	asmlinkage ret sys##name(__SC_DECL##x(__VA_ARGS__))
 
 #endif /* CONFIG_HAVE_SYSCALL_WRAPPERS */
 
-- 
1.7.1

