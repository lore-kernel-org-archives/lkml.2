Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab1LHB6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 20:58:46 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36870 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350Ab1LHB6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 20:58:43 -0500
Message-ID: <1323309517.979.8.camel@mop>
Subject: [PATCH-WIP] convert CPU sysdev class to a real subsytem (needed for
 CPU modaliases)
From: Kay Sievers <kay.sievers@vrfy.org>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com, trenn@suse.de,
        davej@redhat.com
Date: Thu, 08 Dec 2011 02:58:37 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is work-in-progress and just posted to coordinate with Andi
Kleen's current export of CPU modaliases. It boots my x86_64 workstation
fine, nothing else is tested.

The CPU subsystem from a sysdev_class to a plain driver-core subsystem
(currently called 'bus').

With the CPUs as normal devices, userspace will pick the events up
properly and udev is able to coldplug the devices during bootup, which
will allow proper module autoloading based on MODALIAS.

  $ tree /sys/bus/cpu/
  /sys/bus/cpu/
  ├── devices
  │   ├── cpu0 -> ../../../devices/system/cpu/cpu0
  │   ├── cpu1 -> ../../../devices/system/cpu/cpu1
  │   ├── cpu2 -> ../../../devices/system/cpu/cpu2
  │   └── cpu3 -> ../../../devices/system/cpu/cpu3
  ...
  └── uevent

The needed bits to easily convert the remaining sysdev class users to a
plain subsystem and plain devices have been added to the driver core.
Sysdev drivers have never been 'drivers' in the driver-core sense, and
they can be now ported-over to subsys_interfaces. The end goal is to
finally remove all of the ugly sysdev hack from the system.

Greg, I guess we need a bit of your time, to make a plan and get the
remaining things sorted out. We are planning and fiddling for years
already here, and we should finally get the stuff out. :)

Greg, I think with the subsys_interfaces we do not need the
'multi-driver-binding' anymore, seems we can get away with the
interfaces only. Classes which need to convert to buses because the
class interface is not extensible can be easily converted now. The only
missing piece is the 'glue directory'. We should be able to unify
classes and buses internally with all that stuff.

Kay

---
 arch/x86/kernel/cpu/intel_cacheinfo.c    |   25 ++--
 arch/x86/kernel/cpu/mcheck/therm_throt.c |   63 +++++------
 arch/x86/kernel/microcode_core.c         |   58 +++++-----
 drivers/acpi/processor_driver.c          |    6 -
 drivers/base/base.h                      |    8 -
 drivers/base/bus.c                       |  177 +++++++++++++++++++++++++++----
 drivers/base/class.c                     |   14 +-
 drivers/base/core.c                      |   35 +++---
 drivers/base/cpu.c                       |  157 +++++++++++++++------------
 drivers/base/node.c                      |   10 -
 drivers/base/sys.c                       |   75 +++++++++----
 drivers/base/topology.c                  |   51 ++++----
 drivers/cpufreq/cpufreq.c                |   79 ++++++-------
 drivers/cpuidle/cpuidle.c                |   12 +-
 drivers/cpuidle/cpuidle.h                |   10 -
 drivers/cpuidle/sysfs.c                  |   74 ++++++------
 include/linux/cpu.h                      |   19 +--
 include/linux/device.h                   |   63 ++++++++++-
 kernel/sched.c                           |   40 +++----
 19 files changed, 614 insertions(+), 362 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index a3b0811..6b45e5e 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -844,8 +844,7 @@ static int __cpuinit detect_cache_attributes(unsigned int cpu)
 
 #include <linux/kobject.h>
 #include <linux/sysfs.h>
-
-extern struct sysdev_class cpu_sysdev_class; /* from drivers/base/cpu.c */
+#include <linux/cpu.h>
 
 /* pointer to kobject for cpuX/cache */
 static DEFINE_PER_CPU(struct kobject *, ici_cache_kobject);
@@ -1073,9 +1072,9 @@ err_out:
 static DECLARE_BITMAP(cache_dev_map, NR_CPUS);
 
 /* Add/Remove cache interface for CPU device */
-static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
+static int __cpuinit cache_add_dev(struct device *dev)
 {
-	unsigned int cpu = sys_dev->id;
+	unsigned int cpu = dev->id;
 	unsigned long i, j;
 	struct _index_kobject *this_object;
 	struct _cpuid4_info   *this_leaf;
@@ -1087,7 +1086,7 @@ static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
 
 	retval = kobject_init_and_add(per_cpu(ici_cache_kobject, cpu),
 				      &ktype_percpu_entry,
-				      &sys_dev->kobj, "%s", "cache");
+				      &dev->kobj, "%s", "cache");
 	if (retval < 0) {
 		cpuid4_cache_sysfs_exit(cpu);
 		return retval;
@@ -1124,9 +1123,9 @@ static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
 	return 0;
 }
 
-static void __cpuinit cache_remove_dev(struct sys_device * sys_dev)
+static void __cpuinit cache_remove_dev(struct device *dev)
 {
-	unsigned int cpu = sys_dev->id;
+	unsigned int cpu = dev->id;
 	unsigned long i;
 
 	if (per_cpu(ici_cpuid4_info, cpu) == NULL)
@@ -1145,17 +1144,17 @@ static int __cpuinit cacheinfo_cpu_callback(struct notifier_block *nfb,
 					unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
-	struct sys_device *sys_dev;
+	struct device *dev;
 
-	sys_dev = get_cpu_sysdev(cpu);
+	dev = get_cpu_device(cpu);
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		cache_add_dev(sys_dev);
+		cache_add_dev(dev);
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		cache_remove_dev(sys_dev);
+		cache_remove_dev(dev);
 		break;
 	}
 	return NOTIFY_OK;
@@ -1174,9 +1173,9 @@ static int __cpuinit cache_sysfs_init(void)
 
 	for_each_online_cpu(i) {
 		int err;
-		struct sys_device *sys_dev = get_cpu_sysdev(i);
+		struct device *dev = get_cpu_device(i);
 
-		err = cache_add_dev(sys_dev);
+		err = cache_add_dev(dev);
 		if (err)
 			return err;
 	}
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 787e06c..59e3f6e 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -19,7 +19,6 @@
 #include <linux/kernel.h>
 #include <linux/percpu.h>
 #include <linux/export.h>
-#include <linux/sysdev.h>
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/smp.h>
@@ -69,16 +68,16 @@ static atomic_t therm_throt_en	= ATOMIC_INIT(0);
 static u32 lvtthmr_init __read_mostly;
 
 #ifdef CONFIG_SYSFS
-#define define_therm_throt_sysdev_one_ro(_name)				\
-	static SYSDEV_ATTR(_name, 0444,					\
-			   therm_throt_sysdev_show_##_name,		\
+#define define_therm_throt_device_one_ro(_name)				\
+	static DEVICE_ATTR(_name, 0444,					\
+			   therm_throt_device_show_##_name,		\
 				   NULL)				\
 
-#define define_therm_throt_sysdev_show_func(event, name)		\
+#define define_therm_throt_device_show_func(event, name)		\
 									\
-static ssize_t therm_throt_sysdev_show_##event##_##name(		\
-			struct sys_device *dev,				\
-			struct sysdev_attribute *attr,			\
+static ssize_t therm_throt_device_show_##event##_##name(		\
+			struct device *dev,				\
+			struct device_attribute *attr,			\
 			char *buf)					\
 {									\
 	unsigned int cpu = dev->id;					\
@@ -95,20 +94,20 @@ static ssize_t therm_throt_sysdev_show_##event##_##name(		\
 	return ret;							\
 }
 
-define_therm_throt_sysdev_show_func(core_throttle, count);
-define_therm_throt_sysdev_one_ro(core_throttle_count);
+define_therm_throt_device_show_func(core_throttle, count);
+define_therm_throt_device_one_ro(core_throttle_count);
 
-define_therm_throt_sysdev_show_func(core_power_limit, count);
-define_therm_throt_sysdev_one_ro(core_power_limit_count);
+define_therm_throt_device_show_func(core_power_limit, count);
+define_therm_throt_device_one_ro(core_power_limit_count);
 
-define_therm_throt_sysdev_show_func(package_throttle, count);
-define_therm_throt_sysdev_one_ro(package_throttle_count);
+define_therm_throt_device_show_func(package_throttle, count);
+define_therm_throt_device_one_ro(package_throttle_count);
 
-define_therm_throt_sysdev_show_func(package_power_limit, count);
-define_therm_throt_sysdev_one_ro(package_power_limit_count);
+define_therm_throt_device_show_func(package_power_limit, count);
+define_therm_throt_device_one_ro(package_power_limit_count);
 
 static struct attribute *thermal_throttle_attrs[] = {
-	&attr_core_throttle_count.attr,
+	&dev_attr_core_throttle_count.attr,
 	NULL
 };
 
@@ -223,36 +222,36 @@ static int thresh_event_valid(int event)
 
 #ifdef CONFIG_SYSFS
 /* Add/Remove thermal_throttle interface for CPU device: */
-static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev,
+static __cpuinit int thermal_throttle_add_dev(struct device *dev,
 				unsigned int cpu)
 {
 	int err;
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
-	err = sysfs_create_group(&sys_dev->kobj, &thermal_attr_group);
+	err = sysfs_create_group(&dev->kobj, &thermal_attr_group);
 	if (err)
 		return err;
 
 	if (cpu_has(c, X86_FEATURE_PLN))
-		err = sysfs_add_file_to_group(&sys_dev->kobj,
-					      &attr_core_power_limit_count.attr,
+		err = sysfs_add_file_to_group(&dev->kobj,
+					      &dev_attr_core_power_limit_count.attr,
 					      thermal_attr_group.name);
 	if (cpu_has(c, X86_FEATURE_PTS)) {
-		err = sysfs_add_file_to_group(&sys_dev->kobj,
-					      &attr_package_throttle_count.attr,
+		err = sysfs_add_file_to_group(&dev->kobj,
+					      &dev_attr_package_throttle_count.attr,
 					      thermal_attr_group.name);
 		if (cpu_has(c, X86_FEATURE_PLN))
-			err = sysfs_add_file_to_group(&sys_dev->kobj,
-					&attr_package_power_limit_count.attr,
+			err = sysfs_add_file_to_group(&dev->kobj,
+					&dev_attr_package_power_limit_count.attr,
 					thermal_attr_group.name);
 	}
 
 	return err;
 }
 
-static __cpuinit void thermal_throttle_remove_dev(struct sys_device *sys_dev)
+static __cpuinit void thermal_throttle_remove_dev(struct device *dev)
 {
-	sysfs_remove_group(&sys_dev->kobj, &thermal_attr_group);
+	sysfs_remove_group(&dev->kobj, &thermal_attr_group);
 }
 
 /* Mutex protecting device creation against CPU hotplug: */
@@ -265,16 +264,16 @@ thermal_throttle_cpu_callback(struct notifier_block *nfb,
 			      void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
-	struct sys_device *sys_dev;
+	struct device *dev;
 	int err = 0;
 
-	sys_dev = get_cpu_sysdev(cpu);
+	dev = get_cpu_device(cpu);
 
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
 		mutex_lock(&therm_cpu_lock);
-		err = thermal_throttle_add_dev(sys_dev, cpu);
+		err = thermal_throttle_add_dev(dev, cpu);
 		mutex_unlock(&therm_cpu_lock);
 		WARN_ON(err);
 		break;
@@ -283,7 +282,7 @@ thermal_throttle_cpu_callback(struct notifier_block *nfb,
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		mutex_lock(&therm_cpu_lock);
-		thermal_throttle_remove_dev(sys_dev);
+		thermal_throttle_remove_dev(dev);
 		mutex_unlock(&therm_cpu_lock);
 		break;
 	}
@@ -310,7 +309,7 @@ static __init int thermal_throttle_init_device(void)
 #endif
 	/* connect live CPUs to sysfs */
 	for_each_online_cpu(cpu) {
-		err = thermal_throttle_add_dev(get_cpu_sysdev(cpu), cpu);
+		err = thermal_throttle_add_dev(get_cpu_device(cpu), cpu);
 		WARN_ON(err);
 	}
 #ifdef CONFIG_HOTPLUG_CPU
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 9d46f5e..240b8d4 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -292,8 +292,8 @@ static int reload_for_cpu(int cpu)
 	return err;
 }
 
-static ssize_t reload_store(struct sys_device *dev,
-			    struct sysdev_attribute *attr,
+static ssize_t reload_store(struct device *dev,
+			    struct device_attribute *attr,
 			    const char *buf, size_t size)
 {
 	unsigned long val;
@@ -318,30 +318,30 @@ static ssize_t reload_store(struct sys_device *dev,
 	return ret;
 }
 
-static ssize_t version_show(struct sys_device *dev,
-			struct sysdev_attribute *attr, char *buf)
+static ssize_t version_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + dev->id;
 
 	return sprintf(buf, "0x%x\n", uci->cpu_sig.rev);
 }
 
-static ssize_t pf_show(struct sys_device *dev,
-			struct sysdev_attribute *attr, char *buf)
+static ssize_t pf_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + dev->id;
 
 	return sprintf(buf, "0x%x\n", uci->cpu_sig.pf);
 }
 
-static SYSDEV_ATTR(reload, 0200, NULL, reload_store);
-static SYSDEV_ATTR(version, 0400, version_show, NULL);
-static SYSDEV_ATTR(processor_flags, 0400, pf_show, NULL);
+static DEVICE_ATTR(reload, 0200, NULL, reload_store);
+static DEVICE_ATTR(version, 0400, version_show, NULL);
+static DEVICE_ATTR(processor_flags, 0400, pf_show, NULL);
 
 static struct attribute *mc_default_attrs[] = {
-	&attr_reload.attr,
-	&attr_version.attr,
-	&attr_processor_flags.attr,
+	&dev_attr_reload.attr,
+	&dev_attr_version.attr,
+	&dev_attr_processor_flags.attr,
 	NULL
 };
 
@@ -405,43 +405,45 @@ static enum ucode_state microcode_update_cpu(int cpu)
 	return ustate;
 }
 
-static int mc_sysdev_add(struct sys_device *sys_dev)
+static int mc_device_add(struct device *dev, struct subsys_interface *sif)
 {
-	int err, cpu = sys_dev->id;
+	int err, cpu = dev->id;
 
 	if (!cpu_online(cpu))
 		return 0;
 
 	pr_debug("CPU%d added\n", cpu);
 
-	err = sysfs_create_group(&sys_dev->kobj, &mc_attr_group);
+	err = sysfs_create_group(&dev->kobj, &mc_attr_group);
 	if (err)
 		return err;
 
 	if (microcode_init_cpu(cpu) == UCODE_ERROR) {
-		sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
+		sysfs_remove_group(&dev->kobj, &mc_attr_group);
 		return -EINVAL;
 	}
 
 	return err;
 }
 
-static int mc_sysdev_remove(struct sys_device *sys_dev)
+static int mc_device_remove(struct device *dev, struct subsys_interface *sif)
 {
-	int cpu = sys_dev->id;
+	int cpu = dev->id;
 
 	if (!cpu_online(cpu))
 		return 0;
 
 	pr_debug("CPU%d removed\n", cpu);
 	microcode_fini_cpu(cpu);
-	sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
+	sysfs_remove_group(&dev->kobj, &mc_attr_group);
 	return 0;
 }
 
-static struct sysdev_driver mc_sysdev_driver = {
-	.add			= mc_sysdev_add,
-	.remove			= mc_sysdev_remove,
+static struct subsys_interface mc_cpu_interface = {
+	.name			= "microcode",
+	.subsys			= &cpu_subsys,
+	.add_dev		= mc_device_add,
+	.remove_dev		= mc_device_remove,
 };
 
 /**
@@ -464,9 +466,9 @@ static __cpuinit int
 mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
-	struct sys_device *sys_dev;
+	struct device *dev;
 
-	sys_dev = get_cpu_sysdev(cpu);
+	dev = get_cpu_device(cpu);
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
@@ -474,13 +476,13 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
 		pr_debug("CPU%d added\n", cpu);
-		if (sysfs_create_group(&sys_dev->kobj, &mc_attr_group))
+		if (sysfs_create_group(&dev->kobj, &mc_attr_group))
 			pr_err("Failed to create group for CPU%d\n", cpu);
 		break;
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
 		/* Suspend is in progress, only remove the interface */
-		sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
+		sysfs_remove_group(&dev->kobj, &mc_attr_group);
 		pr_debug("CPU%d removed\n", cpu);
 		break;
 
@@ -525,7 +527,7 @@ static int __init microcode_init(void)
 	get_online_cpus();
 	mutex_lock(&microcode_mutex);
 
-	error = sysdev_driver_register(&cpu_sysdev_class, &mc_sysdev_driver);
+	error = subsys_interface_register(&mc_cpu_interface);
 
 	mutex_unlock(&microcode_mutex);
 	put_online_cpus();
@@ -549,7 +551,7 @@ out_sysdev_driver:
 	get_online_cpus();
 	mutex_lock(&microcode_mutex);
 
-	sysdev_driver_unregister(&cpu_sysdev_class, &mc_sysdev_driver);
+	subsys_interface_unregister(&mc_cpu_interface);
 
 	mutex_unlock(&microcode_mutex);
 	put_online_cpus();
diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index 9d7bc9f..20a68ca 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -446,7 +446,7 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
 {
 	struct acpi_processor *pr = NULL;
 	int result = 0;
-	struct sys_device *sysdev;
+	struct device *dev;
 
 	pr = kzalloc(sizeof(struct acpi_processor), GFP_KERNEL);
 	if (!pr)
@@ -491,8 +491,8 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
 
 	per_cpu(processors, pr->id) = pr;
 
-	sysdev = get_cpu_sysdev(pr->id);
-	if (sysfs_create_link(&device->dev.kobj, &sysdev->kobj, "sysdev")) {
+	dev = get_cpu_device(pr->id);
+	if (sysfs_create_link(&device->dev.kobj, &dev->kobj, "sysdev")) {
 		result = -EFAULT;
 		goto err_free_cpumask;
 	}
diff --git a/drivers/base/base.h b/drivers/base/base.h
index 21c1b96..7144953 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -5,6 +5,8 @@
  *
  * @subsys - the struct kset that defines this subsystem
  * @devices_kset - the list of devices associated
+ * @interfaces - list of subsystem interfaces associated
+ * @mutex - protect the devices, and interfaces lists.
  *
  * @drivers_kset - the list of drivers associated
  * @klist_devices - the klist to iterate over the @devices_kset
@@ -14,10 +16,8 @@
  * @bus - pointer back to the struct bus_type that this structure is associated
  *        with.
  *
- * @class_interfaces - list of class_interfaces associated
  * @glue_dirs - "glue" directory to put in-between the parent device to
  *              avoid namespace conflicts
- * @class_mutex - mutex to protect the children, devices, and interfaces lists.
  * @class - pointer back to the struct class that this structure is associated
  *          with.
  *
@@ -28,6 +28,8 @@
 struct subsys_private {
 	struct kset subsys;
 	struct kset *devices_kset;
+	struct list_head interfaces;
+	struct mutex mutex;
 
 	struct kset *drivers_kset;
 	struct klist klist_devices;
@@ -36,9 +38,7 @@ struct subsys_private {
 	unsigned int drivers_autoprobe:1;
 	struct bus_type *bus;
 
-	struct list_head class_interfaces;
 	struct kset glue_dirs;
-	struct mutex class_mutex;
 	struct class *class;
 };
 #define to_subsys_private(obj) container_of(obj, struct subsys_private, subsys.kobj)
diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 000e7b2..b66547a 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/string.h>
+#include <linux/mutex.h>
 #include "base.h"
 #include "power/power.h"
 
@@ -487,38 +488,59 @@ out_put:
 void bus_probe_device(struct device *dev)
 {
 	struct bus_type *bus = dev->bus;
+	struct subsys_interface *sif;
 	int ret;
 
-	if (bus && bus->p->drivers_autoprobe) {
+	if (!bus)
+		return;
+
+	if (bus->p->drivers_autoprobe) {
 		ret = device_attach(dev);
 		WARN_ON(ret < 0);
 	}
+
+	mutex_lock(&bus->p->mutex);
+	list_for_each_entry(sif, &bus->p->interfaces, node)
+		if (sif->add_dev)
+			sif->add_dev(dev, sif);
+	mutex_unlock(&bus->p->mutex);
 }
 
 /**
  * bus_remove_device - remove device from bus
  * @dev: device to be removed
  *
- * - Remove symlink from bus's directory.
+ * - Remove device from all interfaces.
+ * - Remove symlink from bus' directory.
  * - Delete device from bus's list.
  * - Detach from its driver.
  * - Drop reference taken in bus_add_device().
  */
 void bus_remove_device(struct device *dev)
 {
-	if (dev->bus) {
-		sysfs_remove_link(&dev->kobj, "subsystem");
-		sysfs_remove_link(&dev->bus->p->devices_kset->kobj,
-				  dev_name(dev));
-		device_remove_attrs(dev->bus, dev);
-		if (klist_node_attached(&dev->p->knode_bus))
-			klist_del(&dev->p->knode_bus);
-
-		pr_debug("bus: '%s': remove device %s\n",
-			 dev->bus->name, dev_name(dev));
-		device_release_driver(dev);
-		bus_put(dev->bus);
-	}
+	struct bus_type *bus = dev->bus;
+	struct subsys_interface *sif;
+
+	if (!bus)
+		return;
+
+	mutex_lock(&bus->p->mutex);
+	list_for_each_entry(sif, &bus->p->interfaces, node)
+		if (sif->remove_dev)
+			sif->remove_dev(dev, sif);
+	mutex_unlock(&bus->p->mutex);
+
+	sysfs_remove_link(&dev->kobj, "subsystem");
+	sysfs_remove_link(&dev->bus->p->devices_kset->kobj,
+			  dev_name(dev));
+	device_remove_attrs(dev->bus, dev);
+	if (klist_node_attached(&dev->p->knode_bus))
+		klist_del(&dev->p->knode_bus);
+
+	pr_debug("bus: '%s': remove device %s\n",
+		 dev->bus->name, dev_name(dev));
+	device_release_driver(dev);
+	bus_put(dev->bus);
 }
 
 static int driver_add_attrs(struct bus_type *bus, struct device_driver *drv)
@@ -847,14 +869,14 @@ static ssize_t bus_uevent_store(struct bus_type *bus,
 static BUS_ATTR(uevent, S_IWUSR, NULL, bus_uevent_store);
 
 /**
- * bus_register - register a bus with the system.
+ * __bus_register - register a driver-core subsystem
  * @bus: bus.
  *
  * Once we have that, we registered the bus with the kobject
  * infrastructure, then register the children subsystems it has:
- * the devices and drivers that belong to the bus.
+ * the devices and drivers that belong to the subsystem.
  */
-int bus_register(struct bus_type *bus)
+int __bus_register(struct bus_type *bus, struct lock_class_key *key)
 {
 	int retval;
 	struct subsys_private *priv;
@@ -898,6 +920,8 @@ int bus_register(struct bus_type *bus)
 		goto bus_drivers_fail;
 	}
 
+	INIT_LIST_HEAD(&priv->interfaces);
+	__mutex_init(&priv->mutex, "subsys mutex", key);
 	klist_init(&priv->klist_devices, klist_devices_get, klist_devices_put);
 	klist_init(&priv->klist_drivers, NULL, NULL);
 
@@ -927,7 +951,7 @@ out:
 	bus->p = NULL;
 	return retval;
 }
-EXPORT_SYMBOL_GPL(bus_register);
+EXPORT_SYMBOL_GPL(__bus_register);
 
 /**
  * bus_unregister - remove a bus from the system
@@ -1028,6 +1052,121 @@ void bus_sort_breadthfirst(struct bus_type *bus,
 }
 EXPORT_SYMBOL_GPL(bus_sort_breadthfirst);
 
+/**
+ * subsys_dev_iter_init - initialize subsys device iterator
+ * @iter: subsys iterator to initialize
+ * @subsys: the subsys we wanna iterate over
+ * @start: the device to start iterating from, if any
+ * @type: device_type of the devices to iterate over, NULL for all
+ *
+ * Initialize subsys iterator @iter such that it iterates over devices
+ * of @subsys.  If @start is set, the list iteration will start there,
+ * otherwise if it is NULL, the iteration starts at the beginning of
+ * the list.
+ */
+void subsys_dev_iter_init(struct subsys_dev_iter *iter, struct bus_type *subsys,
+			  struct device *start, const struct device_type *type)
+{
+	struct klist_node *start_knode = NULL;
+
+	if (start)
+		start_knode = &start->p->knode_bus;
+	klist_iter_init_node(&subsys->p->klist_devices, &iter->ki, start_knode);
+	iter->type = type;
+}
+EXPORT_SYMBOL_GPL(subsys_dev_iter_init);
+
+/**
+ * subsys_dev_iter_next - iterate to the next device
+ * @iter: subsys iterator to proceed
+ *
+ * Proceed @iter to the next device and return it.  Returns NULL if
+ * iteration is complete.
+ *
+ * The returned device is referenced and won't be released till
+ * iterator is proceed to the next device or exited.  The caller is
+ * free to do whatever it wants to do with the device including
+ * calling back into subsys code.
+ */
+struct device *subsys_dev_iter_next(struct subsys_dev_iter *iter)
+{
+	struct klist_node *knode;
+	struct device *dev;
+
+	for(;;) {
+		knode = klist_next(&iter->ki);
+		if (!knode)
+			return NULL;
+		dev = container_of(knode, struct device_private, knode_bus)->device;
+		if (!iter->type || iter->type == dev->type)
+			return dev;
+	}
+}
+EXPORT_SYMBOL_GPL(subsys_dev_iter_next);
+
+/**
+ * subsys_dev_iter_exit - finish iteration
+ * @iter: subsys iterator to finish
+ *
+ * Finish an iteration.  Always call this function after iteration is
+ * complete whether the iteration ran till the end or not.
+ */
+void subsys_dev_iter_exit(struct subsys_dev_iter *iter)
+{
+	klist_iter_exit(&iter->ki);
+}
+EXPORT_SYMBOL_GPL(subsys_dev_iter_exit);
+
+int subsys_interface_register(struct subsys_interface *sif)
+{
+	struct bus_type *subsys;
+	struct subsys_dev_iter iter;
+	struct device *dev;
+
+	if (!sif || !sif->subsys)
+		return -ENODEV;
+
+	subsys = bus_get(sif->subsys);
+	if (!subsys)
+		return -EINVAL;
+
+	mutex_lock(&subsys->p->mutex);
+	list_add_tail(&sif->node, &subsys->p->interfaces);
+	if (sif->add_dev) {
+		subsys_dev_iter_init(&iter, subsys, NULL, NULL);
+		while ((dev = subsys_dev_iter_next(&iter)))
+			sif->add_dev(dev, sif);
+		subsys_dev_iter_exit(&iter);
+	}
+	mutex_unlock(&subsys->p->mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(subsys_interface_register);
+
+void subsys_interface_unregister(struct subsys_interface *sif)
+{
+	struct bus_type *subsys = sif->subsys;
+	struct subsys_dev_iter iter;
+	struct device *dev;
+
+	if (!sif)
+		return;
+
+	mutex_lock(&subsys->p->mutex);
+	list_del_init(&sif->node);
+	if (sif->remove_dev) {
+		subsys_dev_iter_init(&iter, subsys, NULL, NULL);
+		while ((dev = subsys_dev_iter_next(&iter)))
+			sif->remove_dev(dev, sif);
+		subsys_dev_iter_exit(&iter);
+	}
+	mutex_unlock(&subsys->p->mutex);
+
+	bus_put(subsys);
+}
+EXPORT_SYMBOL_GPL(subsys_interface_unregister);
+
 int __init buses_init(void)
 {
 	bus_kset = kset_create_and_add("bus", &bus_uevent_ops, NULL);
diff --git a/drivers/base/class.c b/drivers/base/class.c
index b80d91c..03243d4 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -184,9 +184,9 @@ int __class_register(struct class *cls, struct lock_class_key *key)
 	if (!cp)
 		return -ENOMEM;
 	klist_init(&cp->klist_devices, klist_class_dev_get, klist_class_dev_put);
-	INIT_LIST_HEAD(&cp->class_interfaces);
+	INIT_LIST_HEAD(&cp->interfaces);
 	kset_init(&cp->glue_dirs);
-	__mutex_init(&cp->class_mutex, "struct class mutex", key);
+	__mutex_init(&cp->mutex, "subsys mutex", key);
 	error = kobject_set_name(&cp->subsys.kobj, "%s", cls->name);
 	if (error) {
 		kfree(cp);
@@ -460,15 +460,15 @@ int class_interface_register(struct class_interface *class_intf)
 	if (!parent)
 		return -EINVAL;
 
-	mutex_lock(&parent->p->class_mutex);
-	list_add_tail(&class_intf->node, &parent->p->class_interfaces);
+	mutex_lock(&parent->p->mutex);
+	list_add_tail(&class_intf->node, &parent->p->interfaces);
 	if (class_intf->add_dev) {
 		class_dev_iter_init(&iter, parent, NULL, NULL);
 		while ((dev = class_dev_iter_next(&iter)))
 			class_intf->add_dev(dev, class_intf);
 		class_dev_iter_exit(&iter);
 	}
-	mutex_unlock(&parent->p->class_mutex);
+	mutex_unlock(&parent->p->mutex);
 
 	return 0;
 }
@@ -482,7 +482,7 @@ void class_interface_unregister(struct class_interface *class_intf)
 	if (!parent)
 		return;
 
-	mutex_lock(&parent->p->class_mutex);
+	mutex_lock(&parent->p->mutex);
 	list_del_init(&class_intf->node);
 	if (class_intf->remove_dev) {
 		class_dev_iter_init(&iter, parent, NULL, NULL);
@@ -490,7 +490,7 @@ void class_interface_unregister(struct class_interface *class_intf)
 			class_intf->remove_dev(dev, class_intf);
 		class_dev_iter_exit(&iter);
 	}
-	mutex_unlock(&parent->p->class_mutex);
+	mutex_unlock(&parent->p->mutex);
 
 	class_put(parent);
 }
diff --git a/drivers/base/core.c b/drivers/base/core.c
index d8b3d89..4a3e579 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -711,6 +711,12 @@ static struct kobject *get_device_parent(struct device *dev,
 		return k;
 	}
 
+	/* subsystems can specify a default device root directory */
+	if (!parent && dev->bus) {
+		if (dev->bus->dev_root)
+			return &dev->bus->dev_root->kobj;
+	}
+
 	if (parent)
 		return &parent->kobj;
 	return NULL;
@@ -731,14 +737,6 @@ static void cleanup_device_parent(struct device *dev)
 	cleanup_glue_dir(dev, dev->kobj.parent);
 }
 
-static void setup_parent(struct device *dev, struct device *parent)
-{
-	struct kobject *kobj;
-	kobj = get_device_parent(dev, parent);
-	if (kobj)
-		dev->kobj.parent = kobj;
-}
-
 static int device_add_class_symlinks(struct device *dev)
 {
 	int error;
@@ -891,6 +889,7 @@ int device_private_init(struct device *dev)
 int device_add(struct device *dev)
 {
 	struct device *parent = NULL;
+	struct kobject *kobj;
 	struct class_interface *class_intf;
 	int error = -EINVAL;
 
@@ -914,6 +913,10 @@ int device_add(struct device *dev)
 		dev->init_name = NULL;
 	}
 
+	/* subsystems can specify simple device enumeration */
+	if (!dev_name(dev) && dev->bus && dev->bus->dev_name)
+		dev_set_name(dev, "%s%u", dev->bus->dev_name, dev->id);
+
 	if (!dev_name(dev)) {
 		error = -EINVAL;
 		goto name_error;
@@ -922,7 +925,9 @@ int device_add(struct device *dev)
 	pr_debug("device: '%s': %s\n", dev_name(dev), __func__);
 
 	parent = get_device(dev->parent);
-	setup_parent(dev, parent);
+	kobj = get_device_parent(dev, parent);
+	if (kobj)
+		dev->kobj.parent = kobj;
 
 	/* use parent numa_node */
 	if (parent)
@@ -982,17 +987,17 @@ int device_add(struct device *dev)
 			       &parent->p->klist_children);
 
 	if (dev->class) {
-		mutex_lock(&dev->class->p->class_mutex);
+		mutex_lock(&dev->class->p->mutex);
 		/* tie the class to the device */
 		klist_add_tail(&dev->knode_class,
 			       &dev->class->p->klist_devices);
 
 		/* notify any interfaces that the device is here */
 		list_for_each_entry(class_intf,
-				    &dev->class->p->class_interfaces, node)
+				    &dev->class->p->interfaces, node)
 			if (class_intf->add_dev)
 				class_intf->add_dev(dev, class_intf);
-		mutex_unlock(&dev->class->p->class_mutex);
+		mutex_unlock(&dev->class->p->mutex);
 	}
 done:
 	put_device(dev);
@@ -1107,15 +1112,15 @@ void device_del(struct device *dev)
 	if (dev->class) {
 		device_remove_class_symlinks(dev);
 
-		mutex_lock(&dev->class->p->class_mutex);
+		mutex_lock(&dev->class->p->mutex);
 		/* notify any interfaces that the device is now gone */
 		list_for_each_entry(class_intf,
-				    &dev->class->p->class_interfaces, node)
+				    &dev->class->p->interfaces, node)
 			if (class_intf->remove_dev)
 				class_intf->remove_dev(dev, class_intf);
 		/* remove the device from the class list */
 		klist_del(&dev->knode_class);
-		mutex_unlock(&dev->class->p->class_mutex);
+		mutex_unlock(&dev->class->p->mutex);
 	}
 	device_remove_file(dev, &uevent_attr);
 	device_remove_attrs(dev);
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 251acea..3926e04 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -1,8 +1,7 @@
 /*
- * drivers/base/cpu.c - basic CPU class support
+ * CPU subsystem support
  */
 
-#include <linux/sysdev.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/sched.h>
@@ -14,40 +13,43 @@
 
 #include "base.h"
 
-static struct sysdev_class_attribute *cpu_sysdev_class_attrs[];
-
-struct sysdev_class cpu_sysdev_class = {
+struct bus_type cpu_subsys = {
 	.name = "cpu",
-	.attrs = cpu_sysdev_class_attrs,
+	.dev_name = "cpu"
 };
-EXPORT_SYMBOL(cpu_sysdev_class);
+EXPORT_SYMBOL_GPL(cpu_subsys);
+
+struct device *cpu_root_dev;
+EXPORT_SYMBOL_GPL(cpu_root_dev);
 
-static DEFINE_PER_CPU(struct sys_device *, cpu_sys_devices);
+static DEFINE_PER_CPU(struct device *, cpu_sys_devices);
 
 #ifdef CONFIG_HOTPLUG_CPU
-static ssize_t show_online(struct sys_device *dev, struct sysdev_attribute *attr,
+static ssize_t show_online(struct device *dev,
+			   struct device_attribute *attr,
 			   char *buf)
 {
-	struct cpu *cpu = container_of(dev, struct cpu, sysdev);
+	struct cpu *cpu = container_of(dev, struct cpu, dev);
 
-	return sprintf(buf, "%u\n", !!cpu_online(cpu->sysdev.id));
+	return sprintf(buf, "%u\n", !!cpu_online(cpu->dev.id));
 }
 
-static ssize_t __ref store_online(struct sys_device *dev, struct sysdev_attribute *attr,
-				 const char *buf, size_t count)
+static ssize_t __ref store_online(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
 {
-	struct cpu *cpu = container_of(dev, struct cpu, sysdev);
+	struct cpu *cpu = container_of(dev, struct cpu, dev);
 	ssize_t ret;
 
 	cpu_hotplug_driver_lock();
 	switch (buf[0]) {
 	case '0':
-		ret = cpu_down(cpu->sysdev.id);
+		ret = cpu_down(cpu->dev.id);
 		if (!ret)
 			kobject_uevent(&dev->kobj, KOBJ_OFFLINE);
 		break;
 	case '1':
-		ret = cpu_up(cpu->sysdev.id);
+		ret = cpu_up(cpu->dev.id);
 		if (!ret)
 			kobject_uevent(&dev->kobj, KOBJ_ONLINE);
 		break;
@@ -60,44 +62,44 @@ static ssize_t __ref store_online(struct sys_device *dev, struct sysdev_attribut
 		ret = count;
 	return ret;
 }
-static SYSDEV_ATTR(online, 0644, show_online, store_online);
+static DEVICE_ATTR(online, 0644, show_online, store_online);
 
 static void __cpuinit register_cpu_control(struct cpu *cpu)
 {
-	sysdev_create_file(&cpu->sysdev, &attr_online);
+	device_create_file(&cpu->dev, &dev_attr_online);
 }
 void unregister_cpu(struct cpu *cpu)
 {
-	int logical_cpu = cpu->sysdev.id;
+	int logical_cpu = cpu->dev.id;
 
 	unregister_cpu_under_node(logical_cpu, cpu_to_node(logical_cpu));
 
-	sysdev_remove_file(&cpu->sysdev, &attr_online);
+	device_remove_file(&cpu->dev, &dev_attr_online);
 
-	sysdev_unregister(&cpu->sysdev);
+	device_unregister(&cpu->dev);
 	per_cpu(cpu_sys_devices, logical_cpu) = NULL;
 	return;
 }
 
 #ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
-static ssize_t cpu_probe_store(struct sysdev_class *class,
-			       struct sysdev_class_attribute *attr,
+static ssize_t cpu_probe_store(struct device *dev,
+			       struct device_attribute *attr,
 			       const char *buf,
 			       size_t count)
 {
 	return arch_cpu_probe(buf, count);
 }
 
-static ssize_t cpu_release_store(struct sysdev_class *class,
-				 struct sysdev_class_attribute *attr,
+static ssize_t cpu_release_store(struct device *dev,
+				 struct device_attribute *attr,
 				 const char *buf,
 				 size_t count)
 {
 	return arch_cpu_release(buf, count);
 }
 
-static SYSDEV_CLASS_ATTR(probe, S_IWUSR, NULL, cpu_probe_store);
-static SYSDEV_CLASS_ATTR(release, S_IWUSR, NULL, cpu_release_store);
+static DEVICE_ATTR(probe, S_IWUSR, NULL, cpu_probe_store);
+static DEVICE_ATTR(release, S_IWUSR, NULL, cpu_release_store);
 #endif /* CONFIG_ARCH_CPU_PROBE_RELEASE */
 
 #else /* ... !CONFIG_HOTPLUG_CPU */
@@ -109,15 +111,15 @@ static inline void register_cpu_control(struct cpu *cpu)
 #ifdef CONFIG_KEXEC
 #include <linux/kexec.h>
 
-static ssize_t show_crash_notes(struct sys_device *dev, struct sysdev_attribute *attr,
+static ssize_t show_crash_notes(struct device *dev, struct device_attribute *attr,
 				char *buf)
 {
-	struct cpu *cpu = container_of(dev, struct cpu, sysdev);
+	struct cpu *cpu = container_of(dev, struct cpu, dev);
 	ssize_t rc;
 	unsigned long long addr;
 	int cpunum;
 
-	cpunum = cpu->sysdev.id;
+	cpunum = cpu->dev.id;
 
 	/*
 	 * Might be reading other cpu's data based on which cpu read thread
@@ -129,7 +131,7 @@ static ssize_t show_crash_notes(struct sys_device *dev, struct sysdev_attribute
 	rc = sprintf(buf, "%Lx\n", addr);
 	return rc;
 }
-static SYSDEV_ATTR(crash_notes, 0400, show_crash_notes, NULL);
+static DEVICE_ATTR(crash_notes, 0400, show_crash_notes, NULL);
 #endif
 
 /*
@@ -137,12 +139,12 @@ static SYSDEV_ATTR(crash_notes, 0400, show_crash_notes, NULL);
  */
 
 struct cpu_attr {
-	struct sysdev_class_attribute attr;
+	struct device_attribute attr;
 	const struct cpumask *const * const map;
 };
 
-static ssize_t show_cpus_attr(struct sysdev_class *class,
-			      struct sysdev_class_attribute *attr,
+static ssize_t show_cpus_attr(struct device *dev,
+			      struct device_attribute *attr,
 			      char *buf)
 {
 	struct cpu_attr *ca = container_of(attr, struct cpu_attr, attr);
@@ -153,10 +155,10 @@ static ssize_t show_cpus_attr(struct sysdev_class *class,
 	return n;
 }
 
-#define _CPU_ATTR(name, map)						\
-	{ _SYSDEV_CLASS_ATTR(name, 0444, show_cpus_attr, NULL), map }
+#define _CPU_ATTR(name, map) \
+	{ __ATTR(name, 0444, show_cpus_attr, NULL), map }
 
-/* Keep in sync with cpu_sysdev_class_attrs */
+/* Keep in sync with cpu_subsys_attrs */
 static struct cpu_attr cpu_attrs[] = {
 	_CPU_ATTR(online, &cpu_online_mask),
 	_CPU_ATTR(possible, &cpu_possible_mask),
@@ -166,19 +168,19 @@ static struct cpu_attr cpu_attrs[] = {
 /*
  * Print values for NR_CPUS and offlined cpus
  */
-static ssize_t print_cpus_kernel_max(struct sysdev_class *class,
-				     struct sysdev_class_attribute *attr, char *buf)
+static ssize_t print_cpus_kernel_max(struct device *dev,
+				     struct device_attribute *attr, char *buf)
 {
 	int n = snprintf(buf, PAGE_SIZE-2, "%d\n", NR_CPUS - 1);
 	return n;
 }
-static SYSDEV_CLASS_ATTR(kernel_max, 0444, print_cpus_kernel_max, NULL);
+static DEVICE_ATTR(kernel_max, 0444, print_cpus_kernel_max, NULL);
 
 /* arch-optional setting to enable display of offline cpus >= nr_cpu_ids */
 unsigned int total_cpus;
 
-static ssize_t print_cpus_offline(struct sysdev_class *class,
-				  struct sysdev_class_attribute *attr, char *buf)
+static ssize_t print_cpus_offline(struct device *dev,
+				  struct device_attribute *attr, char *buf)
 {
 	int n = 0, len = PAGE_SIZE-2;
 	cpumask_var_t offline;
@@ -205,7 +207,7 @@ static ssize_t print_cpus_offline(struct sysdev_class *class,
 	n += snprintf(&buf[n], len - n, "\n");
 	return n;
 }
-static SYSDEV_CLASS_ATTR(offline, 0444, print_cpus_offline, NULL);
+static DEVICE_ATTR(offline, 0444, print_cpus_offline, NULL);
 
 /*
  * register_cpu - Setup a sysfs device for a CPU.
@@ -218,57 +220,74 @@ static SYSDEV_CLASS_ATTR(offline, 0444, print_cpus_offline, NULL);
 int __cpuinit register_cpu(struct cpu *cpu, int num)
 {
 	int error;
-	cpu->node_id = cpu_to_node(num);
-	cpu->sysdev.id = num;
-	cpu->sysdev.cls = &cpu_sysdev_class;
-
-	error = sysdev_register(&cpu->sysdev);
 
+	cpu->node_id = cpu_to_node(num);
+	cpu->dev.id = num;
+	cpu->dev.bus = &cpu_subsys;
+	error = device_register(&cpu->dev);
 	if (!error && cpu->hotpluggable)
 		register_cpu_control(cpu);
 	if (!error)
-		per_cpu(cpu_sys_devices, num) = &cpu->sysdev;
+		per_cpu(cpu_sys_devices, num) = &cpu->dev;
 	if (!error)
 		register_cpu_under_node(num, cpu_to_node(num));
 
 #ifdef CONFIG_KEXEC
 	if (!error)
-		error = sysdev_create_file(&cpu->sysdev, &attr_crash_notes);
+		error = device_create_file(&cpu->dev, &dev_attr_crash_notes);
 #endif
 	return error;
 }
 
-struct sys_device *get_cpu_sysdev(unsigned cpu)
+struct device *get_cpu_device(unsigned cpu)
 {
 	if (cpu < nr_cpu_ids && cpu_possible(cpu))
 		return per_cpu(cpu_sys_devices, cpu);
 	else
 		return NULL;
 }
-EXPORT_SYMBOL_GPL(get_cpu_sysdev);
+EXPORT_SYMBOL_GPL(get_cpu_device);
+
+static struct attribute *cpu_root_attrs[] = {
+#ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
+	&dev_attr_probe.attr,
+	&dev_attr_release.attr,
+#endif
+	&cpu_attrs[0].attr.attr,
+	&cpu_attrs[1].attr.attr,
+	&cpu_attrs[2].attr.attr,
+	&dev_attr_kernel_max.attr,
+	&dev_attr_offline.attr,
+	NULL
+};
+
+static struct attribute_group cpu_root_attr_group = {
+	.attrs = cpu_root_attrs,
+};
+
+static const struct attribute_group *cpu_root_attr_groups[] = {
+	&cpu_root_attr_group,
+	NULL,
+};
 
 int __init cpu_dev_init(void)
 {
 	int err;
 
-	err = sysdev_class_register(&cpu_sysdev_class);
+	err = bus_register(&cpu_subsys);
+	if (err)
+		return err;
+
+	err = system_root_device(&cpu_root_dev,
+				 &cpu_subsys, cpu_root_attr_groups);
+	if (err) {
+		bus_unregister(&cpu_subsys);
+		return err;
+	}
+	cpu_subsys.dev_root = cpu_root_dev;
+
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-	if (!err)
-		err = sched_create_sysfs_power_savings_entries(&cpu_sysdev_class);
+	err = sched_create_sysfs_power_savings_entries(cpu_root_dev);
 #endif
-
 	return err;
 }
-
-static struct sysdev_class_attribute *cpu_sysdev_class_attrs[] = {
-#ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
-	&attr_probe,
-	&attr_release,
-#endif
-	&cpu_attrs[0].attr,
-	&cpu_attrs[1].attr,
-	&cpu_attrs[2].attr,
-	&attr_kernel_max,
-	&attr_offline,
-	NULL
-};
diff --git a/drivers/base/node.c b/drivers/base/node.c
index 5693ece..9694955 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -1,5 +1,5 @@
 /*
- * drivers/base/node.c - basic Node class support
+ * Basic Node interface support
  */
 
 #include <linux/sysdev.h>
@@ -317,12 +317,12 @@ struct node node_devices[MAX_NUMNODES];
 int register_cpu_under_node(unsigned int cpu, unsigned int nid)
 {
 	int ret;
-	struct sys_device *obj;
+	struct device *obj;
 
 	if (!node_online(nid))
 		return 0;
 
-	obj = get_cpu_sysdev(cpu);
+	obj = get_cpu_device(cpu);
 	if (!obj)
 		return 0;
 
@@ -339,12 +339,12 @@ int register_cpu_under_node(unsigned int cpu, unsigned int nid)
 
 int unregister_cpu_under_node(unsigned int cpu, unsigned int nid)
 {
-	struct sys_device *obj;
+	struct device *obj;
 
 	if (!node_online(nid))
 		return 0;
 
-	obj = get_cpu_sysdev(cpu);
+	obj = get_cpu_device(cpu);
 	if (!obj)
 		return 0;
 
diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 9dff77b..fa3ed25 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -1,17 +1,18 @@
 /*
- * sys.c - pseudo-bus for system 'devices' (cpus, PICs, timers, etc)
+ * Support for System devices
  *
- * Copyright (c) 2002-3 Patrick Mochel
- *               2002-3 Open Source Development Lab
+ * Copyright (C) 2002-2003 Patrick Mochel
+ * Copyright (C) 2002-2003 Open Source Development Lab
+ * Copyright (C) 2011 Kay Sievers <kay.sievers@vrfy.org>
  *
  * This file is released under the GPLv2
  *
- * This exports a 'system' bus type.
- * By default, a 'sys' bus gets added to the root of the system. There will
- * always be core system devices. Devices can use sysdev_register() to
- * add themselves as children of the system bus.
+ * This creates the /sys/devices/system directory and provides support
+ * to create root devices below to act as a parent for the basic system
+ * devices like cpu, memory, clocksource, ...
  */
 
+#include <linux/slab.h>
 #include <linux/sysdev.h>
 #include <linux/err.h>
 #include <linux/module.h>
@@ -25,10 +26,57 @@
 
 #include "base.h"
 
+/* the /sys/devices/system directory */
+static struct kset *system_kset;
+
+static void root_device_release(struct device *dev)
+{
+	kfree(dev);
+}
+
+int system_root_device(struct device **dev,
+		       struct bus_type *subsys,
+		       const struct attribute_group **groups)
+{
+	struct device *d;
+	int err;
+
+	d = kzalloc(sizeof(struct device), GFP_KERNEL);
+	if (!d)
+		return -ENOMEM;
+
+	err = dev_set_name(d, "%s", subsys->name);
+	if (err < 0) {
+		kfree(d);
+		return err;
+	}
+
+	d->kobj.parent = &system_kset->kobj;
+	d->groups = groups;
+	d->release = root_device_release;
+
+	err = device_register(d);
+	if (err < 0) {
+		put_device(d);
+		return err;
+	}
+
+	*dev = d;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(system_root_device);
+
+int __init system_bus_init(void)
+{
+	system_kset = kset_create_and_add("system", NULL, &devices_kset->kobj);
+	if (!system_kset)
+		return -ENOMEM;
+	return 0;
+}
+
 #define to_sysdev(k) container_of(k, struct sys_device, kobj)
 #define to_sysdev_attr(a) container_of(a, struct sysdev_attribute, attr)
 
-
 static ssize_t
 sysdev_show(struct kobject *kobj, struct attribute *attr, char *buffer)
 {
@@ -126,8 +174,6 @@ void sysdev_class_remove_file(struct sysdev_class *c,
 }
 EXPORT_SYMBOL_GPL(sysdev_class_remove_file);
 
-static struct kset *system_kset;
-
 int sysdev_class_register(struct sysdev_class *cls)
 {
 	int retval;
@@ -331,14 +377,6 @@ void sysdev_unregister(struct sys_device *sysdev)
 EXPORT_SYMBOL_GPL(sysdev_register);
 EXPORT_SYMBOL_GPL(sysdev_unregister);
 
-int __init system_bus_init(void)
-{
-	system_kset = kset_create_and_add("system", NULL, &devices_kset->kobj);
-	if (!system_kset)
-		return -ENOMEM;
-	return 0;
-}
-
 #define to_ext_attr(x) container_of(x, struct sysdev_ext_attribute, attr)
 
 ssize_t sysdev_store_ulong(struct sys_device *sysdev,
@@ -388,4 +426,3 @@ ssize_t sysdev_show_int(struct sys_device *sysdev,
 	return snprintf(buf, PAGE_SIZE, "%d\n", *(int *)(ea->var));
 }
 EXPORT_SYMBOL_GPL(sysdev_show_int);
-
diff --git a/drivers/base/topology.c b/drivers/base/topology.c
index f6f37a0..ae989c5 100644
--- a/drivers/base/topology.c
+++ b/drivers/base/topology.c
@@ -23,7 +23,6 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  */
-#include <linux/sysdev.h>
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/cpu.h>
@@ -32,14 +31,14 @@
 #include <linux/topology.h>
 
 #define define_one_ro_named(_name, _func)				\
-static SYSDEV_ATTR(_name, 0444, _func, NULL)
+	static DEVICE_ATTR(_name, 0444, _func, NULL)
 
 #define define_one_ro(_name)				\
-static SYSDEV_ATTR(_name, 0444, show_##_name, NULL)
+	static DEVICE_ATTR(_name, 0444, show_##_name, NULL)
 
 #define define_id_show_func(name)				\
-static ssize_t show_##name(struct sys_device *dev,		\
-		struct sysdev_attribute *attr, char *buf)	\
+static ssize_t show_##name(struct device *dev,			\
+		struct device_attribute *attr, char *buf)	\
 {								\
 	unsigned int cpu = dev->id;				\
 	return sprintf(buf, "%d\n", topology_##name(cpu));	\
@@ -65,16 +64,16 @@ static ssize_t show_cpumap(int type, const struct cpumask *mask, char *buf)
 
 #ifdef arch_provides_topology_pointers
 #define define_siblings_show_map(name)					\
-static ssize_t show_##name(struct sys_device *dev,			\
-			   struct sysdev_attribute *attr, char *buf)	\
+static ssize_t show_##name(struct device *dev,				\
+			   struct device_attribute *attr, char *buf)	\
 {									\
 	unsigned int cpu = dev->id;					\
 	return show_cpumap(0, topology_##name(cpu), buf);		\
 }
 
 #define define_siblings_show_list(name)					\
-static ssize_t show_##name##_list(struct sys_device *dev,		\
-				  struct sysdev_attribute *attr,	\
+static ssize_t show_##name##_list(struct device *dev,			\
+				  struct device_attribute *attr,	\
 				  char *buf)				\
 {									\
 	unsigned int cpu = dev->id;					\
@@ -83,15 +82,15 @@ static ssize_t show_##name##_list(struct sys_device *dev,		\
 
 #else
 #define define_siblings_show_map(name)					\
-static ssize_t show_##name(struct sys_device *dev,			\
-			   struct sysdev_attribute *attr, char *buf)	\
+static ssize_t show_##name(struct device *dev,				\
+			   struct device_attribute *attr, char *buf)	\
 {									\
 	return show_cpumap(0, topology_##name(dev->id), buf);		\
 }
 
 #define define_siblings_show_list(name)					\
-static ssize_t show_##name##_list(struct sys_device *dev,		\
-				  struct sysdev_attribute *attr,	\
+static ssize_t show_##name##_list(struct device *dev,			\
+				  struct device_attribute *attr,	\
 				  char *buf)				\
 {									\
 	return show_cpumap(1, topology_##name(dev->id), buf);		\
@@ -124,16 +123,16 @@ define_one_ro_named(book_siblings_list, show_book_cpumask_list);
 #endif
 
 static struct attribute *default_attrs[] = {
-	&attr_physical_package_id.attr,
-	&attr_core_id.attr,
-	&attr_thread_siblings.attr,
-	&attr_thread_siblings_list.attr,
-	&attr_core_siblings.attr,
-	&attr_core_siblings_list.attr,
+	&dev_attr_physical_package_id.attr,
+	&dev_attr_core_id.attr,
+	&dev_attr_thread_siblings.attr,
+	&dev_attr_thread_siblings_list.attr,
+	&dev_attr_core_siblings.attr,
+	&dev_attr_core_siblings_list.attr,
 #ifdef CONFIG_SCHED_BOOK
-	&attr_book_id.attr,
-	&attr_book_siblings.attr,
-	&attr_book_siblings_list.attr,
+	&dev_attr_book_id.attr,
+	&dev_attr_book_siblings.attr,
+	&dev_attr_book_siblings_list.attr,
 #endif
 	NULL
 };
@@ -146,16 +145,16 @@ static struct attribute_group topology_attr_group = {
 /* Add/Remove cpu_topology interface for CPU device */
 static int __cpuinit topology_add_dev(unsigned int cpu)
 {
-	struct sys_device *sys_dev = get_cpu_sysdev(cpu);
+	struct device *dev = get_cpu_device(cpu);
 
-	return sysfs_create_group(&sys_dev->kobj, &topology_attr_group);
+	return sysfs_create_group(&dev->kobj, &topology_attr_group);
 }
 
 static void __cpuinit topology_remove_dev(unsigned int cpu)
 {
-	struct sys_device *sys_dev = get_cpu_sysdev(cpu);
+	struct device *dev = get_cpu_device(cpu);
 
-	sysfs_remove_group(&sys_dev->kobj, &topology_attr_group);
+	sysfs_remove_group(&dev->kobj, &topology_attr_group);
 }
 
 static int __cpuinit topology_cpu_callback(struct notifier_block *nfb,
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 987a165..1985a45 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -679,7 +679,7 @@ static struct kobj_type ktype_cpufreq = {
  */
 static int cpufreq_add_dev_policy(unsigned int cpu,
 				  struct cpufreq_policy *policy,
-				  struct sys_device *sys_dev)
+				  struct device *dev)
 {
 	int ret = 0;
 #ifdef CONFIG_SMP
@@ -728,7 +728,7 @@ static int cpufreq_add_dev_policy(unsigned int cpu,
 			spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 			pr_debug("CPU already managed, adding link\n");
-			ret = sysfs_create_link(&sys_dev->kobj,
+			ret = sysfs_create_link(&dev->kobj,
 						&managed_policy->kobj,
 						"cpufreq");
 			if (ret)
@@ -761,7 +761,7 @@ static int cpufreq_add_dev_symlink(unsigned int cpu,
 
 	for_each_cpu(j, policy->cpus) {
 		struct cpufreq_policy *managed_policy;
-		struct sys_device *cpu_sys_dev;
+		struct device *cpu_dev;
 
 		if (j == cpu)
 			continue;
@@ -770,8 +770,8 @@ static int cpufreq_add_dev_symlink(unsigned int cpu,
 
 		pr_debug("CPU %u already managed, adding link\n", j);
 		managed_policy = cpufreq_cpu_get(cpu);
-		cpu_sys_dev = get_cpu_sysdev(j);
-		ret = sysfs_create_link(&cpu_sys_dev->kobj, &policy->kobj,
+		cpu_dev = get_cpu_device(j);
+		ret = sysfs_create_link(&cpu_dev->kobj, &policy->kobj,
 					"cpufreq");
 		if (ret) {
 			cpufreq_cpu_put(managed_policy);
@@ -783,7 +783,7 @@ static int cpufreq_add_dev_symlink(unsigned int cpu,
 
 static int cpufreq_add_dev_interface(unsigned int cpu,
 				     struct cpufreq_policy *policy,
-				     struct sys_device *sys_dev)
+				     struct device *dev)
 {
 	struct cpufreq_policy new_policy;
 	struct freq_attr **drv_attr;
@@ -793,7 +793,7 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
 
 	/* prepare interface data */
 	ret = kobject_init_and_add(&policy->kobj, &ktype_cpufreq,
-				   &sys_dev->kobj, "cpufreq");
+				   &dev->kobj, "cpufreq");
 	if (ret)
 		return ret;
 
@@ -866,9 +866,9 @@ err_out_kobj_put:
  * with with cpu hotplugging and all hell will break loose. Tried to clean this
  * mess up, but more thorough testing is needed. - Mathieu
  */
-static int cpufreq_add_dev(struct sys_device *sys_dev)
+static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 {
-	unsigned int cpu = sys_dev->id;
+	unsigned int cpu = dev->id;
 	int ret = 0, found = 0;
 	struct cpufreq_policy *policy;
 	unsigned long flags;
@@ -947,7 +947,7 @@ static int cpufreq_add_dev(struct sys_device *sys_dev)
 	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
 				     CPUFREQ_START, policy);
 
-	ret = cpufreq_add_dev_policy(cpu, policy, sys_dev);
+	ret = cpufreq_add_dev_policy(cpu, policy, dev);
 	if (ret) {
 		if (ret > 0)
 			/* This is a managed cpu, symlink created,
@@ -956,7 +956,7 @@ static int cpufreq_add_dev(struct sys_device *sys_dev)
 		goto err_unlock_policy;
 	}
 
-	ret = cpufreq_add_dev_interface(cpu, policy, sys_dev);
+	ret = cpufreq_add_dev_interface(cpu, policy, dev);
 	if (ret)
 		goto err_out_unregister;
 
@@ -999,15 +999,15 @@ module_out:
  * Caller should already have policy_rwsem in write mode for this CPU.
  * This routine frees the rwsem before returning.
  */
-static int __cpufreq_remove_dev(struct sys_device *sys_dev)
+static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif)
 {
-	unsigned int cpu = sys_dev->id;
+	unsigned int cpu = dev->id;
 	unsigned long flags;
 	struct cpufreq_policy *data;
 	struct kobject *kobj;
 	struct completion *cmp;
 #ifdef CONFIG_SMP
-	struct sys_device *cpu_sys_dev;
+	struct device *cpu_dev;
 	unsigned int j;
 #endif
 
@@ -1032,7 +1032,7 @@ static int __cpufreq_remove_dev(struct sys_device *sys_dev)
 		pr_debug("removing link\n");
 		cpumask_clear_cpu(cpu, data->cpus);
 		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
-		kobj = &sys_dev->kobj;
+		kobj = &dev->kobj;
 		cpufreq_cpu_put(data);
 		unlock_policy_rwsem_write(cpu);
 		sysfs_remove_link(kobj, "cpufreq");
@@ -1071,8 +1071,8 @@ static int __cpufreq_remove_dev(struct sys_device *sys_dev)
 			strncpy(per_cpu(cpufreq_cpu_governor, j),
 				data->governor->name, CPUFREQ_NAME_LEN);
 #endif
-			cpu_sys_dev = get_cpu_sysdev(j);
-			kobj = &cpu_sys_dev->kobj;
+			cpu_dev = get_cpu_device(j);
+			kobj = &cpu_dev->kobj;
 			unlock_policy_rwsem_write(cpu);
 			sysfs_remove_link(kobj, "cpufreq");
 			lock_policy_rwsem_write(cpu);
@@ -1112,11 +1112,11 @@ static int __cpufreq_remove_dev(struct sys_device *sys_dev)
 	if (unlikely(cpumask_weight(data->cpus) > 1)) {
 		/* first sibling now owns the new sysfs dir */
 		cpumask_clear_cpu(cpu, data->cpus);
-		cpufreq_add_dev(get_cpu_sysdev(cpumask_first(data->cpus)));
+		cpufreq_add_dev(get_cpu_device(cpumask_first(data->cpus)), NULL);
 
 		/* finally remove our own symlink */
 		lock_policy_rwsem_write(cpu);
-		__cpufreq_remove_dev(sys_dev);
+		__cpufreq_remove_dev(dev, sif);
 	}
 #endif
 
@@ -1128,9 +1128,9 @@ static int __cpufreq_remove_dev(struct sys_device *sys_dev)
 }
 
 
-static int cpufreq_remove_dev(struct sys_device *sys_dev)
+static int cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif)
 {
-	unsigned int cpu = sys_dev->id;
+	unsigned int cpu = dev->id;
 	int retval;
 
 	if (cpu_is_offline(cpu))
@@ -1139,7 +1139,7 @@ static int cpufreq_remove_dev(struct sys_device *sys_dev)
 	if (unlikely(lock_policy_rwsem_write(cpu)))
 		BUG();
 
-	retval = __cpufreq_remove_dev(sys_dev);
+	retval = __cpufreq_remove_dev(dev, sif);
 	return retval;
 }
 
@@ -1271,9 +1271,11 @@ out:
 }
 EXPORT_SYMBOL(cpufreq_get);
 
-static struct sysdev_driver cpufreq_sysdev_driver = {
-	.add		= cpufreq_add_dev,
-	.remove		= cpufreq_remove_dev,
+static struct subsys_interface cpufreq_interface = {
+	.name		= "cpufreq",
+	.subsys		= &cpu_subsys,
+	.add_dev	= cpufreq_add_dev,
+	.remove_dev	= cpufreq_remove_dev,
 };
 
 
@@ -1765,25 +1767,25 @@ static int __cpuinit cpufreq_cpu_callback(struct notifier_block *nfb,
 					unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
-	struct sys_device *sys_dev;
+	struct device *dev;
 
-	sys_dev = get_cpu_sysdev(cpu);
-	if (sys_dev) {
+	dev = get_cpu_device(cpu);
+	if (dev) {
 		switch (action) {
 		case CPU_ONLINE:
 		case CPU_ONLINE_FROZEN:
-			cpufreq_add_dev(sys_dev);
+			cpufreq_add_dev(dev, NULL);
 			break;
 		case CPU_DOWN_PREPARE:
 		case CPU_DOWN_PREPARE_FROZEN:
 			if (unlikely(lock_policy_rwsem_write(cpu)))
 				BUG();
 
-			__cpufreq_remove_dev(sys_dev);
+			__cpufreq_remove_dev(dev, NULL);
 			break;
 		case CPU_DOWN_FAILED:
 		case CPU_DOWN_FAILED_FROZEN:
-			cpufreq_add_dev(sys_dev);
+			cpufreq_add_dev(dev, NULL);
 			break;
 		}
 	}
@@ -1830,8 +1832,7 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 	cpufreq_driver = driver_data;
 	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
-	ret = sysdev_driver_register(&cpu_sysdev_class,
-					&cpufreq_sysdev_driver);
+	ret = subsys_interface_register(&cpufreq_interface);
 	if (ret)
 		goto err_null_driver;
 
@@ -1850,7 +1851,7 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 		if (ret) {
 			pr_debug("no CPU initialized for driver %s\n",
 							driver_data->name);
-			goto err_sysdev_unreg;
+			goto err_if_unreg;
 		}
 	}
 
@@ -1858,9 +1859,8 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 	pr_debug("driver %s up and running\n", driver_data->name);
 
 	return 0;
-err_sysdev_unreg:
-	sysdev_driver_unregister(&cpu_sysdev_class,
-			&cpufreq_sysdev_driver);
+err_if_unreg:
+	subsys_interface_unregister(&cpufreq_interface);
 err_null_driver:
 	spin_lock_irqsave(&cpufreq_driver_lock, flags);
 	cpufreq_driver = NULL;
@@ -1887,7 +1887,7 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver)
 
 	pr_debug("unregistering driver %s\n", driver->name);
 
-	sysdev_driver_unregister(&cpu_sysdev_class, &cpufreq_sysdev_driver);
+	subsys_interface_unregister(&cpufreq_interface);
 	unregister_hotcpu_notifier(&cpufreq_cpu_notifier);
 
 	spin_lock_irqsave(&cpufreq_driver_lock, flags);
@@ -1907,8 +1907,7 @@ static int __init cpufreq_core_init(void)
 		init_rwsem(&per_cpu(cpu_policy_rwsem, cpu));
 	}
 
-	cpufreq_global_kobject = kobject_create_and_add("cpufreq",
-						&cpu_sysdev_class.kset.kobj);
+	cpufreq_global_kobject = kobject_create_and_add("cpufreq", &cpu_root_dev->kobj);
 	BUG_ON(!cpufreq_global_kobject);
 	register_syscore_ops(&cpufreq_syscore_ops);
 
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 06ce268..a95fe5b 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -291,10 +291,10 @@ EXPORT_SYMBOL_GPL(cpuidle_disable_device);
 static int __cpuidle_register_device(struct cpuidle_device *dev)
 {
 	int ret;
-	struct sys_device *sys_dev = get_cpu_sysdev((unsigned long)dev->cpu);
+	struct device *cpu_dev = get_cpu_device((unsigned long)dev->cpu);
 	struct cpuidle_driver *cpuidle_driver = cpuidle_get_driver();
 
-	if (!sys_dev)
+	if (!dev)
 		return -EINVAL;
 	if (!try_module_get(cpuidle_driver->owner))
 		return -EINVAL;
@@ -303,7 +303,7 @@ static int __cpuidle_register_device(struct cpuidle_device *dev)
 
 	per_cpu(cpuidle_devices, dev->cpu) = dev;
 	list_add(&dev->device_list, &cpuidle_detected_devices);
-	if ((ret = cpuidle_add_sysfs(sys_dev))) {
+	if ((ret = cpuidle_add_sysfs(cpu_dev))) {
 		module_put(cpuidle_driver->owner);
 		return ret;
 	}
@@ -344,7 +344,7 @@ EXPORT_SYMBOL_GPL(cpuidle_register_device);
  */
 void cpuidle_unregister_device(struct cpuidle_device *dev)
 {
-	struct sys_device *sys_dev = get_cpu_sysdev((unsigned long)dev->cpu);
+	struct device *cpu_dev = get_cpu_device((unsigned long)dev->cpu);
 	struct cpuidle_driver *cpuidle_driver = cpuidle_get_driver();
 
 	if (dev->registered == 0)
@@ -354,7 +354,7 @@ void cpuidle_unregister_device(struct cpuidle_device *dev)
 
 	cpuidle_disable_device(dev);
 
-	cpuidle_remove_sysfs(sys_dev);
+	cpuidle_remove_sysfs(cpu_dev);
 	list_del(&dev->device_list);
 	wait_for_completion(&dev->kobj_unregister);
 	per_cpu(cpuidle_devices, dev->cpu) = NULL;
@@ -411,7 +411,7 @@ static int __init cpuidle_init(void)
 	if (cpuidle_disabled())
 		return -ENODEV;
 
-	ret = cpuidle_add_class_sysfs(&cpu_sysdev_class);
+	ret = cpuidle_add_interface(cpu_root_dev);
 	if (ret)
 		return ret;
 
diff --git a/drivers/cpuidle/cpuidle.h b/drivers/cpuidle/cpuidle.h
index 38c3fd8..7db1866 100644
--- a/drivers/cpuidle/cpuidle.h
+++ b/drivers/cpuidle/cpuidle.h
@@ -5,7 +5,7 @@
 #ifndef __DRIVER_CPUIDLE_H
 #define __DRIVER_CPUIDLE_H
 
-#include <linux/sysdev.h>
+#include <linux/device.h>
 
 /* For internal use only */
 extern struct cpuidle_governor *cpuidle_curr_governor;
@@ -23,11 +23,11 @@ extern void cpuidle_uninstall_idle_handler(void);
 extern int cpuidle_switch_governor(struct cpuidle_governor *gov);
 
 /* sysfs */
-extern int cpuidle_add_class_sysfs(struct sysdev_class *cls);
-extern void cpuidle_remove_class_sysfs(struct sysdev_class *cls);
+extern int cpuidle_add_interface(struct device *dev);
+extern void cpuidle_remove_interface(struct device *dev);
 extern int cpuidle_add_state_sysfs(struct cpuidle_device *device);
 extern void cpuidle_remove_state_sysfs(struct cpuidle_device *device);
-extern int cpuidle_add_sysfs(struct sys_device *sysdev);
-extern void cpuidle_remove_sysfs(struct sys_device *sysdev);
+extern int cpuidle_add_sysfs(struct device *dev);
+extern void cpuidle_remove_sysfs(struct device *dev);
 
 #endif /* __DRIVER_CPUIDLE_H */
diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
index 1e756e1..3fe41fe 100644
--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -22,8 +22,8 @@ static int __init cpuidle_sysfs_setup(char *unused)
 }
 __setup("cpuidle_sysfs_switch", cpuidle_sysfs_setup);
 
-static ssize_t show_available_governors(struct sysdev_class *class,
-					struct sysdev_class_attribute *attr,
+static ssize_t show_available_governors(struct device *dev,
+					struct device_attribute *attr,
 					char *buf)
 {
 	ssize_t i = 0;
@@ -42,8 +42,8 @@ out:
 	return i;
 }
 
-static ssize_t show_current_driver(struct sysdev_class *class,
-				   struct sysdev_class_attribute *attr,
+static ssize_t show_current_driver(struct device *dev,
+				   struct device_attribute *attr,
 				   char *buf)
 {
 	ssize_t ret;
@@ -59,8 +59,8 @@ static ssize_t show_current_driver(struct sysdev_class *class,
 	return ret;
 }
 
-static ssize_t show_current_governor(struct sysdev_class *class,
-				     struct sysdev_class_attribute *attr,
+static ssize_t show_current_governor(struct device *dev,
+				     struct device_attribute *attr,
 				     char *buf)
 {
 	ssize_t ret;
@@ -75,8 +75,8 @@ static ssize_t show_current_governor(struct sysdev_class *class,
 	return ret;
 }
 
-static ssize_t store_current_governor(struct sysdev_class *class,
-				      struct sysdev_class_attribute *attr,
+static ssize_t store_current_governor(struct device *dev,
+				      struct device_attribute *attr,
 				      const char *buf, size_t count)
 {
 	char gov_name[CPUIDLE_NAME_LEN];
@@ -109,50 +109,48 @@ static ssize_t store_current_governor(struct sysdev_class *class,
 		return count;
 }
 
-static SYSDEV_CLASS_ATTR(current_driver, 0444, show_current_driver, NULL);
-static SYSDEV_CLASS_ATTR(current_governor_ro, 0444, show_current_governor,
-			 NULL);
+static DEVICE_ATTR(current_driver, 0444, show_current_driver, NULL);
+static DEVICE_ATTR(current_governor_ro, 0444, show_current_governor, NULL);
 
-static struct attribute *cpuclass_default_attrs[] = {
-	&attr_current_driver.attr,
-	&attr_current_governor_ro.attr,
+static struct attribute *cpuidle_default_attrs[] = {
+	&dev_attr_current_driver.attr,
+	&dev_attr_current_governor_ro.attr,
 	NULL
 };
 
-static SYSDEV_CLASS_ATTR(available_governors, 0444, show_available_governors,
-			 NULL);
-static SYSDEV_CLASS_ATTR(current_governor, 0644, show_current_governor,
-			 store_current_governor);
+static DEVICE_ATTR(available_governors, 0444, show_available_governors, NULL);
+static DEVICE_ATTR(current_governor, 0644, show_current_governor,
+		   store_current_governor);
 
-static struct attribute *cpuclass_switch_attrs[] = {
-	&attr_available_governors.attr,
-	&attr_current_driver.attr,
-	&attr_current_governor.attr,
+static struct attribute *cpuidle_switch_attrs[] = {
+	&dev_attr_available_governors.attr,
+	&dev_attr_current_driver.attr,
+	&dev_attr_current_governor.attr,
 	NULL
 };
 
-static struct attribute_group cpuclass_attr_group = {
-	.attrs = cpuclass_default_attrs,
+static struct attribute_group cpuidle_attr_group = {
+	.attrs = cpuidle_default_attrs,
 	.name = "cpuidle",
 };
 
 /**
- * cpuidle_add_class_sysfs - add CPU global sysfs attributes
+ * cpuidle_add_interface - add CPU global sysfs attributes
  */
-int cpuidle_add_class_sysfs(struct sysdev_class *cls)
+int cpuidle_add_interface(struct device *dev)
 {
 	if (sysfs_switch)
-		cpuclass_attr_group.attrs = cpuclass_switch_attrs;
+		cpuidle_attr_group.attrs = cpuidle_switch_attrs;
 
-	return sysfs_create_group(&cls->kset.kobj, &cpuclass_attr_group);
+	return sysfs_create_group(&dev->kobj, &cpuidle_attr_group);
 }
 
 /**
- * cpuidle_remove_class_sysfs - remove CPU global sysfs attributes
+ * cpuidle_remove_interface - remove CPU global sysfs attributes
  */
-void cpuidle_remove_class_sysfs(struct sysdev_class *cls)
+void cpuidle_remove_interface(struct device *dev)
 {
-	sysfs_remove_group(&cls->kset.kobj, &cpuclass_attr_group);
+	sysfs_remove_group(&dev->kobj, &cpuidle_attr_group);
 }
 
 struct cpuidle_attr {
@@ -365,16 +363,16 @@ void cpuidle_remove_state_sysfs(struct cpuidle_device *device)
 
 /**
  * cpuidle_add_sysfs - creates a sysfs instance for the target device
- * @sysdev: the target device
+ * @dev: the target device
  */
-int cpuidle_add_sysfs(struct sys_device *sysdev)
+int cpuidle_add_sysfs(struct device *cpu_dev)
 {
-	int cpu = sysdev->id;
+	int cpu = cpu_dev->id;
 	struct cpuidle_device *dev;
 	int error;
 
 	dev = per_cpu(cpuidle_devices, cpu);
-	error = kobject_init_and_add(&dev->kobj, &ktype_cpuidle, &sysdev->kobj,
+	error = kobject_init_and_add(&dev->kobj, &ktype_cpuidle, &cpu_dev->kobj,
 				     "cpuidle");
 	if (!error)
 		kobject_uevent(&dev->kobj, KOBJ_ADD);
@@ -383,11 +381,11 @@ int cpuidle_add_sysfs(struct sys_device *sysdev)
 
 /**
  * cpuidle_remove_sysfs - deletes a sysfs instance on the target device
- * @sysdev: the target device
+ * @dev: the target device
  */
-void cpuidle_remove_sysfs(struct sys_device *sysdev)
+void cpuidle_remove_sysfs(struct device *cpu_dev)
 {
-	int cpu = sysdev->id;
+	int cpu = cpu_dev->id;
 	struct cpuidle_device *dev;
 
 	dev = per_cpu(cpuidle_devices, cpu);
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 6cb60fd..823aecb 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -14,7 +14,7 @@
 #ifndef _LINUX_CPU_H_
 #define _LINUX_CPU_H_
 
-#include <linux/sysdev.h>
+#include <linux/device.h>
 #include <linux/node.h>
 #include <linux/compiler.h>
 #include <linux/cpumask.h>
@@ -22,19 +22,19 @@
 struct cpu {
 	int node_id;		/* The node which contains the CPU */
 	int hotpluggable;	/* creates sysfs control file if hotpluggable */
-	struct sys_device sysdev;
+	struct device dev;
 };
 
 extern int register_cpu(struct cpu *cpu, int num);
-extern struct sys_device *get_cpu_sysdev(unsigned cpu);
+extern struct device *get_cpu_device(unsigned cpu);
 
-extern int cpu_add_sysdev_attr(struct sysdev_attribute *attr);
-extern void cpu_remove_sysdev_attr(struct sysdev_attribute *attr);
+extern int cpu_add_dev_attr(struct device_attribute *attr);
+extern void cpu_remove_dev_attr(struct device_attribute *attr);
 
-extern int cpu_add_sysdev_attr_group(struct attribute_group *attrs);
-extern void cpu_remove_sysdev_attr_group(struct attribute_group *attrs);
+extern int cpu_add_dev_attr_group(struct attribute_group *attrs);
+extern void cpu_remove_dev_attr_group(struct attribute_group *attrs);
 
-extern int sched_create_sysfs_power_savings_entries(struct sysdev_class *cls);
+extern int sched_create_sysfs_power_savings_entries(struct device *dev);
 
 #ifdef CONFIG_HOTPLUG_CPU
 extern void unregister_cpu(struct cpu *cpu);
@@ -160,7 +160,8 @@ static inline void cpu_maps_update_done(void)
 }
 
 #endif /* CONFIG_SMP */
-extern struct sysdev_class cpu_sysdev_class;
+extern struct bus_type cpu_subsys;
+extern struct device *cpu_root_dev;
 
 #ifdef CONFIG_HOTPLUG_CPU
 /* Stop CPUs going up and down. */
diff --git a/include/linux/device.h b/include/linux/device.h
index 3136ede..23aa8bf 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -53,6 +53,8 @@ extern void bus_remove_file(struct bus_type *, struct bus_attribute *);
  * struct bus_type - The bus type of the device
  *
  * @name:	The name of the bus.
+ * @dev_name:	Used for subsystems to enumerate devices like "foo%u".
+ * @dev_root:	Default device to use as the parent.
  * @bus_attrs:	Default attributes of the bus.
  * @dev_attrs:	Default attributes of the devices on the bus.
  * @drv_attrs:	Default attributes of the device drivers on the bus.
@@ -86,6 +88,8 @@ extern void bus_remove_file(struct bus_type *, struct bus_attribute *);
  */
 struct bus_type {
 	const char		*name;
+	const char		*dev_name;
+	struct device		*dev_root;
 	struct bus_attribute	*bus_attrs;
 	struct device_attribute	*dev_attrs;
 	struct driver_attribute	*drv_attrs;
@@ -106,12 +110,30 @@ struct bus_type {
 	struct subsys_private *p;
 };
 
-extern int __must_check bus_register(struct bus_type *bus);
+/* This is a #define to keep the compiler from merging different
+ * instances of the __key variable */
+#define bus_register(subsys)			\
+({						\
+	static struct lock_class_key __key;	\
+	__bus_register(subsys, &__key);	\
+})
+extern int __must_check __bus_register(struct bus_type *bus,
+				       struct lock_class_key *key);
 extern void bus_unregister(struct bus_type *bus);
 
 extern int __must_check bus_rescan_devices(struct bus_type *bus);
 
 /* iterator helpers for buses */
+struct subsys_dev_iter {
+	struct klist_iter		ki;
+	const struct device_type	*type;
+};
+void subsys_dev_iter_init(struct subsys_dev_iter *iter,
+			 struct bus_type *subsys,
+			 struct device *start,
+			 const struct device_type *type);
+struct device *subsys_dev_iter_next(struct subsys_dev_iter *iter);
+void subsys_dev_iter_exit(struct subsys_dev_iter *iter);
 
 int bus_for_each_dev(struct bus_type *bus, struct device *start, void *data,
 		     int (*fn)(struct device *dev, void *data));
@@ -121,10 +143,8 @@ struct device *bus_find_device(struct bus_type *bus, struct device *start,
 struct device *bus_find_device_by_name(struct bus_type *bus,
 				       struct device *start,
 				       const char *name);
-
 int bus_for_each_drv(struct bus_type *bus, struct device_driver *start,
 		     void *data, int (*fn)(struct device_driver *, void *));
-
 void bus_sort_breadthfirst(struct bus_type *bus,
 			   int (*compare)(const struct device *a,
 					  const struct device *b));
@@ -256,6 +276,42 @@ struct device *driver_find_device(struct device_driver *drv,
 				  int (*match)(struct device *dev, void *data));
 
 /**
+ * struct subsys_interface - interfaces to device functions
+ * @name        name of the device function
+ * @subsystem   subsytem of the devices to attach to
+ * @node        the list of functions registered at the subsystem
+ * @add         device hookup to device function handler
+ * @remove      device hookup to device function handler
+ *
+ * Simple interfaces attached to a subsystem. Multiple interfaces can
+ * attach to a subsystem and its devices. Unlike drivers, they do not
+ * exclusively claim or control devices. Interfaces usually represent
+ * a specific functionality of a subsystem/class of devices.
+ */
+struct subsys_interface {
+	const char *name;
+	struct bus_type *subsys;
+	struct list_head node;
+	int (*add_dev)(struct device *dev, struct subsys_interface *sif);
+	int (*remove_dev)(struct device *dev, struct subsys_interface *sif);
+};
+
+int subsys_interface_register(struct subsys_interface *sif);
+void subsys_interface_unregister(struct subsys_interface *sif);
+
+/**
+ * system_root_device
+ * @dev         created root device with the name of the subsystem
+ * @subsys      subsystem for the system root device
+ * @groups      default attribute groups to create
+ *
+ * Register a parent device in /sys/devices/system/<name>.
+ */
+int system_root_device(struct device **dev,
+		       struct bus_type *subsys,
+		       const struct attribute_group **groups);
+
+/**
  * struct class - device classes
  * @name:	Name of the class.
  * @owner:	The module owner.
@@ -600,6 +656,7 @@ struct device {
 	struct device_node	*of_node; /* associated device tree node */
 
 	dev_t			devt;	/* dev_t, creates the sysfs "dev" */
+	u32			id;	/* device instance */
 
 	spinlock_t		devres_lock;
 	struct list_head	devres_head;
diff --git a/kernel/sched.c b/kernel/sched.c
index d6b149c..a7f381a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7940,54 +7940,52 @@ static ssize_t sched_power_savings_store(const char *buf, size_t count, int smt)
 }
 
 #ifdef CONFIG_SCHED_MC
-static ssize_t sched_mc_power_savings_show(struct sysdev_class *class,
-					   struct sysdev_class_attribute *attr,
-					   char *page)
+static ssize_t sched_mc_power_savings_show(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
 {
-	return sprintf(page, "%u\n", sched_mc_power_savings);
+	return sprintf(buf, "%u\n", sched_mc_power_savings);
 }
-static ssize_t sched_mc_power_savings_store(struct sysdev_class *class,
-					    struct sysdev_class_attribute *attr,
+static ssize_t sched_mc_power_savings_store(struct device *dev,
+					    struct device_attribute *attr,
 					    const char *buf, size_t count)
 {
 	return sched_power_savings_store(buf, count, 0);
 }
-static SYSDEV_CLASS_ATTR(sched_mc_power_savings, 0644,
-			 sched_mc_power_savings_show,
-			 sched_mc_power_savings_store);
+static DEVICE_ATTR(sched_mc_power_savings, 0644,
+		   sched_mc_power_savings_show,
+		   sched_mc_power_savings_store);
 #endif
 
 #ifdef CONFIG_SCHED_SMT
-static ssize_t sched_smt_power_savings_show(struct sysdev_class *dev,
-					    struct sysdev_class_attribute *attr,
-					    char *page)
+static ssize_t sched_smt_power_savings_show(struct device *dev,
+					    struct device_attribute *attr,
+					    char *buf)
 {
-	return sprintf(page, "%u\n", sched_smt_power_savings);
+	return sprintf(buf, "%u\n", sched_smt_power_savings);
 }
-static ssize_t sched_smt_power_savings_store(struct sysdev_class *dev,
-					     struct sysdev_class_attribute *attr,
+static ssize_t sched_smt_power_savings_store(struct device *dev,
+					    struct device_attribute *attr,
 					     const char *buf, size_t count)
 {
 	return sched_power_savings_store(buf, count, 1);
 }
-static SYSDEV_CLASS_ATTR(sched_smt_power_savings, 0644,
+static DEVICE_ATTR(sched_smt_power_savings, 0644,
 		   sched_smt_power_savings_show,
 		   sched_smt_power_savings_store);
 #endif
 
-int __init sched_create_sysfs_power_savings_entries(struct sysdev_class *cls)
+int __init sched_create_sysfs_power_savings_entries(struct device *dev)
 {
 	int err = 0;
 
 #ifdef CONFIG_SCHED_SMT
 	if (smt_capable())
-		err = sysfs_create_file(&cls->kset.kobj,
-					&attr_sched_smt_power_savings.attr);
+		err = device_create_file(dev, &dev_attr_sched_smt_power_savings);
 #endif
 #ifdef CONFIG_SCHED_MC
 	if (!err && mc_capable())
-		err = sysfs_create_file(&cls->kset.kobj,
-					&attr_sched_mc_power_savings.attr);
+		err = device_create_file(dev, &dev_attr_sched_mc_power_savings);
 #endif
 	return err;
 }


