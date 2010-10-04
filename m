Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab0JDKwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 06:52:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:27110 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755172Ab0JDKws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 06:52:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,277,1283756400"; 
   d="scan'208";a="560434238"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, ramesh.b.k.v@intel.com,
        yong.y.wang@linux.intel.com
Cc: Yong Wang <yong.y.wang@intel.com>, Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 2/6] intel_mid_dma: Allow IRQ sharing
Date: Mon,  4 Oct 2010 16:07:02 +0530
Message-Id: <1286188622-6160-1-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Wang <yong.y.wang@intel.com>

intel_mid_dma driver allows interrupt sharing. Thus it needs
to check whether IRQ source is the DMA controller and return
the appropriate IRQ return.

Signed-off-by: Yong Wang <yong.y.wang@intel.com>
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/dma/intel_mid_dma.c |   25 ++++++++++++++-----------
 1 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
index 373396c..c4b8138 100644
--- a/drivers/dma/intel_mid_dma.c
+++ b/drivers/dma/intel_mid_dma.c
@@ -817,9 +817,14 @@ static void dma_tasklet2(unsigned long data)
 static irqreturn_t intel_mid_dma_interrupt(int irq, void *data)
 {
 	struct middma_device *mid = data;
-	u32 status;
+	u32 tfr_status, err_status;
 	int call_tasklet = 0;
 
+	tfr_status = ioread32(mid->dma_base + RAW_TFR);
+	err_status = ioread32(mid->dma_base + RAW_ERR);
+	if (!tfr_status && !err_status)
+		return IRQ_NONE;
+
 	/*DMA Interrupt*/
 	pr_debug("MDMA:Got an interrupt on irq %d\n", irq);
 	if (!mid) {
@@ -827,19 +832,17 @@ static irqreturn_t intel_mid_dma_interrupt(int irq, void *data)
 		return -EINVAL;
 	}
 
-	status = ioread32(mid->dma_base + RAW_TFR);
-	pr_debug("MDMA: Status %x, Mask %x\n", status, mid->intr_mask);
-	status &= mid->intr_mask;
-	if (status) {
+	pr_debug("MDMA: Status %x, Mask %x\n", tfr_status, mid->intr_mask);
+	tfr_status &= mid->intr_mask;
+	if (tfr_status) {
 		/*need to disable intr*/
-		iowrite32((status << 8), mid->dma_base + MASK_TFR);
-		pr_debug("MDMA: Calling tasklet %x\n", status);
+		iowrite32((tfr_status << 8), mid->dma_base + MASK_TFR);
+		pr_debug("MDMA: Calling tasklet %x\n", tfr_status);
 		call_tasklet = 1;
 	}
-	status = ioread32(mid->dma_base + RAW_ERR);
-	status &= mid->intr_mask;
-	if (status) {
-		iowrite32(MASK_INTR_REG(status), mid->dma_base + MASK_ERR);
+	err_status &= mid->intr_mask;
+	if (err_status) {
+		iowrite32(MASK_INTR_REG(err_status), mid->dma_base + MASK_ERR);
 		call_tasklet = 1;
 	}
 	if (call_tasklet)
-- 
1.6.6.1

