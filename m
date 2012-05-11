Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759470Ab2EKW4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 18:56:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759335Ab2EKW43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 18:56:29 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 06/13] iommu: Make use of DMA quirking and ACS enabled check
 for groups
To: benh@kernel.crashing.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, dwmw2@infradead.org
Cc: chrisw@sous-sol.org, agraf@suse.de, benve@cisco.com, aafabbri@cisco.com,
        B08248@freescale.com, B07421@freescale.com, avi@redhat.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        bhelgaas@google.com, alex.williamson@redhat.com
Date: Fri, 11 May 2012 16:56:09 -0600
Message-ID: <20120511225609.30496.92191.stgit@bling.home>
In-Reply-To: <20120511222148.30496.68571.stgit@bling.home>
References: <20120511222148.30496.68571.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Incorporate DMA quirking and ACS checking into amd_iommu and
intel-iommu.  Note that IOMMU groups are not yet used for
streaming DMA, so this doesn't immediately solve the problems
with broken Ricoh devices.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/iommu/amd_iommu.c   |    3 +++
 drivers/iommu/intel-iommu.c |    3 +++
 drivers/pci/pci.h           |    1 +
 3 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index b7e5ddf..a165311 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -291,6 +291,9 @@ static int iommu_init_device(struct device *dev)
 		dma_pdev = pci_get_slot(pdev->bus,
 					PCI_DEVFN(PCI_SLOT(pdev->devfn), 0));
 
+	dma_pdev = pci_dma_quirk(dma_pdev);
+	dma_pdev = pci_acs_enabled(dma_pdev);
+
 	group = iommu_group_get(&dma_pdev->dev);
 	if (!group) {
 		group = iommu_group_alloc();
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index e63b33b..5f526c7 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4113,6 +4113,9 @@ static int intel_iommu_add_device(struct device *dev)
 		dma_pdev = pci_get_slot(pdev->bus,
 					PCI_DEVFN(PCI_SLOT(pdev->devfn), 0));
 
+	dma_pdev = pci_dma_quirk(dma_pdev);
+	dma_pdev = pci_acs_enabled(dma_pdev);
+
 	group = iommu_group_get(&dma_pdev->dev);
 	if (!group) {
 		group = iommu_group_alloc();
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index e494347..e8f2f8f 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -310,6 +310,7 @@ static inline resource_size_t pci_resource_alignment(struct pci_dev *dev,
 }
 
 extern void pci_enable_acs(struct pci_dev *dev);
+extern struct pci_dev *pci_acs_enabled(struct pci_dev *dev);
 
 struct pci_dev_reset_methods {
 	u16 vendor;

