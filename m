Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab2DCCXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 22:23:36 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:21727 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab2DCCUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 22:20:01 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <len.brown@intel.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [RFC PATCH 03/14] ACPI, PCI: Skip extra pci_enable_bridges for non hot-add root
Date: Mon,  2 Apr 2012 19:19:30 -0700
Message-Id: <1333419581-7836-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1333419581-7836-1-git-send-email-yinghai@kernel.org>
References: <1333419581-7836-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090202.4F7A5E47.00D3,ss=1,re=0.000,fgs=0
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
index 95b8f22..b313125 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -645,7 +645,8 @@ static int acpi_pci_root_start(struct acpi_device *device)
 			driver->add(device->handle);
 
 	/* need to after hot-added ioapic is registered */
-	pci_enable_bridges(root->bus);
+	if (root->hot_added)
+		pci_enable_bridges(root->bus);
 
 	pci_bus_add_devices(root->bus);
 	mutex_unlock(&acpi_pci_root_lock);
diff --git a/drivers/acpi/pci_root_hp.c b/drivers/acpi/pci_root_hp.c
index e16b53d..7d7f809 100644
--- a/drivers/acpi/pci_root_hp.c
+++ b/drivers/acpi/pci_root_hp.c
@@ -86,6 +86,7 @@ static void acpi_root_configure_bridge(acpi_handle handle)
 
 	pcibios_resource_survey_bus(root->bus);
 	pci_assign_unassigned_bus_resources(root->bus);
+	root->hot_added = true;
 }
 
 static void handle_root_bridge_insertion(acpi_handle handle)
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index f1c8ca6..333d38c 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -370,6 +370,7 @@ struct acpi_pci_root {
 
 	u32 osc_support_set;	/* _OSC state of support bits */
 	u32 osc_control_set;	/* _OSC state of control bits */
+	bool hot_added;
 };
 
 /* helper */
-- 
1.7.7

