Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965481Ab2B1CLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 21:11:30 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:43231 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965331Ab2B1CL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 21:11:27 -0500
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
Subject: [PATCH 13/18] PCI: Allocate bus range instead of use max blindly
Date: Mon, 27 Feb 2012 18:10:04 -0800
Message-Id: <1330395009-29260-14-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330395009-29260-1-git-send-email-yinghai@kernel.org>
References: <1330395009-29260-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090203.4F4C37C7.002B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

every bus have extra busn_res, and linked them toghter to iobusn_resource.

when need to find usable bus number range, try probe from iobusn_resource tree.

To avoid falling to small hole in the middle, we try from 8 spare bus.
if can not find 8 or more in the middle, will try to append 8 on top later.
then if can not append, will try to find 7 from the middle, then will try to append 7 on top.
then if can not append, will try to find 6 from the middle...

for cardbus will only find 4 spare.

if extend from top, at last will shrink back to really needed range...

-v4: fix checking with pci rescan. Found by Bjorn.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |  100 ++++++++++++++++++++++++++++++---------------------
 1 files changed, 59 insertions(+), 41 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 1d36a2a..85266e6 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -832,10 +832,11 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
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
@@ -852,10 +853,16 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 
 	/* Check if setup is sensible at all */
 	if (!pass &&
-	    (primary != bus->number || secondary <= bus->number)) {
-		dev_dbg(&dev->dev, "bus configuration invalid, reconfiguring\n");
+	    (primary != bus->number || secondary <= bus->number))
 		broken = 1;
-	}
+
+	/* more strict checking */
+	if (!pass && !broken && !dev->subordinate)
+		broken = pci_bridge_check_busn_broken(bus, dev,
+						   secondary, subordinate);
+
+	if (broken)
+		dev_dbg(&dev->dev, "bus configuration invalid, reconfiguring\n");
 
 	/* Disable MasterAbortMode during probing to avoid reporting
 	   of bus errors (in some architectures) */ 
@@ -888,6 +895,8 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 			child->primary = primary;
 			child->subordinate = subordinate;
 			child->bridge_ctl = bctl;
+
+			pci_bus_insert_busn_res(child, secondary, subordinate);
 		}
 
 		cmax = pci_scan_child_bus(child);
@@ -900,6 +909,11 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
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
@@ -916,20 +930,43 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
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
+		child->subordinate = busn_res.end;
+		pci_bus_insert_busn_res(child, busn_res.start, busn_res.end);
+
 		buses = (buses & 0xff000000)
 		      | ((unsigned int)(child->primary)     <<  0)
 		      | ((unsigned int)(child->secondary)   <<  8)
 		      | ((unsigned int)(child->subordinate) << 16);
 
+		max = child->subordinate;
+
 		/*
 		 * yenta.c forces a secondary latency timer of 176.
 		 * Copy that behaviour here.
@@ -960,43 +997,24 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
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
-					    (parent->subordinate > max) &&
-					    (parent->subordinate <= max+i)) {
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
+		shrink_size = child->subordinate - max;
 		child->subordinate = max;
 		pci_write_config_byte(dev, PCI_SUBORDINATE_BUS, max);
+		pci_bus_update_busn_res_end(child, max);
+
+		/* shrink some back, if we extend top before */
+		if (!is_cardbus && (shrink_size > 0) && parent_res)
+			pci_bus_shrink_top(bus, shrink_size, parent_res);
+
+		if (old_max > max)
+			max = old_max;
 	}
 
 	sprintf(child->name,
-- 
1.7.7

