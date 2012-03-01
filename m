Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755Ab2CADDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 22:03:12 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:34321 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758412Ab2CADDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 22:03:09 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 23/36] x86, PCI: put busn resource in pci_root_info for no_crs path
Date: Wed, 29 Feb 2012 19:00:24 -0800
Message-Id: <1330570837-26638-24-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330570837-26638-1-git-send-email-yinghai@kernel.org>
References: <1330570837-26638-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090204.4F4EE680.007A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

will put it in resources list and pass it for create_root_bus

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/amd_bus.c  |    1 -
 arch/x86/pci/bus_numa.c |   22 ++++++++++++++--------
 arch/x86/pci/bus_numa.h |    3 +--
 3 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index aff155d..03397ea 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -116,7 +116,6 @@ static int __init early_fill_mp_bus_info(void)
 		link = (reg >> 8) & 0x03;
 
 		info = alloc_pci_root_info(min_bus, max_bus, node, link);
-		sprintf(info->name, "PCI Bus #%02x", min_bus);
 	}
 
 	/* get the default node and link for left over res */
diff --git a/arch/x86/pci/bus_numa.c b/arch/x86/pci/bus_numa.c
index 772949f..b5b9d91 100644
--- a/arch/x86/pci/bus_numa.c
+++ b/arch/x86/pci/bus_numa.c
@@ -14,7 +14,7 @@ static struct pci_root_info *x86_find_pci_root_info(int bus)
 		return NULL;
 
 	list_for_each_entry(info, &pci_root_infos, list)
-		if (info->bus_min == bus)
+		if (info->busn.start == bus)
 			return info;
 
 	return NULL;
@@ -31,6 +31,8 @@ void x86_pci_root_bus_resources(int bus, struct list_head *resources)
 	printk(KERN_DEBUG "PCI: root bus %02x: hardware-probed resources\n",
 	       bus);
 
+	pci_add_resource(resources, &info->busn);
+
 	list_for_each_entry(root_res, &info->resources, list) {
 		struct resource *res;
 		struct resource *root;
@@ -54,6 +56,7 @@ default_resources:
 	printk(KERN_DEBUG "PCI: root bus %02x: using default resources\n", bus);
 	pci_add_resource(resources, &ioport_resource);
 	pci_add_resource(resources, &iomem_resource);
+	pci_add_resource(resources, &busn_resource);
 }
 
 struct pci_root_info __init *alloc_pci_root_info(int bus_min, int bus_max,
@@ -66,9 +69,13 @@ struct pci_root_info __init *alloc_pci_root_info(int bus_min, int bus_max,
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
 
@@ -80,14 +87,13 @@ struct pci_root_info __init *alloc_pci_root_info(int bus_min, int bus_max,
 void print_pci_root_info(struct pci_root_info *info, char *name, bool nodelink)
 {
 	struct pci_root_res *root_res;
-	int busnum = info->bus_min;
+	int busnum = info->busn.start;
 
 	if (!nodelink)
-		printk(KERN_DEBUG "%s: [%02x, %02x]\n", name,
-				info->bus_min, info->bus_max);
+		printk(KERN_DEBUG "%s: %pR\n", name, &info->busn);
 	else
-		printk(KERN_DEBUG "%s: [%02x, %02x] on node %x link %x\n", name,
-			info->bus_min, info->bus_max, info->node, info->link);
+		printk(KERN_DEBUG "%s: %pR on node %x link %x\n", name,
+			&info->busn, info->node, info->link);
 
 	list_for_each_entry(root_res, &info->resources, list)
 		printk(KERN_DEBUG "%s: %02x %pR\n", name, busnum,
diff --git a/arch/x86/pci/bus_numa.h b/arch/x86/pci/bus_numa.h
index deada6a..f9919c3 100644
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

