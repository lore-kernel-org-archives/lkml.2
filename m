Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab1GQPMc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 11:12:32 -0400
Received: from mail.southpole.se ([193.12.106.18]:34891 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027Ab1GQPJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 11:09:33 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>
Subject: [PATCH v3 06/19] OpenRISC: PTrace
Date: Sun, 17 Jul 2011 17:08:16 +0200
Message-Id: <13d338b955ae0f6b9ee1eda6aede2ee2be33c446.1310913472.git.jonas@southpole.se>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1310913472.git.jonas@southpole.se>
References: <cover.1310913472.git.jonas@southpole.se>
In-Reply-To: <cover.1310913472.git.jonas@southpole.se>
References: <cover.1310913472.git.jonas@southpole.se>
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch implements minimal PTrace support.  The pt_regs structure is
not exported to userspace for OpenRISC; rather, the GETREGSET mechanism
is intended to be used and the registers, as such, exported in the core
dump format which is ABI stable.  This is in line with what is intended
for new architectures as of 2.6.34 and has the advantage of permitting
the layout of the registers on the kernel stack (as per pt_regs) to be
freely modified.

Signed-off-by: Jonas Bonn <jonas@southpole.se>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/openrisc/include/asm/ptrace.h |  131 ++++++++++++++++++++++
 arch/openrisc/kernel/ptrace.c      |  211 ++++++++++++++++++++++++++++++++++++
 2 files changed, 342 insertions(+), 0 deletions(-)
 create mode 100644 arch/openrisc/include/asm/ptrace.h
 create mode 100644 arch/openrisc/kernel/ptrace.c

diff --git a/arch/openrisc/include/asm/ptrace.h b/arch/openrisc/include/asm/ptrace.h
new file mode 100644
index 0000000..054537c
--- /dev/null
+++ b/arch/openrisc/include/asm/ptrace.h
@@ -0,0 +1,131 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_PTRACE_H
+#define __ASM_OPENRISC_PTRACE_H
+
+#include <asm/spr_defs.h>
+
+#ifndef __ASSEMBLY__
+/*
+ * This is the layout of the regset returned by the GETREGSET ptrace call
+ */
+struct user_regs_struct {
+	/* GPR R0-R31... */
+	unsigned long gpr[32];
+	unsigned long pc;
+	unsigned long sr;
+	unsigned long pad1;
+	unsigned long pad2;
+};
+#endif
+
+#ifdef __KERNEL__
+
+/*
+ * Make kernel PTrace/register structures opaque to userspace... userspace can
+ * access thread state via the regset mechanism.  This allows us a bit of
+ * flexibility in how we order the registers on the stack, permitting some
+ * optimizations like packing call-clobbered registers together so that
+ * they share a cacheline (not done yet, though... future optimization).
+ */
+
+#ifndef __ASSEMBLY__
+/*
+ * This struct describes how the registers are laid out on the kernel stack
+ * during a syscall or other kernel entry.
+ *
+ * This structure should always be cacheline aligned on the stack.
+ * FIXME: I don't think that's the case right now.  The alignment is
+ * taken care of elsewhere... head.S, process.c, etc.
+ */
+
+struct pt_regs {
+	union {
+		struct {
+			/* Named registers */
+			long  sr;	/* Stored in place of r0 */
+			long  sp;	/* r1 */
+		};
+		struct {
+			/* Old style */
+			long offset[2];
+			long gprs[30];
+		};
+		struct {
+			/* New style */
+			long gpr[32];
+		};
+	};
+	long  pc;
+	long  orig_gpr11;	/* For restarting system calls */
+	long  syscallno;	/* Syscall number (used by strace) */
+	long dummy;		/* Cheap alignment fix */
+};
+#endif /* __ASSEMBLY__ */
+
+/* TODO: Rename this to REDZONE because that's what it is */
+#define STACK_FRAME_OVERHEAD  128  /* size of minimum stack frame */
+
+#define instruction_pointer(regs)	((regs)->pc)
+#define user_mode(regs)			(((regs)->sr & SPR_SR_SM) == 0)
+#define user_stack_pointer(regs)	((unsigned long)(regs)->sp)
+#define profile_pc(regs)		instruction_pointer(regs)
+
+/*
+ * Offsets used by 'ptrace' system call interface.
+ */
+#define PT_SR         0
+#define PT_SP         4
+#define PT_GPR2       8
+#define PT_GPR3       12
+#define PT_GPR4       16
+#define PT_GPR5       20
+#define PT_GPR6       24
+#define PT_GPR7       28
+#define PT_GPR8       32
+#define PT_GPR9       36
+#define PT_GPR10      40
+#define PT_GPR11      44
+#define PT_GPR12      48
+#define PT_GPR13      52
+#define PT_GPR14      56
+#define PT_GPR15      60
+#define PT_GPR16      64
+#define PT_GPR17      68
+#define PT_GPR18      72
+#define PT_GPR19      76
+#define PT_GPR20      80
+#define PT_GPR21      84
+#define PT_GPR22      88
+#define PT_GPR23      92
+#define PT_GPR24      96
+#define PT_GPR25      100
+#define PT_GPR26      104
+#define PT_GPR27      108
+#define PT_GPR28      112
+#define PT_GPR29      116
+#define PT_GPR30      120
+#define PT_GPR31      124
+#define PT_PC	      128
+#define PT_ORIG_GPR11 132
+#define PT_SYSCALLNO  136
+
+#endif /* __KERNEL__ */
+
+#endif /* __ASM_OPENRISC_PTRACE_H */
diff --git a/arch/openrisc/kernel/ptrace.c b/arch/openrisc/kernel/ptrace.c
new file mode 100644
index 0000000..656b94b
--- /dev/null
+++ b/arch/openrisc/kernel/ptrace.c
@@ -0,0 +1,211 @@
+/*
+ * OpenRISC ptrace.c
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * Modifications for the OpenRISC architecture:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2005 Gyorgy Jeney <nog@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ */
+
+#include <stddef.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/string.h>
+
+#include <linux/mm.h>
+#include <linux/errno.h>
+#include <linux/ptrace.h>
+#include <linux/audit.h>
+#include <linux/regset.h>
+#include <linux/tracehook.h>
+#include <linux/elf.h>
+
+#include <asm/thread_info.h>
+#include <asm/segment.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+#include <asm/system.h>
+
+/*
+ * Copy the thread state to a regset that can be interpreted by userspace.
+ *
+ * It doesn't matter what our internal pt_regs structure looks like.  The
+ * important thing is that we export a consistent view of the thread state
+ * to userspace.  As such, we need to make sure that the regset remains
+ * ABI compatible as defined by the struct user_regs_struct:
+ *
+ * (Each item is a 32-bit word)
+ * r0 = 0 (exported for clarity)
+ * 31 GPRS r1-r31
+ * PC (Program counter)
+ * SR (Supervision register)
+ */
+static int genregs_get(struct task_struct *target,
+		       const struct user_regset *regset,
+		       unsigned int pos, unsigned int count,
+		       void *kbuf, void __user * ubuf)
+{
+	const struct pt_regs *regs = task_pt_regs(target);
+	int ret;
+
+	/* r0 */
+	ret = user_regset_copyout_zero(&pos, &count, &kbuf, &ubuf, 0, 4);
+
+	if (!ret)
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+					  regs->gpr+1, 4, 4*32);
+	if (!ret)
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				  &regs->pc, 4*32, 4*33);
+	if (!ret)
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+					  &regs->sr, 4*33, 4*34);
+	if (!ret)
+		ret = user_regset_copyout_zero(&pos, &count, &kbuf, &ubuf,
+					       4*34, -1);
+
+	return ret;
+}
+
+/*
+ * Set the thread state from a regset passed in via ptrace
+ */
+static int genregs_set(struct task_struct *target,
+		       const struct user_regset *regset,
+		       unsigned int pos, unsigned int count,
+		       const void *kbuf, const void __user * ubuf)
+{
+	struct pt_regs *regs = task_pt_regs(target);
+	int ret;
+
+	/* ignore r0 */
+	ret = user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf, 0, 4);
+	/* r1 - r31 */
+	if (!ret)
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+					 regs->gpr+1, 4, 4*32);
+	/* PC */
+	if (!ret)
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				 &regs->pc, 4*32, 4*33);
+	/*
+	 * Skip SR and padding... userspace isn't allowed to changes bits in
+	 * the Supervision register
+	 */
+	if (!ret)
+		ret = user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+						4*33, -1);
+
+	return ret;
+}
+
+/*
+ * Define the register sets available on OpenRISC under Linux
+ */
+enum or1k_regset {
+	REGSET_GENERAL,
+};
+
+static const struct user_regset or1k_regsets[] = {
+	[REGSET_GENERAL] = {
+			    .core_note_type = NT_PRSTATUS,
+			    .n = ELF_NGREG,
+			    .size = sizeof(long),
+			    .align = sizeof(long),
+			    .get = genregs_get,
+			    .set = genregs_set,
+			    },
+};
+
+static const struct user_regset_view user_or1k_native_view = {
+	.name = "or1k",
+	.e_machine = EM_OPENRISC,
+	.regsets = or1k_regsets,
+	.n = ARRAY_SIZE(or1k_regsets),
+};
+
+const struct user_regset_view *task_user_regset_view(struct task_struct *task)
+{
+	return &user_or1k_native_view;
+}
+
+/*
+ * does not yet catch signals sent when the child dies.
+ * in exit.c or in signal.c.
+ */
+
+
+/*
+ * Called by kernel/ptrace.c when detaching..
+ *
+ * Make sure the single step bit is not set.
+ */
+void ptrace_disable(struct task_struct *child)
+{
+	pr_debug("ptrace_disable(): TODO\n");
+
+	user_disable_single_step(child);
+	clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
+}
+
+long arch_ptrace(struct task_struct *child, long request, unsigned long addr,
+		 unsigned long data)
+{
+	int ret;
+
+	switch (request) {
+	default:
+		ret = ptrace_request(child, request, addr, data);
+		break;
+	}
+
+	return ret;
+}
+
+/*
+ * Notification of system call entry/exit
+ * - triggered by current->work.syscall_trace
+ */
+asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
+{
+	long ret = 0;
+
+	if (test_thread_flag(TIF_SYSCALL_TRACE) &&
+	    tracehook_report_syscall_entry(regs))
+		/*
+		 * Tracing decided this syscall should not happen.
+		 * We'll return a bogus call number to get an ENOSYS
+		 * error, but leave the original number in <something>.
+		 */
+		ret = -1L;
+
+	/* Are these regs right??? */
+	if (unlikely(current->audit_context))
+		audit_syscall_entry(audit_arch(), regs->syscallno,
+				    regs->gpr[3], regs->gpr[4],
+				    regs->gpr[5], regs->gpr[6]);
+
+	return ret ? : regs->syscallno;
+}
+
+asmlinkage void do_syscall_trace_leave(struct pt_regs *regs)
+{
+	int step;
+
+	if (unlikely(current->audit_context))
+		audit_syscall_exit(AUDITSC_RESULT(regs->gpr[11]),
+				   regs->gpr[11]);
+
+	step = test_thread_flag(TIF_SINGLESTEP);
+	if (step || test_thread_flag(TIF_SYSCALL_TRACE))
+		tracehook_report_syscall_exit(regs, step);
+}
-- 
1.7.4.1

