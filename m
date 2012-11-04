Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab2KDEmP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 00:42:15 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:27415 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab2KDEmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 00:42:10 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <lenb@kernel.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org
Subject: [PATCH 3/8] PCI, x86: Let pcibios_allocate_bus_resources() take bus instead
Date: Sat,  3 Nov 2012 21:39:26 -0700
Message-Id: <1352003971-22278-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1352003971-22278-1-git-send-email-yinghai@kernel.org>
References: <20121030040237.GA10472@google.com>
 <1352003971-22278-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will need call the same code for one single root bus during hot add.
So make it take bus instead of bus list.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: x86@kernel.org
---
 arch/x86/pci/i386.c |   38 +++++++++++++++++++++++++-------------
 1 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 5817cf2..84696ed 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -215,16 +215,15 @@ static void __init pcibios_allocate_bridge_resources(struct pci_dev *dev)
 	}
 }
 
-static void __init pcibios_allocate_bus_resources(struct list_head *bus_list)
+static void __init pcibios_allocate_bus_resources(struct pci_bus *bus)
 {
-	struct pci_bus *bus;
+	struct pci_bus *child;
 
 	/* Depth-First Search on bus tree */
-	list_for_each_entry(bus, bus_list, node) {
-		if (bus->self)
-			pcibios_allocate_bridge_resources(bus->self);
-		pcibios_allocate_bus_resources(&bus->children);
-	}
+	if (bus->self)
+		pcibios_allocate_bridge_resources(bus->self);
+	list_for_each_entry(child, &bus->children, node)
+		pcibios_allocate_bus_resources(child);
 }
 
 struct pci_check_idx_range {
@@ -285,12 +284,18 @@ static void __init pcibios_allocate_dev_resources(struct pci_dev *dev, int pass)
 	}
 }
 
-static void __init pcibios_allocate_resources(int pass)
+static void __init pcibios_allocate_resources(struct pci_bus *bus, int pass)
 {
-	struct pci_dev *dev = NULL;
+	struct pci_dev *dev;
+	struct pci_bus *child;
 
-	for_each_pci_dev(dev)
+	list_for_each_entry(dev, &bus->devices, bus_list) {
 		pcibios_allocate_dev_resources(dev, pass);
+
+		child = dev->subordinate;
+		if (child)
+			pcibios_allocate_resources(child, pass);
+	}
 }
 
 static int __init pcibios_assign_resources(void)
@@ -323,10 +328,17 @@ static int __init pcibios_assign_resources(void)
 
 void __init pcibios_resource_survey(void)
 {
+	struct pci_bus *bus;
+
 	DBG("PCI: Allocating resources\n");
-	pcibios_allocate_bus_resources(&pci_root_buses);
-	pcibios_allocate_resources(0);
-	pcibios_allocate_resources(1);
+
+	list_for_each_entry(bus, &pci_root_buses, node)
+		pcibios_allocate_bus_resources(bus);
+
+	list_for_each_entry(bus, &pci_root_buses, node)
+		pcibios_allocate_resources(bus, 0);
+	list_for_each_entry(bus, &pci_root_buses, node)
+		pcibios_allocate_resources(bus, 1);
 
 	e820_reserve_resources_late();
 	/*
-- 
1.7.7

