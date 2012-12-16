Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab2LPNxE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 08:53:04 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:35421 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120Ab2LPNwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 08:52:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Jiang Liu <liuj97@gmail.com>,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: [PATCH 1/6] ACPI / PCI: Fold acpi_pci_root_start() into acpi_pci_root_add()
Date: Sun, 16 Dec 2012 14:49:34 +0100
Message-ID: <1648717.NkV1ZYWqNp@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <4532917.9APhB4xTvi@vostro.rjw.lan>
References: <4532917.9APhB4xTvi@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Move the code from the ACPI PCI root bridge's .start() callback
routine, acpi_pci_root_start(), directly into acpi_pci_root_add()
and drop acpi_pci_root_start().

It is safe to do that, because it is now always guaranteed that
when struct pci_dev objects are created, their companion struct
acpi_device objects are already present, so it is not necessary to
wait for them to be created before calling pci_bus_add_devices().

This change was previously proposed in a different form by
Yinghai Lu.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/pci_root.c |   26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

Index: linux/drivers/acpi/pci_root.c
===================================================================
--- linux.orig/drivers/acpi/pci_root.c
+++ linux/drivers/acpi/pci_root.c
@@ -47,7 +47,6 @@ ACPI_MODULE_NAME("pci_root");
 #define ACPI_PCI_ROOT_DEVICE_NAME	"PCI Root Bridge"
 static int acpi_pci_root_add(struct acpi_device *device);
 static int acpi_pci_root_remove(struct acpi_device *device, int type);
-static int acpi_pci_root_start(struct acpi_device *device);
 
 #define ACPI_PCIE_REQ_SUPPORT (OSC_EXT_PCI_CONFIG_SUPPORT \
 				| OSC_ACTIVE_STATE_PWR_SUPPORT \
@@ -67,7 +66,6 @@ static struct acpi_driver acpi_pci_root_
 	.ops = {
 		.add = acpi_pci_root_add,
 		.remove = acpi_pci_root_remove,
-		.start = acpi_pci_root_start,
 		},
 };
 
@@ -453,6 +451,7 @@ static int __devinit acpi_pci_root_add(s
 	struct acpi_pci_root *root;
 	acpi_handle handle;
 	struct acpi_device *child;
+	struct acpi_pci_driver *driver;
 	u32 flags, base_flags;
 
 	root = kzalloc(sizeof(struct acpi_pci_root), GFP_KERNEL);
@@ -628,6 +627,13 @@ static int __devinit acpi_pci_root_add(s
 	if (device->wakeup.flags.run_wake)
 		device_set_run_wake(root->bus->bridge, true);
 
+	mutex_lock(&acpi_pci_root_lock);
+	list_for_each_entry(driver, &acpi_pci_drivers, node)
+		if (driver->add)
+			driver->add(root);
+	mutex_unlock(&acpi_pci_root_lock);
+
+	pci_bus_add_devices(root->bus);
 	return 0;
 
 out_del_root:
@@ -639,22 +645,6 @@ end:
 	return result;
 }
 
-static int acpi_pci_root_start(struct acpi_device *device)
-{
-	struct acpi_pci_root *root = acpi_driver_data(device);
-	struct acpi_pci_driver *driver;
-
-	mutex_lock(&acpi_pci_root_lock);
-	list_for_each_entry(driver, &acpi_pci_drivers, node)
-		if (driver->add)
-			driver->add(root);
-	mutex_unlock(&acpi_pci_root_lock);
-
-	pci_bus_add_devices(root->bus);
-
-	return 0;
-}
-
 static int acpi_pci_root_remove(struct acpi_device *device, int type)
 {
 	struct acpi_pci_root *root = acpi_driver_data(device);

