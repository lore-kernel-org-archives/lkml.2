Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab1DHIRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 04:17:42 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.181]:16666
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751503Ab1DHIRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 04:17:23 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJBR0R-02-3ML-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5/5] x86/amd-iommu: Add ATS enable/disable code
Date: Fri, 8 Apr 2011 10:17:10 +0200
Message-ID: <1302250630-8183-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302250630-8183-1-git-send-email-joerg.roedel@amd.com>
References: <1302250630-8183-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the necessary code to the AMD IOMMU driver
for enabling and disabling the ATS capability on a device
and to setup the IOMMU data structures correctly.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    2 ++
 arch/x86/kernel/amd_iommu.c            |   29 +++++++++++++++++++++++------
 2 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index cb811c9..7434377 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -216,6 +216,8 @@
 #define IOMMU_PTE_IR (1ULL << 61)
 #define IOMMU_PTE_IW (1ULL << 62)
 
+#define DTE_FLAG_IOTLB	0x01
+
 #define IOMMU_PAGE_MASK (((1ULL << 52) - 1) & ~0xfffULL)
 #define IOMMU_PTE_PRESENT(pte) ((pte) & IOMMU_PTE_P)
 #define IOMMU_PTE_PAGE(pte) (phys_to_virt((pte) & IOMMU_PAGE_MASK))
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index f3ce433..ad97fd6 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1452,17 +1452,22 @@ static bool dma_ops_domain(struct protection_domain *domain)
 	return domain->flags & PD_DMA_OPS_MASK;
 }
 
-static void set_dte_entry(u16 devid, struct protection_domain *domain)
+static void set_dte_entry(u16 devid, struct protection_domain *domain, bool ats)
 {
 	u64 pte_root = virt_to_phys(domain->pt_root);
+	u32 flags = 0;
 
 	pte_root |= (domain->mode & DEV_ENTRY_MODE_MASK)
 		    << DEV_ENTRY_MODE_SHIFT;
 	pte_root |= IOMMU_PTE_IR | IOMMU_PTE_IW | IOMMU_PTE_P | IOMMU_PTE_TV;
 
-	amd_iommu_dev_table[devid].data[2] = domain->id;
-	amd_iommu_dev_table[devid].data[1] = upper_32_bits(pte_root);
-	amd_iommu_dev_table[devid].data[0] = lower_32_bits(pte_root);
+	if (ats)
+		flags |= DTE_FLAG_IOTLB;
+
+	amd_iommu_dev_table[devid].data[3] |= flags;
+	amd_iommu_dev_table[devid].data[2]  = domain->id;
+	amd_iommu_dev_table[devid].data[1]  = upper_32_bits(pte_root);
+	amd_iommu_dev_table[devid].data[0]  = lower_32_bits(pte_root);
 }
 
 static void clear_dte_entry(u16 devid)
@@ -1479,16 +1484,22 @@ static void do_attach(struct device *dev, struct protection_domain *domain)
 {
 	struct iommu_dev_data *dev_data;
 	struct amd_iommu *iommu;
+	struct pci_dev *pdev;
+	bool ats = false;
 	u16 devid;
 
 	devid    = get_device_id(dev);
 	iommu    = amd_iommu_rlookup_table[devid];
 	dev_data = get_dev_data(dev);
+	pdev     = to_pci_dev(dev);
+
+	if (amd_iommu_iotlb_sup)
+		ats = pci_enable_ats(pdev, PAGE_SHIFT) == 0;
 
 	/* Update data structures */
 	dev_data->domain = domain;
 	list_add(&dev_data->list, &domain->dev_list);
-	set_dte_entry(devid, domain);
+	set_dte_entry(devid, domain, ats);
 
 	/* Do reference counting */
 	domain->dev_iommu[iommu->index] += 1;
@@ -1502,11 +1513,13 @@ static void do_detach(struct device *dev)
 {
 	struct iommu_dev_data *dev_data;
 	struct amd_iommu *iommu;
+	struct pci_dev *pdev;
 	u16 devid;
 
 	devid    = get_device_id(dev);
 	iommu    = amd_iommu_rlookup_table[devid];
 	dev_data = get_dev_data(dev);
+	pdev     = to_pci_dev(dev);
 
 	/* decrease reference counters */
 	dev_data->domain->dev_iommu[iommu->index] -= 1;
@@ -1517,6 +1530,9 @@ static void do_detach(struct device *dev)
 	list_del(&dev_data->list);
 	clear_dte_entry(devid);
 
+	if (amd_iommu_iotlb_sup && pci_ats_enabled(pdev))
+		pci_disable_ats(pdev);
+
 	/* Flush the DTE entry */
 	device_flush_dte(dev);
 }
@@ -1795,8 +1811,9 @@ static void update_device_table(struct protection_domain *domain)
 	struct iommu_dev_data *dev_data;
 
 	list_for_each_entry(dev_data, &domain->dev_list, list) {
+		struct pci_dev *pdev = to_pci_dev(dev_data->dev);
 		u16 devid = get_device_id(dev_data->dev);
-		set_dte_entry(devid, domain);
+		set_dte_entry(devid, domain, pci_ats_enabled(pdev));
 	}
 }
 
-- 
1.7.1


