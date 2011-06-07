Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab1FGQaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 12:30:24 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:43939 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995Ab1FGQaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 12:30:21 -0400
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Subject: [RFC PATCH V1 5/7] cpuidle: (POWER) cpuidle driver for pSeries
To: linux-pm@lists.linux-foundation.org, linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Date: Tue, 07 Jun 2011 22:00:15 +0530
Message-ID: <20110607163012.6848.19268.stgit@tringupt.in.ibm.com>
In-Reply-To: <20110607162847.6848.44707.stgit@tringupt.in.ibm.com>
References: <20110607162847.6848.44707.stgit@tringupt.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements a cpuidle driver for pSeries based on
routines pseries_dedicated_idle_loop and pseries_shared_idle_loop.
The driver is built only if CONFIG_CPU_IDLE is set. This
cpuidle driver uses global registration of idle states and
not per-cpu.

Signed-off-by: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---

 arch/powerpc/include/asm/system.h               |    8 +
 arch/powerpc/kernel/sysfs.c                     |    2 
 arch/powerpc/platforms/pseries/Kconfig          |    9 +
 arch/powerpc/platforms/pseries/Makefile         |    1 
 arch/powerpc/platforms/pseries/processor_idle.c |  331 +++++++++++++++++++++++
 arch/powerpc/platforms/pseries/pseries.h        |    3 
 arch/powerpc/platforms/pseries/setup.c          |    3 
 arch/powerpc/platforms/pseries/smp.c            |    1 
 8 files changed, 355 insertions(+), 3 deletions(-)
 create mode 100644 arch/powerpc/platforms/pseries/processor_idle.c

diff --git a/arch/powerpc/include/asm/system.h b/arch/powerpc/include/asm/system.h
index 811cdf1..b5b4fc4 100644
--- a/arch/powerpc/include/asm/system.h
+++ b/arch/powerpc/include/asm/system.h
@@ -224,6 +224,14 @@ extern void *zalloc_maybe_bootmem(size_t size, gfp_t mask);
 extern int powersave_nap;	/* set if nap mode can be used in idle loop */
 void cpu_idle_wait(void);
 
+#ifdef CONFIG_PSERIES_IDLE
+extern void update_smt_snooze_delay(int snooze);
+extern int pseries_notify_cpuidle_add_cpu(int cpu);
+#else
+static inline void update_smt_snooze_delay(int snooze) {}
+static inline int pseries_notify_cpuidle_add_cpu(int cpu) { }
+#endif
+
 /*
  * Atomic exchange
  *
diff --git a/arch/powerpc/kernel/sysfs.c b/arch/powerpc/kernel/sysfs.c
index f0f2199..fbb666f 100644
--- a/arch/powerpc/kernel/sysfs.c
+++ b/arch/powerpc/kernel/sysfs.c
@@ -18,6 +18,7 @@
 #include <asm/machdep.h>
 #include <asm/smp.h>
 #include <asm/pmc.h>
+#include <asm/system.h>
 
 #include "cacheinfo.h"
 
@@ -51,6 +52,7 @@ static ssize_t store_smt_snooze_delay(struct sys_device *dev,
 		return -EINVAL;
 
 	per_cpu(smt_snooze_delay, cpu->sysdev.id) = snooze;
+	update_smt_snooze_delay(snooze);
 
 	return count;
 }
diff --git a/arch/powerpc/platforms/pseries/Kconfig b/arch/powerpc/platforms/pseries/Kconfig
index 71af4c5..877bac6 100644
--- a/arch/powerpc/platforms/pseries/Kconfig
+++ b/arch/powerpc/platforms/pseries/Kconfig
@@ -118,3 +118,12 @@ config DTL
 	  which are accessible through a debugfs file.
 
 	  Say N if you are unsure.
+
+config PSERIES_IDLE
+	tristate "Cpuidle driver for pSeries platforms"
+	depends on CPU_IDLE
+	depends on PPC_PSERIES
+	default y
+	help
+	  Select this option to enable processor idle state management
+	  through cpuidle subsystem.
diff --git a/arch/powerpc/platforms/pseries/Makefile b/arch/powerpc/platforms/pseries/Makefile
index 3556e40..236db46 100644
--- a/arch/powerpc/platforms/pseries/Makefile
+++ b/arch/powerpc/platforms/pseries/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_PHYP_DUMP)		+= phyp_dump.o
 obj-$(CONFIG_CMM)		+= cmm.o
 obj-$(CONFIG_DTL)		+= dtl.o
 obj-$(CONFIG_IO_EVENT_IRQ)	+= io_event_irq.o
+obj-$(CONFIG_PSERIES_IDLE)	+= processor_idle.o
 
 ifeq ($(CONFIG_PPC_PSERIES),y)
 obj-$(CONFIG_SUSPEND)		+= suspend.o
diff --git a/arch/powerpc/platforms/pseries/processor_idle.c b/arch/powerpc/platforms/pseries/processor_idle.c
new file mode 100644
index 0000000..ff44b49
--- /dev/null
+++ b/arch/powerpc/platforms/pseries/processor_idle.c
@@ -0,0 +1,331 @@
+/*
+ *  processor_idle - idle state cpuidle driver.
+ *  Adapted from drivers/idle/intel_idle.c and
+ *  drivers/acpi/processor_idle.c
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/moduleparam.h>
+#include <linux/cpuidle.h>
+#include <linux/cpu.h>
+
+#include <asm/paca.h>
+#include <asm/reg.h>
+#include <asm/system.h>
+#include <asm/machdep.h>
+#include <asm/firmware.h>
+
+#include "plpar_wrappers.h"
+#include "pseries.h"
+
+struct cpuidle_driver pseries_idle_driver = {
+	.name =		"pseries_idle",
+	.owner =	THIS_MODULE,
+};
+
+#define MAX_IDLE_STATE_COUNT	2
+
+static int max_cstate = MAX_IDLE_STATE_COUNT - 1;
+static struct cpuidle_device __percpu *pseries_idle_cpuidle_devices;
+static struct cpuidle_state *cpuidle_state_table;
+
+void update_smt_snooze_delay(int snooze)
+{
+	struct cpuidle_driver *drv = cpuidle_get_driver();
+	if (drv)
+		drv->states[0].target_residency = snooze;
+}
+
+static int snooze_loop(struct cpuidle_device *dev,
+			struct cpuidle_driver *drv,
+			int index)
+{
+	unsigned long in_purr, out_purr;
+	ktime_t kt_before, kt_after;
+	s64 usec_delta;
+
+	/*
+	 * Indicate to the HV that we are idle. Now would be
+	 * a good time to find other work to dispatch.
+	 */
+	get_lppaca()->idle = 1;
+	get_lppaca()->donate_dedicated_cpu = 1;
+	in_purr = mfspr(SPRN_PURR);
+
+	kt_before = ktime_get_real();
+
+	local_irq_enable();
+	set_thread_flag(TIF_POLLING_NRFLAG);
+	while (!need_resched()) {
+		ppc64_runlatch_off();
+		HMT_low();
+		HMT_very_low();
+	}
+	HMT_medium();
+	clear_thread_flag(TIF_POLLING_NRFLAG);
+	smp_mb();
+	local_irq_disable();
+
+	kt_after = ktime_get_real();
+	usec_delta = ktime_to_us(ktime_sub(kt_after, kt_before));
+
+	out_purr = mfspr(SPRN_PURR);
+	get_lppaca()->wait_state_cycles += out_purr - in_purr;
+	get_lppaca()->donate_dedicated_cpu = 0;
+	get_lppaca()->idle = 0;
+
+	dev->last_residency = (int)usec_delta;
+
+	return index;
+}
+
+static int dedicated_cede_loop(struct cpuidle_device *dev,
+				struct cpuidle_driver *drv,
+				int index)
+{
+	unsigned long in_purr, out_purr;
+	ktime_t kt_before, kt_after;
+	s64 usec_delta;
+
+	/*
+	 * Indicate to the HV that we are idle. Now would be
+	 * a good time to find other work to dispatch.
+	 */
+	get_lppaca()->idle = 1;
+	get_lppaca()->donate_dedicated_cpu = 1;
+	in_purr = mfspr(SPRN_PURR);
+
+	kt_before = ktime_get_real();
+
+	ppc64_runlatch_off();
+	HMT_medium();
+	cede_processor();
+
+	kt_after = ktime_get_real();
+	usec_delta = ktime_to_us(ktime_sub(kt_after, kt_before));
+
+	out_purr = mfspr(SPRN_PURR);
+	get_lppaca()->wait_state_cycles += out_purr - in_purr;
+	get_lppaca()->donate_dedicated_cpu = 0;
+	get_lppaca()->idle = 0;
+
+	dev->last_residency = (int)usec_delta;
+
+	return index;
+}
+
+static int shared_cede_loop(struct cpuidle_device *dev,
+			struct cpuidle_driver *drv,
+			int index)
+{
+	unsigned long in_purr, out_purr;
+	ktime_t kt_before, kt_after;
+	s64 usec_delta;
+
+	/*
+	 * Indicate to the HV that we are idle. Now would be
+	 * a good time to find other work to dispatch.
+	 */
+	get_lppaca()->idle = 1;
+	get_lppaca()->donate_dedicated_cpu = 1;
+	in_purr = mfspr(SPRN_PURR);
+
+	kt_before = ktime_get_real();
+	/*
+	 * Yield the processor to the hypervisor.  We return if
+	 * an external interrupt occurs (which are driven prior
+	 * to returning here) or if a prod occurs from another
+	 * processor. When returning here, external interrupts
+	 * are enabled.
+	 */
+	cede_processor();
+
+	kt_after = ktime_get_real();
+
+	usec_delta = ktime_to_us(ktime_sub(kt_after, kt_before));
+
+	out_purr = mfspr(SPRN_PURR);
+	get_lppaca()->wait_state_cycles += out_purr - in_purr;
+	get_lppaca()->donate_dedicated_cpu = 0;
+	get_lppaca()->idle = 0;
+
+	dev->last_residency = (int)usec_delta;
+
+	return index;
+}
+
+/*
+ * States for dedicated partition case.
+ */
+static struct cpuidle_state dedicated_states[MAX_IDLE_STATE_COUNT] = {
+	{ /* Snooze */
+		.name = "snooze",
+		.desc = "snooze",
+		.flags = CPUIDLE_FLAG_TIME_VALID,
+		.exit_latency = 0,
+		.target_residency = 0,
+		.enter = &snooze_loop },
+	{ /* CEDE */
+		.name = "CEDE",
+		.desc = "CEDE",
+		.flags = CPUIDLE_FLAG_TIME_VALID,
+		.exit_latency = 1,
+		.target_residency = 10,
+		.enter = &dedicated_cede_loop },
+};
+
+/*
+ * States for shared partition case.
+ */
+static struct cpuidle_state shared_states[MAX_IDLE_STATE_COUNT] = {
+	{ /* Shared Cede */
+		.name = "Shared Cede",
+		.desc = "Shared Cede",
+		.flags = CPUIDLE_FLAG_TIME_VALID,
+		.exit_latency = 0,
+		.target_residency = 0,
+		.enter = &shared_cede_loop },
+};
+
+int pseries_notify_cpuidle_add_cpu(int cpu)
+{
+	struct cpuidle_device *dev =
+			per_cpu_ptr(pseries_idle_cpuidle_devices, cpu);
+	if (dev && cpuidle_get_driver()) {
+		cpuidle_disable_device(dev);
+		cpuidle_enable_device(dev);
+	}
+	return 0;
+}
+
+/*
+ * pseries_idle_cpuidle_driver_init()
+ */
+static int pseries_idle_cpuidle_driver_init(void)
+{
+	int cstate;
+	struct cpuidle_driver *drv = &pseries_idle_driver;
+
+	drv->state_count = 0;
+
+	for (cstate = 0; cstate < MAX_IDLE_STATE_COUNT; ++cstate) {
+
+		if (cstate > max_cstate)
+			break;
+
+		/* is the state not enabled? */
+		if (cpuidle_state_table[cstate].enter == NULL)
+			continue;
+
+		drv->states[drv->state_count] =	/* structure copy */
+			cpuidle_state_table[cstate];
+
+		if (cpuidle_state_table == dedicated_states)
+			drv->states[drv->state_count].target_residency =
+				__get_cpu_var(smt_snooze_delay);
+
+		drv->state_count += 1;
+	}
+
+	return 0;
+}
+
+/* pseries_idle_devices_uninit(void)
+ * unregister cpuidle devices and de-allocate memory
+ */
+static void pseries_idle_devices_uninit(void)
+{
+	int i;
+	struct cpuidle_device *dev;
+
+	for_each_possible_cpu(i) {
+		dev = per_cpu_ptr(pseries_idle_cpuidle_devices, i);
+		cpuidle_unregister_device(dev);
+	}
+
+	free_percpu(pseries_idle_cpuidle_devices);
+	return;
+}
+
+/* pseries_idle_devices_init()
+ * allocate, initialize and register cpuidle device
+ */
+static int pseries_idle_devices_init(void)
+{
+	int i;
+	struct cpuidle_driver *drv = &pseries_idle_driver;
+	struct cpuidle_device *dev;
+
+	pseries_idle_cpuidle_devices = alloc_percpu(struct cpuidle_device);
+	if (pseries_idle_cpuidle_devices == NULL)
+		return -ENOMEM;
+
+	for_each_possible_cpu(i) {
+		dev = per_cpu_ptr(pseries_idle_cpuidle_devices, i);
+		dev->state_count = drv->state_count;
+		dev->cpu = i;
+		if (cpuidle_register_device(dev)) {
+			printk(KERN_DEBUG "cpuidle_register_device %d failed!\n",
+				 i);
+			return -EIO;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * pseries_idle_probe()
+ * Choose state table for shared versus dedicated partition
+ */
+static int pseries_idle_probe(void)
+{
+	if (max_cstate == 0) {
+		printk(KERN_DEBUG "pseries processor idle disabled.\n");
+		return -EPERM;
+	}
+
+	if (!firmware_has_feature(FW_FEATURE_SPLPAR)) {
+		printk(KERN_DEBUG "Using default idle\n");
+		return -ENODEV;
+	}
+
+	if (get_lppaca()->shared_proc)
+		cpuidle_state_table = shared_states;
+	else
+		cpuidle_state_table = dedicated_states;
+
+	return 0;
+}
+
+static int __init pseries_processor_idle_init(void)
+{
+	int retval;
+
+	retval = pseries_idle_probe();
+	if (retval)
+		return retval;
+
+	pseries_idle_cpuidle_driver_init();
+	retval = cpuidle_register_driver(&pseries_idle_driver);
+	if (retval) {
+		printk(KERN_DEBUG "Registration of pseries driver failed.\n");
+		return retval;
+	}
+
+	retval = pseries_idle_devices_init();
+	if (retval) {
+		pseries_idle_devices_uninit();
+		cpuidle_unregister_driver(&pseries_idle_driver);
+		return retval;
+	}
+
+	printk(KERN_DEBUG "pseries_idle_driver registered\n");
+
+	return 0;
+}
+
+device_initcall(pseries_processor_idle_init);
diff --git a/arch/powerpc/platforms/pseries/pseries.h b/arch/powerpc/platforms/pseries/pseries.h
index e9f6d28..7c60380 100644
--- a/arch/powerpc/platforms/pseries/pseries.h
+++ b/arch/powerpc/platforms/pseries/pseries.h
@@ -56,4 +56,7 @@ extern struct device_node *dlpar_configure_connector(u32);
 extern int dlpar_attach_node(struct device_node *);
 extern int dlpar_detach_node(struct device_node *);
 
+/* Snooze Delay, pseries_idle */
+DECLARE_PER_CPU(long, smt_snooze_delay);
+
 #endif /* _PSERIES_PSERIES_H */
diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index 593acce..6893a0c 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -584,9 +584,6 @@ static int __init pSeries_probe(void)
 	return 1;
 }
 
-
-DECLARE_PER_CPU(long, smt_snooze_delay);
-
 static void pseries_dedicated_idle_sleep(void)
 { 
 	unsigned int cpu = smp_processor_id();
diff --git a/arch/powerpc/platforms/pseries/smp.c b/arch/powerpc/platforms/pseries/smp.c
index fbffd7e..2e46883 100644
--- a/arch/powerpc/platforms/pseries/smp.c
+++ b/arch/powerpc/platforms/pseries/smp.c
@@ -150,6 +150,7 @@ static void __devinit smp_xics_setup_cpu(int cpu)
 	set_cpu_current_state(cpu, CPU_STATE_ONLINE);
 	set_default_offline_state(cpu);
 #endif
+	pseries_notify_cpuidle_add_cpu(cpu);
 }
 
 static int __devinit smp_pSeries_kick_cpu(int nr)

