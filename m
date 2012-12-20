Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab2LTB6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 20:58:16 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:38301 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397Ab2LTBzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 20:55:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Toshi Kani <toshi.kani@hp.com>, Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Jiang Liu <liuj97@gmail.com>
Subject: [PATCH 15/16] ACPI / PCI: Move the _PRT setup and cleanup code to pci-acpi.c
Date: Thu, 20 Dec 2012 02:59:17 +0100
Message-ID: <1444724.1lVhhTmGMg@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1855256.SyhOJGYMIh@vostro.rjw.lan>
References: <8498184.VilrUmatxI@vostro.rjw.lan> <4082842.31rfDviYHK@vostro.rjw.lan> <1855256.SyhOJGYMIh@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Move the code related to _PRT setup and removal from acpi_pci_bind()
and acpi_pci_unbind() to the .setup() and .cleanup() callbacks in
acpi_pci_bus and remove acpi_pci_bind() and acpi_pci_unbind() that
have no purpose any more.  Accordingly, remove the code related to
device .bind() and .unbind() operations from the ACPI PCI root bridge
driver.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/Makefile   |    2 
 drivers/acpi/pci_bind.c |  113 ------------------------------------------------
 drivers/acpi/pci_root.c |   31 -------------
 drivers/pci/pci-acpi.c  |   34 +++++++++++---
 4 files changed, 29 insertions(+), 151 deletions(-)

Index: linux/drivers/acpi/pci_bind.c
===================================================================
--- linux.orig/drivers/acpi/pci_bind.c
+++ /dev/null
@@ -1,113 +0,0 @@
-/*
- *  pci_bind.c - ACPI PCI Device Binding ($Revision: 2 $)
- *
- *  Copyright (C) 2001, 2002 Andy Grover <andrew.grover@intel.com>
- *  Copyright (C) 2001, 2002 Paul Diefenbaugh <paul.s.diefenbaugh@intel.com>
- *
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or (at
- *  your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful, but
- *  WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- *  General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License along
- *  with this program; if not, write to the Free Software Foundation, Inc.,
- *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
- *
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- */
-
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <linux/pci.h>
-#include <linux/pci-acpi.h>
-#include <linux/acpi.h>
-#include <linux/pm_runtime.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
-
-#define _COMPONENT		ACPI_PCI_COMPONENT
-ACPI_MODULE_NAME("pci_bind");
-
-static int acpi_pci_unbind(struct acpi_device *device)
-{
-	struct pci_dev *dev;
-
-	dev = acpi_get_pci_dev(device->handle);
-	if (!dev)
-		goto out;
-
-	if (!dev->subordinate)
-		goto out;
-
-	acpi_pci_irq_del_prt(dev->subordinate);
-
-	device->ops.bind = NULL;
-	device->ops.unbind = NULL;
-
-out:
-	pci_dev_put(dev);
-	return 0;
-}
-
-static int acpi_pci_bind(struct acpi_device *device)
-{
-	acpi_status status;
-	acpi_handle handle;
-	struct pci_bus *bus;
-	struct pci_dev *dev;
-
-	dev = acpi_get_pci_dev(device->handle);
-	if (!dev)
-		return 0;
-
-	/*
-	 * Install the 'bind' function to facilitate callbacks for
-	 * children of the P2P bridge.
-	 */
-	if (dev->subordinate) {
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-				  "Device %04x:%02x:%02x.%d is a PCI bridge\n",
-				  pci_domain_nr(dev->bus), dev->bus->number,
-				  PCI_SLOT(dev->devfn), PCI_FUNC(dev->devfn)));
-		device->ops.bind = acpi_pci_bind;
-		device->ops.unbind = acpi_pci_unbind;
-	}
-
-	/*
-	 * Evaluate and parse _PRT, if exists.  This code allows parsing of
-	 * _PRT objects within the scope of non-bridge devices.  Note that
-	 * _PRTs within the scope of a PCI bridge assume the bridge's
-	 * subordinate bus number.
-	 *
-	 * TBD: Can _PRTs exist within the scope of non-bridge PCI devices?
-	 */
-	status = acpi_get_handle(device->handle, METHOD_NAME__PRT, &handle);
-	if (ACPI_FAILURE(status))
-		goto out;
-
-	if (dev->subordinate)
-		bus = dev->subordinate;
-	else
-		bus = dev->bus;
-
-	acpi_pci_irq_add_prt(device->handle, bus);
-
-out:
-	pci_dev_put(dev);
-	return 0;
-}
-
-int acpi_pci_bind_root(struct acpi_device *device)
-{
-	device->ops.bind = acpi_pci_bind;
-	device->ops.unbind = acpi_pci_unbind;
-
-	return 0;
-}
Index: linux/drivers/pci/pci-acpi.c
===================================================================
--- linux.orig/drivers/pci/pci-acpi.c
+++ linux/drivers/pci/pci-acpi.c
@@ -320,12 +320,30 @@ static int acpi_pci_find_root_bridge(str
 	return 0;
 }
 
-static void acpi_pci_wakeup_setup(struct device *dev)
+static void pci_acpi_setup(struct device *dev)
 {
-	struct acpi_device *adev = acpi_dev_pm_get_node(dev);
 	struct pci_dev *pci_dev = to_pci_dev(dev);
+	acpi_handle handle = ACPI_HANDLE(dev);
+	struct acpi_device *adev;
+	acpi_status status;
+	acpi_handle dummy;
+
+	/*
+	 * Evaluate and parse _PRT, if exists.  This code allows parsing of
+	 * _PRT objects within the scope of non-bridge devices.  Note that
+	 * _PRTs within the scope of a PCI bridge assume the bridge's
+	 * subordinate bus number.
+	 *
+	 * TBD: Can _PRTs exist within the scope of non-bridge PCI devices?
+	 */
+	status = acpi_get_handle(handle, METHOD_NAME__PRT, &dummy);
+	if (ACPI_SUCCESS(status)) {
+		struct pci_bus *bus = pci_dev->subordinate;
+
+		acpi_pci_irq_add_prt(handle, bus ? bus : pci_dev->bus);
+	}
 
-	if (!adev || !adev->wakeup.flags.valid)
+	if (acpi_bus_get_device(handle, &adev) || !adev->wakeup.flags.valid)
 		return;
 
 	device_set_wakeup_capable(dev, true);
@@ -336,23 +354,27 @@ static void acpi_pci_wakeup_setup(struct
 		device_set_run_wake(dev, true);
 }
 
-static void acpi_pci_wakeup_cleanup(struct device *dev)
+static void pci_acpi_cleanup(struct device *dev)
 {
 	struct acpi_device *adev = acpi_dev_pm_get_node(dev);
+	struct pci_dev *pci_dev = to_pci_dev(dev);
 
 	if (adev && adev->wakeup.flags.valid) {
 		device_set_wakeup_capable(dev, false);
 		device_set_run_wake(dev, false);
 		pci_acpi_remove_pm_notifier(adev);
 	}
+
+	if (pci_dev->subordinate)
+		acpi_pci_irq_del_prt(pci_dev->subordinate);
 }
 
 static struct acpi_bus_type acpi_pci_bus = {
 	.bus = &pci_bus_type,
 	.find_device = acpi_pci_find_device,
 	.find_bridge = acpi_pci_find_root_bridge,
-	.setup = acpi_pci_wakeup_setup,
-	.cleanup = acpi_pci_wakeup_cleanup,
+	.setup = pci_acpi_setup,
+	.cleanup = pci_acpi_cleanup,
 };
 
 static int __init acpi_pci_init(void)
Index: linux/drivers/acpi/Makefile
===================================================================
--- linux.orig/drivers/acpi/Makefile
+++ linux/drivers/acpi/Makefile
@@ -37,7 +37,7 @@ acpi-y				+= resource.o
 acpi-y				+= processor_core.o
 acpi-y				+= ec.o
 acpi-$(CONFIG_ACPI_DOCK)	+= dock.o
-acpi-y				+= pci_root.o pci_link.o pci_irq.o pci_bind.o
+acpi-y				+= pci_root.o pci_link.o pci_irq.o
 acpi-y				+= acpi_platform.o
 acpi-y				+= power.o
 acpi-y				+= event.o
Index: linux/drivers/acpi/pci_root.c
===================================================================
--- linux.orig/drivers/acpi/pci_root.c
+++ linux/drivers/acpi/pci_root.c
@@ -186,21 +186,6 @@ static acpi_status try_get_root_bridge_b
 	return AE_OK;
 }
 
-static void acpi_pci_bridge_scan(struct acpi_device *device)
-{
-	int status;
-	struct acpi_device *child = NULL;
-
-	if (device->flags.bus_address)
-		if (device->parent && device->parent->ops.bind) {
-			status = device->parent->ops.bind(device);
-			if (!status) {
-				list_for_each_entry(child, &device->children, node)
-					acpi_pci_bridge_scan(child);
-			}
-		}
-}
-
 static u8 pci_osc_uuid_str[] = "33DB4D5B-1FF7-401C-9657-7441C03DD766";
 
 static acpi_status acpi_pci_run_osc(acpi_handle handle,
@@ -450,7 +435,6 @@ static int __devinit acpi_pci_root_add(s
 	int result;
 	struct acpi_pci_root *root;
 	acpi_handle handle;
-	struct acpi_device *child;
 	struct acpi_pci_driver *driver;
 	u32 flags, base_flags;
 
@@ -538,15 +522,6 @@ static int __devinit acpi_pci_root_add(s
 	}
 
 	/*
-	 * Attach ACPI-PCI Context
-	 * -----------------------
-	 * Thus binding the ACPI and PCI devices.
-	 */
-	result = acpi_pci_bind_root(device);
-	if (result)
-		goto out_del_root;
-
-	/*
 	 * PCI Routing Table
 	 * -----------------
 	 * Evaluate and parse _PRT, if exists.
@@ -555,12 +530,6 @@ static int __devinit acpi_pci_root_add(s
 	if (ACPI_SUCCESS(status))
 		result = acpi_pci_irq_add_prt(device->handle, root->bus);
 
-	/*
-	 * Scan and bind all _ADR-Based Devices
-	 */
-	list_for_each_entry(child, &device->children, node)
-		acpi_pci_bridge_scan(child);
-
 	/* Indicate support for various _OSC capabilities. */
 	if (pci_ext_cfg_avail(root->bus->self))
 		flags |= OSC_EXT_PCI_CONFIG_SUPPORT;

