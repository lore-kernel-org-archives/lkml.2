Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab0G1TKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 15:10:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:9181 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089Ab0G1TJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 15:09:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,275,1278313200"; 
   d="scan'208";a="305514036"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>, "Len Brown" <lenb@kernel.org>,
        "Guenter Roeck" <guenter.roeck@ericsson.com>,
        "Chen Gong" <gong.chen@linux.intel.com>,
        "Jean Delvare" <khali@linux-fr.org>, "Huaxu Wan" <huaxu.wan@intel.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "lm-sensors" <lm-sensors@lm-sensors.org>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATH V2 3/5] Package Level Thermal Control and Power Limit Notification: thermal throttling handler
Date: Wed, 28 Jul 2010 12:00:51 -0700
Message-Id: <1280343653-26380-4-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1280343653-26380-1-git-send-email-fenghua.yu@intel.com>
References: <1280343653-26380-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Add package level thermal throttle interrupt support. The interrupt handler
increases package level thermal throttle count. It also logs the event in MCE
log.

The package level thermal throttle interrupt happens across threads in a
package. Each thread handles the interrupt individually. User level application
is supposed to retrieve correct event count and log based on package/thread
topology. This is the same situation for core level interrupt handler.

core_throttle_count and package_throttle_count are used for user interface.
Previously only throttle_count is used for core throttle count. If you think
new core_throttle_count name breaks user interface, I can change this part.

This patch also fixes a bug which defines reverse THERM_INT_LOW_ENABLE bit and
THERM_INT_HIGH_ENABLE bit.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Reviewed-by: Len Brown <len.brown@intel.com>
---
 arch/x86/include/asm/msr-index.h         |   10 +++-
 arch/x86/kernel/cpu/mcheck/therm_throt.c |   89 ++++++++++++++++++++++++------
 2 files changed, 79 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 5eaad6f..f1c1b82 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -224,8 +224,8 @@
 #define MSR_IA32_THERM_CONTROL		0x0000019a
 #define MSR_IA32_THERM_INTERRUPT	0x0000019b
 
-#define THERM_INT_LOW_ENABLE		(1 << 0)
-#define THERM_INT_HIGH_ENABLE		(1 << 1)
+#define THERM_INT_HIGH_ENABLE		(1 << 0)
+#define THERM_INT_LOW_ENABLE		(1 << 1)
 
 #define MSR_IA32_THERM_STATUS		0x0000019c
 
@@ -240,8 +240,14 @@
 #define MSR_IA32_TEMPERATURE_TARGET	0x000001a2
 
 #define MSR_IA32_PACKAGE_THERM_STATUS		0x000001b1
+
+#define PACKAGE_THERM_STATUS_PROCHOT		(1 << 0)
+
 #define MSR_IA32_PACKAGE_THERM_INTERRUPT	0x000001b2
 
+#define PACKAGE_THERM_INT_HIGH_ENABLE		(1 << 0)
+#define PACKAGE_THERM_INT_LOW_ENABLE		(1 << 1)
+
 /* MISC_ENABLE bits: architectural */
 #define MSR_IA32_MISC_ENABLE_FAST_STRING	(1ULL << 0)
 #define MSR_IA32_MISC_ENABLE_TCC		(1ULL << 1)
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index e1a0a3b..d307f9f 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -37,7 +37,7 @@
 /*
  * Current thermal throttling state:
  */
-struct thermal_state {
+struct _thermal_state {
 	bool			is_throttled;
 
 	u64			next_check;
@@ -45,6 +45,11 @@ struct thermal_state {
 	unsigned long		last_throttle_count;
 };
 
+struct thermal_state {
+	struct _thermal_state core;
+	struct _thermal_state package;
+};
+
 static DEFINE_PER_CPU(struct thermal_state, thermal_state);
 
 static atomic_t therm_throt_en	= ATOMIC_INIT(0);
@@ -53,11 +58,13 @@ static u32 lvtthmr_init __read_mostly;
 
 #ifdef CONFIG_SYSFS
 #define define_therm_throt_sysdev_one_ro(_name)				\
-	static SYSDEV_ATTR(_name, 0444, therm_throt_sysdev_show_##_name, NULL)
+	static SYSDEV_ATTR(_name, 0444,					\
+			   therm_throt_sysdev_show_##_name,		\
+				   NULL)				\
 
-#define define_therm_throt_sysdev_show_func(name)			\
+#define define_therm_throt_sysdev_show_func(level, name)		\
 									\
-static ssize_t therm_throt_sysdev_show_##name(				\
+static ssize_t therm_throt_sysdev_show_##level##_##name(		\
 			struct sys_device *dev,				\
 			struct sysdev_attribute *attr,			\
 			char *buf)					\
@@ -66,21 +73,24 @@ static ssize_t therm_throt_sysdev_show_##name(				\
 	ssize_t ret;							\
 									\
 	preempt_disable();	/* CPU hotplug */			\
-	if (cpu_online(cpu))						\
+	if (cpu_online(cpu)) {						\
 		ret = sprintf(buf, "%lu\n",				\
-			      per_cpu(thermal_state, cpu).name);	\
-	else								\
+			      per_cpu(thermal_state, cpu).level.name);	\
+	} else								\
 		ret = 0;						\
 	preempt_enable();						\
 									\
 	return ret;							\
 }
 
-define_therm_throt_sysdev_show_func(throttle_count);
-define_therm_throt_sysdev_one_ro(throttle_count);
+define_therm_throt_sysdev_show_func(core, throttle_count);
+define_therm_throt_sysdev_one_ro(core_throttle_count);
+
+define_therm_throt_sysdev_show_func(package, throttle_count);
+define_therm_throt_sysdev_one_ro(package_throttle_count);
 
 static struct attribute *thermal_throttle_attrs[] = {
-	&attr_throttle_count.attr,
+	&attr_core_throttle_count.attr,
 	NULL
 };
 
@@ -106,16 +116,21 @@ static struct attribute_group thermal_throttle_attr_group = {
  *          1 : Event should be logged further, and a message has been
  *              printed to the syslog.
  */
-static int therm_throt_process(bool is_throttled)
+#define CORE_LEVEL	0
+#define PACKAGE_LEVEL	1
+static int therm_throt_process(bool is_throttled, int level)
 {
-	struct thermal_state *state;
+	struct _thermal_state *state;
 	unsigned int this_cpu;
 	bool was_throttled;
 	u64 now;
 
 	this_cpu = smp_processor_id();
 	now = get_jiffies_64();
-	state = &per_cpu(thermal_state, this_cpu);
+	if (level == CORE_LEVEL)
+		state = &per_cpu(thermal_state, this_cpu).core;
+	else
+		state = &per_cpu(thermal_state, this_cpu).package;
 
 	was_throttled = state->is_throttled;
 	state->is_throttled = is_throttled;
@@ -132,13 +147,18 @@ static int therm_throt_process(bool is_throttled)
 
 	/* if we just entered the thermal event */
 	if (is_throttled) {
-		printk(KERN_CRIT "CPU%d: Temperature above threshold, cpu clock throttled (total events = %lu)\n", this_cpu, state->throttle_count);
+		printk(KERN_CRIT "CPU%d: %s temperature above threshold, cpu clock throttled (total events = %lu)\n",
+		      this_cpu,
+		      level == CORE_LEVEL ? "Core" : "Package",
+		      state->throttle_count);
 
 		add_taint(TAINT_MACHINE_CHECK);
 		return 1;
 	}
 	if (was_throttled) {
-		printk(KERN_INFO "CPU%d: Temperature/speed normal\n", this_cpu);
+		printk(KERN_INFO "CPU%d: %s temperature/speed normal\n",
+		       this_cpu,
+		       level == CORE_LEVEL ? "Core" : "Package");
 		return 1;
 	}
 
@@ -149,8 +169,19 @@ static int therm_throt_process(bool is_throttled)
 /* Add/Remove thermal_throttle interface for CPU device: */
 static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev)
 {
-	return sysfs_create_group(&sys_dev->kobj,
-				  &thermal_throttle_attr_group);
+	int err;
+	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
+
+	err = sysfs_create_group(&sys_dev->kobj, &thermal_throttle_attr_group);
+	if (err)
+		return err;
+
+	if (cpu_has(c, X86_FEATURE_PTS))
+		err = sysfs_add_file_to_group(&sys_dev->kobj,
+					      &attr_package_throttle_count.attr,
+					      thermal_throttle_attr_group.name);
+
+	return err;
 }
 
 static __cpuinit void thermal_throttle_remove_dev(struct sys_device *sys_dev)
@@ -230,10 +261,25 @@ device_initcall(thermal_throttle_init_device);
 static void intel_thermal_interrupt(void)
 {
 	__u64 msr_val;
+	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
 
 	rdmsrl(MSR_IA32_THERM_STATUS, msr_val);
-	if (therm_throt_process((msr_val & THERM_STATUS_PROCHOT) != 0))
+	if (therm_throt_process(msr_val & THERM_STATUS_PROCHOT,
+				CORE_LEVEL) != 0)
 		mce_log_therm_throt_event(msr_val);
+
+	if (cpu_has(c, X86_FEATURE_PTS)) {
+		rdmsrl(MSR_IA32_PACKAGE_THERM_STATUS, msr_val);
+		if (therm_throt_process(msr_val & PACKAGE_THERM_STATUS_PROCHOT,
+					PACKAGE_LEVEL) != 0)
+			/*
+			 * Set up the most significant bit to notify mce log
+			 * that this thermal event is a package level event.
+			 * This is a temp solution. May be changed in the future
+			 * with mce log infrasture.
+			 */
+			mce_log_therm_throt_event(((__u64)1 << 63) | msr_val);
+	}
 }
 
 static void unexpected_thermal_interrupt(void)
@@ -338,6 +384,13 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
 	wrmsr(MSR_IA32_THERM_INTERRUPT,
 		l | (THERM_INT_LOW_ENABLE | THERM_INT_HIGH_ENABLE), h);
 
+	if (cpu_has(c, X86_FEATURE_PTS)) {
+		rdmsr(MSR_IA32_PACKAGE_THERM_INTERRUPT, l, h);
+		wrmsr(MSR_IA32_PACKAGE_THERM_INTERRUPT,
+			l | (PACKAGE_THERM_INT_LOW_ENABLE
+		  | PACKAGE_THERM_INT_HIGH_ENABLE), h);
+	}
+
 	smp_thermal_vector = intel_thermal_interrupt;
 
 	rdmsr(MSR_IA32_MISC_ENABLE, l, h);
-- 
1.7.2

