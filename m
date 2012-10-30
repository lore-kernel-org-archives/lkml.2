Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab2J3Bl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 21:41:57 -0400
Received: from smtp.outflux.net ([198.145.64.163]:56171 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629Ab2J3Bl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 21:41:56 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        Will Drewry <wad@chromium.org>, Geremy Condra <gcondra@google.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 2/4] arch/arm: move secure_computing into trace
Date: Mon, 29 Oct 2012 17:41:20 -0700
Message-Id: <1351557682-20983-3-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351557682-20983-1-git-send-email-keescook@chromium.org>
References: <1351557682-20983-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Drewry <wad@chromium.org>

There is very little difference in the TIF_SECCOMP and TIF_SYSCALL_TRACE
path in entry-common.S. In order to add support for
CONFIG_HAVE_ARCH_SECCOMP_FILTER without mangling the assembly too badly,
seccomp was moved into the syscall_trace_enter() handler.

Additionally, the return value for secure_computing() is now checked
and a -1 value will result in the system call being skipped.

Signed-off-by: Will Drewry <wad@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/kernel/entry-common.S |    9 ++-------
 arch/arm/kernel/ptrace.c       |    3 +++
 2 files changed, 5 insertions(+), 7 deletions(-)

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
index 739db3a..aa4d93f 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -923,6 +923,9 @@ static int ptrace_syscall_trace(struct pt_regs *regs, int scno,
 
 	current_thread_info()->syscall = scno;
 
+	if (dir == PTRACE_SYSCALL_ENTER && secure_computing(scno) == -1)
+		return -1;
+
 	if (!test_thread_flag(TIF_SYSCALL_TRACE))
 		return scno;
 
-- 
1.7.9.5

