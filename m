Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab1HHMut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 08:50:49 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:64052 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab1HHMur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 08:50:47 -0400
From: =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org, shawn.guo@freescale.com,
        u.kleine-koenig@pengutronix.de
Cc: =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [RESEND][PATCH 2/2] mxs-dma: enable CLKGATE before accessing registers
Date: Mon,  8 Aug 2011 14:47:47 +0200
Message-Id: <1312807667-24373-3-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1312807667-24373-2-git-send-email-LW@KARO-electronics.de>
References: <dc6791e4e926902967a182107d4558d5e0a16381.1303373126.git.LW@KARO-electronics.de>
 <1312807667-24373-1-git-send-email-LW@KARO-electronics.de>
 <1312807667-24373-2-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After calling mxs_dma_disable_chan() for a channel, that channel
becomes unusable because some controller registers can only be written
when the clock is enabled via CLKGATE.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/dma/mxs-dma.c |   45 ++++++++++++++++++++++++---------------------
 1 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
index f2ddcbd..7deab8a 100644
--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -130,6 +130,23 @@ struct mxs_dma_engine {
 	struct mxs_dma_chan		mxs_chans[MXS_DMA_CHANNELS];
 };
 
+static inline void mxs_dma_clkgate(struct mxs_dma_chan *mxs_chan, int enable)
+{
+	struct mxs_dma_engine *mxs_dma = mxs_chan->mxs_dma;
+	int chan_id = mxs_chan->chan.chan_id;
+	int set_clr = enable ? MXS_CLR_ADDR : MXS_SET_ADDR;
+
+	/* enable apbh channel clock */
+	if (dma_is_apbh()) {
+		if (apbh_is_old())
+			writel(1 << (chan_id + BP_APBH_CTRL0_CLKGATE_CHANNEL),
+				mxs_dma->base + HW_APBHX_CTRL0 + set_clr);
+		else
+			writel(1 << chan_id,
+				mxs_dma->base + HW_APBHX_CTRL0 + set_clr);
+	}
+}
+
 static void mxs_dma_reset_chan(struct mxs_dma_chan *mxs_chan)
 {
 	struct mxs_dma_engine *mxs_dma = mxs_chan->mxs_dma;
@@ -148,38 +165,21 @@ static void mxs_dma_enable_chan(struct mxs_dma_chan *mxs_chan)
 	struct mxs_dma_engine *mxs_dma = mxs_chan->mxs_dma;
 	int chan_id = mxs_chan->chan.chan_id;
 
+	/* clkgate needs to be enabled before writing other registers */
+	mxs_dma_clkgate(mxs_chan, 1);
+
 	/* set cmd_addr up */
 	writel(mxs_chan->ccw_phys,
 		mxs_dma->base + HW_APBHX_CHn_NXTCMDAR(chan_id));
 
-	/* enable apbh channel clock */
-	if (dma_is_apbh()) {
-		if (apbh_is_old())
-			writel(1 << (chan_id + BP_APBH_CTRL0_CLKGATE_CHANNEL),
-				mxs_dma->base + HW_APBHX_CTRL0 + MXS_CLR_ADDR);
-		else
-			writel(1 << chan_id,
-				mxs_dma->base + HW_APBHX_CTRL0 + MXS_CLR_ADDR);
-	}
-
 	/* write 1 to SEMA to kick off the channel */
 	writel(1, mxs_dma->base + HW_APBHX_CHn_SEMA(chan_id));
 }
 
 static void mxs_dma_disable_chan(struct mxs_dma_chan *mxs_chan)
 {
-	struct mxs_dma_engine *mxs_dma = mxs_chan->mxs_dma;
-	int chan_id = mxs_chan->chan.chan_id;
-
 	/* disable apbh channel clock */
-	if (dma_is_apbh()) {
-		if (apbh_is_old())
-			writel(1 << (chan_id + BP_APBH_CTRL0_CLKGATE_CHANNEL),
-				mxs_dma->base + HW_APBHX_CTRL0 + MXS_SET_ADDR);
-		else
-			writel(1 << chan_id,
-				mxs_dma->base + HW_APBHX_CTRL0 + MXS_SET_ADDR);
-	}
+	mxs_dma_clkgate(mxs_chan, 0);
 
 	mxs_chan->status = DMA_SUCCESS;
 }
@@ -336,7 +336,10 @@ static int mxs_dma_alloc_chan_resources(struct dma_chan *chan)
 	if (ret)
 		goto err_clk;
 
+	/* clkgate needs to be enabled for reset to finish */
+	mxs_dma_clkgate(mxs_chan, 1);
 	mxs_dma_reset_chan(mxs_chan);
+	mxs_dma_clkgate(mxs_chan, 0);
 
 	dma_async_tx_descriptor_init(&mxs_chan->desc, chan);
 	mxs_chan->desc.tx_submit = mxs_dma_tx_submit;
-- 
1.5.6.5

