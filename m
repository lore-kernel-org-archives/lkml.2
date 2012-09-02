Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab2IBV4q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:56:46 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:23303 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183Ab2IBV43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:56:29 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH part5 7/7] ACPI, PCI: Skip extra pci_enable_bridges for non hot-add root
Date: Sun,  2 Sep 2012 14:56:05 -0700
Message-Id: <1346622965-30937-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1346622965-30937-1-git-send-email-yinghai@kernel.org>
References: <1346622965-30937-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pre-installed will be handled later, need to skip the one only for hot-added
roots.

Otherwise will get anonying failing message about can not reserve, irq ...

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/acpi/pci_root.c    |    3 ++-
 drivers/acpi/pci_root_hp.c |    1 +
 include/acpi/acpi_bus.h    |    1 +
 3 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 80adbbb..576fe9a 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -647,7 +647,8 @@ static int acpi_pci_root_start(struct acpi_device *device)
 			driver->add(device->handle);
 
 	/* need to after hot-added ioapic is registered */
-	pci_enable_bridges(root->bus);
+	if (root->hot_added)
+		pci_enable_bridges(root->bus);
 
 	pci_bus_add_devices(root->bus);
 	mutex_unlock(&acpi_pci_root_lock);
diff --git a/drivers/acpi/pci_root_hp.c b/drivers/acpi/pci_root_hp.c
index d2ace81..2800fb4 100644
--- a/drivers/acpi/pci_root_hp.c
+++ b/drivers/acpi/pci_root_hp.c
@@ -86,6 +86,7 @@ static void acpi_root_configure_bridge(acpi_handle handle)
 
 	pcibios_resource_survey_bus(root->bus);
 	pci_assign_unassigned_bus_resources(root->bus);
+	root->hot_added = true;
 }
 
 static void handle_root_bridge_insertion(acpi_handle handle)
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index bde976e..47de196 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -406,6 +406,7 @@ struct acpi_pci_root {
 
 	u32 osc_support_set;	/* _OSC state of support bits */
 	u32 osc_control_set;	/* _OSC state of control bits */
+	bool hot_added;
 	phys_addr_t mcfg_addr;
 };
 
-- 
1.7.7

