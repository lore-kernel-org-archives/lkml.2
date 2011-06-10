Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab1FJMId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 08:08:33 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:25409
	"EHLO CH1EHSOBE011.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755864Ab1FJMIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 08:08:31 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMKPQ2-02-3BU-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6/9] x86/amd-iommu: Use only dev_data in low-level domain attach/detach functions
Date: Fri, 10 Jun 2011 14:08:46 +0200
Message-ID: <1307707729-29767-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307707729-29767-1-git-send-email-joerg.roedel@amd.com>
References: <1307707729-29767-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this patch the low-level attach/detach functions only
work on dev_data structures. This allows to remove the
dev_data->dev pointer.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    1 -
 arch/x86/kernel/amd_iommu.c            |   61 ++++++++++++-------------------
 2 files changed, 24 insertions(+), 38 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 9fc045e..fffbe3c 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -311,7 +311,6 @@ struct protection_domain {
 struct iommu_dev_data {
 	struct list_head list;		  /* For domain->dev_list */
 	struct list_head dev_data_list;	  /* For global dev_data_list */
-	struct device *dev;		  /* Device this data belong to */
 	struct device *alias;		  /* The Alias Device */
 	struct protection_domain *domain; /* Domain the device is bound to */
 	atomic_t bind;			  /* Domain attach reverent count */
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 0a5b465..a15a172 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -182,8 +182,6 @@ static int iommu_init_device(struct device *dev)
 	if (!dev_data)
 		return -ENOMEM;
 
-	dev_data->dev = dev;
-
 	alias = amd_iommu_alias_table[dev_data->devid];
 	pdev = pci_get_bus_and_slot(PCI_BUS(alias), alias & 0xff);
 	if (pdev)
@@ -1558,18 +1556,14 @@ static void clear_dte_entry(u16 devid)
 	amd_iommu_apply_erratum_63(devid);
 }
 
-static void do_attach(struct device *dev, struct protection_domain *domain)
+static void do_attach(struct iommu_dev_data *dev_data,
+		      struct protection_domain *domain)
 {
-	struct iommu_dev_data *dev_data;
 	struct amd_iommu *iommu;
-	struct pci_dev *pdev;
-	bool ats = false;
-
-	dev_data = get_dev_data(dev);
-	iommu    = amd_iommu_rlookup_table[dev_data->devid];
-	pdev     = to_pci_dev(dev);
+	bool ats;
 
-	ats = dev_data->ats.enabled;
+	iommu = amd_iommu_rlookup_table[dev_data->devid];
+	ats   = dev_data->ats.enabled;
 
 	/* Update data structures */
 	dev_data->domain = domain;
@@ -1584,13 +1578,11 @@ static void do_attach(struct device *dev, struct protection_domain *domain)
 	device_flush_dte(dev_data);
 }
 
-static void do_detach(struct device *dev)
+static void do_detach(struct iommu_dev_data *dev_data)
 {
-	struct iommu_dev_data *dev_data;
 	struct amd_iommu *iommu;
 
-	dev_data = get_dev_data(dev);
-	iommu    = amd_iommu_rlookup_table[dev_data->devid];
+	iommu = amd_iommu_rlookup_table[dev_data->devid];
 
 	/* decrease reference counters */
 	dev_data->domain->dev_iommu[iommu->index] -= 1;
@@ -1609,13 +1601,12 @@ static void do_detach(struct device *dev)
  * If a device is not yet associated with a domain, this function does
  * assigns it visible for the hardware
  */
-static int __attach_device(struct device *dev,
+static int __attach_device(struct iommu_dev_data *dev_data,
 			   struct protection_domain *domain)
 {
-	struct iommu_dev_data *dev_data, *alias_data;
+	struct iommu_dev_data *alias_data;
 	int ret;
 
-	dev_data   = get_dev_data(dev);
 	alias_data = get_dev_data(dev_data->alias);
 
 	if (!alias_data)
@@ -1635,16 +1626,15 @@ static int __attach_device(struct device *dev,
 		goto out_unlock;
 
 	/* Do real assignment */
-	if (dev_data->alias != dev) {
-		alias_data = get_dev_data(dev_data->alias);
+	if (dev_data->devid != alias_data->devid) {
 		if (alias_data->domain == NULL)
-			do_attach(dev_data->alias, domain);
+			do_attach(alias_data, domain);
 
 		atomic_inc(&alias_data->bind);
 	}
 
 	if (dev_data->domain == NULL)
-		do_attach(dev, domain);
+		do_attach(dev_data, domain);
 
 	atomic_inc(&dev_data->bind);
 
@@ -1678,7 +1668,7 @@ static int attach_device(struct device *dev,
 	}
 
 	write_lock_irqsave(&amd_iommu_devtable_lock, flags);
-	ret = __attach_device(dev, domain);
+	ret = __attach_device(dev_data, domain);
 	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
 
 	/*
@@ -1694,9 +1684,8 @@ static int attach_device(struct device *dev,
 /*
  * Removes a device from a protection domain (unlocked)
  */
-static void __detach_device(struct device *dev)
+static void __detach_device(struct iommu_dev_data *dev_data)
 {
-	struct iommu_dev_data *dev_data = get_dev_data(dev);
 	struct iommu_dev_data *alias_data;
 	struct protection_domain *domain;
 	unsigned long flags;
@@ -1707,14 +1696,14 @@ static void __detach_device(struct device *dev)
 
 	spin_lock_irqsave(&domain->lock, flags);
 
-	if (dev_data->alias != dev) {
-		alias_data = get_dev_data(dev_data->alias);
+	alias_data = get_dev_data(dev_data->alias);
+	if (dev_data->devid != alias_data->devid) {
 		if (atomic_dec_and_test(&alias_data->bind))
-			do_detach(dev_data->alias);
+			do_detach(alias_data);
 	}
 
 	if (atomic_dec_and_test(&dev_data->bind))
-		do_detach(dev);
+		do_detach(dev_data);
 
 	spin_unlock_irqrestore(&domain->lock, flags);
 
@@ -1725,7 +1714,7 @@ static void __detach_device(struct device *dev)
 	 */
 	if (iommu_pass_through &&
 	    (dev_data->domain == NULL && domain != pt_domain))
-		__attach_device(dev, pt_domain);
+		__attach_device(dev_data, pt_domain);
 }
 
 /*
@@ -1736,13 +1725,13 @@ static void detach_device(struct device *dev)
 	struct iommu_dev_data *dev_data;
 	unsigned long flags;
 
+	dev_data = get_dev_data(dev);
+
 	/* lock device table */
 	write_lock_irqsave(&amd_iommu_devtable_lock, flags);
-	__detach_device(dev);
+	__detach_device(dev_data);
 	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
 
-	dev_data = get_dev_data(dev);
-
 	if (dev_data->ats.enabled) {
 		pci_disable_ats(to_pci_dev(dev));
 		dev_data->ats.enabled = false;
@@ -1768,7 +1757,7 @@ static struct protection_domain *domain_for_device(struct device *dev)
 	dom = dev_data->domain;
 	if (dom == NULL &&
 	    alias_data->domain != NULL) {
-		__attach_device(dev, alias_data->domain);
+		__attach_device(dev_data, alias_data->domain);
 		dom = alias_data->domain;
 	}
 
@@ -2527,9 +2516,7 @@ static void cleanup_domain(struct protection_domain *domain)
 	write_lock_irqsave(&amd_iommu_devtable_lock, flags);
 
 	list_for_each_entry_safe(dev_data, next, &domain->dev_list, list) {
-		struct device *dev = dev_data->dev;
-
-		__detach_device(dev);
+		__detach_device(dev_data);
 		atomic_set(&dev_data->bind, 0);
 	}
 
-- 
1.7.4.1


