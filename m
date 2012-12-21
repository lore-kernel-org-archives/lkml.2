Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab2LULRL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 06:17:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868Ab2LULQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 06:16:48 -0500
From: Anton Arapov <anton@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Anton Arapov <anton@redhat.com>,
        Anithra P Janakiraman <anithra@linux.vnet.ibm.com>
Subject: [RFC PATCH 1/6] uretprobes/x86: hijack return address
Date: Fri, 21 Dec 2012 12:16:31 +0100
Message-Id: <1356088596-17858-2-git-send-email-anton@redhat.com>
In-Reply-To: <1356088596-17858-1-git-send-email-anton@redhat.com>
References: <1356088596-17858-1-git-send-email-anton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function to hijack the return address, replace it with a "trampoline"
and functio to predict the stack pointer address value at return.

Signed-off-by: Anton Arapov <anton@redhat.com>
Signed-off-by: Anithra P Janakiraman <anithra@linux.vnet.ibm.com>
---
 arch/x86/include/asm/uprobes.h |  6 +++++
 arch/x86/kernel/uprobes.c      | 57 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/uprobes.h        | 11 +++++++-
 kernel/events/uprobes.c        |  5 +++-
 4 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
index 8ff8be7..9517c55 100644
--- a/arch/x86/include/asm/uprobes.h
+++ b/arch/x86/include/asm/uprobes.h
@@ -18,9 +18,11 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  *
  * Copyright (C) IBM Corporation, 2008-2011
+ * Copyright (C) Red Hat, Inc. 2011-2012
  * Authors:
  *	Srikar Dronamraju
  *	Jim Keniston
+ *	Anton Arapov (uretprobes)
  */
 
 #include <linux/notifier.h>
@@ -55,4 +57,7 @@ extern int  arch_uprobe_post_xol(struct arch_uprobe *aup, struct pt_regs *regs);
 extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
 extern int  arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data);
 extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *regs);
+
+extern unsigned long arch_uretprobe_hijack_return_addr(unsigned long rp_trampoline_vaddr, struct pt_regs *regs);
+extern unsigned long arch_uretprobe_predict_sp_at_return(struct pt_regs *regs, struct task_struct *tsk);
 #endif	/* _ASM_UPROBES_H */
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index c71025b..1a30607 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -16,9 +16,11 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  *
  * Copyright (C) IBM Corporation, 2008-2011
+ * Copyright (C) Red Hat, Inc. 2011-2012
  * Authors:
  *	Srikar Dronamraju
  *	Jim Keniston
+ *	Anton Arapov (uretprobes)
  */
 #include <linux/kernel.h>
 #include <linux/sched.h>
@@ -695,3 +697,57 @@ bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
 		send_sig(SIGTRAP, current, 0);
 	return ret;
 }
+
+extern unsigned long
+arch_uretprobe_hijack_return_addr(unsigned long rp_trampoline_vaddr, struct pt_regs *regs)
+{
+	struct uprobe_task *utask = current->utask;
+	int rasize, ncopied;
+	unsigned long orig_return_vaddr = 0; /* clear high bits for 32-bit apps */
+
+	if (is_ia32_task())
+		rasize = 4;
+	else
+		rasize = 8;
+
+	ncopied = copy_from_user(&orig_return_vaddr, (void __user *)regs->sp, rasize);
+	if (unlikely(ncopied))
+		return -EFAULT;
+
+	/* check whether address has been already hijacked */
+	if (orig_return_vaddr == rp_trampoline_vaddr)
+		return orig_return_vaddr;
+
+	ncopied = copy_to_user((void __user *)regs->sp, &rp_trampoline_vaddr, rasize);
+	if (unlikely(ncopied)) {
+		if (ncopied != rasize) {
+			printk(KERN_ERR "uretprobe: return address clobbered: "
+					"pid=%d, %%sp=%#lx, %%ip=%#lx\n",
+					current->pid, regs->sp, regs->ip);
+			utask->doomed = true;
+		}
+		return -EFAULT;
+	}
+
+	return orig_return_vaddr;
+}
+
+/*
+ * On x86_32, if a function returns a struct or union, the return
+ * value is copied into an area created by the caller. The address
+ * of this area is passed on the stack as a "hidden" first argument.
+ * When such a function returns, it uses a "ret $4" instruction to pop
+ * not only the return address but also the hidden arg.  To accommodate
+ * such functions, we add 4 bytes of slop when predicting the return
+ * address. See PR #10078.
+ */
+#define STRUCT_RETURN_SLOP 4
+
+extern unsigned long
+arch_uretprobe_predict_sp_at_return(struct pt_regs *regs, struct task_struct *tsk)
+{
+	if (test_tsk_thread_flag(tsk, TIF_IA32))
+		return (unsigned long) (regs->sp + 4 + STRUCT_RETURN_SLOP);
+	else
+		return (unsigned long) (regs->sp + 8);
+}
diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 83742b9..a5db480 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -18,10 +18,13 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  *
  * Copyright (C) IBM Corporation, 2008-2012
+ * Copyright (C) Red Hat, Inc. 2011-2012
  * Authors:
  *	Srikar Dronamraju
  *	Jim Keniston
- * Copyright (C) 2011-2012 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *	Oleg Nesterov
+ *	Peter Zijlstra <pzijlstr@redhat.com>
+ *	Anton Arapov (uretprobes)
  */
 
 #include <linux/errno.h>
@@ -60,6 +63,12 @@ struct uprobe_task {
 
 	unsigned long			xol_vaddr;
 	unsigned long			vaddr;
+
+	/*
+	 * Unexpected error in probe point handling has left task's
+	 * text or stack corrupted. Kill task ASAP.
+	 */
+	bool				doomed;
 };
 
 /*
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index c3b65d1..30f2ebc 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -16,10 +16,12 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  *
  * Copyright (C) IBM Corporation, 2008-2012
+ * Copyright (C) Red Hat, Inc. 2011-2012
  * Authors:
  *	Srikar Dronamraju
  *	Jim Keniston
- * Copyright (C) 2011-2012 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *	Peter Zijlstra <pzijlstr@redhat.com>
+ *	Anton Arapov (uretprobes)
  */
 
 #include <linux/kernel.h>
@@ -1298,6 +1300,7 @@ static struct uprobe_task *add_utask(void)
 	if (unlikely(!utask))
 		return NULL;
 
+	utask->doomed = false;
 	current->utask = utask;
 	return utask;
 }
-- 
1.8.0.2

