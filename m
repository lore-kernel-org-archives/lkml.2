Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab1FJMJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 08:09:41 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:25418
	"EHLO CH1EHSOBE011.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756060Ab1FJMIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 08:08:32 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMKPQ1-02-3BR-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/9] x86/amd-iommu: Store ATS state in dev_data
Date: Fri, 10 Jun 2011 14:08:44 +0200
Message-ID: <1307707729-29767-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307707729-29767-1-git-send-email-joerg.roedel@amd.com>
References: <1307707729-29767-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows the low-level functions to operate on dev_data
exclusivly later.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    4 +++
 arch/x86/kernel/amd_iommu.c            |   44 +++++++++++++++++--------------
 2 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 2833862..9fc045e 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -316,6 +316,10 @@ struct iommu_dev_data {
 	struct protection_domain *domain; /* Domain the device is bound to */
 	atomic_t bind;			  /* Domain attach reverent count */
 	u16 devid;			  /* PCI Device ID */
+	struct {
+		bool enabled;
+		int qdep;
+	} ats;				  /* ATS state */
 };
 
 /*
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 4e8b176..9e07ef6 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -695,17 +695,16 @@ void iommu_flush_all_caches(struct amd_iommu *iommu)
  */
 static int device_flush_iotlb(struct device *dev, u64 address, size_t size)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
+	struct iommu_dev_data *dev_data;
 	struct amd_iommu *iommu;
 	struct iommu_cmd cmd;
-	u16 devid;
 	int qdep;
 
-	qdep  = pci_ats_queue_depth(pdev);
-	devid = get_device_id(dev);
-	iommu = amd_iommu_rlookup_table[devid];
+	dev_data = get_dev_data(dev);
+	qdep     = dev_data->ats.qdep;
+	iommu    = amd_iommu_rlookup_table[dev_data->devid];
 
-	build_inv_iotlb_pages(&cmd, devid, qdep, address, size);
+	build_inv_iotlb_pages(&cmd, dev_data->devid, qdep, address, size);
 
 	return iommu_queue_command(iommu, &cmd);
 }
@@ -728,7 +727,7 @@ static int device_flush_dte(struct device *dev)
 	if (ret)
 		return ret;
 
-	if (pci_ats_enabled(pdev))
+	if (dev_data->ats.enabled)
 		ret = device_flush_iotlb(dev, 0, ~0UL);
 
 	return ret;
@@ -760,9 +759,8 @@ static void __domain_flush_pages(struct protection_domain *domain,
 	}
 
 	list_for_each_entry(dev_data, &domain->dev_list, list) {
-		struct pci_dev *pdev = to_pci_dev(dev_data->dev);
 
-		if (!pci_ats_enabled(pdev))
+		if (!dev_data->ats.enabled)
 			continue;
 
 		ret |= device_flush_iotlb(dev_data->dev, address, size);
@@ -1576,8 +1574,7 @@ static void do_attach(struct device *dev, struct protection_domain *domain)
 	iommu    = amd_iommu_rlookup_table[dev_data->devid];
 	pdev     = to_pci_dev(dev);
 
-	if (amd_iommu_iotlb_sup)
-		ats = pci_ats_enabled(pdev);
+	ats = dev_data->ats.enabled;
 
 	/* Update data structures */
 	dev_data->domain = domain;
@@ -1674,11 +1671,16 @@ static int attach_device(struct device *dev,
 			 struct protection_domain *domain)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
+	struct iommu_dev_data *dev_data;
 	unsigned long flags;
 	int ret;
 
-	if (amd_iommu_iotlb_sup)
-		pci_enable_ats(pdev, PAGE_SHIFT);
+	dev_data = get_dev_data(dev);
+
+	if (amd_iommu_iotlb_sup && pci_enable_ats(pdev, PAGE_SHIFT) == 0) {
+		dev_data->ats.enabled = true;
+		dev_data->ats.qdep    = pci_ats_queue_depth(pdev);
+	}
 
 	write_lock_irqsave(&amd_iommu_devtable_lock, flags);
 	ret = __attach_device(dev, domain);
@@ -1736,7 +1738,7 @@ static void __detach_device(struct device *dev)
  */
 static void detach_device(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
+	struct iommu_dev_data *dev_data;
 	unsigned long flags;
 
 	/* lock device table */
@@ -1744,8 +1746,12 @@ static void detach_device(struct device *dev)
 	__detach_device(dev);
 	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
 
-	if (amd_iommu_iotlb_sup && pci_ats_enabled(pdev))
-		pci_disable_ats(pdev);
+	dev_data = get_dev_data(dev);
+
+	if (dev_data->ats.enabled) {
+		pci_disable_ats(to_pci_dev(dev));
+		dev_data->ats.enabled = false;
+	}
 }
 
 /*
@@ -1890,10 +1896,8 @@ static void update_device_table(struct protection_domain *domain)
 {
 	struct iommu_dev_data *dev_data;
 
-	list_for_each_entry(dev_data, &domain->dev_list, list) {
-		struct pci_dev *pdev = to_pci_dev(dev_data->dev);
-		set_dte_entry(dev_data->devid, domain, pci_ats_enabled(pdev));
-	}
+	list_for_each_entry(dev_data, &domain->dev_list, list)
+		set_dte_entry(dev_data->devid, domain, dev_data->ats.enabled);
 }
 
 static void update_domain(struct protection_domain *domain)
-- 
1.7.4.1


