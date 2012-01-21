Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754Ab2AUKY6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 05:24:58 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:17450 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab2AUKY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 05:24:27 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [RFC PATCH 3/3] PCI: kill pci_fixup_parent_subordinate_busnr()
Date: Sat, 21 Jan 2012 02:24:08 -0800
Message-Id: <1327141448-15281-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1327141448-15281-1-git-send-email-yinghai@kernel.org>
References: <1327141448-15281-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4F1A9258.0001,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we can safely extend parent top and shrink them according iobusn_resource tree.

Don't need that any more.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |   45 +++++++++------------------------------------
 1 files changed, 9 insertions(+), 36 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index e20fe45..85cb6d0 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -608,22 +608,6 @@ struct pci_bus *__ref pci_add_new_bus(struct pci_bus *parent, struct pci_dev *de
 	return child;
 }
 
-static void pci_fixup_parent_subordinate_busnr(struct pci_bus *child, int max)
-{
-	struct pci_bus *parent = child->parent;
-
-	/* Attempts to fix that up are really dangerous unless
-	   we're going to re-assign all bus numbers. */
-	if (!pcibios_assign_all_busses())
-		return;
-
-	while (parent->parent && parent->subordinate < max) {
-		parent->subordinate = max;
-		pci_write_config_byte(parent->self, PCI_SUBORDINATE_BUS, max);
-		parent = parent->parent;
-	}
-}
-
 static void __devinit pci_bus_extend_top(struct pci_bus *parent,
 		 resource_size_t needed_size, struct resource *parent_res)
 {
@@ -866,6 +850,13 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 		/* Clear errors */
 		pci_write_config_word(dev, PCI_STATUS, 0xffff);
 
+		/*
+		 * For CardBus bridges, we leave 4 bus numbers
+		 * as cards with a PCI-to-PCI bridge can be
+		 * inserted later.
+		 * other just allocate 8 bus to avoid we fall into
+		 *  small hole in the middle.
+		 */
 		ret = pci_bridge_probe_busn_res(bus, dev, &busn_res,
 				is_cardbus ? (CARDBUS_RESERVE_BUSNR + 1) : 8,
 				&parent_res);
@@ -907,29 +898,11 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 
 		if (!is_cardbus) {
 			child->bridge_ctl = bctl;
-			/*
-			 * Adjust subordinate busnr in parent buses.
-			 * We do this before scanning for children because
-			 * some devices may not be detected if the bios
-			 * was lazy.
-			 */
-			pci_fixup_parent_subordinate_busnr(child, max);
+
 			/* Now we can scan all subordinate buses... */
 			max = pci_scan_child_bus(child);
-			/*
-			 * now fix it up again since we have found
-			 * the real value of max.
-			 */
-			pci_fixup_parent_subordinate_busnr(child, max);
-
-		} else {
-			/*
-			 * For CardBus bridges, we leave 4 bus numbers
-			 * as cards with a PCI-to-PCI bridge can be
-			 * inserted later.
-			 */
-			pci_fixup_parent_subordinate_busnr(child, max);
 		}
+
 		/*
 		 * Set the subordinate bus number to its real value.
 		 */
-- 
1.7.7

