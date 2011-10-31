Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934832Ab1KAASM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 20:18:12 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43327 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934802Ab1KAASJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 20:18:09 -0400
Message-Id: <e97c6e$3uab20@wolverine02.qualcomm.com>
X-IronPort-AV: E=McAfee;i="5400,1158,6516"; a="132459584"
From: Richard Kuo <rkuo@codeaurora.org>
Date: Mon, 31 Oct 2011 18:54:43 -0500
Subject: [PATCH v5 31/36] Hexagon: kgdb support files
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Linas Vepstas <linas@codeaurora.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/hexagon/include/asm/kgdb.h |   43 +++++++
 arch/hexagon/kernel/kgdb.c      |  255 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 298 insertions(+), 0 deletions(-)
 create mode 100644 arch/hexagon/include/asm/kgdb.h
 create mode 100644 arch/hexagon/kernel/kgdb.c

diff --git a/arch/hexagon/include/asm/kgdb.h b/arch/hexagon/include/asm/kgdb.h
new file mode 100644
index 0000000..9e87797
--- /dev/null
+++ b/arch/hexagon/include/asm/kgdb.h
@@ -0,0 +1,43 @@
+/*
+ * arch/hexagon/include/asm/kgdb.h - Hexagon KGDB Support
+ *
+ * Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef __HEXAGON_KGDB_H__
+#define __HEXAGON_KGDB_H__
+
+#define BREAK_INSTR_SIZE 4
+#define CACHE_FLUSH_IS_SAFE   1
+#define BUFMAX       ((NUMREGBYTES * 2) + 512)
+
+static inline void arch_kgdb_breakpoint(void)
+{
+	asm("trap0(#0xDB)");
+}
+
+/* Registers:
+ * 32 gpr + sa0/1 + lc0/1 + m0/1 + gp + ugp + pred + pc = 42 total.
+ * vm regs = psp+elr+est+badva = 4
+ * syscall+restart = 2 more
+ * so 48 = 42 +4 + 2
+ */
+#define DBG_USER_REGS 42
+#define DBG_MAX_REG_NUM (DBG_USER_REGS + 6)
+#define NUMREGBYTES  (DBG_MAX_REG_NUM*4)
+
+#endif /* __HEXAGON_KGDB_H__ */
diff --git a/arch/hexagon/kernel/kgdb.c b/arch/hexagon/kernel/kgdb.c
new file mode 100644
index 0000000..38ab0ea
--- /dev/null
+++ b/arch/hexagon/kernel/kgdb.c
@@ -0,0 +1,255 @@
+/*
+ * arch/hexagon/kernel/kgdb.c - Hexagon KGDB Support
+ *
+ * Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <linux/kdebug.h>
+#include <linux/kgdb.h>
+
+/* All registers are 4 bytes, for now */
+#define GDB_SIZEOF_REG 4
+
+/* The register names are used during printing of the regs;
+ * Keep these at three letters to pretty-print. */
+struct dbg_reg_def_t dbg_reg_def[DBG_MAX_REG_NUM] = {
+	{ " r0", GDB_SIZEOF_REG, offsetof(struct pt_regs, r00)},
+	{ " r1", GDB_SIZEOF_REG, offsetof(struct pt_regs, r01)},
+	{ " r2", GDB_SIZEOF_REG, offsetof(struct pt_regs, r02)},
+	{ " r3", GDB_SIZEOF_REG, offsetof(struct pt_regs, r03)},
+	{ " r4", GDB_SIZEOF_REG, offsetof(struct pt_regs, r04)},
+	{ " r5", GDB_SIZEOF_REG, offsetof(struct pt_regs, r05)},
+	{ " r6", GDB_SIZEOF_REG, offsetof(struct pt_regs, r06)},
+	{ " r7", GDB_SIZEOF_REG, offsetof(struct pt_regs, r07)},
+	{ " r8", GDB_SIZEOF_REG, offsetof(struct pt_regs, r08)},
+	{ " r9", GDB_SIZEOF_REG, offsetof(struct pt_regs, r09)},
+	{ "r10", GDB_SIZEOF_REG, offsetof(struct pt_regs, r10)},
+	{ "r11", GDB_SIZEOF_REG, offsetof(struct pt_regs, r11)},
+	{ "r12", GDB_SIZEOF_REG, offsetof(struct pt_regs, r12)},
+	{ "r13", GDB_SIZEOF_REG, offsetof(struct pt_regs, r13)},
+	{ "r14", GDB_SIZEOF_REG, offsetof(struct pt_regs, r14)},
+	{ "r15", GDB_SIZEOF_REG, offsetof(struct pt_regs, r15)},
+	{ "r16", GDB_SIZEOF_REG, offsetof(struct pt_regs, r16)},
+	{ "r17", GDB_SIZEOF_REG, offsetof(struct pt_regs, r17)},
+	{ "r18", GDB_SIZEOF_REG, offsetof(struct pt_regs, r18)},
+	{ "r19", GDB_SIZEOF_REG, offsetof(struct pt_regs, r19)},
+	{ "r20", GDB_SIZEOF_REG, offsetof(struct pt_regs, r20)},
+	{ "r21", GDB_SIZEOF_REG, offsetof(struct pt_regs, r21)},
+	{ "r22", GDB_SIZEOF_REG, offsetof(struct pt_regs, r22)},
+	{ "r23", GDB_SIZEOF_REG, offsetof(struct pt_regs, r23)},
+	{ "r24", GDB_SIZEOF_REG, offsetof(struct pt_regs, r24)},
+	{ "r25", GDB_SIZEOF_REG, offsetof(struct pt_regs, r25)},
+	{ "r26", GDB_SIZEOF_REG, offsetof(struct pt_regs, r26)},
+	{ "r27", GDB_SIZEOF_REG, offsetof(struct pt_regs, r27)},
+	{ "r28", GDB_SIZEOF_REG, offsetof(struct pt_regs, r28)},
+	{ "r29", GDB_SIZEOF_REG, offsetof(struct pt_regs, r29)},
+	{ "r30", GDB_SIZEOF_REG, offsetof(struct pt_regs, r30)},
+	{ "r31", GDB_SIZEOF_REG, offsetof(struct pt_regs, r31)},
+
+	{ "usr", GDB_SIZEOF_REG, offsetof(struct pt_regs, usr)},
+	{ "preds", GDB_SIZEOF_REG, offsetof(struct pt_regs, preds)},
+	{ " m0", GDB_SIZEOF_REG, offsetof(struct pt_regs, m0)},
+	{ " m1", GDB_SIZEOF_REG, offsetof(struct pt_regs, m1)},
+	{ "sa0", GDB_SIZEOF_REG, offsetof(struct pt_regs, sa0)},
+	{ "sa1", GDB_SIZEOF_REG, offsetof(struct pt_regs, sa1)},
+	{ "lc0", GDB_SIZEOF_REG, offsetof(struct pt_regs, lc0)},
+	{ "lc1", GDB_SIZEOF_REG, offsetof(struct pt_regs, lc1)},
+	{ " gp", GDB_SIZEOF_REG, offsetof(struct pt_regs, gp)},
+	{ "ugp", GDB_SIZEOF_REG, offsetof(struct pt_regs, ugp)},
+	{ "psp", GDB_SIZEOF_REG, offsetof(struct pt_regs, hvmer.vmpsp)},
+	{ "elr", GDB_SIZEOF_REG, offsetof(struct pt_regs, hvmer.vmel)},
+	{ "est", GDB_SIZEOF_REG, offsetof(struct pt_regs, hvmer.vmest)},
+	{ "badva", GDB_SIZEOF_REG, offsetof(struct pt_regs, hvmer.vmbadva)},
+	{ "restart_r0", GDB_SIZEOF_REG, offsetof(struct pt_regs, restart_r0)},
+	{ "syscall_nr", GDB_SIZEOF_REG, offsetof(struct pt_regs, syscall_nr)},
+};
+
+struct kgdb_arch arch_kgdb_ops = {
+	/* trap0(#0xDB) 0x0cdb0054 */
+	.gdb_bpt_instr = {0x54, 0x00, 0xdb, 0x0c},
+};
+
+char *dbg_get_reg(int regno, void *mem, struct pt_regs *regs)
+{
+	if (regno >= DBG_MAX_REG_NUM || regno < 0)
+		return NULL;
+
+	*((unsigned long *) mem) = *((unsigned long *) ((void *)regs +
+		dbg_reg_def[regno].offset));
+
+	return dbg_reg_def[regno].name;
+}
+
+int dbg_set_reg(int regno, void *mem, struct pt_regs *regs)
+{
+	if (regno >= DBG_MAX_REG_NUM || regno < 0)
+		return -EINVAL;
+
+	*((unsigned long *) ((void *)regs + dbg_reg_def[regno].offset)) =
+		*((unsigned long *) mem);
+
+	return 0;
+}
+
+void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long pc)
+{
+	instruction_pointer(regs) = pc;
+}
+
+#ifdef CONFIG_SMP
+
+/**
+ * kgdb_roundup_cpus - Get other CPUs into a holding pattern
+ * @flags: Current IRQ state
+ *
+ * On SMP systems, we need to get the attention of the other CPUs
+ * and get them be in a known state.  This should do what is needed
+ * to get the other CPUs to call kgdb_wait(). Note that on some arches,
+ * the NMI approach is not used for rounding up all the CPUs. For example,
+ * in case of MIPS, smp_call_function() is used to roundup CPUs. In
+ * this case, we have to make sure that interrupts are enabled before
+ * calling smp_call_function(). The argument to this function is
+ * the flags that will be used when restoring the interrupts. There is
+ * local_irq_save() call before kgdb_roundup_cpus().
+ *
+ * On non-SMP systems, this is not called.
+ */
+
+static void hexagon_kgdb_nmi_hook(void *ignored)
+{
+	kgdb_nmicallback(raw_smp_processor_id(), get_irq_regs());
+}
+
+void kgdb_roundup_cpus(unsigned long flags)
+{
+	local_irq_enable();
+	smp_call_function(hexagon_kgdb_nmi_hook, NULL, 0);
+	local_irq_disable();
+}
+#endif
+
+
+/*  Not yet working  */
+void sleeping_thread_to_gdb_regs(unsigned long *gdb_regs,
+				 struct task_struct *task)
+{
+	struct pt_regs *thread_regs;
+
+	if (task == NULL)
+		return;
+
+	/* Initialize to zero */
+	memset(gdb_regs, 0, NUMREGBYTES);
+
+	/* Otherwise, we have only some registers from switch_to() */
+	thread_regs = task_pt_regs(task);
+	gdb_regs[0] = thread_regs->r00;
+}
+
+/**
+ * kgdb_arch_handle_exception - Handle architecture specific GDB packets.
+ * @vector: The error vector of the exception that happened.
+ * @signo: The signal number of the exception that happened.
+ * @err_code: The error code of the exception that happened.
+ * @remcom_in_buffer: The buffer of the packet we have read.
+ * @remcom_out_buffer: The buffer of %BUFMAX bytes to write a packet into.
+ * @regs: The &struct pt_regs of the current process.
+ *
+ * This function MUST handle the 'c' and 's' command packets,
+ * as well packets to set / remove a hardware breakpoint, if used.
+ * If there are additional packets which the hardware needs to handle,
+ * they are handled here.  The code should return -1 if it wants to
+ * process more packets, and a %0 or %1 if it wants to exit from the
+ * kgdb callback.
+ *
+ * Not yet working.
+ */
+int kgdb_arch_handle_exception(int vector, int signo, int err_code,
+			       char *remcom_in_buffer, char *remcom_out_buffer,
+			       struct pt_regs *linux_regs)
+{
+	switch (remcom_in_buffer[0]) {
+	case 's':
+	case 'c':
+		return 0;
+	}
+	/* Stay in the debugger. */
+	return -1;
+}
+
+static int __kgdb_notify(struct die_args *args, unsigned long cmd)
+{
+	/* cpu roundup */
+	if (atomic_read(&kgdb_active) != -1) {
+		kgdb_nmicallback(smp_processor_id(), args->regs);
+		return NOTIFY_STOP;
+	}
+
+	if (user_mode(args->regs))
+		return NOTIFY_DONE;
+
+	if (kgdb_handle_exception(args->trapnr & 0xff, args->signr, args->err,
+				    args->regs))
+		return NOTIFY_DONE;
+
+	return NOTIFY_STOP;
+}
+
+static int
+kgdb_notify(struct notifier_block *self, unsigned long cmd, void *ptr)
+{
+	unsigned long flags;
+	int ret;
+
+	local_irq_save(flags);
+	ret = __kgdb_notify(ptr, cmd);
+	local_irq_restore(flags);
+
+	return ret;
+}
+
+static struct notifier_block kgdb_notifier = {
+	.notifier_call = kgdb_notify,
+
+	/*
+	 * Lowest-prio notifier priority, we want to be notified last:
+	 */
+	.priority = -INT_MAX,
+};
+
+/**
+ * kgdb_arch_init - Perform any architecture specific initalization.
+ *
+ * This function will handle the initalization of any architecture
+ * specific callbacks.
+ */
+int kgdb_arch_init(void)
+{
+	return register_die_notifier(&kgdb_notifier);
+}
+
+/**
+ * kgdb_arch_exit - Perform any architecture specific uninitalization.
+ *
+ * This function will handle the uninitalization of any architecture
+ * specific callbacks, for dynamic registration and unregistration.
+ */
+void kgdb_arch_exit(void)
+{
+	unregister_die_notifier(&kgdb_notifier);
+}
+
-- 
1.7.1


--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
