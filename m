Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab1JUT5G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 15:57:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152Ab1JUT5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 15:57:04 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 2/4] intel-iommu: Implement iommu_device_group
To: joerg.roedel@amd.com, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, chrisw@redhat.com, agraf@suse.de,
        dwg@au1.ibm.com, scottwood@freescale.com, B08248@freescale.com,
        benh@kernel.crashing.org, alex.williamson@redhat.com
Date: Fri, 21 Oct 2011 13:56:11 -0600
Message-ID: <20111021195611.8438.84499.stgit@s20.home>
In-Reply-To: <20111021195412.8438.9951.stgit@s20.home>
References: <20111021195412.8438.9951.stgit@s20.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We generally have BDF granularity for devices, so we just need
to make sure devices aren't hidden behind PCIe-to-PCI bridges.
We can then make up a group number that's simply the concatenated
seg|bus|dev|fn so we don't have to track them (not that users
should depend on that).

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/iommu/intel-iommu.c |   44 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 2d53c3d..d23d66a 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3901,6 +3901,49 @@ static int intel_iommu_domain_has_cap(struct iommu_domain *domain,
 	return 0;
 }
 
+/* Group numbers are arbitrary.  Device with the same group number
+ * indicate the iommu cannot differentiate between them.  To avoid
+ * tracking used groups we just use the seg|bus|devfn of the lowest
+ * level we're able to differentiate devices */
+static int intel_iommu_device_group(struct device *dev, unsigned int *groupid)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct pci_dev *bridge;
+	union {
+		struct {
+			u8 devfn;
+			u8 bus;
+			u16 segment;
+		} pci;
+		u32 group;
+	} id;
+
+	if (iommu_no_mapping(dev))
+		return -ENODEV;
+
+	id.pci.segment = pci_domain_nr(pdev->bus);
+	id.pci.bus = pdev->bus->number;
+	id.pci.devfn = pdev->devfn;
+
+	if (!device_to_iommu(id.pci.segment, id.pci.bus, id.pci.devfn))
+		return -ENODEV;
+
+	bridge = pci_find_upstream_pcie_bridge(pdev);
+	if (bridge) {
+		if (pci_is_pcie(bridge)) {
+			id.pci.bus = bridge->subordinate->number;
+			id.pci.devfn = 0;
+		} else {
+			id.pci.bus = bridge->bus->number;
+			id.pci.devfn = bridge->devfn;
+		}
+	}
+
+	*groupid = id.group;
+
+	return 0;
+}
+
 static struct iommu_ops intel_iommu_ops = {
 	.domain_init	= intel_iommu_domain_init,
 	.domain_destroy = intel_iommu_domain_destroy,
@@ -3910,6 +3953,7 @@ static struct iommu_ops intel_iommu_ops = {
 	.unmap		= intel_iommu_unmap,
 	.iova_to_phys	= intel_iommu_iova_to_phys,
 	.domain_has_cap = intel_iommu_domain_has_cap,
+	.device_group	= intel_iommu_device_group,
 };
 
 static void __devinit quirk_iommu_rwbf(struct pci_dev *dev)

