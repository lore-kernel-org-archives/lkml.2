Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab2EGUal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:30:41 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:51068 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255Ab2EGUaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:30:35 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 13/21] x86/PCI: add busn_res into resources list for ACPI path
Date: Mon,  7 May 2012 13:29:58 -0700
Message-Id: <1336422606-4244-14-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
References: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the host bridge bus number aperture from _CRS to the resource list.
Like the MMIO and I/O port apertures, this will be used when assigning
resources to hot-added devices or in the case of conflicts.

Always insert that even pci_use_crs is not used.

[bhelgaas: rewrite changelog]
Suggested-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/acpi.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 350fe63..2bb885a 100644
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
@@ -426,6 +425,8 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 	} else {
 		probe_pci_root_info(info, device, busnum, domain);
 
+		/* insert busn res at first */
+		pci_add_resource(&resources,  &root->secondary);
 		/*
 		 * _CRS with no apertures is normal, so only fall back to
 		 * defaults or native bridge info if we're ignoring _CRS.
@@ -440,7 +441,7 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 		bus = pci_create_root_bus(NULL, busnum, &pci_root_ops, sd,
 					  &resources);
 		if (bus) {
-			bus->busn_res.end = pci_scan_child_bus(bus);
+			pci_scan_child_bus(bus);
 			pci_set_host_bridge_release(
 				to_pci_host_bridge(bus->bridge),
 				release_pci_root_info, info);
-- 
1.7.7

