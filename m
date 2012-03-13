Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759918Ab2CMH2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 03:28:20 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:28345 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172Ab2CMH2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 03:28:15 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 06/12] PCI: Use for_each_pci_dev_resource helper
Date: Tue, 13 Mar 2012 00:26:28 -0700
Message-Id: <1331623594-30543-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331623594-30543-1-git-send-email-yinghai@kernel.org>
References: <1331623594-30543-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4F5EF70A.000C,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace those open code, and make code more readable.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/common.c              |    3 +-
 arch/x86/pci/i386.c                |   75 +++++++++++++++--------------------
 arch/x86/pci/mrst.c                |    7 ++-
 drivers/pci/hotplug/acpiphp_glue.c |    4 +-
 drivers/pci/hotplug/pciehp_hpc.c   |    5 +-
 drivers/pci/iov.c                  |   31 +++++++--------
 drivers/pci/pci-driver.c           |    6 ++-
 drivers/pci/pci.c                  |   21 +++++-----
 drivers/pci/probe.c                |    6 ++-
 drivers/pci/remove.c               |    5 +-
 drivers/pci/setup-bus.c            |   28 ++++++--------
 drivers/pci/setup-res.c            |   14 +++----
 drivers/pci/xen-pcifront.c         |    4 +-
 13 files changed, 96 insertions(+), 113 deletions(-)

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 0ec860f..7ea09f8 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -136,8 +136,7 @@ static void __devinit pcibios_fixup_device_resources(struct pci_dev *dev)
 		* resource so the kernel doesn't attmept to assign
 		* it later on in pci_assign_unassigned_resources
 		*/
-		for (bar = 0; bar <= PCI_STD_RESOURCE_END; bar++) {
-			bar_r = &dev->resource[bar];
+		for_each_pci_dev_base_norom_resource(dev, bar_r, bar) {
 			if (bar_r->start == 0 && bar_r->end != 0) {
 				bar_r->flags = 0;
 				bar_r->end = 0;
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 3e1dd0e..29c3e19 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -196,7 +196,7 @@ static void pcibios_allocate_bridge_resources(struct pci_dev *dev)
 	int idx;
 	struct resource *r;
 
-	for (idx = PCI_BRIDGE_RESOURCES; idx < PCI_NUM_RESOURCES; idx++) {
+	for_each_pci_dev_bridge_resource(dev, r, idx) {
 		r = &dev->resource[idx];
 		if (!r->flags)
 			continue;
@@ -231,56 +231,45 @@ struct pci_check_idx_range {
 
 static void pcibios_allocate_dev_resources(struct pci_dev *dev, int pass)
 {
-	int idx, disabled, i;
+	int idx, disabled;
 	u16 command;
 	struct resource *r;
 
-	struct pci_check_idx_range idx_range[] = {
-		{ PCI_STD_RESOURCES, PCI_STD_RESOURCE_END },
-#ifdef CONFIG_PCI_IOV
-		{ PCI_IOV_RESOURCES, PCI_IOV_RESOURCE_END },
-#endif
-	};
-
 	pci_read_config_word(dev, PCI_COMMAND, &command);
-	for (i = 0; i < ARRAY_SIZE(idx_range); i++)
-		for (idx = idx_range[i].start; idx <= idx_range[i].end; idx++) {
-			r = &dev->resource[idx];
-			if (r->parent)		/* Already allocated */
-				continue;
-			if (!r->start)		/* Address not assigned at all */
-				continue;
-			if (r->flags & IORESOURCE_IO)
-				disabled = !(command & PCI_COMMAND_IO);
-			else
-				disabled = !(command & PCI_COMMAND_MEMORY);
-			if (pass == disabled) {
-				dev_dbg(&dev->dev,
-					"BAR %d: reserving %pr (d=%d, p=%d)\n",
-					idx, r, disabled, pass);
-				if (pci_claim_resource(dev, idx) < 0) {
-					/* We'll assign a new address later */
-					pcibios_save_fw_addr(dev,
-							idx, r->start);
-					r->end -= r->start;
-					r->start = 0;
-				}
+	for_each_pci_dev_base_norom_resource(dev, r, idx) {
+		if (r->parent)		/* Already allocated */
+			continue;
+		if (!r->start)		/* Address not assigned at all */
+			continue;
+		if (r->flags & IORESOURCE_IO)
+			disabled = !(command & PCI_COMMAND_IO);
+		else
+			disabled = !(command & PCI_COMMAND_MEMORY);
+		if (pass == disabled) {
+			dev_dbg(&dev->dev,
+				"BAR %d: reserving %pr (d=%d, p=%d)\n",
+				idx, r, disabled, pass);
+			if (pci_claim_resource(dev, idx) < 0) {
+				/* We'll assign a new address later */
+				pcibios_save_fw_addr(dev, idx, r->start);
+				r->end -= r->start;
+				r->start = 0;
 			}
 		}
-		if (!pass) {
-			r = &dev->resource[PCI_ROM_RESOURCE];
-			if (r->flags & IORESOURCE_ROM_ENABLE) {
-				/* Turn the ROM off, leave the resource region,
-				 * but keep it unregistered. */
-				u32 reg;
-				dev_dbg(&dev->dev, "disabling ROM %pR\n", r);
-				r->flags &= ~IORESOURCE_ROM_ENABLE;
-				pci_read_config_dword(dev,
-						dev->rom_base_reg, &reg);
-				pci_write_config_dword(dev, dev->rom_base_reg,
+	}
+	if (!pass) {
+		r = &dev->resource[PCI_ROM_RESOURCE];
+		if (r->flags & IORESOURCE_ROM_ENABLE) {
+			/* Turn the ROM off, leave the resource region,
+			 * but keep it unregistered. */
+			u32 reg;
+			dev_dbg(&dev->dev, "disabling ROM %pR\n", r);
+			r->flags &= ~IORESOURCE_ROM_ENABLE;
+			pci_read_config_dword(dev, dev->rom_base_reg, &reg);
+			pci_write_config_dword(dev, dev->rom_base_reg,
 						reg & ~PCI_ROM_ADDRESS_ENABLE);
-			}
 		}
+	}
 }
 
 void pcibios_allocate_resources(struct pci_bus *bus, int pass)
diff --git a/arch/x86/pci/mrst.c b/arch/x86/pci/mrst.c
index 140942f..55e20d8 100644
--- a/arch/x86/pci/mrst.c
+++ b/arch/x86/pci/mrst.c
@@ -280,6 +280,7 @@ static void __devinit pci_fixed_bar_fixup(struct pci_dev *dev)
 	unsigned long offset;
 	u32 size;
 	int i;
+	struct resource *res;
 
 	if (!pci_soc_mode)
 		return;
@@ -294,10 +295,10 @@ static void __devinit pci_fixed_bar_fixup(struct pci_dev *dev)
 	    PCI_DEVFN(2, 2) == dev->devfn)
 		return;
 
-	for (i = 0; i < PCI_ROM_RESOURCE; i++) {
+	for_each_pci_dev_std_resource(dev, res, i) {
 		pci_read_config_dword(dev, offset + 8 + (i * 4), &size);
-		dev->resource[i].end = dev->resource[i].start + size - 1;
-		dev->resource[i].flags |= IORESOURCE_PCI_FIXED;
+		res->end = res->start + size - 1;
+		res->flags |= IORESOURCE_PCI_FIXED;
 	}
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_ANY_ID, pci_fixed_bar_fixup);
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 9f1a195..329d4fc 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -1024,10 +1024,10 @@ static void acpiphp_sanitize_bus(struct pci_bus *bus)
 	struct pci_dev *dev;
 	int i;
 	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM;
+	struct resource *res;
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
-		for (i=0; i<PCI_BRIDGE_RESOURCES; i++) {
-			struct resource *res = &dev->resource[i];
+		for_each_pci_dev_nobridge_resource(dev, res, i) {
 			if ((res->flags & type_mask) && !res->start &&
 					res->end) {
 				/* Could not assign a required resources
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index a960fae..ef10429 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -899,6 +899,7 @@ static inline void dbg_ctrl(struct controller *ctrl)
 	int i;
 	u16 reg16;
 	struct pci_dev *pdev = ctrl->pcie->port;
+	struct resource *res;
 
 	if (!pciehp_debug)
 		return;
@@ -914,11 +915,11 @@ static inline void dbg_ctrl(struct controller *ctrl)
 		  pdev->subsystem_vendor);
 	ctrl_info(ctrl, "  PCIe Cap offset      : 0x%02x\n",
 		  pci_pcie_cap(pdev));
-	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
+	for_each_pci_dev_all_resource(pdev, res, i) {
 		if (!pci_resource_len(pdev, i))
 			continue;
 		ctrl_info(ctrl, "  PCI resource [%d]     : %pR\n",
-			  i, &pdev->resource[i]);
+			  i, res);
 	}
 	ctrl_info(ctrl, "Slot Capabilities      : 0x%08x\n", ctrl->slot_cap);
 	ctrl_info(ctrl, "  Physical Slot Number : %d\n", PSN(ctrl));
diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 6554e1a..f015764 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -99,17 +99,20 @@ static int virtfn_add(struct pci_dev *dev, int id, int reset)
 	pci_setup_device(virtfn);
 	virtfn->dev.parent = dev->dev.parent;
 
-	for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
-		res = dev->resource + PCI_IOV_RESOURCES + i;
+	for_each_pci_dev_iov_resource(dev, res, i) {
+		struct resource *virtfn_res;
+
 		if (!res->parent)
 			continue;
-		virtfn->resource[i].name = pci_name(virtfn);
-		virtfn->resource[i].flags = res->flags;
+
+		virtfn_res = pci_dev_resource_n(virtfn, i - PCI_IOV_RESOURCES);
+		virtfn_res->name = pci_name(virtfn);
+		virtfn_res->flags = res->flags;
 		size = resource_size(res);
 		do_div(size, iov->total);
-		virtfn->resource[i].start = res->start + size * id;
-		virtfn->resource[i].end = virtfn->resource[i].start + size - 1;
-		rc = request_resource(res, &virtfn->resource[i]);
+		virtfn_res->start = res->start + size * id;
+		virtfn_res->end = virtfn_res->start + size - 1;
+		rc = request_resource(res, virtfn_res);
 		BUG_ON(rc);
 	}
 
@@ -313,9 +316,8 @@ static int sriov_enable(struct pci_dev *dev, int nr_virtfn)
 		return -EIO;
 
 	nres = 0;
-	for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
-		bars |= (1 << (i + PCI_IOV_RESOURCES));
-		res = dev->resource + PCI_IOV_RESOURCES + i;
+	for_each_pci_dev_iov_resource(dev, res, i) {
+		bars |= 1 << i;
 		if (res->parent)
 			nres++;
 	}
@@ -473,10 +475,9 @@ found:
 	pci_write_config_dword(dev, pos + PCI_SRIOV_SYS_PGSIZE, pgsz);
 
 	nres = 0;
-	for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
-		res = dev->resource + PCI_IOV_RESOURCES + i;
+	for_each_pci_dev_iov_resource(dev, res, i) {
 		i += __pci_read_base(dev, pci_bar_unknown, res,
-				     pos + PCI_SRIOV_BAR + i * 4);
+			     pos + PCI_SRIOV_BAR + (i - PCI_IOV_RESOURCES) * 4);
 		if (!res->flags)
 			continue;
 		if (resource_size(res) & (PAGE_SIZE - 1)) {
@@ -519,10 +520,8 @@ found:
 	return 0;
 
 failed:
-	for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
-		res = dev->resource + PCI_IOV_RESOURCES + i;
+	for_each_pci_dev_iov_resource(dev, res, i)
 		res->flags = 0;
-	}
 
 	return rc;
 }
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 5d19695..a82c66f 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -1201,9 +1201,11 @@ pci_dev_driver(const struct pci_dev *dev)
 	if (dev->driver)
 		return dev->driver;
 	else {
+		struct resource *res;
 		int i;
-		for(i=0; i<=PCI_ROM_RESOURCE; i++)
-			if (dev->resource[i].flags & IORESOURCE_BUSY)
+
+		for_each_pci_dev_base_resource((struct pci_dev *)dev, res, i)
+			if (res->flags & IORESOURCE_BUSY)
 				return &pci_compat_driver;
 	}
 	return NULL;
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index af84abf..4512db6 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -483,8 +483,9 @@ static void
 pci_restore_bars(struct pci_dev *dev)
 {
 	int i;
+	struct resource *res;
 
-	for (i = 0; i < PCI_BRIDGE_RESOURCES; i++)
+	for_each_pci_dev_nobridge_resource(dev, res, i)
 		pci_update_resource(dev, i);
 }
 
@@ -1138,6 +1139,7 @@ static int __pci_enable_device_flags(struct pci_dev *dev,
 {
 	int err;
 	int i, bars = 0;
+	struct resource *res;
 
 	/*
 	 * Power state could be unknown at this point, either due to a fresh
@@ -1155,12 +1157,11 @@ static int __pci_enable_device_flags(struct pci_dev *dev,
 		return 0;		/* already enabled */
 
 	/* only skip sriov related */
-	for (i = 0; i <= PCI_ROM_RESOURCE; i++)
-		if (dev->resource[i].flags & flags)
-			bars |= (1 << i);
-	for (i = PCI_BRIDGE_RESOURCES; i < DEVICE_COUNT_RESOURCE; i++)
-		if (dev->resource[i].flags & flags)
+	for_each_pci_dev_noiov_resource(dev, res, i) {
+		/* TODO: check i with bits of bars */
+		if (res->flags & flags)
 			bars |= (1 << i);
+	}
 
 	err = do_pci_enable_device(dev, bars);
 	if (err < 0)
@@ -2462,7 +2463,7 @@ static int __pci_request_region(struct pci_dev *pdev, int bar, const char *res_n
 
 err_out:
 	dev_warn(&pdev->dev, "BAR %d: can't reserve %pR\n", bar,
-		 &pdev->resource[bar]);
+		 pci_dev_resource_n(pdev, bar));
 	return -EBUSY;
 }
 
@@ -3721,8 +3722,7 @@ void pci_reassigndev_resource_alignment(struct pci_dev *dev)
 	command &= ~PCI_COMMAND_MEMORY;
 	pci_write_config_word(dev, PCI_COMMAND, command);
 
-	for (i = 0; i < PCI_BRIDGE_RESOURCES; i++) {
-		r = &dev->resource[i];
+	for_each_pci_dev_nobridge_resource(dev, r, i) {
 		if (!(r->flags & IORESOURCE_MEM))
 			continue;
 		size = resource_size(r);
@@ -3741,8 +3741,7 @@ void pci_reassigndev_resource_alignment(struct pci_dev *dev)
 	 */
 	if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE &&
 	    (dev->class >> 8) == PCI_CLASS_BRIDGE_PCI) {
-		for (i = PCI_BRIDGE_RESOURCES; i < PCI_NUM_RESOURCES; i++) {
-			r = &dev->resource[i];
+		for_each_pci_dev_bridge_resource(dev, r, i) {
 			if (!(r->flags & IORESOURCE_MEM))
 				continue;
 			r->end = resource_size(r) - 1;
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index dac829f..3143964 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -360,9 +360,11 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 static void pci_read_bases(struct pci_dev *dev, unsigned int howmany, int rom)
 {
 	unsigned int pos, reg;
+	struct resource *res;
 
-	for (pos = 0; pos < howmany; pos++) {
-		struct resource *res = &dev->resource[pos];
+	for_each_pci_dev_std_resource(dev, res, pos) {
+		if (pos >= howmany)
+			break;
 		reg = PCI_BASE_ADDRESS_0 + (pos << 2);
 		pos += __pci_read_base(dev, pci_bar_unknown, res, reg);
 	}
diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index 9ffc071..28c9fb8 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -6,15 +6,14 @@
 static void pci_free_resources(struct pci_dev *dev)
 {
 	int i;
+	struct resource *res;
 
  	msi_remove_pci_irq_vectors(dev);
 
 	pci_cleanup_rom(dev);
-	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
-		struct resource *res = dev->resource + i;
+	for_each_pci_dev_all_resource(dev, res, i)
 		if (res->parent)
 			release_resource(res);
-	}
 }
 
 static void pci_stop_dev(struct pci_dev *dev)
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 33f0fcd..8540155 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -106,7 +106,7 @@ static resource_size_t get_res_add_size(struct list_head *head,
 
 	list_for_each_entry(dev_res, head, list) {
 		if (dev_res->res == res) {
-			int idx = res - &dev_res->dev->resource[0];
+			int idx = pci_dev_resource_idx(dev_res->dev, res);
 
 			dev_printk(KERN_DEBUG, &dev_res->dev->dev,
 				 "res[%d]=%pR get_res_add_size add_size %llx\n",
@@ -124,15 +124,13 @@ static resource_size_t get_res_add_size(struct list_head *head,
 static void pdev_sort_resources(struct pci_dev *dev, struct list_head *head)
 {
 	int i;
+	struct resource *r;
 
-	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
-		struct resource *r;
+	for_each_pci_dev_all_resource(dev, r, i) {
 		struct pci_dev_resource *dev_res, *tmp;
 		resource_size_t r_align;
 		struct list_head *n;
 
-		r = &dev->resource[i];
-
 		if (r->flags & IORESOURCE_PCI_FIXED)
 			continue;
 
@@ -237,7 +235,7 @@ static void reassign_resources_sorted(struct list_head *realloc_head,
 		if (!found_match)/* just skip */
 			continue;
 
-		idx = res - &add_res->dev->resource[0];
+		idx = pci_dev_resource_idx(add_res->dev, res);
 		add_size = add_res->add_size;
 		if (!resource_size(res)) {
 			res->start = add_res->start;
@@ -280,7 +278,7 @@ static void assign_requested_resources_sorted(struct list_head *head,
 
 	list_for_each_entry(dev_res, head, list) {
 		res = dev_res->res;
-		idx = res - &dev_res->dev->resource[0];
+		idx = pci_dev_resource_idx(dev_res->dev, res);
 		if (resource_size(res) &&
 		    pci_assign_resource(dev_res->dev, idx)) {
 			if (fail_head && !pci_is_root_bus(dev_res->dev->bus)) {
@@ -716,9 +714,9 @@ static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size,
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		int i;
+		struct resource *r;
 
-		for (i = 0; i < PCI_NUM_RESOURCES; i++) {
-			struct resource *r = &dev->resource[i];
+		for_each_pci_dev_all_resource(dev, r, i) {
 			unsigned long r_size;
 
 			if (r->parent || !(r->flags & IORESOURCE_IO))
@@ -798,9 +796,9 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		int i;
+		struct resource *r;
 
-		for (i = 0; i < PCI_NUM_RESOURCES; i++) {
-			struct resource *r = &dev->resource[i];
+		for_each_pci_dev_all_resource(dev, r, i) {
 			resource_size_t r_size;
 
 			if (r->parent || (r->flags & mask) != type)
@@ -1140,9 +1138,7 @@ static void pci_bridge_release_resources(struct pci_bus *bus,
 				  IORESOURCE_PREFETCH;
 
 	dev = bus->self;
-	for (idx = PCI_BRIDGE_RESOURCES; idx <= PCI_BRIDGE_RESOURCE_END;
-	     idx++) {
-		r = &dev->resource[idx];
+	for_each_pci_dev_bridge_resource(dev, r, idx) {
 		if ((r->flags & type_mask) != type)
 			continue;
 		if (!r->parent)
@@ -1313,9 +1309,9 @@ static void __init pci_realloc_detect(void)
 
 	for_each_pci_dev(dev) {
 		int i;
+		struct resource *r;
 
-		for (i = PCI_IOV_RESOURCES; i <= PCI_IOV_RESOURCE_END; i++) {
-			struct resource *r = &dev->resource[i];
+		for_each_pci_dev_iov_resource(dev, r, i) {
 
 			/* Not assigned, or rejected by kernel ? */
 			if (r->flags && !r->start) {
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 48251e3..4c6c924 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -104,7 +104,7 @@ void pci_update_resource(struct pci_dev *dev, int resno)
 
 int pci_claim_resource(struct pci_dev *dev, int resource)
 {
-	struct resource *res = &dev->resource[resource];
+	struct resource *res = pci_dev_resource_n(dev, resource);
 	struct resource *root, *conflict;
 
 	root = pci_find_parent_resource(dev, res);
@@ -142,7 +142,7 @@ void pci_disable_bridge_window(struct pci_dev *dev)
 static int __pci_assign_resource(struct pci_bus *bus, struct pci_dev *dev,
 		int resno, resource_size_t size, resource_size_t align)
 {
-	struct resource *res = dev->resource + resno;
+	struct resource *res = pci_dev_resource_n(dev, resno);
 	resource_size_t min;
 	int ret;
 
@@ -220,7 +220,7 @@ static int pci_revert_fw_address(struct resource *res, struct pci_dev *dev,
 
 static int _pci_assign_resource(struct pci_dev *dev, int resno, int size, resource_size_t min_align)
 {
-	struct resource *res = dev->resource + resno;
+	struct resource *res = pci_dev_resource_n(dev, resno);
 	struct pci_bus *bus;
 	int ret;
 	char *type;
@@ -253,7 +253,7 @@ static int _pci_assign_resource(struct pci_dev *dev, int resno, int size, resour
 int pci_reassign_resource(struct pci_dev *dev, int resno, resource_size_t addsize,
 			resource_size_t min_align)
 {
-	struct resource *res = dev->resource + resno;
+	struct resource *res = pci_dev_resource_n(dev, resno);
 	resource_size_t new_size;
 	int ret;
 
@@ -277,7 +277,7 @@ int pci_reassign_resource(struct pci_dev *dev, int resno, resource_size_t addsiz
 
 int pci_assign_resource(struct pci_dev *dev, int resno)
 {
-	struct resource *res = dev->resource + resno;
+	struct resource *res = pci_dev_resource_n(dev, resno);
 	resource_size_t align, size;
 	struct pci_bus *bus;
 	int ret;
@@ -319,12 +319,10 @@ int pci_enable_resources(struct pci_dev *dev, int mask)
 	pci_read_config_word(dev, PCI_COMMAND, &cmd);
 	old_cmd = cmd;
 
-	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
+	for_each_pci_dev_all_resource(dev, r, i) {
 		if (!(mask & (1 << i)))
 			continue;
 
-		r = &dev->resource[i];
-
 		if (!(r->flags & (IORESOURCE_IO | IORESOURCE_MEM)))
 			continue;
 		if ((i == PCI_ROM_RESOURCE) &&
diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index 9c43ab4..9ae41ba 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -393,9 +393,7 @@ static int pcifront_claim_resource(struct pci_dev *dev, void *data)
 	int i;
 	struct resource *r;
 
-	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
-		r = &dev->resource[i];
-
+	for_each_pci_dev_all_resource(dev, r, i) {
 		if (!r->parent && r->start && r->flags) {
 			dev_info(&pdev->xdev->dev, "claiming resource %s/%d\n",
 				pci_name(dev), i);
-- 
1.7.7

