Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548Ab2CFHTP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 02:19:15 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:31805 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757703Ab2CFHP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 02:15:58 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        iommu@lists.linux-foundation.org
Subject: [PATCH 07/23] pci, dmar: Update dmar units devices list during hotplug
Date: Mon,  5 Mar 2012 23:13:44 -0800
Message-Id: <1331018040-30725-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
References: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090202.4F55B994.00A3,ss=1,re=0.000,fgs=0
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

it turns out when remove/rescan, pci dev will be freed and will get another new dev.
but drhd units still keep old one... so dmar_find_matched_drhd_unit will
return wrong drhd and iommu for the device that is not on first iommu.

So need to update devices in drhd_units during pci remove/rescan.

Could save domain/bus/device/function aside in the list and according that info
restore new dev to drhd_units later.
Then dmar_find_matched_drdh_unit and device_to_iommu could return right drhd and iommu.

Add remove_dev_from_drhd/restore_dev_to_drhd functions to do the real work.
call them in device ADD_DEVICE and UNBOUND_DRIVER

Need to do the samething to atsr.  (expose dmar_atsr_units and add atsru->segment)

After patch, will right iommu for the new dev and will not get DMAR error any more.

-v2: add pci_dev_put/pci_dev_get to make refcount consistent.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: iommu@lists.linux-foundation.org
---
 drivers/iommu/intel-iommu.c |  187 ++++++++++++++++++++++++++++++++++++++++---
 include/linux/dmar.h        |    4 +
 2 files changed, 181 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index c9c6053..39ef2ce 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -665,6 +665,159 @@ static struct intel_iommu *device_to_iommu(int segment, u8 bus, u8 devfn)
 	return NULL;
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
+static int
+save_dev_dmaru(int segment, unsigned char bus, unsigned int devfn,
+		 void *dmaru, int index, struct list_head *lh)
+{
+	struct dev_dmaru *m;
+
+	m = kzalloc(sizeof(*m), GFP_KERNEL);
+	if (!m)
+		return -ENOMEM;
+
+	m->segment = segment;
+	m->bus     = bus;
+	m->devfn   = devfn;
+	m->dmaru   = dmaru;
+	m->index   = index;
+
+	list_add(&m->list, lh);
+
+	return 0;
+}
+
+static void
+*get_dev_dmaru(int segment, unsigned char bus, unsigned int devfn,
+		int *index, struct list_head *lh)
+{
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
+
+static void remove_dev_from_drhd(struct pci_dev *dev)
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
+				save_dev_dmaru(segment, dev->bus->number,
+						dev->devfn, drhd, i,
+						&saved_dev_drhd_list);
+				/* always remove it */
+				pci_dev_put(dev);
+				drhd->devices[i] = NULL;
+				return;
+			}
+		}
+	}
+}
+
+static void restore_dev_to_drhd(struct pci_dev *dev)
+{
+	struct dmar_drhd_unit *drhd = NULL;
+	int i;
+
+	/* find the stored drhd */
+	drhd = get_dev_dmaru(pci_domain_nr(dev->bus), dev->bus->number,
+				 dev->devfn, &i, &saved_dev_drhd_list);
+	/* restore that into drhd */
+	if (drhd)
+		drhd->devices[i] = pci_dev_get(dev);
+}
+#else
+static void remove_dev_from_drhd(struct pci_dev *dev)
+{
+}
+
+static void restore_dev_to_drhd(struct pci_dev *dev)
+{
+}
+#endif
+
+#if defined(CONFIG_DMAR) && defined(CONFIG_HOTPLUG)
+static LIST_HEAD(saved_dev_atsr_list);
+
+static void remove_dev_from_atsr(struct pci_dev *dev)
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
+				save_dev_dmaru(segment, dev->bus->number,
+						dev->devfn, atsr, i,
+						&saved_dev_atsr_list);
+				/* always remove it */
+				pci_dev_put(dev);
+				atsr->devices[i] = NULL;
+				return;
+			}
+		}
+	}
+}
+
+static void restore_dev_to_atsr(struct pci_dev *dev)
+{
+	struct dmar_atsr_unit *atsr = NULL;
+	int i;
+
+	/* find the stored atsr */
+	atsr = get_dev_dmaru(pci_domain_nr(dev->bus), dev->bus->number,
+				 dev->devfn, &i, &saved_dev_atsr_list);
+	/* restore that into atsr */
+	if (atsr)
+		atsr->devices[i] = pci_dev_get(dev);
+}
+#else
+static void remove_dev_from_atsr(struct pci_dev *dev)
+{
+}
+
+static void restore_dev_to_atsr(struct pci_dev *dev)
+{
+}
+#endif
+
 static void domain_flush_cache(struct dmar_domain *domain,
 			       void *addr, int size)
 {
@@ -3474,6 +3627,7 @@ int __init dmar_parse_one_atsr(struct acpi_dmar_header *hdr)
 
 	atsru->hdr = hdr;
 	atsru->include_all = atsr->flags & 0x1;
+	atsru->segment = atsr->segment;
 
 	list_add(&atsru->list, &dmar_atsr_units);
 
@@ -3505,16 +3659,13 @@ int dmar_find_matched_atsr_unit(struct pci_dev *dev)
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
 
@@ -3574,20 +3725,36 @@ static int device_notifier(struct notifier_block *nb,
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
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index 731a609..57e1375 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -236,9 +236,13 @@ struct dmar_atsr_unit {
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

