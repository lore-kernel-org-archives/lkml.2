Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab2J2JKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 05:10:39 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:42678 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932258Ab2J2JKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 05:10:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, Huang Ying <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 1/7] ACPI / PM: Move routines for adding/removing device wakeup notifiers
Date: Mon, 29 Oct 2012 10:07:59 +0100
Message-ID: <3642172.cSPaZlCJxd@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1766582.8gdQKXoi0K@vostro.rjw.lan>
References: <1766582.8gdQKXoi0K@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

ACPI routines for adding and removing device wakeup notifiers are
currently defined in a PCI-specific file, but they will be necessary
for non-PCI devices too, so move them to a separate file under
drivers/acpi and rename them to indicate their ACPI origins.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/Makefile    |    3 +
 drivers/acpi/device_pm.c |   91 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/pci-acpi.c   |   71 ++----------------------------------
 include/acpi/acpi_bus.h  |   15 +++++++
 4 files changed, 112 insertions(+), 68 deletions(-)

Index: linux/drivers/acpi/device_pm.c
===================================================================
--- /dev/null
+++ linux/drivers/acpi/device_pm.c
@@ -0,0 +1,91 @@
+/*
+ * drivers/acpi/device_pm.c - ACPI device power management routines.
+ *
+ * Copyright (C) 2012, Intel Corp.
+ * Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as published
+ *  by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+
+#include <linux/device.h>
+#include <linux/mutex.h>
+
+#include <acpi/acpi.h>
+#include <acpi/acpi_bus.h>
+
+static DEFINE_MUTEX(acpi_pm_notifier_lock);
+
+/**
+ * acpi_add_pm_notifier - Register PM notifier for given ACPI device.
+ * @adev: ACPI device to add the notifier for.
+ * @context: Context information to pass to the notifier routine.
+ *
+ * NOTE: @adev need not be a run-wake or wakeup device to be a valid source of
+ * PM wakeup events.  For example, wakeup events may be generated for bridges
+ * if one of the devices below the bridge is signaling wakeup, even if the
+ * bridge itself doesn't have a wakeup GPE associated with it.
+ */
+acpi_status acpi_add_pm_notifier(struct acpi_device *adev,
+				 acpi_notify_handler handler, void *context)
+{
+	acpi_status status = AE_ALREADY_EXISTS;
+
+	mutex_lock(&acpi_pm_notifier_lock);
+
+	if (adev->wakeup.flags.notifier_present)
+		goto out;
+
+	status = acpi_install_notify_handler(adev->handle,
+					     ACPI_SYSTEM_NOTIFY,
+					     handler, context);
+	if (ACPI_FAILURE(status))
+		goto out;
+
+	adev->wakeup.flags.notifier_present = true;
+
+ out:
+	mutex_unlock(&acpi_pm_notifier_lock);
+	return status;
+}
+
+/**
+ * acpi_remove_pm_notifier - Unregister PM notifier from given ACPI device.
+ * @adev: ACPI device to remove the notifier from.
+ */
+acpi_status acpi_remove_pm_notifier(struct acpi_device *adev,
+				    acpi_notify_handler handler)
+{
+	acpi_status status = AE_BAD_PARAMETER;
+
+	mutex_lock(&acpi_pm_notifier_lock);
+
+	if (!adev->wakeup.flags.notifier_present)
+		goto out;
+
+	status = acpi_remove_notify_handler(adev->handle,
+					    ACPI_SYSTEM_NOTIFY,
+					    handler);
+	if (ACPI_FAILURE(status))
+		goto out;
+
+	adev->wakeup.flags.notifier_present = false;
+
+ out:
+	mutex_unlock(&acpi_pm_notifier_lock);
+	return status;
+}
Index: linux/drivers/pci/pci-acpi.c
===================================================================
--- linux.orig/drivers/pci/pci-acpi.c
+++ linux/drivers/pci/pci-acpi.c
@@ -20,8 +20,6 @@
 #include <linux/pm_qos.h>
 #include "pci.h"
 
-static DEFINE_MUTEX(pci_acpi_pm_notify_mtx);
-
 /**
  * pci_acpi_wake_bus - Wake-up notification handler for root buses.
  * @handle: ACPI handle of a device the notification is for.
@@ -69,67 +67,6 @@ static void pci_acpi_wake_dev(acpi_handl
 }
 
 /**
- * add_pm_notifier - Register PM notifier for given ACPI device.
- * @dev: ACPI device to add the notifier for.
- * @context: PCI device or bus to check for PME status if an event is signaled.
- *
- * NOTE: @dev need not be a run-wake or wake-up device to be a valid source of
- * PM wake-up events.  For example, wake-up events may be generated for bridges
- * if one of the devices below the bridge is signaling PME, even if the bridge
- * itself doesn't have a wake-up GPE associated with it.
- */
-static acpi_status add_pm_notifier(struct acpi_device *dev,
-				   acpi_notify_handler handler,
-				   void *context)
-{
-	acpi_status status = AE_ALREADY_EXISTS;
-
-	mutex_lock(&pci_acpi_pm_notify_mtx);
-
-	if (dev->wakeup.flags.notifier_present)
-		goto out;
-
-	status = acpi_install_notify_handler(dev->handle,
-					     ACPI_SYSTEM_NOTIFY,
-					     handler, context);
-	if (ACPI_FAILURE(status))
-		goto out;
-
-	dev->wakeup.flags.notifier_present = true;
-
- out:
-	mutex_unlock(&pci_acpi_pm_notify_mtx);
-	return status;
-}
-
-/**
- * remove_pm_notifier - Unregister PM notifier from given ACPI device.
- * @dev: ACPI device to remove the notifier from.
- */
-static acpi_status remove_pm_notifier(struct acpi_device *dev,
-				      acpi_notify_handler handler)
-{
-	acpi_status status = AE_BAD_PARAMETER;
-
-	mutex_lock(&pci_acpi_pm_notify_mtx);
-
-	if (!dev->wakeup.flags.notifier_present)
-		goto out;
-
-	status = acpi_remove_notify_handler(dev->handle,
-					    ACPI_SYSTEM_NOTIFY,
-					    handler);
-	if (ACPI_FAILURE(status))
-		goto out;
-
-	dev->wakeup.flags.notifier_present = false;
-
- out:
-	mutex_unlock(&pci_acpi_pm_notify_mtx);
-	return status;
-}
-
-/**
  * pci_acpi_add_bus_pm_notifier - Register PM notifier for given PCI bus.
  * @dev: ACPI device to add the notifier for.
  * @pci_bus: PCI bus to walk checking for PME status if an event is signaled.
@@ -137,7 +74,7 @@ static acpi_status remove_pm_notifier(st
 acpi_status pci_acpi_add_bus_pm_notifier(struct acpi_device *dev,
 					 struct pci_bus *pci_bus)
 {
-	return add_pm_notifier(dev, pci_acpi_wake_bus, pci_bus);
+	return acpi_add_pm_notifier(dev, pci_acpi_wake_bus, pci_bus);
 }
 
 /**
@@ -146,7 +83,7 @@ acpi_status pci_acpi_add_bus_pm_notifier
  */
 acpi_status pci_acpi_remove_bus_pm_notifier(struct acpi_device *dev)
 {
-	return remove_pm_notifier(dev, pci_acpi_wake_bus);
+	return acpi_remove_pm_notifier(dev, pci_acpi_wake_bus);
 }
 
 /**
@@ -157,7 +94,7 @@ acpi_status pci_acpi_remove_bus_pm_notif
 acpi_status pci_acpi_add_pm_notifier(struct acpi_device *dev,
 				     struct pci_dev *pci_dev)
 {
-	return add_pm_notifier(dev, pci_acpi_wake_dev, pci_dev);
+	return acpi_add_pm_notifier(dev, pci_acpi_wake_dev, pci_dev);
 }
 
 /**
@@ -166,7 +103,7 @@ acpi_status pci_acpi_add_pm_notifier(str
  */
 acpi_status pci_acpi_remove_pm_notifier(struct acpi_device *dev)
 {
-	return remove_pm_notifier(dev, pci_acpi_wake_dev);
+	return acpi_remove_pm_notifier(dev, pci_acpi_wake_dev);
 }
 
 phys_addr_t acpi_pci_root_get_mcfg_addr(acpi_handle handle)
Index: linux/drivers/acpi/Makefile
===================================================================
--- linux.orig/drivers/acpi/Makefile
+++ linux/drivers/acpi/Makefile
@@ -21,9 +21,10 @@ obj-y				+= acpi.o \
 acpi-y				+= osl.o utils.o reboot.o
 acpi-y				+= nvs.o
 
-# sleep related files
+# Power management related files
 acpi-y				+= wakeup.o
 acpi-y				+= sleep.o
+acpi-$(CONFIG_PM)		+= device_pm.o
 acpi-$(CONFIG_ACPI_SLEEP)	+= proc.o
 
 
Index: linux/include/acpi/acpi_bus.h
===================================================================
--- linux.orig/include/acpi/acpi_bus.h
+++ linux/include/acpi/acpi_bus.h
@@ -415,8 +415,23 @@ int acpi_enable_wakeup_device_power(stru
 int acpi_disable_wakeup_device_power(struct acpi_device *dev);
 
 #ifdef CONFIG_PM
+acpi_status acpi_add_pm_notifier(struct acpi_device *adev,
+				 acpi_notify_handler handler, void *context);
+acpi_status acpi_remove_pm_notifier(struct acpi_device *adev,
+				    acpi_notify_handler handler);
 int acpi_pm_device_sleep_state(struct device *, int *, int);
 #else
+static inline acpi_status acpi_add_pm_notifier(struct acpi_device *adev,
+					       acpi_notify_handler handler,
+					       void *context)
+{
+	return AE_SUPPORT;
+}
+static inline acpi_status acpi_remove_pm_notifier(struct acpi_device *adev,
+						  acpi_notify_handler handler)
+{
+	return AE_SUPPORT;
+}
 static inline int acpi_pm_device_sleep_state(struct device *d, int *p, int m)
 {
 	if (p)

