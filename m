Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab1LIXVG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 18:21:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51375 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698Ab1LIXVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 18:21:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 1/4] PM / Sleep: Make pm_op() and pm_noirq_op() return callback pointers
Date: Sat, 10 Dec 2011 00:20:00 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
References: <201112100018.38536.rjw@sisk.pl>
In-Reply-To: <201112100018.38536.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112100020.00368.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the pm_op() and pm_noirq_op() functions return pointers to
appropriate callbacks instead of executing those callbacks and
returning their results.

This change is required for a subsequent modification that will
execute the corresponding driver callback if the subsystem
callback returned by either pm_op(), or pm_noirq_op() is NULL.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |  195 +++++++++++++++++++++-------------------------
 1 file changed, 93 insertions(+), 102 deletions(-)

Index: linux/drivers/base/power/main.c
===================================================================
--- linux.orig/drivers/base/power/main.c
+++ linux/drivers/base/power/main.c
@@ -211,113 +211,70 @@ static void dpm_wait_for_children(struct
        device_for_each_child(dev, &async, dpm_wait_fn);
 }
 
-static int dpm_run_callback(struct device *dev, int (*cb)(struct device *))
-{
-	ktime_t calltime;
-	int error;
-
-	if (!cb)
-		return 0;
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
 /**
- * pm_op - Execute the PM operation appropriate for given PM event.
- * @dev: Device to handle.
+ * pm_op - Return the PM operation appropriate for given PM event.
  * @ops: PM operations to choose from.
  * @state: PM transition of the system being carried out.
  */
-static int pm_op(struct device *dev,
-		 const struct dev_pm_ops *ops,
-		 pm_message_t state)
+static int (*pm_op(const struct dev_pm_ops *ops, pm_message_t state))(struct device *)
 {
-	int error = 0;
-
 	switch (state.event) {
 #ifdef CONFIG_SUSPEND
 	case PM_EVENT_SUSPEND:
-		error = dpm_run_callback(dev, ops->suspend);
-		break;
+		return ops->suspend;
 	case PM_EVENT_RESUME:
-		error = dpm_run_callback(dev, ops->resume);
-		break;
+		return ops->resume;
 #endif /* CONFIG_SUSPEND */
 #ifdef CONFIG_HIBERNATE_CALLBACKS
 	case PM_EVENT_FREEZE:
 	case PM_EVENT_QUIESCE:
-		error = dpm_run_callback(dev, ops->freeze);
-		break;
+		return ops->freeze;
 	case PM_EVENT_HIBERNATE:
-		error = dpm_run_callback(dev, ops->poweroff);
-		break;
+		return ops->poweroff;
 	case PM_EVENT_THAW:
 	case PM_EVENT_RECOVER:
-		error = dpm_run_callback(dev, ops->thaw);
+		return ops->thaw;
 		break;
 	case PM_EVENT_RESTORE:
-		error = dpm_run_callback(dev, ops->restore);
-		break;
+		return ops->restore;
 #endif /* CONFIG_HIBERNATE_CALLBACKS */
-	default:
-		error = -EINVAL;
 	}
 
-	return error;
+	return NULL;
 }
 
 /**
- * pm_noirq_op - Execute the PM operation appropriate for given PM event.
- * @dev: Device to handle.
+ * pm_noirq_op - Return the PM operation appropriate for given PM event.
  * @ops: PM operations to choose from.
  * @state: PM transition of the system being carried out.
  *
  * The driver of @dev will not receive interrupts while this function is being
  * executed.
  */
-static int pm_noirq_op(struct device *dev,
-			const struct dev_pm_ops *ops,
-			pm_message_t state)
+static int (*pm_noirq_op(const struct dev_pm_ops *ops, pm_message_t state))(struct device *)
 {
-	int error = 0;
-
 	switch (state.event) {
 #ifdef CONFIG_SUSPEND
 	case PM_EVENT_SUSPEND:
-		error = dpm_run_callback(dev, ops->suspend_noirq);
-		break;
+		return ops->suspend_noirq;
 	case PM_EVENT_RESUME:
-		error = dpm_run_callback(dev, ops->resume_noirq);
-		break;
+		return ops->resume_noirq;
 #endif /* CONFIG_SUSPEND */
 #ifdef CONFIG_HIBERNATE_CALLBACKS
 	case PM_EVENT_FREEZE:
 	case PM_EVENT_QUIESCE:
-		error = dpm_run_callback(dev, ops->freeze_noirq);
-		break;
+		return ops->freeze_noirq;
 	case PM_EVENT_HIBERNATE:
-		error = dpm_run_callback(dev, ops->poweroff_noirq);
-		break;
+		return ops->poweroff_noirq;
 	case PM_EVENT_THAW:
 	case PM_EVENT_RECOVER:
-		error = dpm_run_callback(dev, ops->thaw_noirq);
-		break;
+		return ops->thaw_noirq;
 	case PM_EVENT_RESTORE:
-		error = dpm_run_callback(dev, ops->restore_noirq);
-		break;
+		return ops->restore_noirq;
 #endif /* CONFIG_HIBERNATE_CALLBACKS */
-	default:
-		error = -EINVAL;
 	}
 
-	return error;
+	return NULL;
 }
 
 static char *pm_verb(int event)
@@ -375,6 +332,26 @@ static void dpm_show_time(ktime_t startt
 		usecs / USEC_PER_MSEC, usecs % USEC_PER_MSEC);
 }
 
+static int dpm_run_callback(int (*cb)(struct device *), struct device *dev,
+			    pm_message_t state, char *info)
+{
+	ktime_t calltime;
+	int error;
+
+	if (!cb)
+		return 0;
+
+	calltime = initcall_debug_start(dev);
+
+	pm_dev_dbg(dev, state, info);
+	error = cb(dev);
+	suspend_report_result(cb, error);
+
+	initcall_debug_report(dev, calltime, error);
+
+	return error;
+}
+
 /*------------------------- Resume routines -------------------------*/
 
 /**
@@ -387,25 +364,29 @@ static void dpm_show_time(ktime_t startt
  */
 static int device_resume_noirq(struct device *dev, pm_message_t state)
 {
+	int (*callback)(struct device *) = NULL;
+	char *info = NULL;
 	int error = 0;
 
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
 
 	if (dev->pm_domain) {
-		pm_dev_dbg(dev, state, "EARLY power domain ");
-		error = pm_noirq_op(dev, &dev->pm_domain->ops, state);
+		info = "EARLY power domain ";
+		callback = pm_noirq_op(&dev->pm_domain->ops, state);
 	} else if (dev->type && dev->type->pm) {
-		pm_dev_dbg(dev, state, "EARLY type ");
-		error = pm_noirq_op(dev, dev->type->pm, state);
+		info = "EARLY type ";
+		callback = pm_noirq_op(dev->type->pm, state);
 	} else if (dev->class && dev->class->pm) {
-		pm_dev_dbg(dev, state, "EARLY class ");
-		error = pm_noirq_op(dev, dev->class->pm, state);
+		info = "EARLY class ";
+		callback = pm_noirq_op(dev->class->pm, state);
 	} else if (dev->bus && dev->bus->pm) {
-		pm_dev_dbg(dev, state, "EARLY ");
-		error = pm_noirq_op(dev, dev->bus->pm, state);
+		info = "EARLY ";
+		callback = pm_noirq_op(dev->bus->pm, state);
 	}
 
+	error = dpm_run_callback(callback, dev, state, info);
+
 	TRACE_RESUME(error);
 	return error;
 }
@@ -455,6 +436,8 @@ EXPORT_SYMBOL_GPL(dpm_resume_noirq);
  */
 static int device_resume(struct device *dev, pm_message_t state, bool async)
 {
+	int (*callback)(struct device *) = NULL;
+	char *info = NULL;
 	int error = 0;
 	bool put = false;
 
@@ -477,40 +460,41 @@ static int device_resume(struct device *
 	put = true;
 
 	if (dev->pm_domain) {
-		pm_dev_dbg(dev, state, "power domain ");
-		error = pm_op(dev, &dev->pm_domain->ops, state);
+		info = "power domain ";
+		callback = pm_op(&dev->pm_domain->ops, state);
 		goto End;
 	}
 
 	if (dev->type && dev->type->pm) {
-		pm_dev_dbg(dev, state, "type ");
-		error = pm_op(dev, dev->type->pm, state);
+		info = "type ";
+		callback = pm_op(dev->type->pm, state);
 		goto End;
 	}
 
 	if (dev->class) {
 		if (dev->class->pm) {
-			pm_dev_dbg(dev, state, "class ");
-			error = pm_op(dev, dev->class->pm, state);
+			info = "class ";
+			callback = pm_op(dev->class->pm, state);
 			goto End;
 		} else if (dev->class->resume) {
-			pm_dev_dbg(dev, state, "legacy class ");
-			error = dpm_run_callback(dev, dev->class->resume);
+			info = "legacy class ";
+			callback = dev->class->resume;
 			goto End;
 		}
 	}
 
 	if (dev->bus) {
 		if (dev->bus->pm) {
-			pm_dev_dbg(dev, state, "");
-			error = pm_op(dev, dev->bus->pm, state);
+			info = "";
+			callback = pm_op(dev->bus->pm, state);
 		} else if (dev->bus->resume) {
-			pm_dev_dbg(dev, state, "legacy ");
-			error = dpm_run_callback(dev, dev->bus->resume);
+			info = "legacy ";
+			callback = dev->bus->resume;
 		}
 	}
 
  End:
+	error = dpm_run_callback(callback, dev, state, info);
 	dev->power.is_suspended = false;
 
  Unlock:
@@ -705,23 +689,24 @@ static pm_message_t resume_event(pm_mess
  */
 static int device_suspend_noirq(struct device *dev, pm_message_t state)
 {
-	int error = 0;
+	int (*callback)(struct device *) = NULL;
+	char *info = NULL;
 
 	if (dev->pm_domain) {
-		pm_dev_dbg(dev, state, "LATE power domain ");
-		error = pm_noirq_op(dev, &dev->pm_domain->ops, state);
+		info = "LATE power domain ";
+		callback = pm_noirq_op(&dev->pm_domain->ops, state);
 	} else if (dev->type && dev->type->pm) {
-		pm_dev_dbg(dev, state, "LATE type ");
-		error = pm_noirq_op(dev, dev->type->pm, state);
+		info = "LATE type ";
+		callback = pm_noirq_op(dev->type->pm, state);
 	} else if (dev->class && dev->class->pm) {
-		pm_dev_dbg(dev, state, "LATE class ");
-		error = pm_noirq_op(dev, dev->class->pm, state);
+		info = "LATE class ";
+		callback = pm_noirq_op(dev->class->pm, state);
 	} else if (dev->bus && dev->bus->pm) {
-		pm_dev_dbg(dev, state, "LATE ");
-		error = pm_noirq_op(dev, dev->bus->pm, state);
+		info = "LATE ";
+		callback = pm_noirq_op(dev->bus->pm, state);
 	}
 
-	return error;
+	return dpm_run_callback(callback, dev, state, info);
 }
 
 /**
@@ -798,6 +783,8 @@ static int legacy_suspend(struct device
  */
 static int __device_suspend(struct device *dev, pm_message_t state, bool async)
 {
+	int (*callback)(struct device *) = NULL;
+	char *info = NULL;
 	int error = 0;
 
 	dpm_wait_for_children(dev, async);
@@ -818,22 +805,22 @@ static int __device_suspend(struct devic
 	device_lock(dev);
 
 	if (dev->pm_domain) {
-		pm_dev_dbg(dev, state, "power domain ");
-		error = pm_op(dev, &dev->pm_domain->ops, state);
-		goto End;
+		info = "power domain ";
+		callback = pm_op(&dev->pm_domain->ops, state);
+		goto Run;
 	}
 
 	if (dev->type && dev->type->pm) {
-		pm_dev_dbg(dev, state, "type ");
-		error = pm_op(dev, dev->type->pm, state);
-		goto End;
+		info = "type ";
+		callback = pm_op(dev->type->pm, state);
+		goto Run;
 	}
 
 	if (dev->class) {
 		if (dev->class->pm) {
-			pm_dev_dbg(dev, state, "class ");
-			error = pm_op(dev, dev->class->pm, state);
-			goto End;
+			info = "class ";
+			callback = pm_op(dev->class->pm, state);
+			goto Run;
 		} else if (dev->class->suspend) {
 			pm_dev_dbg(dev, state, "legacy class ");
 			error = legacy_suspend(dev, state, dev->class->suspend);
@@ -843,14 +830,18 @@ static int __device_suspend(struct devic
 
 	if (dev->bus) {
 		if (dev->bus->pm) {
-			pm_dev_dbg(dev, state, "");
-			error = pm_op(dev, dev->bus->pm, state);
+			info = "";
+			callback = pm_op(dev->bus->pm, state);
 		} else if (dev->bus->suspend) {
 			pm_dev_dbg(dev, state, "legacy ");
 			error = legacy_suspend(dev, state, dev->bus->suspend);
+			goto End;
 		}
 	}
 
+ Run:
+	error = dpm_run_callback(callback, dev, state, info);
+
  End:
 	if (!error) {
 		dev->power.is_suspended = true;

