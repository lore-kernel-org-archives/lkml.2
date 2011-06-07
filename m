Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab1FGQ35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 12:29:57 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:34072 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab1FGQ34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 12:29:56 -0400
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Subject: [RFC PATCH V1 3/7] cpuidle: stop using pm_idle
To: linux-pm@lists.linux-foundation.org, linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Date: Tue, 07 Jun 2011 21:59:50 +0530
Message-ID: <20110607162947.6848.79430.stgit@tringupt.in.ibm.com>
In-Reply-To: <20110607162847.6848.44707.stgit@tringupt.in.ibm.com>
References: <20110607162847.6848.44707.stgit@tringupt.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

pm_idle does not scale as an idle handler registration mechanism.
Don't use it for cpuidle.  Instead, call cpuidle directly, and
allow architectures to use pm_idle as an arch-specific default
if they need it.  ie.

cpu_idle()
	...
	if(cpuidle_call_idle())
		pm_idle();

cc: x86@kernel.org
cc: Kevin Hilman <khilman@deeprootsystems.com>
cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Len Brown <len.brown@intel.com>
---

 arch/arm/kernel/process.c    |    4 +++-
 arch/sh/kernel/idle.c        |    6 ++++--
 arch/x86/kernel/process_32.c |    4 +++-
 arch/x86/kernel/process_64.c |    4 +++-
 drivers/cpuidle/cpuidle.c    |   39 ++++++++++++++++++---------------------
 include/linux/cpuidle.h      |    2 ++
 6 files changed, 33 insertions(+), 26 deletions(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 5e1e541..d7ee0d4 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -30,6 +30,7 @@
 #include <linux/uaccess.h>
 #include <linux/random.h>
 #include <linux/hw_breakpoint.h>
+#include <linux/cpuidle.h>
 
 #include <asm/cacheflush.h>
 #include <asm/leds.h>
@@ -196,7 +197,8 @@ void cpu_idle(void)
 				cpu_relax();
 			} else {
 				stop_critical_timings();
-				pm_idle();
+				if (cpuidle_call_idle())
+					pm_idle();
 				start_critical_timings();
 				/*
 				 * This will eventually be removed - pm_idle
diff --git a/arch/sh/kernel/idle.c b/arch/sh/kernel/idle.c
index 425d604..9c7099e 100644
--- a/arch/sh/kernel/idle.c
+++ b/arch/sh/kernel/idle.c
@@ -16,12 +16,13 @@
 #include <linux/thread_info.h>
 #include <linux/irqflags.h>
 #include <linux/smp.h>
+#include <linux/cpuidle.h>
 #include <asm/pgalloc.h>
 #include <asm/system.h>
 #include <asm/atomic.h>
 #include <asm/smp.h>
 
-void (*pm_idle)(void) = NULL;
+static void (*pm_idle)(void);
 
 static int hlt_counter;
 
@@ -100,7 +101,8 @@ void cpu_idle(void)
 			local_irq_disable();
 			/* Don't trace irqs off for idle */
 			stop_critical_timings();
-			pm_idle();
+			if (cpuidle_call_idle())
+				pm_idle();
 			/*
 			 * Sanity check to ensure that pm_idle() returns
 			 * with IRQs enabled
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 8d12878..61fadbe 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -38,6 +38,7 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/kdebug.h>
+#include <linux/cpuidle.h>
 
 #include <asm/pgtable.h>
 #include <asm/system.h>
@@ -109,7 +110,8 @@ void cpu_idle(void)
 			local_irq_disable();
 			/* Don't trace irqs off for idle */
 			stop_critical_timings();
-			pm_idle();
+			if (cpuidle_idle_call())
+				pm_idle();
 			start_critical_timings();
 		}
 		tick_nohz_restart_sched_tick();
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 6c9dd92..62c219a 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -37,6 +37,7 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/ftrace.h>
+#include <linux/cpuidle.h>
 
 #include <asm/pgtable.h>
 #include <asm/system.h>
@@ -136,7 +137,8 @@ void cpu_idle(void)
 			enter_idle();
 			/* Don't trace irqs off for idle */
 			stop_critical_timings();
-			pm_idle();
+			if (cpuidle_idle_call())
+				pm_idle();
 			start_critical_timings();
 
 			/* In many cases the interrupt that ended idle
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 8d7303b..304e378 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -25,10 +25,10 @@ DEFINE_PER_CPU(struct cpuidle_device *, cpuidle_devices);
 
 DEFINE_MUTEX(cpuidle_lock);
 LIST_HEAD(cpuidle_detected_devices);
-static void (*pm_idle_old)(void);
 
 static int enabled_devices;
 static int off __read_mostly;
+static int initialized __read_mostly;
 
 int cpuidle_disabled(void)
 {
@@ -56,27 +56,24 @@ static int __cpuidle_register_device(struct cpuidle_device *dev);
  * cpuidle_idle_call - the main idle loop
  *
  * NOTE: no locks or semaphores should be used here
+ * return non-zero on failure
  */
-static void cpuidle_idle_call(void)
+int cpuidle_idle_call(void)
 {
 	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
 	struct cpuidle_driver *drv = cpuidle_get_driver();
 	struct cpuidle_state *target_state;
 	int next_state, entered_state;
 
-	/* check if the device is ready */
-	if (!dev || !dev->enabled) {
-		if (pm_idle_old)
-			pm_idle_old();
-		else
-#if defined(CONFIG_ARCH_HAS_DEFAULT_IDLE)
-			default_idle();
-#else
-			local_irq_enable();
-#endif
-		return;
-	}
+	if (off)
+		return -ENODEV;
+
+	if (!initialized)
+		return -ENODEV;
 
+	/* check if the device is ready */
+	if (!dev || !dev->enabled)
+		return -EBUSY;
 #if 0
 	/* shows regressions, re-enable for 2.6.29 */
 	/*
@@ -90,7 +87,7 @@ static void cpuidle_idle_call(void)
 	next_state = cpuidle_curr_governor->select(drv, dev);
 	if (need_resched()) {
 		local_irq_enable();
-		return;
+		return 0;
 	}
 
 	target_state = &drv->states[next_state];
@@ -116,6 +113,8 @@ static void cpuidle_idle_call(void)
 	/* give the governor an opportunity to reflect on the outcome */
 	if (cpuidle_curr_governor->reflect)
 		cpuidle_curr_governor->reflect(dev, entered_state);
+
+	return 0;
 }
 
 /**
@@ -123,10 +122,10 @@ static void cpuidle_idle_call(void)
  */
 void cpuidle_install_idle_handler(void)
 {
-	if (enabled_devices && (pm_idle != cpuidle_idle_call)) {
+	if (enabled_devices) {
 		/* Make sure all changes finished before we switch to new idle */
 		smp_wmb();
-		pm_idle = cpuidle_idle_call;
+		initialized = 1;
 	}
 }
 
@@ -135,8 +134,8 @@ void cpuidle_install_idle_handler(void)
  */
 void cpuidle_uninstall_idle_handler(void)
 {
-	if (enabled_devices && pm_idle_old && (pm_idle != pm_idle_old)) {
-		pm_idle = pm_idle_old;
+	if (enabled_devices) {
+		initialized = 0;
 		cpuidle_kick_cpus();
 	}
 }
@@ -410,8 +409,6 @@ static int __init cpuidle_init(void)
 	if (cpuidle_disabled())
 		return -ENODEV;
 
-	pm_idle_old = pm_idle;
-
 	ret = cpuidle_add_class_sysfs(&cpu_sysdev_class);
 	if (ret)
 		return ret;
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 2786787..c904188 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -128,6 +128,7 @@ struct cpuidle_driver {
 
 #ifdef CONFIG_CPU_IDLE
 extern void disable_cpuidle(void);
+extern int cpuidle_idle_call(void);
 
 extern int cpuidle_register_driver(struct cpuidle_driver *drv);
 struct cpuidle_driver *cpuidle_get_driver(void);
@@ -142,6 +143,7 @@ extern void cpuidle_disable_device(struct cpuidle_device *dev);
 
 #else
 static inline void disable_cpuidle(void) { }
+static inline int cpuidle_idle_call(void) { return -ENODEV; }
 
 static inline int cpuidle_register_driver(struct cpuidle_driver *drv)
 {return -ENODEV; }

