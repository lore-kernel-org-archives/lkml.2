Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab2IJWUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 18:20:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816Ab2IJWUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 18:20:18 -0400
From: Mark Salter <msalter@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Mark Salter <msalter@redhat.com>
Subject: [PATCH 2/2] c6x: switch to generic sys_execve()
Date: Mon, 10 Sep 2012 18:20:03 -0400
Message-Id: <1347315603-30027-3-git-send-email-msalter@redhat.com>
In-Reply-To: <1347315603-30027-1-git-send-email-msalter@redhat.com>
References: <20120907182004.GE13973@ZenIV.linux.org.uk>
 <1347315603-30027-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/c6x/include/asm/syscalls.h |    5 -----
 arch/c6x/include/asm/unistd.h   |    1 +
 arch/c6x/kernel/entry.S         |   23 -----------------------
 arch/c6x/kernel/process.c       |   22 ----------------------
 4 files changed, 1 insertions(+), 50 deletions(-)

diff --git a/arch/c6x/include/asm/syscalls.h b/arch/c6x/include/asm/syscalls.h
index aed53da..e7b8991 100644
--- a/arch/c6x/include/asm/syscalls.h
+++ b/arch/c6x/include/asm/syscalls.h
@@ -44,11 +44,6 @@ extern int sys_cache_sync(unsigned long s, unsigned long e);
 struct pt_regs;
 
 extern asmlinkage long sys_c6x_clone(struct pt_regs *regs);
-extern asmlinkage long sys_c6x_execve(const char __user *name,
-				      const char __user *const __user *argv,
-				      const char __user *const __user *envp,
-				      struct pt_regs *regs);
-
 
 #include <asm-generic/syscalls.h>
 
diff --git a/arch/c6x/include/asm/unistd.h b/arch/c6x/include/asm/unistd.h
index 1ce3a6f..3c131d5 100644
--- a/arch/c6x/include/asm/unistd.h
+++ b/arch/c6x/include/asm/unistd.h
@@ -17,6 +17,7 @@
 #define _ASM_C6X_UNISTD_H
 
 #define __ARCH_WANT_KERNEL_EXECVE
+#define __ARCH_WANT_SYS_EXECVE
 
 /* Use the standard ABI for syscalls. */
 #include <asm-generic/unistd.h>
diff --git a/arch/c6x/kernel/entry.S b/arch/c6x/kernel/entry.S
index 693002b..1c0e867 100644
--- a/arch/c6x/kernel/entry.S
+++ b/arch/c6x/kernel/entry.S
@@ -645,29 +645,6 @@ ENTRY(sys_rt_sigreturn)
 #endif
 ENDPROC(sys_rt_sigreturn)
 
-ENTRY(sys_execve)
-	ADDAW	.D2	SP,2,B6		; put regs addr in 4th parameter
-					; & adjust regs stack addr
-	LDW	.D2T2	*+SP(REGS_B4+8),B4
-
-	;; c6x_execve(char *name, char **argv,
-	;;            char **envp, struct pt_regs *regs)
-#ifdef CONFIG_C6X_BIG_KERNEL
- ||	MVKL	.S1	sys_c6x_execve,A0
-	MVKH	.S1	sys_c6x_execve,A0
-	B	.S2X	A0
-#else
- ||	B	.S2	sys_c6x_execve
-#endif
-	STW	.D2T2	B3,*SP--[2]
-	ADDKPC	.S2	ret_from_c6x_execve,B3,3
-
-ret_from_c6x_execve:
-	LDW	.D2T2	*++SP[2],B3
-	NOP	4
-	BNOP	.S2	B3,5
-ENDPROC(sys_execve)
-
 ENTRY(sys_pread_c6x)
 	MV	.D2X	A8,B7
 #ifdef CONFIG_C6X_BIG_KERNEL
diff --git a/arch/c6x/kernel/process.c b/arch/c6x/kernel/process.c
index 45e924a..e83d872 100644
--- a/arch/c6x/kernel/process.c
+++ b/arch/c6x/kernel/process.c
@@ -221,28 +221,6 @@ int copy_thread(unsigned long clone_flags, unsigned long usp,
 	return 0;
 }
 
-/*
- * c6x_execve() executes a new program.
- */
-SYSCALL_DEFINE4(c6x_execve, const char __user *, name,
-		const char __user *const __user *, argv,
-		const char __user *const __user *, envp,
-		struct pt_regs *, regs)
-{
-	int error;
-	char *filename;
-
-	filename = getname(name);
-	error = PTR_ERR(filename);
-	if (IS_ERR(filename))
-		goto out;
-
-	error = do_execve(filename, argv, envp, regs);
-	putname(filename);
-out:
-	return error;
-}
-
 unsigned long get_wchan(struct task_struct *p)
 {
 	return p->thread.wchan;
-- 
1.7.9.1

