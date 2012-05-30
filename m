Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab2E3UTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 16:19:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754368Ab2E3UTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 16:19:39 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v2 4/7] intel-iommu: Support IOMMU groups
To: joerg.roedel@amd.com, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org
Cc: bhelgaas@google.com, benh@kernel.crashing.org, aik@ozlabs.ru,
        david@gibson.dropbear.id.au, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        gregkh@linuxfoundation.org, ddutile@redhat.com,
        alex.williamson@redhat.com, liuj97@gmail.com
Date: Wed, 30 May 2012 14:19:19 -0600
Message-ID: <20120530201919.31527.45209.stgit@bling.home>
In-Reply-To: <20120530201424.31527.33142.stgit@bling.home>
References: <20120530201424.31527.33142.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add IOMMU group support to Intel VT-d code.  This driver sets up
devices ondemand, so make use of the add_device/remove_device
callbacks in IOMMU API to manage setting up the groups.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/iommu/intel-iommu.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index c62f2df..4a43452 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4090,6 +4090,47 @@ static int intel_iommu_domain_has_cap(struct iommu_domain *domain,
 	return 0;
 }
 
+static int intel_iommu_add_device(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct pci_dev *bridge, *dma_pdev;
+	struct iommu_group *group;
+	int ret;
+
+	if (!device_to_iommu(pci_domain_nr(pdev->bus),
+			     pdev->bus->number, pdev->devfn))
+		return -ENODEV;
+
+	bridge = pci_find_upstream_pcie_bridge(pdev);
+	if (bridge) {
+		if (pci_is_pcie(bridge))
+			dma_pdev = pci_get_domain_bus_and_slot(
+						pci_domain_nr(pdev->bus),
+						bridge->subordinate->number, 0);
+		else
+			dma_pdev = pci_dev_get(bridge);
+	} else
+		dma_pdev = pci_dev_get(pdev);
+
+	group = iommu_group_get(&dma_pdev->dev);
+	pci_dev_put(dma_pdev);
+	if (!group) {
+		group = iommu_group_alloc();
+		if (IS_ERR(group))
+			return PTR_ERR(group);
+	}
+
+	ret = iommu_group_add_device(group, dev);
+
+	iommu_group_put(group);
+	return ret;
+}
+
+static void intel_iommu_remove_device(struct device *dev)
+{
+	iommu_group_remove_device(dev);
+}
+
 static struct iommu_ops intel_iommu_ops = {
 	.domain_init	= intel_iommu_domain_init,
 	.domain_destroy = intel_iommu_domain_destroy,
@@ -4099,6 +4140,8 @@ static struct iommu_ops intel_iommu_ops = {
 	.unmap		= intel_iommu_unmap,
 	.iova_to_phys	= intel_iommu_iova_to_phys,
 	.domain_has_cap = intel_iommu_domain_has_cap,
+	.add_device	= intel_iommu_add_device,
+	.remove_device	= intel_iommu_remove_device,
 	.pgsize_bitmap	= INTEL_IOMMU_PGSIZES,
 };
 

