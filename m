Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab0FWKEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:04:55 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:59940 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab0FWKEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:04:47 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Jason Baron <jbaron@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Ian Munsie <imunsie@au1.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>,
       Chase Douglas <cndougla@linux.vnet.ibm.com>,
       Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       David Gibson <dwg@au1.ibm.com>
Subject: [PATCH 40/40] trace syscalls, PPC: Convert morphing native/compat syscalls
Date: Wed, 23 Jun 2010 20:03:21 +1000
Message-Id: <1277287401-28571-41-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

Several of the PowerPC system call implementations are used as both the
32bit compat version on PPC64 and the 32bit native version on PPC32.

Previousely these used the preprocessor to change the function names on
PPC64 to add the compat_ prefix.

This patch converts these system calls to use the SYSCALL_DEFINE family
of macros, with the preprocessor selecting which macro to use at their
implementation (which should also make things a little clearer, if more
verbose).

This patch also renames the swapcontext syscall and it's assembly
wrapper such that only the first three characters of their names will
differ which ftrace syscalls ignores when matching the syscall names
to their symbol names. This ensures that the appropriate meta-data will
match for this system call.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 arch/powerpc/include/asm/systbl.h |    2 +-
 arch/powerpc/kernel/entry_64.S    |    4 +-
 arch/powerpc/kernel/signal_32.c   |   56 +++++++++++++++++++++++++-----------
 3 files changed, 42 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
index 06c0a73..a0afa14 100644
--- a/arch/powerpc/include/asm/systbl.h
+++ b/arch/powerpc/include/asm/systbl.h
@@ -252,7 +252,7 @@ COMPAT_SYS_SPU(clock_settime)
 COMPAT_SYS_SPU(clock_gettime)
 COMPAT_SYS_SPU(clock_getres)
 COMPAT_SYS_SPU(clock_nanosleep)
-SYSX(ppc64_swapcontext,ppc32_swapcontext,ppc_swapcontext)
+SYSX(ppc_swapcontext,ppc32_swapcontext,ppc_swapcontext)
 COMPAT_SYS_SPU(tgkill)
 COMPAT_SYS_SPU(utimes)
 COMPAT_SYS_SPU(statfs64)
diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index 42e9d90..8c23ff1 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -346,10 +346,10 @@ _GLOBAL(ppc_clone)
 
 _GLOBAL(ppc32_swapcontext)
 	bl	.save_nvgprs
-	bl	.compat_sys_swapcontext
+	bl	.sys32_swapcontext
 	b	syscall_exit
 
-_GLOBAL(ppc64_swapcontext)
+_GLOBAL(ppc_swapcontext)
 	bl	.save_nvgprs
 	bl	.sys_swapcontext
 	b	syscall_exit
diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
index 212583d..2c4071f 100644
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -55,13 +55,6 @@
 #undef DEBUG_SIG
 
 #ifdef CONFIG_PPC64
-#define sys_sigsuspend	compat_sys_sigsuspend
-#define sys_rt_sigsuspend	compat_sys_rt_sigsuspend
-#define sys_rt_sigreturn	compat_sys_rt_sigreturn
-#define sys_sigaction	compat_sys_sigaction
-#define sys_swapcontext	compat_sys_swapcontext
-#define sys_sigreturn	compat_sys_sigreturn
-
 #define old_sigaction	old_sigaction32
 #define sigcontext	sigcontext32
 #define mcontext	mcontext32
@@ -239,7 +232,11 @@ static inline int restore_general_regs(struct pt_regs *regs,
 /*
  * Atomically swap in the new signal mask, and wait for a signal.
  */
-long sys_sigsuspend(old_sigset_t mask)
+#ifdef CONFIG_PPC64
+COMPAT_SYSCALL_DEFINE1(sigsuspend, old_sigset_t, mask)
+#else
+SYSCALL_DEFINE1(sigsuspend, old_sigset_t, mask)
+#endif
 {
 	mask &= _BLOCKABLE;
 	spin_lock_irq(&current->sighand->siglock);
@@ -254,8 +251,15 @@ long sys_sigsuspend(old_sigset_t mask)
  	return -ERESTARTNOHAND;
 }
 
-long sys_sigaction(int sig, struct old_sigaction __user *act,
-		struct old_sigaction __user *oact)
+#ifdef CONFIG_PPC64
+COMPAT_SYSCALL_DEFINE3(sigaction, int, sig,
+		struct old_sigaction __user *, act,
+		struct old_sigaction __user *, oact)
+#else
+SYSCALL_DEFINE3(sigaction, int, sig,
+		struct old_sigaction __user *, act,
+		struct old_sigaction __user *, oact)
+#endif
 {
 	struct k_sigaction new_ka, old_ka;
 	int ret;
@@ -938,9 +942,21 @@ static int do_setcontext(struct ucontext __user *ucp, struct pt_regs *regs, int
 	return 0;
 }
 
-long sys_swapcontext(struct ucontext __user *old_ctx,
-		     struct ucontext __user *new_ctx,
-		     int ctx_size, int r6, int r7, int r8, struct pt_regs *regs)
+/*
+ * Note: Named sys_swapcontext on PPC32 and sys32_swapcontext on PPC64.
+ * Ensures that it's name will still match when compared with it's wrappers
+ * name (ppc_swapcontext on PPC32, ppc32_swapcontext on PPC64) for ftrace
+ * syscalls (which ignores the 1st three characters).
+ */
+#ifdef CONFIG_PPC64
+PPC_REGS_COMPAT_SYSCALL_DEFINEx(3, long, sys32_, swapcontext, regs,
+		struct ucontext __user *, old_ctx,
+		struct ucontext __user *, new_ctx, int, ctx_size)
+#else
+PPC_REGS_SYSCALL_DEFINE3_RET(long, swapcontext, regs,
+		struct ucontext __user *, old_ctx,
+		struct ucontext __user *, new_ctx, int, ctx_size)
+#endif
 {
 	unsigned char tmp;
 	int ctx_has_vsx_region = 0;
@@ -1029,8 +1045,11 @@ long sys_swapcontext(struct ucontext __user *old_ctx,
 	return 0;
 }
 
-long sys_rt_sigreturn(int r3, int r4, int r5, int r6, int r7, int r8,
-		     struct pt_regs *regs)
+#ifdef CONFIG_PPC64
+PPC_REGS_COMPAT_SYSCALL_DEFINE0_RET(long, rt_sigreturn, regs)
+#else
+PPC_REGS_SYSCALL_DEFINE0_RET(long, rt_sigreturn, regs)
+#endif
 {
 	struct rt_sigframe __user *rt_sf;
 
@@ -1256,8 +1275,11 @@ badframe:
 /*
  * Do a signal return; undo the signal stack.
  */
-long sys_sigreturn(int r3, int r4, int r5, int r6, int r7, int r8,
-		       struct pt_regs *regs)
+#ifdef CONFIG_PPC64
+PPC_REGS_COMPAT_SYSCALL_DEFINE0_RET(long, sigreturn, regs)
+#else
+PPC_REGS_SYSCALL_DEFINE0_RET(long, sigreturn, regs)
+#endif
 {
 	struct sigcontext __user *sc;
 	struct sigcontext sigctx;
-- 
1.7.1

