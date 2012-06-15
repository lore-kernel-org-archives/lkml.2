Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab2FOM67 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 08:58:59 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:36191 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756837Ab2FOM66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 08:58:58 -0400
X-Greylist: delayed 341 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jun 2012 08:58:58 EDT
From: Tom Mingarelli <thomas.mingarelli@hp.com>
To: David Woodhouse <dwm2@infradead.org>, Joerg Roedel <joerg.roedel@amd.com>
Cc: Tom Mingarelli <thomas.mingarelli@hp.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Message-Id: <20120615125336.15536.69372.sendpatchset@localhost6.localdomain6>
Subject: [PATCH] Intel IOMMU patch to reprocess RMRR info
Date: Fri, 15 Jun 2012 08:58:58 -0400
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is being submitted to handle the case where a pci device is
placed into the si domain, but then removed. The RMRR information for
such devices need to be re-processed to avoid DMA Read errors due to
the Present Bit being cleared in the context entry.
----
drivers/iommu/intel-iommu.c |   32 ++++++++++++++++++++++++++++++++
1 files changed, 32 insertions(+), 0 deletions(-)
    
Signed-off-by: Tom Mingarelli <thomas.mingarelli@hp.com>
Tested-by: Tony Camuso <tony.camuso@hp.com>

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index f93d5ac..5ae57c5 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2696,6 +2696,37 @@ static int iommu_dummy(struct pci_dev *pdev)
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
+			pr_info("%s %s\n",
+				"IOMMU: Reprocess RMRR information for device",
+				pci_name(pdev));
+			ret = iommu_prepare_rmrr_dev(rmrr, pdev);
+			if (ret)
+				pr_err("%s %s\n",
+					"IOMMU: Reprocessing RMRR reserved",
+					"region for device failed");
+		}
+	}
+	return 0;
+}
+
 /* Check if the pdev needs to go through non-identity map and unmap process.*/
 static int iommu_no_mapping(struct device *dev)
 {
@@ -2724,6 +2755,7 @@ static int iommu_no_mapping(struct device *dev)
 			domain_remove_one_dev_info(si_domain, pdev);
 			printk(KERN_INFO "32bit %s uses non-identity mapping\n",
 			       pci_name(pdev));
+			reprocess_rmrr(dev);
 			return 0;
 		}
 	} else {
