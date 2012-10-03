Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965250Ab2JCRua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 13:50:30 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4558 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965174Ab2JCRu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 13:50:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 03 Oct 2012 10:50:26 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <arm@vger.kernel.org>, <djbw@fb.com>, <vinod.koul@intel.com>
CC: <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <stable@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] dma: tegra: fix interrupt name issue with apb dma.
Date: Wed, 3 Oct 2012 22:48:07 +0530
Message-ID: <1349284687-22311-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When watching the interrupts through /proc/interrupts,
the name of the interrupts are blank or garbage. The
reason is the pointer passed for devname during irq
registration is stack and so it get changed after
dma registration completes.
Allocate the pointer as part of dma channel and pass
this pointer as the devname for irq registration to
avoid change of name.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/dma/tegra20-apb-dma.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index 24a6512..528c62d 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -169,6 +169,7 @@ typedef void (*dma_isr_handler)(struct tegra_dma_channel *tdc,
 /* tegra_dma_channel: Channel specific information */
 struct tegra_dma_channel {
 	struct dma_chan		dma_chan;
+	char			name[30];
 	bool			config_init;
 	int			id;
 	int			irq;
@@ -1282,7 +1283,6 @@ static int __devinit tegra_dma_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&tdma->dma_dev.channels);
 	for (i = 0; i < cdata->nr_channels; i++) {
 		struct tegra_dma_channel *tdc = &tdma->channels[i];
-		char irq_name[30];
 
 		tdc->chan_base_offset = TEGRA_APBDMA_CHANNEL_BASE_ADD_OFFSET +
 					i * TEGRA_APBDMA_CHANNEL_REGISTER_SIZE;
@@ -1294,9 +1294,9 @@ static int __devinit tegra_dma_probe(struct platform_device *pdev)
 			goto err_irq;
 		}
 		tdc->irq = res->start;
-		snprintf(irq_name, sizeof(irq_name), "apbdma.%d", i);
+		snprintf(tdc->name, sizeof(tdc->name), "apbdma.%d", i);
 		ret = devm_request_irq(&pdev->dev, tdc->irq,
-				tegra_dma_isr, 0, irq_name, tdc);
+				tegra_dma_isr, 0, tdc->name, tdc);
 		if (ret) {
 			dev_err(&pdev->dev,
 				"request_irq failed with err %d channel %d\n",
-- 
1.7.1.1

