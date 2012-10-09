Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab2JIEuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 00:50:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310Ab2JIEuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 00:50:13 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [RFC PATCH 5/5] amd_iommu: Properly account for virtual aliases in
 IOMMU groups
To: Joerg.Roedel@amd.com, florian@dazinger.net
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 08 Oct 2012 22:50:00 -0600
Message-ID: <20121009045000.16302.13122.stgit@bling.home>
In-Reply-To: <20121009044057.16302.44577.stgit@bling.home>
References: <20121009044057.16302.44577.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An alias doesn't always point to a physical device.  When this
happens we must first verify that the IOMMU group isn't rooted in
a device above the alias.  In this case the alias is effectively
just another quirk for the devices aliased to it.  Alternatively,
the virtual alias itself may be the root of the IOMMU group.  To
support this, allow a group to be hosted on the alias dev_data
for use by anything that might have the same alias.

Signed-off-by: Alex williamson <alex.williamson@redhat.com>
---

 drivers/iommu/amd_iommu.c       |   61 ++++++++++++++++++++++++++++++++++++---
 drivers/iommu/amd_iommu_types.h |    1 +
 2 files changed, 57 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 7fa97a5..cb63cc5 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -140,6 +140,9 @@ static void free_dev_data(struct iommu_dev_data *dev_data)
 	list_del(&dev_data->dev_data_list);
 	spin_unlock_irqrestore(&dev_data_list_lock, flags);
 
+	if (dev_data->group)
+		iommu_group_put(dev_data->group);
+
 	kfree(dev_data);
 }
 
@@ -343,11 +346,25 @@ static int use_pdev_iommu_group(struct pci_dev *pdev, struct device *dev)
 	return ret;
 }
 
+static int use_dev_data_iommu_group(struct iommu_dev_data *dev_data,
+				    struct device *dev)
+{
+	if (!dev_data->group) {
+		struct iommu_group *group = iommu_group_alloc();
+		if (IS_ERR(group))
+			return PTR_ERR(group);
+
+		dev_data->group = group;
+	}
+
+	return iommu_group_add_device(dev_data->group, dev);
+}
+
 static int init_iommu_group(struct device *dev)
 {
 	struct iommu_dev_data *dev_data;
 	struct iommu_group *group;
-	struct pci_dev *dma_pdev = NULL;
+	struct pci_dev *dma_pdev;
 	int ret;
 
 	group = iommu_group_get(dev);
@@ -362,18 +379,52 @@ static int init_iommu_group(struct device *dev)
 
 	if (dev_data->alias_data) {
 		u16 alias;
+		struct pci_bus *bus;
+
+		if (dev_data->alias_data->group)
+			goto use_group;
 
+		/*
+		 * If the alias device exists, it's effectively just a first
+		 * level quirk for finding the DMA source.
+		 */
 		alias = amd_iommu_alias_table[dev_data->devid];
 		dma_pdev = pci_get_bus_and_slot(alias >> 8, alias & 0xff);
-	}
+		if (dma_pdev) {
+			dma_pdev = get_isolation_root(dma_pdev);
+			goto use_pdev;
+		}
+
+		/*
+		 * If the alias is virtual, try to find a parent device
+		 * and test whether the IOMMU group is actualy rooted above
+		 * the alias.  Be careful to also test the parent device if
+		 * we think the alias is the root of the group.
+		 */
+		bus = pci_find_bus(0, alias >> 8);
+		if (!bus)
+			goto use_group;
+
+		bus = find_hosted_bus(bus);
+		if (IS_ERR(bus) || !bus->self)
+			goto use_group;
 
-	if (!dma_pdev)
-		dma_pdev = pci_dev_get(to_pci_dev(dev));
+		dma_pdev = get_isolation_root(pci_dev_get(bus->self));
+		if (dma_pdev != bus->self || (dma_pdev->multifunction &&
+		    !pci_acs_enabled(dma_pdev, REQ_ACS_FLAGS)))
+			goto use_pdev;
+
+		pci_dev_put(dma_pdev);
+		goto use_group;
+	}
 
-	dma_pdev = get_isolation_root(dma_pdev);
+	dma_pdev = get_isolation_root(pci_dev_get(to_pci_dev(dev)));
+use_pdev:
 	ret = use_pdev_iommu_group(dma_pdev, dev);
 	pci_dev_put(dma_pdev);
 	return ret;
+use_group:
+	return use_dev_data_iommu_group(dev_data->alias_data, dev);
 }
 
 static int iommu_init_device(struct device *dev)
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index c9aa3d0..e38ab43 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -426,6 +426,7 @@ struct iommu_dev_data {
 	struct iommu_dev_data *alias_data;/* The alias dev_data */
 	struct protection_domain *domain; /* Domain the device is bound to */
 	atomic_t bind;			  /* Domain attach reference count */
+	struct iommu_group *group;	  /* IOMMU group for virtual aliases */
 	u16 devid;			  /* PCI Device ID */
 	bool iommu_v2;			  /* Device can make use of IOMMUv2 */
 	bool passthrough;		  /* Default for device is pt_domain */

