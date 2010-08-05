Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760718Ab0HEUiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:38:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:48057 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760603Ab0HEUin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:38:43 -0400
Date: Thu, 5 Aug 2010 20:38:03 GMT
Message-Id: <201008052038.o75Kc3x6022099@hera.kernel.org>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/hwmon for 2.6.36
Cc: Fenghua Yu <fenghua.yu@intel.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <len.brown@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 05 Aug 2010 20:38:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ This topic needs to be merged after x86/cpu ]

Hi Linus,

The following changes since commit 9792db6174d9927700ed288e6d74b9391bf785d1:

  x86, cpu: Package Level Thermal Control, Power Limit Notification definitions (2010-07-30 16:15:32 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-hwmon-for-linus

Fenghua Yu (4):
      x86, hwmon: Package Level Thermal/Power: pkgtemp hwmon driver
      x86, hwmon: Package Level Thermal/Power: thermal throttling handler
      x86, hwmon: Package Level Thermal/Power: power limit
      x86, hwmon: Package Level Thermal/Power: pkgtemp documentation

 Documentation/hwmon/pkgtemp              |   36 +++
 arch/x86/configs/i386_defconfig          |    1 +
 arch/x86/configs/x86_64_defconfig        |    1 +
 arch/x86/kernel/cpu/mcheck/therm_throt.c |  206 +++++++++++---
 drivers/hwmon/Kconfig                    |    7 +
 drivers/hwmon/Makefile                   |    1 +
 drivers/hwmon/pkgtemp.c                  |  456 ++++++++++++++++++++++++++++++
 7 files changed, 669 insertions(+), 39 deletions(-)
 create mode 100644 Documentation/hwmon/pkgtemp
 create mode 100644 drivers/hwmon/pkgtemp.c

diff --git a/Documentation/hwmon/pkgtemp b/Documentation/hwmon/pkgtemp
new file mode 100644
index 0000000..c8e1fb0
--- /dev/null
+++ b/Documentation/hwmon/pkgtemp
@@ -0,0 +1,36 @@
+Kernel driver pkgtemp
+======================
+
+Supported chips:
+  * Intel family
+    Prefix: 'pkgtemp'
+    CPUID:
+    Datasheet: Intel 64 and IA-32 Architectures Software Developer's Manual
+               Volume 3A: System Programming Guide
+
+Author: Fenghua Yu
+
+Description
+-----------
+
+This driver permits reading package level temperature sensor embedded inside
+Intel CPU package. The sensors can be in core, uncore, memory controller, or
+other components in a package. The feature is first implemented in Intel Sandy
+Bridge platform.
+
+Temperature is measured in degrees Celsius and measurement resolution is
+1 degree C. Valid temperatures are from 0 to TjMax degrees C, because the actual
+value of temperature register is in fact a delta from TjMax.
+
+Temperature known as TjMax is the maximum junction temperature of package.
+We get this from MSR_IA32_TEMPERATURE_TARGET. If the MSR is not accessible,
+we define TjMax as 100 degrees Celsius. At this temperature, protection
+mechanism will perform actions to forcibly cool down the package. Alarm
+may be raised, if the temperature grows enough (more than TjMax) to trigger
+the Out-Of-Spec bit. Following table summarizes the exported sysfs files:
+
+temp1_input	  - Package temperature (in millidegrees Celsius).
+temp1_max        - All cooling devices should be turned on.
+temp1_crit	  - Maximum junction temperature (in millidegrees Celsius).
+temp1_crit_alarm - Set when Out-of-spec bit is set, never clears.
+		    Correct CPU operation is no longer guaranteed.
diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index d28fad1..e3a3243 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -1471,6 +1471,7 @@ CONFIG_HWMON=y
 # CONFIG_SENSORS_GL518SM is not set
 # CONFIG_SENSORS_GL520SM is not set
 # CONFIG_SENSORS_CORETEMP is not set
+# CONFIG_SENSORS_PKGTEMP is not set
 # CONFIG_SENSORS_IT87 is not set
 # CONFIG_SENSORS_LM63 is not set
 # CONFIG_SENSORS_LM75 is not set
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index 6c86acd..4251f83 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -1456,6 +1456,7 @@ CONFIG_HWMON=y
 # CONFIG_SENSORS_GL518SM is not set
 # CONFIG_SENSORS_GL520SM is not set
 # CONFIG_SENSORS_CORETEMP is not set
+# CONFIG_SENSORS_PKGTEMP is not set
 # CONFIG_SENSORS_IT87 is not set
 # CONFIG_SENSORS_LM63 is not set
 # CONFIG_SENSORS_LM75 is not set
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index e1a0a3b..c2a8b26 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -34,15 +34,25 @@
 /* How long to wait between reporting thermal events */
 #define CHECK_INTERVAL		(300 * HZ)
 
+#define THERMAL_THROTTLING_EVENT	0
+#define POWER_LIMIT_EVENT		1
+
 /*
- * Current thermal throttling state:
+ * Current thermal event state:
  */
-struct thermal_state {
-	bool			is_throttled;
-
+struct _thermal_state {
+	bool			new_event;
+	int			event;
 	u64			next_check;
-	unsigned long		throttle_count;
-	unsigned long		last_throttle_count;
+	unsigned long		count;
+	unsigned long		last_count;
+};
+
+struct thermal_state {
+	struct _thermal_state core_throttle;
+	struct _thermal_state core_power_limit;
+	struct _thermal_state package_throttle;
+	struct _thermal_state package_power_limit;
 };
 
 static DEFINE_PER_CPU(struct thermal_state, thermal_state);
@@ -53,11 +63,13 @@ static u32 lvtthmr_init __read_mostly;
 
 #ifdef CONFIG_SYSFS
 #define define_therm_throt_sysdev_one_ro(_name)				\
-	static SYSDEV_ATTR(_name, 0444, therm_throt_sysdev_show_##_name, NULL)
+	static SYSDEV_ATTR(_name, 0444,					\
+			   therm_throt_sysdev_show_##_name,		\
+				   NULL)				\
 
-#define define_therm_throt_sysdev_show_func(name)			\
+#define define_therm_throt_sysdev_show_func(event, name)		\
 									\
-static ssize_t therm_throt_sysdev_show_##name(				\
+static ssize_t therm_throt_sysdev_show_##event##_##name(		\
 			struct sys_device *dev,				\
 			struct sysdev_attribute *attr,			\
 			char *buf)					\
@@ -66,30 +78,42 @@ static ssize_t therm_throt_sysdev_show_##name(				\
 	ssize_t ret;							\
 									\
 	preempt_disable();	/* CPU hotplug */			\
-	if (cpu_online(cpu))						\
+	if (cpu_online(cpu)) {						\
 		ret = sprintf(buf, "%lu\n",				\
-			      per_cpu(thermal_state, cpu).name);	\
-	else								\
+			      per_cpu(thermal_state, cpu).event.name);	\
+	} else								\
 		ret = 0;						\
 	preempt_enable();						\
 									\
 	return ret;							\
 }
 
-define_therm_throt_sysdev_show_func(throttle_count);
-define_therm_throt_sysdev_one_ro(throttle_count);
+define_therm_throt_sysdev_show_func(core_throttle, count);
+define_therm_throt_sysdev_one_ro(core_throttle_count);
+
+define_therm_throt_sysdev_show_func(core_power_limit, count);
+define_therm_throt_sysdev_one_ro(core_power_limit_count);
+
+define_therm_throt_sysdev_show_func(package_throttle, count);
+define_therm_throt_sysdev_one_ro(package_throttle_count);
+
+define_therm_throt_sysdev_show_func(package_power_limit, count);
+define_therm_throt_sysdev_one_ro(package_power_limit_count);
 
 static struct attribute *thermal_throttle_attrs[] = {
-	&attr_throttle_count.attr,
+	&attr_core_throttle_count.attr,
 	NULL
 };
 
-static struct attribute_group thermal_throttle_attr_group = {
+static struct attribute_group thermal_attr_group = {
 	.attrs	= thermal_throttle_attrs,
 	.name	= "thermal_throttle"
 };
 #endif /* CONFIG_SYSFS */
 
+#define CORE_LEVEL	0
+#define PACKAGE_LEVEL	1
+
 /***
  * therm_throt_process - Process thermal throttling event from interrupt
  * @curr: Whether the condition is current or not (boolean), since the
@@ -106,39 +130,70 @@ static struct attribute_group thermal_throttle_attr_group = {
  *          1 : Event should be logged further, and a message has been
  *              printed to the syslog.
  */
-static int therm_throt_process(bool is_throttled)
+static int therm_throt_process(bool new_event, int event, int level)
 {
-	struct thermal_state *state;
-	unsigned int this_cpu;
-	bool was_throttled;
+	struct _thermal_state *state;
+	unsigned int this_cpu = smp_processor_id();
+	bool old_event;
 	u64 now;
+	struct thermal_state *pstate = &per_cpu(thermal_state, this_cpu);
 
-	this_cpu = smp_processor_id();
 	now = get_jiffies_64();
-	state = &per_cpu(thermal_state, this_cpu);
+	if (level == CORE_LEVEL) {
+		if (event == THERMAL_THROTTLING_EVENT)
+			state = &pstate->core_throttle;
+		else if (event == POWER_LIMIT_EVENT)
+			state = &pstate->core_power_limit;
+		else
+			 return 0;
+	} else if (level == PACKAGE_LEVEL) {
+		if (event == THERMAL_THROTTLING_EVENT)
+			state = &pstate->package_throttle;
+		else if (event == POWER_LIMIT_EVENT)
+			state = &pstate->package_power_limit;
+		else
+			return 0;
+	} else
+		return 0;
 
-	was_throttled = state->is_throttled;
-	state->is_throttled = is_throttled;
+	old_event = state->new_event;
+	state->new_event = new_event;
 
-	if (is_throttled)
-		state->throttle_count++;
+	if (new_event)
+		state->count++;
 
 	if (time_before64(now, state->next_check) &&
-			state->throttle_count != state->last_throttle_count)
+			state->count != state->last_count)
 		return 0;
 
 	state->next_check = now + CHECK_INTERVAL;
-	state->last_throttle_count = state->throttle_count;
+	state->last_count = state->count;
 
 	/* if we just entered the thermal event */
-	if (is_throttled) {
-		printk(KERN_CRIT "CPU%d: Temperature above threshold, cpu clock throttled (total events = %lu)\n", this_cpu, state->throttle_count);
+	if (new_event) {
+		if (event == THERMAL_THROTTLING_EVENT)
+			printk(KERN_CRIT "CPU%d: %s temperature above threshold, cpu clock throttled (total events = %lu)\n",
+				this_cpu,
+				level == CORE_LEVEL ? "Core" : "Package",
+				state->count);
+		else
+			printk(KERN_CRIT "CPU%d: %s power limit notification (total events = %lu)\n",
+				this_cpu,
+				level == CORE_LEVEL ? "Core" : "Package",
+				state->count);
 
 		add_taint(TAINT_MACHINE_CHECK);
 		return 1;
 	}
-	if (was_throttled) {
-		printk(KERN_INFO "CPU%d: Temperature/speed normal\n", this_cpu);
+	if (old_event) {
+		if (event == THERMAL_THROTTLING_EVENT)
+			printk(KERN_INFO "CPU%d: %s temperature/speed normal\n",
+				this_cpu,
+				level == CORE_LEVEL ? "Core" : "Package");
+		else
+			printk(KERN_INFO "CPU%d: %s power limit normal\n",
+				this_cpu,
+				level == CORE_LEVEL ? "Core" : "Package");
 		return 1;
 	}
 
@@ -149,13 +204,32 @@ static int therm_throt_process(bool is_throttled)
 /* Add/Remove thermal_throttle interface for CPU device: */
 static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev)
 {
-	return sysfs_create_group(&sys_dev->kobj,
-				  &thermal_throttle_attr_group);
+	int err;
+	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
+
+	err = sysfs_create_group(&sys_dev->kobj, &thermal_attr_group);
+	if (err)
+		return err;
+
+	if (cpu_has(c, X86_FEATURE_PLN))
+		err = sysfs_add_file_to_group(&sys_dev->kobj,
+					      &attr_core_power_limit_count.attr,
+					      thermal_attr_group.name);
+	if (cpu_has(c, X86_FEATURE_PTS))
+		err = sysfs_add_file_to_group(&sys_dev->kobj,
+					      &attr_package_throttle_count.attr,
+					      thermal_attr_group.name);
+		if (cpu_has(c, X86_FEATURE_PLN))
+			err = sysfs_add_file_to_group(&sys_dev->kobj,
+					&attr_package_power_limit_count.attr,
+					thermal_attr_group.name);
+
+	return err;
 }
 
 static __cpuinit void thermal_throttle_remove_dev(struct sys_device *sys_dev)
 {
-	sysfs_remove_group(&sys_dev->kobj, &thermal_throttle_attr_group);
+	sysfs_remove_group(&sys_dev->kobj, &thermal_attr_group);
 }
 
 /* Mutex protecting device creation against CPU hotplug: */
@@ -226,14 +300,50 @@ device_initcall(thermal_throttle_init_device);
 
 #endif /* CONFIG_SYSFS */
 
+/*
+ * Set up the most two significant bit to notify mce log that this thermal
+ * event type.
+ * This is a temp solution. May be changed in the future with mce log
+ * infrasture.
+ */
+#define CORE_THROTTLED		(0)
+#define CORE_POWER_LIMIT	((__u64)1 << 62)
+#define PACKAGE_THROTTLED	((__u64)2 << 62)
+#define PACKAGE_POWER_LIMIT	((__u64)3 << 62)
+
 /* Thermal transition interrupt handler */
 static void intel_thermal_interrupt(void)
 {
 	__u64 msr_val;
+	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
 
 	rdmsrl(MSR_IA32_THERM_STATUS, msr_val);
-	if (therm_throt_process((msr_val & THERM_STATUS_PROCHOT) != 0))
-		mce_log_therm_throt_event(msr_val);
+
+	if (therm_throt_process(msr_val & THERM_STATUS_PROCHOT,
+				THERMAL_THROTTLING_EVENT,
+				CORE_LEVEL) != 0)
+		mce_log_therm_throt_event(CORE_THROTTLED | msr_val);
+
+	if (cpu_has(c, X86_FEATURE_PLN))
+		if (therm_throt_process(msr_val & THERM_STATUS_POWER_LIMIT,
+					POWER_LIMIT_EVENT,
+					CORE_LEVEL) != 0)
+			mce_log_therm_throt_event(CORE_POWER_LIMIT | msr_val);
+
+	if (cpu_has(c, X86_FEATURE_PTS)) {
+		rdmsrl(MSR_IA32_PACKAGE_THERM_STATUS, msr_val);
+		if (therm_throt_process(msr_val & PACKAGE_THERM_STATUS_PROCHOT,
+					THERMAL_THROTTLING_EVENT,
+					PACKAGE_LEVEL) != 0)
+			mce_log_therm_throt_event(PACKAGE_THROTTLED | msr_val);
+		if (cpu_has(c, X86_FEATURE_PLN))
+			if (therm_throt_process(msr_val &
+					PACKAGE_THERM_STATUS_POWER_LIMIT,
+					POWER_LIMIT_EVENT,
+					PACKAGE_LEVEL) != 0)
+				mce_log_therm_throt_event(PACKAGE_POWER_LIMIT
+							  | msr_val);
+	}
 }
 
 static void unexpected_thermal_interrupt(void)
@@ -335,8 +445,26 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
 	apic_write(APIC_LVTTHMR, h);
 
 	rdmsr(MSR_IA32_THERM_INTERRUPT, l, h);
-	wrmsr(MSR_IA32_THERM_INTERRUPT,
-		l | (THERM_INT_LOW_ENABLE | THERM_INT_HIGH_ENABLE), h);
+	if (cpu_has(c, X86_FEATURE_PLN))
+		wrmsr(MSR_IA32_THERM_INTERRUPT,
+		      l | (THERM_INT_LOW_ENABLE
+			| THERM_INT_HIGH_ENABLE | THERM_INT_PLN_ENABLE), h);
+	else
+		wrmsr(MSR_IA32_THERM_INTERRUPT,
+		      l | (THERM_INT_LOW_ENABLE | THERM_INT_HIGH_ENABLE), h);
+
+	if (cpu_has(c, X86_FEATURE_PTS)) {
+		rdmsr(MSR_IA32_PACKAGE_THERM_INTERRUPT, l, h);
+		if (cpu_has(c, X86_FEATURE_PLN))
+			wrmsr(MSR_IA32_PACKAGE_THERM_INTERRUPT,
+			      l | (PACKAGE_THERM_INT_LOW_ENABLE
+				| PACKAGE_THERM_INT_HIGH_ENABLE
+				| PACKAGE_THERM_INT_PLN_ENABLE), h);
+		else
+			wrmsr(MSR_IA32_PACKAGE_THERM_INTERRUPT,
+			      l | (PACKAGE_THERM_INT_LOW_ENABLE
+				| PACKAGE_THERM_INT_HIGH_ENABLE), h);
+	}
 
 	smp_thermal_vector = intel_thermal_interrupt;
 
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index e19cf8e..3a858e8 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -407,6 +407,13 @@ config SENSORS_CORETEMP
 	  sensor inside your CPU. Most of the family 6 CPUs
 	  are supported. Check documentation/driver for details.
 
+config SENSORS_PKGTEMP
+	tristate "Intel processor package temperature sensor"
+	depends on X86 && PCI && EXPERIMENTAL
+	help
+	  If you say yes here you get support for the package level temperature
+	  sensor inside your CPU. Check documentation/driver for details.
+
 config SENSORS_IBMAEM
 	tristate "IBM Active Energy Manager temperature/power sensors and control"
 	select IPMI_SI
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index 2138ceb..879814e 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -39,6 +39,7 @@ obj-$(CONFIG_SENSORS_AMS)	+= ams/
 obj-$(CONFIG_SENSORS_ASC7621)	+= asc7621.o
 obj-$(CONFIG_SENSORS_ATXP1)	+= atxp1.o
 obj-$(CONFIG_SENSORS_CORETEMP)	+= coretemp.o
+obj-$(CONFIG_SENSORS_PKGTEMP)	+= pkgtemp.o
 obj-$(CONFIG_SENSORS_DME1737)	+= dme1737.o
 obj-$(CONFIG_SENSORS_DS1621)	+= ds1621.o
 obj-$(CONFIG_SENSORS_EMC1403)	+= emc1403.o
diff --git a/drivers/hwmon/pkgtemp.c b/drivers/hwmon/pkgtemp.c
new file mode 100644
index 0000000..74157fc
--- /dev/null
+++ b/drivers/hwmon/pkgtemp.c
@@ -0,0 +1,456 @@
+/*
+ * pkgtemp.c - Linux kernel module for processor package hardware monitoring
+ *
+ * Copyright (C) 2010 Fenghua Yu <fenghua.yu@intel.com>
+ *
+ * Inspired from many hwmon drivers especially coretemp.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301 USA.
+ */
+
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/jiffies.h>
+#include <linux/hwmon.h>
+#include <linux/sysfs.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/err.h>
+#include <linux/mutex.h>
+#include <linux/list.h>
+#include <linux/platform_device.h>
+#include <linux/cpu.h>
+#include <linux/pci.h>
+#include <asm/msr.h>
+#include <asm/processor.h>
+
+#define DRVNAME	"pkgtemp"
+
+enum { SHOW_TEMP, SHOW_TJMAX, SHOW_TTARGET, SHOW_LABEL, SHOW_NAME };
+
+/*
+ * Functions declaration
+ */
+
+static struct pkgtemp_data *pkgtemp_update_device(struct device *dev);
+
+struct pkgtemp_data {
+	struct device *hwmon_dev;
+	struct mutex update_lock;
+	const char *name;
+	u32 id;
+	u16 phys_proc_id;
+	char valid;		/* zero until following fields are valid */
+	unsigned long last_updated;	/* in jiffies */
+	int temp;
+	int tjmax;
+	int ttarget;
+	u8 alarm;
+};
+
+/*
+ * Sysfs stuff
+ */
+
+static ssize_t show_name(struct device *dev, struct device_attribute
+			  *devattr, char *buf)
+{
+	int ret;
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct pkgtemp_data *data = dev_get_drvdata(dev);
+
+	if (attr->index == SHOW_NAME)
+		ret = sprintf(buf, "%s\n", data->name);
+	else	/* show label */
+		ret = sprintf(buf, "physical id %d\n",
+			      data->phys_proc_id);
+	return ret;
+}
+
+static ssize_t show_alarm(struct device *dev, struct device_attribute
+			  *devattr, char *buf)
+{
+	struct pkgtemp_data *data = pkgtemp_update_device(dev);
+	/* read the Out-of-spec log, never clear */
+	return sprintf(buf, "%d\n", data->alarm);
+}
+
+static ssize_t show_temp(struct device *dev,
+			 struct device_attribute *devattr, char *buf)
+{
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct pkgtemp_data *data = pkgtemp_update_device(dev);
+	int err = 0;
+
+	if (attr->index == SHOW_TEMP)
+		err = data->valid ? sprintf(buf, "%d\n", data->temp) : -EAGAIN;
+	else if (attr->index == SHOW_TJMAX)
+		err = sprintf(buf, "%d\n", data->tjmax);
+	else
+		err = sprintf(buf, "%d\n", data->ttarget);
+	return err;
+}
+
+static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, show_temp, NULL, SHOW_TEMP);
+static SENSOR_DEVICE_ATTR(temp1_crit, S_IRUGO, show_temp, NULL, SHOW_TJMAX);
+static SENSOR_DEVICE_ATTR(temp1_max, S_IRUGO, show_temp, NULL, SHOW_TTARGET);
+static DEVICE_ATTR(temp1_crit_alarm, S_IRUGO, show_alarm, NULL);
+static SENSOR_DEVICE_ATTR(temp1_label, S_IRUGO, show_name, NULL, SHOW_LABEL);
+static SENSOR_DEVICE_ATTR(name, S_IRUGO, show_name, NULL, SHOW_NAME);
+
+static struct attribute *pkgtemp_attributes[] = {
+	&sensor_dev_attr_name.dev_attr.attr,
+	&sensor_dev_attr_temp1_label.dev_attr.attr,
+	&dev_attr_temp1_crit_alarm.attr,
+	&sensor_dev_attr_temp1_input.dev_attr.attr,
+	&sensor_dev_attr_temp1_crit.dev_attr.attr,
+	NULL
+};
+
+static const struct attribute_group pkgtemp_group = {
+	.attrs = pkgtemp_attributes,
+};
+
+static struct pkgtemp_data *pkgtemp_update_device(struct device *dev)
+{
+	struct pkgtemp_data *data = dev_get_drvdata(dev);
+	unsigned int cpu;
+	int err;
+
+	mutex_lock(&data->update_lock);
+
+	if (!data->valid || time_after(jiffies, data->last_updated + HZ)) {
+		u32 eax, edx;
+
+		data->valid = 0;
+		cpu = data->id;
+		err = rdmsr_on_cpu(cpu, MSR_IA32_PACKAGE_THERM_STATUS,
+				   &eax, &edx);
+		if (!err) {
+			data->alarm = (eax >> 5) & 1;
+			data->temp = data->tjmax - (((eax >> 16)
+							& 0x7f) * 1000);
+			data->valid = 1;
+		} else
+			dev_dbg(dev, "Temperature data invalid (0x%x)\n", eax);
+
+		data->last_updated = jiffies;
+	}
+
+	mutex_unlock(&data->update_lock);
+	return data;
+}
+
+static int get_tjmax(int cpu, struct device *dev)
+{
+	int default_tjmax = 100000;
+	int err;
+	u32 eax, edx;
+	u32 val;
+
+	/* IA32_TEMPERATURE_TARGET contains the TjMax value */
+	err = rdmsr_safe_on_cpu(cpu, MSR_IA32_TEMPERATURE_TARGET, &eax, &edx);
+	if (!err) {
+		val = (eax >> 16) & 0xff;
+		if ((val > 80) && (val < 120)) {
+			dev_info(dev, "TjMax is %d C.\n", val);
+			return val * 1000;
+		}
+	}
+	dev_warn(dev, "Unable to read TjMax from CPU.\n");
+	return default_tjmax;
+}
+
+static int __devinit pkgtemp_probe(struct platform_device *pdev)
+{
+	struct pkgtemp_data *data;
+	int err;
+	u32 eax, edx;
+#ifdef CONFIG_SMP
+	struct cpuinfo_x86 *c = &cpu_data(pdev->id);
+#endif
+
+	data = kzalloc(sizeof(struct pkgtemp_data), GFP_KERNEL);
+	if (!data) {
+		err = -ENOMEM;
+		dev_err(&pdev->dev, "Out of memory\n");
+		goto exit;
+	}
+
+	data->id = pdev->id;
+#ifdef CONFIG_SMP
+	data->phys_proc_id = c->phys_proc_id;
+#endif
+	data->name = "pkgtemp";
+	mutex_init(&data->update_lock);
+
+	/* test if we can access the THERM_STATUS MSR */
+	err = rdmsr_safe_on_cpu(data->id, MSR_IA32_PACKAGE_THERM_STATUS,
+				&eax, &edx);
+	if (err) {
+		dev_err(&pdev->dev,
+			"Unable to access THERM_STATUS MSR, giving up\n");
+		goto exit_free;
+	}
+
+	data->tjmax = get_tjmax(data->id, &pdev->dev);
+	platform_set_drvdata(pdev, data);
+
+	err = rdmsr_safe_on_cpu(data->id, MSR_IA32_TEMPERATURE_TARGET,
+				&eax, &edx);
+	if (err) {
+		dev_warn(&pdev->dev, "Unable to read"
+				" IA32_TEMPERATURE_TARGET MSR\n");
+	} else {
+		data->ttarget = data->tjmax - (((eax >> 8) & 0xff) * 1000);
+		err = device_create_file(&pdev->dev,
+				&sensor_dev_attr_temp1_max.dev_attr);
+		if (err)
+			goto exit_free;
+	}
+
+	err = sysfs_create_group(&pdev->dev.kobj, &pkgtemp_group);
+	if (err)
+		goto exit_free;
+
+	data->hwmon_dev = hwmon_device_register(&pdev->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
+		dev_err(&pdev->dev, "Class registration failed (%d)\n",
+			err);
+		goto exit_class;
+	}
+
+	return 0;
+
+exit_class:
+	sysfs_remove_group(&pdev->dev.kobj, &pkgtemp_group);
+exit_free:
+	kfree(data);
+exit:
+	return err;
+}
+
+static int __devexit pkgtemp_remove(struct platform_device *pdev)
+{
+	struct pkgtemp_data *data = platform_get_drvdata(pdev);
+
+	hwmon_device_unregister(data->hwmon_dev);
+	sysfs_remove_group(&pdev->dev.kobj, &pkgtemp_group);
+	platform_set_drvdata(pdev, NULL);
+	kfree(data);
+	return 0;
+}
+
+static struct platform_driver pkgtemp_driver = {
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = DRVNAME,
+	},
+	.probe = pkgtemp_probe,
+	.remove = __devexit_p(pkgtemp_remove),
+};
+
+struct pdev_entry {
+	struct list_head list;
+	struct platform_device *pdev;
+	unsigned int cpu;
+#ifdef CONFIG_SMP
+	u16 phys_proc_id;
+#endif
+};
+
+static LIST_HEAD(pdev_list);
+static DEFINE_MUTEX(pdev_list_mutex);
+
+static int __cpuinit pkgtemp_device_add(unsigned int cpu)
+{
+	int err;
+	struct platform_device *pdev;
+	struct pdev_entry *pdev_entry;
+#ifdef CONFIG_SMP
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+#endif
+
+	mutex_lock(&pdev_list_mutex);
+
+#ifdef CONFIG_SMP
+	/* Only keep the first entry in each package */
+	list_for_each_entry(pdev_entry, &pdev_list, list) {
+		if (c->phys_proc_id == pdev_entry->phys_proc_id) {
+			err = 0;        /* Not an error */
+			goto exit;
+		}
+	}
+#endif
+
+	pdev = platform_device_alloc(DRVNAME, cpu);
+	if (!pdev) {
+		err = -ENOMEM;
+		printk(KERN_ERR DRVNAME ": Device allocation failed\n");
+		goto exit;
+	}
+
+	pdev_entry = kzalloc(sizeof(struct pdev_entry), GFP_KERNEL);
+	if (!pdev_entry) {
+		err = -ENOMEM;
+		goto exit_device_put;
+	}
+
+	err = platform_device_add(pdev);
+	if (err) {
+		printk(KERN_ERR DRVNAME ": Device addition failed (%d)\n",
+		       err);
+		goto exit_device_free;
+	}
+
+#ifdef CONFIG_SMP
+	pdev_entry->phys_proc_id = c->phys_proc_id;
+#endif
+	pdev_entry->pdev = pdev;
+	pdev_entry->cpu = cpu;
+	list_add_tail(&pdev_entry->list, &pdev_list);
+	mutex_unlock(&pdev_list_mutex);
+
+	return 0;
+
+exit_device_free:
+	kfree(pdev_entry);
+exit_device_put:
+	platform_device_put(pdev);
+exit:
+	mutex_unlock(&pdev_list_mutex);
+	return err;
+}
+
+#ifdef CONFIG_HOTPLUG_CPU
+static void pkgtemp_device_remove(unsigned int cpu)
+{
+	struct pdev_entry *p, *n;
+	unsigned int i;
+	int err;
+
+	mutex_lock(&pdev_list_mutex);
+	list_for_each_entry_safe(p, n, &pdev_list, list) {
+		if (p->cpu != cpu)
+			continue;
+
+		platform_device_unregister(p->pdev);
+		list_del(&p->list);
+		kfree(p);
+		for_each_cpu(i, cpu_core_mask(cpu)) {
+			if (i != cpu) {
+				err = pkgtemp_device_add(i);
+				if (!err)
+					break;
+			}
+		}
+		break;
+	}
+	mutex_unlock(&pdev_list_mutex);
+}
+
+static int __cpuinit pkgtemp_cpu_callback(struct notifier_block *nfb,
+				 unsigned long action, void *hcpu)
+{
+	unsigned int cpu = (unsigned long) hcpu;
+
+	switch (action) {
+	case CPU_ONLINE:
+	case CPU_DOWN_FAILED:
+		pkgtemp_device_add(cpu);
+		break;
+	case CPU_DOWN_PREPARE:
+		pkgtemp_device_remove(cpu);
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block pkgtemp_cpu_notifier __refdata = {
+	.notifier_call = pkgtemp_cpu_callback,
+};
+#endif				/* !CONFIG_HOTPLUG_CPU */
+
+static int __init pkgtemp_init(void)
+{
+	int i, err = -ENODEV;
+	struct pdev_entry *p, *n;
+
+	/* quick check if we run Intel */
+	if (cpu_data(0).x86_vendor != X86_VENDOR_INTEL)
+		goto exit;
+
+	err = platform_driver_register(&pkgtemp_driver);
+	if (err)
+		goto exit;
+
+	for_each_online_cpu(i) {
+		struct cpuinfo_x86 *c = &cpu_data(i);
+
+		if (!cpu_has(c, X86_FEATURE_PTS))
+			continue;
+
+		err = pkgtemp_device_add(i);
+		if (err)
+			goto exit_devices_unreg;
+	}
+	if (list_empty(&pdev_list)) {
+		err = -ENODEV;
+		goto exit_driver_unreg;
+	}
+
+#ifdef CONFIG_HOTPLUG_CPU
+	register_hotcpu_notifier(&pkgtemp_cpu_notifier);
+#endif
+	return 0;
+
+exit_devices_unreg:
+	mutex_lock(&pdev_list_mutex);
+	list_for_each_entry_safe(p, n, &pdev_list, list) {
+		platform_device_unregister(p->pdev);
+		list_del(&p->list);
+		kfree(p);
+	}
+	mutex_unlock(&pdev_list_mutex);
+exit_driver_unreg:
+	platform_driver_unregister(&pkgtemp_driver);
+exit:
+	return err;
+}
+
+static void __exit pkgtemp_exit(void)
+{
+	struct pdev_entry *p, *n;
+#ifdef CONFIG_HOTPLUG_CPU
+	unregister_hotcpu_notifier(&pkgtemp_cpu_notifier);
+#endif
+	mutex_lock(&pdev_list_mutex);
+	list_for_each_entry_safe(p, n, &pdev_list, list) {
+		platform_device_unregister(p->pdev);
+		list_del(&p->list);
+		kfree(p);
+	}
+	mutex_unlock(&pdev_list_mutex);
+	platform_driver_unregister(&pkgtemp_driver);
+}
+
+MODULE_AUTHOR("Fenghua Yu <fenghua.yu@intel.com>");
+MODULE_DESCRIPTION("Intel processor package temperature monitor");
+MODULE_LICENSE("GPL");
+
+module_init(pkgtemp_init)
+module_exit(pkgtemp_exit)
