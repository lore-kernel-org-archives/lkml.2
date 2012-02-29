Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090Ab2B2XJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 18:09:01 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:25540 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354Ab2B2XIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 18:08:22 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 11/39] x86, PCI: Allocating pci_root_info for not using _CRS path
Date: Wed, 29 Feb 2012 15:07:10 -0800
Message-Id: <1330556858-11768-12-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330556858-11768-1-git-send-email-yinghai@kernel.org>
References: <1330556858-11768-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090206.4F4EAFDE.0088,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so we could get ride of static allocation and hard limits.

We could save some bytes, and can handle system with more than 4
peer root buses.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/amd_bus.c      |   76 +++++++++++++++---------------------------
 arch/x86/pci/broadcom_bus.c |   12 ++----
 arch/x86/pci/bus_numa.c     |   69 ++++++++++++++++++++++++++------------
 arch/x86/pci/bus_numa.h     |   18 ++++++----
 4 files changed, 88 insertions(+), 87 deletions(-)

diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index 0567df3..459a731 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -32,6 +32,18 @@ static struct pci_hostbridge_probe pci_probes[] __initdata = {
 
 #define RANGE_NUM 16
 
+static struct pci_root_info __init *find_pci_root_info(int node, int link)
+{
+	struct pci_root_info *info;
+
+	/* find the position */
+	list_for_each_entry(info, &pci_root_infos, list)
+		if (info->node == node && info->link == link)
+			return info;
+
+	return NULL;
+}
+
 /**
  * early_fill_mp_bus_to_node()
  * called before pcibios_scan_root and pci_scan_bus
@@ -50,7 +62,6 @@ static int __init early_fill_mp_bus_info(void)
 	int def_link;
 	struct pci_root_info *info;
 	u32 reg;
-	struct resource *res;
 	u64 start;
 	u64 end;
 	struct range range[RANGE_NUM];
@@ -86,7 +97,6 @@ static int __init early_fill_mp_bus_info(void)
 	if (!found)
 		return 0;
 
-	pci_root_num = 0;
 	for (i = 0; i < 4; i++) {
 		int min_bus;
 		int max_bus;
@@ -105,13 +115,8 @@ static int __init early_fill_mp_bus_info(void)
 #endif
 		link = (reg >> 8) & 0x03;
 
-		info = &pci_root_info[pci_root_num];
-		info->bus_min = min_bus;
-		info->bus_max = max_bus;
-		info->node = node;
-		info->link = link;
+		info = alloc_pci_root_info(min_bus, max_bus, node, link);
 		sprintf(info->name, "PCI Bus #%02x", min_bus);
-		pci_root_num++;
 	}
 
 	/* get the default node and link for left over res */
@@ -134,16 +139,10 @@ static int __init early_fill_mp_bus_info(void)
 		link = (reg >> 4) & 0x03;
 		end = (reg & 0xfff000) | 0xfff;
 
-		/* find the position */
-		for (j = 0; j < pci_root_num; j++) {
-			info = &pci_root_info[j];
-			if (info->node == node && info->link == link)
-				break;
-		}
-		if (j == pci_root_num)
+		info = find_pci_root_info(node, link);
+		if (!info)
 			continue; /* not found */
 
-		info = &pci_root_info[j];
 		printk(KERN_DEBUG "node %d link %d: io port [%llx, %llx]\n",
 		       node, link, start, end);
 
@@ -155,13 +154,8 @@ static int __init early_fill_mp_bus_info(void)
 	}
 	/* add left over io port range to def node/link, [0, 0xffff] */
 	/* find the position */
-	for (j = 0; j < pci_root_num; j++) {
-		info = &pci_root_info[j];
-		if (info->node == def_node && info->link == def_link)
-			break;
-	}
-	if (j < pci_root_num) {
-		info = &pci_root_info[j];
+	info = find_pci_root_info(def_node, def_link);
+	if (info) {
 		for (i = 0; i < RANGE_NUM; i++) {
 			if (!range[i].end)
 				continue;
@@ -214,16 +208,10 @@ static int __init early_fill_mp_bus_info(void)
 		end <<= 8;
 		end |= 0xffff;
 
-		/* find the position */
-		for (j = 0; j < pci_root_num; j++) {
-			info = &pci_root_info[j];
-			if (info->node == node && info->link == link)
-				break;
-		}
-		if (j == pci_root_num)
-			continue; /* not found */
+		info = find_pci_root_info(node, link);
 
-		info = &pci_root_info[j];
+		if (!info)
+			continue;
 
 		printk(KERN_DEBUG "node %d link %d: mmio [%llx, %llx]",
 		       node, link, start, end);
@@ -291,14 +279,8 @@ static int __init early_fill_mp_bus_info(void)
 	 * add left over mmio range to def node/link ?
 	 * that is tricky, just record range in from start_min to 4G
 	 */
-	for (j = 0; j < pci_root_num; j++) {
-		info = &pci_root_info[j];
-		if (info->node == def_node && info->link == def_link)
-			break;
-	}
-	if (j < pci_root_num) {
-		info = &pci_root_info[j];
-
+	info = find_pci_root_info(def_node, def_link);
+	if (info) {
 		for (i = 0; i < RANGE_NUM; i++) {
 			if (!range[i].end)
 				continue;
@@ -309,20 +291,16 @@ static int __init early_fill_mp_bus_info(void)
 		}
 	}
 
-	for (i = 0; i < pci_root_num; i++) {
-		int res_num;
+	list_for_each_entry(info, &pci_root_infos, list) {
 		int busnum;
+		struct pci_root_res *root_res;
 
-		info = &pci_root_info[i];
-		res_num = info->res_num;
 		busnum = info->bus_min;
 		printk(KERN_DEBUG "bus: [%02x, %02x] on node %x link %x\n",
 		       info->bus_min, info->bus_max, info->node, info->link);
-		for (j = 0; j < res_num; j++) {
-			res = &info->res[j];
-			printk(KERN_DEBUG "bus: %02x index %x %pR\n",
-				       busnum, j, res);
-		}
+		list_for_each_entry(root_res, &info->resources, list)
+			printk(KERN_DEBUG "bus: %02x %pR\n",
+				       busnum, &root_res->res);
 	}
 
 	return 0;
diff --git a/arch/x86/pci/broadcom_bus.c b/arch/x86/pci/broadcom_bus.c
index f3a7c56..614392c 100644
--- a/arch/x86/pci/broadcom_bus.c
+++ b/arch/x86/pci/broadcom_bus.c
@@ -22,19 +22,15 @@
 static void __init cnb20le_res(u8 bus, u8 slot, u8 func)
 {
 	struct pci_root_info *info;
+	struct pci_root_res *root_res;
 	struct resource res;
 	u16 word1, word2;
 	u8 fbus, lbus;
-	int i;
-
-	info = &pci_root_info[pci_root_num];
-	pci_root_num++;
 
 	/* read the PCI bus numbers */
 	fbus = read_pci_config_byte(bus, slot, func, 0x44);
 	lbus = read_pci_config_byte(bus, slot, func, 0x45);
-	info->bus_min = fbus;
-	info->bus_max = lbus;
+	info = alloc_pci_root_info(fbus, lbus, 0, 0);
 
 	/*
 	 * Add the legacy IDE ports on bus 0
@@ -86,8 +82,8 @@ static void __init cnb20le_res(u8 bus, u8 slot, u8 func)
 	res.flags = IORESOURCE_BUS;
 	printk(KERN_INFO "CNB20LE PCI Host Bridge (domain 0000 %pR)\n", &res);
 
-	for (i = 0; i < info->res_num; i++)
-		printk(KERN_INFO "host bridge window %pR\n", &info->res[i]);
+	list_for_each_entry(root_res, &info->resources, list)
+		printk(KERN_INFO "host bridge window %pR\n", &root_res->res);
 }
 
 static int __init broadcom_postcore_init(void)
diff --git a/arch/x86/pci/bus_numa.c b/arch/x86/pci/bus_numa.c
index fd3f655..306579f 100644
--- a/arch/x86/pci/bus_numa.c
+++ b/arch/x86/pci/bus_numa.c
@@ -4,35 +4,38 @@
 
 #include "bus_numa.h"
 
-int pci_root_num;
-struct pci_root_info pci_root_info[PCI_ROOT_NR];
+LIST_HEAD(pci_root_infos);
 
-void x86_pci_root_bus_resources(int bus, struct list_head *resources)
+static struct pci_root_info *x86_find_pci_root_info(int bus)
 {
-	int i;
-	int j;
 	struct pci_root_info *info;
 
-	if (!pci_root_num)
-		goto default_resources;
+	if (list_empty(&pci_root_infos))
+		return NULL;
 
-	for (i = 0; i < pci_root_num; i++) {
-		if (pci_root_info[i].bus_min == bus)
-			break;
-	}
+	list_for_each_entry(info, &pci_root_infos, list)
+		if (info->bus_min == bus)
+			return info;
+
+	return NULL;
+}
 
-	if (i == pci_root_num)
+void x86_pci_root_bus_resources(int bus, struct list_head *resources)
+{
+	struct pci_root_info *info = x86_find_pci_root_info(bus);
+	struct pci_root_res *root_res;
+
+	if (!info)
 		goto default_resources;
 
 	printk(KERN_DEBUG "PCI: root bus %02x: hardware-probed resources\n",
 	       bus);
 
-	info = &pci_root_info[i];
-	for (j = 0; j < info->res_num; j++) {
+	list_for_each_entry(root_res, &info->resources, list) {
 		struct resource *res;
 		struct resource *root;
 
-		res = &info->res[j];
+		res = &root_res->res;
 		pci_add_resource(resources, res);
 		if (res->flags & IORESOURCE_IO)
 			root = &ioport_resource;
@@ -53,11 +56,32 @@ default_resources:
 	pci_add_resource(resources, &iomem_resource);
 }
 
+struct pci_root_info __init *alloc_pci_root_info(int bus_min, int bus_max,
+						 int node, int link)
+{
+	struct pci_root_info *info;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+
+	if (!info)
+		return info;
+
+	INIT_LIST_HEAD(&info->resources);
+	info->bus_min = bus_min;
+	info->bus_max = bus_max;
+	info->node = node;
+	info->link = link;
+
+	list_add_tail(&info->list, &pci_root_infos);
+
+	return info;
+}
+
 void __devinit update_res(struct pci_root_info *info, resource_size_t start,
 			  resource_size_t end, unsigned long flags, int merge)
 {
-	int i;
 	struct resource *res;
+	struct pci_root_res *root_res;
 
 	if (start > end)
 		return;
@@ -69,11 +93,11 @@ void __devinit update_res(struct pci_root_info *info, resource_size_t start,
 		goto addit;
 
 	/* try to merge it with old one */
-	for (i = 0; i < info->res_num; i++) {
+	list_for_each_entry(root_res, &info->resources, list) {
 		resource_size_t final_start, final_end;
 		resource_size_t common_start, common_end;
 
-		res = &info->res[i];
+		res = &root_res->res;
 		if (res->flags != flags)
 			continue;
 
@@ -93,14 +117,15 @@ void __devinit update_res(struct pci_root_info *info, resource_size_t start,
 addit:
 
 	/* need to add that */
-	if (info->res_num >= RES_NUM)
+	root_res = kzalloc(sizeof(*root_res), GFP_KERNEL);
+	if (!root_res)
 		return;
 
-	res = &info->res[info->res_num];
+	res = &root_res->res;
 	res->name = info->name;
 	res->flags = flags;
 	res->start = start;
 	res->end = end;
-	res->child = NULL;
-	info->res_num++;
+
+	list_add_tail(&root_res->list, &info->resources);
 }
diff --git a/arch/x86/pci/bus_numa.h b/arch/x86/pci/bus_numa.h
index 804a4b4..226a466 100644
--- a/arch/x86/pci/bus_numa.h
+++ b/arch/x86/pci/bus_numa.h
@@ -4,22 +4,24 @@
  * sub bus (transparent) will use entres from 3 to store extra from
  * root, so need to make sure we have enough slot there.
  */
-#define RES_NUM 16
+struct pci_root_res {
+	struct list_head list;
+	struct resource res;
+};
+
 struct pci_root_info {
+	struct list_head list;
 	char name[12];
-	unsigned int res_num;
-	struct resource res[RES_NUM];
+	struct list_head resources;
 	int bus_min;
 	int bus_max;
 	int node;
 	int link;
 };
 
-/* 4 at this time, it may become to 32 */
-#define PCI_ROOT_NR 4
-extern int pci_root_num;
-extern struct pci_root_info pci_root_info[PCI_ROOT_NR];
-
+extern struct list_head pci_root_infos;
+struct pci_root_info *alloc_pci_root_info(int bus_min, int bus_max,
+						int node, int link);
 extern void update_res(struct pci_root_info *info, resource_size_t start,
 		      resource_size_t end, unsigned long flags, int merge);
 #endif
-- 
1.7.7

