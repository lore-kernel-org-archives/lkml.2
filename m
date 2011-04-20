Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab1DTI2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 04:28:32 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:12448 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab1DTI22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 04:28:28 -0400
Date: Wed, 20 Apr 2011 17:28:26 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [RFC PATCH] PM / Core: suspend_again cb for syscore_ops
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com
Message-id: <1303288106-2965-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 20 Apr 2011 08:28:26.0494 (UTC)
 FILETIME=[EB8511E0:01CBFF34]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A system or a device may need to control suspend/wakeup events. It may
want to wakeup the system after a predefined amount of time or at a
predefined event decided while entering suspend for polling or delayed
work. Then, it may want to enter suspend again if its predefined wakeup
condition is the only wakeup reason and there is no outstanding events;
thus, it does not wakeup the userspace unnecessary and keeps suspended
as long as possible (saving the power).

Enabling a system to wakeup after a specified time can be easily
achieved by using RTC. However, to enter suspend again immediately
without invoking userland, we need additional features in the
suspend framework.

Such need comes from:

1. Monitoring a critical device status without interrupts that can
wakeup the system. (in-suspend polling)
 An example is ambient temperature monitoring that needs to shut down
the system or a specific device function if it is too hot or cold. The
temperature of a specific device may be needed to be monitored as well;
e.g., a charger monitors battery temperature in order to stop charging
if overheated.

2. Execute critical "delayed work" at suspend.
 A driver or a system/board may have a delayed work (or any similar
things) that it wants to execute at the requested time.
 For example, some chargers want to check the battery voltage some
time (e.g., 30 seconds) after the battery is fully charged and the
charger stops. Then, the charger restarts charging if the voltage has
dropped more than a threshold, which is smaller than "restart-charger"
voltage, which is a threshold to restart charging regardless of the
time passed.

This patch allows a system or a device to provide "suspend_again"
callback with syscore_ops. With suspend_again callbacks registered,
the suspend framework (kernel/power/suspend.c) tries to enter suspend
again if conditions are met.

The system enters the suspend again if and only if all of the following
conditions are met:
1. None of suspend_again ops returned "I want to stop suspend"
(suspend_again returns SUSPEND_AGAIN_STOP).
2. At least one of suspend_again ops returned "I want to suspend again"
(suspend_again returns SUSPEND_AGAIN_CONTINUE)

suspend_again ops may return "I do not care. This wakeup is not related
with me." (SUSPEND_AGAIN_NC, which is 0).

Use SUSPEND_AGAIN_STOP in order to override other devices'
SUSPEND_AGAIN_CONTINUE and to wakeup fully. For devices that poll
sensors during suspend may need this if any outstanding status is found.
For conventional suspend wakeup sources, SUSPEND_AGAIN_STOP may be used
to override SUSPEND_AGAIN devices.

Anyway, the following features may need to be added later:
1. An API to allow devices to express next desired wakeup-time. Then,
the framework will combine them and setup RTC alarm accordingly and
save/restore previously registered RTC alarms.
2. Create a method to declare a specific instance of delayed-work is to
be executed in suspend by waking up the system in the middle of
suspend. Then, let the framework handle those "critical" delayed-work
in suspend.
3. If a device says SUSPEND_AGAIN_CONTINUE and there is another wakeup
source pending (e.g., power button) without suspend_again ops, the
system will enter suspend again. In such a case, the system should not
suspend again. We may need to see if irqs that are enabled by
set_irq_wake() (and not related to suspend_ops devices)
are pending at syscore_suspend_again(). Maybe we need to add
something like "set_irq_wake_with_suspend_again" so that IRQs with
suspend_again ops implemented are ignored for the
"override-suspend-again-continue" checking.

For the initial release, I have set the point of "suspend-again" after
suspend_ops->end(). However, I'm not so sure about where to set the
suspend-again point. Because in-suspend polling, which may require
I/O with other devices, is supposed to be executed at suspend-again ops,
the suspend-again point is configured to be as late as possible in
suspend_devices_and_enter(). In order to reduce the number of devices
waked up, we may need to set the suspend-again point ealier.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/base/syscore.c      |   36 +++++++++++++++++++++++++++
 include/linux/syscore_ops.h |    7 +++++
 kernel/power/suspend.c      |   57 +++++++++++++++++++++++-------------------
 3 files changed, 74 insertions(+), 26 deletions(-)

diff --git a/drivers/base/syscore.c b/drivers/base/syscore.c
index 90af294..1a7e08d 100644
--- a/drivers/base/syscore.c
+++ b/drivers/base/syscore.c
@@ -95,6 +95,42 @@ void syscore_resume(void)
 				"Interrupts enabled after %pF\n", ops->resume);
 		}
 }
+
+/**
+ * syscore_suspend_again - Execute all the registeres system core suspend_again
+ *			callbacks. If at least one returns
+ *			SUSPEND_AGAIN_CONTINUE and no one returns
+ *			SUSPEND_AGAIN_STOP, syscore_suspend_again let the system
+ *			enter suspend again.
+ */
+bool syscore_suspend_again(void)
+{
+	struct syscore_ops *ops;
+	enum suspend_again_cond condition = SUSPEND_AGAIN_NC;
+
+	list_for_each_entry(ops, &syscore_ops_list, node)
+		if (ops->suspend_again) {
+			switch (ops->suspend_again()) {
+			case SUSPEND_AGAIN_NC:
+				break;
+			case SUSPEND_AGAIN_CONTINUE:
+				if (condition == SUSPEND_AGAIN_NC)
+					condition = SUSPEND_AGAIN_CONTINUE;
+				break;
+			case SUSPEND_AGAIN_STOP:
+				condition = SUSPEND_AGAIN_STOP;
+				break;
+			default:
+				pr_warn("PM: incorrect return from %pF\n",
+					ops->suspend_again);
+			}
+		}
+
+	if (condition == SUSPEND_AGAIN_CONTINUE)
+		return true;
+
+	return false;
+}
 #endif /* CONFIG_PM_SLEEP */
 
 /**
diff --git a/include/linux/syscore_ops.h b/include/linux/syscore_ops.h
index 27b3b0b..bf9bc4e 100644
--- a/include/linux/syscore_ops.h
+++ b/include/linux/syscore_ops.h
@@ -11,10 +11,16 @@
 
 #include <linux/list.h>
 
+enum suspend_again_cond {
+	SUSPEND_AGAIN_NC = 0, /* Do Not Care */
+	SUSPEND_AGAIN_CONTINUE, /* Start or keep the again */
+	SUSPEND_AGAIN_STOP, /* Stop or do not start. Override CONTINUE */
+};
 struct syscore_ops {
 	struct list_head node;
 	int (*suspend)(void);
 	void (*resume)(void);
+	enum suspend_again_cond (*suspend_again)(void);
 	void (*shutdown)(void);
 };
 
@@ -23,6 +29,7 @@ extern void unregister_syscore_ops(struct syscore_ops *ops);
 #ifdef CONFIG_PM_SLEEP
 extern int syscore_suspend(void);
 extern void syscore_resume(void);
+extern bool syscore_suspend_again(void);
 #endif
 extern void syscore_shutdown(void);
 
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 2814c32..aa6a3d1 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -202,43 +202,48 @@ static int suspend_enter(suspend_state_t state)
 int suspend_devices_and_enter(suspend_state_t state)
 {
 	int error;
+	bool recover = false;
 
 	if (!suspend_ops)
 		return -ENOSYS;
 
-	trace_machine_suspend(state);
-	if (suspend_ops->begin) {
-		error = suspend_ops->begin(state);
-		if (error)
-			goto Close;
-	}
-	suspend_console();
-	pm_restrict_gfp_mask();
-	suspend_test_start();
-	error = dpm_suspend_start(PMSG_SUSPEND);
-	if (error) {
-		printk(KERN_ERR "PM: Some devices failed to suspend\n");
-		goto Recover_platform;
-	}
-	suspend_test_finish("suspend devices");
-	if (suspend_test(TEST_DEVICES))
-		goto Recover_platform;
+	do {
+		trace_machine_suspend(state);
+		if (suspend_ops->begin) {
+			error = suspend_ops->begin(state);
+			if (error)
+				goto Close;
+		}
+		suspend_console();
+		pm_restrict_gfp_mask();
+		suspend_test_start();
+		error = dpm_suspend_start(PMSG_SUSPEND);
+		if (error) {
+			printk(KERN_ERR "PM: Some devices failed to suspend\n");
+			goto Recover_platform;
+		}
+		suspend_test_finish("suspend devices");
+		if (suspend_test(TEST_DEVICES))
+			goto Recover_platform;
 
-	suspend_enter(state);
+		error = suspend_enter(state);
 
  Resume_devices:
-	suspend_test_start();
-	dpm_resume_end(PMSG_RESUME);
-	suspend_test_finish("resume devices");
-	pm_restore_gfp_mask();
-	resume_console();
+		suspend_test_start();
+		dpm_resume_end(PMSG_RESUME);
+		suspend_test_finish("resume devices");
+		pm_restore_gfp_mask();
+		resume_console();
  Close:
-	if (suspend_ops->end)
-		suspend_ops->end();
-	trace_machine_suspend(PWR_EVENT_EXIT);
+		if (suspend_ops->end)
+			suspend_ops->end();
+		trace_machine_suspend(PWR_EVENT_EXIT);
+	} while (syscore_suspend_again() && !error && !recover);
+
 	return error;
 
  Recover_platform:
+	recover = true;
 	if (suspend_ops->recover)
 		suspend_ops->recover();
 	goto Resume_devices;
-- 
1.7.1

