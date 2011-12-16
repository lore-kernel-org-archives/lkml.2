Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964844Ab1LPJCQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 04:02:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:27690 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760224Ab1LPJBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 04:01:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="102886146"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 2/3] dmaengine: intel_mid_dma: error path fix
Date: Fri, 16 Dec 2011 11:01:39 +0200
Message-Id: <1324026100-3124-3-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1324026100-3124-1-git-send-email-adrian.hunter@intel.com>
References: <1324026100-3124-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing iounmap in error path.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/dma/intel_mid_dma.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
index d4b9616..bbcd470 100644
--- a/drivers/dma/intel_mid_dma.c
+++ b/drivers/dma/intel_mid_dma.c
@@ -1104,7 +1104,8 @@ static int mid_setup_dma(struct pci_dev *pdev)
 					LNW_PERIPHRAL_MASK_SIZE);
 		if (dma->mask_reg == NULL) {
 			pr_err("ERR_MDMA:Can't map periphral intr space !!\n");
-			return -ENOMEM;
+			err = -ENOMEM;
+			goto err_ioremap;
 		}
 	} else
 		dma->mask_reg = NULL;
@@ -1201,6 +1202,9 @@ static int mid_setup_dma(struct pci_dev *pdev)
 err_engine:
 	free_irq(pdev->irq, dma);
 err_irq:
+	if (dma->mask_reg)
+		iounmap(dma->mask_reg);
+err_ioremap:
 	pci_pool_destroy(dma->dma_pool);
 err_dma_pool:
 	pr_err("ERR_MDMA:setup_dma failed: %d\n", err);
-- 
1.7.6.4

