Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932959Ab2ISSz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 14:55:59 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:19796 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757028Ab2ISSzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 14:55:41 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 34/40] ACPI, PCI: Notify acpi_pci_drivers when hot-plugging PCI root bridges
Date: Wed, 19 Sep 2012 11:54:48 -0700
Message-Id: <1348080894-23412-35-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1348080894-23412-1-git-send-email-yinghai@kernel.org>
References: <CAE9FiQWFcVNKMnV1qaHchwCXfZuMpyxf_f7GQy3FZid9YuLD3w@mail.gmail.com>
 <1348080894-23412-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

When hot-plugging PCI root bridge, acpi_pci_drivers' add()/remove()
methods should be invoked to notify registered drivers.

-v2: Move add calling to acpi_pci_root_start - Yinghai
-v3: use acpi_pci_root pointer instead of handle - Yinghai
-v3: Fold stop ioapic/iommu drivers after pci devices change in. - Yinghai

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/acpi/pci_root.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 325cf5c..0ea5ad0 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -633,6 +633,11 @@ end:
 static int acpi_pci_root_start(struct acpi_device *device)
 {
 	struct acpi_pci_root *root = acpi_driver_data(device);
+	struct acpi_pci_driver *driver;
+
+	list_for_each_entry(driver, &acpi_pci_drivers, node)
+		if (driver->add)
+			driver->add(root);
 
 	pci_bus_add_devices(root->bus);
 	return 0;
@@ -643,6 +648,7 @@ static int acpi_pci_root_remove(struct acpi_device *device, int type)
 	acpi_status status;
 	acpi_handle handle;
 	struct acpi_pci_root *root = acpi_driver_data(device);
+	struct acpi_pci_driver *driver;
 
 	/* that root bus could be removed already */
 	if (!pci_find_bus(root->segment, root->secondary.start)) {
@@ -651,8 +657,13 @@ static int acpi_pci_root_remove(struct acpi_device *device, int type)
 		goto out;
 	}
 
+	/* stop normal pci drivers before we stop ioapic and dmar etc */
 	pci_stop_root_bus(root->bus);
 
+	list_for_each_entry_reverse(driver, &acpi_pci_drivers, node)
+		if (driver->remove)
+			driver->remove(root);
+
 	device_set_run_wake(root->bus->bridge, false);
 	pci_acpi_remove_bus_pm_notifier(device);
 
-- 
1.7.7

