Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415Ab1FJMIg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 08:08:36 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:34254
	"EHLO CH1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756180Ab1FJMId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 08:08:33 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMKPQ2-02-3BS-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 9/9] x86/amd-iommu: Store device alias as dev_data pointer
Date: Fri, 10 Jun 2011 14:08:49 +0200
Message-ID: <1307707729-29767-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307707729-29767-1-git-send-email-joerg.roedel@amd.com>
References: <1307707729-29767-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This finally allows PCI-Device-IDs to be handled by the
IOMMU driver that have no corresponding struct device
present in the system.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    2 +-
 arch/x86/kernel/amd_iommu.c            |   34 ++++++++++++++-----------------
 2 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index fffbe3c..5b9c507 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -311,7 +311,7 @@ struct protection_domain {
 struct iommu_dev_data {
 	struct list_head list;		  /* For domain->dev_list */
 	struct list_head dev_data_list;	  /* For global dev_data_list */
-	struct device *alias;		  /* The Alias Device */
+	struct iommu_dev_data *alias_data;/* The alias dev_data */
 	struct protection_domain *domain; /* Domain the device is bound to */
 	atomic_t bind;			  /* Domain attach reverent count */
 	u16 devid;			  /* PCI Device ID */
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index f647998..0ed1c94 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -203,7 +203,6 @@ static bool check_device(struct device *dev)
 static int iommu_init_device(struct device *dev)
 {
 	struct iommu_dev_data *dev_data;
-	struct pci_dev *pdev;
 	u16 alias;
 
 	if (dev->archdata.iommu)
@@ -215,13 +214,16 @@ static int iommu_init_device(struct device *dev)
 
 	alias = amd_iommu_alias_table[dev_data->devid];
 	if (alias != dev_data->devid) {
-		pdev = pci_get_bus_and_slot(PCI_BUS(alias), alias & 0xff);
-		if (pdev)
-			dev_data->alias = &pdev->dev;
-		else {
+		struct iommu_dev_data *alias_data;
+
+		alias_data = find_dev_data(alias);
+		if (alias_data == NULL) {
+			pr_err("AMD-Vi: Warning: Unhandled device %s\n",
+					dev_name(dev));
 			free_dev_data(dev_data);
 			return -ENOTSUPP;
 		}
+		dev_data->alias_data = alias_data;
 	}
 
 	dev->archdata.iommu = dev_data;
@@ -1642,14 +1644,8 @@ static int __attach_device(struct iommu_dev_data *dev_data,
 	/* lock domain */
 	spin_lock(&domain->lock);
 
-	if (dev_data->alias != NULL) {
-		struct iommu_dev_data *alias_data;
-
-		alias_data = get_dev_data(dev_data->alias);
-
-		ret = -EINVAL;
-		if (!alias_data)
-			goto out_unlock;
+	if (dev_data->alias_data != NULL) {
+		struct iommu_dev_data *alias_data = dev_data->alias_data;
 
 		/* Some sanity checks */
 		ret = -EBUSY;
@@ -1721,7 +1717,6 @@ static int attach_device(struct device *dev,
  */
 static void __detach_device(struct iommu_dev_data *dev_data)
 {
-	struct iommu_dev_data *alias_data;
 	struct protection_domain *domain;
 	unsigned long flags;
 
@@ -1731,8 +1726,9 @@ static void __detach_device(struct iommu_dev_data *dev_data)
 
 	spin_lock_irqsave(&domain->lock, flags);
 
-	if (dev_data->alias) {
-		alias_data = get_dev_data(dev_data->alias);
+	if (dev_data->alias_data != NULL) {
+		struct iommu_dev_data *alias_data = dev_data->alias_data;
+
 		if (atomic_dec_and_test(&alias_data->bind))
 			do_detach(alias_data);
 	}
@@ -1779,7 +1775,7 @@ static void detach_device(struct device *dev)
  */
 static struct protection_domain *domain_for_device(struct device *dev)
 {
-	struct iommu_dev_data *dev_data, *alias_data;
+	struct iommu_dev_data *dev_data;
 	struct protection_domain *dom = NULL;
 	unsigned long flags;
 
@@ -1788,8 +1784,8 @@ static struct protection_domain *domain_for_device(struct device *dev)
 	if (dev_data->domain)
 		return dev_data->domain;
 
-	if (dev_data->alias != NULL) {
-		alias_data = get_dev_data(dev_data->alias);
+	if (dev_data->alias_data != NULL) {
+		struct iommu_dev_data *alias_data = dev_data->alias_data;
 
 		read_lock_irqsave(&amd_iommu_devtable_lock, flags);
 		if (alias_data->domain != NULL) {
-- 
1.7.4.1


