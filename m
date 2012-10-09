Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376Ab2JIEtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 00:49:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262Ab2JIEtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 00:49:47 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [RFC PATCH 2/5] amd_iommu: Split IOMMU Group topology walk
To: Joerg.Roedel@amd.com, florian@dazinger.net
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 08 Oct 2012 22:49:41 -0600
Message-ID: <20121009044941.16302.16171.stgit@bling.home>
In-Reply-To: <20121009044057.16302.44577.stgit@bling.home>
References: <20121009044057.16302.44577.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/iommu/amd_iommu.c |   58 ++++++++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 25 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index b65b377..6edbd0e 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -276,32 +276,9 @@ static void swap_pci_ref(struct pci_dev **from, struct pci_dev *to)
 
 #define REQ_ACS_FLAGS	(PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF)
 
-static int init_iommu_group(struct device *dev)
+static struct pci_dev *get_isolation_root(struct pci_dev *pdev)
 {
-	struct iommu_dev_data *dev_data;
-	struct iommu_group *group;
-	struct pci_dev *dma_pdev = NULL;
-	int ret;
-
-	group = iommu_group_get(dev);
-	if (group) {
-		iommu_group_put(group);
-		return 0;
-	}
-
-	dev_data = find_dev_data(get_device_id(dev));
-	if (!dev_data)
-		return -ENOMEM;
-
-	if (dev_data->alias_data) {
-		u16 alias;
-
-		alias = amd_iommu_alias_table[dev_data->devid];
-		dma_pdev = pci_get_bus_and_slot(alias >> 8, alias & 0xff);
-	}
-
-	if (!dma_pdev)
-		dma_pdev = pci_dev_get(to_pci_dev(dev));
+	struct pci_dev *dma_pdev = pdev;
 
 	/* Account for quirked devices */
 	swap_pci_ref(&dma_pdev, pci_get_dma_source(dma_pdev));
@@ -339,6 +316,37 @@ static int init_iommu_group(struct device *dev)
 	}
 
 root_bus:
+	return dma_pdev;
+}
+
+static int init_iommu_group(struct device *dev)
+{
+	struct iommu_dev_data *dev_data;
+	struct iommu_group *group;
+	struct pci_dev *dma_pdev = NULL;
+	int ret;
+
+	group = iommu_group_get(dev);
+	if (group) {
+		iommu_group_put(group);
+		return 0;
+	}
+
+	dev_data = find_dev_data(get_device_id(dev));
+	if (!dev_data)
+		return -ENOMEM;
+
+	if (dev_data->alias_data) {
+		u16 alias;
+
+		alias = amd_iommu_alias_table[dev_data->devid];
+		dma_pdev = pci_get_bus_and_slot(alias >> 8, alias & 0xff);
+	}
+
+	if (!dma_pdev)
+		dma_pdev = pci_dev_get(to_pci_dev(dev));
+
+	dma_pdev = get_isolation_root(dma_pdev);
 	group = iommu_group_get(&dma_pdev->dev);
 	pci_dev_put(dma_pdev);
 	if (!group) {

