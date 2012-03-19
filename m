Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699Ab2CSFly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:41:54 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:26268 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757115Ab2CSFlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:41:51 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v3 07/11] x86, PCI: Add host bridge resource release for _CRS path
Date: Sun, 18 Mar 2012 22:40:20 -0700
Message-Id: <1332135624-13528-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332135624-13528-1-git-send-email-yinghai@kernel.org>
References: <1332135624-13528-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4F66C71C.006B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Allocate pci_root_info instead of use local stack. we need to pass around
   info for release fn.
2. Add release_pci_root_info
3. Set x86 own host bridge release fn, so will make sure root bridge
   related resources get freed during root bus removal.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/acpi.c |   63 +++++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 51 insertions(+), 12 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index a858c1d..2b74a16 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -315,11 +315,40 @@ static void add_resources(struct pci_root_info *info,
 	}
 }
 
-static void free_pci_root_info(struct pci_root_info *info)
+static void free_pci_root_info_res(struct pci_root_info *info)
 {
 	kfree(info->name);
 	kfree(info->res);
-	memset(info, 0, sizeof(struct pci_root_info));
+	info->res = NULL;
+	info->res_num = 0;
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
+	free_pci_root_info_res(info);
+
+	kfree(info);
+}
+static void release_pci_root_info(struct pci_host_bridge *bridge)
+{
+	struct pci_root_info *info = bridge->release_data;
+
+	__release_pci_root_info(info);
 }
 
 static void
@@ -352,7 +381,7 @@ probe_pci_root_info(struct pci_root_info *info, struct acpi_device *device,
 struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 {
 	struct acpi_device *device = root->device;
-	struct pci_root_info info;
+	struct pci_root_info *info = NULL;
 	int domain = root->segment;
 	int busnum = root->secondary.start;
 	LIST_HEAD(resources);
@@ -397,7 +426,13 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 
 	sd->domain = domain;
 	sd->node = node;
-	memset(&info, 0, sizeof(struct pci_root_info));
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info) {
+		kfree(sd);
+		printk(KERN_WARNING "pci_bus %04x:%02x: "
+		       "ignored (out of memory)\n", domain, busnum);
+		return NULL;
+	}
 	/*
 	 * Maybe the desired pci bus has been already scanned. In such case
 	 * it is unnecessary to scan the pci bus with the given domain,busnum.
@@ -409,29 +444,33 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
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
+			free_pci_root_info_res(info);
 			x86_pci_root_bus_resources(busnum, &resources);
 		}
+
 		bus = pci_create_root_bus(NULL, busnum, &pci_root_ops, sd,
 					  &resources);
-		if (bus)
+		if (bus) {
 			bus->subordinate = pci_scan_child_bus(bus);
-		else
+			pci_set_host_bridge_release(
+				to_pci_host_bridge(bus->bridge),
+				release_pci_root_info, info);
+		} else {
 			pci_free_resource_list(&resources);
-
-		if (!bus && pci_use_crs)
-			free_pci_root_info(&info);
+			__release_pci_root_info(info);
+		}
 	}
 
 	/* After the PCI-E bus has been walked and all devices discovered,
-- 
1.7.7

