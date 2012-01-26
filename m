Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab2AZO4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 09:56:43 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62063 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab2AZO4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 09:56:38 -0500
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-mmc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-serial@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 3/7 v2] mmc: sh_mmcif: remove unneeded struct sh_mmcif_dma, prepare for simple DMA
Date: Thu, 26 Jan 2012 15:56:20 +0100
Message-Id: <1327589784-4287-4-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1327589784-4287-1-git-send-email-g.liakhovetski@gmx.de>
References: <1327589784-4287-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:Eyg44/BlDWlgzhPskuFPnVWq9W2kaa0ql1gG73QF5ov
 RQCCdRYXW0t5eouH6F9qBQsKdtONbya83fAiRm5lHWZeLDewVW
 7CDDZoTaQoLGWnl/2OFQYppfWnPVQXbW94aaOuSjh7K9fK35Xu
 KQyVfrF2MAN0Vt1iaNmQEVaz3AckaadpGbB2Ie6LCAJ5/BzYSZ
 4aSYTsrMMD41gyQqaiXIAr2SjuW7e7Y3hLhH48+IzdXk6oakhk
 v/qMMhG+diHLpcASC3OK0/hgvb5WsnBxAdDQ8RT34g8pGEPjCS
 3BCO67AJVgfKgmrfIQFM7S77k8jjfG/Y2XCFIkvorTl3ccQUIw
 jE2Sc1z41Euzm1G1xqJFFdey3ewwFL4jIhGGDyEZdjBR00dJMl
 MLWxQdfYdQi7Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all users have been updated to use the embedded in struct
sh_mmcif_plat_data DMA slave IDs, struct sh_mmcif_dma is no longer needed
and can be removed. This also makes preparation for simple DMA conversion
easier.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/mmc/host/sh_mmcif.c  |   24 ++++++++++--------------
 include/linux/mmc/sh_mmcif.h |    8 +-------
 2 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/drivers/mmc/host/sh_mmcif.c b/drivers/mmc/host/sh_mmcif.c
index 2ad6c81..06a7cdc 100644
--- a/drivers/mmc/host/sh_mmcif.c
+++ b/drivers/mmc/host/sh_mmcif.c
@@ -384,31 +384,27 @@ static void sh_mmcif_request_dma(struct sh_mmcif_host *host,
 	host->dma_active = false;
 
 	/* We can only either use DMA for both Tx and Rx or not use it at all */
-	if (pdata->dma) {
-		dev_warn(&host->pd->dev,
-			 "Update your platform to use embedded DMA slave IDs\n");
-		tx = &pdata->dma->chan_priv_tx;
-		rx = &pdata->dma->chan_priv_rx;
-	} else {
-		tx = &host->dma_slave_tx;
-		tx->slave_id = pdata->slave_id_tx;
-		rx = &host->dma_slave_rx;
-		rx->slave_id = pdata->slave_id_rx;
-	}
-	if (tx->slave_id > 0 && rx->slave_id > 0) {
+	tx = &host->dma_slave_tx;
+	tx->simple_slave.slave_id = pdata->slave_id_tx;
+	rx = &host->dma_slave_rx;
+	rx->simple_slave.slave_id = pdata->slave_id_rx;
+
+	if (tx->simple_slave.slave_id > 0 && rx->simple_slave.slave_id > 0) {
 		dma_cap_mask_t mask;
 
 		dma_cap_zero(mask);
 		dma_cap_set(DMA_SLAVE, mask);
 
-		host->chan_tx = dma_request_channel(mask, sh_mmcif_filter, tx);
+		host->chan_tx = dma_request_channel(mask, sh_mmcif_filter,
+						    &tx->simple_slave);
 		dev_dbg(&host->pd->dev, "%s: TX: got channel %p\n", __func__,
 			host->chan_tx);
 
 		if (!host->chan_tx)
 			return;
 
-		host->chan_rx = dma_request_channel(mask, sh_mmcif_filter, rx);
+		host->chan_rx = dma_request_channel(mask, sh_mmcif_filter,
+						    &rx->simple_slave);
 		dev_dbg(&host->pd->dev, "%s: RX: got channel %p\n", __func__,
 			host->chan_rx);
 
diff --git a/include/linux/mmc/sh_mmcif.h b/include/linux/mmc/sh_mmcif.h
index 04ff452..b36caa9 100644
--- a/include/linux/mmc/sh_mmcif.h
+++ b/include/linux/mmc/sh_mmcif.h
@@ -32,17 +32,11 @@
  * 1111 : Peripheral clock (sup_pclk set '1')
  */
 
-struct sh_mmcif_dma {
-	struct sh_dmae_slave chan_priv_tx;
-	struct sh_dmae_slave chan_priv_rx;
-};
-
 struct sh_mmcif_plat_data {
 	void (*set_pwr)(struct platform_device *pdev, int state);
 	void (*down_pwr)(struct platform_device *pdev);
 	int (*get_cd)(struct platform_device *pdef);
-	struct sh_mmcif_dma	*dma;		/* Deprecated. Instead */
-	unsigned int		slave_id_tx;	/* use embedded slave_id_[tr]x */
+	unsigned int		slave_id_tx;	/* embedded slave_id_[tr]x */
 	unsigned int		slave_id_rx;
 	u8			sup_pclk;	/* 1 :SH7757, 0: SH7724/SH7372 */
 	unsigned long		caps;
-- 
1.7.2.5

