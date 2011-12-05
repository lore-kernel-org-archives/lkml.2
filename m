Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428Ab1LENfT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:35:19 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:3759
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932361Ab1LENfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:35:09 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVQGED-02-AUL-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 10/22] iommu/amd: Add support for IOMMUv2 domain mode
Date: Mon, 5 Dec 2011 14:34:25 +0100
Message-ID: <1323092077-25501-11-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
References: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for protection domains that
implement two-level paging for devices.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/Kconfig           |    4 +-
 drivers/iommu/amd_iommu.c       |  144 +++++++++++++++++++++++++++++++++++++-
 drivers/iommu/amd_iommu_init.c  |    9 +++
 drivers/iommu/amd_iommu_proto.h |    1 +
 drivers/iommu/amd_iommu_types.h |   27 +++++++
 5 files changed, 180 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 5414253b..220dfc2 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -34,7 +34,9 @@ config AMD_IOMMU
 	bool "AMD IOMMU support"
 	select SWIOTLB
 	select PCI_MSI
-	select PCI_IOV
+	select PCI_ATS
+	select PCI_PRI
+	select PCI_PASID
 	select IOMMU_API
 	depends on X86_64 && PCI && ACPI
 	---help---
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index f0b289f..eaa1af2 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -63,6 +63,7 @@ static struct protection_domain *pt_domain;
 static struct iommu_ops amd_iommu_ops;
 
 static ATOMIC_NOTIFIER_HEAD(ppr_notifier);
+int amd_iommu_max_glx_val = -1;
 
 /*
  * general struct to manage commands send to an IOMMU
@@ -1598,6 +1599,11 @@ static void free_pagetable(struct protection_domain *domain)
 	domain->pt_root = NULL;
 }
 
+static void free_gcr3_table(struct protection_domain *domain)
+{
+	free_page((unsigned long)domain->gcr3_tbl);
+}
+
 /*
  * Free a domain, only used if something went wrong in the
  * allocation path and we need to free an already allocated page table
@@ -1699,6 +1705,32 @@ static void set_dte_entry(u16 devid, struct protection_domain *domain, bool ats)
 	if (ats)
 		flags |= DTE_FLAG_IOTLB;
 
+	if (domain->flags & PD_IOMMUV2_MASK) {
+		u64 gcr3 = __pa(domain->gcr3_tbl);
+		u64 glx  = domain->glx;
+		u64 tmp;
+
+		pte_root |= DTE_FLAG_GV;
+		pte_root |= (glx & DTE_GLX_MASK) << DTE_GLX_SHIFT;
+
+		/* First mask out possible old values for GCR3 table */
+		tmp = DTE_GCR3_VAL_B(~0ULL) << DTE_GCR3_SHIFT_B;
+		flags    &= ~tmp;
+
+		tmp = DTE_GCR3_VAL_C(~0ULL) << DTE_GCR3_SHIFT_C;
+		flags    &= ~tmp;
+
+		/* Encode GCR3 table into DTE */
+		tmp = DTE_GCR3_VAL_A(gcr3) << DTE_GCR3_SHIFT_A;
+		pte_root |= tmp;
+
+		tmp = DTE_GCR3_VAL_B(gcr3) << DTE_GCR3_SHIFT_B;
+		flags    |= tmp;
+
+		tmp = DTE_GCR3_VAL_C(gcr3) << DTE_GCR3_SHIFT_C;
+		flags    |= tmp;
+	}
+
 	flags &= ~(0xffffUL);
 	flags |= domain->id;
 
@@ -1803,6 +1835,46 @@ out_unlock:
 	return ret;
 }
 
+
+static void pdev_iommuv2_disable(struct pci_dev *pdev)
+{
+	pci_disable_ats(pdev);
+	pci_disable_pri(pdev);
+	pci_disable_pasid(pdev);
+}
+
+static int pdev_iommuv2_enable(struct pci_dev *pdev)
+{
+	int ret;
+
+	/* Only allow access to user-accessible pages */
+	ret = pci_enable_pasid(pdev, 0);
+	if (ret)
+		goto out_err;
+
+	/* First reset the PRI state of the device */
+	ret = pci_reset_pri(pdev);
+	if (ret)
+		goto out_err;
+
+	/* FIXME: Hardcode number of outstanding requests for now */
+	ret = pci_enable_pri(pdev, 32);
+	if (ret)
+		goto out_err;
+
+	ret = pci_enable_ats(pdev, PAGE_SHIFT);
+	if (ret)
+		goto out_err;
+
+	return 0;
+
+out_err:
+	pci_disable_pri(pdev);
+	pci_disable_pasid(pdev);
+
+	return ret;
+}
+
 /*
  * If a device is not yet associated with a domain, this function does
  * assigns it visible for the hardware
@@ -1817,7 +1889,17 @@ static int attach_device(struct device *dev,
 
 	dev_data = get_dev_data(dev);
 
-	if (amd_iommu_iotlb_sup && pci_enable_ats(pdev, PAGE_SHIFT) == 0) {
+	if (domain->flags & PD_IOMMUV2_MASK) {
+		if (!dev_data->iommu_v2 || !dev_data->passthrough)
+			return -EINVAL;
+
+		if (pdev_iommuv2_enable(pdev) != 0)
+			return -EINVAL;
+
+		dev_data->ats.enabled = true;
+		dev_data->ats.qdep    = pci_ats_queue_depth(pdev);
+	} else if (amd_iommu_iotlb_sup &&
+		   pci_enable_ats(pdev, PAGE_SHIFT) == 0) {
 		dev_data->ats.enabled = true;
 		dev_data->ats.qdep    = pci_ats_queue_depth(pdev);
 	}
@@ -1877,20 +1959,24 @@ static void __detach_device(struct iommu_dev_data *dev_data)
  */
 static void detach_device(struct device *dev)
 {
+	struct protection_domain *domain;
 	struct iommu_dev_data *dev_data;
 	unsigned long flags;
 
 	dev_data = get_dev_data(dev);
+	domain   = dev_data->domain;
 
 	/* lock device table */
 	write_lock_irqsave(&amd_iommu_devtable_lock, flags);
 	__detach_device(dev_data);
 	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
 
-	if (dev_data->ats.enabled) {
+	if (domain->flags & PD_IOMMUV2_MASK)
+		pdev_iommuv2_disable(to_pci_dev(dev));
+	else if (dev_data->ats.enabled)
 		pci_disable_ats(to_pci_dev(dev));
-		dev_data->ats.enabled = false;
-	}
+
+	dev_data->ats.enabled = false;
 }
 
 /*
@@ -2788,6 +2874,9 @@ static void amd_iommu_domain_destroy(struct iommu_domain *dom)
 	if (domain->mode != PAGE_MODE_NONE)
 		free_pagetable(domain);
 
+	if (domain->flags & PD_IOMMUV2_MASK)
+		free_gcr3_table(domain);
+
 	protection_domain_free(domain);
 
 	dom->priv = NULL;
@@ -3010,3 +3099,50 @@ void amd_iommu_domain_direct_map(struct iommu_domain *dom)
 	spin_unlock_irqrestore(&domain->lock, flags);
 }
 EXPORT_SYMBOL(amd_iommu_domain_direct_map);
+
+int amd_iommu_domain_enable_v2(struct iommu_domain *dom, int pasids)
+{
+	struct protection_domain *domain = dom->priv;
+	unsigned long flags;
+	int levels, ret;
+
+	if (pasids <= 0 || pasids & ~PASID_MASK)
+		return -EINVAL;
+
+	/* Number of GCR3 table levels required */
+	for (levels = -1; pasids != 0; pasids >>= 9)
+		levels += 1;
+
+	if (levels > amd_iommu_max_glx_val)
+		return -EINVAL;
+
+	spin_lock_irqsave(&domain->lock, flags);
+
+	/*
+	 * Save us all sanity checks whether devices already in the
+	 * domain support IOMMUv2. Just force that the domain has no
+	 * devices attached when it is switched into IOMMUv2 mode.
+	 */
+	ret = -EBUSY;
+	if (domain->dev_cnt > 0 || domain->flags & PD_IOMMUV2_MASK)
+		goto out;
+
+	ret = -ENOMEM;
+	domain->gcr3_tbl = (void *)get_zeroed_page(GFP_ATOMIC);
+	if (domain->gcr3_tbl == NULL)
+		goto out;
+
+	domain->glx      = levels;
+	domain->flags   |= PD_IOMMUV2_MASK;
+	domain->updated  = true;
+
+	update_domain(domain);
+
+	ret = 0;
+
+out:
+	spin_unlock_irqrestore(&domain->lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(amd_iommu_domain_enable_v2);
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 7c3fd57..c7a5d7e 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -755,6 +755,7 @@ static void __init init_iommu_from_pci(struct amd_iommu *iommu)
 	iommu->features = ((u64)high << 32) | low;
 
 	if (iommu_feature(iommu, FEATURE_GT)) {
+		int glxval;
 		u32 pasids;
 		u64 shift;
 
@@ -763,6 +764,14 @@ static void __init init_iommu_from_pci(struct amd_iommu *iommu)
 		pasids  = (1 << shift);
 
 		amd_iommu_max_pasids = min(amd_iommu_max_pasids, pasids);
+
+		glxval   = iommu->features & FEATURE_GLXVAL_MASK;
+		glxval >>= FEATURE_GLXVAL_SHIFT;
+
+		if (amd_iommu_max_glx_val == -1)
+			amd_iommu_max_glx_val = glxval;
+		else
+			amd_iommu_max_glx_val = min(amd_iommu_max_glx_val, glxval);
 	}
 
 	if (iommu_feature(iommu, FEATURE_GT) &&
diff --git a/drivers/iommu/amd_iommu_proto.h b/drivers/iommu/amd_iommu_proto.h
index 2c4554e..d207b1d 100644
--- a/drivers/iommu/amd_iommu_proto.h
+++ b/drivers/iommu/amd_iommu_proto.h
@@ -39,6 +39,7 @@ extern bool amd_iommu_v2_supported(void);
 extern int amd_iommu_register_ppr_notifier(struct notifier_block *nb);
 extern int amd_iommu_unregister_ppr_notifier(struct notifier_block *nb);
 extern void amd_iommu_domain_direct_map(struct iommu_domain *dom);
+extern int amd_iommu_domain_enable_v2(struct iommu_domain *dom, int pasids);
 
 #ifndef CONFIG_AMD_IOMMU_STATS
 
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index f626722..905eca5 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -93,6 +93,11 @@
 #define FEATURE_PASID_SHIFT	32
 #define FEATURE_PASID_MASK	(0x1fULL << FEATURE_PASID_SHIFT)
 
+#define FEATURE_GLXVAL_SHIFT	14
+#define FEATURE_GLXVAL_MASK	(0x03ULL << FEATURE_GLXVAL_SHIFT)
+
+#define PASID_MASK		0x000fffff
+
 /* MMIO status bits */
 #define MMIO_STATUS_COM_WAIT_INT_MASK	(1 << 2)
 #define MMIO_STATUS_PPR_INT_MASK	(1 << 6)
@@ -257,6 +262,22 @@
 #define IOMMU_PTE_IW (1ULL << 62)
 
 #define DTE_FLAG_IOTLB	(0x01UL << 32)
+#define DTE_FLAG_GV	(0x01ULL << 55)
+#define DTE_GLX_SHIFT	(56)
+#define DTE_GLX_MASK	(3)
+
+#define DTE_GCR3_VAL_A(x)	(((x) >> 12) & 0x00007ULL)
+#define DTE_GCR3_VAL_B(x)	(((x) >> 15) & 0x0ffffULL)
+#define DTE_GCR3_VAL_C(x)	(((x) >> 31) & 0xfffffULL)
+
+#define DTE_GCR3_INDEX_A	0
+#define DTE_GCR3_INDEX_B	1
+#define DTE_GCR3_INDEX_C	1
+
+#define DTE_GCR3_SHIFT_A	58
+#define DTE_GCR3_SHIFT_B	16
+#define DTE_GCR3_SHIFT_C	43
+
 
 #define IOMMU_PAGE_MASK (((1ULL << 52) - 1) & ~0xfffULL)
 #define IOMMU_IO_PAGE_MASK	(~(0xfffULL))
@@ -284,6 +305,7 @@
 					      domain for an IOMMU */
 #define PD_PASSTHROUGH_MASK	(1UL << 2) /* domain has no page
 					      translation */
+#define PD_IOMMUV2_MASK		(1UL << 3) /* domain has gcr3 table */
 
 extern bool amd_iommu_dump;
 #define DUMP_printk(format, arg...)					\
@@ -345,6 +367,8 @@ struct protection_domain {
 	u16 id;			/* the domain id written to the device table */
 	int mode;		/* paging mode (0-6 levels) */
 	u64 *pt_root;		/* page table root pointer */
+	int glx;		/* Number of levels for GCR3 table */
+	u64 *gcr3_tbl;		/* Guest CR3 table */
 	unsigned long flags;	/* flags to find out type of domain */
 	bool updated;		/* complete domain flush required */
 	unsigned dev_cnt;	/* devices assigned to this domain */
@@ -612,6 +636,9 @@ extern bool amd_iommu_v2_present;
 
 extern bool amd_iommu_force_isolation;
 
+/* Max levels of glxval supported */
+extern int amd_iommu_max_glx_val;
+
 /* takes bus and device/function and returns the device id
  * FIXME: should that be in generic PCI code? */
 static inline u16 calc_devid(u8 bus, u8 devfn)
-- 
1.7.5.4


