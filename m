Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab2CSFlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:41:24 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:26104 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab2CSFlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:41:22 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v3 02/11] x86, PCI: Fix memleak with get_current_resources()
Date: Sun, 18 Mar 2012 22:40:15 -0700
Message-Id: <1332135624-13528-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332135624-13528-1-git-send-email-yinghai@kernel.org>
References: <1332135624-13528-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090201.4F66C6FE.0020,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In pci_scan_acpi_root(), when pci_use_crs is set, get_current_resources() is
used to get pci_root_info, and it will allocate name and resource array.

Later if pci_create_root_bus() can not create bus (could be already there...)
it will only free bus res list, but the name and res array is not freed.

Let get_current_resource() take info pointer instead of using local info.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/acpi.c |   49 ++++++++++++++++++++++++++++++-------------------
 1 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index ed2835e..a99b7d7 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -315,49 +315,55 @@ static void add_resources(struct pci_root_info *info)
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
@@ -402,6 +408,7 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 
 	sd->domain = domain;
 	sd->node = node;
+	memset(&info, 0, sizeof(struct pci_root_info));
 	/*
 	 * Maybe the desired pci bus has been already scanned. In such case
 	 * it is unnecessary to scan the pci bus with the given domain,busnum.
@@ -415,7 +422,8 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 		memcpy(bus->sysdata, sd, sizeof(*sd));
 		kfree(sd);
 	} else {
-		get_current_resources(device, busnum, domain, &resources);
+		get_current_resources(&info, device, busnum, domain,
+					&resources);
 
 		/*
 		 * _CRS with no apertures is normal, so only fall back to
@@ -429,6 +437,9 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 			bus->subordinate = pci_scan_child_bus(bus);
 		else
 			pci_free_resource_list(&resources);
+
+		if (!bus && pci_use_crs)
+			free_pci_root_info(&info);
 	}
 
 	/* After the PCI-E bus has been walked and all devices discovered,
-- 
1.7.7

