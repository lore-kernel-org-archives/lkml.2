Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab1DKHRy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 03:17:54 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:51908 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab1DKHRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 03:17:53 -0400
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Subject: [RFC PATCH V2 4/4] Single/Global registration of idle states
To: linux-pm@lists.linux-foundation.org, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, rnayak@ti.com, karthik-dp@ti.com,
        magnus.damm@gmail.com
Date: Mon, 11 Apr 2011 12:47:47 +0530
Message-ID: <20110411071740.6348.68486.stgit@tringupt.in.ibm.com>
In-Reply-To: <20110411071508.6348.67918.stgit@tringupt.in.ibm.com>
References: <20110411071508.6348.67918.stgit@tringupt.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this patch there is single copy of cpuidle_states structure
instead of per-cpu. The statistics needed on per-cpu basis
by the governor are kept per-cpu. This simplifies the cpuidle
subsystem as state registration is done by single cpu only.
Having single copy of cpuidle_states saves memory. Rare case
of asymmetric C-states can be handled within the cpuidle driverand
architectures such as POWER do not have asymmetric C-states.

To Do:

1. Handle the case when idle states may change at run time
and acpi_processor_cst_has_changed() routine is called.

2. Handle acpi_processor_power_exit() correctly i.e. ensure
unregistration of cpuidle driver since registration is now
moved inside acpi_processor_power_init().


Signed-off-by: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
---

 drivers/acpi/processor_driver.c  |   18 +-----
 drivers/acpi/processor_idle.c    |  117 +++++++++++++++++++++++++++++++-------
 drivers/cpuidle/cpuidle.c        |   42 ++++----------
 drivers/cpuidle/driver.c         |   25 ++++++++
 drivers/cpuidle/governors/menu.c |   16 +++--
 drivers/cpuidle/sysfs.c          |    3 +
 include/linux/cpuidle.h          |   16 ++++-
 7 files changed, 156 insertions(+), 81 deletions(-)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index a4e0f1b..91464b4 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -503,8 +503,7 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
 	acpi_processor_get_throttling_info(pr);
 	acpi_processor_get_limit_info(pr);
 
-
-	if (cpuidle_get_driver() == &acpi_idle_driver)
+	if (!cpuidle_get_driver() || cpuidle_get_driver() == &acpi_idle_driver)
 		acpi_processor_power_init(pr, device);
 
 	pr->cdev = thermal_cooling_device_register("Processor", device,
@@ -800,17 +799,9 @@ static int __init acpi_processor_init(void)
 
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
+		return result;
 
 	acpi_processor_install_hotplug_notify();
 
@@ -821,11 +812,6 @@ static int __init acpi_processor_init(void)
 	acpi_processor_throttling_init();
 
 	return 0;
-
-out_cpuidle:
-	cpuidle_unregister_driver(&acpi_idle_driver);
-
-	return result;
 }
 
 static void __exit acpi_processor_exit(void)
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index bd29363..505355d 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -741,11 +741,13 @@ static inline void acpi_idle_do_entry(struct acpi_processor_cx *cx)
 /**
  * acpi_idle_enter_c1 - enters an ACPI C1 state-type
  * @dev: the target CPU
+ * @drv: cpuidle driver containing cpuidle state info
  * @index: index of target state
  *
  * This is equivalent to the HALT instruction.
  */
-static int acpi_idle_enter_c1(struct cpuidle_device *dev, int index)
+static int acpi_idle_enter_c1(struct cpuidle_device *dev,
+		struct cpuidle_driver *drv, int index)
 {
 	ktime_t  kt1, kt2;
 	s64 idle_time;
@@ -789,9 +791,11 @@ static int acpi_idle_enter_c1(struct cpuidle_device *dev, int index)
 /**
  * acpi_idle_enter_simple - enters an ACPI state without BM handling
  * @dev: the target CPU
+ * @drv: cpuidle driver with cpuidle state information
  * @index: the index of suggested state
  */
-static int acpi_idle_enter_simple(struct cpuidle_device *dev, int index)
+static int acpi_idle_enter_simple(struct cpuidle_device *dev,
+		struct cpuidle_driver *drv, int index)
 {
 	struct acpi_processor *pr;
 	struct cpuidle_state_usage *state_usage = &dev->states_usage[index];
@@ -873,11 +877,13 @@ static DEFINE_SPINLOCK(c3_lock);
 /**
  * acpi_idle_enter_bm - enters C3 with proper BM handling
  * @dev: the target CPU
+ * @drv: cpuidle driver containing state data
  * @index: the index of suggested state
  *
  * If BM is detected, the deepest non-C3 idle state is entered instead.
  */
-static int acpi_idle_enter_bm(struct cpuidle_device *dev, int index)
+static int acpi_idle_enter_bm(struct cpuidle_device *dev,
+		struct cpuidle_driver *drv, int index)
 {
 	struct acpi_processor *pr;
 	struct cpuidle_state_usage *state_usage = &dev->states_usage[index];
@@ -900,9 +906,9 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev, int index)
 	}
 
 	if (!cx->bm_sts_skip && acpi_idle_bm_check()) {
-		if (dev->safe_state_index >= 0) {
-			return dev->states[dev->safe_state_index].enter(dev,
-						dev->safe_state_index);
+		if (drv->safe_state_index >= 0) {
+			return drv->states[drv->safe_state_index].enter(dev,
+						drv, drv->safe_state_index);
 		} else {
 			local_irq_disable();
 			acpi_safe_halt();
@@ -999,14 +1005,15 @@ struct cpuidle_driver acpi_idle_driver = {
 };
 
 /**
- * acpi_processor_setup_cpuidle - prepares and configures CPUIDLE
+ * acpi_processor_setup_cpuidle_cx - prepares and configures CPUIDLE
+ * device i.e. per-cpu data
+ *
  * @pr: the ACPI processor
  */
-static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
+static int acpi_processor_setup_cpuidle_cx(struct acpi_processor *pr)
 {
 	int i, count = CPUIDLE_DRIVER_STATE_START;
 	struct acpi_processor_cx *cx;
-	struct cpuidle_state *state;
 	struct cpuidle_state_usage *state_usage;
 	struct cpuidle_device *dev = &pr->power.dev;
 
@@ -1018,18 +1025,12 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
 	}
 
 	dev->cpu = pr->id;
-	dev->safe_state_index = -1;
-	for (i = 0; i < CPUIDLE_STATE_MAX; i++) {
-		dev->states[i].name[0] = '\0';
-		dev->states[i].desc[0] = '\0';
-	}
 
 	if (max_cstate == 0)
 		max_cstate = 1;
 
 	for (i = 1; i < ACPI_PROCESSOR_MAX_POWER && i <= max_cstate; i++) {
 		cx = &pr->power.states[i];
-		state = &dev->states[count];
 		state_usage = &dev->states_usage[count];
 
 		if (!cx->valid)
@@ -1041,8 +1042,61 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
 		    !(acpi_gbl_FADT.flags & ACPI_FADT_C2_MP_SUPPORTED))
 			continue;
 #endif
+
 		cpuidle_set_statedata(state_usage, cx);
 
+		count++;
+		if (count == CPUIDLE_STATE_MAX)
+			break;
+	}
+
+	dev->state_count = count;
+
+	if (!count)
+		return -EINVAL;
+
+	return 0;
+}
+
+/**
+ * acpi_processor_setup_cpuidle states- prepares and configures cpuidle
+ * global state data i.e. idle routines
+ *
+ * @pr: the ACPI processor
+ */
+static int acpi_processor_setup_cpuidle_states(struct acpi_processor *pr)
+{
+	int i, count = CPUIDLE_DRIVER_STATE_START;
+	struct acpi_processor_cx *cx;
+	struct cpuidle_state *state;
+	struct cpuidle_driver *drv = &acpi_idle_driver;
+
+	if (!pr->flags.power_setup_done)
+		return -EINVAL;
+
+	if (pr->flags.power == 0) {
+		return -EINVAL;
+	}
+
+	drv->safe_state_index = -1;
+
+	if (max_cstate == 0)
+		max_cstate = 1;
+
+	for (i = 1; i < ACPI_PROCESSOR_MAX_POWER && i <= max_cstate; i++) {
+		cx = &pr->power.states[i];
+
+		if (!cx->valid)
+			continue;
+
+#ifdef CONFIG_HOTPLUG_CPU
+		if ((cx->type != ACPI_STATE_C1) && (num_online_cpus() > 1) &&
+		    !pr->flags.has_cst &&
+		    !(acpi_gbl_FADT.flags & ACPI_FADT_C2_MP_SUPPORTED))
+			continue;
+#endif
+
+		state = &drv->states[count];
 		snprintf(state->name, CPUIDLE_NAME_LEN, "C%d", i);
 		strncpy(state->desc, cx->desc, CPUIDLE_DESC_LEN);
 		state->exit_latency = cx->latency;
@@ -1055,13 +1109,13 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
 				state->flags |= CPUIDLE_FLAG_TIME_VALID;
 
 			state->enter = acpi_idle_enter_c1;
-			dev->safe_state_index = count;
+			drv->safe_state_index = count;
 			break;
 
 			case ACPI_STATE_C2:
 			state->flags |= CPUIDLE_FLAG_TIME_VALID;
 			state->enter = acpi_idle_enter_simple;
-			dev->safe_state_index = count;
+			drv->safe_state_index = count;
 			break;
 
 			case ACPI_STATE_C3:
@@ -1077,7 +1131,7 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
 			break;
 	}
 
-	dev->state_count = count;
+	drv->state_count = count;
 
 	if (!count)
 		return -EINVAL;
@@ -1106,7 +1160,15 @@ int acpi_processor_cst_has_changed(struct acpi_processor *pr)
 	cpuidle_disable_device(&pr->power.dev);
 	acpi_processor_get_power_info(pr);
 	if (pr->flags.power) {
-		acpi_processor_setup_cpuidle(pr);
+		/*
+		 * To Do: Currently state data within driver
+		 * is not updated. So change this to also update
+		 * actual state data i.e. what this routine is
+		 * meant for. Maybe complete unregistration and
+		 * re-registration.
+		 *
+		 */
+		acpi_processor_setup_cpuidle_cx(pr);
 		ret = cpuidle_enable_device(&pr->power.dev);
 	}
 	cpuidle_resume_and_unlock();
@@ -1118,7 +1180,7 @@ int __cpuinit acpi_processor_power_init(struct acpi_processor *pr,
 			      struct acpi_device *device)
 {
 	acpi_status status = 0;
-	static int first_run;
+	static int first_run, acpi_processor_registered;
 
 	if (disabled_by_idle_boot_param())
 		return 0;
@@ -1154,7 +1216,15 @@ int __cpuinit acpi_processor_power_init(struct acpi_processor *pr,
 	 * platforms that only support C1.
 	 */
 	if (pr->flags.power) {
-		acpi_processor_setup_cpuidle(pr);
+		if (!acpi_processor_registered) {
+			acpi_processor_setup_cpuidle_states(pr);
+			if (!cpuidle_register_driver(&acpi_idle_driver)) {
+				printk(KERN_DEBUG "ACPI: %s registered with cpuidle\n",
+					acpi_idle_driver.name);
+				acpi_processor_registered = 1;
+			}
+		}
+		acpi_processor_setup_cpuidle_cx(pr);
 		if (cpuidle_register_device(&pr->power.dev))
 			return -EIO;
 	}
@@ -1168,6 +1238,11 @@ int acpi_processor_power_exit(struct acpi_processor *pr,
 		return 0;
 
 	cpuidle_unregister_device(&pr->power.dev);
+	/* We will have to have unregister driver as well here
+	 * since we move register_driver to power_init. Maybe
+	 * just do an unregister everytime; which will be successful
+	 * only during the last call.
+	 */
 	pr->flags.power_setup_done = 0;
 
 	return 0;
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 5d6f98d..69c5de5 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -50,6 +50,7 @@ static int __cpuidle_register_device(struct cpuidle_device *dev);
 static void cpuidle_idle_call(void)
 {
 	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
+	struct cpuidle_driver *drv = cpuidle_get_driver();
 	struct cpuidle_state *target_state;
 	int next_state, entered_state;
 
@@ -76,19 +77,19 @@ static void cpuidle_idle_call(void)
 #endif
 
 	/* ask the governor for the next state */
-	next_state = cpuidle_curr_governor->select(dev);
+	next_state = cpuidle_curr_governor->select(drv, dev);
 	if (need_resched()) {
 		local_irq_enable();
 		return;
 	}
 
-	target_state = &dev->states[next_state];
+	target_state = &drv->states[next_state];
 
 	/* Is using next_state here correct?? */
 	trace_power_start(POWER_CSTATE, next_state, dev->cpu);
 	trace_cpu_idle(next_state, dev->cpu);
 
-	entered_state = target_state->enter(dev, next_state);
+	entered_state = target_state->enter(dev, drv, next_state);
 
 	trace_power_end(dev->cpu);
 	trace_cpu_idle(PWR_EVENT_EXIT, dev->cpu);
@@ -144,7 +145,8 @@ void cpuidle_resume_and_unlock(void)
 EXPORT_SYMBOL_GPL(cpuidle_resume_and_unlock);
 
 #ifdef CONFIG_ARCH_HAS_CPU_RELAX
-static int poll_idle(struct cpuidle_device *dev, int index)
+static int poll_idle(struct cpuidle_device *dev,
+		struct cpuidle_driver *drv, int index)
 {
 	ktime_t	t1, t2;
 	s64 diff;
@@ -167,12 +169,9 @@ static int poll_idle(struct cpuidle_device *dev, int index)
 	return index;
 }
 
-static void poll_idle_init(struct cpuidle_device *dev)
+static void poll_idle_init(struct cpuidle_driver *drv)
 {
-	struct cpuidle_state *state = &dev->states[0];
-	struct cpuidle_state_usage *state_usage = &dev->states_usage[0];
-
-	cpuidle_set_statedata(state_usage, NULL);
+	struct cpuidle_state *state = &drv->states[0];
 
 	snprintf(state->name, CPUIDLE_NAME_LEN, "POLL");
 	snprintf(state->desc, CPUIDLE_DESC_LEN, "CPUIDLE CORE POLL IDLE");
@@ -183,7 +182,7 @@ static void poll_idle_init(struct cpuidle_device *dev)
 	state->enter = poll_idle;
 }
 #else
-static void poll_idle_init(struct cpuidle_device *dev) {}
+static void poll_idle_init(struct cpuidle_driver *drv) {}
 #endif /* CONFIG_ARCH_HAS_CPU_RELAX */
 
 /**
@@ -210,7 +209,8 @@ int cpuidle_enable_device(struct cpuidle_device *dev)
 			return ret;
 	}
 
-	poll_idle_init(dev);
+	poll_idle_init(cpuidle_get_driver());
+	cpuidle_set_statedata(&dev->states_usage[0], NULL);
 
 	if ((ret = cpuidle_add_state_sysfs(dev)))
 		return ret;
@@ -285,26 +285,6 @@ static int __cpuidle_register_device(struct cpuidle_device *dev)
 
 	init_completion(&dev->kobj_unregister);
 
-	/*
-	 * cpuidle driver should set the dev->power_specified bit
-	 * before registering the device if the driver provides
-	 * power_usage numbers.
-	 *
-	 * For those devices whose ->power_specified is not set,
-	 * we fill in power_usage with decreasing values as the
-	 * cpuidle code has an implicit assumption that state Cn
-	 * uses less power than C(n-1).
-	 *
-	 * With CONFIG_ARCH_HAS_CPU_RELAX, C0 is already assigned
-	 * an power value of -1.  So we use -2, -3, etc, for other
-	 * c-states.
-	 */
-	if (!dev->power_specified) {
-		int i;
-		for (i = CPUIDLE_DRIVER_STATE_START; i < dev->state_count; i++)
-			dev->states[i].power_usage = -1 - i;
-	}
-
 	per_cpu(cpuidle_devices, dev->cpu) = dev;
 	list_add(&dev->device_list, &cpuidle_detected_devices);
 	if ((ret = cpuidle_add_sysfs(sys_dev))) {
diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
index fd1601e..4b04129 100644
--- a/drivers/cpuidle/driver.c
+++ b/drivers/cpuidle/driver.c
@@ -17,6 +17,30 @@
 static struct cpuidle_driver *cpuidle_curr_driver;
 DEFINE_SPINLOCK(cpuidle_driver_lock);
 
+static void __cpuidle_register_driver(struct cpuidle_driver *drv)
+{
+	/*
+	 * cpuidle driver should set the drv->power_specified bit
+	 * before registering if the driver provides
+	 * power_usage numbers.
+	 *
+	 * If power_specified is not set,
+	 * we fill in power_usage with decreasing values as the
+	 * cpuidle code has an implicit assumption that state Cn
+	 * uses less power than C(n-1).
+	 *
+	 * With CONFIG_ARCH_HAS_CPU_RELAX, C0 is already assigned
+	 * an power value of -1.  So we use -2, -3, etc, for other
+	 * c-states.
+	 */
+	if (!drv->power_specified) {
+		int i;
+		for (i = CPUIDLE_DRIVER_STATE_START; i < drv->state_count; i++)
+			drv->states[i].power_usage = -1 - i;
+	}
+}
+
+
 /**
  * cpuidle_register_driver - registers a driver
  * @drv: the driver
@@ -31,6 +55,7 @@ int cpuidle_register_driver(struct cpuidle_driver *drv)
 		spin_unlock(&cpuidle_driver_lock);
 		return -EBUSY;
 	}
+	__cpuidle_register_driver(drv);
 	cpuidle_curr_driver = drv;
 	spin_unlock(&cpuidle_driver_lock);
 
diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 40b5630..44651ae 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -182,7 +182,7 @@ static inline int performance_multiplier(void)
 
 static DEFINE_PER_CPU(struct menu_device, menu_devices);
 
-static void menu_update(struct cpuidle_device *dev);
+static void menu_update(struct cpuidle_driver *drv, struct cpuidle_device *dev);
 
 /* This implements DIV_ROUND_CLOSEST but avoids 64 bit division */
 static u64 div_round64(u64 dividend, u32 divisor)
@@ -228,9 +228,10 @@ static void detect_repeating_patterns(struct menu_device *data)
 
 /**
  * menu_select - selects the next idle state to enter
+ * @drv: cpuidle driver containing state data
  * @dev: the CPU
  */
-static int menu_select(struct cpuidle_device *dev)
+static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 {
 	struct menu_device *data = &__get_cpu_var(menu_devices);
 	int latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
@@ -239,7 +240,7 @@ static int menu_select(struct cpuidle_device *dev)
 	int multiplier;
 
 	if (data->needs_update) {
-		menu_update(dev);
+		menu_update(drv, dev);
 		data->needs_update = 0;
 	}
 
@@ -283,8 +284,8 @@ static int menu_select(struct cpuidle_device *dev)
 	 * Find the idle state with the lowest power while satisfying
 	 * our constraints.
 	 */
-	for (i = CPUIDLE_DRIVER_STATE_START; i < dev->state_count; i++) {
-		struct cpuidle_state *s = &dev->states[i];
+	for (i = CPUIDLE_DRIVER_STATE_START; i < drv->state_count; i++) {
+		struct cpuidle_state *s = &drv->states[i];
 
 		if (s->target_residency > data->predicted_us)
 			continue;
@@ -321,14 +322,15 @@ static void menu_reflect(struct cpuidle_device *dev, int index)
 
 /**
  * menu_update - attempts to guess what happened after entry
+ * @drv: cpuidle driver containing state data
  * @dev: the CPU
  */
-static void menu_update(struct cpuidle_device *dev)
+static void menu_update(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 {
 	struct menu_device *data = &__get_cpu_var(menu_devices);
 	int last_idx = data->last_state_idx;
 	unsigned int last_idle_us = cpuidle_get_last_residency(dev);
-	struct cpuidle_state *target = &dev->states[last_idx];
+	struct cpuidle_state *target = &drv->states[last_idx];
 	unsigned int measured_us;
 	u64 new_factor;
 
diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
index 09c9c77..90be2ad 100644
--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -318,13 +318,14 @@ int cpuidle_add_state_sysfs(struct cpuidle_device *device)
 {
 	int i, ret = -ENOMEM;
 	struct cpuidle_state_kobj *kobj;
+	struct cpuidle_driver *drv = cpuidle_get_driver();
 
 	/* state statistics */
 	for (i = 0; i < device->state_count; i++) {
 		kobj = kzalloc(sizeof(struct cpuidle_state_kobj), GFP_KERNEL);
 		if (!kobj)
 			goto error_state;
-		kobj->state = &device->states[i];
+		kobj->state = &drv->states[i];
 		kobj->state_usage = &device->states_usage[i];
 		init_completion(&kobj->kobj_unregister);
 
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 5a1a238..0964f21 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -22,6 +22,7 @@
 #define CPUIDLE_DESC_LEN	32
 
 struct cpuidle_device;
+struct cpuidle_driver;
 
 
 /****************************
@@ -45,6 +46,7 @@ struct cpuidle_state {
 	unsigned int	target_residency; /* in US */
 
 	int (*enter)	(struct cpuidle_device *dev,
+			struct cpuidle_driver *drv,
 			int index);
 };
 
@@ -83,20 +85,17 @@ struct cpuidle_state_kobj {
 struct cpuidle_device {
 	unsigned int		registered:1;
 	unsigned int		enabled:1;
-	unsigned int		power_specified:1;
 	unsigned int		cpu;
 
 	int			last_residency;
 	int			state_count;
-	struct cpuidle_state	states[CPUIDLE_STATE_MAX];
 	struct cpuidle_state_usage	states_usage[CPUIDLE_STATE_MAX];
 	struct cpuidle_state_kobj *kobjs[CPUIDLE_STATE_MAX];
 
-	struct list_head 	device_list;
+	struct list_head	device_list;
 	struct kobject		kobj;
 	struct completion	kobj_unregister;
 	void			*governor_data;
-	int			safe_state_index;
 };
 
 DECLARE_PER_CPU(struct cpuidle_device *, cpuidle_devices);
@@ -120,6 +119,12 @@ static inline int cpuidle_get_last_residency(struct cpuidle_device *dev)
 struct cpuidle_driver {
 	char			name[CPUIDLE_NAME_LEN];
 	struct module 		*owner;
+
+	unsigned int		power_specified:1;
+	struct cpuidle_state	states[CPUIDLE_STATE_MAX];
+	int			state_count;
+	struct cpuidle_state	*safe_state;
+	int			safe_state_index;
 };
 
 #ifdef CONFIG_CPU_IDLE
@@ -165,7 +170,8 @@ struct cpuidle_governor {
 	int  (*enable)		(struct cpuidle_device *dev);
 	void (*disable)		(struct cpuidle_device *dev);
 
-	int  (*select)		(struct cpuidle_device *dev);
+	int  (*select)		(struct cpuidle_driver *drv,
+					struct cpuidle_device *dev);
 	void (*reflect)		(struct cpuidle_device *dev, int index);
 
 	struct module 		*owner;

