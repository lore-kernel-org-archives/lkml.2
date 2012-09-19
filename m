Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147Ab2ISTDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 15:03:52 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:47916 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756913Ab2ISSzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 14:55:21 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 15/40] PCI: Move back pci_rescan_bus() to probe.c
Date: Wed, 19 Sep 2012 11:54:29 -0700
Message-Id: <1348080894-23412-16-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1348080894-23412-1-git-send-email-yinghai@kernel.org>
References: <CAE9FiQWFcVNKMnV1qaHchwCXfZuMpyxf_f7GQy3FZid9YuLD3w@mail.gmail.com>
 <1348080894-23412-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have pci_assign_unassigned_bus_resources() in as global function now.

So could move back pci_rescan_bus to probe.c where it should be.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c     |   21 +++++++++++++++++++++
 drivers/pci/setup-bus.c |   22 ----------------------
 2 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 2396111..47238dd 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1888,6 +1888,27 @@ unsigned int __ref pci_rescan_bus_bridge_resize(struct pci_dev *bridge)
 	return max;
 }
 
+/**
+ * pci_rescan_bus - scan a PCI bus for devices.
+ * @bus: PCI bus to scan
+ *
+ * Scan a PCI bus and child buses for new devices, adds them,
+ * and enables them.
+ *
+ * Returns the max number of subordinate bus discovered.
+ */
+unsigned int __ref pci_rescan_bus(struct pci_bus *bus)
+{
+	unsigned int max;
+
+	max = pci_scan_child_bus(bus);
+	pci_assign_unassigned_bus_resources(bus);
+	pci_bus_add_devices(bus);
+
+	return max;
+}
+EXPORT_SYMBOL_GPL(pci_rescan_bus);
+
 EXPORT_SYMBOL(pci_add_new_bus);
 EXPORT_SYMBOL(pci_scan_slot);
 EXPORT_SYMBOL(pci_scan_bridge);
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 7d7c1c9..31821d4 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1569,25 +1569,3 @@ void pci_assign_unassigned_bus_resources(struct pci_bus *bus)
 
 	pci_enable_bridges(bus);
 }
-#ifdef CONFIG_HOTPLUG
-/**
- * pci_rescan_bus - scan a PCI bus for devices.
- * @bus: PCI bus to scan
- *
- * Scan a PCI bus and child buses for new devices, adds them,
- * and enables them.
- *
- * Returns the max number of subordinate bus discovered.
- */
-unsigned int __ref pci_rescan_bus(struct pci_bus *bus)
-{
-	unsigned int max;
-
-	max = pci_scan_child_bus(bus);
-	pci_assign_unassigned_bus_resources(bus);
-	pci_bus_add_devices(bus);
-
-	return max;
-}
-EXPORT_SYMBOL_GPL(pci_rescan_bus);
-#endif
-- 
1.7.7

