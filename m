Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161684Ab2CSFsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:48:23 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30858 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161609Ab2CSFsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:48:17 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v3 36/47] PCI, shpchp: Simplify configure_device
Date: Sun, 18 Mar 2012 22:46:25 -0700
Message-Id: <1332135996-13860-37-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
References: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4F66C89E.005A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For child p2p bridge hotplug support should use pci_scan_bridge instead.

Make it more simillar to pciehp, just use pci_hp_add_bridge()

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/hotplug/shpchp_pci.c |   45 ++++++++++++-------------------------
 1 files changed, 15 insertions(+), 30 deletions(-)

diff --git a/drivers/pci/hotplug/shpchp_pci.c b/drivers/pci/hotplug/shpchp_pci.c
index d92807b..c627ed9 100644
--- a/drivers/pci/hotplug/shpchp_pci.c
+++ b/drivers/pci/hotplug/shpchp_pci.c
@@ -37,9 +37,10 @@
 int __ref shpchp_configure_device(struct slot *p_slot)
 {
 	struct pci_dev *dev;
-	struct pci_bus *parent = p_slot->ctrl->pci_dev->subordinate;
-	int num, fn;
 	struct controller *ctrl = p_slot->ctrl;
+	struct pci_dev *bridge = ctrl->pci_dev;
+	struct pci_bus *parent = bridge->subordinate;
+	int num, fn;
 
 	dev = pci_get_slot(parent, PCI_DEVFN(p_slot->device, 0));
 	if (dev) {
@@ -61,39 +62,23 @@ int __ref shpchp_configure_device(struct slot *p_slot)
 		if (!dev)
 			continue;
 		if ((dev->hdr_type == PCI_HEADER_TYPE_BRIDGE) ||
-				(dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)) {
-			/* Find an unused bus number for the new bridge */
-			struct pci_bus *child;
-			unsigned char busnr, start = parent->secondary;
-			unsigned char end = parent->subordinate;
-			for (busnr = start; busnr <= end; busnr++) {
-				if (!pci_find_bus(pci_domain_nr(parent),
-							busnr))
-					break;
-			}
-			if (busnr > end) {
-				ctrl_err(ctrl,
-					 "No free bus for hot-added bridge\n");
-				pci_dev_put(dev);
-				continue;
-			}
-			child = pci_add_new_bus(parent, dev, busnr);
-			if (!child) {
-				ctrl_err(ctrl, "Cannot add new bus for %s\n",
-					 pci_name(dev));
-				pci_dev_put(dev);
-				continue;
-			}
-			child->subordinate = pci_do_scan_bus(child);
-			pci_bus_size_bridges_with_self(child);
-		}
+		    (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS))
+			pci_hp_add_bridge(dev);
+		pci_dev_put(dev);
+	}
+
+	pci_assign_unassigned_bridge_resources(bridge);
+
+	for (fn = 0; fn < 8; fn++) {
+		dev = pci_get_slot(parent, PCI_DEVFN(p_slot->device, fn));
+		if (!dev)
+			continue;
 		pci_configure_slot(dev);
 		pci_dev_put(dev);
 	}
 
-	pci_bus_assign_resources(parent);
 	pci_bus_add_devices(parent);
-	pci_enable_bridges(parent);
+
 	return 0;
 }
 
-- 
1.7.7

