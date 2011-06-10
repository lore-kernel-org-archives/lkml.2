Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab1FJMJE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 08:09:04 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:29291
	"EHLO CH1EHSOBE012.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756180Ab1FJMIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 08:08:37 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMKPQ2-01-6LV-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/9] x86/amd-iommu: Store devid in dev_data
Date: Fri, 10 Jun 2011 14:08:43 +0200
Message-ID: <1307707729-29767-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307707729-29767-1-git-send-email-joerg.roedel@amd.com>
References: <1307707729-29767-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows to use dev_data independent of struct device
later.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    1 +
 arch/x86/kernel/amd_iommu.c            |   39 ++++++++++++-------------------
 2 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 35520e3..2833862 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -315,6 +315,7 @@ struct iommu_dev_data {
 	struct device *alias;		  /* The Alias Device */
 	struct protection_domain *domain; /* Domain the device is bound to */
 	atomic_t bind;			  /* Domain attach reverent count */
+	u16 devid;			  /* PCI Device ID */
 };
 
 /*
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 8b84890..4e8b176 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -72,7 +72,7 @@ static void update_domain(struct protection_domain *domain);
  *
  ****************************************************************************/
 
-static struct iommu_dev_data *alloc_dev_data(void)
+static struct iommu_dev_data *alloc_dev_data(u16 devid)
 {
 	struct iommu_dev_data *dev_data;
 	unsigned long flags;
@@ -81,6 +81,7 @@ static struct iommu_dev_data *alloc_dev_data(void)
 	if (!dev_data)
 		return NULL;
 
+	dev_data->devid = devid;
 	atomic_set(&dev_data->bind, 0);
 
 	spin_lock_irqsave(&dev_data_list_lock, flags);
@@ -177,13 +178,13 @@ static int iommu_init_device(struct device *dev)
 	if (dev->archdata.iommu)
 		return 0;
 
-	dev_data = alloc_dev_data();
+	dev_data = alloc_dev_data(get_device_id(dev));
 	if (!dev_data)
 		return -ENOMEM;
 
 	dev_data->dev = dev;
 
-	alias = amd_iommu_alias_table[get_device_id(dev)];
+	alias = amd_iommu_alias_table[dev_data->devid];
 	pdev = pci_get_bus_and_slot(PCI_BUS(alias), alias & 0xff);
 	if (pdev)
 		dev_data->alias = &pdev->dev;
@@ -714,16 +715,16 @@ static int device_flush_iotlb(struct device *dev, u64 address, size_t size)
  */
 static int device_flush_dte(struct device *dev)
 {
+	struct iommu_dev_data *dev_data;
 	struct amd_iommu *iommu;
 	struct pci_dev *pdev;
-	u16 devid;
 	int ret;
 
-	pdev  = to_pci_dev(dev);
-	devid = get_device_id(dev);
-	iommu = amd_iommu_rlookup_table[devid];
+	pdev     = to_pci_dev(dev);
+	dev_data = get_dev_data(dev);
+	iommu    = amd_iommu_rlookup_table[dev_data->devid];
 
-	ret = iommu_flush_dte(iommu, devid);
+	ret = iommu_flush_dte(iommu, dev_data->devid);
 	if (ret)
 		return ret;
 
@@ -1570,11 +1571,9 @@ static void do_attach(struct device *dev, struct protection_domain *domain)
 	struct amd_iommu *iommu;
 	struct pci_dev *pdev;
 	bool ats = false;
-	u16 devid;
 
-	devid    = get_device_id(dev);
-	iommu    = amd_iommu_rlookup_table[devid];
 	dev_data = get_dev_data(dev);
+	iommu    = amd_iommu_rlookup_table[dev_data->devid];
 	pdev     = to_pci_dev(dev);
 
 	if (amd_iommu_iotlb_sup)
@@ -1583,7 +1582,7 @@ static void do_attach(struct device *dev, struct protection_domain *domain)
 	/* Update data structures */
 	dev_data->domain = domain;
 	list_add(&dev_data->list, &domain->dev_list);
-	set_dte_entry(devid, domain, ats);
+	set_dte_entry(dev_data->devid, domain, ats);
 
 	/* Do reference counting */
 	domain->dev_iommu[iommu->index] += 1;
@@ -1597,11 +1596,9 @@ static void do_detach(struct device *dev)
 {
 	struct iommu_dev_data *dev_data;
 	struct amd_iommu *iommu;
-	u16 devid;
 
-	devid    = get_device_id(dev);
-	iommu    = amd_iommu_rlookup_table[devid];
 	dev_data = get_dev_data(dev);
+	iommu    = amd_iommu_rlookup_table[dev_data->devid];
 
 	/* decrease reference counters */
 	dev_data->domain->dev_iommu[iommu->index] -= 1;
@@ -1610,7 +1607,7 @@ static void do_detach(struct device *dev)
 	/* Update data structures */
 	dev_data->domain = NULL;
 	list_del(&dev_data->list);
-	clear_dte_entry(devid);
+	clear_dte_entry(dev_data->devid);
 
 	/* Flush the DTE entry */
 	device_flush_dte(dev);
@@ -1760,9 +1757,7 @@ static struct protection_domain *domain_for_device(struct device *dev)
 	struct protection_domain *dom;
 	struct iommu_dev_data *dev_data, *alias_data;
 	unsigned long flags;
-	u16 devid;
 
-	devid      = get_device_id(dev);
 	dev_data   = get_dev_data(dev);
 	alias_data = get_dev_data(dev_data->alias);
 	if (!alias_data)
@@ -1897,8 +1892,7 @@ static void update_device_table(struct protection_domain *domain)
 
 	list_for_each_entry(dev_data, &domain->dev_list, list) {
 		struct pci_dev *pdev = to_pci_dev(dev_data->dev);
-		u16 devid = get_device_id(dev_data->dev);
-		set_dte_entry(devid, domain, pci_ats_enabled(pdev));
+		set_dte_entry(dev_data->devid, domain, pci_ats_enabled(pdev));
 	}
 }
 
@@ -2652,16 +2646,13 @@ static int amd_iommu_attach_device(struct iommu_domain *dom,
 	struct iommu_dev_data *dev_data;
 	struct amd_iommu *iommu;
 	int ret;
-	u16 devid;
 
 	if (!check_device(dev))
 		return -EINVAL;
 
 	dev_data = dev->archdata.iommu;
 
-	devid = get_device_id(dev);
-
-	iommu = amd_iommu_rlookup_table[devid];
+	iommu = amd_iommu_rlookup_table[dev_data->devid];
 	if (!iommu)
 		return -EINVAL;
 
-- 
1.7.4.1


