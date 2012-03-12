Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964Ab2CLWdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 18:33:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757894Ab2CLWdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 18:33:15 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 2/2] intel-iommu: Basic isolation group provider support
To: david@gibson.dropbear.id.au, aik@ozlabs.ru, dwmw2@infradead.org
Cc: alex.williamson@redhat.com, iommu@lists.linux-foundation.org,
        benh@kernel.crashing.org, qemu-devel@nongnu.org, joerg.roedel@amd.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 12 Mar 2012 16:33:02 -0600
Message-ID: <20120312223302.30321.91922.stgit@bling.home>
In-Reply-To: <20120312220109.30321.83419.stgit@bling.home>
References: <20120312220109.30321.83419.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/iommu/intel-iommu.c |   70 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 70 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index c9c6053..2e5a709 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -42,6 +42,7 @@
 #include <linux/dmi.h>
 #include <linux/pci-ats.h>
 #include <linux/memblock.h>
+#include <linux/isolation.h>
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
 
@@ -3597,6 +3598,73 @@ static struct notifier_block device_nb = {
 	.notifier_call = device_notifier,
 };
 
+static int isolation_notifier(struct notifier_block *nb,
+			      unsigned long action, void *data)
+{
+	struct device *dev = data;
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	if (iommu_no_mapping(dev) ||
+	    !device_to_iommu(pci_domain_nr(pdev->bus),
+			     pdev->bus->number, pdev->devfn))
+		return NOTIFY_DONE;
+
+
+	if (action == ISOLATION_NOTIFY_ADD_DEVICE) {
+		struct device *dma_dev = NULL;
+		struct pci_dev *bridge = pci_find_upstream_pcie_bridge(pdev);
+		struct isolation_group *group;
+
+		if (bridge) {
+			if (pci_is_pcie(bridge)) {
+				struct pci_dev *dma_pdev;
+				dma_pdev = pci_get_domain_bus_and_slot(
+					pci_domain_nr(pdev->bus),
+					bridge->subordinate->number, 0);
+				dma_dev = &dma_pdev->dev;
+			}
+
+			if (!dma_dev)
+				dma_dev = &bridge->dev;
+		} else
+			dma_dev = dev;
+
+		group = to_isolation_group(dma_dev);
+
+		if (!group) {
+			group = isolation_create_group();
+			if (IS_ERR(group))
+				return NOTIFY_BAD;
+
+			isolation_group_set_iommu_ops(group, &intel_iommu_ops);
+
+			if (dma_dev != dev)
+				isolation_group_add_dev(group, dma_dev);
+		}
+
+		if (isolation_group_add_dev(group, dev))
+			return NOTIFY_BAD;
+
+		return NOTIFY_STOP;
+
+	} else if (action == ISOLATION_NOTIFY_DEL_DEVICE) {
+		struct isolation_group *group = to_isolation_group(dev);
+
+		if (isolation_group_del_dev(dev))
+			return NOTIFY_BAD;
+
+		isolation_free_group(group);
+
+		return NOTIFY_STOP;
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block isolation_nb = {
+	.notifier_call = isolation_notifier,
+};
+
 int __init intel_iommu_init(void)
 {
 	int ret = 0;
@@ -3663,6 +3731,8 @@ int __init intel_iommu_init(void)
 
 	bus_register_notifier(&pci_bus_type, &device_nb);
 
+	isolation_register_notifier(&pci_bus_type, &isolation_nb);
+
 	intel_iommu_enabled = 1;
 
 	return 0;

