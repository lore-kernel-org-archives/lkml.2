Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab1BQX5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 18:57:53 -0500
Received: from mail.fuw.edu.pl ([193.0.80.14]:51239 "EHLO mail.fuw.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754254Ab1BQX5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 18:57:51 -0500
From: "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>
To: Greg KH <greg@kroah.com>
Subject: [PATCH] PM: Make system-wide PM and runtime PM treat subsystems consistently
Date: Fri, 18 Feb 2011 00:54:25 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc5+; KDE/4.4.4; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Kevin Hilman <khilman@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Len Brown <lenb@kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <201102170045.48975.rjw@sisk.pl> <Pine.LNX.4.44L0.1102170951330.2153-100000@iolanthe.rowland.org> <20110217170441.GA31809@kroah.com>
In-Reply-To: <20110217170441.GA31809@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102180054.25603.rwys@fuw.edu.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The code handling system-wide power transitions (eg. suspend-to-RAM)
can in theory execute callbacks provided by the device's bus type,
device type and class in each phase of the power transition.  In
turn, the runtime PM core code only calls one of those callbacks at
a time, preferring bus type callbacks to device type or class
callbacks and device type callbacks to class callbacks.

It seems reasonable to make them both behave in the same way in that
respect.  Moreover, even though a device may belong to two subsystems
(eg. bus type and device class) simultaneously, in practice power
management callbacks for system-wide power transitions are always
provided by only one of them (ie. if the bus type callbacks are
defined, the device class ones are not and vice versa).  Thus it is
possible to modify the code handling system-wide power transitions
so that it follows the core runtime PM code (ie. treats the
subsystem callbacks as mutually exclusive).

On the other hand, the core runtime PM code will choose to execute,
for example, a runtime suspend callback provided by the device type
even if the bus type's struct dev_pm_ops object exists, but the
runtime_suspend pointer in it happens to be NULL.  This is confusing,
because it may lead to the execution of callbacks from different
subsystems during different operations (eg. the bus type suspend
callback may be executed during runtime suspend of the device, while
the device type callback will be executed during system suspend).

Make all of the power management code treat subsystem callbacks in
a consistent way, such that:
(1) If the device's type is defined (eg. dev->type is not NULL)
    and its pm pointer is not NULL, the callbacks from dev->type->pm
    will be used.
(2) If dev->type is NULL or dev->type->pm is NULL, but the device's
    class is defined (eg. dev->class is not NULL) and its pm pointer
    is not NULL, the callbacks from dev->class->pm will be used.
(3) If dev->type is NULL or dev->type->pm is NULL and dev->class is
    NULL or dev->class->pm is NULL, the callbacks from dev->bus->pm
    will be used provided that both dev->bus and dev->bus->pm are
    not NULL.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Kevin Hilman <khilman@ti.com>
Reasoning-sounds-sane-to: Grant Likely <grant.likely@secretlab.ca>
---

Hi,

This patch is on top of suspend-2.6/linux-next.

I changed the ordering of callbacks following your advice, hopefully the
ACKs above still apply.

Thanks,
Rafael

---
Documentation/power/devices.txt |   28 +++----
 Documentation/power/devices.txt    |   29 ++-----
 Documentation/power/runtime_pm.txt |   13 +--
 drivers/base/power/main.c          |  150 +++++++++++++++----------------------
 drivers/base/power/runtime.c       |   18 ++--
 4 files changed, 92 insertions(+), 118 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -428,26 +428,17 @@ static int device_resume_noirq(struct de
 		pm_noirq_op(dev, &dev->pwr_domain->ops, state);
 	}
 
-	if (dev->bus && dev->bus->pm) {
-		pm_dev_dbg(dev, state, "EARLY ");
-		error = pm_noirq_op(dev, dev->bus->pm, state);
-		if (error)
-			goto End;
-	}
-
 	if (dev->type && dev->type->pm) {
 		pm_dev_dbg(dev, state, "EARLY type ");
 		error = pm_noirq_op(dev, dev->type->pm, state);
-		if (error)
-			goto End;
-	}
-
-	if (dev->class && dev->class->pm) {
+	} else if (dev->class && dev->class->pm) {
 		pm_dev_dbg(dev, state, "EARLY class ");
 		error = pm_noirq_op(dev, dev->class->pm, state);
+	} else if (dev->bus && dev->bus->pm) {
+		pm_dev_dbg(dev, state, "EARLY ");
+		error = pm_noirq_op(dev, dev->bus->pm, state);
 	}
 
-End:
 	TRACE_RESUME(error);
 	return error;
 }
@@ -528,36 +519,34 @@ static int device_resume(struct device *
 		pm_op(dev, &dev->pwr_domain->ops, state);
 	}
 
-	if (dev->bus) {
-		if (dev->bus->pm) {
-			pm_dev_dbg(dev, state, "");
-			error = pm_op(dev, dev->bus->pm, state);
-		} else if (dev->bus->resume) {
-			pm_dev_dbg(dev, state, "legacy ");
-			error = legacy_resume(dev, dev->bus->resume);
-		}
-		if (error)
-			goto End;
-	}
-
-	if (dev->type) {
-		if (dev->type->pm) {
-			pm_dev_dbg(dev, state, "type ");
-			error = pm_op(dev, dev->type->pm, state);
-		}
-		if (error)
-			goto End;
+	if (dev->type && dev->type->pm) {
+		pm_dev_dbg(dev, state, "type ");
+		error = pm_op(dev, dev->type->pm, state);
+		goto End;
 	}
 
 	if (dev->class) {
 		if (dev->class->pm) {
 			pm_dev_dbg(dev, state, "class ");
 			error = pm_op(dev, dev->class->pm, state);
+			goto End;
 		} else if (dev->class->resume) {
 			pm_dev_dbg(dev, state, "legacy class ");
 			error = legacy_resume(dev, dev->class->resume);
+			goto End;
 		}
 	}
+
+	if (dev->bus) {
+		if (dev->bus->pm) {
+			pm_dev_dbg(dev, state, "");
+			error = pm_op(dev, dev->bus->pm, state);
+		} else if (dev->bus->resume) {
+			pm_dev_dbg(dev, state, "legacy ");
+			error = legacy_resume(dev, dev->bus->resume);
+		}
+	}
+
  End:
 	device_unlock(dev);
 	complete_all(&dev->power.completion);
@@ -644,19 +633,18 @@ static void device_complete(struct devic
 		dev->pwr_domain->ops.complete(dev);
 	}
 
-	if (dev->class && dev->class->pm && dev->class->pm->complete) {
-		pm_dev_dbg(dev, state, "completing class ");
-		dev->class->pm->complete(dev);
-	}
-
-	if (dev->type && dev->type->pm && dev->type->pm->complete) {
+	if (dev->type && dev->type->pm) {
 		pm_dev_dbg(dev, state, "completing type ");
-		dev->type->pm->complete(dev);
-	}
-
-	if (dev->bus && dev->bus->pm && dev->bus->pm->complete) {
+		if (dev->type->pm->complete)
+			dev->type->pm->complete(dev);
+	} else if (dev->class && dev->class->pm) {
+		pm_dev_dbg(dev, state, "completing class ");
+		if (dev->class->pm->complete)
+			dev->class->pm->complete(dev);
+	} else if (dev->bus && dev->bus->pm) {
 		pm_dev_dbg(dev, state, "completing ");
-		dev->bus->pm->complete(dev);
+		if (dev->bus->pm->complete)
+			dev->bus->pm->complete(dev);
 	}
 
 	device_unlock(dev);
@@ -741,27 +729,23 @@ static pm_message_t resume_event(pm_mess
  */
 static int device_suspend_noirq(struct device *dev, pm_message_t state)
 {
-	int error = 0;
-
-	if (dev->class && dev->class->pm) {
-		pm_dev_dbg(dev, state, "LATE class ");
-		error = pm_noirq_op(dev, dev->class->pm, state);
-		if (error)
-			goto End;
-	}
+	int error;
 
 	if (dev->type && dev->type->pm) {
 		pm_dev_dbg(dev, state, "LATE type ");
 		error = pm_noirq_op(dev, dev->type->pm, state);
 		if (error)
-			goto End;
-	}
-
-	if (dev->bus && dev->bus->pm) {
+			return error;
+	} else if (dev->class && dev->class->pm) {
+		pm_dev_dbg(dev, state, "LATE class ");
+		error = pm_noirq_op(dev, dev->class->pm, state);
+		if (error)
+			return error;
+	} else if (dev->bus && dev->bus->pm) {
 		pm_dev_dbg(dev, state, "LATE ");
 		error = pm_noirq_op(dev, dev->bus->pm, state);
 		if (error)
-			goto End;
+			return error;
 	}
 
 	if (dev->pwr_domain) {
@@ -769,8 +753,7 @@ static int device_suspend_noirq(struct d
 		pm_noirq_op(dev, &dev->pwr_domain->ops, state);
 	}
 
-End:
-	return error;
+	return 0;
 }
 
 /**
@@ -857,25 +840,22 @@ static int __device_suspend(struct devic
 		goto End;
 	}
 
+	if (dev->type && dev->type->pm) {
+		pm_dev_dbg(dev, state, "type ");
+		error = pm_op(dev, dev->type->pm, state);
+		goto Domain;
+	}
+
 	if (dev->class) {
 		if (dev->class->pm) {
 			pm_dev_dbg(dev, state, "class ");
 			error = pm_op(dev, dev->class->pm, state);
+			goto Domain;
 		} else if (dev->class->suspend) {
 			pm_dev_dbg(dev, state, "legacy class ");
 			error = legacy_suspend(dev, state, dev->class->suspend);
+			goto Domain;
 		}
-		if (error)
-			goto End;
-	}
-
-	if (dev->type) {
-		if (dev->type->pm) {
-			pm_dev_dbg(dev, state, "type ");
-			error = pm_op(dev, dev->type->pm, state);
-		}
-		if (error)
-			goto End;
 	}
 
 	if (dev->bus) {
@@ -886,11 +866,10 @@ static int __device_suspend(struct devic
 			pm_dev_dbg(dev, state, "legacy ");
 			error = legacy_suspend(dev, state, dev->bus->suspend);
 		}
-		if (error)
-			goto End;
 	}
 
-	if (dev->pwr_domain) {
+ Domain:
+	if (!error && dev->pwr_domain) {
 		pm_dev_dbg(dev, state, "power domain ");
 		pm_op(dev, &dev->pwr_domain->ops, state);
 	}
@@ -985,28 +964,27 @@ static int device_prepare(struct device
 
 	device_lock(dev);
 
-	if (dev->bus && dev->bus->pm && dev->bus->pm->prepare) {
-		pm_dev_dbg(dev, state, "preparing ");
-		error = dev->bus->pm->prepare(dev);
-		suspend_report_result(dev->bus->pm->prepare, error);
-		if (error)
-			goto End;
-	}
-
-	if (dev->type && dev->type->pm && dev->type->pm->prepare) {
+	if (dev->type && dev->type->pm) {
 		pm_dev_dbg(dev, state, "preparing type ");
-		error = dev->type->pm->prepare(dev);
+		if (dev->type->pm->prepare)
+			error = dev->type->pm->prepare(dev);
 		suspend_report_result(dev->type->pm->prepare, error);
 		if (error)
 			goto End;
-	}
-
-	if (dev->class && dev->class->pm && dev->class->pm->prepare) {
+	} else if (dev->class && dev->class->pm) {
 		pm_dev_dbg(dev, state, "preparing class ");
-		error = dev->class->pm->prepare(dev);
+		if (dev->class->pm->prepare)
+			error = dev->class->pm->prepare(dev);
 		suspend_report_result(dev->class->pm->prepare, error);
 		if (error)
 			goto End;
+	} else if (dev->bus && dev->bus->pm) {
+		pm_dev_dbg(dev, state, "preparing ");
+		if (dev->bus->pm->prepare)
+			error = dev->bus->pm->prepare(dev);
+		suspend_report_result(dev->bus->pm->prepare, error);
+		if (error)
+			goto End;
 	}
 
 	if (dev->pwr_domain && dev->pwr_domain->ops.prepare) {
Index: linux-2.6/drivers/base/power/runtime.c
===================================================================
--- linux-2.6.orig/drivers/base/power/runtime.c
+++ linux-2.6/drivers/base/power/runtime.c
@@ -214,12 +214,12 @@ static int rpm_idle(struct device *dev,
 
 	dev->power.idle_notification = true;
 
-	if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_idle)
-		callback = dev->bus->pm->runtime_idle;
-	else if (dev->type && dev->type->pm && dev->type->pm->runtime_idle)
+	if (dev->type && dev->type->pm)
 		callback = dev->type->pm->runtime_idle;
 	else if (dev->class && dev->class->pm)
 		callback = dev->class->pm->runtime_idle;
+	else if (dev->bus && dev->bus->pm)
+		callback = dev->bus->pm->runtime_idle;
 	else
 		callback = NULL;
 
@@ -382,12 +382,12 @@ static int rpm_suspend(struct device *de
 
 	__update_runtime_status(dev, RPM_SUSPENDING);
 
-	if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_suspend)
-		callback = dev->bus->pm->runtime_suspend;
-	else if (dev->type && dev->type->pm && dev->type->pm->runtime_suspend)
+	if (dev->type && dev->type->pm)
 		callback = dev->type->pm->runtime_suspend;
 	else if (dev->class && dev->class->pm)
 		callback = dev->class->pm->runtime_suspend;
+	else if (dev->bus && dev->bus->pm)
+		callback = dev->bus->pm->runtime_suspend;
 	else
 		callback = NULL;
 
@@ -584,12 +584,12 @@ static int rpm_resume(struct device *dev
 	if (dev->pwr_domain)
 		rpm_callback(dev->pwr_domain->ops.runtime_resume, dev);
 
-	if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_resume)
-		callback = dev->bus->pm->runtime_resume;
-	else if (dev->type && dev->type->pm && dev->type->pm->runtime_resume)
+	if (dev->type && dev->type->pm)
 		callback = dev->type->pm->runtime_resume;
 	else if (dev->class && dev->class->pm)
 		callback = dev->class->pm->runtime_resume;
+	else if (dev->bus && dev->bus->pm)
+		callback = dev->bus->pm->runtime_resume;
 	else
 		callback = NULL;
 
Index: linux-2.6/Documentation/power/devices.txt
===================================================================
--- linux-2.6.orig/Documentation/power/devices.txt
+++ linux-2.6/Documentation/power/devices.txt
@@ -249,23 +249,18 @@ various phases always run after tasks ha
 unfrozen.  Furthermore, the *_noirq phases run at a time when IRQ handlers have
 been disabled (except for those marked with the IRQ_WAKEUP flag).
 
-Most phases use bus, type, and class callbacks (that is, methods defined in
-dev->bus->pm, dev->type->pm, and dev->class->pm).  The prepare and complete
-phases are exceptions; they use only bus callbacks.  When multiple callbacks
-are used in a phase, they are invoked in the order: <class, type, bus> during
-power-down transitions and in the opposite order during power-up transitions.
-For example, during the suspend phase the PM core invokes
-
-	dev->class->pm.suspend(dev);
-	dev->type->pm.suspend(dev);
-	dev->bus->pm.suspend(dev);
-
-before moving on to the next device, whereas during the resume phase the core
-invokes
-
-	dev->bus->pm.resume(dev);
-	dev->type->pm.resume(dev);
-	dev->class->pm.resume(dev);
+All phases use bus, type, or class callbacks (that is, methods defined in
+dev->bus->pm, dev->type->pm, or dev->class->pm).  These callbacks are mutually
+exclusive, so if the device type provides a struct dev_pm_ops object pointed to
+by its pm field (i.e. both dev->type and dev->type->pm are defined), the
+callbacks included in that object (i.e. dev->type->pm) will be used.  Otherwise,
+if the class provides a struct dev_pm_ops object pointed to by its pm field
+(i.e. both dev->class and dev->class->pm are defined), the PM core will use the
+callbacks from that object (i.e. dev->class->pm).  Finally, if the pm fields of
+both the device type and class objects are NULL (or those objects do not exist),
+the callbacks provided by the bus (that is, the callbacks from dev->bus->pm)
+will be used (this allows device types to override callbacks provided by bus
+types or classes if necessary).
 
 These callbacks may in turn invoke device- or driver-specific methods stored in
 dev->driver->pm, but they don't have to.
Index: linux-2.6/Documentation/power/runtime_pm.txt
===================================================================
--- linux-2.6.orig/Documentation/power/runtime_pm.txt
+++ linux-2.6/Documentation/power/runtime_pm.txt
@@ -1,6 +1,6 @@
 Run-time Power Management Framework for I/O Devices
 
-(C) 2009 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
+(C) 2009-2011 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
 (C) 2010 Alan Stern <stern@rowland.harvard.edu>
 
 1. Introduction
@@ -44,11 +44,12 @@ struct dev_pm_ops {
 };
 
 The ->runtime_suspend(), ->runtime_resume() and ->runtime_idle() callbacks are
-executed by the PM core for either the bus type, or device type (if the bus
-type's callback is not defined), or device class (if the bus type's and device
-type's callbacks are not defined) of given device.  The bus type, device type
-and device class callbacks are referred to as subsystem-level callbacks in what
-follows.
+executed by the PM core for either the device type, or the class (if the device
+type's struct dev_pm_ops object does not exist), or the bus type (if the
+device type's and class' struct dev_pm_ops objects do not exist) of the given
+device (this allows device types to override callbacks provided by bus types or
+classes if necessary).  The bus type, device type and class callbacks are
+referred to as subsystem-level callbacks in what follows.
 
 By default, the callbacks are always invoked in process context with interrupts
 enabled.  However, subsystems can use the pm_runtime_irq_safe() helper function

