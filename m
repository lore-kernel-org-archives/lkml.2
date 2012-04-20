Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab2DTNHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 09:07:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:44819 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab2DTNGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 09:06:01 -0400
Message-Id: <20120420124557.102478630@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 20 Apr 2012 13:05:45 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Matt Turner <mattst88@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Richard Kuo <rkuo@codeaurora.org>, Tony Luck <tony.luck@intel.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        David Howells <dhowells@redhat.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Richard Weinberger <richard@nod.at>, x86@kernel.org
Subject: [patch 04/18] smp: Provide generic idle thread allocation
References: <20120420122120.097464672@linutronix.de>
Content-Disposition: inline;
 filename=smp-provide-generic-idle-thread-allocation.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All SMP architectures have magic to fork the idle task and to store it
for reusage when cpu hotplug is enabled. Provide a generic
infrastructure for it.

Create/reinit the idle thread for the cpu which is brought up in the
generic code and hand the thread pointer to the architecture code via
__cpu_up().

Note, that fork_idle() is called via a workqueue, because this
guarantees that the idle thread does not get a reference to a user
space VM. This can happen when the boot process did not bring up all
possible cpus and a later cpu_up() is initiated via the sysfs
interface. In that case fork_idle() would be called in the context of
the user space task and take a reference on the user space VM.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Howells <dhowells@redhat.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: x86@kernel.org
---
 arch/Kconfig        |    3 +
 kernel/cpu.c        |    2 -
 kernel/sched/core.c |    2 +
 kernel/smpboot.c    |   83 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/smpboot.h    |   10 ++++++
 5 files changed, 99 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/Kconfig
===================================================================
--- linux-2.6.orig/arch/Kconfig
+++ linux-2.6/arch/Kconfig
@@ -145,6 +145,9 @@ config HAVE_DMA_ATTRS
 config USE_GENERIC_SMP_HELPERS
 	bool
 
+config GENERIC_SMP_IDLE_THREAD
+       bool
+
 config HAVE_REGS_AND_STACK_ACCESS_API
 	bool
 	help
Index: linux-2.6/kernel/cpu.c
===================================================================
--- linux-2.6.orig/kernel/cpu.c
+++ linux-2.6/kernel/cpu.c
@@ -316,7 +316,7 @@ static int __cpuinit _cpu_up(unsigned in
 	}
 
 	/* Arch-specific enabling code. */
-	ret = __cpu_up(cpu, NULL);
+	ret = __cpu_up(cpu, idle_thread_get(cpu));
 	if (ret != 0)
 		goto out_notify;
 	BUG_ON(!cpu_online(cpu));
Index: linux-2.6/kernel/sched/core.c
===================================================================
--- linux-2.6.orig/kernel/sched/core.c
+++ linux-2.6/kernel/sched/core.c
@@ -83,6 +83,7 @@
 
 #include "sched.h"
 #include "../workqueue_sched.h"
+#include "../smpboot.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/sched.h>
@@ -7049,6 +7050,7 @@ void __init sched_init(void)
 	/* May be allocated at isolcpus cmdline parse time */
 	if (cpu_isolated_map == NULL)
 		zalloc_cpumask_var(&cpu_isolated_map, GFP_NOWAIT);
+	idle_thread_set_boot_cpu();
 #endif
 	init_sched_fair_class();
 
Index: linux-2.6/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/kernel/smpboot.c
+++ linux-2.6/kernel/smpboot.c
@@ -1,12 +1,95 @@
 /*
  * Common SMP CPU bringup/teardown functions
  */
+#include <linux/err.h>
+#include <linux/smp.h>
+#include <linux/sched.h>
+#include <linux/percpu.h>
+#include <linux/workqueue.h>
 
 #include "smpboot.h"
 
+#ifdef CONFIG_GENERIC_SMP_IDLE_THREAD
+struct create_idle {
+	struct work_struct	work;
+	struct task_struct	*idle;
+	struct completion	done;
+	unsigned int cpu;
+};
+
+static void __cpuinit do_fork_idle(struct work_struct *work)
+{
+	struct create_idle *c = container_of(work, struct create_idle, work);
+
+	c->idle = fork_idle(c->cpu);
+	complete(&c->done);
+}
+
+static struct task_struct * __cpuinit idle_thread_create(unsigned int cpu)
+{
+	struct create_idle c_idle = {
+		.cpu	= cpu,
+		.done	= COMPLETION_INITIALIZER_ONSTACK(c_idle.done),
+	};
+
+	INIT_WORK_ONSTACK(&c_idle.work, do_fork_idle);
+	schedule_work(&c_idle.work);
+	wait_for_completion(&c_idle.done);
+	destroy_work_on_stack(&c_idle.work);
+	return c_idle.idle;
+}
+
+/*
+ * For the hotplug case we keep the task structs around and reuse
+ * them.
+ */
+static DEFINE_PER_CPU(struct task_struct *, idle_threads);
+
+static inline struct task_struct *get_idle_for_cpu(unsigned int cpu)
+{
+	struct task_struct *tsk = per_cpu(idle_threads, cpu);
+
+	if (!tsk)
+		return idle_thread_create(cpu);
+	init_idle(tsk, cpu);
+	return tsk;
+}
+
+struct task_struct * __cpuinit idle_thread_get(unsigned int cpu)
+{
+	return per_cpu(idle_threads, cpu);
+}
+
+void __init idle_thread_set_boot_cpu(void)
+{
+	per_cpu(idle_threads, smp_processor_id()) = current;
+}
+
+/**
+ * idle_thread_init - Initialize the idle thread for a cpu
+ * @cpu:	The cpu for which the idle thread should be initialized
+ *
+ * Creates the thread if it does not exist.
+ */
+static int __cpuinit idle_thread_init(unsigned int cpu)
+{
+	struct task_struct *idle = get_idle_for_cpu(cpu);
+
+	if (IS_ERR(idle)) {
+		printk(KERN_ERR "failed fork for CPU %u\n", cpu);
+		return PTR_ERR(idle);
+	}
+	per_cpu(idle_threads, cpu) = idle;
+	return 0;
+}
+#else
+static inline int idle_thread_init(unsigned int cpu) { return 0; }
+#endif
+
 /**
  * smpboot_prepare - generic smpboot preparation
  */
 int __cpuinit smpboot_prepare(unsigned int cpu)
 {
+	return idle_thread_init(cpu);
 }
Index: linux-2.6/kernel/smpboot.h
===================================================================
--- linux-2.6.orig/kernel/smpboot.h
+++ linux-2.6/kernel/smpboot.h
@@ -1,6 +1,16 @@
 #ifndef SMPBOOT_H
 #define SMPBOOT_H
 
+struct task_struct;
+
 int smpboot_prepare(unsigned int cpu);
 
+#ifdef CONFIG_GENERIC_SMP_IDLE_THREAD
+struct task_struct *idle_thread_get(unsigned int cpu);
+void idle_thread_set_boot_cpu(void);
+#else
+static inline struct task_struct *idle_thread_get(unsigned int cpu) { return NULL; }
+static inline void idle_thread_set_boot_cpu(void) { }
+#endif
+
 #endif


