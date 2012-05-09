Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759871Ab2EIPJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 11:09:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54315 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759849Ab2EIPJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 11:09:42 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
        Chris Ball <cjb@laptop.org>
Subject: [PATCH 3/9 v3] mmc: sh_mmcif: remove unneeded struct sh_mmcif_dma, prepare to shdma conversion
Date: Wed,  9 May 2012 17:09:15 +0200
Message-Id: <1336576161-27082-4-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1336576161-27082-1-git-send-email-g.liakhovetski@gmx.de>
References: <1336576161-27082-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:NKKgbNsrAZ7ISa3OLx84EUW+Z2xu2KbBkqYGzzBRAmA
 tm6TBeko0MjqQpeEqjtwplZwjsXRkc2iIR5/uihkGU8DSr7arp
 iY8IAjpSRtup0s11ZgZYZ0Sz6qJXAZqDCoSHP8A6NTcygjzcrj
 bEGYPZIWN1ULXoYk1suisiz3q2aprhECH+mD58pUVJ2GAFF4H7
 6iOhO+EUujGBYtR++GIiblkbmL3ppjGo7Ma8Dp+4WvaCMTCTNt
 cSFYHotOx5geGUHxWEYTnEWSDs2nby+zJFaZ1RZwXk18ynvKRC
 OhJsqQdTxVfXddjeVAeJqj19pZIBBa4FwPBt0J7NPwg0jqcMtC
 Drn4xJbboz6AIURn5+g4sAe0xVAc/KOqK7dGub+N8hW3nQW0BQ
 aDueXYNLSKFxA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all users have been updated to use the embedded in struct
sh_mmcif_plat_data DMA slave IDs, struct sh_mmcif_dma is no longer needed
and can be removed. This also makes preparation to the shdma base library
conversion easier.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Chris Ball <cjb@laptop.org>
---
 drivers/mmc/host/sh_mmcif.c  |   24 ++++++++++--------------
 include/linux/mmc/sh_mmcif.h |    8 +-------
 2 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/drivers/mmc/host/sh_mmcif.c b/drivers/mmc/host/sh_mmcif.c
index aafaf0b..25cf203 100644
--- a/drivers/mmc/host/sh_mmcif.c
+++ b/drivers/mmc/host/sh_mmcif.c
@@ -385,31 +385,27 @@ static void sh_mmcif_request_dma(struct sh_mmcif_host *host,
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
+	tx->shdma_slave.slave_id = pdata->slave_id_tx;
+	rx = &host->dma_slave_rx;
+	rx->shdma_slave.slave_id = pdata->slave_id_rx;
+
+	if (tx->shdma_slave.slave_id > 0 && rx->shdma_slave.slave_id > 0) {
 		dma_cap_mask_t mask;
 
 		dma_cap_zero(mask);
 		dma_cap_set(DMA_SLAVE, mask);
 
-		host->chan_tx = dma_request_channel(mask, sh_mmcif_filter, tx);
+		host->chan_tx = dma_request_channel(mask, sh_mmcif_filter,
+						    &tx->shdma_slave);
 		dev_dbg(&host->pd->dev, "%s: TX: got channel %p\n", __func__,
 			host->chan_tx);
 
 		if (!host->chan_tx)
 			return;
 
-		host->chan_rx = dma_request_channel(mask, sh_mmcif_filter, rx);
+		host->chan_rx = dma_request_channel(mask, sh_mmcif_filter,
+						    &rx->shdma_slave);
 		dev_dbg(&host->pd->dev, "%s: RX: got channel %p\n", __func__,
 			host->chan_rx);
 
diff --git a/include/linux/mmc/sh_mmcif.h b/include/linux/mmc/sh_mmcif.h
index 05f0e3d..c37956c 100644
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

