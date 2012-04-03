Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab2DCCV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 22:21:26 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:21816 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189Ab2DCCVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 22:21:10 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <len.brown@intel.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [RFC PATCH 01/14] ACPI, PCI: Stop pci devices before acpi_pci_driver remove calling
Date: Mon,  2 Apr 2012 19:19:28 -0700
Message-Id: <1333419581-7836-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1333419581-7836-1-git-send-email-yinghai@kernel.org>
References: <1333419581-7836-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A020204.4F7A5E48.0033,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During stop pci drivers, it still need to access ioapic and iommu.
So need to make sure those drivers need to be stop at first.

Also change the acpi_pci_drivers remove calling sequence to reverse.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/acpi/pci_root.c |   11 +++++++----
 drivers/pci/remove.c    |    2 +-
 include/linux/pci.h     |    1 +
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 4a7d575..ce662ae 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -657,10 +657,6 @@ static int acpi_pci_root_remove(struct acpi_device *device, int type)
 
 	mutex_lock(&acpi_pci_root_lock);
 
-	list_for_each_entry(driver, &acpi_pci_drivers, node)
-		if (driver->remove)
-			driver->remove(root->device->handle);
-
 	/* that root bus could be removed already */
 	if (!pci_find_bus(root->segment, root->secondary.start)) {
 		dev_printk(KERN_DEBUG, &device->dev,
@@ -668,6 +664,13 @@ static int acpi_pci_root_remove(struct acpi_device *device, int type)
 		goto out;
 	}
 
+	/* stop normal pci drivers before we stop ioapic and dmar etc */
+	pci_stop_bus_devices(root->bus);
+
+	list_for_each_entry_reverse(driver, &acpi_pci_drivers, node)
+		if (driver->remove)
+			driver->remove(root->device->handle);
+
 	device_set_run_wake(root->bus->bridge, false);
 	pci_acpi_remove_bus_pm_notifier(device);
 
diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index 18efb31..f672731 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -118,7 +118,7 @@ static void __pci_remove_bus_devices(struct pci_bus *bus)
 		__pci_remove_bus_device(dev);
 }
 
-static void pci_stop_bus_devices(struct pci_bus *bus)
+void pci_stop_bus_devices(struct pci_bus *bus)
 {
 	struct pci_dev *dev, *tmp;
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 8199563..944f49e 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -706,6 +706,7 @@ extern void pci_dev_put(struct pci_dev *dev);
 extern void pci_remove_bus(struct pci_bus *b);
 extern void __pci_remove_bus_device(struct pci_dev *dev);
 extern void pci_stop_and_remove_bus_device(struct pci_dev *dev);
+void pci_stop_bus_devices(struct pci_bus *bus);
 void pci_stop_and_remove_bus(struct pci_bus *bus);
 extern void pci_stop_bus_device(struct pci_dev *dev);
 void pci_setup_cardbus(struct pci_bus *bus);
-- 
1.7.7

