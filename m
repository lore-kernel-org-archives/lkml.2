Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab2E3FKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 01:10:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406Ab2E3FKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 01:10:34 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 3/7] amd_iommu: Support IOMMU groups
To: joerg.roedel@amd.com, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org
Cc: bhelgaas@google.com, benh@kernel.crashing.org, aik@ozlabs.ru,
        david@gibson.dropbear.id.au, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        gregkh@linuxfoundation.org, ddutile@redhat.com,
        alex.williamson@redhat.com
Date: Tue, 29 May 2012 23:10:21 -0600
Message-ID: <20120530051021.1543.35393.stgit@bling.home>
In-Reply-To: <20120530045150.1543.73660.stgit@bling.home>
References: <20120530045150.1543.73660.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add IOMMU group support to AMD-Vi device init and uninit code.
Existing notifiers make sure this gets called for each device.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/iommu/amd_iommu.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 0ad46f1..c0385b3 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -256,9 +256,11 @@ static bool check_device(struct device *dev)
 
 static int iommu_init_device(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
+	struct pci_dev *dma_pdev, *pdev = to_pci_dev(dev);
 	struct iommu_dev_data *dev_data;
+	struct iommu_group *group;
 	u16 alias;
+	int ret;
 
 	if (dev->archdata.iommu)
 		return 0;
@@ -279,8 +281,30 @@ static int iommu_init_device(struct device *dev)
 			return -ENOTSUPP;
 		}
 		dev_data->alias_data = alias_data;
+
+		dma_pdev = pci_get_bus_and_slot(alias >> 8, alias & 0xff);
+	} else
+		dma_pdev = pdev;
+
+	if (!pdev->is_virtfn && PCI_FUNC(pdev->devfn) && iommu_group_mf &&
+	    pdev->hdr_type == PCI_HEADER_TYPE_NORMAL)
+		dma_pdev = pci_get_slot(pdev->bus,
+					PCI_DEVFN(PCI_SLOT(pdev->devfn), 0));
+
+	group = iommu_group_get(&dma_pdev->dev);
+	if (!group) {
+		group = iommu_group_alloc();
+		if (IS_ERR(group))
+			return PTR_ERR(group);
 	}
 
+	ret = iommu_group_add_device(group, dev);
+
+	iommu_group_put(group);
+
+	if (ret)
+		return ret;
+
 	if (pci_iommuv2_capable(pdev)) {
 		struct amd_iommu *iommu;
 
@@ -309,6 +333,8 @@ static void iommu_ignore_device(struct device *dev)
 
 static void iommu_uninit_device(struct device *dev)
 {
+	iommu_group_remove_device(dev);
+
 	/*
 	 * Nothing to do here - we keep dev_data around for unplugged devices
 	 * and reuse it when the device is re-plugged - not doing so would

