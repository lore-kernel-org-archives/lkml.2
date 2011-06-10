Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab1FJMKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 08:10:07 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:44406
	"EHLO CH1EHSOBE013.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755964Ab1FJMIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 08:08:31 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMKPQ2-01-6LS-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5/9] x86/amd-iommu: Use only dev_data for dte and iotlb flushing routines
Date: Fri, 10 Jun 2011 14:08:45 +0200
Message-ID: <1307707729-29767-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307707729-29767-1-git-send-email-joerg.roedel@amd.com>
References: <1307707729-29767-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch make the functions flushing the DTE and IOTLBs
only take the dev_data structure instead of the struct
device directly.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   23 +++++++++--------------
 1 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 9e07ef6..0a5b465 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -693,14 +693,13 @@ void iommu_flush_all_caches(struct amd_iommu *iommu)
 /*
  * Command send function for flushing on-device TLB
  */
-static int device_flush_iotlb(struct device *dev, u64 address, size_t size)
+static int device_flush_iotlb(struct iommu_dev_data *dev_data,
+			      u64 address, size_t size)
 {
-	struct iommu_dev_data *dev_data;
 	struct amd_iommu *iommu;
 	struct iommu_cmd cmd;
 	int qdep;
 
-	dev_data = get_dev_data(dev);
 	qdep     = dev_data->ats.qdep;
 	iommu    = amd_iommu_rlookup_table[dev_data->devid];
 
@@ -712,23 +711,19 @@ static int device_flush_iotlb(struct device *dev, u64 address, size_t size)
 /*
  * Command send function for invalidating a device table entry
  */
-static int device_flush_dte(struct device *dev)
+static int device_flush_dte(struct iommu_dev_data *dev_data)
 {
-	struct iommu_dev_data *dev_data;
 	struct amd_iommu *iommu;
-	struct pci_dev *pdev;
 	int ret;
 
-	pdev     = to_pci_dev(dev);
-	dev_data = get_dev_data(dev);
-	iommu    = amd_iommu_rlookup_table[dev_data->devid];
+	iommu = amd_iommu_rlookup_table[dev_data->devid];
 
 	ret = iommu_flush_dte(iommu, dev_data->devid);
 	if (ret)
 		return ret;
 
 	if (dev_data->ats.enabled)
-		ret = device_flush_iotlb(dev, 0, ~0UL);
+		ret = device_flush_iotlb(dev_data, 0, ~0UL);
 
 	return ret;
 }
@@ -763,7 +758,7 @@ static void __domain_flush_pages(struct protection_domain *domain,
 		if (!dev_data->ats.enabled)
 			continue;
 
-		ret |= device_flush_iotlb(dev_data->dev, address, size);
+		ret |= device_flush_iotlb(dev_data, address, size);
 	}
 
 	WARN_ON(ret);
@@ -815,7 +810,7 @@ static void domain_flush_devices(struct protection_domain *domain)
 	spin_lock_irqsave(&domain->lock, flags);
 
 	list_for_each_entry(dev_data, &domain->dev_list, list)
-		device_flush_dte(dev_data->dev);
+		device_flush_dte(dev_data);
 
 	spin_unlock_irqrestore(&domain->lock, flags);
 }
@@ -1586,7 +1581,7 @@ static void do_attach(struct device *dev, struct protection_domain *domain)
 	domain->dev_cnt                 += 1;
 
 	/* Flush the DTE entry */
-	device_flush_dte(dev);
+	device_flush_dte(dev_data);
 }
 
 static void do_detach(struct device *dev)
@@ -1607,7 +1602,7 @@ static void do_detach(struct device *dev)
 	clear_dte_entry(dev_data->devid);
 
 	/* Flush the DTE entry */
-	device_flush_dte(dev);
+	device_flush_dte(dev_data);
 }
 
 /*
-- 
1.7.4.1


