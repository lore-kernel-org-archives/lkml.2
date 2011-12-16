Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675Ab1LPJCF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 04:02:05 -0500
Received: from mga01.intel.com ([192.55.52.88]:27690 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760220Ab1LPJBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 04:01:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="102886137"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 1/3] dmaengine: intel_mid_dma: locking and freeing fixes
Date: Fri, 16 Dec 2011 11:01:38 +0200
Message-Id: <1324026100-3124-2-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1324026100-3124-1-git-send-email-adrian.hunter@intel.com>
References: <1324026100-3124-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two issues are fixed:

1. DMA descriptors are reused so when freeing lli structures
that are linked to them, the pointer must be nulled.

2. midc_scan_descriptors() must be called with the
channel lock held.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/dma/intel_mid_dma.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
index 01929ed..d4b9616 100644
--- a/drivers/dma/intel_mid_dma.c
+++ b/drivers/dma/intel_mid_dma.c
@@ -280,7 +280,8 @@ static void midc_dostart(struct intel_mid_dma_chan *midc,
  * callbacks but must be called with the lock held.
  */
 static void midc_descriptor_complete(struct intel_mid_dma_chan *midc,
-	       struct intel_mid_dma_desc *desc)
+		struct intel_mid_dma_desc *desc)
+		__releases(&midc->lock) __acquires(&midc->lock)
 {
 	struct dma_async_tx_descriptor	*txd = &desc->txd;
 	dma_async_tx_callback callback_txd = NULL;
@@ -311,6 +312,7 @@ static void midc_descriptor_complete(struct intel_mid_dma_chan *midc,
 			pci_pool_free(desc->lli_pool, desc->lli,
 						desc->lli_phys);
 			pci_pool_destroy(desc->lli_pool);
+			desc->lli = NULL;
 		}
 		list_move(&desc->desc_node, &midc->free_list);
 		midc->busy = false;
@@ -490,7 +492,9 @@ static enum dma_status intel_mid_dma_tx_status(struct dma_chan *chan,
 
 	ret = dma_async_is_complete(cookie, last_complete, last_used);
 	if (ret != DMA_SUCCESS) {
+		spin_lock_bh(&midc->lock);
 		midc_scan_descriptors(to_middma_device(chan->device), midc);
+		spin_unlock_bh(&midc->lock);
 
 		last_complete = midc->completed;
 		last_used = chan->cookie;
@@ -566,6 +570,7 @@ static int intel_mid_dma_device_control(struct dma_chan *chan,
 			pci_pool_free(desc->lli_pool, desc->lli,
 						desc->lli_phys);
 			pci_pool_destroy(desc->lli_pool);
+			desc->lli = NULL;
 		}
 		list_move(&desc->desc_node, &midc->free_list);
 	}
-- 
1.7.6.4

