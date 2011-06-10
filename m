Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab1FJMIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 08:08:45 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:24512
	"EHLO CH1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755864Ab1FJMIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 08:08:34 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMKPQ2-02-3BT-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 7/9] x86/amd-iommu: Allow dev_data->alias to be NULL
Date: Fri, 10 Jun 2011 14:08:47 +0200
Message-ID: <1307707729-29767-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307707729-29767-1-git-send-email-joerg.roedel@amd.com>
References: <1307707729-29767-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let dev_data->alias be just NULL if the device has no alias.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   77 +++++++++++++++++++++++--------------------
 1 files changed, 41 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index a15a172..2d914a4 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -183,12 +183,14 @@ static int iommu_init_device(struct device *dev)
 		return -ENOMEM;
 
 	alias = amd_iommu_alias_table[dev_data->devid];
-	pdev = pci_get_bus_and_slot(PCI_BUS(alias), alias & 0xff);
-	if (pdev)
-		dev_data->alias = &pdev->dev;
-	else {
-		free_dev_data(dev_data);
-		return -ENOTSUPP;
+	if (alias != dev_data->devid) {
+		pdev = pci_get_bus_and_slot(PCI_BUS(alias), alias & 0xff);
+		if (pdev)
+			dev_data->alias = &pdev->dev;
+		else {
+			free_dev_data(dev_data);
+			return -ENOTSUPP;
+		}
 	}
 
 	dev->archdata.iommu = dev_data;
@@ -1604,29 +1606,31 @@ static void do_detach(struct iommu_dev_data *dev_data)
 static int __attach_device(struct iommu_dev_data *dev_data,
 			   struct protection_domain *domain)
 {
-	struct iommu_dev_data *alias_data;
 	int ret;
 
-	alias_data = get_dev_data(dev_data->alias);
-
-	if (!alias_data)
-		return -EINVAL;
-
 	/* lock domain */
 	spin_lock(&domain->lock);
 
-	/* Some sanity checks */
-	ret = -EBUSY;
-	if (alias_data->domain != NULL &&
-	    alias_data->domain != domain)
-		goto out_unlock;
+	if (dev_data->alias != NULL) {
+		struct iommu_dev_data *alias_data;
+
+		alias_data = get_dev_data(dev_data->alias);
+
+		ret = -EINVAL;
+		if (!alias_data)
+			goto out_unlock;
 
-	if (dev_data->domain != NULL &&
-	    dev_data->domain != domain)
-		goto out_unlock;
+		/* Some sanity checks */
+		ret = -EBUSY;
+		if (alias_data->domain != NULL &&
+				alias_data->domain != domain)
+			goto out_unlock;
 
-	/* Do real assignment */
-	if (dev_data->devid != alias_data->devid) {
+		if (dev_data->domain != NULL &&
+				dev_data->domain != domain)
+			goto out_unlock;
+
+		/* Do real assignment */
 		if (alias_data->domain == NULL)
 			do_attach(alias_data, domain);
 
@@ -1696,8 +1700,8 @@ static void __detach_device(struct iommu_dev_data *dev_data)
 
 	spin_lock_irqsave(&domain->lock, flags);
 
-	alias_data = get_dev_data(dev_data->alias);
-	if (dev_data->devid != alias_data->devid) {
+	if (dev_data->alias) {
+		alias_data = get_dev_data(dev_data->alias);
 		if (atomic_dec_and_test(&alias_data->bind))
 			do_detach(alias_data);
 	}
@@ -1744,24 +1748,25 @@ static void detach_device(struct device *dev)
  */
 static struct protection_domain *domain_for_device(struct device *dev)
 {
-	struct protection_domain *dom;
 	struct iommu_dev_data *dev_data, *alias_data;
+	struct protection_domain *dom = NULL;
 	unsigned long flags;
 
 	dev_data   = get_dev_data(dev);
-	alias_data = get_dev_data(dev_data->alias);
-	if (!alias_data)
-		return NULL;
 
-	read_lock_irqsave(&amd_iommu_devtable_lock, flags);
-	dom = dev_data->domain;
-	if (dom == NULL &&
-	    alias_data->domain != NULL) {
-		__attach_device(dev_data, alias_data->domain);
-		dom = alias_data->domain;
-	}
+	if (dev_data->domain)
+		return dev_data->domain;
 
-	read_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
+	if (dev_data->alias != NULL) {
+		alias_data = get_dev_data(dev_data->alias);
+
+		read_lock_irqsave(&amd_iommu_devtable_lock, flags);
+		if (alias_data->domain != NULL) {
+			__attach_device(dev_data, alias_data->domain);
+			dom = alias_data->domain;
+		}
+		read_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
+	}
 
 	return dom;
 }
-- 
1.7.4.1


