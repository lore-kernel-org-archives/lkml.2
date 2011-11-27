Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab1K0W5H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 17:57:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58987 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509Ab1K0W5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 17:57:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 2/2] PM / Sleep: Drop pm_op() and pm_noirq_op()
Date: Sun, 27 Nov 2011 23:59:36 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, "Greg Kroah-Hartman" <gregkh@suse.de>
References: <201111272357.26930.rjw@sisk.pl>
In-Reply-To: <201111272357.26930.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111272359.36511.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The helper functions pm_op() and pm_noirq_op() are not really
necessary and they don't do anything useful, so drop them.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |  123 +++++-----------------------------------------
 1 file changed, 16 insertions(+), 107 deletions(-)

Index: linux/drivers/base/power/main.c
===================================================================
--- linux.orig/drivers/base/power/main.c
+++ linux/drivers/base/power/main.c
@@ -229,97 +229,6 @@ static int dpm_run_callback(struct devic
 	return error;
 }
 
-/**
- * pm_op - Execute the PM operation appropriate for given PM event.
- * @dev: Device to handle.
- * @ops: PM operations to choose from.
- * @state: PM transition of the system being carried out.
- */
-static int pm_op(struct device *dev,
-		 const struct dev_pm_ops *ops,
-		 pm_message_t state)
-{
-	int error = 0;
-
-	switch (state.event) {
-#ifdef CONFIG_SUSPEND
-	case PM_EVENT_SUSPEND:
-		error = dpm_run_callback(dev, ops->suspend);
-		break;
-	case PM_EVENT_RESUME:
-		error = dpm_run_callback(dev, ops->resume);
-		break;
-#endif /* CONFIG_SUSPEND */
-#ifdef CONFIG_HIBERNATE_CALLBACKS
-	case PM_EVENT_FREEZE:
-	case PM_EVENT_QUIESCE:
-		error = dpm_run_callback(dev, ops->freeze);
-		break;
-	case PM_EVENT_HIBERNATE:
-		error = dpm_run_callback(dev, ops->poweroff);
-		break;
-	case PM_EVENT_THAW:
-	case PM_EVENT_RECOVER:
-		error = dpm_run_callback(dev, ops->thaw);
-		break;
-	case PM_EVENT_RESTORE:
-		error = dpm_run_callback(dev, ops->restore);
-		break;
-#endif /* CONFIG_HIBERNATE_CALLBACKS */
-	default:
-		error = -EINVAL;
-	}
-
-	return error;
-}
-
-/**
- * pm_noirq_op - Execute the PM operation appropriate for given PM event.
- * @dev: Device to handle.
- * @ops: PM operations to choose from.
- * @state: PM transition of the system being carried out.
- *
- * The driver of @dev will not receive interrupts while this function is being
- * executed.
- */
-static int pm_noirq_op(struct device *dev,
-			const struct dev_pm_ops *ops,
-			pm_message_t state)
-{
-	int error = 0;
-
-	switch (state.event) {
-#ifdef CONFIG_SUSPEND
-	case PM_EVENT_SUSPEND:
-		error = dpm_run_callback(dev, ops->suspend_noirq);
-		break;
-	case PM_EVENT_RESUME:
-		error = dpm_run_callback(dev, ops->resume_noirq);
-		break;
-#endif /* CONFIG_SUSPEND */
-#ifdef CONFIG_HIBERNATE_CALLBACKS
-	case PM_EVENT_FREEZE:
-	case PM_EVENT_QUIESCE:
-		error = dpm_run_callback(dev, ops->freeze_noirq);
-		break;
-	case PM_EVENT_HIBERNATE:
-		error = dpm_run_callback(dev, ops->poweroff_noirq);
-		break;
-	case PM_EVENT_THAW:
-	case PM_EVENT_RECOVER:
-		error = dpm_run_callback(dev, ops->thaw_noirq);
-		break;
-	case PM_EVENT_RESTORE:
-		error = dpm_run_callback(dev, ops->restore_noirq);
-		break;
-#endif /* CONFIG_HIBERNATE_CALLBACKS */
-	default:
-		error = -EINVAL;
-	}
-
-	return error;
-}
-
 static char *pm_verb(int event)
 {
 	switch (event) {
@@ -394,16 +303,16 @@ static int device_resume_noirq(struct de
 
 	if (dev->pm_domain) {
 		pm_dev_dbg(dev, state, "EARLY power domain ");
-		error = pm_noirq_op(dev, &dev->pm_domain->ops, state);
+		error = dpm_run_callback(dev, dev->pm_domain->ops.resume_noirq);
 	} else if (dev->type && dev->type->pm) {
 		pm_dev_dbg(dev, state, "EARLY type ");
-		error = pm_noirq_op(dev, dev->type->pm, state);
+		error = dpm_run_callback(dev, dev->type->pm->resume_noirq);
 	} else if (dev->class && dev->class->pm) {
 		pm_dev_dbg(dev, state, "EARLY class ");
-		error = pm_noirq_op(dev, dev->class->pm, state);
+		error = dpm_run_callback(dev, dev->class->pm->resume_noirq);
 	} else if (dev->bus && dev->bus->pm) {
 		pm_dev_dbg(dev, state, "EARLY ");
-		error = pm_noirq_op(dev, dev->bus->pm, state);
+		error = dpm_run_callback(dev, dev->bus->pm->resume_noirq);
 	}
 
 	TRACE_RESUME(error);
@@ -478,20 +387,20 @@ static int device_resume(struct device *
 
 	if (dev->pm_domain) {
 		pm_dev_dbg(dev, state, "power domain ");
-		error = pm_op(dev, &dev->pm_domain->ops, state);
+		error = dpm_run_callback(dev, dev->pm_domain->ops.resume);
 		goto End;
 	}
 
 	if (dev->type && dev->type->pm) {
 		pm_dev_dbg(dev, state, "type ");
-		error = pm_op(dev, dev->type->pm, state);
+		error = dpm_run_callback(dev, dev->type->pm->resume);
 		goto End;
 	}
 
 	if (dev->class) {
 		if (dev->class->pm) {
 			pm_dev_dbg(dev, state, "class ");
-			error = pm_op(dev, dev->class->pm, state);
+			error = dpm_run_callback(dev, dev->class->pm->resume);
 			goto End;
 		} else if (dev->class->resume) {
 			pm_dev_dbg(dev, state, "legacy class ");
@@ -503,7 +412,7 @@ static int device_resume(struct device *
 	if (dev->bus) {
 		if (dev->bus->pm) {
 			pm_dev_dbg(dev, state, "");
-			error = pm_op(dev, dev->bus->pm, state);
+			error = dpm_run_callback(dev, dev->bus->pm->resume);
 		} else if (dev->bus->resume) {
 			pm_dev_dbg(dev, state, "legacy ");
 			error = dpm_run_callback(dev, dev->bus->resume);
@@ -709,16 +618,16 @@ static int device_suspend_noirq(struct d
 
 	if (dev->pm_domain) {
 		pm_dev_dbg(dev, state, "LATE power domain ");
-		error = pm_noirq_op(dev, &dev->pm_domain->ops, state);
+		error = dpm_run_callback(dev, dev->pm_domain->ops.suspend_noirq);
 	} else if (dev->type && dev->type->pm) {
 		pm_dev_dbg(dev, state, "LATE type ");
-		error = pm_noirq_op(dev, dev->type->pm, state);
+		error = dpm_run_callback(dev, dev->type->pm->suspend_noirq);
 	} else if (dev->class && dev->class->pm) {
 		pm_dev_dbg(dev, state, "LATE class ");
-		error = pm_noirq_op(dev, dev->class->pm, state);
+		error = dpm_run_callback(dev, dev->class->pm->suspend_noirq);
 	} else if (dev->bus && dev->bus->pm) {
 		pm_dev_dbg(dev, state, "LATE ");
-		error = pm_noirq_op(dev, dev->bus->pm, state);
+		error = dpm_run_callback(dev, dev->bus->pm->suspend_noirq);
 	}
 
 	return error;
@@ -819,20 +728,20 @@ static int __device_suspend(struct devic
 
 	if (dev->pm_domain) {
 		pm_dev_dbg(dev, state, "power domain ");
-		error = pm_op(dev, &dev->pm_domain->ops, state);
+		error = dpm_run_callback(dev, dev->pm_domain->ops.suspend);
 		goto End;
 	}
 
 	if (dev->type && dev->type->pm) {
 		pm_dev_dbg(dev, state, "type ");
-		error = pm_op(dev, dev->type->pm, state);
+		error = dpm_run_callback(dev, dev->type->pm->suspend);
 		goto End;
 	}
 
 	if (dev->class) {
 		if (dev->class->pm) {
 			pm_dev_dbg(dev, state, "class ");
-			error = pm_op(dev, dev->class->pm, state);
+			error = dpm_run_callback(dev, dev->class->pm->suspend);
 			goto End;
 		} else if (dev->class->suspend) {
 			pm_dev_dbg(dev, state, "legacy class ");
@@ -844,7 +753,7 @@ static int __device_suspend(struct devic
 	if (dev->bus) {
 		if (dev->bus->pm) {
 			pm_dev_dbg(dev, state, "");
-			error = pm_op(dev, dev->bus->pm, state);
+			error = dpm_run_callback(dev, dev->bus->pm->suspend);
 		} else if (dev->bus->suspend) {
 			pm_dev_dbg(dev, state, "legacy ");
 			error = legacy_suspend(dev, state, dev->bus->suspend);

