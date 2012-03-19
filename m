Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551Ab2CSFlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:41:49 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:26928 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757115Ab2CSFlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:41:45 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v3 06/11] x86, PCI: Break down get_current_resource()
Date: Sun, 18 Mar 2012 22:40:19 -0700
Message-Id: <1332135624-13528-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332135624-13528-1-git-send-email-yinghai@kernel.org>
References: <1332135624-13528-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4F66C716.0017,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change it to probe_pci_root_info, aka only do one thing.

1. Remove resource list head from pci_root_info
2. Make get_current_resources() not to pass resources
3. Rename get_current_resourcs name to probe_pci_root_info

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/acpi.c |   34 +++++++++++++---------------------
 1 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index a99b7d7..a858c1d 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -12,7 +12,6 @@ struct pci_root_info {
 	char *name;
 	unsigned int res_num;
 	struct resource *res;
-	struct list_head *resources;
 	int busnum;
 };
 
@@ -287,7 +286,8 @@ static void coalesce_windows(struct pci_root_info *info, unsigned long type)
 	}
 }
 
-static void add_resources(struct pci_root_info *info)
+static void add_resources(struct pci_root_info *info,
+			  struct list_head *resources)
 {
 	int i;
 	struct resource *res, *root, *conflict;
@@ -311,7 +311,7 @@ static void add_resources(struct pci_root_info *info)
 				 "ignoring host bridge window %pR (conflicts with %s %pR)\n",
 				 res, conflict->name, conflict);
 		else
-			pci_add_resource(info->resources, res);
+			pci_add_resource(resources, res);
 	}
 }
 
@@ -323,41 +323,30 @@ static void free_pci_root_info(struct pci_root_info *info)
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
@@ -422,15 +411,18 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
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

