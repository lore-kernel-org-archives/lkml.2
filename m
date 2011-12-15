Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790Ab1LOKXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 05:23:36 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:28706
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755414Ab1LOKXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 05:23:33 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LW8Q74-02-EHE-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/3] iommu/amd: Add amd_iommu_device_info() function
Date: Thu, 15 Dec 2011 11:23:21 +0100
Message-ID: <1323944602-26155-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323944602-26155-1-git-send-email-joerg.roedel@amd.com>
References: <1323944602-26155-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function can be used to find out which features
necessary for IOMMUv2 usage are available on a given device.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/amd-iommu.h |   26 ++++++++++++++++++++++++++
 2 files changed, 69 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index d5074f4..03944e7 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -3565,3 +3565,46 @@ void amd_iommu_enable_device_erratum(struct pci_dev *pdev, u32 erratum)
 	dev_data->errata |= (1 << erratum);
 }
 EXPORT_SYMBOL(amd_iommu_enable_device_erratum);
+
+int amd_iommu_device_info(struct pci_dev *pdev,
+                          struct amd_iommu_device_info *info)
+{
+	int max_pasids;
+	int pos;
+
+	if (pdev == NULL || info == NULL)
+		return -EINVAL;
+
+	if (!amd_iommu_v2_supported())
+		return -EINVAL;
+
+	memset(info, 0, sizeof(*info));
+
+	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ATS);
+	if (pos)
+		info->flags |= AMD_IOMMU_DEVICE_FLAG_ATS_SUP;
+
+	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_PRI);
+	if (pos)
+		info->flags |= AMD_IOMMU_DEVICE_FLAG_PRI_SUP;
+
+	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_PASID);
+	if (pos) {
+		int features;
+
+		max_pasids = 1 << (9 * (amd_iommu_max_glx_val + 1));
+		max_pasids = min(max_pasids, (1 << 20));
+
+		info->flags |= AMD_IOMMU_DEVICE_FLAG_PASID_SUP;
+		info->max_pasids = min(pci_max_pasids(pdev), max_pasids);
+
+		features = pci_pasid_features(pdev);
+		if (features & PCI_PASID_CAP_EXEC)
+			info->flags |= AMD_IOMMU_DEVICE_FLAG_EXEC_SUP;
+		if (features & PCI_PASID_CAP_PRIV)
+			info->flags |= AMD_IOMMU_DEVICE_FLAG_PRIV_SUP;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(amd_iommu_device_info);
diff --git a/include/linux/amd-iommu.h b/include/linux/amd-iommu.h
index 06688c4..c03c281 100644
--- a/include/linux/amd-iommu.h
+++ b/include/linux/amd-iommu.h
@@ -119,6 +119,32 @@ typedef int (*amd_iommu_invalid_ppr_cb)(struct pci_dev *pdev,
 extern int amd_iommu_set_invalid_ppr_cb(struct pci_dev *pdev,
 					amd_iommu_invalid_ppr_cb cb);
 
+/**
+ * amd_iommu_device_info() - Get information about IOMMUv2 support of a
+ *			     PCI device
+ * @pdev: PCI device to query information from
+ * @info: A pointer to an amd_iommu_device_info structure which will contain
+ *	  the information about the PCI device
+ *
+ * Returns 0 on success, negative value on error
+ */
+
+#define AMD_IOMMU_DEVICE_FLAG_ATS_SUP     0x1    /* ATS feature supported */
+#define AMD_IOMMU_DEVICE_FLAG_PRI_SUP     0x2    /* PRI feature supported */
+#define AMD_IOMMU_DEVICE_FLAG_PASID_SUP   0x4    /* PASID context supported */
+#define AMD_IOMMU_DEVICE_FLAG_EXEC_SUP    0x8    /* Device may request execution
+						    on memory pages */
+#define AMD_IOMMU_DEVICE_FLAG_PRIV_SUP   0x10    /* Device may request
+						    super-user privileges */
+
+struct amd_iommu_device_info {
+	int max_pasids;
+	u32 flags;
+};
+
+extern int amd_iommu_device_info(struct pci_dev *pdev,
+				 struct amd_iommu_device_info *info);
+
 #else
 
 static inline int amd_iommu_detect(void) { return -ENODEV; }
-- 
1.7.5.4


