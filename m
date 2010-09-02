Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab0IBPsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:48:32 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58030 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099Ab0IBPsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:48:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BmQZvZt9iAaRCWmOt9ROyBtOoBiLjfOGPvR7C/ynwDNB6ZgUlnS9Fkmm6wNVs6+u1P
         cxMdDrfXmNZW+A3EH3dM40YWdVnSqPc2zWketgeBfWA5J3jTbj4bTLV0wacguB0/vXCr
         gV9hx4a/5Dw7OkIfZqHpmeW2crCpgc4R9NfxE=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH v2 18/24] ptrace: cleanup arch_ptrace() on powerpc
Date: Fri,  3 Sep 2010 00:46:25 +0900
Message-Id: <1283442391-23612-19-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
References: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use new 'datavp' and 'datalp' variables in order to remove unnecessary
castings.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/kernel/ptrace.c |   51 +++++++++++++++++++++--------------------
 1 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index e4b6d75..8d5301c 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -1409,26 +1409,28 @@ static long ppc_del_hwdebug(struct task_struct *child, long addr, long data)
 static long arch_ptrace_old(struct task_struct *child, long request,
 			    unsigned long addr, unsigned long data)
 {
+	void __user *datavp = (void __user *) data;
+
 	switch (request) {
 	case PPC_PTRACE_GETREGS:	/* Get GPRs 0 - 31. */
 		return copy_regset_to_user(child, &user_ppc_native_view,
 					   REGSET_GPR, 0, 32 * sizeof(long),
-					   (void __user *) data);
+					   datavp);
 
 	case PPC_PTRACE_SETREGS:	/* Set GPRs 0 - 31. */
 		return copy_regset_from_user(child, &user_ppc_native_view,
 					     REGSET_GPR, 0, 32 * sizeof(long),
-					     (const void __user *) data);
+					     datavp);
 
 	case PPC_PTRACE_GETFPREGS:	/* Get FPRs 0 - 31. */
 		return copy_regset_to_user(child, &user_ppc_native_view,
 					   REGSET_FPR, 0, 32 * sizeof(double),
-					   (void __user *) data);
+					   datavp);
 
 	case PPC_PTRACE_SETFPREGS:	/* Set FPRs 0 - 31. */
 		return copy_regset_from_user(child, &user_ppc_native_view,
 					     REGSET_FPR, 0, 32 * sizeof(double),
-					     (const void __user *) data);
+					     datavp);
 	}
 
 	return -EPERM;
@@ -1438,6 +1440,8 @@ long arch_ptrace(struct task_struct *child, long request,
 		 unsigned long addr, unsigned long data)
 {
 	int ret = -EPERM;
+	void __user *datavp = (void __user *) data;
+	unsigned long __user *datalp = datavp;
 
 	switch (request) {
 	/* read the word at location addr in the USER area. */
@@ -1464,7 +1468,7 @@ long arch_ptrace(struct task_struct *child, long request,
 			tmp = ((unsigned long *)child->thread.fpr)
 				[TS_FPRWIDTH * (index - PT_FPR0)];
 		}
-		ret = put_user(tmp,(unsigned long __user *) data);
+		ret = put_user(tmp, datalp);
 		break;
 	}
 
@@ -1526,11 +1530,11 @@ long arch_ptrace(struct task_struct *child, long request,
 		dbginfo.features = 0;
 #endif /* CONFIG_PPC_ADV_DEBUG_REGS */
 
-		if (!access_ok(VERIFY_WRITE, data,
+		if (!access_ok(VERIFY_WRITE, datavp,
 			       sizeof(struct ppc_debug_info)))
 			return -EFAULT;
-		ret = __copy_to_user((struct ppc_debug_info __user *)data,
-				     &dbginfo, sizeof(struct ppc_debug_info)) ?
+		ret = __copy_to_user(datavp, &dbginfo,
+				     sizeof(struct ppc_debug_info)) ?
 		      -EFAULT : 0;
 		break;
 	}
@@ -1538,11 +1542,10 @@ long arch_ptrace(struct task_struct *child, long request,
 	case PPC_PTRACE_SETHWDEBUG: {
 		struct ppc_hw_breakpoint bp_info;
 
-		if (!access_ok(VERIFY_READ, data,
+		if (!access_ok(VERIFY_READ, datavp,
 			       sizeof(struct ppc_hw_breakpoint)))
 			return -EFAULT;
-		ret = __copy_from_user(&bp_info,
-				       (struct ppc_hw_breakpoint __user *)data,
+		ret = __copy_from_user(&bp_info, datavp,
 				       sizeof(struct ppc_hw_breakpoint)) ?
 		      -EFAULT : 0;
 		if (!ret)
@@ -1561,11 +1564,9 @@ long arch_ptrace(struct task_struct *child, long request,
 		if (addr > 0)
 			break;
 #ifdef CONFIG_PPC_ADV_DEBUG_REGS
-		ret = put_user(child->thread.dac1,
-			       (unsigned long __user *)data);
+		ret = put_user(child->thread.dac1, datalp);
 #else
-		ret = put_user(child->thread.dabr,
-			       (unsigned long __user *)data);
+		ret = put_user(child->thread.dabr, datalp);
 #endif
 		break;
 	}
@@ -1581,7 +1582,7 @@ long arch_ptrace(struct task_struct *child, long request,
 		return copy_regset_to_user(child, &user_ppc_native_view,
 					   REGSET_GPR,
 					   0, sizeof(struct pt_regs),
-					   (void __user *) data);
+					   datavp);
 
 #ifdef CONFIG_PPC64
 	case PTRACE_SETREGS64:
@@ -1590,19 +1591,19 @@ long arch_ptrace(struct task_struct *child, long request,
 		return copy_regset_from_user(child, &user_ppc_native_view,
 					     REGSET_GPR,
 					     0, sizeof(struct pt_regs),
-					     (const void __user *) data);
+					     datavp);
 
 	case PTRACE_GETFPREGS: /* Get the child FPU state (FPR0...31 + FPSCR) */
 		return copy_regset_to_user(child, &user_ppc_native_view,
 					   REGSET_FPR,
 					   0, sizeof(elf_fpregset_t),
-					   (void __user *) data);
+					   datavp);
 
 	case PTRACE_SETFPREGS: /* Set the child FPU state (FPR0...31 + FPSCR) */
 		return copy_regset_from_user(child, &user_ppc_native_view,
 					     REGSET_FPR,
 					     0, sizeof(elf_fpregset_t),
-					     (const void __user *) data);
+					     datavp);
 
 #ifdef CONFIG_ALTIVEC
 	case PTRACE_GETVRREGS:
@@ -1610,40 +1611,40 @@ long arch_ptrace(struct task_struct *child, long request,
 					   REGSET_VMX,
 					   0, (33 * sizeof(vector128) +
 					       sizeof(u32)),
-					   (void __user *) data);
+					   datavp);
 
 	case PTRACE_SETVRREGS:
 		return copy_regset_from_user(child, &user_ppc_native_view,
 					     REGSET_VMX,
 					     0, (33 * sizeof(vector128) +
 						 sizeof(u32)),
-					     (const void __user *) data);
+					     datavp);
 #endif
 #ifdef CONFIG_VSX
 	case PTRACE_GETVSRREGS:
 		return copy_regset_to_user(child, &user_ppc_native_view,
 					   REGSET_VSX,
 					   0, 32 * sizeof(double),
-					   (void __user *) data);
+					   datavp);
 
 	case PTRACE_SETVSRREGS:
 		return copy_regset_from_user(child, &user_ppc_native_view,
 					     REGSET_VSX,
 					     0, 32 * sizeof(double),
-					     (const void __user *) data);
+					     datavp);
 #endif
 #ifdef CONFIG_SPE
 	case PTRACE_GETEVRREGS:
 		/* Get the child spe register state. */
 		return copy_regset_to_user(child, &user_ppc_native_view,
 					   REGSET_SPE, 0, 35 * sizeof(u32),
-					   (void __user *) data);
+					   datavp);
 
 	case PTRACE_SETEVRREGS:
 		/* Set the child spe register state. */
 		return copy_regset_from_user(child, &user_ppc_native_view,
 					     REGSET_SPE, 0, 35 * sizeof(u32),
-					     (const void __user *) data);
+					     datavp);
 #endif
 
 	/* Old reverse args ptrace callss */
-- 
1.7.2.2

