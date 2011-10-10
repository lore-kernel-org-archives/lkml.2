Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab1JJHLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 03:11:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:58638 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600Ab1JJHLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 03:11:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="61024696"
Subject: [PATCH] dmaengine: mid_dma: mask_peripheral_interrupt only when
 dmac is idle
From: Vinod Koul <vinod.koul@intel.com>
To: Dan <dan.j.williams@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Oct 2011 12:33:59 +0530
Message-ID: <1318230239.1573.2301.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The mask_peripheral_interrupt is called when channel wants to mask the
interrupt. Move this to suspend as this masking affects other channels
as well Not touching unmask here and unmask would still be done of
first channel use

Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
---
 drivers/dma/intel_mid_dma.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
index cf74a66..9e96c43 100644
--- a/drivers/dma/intel_mid_dma.c
+++ b/drivers/dma/intel_mid_dma.c
@@ -115,16 +115,15 @@ DMAC1 interrupt Functions*/
 
 /**
  * dmac1_mask_periphral_intr -	mask the periphral interrupt
- * @midc: dma channel for which masking is required
+ * @mid: dma device for which masking is required
  *
  * Masks the DMA periphral interrupt
  * this is valid for DMAC1 family controllers only
  * This controller should have periphral mask registers already mapped
  */
-static void dmac1_mask_periphral_intr(struct intel_mid_dma_chan *midc)
+static void dmac1_mask_periphral_intr(struct middma_device *mid)
 {
 	u32 pimr;
-	struct middma_device *mid = to_middma_device(midc->chan.device);
 
 	if (mid->pimr_mask) {
 		pimr = readl(mid->mask_reg + LNW_PERIPHRAL_MASK);
@@ -184,7 +183,6 @@ static void enable_dma_interrupt(struct intel_mid_dma_chan *midc)
 static void disable_dma_interrupt(struct intel_mid_dma_chan *midc)
 {
 	/*Check LPE PISR, make sure fwd is disabled*/
-	dmac1_mask_periphral_intr(midc);
 	iowrite32(MASK_INTR_REG(midc->ch_id), midc->dma_base + MASK_BLOCK);
 	iowrite32(MASK_INTR_REG(midc->ch_id), midc->dma_base + MASK_TFR);
 	iowrite32(MASK_INTR_REG(midc->ch_id), midc->dma_base + MASK_ERR);
@@ -1348,6 +1346,7 @@ int dma_suspend(struct pci_dev *pci, pm_message_t state)
 		if (device->ch[i].in_use)
 			return -EAGAIN;
 	}
+	dmac1_mask_periphral_intr(device);
 	device->state = SUSPENDED;
 	pci_save_state(pci);
 	pci_disable_device(pci);
-- 
1.7.0.4


-- 
~Vinod

