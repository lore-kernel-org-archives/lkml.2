Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab2IGQ3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:29:42 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34614 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab2IGQ17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:27:59 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 23/31] arm64: Debugging support
Date: Fri,  7 Sep 2012 17:26:58 +0100
Message-Id: <1347035226-18649-24-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 07 Sep 2012 16:27:56.0347 (UTC) FILETIME=[BCB5C0B0:01CD8D15]
X-MC-Unique: 112090717275607001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q87GTrGc008364

From: Will Deacon <will.deacon@arm.com>

This patch adds ptrace, debug monitors and hardware breakpoints support.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm64/include/asm/debug-monitors.h |   88 +++
 arch/arm64/include/asm/hw_breakpoint.h  |  137 ++++
 arch/arm64/kernel/debug-monitors.c      |  288 ++++++++
 arch/arm64/kernel/hw_breakpoint.c       |  880 ++++++++++++++++++++++++
 arch/arm64/kernel/ptrace.c              | 1126 +++++++++++++++++++++++++++++++
 include/linux/elf.h                     |    3 +
 6 files changed, 2522 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm64/include/asm/debug-monitors.h
 create mode 100644 arch/arm64/include/asm/hw_breakpoint.h
 create mode 100644 arch/arm64/kernel/debug-monitors.c
 create mode 100644 arch/arm64/kernel/hw_breakpoint.c
 create mode 100644 arch/arm64/kernel/ptrace.c

diff --git a/arch/arm64/include/asm/debug-monitors.h b/arch/arm64/include/asm/debug-monitors.h
new file mode 100644
index 0000000..7eaa0b3
--- /dev/null
+++ b/arch/arm64/include/asm/debug-monitors.h
@@ -0,0 +1,88 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_DEBUG_MONITORS_H
+#define __ASM_DEBUG_MONITORS_H
+
+#ifdef __KERNEL__
+
+#define	DBG_ESR_EVT(x)		(((x) >> 27) & 0x7)
+
+/* AArch64 */
+#define DBG_ESR_EVT_HWBP	0x0
+#define DBG_ESR_EVT_HWSS	0x1
+#define DBG_ESR_EVT_HWWP	0x2
+#define DBG_ESR_EVT_BRK		0x6
+
+enum debug_el {
+	DBG_ACTIVE_EL0 = 0,
+	DBG_ACTIVE_EL1,
+};
+
+/* AArch32 */
+#define DBG_ESR_EVT_BKPT	0x4
+#define DBG_ESR_EVT_VECC	0x5
+
+#define AARCH32_BREAK_ARM	0x07f001f0
+#define AARCH32_BREAK_THUMB	0xde01
+#define AARCH32_BREAK_THUMB2_LO	0xf7f0
+#define AARCH32_BREAK_THUMB2_HI	0xa000
+
+#ifndef __ASSEMBLY__
+struct task_struct;
+
+#define local_dbg_save(flags)							\
+	do {									\
+		typecheck(unsigned long, flags);				\
+		asm volatile(							\
+		"mrs	%0, daif			// local_dbg_save\n"	\
+		"msr	daifset, #8"						\
+		: "=r" (flags) : : "memory");					\
+	} while (0)
+
+#define local_dbg_restore(flags)						\
+	do {									\
+		typecheck(unsigned long, flags);				\
+		asm volatile(							\
+		"msr	daif, %0			// local_dbg_restore\n"	\
+		: : "r" (flags) : "memory");					\
+	} while (0)
+
+#define DBG_ARCH_ID_RESERVED	0	/* In case of ptrace ABI updates. */
+
+u8 debug_monitors_arch(void);
+
+void enable_debug_monitors(enum debug_el el);
+void disable_debug_monitors(enum debug_el el);
+
+void user_rewind_single_step(struct task_struct *task);
+void user_fastforward_single_step(struct task_struct *task);
+
+void kernel_enable_single_step(struct pt_regs *regs);
+void kernel_disable_single_step(void);
+int kernel_active_single_step(void);
+
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+int reinstall_suspended_bps(struct pt_regs *regs);
+#else
+static inline int reinstall_suspended_bps(struct pt_regs *regs)
+{
+	return -ENODEV;
+}
+#endif
+
+#endif	/* __ASSEMBLY */
+#endif	/* __KERNEL__ */
+#endif	/* __ASM_DEBUG_MONITORS_H */
diff --git a/arch/arm64/include/asm/hw_breakpoint.h b/arch/arm64/include/asm/hw_breakpoint.h
new file mode 100644
index 0000000..d064047
--- /dev/null
+++ b/arch/arm64/include/asm/hw_breakpoint.h
@@ -0,0 +1,137 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_HW_BREAKPOINT_H
+#define __ASM_HW_BREAKPOINT_H
+
+#ifdef __KERNEL__
+
+struct arch_hw_breakpoint_ctrl {
+	u32 __reserved	: 19,
+	len		: 8,
+	type		: 2,
+	privilege	: 2,
+	enabled		: 1;
+};
+
+struct arch_hw_breakpoint {
+	u64 address;
+	u64 trigger;
+	struct arch_hw_breakpoint_ctrl ctrl;
+};
+
+static inline u32 encode_ctrl_reg(struct arch_hw_breakpoint_ctrl ctrl)
+{
+	return (ctrl.len << 5) | (ctrl.type << 3) | (ctrl.privilege << 1) |
+		ctrl.enabled;
+}
+
+static inline void decode_ctrl_reg(u32 reg,
+				   struct arch_hw_breakpoint_ctrl *ctrl)
+{
+	ctrl->enabled	= reg & 0x1;
+	reg >>= 1;
+	ctrl->privilege	= reg & 0x3;
+	reg >>= 2;
+	ctrl->type	= reg & 0x3;
+	reg >>= 2;
+	ctrl->len	= reg & 0xff;
+}
+
+/* Breakpoint */
+#define ARM_BREAKPOINT_EXECUTE	0
+
+/* Watchpoints */
+#define ARM_BREAKPOINT_LOAD	1
+#define ARM_BREAKPOINT_STORE	2
+#define AARCH64_ESR_ACCESS_MASK	(1 << 6)
+
+/* Privilege Levels */
+#define AARCH64_BREAKPOINT_EL1	1
+#define AARCH64_BREAKPOINT_EL0	2
+
+/* Lengths */
+#define ARM_BREAKPOINT_LEN_1	0x1
+#define ARM_BREAKPOINT_LEN_2	0x3
+#define ARM_BREAKPOINT_LEN_4	0xf
+#define ARM_BREAKPOINT_LEN_8	0xff
+
+/* Kernel stepping */
+#define ARM_KERNEL_STEP_NONE	0
+#define ARM_KERNEL_STEP_ACTIVE	1
+#define ARM_KERNEL_STEP_SUSPEND	2
+
+/*
+ * Limits.
+ * Changing these will require modifications to the register accessors.
+ */
+#define ARM_MAX_BRP		16
+#define ARM_MAX_WRP		16
+#define ARM_MAX_HBP_SLOTS	(ARM_MAX_BRP + ARM_MAX_WRP)
+
+/* Virtual debug register bases. */
+#define AARCH64_DBG_REG_BVR	0
+#define AARCH64_DBG_REG_BCR	(AARCH64_DBG_REG_BVR + ARM_MAX_BRP)
+#define AARCH64_DBG_REG_WVR	(AARCH64_DBG_REG_BCR + ARM_MAX_BRP)
+#define AARCH64_DBG_REG_WCR	(AARCH64_DBG_REG_WVR + ARM_MAX_WRP)
+
+/* Debug register names. */
+#define AARCH64_DBG_REG_NAME_BVR	"bvr"
+#define AARCH64_DBG_REG_NAME_BCR	"bcr"
+#define AARCH64_DBG_REG_NAME_WVR	"wvr"
+#define AARCH64_DBG_REG_NAME_WCR	"wcr"
+
+/* Accessor macros for the debug registers. */
+#define AARCH64_DBG_READ(N, REG, VAL) do {\
+	asm volatile("mrs %0, dbg" REG #N "_el1" : "=r" (VAL));\
+} while (0)
+
+#define AARCH64_DBG_WRITE(N, REG, VAL) do {\
+	asm volatile("msr dbg" REG #N "_el1, %0" :: "r" (VAL));\
+} while (0)
+
+struct task_struct;
+struct notifier_block;
+struct perf_event;
+struct pmu;
+
+extern int arch_bp_generic_fields(struct arch_hw_breakpoint_ctrl ctrl,
+				  int *gen_len, int *gen_type);
+extern int arch_check_bp_in_kernelspace(struct perf_event *bp);
+extern int arch_validate_hwbkpt_settings(struct perf_event *bp);
+extern int hw_breakpoint_exceptions_notify(struct notifier_block *unused,
+					   unsigned long val, void *data);
+
+extern int arch_install_hw_breakpoint(struct perf_event *bp);
+extern void arch_uninstall_hw_breakpoint(struct perf_event *bp);
+extern void hw_breakpoint_pmu_read(struct perf_event *bp);
+extern int hw_breakpoint_slots(int type);
+
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+extern void hw_breakpoint_thread_switch(struct task_struct *next);
+extern void ptrace_hw_copy_thread(struct task_struct *task);
+#else
+static inline void hw_breakpoint_thread_switch(struct task_struct *next)
+{
+}
+static inline void ptrace_hw_copy_thread(struct task_struct *task)
+{
+}
+#endif
+
+extern struct pmu perf_ops_bp;
+
+#endif	/* __KERNEL__ */
+#endif	/* __ASM_BREAKPOINT_H */
diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
new file mode 100644
index 0000000..0c3ba9f
--- /dev/null
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -0,0 +1,288 @@
+/*
+ * ARMv8 single-step debug support and mdscr context switching.
+ *
+ * Copyright (C) 2012 ARM Limited
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ * Author: Will Deacon <will.deacon@arm.com>
+ */
+
+#include <linux/cpu.h>
+#include <linux/debugfs.h>
+#include <linux/hardirq.h>
+#include <linux/init.h>
+#include <linux/ptrace.h>
+#include <linux/stat.h>
+
+#include <asm/debug-monitors.h>
+#include <asm/local.h>
+#include <asm/cputype.h>
+#include <asm/system_misc.h>
+
+/* Low-level stepping controls. */
+#define DBG_MDSCR_SS		(1 << 0)
+#define DBG_SPSR_SS		(1 << 21)
+
+/* MDSCR_EL1 enabling bits */
+#define DBG_MDSCR_KDE		(1 << 13)
+#define DBG_MDSCR_MDE		(1 << 15)
+#define DBG_MDSCR_MASK		~(DBG_MDSCR_KDE | DBG_MDSCR_MDE)
+
+/* Determine debug architecture. */
+u8 debug_monitors_arch(void)
+{
+	return read_cpuid(ID_AA64DFR0_EL1) & 0xf;
+}
+
+/*
+ * MDSCR access routines.
+ */
+static void mdscr_write(u32 mdscr)
+{
+	unsigned long flags;
+	local_dbg_save(flags);
+	asm volatile("msr mdscr_el1, %0" :: "r" (mdscr));
+	local_dbg_restore(flags);
+}
+
+static u32 mdscr_read(void)
+{
+	u32 mdscr;
+	asm volatile("mrs %0, mdscr_el1" : "=r" (mdscr));
+	return mdscr;
+}
+
+/*
+ * Allow root to disable self-hosted debug from userspace.
+ * This is useful if you want to connect an external JTAG debugger.
+ */
+static u32 debug_enabled = 1;
+
+static int create_debug_debugfs_entry(void)
+{
+	debugfs_create_bool("debug_enabled", 0644, NULL, &debug_enabled);
+	return 0;
+}
+fs_initcall(create_debug_debugfs_entry);
+
+static int __init early_debug_disable(char *buf)
+{
+	debug_enabled = 0;
+	return 0;
+}
+
+early_param("nodebugmon", early_debug_disable);
+
+/*
+ * Keep track of debug users on each core.
+ * The ref counts are per-cpu so we use a local_t type.
+ */
+static DEFINE_PER_CPU(local_t, mde_ref_count);
+static DEFINE_PER_CPU(local_t, kde_ref_count);
+
+void enable_debug_monitors(enum debug_el el)
+{
+	u32 mdscr, enable = 0;
+
+	WARN_ON(preemptible());
+
+	if (local_inc_return(&__get_cpu_var(mde_ref_count)) == 1)
+		enable = DBG_MDSCR_MDE;
+
+	if (el == DBG_ACTIVE_EL1 &&
+	    local_inc_return(&__get_cpu_var(kde_ref_count)) == 1)
+		enable |= DBG_MDSCR_KDE;
+
+	if (enable && debug_enabled) {
+		mdscr = mdscr_read();
+		mdscr |= enable;
+		mdscr_write(mdscr);
+	}
+}
+
+void disable_debug_monitors(enum debug_el el)
+{
+	u32 mdscr, disable = 0;
+
+	WARN_ON(preemptible());
+
+	if (local_dec_and_test(&__get_cpu_var(mde_ref_count)))
+		disable = ~DBG_MDSCR_MDE;
+
+	if (el == DBG_ACTIVE_EL1 &&
+	    local_dec_and_test(&__get_cpu_var(kde_ref_count)))
+		disable &= ~DBG_MDSCR_KDE;
+
+	if (disable) {
+		mdscr = mdscr_read();
+		mdscr &= disable;
+		mdscr_write(mdscr);
+	}
+}
+
+/*
+ * OS lock clearing.
+ */
+static void clear_os_lock(void *unused)
+{
+	asm volatile("msr mdscr_el1, %0" : : "r" (0));
+	isb();
+	asm volatile("msr oslar_el1, %0" : : "r" (0));
+	isb();
+}
+
+static int __cpuinit os_lock_notify(struct notifier_block *self,
+				    unsigned long action, void *data)
+{
+	int cpu = (unsigned long)data;
+	if (action == CPU_ONLINE)
+		smp_call_function_single(cpu, clear_os_lock, NULL, 1);
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __cpuinitdata os_lock_nb = {
+	.notifier_call = os_lock_notify,
+};
+
+static int __cpuinit debug_monitors_init(void)
+{
+	/* Clear the OS lock. */
+	smp_call_function(clear_os_lock, NULL, 1);
+	clear_os_lock(NULL);
+
+	/* Register hotplug handler. */
+	register_cpu_notifier(&os_lock_nb);
+	return 0;
+}
+postcore_initcall(debug_monitors_init);
+
+/*
+ * Single step API and exception handling.
+ */
+static void set_regs_spsr_ss(struct pt_regs *regs)
+{
+	unsigned long spsr;
+
+	spsr = regs->pstate;
+	spsr &= ~DBG_SPSR_SS;
+	spsr |= DBG_SPSR_SS;
+	regs->pstate = spsr;
+}
+
+static void clear_regs_spsr_ss(struct pt_regs *regs)
+{
+	unsigned long spsr;
+
+	spsr = regs->pstate;
+	spsr &= ~DBG_SPSR_SS;
+	regs->pstate = spsr;
+}
+
+static int single_step_handler(unsigned long addr, unsigned int esr,
+			       struct pt_regs *regs)
+{
+	siginfo_t info;
+
+	/*
+	 * If we are stepping a pending breakpoint, call the hw_breakpoint
+	 * handler first.
+	 */
+	if (!reinstall_suspended_bps(regs))
+		return 0;
+
+	if (user_mode(regs)) {
+		info.si_signo = SIGTRAP;
+		info.si_errno = 0;
+		info.si_code  = TRAP_HWBKPT;
+		info.si_addr  = (void __user *)instruction_pointer(regs);
+		force_sig_info(SIGTRAP, &info, current);
+
+		/*
+		 * ptrace will disable single step unless explicitly
+		 * asked to re-enable it. For other clients, it makes
+		 * sense to leave it enabled (i.e. rewind the controls
+		 * to the active-not-pending state).
+		 */
+		user_rewind_single_step(current);
+	} else {
+		/* TODO: route to KGDB */
+		pr_warning("Unexpected kernel single-step exception at EL1\n");
+		/*
+		 * Re-enable stepping since we know that we will be
+		 * returning to regs.
+		 */
+		set_regs_spsr_ss(regs);
+	}
+
+	return 0;
+}
+
+static int __init single_step_init(void)
+{
+	hook_debug_fault_code(DBG_ESR_EVT_HWSS, single_step_handler, SIGTRAP,
+			      TRAP_HWBKPT, "single-step handler");
+	return 0;
+}
+arch_initcall(single_step_init);
+
+/* Re-enable single step for syscall restarting. */
+void user_rewind_single_step(struct task_struct *task)
+{
+	/*
+	 * If single step is active for this thread, then set SPSR.SS
+	 * to 1 to avoid returning to the active-pending state.
+	 */
+	if (test_ti_thread_flag(task_thread_info(task), TIF_SINGLESTEP))
+		set_regs_spsr_ss(task_pt_regs(task));
+}
+
+void user_fastforward_single_step(struct task_struct *task)
+{
+	if (test_ti_thread_flag(task_thread_info(task), TIF_SINGLESTEP))
+		clear_regs_spsr_ss(task_pt_regs(task));
+}
+
+/* Kernel API */
+void kernel_enable_single_step(struct pt_regs *regs)
+{
+	WARN_ON(!irqs_disabled());
+	set_regs_spsr_ss(regs);
+	mdscr_write(mdscr_read() | DBG_MDSCR_SS);
+	enable_debug_monitors(DBG_ACTIVE_EL1);
+}
+
+void kernel_disable_single_step(void)
+{
+	WARN_ON(!irqs_disabled());
+	mdscr_write(mdscr_read() & ~DBG_MDSCR_SS);
+	disable_debug_monitors(DBG_ACTIVE_EL1);
+}
+
+int kernel_active_single_step(void)
+{
+	WARN_ON(!irqs_disabled());
+	return mdscr_read() & DBG_MDSCR_SS;
+}
+
+/* ptrace API */
+void user_enable_single_step(struct task_struct *task)
+{
+	set_ti_thread_flag(task_thread_info(task), TIF_SINGLESTEP);
+	set_regs_spsr_ss(task_pt_regs(task));
+}
+
+void user_disable_single_step(struct task_struct *task)
+{
+	clear_ti_thread_flag(task_thread_info(task), TIF_SINGLESTEP);
+}
diff --git a/arch/arm64/kernel/hw_breakpoint.c b/arch/arm64/kernel/hw_breakpoint.c
new file mode 100644
index 0000000..5ab825c
--- /dev/null
+++ b/arch/arm64/kernel/hw_breakpoint.c
@@ -0,0 +1,880 @@
+/*
+ * HW_breakpoint: a unified kernel/user-space hardware breakpoint facility,
+ * using the CPU's debug registers.
+ *
+ * Copyright (C) 2012 ARM Limited
+ * Author: Will Deacon <will.deacon@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#define pr_fmt(fmt) "hw-breakpoint: " fmt
+
+#include <linux/errno.h>
+#include <linux/hw_breakpoint.h>
+#include <linux/perf_event.h>
+#include <linux/ptrace.h>
+#include <linux/smp.h>
+
+#include <asm/compat.h>
+#include <asm/current.h>
+#include <asm/debug-monitors.h>
+#include <asm/hw_breakpoint.h>
+#include <asm/kdebug.h>
+#include <asm/traps.h>
+#include <asm/cputype.h>
+#include <asm/system_misc.h>
+
+/* Breakpoint currently in use for each BRP. */
+static DEFINE_PER_CPU(struct perf_event *, bp_on_reg[ARM_MAX_BRP]);
+
+/* Watchpoint currently in use for each WRP. */
+static DEFINE_PER_CPU(struct perf_event *, wp_on_reg[ARM_MAX_WRP]);
+
+/* Currently stepping a per-CPU kernel breakpoint. */
+static DEFINE_PER_CPU(int, stepping_kernel_bp);
+
+/* Number of BRP/WRP registers on this CPU. */
+static int core_num_brps;
+static int core_num_wrps;
+
+/* Determine number of BRP registers available. */
+static int get_num_brps(void)
+{
+	return ((read_cpuid(ID_AA64DFR0_EL1) >> 12) & 0xf) + 1;
+}
+
+/* Determine number of WRP registers available. */
+static int get_num_wrps(void)
+{
+	return ((read_cpuid(ID_AA64DFR0_EL1) >> 20) & 0xf) + 1;
+}
+
+int hw_breakpoint_slots(int type)
+{
+	/*
+	 * We can be called early, so don't rely on
+	 * our static variables being initialised.
+	 */
+	switch (type) {
+	case TYPE_INST:
+		return get_num_brps();
+	case TYPE_DATA:
+		return get_num_wrps();
+	default:
+		pr_warning("unknown slot type: %d\n", type);
+		return 0;
+	}
+}
+
+#define READ_WB_REG_CASE(OFF, N, REG, VAL)	\
+	case (OFF + N):				\
+		AARCH64_DBG_READ(N, REG, VAL);	\
+		break
+
+#define WRITE_WB_REG_CASE(OFF, N, REG, VAL)	\
+	case (OFF + N):				\
+		AARCH64_DBG_WRITE(N, REG, VAL);	\
+		break
+
+#define GEN_READ_WB_REG_CASES(OFF, REG, VAL)	\
+	READ_WB_REG_CASE(OFF,  0, REG, VAL);	\
+	READ_WB_REG_CASE(OFF,  1, REG, VAL);	\
+	READ_WB_REG_CASE(OFF,  2, REG, VAL);	\
+	READ_WB_REG_CASE(OFF,  3, REG, VAL);	\
+	READ_WB_REG_CASE(OFF,  4, REG, VAL);	\
+	READ_WB_REG_CASE(OFF,  5, REG, VAL);	\
+	READ_WB_REG_CASE(OFF,  6, REG, VAL);	\
+	READ_WB_REG_CASE(OFF,  7, REG, VAL);	\
+	READ_WB_REG_CASE(OFF,  8, REG, VAL);	\
+	READ_WB_REG_CASE(OFF,  9, REG, VAL);	\
+	READ_WB_REG_CASE(OFF, 10, REG, VAL);	\
+	READ_WB_REG_CASE(OFF, 11, REG, VAL);	\
+	READ_WB_REG_CASE(OFF, 12, REG, VAL);	\
+	READ_WB_REG_CASE(OFF, 13, REG, VAL);	\
+	READ_WB_REG_CASE(OFF, 14, REG, VAL);	\
+	READ_WB_REG_CASE(OFF, 15, REG, VAL)
+
+#define GEN_WRITE_WB_REG_CASES(OFF, REG, VAL)	\
+	WRITE_WB_REG_CASE(OFF,  0, REG, VAL);	\
+	WRITE_WB_REG_CASE(OFF,  1, REG, VAL);	\
+	WRITE_WB_REG_CASE(OFF,  2, REG, VAL);	\
+	WRITE_WB_REG_CASE(OFF,  3, REG, VAL);	\
+	WRITE_WB_REG_CASE(OFF,  4, REG, VAL);	\
+	WRITE_WB_REG_CASE(OFF,  5, REG, VAL);	\
+	WRITE_WB_REG_CASE(OFF,  6, REG, VAL);	\
+	WRITE_WB_REG_CASE(OFF,  7, REG, VAL);	\
+	WRITE_WB_REG_CASE(OFF,  8, REG, VAL);	\
+	WRITE_WB_REG_CASE(OFF,  9, REG, VAL);	\
+	WRITE_WB_REG_CASE(OFF, 10, REG, VAL);	\
+	WRITE_WB_REG_CASE(OFF, 11, REG, VAL);	\
+	WRITE_WB_REG_CASE(OFF, 12, REG, VAL);	\
+	WRITE_WB_REG_CASE(OFF, 13, REG, VAL);	\
+	WRITE_WB_REG_CASE(OFF, 14, REG, VAL);	\
+	WRITE_WB_REG_CASE(OFF, 15, REG, VAL)
+
+static u64 read_wb_reg(int reg, int n)
+{
+	u64 val = 0;
+
+	switch (reg + n) {
+	GEN_READ_WB_REG_CASES(AARCH64_DBG_REG_BVR, AARCH64_DBG_REG_NAME_BVR, val);
+	GEN_READ_WB_REG_CASES(AARCH64_DBG_REG_BCR, AARCH64_DBG_REG_NAME_BCR, val);
+	GEN_READ_WB_REG_CASES(AARCH64_DBG_REG_WVR, AARCH64_DBG_REG_NAME_WVR, val);
+	GEN_READ_WB_REG_CASES(AARCH64_DBG_REG_WCR, AARCH64_DBG_REG_NAME_WCR, val);
+	default:
+		pr_warning("attempt to read from unknown breakpoint register %d\n", n);
+	}
+
+	return val;
+}
+
+static void write_wb_reg(int reg, int n, u64 val)
+{
+	switch (reg + n) {
+	GEN_WRITE_WB_REG_CASES(AARCH64_DBG_REG_BVR, AARCH64_DBG_REG_NAME_BVR, val);
+	GEN_WRITE_WB_REG_CASES(AARCH64_DBG_REG_BCR, AARCH64_DBG_REG_NAME_BCR, val);
+	GEN_WRITE_WB_REG_CASES(AARCH64_DBG_REG_WVR, AARCH64_DBG_REG_NAME_WVR, val);
+	GEN_WRITE_WB_REG_CASES(AARCH64_DBG_REG_WCR, AARCH64_DBG_REG_NAME_WCR, val);
+	default:
+		pr_warning("attempt to write to unknown breakpoint register %d\n", n);
+	}
+	isb();
+}
+
+/*
+ * Convert a breakpoint privilege level to the corresponding exception
+ * level.
+ */
+static enum debug_el debug_exception_level(int privilege)
+{
+	switch (privilege) {
+	case AARCH64_BREAKPOINT_EL0:
+		return DBG_ACTIVE_EL0;
+	case AARCH64_BREAKPOINT_EL1:
+		return DBG_ACTIVE_EL1;
+	default:
+		pr_warning("invalid breakpoint privilege level %d\n", privilege);
+		return -EINVAL;
+	}
+}
+
+/*
+ * Install a perf counter breakpoint.
+ */
+int arch_install_hw_breakpoint(struct perf_event *bp)
+{
+	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
+	struct perf_event **slot, **slots;
+	struct debug_info *debug_info = &current->thread.debug;
+	int i, max_slots, ctrl_reg, val_reg, reg_enable;
+	u32 ctrl;
+
+	if (info->ctrl.type == ARM_BREAKPOINT_EXECUTE) {
+		/* Breakpoint */
+		ctrl_reg = AARCH64_DBG_REG_BCR;
+		val_reg = AARCH64_DBG_REG_BVR;
+		slots = __get_cpu_var(bp_on_reg);
+		max_slots = core_num_brps;
+		reg_enable = !debug_info->bps_disabled;
+	} else {
+		/* Watchpoint */
+		ctrl_reg = AARCH64_DBG_REG_WCR;
+		val_reg = AARCH64_DBG_REG_WVR;
+		slots = __get_cpu_var(wp_on_reg);
+		max_slots = core_num_wrps;
+		reg_enable = !debug_info->wps_disabled;
+	}
+
+	for (i = 0; i < max_slots; ++i) {
+		slot = &slots[i];
+
+		if (!*slot) {
+			*slot = bp;
+			break;
+		}
+	}
+
+	if (WARN_ONCE(i == max_slots, "Can't find any breakpoint slot"))
+		return -ENOSPC;
+
+	/* Ensure debug monitors are enabled at the correct exception level.  */
+	enable_debug_monitors(debug_exception_level(info->ctrl.privilege));
+
+	/* Setup the address register. */
+	write_wb_reg(val_reg, i, info->address);
+
+	/* Setup the control register. */
+	ctrl = encode_ctrl_reg(info->ctrl);
+	write_wb_reg(ctrl_reg, i, reg_enable ? ctrl | 0x1 : ctrl & ~0x1);
+
+	return 0;
+}
+
+void arch_uninstall_hw_breakpoint(struct perf_event *bp)
+{
+	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
+	struct perf_event **slot, **slots;
+	int i, max_slots, base;
+
+	if (info->ctrl.type == ARM_BREAKPOINT_EXECUTE) {
+		/* Breakpoint */
+		base = AARCH64_DBG_REG_BCR;
+		slots = __get_cpu_var(bp_on_reg);
+		max_slots = core_num_brps;
+	} else {
+		/* Watchpoint */
+		base = AARCH64_DBG_REG_WCR;
+		slots = __get_cpu_var(wp_on_reg);
+		max_slots = core_num_wrps;
+	}
+
+	/* Remove the breakpoint. */
+	for (i = 0; i < max_slots; ++i) {
+		slot = &slots[i];
+
+		if (*slot == bp) {
+			*slot = NULL;
+			break;
+		}
+	}
+
+	if (WARN_ONCE(i == max_slots, "Can't find any breakpoint slot"))
+		return;
+
+	/* Reset the control register. */
+	write_wb_reg(base, i, 0);
+
+	/* Release the debug monitors for the correct exception level.  */
+	disable_debug_monitors(debug_exception_level(info->ctrl.privilege));
+}
+
+static int get_hbp_len(u8 hbp_len)
+{
+	unsigned int len_in_bytes = 0;
+
+	switch (hbp_len) {
+	case ARM_BREAKPOINT_LEN_1:
+		len_in_bytes = 1;
+		break;
+	case ARM_BREAKPOINT_LEN_2:
+		len_in_bytes = 2;
+		break;
+	case ARM_BREAKPOINT_LEN_4:
+		len_in_bytes = 4;
+		break;
+	case ARM_BREAKPOINT_LEN_8:
+		len_in_bytes = 8;
+		break;
+	}
+
+	return len_in_bytes;
+}
+
+/*
+ * Check whether bp virtual address is in kernel space.
+ */
+int arch_check_bp_in_kernelspace(struct perf_event *bp)
+{
+	unsigned int len;
+	unsigned long va;
+	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
+
+	va = info->address;
+	len = get_hbp_len(info->ctrl.len);
+
+	return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE);
+}
+
+/*
+ * Extract generic type and length encodings from an arch_hw_breakpoint_ctrl.
+ * Hopefully this will disappear when ptrace can bypass the conversion
+ * to generic breakpoint descriptions.
+ */
+int arch_bp_generic_fields(struct arch_hw_breakpoint_ctrl ctrl,
+			   int *gen_len, int *gen_type)
+{
+	/* Type */
+	switch (ctrl.type) {
+	case ARM_BREAKPOINT_EXECUTE:
+		*gen_type = HW_BREAKPOINT_X;
+		break;
+	case ARM_BREAKPOINT_LOAD:
+		*gen_type = HW_BREAKPOINT_R;
+		break;
+	case ARM_BREAKPOINT_STORE:
+		*gen_type = HW_BREAKPOINT_W;
+		break;
+	case ARM_BREAKPOINT_LOAD | ARM_BREAKPOINT_STORE:
+		*gen_type = HW_BREAKPOINT_RW;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* Len */
+	switch (ctrl.len) {
+	case ARM_BREAKPOINT_LEN_1:
+		*gen_len = HW_BREAKPOINT_LEN_1;
+		break;
+	case ARM_BREAKPOINT_LEN_2:
+		*gen_len = HW_BREAKPOINT_LEN_2;
+		break;
+	case ARM_BREAKPOINT_LEN_4:
+		*gen_len = HW_BREAKPOINT_LEN_4;
+		break;
+	case ARM_BREAKPOINT_LEN_8:
+		*gen_len = HW_BREAKPOINT_LEN_8;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ * Construct an arch_hw_breakpoint from a perf_event.
+ */
+static int arch_build_bp_info(struct perf_event *bp)
+{
+	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
+
+	/* Type */
+	switch (bp->attr.bp_type) {
+	case HW_BREAKPOINT_X:
+		info->ctrl.type = ARM_BREAKPOINT_EXECUTE;
+		break;
+	case HW_BREAKPOINT_R:
+		info->ctrl.type = ARM_BREAKPOINT_LOAD;
+		break;
+	case HW_BREAKPOINT_W:
+		info->ctrl.type = ARM_BREAKPOINT_STORE;
+		break;
+	case HW_BREAKPOINT_RW:
+		info->ctrl.type = ARM_BREAKPOINT_LOAD | ARM_BREAKPOINT_STORE;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* Len */
+	switch (bp->attr.bp_len) {
+	case HW_BREAKPOINT_LEN_1:
+		info->ctrl.len = ARM_BREAKPOINT_LEN_1;
+		break;
+	case HW_BREAKPOINT_LEN_2:
+		info->ctrl.len = ARM_BREAKPOINT_LEN_2;
+		break;
+	case HW_BREAKPOINT_LEN_4:
+		info->ctrl.len = ARM_BREAKPOINT_LEN_4;
+		break;
+	case HW_BREAKPOINT_LEN_8:
+		info->ctrl.len = ARM_BREAKPOINT_LEN_8;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/*
+	 * On AArch64, we only permit breakpoints of length 4, whereas
+	 * AArch32 also requires breakpoints of length 2 for Thumb.
+	 * Watchpoints can be of length 1, 2, 4 or 8 bytes.
+	 */
+	if (info->ctrl.type == ARM_BREAKPOINT_EXECUTE) {
+		if (is_compat_task()) {
+			if (info->ctrl.len != ARM_BREAKPOINT_LEN_2 &&
+			    info->ctrl.len != ARM_BREAKPOINT_LEN_4)
+				return -EINVAL;
+		} else if (info->ctrl.len != ARM_BREAKPOINT_LEN_4) {
+			/*
+			 * FIXME: Some tools (I'm looking at you perf) assume
+			 *	  that breakpoints should be sizeof(long). This
+			 *	  is nonsense. For now, we fix up the parameter
+			 *	  but we should probably return -EINVAL instead.
+			 */
+			info->ctrl.len = ARM_BREAKPOINT_LEN_4;
+		}
+	}
+
+	/* Address */
+	info->address = bp->attr.bp_addr;
+
+	/*
+	 * Privilege
+	 * Note that we disallow combined EL0/EL1 breakpoints because
+	 * that would complicate the stepping code.
+	 */
+	if (arch_check_bp_in_kernelspace(bp))
+		info->ctrl.privilege = AARCH64_BREAKPOINT_EL1;
+	else
+		info->ctrl.privilege = AARCH64_BREAKPOINT_EL0;
+
+	/* Enabled? */
+	info->ctrl.enabled = !bp->attr.disabled;
+
+	return 0;
+}
+
+/*
+ * Validate the arch-specific HW Breakpoint register settings.
+ */
+int arch_validate_hwbkpt_settings(struct perf_event *bp)
+{
+	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
+	int ret;
+	u64 alignment_mask, offset;
+
+	/* Build the arch_hw_breakpoint. */
+	ret = arch_build_bp_info(bp);
+	if (ret)
+		return ret;
+
+	/*
+	 * Check address alignment.
+	 * We don't do any clever alignment correction for watchpoints
+	 * because using 64-bit unaligned addresses is deprecated for
+	 * AArch64.
+	 *
+	 * AArch32 tasks expect some simple alignment fixups, so emulate
+	 * that here.
+	 */
+	if (is_compat_task()) {
+		if (info->ctrl.len == ARM_BREAKPOINT_LEN_8)
+			alignment_mask = 0x7;
+		else
+			alignment_mask = 0x3;
+		offset = info->address & alignment_mask;
+		switch (offset) {
+		case 0:
+			/* Aligned */
+			break;
+		case 1:
+			/* Allow single byte watchpoint. */
+			if (info->ctrl.len == ARM_BREAKPOINT_LEN_1)
+				break;
+		case 2:
+			/* Allow halfword watchpoints and breakpoints. */
+			if (info->ctrl.len == ARM_BREAKPOINT_LEN_2)
+				break;
+		default:
+			return -EINVAL;
+		}
+
+		info->address &= ~alignment_mask;
+		info->ctrl.len <<= offset;
+	} else {
+		if (info->ctrl.type == ARM_BREAKPOINT_EXECUTE)
+			alignment_mask = 0x3;
+		else
+			alignment_mask = 0x7;
+		if (info->address & alignment_mask)
+			return -EINVAL;
+	}
+
+	/*
+	 * Disallow per-task kernel breakpoints since these would
+	 * complicate the stepping code.
+	 */
+	if (info->ctrl.privilege == AARCH64_BREAKPOINT_EL1 && bp->hw.bp_target)
+		return -EINVAL;
+
+	return 0;
+}
+
+/*
+ * Enable/disable all of the breakpoints active at the specified
+ * exception level at the register level.
+ * This is used when single-stepping after a breakpoint exception.
+ */
+static void toggle_bp_registers(int reg, enum debug_el el, int enable)
+{
+	int i, max_slots, privilege;
+	u32 ctrl;
+	struct perf_event **slots;
+
+	switch (reg) {
+	case AARCH64_DBG_REG_BCR:
+		slots = __get_cpu_var(bp_on_reg);
+		max_slots = core_num_brps;
+		break;
+	case AARCH64_DBG_REG_WCR:
+		slots = __get_cpu_var(wp_on_reg);
+		max_slots = core_num_wrps;
+		break;
+	default:
+		return;
+	}
+
+	for (i = 0; i < max_slots; ++i) {
+		if (!slots[i])
+			continue;
+
+		privilege = counter_arch_bp(slots[i])->ctrl.privilege;
+		if (debug_exception_level(privilege) != el)
+			continue;
+
+		ctrl = read_wb_reg(reg, i);
+		if (enable)
+			ctrl |= 0x1;
+		else
+			ctrl &= ~0x1;
+		write_wb_reg(reg, i, ctrl);
+	}
+}
+
+/*
+ * Debug exception handlers.
+ */
+static int breakpoint_handler(unsigned long unused, unsigned int esr,
+			      struct pt_regs *regs)
+{
+	int i, step = 0, *kernel_step;
+	u32 ctrl_reg;
+	u64 addr, val;
+	struct perf_event *bp, **slots;
+	struct debug_info *debug_info;
+	struct arch_hw_breakpoint_ctrl ctrl;
+
+	slots = (struct perf_event **)__get_cpu_var(bp_on_reg);
+	addr = instruction_pointer(regs);
+	debug_info = &current->thread.debug;
+
+	for (i = 0; i < core_num_brps; ++i) {
+		rcu_read_lock();
+
+		bp = slots[i];
+
+		if (bp == NULL)
+			goto unlock;
+
+		/* Check if the breakpoint value matches. */
+		val = read_wb_reg(AARCH64_DBG_REG_BVR, i);
+		if (val != (addr & ~0x3))
+			goto unlock;
+
+		/* Possible match, check the byte address select to confirm. */
+		ctrl_reg = read_wb_reg(AARCH64_DBG_REG_BCR, i);
+		decode_ctrl_reg(ctrl_reg, &ctrl);
+		if (!((1 << (addr & 0x3)) & ctrl.len))
+			goto unlock;
+
+		counter_arch_bp(bp)->trigger = addr;
+		perf_bp_event(bp, regs);
+
+		/* Do we need to handle the stepping? */
+		if (!bp->overflow_handler)
+			step = 1;
+unlock:
+		rcu_read_unlock();
+	}
+
+	if (!step)
+		return 0;
+
+	if (user_mode(regs)) {
+		debug_info->bps_disabled = 1;
+		toggle_bp_registers(AARCH64_DBG_REG_BCR, DBG_ACTIVE_EL0, 0);
+
+		/* If we're already stepping a watchpoint, just return. */
+		if (debug_info->wps_disabled)
+			return 0;
+
+		if (test_thread_flag(TIF_SINGLESTEP))
+			debug_info->suspended_step = 1;
+		else
+			user_enable_single_step(current);
+	} else {
+		toggle_bp_registers(AARCH64_DBG_REG_BCR, DBG_ACTIVE_EL1, 0);
+		kernel_step = &__get_cpu_var(stepping_kernel_bp);
+
+		if (*kernel_step != ARM_KERNEL_STEP_NONE)
+			return 0;
+
+		if (kernel_active_single_step()) {
+			*kernel_step = ARM_KERNEL_STEP_SUSPEND;
+		} else {
+			*kernel_step = ARM_KERNEL_STEP_ACTIVE;
+			kernel_enable_single_step(regs);
+		}
+	}
+
+	return 0;
+}
+
+static int watchpoint_handler(unsigned long addr, unsigned int esr,
+			      struct pt_regs *regs)
+{
+	int i, step = 0, *kernel_step, access;
+	u32 ctrl_reg;
+	u64 val, alignment_mask;
+	struct perf_event *wp, **slots;
+	struct debug_info *debug_info;
+	struct arch_hw_breakpoint *info;
+	struct arch_hw_breakpoint_ctrl ctrl;
+
+	slots = (struct perf_event **)__get_cpu_var(wp_on_reg);
+	debug_info = &current->thread.debug;
+
+	for (i = 0; i < core_num_wrps; ++i) {
+		rcu_read_lock();
+
+		wp = slots[i];
+
+		if (wp == NULL)
+			goto unlock;
+
+		info = counter_arch_bp(wp);
+		/* AArch32 watchpoints are either 4 or 8 bytes aligned. */
+		if (is_compat_task()) {
+			if (info->ctrl.len == ARM_BREAKPOINT_LEN_8)
+				alignment_mask = 0x7;
+			else
+				alignment_mask = 0x3;
+		} else {
+			alignment_mask = 0x7;
+		}
+
+		/* Check if the watchpoint value matches. */
+		val = read_wb_reg(AARCH64_DBG_REG_WVR, i);
+		if (val != (addr & ~alignment_mask))
+			goto unlock;
+
+		/* Possible match, check the byte address select to confirm. */
+		ctrl_reg = read_wb_reg(AARCH64_DBG_REG_WCR, i);
+		decode_ctrl_reg(ctrl_reg, &ctrl);
+		if (!((1 << (addr & alignment_mask)) & ctrl.len))
+			goto unlock;
+
+		/*
+		 * Check that the access type matches.
+		 * 0 => load, otherwise => store
+		 */
+		access = (esr & AARCH64_ESR_ACCESS_MASK) ? HW_BREAKPOINT_W :
+			 HW_BREAKPOINT_R;
+		if (!(access & hw_breakpoint_type(wp)))
+			goto unlock;
+
+		info->trigger = addr;
+		perf_bp_event(wp, regs);
+
+		/* Do we need to handle the stepping? */
+		if (!wp->overflow_handler)
+			step = 1;
+
+unlock:
+		rcu_read_unlock();
+	}
+
+	if (!step)
+		return 0;
+
+	/*
+	 * We always disable EL0 watchpoints because the kernel can
+	 * cause these to fire via an unprivileged access.
+	 */
+	toggle_bp_registers(AARCH64_DBG_REG_WCR, DBG_ACTIVE_EL0, 0);
+
+	if (user_mode(regs)) {
+		debug_info->wps_disabled = 1;
+
+		/* If we're already stepping a breakpoint, just return. */
+		if (debug_info->bps_disabled)
+			return 0;
+
+		if (test_thread_flag(TIF_SINGLESTEP))
+			debug_info->suspended_step = 1;
+		else
+			user_enable_single_step(current);
+	} else {
+		toggle_bp_registers(AARCH64_DBG_REG_WCR, DBG_ACTIVE_EL1, 0);
+		kernel_step = &__get_cpu_var(stepping_kernel_bp);
+
+		if (*kernel_step != ARM_KERNEL_STEP_NONE)
+			return 0;
+
+		if (kernel_active_single_step()) {
+			*kernel_step = ARM_KERNEL_STEP_SUSPEND;
+		} else {
+			*kernel_step = ARM_KERNEL_STEP_ACTIVE;
+			kernel_enable_single_step(regs);
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Handle single-step exception.
+ */
+int reinstall_suspended_bps(struct pt_regs *regs)
+{
+	struct debug_info *debug_info = &current->thread.debug;
+	int handled_exception = 0, *kernel_step;
+
+	kernel_step = &__get_cpu_var(stepping_kernel_bp);
+
+	/*
+	 * Called from single-step exception handler.
+	 * Return 0 if execution can resume, 1 if a SIGTRAP should be
+	 * reported.
+	 */
+	if (user_mode(regs)) {
+		if (debug_info->bps_disabled) {
+			debug_info->bps_disabled = 0;
+			toggle_bp_registers(AARCH64_DBG_REG_BCR, DBG_ACTIVE_EL0, 1);
+			handled_exception = 1;
+		}
+
+		if (debug_info->wps_disabled) {
+			debug_info->wps_disabled = 0;
+			toggle_bp_registers(AARCH64_DBG_REG_WCR, DBG_ACTIVE_EL0, 1);
+			handled_exception = 1;
+		}
+
+		if (handled_exception) {
+			if (debug_info->suspended_step) {
+				debug_info->suspended_step = 0;
+				/* Allow exception handling to fall-through. */
+				handled_exception = 0;
+			} else {
+				user_disable_single_step(current);
+			}
+		}
+	} else if (*kernel_step != ARM_KERNEL_STEP_NONE) {
+		toggle_bp_registers(AARCH64_DBG_REG_BCR, DBG_ACTIVE_EL1, 1);
+		toggle_bp_registers(AARCH64_DBG_REG_WCR, DBG_ACTIVE_EL1, 1);
+
+		if (!debug_info->wps_disabled)
+			toggle_bp_registers(AARCH64_DBG_REG_WCR, DBG_ACTIVE_EL0, 1);
+
+		if (*kernel_step != ARM_KERNEL_STEP_SUSPEND) {
+			kernel_disable_single_step();
+			handled_exception = 1;
+		} else {
+			handled_exception = 0;
+		}
+
+		*kernel_step = ARM_KERNEL_STEP_NONE;
+	}
+
+	return !handled_exception;
+}
+
+/*
+ * Context-switcher for restoring suspended breakpoints.
+ */
+void hw_breakpoint_thread_switch(struct task_struct *next)
+{
+	/*
+	 *           current        next
+	 * disabled: 0              0     => The usual case, NOTIFY_DONE
+	 *           0              1     => Disable the registers
+	 *           1              0     => Enable the registers
+	 *           1              1     => NOTIFY_DONE. per-task bps will
+	 *                                   get taken care of by perf.
+	 */
+
+	struct debug_info *current_debug_info, *next_debug_info;
+
+	current_debug_info = &current->thread.debug;
+	next_debug_info = &next->thread.debug;
+
+	/* Update breakpoints. */
+	if (current_debug_info->bps_disabled != next_debug_info->bps_disabled)
+		toggle_bp_registers(AARCH64_DBG_REG_BCR,
+				    DBG_ACTIVE_EL0,
+				    !next_debug_info->bps_disabled);
+
+	/* Update watchpoints. */
+	if (current_debug_info->wps_disabled != next_debug_info->wps_disabled)
+		toggle_bp_registers(AARCH64_DBG_REG_WCR,
+				    DBG_ACTIVE_EL0,
+				    !next_debug_info->wps_disabled);
+}
+
+/*
+ * CPU initialisation.
+ */
+static void reset_ctrl_regs(void *unused)
+{
+	int i;
+
+	for (i = 0; i < core_num_brps; ++i) {
+		write_wb_reg(AARCH64_DBG_REG_BCR, i, 0UL);
+		write_wb_reg(AARCH64_DBG_REG_BVR, i, 0UL);
+	}
+
+	for (i = 0; i < core_num_wrps; ++i) {
+		write_wb_reg(AARCH64_DBG_REG_WCR, i, 0UL);
+		write_wb_reg(AARCH64_DBG_REG_WVR, i, 0UL);
+	}
+}
+
+static int __cpuinit hw_breakpoint_reset_notify(struct notifier_block *self,
+						unsigned long action,
+						void *hcpu)
+{
+	int cpu = (long)hcpu;
+	if (action == CPU_ONLINE)
+		smp_call_function_single(cpu, reset_ctrl_regs, NULL, 1);
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __cpuinitdata hw_breakpoint_reset_nb = {
+	.notifier_call = hw_breakpoint_reset_notify,
+};
+
+/*
+ * One-time initialisation.
+ */
+static int __init arch_hw_breakpoint_init(void)
+{
+	core_num_brps = get_num_brps();
+	core_num_wrps = get_num_wrps();
+
+	pr_info("found %d breakpoint and %d watchpoint registers.\n",
+		core_num_brps, core_num_wrps);
+
+	/*
+	 * Reset the breakpoint resources. We assume that a halting
+	 * debugger will leave the world in a nice state for us.
+	 */
+	smp_call_function(reset_ctrl_regs, NULL, 1);
+	reset_ctrl_regs(NULL);
+
+	/* Register debug fault handlers. */
+	hook_debug_fault_code(DBG_ESR_EVT_HWBP, breakpoint_handler, SIGTRAP,
+			      TRAP_HWBKPT, "hw-breakpoint handler");
+	hook_debug_fault_code(DBG_ESR_EVT_HWWP, watchpoint_handler, SIGTRAP,
+			      TRAP_HWBKPT, "hw-watchpoint handler");
+
+	/* Register hotplug notifier. */
+	register_cpu_notifier(&hw_breakpoint_reset_nb);
+
+	return 0;
+}
+arch_initcall(arch_hw_breakpoint_init);
+
+void hw_breakpoint_pmu_read(struct perf_event *bp)
+{
+}
+
+/*
+ * Dummy function to register with die_notifier.
+ */
+int hw_breakpoint_exceptions_notify(struct notifier_block *unused,
+				    unsigned long val, void *data)
+{
+	return NOTIFY_DONE;
+}
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
new file mode 100644
index 0000000..9e1e200
--- /dev/null
+++ b/arch/arm64/kernel/ptrace.c
@@ -0,0 +1,1126 @@
+/*
+ * Based on arch/arm/kernel/ptrace.c
+ *
+ * By Ross Biro 1/23/92
+ * edited by Linus Torvalds
+ * ARM modifications Copyright (C) 2000 Russell King
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/ptrace.h>
+#include <linux/user.h>
+#include <linux/security.h>
+#include <linux/init.h>
+#include <linux/signal.h>
+#include <linux/uaccess.h>
+#include <linux/perf_event.h>
+#include <linux/hw_breakpoint.h>
+#include <linux/regset.h>
+#include <linux/tracehook.h>
+#include <linux/elf.h>
+
+#include <asm/compat.h>
+#include <asm/debug-monitors.h>
+#include <asm/pgtable.h>
+#include <asm/traps.h>
+#include <asm/system_misc.h>
+
+/*
+ * TODO: does not yet catch signals sent when the child dies.
+ * in exit.c or in signal.c.
+ */
+
+/*
+ * Called by kernel/ptrace.c when detaching..
+ */
+void ptrace_disable(struct task_struct *child)
+{
+}
+
+/*
+ * Handle hitting a breakpoint.
+ */
+static int ptrace_break(struct pt_regs *regs)
+{
+	siginfo_t info = {
+		.si_signo = SIGTRAP,
+		.si_errno = 0,
+		.si_code  = TRAP_BRKPT,
+		.si_addr  = (void __user *)instruction_pointer(regs),
+	};
+
+	force_sig_info(SIGTRAP, &info, current);
+	return 0;
+}
+
+static int arm64_break_trap(unsigned long addr, unsigned int esr,
+			    struct pt_regs *regs)
+{
+	return ptrace_break(regs);
+}
+
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+/*
+ * Handle hitting a HW-breakpoint.
+ */
+static void ptrace_hbptriggered(struct perf_event *bp,
+				struct perf_sample_data *data,
+				struct pt_regs *regs)
+{
+	struct arch_hw_breakpoint *bkpt = counter_arch_bp(bp);
+	siginfo_t info = {
+		.si_signo	= SIGTRAP,
+		.si_errno	= 0,
+		.si_code	= TRAP_HWBKPT,
+		.si_addr	= (void __user *)(bkpt->trigger),
+	};
+
+#ifdef CONFIG_AARCH32_EMULATION
+	int i;
+
+	if (!is_compat_task())
+		goto send_sig;
+
+	for (i = 0; i < ARM_MAX_BRP; ++i) {
+		if (current->thread.debug.hbp_break[i] == bp) {
+			info.si_errno = (i << 1) + 1;
+			break;
+		}
+	}
+	for (i = ARM_MAX_BRP; i < ARM_MAX_HBP_SLOTS && !bp; ++i) {
+		if (current->thread.debug.hbp_watch[i] == bp) {
+			info.si_errno = -((i << 1) + 1);
+			break;
+		}
+	}
+
+send_sig:
+#endif
+	force_sig_info(SIGTRAP, &info, current);
+}
+
+/*
+ * Unregister breakpoints from this task and reset the pointers in
+ * the thread_struct.
+ */
+void flush_ptrace_hw_breakpoint(struct task_struct *tsk)
+{
+	int i;
+	struct thread_struct *t = &tsk->thread;
+
+	for (i = 0; i < ARM_MAX_BRP; i++) {
+		if (t->debug.hbp_break[i]) {
+			unregister_hw_breakpoint(t->debug.hbp_break[i]);
+			t->debug.hbp_break[i] = NULL;
+		}
+	}
+
+	for (i = 0; i < ARM_MAX_WRP; i++) {
+		if (t->debug.hbp_watch[i]) {
+			unregister_hw_breakpoint(t->debug.hbp_watch[i]);
+			t->debug.hbp_watch[i] = NULL;
+		}
+	}
+}
+
+void ptrace_hw_copy_thread(struct task_struct *tsk)
+{
+	memset(&tsk->thread.debug, 0, sizeof(struct debug_info));
+}
+
+static struct perf_event *ptrace_hbp_get_event(unsigned int note_type,
+					       struct task_struct *tsk,
+					       unsigned long idx)
+{
+	struct perf_event *bp = ERR_PTR(-EINVAL);
+
+	switch (note_type) {
+	case NT_ARM_HW_BREAK:
+		if (idx < ARM_MAX_BRP)
+			bp = tsk->thread.debug.hbp_break[idx];
+		break;
+	case NT_ARM_HW_WATCH:
+		if (idx < ARM_MAX_WRP)
+			bp = tsk->thread.debug.hbp_watch[idx];
+		break;
+	}
+
+	return bp;
+}
+
+static int ptrace_hbp_set_event(unsigned int note_type,
+				struct task_struct *tsk,
+				unsigned long idx,
+				struct perf_event *bp)
+{
+	int err = -EINVAL;
+
+	switch (note_type) {
+	case NT_ARM_HW_BREAK:
+		if (idx < ARM_MAX_BRP) {
+			tsk->thread.debug.hbp_break[idx] = bp;
+			err = 0;
+		}
+		break;
+	case NT_ARM_HW_WATCH:
+		if (idx < ARM_MAX_WRP) {
+			tsk->thread.debug.hbp_watch[idx] = bp;
+			err = 0;
+		}
+		break;
+	}
+
+	return err;
+}
+
+static struct perf_event *ptrace_hbp_create(unsigned int note_type,
+					    struct task_struct *tsk,
+					    unsigned long idx)
+{
+	struct perf_event *bp;
+	struct perf_event_attr attr;
+	int err, type;
+
+	switch (note_type) {
+	case NT_ARM_HW_BREAK:
+		type = HW_BREAKPOINT_X;
+		break;
+	case NT_ARM_HW_WATCH:
+		type = HW_BREAKPOINT_RW;
+		break;
+	default:
+		return ERR_PTR(-EINVAL);
+	}
+
+	ptrace_breakpoint_init(&attr);
+
+	/*
+	 * Initialise fields to sane defaults
+	 * (i.e. values that will pass validation).
+	 */
+	attr.bp_addr	= 0;
+	attr.bp_len	= HW_BREAKPOINT_LEN_4;
+	attr.bp_type	= type;
+	attr.disabled	= 1;
+
+	bp = register_user_hw_breakpoint(&attr, ptrace_hbptriggered, NULL, tsk);
+	if (IS_ERR(bp))
+		return bp;
+
+	err = ptrace_hbp_set_event(note_type, tsk, idx, bp);
+	if (err)
+		return ERR_PTR(err);
+
+	return bp;
+}
+
+static int ptrace_hbp_fill_attr_ctrl(unsigned int note_type,
+				     struct arch_hw_breakpoint_ctrl ctrl,
+				     struct perf_event_attr *attr)
+{
+	int err, len, type;
+
+	err = arch_bp_generic_fields(ctrl, &len, &type);
+	if (err)
+		return err;
+
+	switch (note_type) {
+	case NT_ARM_HW_BREAK:
+		if ((type & HW_BREAKPOINT_X) != type)
+			return -EINVAL;
+		break;
+	case NT_ARM_HW_WATCH:
+		if ((type & HW_BREAKPOINT_RW) != type)
+			return -EINVAL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	attr->bp_len	= len;
+	attr->bp_type	= type;
+	attr->disabled	= !ctrl.enabled;
+
+	return 0;
+}
+
+static int ptrace_hbp_get_resource_info(unsigned int note_type, u32 *info)
+{
+	u8 num;
+	u32 reg = 0;
+
+	switch (note_type) {
+	case NT_ARM_HW_BREAK:
+		num = hw_breakpoint_slots(TYPE_INST);
+		break;
+	case NT_ARM_HW_WATCH:
+		num = hw_breakpoint_slots(TYPE_DATA);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	reg |= debug_monitors_arch();
+	reg <<= 8;
+	reg |= num;
+
+	*info = reg;
+	return 0;
+}
+
+static int ptrace_hbp_get_ctrl(unsigned int note_type,
+			       struct task_struct *tsk,
+			       unsigned long idx,
+			       u32 *ctrl)
+{
+	struct perf_event *bp = ptrace_hbp_get_event(note_type, tsk, idx);
+
+	if (IS_ERR(bp))
+		return PTR_ERR(bp);
+
+	*ctrl = bp ? encode_ctrl_reg(counter_arch_bp(bp)->ctrl) : 0;
+	return 0;
+}
+
+static int ptrace_hbp_get_addr(unsigned int note_type,
+			       struct task_struct *tsk,
+			       unsigned long idx,
+			       u64 *addr)
+{
+	struct perf_event *bp = ptrace_hbp_get_event(note_type, tsk, idx);
+
+	if (IS_ERR(bp))
+		return PTR_ERR(bp);
+
+	*addr = bp ? bp->attr.bp_addr : 0;
+	return 0;
+}
+
+static struct perf_event *ptrace_hbp_get_initialised_bp(unsigned int note_type,
+							struct task_struct *tsk,
+							unsigned long idx)
+{
+	struct perf_event *bp = ptrace_hbp_get_event(note_type, tsk, idx);
+
+	if (!bp)
+		bp = ptrace_hbp_create(note_type, tsk, idx);
+
+	return bp;
+}
+
+static int ptrace_hbp_set_ctrl(unsigned int note_type,
+			       struct task_struct *tsk,
+			       unsigned long idx,
+			       u32 uctrl)
+{
+	int err;
+	struct perf_event *bp;
+	struct perf_event_attr attr;
+	struct arch_hw_breakpoint_ctrl ctrl;
+
+	bp = ptrace_hbp_get_initialised_bp(note_type, tsk, idx);
+	if (IS_ERR(bp)) {
+		err = PTR_ERR(bp);
+		return err;
+	}
+
+	attr = bp->attr;
+	decode_ctrl_reg(uctrl, &ctrl);
+	err = ptrace_hbp_fill_attr_ctrl(note_type, ctrl, &attr);
+	if (err)
+		return err;
+
+	return modify_user_hw_breakpoint(bp, &attr);
+}
+
+static int ptrace_hbp_set_addr(unsigned int note_type,
+			       struct task_struct *tsk,
+			       unsigned long idx,
+			       u64 addr)
+{
+	int err;
+	struct perf_event *bp;
+	struct perf_event_attr attr;
+
+	bp = ptrace_hbp_get_initialised_bp(note_type, tsk, idx);
+	if (IS_ERR(bp)) {
+		err = PTR_ERR(bp);
+		return err;
+	}
+
+	attr = bp->attr;
+	attr.bp_addr = addr;
+	err = modify_user_hw_breakpoint(bp, &attr);
+	return err;
+}
+
+#define PTRACE_HBP_ADDR_SZ	sizeof(u64)
+#define PTRACE_HBP_CTRL_SZ	sizeof(u32)
+#define PTRACE_HBP_REG_OFF	sizeof(u32)
+
+static int hw_break_get(struct task_struct *target,
+			const struct user_regset *regset,
+			unsigned int pos, unsigned int count,
+			void *kbuf, void __user *ubuf)
+{
+	unsigned int note_type = regset->core_note_type;
+	int ret, idx = 0, offset = PTRACE_HBP_REG_OFF, limit;
+	u32 info, ctrl;
+	u64 addr;
+
+	/* Resource info */
+	ret = ptrace_hbp_get_resource_info(note_type, &info);
+	if (ret)
+		return ret;
+
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf, &info, 0, 4);
+	if (ret)
+		return ret;
+
+	/* (address, ctrl) registers */
+	limit = regset->n * regset->size;
+	while (count && offset < limit) {
+		ret = ptrace_hbp_get_addr(note_type, target, idx, &addr);
+		if (ret)
+			return ret;
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf, &addr,
+					  offset, offset + PTRACE_HBP_ADDR_SZ);
+		if (ret)
+			return ret;
+		offset += PTRACE_HBP_ADDR_SZ;
+
+		ret = ptrace_hbp_get_ctrl(note_type, target, idx, &ctrl);
+		if (ret)
+			return ret;
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf, &ctrl,
+					  offset, offset + PTRACE_HBP_CTRL_SZ);
+		if (ret)
+			return ret;
+		offset += PTRACE_HBP_CTRL_SZ;
+		idx++;
+	}
+
+	return 0;
+}
+
+static int hw_break_set(struct task_struct *target,
+			const struct user_regset *regset,
+			unsigned int pos, unsigned int count,
+			const void *kbuf, const void __user *ubuf)
+{
+	unsigned int note_type = regset->core_note_type;
+	int ret, idx = 0, offset = PTRACE_HBP_REG_OFF, limit;
+	u32 ctrl;
+	u64 addr;
+
+	/* Resource info */
+	ret = user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf, 0, 4);
+	if (ret)
+		return ret;
+
+	/* (address, ctrl) registers */
+	limit = regset->n * regset->size;
+	while (count && offset < limit) {
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &addr,
+					 offset, offset + PTRACE_HBP_ADDR_SZ);
+		if (ret)
+			return ret;
+		ret = ptrace_hbp_set_addr(note_type, target, idx, addr);
+		if (ret)
+			return ret;
+		offset += PTRACE_HBP_ADDR_SZ;
+
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &ctrl,
+					 offset, offset + PTRACE_HBP_CTRL_SZ);
+		if (ret)
+			return ret;
+		ret = ptrace_hbp_set_ctrl(note_type, target, idx, ctrl);
+		if (ret)
+			return ret;
+		offset += PTRACE_HBP_CTRL_SZ;
+		idx++;
+	}
+
+	return 0;
+}
+#endif	/* CONFIG_HAVE_HW_BREAKPOINT */
+
+static int gpr_get(struct task_struct *target,
+		   const struct user_regset *regset,
+		   unsigned int pos, unsigned int count,
+		   void *kbuf, void __user *ubuf)
+{
+	struct user_pt_regs *uregs = &task_pt_regs(target)->user_regs;
+	return user_regset_copyout(&pos, &count, &kbuf, &ubuf, uregs, 0, -1);
+}
+
+static int gpr_set(struct task_struct *target, const struct user_regset *regset,
+		   unsigned int pos, unsigned int count,
+		   const void *kbuf, const void __user *ubuf)
+{
+	int ret;
+	struct user_pt_regs newregs;
+
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &newregs, 0, -1);
+	if (ret)
+		return ret;
+
+	if (!valid_user_regs(&newregs))
+		return -EINVAL;
+
+	task_pt_regs(target)->user_regs = newregs;
+	return 0;
+}
+
+/*
+ * TODO: update fp accessors for lazy context switching (sync/flush hwstate)
+ */
+static int fpr_get(struct task_struct *target, const struct user_regset *regset,
+		   unsigned int pos, unsigned int count,
+		   void *kbuf, void __user *ubuf)
+{
+	struct user_fpsimd_state *uregs;
+	uregs = &target->thread.fpsimd_state.user_fpsimd;
+	return user_regset_copyout(&pos, &count, &kbuf, &ubuf, uregs, 0, -1);
+}
+
+static int fpr_set(struct task_struct *target, const struct user_regset *regset,
+		   unsigned int pos, unsigned int count,
+		   const void *kbuf, const void __user *ubuf)
+{
+	int ret;
+	struct user_fpsimd_state newstate;
+
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &newstate, 0, -1);
+	if (ret)
+		return ret;
+
+	target->thread.fpsimd_state.user_fpsimd = newstate;
+	return ret;
+}
+
+static int tls_get(struct task_struct *target, const struct user_regset *regset,
+		   unsigned int pos, unsigned int count,
+		   void *kbuf, void __user *ubuf)
+{
+	unsigned long *tls = &target->thread.tp_value;
+	return user_regset_copyout(&pos, &count, &kbuf, &ubuf, tls, 0, -1);
+}
+
+static int tls_set(struct task_struct *target, const struct user_regset *regset,
+		   unsigned int pos, unsigned int count,
+		   const void *kbuf, const void __user *ubuf)
+{
+	int ret;
+	unsigned long tls;
+
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &tls, 0, -1);
+	if (ret)
+		return ret;
+
+	target->thread.tp_value = tls;
+	return ret;
+}
+
+enum aarch64_regset {
+	REGSET_GPR,
+	REGSET_FPR,
+	REGSET_TLS,
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+	REGSET_HW_BREAK,
+	REGSET_HW_WATCH,
+#endif
+};
+
+static const struct user_regset aarch64_regsets[] = {
+	[REGSET_GPR] = {
+		.core_note_type = NT_PRSTATUS,
+		.n = sizeof(struct user_pt_regs) / sizeof(u64),
+		.size = sizeof(u64),
+		.align = sizeof(u64),
+		.get = gpr_get,
+		.set = gpr_set
+	},
+	[REGSET_FPR] = {
+		.core_note_type = NT_PRFPREG,
+		.n = sizeof(struct user_fpsimd_state) / sizeof(u32),
+		/*
+		 * We pretend we have 32-bit registers because the fpsr and
+		 * fpcr are 32-bits wide.
+		 */
+		.size = sizeof(u32),
+		.align = sizeof(u32),
+		.get = fpr_get,
+		.set = fpr_set
+	},
+	[REGSET_TLS] = {
+		.core_note_type = NT_ARM_TLS,
+		.n = 1,
+		.size = sizeof(void *),
+		.align = sizeof(void *),
+		.get = tls_get,
+		.set = tls_set,
+	},
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+	[REGSET_HW_BREAK] = {
+		.core_note_type = NT_ARM_HW_BREAK,
+		.n = sizeof(struct user_hwdebug_state) / sizeof(u32),
+		.size = sizeof(u32),
+		.align = sizeof(u32),
+		.get = hw_break_get,
+		.set = hw_break_set,
+	},
+	[REGSET_HW_WATCH] = {
+		.core_note_type = NT_ARM_HW_WATCH,
+		.n = sizeof(struct user_hwdebug_state) / sizeof(u32),
+		.size = sizeof(u32),
+		.align = sizeof(u32),
+		.get = hw_break_get,
+		.set = hw_break_set,
+	},
+#endif
+};
+
+static const struct user_regset_view user_aarch64_view = {
+	.name = "aarch64", .e_machine = EM_AARCH64,
+	.regsets = aarch64_regsets, .n = ARRAY_SIZE(aarch64_regsets)
+};
+
+#ifdef CONFIG_COMPAT
+#include <linux/compat.h>
+
+enum compat_regset {
+	REGSET_COMPAT_GPR,
+	REGSET_COMPAT_VFP,
+};
+
+static int compat_gpr_get(struct task_struct *target,
+			  const struct user_regset *regset,
+			  unsigned int pos, unsigned int count,
+			  void *kbuf, void __user *ubuf)
+{
+	int ret = 0;
+	unsigned int i, start, num_regs;
+
+	/* Calculate the number of AArch32 registers contained in count */
+	num_regs = count / regset->size;
+
+	/* Convert pos into an register number */
+	start = pos / regset->size;
+
+	if (start + num_regs > regset->n)
+		return -EIO;
+
+	for (i = 0; i < num_regs; ++i) {
+		unsigned int idx = start + i;
+		void *reg;
+
+		switch (idx) {
+		case 15:
+			reg = (void *)&task_pt_regs(target)->pc;
+			break;
+		case 16:
+			reg = (void *)&task_pt_regs(target)->pstate;
+			break;
+		case 17:
+			reg = (void *)&task_pt_regs(target)->orig_x0;
+			break;
+		default:
+			reg = (void *)&task_pt_regs(target)->regs[idx];
+		}
+
+		ret = copy_to_user(ubuf, reg, sizeof(compat_ulong_t));
+
+		if (ret)
+			break;
+		else
+			ubuf += sizeof(compat_ulong_t);
+	}
+
+	return ret;
+}
+
+static int compat_gpr_set(struct task_struct *target,
+			  const struct user_regset *regset,
+			  unsigned int pos, unsigned int count,
+			  const void *kbuf, const void __user *ubuf)
+{
+	struct pt_regs newregs;
+	int ret = 0;
+	unsigned int i, start, num_regs;
+
+	/* Calculate the number of AArch32 registers contained in count */
+	num_regs = count / regset->size;
+
+	/* Convert pos into an register number */
+	start = pos / regset->size;
+
+	if (start + num_regs > regset->n)
+		return -EIO;
+
+	newregs = *task_pt_regs(target);
+
+	for (i = 0; i < num_regs; ++i) {
+		unsigned int idx = start + i;
+		void *reg;
+
+		switch (idx) {
+		case 15:
+			reg = (void *)&newregs.pc;
+			break;
+		case 16:
+			reg = (void *)&newregs.pstate;
+			break;
+		case 17:
+			reg = (void *)&newregs.orig_x0;
+			break;
+		default:
+			reg = (void *)&newregs.regs[idx];
+		}
+
+		ret = copy_from_user(reg, ubuf, sizeof(compat_ulong_t));
+
+		if (ret)
+			goto out;
+		else
+			ubuf += sizeof(compat_ulong_t);
+	}
+
+	if (valid_user_regs(&newregs.user_regs))
+		*task_pt_regs(target) = newregs;
+	else
+		ret = -EINVAL;
+
+out:
+	return ret;
+}
+
+static int compat_vfp_get(struct task_struct *target,
+			  const struct user_regset *regset,
+			  unsigned int pos, unsigned int count,
+			  void *kbuf, void __user *ubuf)
+{
+	struct user_fpsimd_state *uregs;
+	compat_ulong_t fpscr;
+	int ret;
+
+	uregs = &target->thread.fpsimd_state.user_fpsimd;
+
+	/*
+	 * The VFP registers are packed into the fpsimd_state, so they all sit
+	 * nicely together for us. We just need to create the fpscr separately.
+	 */
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf, uregs, 0,
+				  VFP_STATE_SIZE - sizeof(compat_ulong_t));
+
+	if (count && !ret) {
+		fpscr = (uregs->fpsr & VFP_FPSCR_STAT_MASK) |
+			(uregs->fpcr & VFP_FPSCR_CTRL_MASK);
+		ret = put_user(fpscr, (compat_ulong_t *)ubuf);
+	}
+
+	return ret;
+}
+
+static int compat_vfp_set(struct task_struct *target,
+			  const struct user_regset *regset,
+			  unsigned int pos, unsigned int count,
+			  const void *kbuf, const void __user *ubuf)
+{
+	struct user_fpsimd_state *uregs;
+	compat_ulong_t fpscr;
+	int ret;
+
+	if (pos + count > VFP_STATE_SIZE)
+		return -EIO;
+
+	uregs = &target->thread.fpsimd_state.user_fpsimd;
+
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, uregs, 0,
+				 VFP_STATE_SIZE - sizeof(compat_ulong_t));
+
+	if (count && !ret) {
+		ret = get_user(fpscr, (compat_ulong_t *)ubuf);
+		uregs->fpsr = fpscr & VFP_FPSCR_STAT_MASK;
+		uregs->fpcr = fpscr & VFP_FPSCR_CTRL_MASK;
+	}
+
+	return ret;
+}
+
+static const struct user_regset aarch32_regsets[] = {
+	[REGSET_COMPAT_GPR] = {
+		.core_note_type = NT_PRSTATUS,
+		.n = COMPAT_ELF_NGREG,
+		.size = sizeof(compat_elf_greg_t),
+		.align = sizeof(compat_elf_greg_t),
+		.get = compat_gpr_get,
+		.set = compat_gpr_set
+	},
+	[REGSET_COMPAT_VFP] = {
+		.core_note_type = NT_ARM_VFP,
+		.n = VFP_STATE_SIZE / sizeof(compat_ulong_t),
+		.size = sizeof(compat_ulong_t),
+		.align = sizeof(compat_ulong_t),
+		.get = compat_vfp_get,
+		.set = compat_vfp_set
+	},
+};
+
+static const struct user_regset_view user_aarch32_view = {
+	.name = "aarch32", .e_machine = EM_ARM,
+	.regsets = aarch32_regsets, .n = ARRAY_SIZE(aarch32_regsets)
+};
+
+int aarch32_break_trap(struct pt_regs *regs)
+{
+	unsigned int instr;
+	bool bp = false;
+	void __user *pc = (void __user *)instruction_pointer(regs);
+
+	if (compat_thumb_mode(regs)) {
+		/* get 16-bit Thumb instruction */
+		get_user(instr, (u16 __user *)pc);
+		if (instr == AARCH32_BREAK_THUMB2_LO) {
+			/* get second half of 32-bit Thumb-2 instruction */
+			get_user(instr, (u16 __user *)(pc + 2));
+			bp = instr == AARCH32_BREAK_THUMB2_HI;
+		} else {
+			bp = instr == AARCH32_BREAK_THUMB;
+		}
+	} else {
+		/* 32-bit ARM instruction */
+		get_user(instr, (u32 __user *)pc);
+		bp = (instr & ~0xf0000000) == AARCH32_BREAK_ARM;
+	}
+
+	if (bp)
+		return ptrace_break(regs);
+	return 1;
+}
+
+static int compat_ptrace_read_user(struct task_struct *tsk, compat_ulong_t off,
+				   compat_ulong_t __user *ret)
+{
+	compat_ulong_t tmp;
+
+	if (off & 3)
+		return -EIO;
+
+	if (off == PT_TEXT_ADDR)
+		tmp = tsk->mm->start_code;
+	else if (off == PT_DATA_ADDR)
+		tmp = tsk->mm->start_data;
+	else if (off == PT_TEXT_END_ADDR)
+		tmp = tsk->mm->end_code;
+	else if (off < sizeof(compat_elf_gregset_t))
+		return copy_regset_to_user(tsk, &user_aarch32_view,
+					   REGSET_COMPAT_GPR, off,
+					   sizeof(compat_ulong_t), ret);
+	else if (off >= COMPAT_USER_SZ)
+		return -EIO;
+	else
+		tmp = 0;
+
+	return put_user(tmp, ret);
+}
+
+static int compat_ptrace_write_user(struct task_struct *tsk, compat_ulong_t off,
+				    compat_ulong_t val)
+{
+	int ret;
+
+	if (off & 3 || off >= COMPAT_USER_SZ)
+		return -EIO;
+
+	if (off >= sizeof(compat_elf_gregset_t))
+		return 0;
+
+	ret = copy_regset_from_user(tsk, &user_aarch32_view,
+				    REGSET_COMPAT_GPR, off,
+				    sizeof(compat_ulong_t),
+				    &val);
+	return ret;
+}
+
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+
+/*
+ * Convert a virtual register number into an index for a thread_info
+ * breakpoint array. Breakpoints are identified using positive numbers
+ * whilst watchpoints are negative. The registers are laid out as pairs
+ * of (address, control), each pair mapping to a unique hw_breakpoint struct.
+ * Register 0 is reserved for describing resource information.
+ */
+static int compat_ptrace_hbp_num_to_idx(compat_long_t num)
+{
+	return (abs(num) - 1) >> 1;
+}
+
+static int compat_ptrace_hbp_get_resource_info(u32 *kdata)
+{
+	u8 num_brps, num_wrps, debug_arch, wp_len;
+	u32 reg = 0;
+
+	num_brps	= hw_breakpoint_slots(TYPE_INST);
+	num_wrps	= hw_breakpoint_slots(TYPE_DATA);
+
+	debug_arch	= debug_monitors_arch();
+	wp_len		= 8;
+	reg		|= debug_arch;
+	reg		<<= 8;
+	reg		|= wp_len;
+	reg		<<= 8;
+	reg		|= num_wrps;
+	reg		<<= 8;
+	reg		|= num_brps;
+
+	*kdata = reg;
+	return 0;
+}
+
+static int compat_ptrace_hbp_get(unsigned int note_type,
+				 struct task_struct *tsk,
+				 compat_long_t num,
+				 u32 *kdata)
+{
+	u64 addr = 0;
+	u32 ctrl = 0;
+
+	int err, idx = compat_ptrace_hbp_num_to_idx(num);;
+
+	if (num & 1) {
+		err = ptrace_hbp_get_addr(note_type, tsk, idx, &addr);
+		*kdata = (u32)addr;
+	} else {
+		err = ptrace_hbp_get_ctrl(note_type, tsk, idx, &ctrl);
+		*kdata = ctrl;
+	}
+
+	return err;
+}
+
+static int compat_ptrace_hbp_set(unsigned int note_type,
+				 struct task_struct *tsk,
+				 compat_long_t num,
+				 u32 *kdata)
+{
+	u64 addr;
+	u32 ctrl;
+
+	int err, idx = compat_ptrace_hbp_num_to_idx(num);
+
+	if (num & 1) {
+		addr = *kdata;
+		err = ptrace_hbp_set_addr(note_type, tsk, idx, addr);
+	} else {
+		ctrl = *kdata;
+		err = ptrace_hbp_set_ctrl(note_type, tsk, idx, ctrl);
+	}
+
+	return err;
+}
+
+static int compat_ptrace_gethbpregs(struct task_struct *tsk, compat_long_t num,
+				    compat_ulong_t __user *data)
+{
+	int ret;
+	u32 kdata;
+	mm_segment_t old_fs = get_fs();
+
+	set_fs(KERNEL_DS);
+	/* Watchpoint */
+	if (num < 0) {
+		ret = compat_ptrace_hbp_get(NT_ARM_HW_WATCH, tsk, num, &kdata);
+	/* Resource info */
+	} else if (num == 0) {
+		ret = compat_ptrace_hbp_get_resource_info(&kdata);
+	/* Breakpoint */
+	} else {
+		ret = compat_ptrace_hbp_get(NT_ARM_HW_BREAK, tsk, num, &kdata);
+	}
+	set_fs(old_fs);
+
+	if (!ret)
+		ret = put_user(kdata, data);
+
+	return ret;
+}
+
+static int compat_ptrace_sethbpregs(struct task_struct *tsk, compat_long_t num,
+				    compat_ulong_t __user *data)
+{
+	int ret;
+	u32 kdata = 0;
+	mm_segment_t old_fs = get_fs();
+
+	if (num == 0)
+		return 0;
+
+	ret = get_user(kdata, data);
+	if (ret)
+		return ret;
+
+	set_fs(KERNEL_DS);
+	if (num < 0)
+		ret = compat_ptrace_hbp_set(NT_ARM_HW_WATCH, tsk, num, &kdata);
+	else
+		ret = compat_ptrace_hbp_set(NT_ARM_HW_BREAK, tsk, num, &kdata);
+	set_fs(old_fs);
+
+	return ret;
+}
+#endif	/* CONFIG_HAVE_HW_BREAKPOINT */
+
+long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
+			compat_ulong_t caddr, compat_ulong_t cdata)
+{
+	unsigned long addr = caddr;
+	unsigned long data = cdata;
+	void __user *datap = compat_ptr(data);
+	int ret;
+
+	switch (request) {
+		case PTRACE_PEEKUSR:
+			ret = compat_ptrace_read_user(child, addr, datap);
+			break;
+
+		case PTRACE_POKEUSR:
+			ret = compat_ptrace_write_user(child, addr, data);
+			break;
+
+		case PTRACE_GETREGS:
+			ret = copy_regset_to_user(child,
+						  &user_aarch32_view,
+						  REGSET_COMPAT_GPR,
+						  0, sizeof(compat_elf_gregset_t),
+						  datap);
+			break;
+
+		case PTRACE_SETREGS:
+			ret = copy_regset_from_user(child,
+						    &user_aarch32_view,
+						    REGSET_COMPAT_GPR,
+						    0, sizeof(compat_elf_gregset_t),
+						    datap);
+			break;
+
+		case PTRACE_GET_THREAD_AREA:
+			ret = put_user((compat_ulong_t)child->thread.tp_value,
+				       (compat_ulong_t __user *)datap);
+			break;
+
+		case PTRACE_SET_SYSCALL:
+			task_pt_regs(child)->syscallno = data;
+			ret = 0;
+			break;
+
+		case COMPAT_PTRACE_GETVFPREGS:
+			ret = copy_regset_to_user(child,
+						  &user_aarch32_view,
+						  REGSET_COMPAT_VFP,
+						  0, VFP_STATE_SIZE,
+						  datap);
+			break;
+
+		case COMPAT_PTRACE_SETVFPREGS:
+			ret = copy_regset_from_user(child,
+						    &user_aarch32_view,
+						    REGSET_COMPAT_VFP,
+						    0, VFP_STATE_SIZE,
+						    datap);
+			break;
+
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+		case PTRACE_GETHBPREGS:
+			ret = compat_ptrace_gethbpregs(child, addr, datap);
+			break;
+
+		case PTRACE_SETHBPREGS:
+			ret = compat_ptrace_sethbpregs(child, addr, datap);
+			break;
+#endif
+
+		default:
+			ret = compat_ptrace_request(child, request, addr,
+						    data);
+			break;
+	}
+
+	return ret;
+}
+#endif /* CONFIG_COMPAT */
+
+const struct user_regset_view *task_user_regset_view(struct task_struct *task)
+{
+#ifdef CONFIG_COMPAT
+	if (is_compat_thread(task_thread_info(task)))
+		return &user_aarch32_view;
+#endif
+	return &user_aarch64_view;
+}
+
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
+{
+	return ptrace_request(child, request, addr, data);
+}
+
+
+static int __init ptrace_break_init(void)
+{
+	hook_debug_fault_code(DBG_ESR_EVT_BRK, arm64_break_trap, SIGTRAP,
+			      TRAP_BRKPT, "ptrace BRK handler");
+	return 0;
+}
+core_initcall(ptrace_break_init);
+
+
+asmlinkage int syscall_trace(int dir, struct pt_regs *regs)
+{
+	unsigned long saved_reg;
+
+	if (!test_thread_flag(TIF_SYSCALL_TRACE))
+		return regs->syscallno;
+
+	if (is_compat_task()) {
+		/* AArch32 uses ip (r12) for scratch */
+		saved_reg = regs->regs[12];
+		regs->regs[12] = dir;
+	} else {
+		/*
+		 * Save X7. X7 is used to denote syscall entry/exit:
+		 *   X7 = 0 -> entry, = 1 -> exit
+		 */
+		saved_reg = regs->regs[7];
+		regs->regs[7] = dir;
+	}
+
+	if (dir)
+		tracehook_report_syscall_exit(regs, 0);
+	else if (tracehook_report_syscall_entry(regs))
+		regs->syscallno = ~0UL;
+
+	if (is_compat_task())
+		regs->regs[12] = saved_reg;
+	else
+		regs->regs[7] = saved_reg;
+
+	return regs->syscallno;
+}
diff --git a/include/linux/elf.h b/include/linux/elf.h
index 999b4f5..1e935e4 100644
--- a/include/linux/elf.h
+++ b/include/linux/elf.h
@@ -388,6 +388,9 @@ typedef struct elf64_shdr {
 #define NT_S390_LAST_BREAK	0x306	/* s390 breaking event address */
 #define NT_S390_SYSTEM_CALL	0x307	/* s390 system call restart data */
 #define NT_ARM_VFP	0x400		/* ARM VFP/NEON registers */
+#define NT_ARM_TLS	0x401		/* ARM TLS register */
+#define NT_ARM_HW_BREAK	0x402		/* ARM hardware breakpoint registers */
+#define NT_ARM_HW_WATCH	0x403		/* ARM hardware watchpoint registers */
 
 
 /* Note header in a PT_NOTE section */

