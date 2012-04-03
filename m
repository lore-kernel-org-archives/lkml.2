Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab2DCCVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 22:21:38 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:21882 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab2DCCVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 22:21:25 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <len.brown@intel.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        iommu@lists.linux-foundation.org
Subject: [RFC PATCH 05/14] IOMMU: Update dmar units devices list during hotplug
Date: Mon,  2 Apr 2012 19:19:32 -0700
Message-Id: <1333419581-7836-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1333419581-7836-1-git-send-email-yinghai@kernel.org>
References: <1333419581-7836-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A020204.4F7A5E4C.005E,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When do pci remove/rescan on system that have more iommus, got

[  894.089745] Set context mapping for c4:00.0
[  894.110890] mpt2sas3: Allocated physical memory: size(4293 kB)
[  894.112556] mpt2sas3: Current Controller Queue Depth(1883), Max Controller Queue Depth(2144)
[  894.127278] mpt2sas3: Scatter Gather Elements per IO(128)
[  894.361295] DRHD: handling fault status reg 2
[  894.364053] DMAR:[DMA Read] Request device [c4:00.0] fault addr fffbe000
[  894.364056] DMAR:[fault reason 02] Present bit in context entry is cl

It turns out when remove/rescan, pci dev will be freed and will get another
new dev. But drhd units still keep old one... so dmar_find_matched_drhd_unit
will return wrong drhd and iommu for the device that is not on first iommu.

So need to update devices in drhd_units during pci remove/rescan.

Could save domain/bus/device/function aside in the list and according that
info restore new dev to drhd_units later.
Then dmar_find_matched_drdh_unit and device_to_iommu could return right drhd
and iommu.

Add remove_dev_from_drhd/restore_dev_to_drhd functions to do the real work.
call them in device ADD_DEVICE and UNBOUND_DRIVER

Need to do the samething to atsr. (expose dmar_atsr_units and add
atsru->segment)

After patch, will have right iommu for the new dev and will not get DMAR
error anymore.

-v2: add pci_dev_put/pci_dev_get to make refcount consistent.
-v3: fix one left over CONFIG_DMAR
-v4: pass pci_dev *dev in save_dev_dmaru()/get_dev_dmaru() according to Bjorn.
-v5: fix case only have intr-remap enabled.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: iommu@lists.linux-foundation.org
---
 drivers/iommu/dmar.c                |  129 +++++++++++++++++++++++++++++++++++
 drivers/iommu/intel-iommu.c         |   36 +++++++---
 drivers/iommu/intel_irq_remapping.c |   36 ++++++++++-
 include/linux/dmar.h                |   17 +++++
 4 files changed, 206 insertions(+), 12 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index ec01bc7..fde4991 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -455,6 +455,135 @@ fail:
 	return ret;
 }
 
+#ifdef CONFIG_HOTPLUG
+struct dev_dmaru {
+	struct list_head list;
+	void *dmaru;
+	int index;
+	int segment;
+	unsigned char bus;
+	unsigned int devfn;
+};
+
+static int save_dev_dmaru(struct pci_dev *dev, void *dmaru,
+			  int index, struct list_head *lh)
+{
+	struct dev_dmaru *m;
+
+	m = kzalloc(sizeof(*m), GFP_KERNEL);
+	if (!m)
+		return -ENOMEM;
+
+	m->segment = pci_domain_nr(dev->bus);
+	m->bus     = dev->bus->number;
+	m->devfn   = dev->devfn;
+	m->dmaru   = dmaru;
+	m->index   = index;
+
+	list_add(&m->list, lh);
+
+	return 0;
+}
+static void *get_dev_dmaru(struct pci_dev *dev, int *index,
+				struct list_head *lh)
+{
+	int segment = pci_domain_nr(dev->bus);
+	unsigned char bus = dev->bus->number;
+	unsigned int devfn = dev->devfn;
+	struct dev_dmaru *m;
+	void *dmaru = NULL;
+
+	list_for_each_entry(m, lh, list) {
+		if (m->segment == segment &&
+		    m->bus == bus && m->devfn == devfn) {
+			*index = m->index;
+			dmaru  = m->dmaru;
+			list_del(&m->list);
+			kfree(m);
+			break;
+		}
+	}
+
+	return dmaru;
+}
+
+static LIST_HEAD(saved_dev_drhd_list);
+void remove_dev_from_drhd(struct pci_dev *dev)
+{
+	struct dmar_drhd_unit *drhd = NULL;
+	int segment = pci_domain_nr(dev->bus);
+	int i;
+
+	for_each_drhd_unit(drhd) {
+		if (drhd->ignored)
+			continue;
+		if (segment != drhd->segment)
+			continue;
+
+		for (i = 0; i < drhd->devices_cnt; i++) {
+			if (drhd->devices[i] == dev) {
+				/* save it at first if it is in drhd */
+				save_dev_dmaru(dev, drhd, i,
+						&saved_dev_drhd_list);
+				/* always remove it */
+				pci_dev_put(dev);
+				drhd->devices[i] = NULL;
+				return;
+			}
+		}
+	}
+}
+void restore_dev_to_drhd(struct pci_dev *dev)
+{
+	struct dmar_drhd_unit *drhd = NULL;
+	int i;
+
+	/* find the stored drhd */
+	drhd = get_dev_dmaru(dev, &i, &saved_dev_drhd_list);
+	/* restore that into drhd */
+	if (drhd)
+		drhd->devices[i] = pci_dev_get(dev);
+}
+
+#ifdef CONFIG_INTEL_IOMMU
+static LIST_HEAD(saved_dev_atsr_list);
+void remove_dev_from_atsr(struct pci_dev *dev)
+{
+	struct dmar_atsr_unit *atsr = NULL;
+	int segment = pci_domain_nr(dev->bus);
+	int i;
+
+	for_each_atsr_unit(atsr) {
+		if (segment != atsr->segment)
+			continue;
+
+		for (i = 0; i < atsr->devices_cnt; i++) {
+			if (atsr->devices[i] == dev) {
+				/* save it at first if it is in drhd */
+				save_dev_dmaru(dev, atsr, i,
+						&saved_dev_atsr_list);
+				/* always remove it */
+				pci_dev_put(dev);
+				atsr->devices[i] = NULL;
+				return;
+			}
+		}
+	}
+}
+void restore_dev_to_atsr(struct pci_dev *dev)
+{
+	struct dmar_atsr_unit *atsr = NULL;
+	int i;
+
+	/* find the stored atsr */
+	atsr = get_dev_dmaru(dev, &i, &saved_dev_atsr_list);
+	/* restore that into atsr */
+	if (atsr)
+		atsr->devices[i] = pci_dev_get(dev);
+}
+#endif  /* CONFIG_INTEL_IOMMU */
+
+#endif  /* CONFIG_HOTPLUG */
 
 int __init dmar_table_init(void)
 {
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 430224b..be867e6 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3472,7 +3472,7 @@ rmrr_parse_dev(struct dmar_rmrr_unit *rmrru)
 	return ret;
 }
 
-static LIST_HEAD(dmar_atsr_units);
+LIST_HEAD(dmar_atsr_units);
 
 int __init dmar_parse_one_atsr(struct acpi_dmar_header *hdr)
 {
@@ -3486,6 +3486,7 @@ int __init dmar_parse_one_atsr(struct acpi_dmar_header *hdr)
 
 	atsru->hdr = hdr;
 	atsru->include_all = atsr->flags & 0x1;
+	atsru->segment = atsr->segment;
 
 	list_add(&atsru->list, &dmar_atsr_units);
 
@@ -3517,16 +3518,13 @@ int dmar_find_matched_atsr_unit(struct pci_dev *dev)
 {
 	int i;
 	struct pci_bus *bus;
-	struct acpi_dmar_atsr *atsr;
 	struct dmar_atsr_unit *atsru;
 
 	dev = pci_physfn(dev);
 
-	list_for_each_entry(atsru, &dmar_atsr_units, list) {
-		atsr = container_of(atsru->hdr, struct acpi_dmar_atsr, header);
-		if (atsr->segment == pci_domain_nr(dev->bus))
+	list_for_each_entry(atsru, &dmar_atsr_units, list)
+		if (atsru->segment == pci_domain_nr(dev->bus))
 			goto found;
-	}
 
 	return 0;
 
@@ -3586,20 +3584,36 @@ static int device_notifier(struct notifier_block *nb,
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct dmar_domain *domain;
 
-	if (iommu_no_mapping(dev))
+	if (unlikely(dev->bus != &pci_bus_type))
 		return 0;
 
-	domain = find_domain(pdev);
-	if (!domain)
-		return 0;
+	switch (action) {
+	case BUS_NOTIFY_UNBOUND_DRIVER:
+		if (iommu_no_mapping(dev))
+			goto out;
+
+		if (iommu_pass_through)
+			goto out;
+
+		domain = find_domain(pdev);
+		if (!domain)
+			goto out;
 
-	if (action == BUS_NOTIFY_UNBOUND_DRIVER && !iommu_pass_through) {
 		domain_remove_one_dev_info(domain, pdev);
 
 		if (!(domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE) &&
 		    !(domain->flags & DOMAIN_FLAG_STATIC_IDENTITY) &&
 		    list_empty(&domain->devices))
 			domain_exit(domain);
+out:
+		remove_dev_from_drhd(pdev);
+		remove_dev_from_atsr(pdev);
+
+		break;
+	case BUS_NOTIFY_ADD_DEVICE:
+		restore_dev_to_drhd(pdev);
+		restore_dev_to_atsr(pdev);
+		break;
 	}
 
 	return 0;
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index b4d3950..05ffe20 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -757,12 +757,46 @@ int __init parse_ioapics_under_ir(void)
 	return ir_supported;
 }
 
+static int device_notifier(struct notifier_block *nb,
+				  unsigned long action, void *data)
+{
+	struct device *dev = data;
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	if (unlikely(dev->bus != &pci_bus_type))
+		return 0;
+
+	switch (action) {
+	case BUS_NOTIFY_UNBOUND_DRIVER:
+		remove_dev_from_drhd(pdev);
+		break;
+	case BUS_NOTIFY_ADD_DEVICE:
+		restore_dev_to_drhd(pdev);
+		break;
+	}
+
+	return 0;
+}
+
+static struct notifier_block device_nb = {
+	.notifier_call = device_notifier,
+};
+
 int __init ir_dev_scope_init(void)
 {
+	int ret;
+
 	if (!irq_remapping_enabled)
 		return 0;
 
-	return dmar_dev_scope_init();
+	ret = dmar_dev_scope_init();
+	if (ret < 0)
+		return ret;
+
+	if (intel_iommu_enabled != 1)
+		bus_register_notifier(&pci_bus_type, &device_nb);
+
+	return ret;
 }
 rootfs_initcall(ir_dev_scope_init);
 
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index b029d1a..305db55 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -131,6 +131,18 @@ extern int dmar_set_interrupt(struct intel_iommu *iommu);
 extern irqreturn_t dmar_fault(int irq, void *dev_id);
 extern int arch_setup_dmar_msi(unsigned int irq);
 
+#ifdef CONFIG_HOTPLUG
+void remove_dev_from_drhd(struct pci_dev *dev);
+void restore_dev_to_drhd(struct pci_dev *dev);
+void remove_dev_from_atsr(struct pci_dev *dev);
+void restore_dev_to_atsr(struct pci_dev *dev);
+#else
+static inline void remove_dev_from_drhd(struct pci_dev *dev) { }
+static inline void restore_dev_to_drhd(struct pci_dev *dev) { }
+static inline void remove_dev_from_atsr(struct pci_dev *dev) { }
+static inline void restore_dev_to_atsr(struct pci_dev *dev) { }
+#endif
+
 #ifdef CONFIG_INTEL_IOMMU
 extern int iommu_detected, no_iommu;
 extern struct list_head dmar_rmrr_units;
@@ -146,14 +158,19 @@ struct dmar_rmrr_unit {
 #define for_each_rmrr_units(rmrr) \
 	list_for_each_entry(rmrr, &dmar_rmrr_units, list)
 
+extern struct list_head dmar_atsr_units;
 struct dmar_atsr_unit {
 	struct list_head list;		/* list of ATSR units */
 	struct acpi_dmar_header *hdr;	/* ACPI header */
 	struct pci_dev **devices;	/* target devices */
 	int devices_cnt;		/* target device count */
+	u16 segment;			/* PCI domain */
 	u8 include_all:1;		/* include all ports */
 };
 
+#define for_each_atsr_unit(atsr) \
+	list_for_each_entry(atsr, &dmar_atsr_units, list)
+
 int dmar_parse_rmrr_atsr_dev(void);
 extern int dmar_parse_one_rmrr(struct acpi_dmar_header *header);
 extern int dmar_parse_one_atsr(struct acpi_dmar_header *header);
-- 
1.7.7

