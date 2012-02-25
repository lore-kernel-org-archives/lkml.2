Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab2BYHda (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 02:33:30 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:30593 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab2BYHd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 02:33:29 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH] x86, PCI: Fix memleak in theory with get_current_resources
Date: Fri, 24 Feb 2012 23:33:03 -0800
Message-Id: <1330155183-15201-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4F488EC7.003B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in pci_scan_acpi_root, when pci_use_crs is set, get_current_resources is used
to get pci_root_info, and it will allocate name and res array.

later if pci_create_root_bus can not create bus (could be already there...)
it will only free bus res list. but the name and res array is not freed.

let get_current_resource take info pointer instead have local info.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>

---
 arch/x86/pci/acpi.c |   49 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 19 deletions(-)

Index: linux-2.6/arch/x86/pci/acpi.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/acpi.c
+++ linux-2.6/arch/x86/pci/acpi.c
@@ -305,49 +305,55 @@ static void add_resources(struct pci_roo
 	}
 }
 
+static void free_pci_root_info(struct pci_root_info *info)
+{
+	kfree(info->name);
+	kfree(info->res);
+	memset(info, 0, sizeof(struct pci_root_info));
+}
+
 static void
-get_current_resources(struct acpi_device *device, int busnum,
+get_current_resources(struct pci_root_info *info,
+		      struct acpi_device *device, int busnum,
 		      int domain, struct list_head *resources)
 {
-	struct pci_root_info info;
 	size_t size;
 
-	info.bridge = device;
-	info.res_num = 0;
-	info.resources = resources;
+	info->bridge = device;
+	info->res_num = 0;
+	info->resources = resources;
 	acpi_walk_resources(device->handle, METHOD_NAME__CRS, count_resource,
-				&info);
-	if (!info.res_num)
+				info);
+	if (!info->res_num)
 		return;
 
-	size = sizeof(*info.res) * info.res_num;
-	info.res = kmalloc(size, GFP_KERNEL);
-	if (!info.res)
+	size = sizeof(*info->res) * info->res_num;
+	info->res = kmalloc(size, GFP_KERNEL);
+	if (!info->res)
 		return;
 
-	info.name = kasprintf(GFP_KERNEL, "PCI Bus %04x:%02x", domain, busnum);
-	if (!info.name)
+	info->name = kasprintf(GFP_KERNEL, "PCI Bus %04x:%02x", domain, busnum);
+	if (!info->name)
 		goto name_alloc_fail;
 
-	info.res_num = 0;
+	info->res_num = 0;
 	acpi_walk_resources(device->handle, METHOD_NAME__CRS, setup_resource,
-				&info);
+				info);
 
 	if (pci_use_crs) {
-		add_resources(&info);
+		add_resources(info);
 
 		return;
 	}
 
-	kfree(info.name);
-
 name_alloc_fail:
-	kfree(info.res);
+	free_pci_root_info(info);
 }
 
 struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 {
 	struct acpi_device *device = root->device;
+	struct pci_root_info info;
 	int domain = root->segment;
 	int busnum = root->secondary.start;
 	LIST_HEAD(resources);
@@ -392,6 +398,7 @@ struct pci_bus * __devinit pci_acpi_scan
 
 	sd->domain = domain;
 	sd->node = node;
+	memset(&info, 0, sizeof(struct pci_root_info));
 	/*
 	 * Maybe the desired pci bus has been already scanned. In such case
 	 * it is unnecessary to scan the pci bus with the given domain,busnum.
@@ -405,7 +412,8 @@ struct pci_bus * __devinit pci_acpi_scan
 		memcpy(bus->sysdata, sd, sizeof(*sd));
 		kfree(sd);
 	} else {
-		get_current_resources(device, busnum, domain, &resources);
+		get_current_resources(&info, device, busnum, domain,
+					&resources);
 
 		/*
 		 * _CRS with no apertures is normal, so only fall back to
@@ -419,6 +427,9 @@ struct pci_bus * __devinit pci_acpi_scan
 			bus->subordinate = pci_scan_child_bus(bus);
 		else
 			pci_free_resource_list(&resources);
+
+		if (!bus && pci_use_crs)
+			free_pci_root_info(&info);
 	}
 
 	/* After the PCI-E bus has been walked and all devices discovered,
