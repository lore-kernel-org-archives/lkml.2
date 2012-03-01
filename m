Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab2CADCL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 22:02:11 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:32163 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab2CADCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 22:02:05 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 08/36] x86, PCI: embed name acpi version pci_root_info struct
Date: Wed, 29 Feb 2012 19:00:09 -0800
Message-Id: <1330570837-26638-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330570837-26638-1-git-send-email-yinghai@kernel.org>
References: <1330570837-26638-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090209.4F4EE67D.0030,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now We allocate info, and keep that in during whole life of hostbridge.

So don't allocate info->name seperately, just put name into struct.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/acpi.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index c7a230f..11c3ae7 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -9,7 +9,7 @@
 
 struct pci_root_info {
 	struct acpi_device *bridge;
-	char *name;
+	char name[16];
 	unsigned int res_num;
 	struct resource *res;
 	int busnum;
@@ -307,7 +307,6 @@ static void add_resources(struct pci_root_info *info,
 
 static void free_pci_root_info_res(struct pci_root_info *info)
 {
-	kfree(info->name);
 	kfree(info->res);
 	info->res = NULL;
 	info->res_num = 0;
@@ -360,9 +359,7 @@ probe_pci_root_info(struct pci_root_info *info, struct acpi_device *device,
 	if (!info->res)
 		return;
 
-	info->name = kasprintf(GFP_KERNEL, "PCI Bus %04x:%02x", domain, busnum);
-	if (!info->name)
-		return;
+	sprintf(info->name, "PCI Bus %04x:%02x", domain, busnum);
 
 	acpi_walk_resources(device->handle, METHOD_NAME__CRS, setup_resource,
 				info);
-- 
1.7.7

