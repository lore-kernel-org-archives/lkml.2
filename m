Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161703Ab2CSGCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 02:02:49 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30655 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161282Ab2CSFrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:47:48 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v3 18/47] x86, PCI: Let pcibios_allocate_bus_resources() take bus instead
Date: Sun, 18 Mar 2012 22:46:07 -0700
Message-Id: <1332135996-13860-19-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
References: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090209.4F66C882.0019,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will need call the same code for one single root bus during hot add.
So try to make it take bus instead of bus_list.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/i386.c |   38 +++++++++++++++++++++++++-------------
 1 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index bb84ff0..cecb842 100644
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

