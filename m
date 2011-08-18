Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab1HRTDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:03:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44286 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab1HRTDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:03:50 -0400
Date: Thu, 18 Aug 2011 20:03:49 +0100
To: richard@nod.at
Subject: Subject: [PATCH 29/91] um: merge
 arch/um/os-Linux/sys-{i386,x86_64}
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7sb-0007d6-DN@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/os-Linux/Makefile                          |    2 +-
 arch/um/os-Linux/{sys-i386 => sys-x86}/Makefile    |    5 ++-
 arch/um/os-Linux/{sys-x86_64 => sys-x86}/prctl.c   |    0
 arch/um/os-Linux/{sys-i386 => sys-x86}/registers.c |   58 ++++++++++++++------
 arch/um/os-Linux/{sys-i386 => sys-x86}/task_size.c |   12 ++++
 arch/um/os-Linux/{sys-i386 => sys-x86}/tls.c       |    0
 arch/um/os-Linux/sys-x86_64/Makefile               |   10 ----
 arch/um/os-Linux/sys-x86_64/registers.c            |   50 -----------------
 arch/um/os-Linux/sys-x86_64/task_size.c            |    5 --
 9 files changed, 57 insertions(+), 85 deletions(-)
 rename arch/um/os-Linux/{sys-i386 => sys-x86}/Makefile (63%)
 rename arch/um/os-Linux/{sys-x86_64 => sys-x86}/prctl.c (100%)
 rename arch/um/os-Linux/{sys-i386 => sys-x86}/registers.c (83%)
 rename arch/um/os-Linux/{sys-i386 => sys-x86}/task_size.c (95%)
 rename arch/um/os-Linux/{sys-i386 => sys-x86}/tls.c (100%)
 delete mode 100644 arch/um/os-Linux/sys-x86_64/Makefile
 delete mode 100644 arch/um/os-Linux/sys-x86_64/registers.c
 delete mode 100644 arch/um/os-Linux/sys-x86_64/task_size.c

diff --git a/arch/um/os-Linux/Makefile b/arch/um/os-Linux/Makefile
index 7aec5bf..7879e76 100644
--- a/arch/um/os-Linux/Makefile
+++ b/arch/um/os-Linux/Makefile
@@ -5,7 +5,7 @@
 
 obj-y = aio.o execvp.o file.o helper.o irq.o main.o mem.o process.o \
 	registers.o sigio.o signal.o start_up.o time.o tty.o \
-	umid.o tls.o user_syms.o util.o drivers/ sys-$(SUBARCH)/ skas/
+	umid.o tls.o user_syms.o util.o drivers/ sys-$(HEADER_ARCH)/ skas/
 
 obj-$(CONFIG_ARCH_REUSE_HOST_VSYSCALL_AREA) += elf_aux.o
 
diff --git a/arch/um/os-Linux/sys-i386/Makefile b/arch/um/os-Linux/sys-x86/Makefile
similarity index 63%
rename from arch/um/os-Linux/sys-i386/Makefile
rename to arch/um/os-Linux/sys-x86/Makefile
index d491754..22cc507 100644
--- a/arch/um/os-Linux/sys-i386/Makefile
+++ b/arch/um/os-Linux/sys-x86/Makefile
@@ -3,7 +3,10 @@
 # Licensed under the GPL
 #
 
-obj-y = registers.o task_size.o tls.o
+obj-y = registers.o task_size.o
+
+obj-$(CONFIG_X86_32) += tls.o
+obj-$(CONFIG_64BIT) += prctl.o
 
 USER_OBJS := $(obj-y)
 
diff --git a/arch/um/os-Linux/sys-x86_64/prctl.c b/arch/um/os-Linux/sys-x86/prctl.c
similarity index 100%
rename from arch/um/os-Linux/sys-x86_64/prctl.c
rename to arch/um/os-Linux/sys-x86/prctl.c
diff --git a/arch/um/os-Linux/sys-i386/registers.c b/arch/um/os-Linux/sys-x86/registers.c
similarity index 83%
rename from arch/um/os-Linux/sys-i386/registers.c
rename to arch/um/os-Linux/sys-x86/registers.c
index 913d811..3a9b624 100644
--- a/arch/um/os-Linux/sys-i386/registers.c
+++ b/arch/um/os-Linux/sys-x86/registers.c
@@ -24,6 +24,8 @@ int restore_fp_registers(int pid, unsigned long *fp_regs)
 	return 0;
 }
 
+#ifdef __i386__
+int have_fpx_regs = 1;
 int save_fpx_registers(int pid, unsigned long *fp_regs)
 {
 	if (ptrace(PTRACE_GETFPXREGS, pid, 0, fp_regs) < 0)
@@ -38,24 +40,6 @@ int restore_fpx_registers(int pid, unsigned long *fp_regs)
 	return 0;
 }
 
-unsigned long get_thread_reg(int reg, jmp_buf *buf)
-{
-	switch (reg) {
-	case EIP:
-		return buf[0]->__eip;
-	case UESP:
-		return buf[0]->__esp;
-	case EBP:
-		return buf[0]->__ebp;
-	default:
-		printk(UM_KERN_ERR "get_thread_regs - unknown register %d\n",
-		       reg);
-		return 0;
-	}
-}
-
-int have_fpx_regs = 1;
-
 int get_fp_registers(int pid, unsigned long *regs)
 {
 	if (have_fpx_regs)
@@ -87,3 +71,41 @@ void arch_init_registers(int pid)
 
 	have_fpx_regs = 0;
 }
+#else
+
+int get_fp_registers(int pid, unsigned long *regs)
+{
+	return save_fp_registers(pid, regs);
+}
+
+int put_fp_registers(int pid, unsigned long *regs)
+{
+	return restore_fp_registers(pid, regs);
+}
+
+#endif
+
+unsigned long get_thread_reg(int reg, jmp_buf *buf)
+{
+	switch (reg) {
+#ifdef __i386__
+	case EIP:
+		return buf[0]->__eip;
+	case UESP:
+		return buf[0]->__esp;
+	case EBP:
+		return buf[0]->__ebp;
+#else
+	case RIP:
+		return buf[0]->__rip;
+	case RSP:
+		return buf[0]->__rsp;
+	case RBP:
+		return buf[0]->__rbp;
+#endif
+	default:
+		printk(UM_KERN_ERR "get_thread_regs - unknown register %d\n",
+		       reg);
+		return 0;
+	}
+}
diff --git a/arch/um/os-Linux/sys-i386/task_size.c b/arch/um/os-Linux/sys-x86/task_size.c
similarity index 95%
rename from arch/um/os-Linux/sys-i386/task_size.c
rename to arch/um/os-Linux/sys-x86/task_size.c
index 4ce09b8..efb16c5 100644
--- a/arch/um/os-Linux/sys-i386/task_size.c
+++ b/arch/um/os-Linux/sys-x86/task_size.c
@@ -4,6 +4,8 @@
 #include <sys/mman.h>
 #include "longjmp.h"
 
+#ifdef __i386__
+
 static jmp_buf buf;
 
 static void segfault(int sig)
@@ -136,3 +138,13 @@ out:
 
 	return top;
 }
+
+#else
+
+unsigned long os_get_top_address(void)
+{
+	/* The old value of CONFIG_TOP_ADDR */
+	return 0x7fc0000000;
+}
+
+#endif
diff --git a/arch/um/os-Linux/sys-i386/tls.c b/arch/um/os-Linux/sys-x86/tls.c
similarity index 100%
rename from arch/um/os-Linux/sys-i386/tls.c
rename to arch/um/os-Linux/sys-x86/tls.c
diff --git a/arch/um/os-Linux/sys-x86_64/Makefile b/arch/um/os-Linux/sys-x86_64/Makefile
deleted file mode 100644
index 58f6e0a..0000000
--- a/arch/um/os-Linux/sys-x86_64/Makefile
+++ /dev/null
@@ -1,10 +0,0 @@
-#
-# Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
-# Licensed under the GPL
-#
-
-obj-y = registers.o prctl.o task_size.o
-
-USER_OBJS := $(obj-y)
-
-include arch/um/scripts/Makefile.rules
diff --git a/arch/um/os-Linux/sys-x86_64/registers.c b/arch/um/os-Linux/sys-x86_64/registers.c
deleted file mode 100644
index 0594d55..0000000
--- a/arch/um/os-Linux/sys-x86_64/registers.c
+++ /dev/null
@@ -1,50 +0,0 @@
-/*
- * Copyright (C) 2006 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
- * Licensed under the GPL
- */
-
-#include <errno.h>
-#include <sys/ptrace.h>
-#define __FRAME_OFFSETS
-#include <asm/ptrace.h>
-#include "longjmp.h"
-
-int save_fp_registers(int pid, unsigned long *fp_regs)
-{
-	if (ptrace(PTRACE_GETFPREGS, pid, 0, fp_regs) < 0)
-		return -errno;
-	return 0;
-}
-
-int restore_fp_registers(int pid, unsigned long *fp_regs)
-{
-	if (ptrace(PTRACE_SETFPREGS, pid, 0, fp_regs) < 0)
-		return -errno;
-	return 0;
-}
-
-unsigned long get_thread_reg(int reg, jmp_buf *buf)
-{
-	switch (reg) {
-	case RIP:
-		return buf[0]->__rip;
-	case RSP:
-		return buf[0]->__rsp;
-	case RBP:
-		return buf[0]->__rbp;
-	default:
-		printk(UM_KERN_ERR "get_thread_regs - unknown register %d\n",
-		       reg);
-		return 0;
-	}
-}
-
-int get_fp_registers(int pid, unsigned long *regs)
-{
-	return save_fp_registers(pid, regs);
-}
-
-int put_fp_registers(int pid, unsigned long *regs)
-{
-	return restore_fp_registers(pid, regs);
-}
diff --git a/arch/um/os-Linux/sys-x86_64/task_size.c b/arch/um/os-Linux/sys-x86_64/task_size.c
deleted file mode 100644
index 26a0dd1..0000000
--- a/arch/um/os-Linux/sys-x86_64/task_size.c
+++ /dev/null
@@ -1,5 +0,0 @@
-unsigned long os_get_top_address(unsigned long shift)
-{
-	/* The old value of CONFIG_TOP_ADDR */
-	return 0x7fc0000000;
-}
-- 
1.7.2.5


