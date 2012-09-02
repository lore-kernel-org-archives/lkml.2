Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab2IBV5M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:57:12 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:23297 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756123Ab2IBV41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:56:27 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH part5 6/7] PCI, x86: Move pci_enable_bridges() down
Date: Sun,  2 Sep 2012 14:56:04 -0700
Message-Id: <1346622965-30937-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1346622965-30937-1-git-send-email-yinghai@kernel.org>
References: <1346622965-30937-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After we get hot-added ioapic registered.

pci_enable_bridges will try to enable ioapic irq for pci bridge.

So need to move it down.

Or We can move out pcibios_enable_irq() out of pci_enable_device()
and call pcibios_enable_irq in pci_bus_add_devices ?
also will need to move ...
        pcibios_resource_survey_bus(root->bus);
        pci_assign_unassigned_bus_resources(root->bus);
to the start add ....

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/acpi/pci_root.c |    3 +++
 drivers/pci/probe.c     |    1 +
 drivers/pci/setup-bus.c |    2 --
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 59aa947..80adbbb 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -646,6 +646,9 @@ static int acpi_pci_root_start(struct acpi_device *device)
 		if (driver->add)
 			driver->add(device->handle);
 
+	/* need to after hot-added ioapic is registered */
+	pci_enable_bridges(root->bus);
+
 	pci_bus_add_devices(root->bus);
 	mutex_unlock(&acpi_pci_root_lock);
 
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index dd84224..b18f429 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1909,6 +1909,7 @@ unsigned int __ref pci_rescan_bus(struct pci_bus *bus)
 
 	max = pci_scan_child_bus(bus);
 	pci_assign_unassigned_bus_resources(bus);
+	pci_enable_bridges(bus);
 	pci_bus_add_devices(bus);
 
 	return max;
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 054d54b..ec10d51 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1527,6 +1527,4 @@ void pci_assign_unassigned_bus_resources(struct pci_bus *bus)
 	up_read(&pci_bus_sem);
 	__pci_bus_assign_resources(bus, &add_list, NULL);
 	BUG_ON(!list_empty(&add_list));
-
-	pci_enable_bridges(bus);
 }
-- 
1.7.7

