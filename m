Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044Ab0FORMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 13:12:18 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:65499 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758018Ab0FORMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 13:12:15 -0400
From: Himanshu Chauhan <hschauhan@nulltrace.org>
To: linux-kernel@vger.kernel.org
Cc: ralf@linux-mips.org, linux-mips@linux-mips.org, ddaney@caviumnetworks.com
Subject: [PATCH 2/2] MIPS: Kretprobe support
Date: Tue, 15 Jun 2010 20:12:49 +0530
Message-Id: <1276612969-13508-3-git-send-email-hschauhan@nulltrace.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1276612969-13508-1-git-send-email-hschauhan@nulltrace.org>
References: <1276612969-13508-1-git-send-email-hschauhan@nulltrace.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for kretprobes on MIPS architecture.

Signed-off-by: Himanshu Chauhan <hschauhan@nulltrace.org>
---
 arch/mips/Kconfig          |    1 +
 arch/mips/kernel/kprobes.c |  117 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 117 insertions(+), 1 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index ba7cc87..8dd82cf 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -2248,6 +2248,7 @@ menu "Instrumentation Support"
 config KPROBES
        bool "MIPS Kprobes Support (Experimental)"
        depends on EXPERIMENTAL && MODULES
+       select HAVE_KRETPROBES
        help
 	  Kprobes allow you to trap at almost any kernel address
 	  and execute a callback function. Kprobes is useful for
diff --git a/arch/mips/kernel/kprobes.c b/arch/mips/kernel/kprobes.c
index 6b6689f..07e8a04 100644
--- a/arch/mips/kernel/kprobes.c
+++ b/arch/mips/kernel/kprobes.c
@@ -4,7 +4,9 @@
  *
  *  Copyright 2006 Sony Corp.
  *
- *  Himanshu Chauhan <hschauhan@nulltrace.org> for >2.6.35 kernels.
+ *  (C) 2010 Himanshu Chauhan <hschauhan@nulltrace.org>
+ *  o Kprobes replay on kernels >2.6.35
+ *  o Added support for kretprobes.
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -24,6 +26,7 @@
 #include <linux/kdebug.h>
 #include <linux/kprobes.h>
 #include <linux/preempt.h>
+#include <linux/slab.h>
 #include <asm/cacheflush.h>
 #include <asm/inst.h>
 #include <asm/ptrace.h>
@@ -358,6 +361,113 @@ int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
 	return ret;
 }
 
+/*
+ * When a retprobed function returns, trampoline_handler() is called,
+ * calling the kretprobe's handler. We need to generate a pt_regs
+ * frame before calling trampoline_handler. Saving RA here makes no
+ * sense because kretprobe_trampoline will have no RA, rather
+ * RA will be returned by trampoline_handler. We would only be
+ * interested in saving v0 and v1 i.e. the return value of the
+ * probed function.
+ */
+void notrace  __kprobes kretprobe_trampoline(void)
+{
+	__asm__ __volatile__ (
+		".set noreorder\n\t"
+#ifdef CONFIG_32BIT
+		"addiu $29, -152\n\t"
+		"sw $2, 32($29)\n\t"
+		"sw $3, 36($29)\n\t"
+#else
+		"addiu $29, -128\n\t"
+		"sw $2, 8($29)\n\t"
+		"sw $3, 12($29)\n\t"
+#endif
+		"jal trampoline_handler\n\t"
+		"move $4, $29\n\t"
+		"move $31, $2\n\t"
+#ifdef CONFIG_32BIT
+		"lw $2, 32($29)\n\t"
+		"lw $3, 36($29)\n\t"
+		"addiu $29, 152\n\t"
+#else
+		"lw $2, 8($29)\n\t"
+		"lw $3, 12($29)\n\t"
+		"addiu $29, 128\n\t"
+#endif
+		: : : "memory");
+}
+
+/* Called from kretprobe_trampoline */
+static __used __kprobes void *trampoline_handler(struct pt_regs *regs)
+{
+	struct kretprobe_instance *ri = NULL;
+	struct hlist_head *head, empty_rp;
+	struct hlist_node *node, *tmp;
+	unsigned long flags, orig_ret_address = 0;
+	unsigned long trampoline_address = (unsigned long)&kretprobe_trampoline;
+
+	INIT_HLIST_HEAD(&empty_rp);
+	kretprobe_hash_lock(current, &head, &flags);
+
+	/*
+	 * It is possible to have multiple instances associated with a given
+	 * task either because multiple functions in the call path have
+	 * a return probe installed on them, and/or more than one return
+	 * probe was registered for a target function.
+	 *
+	 * We can handle this because:
+	 *     - instances are always inserted at the head of the list
+	 *     - when multiple return probes are registered for the same
+	 *       function, the first instance's ret_addr will point to the
+	 *       real return address, and all the rest will point to
+	 *       kretprobe_trampoline
+	 */
+	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
+		if (ri->task != current)
+			/* another task is sharing our hash bucket */
+			continue;
+
+		if (ri->rp && ri->rp->handler) {
+			__get_cpu_var(current_kprobe) = &ri->rp->kp;
+			get_kprobe_ctlblk()->kprobe_status = KPROBE_HIT_ACTIVE;
+			ri->rp->handler(ri, regs);
+			__get_cpu_var(current_kprobe) = NULL;
+		}
+
+		orig_ret_address = (unsigned long)ri->ret_addr;
+		recycle_rp_inst(ri, &empty_rp);
+
+		if (orig_ret_address != trampoline_address)
+			/*
+			 * This is the real return address. Any other
+			 * instances associated with this task are for
+			 * other calls deeper on the call stack
+			 */
+			break;
+	}
+
+	kretprobe_assert(ri, orig_ret_address, trampoline_address);
+	kretprobe_hash_unlock(current, &flags);
+
+	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
+		hlist_del(&ri->hlist);
+		kfree(ri);
+	}
+
+	return (void *)orig_ret_address;
+}
+
+void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
+				      struct pt_regs *regs)
+{
+	/* save the ra */
+	ri->ret_addr = (kprobe_opcode_t *)regs->regs[31];
+
+	/* Replace the return addr with trampoline addr. */
+	regs->regs[31] = (unsigned long)&kretprobe_trampoline;
+}
+
 int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
 {
 	return 0;
@@ -376,3 +486,8 @@ int __init arch_init_kprobes(void)
 {
 	return 0;
 }
+
+int __kprobes arch_trampoline_kprobe(struct kprobe *p)
+{
+	return 0;
+}
-- 
1.7.0.4

