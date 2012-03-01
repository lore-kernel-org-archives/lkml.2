Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890Ab2CADJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 22:09:49 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:32222 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab2CADCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 22:02:08 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 22/36] x86, PCI: add busn into resources list for acpi path
Date: Wed, 29 Feb 2012 19:00:23 -0800
Message-Id: <1330570837-26638-23-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330570837-26638-1-git-send-email-yinghai@kernel.org>
References: <1330570837-26638-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4F4EE68B.0069,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

will put it in resources list and pass it for create_root_bus

Bjorn thought that we should just use that in acpi_root.

Suggested-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/acpi.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 2331ccb..5178917 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -12,7 +12,6 @@ struct pci_root_info {
 	char name[16];
 	unsigned int res_num;
 	struct resource *res;
-	int busnum;
 	struct pci_sysdata sd;
 };
 
@@ -347,7 +346,9 @@ probe_pci_root_info(struct pci_root_info *info, struct acpi_device *device,
 {
 	size_t size;
 
+	sprintf(info->name, "PCI Bus %04x:%02x", domain, busnum);
 	info->bridge = device;
+
 	info->res_num = 0;
 	acpi_walk_resources(device->handle, METHOD_NAME__CRS, count_resource,
 				info);
@@ -360,8 +361,6 @@ probe_pci_root_info(struct pci_root_info *info, struct acpi_device *device,
 	if (!info->res)
 		return;
 
-	sprintf(info->name, "PCI Bus %04x:%02x", domain, busnum);
-
 	acpi_walk_resources(device->handle, METHOD_NAME__CRS, setup_resource,
 				info);
 }
@@ -430,9 +429,11 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
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

