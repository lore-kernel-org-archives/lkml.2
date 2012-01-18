Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab2ARKWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 05:22:31 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:52043 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306Ab2ARKW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 05:22:28 -0500
Date: Wed, 18 Jan 2012 11:22:26 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: linux-sh@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        "Shimoda, Yoshihiro" <yoshihiro.shimoda.uh@renesas.com>,
        linux-mmc@vger.kernel.org
Subject: [PATCH 3/7] mmc: sh_mmcif: remove unneeded struct sh_mmcif_dma,
 prepare for simple DMA
In-Reply-To: <Pine.LNX.4.64.1201181025280.28782@axis700.grange>
Message-ID: <Pine.LNX.4.64.1201181115420.28782@axis700.grange>
References: <Pine.LNX.4.64.1201181025280.28782@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:xwoPJ8wyZJJUj/E4Q5hB9czz4pS2xaKLg1n21XNQLMR
 a6mA9lj6Mm9Jf1HJcEpMZ53RtXo2ZWkzSjfWD2cPVtCvYxpdq0
 40Iw7rgTP1z/3dzyCO00XJOmPtpvRpQUtoRsA4uO4n8WwuAho+
 37o+2hnUAvi+fOkaIyNpYcnIsaINYv5UbSS/Ci1kqyWxsWyteO
 UKbJqphUnAy6NjotPWmpEMQzUcHbwD+TFG364f2Sk6t1guCDOu
 ID1chrUBkSek7MzX9P1ds1q6lSd9yMINTkL4BRRFcggOR5S5g6
 3dF5pLdEmCCByb2qwIY1jqR6Dd6XX0xFirD+kmcs0It/Q+K+0V
 YqFW98nMsBNNrdzKr13eXUsqf7q0HcG/DMRb62XweEZJy/MfTz
 iNiQ59ttJFupw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all users have been updated to use the embedded in struct
sh_mmcif_plat_data DMA slave IDs, struct sh_mmcif_dma is no longer needed
and can be removed. This also makes preparation for simple DMA conversion
easier.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Notice, that this patch also requires the recent
http://article.gmane.org/gmane.linux.ports.sh.devel/13337
to be applied first to avoid breakage

 drivers/mmc/host/sh_mmcif.c  |   24 ++++++++++--------------
 include/linux/mmc/sh_mmcif.h |    8 +-------
 2 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/drivers/mmc/host/sh_mmcif.c b/drivers/mmc/host/sh_mmcif.c
index c4bfbb0..497e6f4 100644
--- a/drivers/mmc/host/sh_mmcif.c
+++ b/drivers/mmc/host/sh_mmcif.c
@@ -383,31 +383,27 @@ static void sh_mmcif_request_dma(struct sh_mmcif_host *host,
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

