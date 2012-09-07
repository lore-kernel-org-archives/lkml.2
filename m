Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab2IGQdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:33:38 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34462 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab2IGQ1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:27:55 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 15/31] arm64: SMP support
Date: Fri,  7 Sep 2012 17:26:50 +0100
Message-Id: <1347035226-18649-16-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 07 Sep 2012 16:27:53.0269 (UTC) FILETIME=[BAE01650:01CD8D15]
X-MC-Unique: 112090717275307501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q87GXmuU008431

This patch adds SMP initialisation and spinlocks implementation for
AArch64. The spinlock support uses the new load-acquire/store-release
instructions to avoid explicit barriers. The architecture also specifies
that an event is automatically generated when clearing the exclusive
monitor state to wake up processors in WFE, so there is no need for an
explicit DSB/SEV instruction sequence. The SEVL instruction is used to
set the exclusive monitor locally as there is no conditional WFE and a
branch is more expensive.

For the SMP booting protocol, see Documentation/arm64/booting.txt.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm64/include/asm/hardirq.h        |    5 +
 arch/arm64/include/asm/smp.h            |   69 +++++
 arch/arm64/include/asm/spinlock.h       |  202 +++++++++++++
 arch/arm64/include/asm/spinlock_types.h |   38 +++
 arch/arm64/kernel/smp.c                 |  469 +++++++++++++++++++++++++++++++
 5 files changed, 783 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm64/include/asm/smp.h
 create mode 100644 arch/arm64/include/asm/spinlock.h
 create mode 100644 arch/arm64/include/asm/spinlock_types.h
 create mode 100644 arch/arm64/kernel/smp.c

diff --git a/arch/arm64/include/asm/hardirq.h b/arch/arm64/include/asm/hardirq.h
index c6c9514..5075463 100644
--- a/arch/arm64/include/asm/hardirq.h
+++ b/arch/arm64/include/asm/hardirq.h
@@ -20,8 +20,13 @@
 #include <linux/threads.h>
 #include <asm/irq.h>
 
+#define NR_IPI	4
+
 typedef struct {
 	unsigned int __softirq_pending;
+#ifdef CONFIG_SMP
+	unsigned int ipi_irqs[NR_IPI];
+#endif
 } ____cacheline_aligned irq_cpustat_t;
 
 #include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
diff --git a/arch/arm64/include/asm/smp.h b/arch/arm64/include/asm/smp.h
new file mode 100644
index 0000000..7e34295
--- /dev/null
+++ b/arch/arm64/include/asm/smp.h
@@ -0,0 +1,69 @@
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
+#ifndef __ASM_SMP_H
+#define __ASM_SMP_H
+
+#include <linux/threads.h>
+#include <linux/cpumask.h>
+#include <linux/thread_info.h>
+
+#ifndef CONFIG_SMP
+# error "<asm/smp.h> included in non-SMP build"
+#endif
+
+#define raw_smp_processor_id() (current_thread_info()->cpu)
+
+struct seq_file;
+
+/*
+ * generate IPI list text
+ */
+extern void show_ipi_list(struct seq_file *p, int prec);
+
+/*
+ * Called from C code, this handles an IPI.
+ */
+extern void handle_IPI(int ipinr, struct pt_regs *regs);
+
+/*
+ * Setup the set of possible CPUs (via set_cpu_possible)
+ */
+extern void smp_init_cpus(void);
+
+/*
+ * Provide a function to raise an IPI cross call on CPUs in callmap.
+ */
+extern void set_smp_cross_call(void (*)(const struct cpumask *, unsigned int));
+
+/*
+ * Called from the secondary holding pen, this is the secondary CPU entry point.
+ */
+asmlinkage void secondary_start_kernel(void);
+
+/*
+ * Initial data for bringing up a secondary CPU.
+ */
+struct secondary_data {
+	void *stack;
+};
+extern struct secondary_data secondary_data;
+extern void secondary_holding_pen(void);
+extern volatile unsigned long secondary_holding_pen_release;
+
+extern void arch_send_call_function_single_ipi(int cpu);
+extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
+
+#endif /* ifndef __ASM_SMP_H */
diff --git a/arch/arm64/include/asm/spinlock.h b/arch/arm64/include/asm/spinlock.h
new file mode 100644
index 0000000..41112fe
--- /dev/null
+++ b/arch/arm64/include/asm/spinlock.h
@@ -0,0 +1,202 @@
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
+#ifndef __ASM_SPINLOCK_H
+#define __ASM_SPINLOCK_H
+
+#include <asm/spinlock_types.h>
+#include <asm/processor.h>
+
+/*
+ * Spinlock implementation.
+ *
+ * The old value is read exclusively and the new one, if unlocked, is written
+ * exclusively. In case of failure, the loop is restarted.
+ *
+ * The memory barriers are implicit with the load-acquire and store-release
+ * instructions.
+ *
+ * Unlocked value: 0
+ * Locked value: 1
+ */
+
+#define arch_spin_is_locked(x)		((x)->lock != 0)
+#define arch_spin_unlock_wait(lock) \
+	do { while (arch_spin_is_locked(lock)) cpu_relax(); } while (0)
+
+#define arch_spin_lock_flags(lock, flags) arch_spin_lock(lock)
+
+static inline void arch_spin_lock(arch_spinlock_t *lock)
+{
+	unsigned int tmp;
+
+	asm volatile(
+	"	sevl\n"
+	"1:	wfe\n"
+	"2:	ldaxr	%w0, [%1]\n"
+	"	cbnz	%w0, 1b\n"
+	"	stxr	%w0, %w2, [%1]\n"
+	"	cbnz	%w0, 2b\n"
+	: "=&r" (tmp)
+	: "r" (&lock->lock), "r" (1)
+	: "memory");
+}
+
+static inline int arch_spin_trylock(arch_spinlock_t *lock)
+{
+	unsigned int tmp;
+
+	asm volatile(
+	"	ldaxr	%w0, [%1]\n"
+	"	cbnz	%w0, 1f\n"
+	"	stxr	%w0, %w2, [%1]\n"
+	"1:\n"
+	: "=&r" (tmp)
+	: "r" (&lock->lock), "r" (1)
+	: "memory");
+
+	return !tmp;
+}
+
+static inline void arch_spin_unlock(arch_spinlock_t *lock)
+{
+	asm volatile(
+	"	stlr	%w1, [%0]\n"
+	: : "r" (&lock->lock), "r" (0) : "memory");
+}
+
+/*
+ * Write lock implementation.
+ *
+ * Write locks set bit 31. Unlocking, is done by writing 0 since the lock is
+ * exclusively held.
+ *
+ * The memory barriers are implicit with the load-acquire and store-release
+ * instructions.
+ */
+
+static inline void arch_write_lock(arch_rwlock_t *rw)
+{
+	unsigned int tmp;
+
+	asm volatile(
+	"	sevl\n"
+	"1:	wfe\n"
+	"2:	ldaxr	%w0, [%1]\n"
+	"	cbnz	%w0, 1b\n"
+	"	stxr	%w0, %w2, [%1]\n"
+	"	cbnz	%w0, 2b\n"
+	: "=&r" (tmp)
+	: "r" (&rw->lock), "r" (0x80000000)
+	: "memory");
+}
+
+static inline int arch_write_trylock(arch_rwlock_t *rw)
+{
+	unsigned int tmp;
+
+	asm volatile(
+	"	ldaxr	%w0, [%1]\n"
+	"	cbnz	%w0, 1f\n"
+	"	stxr	%w0, %w2, [%1]\n"
+	"1:\n"
+	: "=&r" (tmp)
+	: "r" (&rw->lock), "r" (0x80000000)
+	: "memory");
+
+	return !tmp;
+}
+
+static inline void arch_write_unlock(arch_rwlock_t *rw)
+{
+	asm volatile(
+	"	stlr	%w1, [%0]\n"
+	: : "r" (&rw->lock), "r" (0) : "memory");
+}
+
+/* write_can_lock - would write_trylock() succeed? */
+#define arch_write_can_lock(x)		((x)->lock == 0)
+
+/*
+ * Read lock implementation.
+ *
+ * It exclusively loads the lock value, increments it and stores the new value
+ * back if positive and the CPU still exclusively owns the location. If the
+ * value is negative, the lock is already held.
+ *
+ * During unlocking there may be multiple active read locks but no write lock.
+ *
+ * The memory barriers are implicit with the load-acquire and store-release
+ * instructions.
+ */
+static inline void arch_read_lock(arch_rwlock_t *rw)
+{
+	unsigned int tmp, tmp2;
+
+	asm volatile(
+	"	sevl\n"
+	"1:	wfe\n"
+	"2:	ldaxr	%w0, [%2]\n"
+	"	add	%w0, %w0, #1\n"
+	"	tbnz	%w0, #31, 1b\n"
+	"	stxr	%w1, %w0, [%2]\n"
+	"	cbnz	%w1, 2b\n"
+	: "=&r" (tmp), "=&r" (tmp2)
+	: "r" (&rw->lock)
+	: "memory");
+}
+
+static inline void arch_read_unlock(arch_rwlock_t *rw)
+{
+	unsigned int tmp, tmp2;
+
+	asm volatile(
+	"1:	ldxr	%w0, [%2]\n"
+	"	sub	%w0, %w0, #1\n"
+	"	stlxr	%w1, %w0, [%2]\n"
+	"	cbnz	%w1, 1b\n"
+	: "=&r" (tmp), "=&r" (tmp2)
+	: "r" (&rw->lock)
+	: "memory");
+}
+
+static inline int arch_read_trylock(arch_rwlock_t *rw)
+{
+	unsigned int tmp, tmp2 = 1;
+
+	asm volatile(
+	"	ldaxr	%w0, [%2]\n"
+	"	add	%w0, %w0, #1\n"
+	"	tbnz	%w0, #31, 1f\n"
+	"	stxr	%w1, %w0, [%2]\n"
+	"1:\n"
+	: "=&r" (tmp), "+r" (tmp2)
+	: "r" (&rw->lock)
+	: "memory");
+
+	return !tmp2;
+}
+
+/* read_can_lock - would read_trylock() succeed? */
+#define arch_read_can_lock(x)		((x)->lock < 0x80000000)
+
+#define arch_read_lock_flags(lock, flags) arch_read_lock(lock)
+#define arch_write_lock_flags(lock, flags) arch_write_lock(lock)
+
+#define arch_spin_relax(lock)	cpu_relax()
+#define arch_read_relax(lock)	cpu_relax()
+#define arch_write_relax(lock)	cpu_relax()
+
+#endif /* __ASM_SPINLOCK_H */
diff --git a/arch/arm64/include/asm/spinlock_types.h b/arch/arm64/include/asm/spinlock_types.h
new file mode 100644
index 0000000..9a49434
--- /dev/null
+++ b/arch/arm64/include/asm/spinlock_types.h
@@ -0,0 +1,38 @@
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
+#ifndef __ASM_SPINLOCK_TYPES_H
+#define __ASM_SPINLOCK_TYPES_H
+
+#if !defined(__LINUX_SPINLOCK_TYPES_H) && !defined(__ASM_SPINLOCK_H)
+# error "please don't include this file directly"
+#endif
+
+/* We only require natural alignment for exclusive accesses. */
+#define __lock_aligned
+
+typedef struct {
+	volatile unsigned int lock;
+} arch_spinlock_t;
+
+#define __ARCH_SPIN_LOCK_UNLOCKED	{ 0 }
+
+typedef struct {
+	volatile unsigned int lock;
+} arch_rwlock_t;
+
+#define __ARCH_RW_LOCK_UNLOCKED		{ 0 }
+
+#endif
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
new file mode 100644
index 0000000..b711525
--- /dev/null
+++ b/arch/arm64/kernel/smp.c
@@ -0,0 +1,469 @@
+/*
+ * SMP initialisation and IPI support
+ * Based on arch/arm/kernel/smp.c
+ *
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
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/spinlock.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/cache.h>
+#include <linux/profile.h>
+#include <linux/errno.h>
+#include <linux/mm.h>
+#include <linux/err.h>
+#include <linux/cpu.h>
+#include <linux/smp.h>
+#include <linux/seq_file.h>
+#include <linux/irq.h>
+#include <linux/percpu.h>
+#include <linux/clockchips.h>
+#include <linux/completion.h>
+#include <linux/of.h>
+
+#include <asm/atomic.h>
+#include <asm/cacheflush.h>
+#include <asm/cputype.h>
+#include <asm/mmu_context.h>
+#include <asm/pgtable.h>
+#include <asm/pgalloc.h>
+#include <asm/processor.h>
+#include <asm/sections.h>
+#include <asm/tlbflush.h>
+#include <asm/ptrace.h>
+#include <asm/mmu_context.h>
+
+/*
+ * as from 2.5, kernels no longer have an init_tasks structure
+ * so we need some other way of telling a new secondary core
+ * where to place its SVC stack
+ */
+struct secondary_data secondary_data;
+volatile unsigned long secondary_holding_pen_release = -1;
+
+enum ipi_msg_type {
+	IPI_RESCHEDULE,
+	IPI_CALL_FUNC,
+	IPI_CALL_FUNC_SINGLE,
+	IPI_CPU_STOP,
+};
+
+static DEFINE_RAW_SPINLOCK(boot_lock);
+
+/*
+ * Write secondary_holding_pen_release in a way that is guaranteed to be
+ * visible to all observers, irrespective of whether they're taking part
+ * in coherency or not.  This is necessary for the hotplug code to work
+ * reliably.
+ */
+static void __cpuinit write_pen_release(int val)
+{
+	void *start = (void *)&secondary_holding_pen_release;
+	unsigned long size = sizeof(secondary_holding_pen_release);
+
+	secondary_holding_pen_release = val;
+	__flush_dcache_area(start, size);
+}
+
+/*
+ * Boot a secondary CPU, and assign it the specified idle task.
+ * This also gives us the initial stack to use for this CPU.
+ */
+static int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
+{
+	unsigned long timeout;
+
+	/*
+	 * Set synchronisation state between this boot processor
+	 * and the secondary one
+	 */
+	raw_spin_lock(&boot_lock);
+
+	/*
+	 * Update the pen release flag.
+	 */
+	write_pen_release(cpu);
+
+	/*
+	 * Send an event, causing the secondaries to read pen_release.
+	 */
+	sev();
+
+	timeout = jiffies + (1 * HZ);
+	while (time_before(jiffies, timeout)) {
+		if (secondary_holding_pen_release == -1UL)
+			break;
+		udelay(10);
+	}
+
+	/*
+	 * Now the secondary core is starting up let it run its
+	 * calibrations, then wait for it to finish
+	 */
+	raw_spin_unlock(&boot_lock);
+
+	return secondary_holding_pen_release != -1 ? -ENOSYS : 0;
+}
+
+static DECLARE_COMPLETION(cpu_running);
+
+int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *idle)
+{
+	int ret;
+
+	/*
+	 * We need to tell the secondary core where to find its stack and the
+	 * page tables.
+	 */
+	secondary_data.stack = task_stack_page(idle) + THREAD_START_SP;
+	__flush_dcache_area(&secondary_data, sizeof(secondary_data));
+
+	/*
+	 * Now bring the CPU into our world.
+	 */
+	ret = boot_secondary(cpu, idle);
+	if (ret == 0) {
+		/*
+		 * CPU was successfully started, wait for it to come online or
+		 * time out.
+		 */
+		wait_for_completion_timeout(&cpu_running,
+					    msecs_to_jiffies(1000));
+
+		if (!cpu_online(cpu)) {
+			pr_crit("CPU%u: failed to come online\n", cpu);
+			ret = -EIO;
+		}
+	} else {
+		pr_err("CPU%u: failed to boot: %d\n", cpu, ret);
+	}
+
+	secondary_data.stack = NULL;
+
+	return ret;
+}
+
+/*
+ * This is the secondary CPU boot entry.  We're using this CPUs
+ * idle thread stack, but a set of temporary page tables.
+ */
+asmlinkage void __cpuinit secondary_start_kernel(void)
+{
+	struct mm_struct *mm = &init_mm;
+	unsigned int cpu = smp_processor_id();
+
+	printk("CPU%u: Booted secondary processor\n", cpu);
+
+	/*
+	 * All kernel threads share the same mm context; grab a
+	 * reference and switch to it.
+	 */
+	atomic_inc(&mm->mm_count);
+	current->active_mm = mm;
+	cpumask_set_cpu(cpu, mm_cpumask(mm));
+
+	/*
+	 * TTBR0 is only used for the identity mapping at this stage. Make it
+	 * point to zero page to avoid speculatively fetching new entries.
+	 */
+	cpu_set_reserved_ttbr0();
+	flush_tlb_all();
+
+	preempt_disable();
+	trace_hardirqs_off();
+
+	/*
+	 * Let the primary processor know we're out of the
+	 * pen, then head off into the C entry point
+	 */
+	write_pen_release(-1);
+
+	/*
+	 * Synchronise with the boot thread.
+	 */
+	raw_spin_lock(&boot_lock);
+	raw_spin_unlock(&boot_lock);
+
+	/*
+	 * Enable local interrupts.
+	 */
+	notify_cpu_starting(cpu);
+	local_irq_enable();
+	local_fiq_enable();
+
+	/*
+	 * OK, now it's safe to let the boot CPU continue.  Wait for
+	 * the CPU migration code to notice that the CPU is online
+	 * before we continue.
+	 */
+	set_cpu_online(cpu, true);
+	while (!cpu_active(cpu))
+		cpu_relax();
+
+	/*
+	 * OK, it's off to the idle thread for us
+	 */
+	cpu_idle();
+}
+
+void __init smp_cpus_done(unsigned int max_cpus)
+{
+	unsigned long bogosum = loops_per_jiffy * num_online_cpus();
+
+	pr_info("SMP: Total of %d processors activated (%lu.%02lu BogoMIPS).\n",
+		num_online_cpus(), bogosum / (500000/HZ),
+		(bogosum / (5000/HZ)) % 100);
+}
+
+void __init smp_prepare_boot_cpu(void)
+{
+}
+
+static void (*smp_cross_call)(const struct cpumask *, unsigned int);
+static phys_addr_t cpu_release_addr[NR_CPUS];
+
+/*
+ * Enumerate the possible CPU set from the device tree.
+ */
+void __init smp_init_cpus(void)
+{
+	const char *enable_method;
+	struct device_node *dn = NULL;
+	int cpu = 0;
+
+	while ((dn = of_find_node_by_type(dn, "cpu"))) {
+		if (cpu >= NR_CPUS)
+			goto next;
+
+		/*
+		 * We currently support only the "spin-table" enable-method.
+		 */
+		enable_method = of_get_property(dn, "enable-method", NULL);
+		if (!enable_method || strcmp(enable_method, "spin-table")) {
+			pr_err("CPU %d: missing or invalid enable-method property: %s\n",
+			       cpu, enable_method);
+			goto next;
+		}
+
+		/*
+		 * Determine the address from which the CPU is polling.
+		 */
+		if (of_property_read_u64(dn, "cpu-release-addr",
+					 &cpu_release_addr[cpu])) {
+			pr_err("CPU %d: missing or invalid cpu-release-addr property\n",
+			       cpu);
+			goto next;
+		}
+
+		set_cpu_possible(cpu, true);
+next:
+		cpu++;
+	}
+
+	/* sanity check */
+	if (cpu > NR_CPUS)
+		pr_warning("no. of cores (%d) greater than configured maximum of %d - clipping\n",
+			   cpu, NR_CPUS);
+}
+
+void __init smp_prepare_cpus(unsigned int max_cpus)
+{
+	int cpu;
+	void **release_addr;
+	unsigned int ncores = num_possible_cpus();
+
+	/*
+	 * are we trying to boot more cores than exist?
+	 */
+	if (max_cpus > ncores)
+		max_cpus = ncores;
+
+	/*
+	 * Initialise the present map (which describes the set of CPUs
+	 * actually populated at the present time) and release the
+	 * secondaries from the bootloader.
+	 */
+	for_each_possible_cpu(cpu) {
+		if (max_cpus == 0)
+			break;
+
+		if (!cpu_release_addr[cpu])
+			continue;
+
+		release_addr = __va(cpu_release_addr[cpu]);
+		release_addr[0] = (void *)__pa(secondary_holding_pen);
+		__flush_dcache_area(release_addr, sizeof(release_addr[0]));
+
+		set_cpu_present(cpu, true);
+		max_cpus--;
+	}
+
+	/*
+	 * Send an event to wake up the secondaries.
+	 */
+	sev();
+}
+
+
+void __init set_smp_cross_call(void (*fn)(const struct cpumask *, unsigned int))
+{
+	smp_cross_call = fn;
+}
+
+void arch_send_call_function_ipi_mask(const struct cpumask *mask)
+{
+	smp_cross_call(mask, IPI_CALL_FUNC);
+}
+
+void arch_send_call_function_single_ipi(int cpu)
+{
+	smp_cross_call(cpumask_of(cpu), IPI_CALL_FUNC_SINGLE);
+}
+
+static const char *ipi_types[NR_IPI] = {
+#define S(x,s)	[x - IPI_RESCHEDULE] = s
+	S(IPI_RESCHEDULE, "Rescheduling interrupts"),
+	S(IPI_CALL_FUNC, "Function call interrupts"),
+	S(IPI_CALL_FUNC_SINGLE, "Single function call interrupts"),
+	S(IPI_CPU_STOP, "CPU stop interrupts"),
+};
+
+void show_ipi_list(struct seq_file *p, int prec)
+{
+	unsigned int cpu, i;
+
+	for (i = 0; i < NR_IPI; i++) {
+		seq_printf(p, "%*s%u:%s", prec - 1, "IPI", i + IPI_RESCHEDULE,
+			   prec >= 4 ? " " : "");
+		for_each_present_cpu(cpu)
+			seq_printf(p, "%10u ",
+				   __get_irq_stat(cpu, ipi_irqs[i]));
+		seq_printf(p, "      %s\n", ipi_types[i]);
+	}
+}
+
+u64 smp_irq_stat_cpu(unsigned int cpu)
+{
+	u64 sum = 0;
+	int i;
+
+	for (i = 0; i < NR_IPI; i++)
+		sum += __get_irq_stat(cpu, ipi_irqs[i]);
+
+	return sum;
+}
+
+static DEFINE_RAW_SPINLOCK(stop_lock);
+
+/*
+ * ipi_cpu_stop - handle IPI from smp_send_stop()
+ */
+static void ipi_cpu_stop(unsigned int cpu)
+{
+	if (system_state == SYSTEM_BOOTING ||
+	    system_state == SYSTEM_RUNNING) {
+		raw_spin_lock(&stop_lock);
+		pr_crit("CPU%u: stopping\n", cpu);
+		dump_stack();
+		raw_spin_unlock(&stop_lock);
+	}
+
+	set_cpu_online(cpu, false);
+
+	local_fiq_disable();
+	local_irq_disable();
+
+	while (1)
+		cpu_relax();
+}
+
+/*
+ * Main handler for inter-processor interrupts
+ */
+void handle_IPI(int ipinr, struct pt_regs *regs)
+{
+	unsigned int cpu = smp_processor_id();
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	if (ipinr >= IPI_RESCHEDULE && ipinr < IPI_RESCHEDULE + NR_IPI)
+		__inc_irq_stat(cpu, ipi_irqs[ipinr - IPI_RESCHEDULE]);
+
+	switch (ipinr) {
+	case IPI_RESCHEDULE:
+		scheduler_ipi();
+		break;
+
+	case IPI_CALL_FUNC:
+		irq_enter();
+		generic_smp_call_function_interrupt();
+		irq_exit();
+		break;
+
+	case IPI_CALL_FUNC_SINGLE:
+		irq_enter();
+		generic_smp_call_function_single_interrupt();
+		irq_exit();
+		break;
+
+	case IPI_CPU_STOP:
+		irq_enter();
+		ipi_cpu_stop(cpu);
+		irq_exit();
+		break;
+
+	default:
+		pr_crit("CPU%u: Unknown IPI message 0x%x\n", cpu, ipinr);
+		break;
+	}
+	set_irq_regs(old_regs);
+}
+
+void smp_send_reschedule(int cpu)
+{
+	smp_cross_call(cpumask_of(cpu), IPI_RESCHEDULE);
+}
+
+void smp_send_stop(void)
+{
+	unsigned long timeout;
+
+	if (num_online_cpus() > 1) {
+		cpumask_t mask;
+
+		cpumask_copy(&mask, cpu_online_mask);
+		cpu_clear(smp_processor_id(), mask);
+
+		smp_cross_call(&mask, IPI_CPU_STOP);
+	}
+
+	/* Wait up to one second for other CPUs to stop */
+	timeout = USEC_PER_SEC;
+	while (num_online_cpus() > 1 && timeout--)
+		udelay(1);
+
+	if (num_online_cpus() > 1)
+		pr_warning("SMP: failed to stop secondary CPUs\n");
+}
+
+/*
+ * not supported here
+ */
+int setup_profiling_timer(unsigned int multiplier)
+{
+	return -EINVAL;
+}

