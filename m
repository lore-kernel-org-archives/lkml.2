Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab1CVMs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 08:48:26 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:41602 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923Ab1CVMsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 08:48:23 -0400
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Subject: [RFC PATCH V1 2/2] cpuidle: API changes in callers using new
	cpuidle_state_stats
To: arjan@linux.intel.com, peterz@infradead.org, lenb@kernel.org,
        suresh.b.siddha@intel.com, benh@kernel.crashing.org, venki@google.com,
        ak@linux.intel.com
Cc: linux-kernel@vger.kernel.org
Date: Tue, 22 Mar 2011 18:18:17 +0530
Message-ID: <20110322124807.29408.96250.stgit@tringupt.in.ibm.com>
In-Reply-To: <20110322124724.29408.12885.stgit@tringupt.in.ibm.com>
References: <20110322124724.29408.12885.stgit@tringupt.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpuidle subsystem users will need to use struct cpuidle_state *state
and struct cpuidle_state_stats *state_stats.

Driver's per-cpu context is stored in cpuidle_state_stats for this
RFC. This need to be moved into cpuidle_driver.

Signed-off-by: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
---

 drivers/acpi/processor_driver.c    |   19 +---
 drivers/acpi/processor_idle.c      |   49 +++++++---
 drivers/cpuidle/cpuidle.c          |  170 +++++++++++++++++++++++-------------
 drivers/cpuidle/cpuidle.h          |    4 -
 drivers/cpuidle/driver.c           |   24 -----
 drivers/cpuidle/governor.c         |   10 +-
 drivers/cpuidle/governors/Makefile |    2 
 drivers/cpuidle/governors/menu.c   |   19 ++--
 drivers/cpuidle/sysfs.c            |   63 +++++++------
 drivers/idle/default_driver.c      |   40 +++-----
 10 files changed, 210 insertions(+), 190 deletions(-)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index 360a74e..4837861 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -503,9 +503,7 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
 	acpi_processor_get_throttling_info(pr);
 	acpi_processor_get_limit_info(pr);
 
-
-	if (cpuidle_get_driver() == &acpi_idle_driver)
-		acpi_processor_power_init(pr, device);
+	acpi_processor_power_init(pr, device);
 
 	pr->cdev = thermal_cooling_device_register("Processor", device,
 						&processor_cooling_ops);
@@ -800,17 +798,9 @@ static int __init acpi_processor_init(void)
 
 	memset(&errata, 0, sizeof(errata));
 
-	if (!cpuidle_register_driver(&acpi_idle_driver)) {
-		printk(KERN_DEBUG "ACPI: %s registered with cpuidle\n",
-			acpi_idle_driver.name);
-	} else {
-		printk(KERN_DEBUG "ACPI: acpi_idle yielding to %s\n",
-			cpuidle_get_driver()->name);
-	}
-
 	result = acpi_bus_register_driver(&acpi_processor_driver);
 	if (result < 0)
-		goto out_cpuidle;
+		goto out;
 
 	acpi_processor_install_hotplug_notify();
 
@@ -822,8 +812,7 @@ static int __init acpi_processor_init(void)
 
 	return 0;
 
-out_cpuidle:
-	cpuidle_unregister_driver(&acpi_idle_driver);
+out:
 
 	return result;
 }
@@ -841,8 +830,6 @@ static void __exit acpi_processor_exit(void)
 
 	acpi_bus_unregister_driver(&acpi_processor_driver);
 
-	cpuidle_unregister_driver(&acpi_idle_driver);
-
 	return;
 }
 
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 65dde00..407acd7 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -746,12 +746,13 @@ static inline void acpi_idle_do_entry(struct acpi_processor_cx *cx)
  * This is equivalent to the HALT instruction.
  */
 static int acpi_idle_enter_c1(struct cpuidle_device *dev,
-			      struct cpuidle_state *state)
+			      struct cpuidle_state *state,
+				struct cpuidle_state_stats *state_stats)
 {
 	ktime_t  kt1, kt2;
 	s64 idle_time;
 	struct acpi_processor *pr;
-	struct acpi_processor_cx *cx = cpuidle_get_statedata(state);
+	struct acpi_processor_cx *cx = cpuidle_get_statedata(state_stats);
 
 	pr = __this_cpu_read(processors);
 
@@ -786,13 +787,14 @@ static int acpi_idle_enter_c1(struct cpuidle_device *dev,
  * @state: the state data
  */
 static int acpi_idle_enter_simple(struct cpuidle_device *dev,
-				  struct cpuidle_state *state)
+				  struct cpuidle_state *state,
+				struct cpuidle_state_stats *state_stats)
 {
 	struct acpi_processor *pr;
-	struct acpi_processor_cx *cx = cpuidle_get_statedata(state);
 	ktime_t  kt1, kt2;
 	s64 idle_time_ns;
 	s64 idle_time;
+	struct acpi_processor_cx *cx = cpuidle_get_statedata(state_stats);
 
 	pr = __this_cpu_read(processors);
 
@@ -800,7 +802,7 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 		return 0;
 
 	if (acpi_idle_suspend)
-		return(acpi_idle_enter_c1(dev, state));
+		return acpi_idle_enter_c1(dev, state, state_stats);
 
 	local_irq_disable();
 
@@ -862,14 +864,15 @@ static DEFINE_SPINLOCK(c3_lock);
  * If BM is detected, the deepest non-C3 idle state is entered instead.
  */
 static int acpi_idle_enter_bm(struct cpuidle_device *dev,
-			      struct cpuidle_state *state)
+			      struct cpuidle_state *state,
+				struct cpuidle_state_stats *state_stats)
 {
 	struct acpi_processor *pr;
-	struct acpi_processor_cx *cx = cpuidle_get_statedata(state);
 	ktime_t  kt1, kt2;
 	s64 idle_time_ns;
 	s64 idle_time;
-
+	struct cpuidle_device_stats *dev_stats;
+	struct acpi_processor_cx *cx = cpuidle_get_statedata(state_stats);
 
 	pr = __this_cpu_read(processors);
 
@@ -877,12 +880,15 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 		return 0;
 
 	if (acpi_idle_suspend)
-		return(acpi_idle_enter_c1(dev, state));
+		return acpi_idle_enter_c1(dev, state, state_stats);
 
 	if (!cx->bm_sts_skip && acpi_idle_bm_check()) {
 		if (dev->safe_state) {
-			dev->last_state = dev->safe_state;
-			return dev->safe_state->enter(dev, dev->safe_state);
+			dev_stats = &per_cpu(cpuidle_dev_stats,
+						smp_processor_id());
+			dev_stats->last_state = dev->safe_state;
+			return dev->safe_state->enter(dev, dev->safe_state,
+							state_stats);
 		} else {
 			local_irq_disable();
 			acpi_safe_halt();
@@ -983,6 +989,7 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
 	int i, count = CPUIDLE_DRIVER_STATE_START;
 	struct acpi_processor_cx *cx;
 	struct cpuidle_state *state;
+	struct cpuidle_state_stats *state_stats;
 	struct cpuidle_device *dev = &pr->power.dev;
 
 	if (!pr->flags.power_setup_done)
@@ -992,7 +999,6 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
 		return -EINVAL;
 	}
 
-	dev->cpu = pr->id;
 	dev->drv = &acpi_idle_driver;
 	for (i = 0; i < CPUIDLE_STATE_MAX; i++) {
 		dev->states[i].name[0] = '\0';
@@ -1005,6 +1011,12 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
 	for (i = 1; i < ACPI_PROCESSOR_MAX_POWER && i <= max_cstate; i++) {
 		cx = &pr->power.states[i];
 		state = &dev->states[count];
+		/*
+		 * To Do: driver_data would have to be made per
+		 * cpuidle driver. It works as there is just one
+		 * driver using this.
+		 * */
+		state_stats = get_cpuidle_state_stats(pr->id, count);
 
 		if (!cx->valid)
 			continue;
@@ -1015,7 +1027,7 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
 		    !(acpi_gbl_FADT.flags & ACPI_FADT_C2_MP_SUPPORTED))
 			continue;
 #endif
-		cpuidle_set_statedata(state, cx);
+		cpuidle_set_statedata(state_stats, cx);
 
 		snprintf(state->name, CPUIDLE_NAME_LEN, "C%d", i);
 		strncpy(state->desc, cx->desc, CPUIDLE_DESC_LEN);
@@ -1127,10 +1139,15 @@ int __cpuinit acpi_processor_power_init(struct acpi_processor *pr,
 	 * Note that we use previously set idle handler will be used on
 	 * platforms that only support C1.
 	 */
-	if (pr->flags.power) {
+	if (pr->flags.power)
 		acpi_processor_setup_cpuidle(pr);
-		if (cpuidle_register_device(&pr->power.dev))
-			return -EIO;
+	/*
+	 * Driver registration has to be done by last cpu.
+	 * To Do: Remove hard coded cpu number.
+	 */
+	if (pr->flags.power && pr->id == (num_online_cpus() - 1)) {
+		acpi_idle_driver.dev = &pr->power.dev;
+		cpuidle_register_driver(&acpi_idle_driver);
 	}
 	return 0;
 }
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 5335598..a232845 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -21,10 +21,10 @@
 
 #include "cpuidle.h"
 
-DEFINE_PER_CPU(struct cpuidle_device *, cpuidle_devices);
+DEFINE_PER_CPU(struct cpuidle_device_stats, cpuidle_dev_stats);
+EXPORT_PER_CPU_SYMBOL(cpuidle_dev_stats);
 
 DEFINE_MUTEX(cpuidle_lock);
-LIST_HEAD(cpuidle_detected_devices);
 static void (*pm_idle_old)(void);
 
 static int enabled_devices;
@@ -41,6 +41,8 @@ static void cpuidle_kick_cpus(void) {}
 #endif
 
 static int __cpuidle_register_device(struct cpuidle_device *dev);
+static int __cpuidle_register_device_stats(
+		struct cpuidle_device_stats *dev_stats);
 
 /**
  * cpuidle_idle_call - the main idle loop
@@ -49,12 +51,16 @@ static int __cpuidle_register_device(struct cpuidle_device *dev);
  */
 void cpuidle_idle_call(void)
 {
-	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
+	struct cpuidle_device_stats *dev_stats = &per_cpu(cpuidle_dev_stats,
+							smp_processor_id());
+	struct cpuidle_device *dev;
 	struct cpuidle_state *target_state;
+	struct cpuidle_state_stats *target_state_stats;
+	struct cpuidle_driver *drv = cpuidle_get_driver();
 	int next_state;
 
 	/* check if the device is ready */
-	if (!dev || !dev->enabled) {
+	if (!drv || !drv->dev || !drv->dev->enabled) {
 		if (pm_idle_old)
 			pm_idle_old();
 		else
@@ -65,6 +71,7 @@ void cpuidle_idle_call(void)
 #endif
 		return;
 	}
+	dev = drv->dev;
 
 #if 0
 	/* shows regressions, re-enable for 2.6.29 */
@@ -83,37 +90,40 @@ void cpuidle_idle_call(void)
 	 * state availability, latencies, residencies, etc.
 	 */
 	if (dev->prepare)
-		dev->prepare(dev);
+		dev->prepare(dev_stats);
 
 	/* ask the governor for the next state */
-	next_state = cpuidle_curr_governor->select(dev);
+	next_state = cpuidle_curr_governor->select(dev, dev_stats);
 	if (need_resched()) {
 		local_irq_enable();
 		return;
 	}
 
 	target_state = &dev->states[next_state];
+	target_state_stats = &dev_stats->state_stats[next_state];
 
 	/* enter the state and update stats */
-	dev->last_state = target_state;
+	dev_stats->last_state = target_state;
 
-	trace_power_start(POWER_CSTATE, next_state, dev->cpu);
-	trace_cpu_idle(next_state, dev->cpu);
+	trace_power_start(POWER_CSTATE, next_state, dev_stats->cpu);
+	trace_cpu_idle(next_state, dev_stats->cpu);
 
-	dev->last_residency = target_state->enter(dev, target_state);
+	dev_stats->last_residency = target_state->enter(dev, target_state,
+							target_state_stats);
 
-	trace_power_end(dev->cpu);
-	trace_cpu_idle(PWR_EVENT_EXIT, dev->cpu);
+	trace_power_end(dev_stats->cpu);
+	trace_cpu_idle(PWR_EVENT_EXIT, dev_stats->cpu);
 
-	if (dev->last_state)
-		target_state = dev->last_state;
+	if (dev_stats->last_state)
+		target_state = dev_stats->last_state;
 
-	target_state->time += (unsigned long long)dev->last_residency;
-	target_state->usage++;
+	target_state_stats->time +=
+			(unsigned long long)dev_stats->last_residency;
+	target_state_stats->usage++;
 
 	/* give the governor an opportunity to reflect on the outcome */
 	if (cpuidle_curr_governor->reflect)
-		cpuidle_curr_governor->reflect(dev);
+		cpuidle_curr_governor->reflect(dev_stats);
 }
 
 #ifdef CONFIG_ARCH_USES_PMIDLE
@@ -167,7 +177,8 @@ void cpuidle_resume_and_unlock(void)
 EXPORT_SYMBOL_GPL(cpuidle_resume_and_unlock);
 
 #ifdef CONFIG_ARCH_HAS_CPU_RELAX
-static int poll_idle(struct cpuidle_device *dev, struct cpuidle_state *st)
+static int poll_idle(struct cpuidle_device *dev, struct cpuidle_state *st,
+			struct cpuidle_state_stats *st_stats)
 {
 	ktime_t	t1, t2;
 	s64 diff;
@@ -191,8 +202,6 @@ static void poll_idle_init(struct cpuidle_device *dev)
 {
 	struct cpuidle_state *state = &dev->states[0];
 
-	cpuidle_set_statedata(state, NULL);
-
 	snprintf(state->name, CPUIDLE_NAME_LEN, "POLL");
 	snprintf(state->desc, CPUIDLE_DESC_LEN, "CPUIDLE CORE POLL IDLE");
 	state->exit_latency = 0;
@@ -205,6 +214,28 @@ static void poll_idle_init(struct cpuidle_device *dev)
 static void poll_idle_init(struct cpuidle_device *dev) {}
 #endif /* CONFIG_ARCH_HAS_CPU_RELAX */
 
+static int cpuidle_enable_device_stats(struct cpuidle_device_stats *dev_stats)
+{
+	int ret, i;
+
+	if ((ret = cpuidle_add_state_sysfs(dev_stats)))
+		return ret;
+
+	if (cpuidle_curr_governor->enable &&
+		(ret = cpuidle_curr_governor->enable(dev_stats)))
+			return ret;
+
+	for (i = 0; i < dev_stats->drv->dev->state_count; i++) {
+		dev_stats->state_stats[i].usage = 0;
+		dev_stats->state_stats[i].time = 0;
+	}
+	dev_stats->last_residency = 0;
+	dev_stats->last_state = NULL;
+
+	smp_wmb();
+	return 0;
+}
+
 /**
  * cpuidle_enable_device - enables idle PM for a CPU
  * @dev: the CPU
@@ -231,35 +262,29 @@ int cpuidle_enable_device(struct cpuidle_device *dev)
 
 	poll_idle_init(dev);
 
-	if ((ret = cpuidle_add_state_sysfs(dev)))
-		return ret;
-
-	if (cpuidle_curr_governor->enable &&
-	    (ret = cpuidle_curr_governor->enable(dev)))
-		goto fail_sysfs;
-
-	for (i = 0; i < dev->state_count; i++) {
-		dev->states[i].usage = 0;
-		dev->states[i].time = 0;
+	for_each_online_cpu(i) {
+		cpuidle_enable_device_stats(&per_cpu(cpuidle_dev_stats, i));
 	}
-	dev->last_residency = 0;
-	dev->last_state = NULL;
 
 	smp_wmb();
 
 	dev->enabled = 1;
 
-	enabled_devices++;
 	return 0;
 
-fail_sysfs:
-	cpuidle_remove_state_sysfs(dev);
-
-	return ret;
 }
 
 EXPORT_SYMBOL_GPL(cpuidle_enable_device);
 
+static void cpuidle_disable_device_stats(struct cpuidle_device_stats *dev_stats)
+{
+	cpuidle_remove_state_sysfs(dev_stats);
+
+	if (cpuidle_curr_governor->disable)
+		cpuidle_curr_governor->disable(dev_stats);
+
+}
+
 /**
  * cpuidle_disable_device - disables idle PM for a CPU
  * @dev: the CPU
@@ -269,6 +294,8 @@ EXPORT_SYMBOL_GPL(cpuidle_enable_device);
  */
 void cpuidle_disable_device(struct cpuidle_device *dev)
 {
+	int i;
+
 	if (!dev->enabled)
 		return;
 	if (!cpuidle_get_driver() || !cpuidle_curr_governor)
@@ -276,15 +303,31 @@ void cpuidle_disable_device(struct cpuidle_device *dev)
 
 	dev->enabled = 0;
 
-	if (cpuidle_curr_governor->disable)
-		cpuidle_curr_governor->disable(dev);
+	for_each_online_cpu(i) {
+		cpuidle_disable_device_stats(&per_cpu(cpuidle_dev_stats, i));
+	}
 
-	cpuidle_remove_state_sysfs(dev);
-	enabled_devices--;
 }
 
 EXPORT_SYMBOL_GPL(cpuidle_disable_device);
 
+static int cpuidle_register_device_stats(struct cpuidle_device_stats *dev_stats)
+{
+	int ret;
+	struct sys_device *sys_dev =
+			get_cpu_sysdev((unsigned long)dev_stats->cpu);
+
+	if (!sys_dev)
+		return -EINVAL;
+
+	init_completion(&dev_stats->kobj_unregister);
+
+	if ((ret = cpuidle_add_sysfs(sys_dev)))
+		return ret;
+
+	return 0;
+}
+
 /**
  * __cpuidle_register_device - internal register function called before register
  * and enable routines
@@ -294,14 +337,10 @@ EXPORT_SYMBOL_GPL(cpuidle_disable_device);
  */
 static int __cpuidle_register_device(struct cpuidle_device *dev)
 {
-	int ret;
-	struct sys_device *sys_dev = get_cpu_sysdev((unsigned long)dev->cpu);
 	struct cpuidle_driver *cpuidle_driver = cpuidle_get_driver();
 
 	if (dev->registered)
 		return 0;
-	if (!sys_dev)
-		return -EINVAL;
 	/*
 	 * This will maintain compatibility with old cpuidle_device
 	 * structure where driver pointer is not set.
@@ -315,8 +354,6 @@ static int __cpuidle_register_device(struct cpuidle_device *dev)
 	if (!try_module_get(dev->drv->owner))
 		return -EINVAL;
 
-	init_completion(&dev->kobj_unregister);
-
 	/*
 	 * cpuidle driver should set the dev->power_specified bit
 	 * before registering the device if the driver provides
@@ -337,14 +374,6 @@ static int __cpuidle_register_device(struct cpuidle_device *dev)
 			dev->states[i].power_usage = -1 - i;
 	}
 
-	if (cpuidle_driver == dev->drv)
-		per_cpu(cpuidle_devices, dev->cpu) = dev;
-	list_add(&dev->device_list, &cpuidle_detected_devices);
-	if ((ret = cpuidle_add_sysfs(sys_dev))) {
-		module_put(dev->drv->owner);
-		return ret;
-	}
-
 	dev->registered = 1;
 	return 0;
 }
@@ -355,7 +384,8 @@ static int __cpuidle_register_device(struct cpuidle_device *dev)
  */
 int cpuidle_register_device(struct cpuidle_device *dev)
 {
-	int ret;
+	int ret, i;
+	struct cpuidle_device_stats *dev_stats;
 
 	mutex_lock(&cpuidle_lock);
 
@@ -364,6 +394,13 @@ int cpuidle_register_device(struct cpuidle_device *dev)
 		return ret;
 	}
 
+	for_each_online_cpu(i) {
+		dev_stats = &per_cpu(cpuidle_dev_stats, i);
+		dev_stats->cpu = i;
+		dev_stats->drv = cpuidle_get_driver();
+		cpuidle_register_device_stats(dev_stats);
+	}
+
 	cpuidle_enable_device(dev);
 	cpuidle_install_idle_handler();
 
@@ -375,14 +412,23 @@ int cpuidle_register_device(struct cpuidle_device *dev)
 
 EXPORT_SYMBOL_GPL(cpuidle_register_device);
 
+static void cpuidle_unregister_device_stats(
+				struct cpuidle_device_stats *dev_stats)
+{
+	struct sys_device *sys_dev =
+			get_cpu_sysdev((unsigned long)dev_stats->cpu);
+	cpuidle_remove_sysfs(sys_dev);
+	wait_for_completion(&dev_stats->kobj_unregister);
+}
+
+
 /**
  * cpuidle_unregister_device - unregisters a CPU's idle PM feature
  * @dev: the cpu
  */
 void cpuidle_unregister_device(struct cpuidle_device *dev)
 {
-	struct sys_device *sys_dev = get_cpu_sysdev((unsigned long)dev->cpu);
-	struct cpuidle_driver *cpuidle_driver = cpuidle_get_driver();
+	int i;
 
 	if (dev->registered == 0)
 		return;
@@ -390,11 +436,9 @@ void cpuidle_unregister_device(struct cpuidle_device *dev)
 	cpuidle_pause_and_lock();
 
 	cpuidle_disable_device(dev);
-
-	cpuidle_remove_sysfs(sys_dev);
-	wait_for_completion(&dev->kobj_unregister);
-	if (cpuidle_driver == dev->drv)
-		per_cpu(cpuidle_devices, dev->cpu) = NULL;
+	for_each_online_cpu(i) {
+		cpuidle_unregister_device_stats(&per_cpu(cpuidle_dev_stats, i));
+	}
 
 	cpuidle_resume_and_unlock();
 
diff --git a/drivers/cpuidle/cpuidle.h b/drivers/cpuidle/cpuidle.h
index 33e50d5..ea48dd8 100644
--- a/drivers/cpuidle/cpuidle.h
+++ b/drivers/cpuidle/cpuidle.h
@@ -24,8 +24,8 @@ extern int cpuidle_switch_governor(struct cpuidle_governor *gov);
 /* sysfs */
 extern int cpuidle_add_class_sysfs(struct sysdev_class *cls);
 extern void cpuidle_remove_class_sysfs(struct sysdev_class *cls);
-extern int cpuidle_add_state_sysfs(struct cpuidle_device *device);
-extern void cpuidle_remove_state_sysfs(struct cpuidle_device *device);
+extern int cpuidle_add_state_sysfs(struct cpuidle_device_stats *dev_stats);
+extern void cpuidle_remove_state_sysfs(struct cpuidle_device_stats *dev_stats);
 extern int cpuidle_add_sysfs(struct sys_device *sysdev);
 extern void cpuidle_remove_sysfs(struct sys_device *sysdev);
 
diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
index c235286..19b2000 100644
--- a/drivers/cpuidle/driver.c
+++ b/drivers/cpuidle/driver.c
@@ -38,18 +38,13 @@ static struct cpuidle_driver *select_cpuidle_driver(void)
 
 static void set_current_cpuidle_driver(struct cpuidle_driver *drv)
 {
-	struct cpuidle_device *item = NULL;
 	if (drv == cpuidle_curr_driver)
 		return;
 
 	/* Unregister the previous drivers devices */
 	/* Do we need to take cpuidle_lock ? {un}register_device takes lock*/
 	if (cpuidle_curr_driver) {
-		list_for_each_entry(item, &cpuidle_detected_devices,
-			device_list) {
-			if (item->drv == cpuidle_curr_driver)
-				cpuidle_unregister_device(item);
-		}
+		cpuidle_unregister_device(cpuidle_curr_driver->dev);
 	}
 
 	cpuidle_curr_driver = drv;
@@ -57,12 +52,7 @@ static void set_current_cpuidle_driver(struct cpuidle_driver *drv)
 	if (drv == NULL)
 		return;
 	else {
-		/* Register the new driver devices */
-		list_for_each_entry(item, &cpuidle_detected_devices,
-			device_list) {
-			if (item->drv == drv)
-				cpuidle_register_device(item);
-		}
+		cpuidle_register_device(drv->dev);
 	}
 }
 
@@ -143,8 +133,6 @@ EXPORT_SYMBOL_GPL(cpuidle_get_driver);
  */
 void cpuidle_unregister_driver(struct cpuidle_driver *drv)
 {
-	struct cpuidle_device *item = NULL;
-
 	if (arch_allow_unregister(drv))
 		return;
 
@@ -154,14 +142,6 @@ void cpuidle_unregister_driver(struct cpuidle_driver *drv)
 	list_del(&drv->driver_list);
 	set_current_cpuidle_driver(select_cpuidle_driver());
 
-	/* Delete all devices corresponding to this driver */
-	mutex_lock(&cpuidle_lock);
-	list_for_each_entry(item, &cpuidle_detected_devices, device_list) {
-		if (item->drv == drv)
-			list_del(&item->device_list);
-	}
-	mutex_unlock(&cpuidle_lock);
-
 	spin_unlock(&cpuidle_driver_lock);
 }
 
diff --git a/drivers/cpuidle/governor.c b/drivers/cpuidle/governor.c
index 724c164..c4bf5f0 100644
--- a/drivers/cpuidle/governor.c
+++ b/drivers/cpuidle/governor.c
@@ -43,7 +43,7 @@ static struct cpuidle_governor * __cpuidle_find_governor(const char *str)
  */
 int cpuidle_switch_governor(struct cpuidle_governor *gov)
 {
-	struct cpuidle_device *dev;
+	struct cpuidle_driver *cpuidle_driver = cpuidle_get_driver();
 
 	if (gov == cpuidle_curr_governor)
 		return 0;
@@ -51,8 +51,8 @@ int cpuidle_switch_governor(struct cpuidle_governor *gov)
 	cpuidle_uninstall_idle_handler();
 
 	if (cpuidle_curr_governor) {
-		list_for_each_entry(dev, &cpuidle_detected_devices, device_list)
-			cpuidle_disable_device(dev);
+		if (cpuidle_driver)
+			cpuidle_disable_device(cpuidle_driver->dev);
 		module_put(cpuidle_curr_governor->owner);
 	}
 
@@ -61,8 +61,8 @@ int cpuidle_switch_governor(struct cpuidle_governor *gov)
 	if (gov) {
 		if (!try_module_get(cpuidle_curr_governor->owner))
 			return -EINVAL;
-		list_for_each_entry(dev, &cpuidle_detected_devices, device_list)
-			cpuidle_enable_device(dev);
+		if (cpuidle_driver)
+			cpuidle_enable_device(cpuidle_driver->dev);
 		cpuidle_install_idle_handler();
 		printk(KERN_INFO "cpuidle: using governor %s\n", gov->name);
 	}
diff --git a/drivers/cpuidle/governors/Makefile b/drivers/cpuidle/governors/Makefile
index 1b51272..a2afe56 100644
--- a/drivers/cpuidle/governors/Makefile
+++ b/drivers/cpuidle/governors/Makefile
@@ -2,5 +2,5 @@
 # Makefile for cpuidle governors.
 #
 
-obj-$(CONFIG_CPU_IDLE_GOV_LADDER) += ladder.o
+obj-n += ladder.o
 obj-$(CONFIG_CPU_IDLE_GOV_MENU) += menu.o
diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index f508690..8de7b76 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -182,7 +182,8 @@ static inline int performance_multiplier(void)
 
 static DEFINE_PER_CPU(struct menu_device, menu_devices);
 
-static void menu_update(struct cpuidle_device *dev);
+static void menu_update(struct cpuidle_device *dev,
+			struct cpuidle_device_stats *dev_stats);
 
 /* This implements DIV_ROUND_CLOSEST but avoids 64 bit division */
 static u64 div_round64(u64 dividend, u32 divisor)
@@ -230,7 +231,8 @@ static void detect_repeating_patterns(struct menu_device *data)
  * menu_select - selects the next idle state to enter
  * @dev: the CPU
  */
-static int menu_select(struct cpuidle_device *dev)
+static int menu_select(struct cpuidle_device *dev,
+			struct cpuidle_device_stats *dev_stats)
 {
 	struct menu_device *data = &__get_cpu_var(menu_devices);
 	int latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
@@ -239,7 +241,7 @@ static int menu_select(struct cpuidle_device *dev)
 	int multiplier;
 
 	if (data->needs_update) {
-		menu_update(dev);
+		menu_update(dev, dev_stats);
 		data->needs_update = 0;
 	}
 
@@ -312,7 +314,7 @@ static int menu_select(struct cpuidle_device *dev)
  * NOTE: it's important to be fast here because this operation will add to
  *       the overall exit latency.
  */
-static void menu_reflect(struct cpuidle_device *dev)
+static void menu_reflect(struct cpuidle_device_stats *dev_stats)
 {
 	struct menu_device *data = &__get_cpu_var(menu_devices);
 	data->needs_update = 1;
@@ -322,11 +324,12 @@ static void menu_reflect(struct cpuidle_device *dev)
  * menu_update - attempts to guess what happened after entry
  * @dev: the CPU
  */
-static void menu_update(struct cpuidle_device *dev)
+static void menu_update(struct cpuidle_device *dev,
+			struct cpuidle_device_stats *dev_stats)
 {
 	struct menu_device *data = &__get_cpu_var(menu_devices);
 	int last_idx = data->last_state_idx;
-	unsigned int last_idle_us = cpuidle_get_last_residency(dev);
+	unsigned int last_idle_us = cpuidle_get_last_residency(dev_stats);
 	struct cpuidle_state *target = &dev->states[last_idx];
 	unsigned int measured_us;
 	u64 new_factor;
@@ -383,9 +386,9 @@ static void menu_update(struct cpuidle_device *dev)
  * menu_enable_device - scans a CPU's states and does setup
  * @dev: the CPU
  */
-static int menu_enable_device(struct cpuidle_device *dev)
+static int menu_enable_device(struct cpuidle_device_stats *dev_stats)
 {
-	struct menu_device *data = &per_cpu(menu_devices, dev->cpu);
+	struct menu_device *data = &per_cpu(menu_devices, dev_stats->cpu);
 
 	memset(data, 0, sizeof(struct menu_device));
 
diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
index 0310ffa..0737fea 100644
--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -157,8 +157,9 @@ void cpuidle_remove_class_sysfs(struct sysdev_class *cls)
 
 struct cpuidle_attr {
 	struct attribute attr;
-	ssize_t (*show)(struct cpuidle_device *, char *);
-	ssize_t (*store)(struct cpuidle_device *, const char *, size_t count);
+	ssize_t (*show)(struct cpuidle_device_stats *, char *);
+	ssize_t (*store)(struct cpuidle_device_stats *, const char *,
+							size_t count);
 };
 
 #define define_one_ro(_name, show) \
@@ -166,12 +167,12 @@ struct cpuidle_attr {
 #define define_one_rw(_name, show, store) \
 	static struct cpuidle_attr attr_##_name = __ATTR(_name, 0644, show, store)
 
-#define kobj_to_cpuidledev(k) container_of(k, struct cpuidle_device, kobj)
+#define kobj_to_cpuidledev(k) container_of(k, struct cpuidle_device_stats, kobj)
 #define attr_to_cpuidleattr(a) container_of(a, struct cpuidle_attr, attr)
 static ssize_t cpuidle_show(struct kobject * kobj, struct attribute * attr ,char * buf)
 {
 	int ret = -EIO;
-	struct cpuidle_device *dev = kobj_to_cpuidledev(kobj);
+	struct cpuidle_device_stats *dev = kobj_to_cpuidledev(kobj);
 	struct cpuidle_attr * cattr = attr_to_cpuidleattr(attr);
 
 	if (cattr->show) {
@@ -186,7 +187,7 @@ static ssize_t cpuidle_store(struct kobject * kobj, struct attribute * attr,
 		     const char * buf, size_t count)
 {
 	int ret = -EIO;
-	struct cpuidle_device *dev = kobj_to_cpuidledev(kobj);
+	struct cpuidle_device_stats *dev = kobj_to_cpuidledev(kobj);
 	struct cpuidle_attr * cattr = attr_to_cpuidleattr(attr);
 
 	if (cattr->store) {
@@ -204,7 +205,7 @@ static const struct sysfs_ops cpuidle_sysfs_ops = {
 
 static void cpuidle_sysfs_release(struct kobject *kobj)
 {
-	struct cpuidle_device *dev = kobj_to_cpuidledev(kobj);
+	struct cpuidle_device_stats *dev = kobj_to_cpuidledev(kobj);
 
 	complete(&dev->kobj_unregister);
 }
@@ -245,8 +246,11 @@ static ssize_t show_state_##_name(struct cpuidle_state *state, char *buf) \
 
 define_show_state_function(exit_latency)
 define_show_state_function(power_usage)
-define_show_state_ull_function(usage)
-define_show_state_ull_function(time)
+/*
+ * To Do: Show usage and time as well in
+ * sysfs; which are currently removed because
+ * of cpuidle_state structure split.
+ */
 define_show_state_str_function(name)
 define_show_state_str_function(desc)
 
@@ -254,16 +258,12 @@ define_one_state_ro(name, show_state_name);
 define_one_state_ro(desc, show_state_desc);
 define_one_state_ro(latency, show_state_exit_latency);
 define_one_state_ro(power, show_state_power_usage);
-define_one_state_ro(usage, show_state_usage);
-define_one_state_ro(time, show_state_time);
 
 static struct attribute *cpuidle_state_default_attrs[] = {
 	&attr_name.attr,
 	&attr_desc.attr,
 	&attr_latency.attr,
 	&attr_power.attr,
-	&attr_usage.attr,
-	&attr_time.attr,
 	NULL
 };
 
@@ -300,7 +300,8 @@ static struct kobj_type ktype_state_cpuidle = {
 	.release = cpuidle_state_sysfs_release,
 };
 
-static void inline cpuidle_free_state_kobj(struct cpuidle_device *device, int i)
+static inline void cpuidle_free_state_kobj(struct cpuidle_device_stats *device,
+								int i)
 {
 	kobject_put(&device->kobjs[i]->kobj);
 	wait_for_completion(&device->kobjs[i]->kobj_unregister);
@@ -312,34 +313,35 @@ static void inline cpuidle_free_state_kobj(struct cpuidle_device *device, int i)
  * cpuidle_add_driver_sysfs - adds driver-specific sysfs attributes
  * @device: the target device
  */
-int cpuidle_add_state_sysfs(struct cpuidle_device *device)
+int cpuidle_add_state_sysfs(struct cpuidle_device_stats *dev_stats)
 {
 	int i, ret = -ENOMEM;
 	struct cpuidle_state_kobj *kobj;
 
 	/* state statistics */
-	for (i = 0; i < device->state_count; i++) {
+	for (i = 0; i < dev_stats->drv->dev->state_count; i++) {
 		kobj = kzalloc(sizeof(struct cpuidle_state_kobj), GFP_KERNEL);
 		if (!kobj)
 			goto error_state;
-		kobj->state = &device->states[i];
+		kobj->state = &dev_stats->drv->dev->states[i];
 		init_completion(&kobj->kobj_unregister);
 
-		ret = kobject_init_and_add(&kobj->kobj, &ktype_state_cpuidle, &device->kobj,
-					   "state%d", i);
+		ret = kobject_init_and_add(&kobj->kobj, &ktype_state_cpuidle,
+						&dev_stats->kobj,
+						"state%d", i);
 		if (ret) {
 			kfree(kobj);
 			goto error_state;
 		}
 		kobject_uevent(&kobj->kobj, KOBJ_ADD);
-		device->kobjs[i] = kobj;
+		dev_stats->kobjs[i] = kobj;
 	}
 
 	return 0;
 
 error_state:
 	for (i = i - 1; i >= 0; i--)
-		cpuidle_free_state_kobj(device, i);
+		cpuidle_free_state_kobj(dev_stats, i);
 	return ret;
 }
 
@@ -347,12 +349,12 @@ error_state:
  * cpuidle_remove_driver_sysfs - removes driver-specific sysfs attributes
  * @device: the target device
  */
-void cpuidle_remove_state_sysfs(struct cpuidle_device *device)
+void cpuidle_remove_state_sysfs(struct cpuidle_device_stats *dev_stats)
 {
 	int i;
 
-	for (i = 0; i < device->state_count; i++)
-		cpuidle_free_state_kobj(device, i);
+	for (i = 0; i < dev_stats->drv->dev->state_count; i++)
+		cpuidle_free_state_kobj(dev_stats, i);
 }
 
 /**
@@ -362,14 +364,15 @@ void cpuidle_remove_state_sysfs(struct cpuidle_device *device)
 int cpuidle_add_sysfs(struct sys_device *sysdev)
 {
 	int cpu = sysdev->id;
-	struct cpuidle_device *dev;
+	struct cpuidle_device_stats *dev_stats;
 	int error;
 
-	dev = per_cpu(cpuidle_devices, cpu);
-	error = kobject_init_and_add(&dev->kobj, &ktype_cpuidle, &sysdev->kobj,
+	dev_stats = &per_cpu(cpuidle_dev_stats, cpu);
+	error = kobject_init_and_add(&dev_stats->kobj, &ktype_cpuidle,
+					&sysdev->kobj,
 				     "cpuidle");
 	if (!error)
-		kobject_uevent(&dev->kobj, KOBJ_ADD);
+		kobject_uevent(&dev_stats->kobj, KOBJ_ADD);
 	return error;
 }
 
@@ -380,8 +383,8 @@ int cpuidle_add_sysfs(struct sys_device *sysdev)
 void cpuidle_remove_sysfs(struct sys_device *sysdev)
 {
 	int cpu = sysdev->id;
-	struct cpuidle_device *dev;
+	struct cpuidle_device_stats *dev_stats;
 
-	dev = per_cpu(cpuidle_devices, cpu);
-	kobject_put(&dev->kobj);
+	dev_stats = &per_cpu(cpuidle_dev_stats, cpu);
+	kobject_put(&dev_stats->kobj);
 }
diff --git a/drivers/idle/default_driver.c b/drivers/idle/default_driver.c
index c8702b5..41ad63d 100644
--- a/drivers/idle/default_driver.c
+++ b/drivers/idle/default_driver.c
@@ -275,28 +275,32 @@ static void c1e_idle(void)
 }
 
 static int poll_idle_wrapper(struct cpuidle_device *dev,
-		struct cpuidle_state *state)
+		struct cpuidle_state *state,
+		struct cpuidle_state_stats *state_stats)
 {
 	poll_idle();
 	return 0;
 }
 
 static int mwait_idle_wrapper(struct cpuidle_device *dev,
-		struct cpuidle_state *state)
+		struct cpuidle_state *state,
+		struct cpuidle_state_stats *state_stats)
 {
 	mwait_idle();
 	return 0;
 }
 
 static int c1e_idle_wrapper(struct cpuidle_device *dev,
-		struct cpuidle_state *state)
+		struct cpuidle_state *state,
+		struct cpuidle_state_stats *state_stats)
 {
 	c1e_idle();
 	return 0;
 }
 
 int default_idle_wrapper(struct cpuidle_device *dev,
-		struct cpuidle_state *state)
+		struct cpuidle_state *state,
+		struct cpuidle_state_stats *state_stats)
 {
 	default_idle();
 	return 0;
@@ -305,7 +309,6 @@ int default_idle_wrapper(struct cpuidle_device *dev,
 static struct cpuidle_state state_poll = {
 		.name = "POLL",
 		.desc = "POLL",
-		.driver_data = (void *) 0x00,
 		.flags = CPUIDLE_FLAG_TIME_VALID,
 		.exit_latency = 1,
 		.target_residency = 1,
@@ -315,7 +318,6 @@ static struct cpuidle_state state_poll = {
 static struct cpuidle_state state_mwait = {
 		.name = "C1",
 		.desc = "MWAIT No Hints",
-		.driver_data = (void *) 0x01,
 		.flags = CPUIDLE_FLAG_TIME_VALID,
 		.exit_latency = 1,
 		.target_residency = 1,
@@ -325,7 +327,6 @@ static struct cpuidle_state state_mwait = {
 static struct cpuidle_state state_c1e = {
 		.name = "C1E",
 		.desc = "C1E",
-		.driver_data = (void *) 0x02,
 		.flags = CPUIDLE_FLAG_TIME_VALID,
 		.exit_latency = 1,
 		.target_residency = 1,
@@ -335,7 +336,6 @@ static struct cpuidle_state state_c1e = {
 struct cpuidle_state state_default_idle = {
 		.name = "DEFAULT-IDLE",
 		.desc = "Default idle routine",
-		.driver_data = (void *) 0x03,
 		.flags = CPUIDLE_FLAG_TIME_VALID,
 		.exit_latency = 1,
 		.target_residency = 1,
@@ -416,34 +416,20 @@ static struct cpuidle_driver default_idle_driver = {
 	.priority = 100,
 };
 
-static int setup_cpuidle(int cpu)
+static int __init default_idle_init(void)
 {
-	struct cpuidle_device *dev = kzalloc(sizeof(struct cpuidle_device),
-					GFP_KERNEL);
+	int retval;
 	int count = CPUIDLE_DRIVER_STATE_START;
-	dev->cpu = cpu;
+	struct cpuidle_device *dev = kzalloc(sizeof(struct cpuidle_device),
+						GFP_KERNEL);
 	dev->drv = &default_idle_driver;
-
-	BUG_ON(opt_state == NULL);
 	dev->states[count] = *opt_state;
 	count++;
-
 	dev->state_count = count;
 
-	if (cpuidle_register_device(dev))
-		return -EIO;
-	return 0;
-}
-
-static int __init default_idle_init(void)
-{
-	int retval, i;
+	default_idle_driver.dev = dev;
 	retval = cpuidle_register_driver(&default_idle_driver);
 
-	for_each_online_cpu(i) {
-		setup_cpuidle(i);
-	}
-
 	return 0;
 }
 

