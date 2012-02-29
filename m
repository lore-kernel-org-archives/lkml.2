Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965587Ab2B2XOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 18:14:41 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:26484 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965443Ab2B2XJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 18:09:26 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 17/39] x86, PCI: put busn resource in pci_root_info for acpi path
Date: Wed, 29 Feb 2012 15:07:16 -0800
Message-Id: <1330556858-11768-18-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330556858-11768-1-git-send-email-yinghai@kernel.org>
References: <1330556858-11768-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090206.4F4EAFE2.00AD,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

will put it in resources list and pass it for create_root_bus

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/acpi.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 2331ccb..ff5243e 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -12,7 +12,7 @@ struct pci_root_info {
 	char name[16];
 	unsigned int res_num;
 	struct resource *res;
-	int busnum;
+	struct resource busn;
 	struct pci_sysdata sd;
 };
 
@@ -283,6 +283,9 @@ static void add_resources(struct pci_root_info *info,
 	int i;
 	struct resource *res, *root, *conflict;
 
+	if (info->busn.flags & IORESOURCE_BUS)
+		pci_add_resource(resources, &info->busn);
+
 	coalesce_windows(info, IORESOURCE_MEM);
 	coalesce_windows(info, IORESOURCE_IO);
 
@@ -343,11 +346,17 @@ static void release_pci_root_info(struct pci_host_bridge *bridge)
 
 static void
 probe_pci_root_info(struct pci_root_info *info, struct acpi_device *device,
-		    int busnum, int domain)
+		    int busnum, int busmax, int domain)
 {
 	size_t size;
 
+	sprintf(info->name, "PCI Bus %04x:%02x", domain, busnum);
 	info->bridge = device;
+	info->busn.name = info->name;
+	info->busn.start = busnum;
+	info->busn.end = busmax;
+	info->busn.flags = IORESOURCE_BUS;
+
 	info->res_num = 0;
 	acpi_walk_resources(device->handle, METHOD_NAME__CRS, count_resource,
 				info);
@@ -360,8 +369,6 @@ probe_pci_root_info(struct pci_root_info *info, struct acpi_device *device,
 	if (!info->res)
 		return;
 
-	sprintf(info->name, "PCI Bus %04x:%02x", domain, busnum);
-
 	acpi_walk_resources(device->handle, METHOD_NAME__CRS, setup_resource,
 				info);
 }
@@ -372,6 +379,7 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 	struct pci_root_info *info = NULL;
 	int domain = root->segment;
 	int busnum = root->secondary.start;
+	int busmax = root->secondary.end;
 	LIST_HEAD(resources);
 	struct pci_bus *bus;
 	struct pci_sysdata *sd;
@@ -424,7 +432,7 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 		memcpy(bus->sysdata, sd, sizeof(*sd));
 		kfree(info);
 	} else {
-		probe_pci_root_info(info, device, busnum, domain);
+		probe_pci_root_info(info, device, busnum, busmax, domain);
 
 		/*
 		 * _CRS with no apertures is normal, so only fall back to
-- 
1.7.7

