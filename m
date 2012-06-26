Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278Ab2FZSzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 14:55:53 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:37121 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177Ab2FZSzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 14:55:49 -0400
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
Subject: [PATCH -v12 07/15] PCI: Allocate bus range instead of use max blindly
Date: Tue, 26 Jun 2012 11:54:01 -0700
Message-Id: <1340736849-14875-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1340736849-14875-1-git-send-email-yinghai@kernel.org>
References: <1340736849-14875-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every bus have extra busn_res, and linked them together under root bus busn_res

When need to find usable bus number range, try probe it.

To avoid falling to small hole in the middle, we try from 8 spare bus.
If can not find 8 or more in the middle, will try to append 8 on top later.
then if can not append, will try to find 7 from the middle, then will try to append 7 on top.
then if can not append, will try to find 6 from the middle...

For cardbus will only find 4 spare.

If extend from top, at last will shrink back to really needed range...

-v4: fix checking with pci rescan. Found by Bjorn.
-v5: Use update bridge probe busn_res function and replace_resource

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |  100 ++++++++++++++++++++++++++++-----------------------
 1 files changed, 55 insertions(+), 45 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 7498502..1cae8fe 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -638,9 +638,8 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
 	 * Set up the primary, secondary and subordinate
 	 * bus numbers.
 	 */
-	child->number = child->busn_res.start = busnr;
+	child->number = busnr;
 	child->primary = parent->busn_res.start;
-	child->busn_res.end = 0xff;
 
 	if (!bridge)
 		return child;
@@ -774,10 +773,11 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 {
 	struct pci_bus *child;
 	int is_cardbus = (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS);
-	u32 buses, i, j = 0;
+	u32 buses;
 	u16 bctl;
 	u8 primary, secondary, subordinate;
 	int broken = 0;
+	struct resource *parent_res = NULL;
 
 	pci_read_config_dword(dev, PCI_PRIMARY_BUS, &buses);
 	primary = buses & 0xFF;
@@ -794,10 +794,11 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 
 	/* Check if setup is sensible at all */
 	if (!pass &&
-	    (primary != bus->number || secondary <= bus->number)) {
-		dev_dbg(&dev->dev, "bus configuration invalid, reconfiguring\n");
+	    (primary != bus->number || secondary <= bus->number))
 		broken = 1;
-	}
+
+	if (broken)
+		dev_dbg(&dev->dev, "bus configuration invalid, reconfiguring\n");
 
 	/* Disable MasterAbortMode during probing to avoid reporting
 	   of bus errors (in some architectures) */ 
@@ -842,6 +843,11 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 		 * We need to assign a number to this bus which we always
 		 * do in the second pass.
 		 */
+		long shrink_size;
+		struct resource busn_res;
+		int ret = -ENOMEM;
+		int old_max = max;
+
 		if (!pass) {
 			if (pcibios_assign_all_busses() || broken)
 				/* Temporarily disable forwarding of the
@@ -858,21 +864,42 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 		/* Clear errors */
 		pci_write_config_word(dev, PCI_STATUS, 0xffff);
 
-		/* Prevent assigning a bus number that already exists.
-		 * This can happen when a bridge is hot-plugged, so in
-		 * this case we only re-scan this bus. */
-		child = pci_find_bus(pci_domain_nr(bus), max+1);
-		if (!child) {
-			child = pci_add_new_bus(bus, dev, ++max);
-			if (!child)
-				goto out;
-			pci_bus_insert_busn_res(child, max, 0xff);
+		if (dev->subordinate) {
+			/* We get here only for cardbus */
+			child = dev->subordinate;
+			if  (!is_cardbus)
+				dev_warn(&dev->dev,
+				 "rescan scaned bridge as broken one again ?");
+
+			goto out;
 		}
+		/*
+		 * For CardBus bridges, we leave 4 bus numbers
+		 * as cards with a PCI-to-PCI bridge can be
+		 * inserted later.
+		 * other just allocate 8 bus to avoid we fall into
+		 *  small hole in the middle.
+		 */
+		ret = pci_bridge_probe_busn_res(bus, dev, &busn_res,
+				is_cardbus ? (CARDBUS_RESERVE_BUSNR + 1) : 8,
+				&parent_res);
+
+		if (ret != 0)
+			goto out;
+
+		child = pci_add_new_bus(bus, dev, busn_res.start);
+		if (!child)
+			goto out;
+
+		pci_bus_replace_busn_res(child, &busn_res);
+
 		buses = (buses & 0xff000000)
 		      | ((unsigned int)(child->primary)     <<  0)
 		      | ((unsigned int)(child->busn_res.start)   <<  8)
 		      | ((unsigned int)(child->busn_res.end) << 16);
 
+		max = child->busn_res.end;
+
 		/*
 		 * yenta.c forces a secondary latency timer of 176.
 		 * Copy that behaviour here.
@@ -903,43 +930,26 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 			 * the real value of max.
 			 */
 			pci_fixup_parent_subordinate_busnr(child, max);
+
 		} else {
-			/*
-			 * For CardBus bridges, we leave 4 bus numbers
-			 * as cards with a PCI-to-PCI bridge can be
-			 * inserted later.
-			 */
-			for (i=0; i<CARDBUS_RESERVE_BUSNR; i++) {
-				struct pci_bus *parent = bus;
-				if (pci_find_bus(pci_domain_nr(bus),
-							max+i+1))
-					break;
-				while (parent->parent) {
-					if ((!pcibios_assign_all_busses()) &&
-					    (parent->busn_res.end > max) &&
-					    (parent->busn_res.end <= max+i)) {
-						j = 1;
-					}
-					parent = parent->parent;
-				}
-				if (j) {
-					/*
-					 * Often, there are two cardbus bridges
-					 * -- try to leave one valid bus number
-					 * for each one.
-					 */
-					i /= 2;
-					break;
-				}
-			}
-			max += i;
 			pci_fixup_parent_subordinate_busnr(child, max);
 		}
 		/*
 		 * Set the subordinate bus number to its real value.
 		 */
-		pci_bus_update_busn_res_end(child, max);
+		shrink_size = (int)child->busn_res.end - max;
 		pci_write_config_byte(dev, PCI_SUBORDINATE_BUS, max);
+		pci_bus_update_busn_res_end(child, max);
+
+		/* shrink some back, if we extend top before */
+		if (!is_cardbus && (shrink_size > 0) && parent_res) {
+			resource_shrink_parents_top(&bus->busn_res, shrink_size,
+						 parent_res);
+			pci_bus_shrink_top(bus, shrink_size, parent_res);
+		}
+
+		if (old_max > max)
+			max = old_max;
 	}
 
 	sprintf(child->name,
-- 
1.7.7

