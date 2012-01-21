Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab2AUKZB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 05:25:01 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:48104 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001Ab2AUKY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 05:24:27 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [RFC PATCH 2/3] PCI: Allocate bus range instead of use max blindly
Date: Sat, 21 Jan 2012 02:24:07 -0800
Message-Id: <1327141448-15281-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1327141448-15281-1-git-send-email-yinghai@kernel.org>
References: <1327141448-15281-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4F1A9257.0049,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

every bus have extra busn_res, and linked them toghter to iobusn_resource.

when need to find usabled bus number range, try allocate from
iobusn_resource tree.

-v3: support extend buses top.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |  220 ++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 184 insertions(+), 36 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 3e08207..e20fe45 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -624,6 +624,124 @@ static void pci_fixup_parent_subordinate_busnr(struct pci_bus *child, int max)
 	}
 }
 
+static void __devinit pci_bus_extend_top(struct pci_bus *parent,
+		 resource_size_t needed_size, struct resource *parent_res)
+{
+	while (parent) {
+		if (&parent->busn_res == parent_res)
+			break;
+		parent->busn_res.end += needed_size;
+		parent->subordinate += needed_size;
+		pci_write_config_byte(parent->self, PCI_SUBORDINATE_BUS,
+					 parent->subordinate);
+		dev_printk(KERN_DEBUG, &parent->dev, "busn_res: %06llx-%06llx extended\n", (unsigned long long)parent->busn_res.start, (unsigned long long)parent->busn_res.end);
+		parent = parent->parent;
+	}
+}
+
+static void __devinit pci_bus_shrink_top(struct pci_bus *parent,
+		 resource_size_t needed_size, struct resource *parent_res)
+{
+	while (parent) {
+		if (&parent->busn_res == parent_res)
+			break;
+		parent->busn_res.end -= needed_size;
+		parent->subordinate -= needed_size;
+		pci_write_config_byte(parent->self, PCI_SUBORDINATE_BUS,
+					 parent->subordinate);
+		dev_printk(KERN_DEBUG, &parent->dev, "busn_res: %06llx-%06llx shrinked\n", (unsigned long long)parent->busn_res.start, (unsigned long long)parent->busn_res.end);
+		parent = parent->parent;
+	}
+}
+
+static int __devinit pci_bridge_probe_busn_res(struct pci_bus *bus, struct pci_dev *dev, struct resource *busn_res, resource_size_t needed_size, struct resource **p)
+{
+	int ret = -ENOMEM;
+	resource_size_t n_size;
+	struct pci_bus *parent;
+	struct resource *parent_res;
+	resource_size_t tmp = bus->busn_res.end + 1;
+
+	parent_res = NULL;
+
+again:
+	/* find bigest range in bus->busn_res that we can use in the middle */
+	n_size = resource_size(&bus->busn_res) - 1;
+	memset(busn_res, 0, sizeof(struct resource));
+	dev_printk(KERN_DEBUG, &dev->dev, "find free busn in busn_res: %06llx-%06llx\n", (unsigned long long)bus->busn_res.start, (unsigned long long)bus->busn_res.end);
+	while (n_size >= needed_size) {
+		ret = allocate_resource(&bus->busn_res, busn_res, n_size,
+				bus->busn_res.start + 1, bus->busn_res.end,
+				1, NULL, NULL);
+		if (ret == 0) {
+			/* release busn_res */
+			release_resource(busn_res);
+
+			return ret;
+		}
+		n_size--;
+	}
+
+	/*
+	 * try extend the top of parent buss
+	 *   find out number below bus->busn_res, that we can use at first
+	 */
+	ret = -ENOMEM;
+	n_size = resource_size(&bus->busn_res) - 1;
+	memset(busn_res, 0, sizeof(struct resource));
+	dev_printk(KERN_DEBUG, &dev->dev, "find free busn in busn_res: %06llx-%06llx near top \n", (unsigned long long)bus->busn_res.start, (unsigned long long)bus->busn_res.end);
+	while (n_size > 0) {
+		ret = allocate_resource(&bus->busn_res, busn_res, n_size,
+			bus->busn_res.end - n_size + 1, bus->busn_res.end,
+			1, NULL, NULL);
+		if (ret == 0) {
+			/* release busn_res */
+			release_resource(busn_res);
+			break;
+		}
+		n_size--;
+	}
+
+	/* check if extend could cross domain boundary */
+	ret = -ENOMEM;
+	if ((bus->busn_res.end & 0xff) == 0xff)
+		goto reduce_needed_size;
+	if ((0x100 - (tmp & 0xff)) < (needed_size - n_size))
+		goto reduce_needed_size;
+
+	/* find exteded range */
+	memset(busn_res, 0, sizeof(struct resource));
+	parent = bus->parent;
+	while (parent) {
+		ret = allocate_resource(&parent->busn_res, busn_res,
+			 needed_size - n_size, tmp, tmp + needed_size - n_size,
+			 1, NULL, NULL);
+		if (ret == 0)
+			break;
+		parent = parent->parent;
+	}
+
+reduce_needed_size:
+	if (ret != 0) {
+		needed_size--;
+		if (!needed_size)
+			return ret;
+
+		goto again;
+	}
+
+	parent_res = busn_res->parent;
+	/* release busn_res */
+	release_resource(busn_res);
+	busn_res->start -= n_size;
+
+	/* extend */
+	pci_bus_extend_top(bus, needed_size - n_size, parent_res);
+
+	*p = parent_res;
+	return ret;
+}
+
 /*
  * If it's a bridge, configure it and scan the bus behind it.
  * For CardBus bridges, we don't scan behind as the devices will
@@ -638,10 +756,11 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
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
@@ -653,11 +772,30 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 
 	/* Check if setup is sensible at all */
 	if (!pass &&
-	    (primary != bus->number || secondary <= bus->number)) {
-		dev_dbg(&dev->dev, "bus configuration invalid, reconfiguring\n");
+	    (primary != bus->number || secondary <= bus->number))
 		broken = 1;
+
+	/* more strict checking */
+	if (!pass && !broken) {
+		struct resource busn_res;
+		int ret;
+
+		memset(&busn_res, 0, sizeof(struct resource));
+		dev_printk(KERN_DEBUG, &dev->dev, "try to check if busn %02x-%02x is in busn_res: %06llx-%06llx \n", secondary, subordinate, (unsigned long long)bus->busn_res.start, (unsigned long long)bus->busn_res.end);
+		ret = allocate_resource(&bus->busn_res, &busn_res,
+				 (subordinate - secondary + 1),
+				 (pci_domain_nr(bus)<<8) | secondary,
+				 (pci_domain_nr(bus)<<8) | subordinate,
+				 1, NULL, NULL);
+		if (ret)
+			broken = 1;
+		else
+			release_resource(&busn_res);
 	}
 
+	if (broken)
+		dev_dbg(&dev->dev, "bus configuration invalid, reconfiguring\n");
+
 	/* Disable MasterAbortMode during probing to avoid reporting
 	   of bus errors (in some architectures) */ 
 	pci_read_config_word(dev, PCI_BRIDGE_CONTROL, &bctl);
@@ -689,6 +827,12 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 			child->primary = primary;
 			child->subordinate = subordinate;
 			child->bridge_ctl = bctl;
+
+			child->busn_res.start = (pci_domain_nr(bus) << 8) | secondary;
+			child->busn_res.end = (pci_domain_nr(bus) << 8) | subordinate;
+			child->busn_res.flags = IORESOURCE_BUS | IORESOURCE_BUSY;
+			dev_printk(KERN_DEBUG, &child->dev, "busn_res: %06llx-%06llx inserted\n", (unsigned long long)child->busn_res.start, (unsigned long long)child->busn_res.end);
+			insert_resource(&bus->busn_res, &child->busn_res);
 		}
 
 		cmax = pci_scan_child_bus(child);
@@ -701,6 +845,11 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 		 * We need to assign a number to this bus which we always
 		 * do in the second pass.
 		 */
+		resource_size_t shrink_size;
+		struct resource busn_res;
+		int ret = -ENOMEM;
+		int old_max = max;
+
 		if (!pass) {
 			if (pcibios_assign_all_busses() || broken)
 				/* Temporarily disable forwarding of the
@@ -717,20 +866,31 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
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
-		}
+		ret = pci_bridge_probe_busn_res(bus, dev, &busn_res,
+				is_cardbus ? (CARDBUS_RESERVE_BUSNR + 1) : 8,
+				&parent_res);
+
+		if (ret != 0)
+			goto out;
+
+		child = pci_add_new_bus(bus, dev, busn_res.start & 0xff);
+		if (!child)
+			goto out;
+
+		child->subordinate = busn_res.end & 0xff;
+		child->busn_res.start = busn_res.start;
+		child->busn_res.end = busn_res.end;
+		child->busn_res.flags = IORESOURCE_BUS | IORESOURCE_BUSY;
+		dev_printk(KERN_DEBUG, &child->dev, "busn_res: %06llx-%06llx inserted\n", child->busn_res.start, child->busn_res.end);
+		insert_resource(&bus->busn_res, &child->busn_res);
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
@@ -761,43 +921,31 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 			 * the real value of max.
 			 */
 			pci_fixup_parent_subordinate_busnr(child, max);
+
 		} else {
 			/*
 			 * For CardBus bridges, we leave 4 bus numbers
 			 * as cards with a PCI-to-PCI bridge can be
 			 * inserted later.
 			 */
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
+		child->busn_res.end &= ~0xff;
+		child->busn_res.end |= max;
+		dev_printk(KERN_DEBUG, &child->dev, "busn_res: %06llx-%06llx adjusted\n", (unsigned long long)child->busn_res.start, (unsigned long long)child->busn_res.end);
+
+		/* shrink some back, if we extend top before */
+		if (!is_cardbus &&  (shrink_size > 0) && parent_res)
+			pci_bus_shrink_top(bus, shrink_size, parent_res);
+
+		if (old_max > max)
+			max = old_max;
 	}
 
 	sprintf(child->name,
-- 
1.7.7

