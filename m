Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab2EGUc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:32:57 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:51067 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219Ab2EGUaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:30:35 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 14/21] x86/PCI: put busn resource in pci_root_info for native host bridge drivers
Date: Mon,  7 May 2012 13:29:59 -0700
Message-Id: <1336422606-4244-15-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
References: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the host bridge bus number aperture to the resource list.
Like the MMIO and I/O port apertures, this will be used when assigning
resources to hot-added devices or in the case of conflicts.

[bhelgaas: tidy printk, changelog]
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/amd_bus.c  |    7 +++----
 arch/x86/pci/bus_numa.c |   22 +++++++++++++++++++---
 arch/x86/pci/bus_numa.h |    3 +--
 3 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index 5aed49b..e9e6ed5 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -121,7 +121,6 @@ static int __init early_fill_mp_bus_info(void)
 		link = (reg >> 8) & 0x03;
 
 		info = alloc_pci_root_info(min_bus, max_bus, node, link);
-		sprintf(info->name, "PCI Bus #%02x", min_bus);
 	}
 
 	/* get the default node and link for left over res */
@@ -300,9 +299,9 @@ static int __init early_fill_mp_bus_info(void)
 		int busnum;
 		struct pci_root_res *root_res;
 
-		busnum = info->bus_min;
-		printk(KERN_DEBUG "bus: [%02x, %02x] on node %x link %x\n",
-		       info->bus_min, info->bus_max, info->node, info->link);
+		busnum = info->busn.start;
+		printk(KERN_DEBUG "bus: %pR on node %x link %x\n",
+		       &info->busn, info->node, info->link);
 		list_for_each_entry(root_res, &info->resources, list)
 			printk(KERN_DEBUG "bus: %02x %pR\n",
 				       busnum, &root_res->res);
diff --git a/arch/x86/pci/bus_numa.c b/arch/x86/pci/bus_numa.c
index 306579f..d37e2fe 100644
--- a/arch/x86/pci/bus_numa.c
+++ b/arch/x86/pci/bus_numa.c
@@ -14,7 +14,7 @@ static struct pci_root_info *x86_find_pci_root_info(int bus)
 		return NULL;
 
 	list_for_each_entry(info, &pci_root_infos, list)
-		if (info->bus_min == bus)
+		if (info->busn.start == bus)
 			return info;
 
 	return NULL;
@@ -24,6 +24,8 @@ void x86_pci_root_bus_resources(int bus, struct list_head *resources)
 {
 	struct pci_root_info *info = x86_find_pci_root_info(bus);
 	struct pci_root_res *root_res;
+	struct pci_host_bridge_window *window;
+	bool found = false;
 
 	if (!info)
 		goto default_resources;
@@ -31,6 +33,16 @@ void x86_pci_root_bus_resources(int bus, struct list_head *resources)
 	printk(KERN_DEBUG "PCI: root bus %02x: hardware-probed resources\n",
 	       bus);
 
+	/* already added by acpi ? */
+	list_for_each_entry(window, resources, list)
+		if (window->res->flags & IORESOURCE_BUS) {
+			found = true;
+			break;
+		}
+
+	if (!found)
+		pci_add_resource(resources, &info->busn);
+
 	list_for_each_entry(root_res, &info->resources, list) {
 		struct resource *res;
 		struct resource *root;
@@ -66,9 +78,13 @@ struct pci_root_info __init *alloc_pci_root_info(int bus_min, int bus_max,
 	if (!info)
 		return info;
 
+	sprintf(info->name, "PCI Bus #%02x", bus_min);
+
 	INIT_LIST_HEAD(&info->resources);
-	info->bus_min = bus_min;
-	info->bus_max = bus_max;
+	info->busn.name  = info->name;
+	info->busn.start = bus_min;
+	info->busn.end   = bus_max;
+	info->busn.flags = IORESOURCE_BUS;
 	info->node = node;
 	info->link = link;
 
diff --git a/arch/x86/pci/bus_numa.h b/arch/x86/pci/bus_numa.h
index 226a466..ff8f65b 100644
--- a/arch/x86/pci/bus_numa.h
+++ b/arch/x86/pci/bus_numa.h
@@ -13,8 +13,7 @@ struct pci_root_info {
 	struct list_head list;
 	char name[12];
 	struct list_head resources;
-	int bus_min;
-	int bus_max;
+	struct resource busn;
 	int node;
 	int link;
 };
-- 
1.7.7

