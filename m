Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab2KLLvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 06:51:49 -0500
Received: from us01smtp3.synopsys.com ([198.182.44.81]:57570 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab2KLLvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 06:51:46 -0500
From: <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <arnd@arndb.de>,
        Mischa Jonker <Mischa.Jonker@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC Patch v1 46/55] ARC: kgdb support
Date: Mon, 12 Nov 2012 17:19:04 +0530
Message-ID: <1352720953-24321-16-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1352720953-24321-1-git-send-email-vgupta@synopsys.com>
References: <1352720953-24321-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mischa Jonker <mjonker@synopsys.com>

Signed-off-by: Mischa Jonker <mjonker@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/Kconfig            |    5 +-
 arch/arc/include/asm/kgdb.h |   61 +++++++++++++
 arch/arc/kernel/Makefile    |    2 +
 arch/arc/kernel/kgdb.c      |  205 +++++++++++++++++++++++++++++++++++++++++++
 arch/arc/kernel/traps.c     |    6 ++
 5 files changed, 277 insertions(+), 2 deletions(-)
 create mode 100644 arch/arc/include/asm/kgdb.h
 create mode 100644 arch/arc/kernel/kgdb.c

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 81d78fc..b878d3e 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -20,6 +20,7 @@ config ARC
 	select GENERIC_KERNEL_THREAD
 	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_SMP_IDLE_THREAD
+	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_KPROBES
@@ -383,12 +384,12 @@ config ARC_DW2_UNWIND
 
 config ARC_DBG_TLB_PARANOIA
 	bool "Paranoia Checks in Low Level TLB Handlers"
-	depends on ARC_DBG && !SMP
+	depends on ARC_DBG
 	default n
 
 config ARC_DBG_EVENT_TIMELINE
 	bool "Low level event capture"
-	depends on ARC_DBG
+	depends on ARC_DBG && !SMP
 	default n
 	help
 	  Capture low level events: IRQ/Trap/Exception
diff --git a/arch/arc/include/asm/kgdb.h b/arch/arc/include/asm/kgdb.h
new file mode 100644
index 0000000..f3c4934
--- /dev/null
+++ b/arch/arc/include/asm/kgdb.h
@@ -0,0 +1,61 @@
+/*
+ * kgdb support for ARC
+ *
+ * Copyright (C) 2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ARC_KGDB_H__
+#define __ARC_KGDB_H__
+
+#ifdef CONFIG_KGDB
+
+#include <asm/user.h>
+
+/* to ensure compatibility with Linux 2.6.35, we don't implement the get/set
+ * register API yet */
+#undef DBG_MAX_REG_NUM
+
+#define GDB_MAX_REGS		39
+
+#define BREAK_INSTR_SIZE	2
+#define CACHE_FLUSH_IS_SAFE	1
+#define NUMREGBYTES		(GDB_MAX_REGS * 4)
+#define BUFMAX			2048
+
+static inline void arch_kgdb_breakpoint(void)
+{
+	__asm__ __volatile__ ("trap_s	0x4\n");
+}
+
+extern void kgdb_trap(struct pt_regs *regs, int param);
+
+enum arc700_linux_regnums {
+	_R0		= 0,
+	_R1, _R2, _R3, _R4, _R5, _R6, _R7, _R8, _R9, _R10, _R11, _R12, _R13,
+	_R14, _R15, _R16, _R17, _R18, _R19, _R20, _R21, _R22, _R23, _R24,
+	_R25, _R26,
+	_BTA		= 27,
+	_LP_START	= 28,
+	_LP_END		= 29,
+	_LP_COUNT	= 30,
+	_STATUS32	= 31,
+	_BLINK		= 32,
+	_FP		= 33,
+	__SP		= 34,
+	_EFA		= 35,
+	_RET		= 36,
+	_ORIG_R8	= 37,
+	_STOP_PC	= 38
+};
+
+#else
+static inline void kgdb_trap(struct pt_regs *regs, int param)
+{
+}
+#endif
+
+#endif	/* __ARC_KGDB_H__ */
diff --git a/arch/arc/kernel/Makefile b/arch/arc/kernel/Makefile
index 52ef6ce..a2b7493 100644
--- a/arch/arc/kernel/Makefile
+++ b/arch/arc/kernel/Makefile
@@ -17,6 +17,8 @@ obj-$(CONFIG_SMP) 			+= smp.o
 obj-$(CONFIG_ARC_DW2_UNWIND)		+= unwind.o
 obj-$(CONFIG_KPROBES)      		+= kprobes.o
 obj-$(CONFIG_ARC_MISALIGN_ACCESS) 	+= unaligned.o
+obj-$(CONFIG_KGDB)			+= kgdb.o
+
 obj-$(CONFIG_ARC_FPU_SAVE_RESTORE)	+= fpu.o
 CFLAGS_fpu.o   += -mdpfp
 
diff --git a/arch/arc/kernel/kgdb.c b/arch/arc/kernel/kgdb.c
new file mode 100644
index 0000000..2888ba5
--- /dev/null
+++ b/arch/arc/kernel/kgdb.c
@@ -0,0 +1,205 @@
+/*
+ * kgdb support for ARC
+ *
+ * Copyright (C) 2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kgdb.h>
+#include <asm/disasm.h>
+#include <asm/cacheflush.h>
+
+static void to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *kernel_regs,
+			struct callee_regs *cregs)
+{
+	int regno;
+
+	for (regno = 0; regno <= 26; regno++)
+		gdb_regs[_R0 + regno] = get_reg(regno, kernel_regs, cregs);
+
+	for (regno = 27; regno < GDB_MAX_REGS; regno++)
+		gdb_regs[regno] = 0;
+
+	gdb_regs[_FP]		= kernel_regs->fp;
+	gdb_regs[__SP]		= kernel_regs->sp;
+	gdb_regs[_BLINK]	= kernel_regs->blink;
+	gdb_regs[_RET]		= kernel_regs->ret;
+	gdb_regs[_STATUS32]	= kernel_regs->status32;
+	gdb_regs[_LP_COUNT]	= kernel_regs->lp_count;
+	gdb_regs[_LP_END]	= kernel_regs->lp_end;
+	gdb_regs[_LP_START]	= kernel_regs->lp_start;
+	gdb_regs[_BTA]		= kernel_regs->bta;
+	gdb_regs[_STOP_PC]	= kernel_regs->ret;
+}
+
+static void from_gdb_regs(unsigned long *gdb_regs, struct pt_regs *kernel_regs,
+			struct callee_regs *cregs)
+{
+	int regno;
+
+	for (regno = 0; regno <= 26; regno++)
+		set_reg(regno, gdb_regs[regno + _R0], kernel_regs, cregs);
+
+	kernel_regs->fp		= gdb_regs[_FP];
+	kernel_regs->sp		= gdb_regs[__SP];
+	kernel_regs->blink	= gdb_regs[_BLINK];
+	kernel_regs->ret	= gdb_regs[_RET];
+	kernel_regs->status32	= gdb_regs[_STATUS32];
+	kernel_regs->lp_count	= gdb_regs[_LP_COUNT];
+	kernel_regs->lp_end	= gdb_regs[_LP_END];
+	kernel_regs->lp_start	= gdb_regs[_LP_START];
+	kernel_regs->bta	= gdb_regs[_BTA];
+}
+
+
+void pt_regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *kernel_regs)
+{
+	to_gdb_regs(gdb_regs, kernel_regs, (struct callee_regs *)
+		current->thread.callee_reg);
+}
+
+void gdb_regs_to_pt_regs(unsigned long *gdb_regs, struct pt_regs *kernel_regs)
+{
+	from_gdb_regs(gdb_regs, kernel_regs, (struct callee_regs *)
+		current->thread.callee_reg);
+}
+
+void sleeping_thread_to_gdb_regs(unsigned long *gdb_regs,
+				 struct task_struct *task)
+{
+	if (task)
+		to_gdb_regs(gdb_regs, task_pt_regs(task),
+			(struct callee_regs *) task->thread.callee_reg);
+}
+
+struct single_step_data_t {
+	uint16_t opcode[2];
+	unsigned long address[2];
+	int is_branch;
+	int armed;
+} single_step_data;
+
+static void undo_single_step(struct pt_regs *regs)
+{
+	if (single_step_data.armed) {
+		int i;
+
+		for (i = 0; i < (single_step_data.is_branch ? 2 : 1); i++) {
+			memcpy((void *) single_step_data.address[i],
+				&single_step_data.opcode[i],
+				BREAK_INSTR_SIZE);
+
+			flush_icache_range(single_step_data.address[i],
+				single_step_data.address[i] +
+				BREAK_INSTR_SIZE);
+		}
+		single_step_data.armed = 0;
+	}
+}
+
+static void place_trap(unsigned long address, void *save)
+{
+	memcpy(save, (void *) address, BREAK_INSTR_SIZE);
+	memcpy((void *) address, &arch_kgdb_ops.gdb_bpt_instr,
+		BREAK_INSTR_SIZE);
+	flush_icache_range(address, address + BREAK_INSTR_SIZE);
+}
+
+static void do_single_step(struct pt_regs *regs)
+{
+	single_step_data.is_branch = disasm_next_pc((unsigned long)
+		regs->ret, regs, (struct callee_regs *)
+		current->thread.callee_reg,
+		&single_step_data.address[0],
+		&single_step_data.address[1]);
+
+	place_trap(single_step_data.address[0], &single_step_data.opcode[0]);
+
+	if (single_step_data.is_branch) {
+		place_trap(single_step_data.address[1],
+			&single_step_data.opcode[1]);
+	}
+
+	single_step_data.armed++;
+}
+
+int kgdb_arch_handle_exception(int e_vector, int signo, int err_code,
+			       char *remcomInBuffer, char *remcomOutBuffer,
+			       struct pt_regs *regs)
+{
+	unsigned long addr;
+	char *ptr;
+
+	undo_single_step(regs);
+
+	switch (remcomInBuffer[0]) {
+	case 's':
+	case 'c':
+		ptr = &remcomInBuffer[1];
+		if (kgdb_hex2long(&ptr, &addr))
+			regs->ret = addr;
+
+	case 'D':
+	case 'k':
+		atomic_set(&kgdb_cpu_doing_single_step, -1);
+
+		if (remcomInBuffer[0] == 's') {
+			do_single_step(regs);
+			atomic_set(&kgdb_cpu_doing_single_step,
+				   smp_processor_id());
+		}
+
+		return 0;
+	}
+	return -1;
+}
+
+unsigned long kgdb_arch_pc(int exception, struct pt_regs *regs)
+{
+	return instruction_pointer(regs);
+}
+
+int kgdb_arch_init(void)
+{
+	single_step_data.armed = 0;
+	return 0;
+}
+
+void kgdb_trap(struct pt_regs *regs, int param)
+{
+	/* trap_s 3 is used for breakpoints that overwrite existing
+	 * instructions, while trap_s 4 is used for compiled breakpoints.
+	 *
+	 * with trap_s 3 breakpoints the original instruction needs to be
+	 * restored and continuation needs to start at the location of the
+	 * breakpoint.
+	 *
+	 * with trap_s 4 (compiled) breakpoints, continuation needs to
+	 * start after the breakpoint.
+	 */
+	if (param == 3)
+		instruction_pointer(regs) -= BREAK_INSTR_SIZE;
+
+	kgdb_handle_exception(1, SIGTRAP, 0, regs);
+}
+
+void kgdb_arch_exit(void)
+{
+}
+
+void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long ip)
+{
+	instruction_pointer(regs) = ip;
+}
+
+struct kgdb_arch arch_kgdb_ops = {
+	/* breakpoint instruction: TRAP_S 0x3 */
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	.gdb_bpt_instr		= {0x78, 0x7e},
+#else
+	.gdb_bpt_instr		= {0x7e, 0x78},
+#endif
+};
diff --git a/arch/arc/kernel/traps.c b/arch/arc/kernel/traps.c
index d2bc5bd..689c3fb 100644
--- a/arch/arc/kernel/traps.c
+++ b/arch/arc/kernel/traps.c
@@ -20,6 +20,7 @@
 #include <asm/setup.h>
 #include <asm/kprobes.h>
 #include <asm/unaligned.h>
+#include <asm/kgdb.h>
 
 void __init trap_init(void)
 {
@@ -141,6 +142,11 @@ void do_non_swi_trap(unsigned long cause, unsigned long address,
 		trap_is_kprobe(param, address, regs);
 		break;
 
+	case 3:
+	case 4:
+		kgdb_trap(regs, param);
+		break;
+
 	default:
 		break;
 	}
-- 
1.7.4.1

