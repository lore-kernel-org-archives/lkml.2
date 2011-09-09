Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab1IIBLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 21:11:39 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50881 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171Ab1IIBL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 21:11:27 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6463"; a="116864723"
Message-Id: <20110909010916.709728186@codeaurora.org>
User-Agent: quilt/0.48-1
Date: Thu, 08 Sep 2011 20:09:08 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Linas Vepstas <linas@codeaurora.org>
Subject: [patch v3 21/36] Hexagon: Add SMP support
References: <20110909010847.294039464@codeaurora.org>
Content-Disposition: inline; filename=smp.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed smp.c to use generic IPI handler functions.

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
Signed-off-by: Linas Vepstas <linas@codeaurora.org>

---
 arch/hexagon/include/asm/smp.h |   44 ++++++
 arch/hexagon/kernel/smp.c      |  282 +++++++++++++++++++++++++++++++++++++++++
 arch/hexagon/kernel/topology.c |   52 +++++++
 3 files changed, 378 insertions(+)

Index: linux-hexagon-kernel/arch/hexagon/include/asm/smp.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/smp.h	2011-09-07 13:01:00.480691689 -0500
@@ -0,0 +1,44 @@
+/*
+ * SMP definitions for the Hexagon architecture
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
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
+#ifndef __ASM_SMP_H
+#define __ASM_SMP_H
+
+#include <linux/cpumask.h>
+
+#define raw_smp_processor_id() (current_thread_info()->cpu)
+
+enum ipi_message_type {
+	IPI_NOP = 0,
+	IPI_RESCHEDULE = 1,
+	IPI_CALL_FUNC,
+	IPI_CALL_FUNC_SINGLE,
+	IPI_CPU_STOP,
+	IPI_TIMER,
+};
+
+extern void send_ipi(const struct cpumask *cpumask, enum ipi_message_type msg);
+extern void smp_start_cpus(void);
+extern void arch_send_call_function_single_ipi(int cpu);
+extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
+
+extern void smp_vm_unmask_irq(void *info);
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/kernel/smp.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/kernel/smp.c	2011-09-07 13:01:00.500691719 -0500
@@ -0,0 +1,282 @@
+/*
+ * SMP support for Hexagon
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
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
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/percpu.h>
+#include <linux/sched.h>
+#include <linux/smp.h>
+#include <linux/spinlock.h>
+
+#include <asm/system.h>  /*  xchg  */
+#include <asm/time.h>    /*  timer_interrupt  */
+#include <asm/hexagon_vm.h>
+
+#define BASE_IPI_IRQ 26
+
+/*
+ * cpu_possible_map needs to be filled out prior to setup_per_cpu_areas
+ * (which is prior to any of our smp_prepare_cpu crap), in order to set
+ * up the...  per_cpu areas.
+ */
+
+struct ipi_data {
+	spinlock_t lock;
+	unsigned long ipi_count;
+	unsigned long bits;
+};
+
+static DEFINE_PER_CPU(struct ipi_data, ipi_data) = {
+	.lock = __SPIN_LOCK_UNLOCKED(ipi_data.lock)
+};
+
+static inline void __handle_ipi(unsigned long *ops, struct ipi_data *ipi,
+				int cpu)
+{
+	do {
+		unsigned long msg = ffz(~*ops);
+
+		*ops &= ~(1 << msg);
+
+		switch (msg) {
+		case IPI_TIMER:
+			ipi_timer();
+			break;
+
+		case IPI_CALL_FUNC:
+			generic_smp_call_function_interrupt();
+			break;
+
+		case IPI_CALL_FUNC_SINGLE:
+			generic_smp_call_function_single_interrupt();
+			break;
+
+		case IPI_CPU_STOP:
+			/*
+			 * call vmstop()
+			 */
+			__vmstop();
+			break;
+
+		case IPI_RESCHEDULE:
+			/*
+			 * need to revisit our exit path; see comments for
+			 * scheduler_ipi()
+			 */
+			scheduler_ipi();
+			break;
+		}
+	} while (*ops);
+}
+
+/*  Used for IPI call from other CPU's to unmask int  */
+void smp_vm_unmask_irq(void *info)
+{
+	__vmintop_locen((long) info);
+}
+
+
+/*
+ * This is based on Alpha's IPI stuff.
+ * Supposed to take (int, void*) as args now.
+ * Specifically, first arg is irq, second is the irq_desc.
+ */
+
+irqreturn_t handle_ipi(int irq, void *desc)
+{
+	int cpu = smp_processor_id();
+	struct ipi_data *ipi = &per_cpu(ipi_data, cpu);
+	unsigned long ops;
+
+	while ((ops = xchg(&ipi->bits, 0)) != 0)
+		__handle_ipi(&ops, ipi, cpu);
+	return IRQ_HANDLED;
+}
+
+void send_ipi(const struct cpumask *cpumask, enum ipi_message_type msg)
+{
+	unsigned long flags;
+	unsigned long cpu;
+	unsigned long retval;
+
+	local_irq_save(flags);
+
+	for_each_cpu(cpu, cpumask) {
+		struct ipi_data *ipi = &per_cpu(ipi_data, cpu);
+
+		spin_lock(&ipi->lock);
+		ipi->bits |= 1 << msg;  /*  one bit per message  */
+		spin_unlock(&ipi->lock);
+
+		retval = __vmintop_post(BASE_IPI_IRQ+cpu);
+		if (retval != 0) {
+			printk(KERN_ERR "interrupt %ld not configured?\n",
+				BASE_IPI_IRQ+cpu);
+		}
+	}
+
+	local_irq_restore(flags);
+}
+
+static struct irqaction ipi_intdesc = {
+	.handler = handle_ipi,
+	.flags = IRQF_DISABLED | IRQF_TRIGGER_RISING,
+	.name = "ipi_handler"
+};
+
+void __init smp_prepare_boot_cpu(void)
+{
+}
+
+/*
+ * interrupts should already be disabled from the VM
+ * SP should already be correct; need to set THREADINFO_REG
+ * to point to current thread info
+ */
+
+void __cpuinit start_secondary(void)
+{
+	unsigned int cpu;
+	unsigned long thread_ptr;
+
+	/*  Calculate thread_info pointer from stack pointer  */
+	__asm__ __volatile__(
+		"%0 = SP;\n"
+		: "=r" (thread_ptr)
+	);
+
+	thread_ptr = thread_ptr & ~(THREAD_SIZE-1);
+
+	__asm__ __volatile__(
+		QUOTED_THREADINFO_REG " = %0;\n"
+		:
+		: "r" (thread_ptr)
+	);
+
+	/*  Set the memory struct  */
+	atomic_inc(&init_mm.mm_count);
+	current->active_mm = &init_mm;
+
+	cpu = smp_processor_id();
+
+	setup_irq(BASE_IPI_IRQ + cpu, &ipi_intdesc);
+
+	/*  Register the clock_event dummy  */
+	setup_percpu_clockdev();
+
+	printk(KERN_INFO "%s cpu %d\n", __func__, current_thread_info()->cpu);
+
+	local_irq_enable();
+	set_cpu_online(cpu, true);
+	cpu_idle();
+}
+
+
+/*
+ * called once for each present cpu
+ * apparently starts up the CPU and then
+ * maintains control until "cpu_online(cpu)" is set.
+ */
+
+int __cpuinit __cpu_up(unsigned int cpu)
+{
+	struct task_struct *idle;
+	struct thread_info *thread;
+	void *stack_start;
+
+	/*  Create new init task for the CPU  */
+	idle = fork_idle(cpu);
+	if (IS_ERR(idle))
+		panic(KERN_ERR "fork_idle failed\n");
+
+	thread = (struct thread_info *)idle->stack;
+	thread->cpu = cpu;
+
+	/*  Boot to the head.  */
+	stack_start =  ((void *) thread) + THREAD_SIZE;
+	__vmstart(start_secondary, stack_start);
+
+	while (!cpu_isset(cpu, cpu_online_map))
+		barrier();
+
+	return 0;
+}
+
+void __init smp_cpus_done(unsigned int max_cpus)
+{
+}
+
+void __init smp_prepare_cpus(unsigned int max_cpus)
+{
+	int i;
+
+	/*
+	 * should eventually have some sort of machine
+	 * descriptor that has this stuff
+	 */
+
+	/*  Right now, let's just fake it. */
+	for (i = 0; i < max_cpus; i++)
+		cpu_set(i, cpu_present_map);
+
+	/*  Also need to register the interrupts for IPI  */
+	if (max_cpus > 1)
+		setup_irq(BASE_IPI_IRQ, &ipi_intdesc);
+}
+
+void smp_send_reschedule(int cpu)
+{
+	send_ipi(cpumask_of(cpu), IPI_RESCHEDULE);
+}
+
+void smp_send_stop(void)
+{
+	struct cpumask targets;
+	cpumask_copy(&targets, cpu_online_mask);
+	cpumask_clear_cpu(smp_processor_id(), &targets);
+	send_ipi(&targets, IPI_CPU_STOP);
+}
+
+void arch_send_call_function_single_ipi(int cpu)
+{
+	send_ipi(cpumask_of(cpu), IPI_CALL_FUNC_SINGLE);
+}
+
+void arch_send_call_function_ipi_mask(const struct cpumask *mask)
+{
+	send_ipi(mask, IPI_CALL_FUNC);
+}
+
+int setup_profiling_timer(unsigned int multiplier)
+{
+	return -EINVAL;
+}
+
+void smp_start_cpus(void)
+{
+	int i;
+
+	for (i = 0; i < NR_CPUS; i++)
+		cpu_set(i, cpu_possible_map);
+}
Index: linux-hexagon-kernel/arch/hexagon/kernel/topology.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/kernel/topology.c	2011-09-03 20:14:59.704981335 -0500
@@ -0,0 +1,52 @@
+/*
+ * CPU topology for Hexagon
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
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
+#include <linux/cpu.h>
+#include <linux/cpumask.h>
+#include <linux/init.h>
+#include <linux/node.h>
+#include <linux/nodemask.h>
+#include <linux/percpu.h>
+
+/*  Swiped from MIPS.  */
+
+static DEFINE_PER_CPU(struct cpu, cpu_devices);
+
+static int __init topology_init(void)
+{
+	int i, ret;
+
+	for_each_present_cpu(i) {
+
+		/*
+		 * register_cpu takes a per_cpu pointer and
+		 * just points it at another per_cpu struct...
+		 */
+
+		ret = register_cpu(&per_cpu(cpu_devices, i), i);
+		if (ret)
+			printk(KERN_WARNING "topology_init: register_cpu %d "
+			       "failed (%d)\n", i, ret);
+	}
+
+	return 0;
+}
+
+subsys_initcall(topology_init);

--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

