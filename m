Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab0HHUxv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 16:53:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37446 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab0HHUxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 16:53:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=JUKETNI9enbiLr8vibjI5GRy3O88VXdtP3VASTjMCifyHVR/uPLkxyOU1oXGvuZOUV
         ZYQ9xyvRx7ILktjbb5mI/w28yu85vZTTD4o59yF93OiOaDBpoBynhWPfnBe0VNDaFOv+
         k5lpzwK8+Yg/3iMDS/uIG4YQQNFU9rHE9C700=
From: Namhyung Kim <namhyung@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>, Stuart Menefy <stuart.menefy@st.com>,
        linux-sh@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sh: remove RELOC_HIDE on exception handlers and syscall routines
Date: Mon,  9 Aug 2010 05:53:45 +0900
Message-Id: <1281300825-3327-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove unneccessary use of RELOC_HIDE(). It does simple addition of ptr and
offset and in this case (offset 0) does practically nothing. It does NOT do
anything with linker relocation.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 arch/sh/include/asm/system.h |    2 +-
 arch/sh/kernel/process_32.c  |    8 ++++----
 arch/sh/kernel/signal_32.c   |    6 +++---
 arch/sh/kernel/sys_sh32.c    |    2 +-
 arch/sh/kernel/traps_32.c    |    6 +++---
 5 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/sh/include/asm/system.h b/arch/sh/include/asm/system.h
index 0bd7a17..8125c6c 100644
--- a/arch/sh/include/asm/system.h
+++ b/arch/sh/include/asm/system.h
@@ -154,7 +154,7 @@ asmlinkage void name##_trap_handler(unsigned long r4, unsigned long r5,	\
 				    struct pt_regs __regs)
 
 #define TRAP_HANDLER_DECL				\
-	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);	\
+	struct pt_regs *regs = &__regs;			\
 	unsigned int vec = regs->tra;			\
 	(void)vec;
 #else
diff --git a/arch/sh/kernel/process_32.c b/arch/sh/kernel/process_32.c
index 0529819..95c9de1 100644
--- a/arch/sh/kernel/process_32.c
+++ b/arch/sh/kernel/process_32.c
@@ -253,7 +253,7 @@ asmlinkage int sys_fork(unsigned long r4, unsigned long r5,
 			struct pt_regs __regs)
 {
 #ifdef CONFIG_MMU
-	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
+	struct pt_regs *regs = &__regs;
 	return do_fork(SIGCHLD, regs->regs[15], regs, 0, NULL, NULL);
 #else
 	/* fork almost works, enough to trick you into looking elsewhere :-( */
@@ -266,7 +266,7 @@ asmlinkage int sys_clone(unsigned long clone_flags, unsigned long newsp,
 			 unsigned long child_tidptr,
 			 struct pt_regs __regs)
 {
-	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
+	struct pt_regs *regs = &__regs;
 	if (!newsp)
 		newsp = regs->regs[15];
 	return do_fork(clone_flags, newsp, regs, 0,
@@ -288,7 +288,7 @@ asmlinkage int sys_vfork(unsigned long r4, unsigned long r5,
 			 unsigned long r6, unsigned long r7,
 			 struct pt_regs __regs)
 {
-	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
+	struct pt_regs *regs = &__regs;
 	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, regs->regs[15], regs,
 		       0, NULL, NULL);
 }
@@ -300,7 +300,7 @@ asmlinkage int sys_execve(char __user *ufilename, char __user * __user *uargv,
 			  char __user * __user *uenvp, unsigned long r7,
 			  struct pt_regs __regs)
 {
-	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
+	struct pt_regs *regs = &__regs;
 	int error;
 	char *filename;
 
diff --git a/arch/sh/kernel/signal_32.c b/arch/sh/kernel/signal_32.c
index 579cd2c..76843cb 100644
--- a/arch/sh/kernel/signal_32.c
+++ b/arch/sh/kernel/signal_32.c
@@ -109,7 +109,7 @@ sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
 		unsigned long r6, unsigned long r7,
 		struct pt_regs __regs)
 {
-	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
+	struct pt_regs *regs = &__regs;
 
 	return do_sigaltstack(uss, uoss, regs->regs[15]);
 }
@@ -222,7 +222,7 @@ asmlinkage int sys_sigreturn(unsigned long r4, unsigned long r5,
 			     unsigned long r6, unsigned long r7,
 			     struct pt_regs __regs)
 {
-	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
+	struct pt_regs *regs = &__regs;
 	struct sigframe __user *frame = (struct sigframe __user *)regs->regs[15];
 	sigset_t set;
 	int r0;
@@ -259,7 +259,7 @@ asmlinkage int sys_rt_sigreturn(unsigned long r4, unsigned long r5,
 				unsigned long r6, unsigned long r7,
 				struct pt_regs __regs)
 {
-	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
+	struct pt_regs *regs = &__regs;
 	struct rt_sigframe __user *frame = (struct rt_sigframe __user *)regs->regs[15];
 	sigset_t set;
 	int r0;
diff --git a/arch/sh/kernel/sys_sh32.c b/arch/sh/kernel/sys_sh32.c
index eb68bfd..1d96ad2 100644
--- a/arch/sh/kernel/sys_sh32.c
+++ b/arch/sh/kernel/sys_sh32.c
@@ -25,7 +25,7 @@ asmlinkage int sys_sh_pipe(unsigned long r4, unsigned long r5,
 	unsigned long r6, unsigned long r7,
 	struct pt_regs __regs)
 {
-	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
+	struct pt_regs *regs = &__regs;
 	int fd[2];
 	int error;
 
diff --git a/arch/sh/kernel/traps_32.c b/arch/sh/kernel/traps_32.c
index c3d86fa..107cccb 100644
--- a/arch/sh/kernel/traps_32.c
+++ b/arch/sh/kernel/traps_32.c
@@ -666,7 +666,7 @@ asmlinkage void do_reserved_inst(unsigned long r4, unsigned long r5,
 				unsigned long r6, unsigned long r7,
 				struct pt_regs __regs)
 {
-	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
+	struct pt_regs *regs = &__regs;
 	unsigned long error_code;
 	struct task_struct *tsk = current;
 
@@ -754,7 +754,7 @@ asmlinkage void do_illegal_slot_inst(unsigned long r4, unsigned long r5,
 				unsigned long r6, unsigned long r7,
 				struct pt_regs __regs)
 {
-	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
+	struct pt_regs *regs = &__regs;
 	unsigned long inst;
 	struct task_struct *tsk = current;
 
@@ -783,7 +783,7 @@ asmlinkage void do_exception_error(unsigned long r4, unsigned long r5,
 				   unsigned long r6, unsigned long r7,
 				   struct pt_regs __regs)
 {
-	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
+	struct pt_regs *regs = &__regs;
 	long ex;
 
 	ex = lookup_exception_vector();
-- 
1.7.0.4

