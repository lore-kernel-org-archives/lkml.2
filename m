Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab2B1CLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 21:11:20 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:43131 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab2B1CLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 21:11:16 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 01/18] x86, PCI: Merge pcibios_scan_root and pci_scan_bus_on_node
Date: Mon, 27 Feb 2012 18:09:52 -0800
Message-Id: <1330395009-29260-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330395009-29260-1-git-send-email-yinghai@kernel.org>
References: <1330395009-29260-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090203.4F4C37BC.0065,ss=1,re=0.000,fgs=0
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

