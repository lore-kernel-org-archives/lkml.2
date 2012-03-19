Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031468Ab2CSGF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 02:05:29 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:29273 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031025Ab2CSFrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:47:31 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v3 06/47] PCI: Move back pci_rescan_bus()
Date: Sun, 18 Mar 2012 22:45:55 -0700
Message-Id: <1332135996-13860-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
References: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4F66C870.00BD,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have pci_assign_unassigned_bus_resources() in place.

So move back pci_rescan_bus to probe.c where it should be.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c     |   21 +++++++++++++++++++++
 drivers/pci/setup-bus.c |   22 ----------------------
 2 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 38e0448..3dc92b9 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2036,6 +2036,27 @@ unsigned int __ref pci_rescan_bus_bridge_resize(struct pci_dev *bridge)
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
index 6443c81..f35a679 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1507,25 +1507,3 @@ void pci_assign_unassigned_bus_resources(struct pci_bus *bus)
 
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

