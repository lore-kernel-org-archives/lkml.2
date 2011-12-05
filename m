Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414Ab1LENfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:35:17 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:3733
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932311Ab1LENfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:35:07 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LVQGEE-01-IPK-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 13/22] iommu/amd: Implement function to send PPR completions
Date: Mon, 5 Dec 2011 14:34:28 +0100
Message-ID: <1323092077-25501-14-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
References: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To send completions for PPR requests this patch adds a
function which can be used by the IOMMUv2 driver.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu.c       |   51 +++++++++++++++++++++++++++++++++++++++
 drivers/iommu/amd_iommu_proto.h |    6 ++++
 drivers/iommu/amd_iommu_types.h |    6 ++++
 3 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index faf566c..e363180 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -736,6 +736,22 @@ static void build_inv_iotlb_pasid(struct iommu_cmd *cmd, u16 devid, int pasid,
 	CMD_SET_TYPE(cmd, CMD_INV_IOTLB_PAGES);
 }
 
+static void build_complete_ppr(struct iommu_cmd *cmd, u16 devid, int pasid,
+			       int status, int tag, bool gn)
+{
+	memset(cmd, 0, sizeof(*cmd));
+
+	cmd->data[0]  = devid;
+	if (gn) {
+		cmd->data[1]  = pasid & PASID_MASK;
+		cmd->data[2]  = CMD_INV_IOMMU_PAGES_GN_MASK;
+	}
+	cmd->data[3]  = tag & 0x1ff;
+	cmd->data[3] |= (status & PPR_STATUS_MASK) << PPR_STATUS_SHIFT;
+
+	CMD_SET_TYPE(cmd, CMD_COMPLETE_PPR);
+}
+
 static void build_inv_all(struct iommu_cmd *cmd)
 {
 	memset(cmd, 0, sizeof(*cmd));
@@ -1950,6 +1966,23 @@ out_err:
 	return ret;
 }
 
+/* FIXME: Move this to PCI code */
+#define PCI_PRI_TLP_OFF		(1 << 2)
+
+bool pci_pri_tlp_required(struct pci_dev *pdev)
+{
+	u16 control;
+	int pos;
+
+	pos = pci_find_ext_capability(pdev, PCI_PRI_CAP);
+	if (!pos)
+		return false;
+
+	pci_read_config_word(pdev, pos + PCI_PRI_CONTROL_OFF, &control);
+
+	return (control & PCI_PRI_TLP_OFF) ? true : false;
+}
+
 /*
  * If a device is not yet associated with a domain, this function does
  * assigns it visible for the hardware
@@ -1973,6 +2006,7 @@ static int attach_device(struct device *dev,
 
 		dev_data->ats.enabled = true;
 		dev_data->ats.qdep    = pci_ats_queue_depth(pdev);
+		dev_data->pri_tlp     = pci_pri_tlp_required(pdev);
 	} else if (amd_iommu_iotlb_sup &&
 		   pci_enable_ats(pdev, PAGE_SHIFT) == 0) {
 		dev_data->ats.enabled = true;
@@ -3412,3 +3446,20 @@ int amd_iommu_domain_clear_gcr3(struct iommu_domain *dom, int pasid)
 	return ret;
 }
 EXPORT_SYMBOL(amd_iommu_domain_clear_gcr3);
+
+int amd_iommu_complete_ppr(struct pci_dev *pdev, int pasid,
+			   int status, int tag)
+{
+	struct iommu_dev_data *dev_data;
+	struct amd_iommu *iommu;
+	struct iommu_cmd cmd;
+
+	dev_data = get_dev_data(&pdev->dev);
+	iommu    = amd_iommu_rlookup_table[dev_data->devid];
+
+	build_complete_ppr(&cmd, dev_data->devid, pasid, status,
+			   tag, dev_data->pri_tlp);
+
+	return iommu_queue_command(iommu, &cmd);
+}
+EXPORT_SYMBOL(amd_iommu_complete_ppr);
diff --git a/drivers/iommu/amd_iommu_proto.h b/drivers/iommu/amd_iommu_proto.h
index a951a70..bb5ecfe 100644
--- a/drivers/iommu/amd_iommu_proto.h
+++ b/drivers/iommu/amd_iommu_proto.h
@@ -47,6 +47,12 @@ extern int amd_iommu_domain_set_gcr3(struct iommu_domain *dom, int pasid,
 				     unsigned long cr3);
 extern int amd_iommu_domain_clear_gcr3(struct iommu_domain *dom, int pasid);
 
+#define PPR_SUCCESS			0x0
+#define PPR_INVALID			0x1
+#define PPR_FAILURE			0xf
+
+extern int amd_iommu_complete_ppr(struct pci_dev *pdev, int pasid,
+				  int status, int tag);
 
 #ifndef CONFIG_AMD_IOMMU_STATS
 
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index 68937a4..e21c74a 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -142,6 +142,7 @@
 #define CMD_INV_DEV_ENTRY       0x02
 #define CMD_INV_IOMMU_PAGES	0x03
 #define CMD_INV_IOTLB_PAGES	0x04
+#define CMD_COMPLETE_PPR	0x07
 #define CMD_INV_ALL		0x08
 
 #define CMD_COMPL_WAIT_STORE_MASK	0x01
@@ -150,6 +151,9 @@
 #define CMD_INV_IOMMU_PAGES_PDE_MASK	0x02
 #define CMD_INV_IOMMU_PAGES_GN_MASK	0x04
 
+#define PPR_STATUS_MASK			0xf
+#define PPR_STATUS_SHIFT		12
+
 #define CMD_INV_IOMMU_ALL_PAGES_ADDRESS	0x7fffffffffffffffULL
 
 /* macros and definitions for device table entries */
@@ -395,6 +399,8 @@ struct iommu_dev_data {
 		bool enabled;
 		int qdep;
 	} ats;				  /* ATS state */
+	bool pri_tlp;			  /* PASID TLB required for
+					     PPR completions */
 };
 
 /*
-- 
1.7.5.4


