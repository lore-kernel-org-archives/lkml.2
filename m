Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab1FJMJ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 08:09:56 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:26239
	"EHLO CH1EHSOBE016.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756012Ab1FJMIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 08:08:31 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMKPQ2-01-6LU-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/9] x86/amd-iommu: Introduce global dev_data_list
Date: Fri, 10 Jun 2011 14:08:42 +0200
Message-ID: <1307707729-29767-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307707729-29767-1-git-send-email-joerg.roedel@amd.com>
References: <1307707729-29767-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This list keeps all allocated iommu_dev_data structs in a
list together. This is needed for instances that have no
associated device.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    1 +
 arch/x86/kernel/amd_iommu.c            |   56 ++++++++++++++++++++++++++-----
 2 files changed, 48 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 4c99829..35520e3 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -310,6 +310,7 @@ struct protection_domain {
  */
 struct iommu_dev_data {
 	struct list_head list;		  /* For domain->dev_list */
+	struct list_head dev_data_list;	  /* For global dev_data_list */
 	struct device *dev;		  /* Device this data belong to */
 	struct device *alias;		  /* The Alias Device */
 	struct protection_domain *domain; /* Domain the device is bound to */
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index cc6f6da6..8b84890 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -45,6 +45,10 @@ static DEFINE_RWLOCK(amd_iommu_devtable_lock);
 static LIST_HEAD(iommu_pd_list);
 static DEFINE_SPINLOCK(iommu_pd_list_lock);
 
+/* List of all available dev_data structures */
+static LIST_HEAD(dev_data_list);
+static DEFINE_SPINLOCK(dev_data_list_lock);
+
 /*
  * Domain for untranslated devices - only allocated
  * if iommu=pt passed on kernel cmd line.
@@ -68,6 +72,35 @@ static void update_domain(struct protection_domain *domain);
  *
  ****************************************************************************/
 
+static struct iommu_dev_data *alloc_dev_data(void)
+{
+	struct iommu_dev_data *dev_data;
+	unsigned long flags;
+
+	dev_data = kzalloc(sizeof(*dev_data), GFP_KERNEL);
+	if (!dev_data)
+		return NULL;
+
+	atomic_set(&dev_data->bind, 0);
+
+	spin_lock_irqsave(&dev_data_list_lock, flags);
+	list_add_tail(&dev_data->dev_data_list, &dev_data_list);
+	spin_unlock_irqrestore(&dev_data_list_lock, flags);
+
+	return dev_data;
+}
+
+static void free_dev_data(struct iommu_dev_data *dev_data)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev_data_list_lock, flags);
+	list_del(&dev_data->dev_data_list);
+	spin_unlock_irqrestore(&dev_data_list_lock, flags);
+
+	kfree(dev_data);
+}
+
 static inline u16 get_device_id(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -139,32 +172,28 @@ static int iommu_init_device(struct device *dev)
 {
 	struct iommu_dev_data *dev_data;
 	struct pci_dev *pdev;
-	u16 devid, alias;
+	u16 alias;
 
 	if (dev->archdata.iommu)
 		return 0;
 
-	dev_data = kzalloc(sizeof(*dev_data), GFP_KERNEL);
+	dev_data = alloc_dev_data();
 	if (!dev_data)
 		return -ENOMEM;
 
 	dev_data->dev = dev;
 
-	devid = get_device_id(dev);
-	alias = amd_iommu_alias_table[devid];
+	alias = amd_iommu_alias_table[get_device_id(dev)];
 	pdev = pci_get_bus_and_slot(PCI_BUS(alias), alias & 0xff);
 	if (pdev)
 		dev_data->alias = &pdev->dev;
 	else {
-		kfree(dev_data);
+		free_dev_data(dev_data);
 		return -ENOTSUPP;
 	}
 
-	atomic_set(&dev_data->bind, 0);
-
 	dev->archdata.iommu = dev_data;
 
-
 	return 0;
 }
 
@@ -184,11 +213,16 @@ static void iommu_ignore_device(struct device *dev)
 
 static void iommu_uninit_device(struct device *dev)
 {
-	kfree(dev->archdata.iommu);
+	/*
+	 * Nothing to do here - we keep dev_data around for unplugged devices
+	 * and reuse it when the device is re-plugged - not doing so would
+	 * introduce a ton of races.
+	 */
 }
 
 void __init amd_iommu_uninit_devices(void)
 {
+	struct iommu_dev_data *dev_data, *n;
 	struct pci_dev *pdev = NULL;
 
 	for_each_pci_dev(pdev) {
@@ -198,6 +232,10 @@ void __init amd_iommu_uninit_devices(void)
 
 		iommu_uninit_device(&pdev->dev);
 	}
+
+	/* Free all of our dev_data structures */
+	list_for_each_entry_safe(dev_data, n, &dev_data_list, dev_data_list)
+		free_dev_data(dev_data);
 }
 
 int __init amd_iommu_init_devices(void)
-- 
1.7.4.1


