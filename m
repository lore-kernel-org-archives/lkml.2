Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab2B1CGC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 21:06:02 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:25685 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab2B1CEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 21:04:52 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 08/11] x86, PCI: add host bridge resource release for using _CRS
Date: Mon, 27 Feb 2012 18:03:48 -0800
Message-Id: <1330394631-28978-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330394631-28978-1-git-send-email-yinghai@kernel.org>
References: <1330394631-28978-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A020207.4F4C3642.0028,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. allocate pci_root_info instead of use local stack. we need to pass around info
   for release fn.
2. add release_pci_root_info
3. set x86 own host bridge release fn, so will make sure root bridge
   related resources get freed during root bus removal.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/acpi.c |   66 +++++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 53 insertions(+), 13 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 763f7bb..208f257 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -309,7 +309,33 @@ static void free_pci_root_info(struct pci_root_info *info)
 {
 	kfree(info->name);
 	kfree(info->res);
-	memset(info, 0, sizeof(struct pci_root_info));
+	kfree(info);
+}
+
+static void __release_pci_root_info(struct pci_root_info *info)
+{
+	int i;
+	struct resource *res;
+
+	for (i = 0; i < info->res_num; i++) {
+		res = &info->res[i];
+
+		if (!res->parent)
+			continue;
+
+		if (!(res->flags & (IORESOURCE_MEM | IORESOURCE_IO)))
+			continue;
+
+		release_resource(res);
+	}
+
+	free_pci_root_info(info);
+}
+static void release_pci_root_info(struct pci_host_bridge *bridge)
+{
+	struct pci_root_info *info = bridge->release_data;
+
+	__release_pci_root_info(info);
 }
 
 static void
@@ -342,7 +368,7 @@ probe_pci_root_info(struct pci_root_info *info, struct acpi_device *device,
 struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 {
 	struct acpi_device *device = root->device;
-	struct pci_root_info info;
+	struct pci_root_info *info = NULL;
 	int domain = root->segment;
 	int busnum = root->secondary.start;
 	LIST_HEAD(resources);
@@ -379,15 +405,16 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 	 * It's arguable whether it's worth the trouble to care.
 	 */
 	sd = kzalloc(sizeof(*sd), GFP_KERNEL);
-	if (!sd) {
-		printk(KERN_WARNING "pci_bus %04x:%02x: "
-		       "ignored (out of memory)\n", domain, busnum);
-		return NULL;
-	}
+	if (!sd)
+		goto out_no_memory;
 
 	sd->domain = domain;
 	sd->node = node;
-	memset(&info, 0, sizeof(struct pci_root_info));
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info) {
+		kfree(sd);
+		goto out_no_memory;
+	}
 	/*
 	 * Maybe the desired pci bus has been already scanned. In such case
 	 * it is unnecessary to scan the pci bus with the given domain,busnum.
@@ -399,20 +426,22 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 		 * be replaced by sd.
 		 */
 		memcpy(bus->sysdata, sd, sizeof(*sd));
+		kfree(info);
 		kfree(sd);
 	} else {
-		probe_pci_root_info(&info, device, busnum, domain);
+		probe_pci_root_info(info, device, busnum, domain);
 
 		/*
 		 * _CRS with no apertures is normal, so only fall back to
 		 * defaults or native bridge info if we're ignoring _CRS.
 		 */
 		if (pci_use_crs)
-			add_resources(&info, &resources);
+			add_resources(info, &resources);
 		else {
-			free_pci_root_info(&info);
+			free_pci_root_info(info);
 			x86_pci_root_bus_resources(busnum, &resources);
 		}
+
 		bus = pci_create_root_bus(NULL, busnum, &pci_root_ops, sd,
 					  &resources);
 		if (bus)
@@ -420,8 +449,14 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 		else
 			pci_free_resource_list(&resources);
 
-		if (!bus && pci_use_crs)
-			free_pci_root_info(&info);
+		if (pci_use_crs) {
+			if (bus)
+				pci_set_host_bridge_release(
+					to_pci_host_bridge(bus->bridge),
+					release_pci_root_info, info);
+			else
+				__release_pci_root_info(info);
+		}
 	}
 
 	/* After the PCI-E bus has been walked and all devices discovered,
@@ -452,6 +487,11 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 	}
 
 	return bus;
+
+out_no_memory:
+	printk(KERN_WARNING "pci_bus %04x:%02x: "
+	       "ignored (out of memory)\n", domain, busnum);
+	return NULL;
 }
 
 int __init pci_acpi_init(void)
-- 
1.7.7

