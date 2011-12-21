Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab1LUAJ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 19:09:28 -0500
Received: from mail-ee0-f74.google.com ([74.125.83.74]:34960 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab1LUAJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 19:09:16 -0500
From: Colin Cross <ccross@android.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@lists.linux-foundation.org
Cc: Len Brown <len.brown@intel.com>, Kevin Hilman <khilman@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        linux-omap@vger.kernel.org, linux-tegra@vger.kernel.org,
        Colin Cross <ccross@android.com>
Subject: [PATCH 3/3] cpuidle: add support for states that affect multiple cpus
Date: Tue, 20 Dec 2011 16:09:07 -0800
Message-Id: <1324426147-16735-4-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1324426147-16735-1-git-send-email-ccross@android.com>
References: <1324426147-16735-1-git-send-email-ccross@android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some ARM SMP SoCs (OMAP4460, Tegra 2, and probably more), the
cpus cannot be independently powered down, either due to
sequencing restrictions (on Tegra 2, cpu 0 must be the last to
power down), or due to HW bugs (on OMAP4460, a cpu powering up
will corrupt the gic state unless the other cpu runs a work
around).  Each cpu has a power state that it can enter without
coordinating with the other cpu (usually Wait For Interrupt, or
WFI), and one or more "coupled" power states that affect blocks
shared between the cpus (L2 cache, interrupt controller, and
sometimes the whole SoC).  Entering a coupled power state must
be tightly controlled on both cpus.

The easiest solution to implementing coupled cpu power states is
to hotplug all but one cpu whenever possible, usually using a
cpufreq governor that looks at cpu load to determine when to
enable the secondary cpus.  This causes problems, as hotplug is an
expensive operation, so the number of hotplug transitions must be
minimized, leading to very slow response to loads, often on the
order of seconds.

This file implements an alternative solution, where each cpu will
wait in the WFI state until all cpus are ready to enter a coupled
state, at which point the coupled state function will be called
on all cpus at approximately the same time.

Once all cpus are ready to enter idle, they are woken by an smp
cross call.  At this point, there is a chance that one of the
cpus will find work to do, and choose not to enter suspend.  A
final pass is needed to guarantee that all cpus will call the
power state enter function at the same time.  During this pass,
each cpu will increment the ready counter, and continue once the
ready counter matches the number of online coupled cpus.  If any
cpu exits idle, the other cpus will decrement their counter and
retry.

To use coupled cpuidle states, a cpuidle driver must:

   Set struct cpuidle_device.coupled_cpus to the mask of all
   coupled cpus, usually the same as cpu_possible_mask if all cpus
   are part of the same cluster.  The coupled_cpus mask must be
   set in the struct cpuidle_device for each cpu.

   Set struct cpuidle_device.safe_state to a state that is not a
   coupled state.  This is usually WFI.

   Set CPUIDLE_FLAG_COUPLED in struct cpuidle_state.flags for each
   state that affects multiple cpus.

   Provide a struct cpuidle_state.enter function for each state
   that affects multiple cpus.  This function is guaranteed to be
   called on all cpus at approximately the same time.  The driver
   should ensure that the cpus all abort together if any cpu tries
   to abort once the function is called.

Signed-off-by: Colin Cross <ccross@android.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Amit Kucheria <amit.kucheria@linaro.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Trinabh Gupta <g.trinabh@gmail.com>
Cc: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
---
 drivers/cpuidle/Kconfig   |    3 +
 drivers/cpuidle/Makefile  |    1 +
 drivers/cpuidle/coupled.c |  413 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/cpuidle/cpuidle.c |   14 ++-
 drivers/cpuidle/cpuidle.h |   39 +++++
 include/linux/cpuidle.h   |    7 +
 6 files changed, 476 insertions(+), 1 deletions(-)
 create mode 100644 drivers/cpuidle/coupled.c

diff --git a/drivers/cpuidle/Kconfig b/drivers/cpuidle/Kconfig
index 7dbc4a8..7a72e55 100644
--- a/drivers/cpuidle/Kconfig
+++ b/drivers/cpuidle/Kconfig
@@ -18,3 +18,6 @@ config CPU_IDLE_GOV_MENU
 	bool
 	depends on CPU_IDLE && NO_HZ
 	default y
+
+config ARCH_NEEDS_CPU_IDLE_COUPLED
+	def_bool n
diff --git a/drivers/cpuidle/Makefile b/drivers/cpuidle/Makefile
index 5634f88..38c8f69 100644
--- a/drivers/cpuidle/Makefile
+++ b/drivers/cpuidle/Makefile
@@ -3,3 +3,4 @@
 #
 
 obj-y += cpuidle.o driver.o governor.o sysfs.o governors/
+obj-$(CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED) += coupled.o
diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
new file mode 100644
index 0000000..3fb7d24
--- /dev/null
+++ b/drivers/cpuidle/coupled.c
@@ -0,0 +1,413 @@
+/*
+ * coupled.c - helper functions to enter the same idle state on multiple cpus
+ *
+ * Copyright (c) 2011 Google, Inc.
+ *
+ * Author: Colin Cross <ccross@android.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/cpu.h>
+#include <linux/cpuidle.h>
+#include <linux/mutex.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+
+#include "cpuidle.h"
+
+/*
+ * coupled cpuidle states
+ *
+ * On some ARM SMP SoCs (OMAP4460, Tegra 2, and probably more), the
+ * cpus cannot be independently powered down, either due to
+ * sequencing restrictions (on Tegra 2, cpu 0 must be the last to
+ * power down), or due to HW bugs (on OMAP4460, a cpu powering up
+ * will corrupt the gic state unless the other cpu runs a work
+ * around).  Each cpu has a power state that it can enter without
+ * coordinating with the other cpu (usually Wait For Interrupt, or
+ * WFI), and one or more "coupled" power states that affect blocks
+ * shared between the cpus (L2 cache, interrupt controller, and
+ * sometimes the whole SoC).  Entering a coupled power state must
+ * be tightly controlled on both cpus.
+ *
+ * The easiest solution to implementing coupled cpu power states is
+ * to hotplug all but one cpu whenever possible, usually using a
+ * cpufreq governor that looks at cpu load to determine when to
+ * enable the secondary cpus.  This causes problems, as hotplug is an
+ * expensive operation, so the number of hotplug transitions must be
+ * minimized, leading to very slow response to loads, often on the
+ * order of seconds.
+ *
+ * This file implements an alternative solution, where each cpu will
+ * wait in the WFI state until all cpus are ready to enter a coupled
+ * state, at which point the coupled state function will be called
+ * on all cpus at approximately the same time.
+ *
+ * Once all cpus are ready to enter idle, they are woken by an smp
+ * cross call.  At this point, there is a chance that one of the
+ * cpus will find work to do, and choose not to enter suspend.  A
+ * final pass is needed to guarantee that all cpus will call the
+ * power state enter function at the same time.  During this pass,
+ * each cpu will increment the ready counter, and continue once the
+ * ready counter matches the number of online coupled cpus.  If any
+ * cpu exits idle, the other cpus will decrement their counter and
+ * retry.
+ *
+ * To use coupled cpuidle states, a cpuidle driver must:
+ *
+ *    Set struct cpuidle_device.coupled_cpus to the mask of all
+ *    coupled cpus, usually the same as cpu_possible_mask if all cpus
+ *    are part of the same cluster.  The coupled_cpus mask must be
+ *    set in the struct cpuidle_device for each cpu.
+ *
+ *    Set struct cpuidle_device.safe_state to a state that is not a
+ *    coupled state.  This is usually WFI.
+ *
+ *    Set CPUIDLE_FLAG_COUPLED in struct cpuidle_state.flags for each
+ *    state that affects multiple cpus.
+ *
+ *    Provide a struct cpuidle_state.enter function for each state
+ *    that affects multiple cpus.  This function is guaranteed to be
+ *    called on all cpus at approximately the same time.  The driver
+ *    should ensure that the cpus all abort together if any cpu tries
+ *    to abort once the function is called.
+ *
+ */
+
+static DEFINE_MUTEX(cpuidle_coupled_lock);
+static DEFINE_PER_CPU(struct call_single_data, cpuidle_coupled_poke_cb);
+static cpumask_t cpuidle_coupled_poked_mask;
+
+/**
+ * cpuidle_state_is_coupled
+ *
+ * Returns true if the target state is coupled with cpus besides this one
+ */
+bool cpuidle_state_is_coupled(struct cpuidle_device *dev,
+	struct cpuidle_driver *drv, int state)
+{
+	return drv->states[state].flags & CPUIDLE_FLAG_COUPLED;
+}
+
+/**
+ * cpuidle_all_coupled_cpus_idle
+ *
+ * Returns true if all cpus coupled to this target state are idle
+ */
+static inline bool
+cpuidle_coupled_cpus_idle(struct cpuidle_coupled *coupled)
+{
+	int i;
+
+	assert_spin_locked(&coupled->lock);
+
+	smp_rmb();
+
+	for_each_cpu_mask(i, coupled->alive_coupled_cpus)
+		if (coupled->requested_state[i] < 0)
+			return false;
+
+	return true;
+}
+
+/**
+ * cpuidle_get_idle_state
+ *
+ * Returns the deepest idle state that all coupled cpus can enter
+ */
+static inline int cpuidle_coupled_get_state(struct cpuidle_device *dev,
+		struct cpuidle_coupled *coupled)
+{
+	int i;
+	int state = INT_MAX;
+
+	assert_spin_locked(&coupled->lock);
+
+	for_each_cpu_mask(i, coupled->alive_coupled_cpus)
+		if (coupled->requested_state[i] < state)
+			state = coupled->requested_state[i];
+
+	BUG_ON(state >= dev->state_count || state < 0);
+
+	return state;
+}
+
+static void cpuidle_coupled_poked(void *info)
+{
+	int cpu = (unsigned long)info;
+	cpumask_clear_cpu(cpu, &cpuidle_coupled_poked_mask);
+}
+
+static void cpuidle_coupled_poke(int cpu)
+{
+	struct call_single_data *csd = &per_cpu(cpuidle_coupled_poke_cb, cpu);
+	if (cpu_online(cpu))
+		if (!cpumask_test_and_set_cpu(cpu, &cpuidle_coupled_poked_mask))
+			__smp_call_function_single(cpu, csd, 0);
+}
+
+/**
+ * cpuidle_coupled_update_state
+ *
+ * Updates the requested idle state for the specified cpuidle device,
+ * poking all coupled cpus out of idle to let them see the new state.
+ */
+static void cpuidle_coupled_update_state(struct cpuidle_device *dev,
+		struct cpuidle_coupled *coupled, int next_state)
+{
+	int cpu;
+
+	assert_spin_locked(&coupled->lock);
+
+	coupled->requested_state[dev->cpu] = next_state;
+	smp_wmb();
+
+	if (next_state >= 0)
+		for_each_cpu_mask(cpu, coupled->alive_coupled_cpus)
+			if (cpu != dev->cpu)
+				cpuidle_coupled_poke(cpu);
+}
+
+/**
+ * cpuidle_enter_state_coupled
+ *
+ * Coordinate with coupled cpus to enter the target state.  This is a two
+ * stage process.  In the first stage, the cpus are operating independently,
+ * and may call into cpuidle_enter_state_coupled at completely different times.
+ * To save as much power as possible, the first cpus to call this function will
+ * go to an intermediate state (the cpuidle_device's safe state), and wait for
+ * all the other cpus to call this function.  Once all coupled cpus are idle,
+ * the second stage will start.  Each coupled cpu will spin until all cpus have
+ * guaranteed that they will call the target_state.
+ */
+int cpuidle_enter_state_coupled(struct cpuidle_device *dev,
+		struct cpuidle_driver *drv, int next_state)
+{
+	int entered_state = -1;
+	struct cpuidle_coupled *coupled = dev->coupled;
+
+	spin_lock(&coupled->lock);
+	if (!cpumask_test_cpu(dev->cpu, &coupled->alive_coupled_cpus)) {
+		/*
+		 * somebody took us out of the online coupled cpus mask, we
+		 * must be on the way up or down
+		 */
+		spin_unlock(&coupled->lock);
+		return -1;
+	}
+
+	BUG_ON(coupled->ready_count);
+	cpuidle_coupled_update_state(dev, coupled, next_state);
+
+retry:
+	/*
+	 * Wait for all coupled cpus to be idle, using the deepest state
+	 * allowed for a single cpu.
+	 */
+	while (!need_resched() && !cpuidle_coupled_cpus_idle(coupled)) {
+		spin_unlock(&coupled->lock);
+
+		entered_state = cpuidle_enter_state(dev, drv,
+			dev->safe_state_index);
+
+		local_irq_enable();
+		cpu_relax();
+		local_irq_disable();
+
+		spin_lock(&coupled->lock);
+	}
+
+	/* give a chance to process any remaining pokes */
+	local_irq_enable();
+	cpu_relax();
+	local_irq_disable();
+
+	if (need_resched()) {
+		cpuidle_coupled_update_state(dev, coupled, -1);
+		goto out;
+	}
+
+	/*
+	 * All coupled cpus are probably idle.  There is a small chance that
+	 * one of the other cpus just became active.  Increment a counter when
+	 * ready, and spin until all coupled cpus have incremented the counter.
+	 * Once a cpu has incremented the counter, it cannot abort idle and must
+	 * spin until either the count has hit num_online_cpus(), or another
+	 * cpu leaves idle.
+	 */
+
+	coupled->ready_count++;
+
+	while (coupled->ready_count !=
+			cpumask_weight(&coupled->alive_coupled_cpus)) {
+		if (!cpuidle_coupled_cpus_idle(coupled)) {
+			coupled->ready_count--;
+			goto retry;
+		}
+
+		spin_unlock(&coupled->lock);
+		cpu_relax();
+		spin_lock(&coupled->lock);
+	}
+
+	/* all cpus have acked the coupled state */
+	next_state = cpuidle_coupled_get_state(dev, coupled);
+	spin_unlock(&coupled->lock);
+
+	entered_state = cpuidle_enter_state(dev, drv, next_state);
+
+	spin_lock(&coupled->lock);
+
+	cpuidle_coupled_update_state(dev, coupled, -1);
+	coupled->ready_count--;
+
+out:
+	local_irq_enable();
+
+	while (coupled->ready_count > 0) {
+		spin_unlock(&coupled->lock);
+		cpu_relax();
+		spin_lock(&coupled->lock);
+	}
+
+	spin_unlock(&coupled->lock);
+
+	return entered_state;
+}
+
+/**
+ * cpuidle_coupled_register_device
+ *
+ * Called from cpuidle_register_device to handle coupled idle init.  Finds the
+ * cpuidle_coupled struct for this set of coupled cpus, or creates one if none
+ * exists yet.
+ */
+int cpuidle_coupled_register_device(struct cpuidle_device *dev)
+{
+	int cpu;
+	struct cpuidle_device *other_dev;
+	struct call_single_data *csd;
+
+	if (cpumask_empty(&dev->coupled_cpus))
+		return 0;
+
+	for_each_cpu_mask(cpu, dev->coupled_cpus) {
+		other_dev = per_cpu(cpuidle_devices, cpu);
+		if (other_dev && other_dev->coupled) {
+			BUG_ON(!cpumask_equal(&dev->coupled_cpus,
+				&other_dev->coupled_cpus));
+			dev->coupled = other_dev->coupled;
+			goto have_coupled;
+		}
+	}
+
+	/* No existing coupled info found, create a new one */
+	dev->coupled = kzalloc(sizeof(struct cpuidle_coupled), GFP_KERNEL);
+	if (!dev->coupled)
+		return -ENOMEM;
+
+	spin_lock_init(&dev->coupled->lock);
+
+have_coupled:
+	spin_lock(&dev->coupled->lock);
+
+	dev->coupled->requested_state[dev->cpu] = -1;
+
+	if (cpu_online(dev->cpu))
+		cpumask_set_cpu(dev->cpu, &dev->coupled->alive_coupled_cpus);
+	dev->coupled->refcnt++;
+
+	csd = &per_cpu(cpuidle_coupled_poke_cb, dev->cpu);
+	csd->func = cpuidle_coupled_poked;
+	csd->info = (void *)(unsigned long)dev->cpu;
+
+	spin_unlock(&dev->coupled->lock);
+
+	return 0;
+}
+
+/**
+ * cpuidle_coupled_unregister_device
+ *
+ * Called from cpuidle_unregister_device to tear down coupled idle.  Removes the
+ * cpu from the coupled idle set, and frees the cpuidle_coupled_info struct if
+ * this was the last cpu in the set.
+ */
+void cpuidle_coupled_unregister_device(struct cpuidle_device *dev)
+{
+	if (cpumask_empty(&dev->coupled_cpus))
+		return;
+
+	cpumask_clear_cpu(dev->cpu, &dev->coupled->alive_coupled_cpus);
+	if (--dev->coupled->refcnt)
+		kfree(dev->coupled);
+
+	dev->coupled = NULL;
+}
+
+static void cpuidle_coupled_cpu_set_alive(int cpu, bool online)
+{
+	struct cpuidle_device *dev;
+
+	mutex_lock(&cpuidle_lock);
+
+	dev = per_cpu(cpuidle_devices, cpu);
+	if (!dev->coupled)
+		goto out;
+
+	spin_lock(&dev->coupled->lock);
+
+	if (online)
+		cpumask_set_cpu(dev->cpu, &dev->coupled->alive_coupled_cpus);
+	else
+		cpumask_clear_cpu(dev->cpu, &dev->coupled->alive_coupled_cpus);
+
+	spin_unlock(&dev->coupled->lock);
+
+out:
+	mutex_unlock(&cpuidle_lock);
+}
+
+/**
+ * cpuidle_coupled_cpu_notify
+ *
+ * Called when a cpu is brought on or offline using hotplug.  Updates the
+ * coupled cpu set appropriately
+ */
+static int cpuidle_coupled_cpu_notify(struct notifier_block *nb,
+		unsigned long action, void *hcpu)
+{
+	int cpu = (unsigned long)hcpu;
+
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_DEAD:
+	case CPU_UP_CANCELED:
+		cpuidle_coupled_cpu_set_alive(cpu, false);
+		break;
+	case CPU_UP_PREPARE:
+		cpuidle_coupled_cpu_set_alive(cpu, true);
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block cpuidle_coupled_cpu_notifier = {
+	.notifier_call = cpuidle_coupled_cpu_notify,
+};
+
+static int __init cpuidle_coupled_init(void)
+{
+	return register_cpu_notifier(&cpuidle_coupled_cpu_notifier);
+}
+core_initcall(cpuidle_coupled_init);
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index ea00a16..e3d61b2 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -122,7 +122,10 @@ int cpuidle_idle_call(void)
 	trace_power_start(POWER_CSTATE, next_state, dev->cpu);
 	trace_cpu_idle(next_state, dev->cpu);
 
-	entered_state = cpuidle_enter_state(dev, drv, next_state);
+	if (cpuidle_state_is_coupled(dev, drv, next_state))
+		entered_state = cpuidle_enter_state_coupled(dev, drv, next_state);
+	else
+		entered_state = cpuidle_enter_state(dev, drv, next_state);
 
 	trace_power_end(dev->cpu);
 	trace_cpu_idle(PWR_EVENT_EXIT, dev->cpu);
@@ -322,9 +325,16 @@ static int __cpuidle_register_device(struct cpuidle_device *dev)
 	if (ret)
 		goto err_sysfs;
 
+	ret = cpuidle_coupled_register_device(dev);
+	if (ret)
+		goto err_coupled;
+
 	dev->registered = 1;
 	return 0;
 
+err_coupled:
+	cpuidle_remove_sysfs(sys_dev);
+	wait_for_completion(&dev->kobj_unregister);
 err_sysfs:
 	module_put(cpuidle_driver->owner);
 	list_del(&dev->device_list);
@@ -379,6 +389,8 @@ void cpuidle_unregister_device(struct cpuidle_device *dev)
 	wait_for_completion(&dev->kobj_unregister);
 	per_cpu(cpuidle_devices, dev->cpu) = NULL;
 
+	cpuidle_coupled_unregister_device(dev);
+
 	cpuidle_resume_and_unlock();
 
 	module_put(cpuidle_driver->owner);
diff --git a/drivers/cpuidle/cpuidle.h b/drivers/cpuidle/cpuidle.h
index dd2df8f..55a0c6f 100644
--- a/drivers/cpuidle/cpuidle.h
+++ b/drivers/cpuidle/cpuidle.h
@@ -32,4 +32,43 @@ extern void cpuidle_remove_state_sysfs(struct cpuidle_device *device);
 extern int cpuidle_add_sysfs(struct sys_device *sysdev);
 extern void cpuidle_remove_sysfs(struct sys_device *sysdev);
 
+/* coupled states */
+struct cpuidle_coupled {
+	spinlock_t lock;
+	int requested_state[NR_CPUS];
+	int ready_count;
+	cpumask_t alive_coupled_cpus;
+	int refcnt;
+};
+
+#ifdef CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED
+bool cpuidle_state_is_coupled(struct cpuidle_device *dev,
+		struct cpuidle_driver *drv, int state);
+int cpuidle_enter_state_coupled(struct cpuidle_device *dev,
+		struct cpuidle_driver *drv, int next_state);
+int cpuidle_coupled_register_device(struct cpuidle_device *dev);
+void cpuidle_coupled_unregister_device(struct cpuidle_device *dev);
+#else
+static inline bool cpuidle_state_is_coupled(struct cpuidle_device *dev,
+		struct cpuidle_driver *drv, int state)
+{
+	return false;
+}
+
+static inline int cpuidle_enter_state_coupled(struct cpuidle_device *dev,
+		struct cpuidle_driver *drv, int next_state)
+{
+	return -1;
+}
+
+static inline int cpuidle_coupled_register_device(struct cpuidle_device *dev)
+{
+	return 0;
+}
+
+static inline void cpuidle_coupled_unregister_device(struct cpuidle_device *dev)
+{
+}
+#endif
+
 #endif /* __DRIVER_CPUIDLE_H */
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 7408af8..5438a09 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -53,6 +53,7 @@ struct cpuidle_state {
 
 /* Idle State Flags */
 #define CPUIDLE_FLAG_TIME_VALID	(0x01) /* is residency time measurable? */
+#define CPUIDLE_FLAG_COUPLED	(0x02) /* state applies to multiple cpus */
 
 #define CPUIDLE_DRIVER_FLAGS_MASK (0xFFFF0000)
 
@@ -97,6 +98,12 @@ struct cpuidle_device {
 	struct kobject		kobj;
 	struct completion	kobj_unregister;
 	void			*governor_data;
+
+#ifdef CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED
+	int			safe_state_index;
+	cpumask_t		coupled_cpus;
+	struct cpuidle_coupled	*coupled;
+#endif
 };
 
 DECLARE_PER_CPU(struct cpuidle_device *, cpuidle_devices);
-- 
1.7.4.1

