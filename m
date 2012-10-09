Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab2JIEuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 00:50:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429Ab2JIEuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 00:50:00 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [RFC PATCH 4/5] amd_iommu: Split IOMMU group allocation and attach
To: Joerg.Roedel@amd.com, florian@dazinger.net
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 08 Oct 2012 22:49:54 -0600
Message-ID: <20121009044954.16302.75951.stgit@bling.home>
In-Reply-To: <20121009044057.16302.44577.stgit@bling.home>
References: <20121009044057.16302.44577.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a WARN_ON to make it clear why we don't add dma_pdev->dev to the
group we're allocating.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/iommu/amd_iommu.c |   30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 3a00b5ce..7fa97a5 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -325,6 +325,24 @@ static struct pci_dev *get_isolation_root(struct pci_dev *pdev)
 	return dma_pdev;
 }
 
+static int use_pdev_iommu_group(struct pci_dev *pdev, struct device *dev)
+{
+	struct iommu_group *group = iommu_group_get(&pdev->dev);
+	int ret;
+
+	if (!group) {
+		group = iommu_group_alloc();
+		if (IS_ERR(group))
+			return PTR_ERR(group);
+
+		WARN_ON(&pdev->dev != dev);
+	}
+
+	ret = iommu_group_add_device(group, dev);
+	iommu_group_put(group);
+	return ret;
+}
+
 static int init_iommu_group(struct device *dev)
 {
 	struct iommu_dev_data *dev_data;
@@ -353,18 +371,8 @@ static int init_iommu_group(struct device *dev)
 		dma_pdev = pci_dev_get(to_pci_dev(dev));
 
 	dma_pdev = get_isolation_root(dma_pdev);
-	group = iommu_group_get(&dma_pdev->dev);
+	ret = use_pdev_iommu_group(dma_pdev, dev);
 	pci_dev_put(dma_pdev);
-	if (!group) {
-		group = iommu_group_alloc();
-		if (IS_ERR(group))
-			return PTR_ERR(group);
-	}
-
-	ret = iommu_group_add_device(group, dev);
-
-	iommu_group_put(group);
-
 	return ret;
 }
 

