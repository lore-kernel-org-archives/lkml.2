Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab2KLLvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 06:51:41 -0500
Received: from kiruna.synopsys.com ([198.182.44.80]:35818 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab2KLLvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 06:51:37 -0500
From: <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <arnd@arndb.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC Patch v1 45/55] ARC: unaligned access emulation
Date: Mon, 12 Nov 2012 17:19:03 +0530
Message-ID: <1352720953-24321-15-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1352720953-24321-1-git-send-email-vgupta@synopsys.com>
References: <1352720953-24321-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/Kconfig                 |    9 ++
 arch/arc/include/asm/Kbuild      |    1 -
 arch/arc/include/asm/ptrace.h    |    3 +
 arch/arc/include/asm/unaligned.h |   29 +++++
 arch/arc/kernel/Makefile         |    3 +-
 arch/arc/kernel/disasm.c         |    2 +-
 arch/arc/kernel/entry.S          |   13 ++
 arch/arc/kernel/traps.c          |   26 +++++
 arch/arc/kernel/unaligned.c      |  225 ++++++++++++++++++++++++++++++++++++++
 9 files changed, 308 insertions(+), 3 deletions(-)
 create mode 100644 arch/arc/include/asm/unaligned.h
 create mode 100644 arch/arc/kernel/unaligned.c

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 3ef21be..81d78fc 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -343,6 +343,15 @@ config ARC_CURR_IN_REG
 	  This reserved Register R25 to point to Current Task in
 	  kernel mode. This saves memory access for each such access
 
+
+config ARC_MISALIGN_ACCESS
+	bool "Emulate unaligned memory access (userspace only)"
+	default N
+	help
+	  This enables misaligned 16 & 32 bit memory access from user space.
+	  Use ONLY-IF-ABS-NECESSARY as it will be very slow and also can hide
+	  potential bugs in code
+
 config ARC_STACK_NONEXEC
 	bool "Make stack non-executable"
 	default n
diff --git a/arch/arc/include/asm/Kbuild b/arch/arc/include/asm/Kbuild
index a246390..06ca702 100644
--- a/arch/arc/include/asm/Kbuild
+++ b/arch/arc/include/asm/Kbuild
@@ -51,7 +51,6 @@ generic-y += termios.h
 generic-y += topology.h
 generic-y += types.h
 generic-y += ucontext.h
-generic-y += unaligned.h
 generic-y += user.h
 generic-y += vga.h
 generic-y += xor.h
diff --git a/arch/arc/include/asm/ptrace.h b/arch/arc/include/asm/ptrace.h
index bb621e8..2843dd4 100644
--- a/arch/arc/include/asm/ptrace.h
+++ b/arch/arc/include/asm/ptrace.h
@@ -117,6 +117,9 @@ struct user_regs_struct {
 /* return 1 if user mode or 0 if kernel mode */
 #define user_mode(regs) (regs->status32 & STATUS_U_MASK)
 
+/* return 1 if PC in delay slot */
+#define delay_mode(regs) ((regs->status32 & STATUS_DE_MASK) == STATUS_DE_MASK)
+
 /* return 1 if in syscall, 0 if Intr or Exception */
 #define in_syscall(regs) (((regs->orig_r8) >= 0 && \
 			   (regs->orig_r8 <= NR_syscalls)) ? 1 : 0)
diff --git a/arch/arc/include/asm/unaligned.h b/arch/arc/include/asm/unaligned.h
new file mode 100644
index 0000000..5dbe63f
--- /dev/null
+++ b/arch/arc/include/asm/unaligned.h
@@ -0,0 +1,29 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_ARC_UNALIGNED_H
+#define _ASM_ARC_UNALIGNED_H
+
+/* ARC700 can't handle unaligned Data accesses. */
+
+#include <asm-generic/unaligned.h>
+#include <asm/ptrace.h>
+
+#ifdef CONFIG_ARC_MISALIGN_ACCESS
+int misaligned_fixup(unsigned long address, struct pt_regs *regs,
+		     unsigned long cause, struct callee_regs *cregs);
+#else
+static inline int
+misaligned_fixup(unsigned long address, struct pt_regs *regs,
+		 unsigned long cause, struct callee_regs *cregs)
+{
+	return 0;
+}
+#endif
+
+#endif /* _ASM_ARC_UNALIGNED_H */
diff --git a/arch/arc/kernel/Makefile b/arch/arc/kernel/Makefile
index 442d024..52ef6ce 100644
--- a/arch/arc/kernel/Makefile
+++ b/arch/arc/kernel/Makefile
@@ -9,13 +9,14 @@
 CFLAGS_ptrace.o		+= -DUTS_MACHINE='"$(UTS_MACHINE)"'
 
 obj-y	:= arcksyms.o setup.o irq.o time.o reset.o ptrace.o entry.o process.o \
-	   signal.o traps.o sys.o troubleshoot.o stacktrace.o disasm.c
+	   signal.o traps.o sys.o troubleshoot.o stacktrace.o disasm.o
 
 obj-$(CONFIG_MODULES)			+= arcksyms.o module.o
 obj-$(CONFIG_ARC_DBG_EVENT_TIMELINE)	+= event-log.o
 obj-$(CONFIG_SMP) 			+= smp.o
 obj-$(CONFIG_ARC_DW2_UNWIND)		+= unwind.o
 obj-$(CONFIG_KPROBES)      		+= kprobes.o
+obj-$(CONFIG_ARC_MISALIGN_ACCESS) 	+= unaligned.o
 obj-$(CONFIG_ARC_FPU_SAVE_RESTORE)	+= fpu.o
 CFLAGS_fpu.o   += -mdpfp
 
diff --git a/arch/arc/kernel/disasm.c b/arch/arc/kernel/disasm.c
index 51bad8f..2f39028 100644
--- a/arch/arc/kernel/disasm.c
+++ b/arch/arc/kernel/disasm.c
@@ -15,7 +15,7 @@
 #include <asm/disasm.h>
 #include <asm/uaccess.h>
 
-#if defined(CONFIG_KGDB) || defined(CONFIG_MISALIGN_ACCESS) || \
+#if defined(CONFIG_KGDB) || defined(CONFIG_ARC_MISALIGN_ACCESS) || \
 	defined(CONFIG_KPROBES)
 
 /* disasm_instr: Analyses instruction at addr, stores
diff --git a/arch/arc/kernel/entry.S b/arch/arc/kernel/entry.S
index 13d6feb..2ff15e0 100644
--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -12,6 +12,9 @@
  *   needed before task_pt_regs was invented. This saves a branch per call
  *   and more importantly allows clean invocation of post-syscall ptrace hook
  *
+ * vineetg: May 2011
+ *  -Userspace unaligned access emulation
+ *
  * vineetg: Feb 2011 (ptrace low level code fixes)
  *  -traced syscall return code (r0) was not saved into pt_regs for restoring
  *   into user reg-file when traded task rets to user space.
@@ -404,7 +407,17 @@ ARC_ENTRY EV_TLBProtV
 	mov r1, r4              ; faulting address
 	mov r2, sp              ; pt_regs
 
+#ifdef  CONFIG_ARC_MISALIGN_ACCESS
+	SAVE_CALLEE_SAVED_USER
+	mov r3, sp              ; callee_regs
+#endif
+
 	bl  do_misaligned_access
+
+#ifdef  CONFIG_ARC_MISALIGN_ACCESS
+	DISCARD_CALLEE_SAVED_USER
+#endif
+
 	b   ret_from_exception
 
 ARC_EXIT EV_TLBProtV
diff --git a/arch/arc/kernel/traps.c b/arch/arc/kernel/traps.c
index c6396b4..d2bc5bd 100644
--- a/arch/arc/kernel/traps.c
+++ b/arch/arc/kernel/traps.c
@@ -7,6 +7,9 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  *
+ * vineetg: May 2011
+ *  -user-space unaligned access emulation
+ *
  * Rahul Trivedi: Codito Technologies 2004
  */
 
@@ -16,6 +19,7 @@
 #include <asm/ptrace.h>
 #include <asm/setup.h>
 #include <asm/kprobes.h>
+#include <asm/unaligned.h>
 
 void __init trap_init(void)
 {
@@ -79,7 +83,29 @@ DO_ERROR_INFO(SIGILL, "Illegal Insn (or Seq)", insterror_is_error, ILL_ILLOPC)
 DO_ERROR_INFO(SIGBUS, "Invalid Mem Access", do_memory_error, BUS_ADRERR)
 DO_ERROR_INFO(SIGTRAP, "Breakpoint Set", trap_is_brkpt, TRAP_BRKPT)
 
+#ifdef CONFIG_ARC_MISALIGN_ACCESS
+/*
+ * Entry Point for Misaligned Data access Exception, for emulating in software
+ */
+int do_misaligned_access(unsigned long cause, unsigned long address,
+			 struct pt_regs *regs, struct callee_regs *cregs)
+{
+	if (misaligned_fixup(address, regs, cause, cregs) != 0) {
+		siginfo_t info;
+
+		info.si_signo = SIGSEGV;
+		info.si_errno = 0;
+		info.si_code = SEGV_ACCERR;
+		info.si_addr = (void __user *)address;
+		return handle_exception(cause, "Misaligned Access", regs,
+					  &info);
+	}
+	return 0;
+}
+
+#else
 DO_ERROR_INFO(SIGSEGV, "Misaligned Access", do_misaligned_access, SEGV_ACCERR)
+#endif
 
 /*
  * Entry point for miscll errors such as Nested Exceptions
diff --git a/arch/arc/kernel/unaligned.c b/arch/arc/kernel/unaligned.c
new file mode 100644
index 0000000..b41e218
--- /dev/null
+++ b/arch/arc/kernel/unaligned.c
@@ -0,0 +1,225 @@
+/*
+ * Copyright (C) 2011-2012 Synopsys (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * vineetg : May 2011
+ *  -Adapted (from .26 to .35)
+ *  -original contribution by Tim.yao@amlogic.com
+ *
+ */
+
+#include <linux/types.h>
+#include <linux/ptrace.h>
+#include <linux/uaccess.h>
+#include <asm/disasm.h>
+
+#define __get8_unaligned_check(val, addr, err)		\
+	__asm__(					\
+	"1:	ldb.ab	%1, [%2, 1]\n"			\
+	"2:\n"						\
+	"	.section .fixup,\"ax\"\n"		\
+	"	.align	4\n"				\
+	"3:	mov	%0, 1\n"			\
+	"	b	2b\n"				\
+	"	.previous\n"				\
+	"	.section __ex_table,\"a\"\n"		\
+	"	.align	4\n"				\
+	"	.long	1b, 3b\n"			\
+	"	.previous\n"				\
+	: "=r" (err), "=&r" (val), "=r" (addr)		\
+	: "0" (err), "2" (addr))
+
+#define get16_unaligned_check(val, addr)		\
+	do {						\
+		unsigned int err = 0, v, a = addr;	\
+		__get8_unaligned_check(v, a, err);	\
+		val =  v ;				\
+		__get8_unaligned_check(v, a, err);	\
+		val |= v << 8;				\
+		if (err)				\
+			goto fault;			\
+	} while (0)
+
+#define get32_unaligned_check(val, addr)		\
+	do {						\
+		unsigned int err = 0, v, a = addr;	\
+		__get8_unaligned_check(v, a, err);	\
+		val =  v << 0;				\
+		__get8_unaligned_check(v, a, err);	\
+		val |= v << 8;				\
+		__get8_unaligned_check(v, a, err);	\
+		val |= v << 16;				\
+		__get8_unaligned_check(v, a, err);	\
+		val |= v << 24;				\
+		if (err)				\
+			goto fault;			\
+	} while (0)
+
+#define put16_unaligned_check(val, addr)		\
+	do {						\
+		unsigned int err = 0, v = val, a = addr;\
+							\
+		__asm__(				\
+		"1:	stb.ab	%1, [%2, 1]\n"		\
+		"	lsr %1, %1, 8\n"		\
+		"2:	stb	%1, [%2]\n"		\
+		"3:\n"					\
+		"	.section .fixup,\"ax\"\n"	\
+		"	.align	4\n"			\
+		"4:	mov	%0, 1\n"		\
+		"	b	3b\n"			\
+		"	.previous\n"			\
+		"	.section __ex_table,\"a\"\n"	\
+		"	.align	4\n"			\
+		"	.long	1b, 4b\n"		\
+		"	.long	2b, 4b\n"		\
+		"	.previous\n"			\
+		: "=r" (err), "=&r" (v), "=&r" (a)	\
+		: "0" (err), "1" (v), "2" (a));		\
+							\
+		if (err)				\
+			goto fault;			\
+	} while (0)
+
+#define put32_unaligned_check(val, addr)		\
+	do {						\
+		unsigned int err = 0, v = val, a = addr;\
+		__asm__(				\
+							\
+		"1:	stb.ab	%1, [%2, 1]\n"		\
+		"	lsr %1, %1, 8\n"		\
+		"2:	stb.ab	%1, [%2, 1]\n"		\
+		"	lsr %1, %1, 8\n"		\
+		"3:	stb.ab	%1, [%2, 1]\n"		\
+		"	lsr %1, %1, 8\n"		\
+		"4:	stb	%1, [%2]\n"		\
+		"5:\n"					\
+		"	.section .fixup,\"ax\"\n"	\
+		"	.align	4\n"			\
+		"6:	mov	%0, 1\n"		\
+		"	b	5b\n"			\
+		"	.previous\n"			\
+		"	.section __ex_table,\"a\"\n"	\
+		"	.align	4\n"			\
+		"	.long	1b, 6b\n"		\
+		"	.long	2b, 6b\n"		\
+		"	.long	3b, 6b\n"		\
+		"	.long	4b, 6b\n"		\
+		"	.previous\n"			\
+		: "=r" (err), "=&r" (v), "=&r" (a)	\
+		: "0" (err), "1" (v), "2" (a));		\
+							\
+		if (err)				\
+			goto fault;			\
+	} while (0)
+
+static void fixup_load(struct disasm_state *state, struct pt_regs *regs,
+			struct callee_regs *cregs)
+{
+	int val;
+
+	/* register write back */
+	if ((state->aa == 1) || (state->aa == 2)) {
+		set_reg(state->wb_reg, state->src1 + state->src2, regs,
+				cregs);
+
+		if (state->aa == 2)
+			state->src2 = 0;
+	}
+
+	if (state->zz == 0) {
+		get32_unaligned_check(val, state->src1 + state->src2);
+	} else {
+		get16_unaligned_check(val, state->src1 + state->src2);
+
+		if (state->x)
+			val = (val << 16) >> 16;
+	}
+
+	if (state->pref == 0)
+		set_reg(state->dest, val, regs, cregs);
+
+	return;
+
+fault:	state->fault = 1;
+}
+
+static void fixup_store(struct disasm_state *state, struct pt_regs *regs,
+			struct callee_regs *cregs)
+{
+	/* register write back */
+	if ((state->aa == 1) || (state->aa == 2)) {
+		set_reg(state->wb_reg, state->src2 + state->src3, regs, cregs);
+
+		if (state->aa == 3)
+			state->src3 = 0;
+	} else if (state->aa == 3) {
+		if (state->zz == 2) {
+			set_reg(state->wb_reg, state->src2 +
+				(state->src3 << 1), regs, cregs);
+		} else if (!state->zz) {
+			set_reg(state->wb_reg, state->src2 +
+				(state->src3 << 2), regs, cregs);
+		} else {
+			goto fault;
+		}
+	}
+
+	/* write fix-up */
+	if (!state->zz) {
+		put32_unaligned_check(state->src1, state->src2 +
+					state->src3);
+	} else {
+		put16_unaligned_check(state->src1, state->src2 +
+					state->src3);
+	}
+
+	return;
+
+fault:	state->fault = 1;
+}
+
+int misaligned_fixup(unsigned long address, struct pt_regs *regs,
+		     unsigned long cause,  struct callee_regs *cregs)
+{
+	struct disasm_state state;
+
+	/* handle user mode only */
+	if (!user_mode(regs))
+		return 1;
+
+	disasm_instr(regs->ret, &state, 1, regs, cregs);
+
+	if (state.fault)
+		goto fault;
+
+	/* ldb/stb should not have unaligned exception */
+	if ((state.zz == 1) || (state.di))
+		goto fault;
+
+	if (!state.write)
+		fixup_load(&state, regs, cregs);
+	else
+		fixup_store(&state, regs, cregs);
+
+	if (state.fault)
+		goto fault;
+
+	if (delay_mode(regs)) {
+		regs->ret = regs->bta;
+		regs->status32 &= ~STATUS_DE_MASK;
+	} else {
+		regs->ret += state.instr_len;
+	}
+
+	return 0;
+
+fault:
+	pr_err("Alignment trap: fault in fix-up %08lx at [<%08lx>]\n",
+		state.words[0], address);
+
+	return 1;
+}
-- 
1.7.4.1

