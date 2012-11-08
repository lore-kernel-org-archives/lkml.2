Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab2KHU76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 15:59:58 -0500
Received: from smtp.outflux.net ([198.145.64.163]:36272 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756681Ab2KHU7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 15:59:54 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        Geremy Condra <gcondra@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>
Subject: [PATCH 2/4] arch/arm: move secure_computing into trace
Date: Thu,  8 Nov 2012 12:59:31 -0800
Message-Id: <1352408373-25047-3-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352408373-25047-1-git-send-email-keescook@chromium.org>
References: <1352408373-25047-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is very little difference in the TIF_SECCOMP and TIF_SYSCALL_WORK
path in entry-common.S, so merge TIF_SECCOMP into TIF_SYSCALL_WORK and
move seccomp into the syscall_trace_enter() handler.

Expanded some of the tracehook logic into the callers to make this code
more readable. Since tracehook needs to do register changing, this portion
is best left in its own function instead of copy/pasting into the callers.

Additionally, the return value for secure_computing() is now checked
and a -1 value will result in the system call being skipped.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/include/asm/thread_info.h |    7 ++++---
 arch/arm/kernel/entry-common.S     |   10 ----------
 arch/arm/kernel/ptrace.c           |   33 ++++++++++++++++++++++++---------
 3 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index 8477b4c..cddda1f 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -151,10 +151,10 @@ extern int vfp_restore_user_hwstate(struct user_vfp __user *,
 #define TIF_SYSCALL_TRACE	8
 #define TIF_SYSCALL_AUDIT	9
 #define TIF_SYSCALL_TRACEPOINT	10
+#define TIF_SECCOMP		11	/* seccomp syscall filtering active */
 #define TIF_USING_IWMMXT	17
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
 #define TIF_RESTORE_SIGMASK	20
-#define TIF_SECCOMP		21
 #define TIF_SWITCH_MM		22	/* deferred switch_mm */
 
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
@@ -163,11 +163,12 @@ extern int vfp_restore_user_hwstate(struct user_vfp __user *,
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
-#define _TIF_USING_IWMMXT	(1 << TIF_USING_IWMMXT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
+#define _TIF_USING_IWMMXT	(1 << TIF_USING_IWMMXT)
 
 /* Checks for any syscall work in entry-common.S */
-#define _TIF_SYSCALL_WORK (_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | _TIF_SYSCALL_TRACEPOINT)
+#define _TIF_SYSCALL_WORK (_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | \
+			   _TIF_SYSCALL_TRACEPOINT | _TIF_SECCOMP)
 
 /*
  * Change these and you break ASM code in entry-common.S
diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 3471175..8355d4b 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -417,16 +417,6 @@ local_restart:
 	ldr	r10, [tsk, #TI_FLAGS]		@ check for syscall tracing
 	stmdb	sp!, {r4, r5}			@ push fifth and sixth args
 
-#ifdef CONFIG_SECCOMP
-	tst	r10, #_TIF_SECCOMP
-	beq	1f
-	mov	r0, scno
-	bl	__secure_computing	
-	add	r0, sp, #S_R0 + S_OFF		@ pointer to regs
-	ldmia	r0, {r0 - r3}			@ have to reload r0 - r3
-1:
-#endif
-
 	tst	r10, #_TIF_SYSCALL_WORK		@ are we tracing syscalls?
 	bne	__sys_trace
 
diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 739db3a..2aecf8f 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -916,16 +916,11 @@ enum ptrace_syscall_dir {
 	PTRACE_SYSCALL_EXIT,
 };
 
-static int ptrace_syscall_trace(struct pt_regs *regs, int scno,
-				enum ptrace_syscall_dir dir)
+static int tracehook_report_syscall(struct pt_regs *regs,
+				    enum ptrace_syscall_dir dir)
 {
 	unsigned long ip;
 
-	current_thread_info()->syscall = scno;
-
-	if (!test_thread_flag(TIF_SYSCALL_TRACE))
-		return scno;
-
 	/*
 	 * IP is used to denote syscall entry/exit:
 	 * IP = 0 -> entry, =1 -> exit
@@ -944,19 +939,39 @@ static int ptrace_syscall_trace(struct pt_regs *regs, int scno,
 
 asmlinkage int syscall_trace_enter(struct pt_regs *regs, int scno)
 {
-	scno = ptrace_syscall_trace(regs, scno, PTRACE_SYSCALL_ENTER);
+	current_thread_info()->syscall = scno;
+
+	/* do the secure computing check first */
+	if (secure_computing(scno) == -1) {
+		/* seccomp failures shouldn't expose any additional code. */
+		scno = -1;
+		goto out;
+	}
+
+	if (test_thread_flag(TIF_SYSCALL_TRACE))
+		scno = tracehook_report_syscall(regs, PTRACE_SYSCALL_ENTER);
+
 	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
 		trace_sys_enter(regs, scno);
+
 	audit_syscall_entry(AUDIT_ARCH_ARM, scno, regs->ARM_r0, regs->ARM_r1,
 			    regs->ARM_r2, regs->ARM_r3);
+
+out:
 	return scno;
 }
 
 asmlinkage int syscall_trace_exit(struct pt_regs *regs, int scno)
 {
-	scno = ptrace_syscall_trace(regs, scno, PTRACE_SYSCALL_EXIT);
+	current_thread_info()->syscall = scno;
+
+	if (test_thread_flag(TIF_SYSCALL_TRACE))
+		scno = tracehook_report_syscall(regs, PTRACE_SYSCALL_EXIT);
+
 	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
 		trace_sys_exit(regs, scno);
+
 	audit_syscall_exit(regs);
+
 	return scno;
 }
-- 
1.7.9.5

