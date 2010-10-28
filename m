Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761597Ab0J1UF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 16:05:29 -0400
Received: from king.tilera.com ([72.1.168.226]:23087 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934246Ab0J1UEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 16:04:24 -0400
Message-Id: <201010282003.o9SK3YbE006825@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 28 Oct 2010 15:47:06 -0400
Subject: [PATCH] arch/tile: don't allow user code to set the PL via ptrace or signal return
References: <20100923221141.GK19804@ZenIV.linux.org.uk> <9lYpY1#WLHA.1516@exchange1.tad.internal.tilera.com> <4CC89352.7020808@tilera.com> <20101027213745.GI19804@ZenIV.linux.org.uk> <20101027213745.GI19804@ZenIV.linux.org.uk>
In-Reply-To: <20101027233012.GJ19804@ZenIV.linux.org.uk>
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Arnd Bergmann <arnd@arndb.de>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 28 Oct 2010 20:03:34.0203 (UTC) FILETIME=[335FE8B0:01CB76DB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel was allowing any component of the pt_regs to be updated either
by signal handlers writing to the stack, or by processes writing via
PTRACE_POKEUSR or PTRACE_SETREGS, which meant they could set their PL
up from 0 to 1 and get access to kernel code and data (or, in practice,
cause a kernel panic).  We now always reset the ex1 field, allowing the
user to set their ICS bit only.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
This was caught by Al Viro wondering out loud if tile properly handled
this case, and we didn't.  Thanks Al!

 arch/tile/kernel/ptrace.c |   37 +++++++++++++++++++++----------------
 arch/tile/kernel/signal.c |    3 +++
 2 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/arch/tile/kernel/ptrace.c b/arch/tile/kernel/ptrace.c
index 5b20c28..6d0cef8 100644
--- a/arch/tile/kernel/ptrace.c
+++ b/arch/tile/kernel/ptrace.c
@@ -49,10 +49,10 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 {
 	unsigned long __user *datap = (long __user __force *)data;
 	unsigned long tmp;
-	int i;
 	long ret = -EIO;
-	unsigned long *childregs;
 	char *childreg;
+	struct pt_regs copyregs;
+	int ex1_offset;
 
 	switch (request) {
 
@@ -79,6 +79,16 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		if (addr < 0 || addr >= PTREGS_SIZE)
 			break;
 		childreg = (char *)task_pt_regs(child) + addr;
+
+		/* Guard against overwrites of the privilege level. */
+		ex1_offset = PTREGS_OFFSET_EX1;
+#if defined(CONFIG_COMPAT) && defined(__BIG_ENDIAN)
+		if (is_compat_task())   /* point at low word */
+			ex1_offset += sizeof(compat_long_t);
+#endif
+		if (addr == ex1_offset)
+			data = PL_ICS_EX1(USER_PL, EX1_ICS(data));
+
 #ifdef CONFIG_COMPAT
 		if (is_compat_task()) {
 			if (addr & (sizeof(compat_long_t)-1))
@@ -95,24 +105,19 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		break;
 
 	case PTRACE_GETREGS:  /* Get all registers from the child. */
-		if (!access_ok(VERIFY_WRITE, datap, PTREGS_SIZE))
-			break;
-		childregs = (long *)task_pt_regs(child);
-		for (i = 0; i < sizeof(struct pt_regs)/sizeof(long); ++i) {
-			ret = __put_user(childregs[i], &datap[i]);
-			if (ret != 0)
-				break;
+		if (copy_to_user(datap, task_pt_regs(child),
+				 sizeof(struct pt_regs)) == 0) {
+			ret = 0;
 		}
 		break;
 
 	case PTRACE_SETREGS:  /* Set all registers in the child. */
-		if (!access_ok(VERIFY_READ, datap, PTREGS_SIZE))
-			break;
-		childregs = (long *)task_pt_regs(child);
-		for (i = 0; i < sizeof(struct pt_regs)/sizeof(long); ++i) {
-			ret = __get_user(childregs[i], &datap[i]);
-			if (ret != 0)
-				break;
+		if (copy_from_user(&copyregs, datap,
+				   sizeof(struct pt_regs)) == 0) {
+			copyregs.ex1 =
+				PL_ICS_EX1(USER_PL, EX1_ICS(copyregs.ex1));
+			*task_pt_regs(child) = copyregs;
+			ret = 0;
 		}
 		break;
 
diff --git a/arch/tile/kernel/signal.c b/arch/tile/kernel/signal.c
index 704ce0b..687719d 100644
--- a/arch/tile/kernel/signal.c
+++ b/arch/tile/kernel/signal.c
@@ -71,6 +71,9 @@ int restore_sigcontext(struct pt_regs *regs,
 	for (i = 0; i < sizeof(struct pt_regs)/sizeof(long); ++i)
 		err |= __get_user(regs->regs[i], &sc->gregs[i]);
 
+	/* Ensure that the PL is always set to USER_PL. */
+	regs->ex1 = PL_ICS_EX1(USER_PL, EX1_ICS(regs->ex1));
+
 	regs->faultnum = INT_SWINT_1_SIGRETURN;
 
 	err |= __get_user(*pr0, &sc->gregs[0]);
-- 
1.6.5.2

