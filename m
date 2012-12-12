Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab2LLW1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 17:27:47 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:18249 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619Ab2LLW1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 17:27:45 -0500
Message-ID: <201212122227.qBCMRiNg000851@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 12 Dec 2012 17:24:39 -0500
Subject: [PATCH] arch/tile: provide PT_FLAGS_COMPAT value in pt_regs
To: <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This flag is set for ptrace GETREGS or PEEKUSER for processes
that are COMPAT, i.e. 32-bit.  This allows things like strace
to easily discover what personality to use, for example.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/uapi/asm/ptrace.h |    6 ++++
 arch/tile/kernel/ptrace.c           |   57 ++++++++++++++++++++++++-----------
 2 files changed, 46 insertions(+), 17 deletions(-)

diff --git a/arch/tile/include/uapi/asm/ptrace.h b/arch/tile/include/uapi/asm/ptrace.h
index c717d0f..0d22088 100644
--- a/arch/tile/include/uapi/asm/ptrace.h
+++ b/arch/tile/include/uapi/asm/ptrace.h
@@ -84,5 +84,11 @@ struct pt_regs {
 #define PTRACE_O_TRACEMIGRATE	0x00010000
 #define PTRACE_EVENT_MIGRATE	16
 
+/*
+ * Flag bits in pt_regs.flags that are part of the ptrace API.
+ * We start our numbering higher up to avoid confusion with the
+ * non-ABI kernel-internal values that use the low 16 bits.
+ */
+#define PT_FLAGS_COMPAT		0x10000  /* process is an -m32 compat process */
 
 #endif /* _UAPI_ASM_TILE_PTRACE_H */
diff --git a/arch/tile/kernel/ptrace.c b/arch/tile/kernel/ptrace.c
index e92e405..64ba102 100644
--- a/arch/tile/kernel/ptrace.c
+++ b/arch/tile/kernel/ptrace.c
@@ -45,6 +45,41 @@ void ptrace_disable(struct task_struct *child)
 	clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
 }
 
+/*
+ * Get registers from task and ready the result for userspace.
+ * Note that we localize the API issues to getregs() and putregs() at
+ * some cost in performance, e.g. we need a full pt_regs copy for
+ * PEEKUSR, and two copies for POKEUSR.  But in general we expect
+ * GETREGS/PUTREGS to be the API of choice anyway.
+ */
+static char *getregs(struct task_struct *child, struct pt_regs *uregs)
+{
+	*uregs = *task_pt_regs(child);
+
+	/* Set up flags ABI bits. */
+	uregs->flags = 0;
+#ifdef CONFIG_COMPAT
+	if (task_thread_info(child)->status & TS_COMPAT)
+		uregs->flags |= PT_FLAGS_COMPAT;
+#endif
+
+	return (char *)uregs;
+}
+
+/* Put registers back to task. */
+static void putregs(struct task_struct *child, struct pt_regs *uregs)
+{
+	struct pt_regs *regs = task_pt_regs(child);
+
+	/* Don't allow overwriting the kernel-internal flags word. */
+	uregs->flags = regs->flags;
+
+	/* Only allow setting the ICS bit in the ex1 word. */
+	uregs->ex1 = PL_ICS_EX1(USER_PL, EX1_ICS(uregs->ex1));
+
+	*regs = *uregs;
+}
+
 long arch_ptrace(struct task_struct *child, long request,
 		 unsigned long addr, unsigned long data)
 {
@@ -53,14 +88,13 @@ long arch_ptrace(struct task_struct *child, long request,
 	long ret = -EIO;
 	char *childreg;
 	struct pt_regs copyregs;
-	int ex1_offset;
 
 	switch (request) {
 
 	case PTRACE_PEEKUSR:  /* Read register from pt_regs. */
 		if (addr >= PTREGS_SIZE)
 			break;
-		childreg = (char *)task_pt_regs(child) + addr;
+		childreg = getregs(child, &copyregs) + addr;
 #ifdef CONFIG_COMPAT
 		if (is_compat_task()) {
 			if (addr & (sizeof(compat_long_t)-1))
@@ -79,17 +113,7 @@ long arch_ptrace(struct task_struct *child, long request,
 	case PTRACE_POKEUSR:  /* Write register in pt_regs. */
 		if (addr >= PTREGS_SIZE)
 			break;
-		childreg = (char *)task_pt_regs(child) + addr;
-
-		/* Guard against overwrites of the privilege level. */
-		ex1_offset = PTREGS_OFFSET_EX1;
-#if defined(CONFIG_COMPAT) && defined(__BIG_ENDIAN)
-		if (is_compat_task())   /* point at low word */
-			ex1_offset += sizeof(compat_long_t);
-#endif
-		if (addr == ex1_offset)
-			data = PL_ICS_EX1(USER_PL, EX1_ICS(data));
-
+		childreg = getregs(child, &copyregs) + addr;
 #ifdef CONFIG_COMPAT
 		if (is_compat_task()) {
 			if (addr & (sizeof(compat_long_t)-1))
@@ -102,11 +126,12 @@ long arch_ptrace(struct task_struct *child, long request,
 				break;
 			*(long *)childreg = data;
 		}
+		putregs(child, &copyregs);
 		ret = 0;
 		break;
 
 	case PTRACE_GETREGS:  /* Get all registers from the child. */
-		if (copy_to_user(datap, task_pt_regs(child),
+		if (copy_to_user(datap, getregs(child, &copyregs),
 				 sizeof(struct pt_regs)) == 0) {
 			ret = 0;
 		}
@@ -115,9 +140,7 @@ long arch_ptrace(struct task_struct *child, long request,
 	case PTRACE_SETREGS:  /* Set all registers in the child. */
 		if (copy_from_user(&copyregs, datap,
 				   sizeof(struct pt_regs)) == 0) {
-			copyregs.ex1 =
-				PL_ICS_EX1(USER_PL, EX1_ICS(copyregs.ex1));
-			*task_pt_regs(child) = copyregs;
+			putregs(child, &copyregs);
 			ret = 0;
 		}
 		break;
-- 
1.7.10.3

