Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab1K0W5K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 17:57:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58990 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074Ab1K0W5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 17:57:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 1/2] PM / Sleep: Unify diagnostic messages from device suspend/resume
Date: Sun, 27 Nov 2011 23:59:00 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, "Greg Kroah-Hartman" <gregkh@suse.de>
References: <201111272357.26930.rjw@sisk.pl>
In-Reply-To: <201111272357.26930.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111272359.00539.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make pm_op() and pm_noirq_op() use the same helper function for
running callbacks, which will cause them to use the same format of
diagnostic messages.  This also reduces the complexity and size of
the code quite a bit.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |  128 ++++++++++++----------------------------------
 1 file changed, 35 insertions(+), 93 deletions(-)

Index: linux/drivers/base/power/main.c
===================================================================
--- linux.orig/drivers/base/power/main.c
+++ linux/drivers/base/power/main.c
@@ -164,8 +164,9 @@ static ktime_t initcall_debug_start(stru
 	ktime_t calltime = ktime_set(0, 0);
 
 	if (initcall_debug) {
-		pr_info("calling  %s+ @ %i\n",
-				dev_name(dev), task_pid_nr(current));
+		pr_info("calling  %s+ @ %i, parent: %s\n",
+			dev_name(dev), task_pid_nr(current),
+			dev->parent ? dev_name(dev->parent) : "none");
 		calltime = ktime_get();
 	}
 
@@ -210,6 +211,24 @@ static void dpm_wait_for_children(struct
        device_for_each_child(dev, &async, dpm_wait_fn);
 }
 
+static int dpm_run_callback(struct device *dev, int (*cb)(struct device *))
+{
+	ktime_t calltime;
+	int error;
+
+	if (!cb)
+		return 0;
+
+	calltime = initcall_debug_start(dev);
+
+	error = cb(dev);
+	suspend_report_result(cb, error);
+
+	initcall_debug_report(dev, calltime, error);
+
+	return error;
+}
+
 /**
  * pm_op - Execute the PM operation appropriate for given PM event.
  * @dev: Device to handle.
@@ -221,59 +240,36 @@ static int pm_op(struct device *dev,
 		 pm_message_t state)
 {
 	int error = 0;
-	ktime_t calltime;
-
-	calltime = initcall_debug_start(dev);
 
 	switch (state.event) {
 #ifdef CONFIG_SUSPEND
 	case PM_EVENT_SUSPEND:
-		if (ops->suspend) {
-			error = ops->suspend(dev);
-			suspend_report_result(ops->suspend, error);
-		}
+		error = dpm_run_callback(dev, ops->suspend);
 		break;
 	case PM_EVENT_RESUME:
-		if (ops->resume) {
-			error = ops->resume(dev);
-			suspend_report_result(ops->resume, error);
-		}
+		error = dpm_run_callback(dev, ops->resume);
 		break;
 #endif /* CONFIG_SUSPEND */
 #ifdef CONFIG_HIBERNATE_CALLBACKS
 	case PM_EVENT_FREEZE:
 	case PM_EVENT_QUIESCE:
-		if (ops->freeze) {
-			error = ops->freeze(dev);
-			suspend_report_result(ops->freeze, error);
-		}
+		error = dpm_run_callback(dev, ops->freeze);
 		break;
 	case PM_EVENT_HIBERNATE:
-		if (ops->poweroff) {
-			error = ops->poweroff(dev);
-			suspend_report_result(ops->poweroff, error);
-		}
+		error = dpm_run_callback(dev, ops->poweroff);
 		break;
 	case PM_EVENT_THAW:
 	case PM_EVENT_RECOVER:
-		if (ops->thaw) {
-			error = ops->thaw(dev);
-			suspend_report_result(ops->thaw, error);
-		}
+		error = dpm_run_callback(dev, ops->thaw);
 		break;
 	case PM_EVENT_RESTORE:
-		if (ops->restore) {
-			error = ops->restore(dev);
-			suspend_report_result(ops->restore, error);
-		}
+		error = dpm_run_callback(dev, ops->restore);
 		break;
 #endif /* CONFIG_HIBERNATE_CALLBACKS */
 	default:
 		error = -EINVAL;
 	}
 
-	initcall_debug_report(dev, calltime, error);
-
 	return error;
 }
 
@@ -291,70 +287,36 @@ static int pm_noirq_op(struct device *de
 			pm_message_t state)
 {
 	int error = 0;
-	ktime_t calltime = ktime_set(0, 0), delta, rettime;
-
-	if (initcall_debug) {
-		pr_info("calling  %s+ @ %i, parent: %s\n",
-				dev_name(dev), task_pid_nr(current),
-				dev->parent ? dev_name(dev->parent) : "none");
-		calltime = ktime_get();
-	}
 
 	switch (state.event) {
 #ifdef CONFIG_SUSPEND
 	case PM_EVENT_SUSPEND:
-		if (ops->suspend_noirq) {
-			error = ops->suspend_noirq(dev);
-			suspend_report_result(ops->suspend_noirq, error);
-		}
+		error = dpm_run_callback(dev, ops->suspend_noirq);
 		break;
 	case PM_EVENT_RESUME:
-		if (ops->resume_noirq) {
-			error = ops->resume_noirq(dev);
-			suspend_report_result(ops->resume_noirq, error);
-		}
+		error = dpm_run_callback(dev, ops->resume_noirq);
 		break;
 #endif /* CONFIG_SUSPEND */
 #ifdef CONFIG_HIBERNATE_CALLBACKS
 	case PM_EVENT_FREEZE:
 	case PM_EVENT_QUIESCE:
-		if (ops->freeze_noirq) {
-			error = ops->freeze_noirq(dev);
-			suspend_report_result(ops->freeze_noirq, error);
-		}
+		error = dpm_run_callback(dev, ops->freeze_noirq);
 		break;
 	case PM_EVENT_HIBERNATE:
-		if (ops->poweroff_noirq) {
-			error = ops->poweroff_noirq(dev);
-			suspend_report_result(ops->poweroff_noirq, error);
-		}
+		error = dpm_run_callback(dev, ops->poweroff_noirq);
 		break;
 	case PM_EVENT_THAW:
 	case PM_EVENT_RECOVER:
-		if (ops->thaw_noirq) {
-			error = ops->thaw_noirq(dev);
-			suspend_report_result(ops->thaw_noirq, error);
-		}
+		error = dpm_run_callback(dev, ops->thaw_noirq);
 		break;
 	case PM_EVENT_RESTORE:
-		if (ops->restore_noirq) {
-			error = ops->restore_noirq(dev);
-			suspend_report_result(ops->restore_noirq, error);
-		}
+		error = dpm_run_callback(dev, ops->restore_noirq);
 		break;
 #endif /* CONFIG_HIBERNATE_CALLBACKS */
 	default:
 		error = -EINVAL;
 	}
 
-	if (initcall_debug) {
-		rettime = ktime_get();
-		delta = ktime_sub(rettime, calltime);
-		printk("initcall %s_i+ returned %d after %Ld usecs\n",
-			dev_name(dev), error,
-			(unsigned long long)ktime_to_ns(delta) >> 10);
-	}
-
 	return error;
 }
 
@@ -486,26 +448,6 @@ void dpm_resume_noirq(pm_message_t state
 EXPORT_SYMBOL_GPL(dpm_resume_noirq);
 
 /**
- * legacy_resume - Execute a legacy (bus or class) resume callback for device.
- * @dev: Device to resume.
- * @cb: Resume callback to execute.
- */
-static int legacy_resume(struct device *dev, int (*cb)(struct device *dev))
-{
-	int error;
-	ktime_t calltime;
-
-	calltime = initcall_debug_start(dev);
-
-	error = cb(dev);
-	suspend_report_result(cb, error);
-
-	initcall_debug_report(dev, calltime, error);
-
-	return error;
-}
-
-/**
  * device_resume - Execute "resume" callbacks for given device.
  * @dev: Device to handle.
  * @state: PM transition of the system being carried out.
@@ -553,7 +495,7 @@ static int device_resume(struct device *
 			goto End;
 		} else if (dev->class->resume) {
 			pm_dev_dbg(dev, state, "legacy class ");
-			error = legacy_resume(dev, dev->class->resume);
+			error = dpm_run_callback(dev, dev->class->resume);
 			goto End;
 		}
 	}
@@ -564,7 +506,7 @@ static int device_resume(struct device *
 			error = pm_op(dev, dev->bus->pm, state);
 		} else if (dev->bus->resume) {
 			pm_dev_dbg(dev, state, "legacy ");
-			error = legacy_resume(dev, dev->bus->resume);
+			error = dpm_run_callback(dev, dev->bus->resume);
 		}
 	}
 

