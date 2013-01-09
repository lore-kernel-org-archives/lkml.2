Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598Ab3AIJ4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 04:56:48 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1291 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757480Ab3AIJ4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 04:56:46 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 09 Jan 2013 01:56:42 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <vinod.koul@intel.com>
CC: <djbw@fb.com>, <linux-kernel@vger.kernel.org>, <swarren@nvidia.com>,
        <linux-tegra@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH RESEND] dma: tegra: implement flags parameters for cyclic transfer
Date: Wed, 9 Jan 2013 15:26:22 +0530
Message-ID: <1357725382-25780-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The flag parameter is added in the cyclic transfer request.
Use the flag option of:
- DMA_PREP_INTERRUPT for enabling interrupt.
- DMA_CTRL_ACK for deciding whether ack is requred or not for
  descriptor.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Vinod,
This patch was sent before holiday and may be it is missed in you radar.
You have already applied my other patches on dma which was sent later so
resending this patch.
Stephen wanted this to be part of stable branch also.
This is against bug fixes and new feature added in K3.7 for cyclic transfer without
interrupt.

 drivers/dma/tegra20-apb-dma.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index efdfffa..bf58bb8 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -266,6 +266,7 @@ static struct tegra_dma_desc *tegra_dma_desc_get(
 		if (async_tx_test_ack(&dma_desc->txd)) {
 			list_del(&dma_desc->node);
 			spin_unlock_irqrestore(&tdc->lock, flags);
+			dma_desc->txd.flags = 0;
 			return dma_desc;
 		}
 	}
@@ -1050,7 +1051,9 @@ struct dma_async_tx_descriptor *tegra_dma_prep_dma_cyclic(
 					TEGRA_APBDMA_AHBSEQ_WRAP_SHIFT;
 	ahb_seq |= TEGRA_APBDMA_AHBSEQ_BUS_WIDTH_32;
 
-	csr |= TEGRA_APBDMA_CSR_FLOW | TEGRA_APBDMA_CSR_IE_EOC;
+	csr |= TEGRA_APBDMA_CSR_FLOW;
+	if (flags & DMA_PREP_INTERRUPT)
+		csr |= TEGRA_APBDMA_CSR_IE_EOC;
 	csr |= tdc->dma_sconfig.slave_id << TEGRA_APBDMA_CSR_REQ_SEL_SHIFT;
 
 	apb_seq |= TEGRA_APBDMA_APBSEQ_WRAP_WORD_1;
@@ -1095,7 +1098,8 @@ struct dma_async_tx_descriptor *tegra_dma_prep_dma_cyclic(
 		mem += len;
 	}
 	sg_req->last_sg = true;
-	dma_desc->txd.flags = 0;
+	if (flags & DMA_CTRL_ACK)
+		dma_desc->txd.flags = DMA_CTRL_ACK;
 
 	/*
 	 * Make sure that mode should not be conflicting with currently
-- 
1.7.1.1

