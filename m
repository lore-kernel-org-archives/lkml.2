Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445Ab2EGUeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:34:36 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:51000 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217Ab2EGUa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:30:28 -0400
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
Subject: [PATCH 02/21] PCI: replace secondary/subordinate with busn_res
Date: Mon,  7 May 2012 13:29:47 -0700
Message-Id: <1336422606-4244-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
References: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already have busn_res in pci_bus, use that instead, So later
could have them in resource tree.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/alpha/kernel/pci.c                    |    2 +-
 arch/arm/kernel/bios32.c                   |    2 +-
 arch/ia64/pci/pci.c                        |    2 +-
 arch/microblaze/pci/pci-common.c           |    4 +-
 arch/mips/pci/pci.c                        |    2 +-
 arch/powerpc/kernel/pci-common.c           |    6 +-
 arch/powerpc/kernel/pci_64.c               |    2 +-
 arch/powerpc/kernel/pci_of_scan.c          |    2 +-
 arch/powerpc/platforms/powernv/pci-ioda.c  |    8 ++--
 arch/powerpc/platforms/pseries/pci_dlpar.c |    2 +-
 arch/sh/drivers/pci/pci.c                  |    2 +-
 arch/sparc/kernel/pci.c                    |    6 +-
 arch/tile/kernel/pci.c                     |    4 +-
 arch/x86/pci/acpi.c                        |    2 +-
 arch/xtensa/kernel/pci.c                   |    2 +-
 drivers/iommu/intel-iommu.c                |    2 +-
 drivers/net/ethernet/broadcom/tg3.c        |    4 +-
 drivers/parisc/dino.c                      |   10 ++--
 drivers/parisc/iosapic.c                   |    2 +-
 drivers/parisc/lba_pci.c                   |   22 +++++-----
 drivers/pci/hotplug-pci.c                  |    4 +-
 drivers/pci/hotplug/acpiphp_glue.c         |    8 ++--
 drivers/pci/hotplug/shpchp_sysfs.c         |    6 +-
 drivers/pci/iov.c                          |    4 +-
 drivers/pci/pci.c                          |    2 +-
 drivers/pci/probe.c                        |   58 ++++++++++++++--------------
 drivers/pci/setup-bus.c                    |   24 ++++++------
 drivers/pcmcia/cardbus.c                   |    2 +-
 drivers/pcmcia/yenta_socket.c              |   26 ++++++------
 29 files changed, 111 insertions(+), 111 deletions(-)

diff --git a/arch/alpha/kernel/pci.c b/arch/alpha/kernel/pci.c
index 1a62963..53229a4 100644
--- a/arch/alpha/kernel/pci.c
+++ b/arch/alpha/kernel/pci.c
@@ -359,7 +359,7 @@ common_init_pci(void)
 					hose, &resources);
 		hose->bus = bus;
 		hose->need_domain_info = need_domain_info;
-		next_busno = bus->subordinate + 1;
+		next_busno = bus->busn_res.end + 1;
 		/* Don't allow 8-bit bus number overflow inside the hose -
 		   reserve some space for bridges. */ 
 		if (next_busno > 224) {
diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
index ede5f77..ea59205 100644
--- a/arch/arm/kernel/bios32.c
+++ b/arch/arm/kernel/bios32.c
@@ -445,7 +445,7 @@ static void __init pcibios_init_hw(struct hw_pci *hw)
 			if (!sys->bus)
 				panic("PCI: unable to scan bus!");
 
-			busnr = sys->bus->subordinate + 1;
+			busnr = sys->bus->busn_res.end + 1;
 
 			list_add(&sys->node, &hw->buses);
 		} else {
diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index 524df42..3ca9bed 100644
--- a/arch/ia64/pci/pci.c
+++ b/arch/ia64/pci/pci.c
@@ -384,7 +384,7 @@ pci_acpi_scan_root(struct acpi_pci_root *root)
 		return NULL;
 	}
 
-	pbus->subordinate = pci_scan_child_bus(pbus);
+	pbus->busn_res.end = pci_scan_child_bus(pbus);
 	return pbus;
 
 out3:
diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
index d10403d..0855008 100644
--- a/arch/microblaze/pci/pci-common.c
+++ b/arch/microblaze/pci/pci-common.c
@@ -1505,10 +1505,10 @@ static void __devinit pcibios_scan_phb(struct pci_controller *hose)
 		pci_free_resource_list(&resources);
 		return;
 	}
-	bus->secondary = hose->first_busno;
+	bus->busn_res.start = hose->first_busno;
 	hose->bus = bus;
 
-	hose->last_busno = bus->subordinate;
+	hose->last_busno = bus->busn_res.end;
 }
 
 static int __init pcibios_init(void)
diff --git a/arch/mips/pci/pci.c b/arch/mips/pci/pci.c
index 0514866..9ff3f85 100644
--- a/arch/mips/pci/pci.c
+++ b/arch/mips/pci/pci.c
@@ -101,7 +101,7 @@ static void __devinit pcibios_scanbus(struct pci_controller *hose)
 	need_domain_info = need_domain_info || hose->index;
 	hose->need_domain_info = need_domain_info;
 	if (bus) {
-		next_busno = bus->subordinate + 1;
+		next_busno = bus->busn_res.end + 1;
 		/* Don't allow 8-bit bus number overflow inside the hose -
 		   reserve some space for bridges. */
 		if (next_busno > 224) {
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index 8e78e93..3532b53 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -1646,7 +1646,7 @@ void __devinit pcibios_scan_phb(struct pci_controller *hose)
 		pci_free_resource_list(&resources);
 		return;
 	}
-	bus->secondary = hose->first_busno;
+	bus->busn_res.start = hose->first_busno;
 	hose->bus = bus;
 
 	/* Get probe mode and perform scan */
@@ -1655,12 +1655,12 @@ void __devinit pcibios_scan_phb(struct pci_controller *hose)
 		mode = ppc_md.pci_probe_mode(bus);
 	pr_debug("    probe mode: %d\n", mode);
 	if (mode == PCI_PROBE_DEVTREE) {
-		bus->subordinate = hose->last_busno;
+		bus->busn_res.end = hose->last_busno;
 		of_scan_bus(node, bus);
 	}
 
 	if (mode == PCI_PROBE_NORMAL)
-		hose->last_busno = bus->subordinate = pci_scan_child_bus(bus);
+		hose->last_busno = bus->busn_res.end = pci_scan_child_bus(bus);
 
 	/* Platform gets a chance to do some global fixups before
 	 * we proceed to resource allocation
diff --git a/arch/powerpc/kernel/pci_64.c b/arch/powerpc/kernel/pci_64.c
index 94a54f6..4ff190f 100644
--- a/arch/powerpc/kernel/pci_64.c
+++ b/arch/powerpc/kernel/pci_64.c
@@ -236,7 +236,7 @@ long sys_pciconfig_iobase(long which, unsigned long in_bus,
 
 	for (ln = pci_root_buses.next; ln != &pci_root_buses; ln = ln->next) {
 		bus = pci_bus_b(ln);
-		if (in_bus >= bus->number && in_bus <= bus->subordinate)
+		if (in_bus >= bus->number && in_bus <= bus->busn_res.end)
 			break;
 		bus = NULL;
 	}
diff --git a/arch/powerpc/kernel/pci_of_scan.c b/arch/powerpc/kernel/pci_of_scan.c
index 89dde17..a36281a 100644
--- a/arch/powerpc/kernel/pci_of_scan.c
+++ b/arch/powerpc/kernel/pci_of_scan.c
@@ -240,7 +240,7 @@ void __devinit of_scan_pci_bridge(struct pci_dev *dev)
 	}
 
 	bus->primary = dev->bus->number;
-	bus->subordinate = busrange[1];
+	bus->busn_res.end = busrange[1];
 	bus->bridge_ctl = 0;
 
 	/* parse ranges property */
diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index fbdd74d..9cda6a1 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -589,7 +589,7 @@ static int __devinit pnv_ioda_configure_pe(struct pnv_phb *phb,
 		dcomp = OPAL_IGNORE_RID_DEVICE_NUMBER;
 		fcomp = OPAL_IGNORE_RID_FUNCTION_NUMBER;
 		parent = pe->pbus->self;
-		count = pe->pbus->subordinate - pe->pbus->secondary + 1;
+		count = pe->pbus->busn_res.end - pe->pbus->busn_res.start + 1;
 		switch(count) {
 		case  1: bcomp = OpalPciBusAll;		break;
 		case  2: bcomp = OpalPciBus7Bits;	break;
@@ -816,11 +816,11 @@ static void __devinit pnv_ioda_setup_bus_PE(struct pci_dev *dev,
 	pe->pdev = NULL;
 	pe->tce32_seg = -1;
 	pe->mve_number = -1;
-	pe->rid = bus->secondary << 8;
+	pe->rid = bus->busn_res.start << 8;
 	pe->dma_weight = 0;
 
-	pe_info(pe, "Secondary busses %d..%d associated with PE\n",
-		bus->secondary, bus->subordinate);
+	pe_info(pe, "Secondary busses %pR associated with PE\n",
+		&bus->busn_res);
 
 	if (pnv_ioda_configure_pe(phb, pe)) {
 		/* XXX What do we do here ? */
diff --git a/arch/powerpc/platforms/pseries/pci_dlpar.c b/arch/powerpc/platforms/pseries/pci_dlpar.c
index 8b7bafa..3ccebc8 100644
--- a/arch/powerpc/platforms/pseries/pci_dlpar.c
+++ b/arch/powerpc/platforms/pseries/pci_dlpar.c
@@ -121,7 +121,7 @@ void pcibios_add_pci_devices(struct pci_bus * bus)
 		if (!num)
 			return;
 		pcibios_setup_bus_devices(bus);
-		max = bus->secondary;
+		max = bus->busn_res.start;
 		for (pass=0; pass < 2; pass++)
 			list_for_each_entry(dev, &bus->devices, bus_list) {
 			if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE ||
diff --git a/arch/sh/drivers/pci/pci.c b/arch/sh/drivers/pci/pci.c
index 9d10a3c..43068dc 100644
--- a/arch/sh/drivers/pci/pci.c
+++ b/arch/sh/drivers/pci/pci.c
@@ -59,7 +59,7 @@ static void __devinit pcibios_scanbus(struct pci_channel *hose)
 	need_domain_info = need_domain_info || hose->index;
 	hose->need_domain_info = need_domain_info;
 	if (bus) {
-		next_busno = bus->subordinate + 1;
+		next_busno = bus->busn_res.end + 1;
 		/* Don't allow 8-bit bus number overflow inside the hose -
 		   reserve some space for bridges. */
 		if (next_busno > 224) {
diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index fdaf218..c85bfd7 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -535,7 +535,7 @@ static void __devinit of_scan_pci_bridge(struct pci_pbm_info *pbm,
 	}
 
 	bus->primary = dev->bus->number;
-	bus->subordinate = busrange[1];
+	bus->busn_res.end = busrange[1];
 	bus->bridge_ctl = 0;
 
 	/* parse ranges property, or cook one up by hand for Simba */
@@ -693,8 +693,8 @@ struct pci_bus * __devinit pci_scan_one_pbm(struct pci_pbm_info *pbm,
 		pci_free_resource_list(&resources);
 		return NULL;
 	}
-	bus->secondary = pbm->pci_first_busno;
-	bus->subordinate = pbm->pci_last_busno;
+	bus->busn_res.start = pbm->pci_first_busno;
+	bus->busn_res.end = pbm->pci_last_busno;
 
 	pci_of_scan_bus(pbm, node, bus);
 	pci_bus_add_devices(bus);
diff --git a/arch/tile/kernel/pci.c b/arch/tile/kernel/pci.c
index a1bb59e..7aa2743 100644
--- a/arch/tile/kernel/pci.c
+++ b/arch/tile/kernel/pci.c
@@ -329,7 +329,7 @@ int __devinit pcibios_init(void)
 			 */
 			bus = pci_scan_bus(0, controller->ops, controller);
 			controller->root_bus = bus;
-			controller->last_busno = bus->subordinate;
+			controller->last_busno = bus->busn_res.end;
 		}
 	}
 
@@ -366,7 +366,7 @@ int __devinit pcibios_init(void)
 				 */
 				if ((dev->class >> 8) == PCI_CLASS_BRIDGE_PCI &&
 					(PCI_SLOT(dev->devfn) == 0)) {
-					next_bus = dev->subordinate;
+					next_bus = dev->busn_res.end;
 					controllers[i].mem_resources[0] =
 						*next_bus->resource[0];
 					controllers[i].mem_resources[1] =
diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index fc09c27..350fe63 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -440,7 +440,7 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 		bus = pci_create_root_bus(NULL, busnum, &pci_root_ops, sd,
 					  &resources);
 		if (bus) {
-			bus->subordinate = pci_scan_child_bus(bus);
+			bus->busn_res.end = pci_scan_child_bus(bus);
 			pci_set_host_bridge_release(
 				to_pci_host_bridge(bus->bridge),
 				release_pci_root_info, info);
diff --git a/arch/xtensa/kernel/pci.c b/arch/xtensa/kernel/pci.c
index eb30e35..9c57c1e 100644
--- a/arch/xtensa/kernel/pci.c
+++ b/arch/xtensa/kernel/pci.c
@@ -187,7 +187,7 @@ static int __init pcibios_init(void)
 		bus = pci_scan_root_bus(NULL, pci_ctrl->first_busno,
 					pci_ctrl->ops, pci_ctrl, &resources);
 		pci_ctrl->bus = bus;
-		pci_ctrl->last_busno = bus->subordinate;
+		pci_ctrl->last_busno = bus->busn_res.end;
 		if (next_busno <= pci_ctrl->last_busno)
 			next_busno = pci_ctrl->last_busno+1;
 	}
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index f93d5ac..b40aebd 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -660,7 +660,7 @@ static struct intel_iommu *device_to_iommu(int segment, u8 bus, u8 devfn)
 			if (drhd->devices[i] &&
 			    drhd->devices[i]->subordinate &&
 			    drhd->devices[i]->subordinate->number <= bus &&
-			    drhd->devices[i]->subordinate->subordinate >= bus)
+			    drhd->devices[i]->subordinate->busn_res.end >= bus)
 				return drhd->iommu;
 		}
 
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 062ac33..36b35b2 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -14127,7 +14127,7 @@ static int __devinit tg3_get_invariants(struct tg3 *tp)
 			if (bridge->subordinate &&
 			    (bridge->subordinate->number <=
 			     tp->pdev->bus->number) &&
-			    (bridge->subordinate->subordinate >=
+			    (bridge->subordinate->busn_res.end >=
 			     tp->pdev->bus->number)) {
 				tg3_flag_set(tp, 5701_DMA_BUG);
 				pci_dev_put(bridge);
@@ -14155,7 +14155,7 @@ static int __devinit tg3_get_invariants(struct tg3 *tp)
 			if (bridge && bridge->subordinate &&
 			    (bridge->subordinate->number <=
 			     tp->pdev->bus->number) &&
-			    (bridge->subordinate->subordinate >=
+			    (bridge->subordinate->busn_res.end >=
 			     tp->pdev->bus->number)) {
 				tg3_flag_set(tp, 40BIT_DMA_BUG);
 				pci_dev_put(bridge);
diff --git a/drivers/parisc/dino.c b/drivers/parisc/dino.c
index 432d4bb..70517b0 100644
--- a/drivers/parisc/dino.c
+++ b/drivers/parisc/dino.c
@@ -174,7 +174,7 @@ static int dino_cfg_read(struct pci_bus *bus, unsigned int devfn, int where,
 		int size, u32 *val)
 {
 	struct dino_device *d = DINO_DEV(parisc_walk_tree(bus->bridge));
-	u32 local_bus = (bus->parent == NULL) ? 0 : bus->secondary;
+	u32 local_bus = (bus->parent == NULL) ? 0 : bus->busn_res.start;
 	u32 v = DINO_CFG_TOK(local_bus, devfn, where & ~3);
 	void __iomem *base_addr = d->hba.base_addr;
 	unsigned long flags;
@@ -209,7 +209,7 @@ static int dino_cfg_write(struct pci_bus *bus, unsigned int devfn, int where,
 	int size, u32 val)
 {
 	struct dino_device *d = DINO_DEV(parisc_walk_tree(bus->bridge));
-	u32 local_bus = (bus->parent == NULL) ? 0 : bus->secondary;
+	u32 local_bus = (bus->parent == NULL) ? 0 : bus->busn_res.start;
 	u32 v = DINO_CFG_TOK(local_bus, devfn, where & ~3);
 	void __iomem *base_addr = d->hba.base_addr;
 	unsigned long flags;
@@ -554,7 +554,7 @@ dino_fixup_bus(struct pci_bus *bus)
         struct dino_device *dino_dev = DINO_DEV(parisc_walk_tree(bus->bridge));
 
 	DBG(KERN_WARNING "%s(0x%p) bus %d platform_data 0x%p\n",
-	    __func__, bus, bus->secondary,
+	    __func__, bus, bus->busn_res.start,
 	    bus->bridge->platform_data);
 
 	/* Firmware doesn't set up card-mode dino, so we have to */
@@ -998,12 +998,12 @@ static int __init dino_probe(struct parisc_device *dev)
 		return 0;
 	}
 
-	bus->subordinate = pci_scan_child_bus(bus);
+	bus->busn_res.end = pci_scan_child_bus(bus);
 
 	/* This code *depends* on scanning being single threaded
 	 * if it isn't, this global bus number count will fail
 	 */
-	dino_current_bus = bus->subordinate + 1;
+	dino_current_bus = bus->busn_res.end + 1;
 	pci_bus_assign_resources(bus);
 	pci_bus_add_devices(bus);
 	return 0;
diff --git a/drivers/parisc/iosapic.c b/drivers/parisc/iosapic.c
index 1f9e9fe..83380c8 100644
--- a/drivers/parisc/iosapic.c
+++ b/drivers/parisc/iosapic.c
@@ -532,7 +532,7 @@ iosapic_xlate_pin(struct iosapic_info *isi, struct pci_dev *pcidev)
 		intr_slot = PCI_SLOT(pcidev->devfn);
 	}
 	DBG_IRT("iosapic_xlate_pin:  bus %d slot %d pin %d\n",
-				pcidev->bus->secondary, intr_slot, intr_pin);
+			pcidev->bus->busn_res.start, intr_slot, intr_pin);
 
 	return irt_find_irqline(isi, intr_slot, intr_pin);
 }
diff --git a/drivers/parisc/lba_pci.c b/drivers/parisc/lba_pci.c
index 052fa23..cd8f9ce 100644
--- a/drivers/parisc/lba_pci.c
+++ b/drivers/parisc/lba_pci.c
@@ -189,8 +189,8 @@ lba_dump_res(struct resource *r, int d)
 
 static int lba_device_present(u8 bus, u8 dfn, struct lba_device *d)
 {
-	u8 first_bus = d->hba.hba_bus->secondary;
-	u8 last_sub_bus = d->hba.hba_bus->subordinate;
+	u8 first_bus = d->hba.hba_bus->busn_res.start;
+	u8 last_sub_bus = d->hba.hba_bus->busn_res.end;
 
 	if ((bus < first_bus) ||
 	    (bus > last_sub_bus) ||
@@ -364,7 +364,7 @@ lba_rd_cfg(struct lba_device *d, u32 tok, u8 reg, u32 size)
 static int elroy_cfg_read(struct pci_bus *bus, unsigned int devfn, int pos, int size, u32 *data)
 {
 	struct lba_device *d = LBA_DEV(parisc_walk_tree(bus->bridge));
-	u32 local_bus = (bus->parent == NULL) ? 0 : bus->secondary;
+	u32 local_bus = (bus->parent == NULL) ? 0 : bus->busn_res.start;
 	u32 tok = LBA_CFG_TOK(local_bus, devfn);
 	void __iomem *data_reg = d->hba.base_addr + LBA_PCI_CFG_DATA;
 
@@ -380,7 +380,7 @@ static int elroy_cfg_read(struct pci_bus *bus, unsigned int devfn, int pos, int
 		return 0;
 	}
 
-	if (LBA_SKIP_PROBE(d) && !lba_device_present(bus->secondary, devfn, d)) {
+	if (LBA_SKIP_PROBE(d) && !lba_device_present(bus->busn_res.start, devfn, d)) {
 		DBG_CFG("%s(%x+%2x) -> -1 (b)\n", __func__, tok, pos);
 		/* either don't want to look or know device isn't present. */
 		*data = ~0U;
@@ -431,7 +431,7 @@ lba_wr_cfg(struct lba_device *d, u32 tok, u8 reg, u32 data, u32 size)
 static int elroy_cfg_write(struct pci_bus *bus, unsigned int devfn, int pos, int size, u32 data)
 {
 	struct lba_device *d = LBA_DEV(parisc_walk_tree(bus->bridge));
-	u32 local_bus = (bus->parent == NULL) ? 0 : bus->secondary;
+	u32 local_bus = (bus->parent == NULL) ? 0 : bus->busn_res.start;
 	u32 tok = LBA_CFG_TOK(local_bus,devfn);
 
 	if ((pos > 255) || (devfn > 255))
@@ -444,7 +444,7 @@ static int elroy_cfg_write(struct pci_bus *bus, unsigned int devfn, int pos, int
 		return 0;
 	}
 
-	if (LBA_SKIP_PROBE(d) && (!lba_device_present(bus->secondary, devfn, d))) {
+	if (LBA_SKIP_PROBE(d) && (!lba_device_present(bus->busn_res.start, devfn, d))) {
 		DBG_CFG("%s(%x+%2x) = 0x%x (b)\n", __func__, tok, pos,data);
 		return 1; /* New Workaround */
 	}
@@ -481,7 +481,7 @@ static struct pci_ops elroy_cfg_ops = {
 static int mercury_cfg_read(struct pci_bus *bus, unsigned int devfn, int pos, int size, u32 *data)
 {
 	struct lba_device *d = LBA_DEV(parisc_walk_tree(bus->bridge));
-	u32 local_bus = (bus->parent == NULL) ? 0 : bus->secondary;
+	u32 local_bus = (bus->parent == NULL) ? 0 : bus->busn_res.start;
 	u32 tok = LBA_CFG_TOK(local_bus, devfn);
 	void __iomem *data_reg = d->hba.base_addr + LBA_PCI_CFG_DATA;
 
@@ -514,7 +514,7 @@ static int mercury_cfg_write(struct pci_bus *bus, unsigned int devfn, int pos, i
 {
 	struct lba_device *d = LBA_DEV(parisc_walk_tree(bus->bridge));
 	void __iomem *data_reg = d->hba.base_addr + LBA_PCI_CFG_DATA;
-	u32 local_bus = (bus->parent == NULL) ? 0 : bus->secondary;
+	u32 local_bus = (bus->parent == NULL) ? 0 : bus->busn_res.start;
 	u32 tok = LBA_CFG_TOK(local_bus,devfn);
 
 	if ((pos > 255) || (devfn > 255))
@@ -636,7 +636,7 @@ lba_fixup_bus(struct pci_bus *bus)
 	struct lba_device *ldev = LBA_DEV(parisc_walk_tree(bus->bridge));
 
 	DBG("lba_fixup_bus(0x%p) bus %d platform_data 0x%p\n",
-		bus, bus->secondary, bus->bridge->platform_data);
+		bus, (int)bus->busn_res.start, bus->bridge->platform_data);
 
 	/*
 	** Properly Setup MMIO resources for this bus.
@@ -1511,7 +1511,7 @@ lba_driver_probe(struct parisc_device *dev)
 		return 0;
 	}
 
-	lba_bus->subordinate = pci_scan_child_bus(lba_bus);
+	lba_bus->busn_res.end = pci_scan_child_bus(lba_bus);
 
 	/* This is in lieu of calling pci_assign_unassigned_resources() */
 	if (is_pdc_pat()) {
@@ -1541,7 +1541,7 @@ lba_driver_probe(struct parisc_device *dev)
 		lba_dev->flags |= LBA_FLAG_SKIP_PROBE;
 	}
 
-	lba_next_bus = lba_bus->subordinate + 1;
+	lba_next_bus = lba_res->busn_res.end + 1;
 	pci_bus_add_devices(lba_bus);
 
 	/* Whew! Finally done! Tell services we got this one covered. */
diff --git a/drivers/pci/hotplug-pci.c b/drivers/pci/hotplug-pci.c
index 01eae34..6258dc2 100644
--- a/drivers/pci/hotplug-pci.c
+++ b/drivers/pci/hotplug-pci.c
@@ -7,8 +7,8 @@
 int __ref pci_hp_add_bridge(struct pci_dev *dev)
 {
 	struct pci_bus *parent = dev->bus;
-	int pass, busnr, start = parent->secondary;
-	int end = parent->subordinate;
+	int pass, busnr, start = parent->busn_res.start;
+	int end = parent->busn_res.end;
 
 	for (busnr = start; busnr <= end; busnr++) {
 		if (!pci_find_bus(pci_domain_nr(parent), busnr))
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 806c44f..62d0ae4 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -100,11 +100,11 @@ static int post_dock_fixups(struct notifier_block *nb, unsigned long val,
 			PCI_PRIMARY_BUS,
 			&buses);
 
-	if (((buses >> 8) & 0xff) != bus->secondary) {
+	if (((buses >> 8) & 0xff) != bus->busn_res.start) {
 		buses = (buses & 0xff000000)
 			| ((unsigned int)(bus->primary)     <<  0)
-			| ((unsigned int)(bus->secondary)   <<  8)
-			| ((unsigned int)(bus->subordinate) << 16);
+			| ((unsigned int)(bus->busn_res.start)   <<  8)
+			| ((unsigned int)(bus->busn_res.end) << 16);
 		pci_write_config_dword(bus->self, PCI_PRIMARY_BUS, buses);
 	}
 	return NOTIFY_OK;
@@ -692,7 +692,7 @@ static unsigned char acpiphp_max_busnr(struct pci_bus *bus)
 	 * bus->subordinate value because it could have
 	 * padding in it.
 	 */
-	max = bus->secondary;
+	max = bus->busn_res.start;
 
 	list_for_each(tmp, &bus->children) {
 		n = pci_bus_max_busnr(pci_bus_b(tmp));
diff --git a/drivers/pci/hotplug/shpchp_sysfs.c b/drivers/pci/hotplug/shpchp_sysfs.c
index efa30da..eeb23ce 100644
--- a/drivers/pci/hotplug/shpchp_sysfs.c
+++ b/drivers/pci/hotplug/shpchp_sysfs.c
@@ -73,13 +73,13 @@ static ssize_t show_ctrl (struct device *dev, struct device_attribute *attr, cha
 		}
 	}
 	out += sprintf(out, "Free resources: bus numbers\n");
-	for (busnr = bus->secondary; busnr <= bus->subordinate; busnr++) {
+	for (busnr = bus->busn_res.start; busnr <= bus->busn_res.end; busnr++) {
 		if (!pci_find_bus(pci_domain_nr(bus), busnr))
 			break;
 	}
-	if (busnr < bus->subordinate)
+	if (busnr < bus->busn_res.end)
 		out += sprintf(out, "start = %8.8x, length = %8.8x\n",
-				busnr, (bus->subordinate - busnr));
+				busnr, (int)(bus->busn_res.end - busnr));
 
 	return out - buf;
 }
diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 6554e1a..e873060 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -47,7 +47,7 @@ static struct pci_bus *virtfn_add_bus(struct pci_bus *bus, int busnr)
 	if (!child)
 		return NULL;
 
-	child->subordinate = busnr;
+	child->busn_res.end = busnr;
 	child->dev.parent = bus->bridge;
 	rc = pci_bus_add_child(child);
 	if (rc) {
@@ -327,7 +327,7 @@ static int sriov_enable(struct pci_dev *dev, int nr_virtfn)
 	iov->offset = offset;
 	iov->stride = stride;
 
-	if (virtfn_bus(dev, nr_virtfn - 1) > dev->bus->subordinate) {
+	if (virtfn_bus(dev, nr_virtfn - 1) > dev->bus->busn_res.end) {
 		dev_err(&dev->dev, "SR-IOV: bus number out of range\n");
 		return -ENOMEM;
 	}
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 8f16900..1ef809b 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -110,7 +110,7 @@ unsigned char pci_bus_max_busnr(struct pci_bus* bus)
 	struct list_head *tmp;
 	unsigned char max, n;
 
-	max = bus->subordinate;
+	max = bus->busn_res.end;
 	list_for_each(tmp, &bus->children) {
 		n = pci_bus_max_busnr(pci_bus_b(tmp));
 		if(n > max)
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 658ac97..651b096 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -381,8 +381,8 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 	if (pci_is_root_bus(child))	/* It's a host bus, nothing to read */
 		return;
 
-	dev_info(&dev->dev, "PCI bridge to [bus %02x-%02x]%s\n",
-		 child->secondary, child->subordinate,
+	dev_info(&dev->dev, "PCI bridge to %pR%s\n",
+		 &child->busn_res,
 		 dev->transparent ? " (subtractive decode)" : "");
 
 	pci_bus_remove_resources(child);
@@ -599,9 +599,9 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
 	 * Set up the primary, secondary and subordinate
 	 * bus numbers.
 	 */
-	child->number = child->secondary = busnr;
-	child->primary = parent->secondary;
-	child->subordinate = 0xff;
+	child->number = child->busn_res.start = busnr;
+	child->primary = parent->busn_res.start;
+	child->busn_res.end = 0xff;
 
 	if (!bridge)
 		return child;
@@ -643,8 +643,8 @@ static void pci_fixup_parent_subordinate_busnr(struct pci_bus *child, int max)
 	if (!pcibios_assign_all_busses())
 		return;
 
-	while (parent->parent && parent->subordinate < max) {
-		parent->subordinate = max;
+	while (parent->parent && parent->busn_res.end < max) {
+		parent->busn_res.end = max;
 		pci_write_config_byte(parent->self, PCI_SUBORDINATE_BUS, max);
 		parent = parent->parent;
 	}
@@ -718,15 +718,15 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 			if (!child)
 				goto out;
 			child->primary = primary;
-			child->subordinate = subordinate;
+			child->busn_res.end = subordinate;
 			child->bridge_ctl = bctl;
 		}
 
 		cmax = pci_scan_child_bus(child);
 		if (cmax > max)
 			max = cmax;
-		if (child->subordinate > max)
-			max = child->subordinate;
+		if (child->busn_res.end > max)
+			max = child->busn_res.end;
 	} else {
 		/*
 		 * We need to assign a number to this bus which we always
@@ -759,8 +759,8 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 		}
 		buses = (buses & 0xff000000)
 		      | ((unsigned int)(child->primary)     <<  0)
-		      | ((unsigned int)(child->secondary)   <<  8)
-		      | ((unsigned int)(child->subordinate) << 16);
+		      | ((unsigned int)(child->busn_res.start)   <<  8)
+		      | ((unsigned int)(child->busn_res.end) << 16);
 
 		/*
 		 * yenta.c forces a secondary latency timer of 176.
@@ -805,8 +805,8 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 					break;
 				while (parent->parent) {
 					if ((!pcibios_assign_all_busses()) &&
-					    (parent->subordinate > max) &&
-					    (parent->subordinate <= max+i)) {
+					    (parent->busn_res.end > max) &&
+					    (parent->busn_res.end <= max+i)) {
 						j = 1;
 					}
 					parent = parent->parent;
@@ -827,7 +827,7 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 		/*
 		 * Set the subordinate bus number to its real value.
 		 */
-		child->subordinate = max;
+		child->busn_res.end = max;
 		pci_write_config_byte(dev, PCI_SUBORDINATE_BUS, max);
 	}
 
@@ -837,19 +837,19 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 
 	/* Has only triggered on CardBus, fixup is in yenta_socket */
 	while (bus->parent) {
-		if ((child->subordinate > bus->subordinate) ||
-		    (child->number > bus->subordinate) ||
+		if ((child->busn_res.end > bus->busn_res.end) ||
+		    (child->number > bus->busn_res.end) ||
 		    (child->number < bus->number) ||
-		    (child->subordinate < bus->number)) {
-			dev_info(&child->dev, "[bus %02x-%02x] %s "
-				"hidden behind%s bridge %s [bus %02x-%02x]\n",
-				child->number, child->subordinate,
-				(bus->number > child->subordinate &&
-				 bus->subordinate < child->number) ?
+		    (child->busn_res.end < bus->number)) {
+			dev_info(&child->dev, "%pR %s "
+				"hidden behind%s bridge %s %pR\n",
+				&child->busn_res,
+				(bus->number > child->busn_res.end &&
+				 bus->busn_res.end < child->number) ?
 					"wholly" : "partially",
 				bus->self->transparent ? " transparent" : "",
 				dev_name(&bus->dev),
-				bus->number, bus->subordinate);
+				&bus->busn_res);
 		}
 		bus = bus->parent;
 	}
@@ -1548,7 +1548,7 @@ EXPORT_SYMBOL_GPL(pcie_bus_configure_settings);
 
 unsigned int __devinit pci_scan_child_bus(struct pci_bus *bus)
 {
-	unsigned int devfn, pass, max = bus->secondary;
+	unsigned int devfn, pass, max = bus->busn_res.start;
 	struct pci_dev *dev;
 
 	dev_dbg(&bus->dev, "scanning bus\n");
@@ -1642,7 +1642,7 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 	/* Create legacy_io and legacy_mem files for this bus */
 	pci_create_legacy_files(b);
 
-	b->number = b->secondary = bus;
+	b->number = b->busn_res.start = bus;
 
 	if (parent)
 		dev_info(parent, "PCI host bridge to bus %s\n", dev_name(&b->dev));
@@ -1693,7 +1693,7 @@ struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, int bus,
 	if (!b)
 		return NULL;
 
-	b->subordinate = pci_scan_child_bus(b);
+	b->busn_res.end = pci_scan_child_bus(b);
 	pci_bus_add_devices(b);
 	return b;
 }
@@ -1710,7 +1710,7 @@ struct pci_bus * __devinit pci_scan_bus_parented(struct device *parent,
 	pci_add_resource(&resources, &iomem_resource);
 	b = pci_create_root_bus(parent, bus, ops, sysdata, &resources);
 	if (b)
-		b->subordinate = pci_scan_child_bus(b);
+		b->busn_res.end = pci_scan_child_bus(b);
 	else
 		pci_free_resource_list(&resources);
 	return b;
@@ -1727,7 +1727,7 @@ struct pci_bus * __devinit pci_scan_bus(int bus, struct pci_ops *ops,
 	pci_add_resource(&resources, &iomem_resource);
 	b = pci_create_root_bus(NULL, bus, ops, sysdata, &resources);
 	if (b) {
-		b->subordinate = pci_scan_child_bus(b);
+		b->busn_res.end = pci_scan_child_bus(b);
 		pci_bus_add_devices(b);
 	} else {
 		pci_free_resource_list(&resources);
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 8fa2d4b..192172c 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -404,8 +404,8 @@ void pci_setup_cardbus(struct pci_bus *bus)
 	struct resource *res;
 	struct pci_bus_region region;
 
-	dev_info(&bridge->dev, "CardBus bridge to [bus %02x-%02x]\n",
-		 bus->secondary, bus->subordinate);
+	dev_info(&bridge->dev, "CardBus bridge to %pR\n",
+		 &bus->busn_res);
 
 	res = bus->resource[0];
 	pcibios_resource_to_bus(bridge, &region, res);
@@ -553,8 +553,8 @@ static void __pci_setup_bridge(struct pci_bus *bus, unsigned long type)
 {
 	struct pci_dev *bridge = bus->self;
 
-	dev_info(&bridge->dev, "PCI bridge to [bus %02x-%02x]\n",
-		 bus->secondary, bus->subordinate);
+	dev_info(&bridge->dev, "PCI bridge to %pR\n",
+		 &bus->busn_res);
 
 	if (type & IORESOURCE_IO)
 		pci_setup_bridge_io(bus);
@@ -745,8 +745,8 @@ static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size,
 	if (!size0 && !size1) {
 		if (b_res->start || b_res->end)
 			dev_info(&bus->self->dev, "disabling bridge window "
-				 "%pR to [bus %02x-%02x] (unused)\n", b_res,
-				 bus->secondary, bus->subordinate);
+				 "%pR to %pR (unused)\n", b_res,
+				 &bus->busn_res);
 		b_res->flags = 0;
 		return;
 	}
@@ -757,8 +757,8 @@ static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size,
 	if (size1 > size0 && realloc_head) {
 		add_to_list(realloc_head, bus->self, b_res, size1-size0, 4096);
 		dev_printk(KERN_DEBUG, &bus->self->dev, "bridge window "
-				 "%pR to [bus %02x-%02x] add_size %lx\n", b_res,
-				 bus->secondary, bus->subordinate, size1-size0);
+				 "%pR to %pR add_size %lx\n", b_res,
+				 &bus->busn_res, size1-size0);
 	}
 }
 
@@ -863,8 +863,8 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 	if (!size0 && !size1) {
 		if (b_res->start || b_res->end)
 			dev_info(&bus->self->dev, "disabling bridge window "
-				 "%pR to [bus %02x-%02x] (unused)\n", b_res,
-				 bus->secondary, bus->subordinate);
+				 "%pR to %pR (unused)\n", b_res,
+				 &bus->busn_res);
 		b_res->flags = 0;
 		return 1;
 	}
@@ -874,8 +874,8 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 	if (size1 > size0 && realloc_head) {
 		add_to_list(realloc_head, bus->self, b_res, size1-size0, min_align);
 		dev_printk(KERN_DEBUG, &bus->self->dev, "bridge window "
-				 "%pR to [bus %02x-%02x] add_size %llx\n", b_res,
-				 bus->secondary, bus->subordinate, (unsigned long long)size1-size0);
+				 "%pR to %pR add_size %llx\n", b_res,
+				 &bus->busn_res, (unsigned long long)size1-size0);
 	}
 	return 1;
 }
diff --git a/drivers/pcmcia/cardbus.c b/drivers/pcmcia/cardbus.c
index 6e75153..24caeaf 100644
--- a/drivers/pcmcia/cardbus.c
+++ b/drivers/pcmcia/cardbus.c
@@ -73,7 +73,7 @@ int __ref cb_alloc(struct pcmcia_socket *s)
 	s->functions = pci_scan_slot(bus, PCI_DEVFN(0, 0));
 	pci_fixup_cardbus(bus);
 
-	max = bus->secondary;
+	max = bus->busn_res.start;
 	for (pass = 0; pass < 2; pass++)
 		list_for_each_entry(dev, &bus->devices, bus_list)
 			if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE ||
diff --git a/drivers/pcmcia/yenta_socket.c b/drivers/pcmcia/yenta_socket.c
index d07f9ac..667678d 100644
--- a/drivers/pcmcia/yenta_socket.c
+++ b/drivers/pcmcia/yenta_socket.c
@@ -1048,8 +1048,8 @@ static void yenta_config_init(struct yenta_socket *socket)
 	config_writeb(socket, PCI_LATENCY_TIMER, 168);
 	config_writel(socket, PCI_PRIMARY_BUS,
 		(176 << 24) |			   /* sec. latency timer */
-		(dev->subordinate->subordinate << 16) | /* subordinate bus */
-		(dev->subordinate->secondary << 8) |  /* secondary bus */
+		((unsigned int)dev->subordinate->busn_res.end << 16) | /* subordinate bus */
+		((unsigned int)dev->subordinate->busn_res.start << 8) |  /* secondary bus */
 		dev->subordinate->primary);		   /* primary bus */
 
 	/*
@@ -1086,14 +1086,14 @@ static void yenta_fixup_parent_bridge(struct pci_bus *cardbus_bridge)
 	struct pci_bus *bridge_to_fix = cardbus_bridge->parent;
 
 	/* Check bus numbers are already set up correctly: */
-	if (bridge_to_fix->subordinate >= cardbus_bridge->subordinate)
+	if (bridge_to_fix->busn_res.end >= cardbus_bridge->busn_res.end)
 		return; /* The subordinate number is ok, nothing to do */
 
 	if (!bridge_to_fix->parent)
 		return; /* Root bridges are ok */
 
 	/* stay within the limits of the bus range of the parent: */
-	upper_limit = bridge_to_fix->parent->subordinate;
+	upper_limit = bridge_to_fix->parent->busn_res.end;
 
 	/* check the bus ranges of all silbling bridges to prevent overlap */
 	list_for_each(tmp, &bridge_to_fix->parent->children) {
@@ -1104,36 +1104,36 @@ static void yenta_fixup_parent_bridge(struct pci_bus *cardbus_bridge)
 		 * current upper limit, set the new upper limit to
 		 * the bus number below the silbling's range:
 		 */
-		if (silbling->secondary > bridge_to_fix->subordinate
-		    && silbling->secondary <= upper_limit)
-			upper_limit = silbling->secondary - 1;
+		if (silbling->busn_res.start > bridge_to_fix->busn_res.end
+		    && silbling->busn_res.start <= upper_limit)
+			upper_limit = silbling->busn_res.start - 1;
 	}
 
 	/* Show that the wanted subordinate number is not possible: */
-	if (cardbus_bridge->subordinate > upper_limit)
+	if (cardbus_bridge->busn_res.end > upper_limit)
 		dev_printk(KERN_WARNING, &cardbus_bridge->dev,
 			   "Upper limit for fixing this "
 			   "bridge's parent bridge: #%02x\n", upper_limit);
 
 	/* If we have room to increase the bridge's subordinate number, */
-	if (bridge_to_fix->subordinate < upper_limit) {
+	if (bridge_to_fix->busn_res.end < upper_limit) {
 
 		/* use the highest number of the hidden bus, within limits */
 		unsigned char subordinate_to_assign =
-			min(cardbus_bridge->subordinate, upper_limit);
+			min_t(int, cardbus_bridge->busn_res.end, upper_limit);
 
 		dev_printk(KERN_INFO, &bridge_to_fix->dev,
 			   "Raising subordinate bus# of parent "
 			   "bus (#%02x) from #%02x to #%02x\n",
 			   bridge_to_fix->number,
-			   bridge_to_fix->subordinate, subordinate_to_assign);
+			   (int)bridge_to_fix->busn_res.end, subordinate_to_assign);
 
 		/* Save the new subordinate in the bus struct of the bridge */
-		bridge_to_fix->subordinate = subordinate_to_assign;
+		bridge_to_fix->busn_res.end = subordinate_to_assign;
 
 		/* and update the PCI config space with the new subordinate */
 		pci_write_config_byte(bridge_to_fix->self,
-			PCI_SUBORDINATE_BUS, bridge_to_fix->subordinate);
+			PCI_SUBORDINATE_BUS, bridge_to_fix->busn_res.end);
 	}
 }
 
-- 
1.7.7

