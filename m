Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab1BHKwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 05:52:14 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:38485 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349Ab1BHKwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 05:52:12 -0500
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Subject: [RFC PATCH V3 2/3] cpuidle: list based cpuidle driver registration
	and selection
To: arjan@linux.intel.com, peterz@infradead.org, lenb@kernel.org,
        suresh.b.siddha@intel.com, benh@kernel.crashing.org, venki@google.com,
        ak@linux.intel.com
Cc: linux-kernel@vger.kernel.org
Date: Tue, 08 Feb 2011 16:22:04 +0530
Message-ID: <20110208105203.9998.35678.stgit@tringupt.in.ibm.com>
In-Reply-To: <20110208105146.9998.22103.stgit@tringupt.in.ibm.com>
References: <20110208105146.9998.22103.stgit@tringupt.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A cpuidle_driver structure represents a cpuidle driver like
acpi_idle, intel_idle providing low level idle routines.
A cpuidle_driver is global in nature as it provides routines
for all the CPUS. Each CPU registered with the cpuidle subsystem is
represented as a cpuidle_device. A cpuidle_device structure
points to the low level idle routines for that CPU provided by
a certain driver. In other words, a cpuidle driver creates a
cpuidle_device structure for each CPU that it registers with the
cpuidle subsystem. Whenever cpuidle idle loop is called, the cpuidle
subsystem picks the cpuidle_device structure for that cpu and
calls one of the low level idle routines through that structure.

In the current design, only one cpuidle_driver may be registered
and registration of any subsequent driver fails. The same registered
driver provides low level idle routines for each cpuidle_device.

A list based registration for cpuidle_driver provides a clean
mechanism for multiple subsystems/modules to register their own idle
routines and thus avoids using pm_idle.

This patch implements a list based registration for cpuidle
driver. Different drivers can be registered and the driver to
be used is selected based on a per driver priority. On a
cpuidle driver registration or unregistration cpuidle_device
structure for each CPU is changed. Each cpuidle_device points
to its driver to facilitate this registration and unregistration.

        ---------                        ---------
        |cpuidle|                        |cpuidle|
        |driver |----------------------- |driver |
        |default|                        |acpi   |
        ---------                        ---------
            ^                                ^
            |                                |
----------------------------      ---------------------------
^                    ^            ^                ^
|                    |            |                |
|                    |            |                |
---------    ---------            ---------    ----------
|cpuidle|    |cpuidle|            |cpuidle|    |cpuidle |
|device |    |device | ....       |device |    |device  | .....
|  CPU0 |    | CPU1  |            |CPU0   |    |CPU1    |
---------    ---------            ---------    ----------

Signed-off-by: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
---

 drivers/acpi/processor_idle.c |    2 +
 drivers/cpuidle/Kconfig       |    6 ++
 drivers/cpuidle/cpuidle.c     |   41 ++++++++++++---
 drivers/cpuidle/driver.c      |  114 ++++++++++++++++++++++++++++++++++++++---
 include/linux/cpuidle.h       |    3 +
 5 files changed, 152 insertions(+), 14 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index dcb38f8..b53c7fb 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -964,6 +964,7 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 struct cpuidle_driver acpi_idle_driver = {
 	.name =		"acpi_idle",
 	.owner =	THIS_MODULE,
+	.priority =	10,
 };
 
 /**
@@ -985,6 +986,7 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
 	}
 
 	dev->cpu = pr->id;
+	dev->drv = &acpi_idle_driver;
 	for (i = 0; i < CPUIDLE_STATE_MAX; i++) {
 		dev->states[i].name[0] = '\0';
 		dev->states[i].desc[0] = '\0';
diff --git a/drivers/cpuidle/Kconfig b/drivers/cpuidle/Kconfig
index e67c258..8cc73c8 100644
--- a/drivers/cpuidle/Kconfig
+++ b/drivers/cpuidle/Kconfig
@@ -19,3 +19,9 @@ config CPU_IDLE_GOV_MENU
 	bool
 	depends on CPU_IDLE && NO_HZ
 	default y
+
+config ARCH_USES_PMIDLE
+	bool
+	depends on CPUIDLE
+	depends on !X86
+	default y
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 9bf4640..dc472d8 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -109,6 +109,7 @@ void cpuidle_idle_call(void)
 	trace_power_end(smp_processor_id());
 }
 
+#ifdef CONFIG_ARCH_USES_PMIDLE
 /**
  * cpuidle_install_idle_handler - installs the cpuidle idle loop handler
  */
@@ -131,6 +132,10 @@ void cpuidle_uninstall_idle_handler(void)
 		cpuidle_kick_cpus();
 	}
 }
+#else
+void cpuidle_install_idle_handler(void) {}
+void cpuidle_uninstall_idle_handler(void) {}
+#endif
 
 /**
  * cpuidle_pause_and_lock - temporarily disables CPUIDLE
@@ -284,9 +289,21 @@ static int __cpuidle_register_device(struct cpuidle_device *dev)
 	struct sys_device *sys_dev = get_cpu_sysdev((unsigned long)dev->cpu);
 	struct cpuidle_driver *cpuidle_driver = cpuidle_get_driver();
 
+	if (dev->registered)
+		return 0;
 	if (!sys_dev)
 		return -EINVAL;
-	if (!try_module_get(cpuidle_driver->owner))
+	/*
+	 * This will maintain compatibility with old cpuidle_device
+	 * structure where driver pointer is not set.
+	 *
+	 * To Do: Change all call sites to set dev->drv pointer.
+	 * This can be changed to BUG() later in case somebody
+	 * registers without a driver pointer.
+	 */
+	if (!dev->drv)
+		dev->drv = cpuidle_driver;
+	if (!try_module_get(dev->drv->owner))
 		return -EINVAL;
 
 	init_completion(&dev->kobj_unregister);
@@ -313,10 +330,11 @@ static int __cpuidle_register_device(struct cpuidle_device *dev)
 			dev->states[i].power_usage = -1 - i;
 	}
 
-	per_cpu(cpuidle_devices, dev->cpu) = dev;
+	if (cpuidle_driver == dev->drv)
+		per_cpu(cpuidle_devices, dev->cpu) = dev;
 	list_add(&dev->device_list, &cpuidle_detected_devices);
 	if ((ret = cpuidle_add_sysfs(sys_dev))) {
-		module_put(cpuidle_driver->owner);
+		module_put(dev->drv->owner);
 		return ret;
 	}
 
@@ -367,13 +385,13 @@ void cpuidle_unregister_device(struct cpuidle_device *dev)
 	cpuidle_disable_device(dev);
 
 	cpuidle_remove_sysfs(sys_dev);
-	list_del(&dev->device_list);
 	wait_for_completion(&dev->kobj_unregister);
-	per_cpu(cpuidle_devices, dev->cpu) = NULL;
+	if (cpuidle_driver == dev->drv)
+		per_cpu(cpuidle_devices, dev->cpu) = NULL;
 
 	cpuidle_resume_and_unlock();
 
-	module_put(cpuidle_driver->owner);
+	module_put(dev->drv->owner);
 }
 
 EXPORT_SYMBOL_GPL(cpuidle_unregister_device);
@@ -413,6 +431,15 @@ static inline void latency_notifier_init(struct notifier_block *n)
 
 #endif /* CONFIG_SMP */
 
+#ifdef CONFIG_ARCH_USES_PMIDLE
+static inline void save_pm_idle(void)
+{
+	pm_idle_old = pm_idle;
+}
+#else
+static inline void save_pm_idle(void) {}
+#endif
+
 /**
  * cpuidle_init - core initializer
  */
@@ -420,7 +447,7 @@ static int __init cpuidle_init(void)
 {
 	int ret;
 
-	pm_idle_old = pm_idle;
+	save_pm_idle();
 
 	ret = cpuidle_add_class_sysfs(&cpu_sysdev_class);
 	if (ret)
diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
index fd1601e..c235286 100644
--- a/drivers/cpuidle/driver.c
+++ b/drivers/cpuidle/driver.c
@@ -14,8 +14,83 @@
 
 #include "cpuidle.h"
 
+#define MAX_PRIORITY 1000
+#define DEFAULT_PRIORITY 100
+
 static struct cpuidle_driver *cpuidle_curr_driver;
 DEFINE_SPINLOCK(cpuidle_driver_lock);
+LIST_HEAD(registered_cpuidle_drivers);
+
+static struct cpuidle_driver *select_cpuidle_driver(void)
+{
+	struct cpuidle_driver *item = NULL, *selected = NULL;
+	unsigned int min_priority = MAX_PRIORITY;
+
+	list_for_each_entry(item, &registered_cpuidle_drivers,
+		driver_list) {
+		if (item->priority <= min_priority) {
+			selected = item;
+			min_priority = item->priority;
+		}
+	}
+	return selected;
+}
+
+static void set_current_cpuidle_driver(struct cpuidle_driver *drv)
+{
+	struct cpuidle_device *item = NULL;
+	if (drv == cpuidle_curr_driver)
+		return;
+
+	/* Unregister the previous drivers devices */
+	/* Do we need to take cpuidle_lock ? {un}register_device takes lock*/
+	if (cpuidle_curr_driver) {
+		list_for_each_entry(item, &cpuidle_detected_devices,
+			device_list) {
+			if (item->drv == cpuidle_curr_driver)
+				cpuidle_unregister_device(item);
+		}
+	}
+
+	cpuidle_curr_driver = drv;
+
+	if (drv == NULL)
+		return;
+	else {
+		/* Register the new driver devices */
+		list_for_each_entry(item, &cpuidle_detected_devices,
+			device_list) {
+			if (item->drv == drv)
+				cpuidle_register_device(item);
+		}
+	}
+}
+
+static inline int arch_allow_register(void)
+{
+#ifdef CONFIG_ARCH_USES_PMIDLE
+	if (cpuidle_curr_driver)
+		return -EPERM;
+	else
+		return 0;
+#else
+	return 0;
+#endif
+}
+
+static inline int arch_allow_unregister(struct cpuidle_driver *drv)
+{
+#ifdef CONFIG_ARCH_USES_PMIDLE
+	if (drv != cpuidle_curr_driver) {
+		WARN(1, "invalid cpuidle_unregister_driver(%s)\n",
+			drv->name);
+		return -EPERM;
+	} else
+		return 0;
+#else
+	return 0;
+#endif
+}
 
 /**
  * cpuidle_register_driver - registers a driver
@@ -23,15 +98,29 @@ DEFINE_SPINLOCK(cpuidle_driver_lock);
  */
 int cpuidle_register_driver(struct cpuidle_driver *drv)
 {
+	struct cpuidle_driver *item = NULL;
 	if (!drv)
 		return -EINVAL;
+	if (drv->priority == 0)
+		drv->priority = DEFAULT_PRIORITY;
 
 	spin_lock(&cpuidle_driver_lock);
-	if (cpuidle_curr_driver) {
+
+	if (arch_allow_register()) {
 		spin_unlock(&cpuidle_driver_lock);
 		return -EBUSY;
 	}
-	cpuidle_curr_driver = drv;
+
+	/* Check if driver already registered */
+	list_for_each_entry(item, &registered_cpuidle_drivers, driver_list) {
+		if (item == drv) {
+			spin_unlock(&cpuidle_driver_lock);
+			return -EINVAL;
+		}
+	}
+
+	list_add(&drv->driver_list, &registered_cpuidle_drivers);
+	set_current_cpuidle_driver(select_cpuidle_driver());
 	spin_unlock(&cpuidle_driver_lock);
 
 	return 0;
@@ -54,14 +143,25 @@ EXPORT_SYMBOL_GPL(cpuidle_get_driver);
  */
 void cpuidle_unregister_driver(struct cpuidle_driver *drv)
 {
-	if (drv != cpuidle_curr_driver) {
-		WARN(1, "invalid cpuidle_unregister_driver(%s)\n",
-			drv->name);
+	struct cpuidle_device *item = NULL;
+
+	if (arch_allow_unregister(drv))
 		return;
-	}
 
 	spin_lock(&cpuidle_driver_lock);
-	cpuidle_curr_driver = NULL;
+
+	/* Set some other driver as current */
+	list_del(&drv->driver_list);
+	set_current_cpuidle_driver(select_cpuidle_driver());
+
+	/* Delete all devices corresponding to this driver */
+	mutex_lock(&cpuidle_lock);
+	list_for_each_entry(item, &cpuidle_detected_devices, device_list) {
+		if (item->drv == drv)
+			list_del(&item->device_list);
+	}
+	mutex_unlock(&cpuidle_lock);
+
 	spin_unlock(&cpuidle_driver_lock);
 }
 
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 1be416b..cbb504c 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -96,6 +96,7 @@ struct cpuidle_device {
 	struct cpuidle_state	*last_state;
 
 	struct list_head 	device_list;
+	struct cpuidle_driver	*drv;
 	struct kobject		kobj;
 	struct completion	kobj_unregister;
 	void			*governor_data;
@@ -125,6 +126,8 @@ static inline int cpuidle_get_last_residency(struct cpuidle_device *dev)
 struct cpuidle_driver {
 	char			name[CPUIDLE_NAME_LEN];
 	struct module 		*owner;
+	unsigned int		priority;
+	struct list_head	driver_list;
 };
 
 #ifdef CONFIG_CPU_IDLE

