Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab2AaKtK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 05:49:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:42805 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095Ab2AaKtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 05:49:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="118484405"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 2/2] dmaengine: intel_mid_dma: move pm_runtime_put
Date: Tue, 31 Jan 2012 12:49:00 +0200
Message-Id: <1328006940-9101-3-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1328006940-9101-1-git-send-email-adrian.hunter@intel.com>
References: <1328006940-9101-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move pm_runtime_put() to the end of intel_mid_dma_free_chan_resources()
because there is no sense in allowing runtime suspend while the driver
is still accessing the device.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/dma/intel_mid_dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
index 512e2ab..923476d 100644
--- a/drivers/dma/intel_mid_dma.c
+++ b/drivers/dma/intel_mid_dma.c
@@ -832,7 +832,6 @@ static void intel_mid_dma_free_chan_resources(struct dma_chan *chan)
 		/*trying to free ch in use!!!!!*/
 		pr_err("ERR_MDMA: trying to free ch in use\n");
 	}
-	pm_runtime_put(&mid->pdev->dev);
 	spin_lock_bh(&midc->lock);
 	midc->descs_allocated = 0;
 	list_for_each_entry_safe(desc, _desc, &midc->active_list, desc_node) {
@@ -853,6 +852,7 @@ static void intel_mid_dma_free_chan_resources(struct dma_chan *chan)
 	/* Disable CH interrupts */
 	iowrite32(MASK_INTR_REG(midc->ch_id), mid->dma_base + MASK_BLOCK);
 	iowrite32(MASK_INTR_REG(midc->ch_id), mid->dma_base + MASK_ERR);
+	pm_runtime_put(&mid->pdev->dev);
 }
 
 /**
-- 
1.7.6.4

