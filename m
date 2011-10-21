Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab1JUMZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 08:25:30 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:34772 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab1JUMZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 08:25:27 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v3 2/3] CPU hotplug,
 Freezer: Synchronize CPU hotplug and freezer
To: a.p.zijlstra@chello.nl
Cc: rjw@sisk.pl, pavel@ucw.cz, len.brown@intel.com, mingo@elte.hu,
        akpm@linux-foundation.org, suresh.b.siddha@intel.com,
        lucas.demarchi@profusion.mobi, linux-pm@vger.kernel.org,
        rusty@rustcorp.com.au, vatsa@linux.vnet.ibm.com, ashok.raj@intel.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        rdunlap@xenotime.net
Date: Fri, 21 Oct 2011 17:55:20 +0530
Message-ID: <20111021122506.14321.51970.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20111021122401.14321.45857.stgit@srivatsabhat.in.ibm.com>
References: <20111021122401.14321.45857.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't allow the freezer subsystem to race with CPU hotplug to ensure that
during the entire duration for which the CPU hotplug notifications are run,
the state of the system (with respect to the tasks being frozen or not)
remains constant.

This patch introduces four notifications in the freezer subsystem,
PM_FREEZE_PREPARE, PM_POST_FREEZE, PM_THAW_PREPARE and PM_POST_THAW.
These help in making other subsystems aware of the freezer's activity.
The CPU hotplug infrastructure hooks on to these notifications and
synchronizes with the freezer.

Specifically:

* Upon any freezer notification that indicates a change about to happen to
  the tasks' frozen/unfrozen state, such as PM_FREEZE_PREPARE or
  PM_THAW_PREPARE, the CPU hotplug callback for these events disables future
  (regular) CPU hotplugging and also ensures that any currently running CPU
  hotplug operation is completed before allowing the freezer to continue.

* Upon freezer notifications that indicate a completion of an action such as
  freezing or thawing of processes, the CPU hotplug callback handler
  re-enables regular CPU hotplug.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/suspend.h |    6 +++-
 kernel/cpu.c            |   71 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/power/process.c  |   10 +++++++
 3 files changed, 86 insertions(+), 1 deletions(-)

diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 6bbcef2..e526543 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -268,13 +268,17 @@ static inline int hibernate(void) { return -ENOSYS; }
 static inline bool system_entering_hibernation(void) { return false; }
 #endif /* CONFIG_HIBERNATION */
 
-/* Hibernation and suspend events */
+/* Hibernation, suspend and freezer events */
 #define PM_HIBERNATION_PREPARE	0x0001 /* Going to hibernate */
 #define PM_POST_HIBERNATION	0x0002 /* Hibernation finished */
 #define PM_SUSPEND_PREPARE	0x0003 /* Going to suspend the system */
 #define PM_POST_SUSPEND		0x0004 /* Suspend finished */
 #define PM_RESTORE_PREPARE	0x0005 /* Going to restore a saved image */
 #define PM_POST_RESTORE		0x0006 /* Restore failed */
+#define PM_FREEZE_PREPARE	0x0007 /* Going to freeze tasks */
+#define PM_POST_FREEZE  	0x0008 /* Freezing of tasks finished */
+#define PM_THAW_PREPARE  	0x0009 /* Going to thaw tasks */
+#define PM_POST_THAW    	0x000A /* Thawing of tasks finished */
 
 #ifdef CONFIG_PM_SLEEP
 void save_processor_state(void);
diff --git a/kernel/cpu.c b/kernel/cpu.c
index e889ffd..3d14385 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -16,6 +16,7 @@
 #include <linux/mutex.h>
 #include <linux/gfp.h>
 #include <linux/freezer.h>
+#include <linux/suspend.h>
 
 #ifdef CONFIG_SMP
 /* Serializes the updates to cpu_online_mask, cpu_present_mask */
@@ -479,6 +480,76 @@ static int alloc_frozen_cpus(void)
 core_initcall(alloc_frozen_cpus);
 #endif /* CONFIG_PM_SLEEP_SMP */
 
+
+#ifdef CONFIG_FREEZER
+
+/*
+ * Avoid CPU hotplug racing with the freezer subsystem, by disabling CPU
+ * hotplug when tasks are about to be frozen or thawed.
+ * Don't allow the freezer subsystem to continue until any currently running
+ * CPU hotplug operation gets completed.
+ */
+static void cpu_hotplug_freezer_block_begin(void)
+{
+	cpu_maps_update_begin();
+	cpu_hotplug_disabled = 1;
+	cpu_maps_update_done();
+}
+
+
+/*
+ * When freezing or thawing of tasks is complete, re-enable CPU hotplug (which
+ * was disabled when freezing/thawing had begun).
+ */
+static void cpu_hotplug_freezer_block_done(void)
+{
+	cpu_maps_update_begin();
+	cpu_hotplug_disabled = 0;
+	cpu_maps_update_done();
+}
+
+
+/*
+ * Avoid CPU hotplug and the freezer subsystem from racing with each other,
+ * so that when CPU hotplug notifications are being sent (i.e., the
+ * registered callbacks being executed), the state of the system reported
+ * by the notifier (with respect to the tasks being frozen or not) is
+ * consistent with the actual state of the system, *throughout the duration*
+ * during which the CPU hotplug notifications are active.
+ */
+static int
+cpu_hotplug_freezer_callback(struct notifier_block *nb,
+				unsigned long action, void *ptr)
+{
+	switch (action) {
+
+	case PM_FREEZE_PREPARE:
+	case PM_THAW_PREPARE:
+		cpu_hotplug_freezer_block_begin();
+		break;
+
+	case PM_POST_FREEZE:
+	case PM_POST_THAW:
+		cpu_hotplug_freezer_block_done();
+		break;
+
+	default:
+		return NOTIFY_OK;
+	}
+
+	return NOTIFY_DONE;
+}
+
+
+static void cpu_hotplug_freezer_sync_init(void)
+{
+	pm_notifier(cpu_hotplug_freezer_callback, 0);
+}
+core_initcall(cpu_hotplug_freezer_sync_init);
+
+#endif /* CONFIG_FREEZER */
+
+
 /**
  * notify_cpu_starting(cpu) - call the CPU_STARTING notifiers
  * @cpu: cpu that just started
diff --git a/kernel/power/process.c b/kernel/power/process.c
index 230bf96..9b7e07a 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -17,6 +17,8 @@
 #include <linux/delay.h>
 #include <linux/workqueue.h>
 
+#include "power.h"
+
 /*
  * Timeout for stopping processes
  */
@@ -158,6 +160,8 @@ int freeze_processes(void)
 {
 	int error;
 
+	pm_notifier_call_chain(PM_FREEZE_PREPARE);
+
 	printk("Freezing user space processes ... ");
 	error = try_to_freeze_tasks(true);
 	if (error)
@@ -177,6 +181,8 @@ int freeze_processes(void)
 	BUG_ON(in_atomic());
 	printk("\n");
 
+	pm_notifier_call_chain(PM_POST_FREEZE);
+
 	return error;
 }
 
@@ -202,6 +208,8 @@ static void thaw_tasks(bool nosig_only)
 
 void thaw_processes(void)
 {
+	pm_notifier_call_chain(PM_THAW_PREPARE);
+
 	oom_killer_enable();
 
 	printk("Restarting tasks ... ");
@@ -211,5 +219,7 @@ void thaw_processes(void)
 	clear_tasks_frozen_flag();
 	schedule();
 	printk("done.\n");
+
+	pm_notifier_call_chain(PM_POST_THAW);
 }
 

