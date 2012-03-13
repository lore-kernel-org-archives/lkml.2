Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759954Ab2CMH3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 03:29:32 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:49760 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759937Ab2CMH2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 03:28:35 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 11/12] PCI, cphi_hotplug: Simplify configure_slot
Date: Tue, 13 Mar 2012 00:26:33 -0700
Message-Id: <1331623594-30543-12-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331623594-30543-1-git-send-email-yinghai@kernel.org>
References: <1331623594-30543-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090202.4F5EF720.00C4,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For child p2p bridge hotplug support should use pci_scan_bridge instead.

Make it more simillar to pciehp, just use pci_hp_add_bridge()

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/hotplug/cpci_hotplug_pci.c |   35 +++++--------------------------
 1 files changed, 6 insertions(+), 29 deletions(-)

diff --git a/drivers/pci/hotplug/cpci_hotplug_pci.c b/drivers/pci/hotplug/cpci_hotplug_pci.c
index 4ef80ad..dcc75c7 100644
--- a/drivers/pci/hotplug/cpci_hotplug_pci.c
+++ b/drivers/pci/hotplug/cpci_hotplug_pci.c
@@ -285,42 +285,19 @@ int __ref cpci_configure_slot(struct slot *slot)
 	for (fn = 0; fn < 8; fn++) {
 		struct pci_dev *dev;
 
-		dev = pci_get_slot(parent, PCI_DEVFN(PCI_SLOT(slot->devfn), fn));
+		dev = pci_get_slot(parent,
+				   PCI_DEVFN(PCI_SLOT(slot->devfn), fn));
 		if (!dev)
 			continue;
 		if ((dev->hdr_type == PCI_HEADER_TYPE_BRIDGE) ||
-		    (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)) {
-			/* Find an unused bus number for the new bridge */
-			struct pci_bus *child;
-			unsigned char busnr, start = parent->secondary;
-			unsigned char end = parent->subordinate;
-
-			for (busnr = start; busnr <= end; busnr++) {
-				if (!pci_find_bus(pci_domain_nr(parent),
-						  busnr))
-					break;
-			}
-			if (busnr >= end) {
-				err("No free bus for hot-added bridge\n");
-				pci_dev_put(dev);
-				continue;
-			}
-			child = pci_add_new_bus(parent, dev, busnr);
-			if (!child) {
-				err("Cannot add new bus for %s\n",
-				    pci_name(dev));
-				pci_dev_put(dev);
-				continue;
-			}
-			child->subordinate = pci_do_scan_bus(child);
-			pci_bus_size_bridges_with_self(child);
-		}
+		    (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS))
+			pci_hp_add_bridge(dev);
 		pci_dev_put(dev);
 	}
 
-	pci_bus_assign_resources(parent);
+	pci_assign_unassigned_bridge_resources(parent->self);
+
 	pci_bus_add_devices(parent);
-	pci_enable_bridges(parent);
 
 	dbg("%s - exit", __func__);
 	return 0;
-- 
1.7.7

