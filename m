Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab2B2XIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 18:08:20 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:25463 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab2B2XIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 18:08:17 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 07/39] x86, PCI: break down get_current_resource()
Date: Wed, 29 Feb 2012 15:07:06 -0800
Message-Id: <1330556858-11768-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330556858-11768-1-git-send-email-yinghai@kernel.org>
References: <1330556858-11768-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090208.4F4EAFDA.002D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change it to probe_pci_root_info, aka only do one thing.

1. remove resource list head from pci_root_info
2. make get_current_resources() not pass resources
   move out add_resources calling out of yet.
3. rename get_current_resourcs name to probe_pci_root_info

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/acpi.c |   34 +++++++++++++---------------------
 1 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 304ccf0..763f7bb 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -12,7 +12,6 @@ struct pci_root_info {
 	char *name;
 	unsigned int res_num;
 	struct resource *res;
-	struct list_head *resources;
 	int busnum;
 };
 
@@ -277,7 +276,8 @@ static void coalesce_windows(struct pci_root_info *info, unsigned long type)
 	}
 }
 
-static void add_resources(struct pci_root_info *info)
+static void add_resources(struct pci_root_info *info,
+			  struct list_head *resources)
 {
 	int i;
 	struct resource *res, *root, *conflict;
@@ -301,7 +301,7 @@ static void add_resources(struct pci_root_info *info)
 				 "ignoring host bridge window %pR (conflicts with %s %pR)\n",
 				 res, conflict->name, conflict);
 		else
-			pci_add_resource(info->resources, res);
+			pci_add_resource(resources, res);
 	}
 }
 
@@ -313,41 +313,30 @@ static void free_pci_root_info(struct pci_root_info *info)
 }
 
 static void
-get_current_resources(struct pci_root_info *info,
-		      struct acpi_device *device, int busnum,
-		      int domain, struct list_head *resources)
+probe_pci_root_info(struct pci_root_info *info, struct acpi_device *device,
+		    int busnum, int domain)
 {
 	size_t size;
 
 	info->bridge = device;
 	info->res_num = 0;
-	info->resources = resources;
 	acpi_walk_resources(device->handle, METHOD_NAME__CRS, count_resource,
 				info);
 	if (!info->res_num)
 		return;
 
 	size = sizeof(*info->res) * info->res_num;
+	info->res_num = 0;
 	info->res = kmalloc(size, GFP_KERNEL);
 	if (!info->res)
 		return;
 
 	info->name = kasprintf(GFP_KERNEL, "PCI Bus %04x:%02x", domain, busnum);
 	if (!info->name)
-		goto name_alloc_fail;
+		return;
 
-	info->res_num = 0;
 	acpi_walk_resources(device->handle, METHOD_NAME__CRS, setup_resource,
 				info);
-
-	if (pci_use_crs) {
-		add_resources(info);
-
-		return;
-	}
-
-name_alloc_fail:
-	free_pci_root_info(info);
 }
 
 struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
@@ -412,15 +401,18 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 		memcpy(bus->sysdata, sd, sizeof(*sd));
 		kfree(sd);
 	} else {
-		get_current_resources(&info, device, busnum, domain,
-					&resources);
+		probe_pci_root_info(&info, device, busnum, domain);
 
 		/*
 		 * _CRS with no apertures is normal, so only fall back to
 		 * defaults or native bridge info if we're ignoring _CRS.
 		 */
-		if (!pci_use_crs)
+		if (pci_use_crs)
+			add_resources(&info, &resources);
+		else {
+			free_pci_root_info(&info);
 			x86_pci_root_bus_resources(busnum, &resources);
+		}
 		bus = pci_create_root_bus(NULL, busnum, &pci_root_ops, sd,
 					  &resources);
 		if (bus)
-- 
1.7.7

