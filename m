Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964881Ab2B1CLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 21:11:23 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:43141 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014Ab2B1CLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 21:11:18 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 05/18] PCI, x86: Register busn_res for root buses
Date: Mon, 27 Feb 2012 18:09:56 -0800
Message-Id: <1330395009-29260-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330395009-29260-1-git-send-email-yinghai@kernel.org>
References: <1330395009-29260-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090203.4F4C37BF.001E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

update x86_pci_root_bus_resources() to get bus_max for non-acpi case.

update pci_acpi_scan_root_bus, and pci_scan_root_bus_on_node
to insert busn_res before scan child bus.
So could make root bus busn_res is kept the original large one.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/topology.h |    3 ++-
 arch/x86/pci/acpi.c             |    8 +++++---
 arch/x86/pci/bus_numa.c         |    9 ++++++++-
 arch/x86/pci/common.c           |   12 +++++++++---
 4 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index b9676ae..8413481 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -172,7 +172,8 @@ static inline void arch_fix_phys_package_id(int num, u32 slot)
 }
 
 struct pci_bus;
-void x86_pci_root_bus_resources(int bus, struct list_head *resources);
+void x86_pci_root_bus_resources(int bus, int *bus_max,
+				 struct list_head *resources);
 
 #ifdef CONFIG_SMP
 #define mc_capable()	((boot_cpu_data.x86_max_cores > 1) && \
diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 7538fad..7bb327f 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -368,6 +368,7 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 	struct pci_root_info *info = NULL;
 	int domain = root->segment;
 	int busnum = root->secondary.start;
+	int busmax = root->secondary.end;
 	LIST_HEAD(resources);
 	struct pci_bus *bus;
 	struct pci_sysdata *sd;
@@ -436,14 +437,15 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 			add_resources(info, &resources);
 		else {
 			free_pci_root_info(info);
-			x86_pci_root_bus_resources(busnum, &resources);
+			x86_pci_root_bus_resources(busnum, &busmax, &resources);
 		}
 
 		bus = pci_create_root_bus(NULL, busnum, &pci_root_ops, sd,
 					  &resources);
-		if (bus)
+		if (bus) {
+			pci_bus_insert_busn_res(bus, busnum, busmax);
 			bus->subordinate = pci_scan_child_bus(bus);
-		else
+		} else
 			pci_free_resource_list(&resources);
 
 		if (pci_use_crs) {
diff --git a/arch/x86/pci/bus_numa.c b/arch/x86/pci/bus_numa.c
index 7251011..91ce4dd 100644
--- a/arch/x86/pci/bus_numa.c
+++ b/arch/x86/pci/bus_numa.c
@@ -20,7 +20,8 @@ static struct pci_root_info *x86_find_pci_root_info(int bus)
 	return NULL;
 }
 
-void x86_pci_root_bus_resources(int bus, struct list_head *resources)
+void x86_pci_root_bus_resources(int bus, int *bus_max,
+				struct list_head *resources)
 {
 	struct pci_root_info *info = x86_find_pci_root_info(bus);
 	struct pci_root_res *root_res;
@@ -43,6 +44,8 @@ void x86_pci_root_bus_resources(int bus, struct list_head *resources)
 			root = &iomem_resource;
 		insert_resource(root, res);
 	}
+
+	*bus_max = info->bus_max;
 	return;
 
 default_resources:
@@ -54,6 +57,10 @@ default_resources:
 	printk(KERN_DEBUG "PCI: root bus %02x: using default resources\n", bus);
 	pci_add_resource(resources, &ioport_resource);
 	pci_add_resource(resources, &iomem_resource);
+	if (!bus)
+		*bus_max = 0xff;
+	else if (!*bus_max)
+		*bus_max = bus;
 }
 
 struct pci_root_info __init *alloc_pci_root_info(int bus_min, int bus_max,
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 8e04ec5..5115606 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -623,6 +623,7 @@ struct pci_bus * __devinit pci_scan_bus_on_node(int busno, struct pci_ops *ops,
 	LIST_HEAD(resources);
 	struct pci_bus *bus = NULL;
 	struct pci_sysdata *sd;
+	int bus_max;
 
 	/*
 	 * Allocate per-root-bus (not per bus) arch-specific data.
@@ -635,13 +636,18 @@ struct pci_bus * __devinit pci_scan_bus_on_node(int busno, struct pci_ops *ops,
 		return NULL;
 	}
 	sd->node = node;
-	x86_pci_root_bus_resources(busno, &resources);
-	printk(KERN_DEBUG "PCI: Probing PCI hardware (bus %02x)\n", busno);
-	bus = pci_scan_root_bus(NULL, busno, ops, sd, &resources);
+	x86_pci_root_bus_resources(busno, &bus_max, &resources);
+	printk(KERN_DEBUG "PCI: Probing PCI hardware (bus %02x-%02x)\n",
+			 busno, bus_max);
+	bus = pci_create_root_bus(NULL, busno, &pci_root_ops, sd, &resources);
 	if (!bus) {
 		pci_free_resource_list(&resources);
 		kfree(sd);
+		return bus;
 	}
+	pci_bus_insert_busn_res(bus, busno, bus_max);
+	bus->subordinate = pci_scan_child_bus(bus);
+	pci_bus_add_devices(bus);
 
 	return bus;
 }
-- 
1.7.7

