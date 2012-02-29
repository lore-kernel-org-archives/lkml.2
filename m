Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965917Ab2B2XL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 18:11:56 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:29195 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965631Ab2B2XLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 18:11:54 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 39/39] x86, PCI: kill busn in acpi pci_root_info
Date: Wed, 29 Feb 2012 15:07:38 -0800
Message-Id: <1330556858-11768-40-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330556858-11768-1-git-send-email-yinghai@kernel.org>
References: <1330556858-11768-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090205.4F4EB039.00A0,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn thought that we should just use that in acpi_root.

Suggested-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/acpi.c |   19 ++++++-------------
 1 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index ff5243e..5178917 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -12,7 +12,6 @@ struct pci_root_info {
 	char name[16];
 	unsigned int res_num;
 	struct resource *res;
-	struct resource busn;
 	struct pci_sysdata sd;
 };
 
@@ -283,9 +282,6 @@ static void add_resources(struct pci_root_info *info,
 	int i;
 	struct resource *res, *root, *conflict;
 
-	if (info->busn.flags & IORESOURCE_BUS)
-		pci_add_resource(resources, &info->busn);
-
 	coalesce_windows(info, IORESOURCE_MEM);
 	coalesce_windows(info, IORESOURCE_IO);
 
@@ -346,16 +342,12 @@ static void release_pci_root_info(struct pci_host_bridge *bridge)
 
 static void
 probe_pci_root_info(struct pci_root_info *info, struct acpi_device *device,
-		    int busnum, int busmax, int domain)
+		    int busnum, int domain)
 {
 	size_t size;
 
 	sprintf(info->name, "PCI Bus %04x:%02x", domain, busnum);
 	info->bridge = device;
-	info->busn.name = info->name;
-	info->busn.start = busnum;
-	info->busn.end = busmax;
-	info->busn.flags = IORESOURCE_BUS;
 
 	info->res_num = 0;
 	acpi_walk_resources(device->handle, METHOD_NAME__CRS, count_resource,
@@ -379,7 +371,6 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 	struct pci_root_info *info = NULL;
 	int domain = root->segment;
 	int busnum = root->secondary.start;
-	int busmax = root->secondary.end;
 	LIST_HEAD(resources);
 	struct pci_bus *bus;
 	struct pci_sysdata *sd;
@@ -432,15 +423,17 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 		memcpy(bus->sysdata, sd, sizeof(*sd));
 		kfree(info);
 	} else {
-		probe_pci_root_info(info, device, busnum, busmax, domain);
+		probe_pci_root_info(info, device, busnum, domain);
 
 		/*
 		 * _CRS with no apertures is normal, so only fall back to
 		 * defaults or native bridge info if we're ignoring _CRS.
 		 */
-		if (pci_use_crs)
+		if (pci_use_crs) {
+                       /* insert busn res at first */
+			pci_add_resource(&resources,  &root->secondary);
 			add_resources(info, &resources);
-		else {
+		} else {
 			free_pci_root_info_res(info);
 			x86_pci_root_bus_resources(busnum, &resources);
 		}
-- 
1.7.7

