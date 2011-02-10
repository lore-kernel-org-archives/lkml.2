Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab1BJVcD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 16:32:03 -0500
Received: from smtp-out.google.com ([74.125.121.67]:41587 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161Ab1BJVcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 16:32:01 -0500
From: Colin Cross <ccross@android.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, santosh.shilimkar@ti.com, catalin.marinas@arm.com,
        will.deacon@arm.com, Colin Cross <ccross@android.com>,
        Jamie Iles <jamie.iles@picochip.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/3] ARM: Add cpu power management notifiers
Date: Thu, 10 Feb 2011 13:31:25 -0800
Message-Id: <1297373487-23902-2-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1297373487-23902-1-git-send-email-ccross@android.com>
References: <1297373487-23902-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During some CPU power modes entered during idle, hotplug and
suspend, peripherals located in the CPU power domain, such as
the GIC, localtimers, and VFP, may be powered down.  Add a
notifier chain that allows drivers for those peripherals to
be notified before and after they may be reset.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/include/asm/cpu_pm.h |  123 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/Makefile      |    1 +
 arch/arm/kernel/cpu_pm.c      |  116 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 240 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/include/asm/cpu_pm.h
 create mode 100644 arch/arm/kernel/cpu_pm.c

diff --git a/arch/arm/include/asm/cpu_pm.h b/arch/arm/include/asm/cpu_pm.h
new file mode 100644
index 0000000..07b1b6e
--- /dev/null
+++ b/arch/arm/include/asm/cpu_pm.h
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
+#ifndef _ASMARM_CPU_PM_H
+#define _ASMARM_CPU_PM_H
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
+ * complex notifications.
+ *
+ * CPU notifications apply to a single CPU, and must be called on the affected
+ * CPU.  They are used to save per-cpu context for affected blocks.
+ *
+ * CPU complex notifications apply to all CPUs in a single power domain. They
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
+	CPU_COMPLEX_PM_ENTER,
+
+	/* A cpu power domain failed to enter a low power state */
+	CPU_COMPLEX_PM_ENTER_FAILED,
+
+	/* A cpu power domain is exiting a low power state */
+	CPU_COMPLEX_PM_EXIT,
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
+ * cpm_complex_pm_enter
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
+int cpu_complex_pm_enter(void);
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
+int cpu_complex_pm_exit(void);
+
+#endif
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 185ee82..b0f25cb 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -58,6 +58,7 @@ obj-$(CONFIG_CPU_PJ4)		+= pj4-cp0.o
 obj-$(CONFIG_IWMMXT)		+= iwmmxt.o
 obj-$(CONFIG_CPU_HAS_PMU)	+= pmu.o
 obj-$(CONFIG_HW_PERF_EVENTS)	+= perf_event.o
+obj-$(CONFIG_CPU_IDLE)		+= cpu_pm.o
 AFLAGS_iwmmxt.o			:= -Wa,-mcpu=iwmmxt
 
 ifneq ($(CONFIG_ARCH_EBSA110),y)
diff --git a/arch/arm/kernel/cpu_pm.c b/arch/arm/kernel/cpu_pm.c
new file mode 100644
index 0000000..9a04ba1
--- /dev/null
+++ b/arch/arm/kernel/cpu_pm.c
@@ -0,0 +1,116 @@
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
+#include <linux/notifier.h>
+#include <linux/smp.h>
+
+#include <asm/cpu_pm.h>
+
+static DEFINE_SPINLOCK(idle_notifier_lock);
+static RAW_NOTIFIER_HEAD(idle_notifier_chain);
+
+int cpu_pm_register_notifier(struct notifier_block *nb)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&idle_notifier_lock, flags);
+	ret = raw_notifier_chain_register(&idle_notifier_chain, nb);
+	spin_unlock_irqrestore(&idle_notifier_lock, flags);
+
+	return ret;
+}
+
+int cpu_pm_unregister_notifier(struct notifier_block *nb)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&idle_notifier_lock, flags);
+	ret = raw_notifier_chain_unregister(&idle_notifier_chain, nb);
+	spin_unlock_irqrestore(&idle_notifier_lock, flags);
+
+	return ret;
+}
+
+static int __idle_notify(enum cpu_pm_event event, int nr_to_call,
+	int *nr_calls)
+{
+	int ret;
+
+	ret = __raw_notifier_call_chain(&idle_notifier_chain, event, NULL,
+		nr_to_call, nr_calls);
+
+	return notifier_to_errno(ret);
+}
+
+int cpu_pm_enter(void)
+{
+	int nr_calls;
+	int ret;
+
+	spin_lock(&idle_notifier_lock);
+	ret = __idle_notify(CPU_PM_ENTER, -1, &nr_calls);
+	if (ret) {
+		__idle_notify(CPU_PM_ENTER_FAILED, nr_calls - 1, NULL);
+		spin_unlock(&idle_notifier_lock);
+		return ret;
+	}
+	spin_unlock(&idle_notifier_lock);
+
+	return 0;
+}
+
+int cpu_pm_exit(void)
+{
+	int ret;
+
+	spin_lock(&idle_notifier_lock);
+	ret = __idle_notify(CPU_PM_EXIT, -1, NULL);
+	spin_unlock(&idle_notifier_lock);
+
+	return ret;
+}
+
+int cpu_complex_pm_enter(void)
+{
+	int nr_calls;
+	int ret;
+
+	spin_lock(&idle_notifier_lock);
+	ret = __idle_notify(CPU_COMPLEX_PM_ENTER, -1, &nr_calls);
+	if (ret) {
+		__idle_notify(CPU_COMPLEX_PM_ENTER_FAILED, nr_calls - 1, NULL);
+		spin_unlock(&idle_notifier_lock);
+		return ret;
+	}
+	spin_unlock(&idle_notifier_lock);
+
+	return 0;
+}
+
+int cpu_complex_pm_exit(void)
+{
+	int ret;
+
+	spin_lock(&idle_notifier_lock);
+	ret = __idle_notify(CPU_COMPLEX_PM_EXIT, -1, NULL);
+	spin_unlock(&idle_notifier_lock);
+
+	return ret;
+}
-- 
1.7.3.1

