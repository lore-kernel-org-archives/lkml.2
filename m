Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab1DBHCb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 03:02:31 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:59186 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab1DBHCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 03:02:02 -0400
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        x86@kernel.org, Kevin Hilman <khilman@deeprootsystems.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 11/18] cpuidle: stop using pm_idle
Date: Sat, 02 Apr 2011 02:22:53 -0400
Message-id: <5f8cf82855ca448698efe66f48779972ad08ffc0.1301724243.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.5.rc0
In-reply-to: <1301725380-10579-1-git-send-email-lenb@kernel.org>
References: <alpine.LFD.2.02.1104010020280.2797@x980>
 <1301725380-10579-1-git-send-email-lenb@kernel.org>
In-reply-to: <c82cf78992a66bfa7f0c82aeb20ba6922127463b.1301724243.git.len.brown@intel.com>
References: <c82cf78992a66bfa7f0c82aeb20ba6922127463b.1301724243.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
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
 drivers/cpuidle/cpuidle.c    |   38 ++++++++++++++++++--------------------
 include/linux/cpuidle.h      |    2 ++
 6 files changed, 33 insertions(+), 25 deletions(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 94bbedb..dc9d685 100644
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
index bd387e8..210641a 100644
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
index 041df0b..d4c5423 100644
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
@@ -56,25 +56,23 @@ static int __cpuidle_register_device(struct cpuidle_device *dev);
  * cpuidle_idle_call - the main idle loop
  *
  * NOTE: no locks or semaphores should be used here
+ * return non-zero on failure
  */
-static void cpuidle_idle_call(void)
+int cpuidle_idle_call(void)
 {
 	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
 	struct cpuidle_state *target_state;
 	int next_state;
 
+	if (off)
+		return -ENODEV;
+
+	if (!initialized)
+		return -ENODEV;
+
 	/* check if the device is ready */
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
+	if (!dev || !dev->enabled)
+		return -EBUSY;
 
 #if 0
 	/* shows regressions, re-enable for 2.6.29 */
@@ -99,7 +97,7 @@ static void cpuidle_idle_call(void)
 	next_state = cpuidle_curr_governor->select(dev);
 	if (need_resched()) {
 		local_irq_enable();
-		return;
+		return 0;
 	}
 
 	target_state = &dev->states[next_state];
@@ -124,6 +122,8 @@ static void cpuidle_idle_call(void)
 	/* give the governor an opportunity to reflect on the outcome */
 	if (cpuidle_curr_governor->reflect)
 		cpuidle_curr_governor->reflect(dev);
+
+	return 0;
 }
 
 /**
@@ -131,10 +131,10 @@ static void cpuidle_idle_call(void)
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
 
@@ -143,8 +143,8 @@ void cpuidle_install_idle_handler(void)
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
@@ -440,8 +440,6 @@ static int __init cpuidle_init(void)
 	if (cpuidle_disabled())
 		return -ENODEV;
 
-	pm_idle_old = pm_idle;
-
 	ret = cpuidle_add_class_sysfs(&cpu_sysdev_class);
 	if (ret)
 		return ret;
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index b89f67d..b51629e 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -123,6 +123,7 @@ struct cpuidle_driver {
 
 #ifdef CONFIG_CPU_IDLE
 extern void disable_cpuidle(void);
+extern int cpuidle_idle_call(void);
 
 extern int cpuidle_register_driver(struct cpuidle_driver *drv);
 struct cpuidle_driver *cpuidle_get_driver(void);
@@ -137,6 +138,7 @@ extern void cpuidle_disable_device(struct cpuidle_device *dev);
 
 #else
 static inline void disable_cpuidle(void) { }
+static inline int cpuidle_idle_call(void) { return -ENODEV; }
 
 static inline int cpuidle_register_driver(struct cpuidle_driver *drv)
 {return -ENODEV; }
-- 
1.7.5.rc0

