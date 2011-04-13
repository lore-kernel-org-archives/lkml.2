Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706Ab1DMAF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 20:05:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41656 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932282Ab1DMAF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 20:05:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH] PM: Make power domain callbacks take precedence over subsystem ones
Date: Wed, 13 Apr 2011 02:05:26 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Kevin Hilman <khilman@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>,
        linux-sh@vger.kernel.org, lethal@linux-sh.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104130205.26988.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Change the PM core's behavior related to power domains in such a way
that, if a power domain is defined for a given device, its callbacks
will be executed instead of and not in addition to the device
subsystem's PM callbacks.

The idea behind the initial implementation of power domains handling
by the PM core was that power domain callbacks would be executed in
addition to subsystem callbacks, so that it would be possible to
extend the subsystem callbacks by using power domains.  It turns out,
however, that this wouldn't be really convenient in some important
situations.

For example, there are systems in which power can only be removed
from entire power domains.  On those systems it is not desirable to
execute device drivers' PM callbacks until it is known that power is
going to be removed from the devices in question, which means that
they should be executed by power domain callbacks rather then by
subsystem (e.g. bus type) PM callbacks, because subsystems generally
have no information about what devices belong to which power domain.
Thus, for instance, if the bus type in question is the platform bus
type, its PM callbacks generally should not be called in addition to
power domain callbacks, because they run device drivers' callbacks
unconditionally if defined.

While in principle the default subsystem PM callbacks, or a subset of
them, may be replaced with different functions, it doesn't seem
correct to do so, because that would change the subsystem's behavior
with respect to all devices in the system, regardless of whether or
not they belong to any power domains.  Thus, the only remaining
option is to make power domain callbacks take precedence over
subsystem callbacks.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c    |   64 ++++++++++++++++++++-----------------------
 drivers/base/power/runtime.c |   29 ++++++-------------
 2 files changed, 41 insertions(+), 52 deletions(-)

Index: linux-2.6/drivers/base/power/runtime.c
===================================================================
--- linux-2.6.orig/drivers/base/power/runtime.c
+++ linux-2.6/drivers/base/power/runtime.c
@@ -168,7 +168,6 @@ static int rpm_check_suspend_allowed(str
 static int rpm_idle(struct device *dev, int rpmflags)
 {
 	int (*callback)(struct device *);
-	int (*domain_callback)(struct device *);
 	int retval;
 
 	retval = rpm_check_suspend_allowed(dev);
@@ -214,7 +213,9 @@ static int rpm_idle(struct device *dev,
 
 	dev->power.idle_notification = true;
 
-	if (dev->type && dev->type->pm)
+	if (dev->pwr_domain)
+		callback = dev->pwr_domain->ops.runtime_idle;
+	else if (dev->type && dev->type->pm)
 		callback = dev->type->pm->runtime_idle;
 	else if (dev->class && dev->class->pm)
 		callback = dev->class->pm->runtime_idle;
@@ -223,19 +224,10 @@ static int rpm_idle(struct device *dev,
 	else
 		callback = NULL;
 
-	if (dev->pwr_domain)
-		domain_callback = dev->pwr_domain->ops.runtime_idle;
-	else
-		domain_callback = NULL;
-
-	if (callback || domain_callback) {
+	if (callback) {
 		spin_unlock_irq(&dev->power.lock);
 
-		if (domain_callback)
-			retval = domain_callback(dev);
-
-		if (!retval && callback)
-			callback(dev);
+		callback(dev);
 
 		spin_lock_irq(&dev->power.lock);
 	}
@@ -382,7 +374,9 @@ static int rpm_suspend(struct device *de
 
 	__update_runtime_status(dev, RPM_SUSPENDING);
 
-	if (dev->type && dev->type->pm)
+	if (dev->pwr_domain)
+		callback = dev->pwr_domain->ops.runtime_suspend;
+	else if (dev->type && dev->type->pm)
 		callback = dev->type->pm->runtime_suspend;
 	else if (dev->class && dev->class->pm)
 		callback = dev->class->pm->runtime_suspend;
@@ -400,8 +394,6 @@ static int rpm_suspend(struct device *de
 		else
 			pm_runtime_cancel_pending(dev);
 	} else {
-		if (dev->pwr_domain)
-			rpm_callback(dev->pwr_domain->ops.runtime_suspend, dev);
  no_callback:
 		__update_runtime_status(dev, RPM_SUSPENDED);
 		pm_runtime_deactivate_timer(dev);
@@ -582,9 +574,8 @@ static int rpm_resume(struct device *dev
 	__update_runtime_status(dev, RPM_RESUMING);
 
 	if (dev->pwr_domain)
-		rpm_callback(dev->pwr_domain->ops.runtime_resume, dev);
-
-	if (dev->type && dev->type->pm)
+		callback = dev->pwr_domain->ops.runtime_resume;
+	else if (dev->type && dev->type->pm)
 		callback = dev->type->pm->runtime_resume;
 	else if (dev->class && dev->class->pm)
 		callback = dev->class->pm->runtime_resume;
Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -425,10 +425,8 @@ static int device_resume_noirq(struct de
 
 	if (dev->pwr_domain) {
 		pm_dev_dbg(dev, state, "EARLY power domain ");
-		pm_noirq_op(dev, &dev->pwr_domain->ops, state);
-	}
-
-	if (dev->type && dev->type->pm) {
+		error = pm_noirq_op(dev, &dev->pwr_domain->ops, state);
+	} else if (dev->type && dev->type->pm) {
 		pm_dev_dbg(dev, state, "EARLY type ");
 		error = pm_noirq_op(dev, dev->type->pm, state);
 	} else if (dev->class && dev->class->pm) {
@@ -516,7 +514,8 @@ static int device_resume(struct device *
 
 	if (dev->pwr_domain) {
 		pm_dev_dbg(dev, state, "power domain ");
-		pm_op(dev, &dev->pwr_domain->ops, state);
+		error = pm_op(dev, &dev->pwr_domain->ops, state);
+		goto End;
 	}
 
 	if (dev->type && dev->type->pm) {
@@ -628,12 +627,11 @@ static void device_complete(struct devic
 {
 	device_lock(dev);
 
-	if (dev->pwr_domain && dev->pwr_domain->ops.complete) {
+	if (dev->pwr_domain) {
 		pm_dev_dbg(dev, state, "completing power domain ");
-		dev->pwr_domain->ops.complete(dev);
-	}
-
-	if (dev->type && dev->type->pm) {
+		if (dev->pwr_domain->ops.complete)
+			dev->pwr_domain->ops.complete(dev);
+	} else if (dev->type && dev->type->pm) {
 		pm_dev_dbg(dev, state, "completing type ");
 		if (dev->type->pm->complete)
 			dev->type->pm->complete(dev);
@@ -731,7 +729,12 @@ static int device_suspend_noirq(struct d
 {
 	int error;
 
-	if (dev->type && dev->type->pm) {
+	if (dev->pwr_domain) {
+		pm_dev_dbg(dev, state, "LATE power domain ");
+		error = pm_noirq_op(dev, &dev->pwr_domain->ops, state);
+		if (error)
+			return error;
+	} else if (dev->type && dev->type->pm) {
 		pm_dev_dbg(dev, state, "LATE type ");
 		error = pm_noirq_op(dev, dev->type->pm, state);
 		if (error)
@@ -748,11 +751,6 @@ static int device_suspend_noirq(struct d
 			return error;
 	}
 
-	if (dev->pwr_domain) {
-		pm_dev_dbg(dev, state, "LATE power domain ");
-		pm_noirq_op(dev, &dev->pwr_domain->ops, state);
-	}
-
 	return 0;
 }
 
@@ -840,21 +838,27 @@ static int __device_suspend(struct devic
 		goto End;
 	}
 
+	if (dev->pwr_domain) {
+		pm_dev_dbg(dev, state, "power domain ");
+		error = pm_op(dev, &dev->pwr_domain->ops, state);
+		goto End;
+	}
+
 	if (dev->type && dev->type->pm) {
 		pm_dev_dbg(dev, state, "type ");
 		error = pm_op(dev, dev->type->pm, state);
-		goto Domain;
+		goto End;
 	}
 
 	if (dev->class) {
 		if (dev->class->pm) {
 			pm_dev_dbg(dev, state, "class ");
 			error = pm_op(dev, dev->class->pm, state);
-			goto Domain;
+			goto End;
 		} else if (dev->class->suspend) {
 			pm_dev_dbg(dev, state, "legacy class ");
 			error = legacy_suspend(dev, state, dev->class->suspend);
-			goto Domain;
+			goto End;
 		}
 	}
 
@@ -868,12 +872,6 @@ static int __device_suspend(struct devic
 		}
 	}
 
- Domain:
-	if (!error && dev->pwr_domain) {
-		pm_dev_dbg(dev, state, "power domain ");
-		pm_op(dev, &dev->pwr_domain->ops, state);
-	}
-
  End:
 	device_unlock(dev);
 	complete_all(&dev->power.completion);
@@ -964,7 +962,14 @@ static int device_prepare(struct device
 
 	device_lock(dev);
 
-	if (dev->type && dev->type->pm) {
+	if (dev->pwr_domain) {
+		pm_dev_dbg(dev, state, "preparing power domain ");
+		if (dev->pwr_domain->ops.prepare)
+			error = dev->pwr_domain->ops.prepare(dev);
+		suspend_report_result(dev->pwr_domain->ops.prepare, error);
+		if (error)
+			goto End;
+	} else if (dev->type && dev->type->pm) {
 		pm_dev_dbg(dev, state, "preparing type ");
 		if (dev->type->pm->prepare)
 			error = dev->type->pm->prepare(dev);
@@ -983,13 +988,6 @@ static int device_prepare(struct device
 		if (dev->bus->pm->prepare)
 			error = dev->bus->pm->prepare(dev);
 		suspend_report_result(dev->bus->pm->prepare, error);
-		if (error)
-			goto End;
-	}
-
-	if (dev->pwr_domain && dev->pwr_domain->ops.prepare) {
-		pm_dev_dbg(dev, state, "preparing power domain ");
-		dev->pwr_domain->ops.prepare(dev);
 	}
 
  End:
