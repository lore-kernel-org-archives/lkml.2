Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab2B1WJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 17:09:56 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:28512 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757393Ab2B1WJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 17:09:52 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 10/24] x86, PCI: put busn resource in pci_root_info for acpi path
Date: Tue, 28 Feb 2012 14:07:29 -0800
Message-Id: <1330466863-28469-11-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330466863-28469-1-git-send-email-yinghai@kernel.org>
References: <1330466863-28469-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090206.4F4D50A5.00E7,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

will put it in resources list and pass it for create_root_bus

-v2: still have busn setting when no host bridge window setting from ACPI.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/acpi.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 7538fad..2eafc2a 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -12,7 +12,7 @@ struct pci_root_info {
 	char name[16];
 	unsigned int res_num;
 	struct resource *res;
-	int busnum;
+	struct resource busn;
 };
 
 static bool pci_use_crs = true;
@@ -282,6 +282,9 @@ static void add_resources(struct pci_root_info *info,
 	int i;
 	struct resource *res, *root, *conflict;
 
+	if (info->busn.flags & IORESOURCE_BUS)
+		pci_add_resource(resources, &info->busn);
+
 	coalesce_windows(info, IORESOURCE_MEM);
 	coalesce_windows(info, IORESOURCE_IO);
 
@@ -339,11 +342,16 @@ static void release_pci_root_info(struct pci_host_bridge *bridge)
 
 static void
 probe_pci_root_info(struct pci_root_info *info, struct acpi_device *device,
-		    int busnum, int domain)
+		    int busnum, int busmax, int domain)
 {
 	size_t size;
 
+	sprintf(info->name, "PCI Bus %04x:%02x", domain, busnum);
 	info->bridge = device;
+	info->busn.start = busnum;
+	info->busn.end = busmax;
+	info->busn.flags = IORESOURCE_BUS;
+
 	info->res_num = 0;
 	acpi_walk_resources(device->handle, METHOD_NAME__CRS, count_resource,
 				info);
@@ -356,8 +364,6 @@ probe_pci_root_info(struct pci_root_info *info, struct acpi_device *device,
 	if (!info->res)
 		return;
 
-	sprintf(info->name, "PCI Bus %04x:%02x", domain, busnum);
-
 	acpi_walk_resources(device->handle, METHOD_NAME__CRS, setup_resource,
 				info);
 }
@@ -368,6 +374,7 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 	struct pci_root_info *info = NULL;
 	int domain = root->segment;
 	int busnum = root->secondary.start;
+	int busmax = root->secondary.end;
 	LIST_HEAD(resources);
 	struct pci_bus *bus;
 	struct pci_sysdata *sd;
@@ -426,7 +433,7 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 		kfree(info);
 		kfree(sd);
 	} else {
-		probe_pci_root_info(info, device, busnum, domain);
+		probe_pci_root_info(info, device, busnum, busmax, domain);
 
 		/*
 		 * _CRS with no apertures is normal, so only fall back to
-- 
1.7.7

