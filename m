Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818Ab1CaSAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 14:00:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:63939 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758648Ab1CaSAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 14:00:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,276,1299484800"; 
   d="scan'208";a="727577218"
From: kristen@linux.intel.com
To: vinod.koul@intel.com
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
        Kristen Carlson Accardi <kristen@linux.intel.com>
Subject: [PATCH] intel_mid_dma: fix runtime pm issues
Date: Thu, 31 Mar 2011 11:02:43 -0700
Message-Id: <1301594563-19171-1-git-send-email-kristen@linux.intel.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kristen Carlson Accardi <kristen@linux.intel.com>

Use the correct api in probe to enable runtime pm for this driver.
Additionally, do not just call legacy suspend for runtime_suspend,
as this duplicates some work the pci core does for you.

Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
---
 drivers/dma/intel_mid_dma.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
index 798f46a..f153adf 100644
--- a/drivers/dma/intel_mid_dma.c
+++ b/drivers/dma/intel_mid_dma.c
@@ -1292,8 +1292,7 @@ static int __devinit intel_mid_dma_probe(struct pci_dev *pdev,
 	if (err)
 		goto err_dma;
 
-	pm_runtime_set_active(&pdev->dev);
-	pm_runtime_enable(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_allow(&pdev->dev);
 	return 0;
 
@@ -1322,6 +1321,9 @@ err_enable_device:
 static void __devexit intel_mid_dma_remove(struct pci_dev *pdev)
 {
 	struct middma_device *device = pci_get_drvdata(pdev);
+
+	pm_runtime_get_noresume(&pdev->dev);
+	pm_runtime_forbid(&pdev->dev);
 	middma_shutdown(pdev);
 	pci_dev_put(pdev);
 	kfree(device);
@@ -1385,13 +1387,20 @@ int dma_resume(struct pci_dev *pci)
 static int dma_runtime_suspend(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	return dma_suspend(pci_dev, PMSG_SUSPEND);
+	struct middma_device *device = pci_get_drvdata(pci_dev);
+
+	device->state = SUSPENDED;
+	return 0;
 }
 
 static int dma_runtime_resume(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	return dma_resume(pci_dev);
+	struct middma_device *device = pci_get_drvdata(pci_dev);
+
+	device->state = RUNNING;
+	iowrite32(REG_BIT0, device->dma_base + DMA_CFG);
+	return 0;
 }
 
 static int dma_runtime_idle(struct device *dev)
-- 
1.7.3.1

