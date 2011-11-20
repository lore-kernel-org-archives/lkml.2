Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab1KTAyy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 19:54:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47852 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754307Ab1KTAyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 19:54:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 1/3] PM / Domains: Document how PM domains are used by the PM core
Date: Sun, 20 Nov 2011 01:54:38 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Randy Dunlap <rdunlap@xenotime.net>
References: <201111200153.40224.rjw@sisk.pl>
In-Reply-To: <201111200153.40224.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111200154.38438.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The current power management documentation in Documentation/power/
either doesn't cover PM domains at all, or gives inaccurate
information about them, so update the relevant files in there to
follow the code.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/power/devices.txt    |   42 +++++++++++++++++++++++--------------
 Documentation/power/runtime_pm.txt |   29 +++++++++++++++----------
 2 files changed, 45 insertions(+), 26 deletions(-)

Index: linux/Documentation/power/devices.txt
===================================================================
--- linux.orig/Documentation/power/devices.txt
+++ linux/Documentation/power/devices.txt
@@ -123,9 +123,10 @@ please refer directly to the source code
 Subsystem-Level Methods
 -----------------------
 The core methods to suspend and resume devices reside in struct dev_pm_ops
-pointed to by the pm member of struct bus_type, struct device_type and
-struct class.  They are mostly of interest to the people writing infrastructure
-for buses, like PCI or USB, or device type and device class drivers.
+pointed to by the ops member of struct dev_pm_domain, or by the pm member of
+struct bus_type, struct device_type and struct class.  They are mostly of
+interest to the people writing infrastructure for platforms and buses, like PCI
+or USB, or device type and device class drivers.
 
 Bus drivers implement these methods as appropriate for the hardware and the
 drivers using it; PCI works differently from USB, and so on.  Not many people
@@ -251,18 +252,29 @@ various phases always run after tasks ha
 unfrozen.  Furthermore, the *_noirq phases run at a time when IRQ handlers have
 been disabled (except for those marked with the IRQ_WAKEUP flag).
 
-All phases use bus, type, or class callbacks (that is, methods defined in
-dev->bus->pm, dev->type->pm, or dev->class->pm).  These callbacks are mutually
-exclusive, so if the device type provides a struct dev_pm_ops object pointed to
-by its pm field (i.e. both dev->type and dev->type->pm are defined), the
-callbacks included in that object (i.e. dev->type->pm) will be used.  Otherwise,
-if the class provides a struct dev_pm_ops object pointed to by its pm field
-(i.e. both dev->class and dev->class->pm are defined), the PM core will use the
-callbacks from that object (i.e. dev->class->pm).  Finally, if the pm fields of
-both the device type and class objects are NULL (or those objects do not exist),
-the callbacks provided by the bus (that is, the callbacks from dev->bus->pm)
-will be used (this allows device types to override callbacks provided by bus
-types or classes if necessary).
+All phases use PM domain, bus, type, or class callbacks (that is, methods
+defined in dev->pm_domain->ops, dev->bus->pm, dev->type->pm, or dev->class->pm).
+These callbacks are regarded by the PM core as mutually exclusive.  Moreover,
+PM domain callbacks always take precedence over bus, type and class callbacks,
+while type callbacks take precedence over bus and class callbacks, and class
+callbacks take precedence over bus callbacks.  To be precise, the following
+rules are used to determine which callback to execute in the given phase:
+
+    1.	If dev->pm_domain is present, the PM core will attempt to execute the
+	callback included in dev->pm_domain->ops.  If that callback is not
+	present, no action will be carried out for the given device.
+
+    2.	Otherwise, if both dev->type and dev->type->pm are present, the callback
+	included in dev->type->pm will be executed.
+
+    3.	Otherwise, if both dev->class and dev->class->pm are present, the
+	callback included in dev->class->pm will be executed.
+
+    4.	Otherwise, if both dev->bus and dev->bus->pm are present, the callback
+	included in dev->bus->pm will be executed.
+
+This allows PM domains and device types to override callbacks provided by bus
+types or device classes if necessary.
 
 These callbacks may in turn invoke device- or driver-specific methods stored in
 dev->driver->pm, but they don't have to.
Index: linux/Documentation/power/runtime_pm.txt
===================================================================
--- linux.orig/Documentation/power/runtime_pm.txt
+++ linux/Documentation/power/runtime_pm.txt
@@ -44,17 +44,24 @@ struct dev_pm_ops {
 };
 
 The ->runtime_suspend(), ->runtime_resume() and ->runtime_idle() callbacks
-are executed by the PM core for either the power domain, or the device type
-(if the device power domain's struct dev_pm_ops does not exist), or the class
-(if the device power domain's and type's struct dev_pm_ops object does not
-exist), or the bus type (if the device power domain's, type's and class'
-struct dev_pm_ops objects do not exist) of the given device, so the priority
-order of callbacks from high to low is that power domain callbacks, device
-type callbacks, class callbacks and bus type callbacks, and the high priority
-one will take precedence over low priority one. The bus type, device type and
-class callbacks are referred to as subsystem-level callbacks in what follows,
-and generally speaking, the power domain callbacks are used for representing
-power domains within a SoC.
+are executed by the PM core for the device's subsystem that may be either of
+the following:
+
+  1. PM domain of the device, if the device's PM domain object, dev->pm_domain,
+     is present.
+
+  2. Device type of the device, if both dev->type and dev->type->pm are present.
+
+  3. Device class of the device, if both dev->class and dev->class->pm are
+     present.
+
+  4. Bus type of the device, if both dev->bus and dev->bus->pm are present.
+
+The PM core always checks which callback to use in the order given above, so the
+priority order of callbacks from high to low is: PM domain, device type, class
+and bus type.  Moreover, the high-priority one will always take precedence over
+a low-priority one.  The PM domain, bus type, device type and class callbacks
+are referred to as subsystem-level callbacks in what follows.
 
 By default, the callbacks are always invoked in process context with interrupts
 enabled.  However, subsystems can use the pm_runtime_irq_safe() helper function

