Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933460Ab2GEXPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 19:15:21 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33775 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933392Ab2GEXPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 19:15:11 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Colin Cross <ccross@android.com>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        kernel-team@android.com, kgdb-bugreport@lists.sourceforge.net
Subject: =?UTF-8?q?=5BPATCH=204/6=5D=20ARM=3A=20Add=20KGDB/KDB=20FIQ=20debugger=20generic=20code?=
Date: Thu,  5 Jul 2012 16:12:38 -0700
Message-Id: <1341529960-18370-4-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20120705231034.GA16931@lizard>
References: <20120705231034.GA16931@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FIQ debugger may be used to debug situations when the kernel stuck
in uninterruptable sections, e.g. the kernel infinitely loops or
deadlocked in an interrupt or with interrupts disabled.

By default KGDB FIQ is disabled in runtime, but can be enabled with
kgdb_fiq.enable=1 kernel command line option.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 arch/arm/Kconfig                 |   14 +++++++
 arch/arm/include/asm/kgdb.h      |    8 ++++
 arch/arm/kernel/Makefile         |    1 +
 arch/arm/kernel/kgdb_fiq.c       |   78 +++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/kgdb_fiq_entry.S |   80 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 181 insertions(+)
 create mode 100644 arch/arm/kernel/kgdb_fiq.c
 create mode 100644 arch/arm/kernel/kgdb_fiq_entry.S

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index a91009c..bc558d1 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -172,6 +172,20 @@ config GENERIC_ISA_DMA
 config FIQ
 	bool
 
+config KGDB_FIQ
+	bool "KGDB/KDB FIQ debugger"
+	select FIQ
+	help
+	  The FIQ debugger may be used to debug situations when the
+	  kernel stuck in uninterruptable sections, e.g. the kernel
+	  infinitely loops or deadlocked in an interrupt or with
+	  interrupts disabled.
+
+	  By default KGDB FIQ is disabled in runtime, but can be
+	  enabled with kgdb_fiq.enable=1 kernel command line option.
+
+	  If unsure, say N.
+
 config NEED_RET_TO_USER
 	bool
 
diff --git a/arch/arm/include/asm/kgdb.h b/arch/arm/include/asm/kgdb.h
index 48066ce..ee51024 100644
--- a/arch/arm/include/asm/kgdb.h
+++ b/arch/arm/include/asm/kgdb.h
@@ -11,6 +11,8 @@
 #define __ARM_KGDB_H__
 
 #include <linux/ptrace.h>
+#include <linux/linkage.h>
+#include <asm/exception.h>
 
 /*
  * GDB assumes that we're a user process being debugged, so
@@ -47,6 +49,12 @@ static inline void arch_kgdb_breakpoint(void)
 extern void kgdb_handle_bus_error(void);
 extern int kgdb_fault_expected;
 
+extern char kgdb_fiq_handler;
+extern char kgdb_fiq_handler_end;
+asmlinkage void __exception_irq_entry kgdb_fiq_do_handle(struct pt_regs *regs);
+typedef bool (*is_kgdb_nmi_fn)(void);
+extern void kgdb_register_nmi(is_kgdb_nmi_fn is_kgdb_nmi);
+
 #endif /* !__ASSEMBLY__ */
 
 /*
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 7ad2d5c..5aa079b 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -56,6 +56,7 @@ obj-$(CONFIG_ATAGS_PROC)	+= atags.o
 obj-$(CONFIG_OABI_COMPAT)	+= sys_oabi-compat.o
 obj-$(CONFIG_ARM_THUMBEE)	+= thumbee.o
 obj-$(CONFIG_KGDB)		+= kgdb.o
+obj-$(CONFIG_KGDB_FIQ)		+= kgdb_fiq_entry.o kgdb_fiq.o
 obj-$(CONFIG_ARM_UNWIND)	+= unwind.o
 obj-$(CONFIG_HAVE_TCM)		+= tcm.o
 obj-$(CONFIG_OF)		+= devtree.o
diff --git a/arch/arm/kernel/kgdb_fiq.c b/arch/arm/kernel/kgdb_fiq.c
new file mode 100644
index 0000000..287504d
--- /dev/null
+++ b/arch/arm/kernel/kgdb_fiq.c
@@ -0,0 +1,78 @@
+/*
+ * KGDB FIQ entry
+ *
+ * Copyright 2010 Google, Inc.
+ *		  Arve Hjønnevåg <arve@android.com>
+ *		  Colin Cross <ccross@android.com>
+ * Copyright 2012 Linaro Ltd.
+ *		  Anton Vorontsov <anton.vorontsov@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/hardirq.h>
+#include <linux/kgdb.h>
+#include <asm/fiq.h>
+#include <asm/exception.h>
+
+static int kgdb_fiq_enabled;
+module_param_named(enable, kgdb_fiq_enabled, int, 0600);
+MODULE_PARM_DESC(enable, "set to 1 to enable FIQ KGDB");
+
+static long kgdb_fiq_setup_stack(void *info)
+{
+	struct pt_regs regs;
+
+	regs.ARM_sp = __get_free_pages(GFP_KERNEL, THREAD_SIZE_ORDER) +
+			THREAD_START_SP;
+	WARN_ON(!regs.ARM_sp);
+
+	set_fiq_regs(&regs);
+	return 0;
+}
+
+static is_kgdb_nmi_fn is_kgdb_nmi;
+
+asmlinkage void __exception_irq_entry kgdb_fiq_do_handle(struct pt_regs *regs)
+{
+	if (!is_kgdb_nmi())
+		return;
+
+	nmi_enter();
+	kgdb_handle_exception(1, 0, 0, regs);
+	nmi_exit();
+}
+
+static struct fiq_handler kgdb_fiq_desc = {
+	.name = "kgdb",
+};
+
+void kgdb_register_nmi(is_kgdb_nmi_fn _is_kgdb_nmi)
+{
+	int err;
+	int cpu;
+
+	if (!kgdb_fiq_enabled)
+		return;
+
+	is_kgdb_nmi = _is_kgdb_nmi;
+
+	err = claim_fiq(&kgdb_fiq_desc);
+	if (err) {
+		WARN_ON(1);
+		return;
+	}
+
+	for_each_possible_cpu(cpu)
+		work_on_cpu(cpu, kgdb_fiq_setup_stack, NULL);
+
+	set_fiq_handler(&kgdb_fiq_handler,
+			&kgdb_fiq_handler_end - &kgdb_fiq_handler);
+
+	kgdb_arch_enable_nmi(1);
+}
diff --git a/arch/arm/kernel/kgdb_fiq_entry.S b/arch/arm/kernel/kgdb_fiq_entry.S
new file mode 100644
index 0000000..8524671
--- /dev/null
+++ b/arch/arm/kernel/kgdb_fiq_entry.S
@@ -0,0 +1,80 @@
+/*
+ * KGDB FIQ entry
+ *
+ * Copyright 1996,1997,1998 Russell King.
+ * Copyright 2012 Linaro Ltd.
+ *		  Anton Vorontsov <anton.vorontsov@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ */
+
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+#include <asm/memory.h>
+#include <asm/unwind.h>
+#include "entry-header.S"
+
+	.text
+
+	.macro	fiq_handler
+	ldr	r1, =.LCdohandle
+	mov	r0, sp
+	adr	lr, BSYM(9997f)
+	ldr	pc, [r1]
+9997:
+	.endm
+
+	.align	5
+__fiq_svc:
+	svc_entry
+	fiq_handler
+	svc_exit r5				@ return from exception
+ UNWIND(.fnend		)
+ENDPROC(__fiq_svc)
+	.ltorg
+
+	.align	5
+__fiq_usr:
+	usr_entry
+	kuser_cmpxchg_check
+	fiq_handler
+	get_thread_info tsk
+	mov	why, #0
+	b	ret_to_user_from_irq
+ UNWIND(.fnend		)
+ENDPROC(__fiq_usr)
+	.ltorg
+	@ This is needed for kuser_cmpxchg_check/alignment_trap
+	.global cr_alignment
+.LCcralign:
+	.word cr_alignment
+
+.LCdohandle:
+	.long kgdb_fiq_do_handle
+
+	.global kgdb_fiq_handler
+kgdb_fiq_handler:
+
+	vector_stub	fiq, FIQ_MODE, 4
+
+	.long	__fiq_usr			@  0  (USR_26 / USR_32)
+	.long	__fiq_svc			@  1  (FIQ_26 / FIQ_32)
+	.long	__fiq_svc			@  2  (IRQ_26 / IRQ_32)
+	.long	__fiq_svc			@  3  (SVC_26 / SVC_32)
+	.long	__fiq_svc			@  4
+	.long	__fiq_svc			@  5
+	.long	__fiq_svc			@  6
+	.long	__fiq_svc			@  7
+	.long	__fiq_svc			@  8
+	.long	__fiq_svc			@  9
+	.long	__fiq_svc			@  a
+	.long	__fiq_svc			@  b
+	.long	__fiq_svc			@  c
+	.long	__fiq_svc			@  d
+	.long	__fiq_svc			@  e
+	.long	__fiq_svc			@  f
+
+	.global kgdb_fiq_handler_end
+kgdb_fiq_handler_end:
-- 
1.7.10.4

