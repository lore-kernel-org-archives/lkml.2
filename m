Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab2AWXHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:07:55 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:32220 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab2AWXHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:07:21 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 2/4] PCI: Allocate bus range instead of use max blindly
Date: Mon, 23 Jan 2012 15:06:56 -0800
Message-Id: <1327360018-10929-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1327360018-10929-1-git-send-email-yinghai@kernel.org>
References: <1327360018-10929-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090207.4F1DE821.00CA,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

every bus have extra busn_res, and linked them toghter to iobusn_resource.

when need to find usabled bus number range, try allocate from
iobusn_resource tree.

-v3: support extend buses top.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |  276 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 239 insertions(+), 37 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index f327c04..f58164d 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -624,6 +624,200 @@ static void pci_fixup_parent_subordinate_busnr(struct pci_bus *child, int max)
 	}
 }
 
+static void __devinit pci_bus_extend_top(struct pci_bus *parent,
+		 resource_size_t size, struct resource *parent_res)
+{
+	struct resource *res;
+
+	if (!size)
+		return;
+
+	while (parent) {
+		res = &parent->busn_res;
+		if (res == parent_res)
+			break;
+		res->end += size;
+		parent->subordinate += size;
+		pci_write_config_byte(parent->self, PCI_SUBORDINATE_BUS,
+					 parent->subordinate);
+		dev_printk(KERN_DEBUG, &parent->dev,
+				"busn_res: extended %02llx to %06llx-%06llx\n",
+				(unsigned long long)size,
+				(unsigned long long)res->start,
+				(unsigned long long)res->end);
+		parent = parent->parent;
+	}
+}
+
+static void __devinit pci_bus_shrink_top(struct pci_bus *parent,
+		 resource_size_t size, struct resource *parent_res)
+{
+	struct resource *res;
+
+	if (!size)
+		return;
+
+	while (parent) {
+		res = &parent->busn_res;
+		if (res == parent_res)
+			break;
+		res->end -= size;
+		parent->subordinate -= size;
+		pci_write_config_byte(parent->self, PCI_SUBORDINATE_BUS,
+					 parent->subordinate);
+		dev_printk(KERN_DEBUG, &parent->dev,
+				"busn_res: shrunk %02llx to %06llx-%06llx\n",
+				(unsigned long long)size,
+				(unsigned long long)res->start,
+				(unsigned long long)res->end);
+		parent = parent->parent;
+	}
+}
+
+static resource_size_t __devinit find_res_top_free_size(struct resource *res)
+{
+	int ret = -ENOMEM;
+	resource_size_t n_size;
+	struct resource tmp_res;
+
+	/*
+	 *   find out number below res->end, that we can use at first
+	 *	res->start can not be used.
+	 */
+	n_size = resource_size(res) - 1;
+	memset(&tmp_res, 0, sizeof(struct resource));
+	while (n_size > 0) {
+		ret = allocate_resource(res, &tmp_res, n_size,
+			res->end - n_size + 1, res->end,
+			1, NULL, NULL);
+		if (ret == 0) {
+			/* release busn_res */
+			release_resource(&tmp_res);
+			break;
+		}
+		n_size--;
+	}
+
+	return n_size;
+}
+
+static int __devinit pci_bridge_probe_busn_res(struct pci_bus *bus,
+			 struct pci_dev *dev, struct resource *busn_res,
+			 resource_size_t needed_size, struct resource **p)
+{
+	int ret = -ENOMEM;
+	resource_size_t n_size;
+	struct pci_bus *parent;
+	struct resource *parent_res;
+	resource_size_t tmp = bus->busn_res.end + 1;
+	int free_sz = -1;
+
+	parent_res = NULL;
+
+again:
+	/*
+	 * find bigest range in bus->busn_res that we can use in the middle
+	 *  and we can not use bus->busn_res.start.
+	 */
+	n_size = resource_size(&bus->busn_res) - 1;
+	memset(busn_res, 0, sizeof(struct resource));
+	dev_printk(KERN_DEBUG, &dev->dev,
+			"find free busn in busn_res: %06llx-%06llx\n",
+			(unsigned long long)bus->busn_res.start,
+			(unsigned long long)bus->busn_res.end);
+	while (n_size >= needed_size) {
+		ret = allocate_resource(&bus->busn_res, busn_res, n_size,
+				bus->busn_res.start + 1, bus->busn_res.end,
+				1, NULL, NULL);
+		if (ret == 0) {
+			/* release res */
+			release_resource(busn_res);
+
+			return ret;
+		}
+		n_size--;
+	}
+
+	/* try extend the top of parent buss */
+	if (free_sz < 0) {
+		free_sz = find_res_top_free_size(&bus->busn_res);
+		dev_printk(KERN_DEBUG, &dev->dev,
+			"found free busn %d in busn_res: %06llx-%06llx top\n",
+				free_sz,
+				(unsigned long long)bus->busn_res.start,
+				(unsigned long long)bus->busn_res.end);
+	}
+	n_size = free_sz;
+
+	/* check if extend could cross domain boundary */
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
+			 needed_size - n_size,
+			 tmp, tmp + needed_size - n_size - 1,
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
+	/* save parent_res, we need it as stopper later */
+	parent_res = busn_res->parent;
+	/* release busn_res */
+	release_resource(busn_res);
+	busn_res->start -= n_size;
+
+	/* extend parent bus top*/
+	pci_bus_extend_top(bus, needed_size - n_size, parent_res);
+
+	*p = parent_res;
+
+	return ret;
+}
+
+static int __devinit pci_bridge_check_busn_res(struct pci_bus *bus,
+				struct pci_dev *dev,
+				int secondary, int subordinate)
+{
+	int broken = 0;
+
+	struct resource busn_res;
+	int ret;
+
+	memset(&busn_res, 0, sizeof(struct resource));
+	dev_printk(KERN_DEBUG, &dev->dev,
+		 "check if busn %02x-%02x is in busn_res: %06llx-%06llx\n",
+		 secondary, subordinate,
+		 (unsigned long long)bus->busn_res.start,
+		 (unsigned long long)bus->busn_res.end);
+	ret = allocate_resource(&bus->busn_res, &busn_res,
+			 (subordinate - secondary + 1),
+			 (pci_domain_nr(bus)<<8) | secondary,
+			 (pci_domain_nr(bus)<<8) | subordinate,
+			 1, NULL, NULL);
+	if (ret)
+		broken = 1;
+	else
+		release_resource(&busn_res);
+
+	return broken;
+}
 /*
  * If it's a bridge, configure it and scan the bus behind it.
  * For CardBus bridges, we don't scan behind as the devices will
@@ -638,10 +832,11 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
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
@@ -653,10 +848,16 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 
 	/* Check if setup is sensible at all */
 	if (!pass &&
-	    (primary != bus->number || secondary <= bus->number)) {
-		dev_dbg(&dev->dev, "bus configuration invalid, reconfiguring\n");
+	    (primary != bus->number || secondary <= bus->number))
 		broken = 1;
-	}
+
+	/* more strict checking */
+	if (!pass && !broken)
+		broken = pci_bridge_check_busn_res(bus, dev,
+						   secondary, subordinate);
+
+	if (broken)
+		dev_dbg(&dev->dev, "bus configuration invalid, reconfiguring\n");
 
 	/* Disable MasterAbortMode during probing to avoid reporting
 	   of bus errors (in some architectures) */ 
@@ -689,6 +890,8 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 			child->primary = primary;
 			child->subordinate = subordinate;
 			child->bridge_ctl = bctl;
+
+			pci_bus_insert_busn_res(child, secondary, subordinate);
 		}
 
 		cmax = pci_scan_child_bus(child);
@@ -701,6 +904,11 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
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
@@ -717,20 +925,28 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
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
+		pci_bus_insert_busn_res(child, busn_res.start & 0xff,
+					busn_res.end & 0xff);
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
@@ -761,43 +977,29 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
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
+		pci_bus_update_busn_res_end(child, max);
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

