Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342Ab1HXAub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 20:50:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:8460 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756107Ab1HXAtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 20:49:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="41195064"
Message-Id: <20110824001456.282401285@sbsiddha-desk.sc.intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 23 Aug 2011 17:05:20 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, dwmw2@infradead.org
Cc: yinghai@kernel.org, youquan.song@intel.com, joerg.roedel@amd.com,
        tony.luck@intel.com, linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 3/8] iommu: move IOMMU specific code to intel-iommu.c
References: <20110824000517.710353624@sbsiddha-desk.sc.intel.com>
Content-Disposition: inline; filename=mv-iommu-routines-to-intel-iommu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the IOMMU specific routines to intel-iommu.c leaving the dmar.c
to the common ACPI dmar code shared between DMA-remapping and
Interrupt-remapping.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 drivers/iommu/dmar.c          |  171 +-----------------------------------------
 drivers/iommu/intel-iommu.c   |  151 +++++++++++++++++++++++++++++++++++++
 include/linux/dma_remapping.h |    5 -
 include/linux/dmar.h          |   17 ++++
 4 files changed, 180 insertions(+), 164 deletions(-)

Index: tree/drivers/iommu/dmar.c
===================================================================
--- tree.orig/drivers/iommu/dmar.c
+++ tree/drivers/iommu/dmar.c
@@ -118,8 +118,8 @@ static int __init dmar_parse_one_dev_sco
 	return 0;
 }
 
-static int __init dmar_parse_dev_scope(void *start, void *end, int *cnt,
-				       struct pci_dev ***devices, u16 segment)
+int __init dmar_parse_dev_scope(void *start, void *end, int *cnt,
+				struct pci_dev ***devices, u16 segment)
 {
 	struct acpi_dmar_device_scope *scope;
 	void * tmp = start;
@@ -217,133 +217,6 @@ static int __init dmar_parse_dev(struct 
 	return ret;
 }
 
-#ifdef CONFIG_DMAR
-LIST_HEAD(dmar_rmrr_units);
-
-static void __init dmar_register_rmrr_unit(struct dmar_rmrr_unit *rmrr)
-{
-	list_add(&rmrr->list, &dmar_rmrr_units);
-}
-
-
-static int __init
-dmar_parse_one_rmrr(struct acpi_dmar_header *header)
-{
-	struct acpi_dmar_reserved_memory *rmrr;
-	struct dmar_rmrr_unit *rmrru;
-
-	rmrru = kzalloc(sizeof(*rmrru), GFP_KERNEL);
-	if (!rmrru)
-		return -ENOMEM;
-
-	rmrru->hdr = header;
-	rmrr = (struct acpi_dmar_reserved_memory *)header;
-	rmrru->base_address = rmrr->base_address;
-	rmrru->end_address = rmrr->end_address;
-
-	dmar_register_rmrr_unit(rmrru);
-	return 0;
-}
-
-static int __init
-rmrr_parse_dev(struct dmar_rmrr_unit *rmrru)
-{
-	struct acpi_dmar_reserved_memory *rmrr;
-	int ret;
-
-	rmrr = (struct acpi_dmar_reserved_memory *) rmrru->hdr;
-	ret = dmar_parse_dev_scope((void *)(rmrr + 1),
-		((void *)rmrr) + rmrr->header.length,
-		&rmrru->devices_cnt, &rmrru->devices, rmrr->segment);
-
-	if (ret || (rmrru->devices_cnt == 0)) {
-		list_del(&rmrru->list);
-		kfree(rmrru);
-	}
-	return ret;
-}
-
-static LIST_HEAD(dmar_atsr_units);
-
-static int __init dmar_parse_one_atsr(struct acpi_dmar_header *hdr)
-{
-	struct acpi_dmar_atsr *atsr;
-	struct dmar_atsr_unit *atsru;
-
-	atsr = container_of(hdr, struct acpi_dmar_atsr, header);
-	atsru = kzalloc(sizeof(*atsru), GFP_KERNEL);
-	if (!atsru)
-		return -ENOMEM;
-
-	atsru->hdr = hdr;
-	atsru->include_all = atsr->flags & 0x1;
-
-	list_add(&atsru->list, &dmar_atsr_units);
-
-	return 0;
-}
-
-static int __init atsr_parse_dev(struct dmar_atsr_unit *atsru)
-{
-	int rc;
-	struct acpi_dmar_atsr *atsr;
-
-	if (atsru->include_all)
-		return 0;
-
-	atsr = container_of(atsru->hdr, struct acpi_dmar_atsr, header);
-	rc = dmar_parse_dev_scope((void *)(atsr + 1),
-				(void *)atsr + atsr->header.length,
-				&atsru->devices_cnt, &atsru->devices,
-				atsr->segment);
-	if (rc || !atsru->devices_cnt) {
-		list_del(&atsru->list);
-		kfree(atsru);
-	}
-
-	return rc;
-}
-
-int dmar_find_matched_atsr_unit(struct pci_dev *dev)
-{
-	int i;
-	struct pci_bus *bus;
-	struct acpi_dmar_atsr *atsr;
-	struct dmar_atsr_unit *atsru;
-
-	dev = pci_physfn(dev);
-
-	list_for_each_entry(atsru, &dmar_atsr_units, list) {
-		atsr = container_of(atsru->hdr, struct acpi_dmar_atsr, header);
-		if (atsr->segment == pci_domain_nr(dev->bus))
-			goto found;
-	}
-
-	return 0;
-
-found:
-	for (bus = dev->bus; bus; bus = bus->parent) {
-		struct pci_dev *bridge = bus->self;
-
-		if (!bridge || !pci_is_pcie(bridge) ||
-		    bridge->pcie_type == PCI_EXP_TYPE_PCI_BRIDGE)
-			return 0;
-
-		if (bridge->pcie_type == PCI_EXP_TYPE_ROOT_PORT) {
-			for (i = 0; i < atsru->devices_cnt; i++)
-				if (atsru->devices[i] == bridge)
-					return 1;
-			break;
-		}
-	}
-
-	if (atsru->include_all)
-		return 1;
-
-	return 0;
-}
-#endif
-
 #ifdef CONFIG_ACPI_NUMA
 static int __init
 dmar_parse_one_rhsa(struct acpi_dmar_header *header)
@@ -484,14 +357,10 @@ parse_dmar_table(void)
 			ret = dmar_parse_one_drhd(entry_header);
 			break;
 		case ACPI_DMAR_TYPE_RESERVED_MEMORY:
-#ifdef CONFIG_DMAR
 			ret = dmar_parse_one_rmrr(entry_header);
-#endif
 			break;
 		case ACPI_DMAR_TYPE_ATSR:
-#ifdef CONFIG_DMAR
 			ret = dmar_parse_one_atsr(entry_header);
-#endif
 			break;
 		case ACPI_DMAR_HARDWARE_AFFINITY:
 #ifdef CONFIG_ACPI_NUMA
@@ -564,30 +433,18 @@ int __init dmar_dev_scope_init(void)
 	if (dmar_dev_scope_initialized)
 		return dmar_dev_scope_initialized;
 
+	if (list_empty(&dmar_drhd_units))
+		goto fail;
+
 	list_for_each_entry_safe(drhd, drhd_n, &dmar_drhd_units, list) {
 		ret = dmar_parse_dev(drhd);
 		if (ret)
 			goto fail;
 	}
 
-#ifdef CONFIG_DMAR
-	{
-		struct dmar_rmrr_unit *rmrr, *rmrr_n;
-		struct dmar_atsr_unit *atsr, *atsr_n;
-
-		list_for_each_entry_safe(rmrr, rmrr_n, &dmar_rmrr_units, list) {
-			ret = rmrr_parse_dev(rmrr);
-			if (ret)
-				goto fail;
-		}
-
-		list_for_each_entry_safe(atsr, atsr_n, &dmar_atsr_units, list) {
-			ret = atsr_parse_dev(atsr);
-			if (ret)
-				goto fail;
-		}
-	}
-#endif
+	ret = dmar_parse_rmrr_atsr_dev();
+	if (ret)
+		goto fail;
 
 	dmar_dev_scope_initialized = 1;
 	return 0;
@@ -620,14 +477,6 @@ int __init dmar_table_init(void)
 		return -ENODEV;
 	}
 
-#ifdef CONFIG_DMAR
-	if (list_empty(&dmar_rmrr_units))
-		printk(KERN_INFO PREFIX "No RMRR found\n");
-
-	if (list_empty(&dmar_atsr_units))
-		printk(KERN_INFO PREFIX "No ATSR found\n");
-#endif
-
 	return 0;
 }
 
@@ -767,7 +616,6 @@ int alloc_iommu(struct dmar_drhd_unit *d
 		goto err_unmap;
 	}
 
-#ifdef CONFIG_DMAR
 	agaw = iommu_calculate_agaw(iommu);
 	if (agaw < 0) {
 		printk(KERN_ERR
@@ -782,7 +630,6 @@ int alloc_iommu(struct dmar_drhd_unit *d
 			iommu->seq_id);
 		goto err_unmap;
 	}
-#endif
 	iommu->agaw = agaw;
 	iommu->msagaw = msagaw;
 
@@ -826,9 +673,7 @@ void free_iommu(struct intel_iommu *iomm
 	if (!iommu)
 		return;
 
-#ifdef CONFIG_DMAR
 	free_dmar_iommu(iommu);
-#endif
 
 	if (iommu->reg)
 		iounmap(iommu->reg);
Index: tree/drivers/iommu/intel-iommu.c
===================================================================
--- tree.orig/drivers/iommu/intel-iommu.c
+++ tree/drivers/iommu/intel-iommu.c
@@ -3390,6 +3390,151 @@ static void __init init_iommu_pm_ops(voi
 static inline void init_iommu_pm_ops(void) {}
 #endif	/* CONFIG_PM */
 
+LIST_HEAD(dmar_rmrr_units);
+
+static void __init dmar_register_rmrr_unit(struct dmar_rmrr_unit *rmrr)
+{
+	list_add(&rmrr->list, &dmar_rmrr_units);
+}
+
+
+int __init dmar_parse_one_rmrr(struct acpi_dmar_header *header)
+{
+	struct acpi_dmar_reserved_memory *rmrr;
+	struct dmar_rmrr_unit *rmrru;
+
+	rmrru = kzalloc(sizeof(*rmrru), GFP_KERNEL);
+	if (!rmrru)
+		return -ENOMEM;
+
+	rmrru->hdr = header;
+	rmrr = (struct acpi_dmar_reserved_memory *)header;
+	rmrru->base_address = rmrr->base_address;
+	rmrru->end_address = rmrr->end_address;
+
+	dmar_register_rmrr_unit(rmrru);
+	return 0;
+}
+
+static int __init
+rmrr_parse_dev(struct dmar_rmrr_unit *rmrru)
+{
+	struct acpi_dmar_reserved_memory *rmrr;
+	int ret;
+
+	rmrr = (struct acpi_dmar_reserved_memory *) rmrru->hdr;
+	ret = dmar_parse_dev_scope((void *)(rmrr + 1),
+		((void *)rmrr) + rmrr->header.length,
+		&rmrru->devices_cnt, &rmrru->devices, rmrr->segment);
+
+	if (ret || (rmrru->devices_cnt == 0)) {
+		list_del(&rmrru->list);
+		kfree(rmrru);
+	}
+	return ret;
+}
+
+static LIST_HEAD(dmar_atsr_units);
+
+int __init dmar_parse_one_atsr(struct acpi_dmar_header *hdr)
+{
+	struct acpi_dmar_atsr *atsr;
+	struct dmar_atsr_unit *atsru;
+
+	atsr = container_of(hdr, struct acpi_dmar_atsr, header);
+	atsru = kzalloc(sizeof(*atsru), GFP_KERNEL);
+	if (!atsru)
+		return -ENOMEM;
+
+	atsru->hdr = hdr;
+	atsru->include_all = atsr->flags & 0x1;
+
+	list_add(&atsru->list, &dmar_atsr_units);
+
+	return 0;
+}
+
+static int __init atsr_parse_dev(struct dmar_atsr_unit *atsru)
+{
+	int rc;
+	struct acpi_dmar_atsr *atsr;
+
+	if (atsru->include_all)
+		return 0;
+
+	atsr = container_of(atsru->hdr, struct acpi_dmar_atsr, header);
+	rc = dmar_parse_dev_scope((void *)(atsr + 1),
+				(void *)atsr + atsr->header.length,
+				&atsru->devices_cnt, &atsru->devices,
+				atsr->segment);
+	if (rc || !atsru->devices_cnt) {
+		list_del(&atsru->list);
+		kfree(atsru);
+	}
+
+	return rc;
+}
+
+int dmar_find_matched_atsr_unit(struct pci_dev *dev)
+{
+	int i;
+	struct pci_bus *bus;
+	struct acpi_dmar_atsr *atsr;
+	struct dmar_atsr_unit *atsru;
+
+	dev = pci_physfn(dev);
+
+	list_for_each_entry(atsru, &dmar_atsr_units, list) {
+		atsr = container_of(atsru->hdr, struct acpi_dmar_atsr, header);
+		if (atsr->segment == pci_domain_nr(dev->bus))
+			goto found;
+	}
+
+	return 0;
+
+found:
+	for (bus = dev->bus; bus; bus = bus->parent) {
+		struct pci_dev *bridge = bus->self;
+
+		if (!bridge || !pci_is_pcie(bridge) ||
+		    bridge->pcie_type == PCI_EXP_TYPE_PCI_BRIDGE)
+			return 0;
+
+		if (bridge->pcie_type == PCI_EXP_TYPE_ROOT_PORT) {
+			for (i = 0; i < atsru->devices_cnt; i++)
+				if (atsru->devices[i] == bridge)
+					return 1;
+			break;
+		}
+	}
+
+	if (atsru->include_all)
+		return 1;
+
+	return 0;
+}
+
+int dmar_parse_rmrr_atsr_dev(void)
+{
+	struct dmar_rmrr_unit *rmrr, *rmrr_n;
+	struct dmar_atsr_unit *atsr, *atsr_n;
+	int ret = 0;
+
+	list_for_each_entry_safe(rmrr, rmrr_n, &dmar_rmrr_units, list) {
+		ret = rmrr_parse_dev(rmrr);
+		if (ret)
+			return ret;
+	}
+
+	list_for_each_entry_safe(atsr, atsr_n, &dmar_atsr_units, list) {
+		ret = atsr_parse_dev(atsr);
+		if (ret)
+			return ret;
+	}
+
+	return ret;
+}
+
 /*
  * Here we only respond to action of unbound device from driver.
  *
@@ -3454,6 +3599,12 @@ int __init intel_iommu_init(void)
 		return 	-ENODEV;
 	}
 
+	if (list_empty(&dmar_rmrr_units))
+		printk(KERN_INFO "DMAR: No RMRR found\n");
+
+	if (list_empty(&dmar_atsr_units))
+		printk(KERN_INFO "DMAR: No ATSR found\n");
+
 	if (dmar_init_reserved_ranges()) {
 		if (force_on)
 			panic("tboot: Failed to reserve iommu ranges\n");
Index: tree/include/linux/dma_remapping.h
===================================================================
--- tree.orig/include/linux/dma_remapping.h
+++ tree/include/linux/dma_remapping.h
@@ -25,9 +25,9 @@ struct intel_iommu;
 struct dmar_domain;
 struct root_entry;
 
-extern void free_dmar_iommu(struct intel_iommu *iommu);
 
 #ifdef CONFIG_DMAR
+extern void free_dmar_iommu(struct intel_iommu *iommu);
 extern int iommu_calculate_agaw(struct intel_iommu *iommu);
 extern int iommu_calculate_max_sagaw(struct intel_iommu *iommu);
 #else
@@ -39,6 +39,9 @@ static inline int iommu_calculate_max_sa
 {
 	return 0;
 }
+static inline void free_dmar_iommu(struct intel_iommu *iommu)
+{
+}
 #endif
 
 extern int dmar_disabled;
Index: tree/include/linux/dmar.h
===================================================================
--- tree.orig/include/linux/dmar.h
+++ tree/include/linux/dmar.h
@@ -237,9 +237,26 @@ struct dmar_atsr_unit {
 	u8 include_all:1;		/* include all ports */
 };
 
+int dmar_parse_rmrr_atsr_dev(void);
+extern int dmar_parse_one_rmrr(struct acpi_dmar_header *header);
+extern int dmar_parse_one_atsr(struct acpi_dmar_header *header);
+extern int dmar_parse_dev_scope(void *start, void *end, int *cnt,
+				struct pci_dev ***devices, u16 segment);
 extern int intel_iommu_init(void);
 #else /* !CONFIG_DMAR: */
 static inline int intel_iommu_init(void) { return -ENODEV; }
+static inline int dmar_parse_one_rmrr(struct acpi_dmar_header *header)
+{
+	return 0;
+}
+static inline int dmar_parse_one_atsr(struct acpi_dmar_header *header)
+{
+	return 0;
+}
+static inline int dmar_parse_rmrr_atsr_dev(void)
+{
+	return 0;
+}
 #endif /* CONFIG_DMAR */
 
 #endif /* __DMAR_H__ */


