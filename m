Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab1LENkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:40:12 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:38321
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932347Ab1LENfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:35:09 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LVQGEC-02-AUJ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 15/22] iommu/amd: Add device errata handling
Date: Mon, 5 Dec 2011 14:34:30 +0100
Message-ID: <1323092077-25501-16-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
References: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add infrastructure for errata-handling and handle two known
erratas in the IOMMUv2 code.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu.c       |   57 ++++++++++++++++++++++++++++++++++++--
 drivers/iommu/amd_iommu_types.h |    1 +
 include/linux/amd-iommu.h       |   18 ++++++++++++
 3 files changed, 73 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index dd66211..7bd1565 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -172,6 +172,15 @@ static bool pci_iommuv2_capable(struct pci_dev *pdev)
 	return true;
 }
 
+static bool pdev_pri_erratum(struct pci_dev *pdev, u32 erratum)
+{
+	struct iommu_dev_data *dev_data;
+
+	dev_data = get_dev_data(&pdev->dev);
+
+	return dev_data->errata & (1 << erratum) ? true : false;
+}
+
 /*
  * In this function the list of preallocated protection domains is traversed to
  * find the domain for a specific device
@@ -1934,9 +1943,33 @@ static void pdev_iommuv2_disable(struct pci_dev *pdev)
 	pci_disable_pasid(pdev);
 }
 
+/* FIXME: Change generic reset-function to do the same */
+static int pri_reset_while_enabled(struct pci_dev *pdev)
+{
+	u16 control;
+	int pos;
+
+	pos = pci_find_ext_capability(pdev, PCI_PRI_CAP);
+	if (!pos)
+		return -EINVAL;
+
+	pci_read_config_word(pdev, pos + PCI_PRI_CONTROL_OFF, &control);
+	control |= PCI_PRI_RESET;
+	pci_write_config_word(pdev, pos + PCI_PRI_CONTROL_OFF, control);
+
+	return 0;
+}
+
 static int pdev_iommuv2_enable(struct pci_dev *pdev)
 {
-	int ret;
+	bool reset_enable;
+	int reqs, ret;
+
+	/* FIXME: Hardcode number of outstanding requests for now */
+	reqs = 32;
+	if (pdev_pri_erratum(pdev, AMD_PRI_DEV_ERRATUM_LIMIT_REQ_ONE))
+		reqs = 1;
+	reset_enable = pdev_pri_erratum(pdev, AMD_PRI_DEV_ERRATUM_ENABLE_RESET);
 
 	/* Only allow access to user-accessible pages */
 	ret = pci_enable_pasid(pdev, 0);
@@ -1948,11 +1981,17 @@ static int pdev_iommuv2_enable(struct pci_dev *pdev)
 	if (ret)
 		goto out_err;
 
-	/* FIXME: Hardcode number of outstanding requests for now */
-	ret = pci_enable_pri(pdev, 32);
+	/* Enable PRI */
+	ret = pci_enable_pri(pdev, reqs);
 	if (ret)
 		goto out_err;
 
+	if (reset_enable) {
+		ret = pri_reset_while_enabled(pdev);
+		if (ret)
+			goto out_err;
+	}
+
 	ret = pci_enable_ats(pdev, PAGE_SHIFT);
 	if (ret)
 		goto out_err;
@@ -3481,3 +3520,15 @@ struct iommu_domain *amd_iommu_get_v2_domain(struct pci_dev *pdev)
 	return domain->iommu_domain;
 }
 EXPORT_SYMBOL(amd_iommu_get_v2_domain);
+
+void amd_iommu_enable_device_erratum(struct pci_dev *pdev, u32 erratum)
+{
+	struct iommu_dev_data *dev_data;
+
+	if (!amd_iommu_v2_supported())
+		return;
+
+	dev_data = get_dev_data(&pdev->dev);
+	dev_data->errata |= (1 << erratum);
+}
+EXPORT_SYMBOL(amd_iommu_enable_device_erratum);
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index 2ba7b9a..90d149c 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -405,6 +405,7 @@ struct iommu_dev_data {
 	} ats;				  /* ATS state */
 	bool pri_tlp;			  /* PASID TLB required for
 					     PPR completions */
+	u32 errata;			  /* Bitmap for errata to apply */
 };
 
 /*
diff --git a/include/linux/amd-iommu.h b/include/linux/amd-iommu.h
index a6863a2..4152c30 100644
--- a/include/linux/amd-iommu.h
+++ b/include/linux/amd-iommu.h
@@ -26,6 +26,24 @@
 
 extern int amd_iommu_detect(void);
 
+
+/**
+ * amd_iommu_enable_device_erratum() - Enable erratum workaround for device
+ *				       in the IOMMUv2 driver
+ * @pdev: The PCI device the workaround is necessary for
+ * @erratum: The erratum workaround to enable
+ *
+ * Possible values for the erratum number are for now:
+ * - AMD_PRI_DEV_ERRATUM_ENABLE_RESET - Reset PRI capability when PRI
+ *					is enabled
+ * - AMD_PRI_DEV_ERRATUM_LIMIT_REQ_ONE - Limit number of outstanding PRI
+ *					 requests to one
+ */
+#define AMD_PRI_DEV_ERRATUM_ENABLE_RESET		0
+#define AMD_PRI_DEV_ERRATUM_LIMIT_REQ_ONE		1
+
+extern void amd_iommu_enable_device_erratum(struct pci_dev *pdev, u32 erratum);
+
 #else
 
 static inline int amd_iommu_detect(void) { return -ENODEV; }
-- 
1.7.5.4


