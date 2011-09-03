Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab1ICOkb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 10:40:31 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48034 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447Ab1ICOkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 10:40:04 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <ccross@android.com>, <rjw@sisk.pl>, <khilman@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH v2 1/5] cpu_pm: Add cpu power management notifiers
Date: Sat, 3 Sep 2011 20:09:11 +0530
Message-ID: <1315060755-4613-2-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315060755-4613-1-git-send-email-santosh.shilimkar@ti.com>
References: <1315060755-4613-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

During some CPU power modes entered during idle, hotplug and
suspend, peripherals located in the CPU power domain, such as
the GIC, localtimers, and VFP, may be powered down.  Add a
notifier chain that allows drivers for those peripherals to
be notified before and after they may be reset.

Signed-off-by: Colin Cross <ccross@android.com>
[santosh.shilimkar@ti.com: Rebased against 3.1-rc3]
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Tested-by: Kevin Hilman <khilman@ti.com>
---
 include/linux/cpu_pm.h |  123 ++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/Makefile        |    1 +
 kernel/cpu_pm.c        |  115 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/power/Kconfig   |    4 ++
 4 files changed, 243 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/cpu_pm.h
 create mode 100644 kernel/cpu_pm.c

diff --git a/include/linux/cpu_pm.h b/include/linux/cpu_pm.h
new file mode 100644
index 0000000..3c880cb
--- /dev/null
+++ b/include/linux/cpu_pm.h
@@ -0,0 +1,123 @@
+/*
+ * Copyright (C) 2011 Google, Inc.
+ *
+ * Author:
+ *	Colin Cross <ccross@android.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _LINUX_CPU_PM_H
+#define _LINUX_CPU_PM_H
+
+#include <linux/kernel.h>
+#include <linux/notifier.h>
+
+/*
+ * When a CPU goes to a low power state that turns off power to the CPU's
+ * power domain, the contents of some blocks (floating point coprocessors,
+ * interrutp controllers, caches, timers) in the same power domain can
+ * be lost.  The cpm_pm notifiers provide a method for platform idle, suspend,
+ * and hotplug implementations to notify the drivers for these blocks that
+ * they may be reset.
+ *
+ * All cpu_pm notifications must be called with interrupts disabled.
+ *
+ * The notifications are split into two classes, CPU notifications and CPU
+ * cluster notifications.
+ *
+ * CPU notifications apply to a single CPU, and must be called on the affected
+ * CPU.  They are used to save per-cpu context for affected blocks.
+ *
+ * CPU cluster notifications apply to all CPUs in a single power domain. They
+ * are used to save any global context for affected blocks, and must be called
+ * after all the CPUs in the power domain have been notified of the low power
+ * state.
+ *
+ */
+
+/*
+ * Event codes passed as unsigned long val to notifier calls
+ */
+enum cpu_pm_event {
+	/* A single cpu is entering a low power state */
+	CPU_PM_ENTER,
+
+	/* A single cpu failed to enter a low power state */
+	CPU_PM_ENTER_FAILED,
+
+	/* A single cpu is exiting a low power state */
+	CPU_PM_EXIT,
+
+	/* A cpu power domain is entering a low power state */
+	CPU_CLUSTER_PM_ENTER,
+
+	/* A cpu power domain failed to enter a low power state */
+	CPU_CLUSTER_PM_ENTER_FAILED,
+
+	/* A cpu power domain is exiting a low power state */
+	CPU_CLUSTER_PM_EXIT,
+};
+
+int cpu_pm_register_notifier(struct notifier_block *nb);
+int cpu_pm_unregister_notifier(struct notifier_block *nb);
+
+/*
+ * cpm_pm_enter
+ *
+ * Notifies listeners that a single cpu is entering a low power state that may
+ * cause some blocks in the same power domain as the cpu to reset.
+ *
+ * Must be called on the affected cpu with interrupts disabled.  Platform is
+ * responsible for ensuring that cpu_pm_enter is not called twice on the same
+ * cpu before cpu_pm_exit is called.
+ */
+int cpu_pm_enter(void);
+
+/*
+ * cpm_pm_exit
+ *
+ * Notifies listeners that a single cpu is exiting a low power state that may
+ * have caused some blocks in the same power domain as the cpu to reset.
+ *
+ * Must be called on the affected cpu with interrupts disabled.
+ */
+int cpu_pm_exit(void);
+
+/*
+ * cpm_cluster_pm_enter
+ *
+ * Notifies listeners that all cpus in a power domain are entering a low power
+ * state that may cause some blocks in the same power domain to reset.
+ *
+ * Must be called after cpu_pm_enter has been called on all cpus in the power
+ * domain, and before cpu_pm_exit has been called on any cpu in the power
+ * domain.
+ *
+ * Must be called with interrupts disabled.
+ */
+int cpu_cluster_pm_enter(void);
+
+/*
+ * cpm_pm_enter
+ *
+ * Notifies listeners that a single cpu is entering a low power state that may
+ * cause some blocks in the same power domain as the cpu to reset.
+ *
+ * Must be called after cpu_pm_enter has been called on all cpus in the power
+ * domain, and before cpu_pm_exit has been called on any cpu in the power
+ * domain.
+ *
+ * Must be called with interrupts disabled.
+ */
+int cpu_cluster_pm_exit(void);
+
+#endif
diff --git a/kernel/Makefile b/kernel/Makefile
index eca595e..988cb3d 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -101,6 +101,7 @@ obj-$(CONFIG_RING_BUFFER) += trace/
 obj-$(CONFIG_TRACEPOINTS) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
 obj-$(CONFIG_IRQ_WORK) += irq_work.o
+obj-$(CONFIG_CPU_PM) += cpu_pm.o
 
 obj-$(CONFIG_PERF_EVENTS) += events/
 
diff --git a/kernel/cpu_pm.c b/kernel/cpu_pm.c
new file mode 100644
index 0000000..54aa892
--- /dev/null
+++ b/kernel/cpu_pm.c
@@ -0,0 +1,115 @@
+/*
+ * Copyright (C) 2011 Google, Inc.
+ *
+ * Author:
+ *	Colin Cross <ccross@android.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/cpu_pm.h>
+#include <linux/module.h>
+#include <linux/notifier.h>
+#include <linux/spinlock.h>
+
+static DEFINE_RWLOCK(cpu_pm_notifier_lock);
+static RAW_NOTIFIER_HEAD(cpu_pm_notifier_chain);
+
+int cpu_pm_register_notifier(struct notifier_block *nb)
+{
+	unsigned long flags;
+	int ret;
+
+	write_lock_irqsave(&cpu_pm_notifier_lock, flags);
+	ret = raw_notifier_chain_register(&cpu_pm_notifier_chain, nb);
+	write_unlock_irqrestore(&cpu_pm_notifier_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(cpu_pm_register_notifier);
+
+int cpu_pm_unregister_notifier(struct notifier_block *nb)
+{
+	unsigned long flags;
+	int ret;
+
+	write_lock_irqsave(&cpu_pm_notifier_lock, flags);
+	ret = raw_notifier_chain_unregister(&cpu_pm_notifier_chain, nb);
+	write_unlock_irqrestore(&cpu_pm_notifier_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(cpu_pm_unregister_notifier);
+
+static int cpu_pm_notify(enum cpu_pm_event event, int nr_to_call, int *nr_calls)
+{
+	int ret;
+
+	ret = __raw_notifier_call_chain(&cpu_pm_notifier_chain, event, NULL,
+		nr_to_call, nr_calls);
+
+	return notifier_to_errno(ret);
+}
+
+int cpu_pm_enter(void)
+{
+	int nr_calls;
+	int ret = 0;
+
+	read_lock(&cpu_pm_notifier_lock);
+	ret = cpu_pm_notify(CPU_PM_ENTER, -1, &nr_calls);
+	if (ret)
+		cpu_pm_notify(CPU_PM_ENTER_FAILED, nr_calls - 1, NULL);
+	read_unlock(&cpu_pm_notifier_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(cpu_pm_enter);
+
+int cpu_pm_exit(void)
+{
+	int ret;
+
+	read_lock(&cpu_pm_notifier_lock);
+	ret = cpu_pm_notify(CPU_PM_EXIT, -1, NULL);
+	read_unlock(&cpu_pm_notifier_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(cpu_pm_exit);
+
+int cpu_cluster_pm_enter(void)
+{
+	int nr_calls;
+	int ret = 0;
+
+	read_lock(&cpu_pm_notifier_lock);
+	ret = cpu_pm_notify(CPU_CLUSTER_PM_ENTER, -1, &nr_calls);
+	if (ret)
+		cpu_pm_notify(CPU_CLUSTER_PM_ENTER_FAILED, nr_calls - 1, NULL);
+	read_unlock(&cpu_pm_notifier_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(cpu_cluster_pm_enter);
+
+int cpu_cluster_pm_exit(void)
+{
+	int ret;
+
+	read_lock(&cpu_pm_notifier_lock);
+	ret = cpu_pm_notify(CPU_CLUSTER_PM_EXIT, -1, NULL);
+	read_unlock(&cpu_pm_notifier_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(cpu_cluster_pm_exit);
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 3744c59..f7456b4 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -235,3 +235,7 @@ config PM_GENERIC_DOMAINS
 config PM_GENERIC_DOMAINS_RUNTIME
 	def_bool y
 	depends on PM_RUNTIME && PM_GENERIC_DOMAINS
+
+config CPU_PM
+	def_bool y
+	depends on SUSPEND || CPU_IDLE
-- 
1.7.4.1

