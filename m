Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746Ab1ILFCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 01:02:18 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:46400 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751332Ab1ILFCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 01:02:16 -0400
Message-ID: <4E6D924F.9050605@ti.com>
Date: Mon, 12 Sep 2011 10:32:07 +0530
From: Santosh <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, ccross@android.com, rjw@sisk.pl,
        khilman@ti.com
Subject: Re: [PATCH v2 1/5] cpu_pm: Add cpu power management notifiers
References: <1315060755-4613-1-git-send-email-santosh.shilimkar@ti.com>	<1315060755-4613-2-git-send-email-santosh.shilimkar@ti.com> <20110909155632.661f5696.akpm@linux-foundation.org> <4E6B2E6E.7010807@ti.com>
In-Reply-To: <4E6B2E6E.7010807@ti.com>
Content-Type: multipart/mixed;
 boundary="------------030209040405090402060508"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030209040405090402060508
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On Saturday 10 September 2011 03:01 PM, Santosh wrote:
> Andrew,
>
> On Saturday 10 September 2011 04:26 AM, Andrew Morton wrote:
>> On Sat, 3 Sep 2011 20:09:11 +0530
>> Santosh Shilimkar<santosh.shilimkar@ti.com> wrote:
>
> [...]
>
>>
>> Have you identified which indivudual you hope/expect to merge this into
>> mainline?
>>
>> The code is presumably and hopefully applicable to architectures other
>> than ARM, yes? Can you suggest likely candidate architectures so we
>> can go off and bug the relevant maintainers to review it?
>>
> Sorry I missed above question in last email. Am not too sure but any
> arch which has CPU local timers, interrupt controller, Floating point
> co-processor etc, should be able to make use of it. So it's applicable
> to any architecture, but whether they want to use it, i don't know.
>
> As you noticed most of the ARM machine's are adapting to it.
> Along with generic patch, there are couple ARM drivers adapting
> to make use of it. That was the reason I was pushing this series
> via Russell's tree.
>
Here is an updated patch addressing your comments.
Attaching the same in case mailer eats spaces.

 From 6a0ef5d42da459d9eba0a5f396e6d9a95d3f94ff Mon Sep 17 00:00:00 2001
From: Colin Cross <ccross@android.com>
Date: Thu, 10 Feb 2011 02:04:45 -0800
Subject: [PATCH 1/5] cpu_pm: Add cpu power management notifiers

During some CPU power modes entered during idle, hotplug and
suspend, peripherals located in the CPU power domain, such as
the GIC, localtimers, and VFP, may be powered down.  Add a
notifier chain that allows drivers for those peripherals to
be notified before and after they may be reset.

Notified drivers can include VFP co-processor, interrupt controller
and it's PM extensions, local CPU timers context save/restore which
shouldn't be interrupted. Hence CPU PM event APIs  must be called
with interrupts disabled.

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Reviewed-by: Kevin Hilman <khilman@ti.com>
Tested-and-Acked-by: Shawn Guo <shawn.guo@linaro.org>
Tested-by: Kevin Hilman <khilman@ti.com>
---
  include/linux/cpu_pm.h |  109 ++++++++++++++++++++++++++
  kernel/Makefile        |    1 +
  kernel/cpu_pm.c        |  200 
++++++++++++++++++++++++++++++++++++++++++++++++
  kernel/power/Kconfig   |    4 +
  4 files changed, 314 insertions(+), 0 deletions(-)
  create mode 100644 include/linux/cpu_pm.h
  create mode 100644 kernel/cpu_pm.c

diff --git a/include/linux/cpu_pm.h b/include/linux/cpu_pm.h
new file mode 100644
index 0000000..455b233
--- /dev/null
+++ b/include/linux/cpu_pm.h
@@ -0,0 +1,109 @@
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
+ * interrupt controllers, caches, timers) in the same power domain can
+ * be lost.  The cpm_pm notifiers provide a method for platform idle, 
suspend,
+ * and hotplug implementations to notify the drivers for these blocks that
+ * they may be reset.
+ *
+ * All cpu_pm notifications must be called with interrupts disabled.
+ *
+ * The notifications are split into two classes: CPU notifications and CPU
+ * cluster notifications.
+ *
+ * CPU notifications apply to a single CPU and must be called on the 
affected
+ * CPU.  They are used to save per-cpu context for affected blocks.
+ *
+ * CPU cluster notifications apply to all CPUs in a single power 
domain. They
+ * are used to save any global context for affected blocks, and must be 
called
+ * after all the CPUs in the power domain have been notified of the low 
power
+ * state.
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
+#ifdef CONFIG_CPU_PM
+int cpu_pm_register_notifier(struct notifier_block *nb);
+int cpu_pm_unregister_notifier(struct notifier_block *nb);
+int cpu_pm_enter(void);
+int cpu_pm_exit(void);
+int cpu_cluster_pm_enter(void);
+int cpu_cluster_pm_exit(void);
+
+#else
+
+static inline int cpu_pm_register_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
+
+static inline int cpu_pm_unregister_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
+
+static inline int cpu_pm_enter(void)
+{
+	return 0;
+}
+
+static inline int cpu_pm_exit(void)
+{
+	return 0;
+}
+
+static inline int cpu_cluster_pm_enter(void)
+{
+	return 0;
+}
+
+static inline int cpu_cluster_pm_exit(void)
+{
+	return 0;
+}
+#endif
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
index 0000000..4d1ff4a
--- /dev/null
+++ b/kernel/cpu_pm.c
@@ -0,0 +1,200 @@
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
+static int cpu_pm_notify(enum cpu_pm_event event, int nr_to_call, int 
*nr_calls)
+{
+	int ret;
+
+	ret = __raw_notifier_call_chain(&cpu_pm_notifier_chain, event, NULL,
+		nr_to_call, nr_calls);
+
+	return notifier_to_errno(ret);
+}
+
+/**
+ * cpu_pm_register_notifier - register a driver with cpu_pm
+ * @nb: notifier block to register
+ *
+ * Add a driver to a list of drivers that are notified about
+ * CPU and CPU cluster low power entry and exit.
+ *
+ * This function may sleep, and has the same return conditions as
+ * raw_notifier_chain_register.
+ */
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
+/**
+ * cpu_pm_unregister_notifier - unregister a driver with cpu_pm
+ * @nb: notifier block to be unregistered
+ *
+ * Remove a driver from the CPU PM notifier list.
+ *
+ * This function may sleep, and has the same return conditions as
+ * raw_notifier_chain_unregister.
+ */
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
+/**
+ * cpm_pm_enter - CPU low power entry notifier
+ *
+ * Notifies listeners that a single CPU is entering a low power state 
that may
+ * cause some blocks in the same power domain as the cpu to reset.
+ *
+ * Must be called on the affected CPU with interrupts disabled. 
Platform is
+ * responsible for ensuring that cpu_pm_enter is not called twice on 
the same
+ * CPU before cpu_pm_exit is called. Notified drivers can include VFP
+ * co-processor, interrupt controller and it's PM extensions, local CPU
+ * timers context save/restore which shouldn't be interrupted. Hence it
+ * must be called with interrupts disabled.
+ *
+ * Return conditions are same as __raw_notifier_call_chain.
+ */
+int cpu_pm_enter(void)
+{
+	int nr_calls;
+	int ret = 0;
+
+	read_lock(&cpu_pm_notifier_lock);
+	ret = cpu_pm_notify(CPU_PM_ENTER, -1, &nr_calls);
+	if (ret)
+		/*
+		 * Inform listeners (nr_calls - 1) about failure of CPU PM
+		 * PM entry who are notified earlier to prepare for it.
+		 */
+		cpu_pm_notify(CPU_PM_ENTER_FAILED, nr_calls - 1, NULL);
+	read_unlock(&cpu_pm_notifier_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(cpu_pm_enter);
+
+/**
+ * cpm_pm_exit - CPU low power exit notifier
+ *
+ * Notifies listeners that a single CPU is exiting a low power state 
that may
+ * have caused some blocks in the same power domain as the cpu to reset.
+ *
+ * Notified drivers can include VFP co-processor, interrupt controller
+ * and it's PM extensions, local CPU timers context save/restore which
+ * shouldn't be interrupted. Hence it must be called with interrupts 
disabled.
+ *
+ * Return conditions are same as __raw_notifier_call_chain.
+ */
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
+/**
+ * cpm_cluster_pm_enter - CPU cluster low power entry notifier
+ *
+ * Notifies listeners that all cpus in a power domain are entering a 
low power
+ * state that may cause some blocks in the same power domain to reset.
+ *
+ * Must be called after cpu_pm_enter has been called on all cpus in the 
power
+ * domain, and before cpu_pm_exit has been called on any cpu in the power
+ * domain. Notified drivers can include VFP co-processor, interrupt 
controller
+ * and it's PM extensions, local CPU timers context save/restore which
+ * shouldn't be interrupted. Hence it must be called with interrupts 
disabled.
+ *
+ * Must be called with interrupts disabled.
+ *
+ * Return conditions are same as __raw_notifier_call_chain.
+ */
+int cpu_cluster_pm_enter(void)
+{
+	int nr_calls;
+	int ret = 0;
+
+	read_lock(&cpu_pm_notifier_lock);
+	ret = cpu_pm_notify(CPU_CLUSTER_PM_ENTER, -1, &nr_calls);
+	if (ret)
+		/*
+		 * Inform listeners (nr_calls - 1) about failure of CPU cluster
+		 * PM entry who are notified earlier to prepare for it.
+		 */
+		cpu_pm_notify(CPU_CLUSTER_PM_ENTER_FAILED, nr_calls - 1, NULL);
+	read_unlock(&cpu_pm_notifier_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(cpu_cluster_pm_enter);
+
+/**
+ * cpm_cluster_pm_exit - CPU cluster low power exit notifier
+ *
+ * Notifies listeners that all cpus in a power domain are exiting form a
+ * low power state that may have caused some blocks in the same power 
domain
+ * to reset.
+ *
+ * Must be called after cpu_pm_exit has been called on all cpus in the 
power
+ * domain, and before cpu_pm_exit has been called on any cpu in the power
+ * domain. Notified drivers can include VFP co-processor, interrupt 
controller
+ * and it's PM extensions, local CPU timers context save/restore which
+ * shouldn't be interrupted. Hence it must be called with interrupts 
disabled.
+ *
+ * Return conditions are same as __raw_notifier_call_chain.
+ */
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
index 3744c59..80a8597 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -235,3 +235,7 @@ config PM_GENERIC_DOMAINS
  config PM_GENERIC_DOMAINS_RUNTIME
  	def_bool y
  	depends on PM_RUNTIME && PM_GENERIC_DOMAINS
+
+config CPU_PM
+	bool
+	depends on SUSPEND || CPU_IDLE
-- 
1.7.4.1

Regards
Santosh

--------------030209040405090402060508
Content-Type: text/x-patch;
 name="0001-cpu_pm-Add-cpu-power-management-notifiers.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-cpu_pm-Add-cpu-power-management-notifiers.patch"

>From 6a0ef5d42da459d9eba0a5f396e6d9a95d3f94ff Mon Sep 17 00:00:00 2001
From: Colin Cross <ccross@android.com>
Date: Thu, 10 Feb 2011 02:04:45 -0800
Subject: [PATCH 1/5] cpu_pm: Add cpu power management notifiers

During some CPU power modes entered during idle, hotplug and
suspend, peripherals located in the CPU power domain, such as
the GIC, localtimers, and VFP, may be powered down.  Add a
notifier chain that allows drivers for those peripherals to
be notified before and after they may be reset.

Notified drivers can include VFP co-processor, interrupt controller
and it's PM extensions, local CPU timers context save/restore which
shouldn't be interrupted. Hence CPU PM event APIs  must be called
with interrupts disabled.

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Reviewed-by: Kevin Hilman <khilman@ti.com>
Tested-and-Acked-by: Shawn Guo <shawn.guo@linaro.org>
Tested-by: Kevin Hilman <khilman@ti.com>
---
 include/linux/cpu_pm.h |  109 ++++++++++++++++++++++++++
 kernel/Makefile        |    1 +
 kernel/cpu_pm.c        |  200 ++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/power/Kconfig   |    4 +
 4 files changed, 314 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/cpu_pm.h
 create mode 100644 kernel/cpu_pm.c

diff --git a/include/linux/cpu_pm.h b/include/linux/cpu_pm.h
new file mode 100644
index 0000000..455b233
--- /dev/null
+++ b/include/linux/cpu_pm.h
@@ -0,0 +1,109 @@
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
+ * interrupt controllers, caches, timers) in the same power domain can
+ * be lost.  The cpm_pm notifiers provide a method for platform idle, suspend,
+ * and hotplug implementations to notify the drivers for these blocks that
+ * they may be reset.
+ *
+ * All cpu_pm notifications must be called with interrupts disabled.
+ *
+ * The notifications are split into two classes: CPU notifications and CPU
+ * cluster notifications.
+ *
+ * CPU notifications apply to a single CPU and must be called on the affected
+ * CPU.  They are used to save per-cpu context for affected blocks.
+ *
+ * CPU cluster notifications apply to all CPUs in a single power domain. They
+ * are used to save any global context for affected blocks, and must be called
+ * after all the CPUs in the power domain have been notified of the low power
+ * state.
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
+#ifdef CONFIG_CPU_PM
+int cpu_pm_register_notifier(struct notifier_block *nb);
+int cpu_pm_unregister_notifier(struct notifier_block *nb);
+int cpu_pm_enter(void);
+int cpu_pm_exit(void);
+int cpu_cluster_pm_enter(void);
+int cpu_cluster_pm_exit(void);
+
+#else
+
+static inline int cpu_pm_register_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
+
+static inline int cpu_pm_unregister_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
+
+static inline int cpu_pm_enter(void)
+{
+	return 0;
+}
+
+static inline int cpu_pm_exit(void)
+{
+	return 0;
+}
+
+static inline int cpu_cluster_pm_enter(void)
+{
+	return 0;
+}
+
+static inline int cpu_cluster_pm_exit(void)
+{
+	return 0;
+}
+#endif
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
index 0000000..4d1ff4a
--- /dev/null
+++ b/kernel/cpu_pm.c
@@ -0,0 +1,200 @@
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
+/**
+ * cpu_pm_register_notifier - register a driver with cpu_pm
+ * @nb: notifier block to register
+ *
+ * Add a driver to a list of drivers that are notified about
+ * CPU and CPU cluster low power entry and exit.
+ *
+ * This function may sleep, and has the same return conditions as
+ * raw_notifier_chain_register.
+ */
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
+/**
+ * cpu_pm_unregister_notifier - unregister a driver with cpu_pm
+ * @nb: notifier block to be unregistered
+ *
+ * Remove a driver from the CPU PM notifier list.
+ *
+ * This function may sleep, and has the same return conditions as
+ * raw_notifier_chain_unregister.
+ */
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
+/**
+ * cpm_pm_enter - CPU low power entry notifier
+ *
+ * Notifies listeners that a single CPU is entering a low power state that may
+ * cause some blocks in the same power domain as the cpu to reset.
+ *
+ * Must be called on the affected CPU with interrupts disabled.  Platform is
+ * responsible for ensuring that cpu_pm_enter is not called twice on the same
+ * CPU before cpu_pm_exit is called. Notified drivers can include VFP
+ * co-processor, interrupt controller and it's PM extensions, local CPU
+ * timers context save/restore which shouldn't be interrupted. Hence it
+ * must be called with interrupts disabled.
+ *
+ * Return conditions are same as __raw_notifier_call_chain.
+ */
+int cpu_pm_enter(void)
+{
+	int nr_calls;
+	int ret = 0;
+
+	read_lock(&cpu_pm_notifier_lock);
+	ret = cpu_pm_notify(CPU_PM_ENTER, -1, &nr_calls);
+	if (ret)
+		/*
+		 * Inform listeners (nr_calls - 1) about failure of CPU PM
+		 * PM entry who are notified earlier to prepare for it.
+		 */
+		cpu_pm_notify(CPU_PM_ENTER_FAILED, nr_calls - 1, NULL);
+	read_unlock(&cpu_pm_notifier_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(cpu_pm_enter);
+
+/**
+ * cpm_pm_exit - CPU low power exit notifier
+ *
+ * Notifies listeners that a single CPU is exiting a low power state that may
+ * have caused some blocks in the same power domain as the cpu to reset.
+ *
+ * Notified drivers can include VFP co-processor, interrupt controller
+ * and it's PM extensions, local CPU timers context save/restore which
+ * shouldn't be interrupted. Hence it must be called with interrupts disabled.
+ *
+ * Return conditions are same as __raw_notifier_call_chain.
+ */
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
+/**
+ * cpm_cluster_pm_enter - CPU cluster low power entry notifier
+ *
+ * Notifies listeners that all cpus in a power domain are entering a low power
+ * state that may cause some blocks in the same power domain to reset.
+ *
+ * Must be called after cpu_pm_enter has been called on all cpus in the power
+ * domain, and before cpu_pm_exit has been called on any cpu in the power
+ * domain. Notified drivers can include VFP co-processor, interrupt controller
+ * and it's PM extensions, local CPU timers context save/restore which
+ * shouldn't be interrupted. Hence it must be called with interrupts disabled.
+ *
+ * Must be called with interrupts disabled.
+ *
+ * Return conditions are same as __raw_notifier_call_chain.
+ */
+int cpu_cluster_pm_enter(void)
+{
+	int nr_calls;
+	int ret = 0;
+
+	read_lock(&cpu_pm_notifier_lock);
+	ret = cpu_pm_notify(CPU_CLUSTER_PM_ENTER, -1, &nr_calls);
+	if (ret)
+		/*
+		 * Inform listeners (nr_calls - 1) about failure of CPU cluster
+		 * PM entry who are notified earlier to prepare for it.
+		 */
+		cpu_pm_notify(CPU_CLUSTER_PM_ENTER_FAILED, nr_calls - 1, NULL);
+	read_unlock(&cpu_pm_notifier_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(cpu_cluster_pm_enter);
+
+/**
+ * cpm_cluster_pm_exit - CPU cluster low power exit notifier
+ *
+ * Notifies listeners that all cpus in a power domain are exiting form a
+ * low power state that may have caused some blocks in the same power domain
+ * to reset.
+ *
+ * Must be called after cpu_pm_exit has been called on all cpus in the power
+ * domain, and before cpu_pm_exit has been called on any cpu in the power
+ * domain. Notified drivers can include VFP co-processor, interrupt controller
+ * and it's PM extensions, local CPU timers context save/restore which
+ * shouldn't be interrupted. Hence it must be called with interrupts disabled.
+ *
+ * Return conditions are same as __raw_notifier_call_chain.
+ */
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
index 3744c59..80a8597 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -235,3 +235,7 @@ config PM_GENERIC_DOMAINS
 config PM_GENERIC_DOMAINS_RUNTIME
 	def_bool y
 	depends on PM_RUNTIME && PM_GENERIC_DOMAINS
+
+config CPU_PM
+	bool
+	depends on SUSPEND || CPU_IDLE
-- 
1.7.4.1


--------------030209040405090402060508--
