Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab0HaMNB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 08:13:01 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:35621 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755977Ab0HaMM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 08:12:58 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <yuanyabin1978@sina.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 05/12] DMAENGINE: terminate transfers on PL08X mere throughly
Date: Tue, 31 Aug 2010 14:12:07 +0200
Message-ID: <1283256734-3408-6-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1283256734-3408-5-git-send-email-linus.walleij@stericsson.com>
References: <1283256734-3408-1-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-2-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-3-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-4-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-5-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to terminate pending tasklets and be sure to disable not
only the channel but it's IRQ:s when we terminate all work on
a PL08X channel.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/amba-pl08x.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index d1a4813..65f595c 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -312,6 +312,8 @@ static void pl08x_stop_phy_chan(struct pl08x_phy_chan *ch)
 	/* Disable channel */
 	val = readl(ch->base + PL080_CH_CONFIG);
 	val &= ~PL080_CONFIG_ENABLE;
+	val &= ~PL080_CONFIG_ERR_IRQ_MASK;
+	val &= ~PL080_CONFIG_TC_IRQ_MASK;
 	writel(val, ch->base + PL080_CH_CONFIG);
 }
 
@@ -1653,13 +1655,15 @@ static int pl08x_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 			pl08x_put_phy_channel(pl08x, plchan->phychan);
 			plchan->phychan = NULL;
 		}
-
+		/* Stop any pending tasklet */
+		tasklet_disable(&plchan->tasklet);
 		/* Dequeue jobs and free LLIs */
 		if (plchan->at) {
 			pl08x_free_txd(pl08x, plchan->at);
-			pl08x_free_txd_list(pl08x, plchan);
 			plchan->at = NULL;
 		}
+		/* Dequeue jobs not yet fired as well */
+		pl08x_free_txd_list(pl08x, plchan);
 		break;
 	case DMA_PAUSE:
 		pl08x_pause_phy_chan(plchan->phychan);
-- 
1.6.3.3

