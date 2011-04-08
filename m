Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab1DHISH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 04:18:07 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:30272
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751019Ab1DHIRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 04:17:22 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJBR0Q-02-3MF-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/5] x86/amd-iommu: Flush device IOTLB if ATS is enabled
Date: Fri, 8 Apr 2011 10:17:08 +0200
Message-ID: <1302250630-8183-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302250630-8183-1-git-send-email-joerg.roedel@amd.com>
References: <1302250630-8183-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements a function to flush the IOTLB on
devices supporting ATS and makes sure that this TLB is also
flushed if necessary.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    3 +-
 arch/x86/kernel/amd_iommu.c            |   74 +++++++++++++++++++++++++++++++-
 2 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 878ae00..f5d184e 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -113,7 +113,8 @@
 /* command specific defines */
 #define CMD_COMPL_WAIT          0x01
 #define CMD_INV_DEV_ENTRY       0x02
-#define CMD_INV_IOMMU_PAGES     0x03
+#define CMD_INV_IOMMU_PAGES	0x03
+#define CMD_INV_IOTLB_PAGES	0x04
 
 #define CMD_COMPL_WAIT_STORE_MASK	0x01
 #define CMD_COMPL_WAIT_INT_MASK		0x02
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index bcf58ea..f3ce433 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -18,6 +18,7 @@
  */
 
 #include <linux/pci.h>
+#include <linux/pci-ats.h>
 #include <linux/bitmap.h>
 #include <linux/slab.h>
 #include <linux/debugfs.h>
@@ -463,6 +464,37 @@ static void build_inv_iommu_pages(struct iommu_cmd *cmd, u64 address,
 		cmd->data[2] |= CMD_INV_IOMMU_PAGES_PDE_MASK;
 }
 
+static void build_inv_iotlb_pages(struct iommu_cmd *cmd, u16 devid, int qdep,
+				  u64 address, size_t size)
+{
+	u64 pages;
+	int s;
+
+	pages = iommu_num_pages(address, size, PAGE_SIZE);
+	s     = 0;
+
+	if (pages > 1) {
+		/*
+		 * If we have to flush more than one page, flush all
+		 * TLB entries for this domain
+		 */
+		address = CMD_INV_IOMMU_ALL_PAGES_ADDRESS;
+		s = 1;
+	}
+
+	address &= PAGE_MASK;
+
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->data[0]  = devid;
+	cmd->data[0] |= (qdep & 0xff) << 24;
+	cmd->data[1]  = devid;
+	cmd->data[2]  = lower_32_bits(address);
+	cmd->data[3]  = upper_32_bits(address);
+	CMD_SET_TYPE(cmd, CMD_INV_IOTLB_PAGES);
+	if (s)
+		cmd->data[2] |= CMD_INV_IOMMU_PAGES_SIZE_MASK;
+}
+
 /*
  * Writes the command to the IOMMUs command buffer and informs the
  * hardware about the new command.
@@ -574,17 +606,47 @@ void iommu_flush_all_caches(struct amd_iommu *iommu)
 }
 
 /*
+ * Command send function for flushing on-device TLB
+ */
+static int device_flush_iotlb(struct device *dev, u64 address, size_t size)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct amd_iommu *iommu;
+	struct iommu_cmd cmd;
+	u16 devid;
+	int qdep;
+
+	qdep  = pci_ats_queue_depth(pdev);
+	devid = get_device_id(dev);
+	iommu = amd_iommu_rlookup_table[devid];
+
+	build_inv_iotlb_pages(&cmd, devid, qdep, address, size);
+
+	return iommu_queue_command(iommu, &cmd);
+}
+
+/*
  * Command send function for invalidating a device table entry
  */
 static int device_flush_dte(struct device *dev)
 {
 	struct amd_iommu *iommu;
+	struct pci_dev *pdev;
 	u16 devid;
+	int ret;
 
+	pdev  = to_pci_dev(dev);
 	devid = get_device_id(dev);
 	iommu = amd_iommu_rlookup_table[devid];
 
-	return iommu_flush_dte(iommu, devid);
+	ret = iommu_flush_dte(iommu, devid);
+	if (ret)
+		return ret;
+
+	if (pci_ats_enabled(pdev))
+		ret = device_flush_iotlb(dev, 0, ~0UL);
+
+	return ret;
 }
 
 /*
@@ -595,6 +657,7 @@ static int device_flush_dte(struct device *dev)
 static void __domain_flush_pages(struct protection_domain *domain,
 				 u64 address, size_t size, int pde)
 {
+	struct iommu_dev_data *dev_data;
 	struct iommu_cmd cmd;
 	int ret = 0, i;
 
@@ -611,6 +674,15 @@ static void __domain_flush_pages(struct protection_domain *domain,
 		ret |= iommu_queue_command(amd_iommus[i], &cmd);
 	}
 
+	list_for_each_entry(dev_data, &domain->dev_list, list) {
+		struct pci_dev *pdev = to_pci_dev(dev_data->dev);
+
+		if (!pci_ats_enabled(pdev))
+			continue;
+
+		ret |= device_flush_iotlb(dev_data->dev, address, size);
+	}
+
 	WARN_ON(ret);
 }
 
-- 
1.7.1


