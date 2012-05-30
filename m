Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab2E3UTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 16:19:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962Ab2E3UTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 16:19:48 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v2 5/7] amd_iommu: Make use of DMA quirks and ACS checks in
 IOMMU groups
To: joerg.roedel@amd.com, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org
Cc: bhelgaas@google.com, benh@kernel.crashing.org, aik@ozlabs.ru,
        david@gibson.dropbear.id.au, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        gregkh@linuxfoundation.org, ddutile@redhat.com,
        alex.williamson@redhat.com, liuj97@gmail.com
Date: Wed, 30 May 2012 14:19:31 -0600
Message-ID: <20120530201931.31527.57970.stgit@bling.home>
In-Reply-To: <20120530201424.31527.33142.stgit@bling.home>
References: <20120530201424.31527.33142.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Work around broken devices and adhere to ACS support when determining
IOMMU grouping.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/iommu/amd_iommu.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index e072bd1..0e78d3c 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -254,6 +254,14 @@ static bool check_device(struct device *dev)
 	return true;
 }
 
+static void swap_pci_ref(struct pci_dev **from, struct pci_dev *to)
+{
+	pci_dev_put(*from);
+	*from = to;
+}
+
+#define REQ_ACS_FLAGS	(PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF)
+
 static int iommu_init_device(struct device *dev)
 {
 	struct pci_dev *dma_pdev, *pdev = to_pci_dev(dev);
@@ -286,6 +294,23 @@ static int iommu_init_device(struct device *dev)
 	} else
 		dma_pdev = pci_dev_get(pdev);
 
+	swap_pci_ref(&dma_pdev, pci_get_dma_source(dma_pdev));
+
+	if (dma_pdev->multifunction &&
+	    !pci_acs_enabled(dma_pdev, REQ_ACS_FLAGS))
+		swap_pci_ref(&dma_pdev,
+			     pci_get_slot(dma_pdev->bus,
+					  PCI_DEVFN(PCI_SLOT(dma_pdev->devfn),
+					  0)));
+
+	while (!pci_is_root_bus(dma_pdev->bus)) {
+		if (pci_acs_path_enabled(dma_pdev->bus->self,
+					 NULL, REQ_ACS_FLAGS))
+			break;
+
+		swap_pci_ref(&dma_pdev, pci_dev_get(dma_pdev->bus->self));
+	}
+
 	group = iommu_group_get(&dma_pdev->dev);
 	pci_dev_put(dma_pdev);
 	if (!group) {

