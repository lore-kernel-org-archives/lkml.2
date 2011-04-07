Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183Ab1DGD0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 23:26:55 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:38844 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab1DGD0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 23:26:53 -0400
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-pci@vger.kernel.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, bheglaas@google.com, monstr@monstr.eu,
        tglx@linuxtronix.de, bigeasy@linuxtronix.de,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 4/5] x86/devicetree: Use generic PCI <-> OF matching
Date: Thu,  7 Apr 2011 13:26:35 +1000
Message-Id: <1302146796-26825-5-git-send-email-benh@kernel.crashing.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302146796-26825-1-git-send-email-benh@kernel.crashing.org>
References: <1302146796-26825-1-git-send-email-benh@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of walking the whole PCI tree to update the of_node's for
PCI busses and devices after the fact, enable the new generic core
code for doing so by providing the proper device nodes for the
PCI host bridges

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/x86/kernel/devicetree.c |   62 +++++++++++++----------------------------
 1 files changed, 20 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 706a9fb..f6c9d67 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -123,6 +123,26 @@ static int __init add_bus_probe(void)
 module_init(add_bus_probe);
 
 #ifdef CONFIG_PCI
+struct device_node * pcibios_get_phb_of_node(struct pci_bus *bus)
+{
+	struct device_node *np;
+	unsigned int bus_min;
+
+	for_each_node_by_type(np, "pci") {
+		const void *prop;
+		struct pci_bus *bus;
+		unsigned int bus_min;
+		struct device_node *child;
+
+		prop = of_get_property(np, "bus-range", NULL);
+		if (!prop)
+			continue;
+		bus_min = be32_to_cpup(prop);
+		if (bus->number == bus_min)
+			return np;
+	}
+}
+
 static int x86_of_pci_irq_enable(struct pci_dev *dev)
 {
 	struct of_irq oirq;
@@ -154,50 +174,8 @@ static void x86_of_pci_irq_disable(struct pci_dev *dev)
 
 void __cpuinit x86_of_pci_init(void)
 {
-	struct device_node *np;
-
 	pcibios_enable_irq = x86_of_pci_irq_enable;
 	pcibios_disable_irq = x86_of_pci_irq_disable;
-
-	for_each_node_by_type(np, "pci") {
-		const void *prop;
-		struct pci_bus *bus;
-		unsigned int bus_min;
-		struct device_node *child;
-
-		prop = of_get_property(np, "bus-range", NULL);
-		if (!prop)
-			continue;
-		bus_min = be32_to_cpup(prop);
-
-		bus = pci_find_bus(0, bus_min);
-		if (!bus) {
-			printk(KERN_ERR "Can't find a node for bus %s.\n",
-					np->full_name);
-			continue;
-		}
-
-		if (bus->self)
-			bus->self->dev.of_node = np;
-		else
-			bus->dev.of_node = np;
-
-		for_each_child_of_node(np, child) {
-			struct pci_dev *dev;
-			u32 devfn;
-
-			prop = of_get_property(child, "reg", NULL);
-			if (!prop)
-				continue;
-
-			devfn = (be32_to_cpup(prop) >> 8) & 0xff;
-			dev = pci_get_slot(bus, devfn);
-			if (!dev)
-				continue;
-			dev->dev.of_node = child;
-			pci_dev_put(dev);
-		}
-	}
 }
 #endif
 
-- 
1.7.1

