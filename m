Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259Ab2EKW4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 18:56:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757080Ab2EKW4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 18:56:11 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 03/13] iommu: IOMMU groups for VT-d and AMD-Vi
To: benh@kernel.crashing.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, dwmw2@infradead.org
Cc: chrisw@sous-sol.org, agraf@suse.de, benve@cisco.com, aafabbri@cisco.com,
        B08248@freescale.com, B07421@freescale.com, avi@redhat.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        bhelgaas@google.com, alex.williamson@redhat.com
Date: Fri, 11 May 2012 16:55:48 -0600
Message-ID: <20120511225548.30496.34428.stgit@bling.home>
In-Reply-To: <20120511222148.30496.68571.stgit@bling.home>
References: <20120511222148.30496.68571.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add back group support for AMD & Intel.  amd_iommu already tracks
devices and has init and uninit routines to manage groups.
intel-iommu does this on the fly, so we make use of the notifier
support built into iommu groups to create and remove groups.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/iommu/amd_iommu.c   |   28 +++++++++++++++++++++++++-
 drivers/iommu/intel-iommu.c |   46 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 32c00cd..b7e5ddf 100644
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
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index d4a0ff7..e63b33b 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4087,6 +4087,50 @@ static int intel_iommu_domain_has_cap(struct iommu_domain *domain,
 	return 0;
 }
 
+static int intel_iommu_add_device(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct pci_dev *bridge, *dma_pdev = pdev;
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
+			dma_pdev = bridge;
+	}
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
@@ -4096,6 +4140,8 @@ static struct iommu_ops intel_iommu_ops = {
 	.unmap		= intel_iommu_unmap,
 	.iova_to_phys	= intel_iommu_iova_to_phys,
 	.domain_has_cap = intel_iommu_domain_has_cap,
+	.add_device	= intel_iommu_add_device,
+	.remove_device	= intel_iommu_remove_device,
 	.pgsize_bitmap	= INTEL_IOMMU_PGSIZES,
 };
 

