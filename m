Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874Ab2CSFmJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:42:09 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:26313 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757833Ab2CSFmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:42:03 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v3 09/11] x86, PCI: Embed pci_sysdata into pci_root_info on acpi path
Date: Sun, 18 Mar 2012 22:40:22 -0700
Message-Id: <1332135624-13528-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332135624-13528-1-git-send-email-yinghai@kernel.org>
References: <1332135624-13528-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090201.4F66C729.000A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that part memory will be released on root bus removing path.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/acpi.c |   21 ++++-----------------
 1 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 23e7361..8a17b23 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -13,6 +13,7 @@ struct pci_root_info {
 	unsigned int res_num;
 	struct resource *res;
 	int busnum;
+	struct pci_sysdata sd;
 };
 
 static bool pci_use_crs = true;
@@ -410,26 +411,16 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 	if (node != -1 && !node_online(node))
 		node = -1;
 
-	/* Allocate per-root-bus (not per bus) arch-specific data.
-	 * TODO: leak; this memory is never freed.
-	 * It's arguable whether it's worth the trouble to care.
-	 */
-	sd = kzalloc(sizeof(*sd), GFP_KERNEL);
-	if (!sd) {
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info) {
 		printk(KERN_WARNING "pci_bus %04x:%02x: "
 		       "ignored (out of memory)\n", domain, busnum);
 		return NULL;
 	}
 
+	sd = &info->sd;
 	sd->domain = domain;
 	sd->node = node;
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
-	if (!info) {
-		kfree(sd);
-		printk(KERN_WARNING "pci_bus %04x:%02x: "
-		       "ignored (out of memory)\n", domain, busnum);
-		return NULL;
-	}
 	/*
 	 * Maybe the desired pci bus has been already scanned. In such case
 	 * it is unnecessary to scan the pci bus with the given domain,busnum.
@@ -442,7 +433,6 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 		 */
 		memcpy(bus->sysdata, sd, sizeof(*sd));
 		kfree(info);
-		kfree(sd);
 	} else {
 		probe_pci_root_info(info, device, busnum, domain);
 
@@ -484,9 +474,6 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 		}
 	}
 
-	if (!bus)
-		kfree(sd);
-
 	if (bus && node != -1) {
 #ifdef CONFIG_ACPI_NUMA
 		if (pxm >= 0)
-- 
1.7.7

