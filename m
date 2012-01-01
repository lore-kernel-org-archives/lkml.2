Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290Ab2AADaT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Dec 2011 22:30:19 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64798 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab2AADaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Dec 2011 22:30:17 -0500
From: Richard Zhao <richard.zhao@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: kernel@pengutronix.de, shawn.guo@linaro.org, vinod.koul@intel.com,
        dan.j.williams@intel.com, eric.miao@linaro.org, patches@linaro.org,
        Haitao Zhang <minipanda@linuxrobot.org>,
        Haitao Zhang <haitao.zhang@linaro.org>,
        Richard Zhao <richard.zhao@linaro.org>
Subject: [PATCH] dma/imx-sdma: save irq flags when use spin_lock in sdma_tx_submit
Date: Sun,  1 Jan 2012 11:30:06 +0800
Message-Id: <1325388606-20732-1-git-send-email-richard.zhao@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haitao Zhang <minipanda@linuxrobot.org>

mx53_loco: fix deadlock report from sdma_tx_submit() during boot

BugLink: http://bugs.launchpad.net/bugs/878701

Adjust to use spin_lock_irqsave()/spin_unlock_irqresotre(), so to
make it safe when called from interrupt context.

Signed-off-by: Haitao Zhang <haitao.zhang@linaro.org>
Signed-off-by: Eric Miao <eric.miao@linaro.org>
Signed-off-by: Richard Zhao <richard.zhao@linaro.org>
---
 drivers/dma/imx-sdma.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index f993955..2b7a88b 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -832,17 +832,18 @@ static struct sdma_channel *to_sdma_chan(struct dma_chan *chan)
 
 static dma_cookie_t sdma_tx_submit(struct dma_async_tx_descriptor *tx)
 {
+	unsigned long flags;
 	struct sdma_channel *sdmac = to_sdma_chan(tx->chan);
 	struct sdma_engine *sdma = sdmac->sdma;
 	dma_cookie_t cookie;
 
-	spin_lock_irq(&sdmac->lock);
+	spin_lock_irqsave(&sdmac->lock, flags);
 
 	cookie = sdma_assign_cookie(sdmac);
 
 	sdma_enable_channel(sdma, sdmac->channel);
 
-	spin_unlock_irq(&sdmac->lock);
+	spin_unlock_irqrestore(&sdmac->lock, flags);
 
 	return cookie;
 }
-- 
1.7.4.1

