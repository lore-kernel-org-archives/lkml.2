Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840Ab1LFBGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 20:06:16 -0500
Received: from mga11.intel.com ([192.55.52.93]:18104 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932797Ab1LFBGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 20:06:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,302,1320652800"; 
   d="scan'208";a="92645295"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 3/3] x86, um: Use the same style generated syscall tables as native
Date: Mon,  5 Dec 2011 17:05:49 -0800
Message-Id: <1323133549-13590-4-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1323133549-13590-1-git-send-email-hpa@linux.intel.com>
References: <1323133549-13590-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

Now when the native kernel uses a single style of generated system
call table, follow suite for UML and implement the same style, all in
C.  This requires __NR_syscall_max and NR_syscalls to be generated; on
native this is done in asm-headers.h but that file is common to all
UML architectures; therefore put it in user-headers.h instead which
already have accommodations for architecture-specific values.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/um/Makefile            |    3 +-
 arch/x86/um/sys_call_table_32.S |   26 ------------------
 arch/x86/um/sys_call_table_32.c |   55 +++++++++++++++++++++++++++++++++++++++
 arch/x86/um/sys_call_table_64.c |   31 ++++++++-------------
 arch/x86/um/user-offsets.c      |   15 ++++++++++
 5 files changed, 84 insertions(+), 46 deletions(-)
 delete mode 100644 arch/x86/um/sys_call_table_32.S
 create mode 100644 arch/x86/um/sys_call_table_32.c

diff --git a/arch/x86/um/Makefile b/arch/x86/um/Makefile
index 8fb5840..5d065b2 100644
--- a/arch/x86/um/Makefile
+++ b/arch/x86/um/Makefile
@@ -37,7 +37,8 @@ subarch-$(CONFIG_MODULES) += ../kernel/module.o
 USER_OBJS := bugs_$(BITS).o ptrace_user.o fault.o
 
 extra-y += user-offsets.s
-$(obj)/user-offsets.s: c_flags = -Wp,-MD,$(depfile) $(USER_CFLAGS)
+$(obj)/user-offsets.s: c_flags = -Wp,-MD,$(depfile) $(USER_CFLAGS) \
+	-Iarch/x86/include/generated
 
 UNPROFILE_OBJS := stub_segv.o
 CFLAGS_stub_segv.o := $(CFLAGS_NO_HARDENING)
diff --git a/arch/x86/um/sys_call_table_32.S b/arch/x86/um/sys_call_table_32.S
deleted file mode 100644
index a7ca80d..0000000
--- a/arch/x86/um/sys_call_table_32.S
+++ /dev/null
@@ -1,26 +0,0 @@
-#include <linux/linkage.h>
-/* Steal i386 syscall table for our purposes, but with some slight changes.*/
-
-#define sys_iopl sys_ni_syscall
-#define sys_ioperm sys_ni_syscall
-
-#define sys_vm86old sys_ni_syscall
-#define sys_vm86 sys_ni_syscall
-
-#define old_mmap sys_old_mmap
-
-#define ptregs_fork sys_fork
-#define ptregs_execve sys_execve
-#define ptregs_iopl sys_iopl
-#define ptregs_vm86old sys_vm86old
-#define ptregs_clone sys_clone
-#define ptregs_vm86 sys_vm86
-#define ptregs_sigaltstack sys_sigaltstack
-#define ptregs_vfork sys_vfork
-
-.section .rodata,"a"
-
-#include "../kernel/syscall_table_32.S"
-
-ENTRY(syscall_table_size)
-.long .-sys_call_table
diff --git a/arch/x86/um/sys_call_table_32.c b/arch/x86/um/sys_call_table_32.c
new file mode 100644
index 0000000..b897fca
--- /dev/null
+++ b/arch/x86/um/sys_call_table_32.c
@@ -0,0 +1,55 @@
+/*
+ * System call table for UML/i386, copied from arch/x86/kernel/syscall_*.c
+ * with some changes for UML.
+ */
+
+#include <linux/linkage.h>
+#include <linux/sys.h>
+#include <linux/cache.h>
+#include <generated/user_constants.h>
+
+#define __NO_STUBS
+
+/*
+ * Below you can see, in terms of #define's, the differences between the x86-64
+ * and the UML syscall table.
+ */
+
+/* Not going to be implemented by UML, since we have no hardware. */
+#define stub_iopl sys_ni_syscall
+#define sys_ioperm sys_ni_syscall
+
+#define sys_vm86old sys_ni_syscall
+#define sys_vm86 sys_ni_syscall
+
+#define old_mmap sys_old_mmap
+
+#define ptregs_fork sys_fork
+#define ptregs_execve sys_execve
+#define ptregs_iopl sys_iopl
+#define ptregs_vm86old sys_vm86old
+#define ptregs_clone sys_clone
+#define ptregs_vm86 sys_vm86
+#define ptregs_sigaltstack sys_sigaltstack
+#define ptregs_vfork sys_vfork
+
+#define __SYSCALL_I386(nr, sym, compat) extern asmlinkage void sym(void) ;
+#include <asm/syscalls_32.h>
+
+#undef __SYSCALL_I386
+#define __SYSCALL_I386(nr, sym, compat) [ nr ] = sym,
+
+typedef void (*sys_call_ptr_t)(void);
+
+extern void sys_ni_syscall(void);
+
+sys_call_ptr_t sys_call_table[] __cacheline_aligned = {
+	/*
+	 * Smells like a compiler bug -- it doesn't work
+	 * when the & below is removed.
+	 */
+	[0 ... __NR_syscall_max] = &sys_ni_syscall,
+#include <asm/syscalls_32.h>
+};
+
+int syscall_table_size = sizeof(sys_call_table);
diff --git a/arch/x86/um/sys_call_table_64.c b/arch/x86/um/sys_call_table_64.c
index 99522f7..797a639 100644
--- a/arch/x86/um/sys_call_table_64.c
+++ b/arch/x86/um/sys_call_table_64.c
@@ -1,11 +1,12 @@
 /*
- * System call table for UML/x86-64, copied from arch/x86_64/kernel/syscall.c
+ * System call table for UML/x86-64, copied from arch/x86/kernel/syscall_*.c
  * with some changes for UML.
  */
 
 #include <linux/linkage.h>
 #include <linux/sys.h>
 #include <linux/cache.h>
+#include <generated/user_constants.h>
 
 #define __NO_STUBS
 
@@ -34,31 +35,23 @@
 #define stub_sigaltstack sys_sigaltstack
 #define stub_rt_sigreturn sys_rt_sigreturn
 
-#define __SYSCALL(nr, sym) extern asmlinkage void sym(void) ;
-#undef _ASM_X86_UNISTD_64_H
-#include "../../x86/include/asm/unistd_64.h"
+#define __SYSCALL_64(nr, sym, compat) extern asmlinkage void sym(void) ;
+#include <asm/syscalls_64.h>
 
-#undef __SYSCALL
-#define __SYSCALL(nr, sym) [ nr ] = sym,
-#undef _ASM_X86_UNISTD_64_H
+#undef __SYSCALL_64
+#define __SYSCALL_64(nr, sym, compat) [ nr ] = sym,
 
 typedef void (*sys_call_ptr_t)(void);
 
 extern void sys_ni_syscall(void);
 
-/*
- * We used to have a trick here which made sure that holes in the
- * x86_64 table were filled in with sys_ni_syscall, but a comment in
- * unistd_64.h says that holes aren't allowed, so the trick was
- * removed.
- * The trick looked like this
- *	[0 ... UM_NR_syscall_max] = &sys_ni_syscall
- * before including unistd_64.h - the later initializations overwrote
- * the sys_ni_syscall filler.
- */
-
 sys_call_ptr_t sys_call_table[] __cacheline_aligned = {
-#include <asm/unistd_64.h>
+	/*
+	 * Smells like a compiler bug -- it doesn't work
+	 * when the & below is removed.
+	 */
+	[0 ... __NR_syscall_max] = &sys_ni_syscall,
+#include <asm/syscalls_64.h>
 };
 
 int syscall_table_size = sizeof(sys_call_table);
diff --git a/arch/x86/um/user-offsets.c b/arch/x86/um/user-offsets.c
index ca49be8..5edf4f4 100644
--- a/arch/x86/um/user-offsets.c
+++ b/arch/x86/um/user-offsets.c
@@ -8,6 +8,18 @@
 #include <asm/ptrace.h>
 #include <asm/types.h>
 
+#ifdef __i386__
+#define __SYSCALL_I386(nr, sym, compat) [nr] = 1,
+static char syscalls[] = {
+#include <asm/syscalls_32.h>
+};
+#else
+#define __SYSCALL_64(nr, sym, compat) [nr] = 1,
+static char syscalls[] = {
+#include <asm/syscalls_64.h>
+};
+#endif
+
 #define DEFINE(sym, val) \
 	asm volatile("\n->" #sym " %0 " #val : : "i" (val))
 
@@ -77,4 +89,7 @@ void foo(void)
 	DEFINE(UM_PROT_READ, PROT_READ);
 	DEFINE(UM_PROT_WRITE, PROT_WRITE);
 	DEFINE(UM_PROT_EXEC, PROT_EXEC);
+
+	DEFINE(__NR_syscall_max, sizeof(syscalls) - 1);
+	DEFINE(NR_syscalls, sizeof(syscalls));
 }
-- 
1.7.6.4

