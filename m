Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936101Ab2KATrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 15:47:13 -0400
Received: from smtp.outflux.net ([198.145.64.163]:56013 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935167Ab2KATrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 15:47:02 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        Will Drewry <wad@chromium.org>, Geremy Condra <gcondra@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 2/4] arch/arm: move secure_computing into trace
Date: Thu,  1 Nov 2012 12:46:37 -0700
Message-Id: <1351799199-6853-3-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351799199-6853-1-git-send-email-keescook@chromium.org>
References: <1351799199-6853-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is very little difference in the TIF_SECCOMP and TIF_SYSCALL_TRACE
path in entry-common.S. In order to add support for
CONFIG_HAVE_ARCH_SECCOMP_FILTER without mangling the assembly too badly,
seccomp was moved into the syscall_trace_enter() handler.

Expanded ptrace_syscall_trace() into both callers to make code more
readable, as requested by Al Viro.

Additionally, the return value for secure_computing() is now checked
and a -1 value will result in the system call being skipped.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/kernel/entry-common.S |    9 ++-------
 arch/arm/kernel/ptrace.c       |   39 +++++++++++++++++++++++++--------------
 2 files changed, 27 insertions(+), 21 deletions(-)

diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 3471175..c781012 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -418,13 +418,8 @@ local_restart:
 	stmdb	sp!, {r4, r5}			@ push fifth and sixth args
 
 #ifdef CONFIG_SECCOMP
-	tst	r10, #_TIF_SECCOMP
-	beq	1f
-	mov	r0, scno
-	bl	__secure_computing	
-	add	r0, sp, #S_R0 + S_OFF		@ pointer to regs
-	ldmia	r0, {r0 - r3}			@ have to reload r0 - r3
-1:
+	tst	r10, #_TIF_SECCOMP		@ is seccomp enabled?
+	bne	__sys_trace
 #endif
 
 	tst	r10, #_TIF_SYSCALL_WORK		@ are we tracing syscalls?
diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 739db3a..6b0e14b 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -916,13 +916,15 @@ enum ptrace_syscall_dir {
 	PTRACE_SYSCALL_EXIT,
 };
 
-static int ptrace_syscall_trace(struct pt_regs *regs, int scno,
-				enum ptrace_syscall_dir dir)
+asmlinkage int syscall_trace_enter(struct pt_regs *regs, int scno)
 {
 	unsigned long ip;
 
 	current_thread_info()->syscall = scno;
 
+	if (secure_computing(scno) == -1)
+		return -1;
+
 	if (!test_thread_flag(TIF_SYSCALL_TRACE))
 		return scno;
 
@@ -931,20 +933,13 @@ static int ptrace_syscall_trace(struct pt_regs *regs, int scno,
 	 * IP = 0 -> entry, =1 -> exit
 	 */
 	ip = regs->ARM_ip;
-	regs->ARM_ip = dir;
-
-	if (dir == PTRACE_SYSCALL_EXIT)
-		tracehook_report_syscall_exit(regs, 0);
-	else if (tracehook_report_syscall_entry(regs))
+	regs->ARM_ip = PTRACE_SYSCALL_ENTER;
+	if (tracehook_report_syscall_entry(regs))
 		current_thread_info()->syscall = -1;
-
 	regs->ARM_ip = ip;
-	return current_thread_info()->syscall;
-}
 
-asmlinkage int syscall_trace_enter(struct pt_regs *regs, int scno)
-{
-	scno = ptrace_syscall_trace(regs, scno, PTRACE_SYSCALL_ENTER);
+	scno = current_thread_info()->syscall;
+
 	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
 		trace_sys_enter(regs, scno);
 	audit_syscall_entry(AUDIT_ARCH_ARM, scno, regs->ARM_r0, regs->ARM_r1,
@@ -954,7 +949,23 @@ asmlinkage int syscall_trace_enter(struct pt_regs *regs, int scno)
 
 asmlinkage int syscall_trace_exit(struct pt_regs *regs, int scno)
 {
-	scno = ptrace_syscall_trace(regs, scno, PTRACE_SYSCALL_EXIT);
+	unsigned long ip;
+
+	current_thread_info()->syscall = scno;
+
+	if (!test_thread_flag(TIF_SYSCALL_TRACE))
+		return scno;
+
+	/*
+	 * IP is used to denote syscall entry/exit:
+	 * IP = 0 -> entry, =1 -> exit
+	 */
+	ip = regs->ARM_ip;
+	regs->ARM_ip = PTRACE_SYSCALL_EXIT;
+	tracehook_report_syscall_exit(regs, 0);
+	regs->ARM_ip = ip;
+
+	scno = current_thread_info()->syscall;
 	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
 		trace_sys_exit(regs, scno);
 	audit_syscall_exit(regs);
-- 
1.7.9.5

