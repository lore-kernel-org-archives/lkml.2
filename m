Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760624Ab2C3LPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 07:15:13 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:58394 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760126Ab2C3LO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 07:14:57 -0400
X-Greylist: delayed 3614 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Mar 2012 07:14:57 EDT
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Robert Lee <rob.lee@linaro.org>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 05/76] cpuidle: Add common time keeping and irq enabling
Date: Fri, 30 Mar 2012 06:13:08 -0400
Message-id: <e1689795a784a7c41ac4cf9032794986b095a133.1333101989.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.10.rc2.19.gfae9d
In-reply-to: <1333102459-23750-1-git-send-email-lenb@kernel.org>
References: <1333102459-23750-1-git-send-email-lenb@kernel.org>
In-reply-to: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Lee <rob.lee@linaro.org>

Make necessary changes to implement time keeping and irq enabling
in the core cpuidle code.  This will allow the removal of these
functionalities from various platform cpuidle implementations whose
timekeeping and irq enabling follows the form in this common code.

Signed-off-by: Robert Lee <rob.lee@linaro.org>
Tested-by: Jean Pihet <j-pihet@ti.com>
Tested-by: Amit Daniel <amit.kachhap@linaro.org>
Tested-by: Robert Lee <rob.lee@linaro.org>
Reviewed-by: Kevin Hilman <khilman@ti.com>
Reviewed-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Reviewed-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Acked-by: Jean Pihet <j-pihet@ti.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/arm/include/asm/cpuidle.h |   29 ++++++++++++++++++
 arch/arm/kernel/Makefile       |    2 +-
 arch/arm/kernel/cpuidle.c      |   21 +++++++++++++
 drivers/cpuidle/cpuidle.c      |   66 +++++++++++++++++++++++++++++++++++-----
 include/linux/cpuidle.h        |   13 +++++++-
 5 files changed, 122 insertions(+), 9 deletions(-)
 create mode 100644 arch/arm/include/asm/cpuidle.h
 create mode 100644 arch/arm/kernel/cpuidle.c

diff --git a/arch/arm/include/asm/cpuidle.h b/arch/arm/include/asm/cpuidle.h
new file mode 100644
index 0000000..2fca60a
--- /dev/null
+++ b/arch/arm/include/asm/cpuidle.h
@@ -0,0 +1,29 @@
+#ifndef __ASM_ARM_CPUIDLE_H
+#define __ASM_ARM_CPUIDLE_H
+
+#ifdef CONFIG_CPU_IDLE
+extern int arm_cpuidle_simple_enter(struct cpuidle_device *dev,
+		struct cpuidle_driver *drv, int index);
+#else
+static inline int arm_cpuidle_simple_enter(struct cpuidle_device *dev,
+		struct cpuidle_driver *drv, int index) { return -ENODEV; }
+#endif
+
+/* Common ARM WFI state */
+#define ARM_CPUIDLE_WFI_STATE_PWR(p) {\
+	.enter                  = arm_cpuidle_simple_enter,\
+	.exit_latency           = 1,\
+	.target_residency       = 1,\
+	.power_usage		= p,\
+	.flags                  = CPUIDLE_FLAG_TIME_VALID,\
+	.name                   = "WFI",\
+	.desc                   = "ARM WFI",\
+}
+
+/*
+ * in case power_specified == 1, give a default WFI power value needed
+ * by some governors
+ */
+#define ARM_CPUIDLE_WFI_STATE ARM_CPUIDLE_WFI_STATE_PWR(UINT_MAX)
+
+#endif
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 43b740d..940c27f 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -21,7 +21,7 @@ obj-$(CONFIG_DEPRECATED_PARAM_STRUCT) += compat.o
 
 obj-$(CONFIG_LEDS)		+= leds.o
 obj-$(CONFIG_OC_ETM)		+= etm.o
-
+obj-$(CONFIG_CPU_IDLE)		+= cpuidle.o
 obj-$(CONFIG_ISA_DMA_API)	+= dma.o
 obj-$(CONFIG_ARCH_ACORN)	+= ecard.o 
 obj-$(CONFIG_FIQ)		+= fiq.o fiqasm.o
diff --git a/arch/arm/kernel/cpuidle.c b/arch/arm/kernel/cpuidle.c
new file mode 100644
index 0000000..89545f6
--- /dev/null
+++ b/arch/arm/kernel/cpuidle.c
@@ -0,0 +1,21 @@
+/*
+ * Copyright 2012 Linaro Ltd.
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+#include <linux/cpuidle.h>
+#include <asm/proc-fns.h>
+
+int arm_cpuidle_simple_enter(struct cpuidle_device *dev,
+		struct cpuidle_driver *drv, int index)
+{
+	cpu_do_idle();
+
+	return index;
+}
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 59f4261..4869b55 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -53,6 +53,24 @@ static void cpuidle_kick_cpus(void) {}
 
 static int __cpuidle_register_device(struct cpuidle_device *dev);
 
+static inline int cpuidle_enter(struct cpuidle_device *dev,
+				struct cpuidle_driver *drv, int index)
+{
+	struct cpuidle_state *target_state = &drv->states[index];
+	return target_state->enter(dev, drv, index);
+}
+
+static inline int cpuidle_enter_tk(struct cpuidle_device *dev,
+			       struct cpuidle_driver *drv, int index)
+{
+	return cpuidle_wrap_enter(dev, drv, index, cpuidle_enter);
+}
+
+typedef int (*cpuidle_enter_t)(struct cpuidle_device *dev,
+			       struct cpuidle_driver *drv, int index);
+
+static cpuidle_enter_t cpuidle_enter_ops;
+
 /**
  * cpuidle_idle_call - the main idle loop
  *
@@ -63,7 +81,6 @@ int cpuidle_idle_call(void)
 {
 	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
 	struct cpuidle_driver *drv = cpuidle_get_driver();
-	struct cpuidle_state *target_state;
 	int next_state, entered_state;
 
 	if (off)
@@ -92,12 +109,10 @@ int cpuidle_idle_call(void)
 		return 0;
 	}
 
-	target_state = &drv->states[next_state];
-
 	trace_power_start(POWER_CSTATE, next_state, dev->cpu);
 	trace_cpu_idle(next_state, dev->cpu);
 
-	entered_state = target_state->enter(dev, drv, next_state);
+	entered_state = cpuidle_enter_ops(dev, drv, next_state);
 
 	trace_power_end(dev->cpu);
 	trace_cpu_idle(PWR_EVENT_EXIT, dev->cpu);
@@ -110,6 +125,8 @@ int cpuidle_idle_call(void)
 		dev->states_usage[entered_state].time +=
 				(unsigned long long)dev->last_residency;
 		dev->states_usage[entered_state].usage++;
+	} else {
+		dev->last_residency = 0;
 	}
 
 	/* give the governor an opportunity to reflect on the outcome */
@@ -164,6 +181,37 @@ void cpuidle_resume_and_unlock(void)
 
 EXPORT_SYMBOL_GPL(cpuidle_resume_and_unlock);
 
+/**
+ * cpuidle_wrap_enter - performs timekeeping and irqen around enter function
+ * @dev: pointer to a valid cpuidle_device object
+ * @drv: pointer to a valid cpuidle_driver object
+ * @index: index of the target cpuidle state.
+ */
+int cpuidle_wrap_enter(struct cpuidle_device *dev,
+				struct cpuidle_driver *drv, int index,
+				int (*enter)(struct cpuidle_device *dev,
+					struct cpuidle_driver *drv, int index))
+{
+	ktime_t time_start, time_end;
+	s64 diff;
+
+	time_start = ktime_get();
+
+	index = enter(dev, drv, index);
+
+	time_end = ktime_get();
+
+	local_irq_enable();
+
+	diff = ktime_to_us(ktime_sub(time_end, time_start));
+	if (diff > INT_MAX)
+		diff = INT_MAX;
+
+	dev->last_residency = (int) diff;
+
+	return index;
+}
+
 #ifdef CONFIG_ARCH_HAS_CPU_RELAX
 static int poll_idle(struct cpuidle_device *dev,
 		struct cpuidle_driver *drv, int index)
@@ -212,10 +260,11 @@ static void poll_idle_init(struct cpuidle_driver *drv) {}
 int cpuidle_enable_device(struct cpuidle_device *dev)
 {
 	int ret, i;
+	struct cpuidle_driver *drv = cpuidle_get_driver();
 
 	if (dev->enabled)
 		return 0;
-	if (!cpuidle_get_driver() || !cpuidle_curr_governor)
+	if (!drv || !cpuidle_curr_governor)
 		return -EIO;
 	if (!dev->state_count)
 		return -EINVAL;
@@ -226,13 +275,16 @@ int cpuidle_enable_device(struct cpuidle_device *dev)
 			return ret;
 	}
 
-	poll_idle_init(cpuidle_get_driver());
+	cpuidle_enter_ops = drv->en_core_tk_irqen ?
+		cpuidle_enter_tk : cpuidle_enter;
+
+	poll_idle_init(drv);
 
 	if ((ret = cpuidle_add_state_sysfs(dev)))
 		return ret;
 
 	if (cpuidle_curr_governor->enable &&
-	    (ret = cpuidle_curr_governor->enable(cpuidle_get_driver(), dev)))
+	    (ret = cpuidle_curr_governor->enable(drv, dev)))
 		goto fail_sysfs;
 
 	for (i = 0; i < dev->state_count; i++) {
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 712abcc..927db28 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -15,6 +15,7 @@
 #include <linux/list.h>
 #include <linux/kobject.h>
 #include <linux/completion.h>
+#include <linux/hrtimer.h>
 
 #define CPUIDLE_STATE_MAX	8
 #define CPUIDLE_NAME_LEN	16
@@ -122,6 +123,8 @@ struct cpuidle_driver {
 	struct module 		*owner;
 
 	unsigned int		power_specified:1;
+	/* set to 1 to use the core cpuidle time keeping (for all states). */
+	unsigned int		en_core_tk_irqen:1;
 	struct cpuidle_state	states[CPUIDLE_STATE_MAX];
 	int			state_count;
 	int			safe_state_index;
@@ -140,7 +143,10 @@ extern void cpuidle_pause_and_lock(void);
 extern void cpuidle_resume_and_unlock(void);
 extern int cpuidle_enable_device(struct cpuidle_device *dev);
 extern void cpuidle_disable_device(struct cpuidle_device *dev);
-
+extern int cpuidle_wrap_enter(struct cpuidle_device *dev,
+				struct cpuidle_driver *drv, int index,
+				int (*enter)(struct cpuidle_device *dev,
+					struct cpuidle_driver *drv, int index));
 #else
 static inline void disable_cpuidle(void) { }
 static inline int cpuidle_idle_call(void) { return -ENODEV; }
@@ -157,6 +163,11 @@ static inline void cpuidle_resume_and_unlock(void) { }
 static inline int cpuidle_enable_device(struct cpuidle_device *dev)
 {return -ENODEV; }
 static inline void cpuidle_disable_device(struct cpuidle_device *dev) { }
+static inline int cpuidle_wrap_enter(struct cpuidle_device *dev,
+				struct cpuidle_driver *drv, int index,
+				int (*enter)(struct cpuidle_device *dev,
+					struct cpuidle_driver *drv, int index))
+{ return -ENODEV; }
 
 #endif
 
-- 
1.7.10.rc2.19.gfae9d

