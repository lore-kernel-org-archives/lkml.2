Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952Ab2EVFIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 01:08:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932820Ab2EVFFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 01:05:32 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v2 06/13] iommu: Make use of DMA quirking and ACS enabled
 check for groups
To: benh@kernel.crashing.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, dwmw2@infradead.org
Cc: chrisw@sous-sol.org, agraf@suse.de, benve@cisco.com, aafabbri@cisco.com,
        B08248@freescale.com, B07421@freescale.com, avi@redhat.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        bhelgaas@google.com, ddutile@redhat.com, alex.williamson@redhat.com
Date: Mon, 21 May 2012 23:05:15 -0600
Message-ID: <20120522050515.5871.92344.stgit@bling.home>
In-Reply-To: <20120522043607.5871.11340.stgit@bling.home>
References: <20120522043607.5871.11340.stgit@bling.home>
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
with broken Ricoh devices.  This a very strict implementation of
ACS checking, which will often result in multifunction devices
being grouped together.  This is actually a good thing as we
generally have no reason to trust isolation between functions,
but I won't be surprised if we later add a boot option to relax
this if a user wants to opt-in to a less secure grouping.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/iommu/amd_iommu.c   |   18 ++++++++++++++++++
 drivers/iommu/intel-iommu.c |   18 ++++++++++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index b7e5ddf..be72d6d 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -254,6 +254,8 @@ static bool check_device(struct device *dev)
 	return true;
 }
 
+#define PCI_ACS_ENABLED	(PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF)
+
 static int iommu_init_device(struct device *dev)
 {
 	struct pci_dev *dma_pdev, *pdev = to_pci_dev(dev);
@@ -291,6 +293,22 @@ static int iommu_init_device(struct device *dev)
 		dma_pdev = pci_get_slot(pdev->bus,
 					PCI_DEVFN(PCI_SLOT(pdev->devfn), 0));
 
+	dma_pdev = pci_dma_source(dma_pdev);
+
+	if (dma_pdev->multifunction &&
+	    !pci_acs_enabled(dma_pdev, PCI_ACS_ENABLED))
+		dma_pdev = pci_get_slot(dma_pdev->bus,
+					PCI_DEVFN(PCI_SLOT(dma_pdev->devfn),
+					0));
+
+	while (!pci_is_root_bus(dma_pdev->bus)) {
+		if (pci_acs_path_enabled(dma_pdev->bus->self,
+					 NULL, PCI_ACS_ENABLED))
+			break;
+
+		dma_pdev = dma_pdev->bus->self;
+	}
+
 	group = iommu_group_get(&dma_pdev->dev);
 	if (!group) {
 		group = iommu_group_alloc();
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index e63b33b..cf2a650 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4087,6 +4087,8 @@ static int intel_iommu_domain_has_cap(struct iommu_domain *domain,
 	return 0;
 }
 
+#define PCI_ACS_ENABLED	(PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF)
+
 static int intel_iommu_add_device(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -4113,6 +4115,22 @@ static int intel_iommu_add_device(struct device *dev)
 		dma_pdev = pci_get_slot(pdev->bus,
 					PCI_DEVFN(PCI_SLOT(pdev->devfn), 0));
 
+	dma_pdev = pci_dma_source(dma_pdev);
+
+	if (dma_pdev->multifunction &&
+	    !pci_acs_enabled(dma_pdev, PCI_ACS_ENABLED))
+		dma_pdev = pci_get_slot(dma_pdev->bus,
+					PCI_DEVFN(PCI_SLOT(dma_pdev->devfn),
+					0));
+
+	while (!pci_is_root_bus(dma_pdev->bus)) {
+		if (pci_acs_path_enabled(dma_pdev->bus->self,
+					 NULL, PCI_ACS_ENABLED))
+			break;
+
+		dma_pdev = dma_pdev->bus->self;
+	}
+
 	group = iommu_group_get(&dma_pdev->dev);
 	if (!group) {
 		group = iommu_group_alloc();

