Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab0JDKxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 06:53:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:1759 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163Ab0JDKxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 06:53:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,277,1283756400"; 
   d="scan'208";a="663786341"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, ramesh.b.k.v@intel.com,
        yong.y.wang@linux.intel.com
Cc: Yong Wang <yong.y.wang@intel.com>, Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 3/6] intel_mid_dma: Allow DMAC2 to share interrupt
Date: Mon,  4 Oct 2010 16:07:27 +0530
Message-Id: <1286188647-6196-1-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Wang <yong.y.wang@intel.com>

Allow DMAC2 to share interrupt since exclusive interrupt line
for mrst DMAC2 is not provided on other platforms.

Signed-off-by: Yong Wang <yong.y.wang@intel.com>
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/dma/intel_mid_dma.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
index c4b8138..3c4333e 100644
--- a/drivers/dma/intel_mid_dma.c
+++ b/drivers/dma/intel_mid_dma.c
@@ -872,7 +872,6 @@ static int mid_setup_dma(struct pci_dev *pdev)
 {
 	struct middma_device *dma = pci_get_drvdata(pdev);
 	int err, i;
-	unsigned int irq_level;
 
 	/* DMA coherent memory pool for DMA descriptor allocations */
 	dma->dma_pool = pci_pool_create("intel_mid_dma_desc_pool", pdev,
@@ -960,7 +959,6 @@ static int mid_setup_dma(struct pci_dev *pdev)
 
 	/*register irq */
 	if (dma->pimr_mask) {
-		irq_level = IRQF_SHARED;
 		pr_debug("MDMA:Requesting irq shared for DMAC1\n");
 		err = request_irq(pdev->irq, intel_mid_dma_interrupt1,
 			IRQF_SHARED, "INTEL_MID_DMAC1", dma);
@@ -968,10 +966,9 @@ static int mid_setup_dma(struct pci_dev *pdev)
 			goto err_irq;
 	} else {
 		dma->intr_mask = 0x03;
-		irq_level = 0;
 		pr_debug("MDMA:Requesting irq for DMAC2\n");
 		err = request_irq(pdev->irq, intel_mid_dma_interrupt2,
-			0, "INTEL_MID_DMAC2", dma);
+			IRQF_SHARED, "INTEL_MID_DMAC2", dma);
 		if (0 != err)
 			goto err_irq;
 	}
-- 
1.6.6.1

