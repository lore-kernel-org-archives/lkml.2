Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab2KGJsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:48:39 -0500
Received: from kiruna.synopsys.com ([198.182.44.80]:58053 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab2KGJsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:48:33 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, arnd@arndb.de,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC PATCH v1 13/31] ARC: Non-MMU Exception Handling
Date: Wed,  7 Nov 2012 10:47:36 +0100
Message-Id: <1352281674-2186-14-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/hw_irq.h |    7 --
 arch/arc/kernel/traps.c       |  125 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 125 insertions(+), 7 deletions(-)
 delete mode 100644 arch/arc/include/asm/hw_irq.h
 create mode 100644 arch/arc/kernel/traps.c

diff --git a/arch/arc/include/asm/hw_irq.h b/arch/arc/include/asm/hw_irq.h
deleted file mode 100644
index fd565ab..0000000
--- a/arch/arc/include/asm/hw_irq.h
+++ /dev/null
@@ -1,7 +0,0 @@
-/*
- * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
diff --git a/arch/arc/kernel/traps.c b/arch/arc/kernel/traps.c
new file mode 100644
index 0000000..fd2457c
--- /dev/null
+++ b/arch/arc/kernel/traps.c
@@ -0,0 +1,125 @@
+/*
+ * Traps/Non-MMU Exception handling for ARC
+ *
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Rahul Trivedi: Codito Technologies 2004
+ */
+
+#include <linux/sched.h>
+#include <linux/kdebug.h>
+#include <linux/uaccess.h>
+#include <asm/ptrace.h>
+#include <asm/setup.h>
+
+void __init trap_init(void)
+{
+	return;
+}
+
+void die(const char *str, struct pt_regs *regs, unsigned long address,
+	 unsigned long cause_reg)
+{
+	show_kernel_fault_diag(str, regs, address, cause_reg);
+
+	/* DEAD END */
+	__asm__("flag 1");
+}
+
+/*
+ * Helper called for bulk of exceptions NOT needing specific handling
+ *  -for user faults enqueues requested signal
+ *  -for kernel, chk if due to copy_(to|from)_user, otherwise die()
+ */
+static noinline int handle_exception(unsigned long cause, char *str,
+				     struct pt_regs *regs, siginfo_t *info)
+{
+	if (user_mode(regs)) {
+		struct task_struct *tsk = current;
+
+		tsk->thread.fault_address = (__force unsigned int)info->si_addr;
+		tsk->thread.cause_code = cause;
+
+		force_sig_info(info->si_signo, info, tsk);
+
+	} else {
+		/* If not due to copy_(to|from)_user, we are doomed */
+		if (fixup_exception(regs))
+			return 0;
+
+		die(str, regs, (unsigned long)info->si_addr, cause);
+	}
+
+	return 1;
+}
+
+#define DO_ERROR_INFO(signr, str, name, sicode) \
+int name(unsigned long cause, unsigned long address, struct pt_regs *regs) \
+{						\
+	siginfo_t info = {			\
+		.si_signo = signr,		\
+		.si_errno = 0,			\
+		.si_code  = sicode,		\
+		.si_addr = (void __user *)address,	\
+	};					\
+	return handle_exception(cause, str, regs, &info);\
+}
+
+/*
+ * Entry points for exceptions NOT needing specific handling
+ */
+DO_ERROR_INFO(SIGILL, "Priv Op/Disabled Extn", do_privilege_fault, ILL_PRVOPC)
+DO_ERROR_INFO(SIGILL, "Invalid Extn Insn", do_extension_fault, ILL_ILLOPC)
+DO_ERROR_INFO(SIGILL, "Illegal Insn (or Seq)", insterror_is_error, ILL_ILLOPC)
+DO_ERROR_INFO(SIGBUS, "Invalid Mem Access", do_memory_error, BUS_ADRERR)
+DO_ERROR_INFO(SIGTRAP, "Breakpoint Set", trap_is_brkpt, TRAP_BRKPT)
+
+DO_ERROR_INFO(SIGSEGV, "Misaligned Access", do_misaligned_access, SEGV_ACCERR)
+
+/*
+ * Entry point for miscll errors such as Nested Exceptions
+ *  -Duplicate TLB entry is handled seperately though
+ */
+void do_machine_check_fault(unsigned long cause, unsigned long address,
+			    struct pt_regs *regs)
+{
+	die("Machine Check Exception", regs, address, cause);
+}
+
+/*
+ * Entry point for traps induced by ARCompact TRAP_S <n> insn
+ * This is same family as TRAP0/SWI insn (use the same vector).
+ * The only difference being SWI insn take no operand, while TRAP_S does
+ * which reflects in ECR Reg as 8 bit param.
+ * Thus TRAP_S <n> can be used for specific purpose
+ *  -1 used for software breakpointing (gdb)
+ *  -2 used by kprobes
+ */
+void do_non_swi_trap(unsigned long cause, unsigned long address,
+			struct pt_regs *regs)
+{
+	unsigned int param = cause & 0xff;
+
+	switch (param) {
+	case 1:
+		trap_is_brkpt(cause, address, regs);
+		break;
+
+	default:
+		break;
+	}
+}
+
+/*
+ * Entry point for Instruction Error Exception
+ */
+void do_insterror_or_kprobe(unsigned long cause,
+				       unsigned long address,
+				       struct pt_regs *regs)
+{
+	insterror_is_error(cause, address, regs);
+}
-- 
1.7.4.1

