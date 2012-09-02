Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab2IBV41 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:56:27 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:40066 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab2IBV4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:56:22 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH part5 4/7] ACPI, PCI: Stop pci devices before acpi_pci_driver remove calling
Date: Sun,  2 Sep 2012 14:56:02 -0700
Message-Id: <1346622965-30937-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1346622965-30937-1-git-send-email-yinghai@kernel.org>
References: <1346622965-30937-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During stop pci drivers, it still need to access ioapic and iommu.
So need to make sure those drivers need to be stop at first.

Also change the acpi_pci_drivers remove calling sequence to reverse.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/acpi/pci_root.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index f3402df..59aa947 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -659,10 +659,6 @@ static int acpi_pci_root_remove(struct acpi_device *device, int type)
 
 	mutex_lock(&acpi_pci_root_lock);
 
-	list_for_each_entry(driver, &acpi_pci_drivers, node)
-		if (driver->remove)
-			driver->remove(root->device->handle);
-
 	/* that root bus could be removed already */
 	if (!pci_find_bus(root->segment, root->secondary.start)) {
 		dev_printk(KERN_DEBUG, &device->dev,
@@ -670,6 +666,13 @@ static int acpi_pci_root_remove(struct acpi_device *device, int type)
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
 
-- 
1.7.7

