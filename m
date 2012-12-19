Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab2LSLGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 06:06:17 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:63843 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab2LSLGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 06:06:09 -0500
X-Greylist: delayed 414 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Dec 2012 06:06:08 EST
From: Andrew Cooks <acooks@gmail.com>
To: acooks@gmail.com, joro@8bytes.org, xjtuychu@hotmail.com, gm.ychu@gmail.com,
        alex.williamson@redhat.com, bhelgaas@google.com,
        jpiszcz@lucidpixels.com, dwmw2@infradead.org
Cc: iommu@lists.linux-foundation.org (open list:INTEL IOMMU (VT-d)),
        linux-kernel@vger.kernel.org (open list),
        linux-pci@vger.kernel.org (open list:PCI SUBSYSTEM)
Subject: [RFC PATCH] Fix Intel IOMMU support for Marvell 88SE91xx SATA controllers.
Date: Wed, 19 Dec 2012 18:58:23 +0800
Message-Id: <1355914703-28576-1-git-send-email-acooks@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1354533387-4110-1-git-send-email-acooks@gmail.com>
References: <1354533387-4110-1-git-send-email-acooks@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is my second attempt to make Marvell 88SE91xx SATA controllers work when IOMMU is enabled.[1][2] 
As suggested, it no longer tries to add support for phantom functions.

What's missing:
* No AMD support. I need some help with this.
* Table of affected chip IDs is incomplete. I think 0x9123, 0x9125, 0x9128 are also affected.

Patch is against 3.7.1

Review and feedback would be appreciated.

1. https://bugzilla.redhat.com/show_bug.cgi?id=757166
2. https://bugzilla.kernel.org/show_bug.cgi?id=42679

Signed-off-by: Andrew Cooks <acooks@gmail.com>
---
 drivers/iommu/intel-iommu.c |   36 ++++++++++++++++++++++++++++++++++--
 drivers/pci/quirks.c        |   34 ++++++++++++++++++++++++++++++++++
 include/linux/pci.h         |    1 +
 3 files changed, 66 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 0badfa4..17e64c0 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1672,6 +1674,31 @@ static int domain_context_mapping_one(struct dmar_domain *domain, int segment,
 	return 0;
 }
 
+/* For buggy devices like Marvell 88SE91xx chips that use unclaimed
+ * functions.
+ */
+static int map_quirky_dma_fn(struct dmar_domain *domain,
+		struct pci_dev *pdev,
+		int translation)
+{
+	u8 fn;
+	int err = 0;
+
+	for (fn = 1; fn < 8; fn++) {
+		if (pci_func_is_dma_source(pdev, fn)) {
+			err = domain_context_mapping_one(domain,
+					pci_domain_nr(pdev->bus),
+					pdev->bus->number,
+					PCI_DEVFN(PCI_SLOT(pdev->devfn), fn),
+					translation);
+			if (err)
+				return err;
+			dev_dbg(&pdev->dev, "func: %d mapped dma quirk", fn);
+		}
+	}
+	return 0;
+}
+
 static int
 domain_context_mapping(struct dmar_domain *domain, struct pci_dev *pdev,
 			int translation)
@@ -1685,6 +1712,11 @@ domain_context_mapping(struct dmar_domain *domain, struct pci_dev *pdev,
 	if (ret)
 		return ret;
 
+	/* quirk for undeclared pci functions */
+	ret = map_quirky_dma_fn(domain, pdev, translation);
+	if (ret)
+		return ret;
+
 	/* dependent device mapping */
 	tmp = pci_find_upstream_pcie_bridge(pdev);
 	if (!tmp)
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 7a451ff..8d02bac 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3227,6 +3227,40 @@ static const struct pci_dev_dma_source {
 	{ 0 }
 };
 
+static const struct pci_dev_dma_source_funcs {
+	u16 vendor;
+	u16 device;
+	u8 func_map;	/* bit map. lsb is fn 0. */
+} pci_dev_dma_source_funcs[] = {
+	 {0x1b4b, 0x9172, (1<<0)|(1<<1)},
+	 { 0 },	
+};
+
+static u8 pci_get_dma_source_map(struct pci_dev *dev)
+{
+	const struct pci_dev_dma_source_funcs *i;
+
+	for (i = pci_dev_dma_source_funcs; i->func_map; i++) {
+		if ((i->vendor == dev->vendor ||
+		     i->vendor == (u16)PCI_ANY_ID) &&
+		    (i->device == dev->device ||
+		     i->device == (u16)PCI_ANY_ID)) {
+			return i->func_map;			
+		}
+	}
+	return 0;
+}
+
+int pci_func_is_dma_source(struct pci_dev *dev, int fn)
+{
+	u8 fn_map = pci_get_dma_source_map(dev);
+
+	if (fn_map & (1 << fn))
+		return 1;
+
+	return 0;
+}
+
 /*
  * IOMMUs with isolation capabilities need to be programmed with the
  * correct source ID of a device.  In most cases, the source ID matches
diff --git a/include/linux/pci.h b/include/linux/pci.h
index ee21795..8f0fa7f 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1546,6 +1546,7 @@ enum pci_fixup_pass {
 #ifdef CONFIG_PCI_QUIRKS
 void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev);
 struct pci_dev *pci_get_dma_source(struct pci_dev *dev);
+int pci_func_is_dma_source(struct pci_dev *dev, int fn);
 int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags);
 #else
 static inline void pci_fixup_device(enum pci_fixup_pass pass,
-- 
1.7.1

