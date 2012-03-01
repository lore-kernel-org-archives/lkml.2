Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932824Ab2CADDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 22:03:15 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:34298 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758427Ab2CADDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 22:03:08 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 14/36] x86, PCI: Merge pcibios_scan_root and pci_scan_bus_on_node
Date: Wed, 29 Feb 2012 19:00:15 -0800
Message-Id: <1330570837-26638-15-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330570837-26638-1-git-send-email-yinghai@kernel.org>
References: <1330570837-26638-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090209.4F4EE682.002E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those two almost the same.
Let pcibios_scan_root call pci_scan_bus_on_node instead.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/common.c |   27 ++++-----------------------
 1 files changed, 4 insertions(+), 23 deletions(-)

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 323481e..8e04ec5 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -430,9 +430,7 @@ void __init dmi_check_pciprobe(void)
 
 struct pci_bus * __devinit pcibios_scan_root(int busnum)
 {
-	LIST_HEAD(resources);
 	struct pci_bus *bus = NULL;
-	struct pci_sysdata *sd;
 
 	while ((bus = pci_find_next_bus(bus)) != NULL) {
 		if (bus->number == busnum) {
@@ -441,28 +439,10 @@ struct pci_bus * __devinit pcibios_scan_root(int busnum)
 		}
 	}
 
-	/* Allocate per-root-bus (not per bus) arch-specific data.
-	 * TODO: leak; this memory is never freed.
-	 * It's arguable whether it's worth the trouble to care.
-	 */
-	sd = kzalloc(sizeof(*sd), GFP_KERNEL);
-	if (!sd) {
-		printk(KERN_ERR "PCI: OOM, not probing PCI bus %02x\n", busnum);
-		return NULL;
-	}
-
-	sd->node = get_mp_bus_to_node(busnum);
-
-	printk(KERN_DEBUG "PCI: Probing PCI hardware (bus %02x)\n", busnum);
-	x86_pci_root_bus_resources(busnum, &resources);
-	bus = pci_scan_root_bus(NULL, busnum, &pci_root_ops, sd, &resources);
-	if (!bus) {
-		pci_free_resource_list(&resources);
-		kfree(sd);
-	}
-
-	return bus;
+	return pci_scan_bus_on_node(busnum, &pci_root_ops,
+					get_mp_bus_to_node(busnum));
 }
+
 void __init pcibios_set_cache_line_size(void)
 {
 	struct cpuinfo_x86 *c = &boot_cpu_data;
@@ -656,6 +636,7 @@ struct pci_bus * __devinit pci_scan_bus_on_node(int busno, struct pci_ops *ops,
 	}
 	sd->node = node;
 	x86_pci_root_bus_resources(busno, &resources);
+	printk(KERN_DEBUG "PCI: Probing PCI hardware (bus %02x)\n", busno);
 	bus = pci_scan_root_bus(NULL, busno, ops, sd, &resources);
 	if (!bus) {
 		pci_free_resource_list(&resources);
-- 
1.7.7

