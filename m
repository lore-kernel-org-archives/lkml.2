Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab2D1JG1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 05:06:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44353 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab2D1JGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 05:06:21 -0400
Date: Sat, 28 Apr 2012 02:05:03 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-29d5e0476e1c4a513859e7858845ad172f560389@git.kernel.org>
Cc: mingo@kernel.org, jesper.nilsson@axis.com, rusty@rustcorp.com.au,
        schwidefsky@de.ibm.com, peterz@infradead.org, cmetcalf@tilera.com,
        tony.luck@intel.com, ralf@linux-mips.org, linux@arm.linux.org.uk,
        vapier@gentoo.org, tglx@linutronix.de, venki@google.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, richard@nod.at,
        lethal@linux-sh.org, srivatsa.bhat@linux.vnet.ibm.com,
        davem@davemloft.net, paulmck@linux.vnet.ibm.com,
        benh@kernel.crashing.org, dhowells@redhat.com, mattst88@gmail.com,
        jejb@parisc-linux.org, takata@linux-m32r.org, rkuo@codeaurora.org
Reply-To: mingo@kernel.org, jesper.nilsson@axis.com, rusty@rustcorp.com.au,
        peterz@infradead.org, schwidefsky@de.ibm.com, cmetcalf@tilera.com,
        tony.luck@intel.com, linux@arm.linux.org.uk, ralf@linux-mips.org,
        vapier@gentoo.org, tglx@linutronix.de, venki@google.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, richard@nod.at,
        srivatsa.bhat@linux.vnet.ibm.com, lethal@linux-sh.org,
        davem@davemloft.net, paulmck@linux.vnet.ibm.com, dhowells@redhat.com,
        benh@kernel.crashing.org, jejb@parisc-linux.org, mattst88@gmail.com,
        takata@linux-m32r.org, rkuo@codeaurora.org
In-Reply-To: <20120420124557.102478630@linutronix.de>
References: <20120420124557.102478630@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] smp: Provide generic idle thread allocation
Git-Commit-ID: 29d5e0476e1c4a513859e7858845ad172f560389
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 28 Apr 2012 02:05:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  29d5e0476e1c4a513859e7858845ad172f560389
Gitweb:     http://git.kernel.org/tip/29d5e0476e1c4a513859e7858845ad172f560389
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 20 Apr 2012 13:05:45 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 26 Apr 2012 12:06:09 +0200

smp: Provide generic idle thread allocation

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
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Howells <dhowells@redhat.com>
Cc: James E.J. Bottomley <jejb@parisc-linux.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: x86@kernel.org
Acked-by: Venkatesh Pallipadi <venki@google.com>
Link: http://lkml.kernel.org/r/20120420124557.102478630@linutronix.de
---
 arch/Kconfig        |    3 ++
 kernel/cpu.c        |    2 +-
 kernel/sched/core.c |    2 +
 kernel/smpboot.c    |   84 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/smpboot.h    |   10 ++++++
 5 files changed, 99 insertions(+), 2 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 684eb5a..4f0d0f7 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -145,6 +145,9 @@ config HAVE_DMA_ATTRS
 config USE_GENERIC_SMP_HELPERS
 	bool
 
+config GENERIC_SMP_IDLE_THREAD
+       bool
+
 config HAVE_REGS_AND_STACK_ACCESS_API
 	bool
 	help
diff --git a/kernel/cpu.c b/kernel/cpu.c
index e58b99a..05c46ba 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -316,7 +316,7 @@ static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
 	}
 
 	/* Arch-specific enabling code. */
-	ret = __cpu_up(cpu, NULL);
+	ret = __cpu_up(cpu, idle_thread_get(cpu));
 	if (ret != 0)
 		goto out_notify;
 	BUG_ON(!cpu_online(cpu));
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4603b9d..6a63cde 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
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
 
diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index 6dae6a3..ed15769 100644
--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -1,14 +1,96 @@
 /*
  * Common SMP CPU bringup/teardown functions
  */
+#include <linux/err.h>
+#include <linux/smp.h>
 #include <linux/init.h>
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
-	return 0;
+	return idle_thread_init(cpu);
 }
diff --git a/kernel/smpboot.h b/kernel/smpboot.h
index d88e771..7943bbb 100644
--- a/kernel/smpboot.h
+++ b/kernel/smpboot.h
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
