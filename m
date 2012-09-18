Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab2IRR2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 13:28:01 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:42440 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab2IRR15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 13:27:57 -0400
From: Tom Mingarelli <thomas.mingarelli@hp.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>, Don Dutile <ddutile@redhat.com>
Cc: Shuah Khan <shuah.khan@hp.com>, Tom Mingarelli <thomas.mingarelli@hp.com>,
        Linda Knippers <linda.knippers@hp.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Message-Id: <20120918172807.12439.93299.sendpatchset@tmingo.houston.hp.com>
Subject: [PATCH v2] Intel IOMMU patch to reprocess RMRR info
Date: Tue, 18 Sep 2012 17:27:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a 32bit PCI device is removed from the SI Domain, the RMRR information
for this device becomes invalid and needs to be reprocessed to avoid DMA
Read errors. These errors are evidenced by the Present bit being cleared in
the device's context entry. Fixing this problem with an enhancement to process
the RMRR info when the device is assigned to another domain. The Bus Master bit
is cleared during the move to another domain and during the reprocessing of
the RMRR info so no DMA can take place at this time.
----
PATCH v1: https://lkml.org/lkml/2012/6/15/204

drivers/iommu/intel-iommu.c |   47 ++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 44 insertions(+), 3 deletions(-)

Signed-off-by: Thomas Mingarelli <thomas.mingarelli@hp.com>

diff -up ./drivers/iommu/intel-iommu.c.ORIG ./drivers/iommu/intel-iommu.c
--- ./drivers/iommu/intel-iommu.c.ORIG	2012-09-18 09:58:25.147976889 -0500
+++ ./drivers/iommu/intel-iommu.c	2012-09-18 10:39:43.286672765 -0500
@@ -2706,11 +2706,39 @@ static int iommu_dummy(struct pci_dev *p
 	return pdev->dev.archdata.iommu == DUMMY_DEVICE_DOMAIN_INFO;
 }
 
+static int reprocess_rmrr(struct device *dev)
+{
+	struct dmar_rmrr_unit *rmrr;
+	struct pci_dev *pdev;
+	int i, ret;
+
+	pdev = to_pci_dev(dev);
+
+	for_each_rmrr_units(rmrr) {
+		for (i = 0; i < rmrr->devices_cnt; i++) {
+			/*
+			 * Here we are just concerned with
+			 * finding the one device that was
+			 * removed from the si_domain and
+			 * re-evaluating its RMRR info.
+			 */
+			if (rmrr->devices[i] != pdev)
+				continue;
+			pr_info("IOMMU: Reprocess RMRR information for device %s.\n",
+				pci_name(pdev));
+			ret = iommu_prepare_rmrr_dev(rmrr, pdev);
+			if (ret)
+				pr_err("IOMMU: Reprocessing RMRR reserved region for device failed");
+		}
+	}
+return 0;
+}
+
 /* Check if the pdev needs to go through non-identity map and unmap process.*/
 static int iommu_no_mapping(struct device *dev)
 {
 	struct pci_dev *pdev;
-	int found;
+	int found, current_bus_master;
 
 	if (unlikely(dev->bus != &pci_bus_type))
 		return 1;
@@ -2731,9 +2759,22 @@ static int iommu_no_mapping(struct devic
 			 * 32 bit DMA is removed from si_domain and fall back
 			 * to non-identity mapping.
 			 */
-			domain_remove_one_dev_info(si_domain, pdev);
 			printk(KERN_INFO "32bit %s uses non-identity mapping\n",
-			       pci_name(pdev));
+				pci_name(pdev));
+			/*
+			 * If a device gets this far we need to clear the Bus
+			 * Master bit before we start moving devices from domain
+			 * to domain. We will also reset the Bus Master bit
+			 * after reprocessing the RMRR info. However, we only
+			 * do both the clearing and setting if needed.
+			 */
+			current_bus_master = pdev->is_busmaster;
+			if (current_bus_master)
+				pci_clear_master(pdev);
+			domain_remove_one_dev_info(si_domain, pdev);
+			reprocess_rmrr(dev);
+			if (current_bus_master)
+				pci_set_master(pdev);
 			return 0;
 		}
 	} else {
