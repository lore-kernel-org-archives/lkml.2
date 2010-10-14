Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab0JNVQf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:16:35 -0400
Received: from king.tilera.com ([72.1.168.226]:52863 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932157Ab0JNVQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:16:27 -0400
Message-Id: <6ee55caed0b3a26537637f6e15d65bfe6288ff73.1287090291.git.cmetcalf@tilera.com>
In-Reply-To: <cover.1287090280.git.cmetcalf@tilera.com>
References: <cover.1287090280.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 14 Oct 2010 16:48:00 -0400
Subject: [PATCH 13/14] arch/tile: make ptrace() work properly for TILE-Gx COMPAT mode
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
X-OriginalArrivalTime: 14 Oct 2010 21:16:24.0215 (UTC) FILETIME=[0E525270:01CB6BE5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, we tried to pass 64-bit arguments through the
"COMPAT" mode 32-bit syscall API, which turned out not to work
well.  Now we just use straight 32-bit arguments in COMPAT mode,
thus requiring individual registers to be read/written with
two syscalls.  Of course this is uncommon, since usually all
the registers are read or written at once.

The restructuring applies to all the tile platforms, but is
plausibly better than the original code in any case.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/compat.c |    4 +-
 arch/tile/kernel/ptrace.c |   78 +++++++++++++++++++++------------------------
 2 files changed, 38 insertions(+), 44 deletions(-)

diff --git a/arch/tile/kernel/compat.c b/arch/tile/kernel/compat.c
index 5f24e54..77739cd 100644
--- a/arch/tile/kernel/compat.c
+++ b/arch/tile/kernel/compat.c
@@ -154,8 +154,8 @@ long tile_compat_sys_msgrcv(int msqid,
 #define compat_sys_fstat64 sys_newfstat
 #define compat_sys_fstatat64 sys_newfstatat
 
-/* Pass full 64-bit values through ptrace. */
-#define compat_sys_ptrace tile_compat_sys_ptrace
+/* The native sys_ptrace dynamically handles compat binaries. */
+#define compat_sys_ptrace sys_ptrace
 
 /* Call the trampolines to manage pt_regs where necessary. */
 #define compat_sys_execve _compat_sys_execve
diff --git a/arch/tile/kernel/ptrace.c b/arch/tile/kernel/ptrace.c
index 7161bd0..5b20c28 100644
--- a/arch/tile/kernel/ptrace.c
+++ b/arch/tile/kernel/ptrace.c
@@ -32,25 +32,6 @@ void user_disable_single_step(struct task_struct *child)
 }
 
 /*
- * This routine will put a word on the process's privileged stack.
- */
-static void putreg(struct task_struct *task,
-		   unsigned long addr, unsigned long value)
-{
-	unsigned int regno = addr / sizeof(unsigned long);
-	struct pt_regs *childregs = task_pt_regs(task);
-	childregs->regs[regno] = value;
-	childregs->flags |= PT_FLAGS_RESTORE_REGS;
-}
-
-static unsigned long getreg(struct task_struct *task, unsigned long addr)
-{
-	unsigned int regno = addr / sizeof(unsigned long);
-	struct pt_regs *childregs = task_pt_regs(task);
-	return childregs->regs[regno];
-}
-
-/*
  * Called by kernel/ptrace.c when detaching..
  */
 void ptrace_disable(struct task_struct *child)
@@ -66,59 +47,72 @@ void ptrace_disable(struct task_struct *child)
 
 long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 {
-	unsigned long __user *datap;
+	unsigned long __user *datap = (long __user __force *)data;
 	unsigned long tmp;
 	int i;
 	long ret = -EIO;
-
-#ifdef CONFIG_COMPAT
-	if (task_thread_info(current)->status & TS_COMPAT)
-		data = (u32)data;
-	if (task_thread_info(child)->status & TS_COMPAT)
-		addr = (u32)addr;
-#endif
-	datap = (unsigned long __user __force *)data;
+	unsigned long *childregs;
+	char *childreg;
 
 	switch (request) {
 
 	case PTRACE_PEEKUSR:  /* Read register from pt_regs. */
-		if (addr & (sizeof(data)-1))
-			break;
 		if (addr < 0 || addr >= PTREGS_SIZE)
 			break;
-		tmp = getreg(child, addr);   /* Read register */
-		ret = put_user(tmp, datap);
+		childreg = (char *)task_pt_regs(child) + addr;
+#ifdef CONFIG_COMPAT
+		if (is_compat_task()) {
+			if (addr & (sizeof(compat_long_t)-1))
+				break;
+			ret = put_user(*(compat_long_t *)childreg,
+				       (compat_long_t __user *)datap);
+		} else
+#endif
+		{
+			if (addr & (sizeof(long)-1))
+				break;
+			ret = put_user(*(long *)childreg, datap);
+		}
 		break;
 
 	case PTRACE_POKEUSR:  /* Write register in pt_regs. */
-		if (addr & (sizeof(data)-1))
-			break;
 		if (addr < 0 || addr >= PTREGS_SIZE)
 			break;
-		putreg(child, addr, data);   /* Write register */
+		childreg = (char *)task_pt_regs(child) + addr;
+#ifdef CONFIG_COMPAT
+		if (is_compat_task()) {
+			if (addr & (sizeof(compat_long_t)-1))
+				break;
+			*(compat_long_t *)childreg = data;
+		} else
+#endif
+		{
+			if (addr & (sizeof(long)-1))
+				break;
+			*(long *)childreg = data;
+		}
 		ret = 0;
 		break;
 
 	case PTRACE_GETREGS:  /* Get all registers from the child. */
 		if (!access_ok(VERIFY_WRITE, datap, PTREGS_SIZE))
 			break;
-		for (i = 0; i < PTREGS_SIZE; i += sizeof(long)) {
-			ret = __put_user(getreg(child, i), datap);
+		childregs = (long *)task_pt_regs(child);
+		for (i = 0; i < sizeof(struct pt_regs)/sizeof(long); ++i) {
+			ret = __put_user(childregs[i], &datap[i]);
 			if (ret != 0)
 				break;
-			datap++;
 		}
 		break;
 
 	case PTRACE_SETREGS:  /* Set all registers in the child. */
 		if (!access_ok(VERIFY_READ, datap, PTREGS_SIZE))
 			break;
-		for (i = 0; i < PTREGS_SIZE; i += sizeof(long)) {
-			ret = __get_user(tmp, datap);
+		childregs = (long *)task_pt_regs(child);
+		for (i = 0; i < sizeof(struct pt_regs)/sizeof(long); ++i) {
+			ret = __get_user(childregs[i], &datap[i]);
 			if (ret != 0)
 				break;
-			putreg(child, i, tmp);
-			datap++;
 		}
 		break;
 
-- 
1.6.5.2

