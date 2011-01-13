Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab1AMMw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 07:52:27 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:37708 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab1AMMwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 07:52:21 -0500
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Subject: [RFC V2 2/3] cpuidle: list based cpuidle driver registration and
	selection
To: arjan@linux.intel.com, peterz@infradead.org, lenb@kernel.org,
        suresh.b.siddha@intel.com, benh@kernel.crashing.org, venki@google.com,
        ak@linux.intel.com
Cc: linux-kernel@vger.kernel.org
Date: Thu, 13 Jan 2011 18:22:16 +0530
Message-ID: <20110113125207.11174.57059.stgit@tringupt.in.ibm.com>
In-Reply-To: <20110113125113.11174.78525.stgit@tringupt.in.ibm.com>
References: <20110113125113.11174.78525.stgit@tringupt.in.ibm.com>
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
to its driver. Each driver also maintains a list of cpuidle_devices
for itself (although this can be made global). Effectively
there is both way connectivity between cpuidle_device and
cpuidle_driver to facilitate management for subsequent registration
and unregsitration.

        ---------                        ---------
        |cpuidle|                        |cpuidle|
        |driver |----------------------- |driver |
        |default|                        |acpi   |
        ---------                        ---------
            |                                |
            |                                |
----------------------------      ---------------------------
|                    |            |                |
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
 drivers/cpuidle/cpuidle.c     |   50 +++++++++++++-----------------
 drivers/cpuidle/driver.c      |   68 ++++++++++++++++++++++++++++++++++-------
 drivers/cpuidle/governor.c    |   13 +++++---
 include/linux/cpuidle.h       |    4 ++
 5 files changed, 93 insertions(+), 44 deletions(-)

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
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 9bf4640..f16b920 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -25,9 +25,6 @@ DEFINE_PER_CPU(struct cpuidle_device *, cpuidle_devices);
 
 DEFINE_MUTEX(cpuidle_lock);
 LIST_HEAD(cpuidle_detected_devices);
-static void (*pm_idle_old)(void);
-
-static int enabled_devices;
 
 #if defined(CONFIG_ARCH_HAS_CPU_IDLE_WAIT)
 static void cpuidle_kick_cpus(void)
@@ -55,13 +52,10 @@ void cpuidle_idle_call(void)
 
 	/* check if the device is ready */
 	if (!dev || !dev->enabled) {
-		if (pm_idle_old)
-			pm_idle_old();
-		else
 #if defined(CONFIG_ARCH_HAS_DEFAULT_IDLE)
-			default_idle();
+		default_idle();
 #else
-			local_irq_enable();
+		local_irq_enable();
 #endif
 		return;
 	}
@@ -114,11 +108,17 @@ void cpuidle_idle_call(void)
  */
 void cpuidle_install_idle_handler(void)
 {
-	if (enabled_devices && (pm_idle != cpuidle_idle_call)) {
-		/* Make sure all changes finished before we switch to new idle */
-		smp_wmb();
-		pm_idle = cpuidle_idle_call;
-	}
+	/* 
+	* To Do: These (un)install_idle_handler() routines will become
+	* arch specific to stage the cleanup on a per-architecture basis.
+	*
+	* For archs with pm_idle, the original code will remain. This can also
+	* move into arch/kernel where the pm_idle is defined so that
+	* per-architecture code is naturally split-up. From cpuidle's point of
+	* view, it will call the (un)install_idle_handler() as needed and this
+	* will be a no-op on non-pm_idle archs.
+	*/
+	smp_wmb();
 }
 
 /**
@@ -126,10 +126,7 @@ void cpuidle_install_idle_handler(void)
  */
 void cpuidle_uninstall_idle_handler(void)
 {
-	if (enabled_devices && pm_idle_old && (pm_idle != pm_idle_old)) {
-		pm_idle = pm_idle_old;
-		cpuidle_kick_cpus();
-	}
+	cpuidle_kick_cpus();
 }
 
 /**
@@ -196,7 +193,6 @@ int cpuidle_enable_device(struct cpuidle_device *dev)
 
 	dev->enabled = 1;
 
-	enabled_devices++;
 	return 0;
 
 fail_sysfs:
@@ -227,7 +223,6 @@ void cpuidle_disable_device(struct cpuidle_device *dev)
 		cpuidle_curr_governor->disable(dev);
 
 	cpuidle_remove_state_sysfs(dev);
-	enabled_devices--;
 }
 
 EXPORT_SYMBOL_GPL(cpuidle_disable_device);
@@ -286,7 +281,7 @@ static int __cpuidle_register_device(struct cpuidle_device *dev)
 
 	if (!sys_dev)
 		return -EINVAL;
-	if (!try_module_get(cpuidle_driver->owner))
+	if (!try_module_get(dev->drv->owner))
 		return -EINVAL;
 
 	init_completion(&dev->kobj_unregister);
@@ -313,10 +308,11 @@ static int __cpuidle_register_device(struct cpuidle_device *dev)
 			dev->states[i].power_usage = -1 - i;
 	}
 
-	per_cpu(cpuidle_devices, dev->cpu) = dev;
-	list_add(&dev->device_list, &cpuidle_detected_devices);
+	if (cpuidle_driver == dev->drv)
+		per_cpu(cpuidle_devices, dev->cpu) = dev;
+	list_add(&dev->device_list, &dev->drv->device_list);
 	if ((ret = cpuidle_add_sysfs(sys_dev))) {
-		module_put(cpuidle_driver->owner);
+		module_put(dev->drv->owner);
 		return ret;
 	}
 
@@ -367,13 +363,13 @@ void cpuidle_unregister_device(struct cpuidle_device *dev)
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
@@ -420,8 +416,6 @@ static int __init cpuidle_init(void)
 {
 	int ret;
 
-	pm_idle_old = pm_idle;
-
 	ret = cpuidle_add_class_sysfs(&cpu_sysdev_class);
 	if (ret)
 		return ret;
diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
index fd1601e..78ae527 100644
--- a/drivers/cpuidle/driver.c
+++ b/drivers/cpuidle/driver.c
@@ -14,8 +14,52 @@
 
 #include "cpuidle.h"
 
+#define MAX_PRIORITY 1000
+
 static struct cpuidle_driver *cpuidle_curr_driver;
 DEFINE_SPINLOCK(cpuidle_driver_lock);
+LIST_HEAD(registered_cpuidle_drivers);
+
+static struct cpuidle_driver *select_cpuidle_driver(void)
+{
+	struct cpuidle_driver *item = NULL, *next = NULL;
+	unsigned int min_priority = MAX_PRIORITY;
+
+	list_for_each_entry(item, &registered_cpuidle_drivers,
+		driver_list) {
+		if (item->priority <= min_priority) {
+			next = item;
+			min_priority = item->priority;
+		}
+	}
+	return next;
+}
+
+static void set_current_cpuidle_driver(struct cpuidle_driver *drv)
+{
+	struct cpuidle_device *item = NULL;
+	if (drv == cpuidle_curr_driver)
+		return;
+
+	/* Unregister the previous drivers devices */
+	if (cpuidle_curr_driver) {
+		list_for_each_entry(item, &cpuidle_curr_driver->device_list,
+			device_list) {
+			cpuidle_unregister_device(item);
+		}
+	}
+
+	cpuidle_curr_driver = drv;
+
+	if (drv == NULL)
+		return;
+	else {
+		/* Register the new driver devices */
+		list_for_each_entry(item, &drv->device_list, device_list) {
+			cpuidle_register_device(item);
+		}
+	}
+}
 
 /**
  * cpuidle_register_driver - registers a driver
@@ -23,15 +67,20 @@ DEFINE_SPINLOCK(cpuidle_driver_lock);
  */
 int cpuidle_register_driver(struct cpuidle_driver *drv)
 {
+	struct cpuidle_driver *item = NULL;
 	if (!drv)
 		return -EINVAL;
 
-	spin_lock(&cpuidle_driver_lock);
-	if (cpuidle_curr_driver) {
-		spin_unlock(&cpuidle_driver_lock);
-		return -EBUSY;
+	/* Check if driver already registered */
+	list_for_each_entry(item, &registered_cpuidle_drivers, driver_list) {
+		if (item == drv)
+			return -EINVAL;
 	}
-	cpuidle_curr_driver = drv;
+
+	spin_lock(&cpuidle_driver_lock);
+	INIT_LIST_HEAD(&drv->device_list);
+	list_add(&drv->driver_list, &registered_cpuidle_drivers);
+	set_current_cpuidle_driver(select_cpuidle_driver());
 	spin_unlock(&cpuidle_driver_lock);
 
 	return 0;
@@ -54,14 +103,9 @@ EXPORT_SYMBOL_GPL(cpuidle_get_driver);
  */
 void cpuidle_unregister_driver(struct cpuidle_driver *drv)
 {
-	if (drv != cpuidle_curr_driver) {
-		WARN(1, "invalid cpuidle_unregister_driver(%s)\n",
-			drv->name);
-		return;
-	}
-
 	spin_lock(&cpuidle_driver_lock);
-	cpuidle_curr_driver = NULL;
+	list_del(&drv->driver_list);
+	set_current_cpuidle_driver(select_cpuidle_driver());
 	spin_unlock(&cpuidle_driver_lock);
 }
 
diff --git a/drivers/cpuidle/governor.c b/drivers/cpuidle/governor.c
index 724c164..a8ed695 100644
--- a/drivers/cpuidle/governor.c
+++ b/drivers/cpuidle/governor.c
@@ -44,6 +44,7 @@ static struct cpuidle_governor * __cpuidle_find_governor(const char *str)
 int cpuidle_switch_governor(struct cpuidle_governor *gov)
 {
 	struct cpuidle_device *dev;
+	struct cpuidle_driver *drv = cpuidle_get_driver();
 
 	if (gov == cpuidle_curr_governor)
 		return 0;
@@ -51,8 +52,10 @@ int cpuidle_switch_governor(struct cpuidle_governor *gov)
 	cpuidle_uninstall_idle_handler();
 
 	if (cpuidle_curr_governor) {
-		list_for_each_entry(dev, &cpuidle_detected_devices, device_list)
-			cpuidle_disable_device(dev);
+		if (drv) {
+			list_for_each_entry(dev, &drv->device_list, device_list)
+				cpuidle_disable_device(dev);
+		}
 		module_put(cpuidle_curr_governor->owner);
 	}
 
@@ -61,8 +64,10 @@ int cpuidle_switch_governor(struct cpuidle_governor *gov)
 	if (gov) {
 		if (!try_module_get(cpuidle_curr_governor->owner))
 			return -EINVAL;
-		list_for_each_entry(dev, &cpuidle_detected_devices, device_list)
-			cpuidle_enable_device(dev);
+		if (drv) {
+			list_for_each_entry(dev, &drv->device_list, device_list)
+				cpuidle_enable_device(dev);
+		}
 		cpuidle_install_idle_handler();
 		printk(KERN_INFO "cpuidle: using governor %s\n", gov->name);
 	}
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 1be416b..5fea1ff 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -96,6 +96,7 @@ struct cpuidle_device {
 	struct cpuidle_state	*last_state;
 
 	struct list_head 	device_list;
+	struct cpuidle_driver	*drv;
 	struct kobject		kobj;
 	struct completion	kobj_unregister;
 	void			*governor_data;
@@ -125,6 +126,9 @@ static inline int cpuidle_get_last_residency(struct cpuidle_device *dev)
 struct cpuidle_driver {
 	char			name[CPUIDLE_NAME_LEN];
 	struct module 		*owner;
+	unsigned int		priority;
+	struct list_head	driver_list;
+	struct list_head	device_list;
 };
 
 #ifdef CONFIG_CPU_IDLE

