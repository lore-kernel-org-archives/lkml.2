Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab1HRTMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:12:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48384 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967Ab1HRTMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:12:20 -0400
Date: Thu, 18 Aug 2011 20:12:19 +0100
To: richard@nod.at
Subject: Subject: [PATCH 80/91] um: unify ptrace_user.h
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu80p-00084D-VR@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/include/shared/ptrace_user.h       |    3 +-
 arch/um/os-Linux/skas/process.c            |    3 +-
 arch/um/os-Linux/start_up.c                |    9 +++---
 arch/x86/um/ptrace_64.c                    |    2 +-
 arch/x86/um/shared/sysdep/ptrace_64.h      |    2 +-
 arch/x86/um/shared/sysdep/ptrace_user.h    |   26 +++++++++++++++++-
 arch/x86/um/shared/sysdep/ptrace_user_32.h |   26 -------------------
 arch/x86/um/shared/sysdep/ptrace_user_64.h |   38 ----------------------------
 arch/x86/um/user-offsets.c                 |    3 +-
 9 files changed, 35 insertions(+), 77 deletions(-)
 delete mode 100644 arch/x86/um/shared/sysdep/ptrace_user_32.h
 delete mode 100644 arch/x86/um/shared/sysdep/ptrace_user_64.h

diff --git a/arch/um/include/shared/ptrace_user.h b/arch/um/include/shared/ptrace_user.h
index 7fd8539..56b2f28 100644
--- a/arch/um/include/shared/ptrace_user.h
+++ b/arch/um/include/shared/ptrace_user.h
@@ -6,7 +6,8 @@
 #ifndef __PTRACE_USER_H__
 #define __PTRACE_USER_H__
 
-#include "sysdep/ptrace_user.h"
+#include <sys/ptrace.h>
+#include <sysdep/ptrace_user.h>
 
 extern int ptrace_getregs(long pid, unsigned long *regs_out);
 extern int ptrace_setregs(long pid, unsigned long *regs_in);
diff --git a/arch/um/os-Linux/skas/process.c b/arch/um/os-Linux/skas/process.c
index ce26053..a00240a 100644
--- a/arch/um/os-Linux/skas/process.c
+++ b/arch/um/os-Linux/skas/process.c
@@ -9,7 +9,6 @@
 #include <errno.h>
 #include <string.h>
 #include <sys/mman.h>
-#include <sys/ptrace.h>
 #include <sys/wait.h>
 #include <asm/unistd.h>
 #include "as-layout.h"
@@ -162,7 +161,7 @@ static void handle_trap(int pid, struct uml_pt_regs *regs,
 
 	if (!local_using_sysemu)
 	{
-		err = ptrace(PTRACE_POKEUSR, pid, PT_SYSCALL_NR_OFFSET,
+		err = ptrace(PTRACE_POKEUSER, pid, PT_SYSCALL_NR_OFFSET,
 			     __NR_getpid);
 		if (err < 0) {
 			printk(UM_KERN_ERR "handle_trap - nullifying syscall "
diff --git a/arch/um/os-Linux/start_up.c b/arch/um/os-Linux/start_up.c
index b698680..425162e 100644
--- a/arch/um/os-Linux/start_up.c
+++ b/arch/um/os-Linux/start_up.c
@@ -13,7 +13,6 @@
 #include <signal.h>
 #include <string.h>
 #include <sys/mman.h>
-#include <sys/ptrace.h>
 #include <sys/stat.h>
 #include <sys/wait.h>
 #include <asm/unistd.h>
@@ -224,7 +223,7 @@ static void __init check_sysemu(void)
 		goto fail;
 	}
 
-	n = ptrace(PTRACE_POKEUSR, pid, PT_SYSCALL_RET_OFFSET, os_getpid());
+	n = ptrace(PTRACE_POKEUSER, pid, PT_SYSCALL_RET_OFFSET, os_getpid());
 	if (n < 0) {
 		non_fatal("check_sysemu : failed to modify system call "
 			  "return");
@@ -260,7 +259,7 @@ static void __init check_sysemu(void)
 					  "doesn't singlestep");
 				goto fail;
 			}
-			n = ptrace(PTRACE_POKEUSR, pid, PT_SYSCALL_RET_OFFSET,
+			n = ptrace(PTRACE_POKEUSER, pid, PT_SYSCALL_RET_OFFSET,
 				   os_getpid());
 			if (n < 0)
 				fatal_perror("check_sysemu : failed to modify "
@@ -316,10 +315,10 @@ static void __init check_ptrace(void)
 			fatal("check_ptrace : expected (SIGTRAP|0x80), "
 			       "got status = %d", status);
 
-		syscall = ptrace(PTRACE_PEEKUSR, pid, PT_SYSCALL_NR_OFFSET,
+		syscall = ptrace(PTRACE_PEEKUSER, pid, PT_SYSCALL_NR_OFFSET,
 				 0);
 		if (syscall == __NR_getpid) {
-			n = ptrace(PTRACE_POKEUSR, pid, PT_SYSCALL_NR_OFFSET,
+			n = ptrace(PTRACE_POKEUSER, pid, PT_SYSCALL_NR_OFFSET,
 				   __NR_getppid);
 			if (n < 0)
 				fatal_perror("check_ptrace : failed to modify "
diff --git a/arch/x86/um/ptrace_64.c b/arch/x86/um/ptrace_64.c
index 77b0289..71cd19d 100644
--- a/arch/x86/um/ptrace_64.c
+++ b/arch/x86/um/ptrace_64.c
@@ -46,7 +46,7 @@ static const int reg_offsets[] =
 	[FS >> 3] = HOST_FS,
 	[GS >> 3] = HOST_GS,
 	[EFLAGS >> 3] = HOST_EFLAGS,
-	[ORIG_RAX >> 3] = HOST_ORIG_RAX,
+	[ORIG_RAX >> 3] = HOST_ORIG_AX,
 };
 
 int putreg(struct task_struct *child, int regno, unsigned long value)
diff --git a/arch/x86/um/shared/sysdep/ptrace_64.h b/arch/x86/um/shared/sysdep/ptrace_64.h
index 9b933fa..ea6ce83 100644
--- a/arch/x86/um/shared/sysdep/ptrace_64.h
+++ b/arch/x86/um/shared/sysdep/ptrace_64.h
@@ -65,7 +65,7 @@
 #define REGS_FS(r) ((r)[HOST_FS])
 #define REGS_GS(r) ((r)[HOST_GS])
 
-#define REGS_ORIG_RAX(r) ((r)[HOST_ORIG_RAX])
+#define REGS_ORIG_RAX(r) ((r)[HOST_ORIG_AX])
 
 #define REGS_SET_SYSCALL_RETURN(r, res) REGS_RAX(r) = (res)
 
diff --git a/arch/x86/um/shared/sysdep/ptrace_user.h b/arch/x86/um/shared/sysdep/ptrace_user.h
index a92f883..16cd6b5 100644
--- a/arch/x86/um/shared/sysdep/ptrace_user.h
+++ b/arch/x86/um/shared/sysdep/ptrace_user.h
@@ -1,5 +1,27 @@
+#include <generated/user_constants.h>
+
+#define PT_OFFSET(r) ((r) * sizeof(long))
+
+#define PT_SYSCALL_NR(regs) ((regs)[HOST_ORIG_AX])
+#define PT_SYSCALL_NR_OFFSET PT_OFFSET(HOST_ORIG_AX)
+
+#define PT_SYSCALL_RET_OFFSET PT_OFFSET(HOST_AX)
+
+#define REGS_IP_INDEX HOST_IP
+#define REGS_SP_INDEX HOST_SP
+
 #ifdef __i386__
-#include "ptrace_user_32.h"
+#define FP_SIZE ((HOST_FPX_SIZE > HOST_FP_SIZE) ? HOST_FPX_SIZE : HOST_FP_SIZE)
 #else
-#include "ptrace_user_64.h"
+#define FP_SIZE HOST_FP_SIZE
+
+/*
+ * x86_64 FC3 doesn't define this in /usr/include/linux/ptrace.h even though
+ * it's defined in the kernel's include/linux/ptrace.h. Additionally, use the
+ * 2.4 name and value for 2.4 host compatibility.
+ */
+#ifndef PTRACE_OLDSETOPTIONS
+#define PTRACE_OLDSETOPTIONS 21
+#endif
+
 #endif
diff --git a/arch/x86/um/shared/sysdep/ptrace_user_32.h b/arch/x86/um/shared/sysdep/ptrace_user_32.h
deleted file mode 100644
index 9d88a79..0000000
--- a/arch/x86/um/shared/sysdep/ptrace_user_32.h
+++ /dev/null
@@ -1,26 +0,0 @@
-/* 
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#ifndef __SYSDEP_I386_PTRACE_USER_H__
-#define __SYSDEP_I386_PTRACE_USER_H__
-
-#include <sys/ptrace.h>
-#include <linux/ptrace.h>
-#include <asm/ptrace.h>
-#include <generated/user_constants.h>
-
-#define PT_OFFSET(r) ((r) * sizeof(long))
-
-#define PT_SYSCALL_NR(regs) ((regs)[ORIG_EAX])
-#define PT_SYSCALL_NR_OFFSET PT_OFFSET(ORIG_EAX)
-
-#define PT_SYSCALL_RET_OFFSET PT_OFFSET(EAX)
-
-#define REGS_IP_INDEX EIP
-#define REGS_SP_INDEX UESP
-
-#define FP_SIZE ((HOST_FPX_SIZE > HOST_FP_SIZE) ? HOST_FPX_SIZE : HOST_FP_SIZE)
-
-#endif
diff --git a/arch/x86/um/shared/sysdep/ptrace_user_64.h b/arch/x86/um/shared/sysdep/ptrace_user_64.h
deleted file mode 100644
index 2f1b6e3..0000000
--- a/arch/x86/um/shared/sysdep/ptrace_user_64.h
+++ /dev/null
@@ -1,38 +0,0 @@
-/*
- * Copyright 2003 PathScale, Inc.
- *
- * Licensed under the GPL
- */
-
-#ifndef __SYSDEP_X86_64_PTRACE_USER_H__
-#define __SYSDEP_X86_64_PTRACE_USER_H__
-
-#define __FRAME_OFFSETS
-#include <sys/ptrace.h>
-#include <linux/ptrace.h>
-#include <asm/ptrace.h>
-#undef __FRAME_OFFSETS
-#include <generated/user_constants.h>
-
-#define PT_INDEX(off) ((off) / sizeof(unsigned long))
-
-#define PT_SYSCALL_NR(regs) ((regs)[PT_INDEX(ORIG_RAX)])
-#define PT_SYSCALL_NR_OFFSET (ORIG_RAX)
-
-#define PT_SYSCALL_RET_OFFSET (RAX)
-
-/*
- * x86_64 FC3 doesn't define this in /usr/include/linux/ptrace.h even though
- * it's defined in the kernel's include/linux/ptrace.h. Additionally, use the
- * 2.4 name and value for 2.4 host compatibility.
- */
-#ifndef PTRACE_OLDSETOPTIONS
-#define PTRACE_OLDSETOPTIONS 21
-#endif
-
-#define REGS_IP_INDEX PT_INDEX(RIP)
-#define REGS_SP_INDEX PT_INDEX(RSP)
-
-#define FP_SIZE (HOST_FP_SIZE)
-
-#endif
diff --git a/arch/x86/um/user-offsets.c b/arch/x86/um/user-offsets.c
index 88d1255..ca49be8 100644
--- a/arch/x86/um/user-offsets.c
+++ b/arch/x86/um/user-offsets.c
@@ -36,6 +36,7 @@ void foo(void)
 	DEFINE(HOST_FS, FS);
 	DEFINE(HOST_ES, ES);
 	DEFINE(HOST_GS, GS);
+	DEFINE(HOST_ORIG_AX, ORIG_EAX);
 #else
 	DEFINE(HOST_FP_SIZE, sizeof(struct _fpstate) / sizeof(unsigned long));
 	DEFINE_LONGS(HOST_BX, RBX);
@@ -53,7 +54,7 @@ void foo(void)
 	DEFINE_LONGS(HOST_R13, R13);
 	DEFINE_LONGS(HOST_R14, R14);
 	DEFINE_LONGS(HOST_R15, R15);
-	DEFINE_LONGS(HOST_ORIG_RAX, ORIG_RAX);
+	DEFINE_LONGS(HOST_ORIG_AX, ORIG_RAX);
 	DEFINE_LONGS(HOST_CS, CS);
 	DEFINE_LONGS(HOST_SS, SS);
 	DEFINE_LONGS(HOST_EFLAGS, EFLAGS);
-- 
1.7.2.5


